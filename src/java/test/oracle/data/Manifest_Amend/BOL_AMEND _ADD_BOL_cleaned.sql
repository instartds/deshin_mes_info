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

 ----- Line : 249 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 262 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 282 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 302 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAC' ;
 

 ----- Line : 311 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 333 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 355 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAo' ;
 

 ----- Line : 362 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 369 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 382 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 395 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 408 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 421 
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

 ----- Line : 602 
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

 ----- Line : 645 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 655 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 686 
 COMMIT ;
 

 ----- Line : 694 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:23:14"
--Bind 9   value="1944" 

 ----- Line : 734 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 762 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 775 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 794 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 817 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 840 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 878 
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

 ----- Line : 921 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 944 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 966 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 979 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1002 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1024 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAE' ;
 

 ----- Line : 1033 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1055 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1077 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAp' ;
 

 ----- Line : 1084 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 1091 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1104 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1117 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1130 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 1143 
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

 ----- Line : 1324 
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

 ----- Line : 1367 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 1398 
 COMMIT ;
 

 ----- Line : 1406 
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

 ----- Line : 1447 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="MSCUA12345667"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 1477 
 COMMIT ;
 

 ----- Line : 1485 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:23:54"
--Bind 9   value="1944" 

 ----- Line : 1525 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120903ANAFI30SH"
--Bind 3   value="20120903"
--Bind 4   value="SCJUA43AA01812" 

 ----- Line : 1553 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=9508179 

 ----- Line : 1566 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903" 

 ----- Line : 1585 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1608 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1631 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5
--Bind 4   value="TZDL"
--Bind 5   value="20120903ANAFI30SH"
--Bind 6   value="20120903"
--Bind 7   value="SCJUA43AA01812" 

 ----- Line : 1669 
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

 ----- Line : 1712 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1735 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812" 

 ----- Line : 1758 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 1771 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1794 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1816 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfWAAC' ;
 

 ----- Line : 1825 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1847 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value=5 

 ----- Line : 1869 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAo' ;
 

 ----- Line : 1879 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgPAAr' ;
 

 ----- Line : 1886 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 1893 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1906 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1919 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="BOL" 

 ----- Line : 1932 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="INMUN" 

 ----- Line : 1945 
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

 ----- Line : 2126 
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

 ----- Line : 2169 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="CAXU6601506"
--Bind 5   value="CY"
--Bind 6   value="70888" 

 ----- Line : 2200 
 COMMIT ;
 

 ----- Line : 2208 
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

 ----- Line : 2249 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="9/3/2012 0:0:0"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="MSCUA12345667"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 2279 
 COMMIT ;
 

 ----- Line : 2287 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120903ANAFI30SH"
--Bind 2   value="20120903"
--Bind 3   value="SCJUA43AA01812"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121204"
--Bind 8   value="12:24:16"
--Bind 9   value="1944" 

>>> END
