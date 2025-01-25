/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     18/10/2023 23:25:49                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CITIES') and o.name = 'FK_CITIES_COUNTRIES')
alter table CITIES
   drop constraint FK_CITIES_COUNTRIES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COACH') and o.name = 'FK_COACH_COUNTRIES')
alter table COACH
   drop constraint FK_COACH_COUNTRIES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COUNTRIES') and o.name = 'FK_COUNTRIES_GROUPS')
alter table COUNTRIES
   drop constraint FK_COUNTRIES_GROUPS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENTS') and o.name = 'FK_EVENTS_MAIN_PLAYER')
alter table EVENTS
   drop constraint FK_EVENTS_MAIN_PLAYER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENTS') and o.name = 'FK_EVENTS_PLAYER_OUT')
alter table EVENTS
   drop constraint FK_EVENTS_PLAYER_OUT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MATCH') and o.name = 'FK_MATCH_AWAY_TEAM')
alter table MATCH
   drop constraint FK_MATCH_AWAY_TEAM
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MATCH') and o.name = 'FK_MATCH_TPHASE')
alter table MATCH
   drop constraint FK_MATCH_TPHASE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MATCH') and o.name = 'FK_MATCH_HOME_TEAM')
alter table MATCH
   drop constraint FK_MATCH_HOME_TEAM
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MATCH') and o.name = 'FK_MATCH_REFEREE')
alter table MATCH
   drop constraint FK_MATCH_REFEREE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MATCH') and o.name = 'FK_MATCH_STADIUM')
alter table MATCH
   drop constraint FK_MATCH_STADIUM
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PLAYER') and o.name = 'FK_PLAYER_COUNTRIES')
alter table PLAYER
   drop constraint FK_PLAYER_COUNTRIES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REFEREE') and o.name = 'FK_REFEREE_COUNTRIES')
alter table REFEREE
   drop constraint FK_REFEREE_COUNTRIES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STADIUM') and o.name = 'FK_STADIUM_CITIES')
alter table STADIUM
   drop constraint FK_STADIUM_CITIES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SUMMONEDS') and o.name = 'FK_SUMMONEDS_MATCH')
alter table SUMMONEDS
   drop constraint FK_SUMMONEDS_MATCH
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SUMMONEDS') and o.name = 'FK_SUMMONED_EVENT_PLAYER_OUT')
alter table SUMMONEDS
   drop constraint FK_SUMMONED_EVENT_PLAYER_OUT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SUMMONEDS') and o.name = 'FK_SUMMONEDS_PLAYER')
alter table SUMMONEDS
   drop constraint FK_SUMMONEDS_PLAYER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CITIES')
            and   name  = 'BELONGS_TO_FK'
            and   indid > 0
            and   indid < 255)
   drop index CITIES.BELONGS_TO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CITIES')
            and   type = 'U')
   drop table CITIES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COACH')
            and   name  = 'COUNTRY_FK'
            and   indid > 0
            and   indid < 255)
   drop index COACH.COUNTRY_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COACH')
            and   type = 'U')
   drop table COACH
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COUNTRIES')
            and   name  = 'GROUP_FK'
            and   indid > 0
            and   indid < 255)
   drop index COUNTRIES.GROUP_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COUNTRIES')
            and   type = 'U')
   drop table COUNTRIES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EVENTS')
            and   name  = 'PLAYER_OUT_FK'
            and   indid > 0
            and   indid < 255)
   drop index EVENTS.PLAYER_OUT_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EVENTS')
            and   name  = 'MAIN_PLAYER_FK'
            and   indid > 0
            and   indid < 255)
   drop index EVENTS.MAIN_PLAYER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EVENTS')
            and   type = 'U')
   drop table EVENTS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('GROUPS')
            and   type = 'U')
   drop table GROUPS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATCH')
            and   name  = 'REFEREE_FK'
            and   indid > 0
            and   indid < 255)
   drop index MATCH.REFEREE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATCH')
            and   name  = 'HOME_TEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index MATCH.HOME_TEAM_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATCH')
            and   name  = 'AWAY_TEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index MATCH.AWAY_TEAM_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATCH')
            and   name  = 'TPHASE_FK'
            and   indid > 0
            and   indid < 255)
   drop index MATCH.TPHASE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATCH')
            and   name  = 'STADIUM_FK'
            and   indid > 0
            and   indid < 255)
   drop index MATCH.STADIUM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MATCH')
            and   type = 'U')
   drop table MATCH
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PLAYER')
            and   name  = 'COUNTRY_FK'
            and   indid > 0
            and   indid < 255)
   drop index PLAYER.COUNTRY_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PLAYER')
            and   type = 'U')
   drop table PLAYER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REFEREE')
            and   name  = 'COUNTRY_FK'
            and   indid > 0
            and   indid < 255)
   drop index REFEREE.COUNTRY_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REFEREE')
            and   type = 'U')
   drop table REFEREE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STADIUM')
            and   name  = 'CITY_FK'
            and   indid > 0
            and   indid < 255)
   drop index STADIUM.CITY_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STADIUM')
            and   type = 'U')
   drop table STADIUM
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SUMMONEDS')
            and   name  = 'PLAYER_FK'
            and   indid > 0
            and   indid < 255)
   drop index SUMMONEDS.PLAYER_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SUMMONEDS')
            and   name  = 'PLAYER_OUT_FK'
            and   indid > 0
            and   indid < 255)
   drop index SUMMONEDS.PLAYER_OUT_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SUMMONEDS')
            and   name  = 'MATCH_FK'
            and   indid > 0
            and   indid < 255)
   drop index SUMMONEDS.MATCH_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SUMMONEDS')
            and   type = 'U')
   drop table SUMMONEDS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TOURNAMENT_PHASE')
            and   type = 'U')
   drop table TOURNAMENT_PHASE
