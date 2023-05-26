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
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="ANTGEOFRE1234" 

 ----- Line : 844 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128 

 ----- Line : 857 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="ANTGEOFRE1234" 

 ----- Line : 885 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634128 

 ----- Line : 898 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 915 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 935 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24 

 ----- Line : 955 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="ANTGEOFRE1234" 

 ----- Line : 993 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128 

 ----- Line : 1004 
 select count(*)  into :b0  from car_bol_ope where ((((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) and car_ope_typ='ASS') ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1024 
 select count(*)  into :b0  from car_bol_res where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1047 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1067 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1089 
 select count(*) from car_spy where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1111 
 select * from car_spy where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4  order by act_date, act_time, spy_sta  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1132 
 select count(*) from car_bol_ope where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_bol_ref = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1152 
 select * from car_bol_ope where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_bol_ser ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234" 

 ----- Line : 1174 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1187 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24 

 ----- Line : 1207 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24 

 ----- Line : 1227 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAC' ;
 

 ----- Line : 1236 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24 

 ----- Line : 1258 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=24 

 ----- Line : 1280 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAo' ;
 

 ----- Line : 1290 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAp' ;
 

 ----- Line : 1297 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 1304 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1317 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1330 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1343 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="ADLMA" 

 ----- Line : 1356 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="ANTGEOFRE1234"
--Bind 5   value="1"
--Bind 6   value="0"
--Bind 7   value="4"
--Bind 8
--Bind 9   value="BOL"
--Bind 10   value="23"
--Bind 11
--Bind 12   value="CGVSDVGHCSDFCGYSDCSDchjzcsC"
--Bind 13   value="CDSSDGACVGH"
--Bind 14
--Bind 15
--Bind 16
--Bind 17
--Bind 18   value="V.A SHAH"
--Bind 19   value="DSM"
--Bind 20
--Bind 21
--Bind 22
--Bind 23
--Bind 24   value="ANA"
--Bind 25
--Bind 26
--Bind 27
--Bind 28
--Bind 29   value="ADLMA"
--Bind 30   value="TZDAR"
--Bind 31   value="2"
--Bind 32   value="PK"
--Bind 33   value="20"
--Bind 34   value="125600.000"
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
--Bind 45
--Bind 46   value="MACHINERY"
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
--Bind 59
--Bind 60   value="0"
--Bind 61
--Bind 62
--Bind 63
--Bind 64
--Bind 65
--Bind 66
--Bind 67 

 ----- Line : 1525 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="1"
--Bind 5   value="1"
--Bind 6   value="MSCU56489742"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 1566 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 1576 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="MSCU56489742"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 1606 
 COMMIT ;
 

 ----- Line : 1614 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="ANTGEOFRE1234"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:17:10"
--Bind 9   value="1944" 

 ----- Line : 1654 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 1682 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 1695 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1714 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1737 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1760 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 1798 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812"
--Bind 5   value="TZDL"
--Bind 6   value="20120903ANAFI30SH"
--Bind 7   value="20120903"
--Bind 8   value="SCJUA43AA01812" 

 ----- Line : 1841 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1864 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1887 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1900 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1923 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1945 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADceAAB' ;
 

 ----- Line : 1954 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1976 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1998 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgBAAF' ;
 

 ----- Line : 2008 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgBAAG' ;
 

 ----- Line : 2015 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 2022 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2035 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2048 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2061 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 2074 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BG"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812"
--Bind 5   value="5"
--Bind 6   value="0"
--Bind 7   value="4"
--Bind 8
--Bind 9   value="BOL"
--Bind 10   value="23"
--Bind 11
--Bind 12   value="Reliance Industries Ltd"
--Bind 13   value="(UNIT OF RELIANCE JAMNAGAR SEZ)"
--Bind 14   value="POLYMER EXPORT DIVISION, FORTUNE 20"
--Bind 15   value="G BLOCK, BKC, BANDRA (E) MUMBAI - 4"
--Bind 16
--Bind 17
--Bind 18   value="QUALITY PLASTIC LIMITED"
--Bind 19   value="P.O.BOX 21129,"
--Bind 20   value="DAR ES-SALAAM, TANZANIA."
--Bind 21
--Bind 22
--Bind 23
--Bind 24   value="SAME AS CONSIGNEE"
--Bind 25
--Bind 26
--Bind 27
--Bind 28
--Bind 29   value="INMUN"
--Bind 30   value="TZDAR"
--Bind 31   value="2"
--Bind 32   value="BG"
--Bind 33   value="1280"
--Bind 34   value="32160.000"
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
--Bind 45
--Bind 46   value="02X20 FCL/FCL:1280 BAG 32 MTS"
--Bind 47   value="POLYPROPYLENE (HOMOPOLYMER) GRADE"
--Bind 48   value="H200MA COUNTRY OF ORIGIN - INDIA"
--Bind 49   value="H.S.CODE: 3902.10.00 TOTAL GROSS"
--Bind 50   value="WEIGHT:32.160 MTS TOTAL NET"
--Bind 51   value="CY"
--Bind 52
--Bind 53
--Bind 54   value="0"
--Bind 55
--Bind 56
--Bind 57
--Bind 58
--Bind 59
--Bind 60   value="0"
--Bind 61   value="1"
--Bind 62   value="NA"
--Bind 63
--Bind 64
--Bind 65   value="NA"
--Bind 66
--Bind 67 

 ----- Line : 2255 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="5"
--Bind 5   value="2"
--Bind 6   value="CAXU6601506"
--Bind 7   value="20GP"
--Bind 8   value="CY"
--Bind 9   value="70888"
--Bind 10
--Bind 11
--Bind 12   value="CU" 

 ----- Line : 2298 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 2329 
 COMMIT ;
 

 ----- Line : 2337 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:18:19"
--Bind 9   value="1944" 

 ----- Line : 2377 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 2405 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 2418 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2437 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 2460 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 2483 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 2521 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812"
--Bind 5   value="TZDL"
--Bind 6   value="20120903ANAFI30SH"
--Bind 7   value="20120903"
--Bind 8   value="SCJUA43AA01812" 

 ----- Line : 2564 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 2587 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 2609 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 2622 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 2645 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 2667 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAE' ;
 

 ----- Line : 2676 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 2698 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 2720 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAr' ;
 

 ----- Line : 2727 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 2734 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2747 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2760 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 2773 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 2786 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BG"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812"
--Bind 5   value="5"
--Bind 6   value="0"
--Bind 7   value="4"
--Bind 8
--Bind 9   value="BOL"
--Bind 10   value="23"
--Bind 11
--Bind 12   value="Reliance Industries Ltd"
--Bind 13   value="(UNIT OF RELIANCE JAMNAGAR SEZ)"
--Bind 14   value="POLYMER EXPORT DIVISION, FORTUNE 20"
--Bind 15   value="G BLOCK, BKC, BANDRA (E) MUMBAI - 4"
--Bind 16
--Bind 17
--Bind 18   value="QUALITY PLASTIC LIMITED"
--Bind 19   value="P.O.BOX 21129,"
--Bind 20   value="DAR ES-SALAAM, TANZANIA."
--Bind 21
--Bind 22
--Bind 23
--Bind 24   value="SAME AS CONSIGNEE"
--Bind 25
--Bind 26
--Bind 27
--Bind 28
--Bind 29   value="INMUN"
--Bind 30   value="TZDAR"
--Bind 31   value="2"
--Bind 32   value="BG"
--Bind 33   value="1280"
--Bind 34   value="32160.000"
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
--Bind 45
--Bind 46   value="02X20 FCL/FCL:1280 BAG 32 MTS"
--Bind 47   value="POLYPROPYLENE (HOMOPOLYMER) GRADE"
--Bind 48   value="H200MA COUNTRY OF ORIGIN - INDIA"
--Bind 49   value="H.S.CODE: 3902.10.00 TOTAL GROSS"
--Bind 50   value="WEIGHT:32.160 MTS TOTAL NET"
--Bind 51   value="CY"
--Bind 52
--Bind 53
--Bind 54   value="0"
--Bind 55
--Bind 56
--Bind 57
--Bind 58
--Bind 59
--Bind 60   value="0"
--Bind 61   value="1"
--Bind 62   value="NA"
--Bind 63
--Bind 64
--Bind 65   value="NA"
--Bind 66
--Bind 67 

 ----- Line : 2967 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="5"
--Bind 5   value="2"
--Bind 6   value="CAXU6601506"
--Bind 7   value="20GP"
--Bind 8   value="CY"
--Bind 9   value="70888"
--Bind 10
--Bind 11
--Bind 12   value="CU" 

 ----- Line : 3010 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 3041 
 COMMIT ;
 

 ----- Line : 3049 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:18:33"
--Bind 9   value="1944" 

>>> END
