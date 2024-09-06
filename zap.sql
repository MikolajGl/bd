create table KATEGORIE(
id number(3) constraint kategorie_pk Primary key,
nazwa varchar2(45) not null);

create table LINIE_ZAPACHOWE(
id number(3) constraint linie_zapachowe_pk primary key,
nazwa varchar2(45) not null,
opis varchar2(2500) not null);

create table KOSMETYKI(
id number(4) constraint kosmetyki_pk Primary key,
nazwa varchar2(45) not null constraint kosmetyki_nazwa_u Unique,
opis varchar2(2500),
cena number(7,2) not null,
data_rozpoczecia_produkcji date not null,
id_kategorii number(3) constraint kosmetyki_kategorie_fk references KATEGORIE(id),
id_linii_zapachowej number(3) constraint kosmetyki_linie_zapachowe_fk references LINIE_ZAPACHOWE(id));

create table ZESTAWY(
id number(3) constraint zestawy_pk primary key,
nazwa varchar2(45) not null,
opis varchar2(500) not null,
cena number(7,2) not null);

create table SKLADY_ZESTAWOW(
id_zestawu number(3) constraint s_z_z references ZESTAWY(id),
id_kosmetyku number(4) constraint s_z_k references KOSMETYKI(id),
primary key(id_zestawu,id_kosmetyku));

select * from zestawy;
select * from kosmetyki;
select * from linie_zapachowe;
select * from sklady_zestawow;
select * from kategorie;

insert into KATEGORIE values(1,'cienie');
insert into KATEGORIE values(2,'mydła');
insert into KATEGORIE values(3,'szampony');
insert into KATEGORIE values(4,'perfumy');
insert into KATEGORIE values(5,'balsamy');
insert into KATEGORIE values(6,'kremy');
insert into linie_zapachowe values(1,'zielone jabłuszko','opis1');
insert into linie_zapachowe values(2,'Różany wdzięk','opis2');
insert into linie_zapachowe values(3,'Japońska wiśnia','opis3');
insert into linie_zapachowe values(4,'Polskie zioła','opis4');
insert into KOSMETYKI (id, nazwa, opis, cena, data_rozpoczecia_produkcji, id_kategorii, id_linii_zapachowej)
values (1, 'Przykładowy Krem', 'Opis kremu', 49.99, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 6, 1);
insert into KOSMETYKI (id, nazwa, opis, cena, data_rozpoczecia_produkcji, id_kategorii, id_linii_zapachowej)
values (2, 'Inny Kosmetyk', 'Opis innego kosmetyku', 79.99, TO_DATE('2022-02-15', 'YYYY-MM-DD'), 4, 3);
insert into KOSMETYKI (id, nazwa, opis, cena, data_rozpoczecia_produkcji, id_kategorii, id_linii_zapachowej)
values (3, 'Inny Kosmetyk123', 'Opis innego kosmetyku123', 79.99, TO_DATE('2022-02-15', 'YYYY-MM-DD'), 6, 3);
insert into ZESTAWY (id, nazwa, opis, cena) values (1, 'WIŚNIOWY DOTYK', 'Opis zestawu Wiśniowego Dotyku', 59.99);
insert into ZESTAWY (id, nazwa, opis, cena) values (2, 'SZAMPONOWE SZALEŃSTWO', 'Opis zestawu Szamponowego Szaleństwa', 89.99);
insert into SKLADY_ZESTAWOW (id_zestawu, id_kosmetyku) values (1, 1);
insert into SKLADY_ZESTAWOW (id_zestawu, id_kosmetyku) values (1, 2);

select nazwa,opis,cena,length(nazwa)"liczba liter" from zestawy where cena between 50 and 70 and (opis like '%zestawu%' or nazwa like 'S%') order by 3,1 desc;
select lower(k.nazwa)"nazwa",to_char(data_rozpoczecia_produkcji,'DD month YYYY')"Data" from kosmetyki k join linie_zapachowe lz on k.id_linii_zapachowej=lz.id join kategorie ka on k.id_kategorii=ka.id 
where lz.nazwa='Japońska wiśnia' and ka.nazwa='kremy' order by 1;
select sz.id_kosmetyku from sklady_zestawow sz join zestawy z on sz.id_zestawu=z.id where z.opis is not null group by sz.id_kosmetyku having count(distinct sz.id_zestawu)>=1 order by sz.id_kosmetyku desc ;
select initcap(nazwa),to_char(data_rozpoczecia_produkcji,'YYYY')"Rok",to_char(data_rozpoczecia_produkcji,'Q')"kwartał" from kosmetyki k 
where k.data_rozpoczecia_produkcji=(select min(data_rozpoczecia_produkcji)from kosmetyki where nazwa=k.nazwa) order by 1;
select z.nazwa"Nazwa Zestawu",count(sz.id_kosmetyku) from zestawy z join sklady_zestawow sz on sz.id_zestawu=z.id join kosmetyki k on sz.id_kosmetyku=k.id where z.cena>30 group by z.nazwa order by 2 desc;
select z.nazwa"nazwa kosmetyku",k.nazwa,substr(k.nazwa,1,4)||substr(kat.id,1,2)||substr(lz.id,1,1)||to_char(k.data_rozpoczecia_produkcji,'YYYY')"kod kosmetyku" from zestawy z join sklady_zestawow sz on sz.id_zestawu=z.id 
join kosmetyki k on sz.id_kosmetyku=k.id  join kategorie kat on k.id_kategorii=kat.id join linie_zapachowe lz on k.id_linii_zapachowej=lz.id order by 1;
Select k.nazwa from kosmetyki k where k.cena=(select min(cena) from kosmetyki where k.id_kategorii=kosmetyki.id_kategorii group by id_kategorii) order by 1;
select kat.nazwa"Nazwa" from kategorie kat join kosmetyki k on kat.id=k.id_kategorii group by kat.nazwa having count(k.nazwa)=(select min(count(nazwa)) from kosmetyki group by id_kategorii);

Wybierz nazwy zestawów, nazwy kosmetyków, które wchodzą w skład zestawów oraz kody tych
kosmetyków. Kod kosmetyku powstaje ze sklejenia czterech pierwszych liter nazwy kosmetyku, dwóch
pierwszych liter nazwy kategorii, do której kosmetyk należy, pierwszej litery nazwy linii zapachowej, do
której kosmetyk należy i roku z daty rozpoczęcia produkcji. Uporządkuj wyniki według nazw zestawów.
Pierwszej kolumnie nadaj alias „Nazwa zestawu”, drugiej - „Nazwa kosmetyku”, trzeciej - „Kod
kosmetyku”.