go

/*==============================================================*/
/* Table: CITIES                                                */
/*==============================================================*/
create table CITIES (
   IDCITY               numeric              identity,
   IDCOUNTRY            numeric              not null,
   NAME                 varchar(100)         not null,
   constraint PK_CITIES primary key nonclustered (IDCITY)
)
go

/*==============================================================*/
/* Index: BELONGS_TO_FK                                         */
/*==============================================================*/
create index BELONGS_TO_FK on CITIES (
IDCOUNTRY ASC
)
go

/*==============================================================*/
/* Table: COACH                                                 */
/*==============================================================*/
create table COACH (
   IDPERSON             numeric              identity,
   IDCOUNTRY            numeric              not null,
   NAME                 varchar(100)         not null,
   DATEOFBIRTH          datetime             not null,
   GENDER               varchar(8)           not null
      constraint CKC_GENDER_COACH check (GENDER in ('Male','Female','Other')),
   constraint PK_COACH primary key (IDPERSON)
)
go

/*==============================================================*/
/* Index: COUNTRY_FK                                            */
/*==============================================================*/
create index COUNTRY_FK on COACH (
IDCOUNTRY ASC
)
go

/*==============================================================*/
/* Table: COUNTRIES                                             */
/*==============================================================*/
create table COUNTRIES (
   IDCOUNTRY            numeric              identity,
   IDGROUP              numeric              null,
   COUNTRYNAME          varchar(30)          not null,
   COUNTRYCODE          varchar(3)           not null,
   constraint PK_COUNTRIES primary key nonclustered (IDCOUNTRY),
   constraint AK_UNIQUE_COUNTRY_COD_COUNTRIE unique (COUNTRYCODE)
)
go

/*==============================================================*/
/* Index: GROUP_FK                                              */
/*==============================================================*/
create index GROUP_FK on COUNTRIES (
IDGROUP ASC
)
go

/*==============================================================*/
/* Table: EVENTS                                                */
/*==============================================================*/
create table EVENTS (
   IDEVENT              numeric              identity,
   IDSUMMONEDMAINPLAYER numeric              not null,
   IDSUMMONEDPLAYEROUT  numeric              null,
   MINUTE               int                  not null,
   MATCHPART            varchar(100)         not null
      constraint CKC_MATCHPART_EVENTS check (MATCHPART in ('First half','First half added time','Second half','Second half added time','Extra time first half','Extra time first half added time','Extra time second half','Extra time second half added time','Penalties')),
   EVENTTYPE            varchar(50)          not null
      constraint CKC_EVENTTYPE_EVENTS check (EVENTTYPE in ('Goal','Card','Replacement')),
   ISPENALTY            bit                  null,
   ISOWNGOAL            bit                  null default 0,
   CARDTYPE             varchar(20)          null
      constraint CKC_CARDTYPE_EVENTS check (CARDTYPE is null or (CARDTYPE in ('Yellow','Red'))),
   constraint PK_EVENTS primary key nonclustered (IDEVENT)
)
go

/*==============================================================*/
/* Index: MAIN_PLAYER_FK                                        */
/*==============================================================*/
create index MAIN_PLAYER_FK on EVENTS (
IDSUMMONEDMAINPLAYER ASC
)
go

