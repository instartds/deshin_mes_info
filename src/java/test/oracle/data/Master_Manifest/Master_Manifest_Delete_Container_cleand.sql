 ----- Line : 20 
 select ser_db ,rep_flg into :b0,:b1  from server_state  ;
 

 ----- Line : 26 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

 ----- Line : 40 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

 ----- Line : 49 
 select key_cuo, key_voy_nber, key_dep_date from car_gen where key_cuo = :v0 and car_reg_year = :v1 and car_reg_nber = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="2012"
--Bind 2   value="1118" 

 ----- Line : 66 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 77 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 94 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 113 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 126 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 145 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 164 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 181 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 198 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-194" 

 ----- Line : 218 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634283
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 247 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="MBSA001" 

 ----- Line : 275 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634285 

 ----- Line : 288 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="MBSA001" 

 ----- Line : 316 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634285 

 ----- Line : 329 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 346 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001" 

 ----- Line : 366 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=3 

 ----- Line : 386 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=3
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="MBSA001" 

 ----- Line : 424 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634285 

 ----- Line : 435 
 select count(*)  into :b0  from car_bol_ope where ((((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) and car_ope_typ='ASS') ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001" 

 ----- Line : 455 
 select count(*)  into :b0  from car_bol_res where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001" 

 ----- Line : 478 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001" 

 ----- Line : 498 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001" 

 ----- Line : 522 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 550 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634284 

 ----- Line : 563 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 582 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 604 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 627 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="FXTDAR-195" 

 ----- Line : 665 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195"
--Bind 5   value="TZDL"
--Bind 6   value="20120926MSCNEFELI"
--Bind 7   value="20120626"
--Bind 8   value="FXTDAR-195" 

 ----- Line : 708 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 731 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 754 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 767 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 787 
 select rowid from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 807 
 delete from car_bol_gen where rowid = 'AAA7L2AAFAAADfbAAQ' ;
 

 ----- Line : 816 
 select count(*) from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 838 
 select rowid from car_bol_ctn where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3   for update nowait  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 860 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgRAA0' ;
 

 ----- Line : 870 
 delete from car_bol_ctn where rowid = 'AAA7LwAAFAABVgRAA3' ;
 

 ----- Line : 877 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;
 

 ----- Line : 884 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="MST" 

 ----- Line : 897 
 select trd_ctl from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="MST" 

 ----- Line : 910 
 select rowid from UNTRDTAB where TRD_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="MST" 

 ----- Line : 923 
 select rowid from UNLOCTAB where LOC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="OMSLL" 

 ----- Line : 936 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK"
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195"
--Bind 5   value="2"
--Bind 6   value="0"
--Bind 7   value="0"
--Bind 8
--Bind 9   value="MST"
--Bind 10   value="23"
--Bind 11
--Bind 12   value="MR & MRS JULIUS SHENYAGWA"
--Bind 13   value="84 CHERRYDALE ROAD"
--Bind 14   value="BROUGHTON"
--Bind 15   value="CHESTER CH4 OFG"
--Bind 16
--Bind 17
--Bind 18   value="JULIUS SHENYAGWA"
--Bind 19   value="P.O.BOX 71759"
--Bind 20   value="DAR ES SALAAM"
--Bind 21   value="TANZANIA"
--Bind 22   value="TEL:+255755805822"
--Bind 23
--Bind 24   value="JULIUS SHENYAGWA"
--Bind 25   value="P.O.BOX 71759"
--Bind 26   value="DAR ES SALAAM"
--Bind 27   value="TANZANIA"
--Bind 28   value="TEL:+255755805822"
--Bind 29   value="OMSLL"
--Bind 30   value="TZDAR"
--Bind 31   value="1"
--Bind 32   value="PK"
--Bind 33   value="15"
--Bind 34   value="3000.000"
--Bind 35   value="0"
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
--Bind 46   value="1X40FT (PART)HC CONTAINER STC 1USED"
--Bind 47   value="MITSUBISHI OUTLANDER EQUIPPE MOTOR"
--Bind 48   value="VEHICLE REG NO YG04 UEJ CHASSIS NO:"
--Bind 49   value="JMAXRCU5W4U000547,1JCB  TELEVISION"
--Bind 50   value="&TV STAND,1COMPUTER LAPTOP,2 CD ROM"
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

 ----- Line : 1119 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195"
--Bind 4   value="2"
--Bind 5   value="1"
--Bind 6   value="9753938"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9   value="127677"
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 1161 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 1171 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="6/26/2012 0:0:0"
--Bind 3   value="FXTDAR-195"
--Bind 4   value="9753938"
--Bind 5   value="FUL"
--Bind 6   value="127677" 

 ----- Line : 1202 
 COMMIT ;
 

 ----- Line : 1210 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195"
--Bind 4   value="9"
--Bind 5   value="8"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121205"
--Bind 8   value="07:38:33"
--Bind 9   value="1944" 

 ----- Line : 1254 
 select max(ser_sta) from tab_tab where tab_rep = 1  ;
 

 ----- Line : 1264 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL"
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 1292 
 select * FROM car_bol_ope where car_bol_ser = :v0  for update nowait ;

--Bind 0   value=2634284 

 ----- Line : 1305 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 1324 
 select key_cuo, key_voy_nber, key_dep_date, key_lin_nbr, carbol_sline_nber from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 1347 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2 

 ----- Line : 1370 
 select * from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and key_lin_nbr = :v3  order by carbol_sline_nber  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value=2
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="FXTDAR-195" 

 ----- Line : 1408 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195"
--Bind 5   value="TZDL"
--Bind 6   value="20120926MSCNEFELI"
--Bind 7   value="20120626"
--Bind 8   value="FXTDAR-195" 

 ----- Line : 1451 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

 ----- Line : 1474 
 select * from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 order by car_ctn_nbr ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="FXTDAR-195" 

>>> END
