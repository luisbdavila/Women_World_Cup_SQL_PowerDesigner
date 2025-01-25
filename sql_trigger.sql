/*.This solution is able to insert 1 card, multiple goals and 1 replacement per batch insert per player,
asuming that all records already in the events table are correct and we are trying to insert records after those .*/

use MUNDIAL;
go

/*1. It is not possible to summon a player that does not belong to any of the countries 
participating in the match. (INSERT)*/

create or alter trigger summon
on SUMMONEDS
instead of insert
as 
begin
	insert into SUMMONEDS(IDEVENTPLAYEROUT, IDPLAYER, IDMATCH, STARTING11)
	select i.IDEVENTPLAYEROUT, i.IDPLAYER, i.IDMATCH, i.STARTING11
	from inserted i, MATCH m, PLAYER p
	where i.IDMATCH = m.IDMATCH and i.IDPlayer = p.IDPerson 
	and (m.IDHomeTeam = p.IDCountry or m.IDAwayTeam = p.IDCountry)
end;
go


/*2. A referee cannot referee a match where her/his own country is participating. 
(INSERT/UPDATE)*/

create or alter trigger refree_insert
on MATCH
instead of insert
as 
begin
	insert into MATCH(IDAWAYTEAM, IDTOURNAMENTPHASE, IDSTADIUM, IDHOMETEAM, IDREFEREE, STARTDATETIME, ADDEDTIME1STHALF, ADDEDTIME2NDHALF, EXTRATIMEADDEDTIME1STHALF, 
						EXTRATIMEADDEDTIME2NDHALF, EXTRATIME, PENALTIES)
	select i.IDAWAYTEAM, i.IDTOURNAMENTPHASE, i.IDSTADIUM, i.IDHOMETEAM, i.IDREFEREE, i.STARTDATETIME, i.ADDEDTIME1STHALF, i.ADDEDTIME2NDHALF, i.EXTRATIMEADDEDTIME1STHALF, 
			i.EXTRATIMEADDEDTIME2NDHALF, i.EXTRATIME, i.PENALTIES
	from inserted i, REFEREE r
	where i.IDREFEREE = r.IDPerson 
	and not (i.IDHomeTeam = r.IDCountry or i.IDAwayTeam = r.IDCountry) and i.IDHomeTeam<>i.IDAwayTeam;
end;
go

create or alter trigger refree_update
on MATCH
after update
as 
begin
	update MATCH
	set IDAWAYTEAM = d.IDAWAYTEAM, IDTOURNAMENTPHASE = d.IDTOURNAMENTPHASE, 
	IDSTADIUM = d.IDSTADIUM, IDHOMETEAM = d.IDHOMETEAM, IDREFEREE = d.IDREFEREE,  STARTDATETIME = d.STARTDATETIME, ADDEDTIME1STHALF =d.ADDEDTIME1STHALF,
	ADDEDTIME2NDHALF = d.ADDEDTIME2NDHALF, EXTRATIMEADDEDTIME1STHALF =d.EXTRATIMEADDEDTIME1STHALF, EXTRATIMEADDEDTIME2NDHALF = d.EXTRATIMEADDEDTIME2NDHALF,
	EXTRATIME=d.EXTRATIME, PENALTIES = d.PENALTIES
	from deleted d, REFEREE r
	where MATCH.IDMATCH = d.IDMATCH and MATCH.IDREFEREE = r.IDPERSON and 
	( (MATCH.IDHOMETEAM = r.IDCOUNTRY or MATCH.IDAWAYTEAM = r.IDCOUNTRY) or (MATCH.IDHOMETEAM = MATCH.IDAWAYTEAM))
	
end;
go


/*3. When a yellow card event is inserted, it must be verified if the player already received a 
yellow card in the same match. If that is the case, then a new red card event must be 
inserted with the same data. (INSERT)*/ 

