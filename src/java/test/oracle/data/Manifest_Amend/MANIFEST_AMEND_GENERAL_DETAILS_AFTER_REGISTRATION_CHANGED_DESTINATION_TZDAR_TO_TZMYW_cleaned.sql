 ----- Line : 19 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 30 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 50 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 61 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 78 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 98 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 118 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 156 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179 

 ----- Line : 167 
 select count(*)  into :b0  from car_bol_ope where ((((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) and car_ope_typ='ASS') ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 187 
 select count(*)  into :b0  from car_bol_res where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 207 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 227 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 252 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 280 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 293 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 312 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 334 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 357 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 395 
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

 ----- Line : 438 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 461 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 484 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 497 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 517 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 537 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAE' ;
 

 ----- Line : 546 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 568 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 590 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAp' ;
 

 ----- Line : 600 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAs' ;
 

 ----- Line : 607 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 614 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 627 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 640 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 653 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 666 
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

 ----- Line : 847 
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

 ----- Line : 890 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 900 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 931 
 COMMIT ;
 

 ----- Line : 939 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="5"
--Bind 5   value="2"
--Bind 6   value="MSCUA12345667"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 980 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="MSCUA12345667"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 1010 
 COMMIT ;
 

 ----- Line : 1018 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:32:24"
--Bind 9   value="1944" 

 ----- Line : 1059 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1072 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1092 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1114" 

 ----- Line : 1111 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1124 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1141 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1160 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1173 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1192 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1211 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1228 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="TZDL"
--Bind 4   value="20120903ANAFI30SH"
--Bind 5   value="20120903"
--Bind 6   value="ANTGEOFRE1234" 

 ----- Line : 1262 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00514" 

 ----- Line : 1291 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 1319 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 1348 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 1376 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 1405 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 1433 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 1462 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 1490 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 1519 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 1547 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 1576 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 1604 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 1633 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 1661 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 1690 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 1718 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 1747 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 1775 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 1804 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 1832 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 1861 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 1889 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 1918 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 1931 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1942 
 insert into car_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35) ;
 

 ----- Line : 1949 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="ADLMA" 

 ----- Line : 1962 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZMYW" 

 ----- Line : 1975 
 select rowid from UNCARTAB where CAR_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="SHA" 

 ----- Line : 1986 
 select o.owner#,o.name,o.namespace,o.remoteowner,o.linkname,o.subname,o.dataobj#,o.flags from obj$ o where o.obj#=:1 ;

--Bind 0   value=5985 

 ----- Line : 2001 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="1" 

 ----- Line : 2014 
 select rowid from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="1" 

 ----- Line : 2030 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="MH" 

 ----- Line : 2043 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 2057 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2074 
 select rowid from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2091 
 delete from car_gen where rowid = 'AAA7MGAAFAAAMPuAAJ'  ;
 

 ----- Line : 2099 
 insert into car_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35) ;
 

 ----- Line : 2106 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="ADLMA" 

 ----- Line : 2119 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZMYW" 

 ----- Line : 2132 
 select rowid from UNCARTAB where CAR_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="SHA" 

 ----- Line : 2145 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="1" 

 ----- Line : 2158 
 select rowid from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="1" 

 ----- Line : 2174 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="MH"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="20120903"
--Bind 5   value="12:09"
--Bind 6   value="2012"
--Bind 7   value="1114"
--Bind 8   value="20120903"
--Bind 9   value="11:14"
--Bind 10   value="ADLMA"
--Bind 11   value="TZMYW"
--Bind 12   value="SHA"
--Bind 13   value="Sharaf shipping agencies"
--Bind 14   value="dsm,"
--Bind 15
--Bind 16
--Bind 17
--Bind 18   value="1"
--Bind 19   value="MSC ANAFI 1230A"
--Bind 20   value="MH"
--Bind 21   value="MH"
--Bind 22
--Bind 23
--Bind 24
--Bind 25
--Bind 26
--Bind 27   value="1026"
--Bind 28   value="1026"
--Bind 29   value="24"
--Bind 30   value="32120"
--Bind 31   value="1166361.480"
--Bind 32   value="65"
--Bind 33
--Bind 34
--Bind 35
--Bind 36 

 ----- Line : 2283 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3
--Bind 4   value="3"
--Bind 5   value="3"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:34:24"
--Bind 9   value="1984" 

 ----- Line : 2322 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1114" 

 ----- Line : 2341 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 2354 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2374 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2393 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 2406 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2425 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2444 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 2464 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="TZDL"
--Bind 4   value="20120903ANAFI30SH"
--Bind 5   value="20120903"
--Bind 6   value="ANTGEOFRE1234" 

 ----- Line : 2498 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634128
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00514" 

 ----- Line : 2527 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508175
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523A" 

 ----- Line : 2555 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634125
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00524" 

 ----- Line : 2584 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634126
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13662" 

 ----- Line : 2612 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508176
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13917" 

 ----- Line : 2641 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9510444
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01770" 

 ----- Line : 2669 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508178
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 2698 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508179
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01813" 

 ----- Line : 2726 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508180
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01817" 

 ----- Line : 2755 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508181
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01867" 

 ----- Line : 2783 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509160
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01872" 

 ----- Line : 2812 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508183
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01884" 

 ----- Line : 2840 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508184
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00522" 

 ----- Line : 2869 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508185
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00523" 

 ----- Line : 2897 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508186
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01951" 

 ----- Line : 2926 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509986
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01952" 

 ----- Line : 2954 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9509387
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01957" 

 ----- Line : 2983 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508189
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA30AA00535" 

 ----- Line : 3011 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508190
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14568" 

 ----- Line : 3040 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508191
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13799" 

 ----- Line : 3068 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508192
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01885" 

 ----- Line : 3097 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508193
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA13537" 

 ----- Line : 3125 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508194
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA39AA14792" 

 ----- Line : 3154 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=9508195 

 ----- Line : 3167 
 select ser_db ,rep_flg into :b0,:b1  from server_state  ;
 

 ----- Line : 3173 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

 ----- Line : 3187 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

>>> END
