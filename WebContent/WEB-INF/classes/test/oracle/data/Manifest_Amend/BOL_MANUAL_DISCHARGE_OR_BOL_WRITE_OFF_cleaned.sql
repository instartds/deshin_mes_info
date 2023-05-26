 ----- Line : 19 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1114" 

 ----- Line : 36 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 49 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 66 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 83 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 102 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 115 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 134 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 153 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 170 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 187 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 207 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00514" 

 ----- Line : 236 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 264 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 293 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 321 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 350 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 378 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 407 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 435 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 464 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 492 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 521 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 549 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 578 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 606 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 635 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 663 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 692 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 720 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 749 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 777 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 806 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 834 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 863 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 876 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 889 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 906 
 select carbol_pack_cod ,carbol_status ,carbol_nat_cod ,carbol_pack_nber ,carbol_gros_mas ,carbol_abandoned ,carbol_frt_value ,carbol_cust_value ,carbol_trsp_value ,carbol_insu_value ,carbol_cbm ,carbol_cont_nber into :b0,:b1,:b2,:b3,:b4,:b5,:b6,:b7,:b8,:b9,:b10,:b11  from car_bol_gen where (((key_cuo=:b12 and key_voy_nber=:b13) and key_dep_date=:b14) and key_bol_ref=:b15) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA39AA13662"
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA39AA13662" 

 ----- Line : 943 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508176 

 ----- Line : 954 
 select count(*)  into :b0  from sel_bol where (lst_car like :b1 and bol_ref=:b2) ;

--Bind 0   value="%20120903ANAFI30SH 20120903"
--Bind 1   value="SCJUA39AA13662" 

 ----- Line : 970 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 983 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="TZDL"
--Bind 4   value="20120903ANAFI30SH"
--Bind 5   value="20120903"
--Bind 6   value="SCJUA39AA13662" 

 ----- Line : 1018 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 1047 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508176 

 ----- Line : 1058 
 insert into car_bol_ope values (  :VA0,  :VA1,  :VA2,  :VA3,  :VA4,  :VA5,  :VA6,  :VA7,  :VA8,  :VA9,  :VA10,  :VA11,  :VA12,  :VA13,  :VA14,  :VA15,  :VA16,  :VA17,  :VA18,  :VA19,  :VA20,  :VA21,  :VA22,  :VA23,  :VA24,  :VA25,  :VA26,  :VA27,  :VA28, car_bol_ser.NEXTVAL) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA39AA13662"
--Bind 4   value="2"
--Bind 5   value="0.000000"
--Bind 6   value="0.000000"
--Bind 7
--Bind 8
--Bind 9
--Bind 10   value="TRA/CUS/134/12"
--Bind 11
--Bind 12
--Bind 13
--Bind 14   value="MAN"
--Bind 15   value="20121204"
--Bind 16   value="13:14:52"
--Bind 17   value="2"
--Bind 18   value="84.000000"
--Bind 19   value="0.000000"
--Bind 20   value="112714.000000"
--Bind 21   value="0.000000"
--Bind 22
--Bind 23
--Bind 24
--Bind 25   value="0"
--Bind 26   value="0"
--Bind 27   value="BAGGAGE DECLARATION"
--Bind 28   value="STUDENT01" 

 ----- Line : 1143 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA39AA13662"
--Bind 4   value="11"
--Bind 5   value="15"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="13:14:52"
--Bind 9   value="1968" 

 ----- Line : 1187 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1114" 

 ----- Line : 1206 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1220 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1239 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1258 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1271 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1290 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1309 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1329 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="TZDL"
--Bind 4   value="20120903ANAFI30SH"
--Bind 5   value="20120903"
--Bind 6   value="ANTGEOFRE1234" 

 ----- Line : 1364 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00514" 

 ----- Line : 1393 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 1421 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 1450 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 1478 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 1507 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 1535 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 1564 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 1592 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 1621 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 1649 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 1678 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 1706 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 1735 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 1763 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 1792 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 1820 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 1849 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 1877 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 1906 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 1934 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 1963 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 1991 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 2020 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 2033 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00514" 

 ----- Line : 2061 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508175 

 ----- Line : 2074 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2091 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 2111 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=1 

 ----- Line : 2131 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=1
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA30AA00514" 

 ----- Line : 2169 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175 

 ----- Line : 2180 
 select count(*)  into :b0  from car_bol_ope where ((((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) and car_ope_typ='ASS') ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 2200 
 select count(*)  into :b0  from car_bol_res where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 2223 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 2243 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514"
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA30AA00523A" 

 ----- Line : 2281 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A"
--Bind 5   value="TZDL"
--Bind 6   value="20120903ANAFI30SH"
--Bind 7   value="20120903"
--Bind 8   value="SCJUA30AA00523A" 

 ----- Line : 2324 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00523A" 

 ----- Line : 2347 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00523A"
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA30AA00524" 

 ----- Line : 2384 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524"
--Bind 5   value="TZDL"
--Bind 6   value="20120903ANAFI30SH"
--Bind 7   value="20120903"
--Bind 8   value="SCJUA30AA00524" 

 ----- Line : 2427 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00524" 

 ----- Line : 2450 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00524"
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="ANTGEOFRE1234" 

 ----- Line : 2488 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="ANTGEOFRE1234"
--Bind 5   value="TZDL"
--Bind 6   value="20120903ANAFI30SH"
--Bind 7   value="20120903"
--Bind 8   value="ANTGEOFRE1234" 

 ----- Line : 2531 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 2554 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 2574 
 select count(*) from car_spy where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 2596 
 select * from car_spy where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4  order by act_date, act_time, spy_sta  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

>>> END