/*==============================================================*/
/* Index: PLAYER_OUT_FK                                         */
/*==============================================================*/
create index PLAYER_OUT_FK on EVENTS (
IDSUMMONEDPLAYEROUT ASC
)
go

/*==============================================================*/
/* Table: GROUPS                                                */
/*==============================================================*/
create table GROUPS (
   IDGROUP              numeric              identity,
   GROUPNAME            varchar(1)           not null,
   constraint PK_GROUPS primary key nonclustered (IDGROUP),
   constraint AK_UNIQUE_GROUP_GROUPS unique (GROUPNAME)
)
go

/*==============================================================*/
/* Table: MATCH                                                 */
/*==============================================================*/
create table MATCH (
   IDMATCH              numeric              identity,
   IDAWAYTEAM           numeric              not null,
   IDTOURNAMENTPHASE    numeric              not null,
   IDSTADIUM            numeric              not null,
   IDHOMETEAM           numeric              not null,
   IDREFEREE            numeric              not null,
   STARTDATETIME        datetime             not null,
   ADDEDTIME1STHALF     smallint             null,
   ADDEDTIME2NDHALF     smallint             null,
   EXTRATIMEADDEDTIME1STHALF smallint             null,
   EXTRATIMEADDEDTIME2NDHALF smallint             null,
   EXTRATIME            bit                  null,
   PENALTIES            bit                  null,
   constraint PK_MATCH primary key nonclustered (IDMATCH)
)
go

/*==============================================================*/
/* Index: STADIUM_FK                                            */
/*==============================================================*/
create index STADIUM_FK on MATCH (
IDSTADIUM ASC
)
go

/*==============================================================*/
/* Index: TPHASE_FK                                             */
/*==============================================================*/
create index TPHASE_FK on MATCH (
IDTOURNAMENTPHASE ASC
)
go

/*==============================================================*/
/* Index: AWAY_TEAM_FK                                          */
/*==============================================================*/
create index AWAY_TEAM_FK on MATCH (
IDAWAYTEAM ASC
)
go

/*==============================================================*/
/* Index: HOME_TEAM_FK                                          */
/*==============================================================*/
create index HOME_TEAM_FK on MATCH (
IDHOMETEAM ASC
)
go

/*==============================================================*/
/* Index: REFEREE_FK                                            */
/*==============================================================*/
create index REFEREE_FK on MATCH (
IDREFEREE ASC
)
go

/*==============================================================*/
/* Table: PLAYER                                                */
/*==============================================================*/
create table PLAYER (
   IDPERSON             numeric              identity,
   IDCOUNTRY            numeric              not null,
   NAME                 varchar(100)         not null,
   DATEOFBIRTH          datetime             not null,
   GENDER               varchar(8)           not null
      constraint CKC_GENDER_PLAYER check (GENDER in ('Male','Female','Other')),
   FIELDPOSITION        varchar(50)          not null
      constraint CKC_FIELDPOSITION_PLAYER check (FIELDPOSITION in ('Goalkeeper','Right Fullback','Left Fullback','Center back','Center Midfield','Right Midfield/Wing','Forward','Left Midfield/Wing')),
   constraint PK_PLAYER primary key (IDPERSON)
)
go

/*==============================================================*/
/* Index: COUNTRY_FK                                            */
/*==============================================================*/
create index COUNTRY_FK on PLAYER (
IDCOUNTRY ASC
)
go

/*==============================================================*/
/* Table: REFEREE                                               */
/*==============================================================*/
create table REFEREE (
   IDPERSON             numeric              identity,
   IDCOUNTRY            numeric              not null,
   NAME                 varchar(100)         not null,
   DATEOFBIRTH          datetime             not null,
   GENDER               varchar(8)           not null
      constraint CKC_GENDER_REFEREE check (GENDER in ('Male','Female','Other')),
   constraint PK_REFEREE primary key (IDPERSON)
)
go

/*==============================================================*/
/* Index: COUNTRY_FK                                            */
/*==============================================================*/
create index COUNTRY_FK on REFEREE (
IDCOUNTRY ASC
)
go

/*==============================================================*/
/* Table: STADIUM                                               */
/*==============================================================*/
create table STADIUM (
   IDSTADIUM            numeric              identity,
   IDCITY               numeric              not null,
   NAME                 varchar(100)         not null,
   constraint PK_STADIUM primary key nonclustered (IDSTADIUM)
)
go

/*==============================================================*/
/* Index: CITY_FK                                               */
/*==============================================================*/
create index CITY_FK on STADIUM (
IDCITY ASC
)
go

