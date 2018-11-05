/*-------------TABLES-------------*/

/*DIM_PERSON_CATEGORY*/
delete from DIM_PERSON_CATEGORY;
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('FAMILY', 'Семья');
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('RELATIVES', 'Родственники');
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('FRIENDS', 'Друзья');
--select * from DIM_PERSON_CATEGORY;

/*PERSON*/
delete from PERSON;
insert into PERSON (NAME, DESCRIPTION, CATEGORY_ID) values ('UMUDUMOVA GALINA ALEKSANDROVNA', 'Умудумова Галина Александровна', 1);
insert into PERSON (NAME, DESCRIPTION, CATEGORY_ID) values ('UMUDUMOV DIONIS SERGEEVICH', 'Умудумов Дионис Сергеевич', 1);
--select * from PERSON
--update PERSON set CATEGORY_ID = 1;

/*DIM_CURRENCY*/
delete from DIM_CURRENCY;
insert into DIM_CURRENCY (CURRENCY_CODE) values ('RUR');
insert into DIM_CURRENCY (CURRENCY_CODE) values ('USD');
--select * from DIM_CURRENCY

/*EVENT*/
delete from EVENT;
insert into EVENT (EVENT_NAME, EVENT_DATE, DESCRIPTION, PERIOD_ID, CATEGORY_ID) values ('NEW YEAR 31', strftime('%Y/%m/%d','3000-12-31'),'Новый год',2, 1);
insert into EVENT (EVENT_NAME, EVENT_DATE, DESCRIPTION, PERIOD_ID, CATEGORY_ID) values ('OLD NEW YEAR', strftime('%Y/%m/%d','3000-01-14'),'Старый Новый год', 2, 1);
--select * from EVENT

/*PERIOD*/
--IS_ACTUAL FLAG TO VIEW
delete from PERIOD;
insert into PERIOD (DATE_FROM, DATE_TO) values (strftime('%Y/%m/%d','2017-01-01'), strftime('%Y/%m/%d','2017-12-31'));
insert into PERIOD (DATE_FROM, DATE_TO) values (strftime('%Y/%m/%d','2018-01-01'), strftime('%Y/%m/%d','2018-12-31'));
--select * from PERIOD
--select strftime('%m/%d','2018-12-31')

/*GIFT*/
delete from GIFT;
insert into GIFT (GIFT_NAME, PRICE, STATE, CURRENCY_ID, PERSON_ID, EVENT_ID)
    values ('Gucci flora Gorgeous gardenia', 2000, 'GIVEN', 1, 1, 1);
insert into GIFT (GIFT_NAME, PRICE, STATE, CURRENCY_ID, PERSON_ID, EVENT_ID)
    values ('Серьги с опалом', null, 'PLANNED', 1, 1, 1);
--select * from GIFT
--update GIFT set STATE = ''
--STATE IN ('PLANNED', 'GIVEN', 'LEFT', 'IDLE', 'UNKNOWN')

/*-------------VIEWS-------------*/
/*V_ACT_PERIOD current year*/
create view if not exists V_ACT_PERIOD as
select * from PERIOD
    where strftime('%Y/%m/%d',datetime('now')) between DATE_FROM and DATE_TO;
--select * from V_ACT_PERIOD

/*ACTUAL PERIODS for nearest 3 months...*/
--...

/*ACTUAL_PERSON view, which anticipates potential PERSON for presenting*/
--create view if not exists V_ACTUAL_PERSON as
select 
    E.*,
    P.*
    from EVENT E
    left join PERSON P on E.CATEGORY_ID = P.CATEGORY_ID
--select * from PERSON
--!!!USE THIS VIEW FOR GENERATING LIST OF PERSON WHO NEED PRESENT AND DOESN'T HAVE IT IN GIFT WITH "BOUGHT" like STATE!!!
        
    

/*ACTUAL PRESENTS FOR PERIOD*/
--create view V_ACTUAL_PRESENTS as
select
    P.NAME AS PERSON_NAME
    ,E.EVENT_NAME
    ,G.STATE
    ,G.GIFT_NAME
    ,PC.CATEGORY_NAME
    ,AP.DATE_FROM
    ,AP.DATE_TO
from
    EVENT E
    left join PERSON P on E.PERSON_ID = P.PERSON_ID
    left join GIFT G on P.PERSON_ID = G.PERSON_ID
    left join V_ACT_PERIOD AP on E.PERIOD_ID = AP.PERIOD_ID
    left join DIM_PERSON_CATEGORY PC on P.CATEGORY_ID = PC.CATEGORY_ID
where
    G.STATE not in ('GIVEN', 'WAITING')

-------
    
select
    P.NAME AS PERSON_NAME
    ,E.EVENT_NAME
    --,G.STATE
    --,G.GIFT_NAME
from
    PERSON P
    left join EVENT P on E.PERSON_ID = P.PERSON_ID
    left join GIFT G on P.PERSON_ID = G.PERSON_ID
where
    G.STATE not in ('GIVEN', 'WAITING')
--select * from EVENT
--update EVENT set PERSON_ID = 1
--select * from GIFT
--select * from V_ACT_PERIOD
--update PERSON set CATEGORY_ID = 1
--select * from PERSON
--select * from DIM_PERSON_CATEGORY
--select DATE('now') > DATE('2017-11-30')
--select strftime('%m/%d','now') < strftime('%m/%d','2018-12-31')
--select * from PERSON P, DIM_PERSON_CATEGORY PC where PC.CATEGORY_ID = P.CATEGORY_ID
--select * from PERSON P, GIFT G where P.PERSON_ID = G.PERSON_ID

/*
PLANNED - know what to buy for event
GIVEN - presented
LEFT - left to buyer
WAITING - bought and waiting for presenting
UNKNOWN - donno what to buy
NOBODY - donno who to present
*/

/*ACUTAL EVENTS*/
select
    E.EVENT_NAME,
    E.EVENT_DATE
from EVENT E,
     PERIOD P
where
    E.EVENT_ID = P.EVENT_ID
order by EVENT_DATE;
