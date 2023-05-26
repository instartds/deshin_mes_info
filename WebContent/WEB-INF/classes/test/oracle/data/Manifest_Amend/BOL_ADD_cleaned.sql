 ----- Line : 19 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1114" 

 ----- Line : 36 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 47 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 64 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 83 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 96 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 115 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 134 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 151 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 168 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA30AA00514" 

 ----- Line : 188 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 217 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 245 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 274 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 302 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 331 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 359 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 388 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 416 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 445 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 473 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 502 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 530 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 559 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 587 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 616 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 644 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 673 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 701 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 730 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 758 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 787 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 815 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 830 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 843 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 862 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 875 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 895 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 914 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 933 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 946 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 965 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 984 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1004 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="TZDL"
--Bind 4   value="20120903ANAFI30SH"
--Bind 5   value="20120903"
--Bind 6   value="SCJUA30AA00514" 

 ----- Line : 1038 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 1067 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 1095 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 1124 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 1152 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 1181 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 1209 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 1238 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 1266 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 1295 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 1323 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 1352 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 1380 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 1409 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 1437 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 1466 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 1494 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 1523 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 1551 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 1580 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 1608 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 1637 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 1665 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 1678 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1691 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1711 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1730 
 select count(*) from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3 

 ----- Line : 1751 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3 

 ----- Line : 1770 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="24"
--Bind 5   value="0"
--Bind 6   value="4"
--Bind 7
--Bind 8   value="BOL"
--Bind 9   value="23"
--Bind 10
--Bind 11   value="CGVSDVGHCSDFCGYSDCSDchjzcsC"
--Bind 12   value="CDSSDGACVGH"
--Bind 13
--Bind 14
--Bind 15
--Bind 16
--Bind 17   value="V.A SHAH"
--Bind 18   value="DSM"
--Bind 19
--Bind 20
--Bind 21
--Bind 22
--Bind 23   value="ANA"
--Bind 24
--Bind 25
--Bind 26
--Bind 27
--Bind 28   value="ADLMA"
--Bind 29   value="TZDAR"
--Bind 30   value="2"
--Bind 31   value="PK"
--Bind 32   value="20"
--Bind 33   value="125600.000"
--Bind 34
--Bind 35
--Bind 36
--Bind 37
--Bind 38
--Bind 39
--Bind 40
--Bind 41
--Bind 42
--Bind 43
--Bind 44
--Bind 45   value="MACHINERY"
--Bind 46
--Bind 47
--Bind 48
--Bind 49
--Bind 50
--Bind 51
--Bind 52
--Bind 53
--Bind 54
--Bind 55
--Bind 56
--Bind 57
--Bind 58
--Bind 59   value="0"
--Bind 60
--Bind 61
--Bind 62
--Bind 63
--Bind 64
--Bind 65
--Bind 66 

 ----- Line : 1935 
 select count(*) from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="ANTGEOFRE1234" 

 ----- Line : 1970 
 insert into car_bol_ope values (  :VA0,  :VA1,  :VA2,  :VA3,  :VA4,  :VA5,  :VA6,  :VA7,  :VA8,  :VA9,  :VA10,  :VA11,  :VA12,  :VA13,  :VA14,  :VA15,  :VA16,  :VA17,  :VA18,  :VA19,  :VA20,  :VA21,  :VA22,  :VA23,  :VA24,  :VA25,  :VA26,  :VA27,  :VA28, car_bol_ser.NEXTVAL) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="24"
--Bind 5   value="20.000000"
--Bind 6   value="125600.000000"
--Bind 7
--Bind 8
--Bind 9
--Bind 10
--Bind 11
--Bind 12
--Bind 13
--Bind 14   value="STO"
--Bind 15   value="20121204"
--Bind 16   value="12:08:42"
--Bind 17   value="1"
--Bind 18   value="0.000000"
--Bind 19   value="20.000000"
--Bind 20   value="0.000000"
--Bind 21   value="125600.000000"
--Bind 22
--Bind 23
--Bind 24
--Bind 25   value="0"
--Bind 26   value="0"
--Bind 27
--Bind 28   value="STUDENT01" 

 ----- Line : 2053 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="24"
--Bind 5   value="1"
--Bind 6   value="MSCU12356498"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 2094 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 2104 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="MSCU12356498"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 2134 
 COMMIT ;
 

 ----- Line : 2142 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="24"
--Bind 5   value="2"
--Bind 6   value="MSCUC9865744"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 2183 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="MSCUC9865744"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 2213 
 COMMIT ;
 

 ----- Line : 2221 
 select car_bl_nber,car_pac_nber, car_gros_mass, car_cntr_nbr ,rowid from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2238 
 update car_gen set CAR_BL_NBER = :v0 , CAR_PAC_NBER = :v1 , CAR_GROS_MASS = :v2 , CAR_CNTR_NBR = :v3 where rowid = 'AAA7MGAAFAAAMPuAAJ' ;

--Bind 0   value="24"
--Bind 1   value="32120"
--Bind 2   value="1166361.480"
--Bind 3   value="65" 

 ----- Line : 2258 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="5"
--Bind 5   value="5"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:08:42"
--Bind 9   value="1912" 

>>> END