create or alter trigger insert_e_yellow
on EVENTS
after insert
as 
begin
	insert into EVENTS(IDSUMMONEDMAINPLAYER, MINUTE, MATCHPART, EVENTTYPE, CARDTYPE)
	select i.IDSUMMONEDMAINPLAYER, i.MINUTE, i.MATCHPART, i.EVENTTYPE, 'Red'
	from inserted i
	where i.EVENTTYPE = 'Card' and i.CARDTYPE = 'Yellow'
		and 2 = (select count(*) from  EVENTS e
				where e.EVENTTYPE = 'Card' and e.CARDTYPE = 'Yellow' and 
				e.IDSUMMONEDMAINPLAYER = i.IDSUMMONEDMAINPLAYER)
end;
go



/*4. When a “Goal” event is inserted, it must be verified if the player that scored the goal 
was on the field. For a player to be on the field, either: 
• She was part of the starting 11 and did not leave (was not replaced and did not 
receive a red card); 
• She was not part of the starting 11 but replaced another player and did not leave 
afterwards (was not replaced and did not receive a red card). 
If the scorer was not on the field, then the record must not be inserted, and a message 
must be displayed. (INSERT)*/ 

create or alter view tem_events as (select IDEVENT, IDSUMMONEDMAINPLAYER, IDSUMMONEDPLAYEROUT, MINUTE, MATCHPART, EVENTTYPE, ISPENALTY, ISOWNGOAL, CARDTYPE,  
								(CASE
								WHEN e.MATCHPART = 'First half' THEN 1
								WHEN e.MATCHPART = 'First half added time' THEN 2
								WHEN e.MATCHPART = 'Second half' THEN 3
								WHEN e.MATCHPART = 'Second half added time' THEN 4
								WHEN e.MATCHPART = 'Extra time first half' THEN 5
								WHEN e.MATCHPART = 'Extra time first half added time' THEN 6
								WHEN e.MATCHPART = 'Extra time second half' THEN 7
								WHEN e.MATCHPART = 'Extra time second half added time' THEN 8
								Else 9
								END) as Numberpart
			from EVENTS e);
go

CREATE or alter FUNCTION On_the_field(@ID numeric, @Numberpart numeric , @Minute numeric) 
RETURNS INTEGER
AS
begin
	DECLARE @result INTEGER;

	if ( (EXISTS(select 1 from tem_events e1 
					where @ID = e1.IDSummonedMainPlayer and e1.EventType = 'Card'
					and e1.CARDTYPE = 'Red' and (@Numberpart > e1.Numberpart or (@Numberpart = e1.Numberpart and @Minute > e1.Minute))
						)
				)
				or 
				-- Player is replaced, no goals afterwards
				(EXISTS(select 1 from tem_events e1
					where  @ID = e1.IDSummonedPlayerOut and e1.EventType = 'Replacement'
					  and (@Numberpart > e1.Numberpart or (@Numberpart = e1.Numberpart and @Minute > e1.Minute)) 
						)
				)
				or 
				-- Player hasn't entered the game yet, no goal
				(EXISTS(select 1 from tem_events e1, SUMMONEDS s
					where   @ID = s.IDSUMMONED and @ID = e1.IDSummonedMainPlayer and e1.EventType = 'Replacement' 
					 and s.STARTING11 = 0  and ( @Numberpart < e1.Numberpart or (@Numberpart = e1.Numberpart and @Minute < e1.Minute))
						)
				)
				or 
				-- Player never enters the game, no goal
				(EXISTS(select 1 from SUMMONEDS s
					where   @ID = s.IDSUMMONED and s.STARTING11 = 0 
					and ( @ID not in (select e1.IDSUMMONEDMAINPLAYER from EVENTS e1 
															where e1.EventType = 'Replacement')
						)
						)	
				)
		)
		set @result=1;
	else 
		set @result=0;

	return @result;
end;
GO