/*==============================================================*/
/* Table: SUMMONEDS                                             */
/*==============================================================*/
create table SUMMONEDS (
   IDSUMMONED           numeric              identity,
   IDEVENTPLAYEROUT     numeric              null,
   IDPLAYER             numeric              not null,
   IDMATCH              numeric              not null,
   STARTING11           bit                  null,
   constraint PK_SUMMONEDS primary key (IDSUMMONED),
   constraint AK_UNIQUE_SUMMONED_PL_SUMMONED unique (IDPLAYER, IDMATCH)
)
go

/*==============================================================*/
/* Index: MATCH_FK                                              */
/*==============================================================*/
create index MATCH_FK on SUMMONEDS (
IDMATCH ASC
)
go

/*==============================================================*/
/* Index: PLAYER_OUT_FK                                         */
/*==============================================================*/
create index PLAYER_OUT_FK on SUMMONEDS (
IDEVENTPLAYEROUT ASC
)
go

/*==============================================================*/
/* Index: PLAYER_FK                                             */
/*==============================================================*/
create index PLAYER_FK on SUMMONEDS (
IDPLAYER ASC
)
go

/*==============================================================*/
/* Table: TOURNAMENT_PHASE                                      */
/*==============================================================*/
create table TOURNAMENT_PHASE (
   IDTOURNAMENTPHASE    numeric              identity,
   TOURNAMENTPHASE      varchar(50)          not null
      constraint CKC_TOURNAMENTPHASE_TOURNAME check (TOURNAMENTPHASE in ('Group Stage','Round of 16','Quarter finals','Semi finals','Final','Third-place play-off')),
   DATESTART            datetime             not null,
   DATEEND              datetime             not null,
   constraint PK_TOURNAMENT_PHASE primary key nonclustered (IDTOURNAMENTPHASE),
   constraint AK_UNIQUE_TPHASE_TOURNAME unique (TOURNAMENTPHASE)
)
go

alter table CITIES
   add constraint FK_CITIES_COUNTRIES foreign key (IDCOUNTRY)
      references COUNTRIES (IDCOUNTRY)
go

alter table COACH
   add constraint FK_COACH_COUNTRIES foreign key (IDCOUNTRY)
      references COUNTRIES (IDCOUNTRY)
go

alter table COUNTRIES
   add constraint FK_COUNTRIES_GROUPS foreign key (IDGROUP)
      references GROUPS (IDGROUP)
go

alter table EVENTS
   add constraint FK_EVENTS_MAIN_PLAYER foreign key (IDSUMMONEDMAINPLAYER)
      references SUMMONEDS (IDSUMMONED)
go

alter table EVENTS
   add constraint FK_EVENTS_PLAYER_OUT foreign key (IDSUMMONEDPLAYEROUT)
      references SUMMONEDS (IDSUMMONED)
go

alter table MATCH
   add constraint FK_MATCH_AWAY_TEAM foreign key (IDAWAYTEAM)
      references COUNTRIES (IDCOUNTRY)
go

alter table MATCH
   add constraint FK_MATCH_TPHASE foreign key (IDTOURNAMENTPHASE)
      references TOURNAMENT_PHASE (IDTOURNAMENTPHASE)
go

alter table MATCH
   add constraint FK_MATCH_HOME_TEAM foreign key (IDHOMETEAM)
      references COUNTRIES (IDCOUNTRY)
go

alter table MATCH
   add constraint FK_MATCH_REFEREE foreign key (IDREFEREE)
      references REFEREE (IDPERSON)
go

alter table MATCH
   add constraint FK_MATCH_STADIUM foreign key (IDSTADIUM)
      references STADIUM (IDSTADIUM)
go

alter table PLAYER
   add constraint FK_PLAYER_COUNTRIES foreign key (IDCOUNTRY)
      references COUNTRIES (IDCOUNTRY)
go

alter table REFEREE
   add constraint FK_REFEREE_COUNTRIES foreign key (IDCOUNTRY)
      references COUNTRIES (IDCOUNTRY)
go

alter table STADIUM
   add constraint FK_STADIUM_CITIES foreign key (IDCITY)
      references CITIES (IDCITY)
go

alter table SUMMONEDS
   add constraint FK_SUMMONEDS_MATCH foreign key (IDMATCH)
      references MATCH (IDMATCH)
go

alter table SUMMONEDS
   add constraint FK_SUMMONED_EVENT_PLAYER_OUT foreign key (IDEVENTPLAYEROUT)
      references EVENTS (IDEVENT)
go

alter table SUMMONEDS
   add constraint FK_SUMMONEDS_PLAYER foreign key (IDPLAYER)
      references PLAYER (IDPERSON)
go

