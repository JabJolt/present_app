/*-------------TABLES-------------*/

/*PERSON*/
delete from PERSON;
insert into PERSON (NAME, DESCRIPTION) values ('UMUDUMOVA GALINA ALEKSANDROVNA', 'Умудумова Галина Александровна');
insert into PERSON (NAME, DESCRIPTION) values ('UMUDUMOV DIONIS SERGEEVICH', 'Умудумов Дионис Сергеевич');
--select * from PERSON

/*DIM_CURRENCY*/
delete from DIM_CURRENCY;
insert into DIM_CURRENCY (CURRENCY_CODE) values ('RUR');
insert into DIM_CURRENCY (CURRENCY_CODE) values ('USD');
--select * from DIM_CURRENCY

/*DIM_PERSON_CATEGORY*/
delete from DIM_PERSON_CATEGORY;
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('FAMILY', 'Семья');
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('RELATIVES', 'Родственники');
insert into DIM_PERSON_CATEGORY (CATEGORY_NAME, DESCRIPTION) values ('FRIENDS', 'Друзья');
--select * from DIM_PERSON_CATEGORY;

/*EVENT*/
delete from EVENT;
insert into EVENT (EVENT_NAME, EVENT_DATE, DESCRIPTION) values ('NEW YEAR 31', strftime('%Y/%m/%d','3000-12-31'),'Новый год');
insert into EVENT (EVENT_NAME, EVENT_DATE, DESCRIPTION) values ('OLD NEW YEAR', strftime('%Y/%m/%d','3000-01-14'),'Старый Новый год');
--select * from EVENT

/*PERIOD*/
--IS_ACTUAL FLAG TO VIEW
delete from PERIOD;
insert into PERIOD (DATE_FROM, DATE_TO, EVENT_ID) values (strftime('%Y/%m/%d','2018-01-01'), strftime('%Y/%m/%d','2018-12-31'),1);
insert into PERIOD (DATE_FROM, DATE_TO, EVENT_ID) values (strftime('%Y/%m/%d','2017-01-01'), strftime('%Y/%m/%d','2017-12-31'),1);
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




/*ACTUAL PRESENTS FOR PERIOD*/
--create view ACTUAL_PRESENTS as 
select 
    P.NAME AS PERSON_NAME
    ,E.EVENT_NAME
    --,PC.CATEGORY_NAME
    --,AP.DATE_FROM
    --,AP.DATE_TO
from
    EVENT E
    ,PERSON P
    ,GIFT G
    --,V_ACT_PERIOD AP
    --,DIM_PERSON_CATEGORY PC
where 
    E.PERSON_ID = P.PERSON_ID
    and E.EVENT_ID = G.EVENT_ID
    --and E.EVENT_ID = AP.EVENT_ID
    --and PC.CATEGORY_ID = P.CATEGORY_ID
    --and not exists (select 1 from GIFT G2 where P.PERSON_ID = G2.PERSON_ID and IS_GOT = 1) --already bought --check
    and strftime('%m/%d','now') <= E.EVENT_DATE --check
    --and G.IS_GOT != 1

--select * from EVENT
--update EVENT set PERSON_ID = 1
--select * from PERSON
--select * from V_ACT_PERIOD
--update PERSON set CATEGORY_ID = 1
--select * from DIM_PERSON_CATEGORY

--select DATE('now') > DATE('2017-11-30')
--select strftime('%m/%d','now') < strftime('%m/%d','2018-12-31')


/*ACUTAL EVENTS*/
select 
    E.EVENT_NAME,
    E.EVENT_DATE
from EVENT E,
     PERIOD P
where 
    E.EVENT_ID = P.EVENT_ID
order by EVENT_DATE
    