 ----- Line : 19 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1118" 

 ----- Line : 36 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 49 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 66 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 83 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 102 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 115 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 134 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 153 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 170 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 187 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-194" 

 ----- Line : 207 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634283
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 236 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="MBSA001" 

 ----- Line : 264 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634285 

 ----- Line : 277 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 290 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 307 
 select carbol_pack_cod ,carbol_status ,carbol_nat_cod ,carbol_pack_nber ,carbol_gros_mas ,carbol_abandoned ,carbol_frt_value ,carbol_cust_value ,carbol_trsp_value ,carbol_insu_value ,carbol_cbm ,carbol_cont_nber into :b0,:b1,:b2,:b3,:b4,:b5,:b6,:b7,:b8,:b9,:b10,:b11  from car_bol_gen where (((key_cuo=:b12 and key_voy_nber=:b13) and key_dep_date=:b14) and key_bol_ref=:b15) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="MBSA001" 

 ----- Line : 344 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634285 

 ----- Line : 355 
 select count(*)  into :b0  from sel_bol where (lst_car like :b1 and bol_ref=:b2) ;

--Bind 0   value="%20120926MSCNEFELI 20120626"
--Bind 1   value="MBSA001" 

 ----- Line : 371 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 384 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="TZDL"
--Bind 4   value="20120926MSCNEFELI"
--Bind 5   value="20120626"
--Bind 6   value="MBSA001" 

 ----- Line : 419 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634285
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="MBSA001" 

 ----- Line : 448 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634285 

 ----- Line : 459 
 insert into car_bol_ope values (  :VA0,  :VA1,  :VA2,  :VA3,  :VA4,  :VA5,  :VA6,  :VA7,  :VA8,  :VA9,  :VA10,  :VA11,  :VA12,  :VA13,  :VA14,  :VA15,  :VA16,  :VA17,  :VA18,  :VA19,  :VA20,  :VA21,  :VA22,  :VA23,  :VA24,  :VA25,  :VA26,  :VA27,  :VA28, car_bol_ser.NEXTVAL) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="2"
--Bind 5   value="0.000000"
--Bind 6   value="0.000000"
--Bind 7
--Bind 8
--Bind 9
--Bind 10   value="TRA\CUS\CED\123\05"
--Bind 11
--Bind 12
--Bind 13
--Bind 14   value="MAN"
--Bind 15   value="20121205"
--Bind 16   value="07:52:57"
--Bind 17   value="128"
--Bind 18   value="18.600000"
--Bind 19   value="0.000000"
--Bind 20   value="1736.000000"
--Bind 21   value="0.000000"
--Bind 22
--Bind 23
--Bind 24
--Bind 25   value="62"
--Bind 26   value="0"
--Bind 27   value="MACHINERY CAPITAL GOODS_EXEMPTED"
--Bind 28   value="STUDENT01" 

 ----- Line : 544 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="11"
--Bind 5   value="15"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121205"
--Bind 8   value="07:52:57"
--Bind 9   value="1968" 

>>> END