create or alter trigger insert_e_goal
on EVENTS
after insert
as 
begin

	Delete EVENTS
	from inserted i, tem_events e 
	where EVENTS.IDEVENT = i.IDEVENT and i.IDEVENT = e.IDEvent and  i.EVENTTYPE = 'Goal' 
		and [dbo].[On_the_field](e.IDSUMMONEDMAINPLAYER, e.Numberpart, e.MINUTE) = 1

	if @@ROWCOUNT != 0
			print 'Some goals could not be inserted because the scorer was not on the field at that time'

end;
go

/*5. When a “Replacement” event is inserted, it must be verified: 
• If the “player out” was on the field2; 
• If the “player in” was not on the field already and was on the bench, available 
to replace another player (to be available to replace a player means that the 
person is summoned, is not in the starting 11, did not go in yet and did not 
receive a red card); 
• If the “player in” and the “player out” belong to the same team; 
• If the 2 players are in the same match. 
If any of these points is not verified, then the record must not be inserted, and a message 
must be displayed. (INSERT) */


create or alter trigger insert_e_replacement
on EVENTS
after insert
as 
begin
	
	Delete EVENTS
	from inserted i, tem_events e , SUMMONEDS s1, SUMMONEDS s2, PLAYER p1, PLAYER p2
	where EVENTS.IDEVENT = i.IDEVENT and i.IDEVENT = e.IDEvent and  i.EVENTTYPE = 'Replacement' and i.IDSUMMONEDMAINPLAYER = s1.IDSUMMONED and s1.IDPLAYER = p1.IDPERSON
		and i.IDSUMMONEDPLAYEROUT = s2.IDSUMMONED and s2.IDPLAYER = p2.IDPERSON
			and (-- Players from diferent teams
					(p1.IDCOUNTRY <> p2.IDCOUNTRY)
				or
				-- Players from diferent matches 
				(s1.IDMATCH <> s2.IDMATCH)
				or
				[dbo].[On_the_field](e.IDSUMMONEDPLAYEROUT, e.Numberpart, e.MINUTE) = 1
				or
				--PLAYER IN not on the field and on the bench
				(-- Because they received a red card
					(EXISTS(select 1 from tem_events e1 
						where i.IDSUMMONEDMAINPLAYER = e1.IDSummonedMainPlayer and e1.EventType = 'Card'
						and e1.CARDTYPE = 'Red' and (e.Numberpart > e1.Numberpart or (e.Numberpart = e1.Numberpart and e.Minute > e1.Minute))
							)
					)
					or 
				-- Was alredy replaced in
					(EXISTS(select 1 from tem_events e1
						where i.IDSUMMONEDMAINPLAYER = e1.IDSUMMONEDPLAYEROUT and e1.EventType = 'Replacement'
						and (e.Numberpart > e1.Numberpart or (e.Numberpart = e1.Numberpart and e.Minute > e1.Minute)) 
							)
					)
					or
				--Was on the starting 11
					(s1.STARTING11 = 1)
				)
				)

	if @@ROWCOUNT != 0
			print 'Some replacements could not be inserted because they do not respect the required criteria'
	
	--If any of the replacements are actually inserted, then update the IDEVENTPLAYEROUT in the SUMMONEDS table
	if (select count(*) from EVENTS e, inserted i where i.IDEVENT=e.IDEVENT and e.EVENTTYPE='Replacement') > 0
	begin
		update SUMMONEDS
		set SUMMONEDS.IDEVENTPLAYEROUT = i.IDEVENT
		from inserted i, EVENTS e
		where e.IDEVENT = i.IDEVENT and SUMMONEDS.IDSUMMONED = i.IDSUMMONEDPLAYEROUT and i.EVENTTYPE='Replacement'
	end

end;
go


sp_settriggerorder @triggername = 'insert_e_yellow', @order ='first' , @stmttype = 'INSERT';
go
sp_settriggerorder @triggername = 'insert_e_goal', @order ='last' , @stmttype = 'INSERT';
go

/* This solution is able to insert 1 card, multiple goals and 1 replacement per batch insert per player,
asuming that all records already in the events table are correct and we are trying to insert records after those .*/