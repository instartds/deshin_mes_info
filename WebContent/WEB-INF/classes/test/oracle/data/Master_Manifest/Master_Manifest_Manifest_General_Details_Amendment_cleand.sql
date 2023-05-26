 ----- Line : 19 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 30 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 50 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634284 

 ----- Line : 61 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 78 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 98 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 118 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="FXTDAR-195" 

 ----- Line : 156 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284 

 ----- Line : 167 
 select count(*)  into :b0  from car_bol_ope where ((((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) and car_ope_typ='ASS') ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 187 
 select count(*)  into :b0  from car_bol_res where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 207 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 227 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 252 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1118" 

 ----- Line : 271 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 284 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 301 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 320 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 333 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 352 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 371 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 388 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="TZDL"
--Bind 4   value="20120926MSCNEFELI"
--Bind 5   value="20120626"
--Bind 6   value="FXTDAR-194" 

 ----- Line : 422 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634283
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 451 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="MBSA001" 

 ----- Line : 479 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634285 

 ----- Line : 492 
 select ser_db ,rep_flg into :b0,:b1  from server_state  ;
 

 ----- Line : 498 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

 ----- Line : 508 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 522 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 539 
 select rowid from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 556 
 delete from car_gen where rowid = 'AAA7MGAAFAAAMPuAAM'  ;
 

 ----- Line : 564 
 insert into car_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35) ;
 

 ----- Line : 571 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="AEDXB" 

 ----- Line : 584 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZMYW" 

 ----- Line : 597 
 select rowid from UNCARTAB where CAR_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="SSA" 

 ----- Line : 610 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="1" 

 ----- Line : 623 
 select rowid from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="1" 

 ----- Line : 639 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="CN"
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="20120627"
--Bind 5   value="11:00"
--Bind 6   value="2012"
--Bind 7   value="1118"
--Bind 8   value="20121204"
--Bind 9   value="17:10"
--Bind 10   value="AEDXB"
--Bind 11   value="TZMYW"
--Bind 12   value="SSA"
--Bind 13   value="Sealand shipping agencies co ltd"
--Bind 14   value="dsm"
--Bind 15
--Bind 16
--Bind 17
--Bind 18   value="1"
--Bind 19   value="MSC NEFELI VOY 18A"
--Bind 20   value="CN"
--Bind 21   value="SHANGHAI"
--Bind 22
--Bind 23
--Bind 24
--Bind 25
--Bind 26
--Bind 27
--Bind 28   value="4500"
--Bind 29   value="3"
--Bind 30   value="19"
--Bind 31   value="7000.000"
--Bind 32   value="2"
--Bind 33
--Bind 34
--Bind 35
--Bind 36 

 ----- Line : 747 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3
--Bind 4   value="3"
--Bind 5   value="3"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121205"
--Bind 8   value="07:48:42"
--Bind 9   value="1984" 

 ----- Line : 789 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

>>> END
