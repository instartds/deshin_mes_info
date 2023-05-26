 ----- Line : 19 
 select KEY_CUO from TRS_GEN ;
 

 ----- Line : 24 
 select TRS_DEC_DATE from TRS_GEN ;
 

 ----- Line : 29 
 select count(*) from TRS_GEN where  KEY_CUO = :va00  AND TRS_DEC_DATE = :va05  ;

--Bind 0   value="TZDL"
--Bind 1   value="20121205" 

 ----- Line : 44 
 select rowid  ,  KEY_CUO,TRS_DEP_SERIAL,TRS_DEP_NBER,TRS_DEP_DATE from TRS_GEN where  KEY_CUO = :va00  AND TRS_DEC_DATE = :va05  order by  KEY_CUO,TRS_DEP_SERIAL,TRS_DEP_NBER,TRS_DEP_DATE ;

--Bind 0   value="TZDL"
--Bind 1   value="20121205" 

 ----- Line : 59 
 select KEY_CUO, TRS_CUODEST_COD, TRS_STATUS, KEY_DEC, KEY_YEAR, KEY_NBER, TRS_DEP_SERIAL, TRS_DEP_NBER, TRS_DEP_DATE, TRS_ARR_SERIAL, TRS_ARR_NBER, TRS_ARR_DATE, TRS_VOY_NBER, TRS_EXPORTER, TRS_CONSIGNEE, TRS_PRV_CUO_COD, TRS_TRANSIT_PLACE from TRS_GEN where rowid = :va00 ;

--Bind 0   value="AAA7QVAAFAAHuimAAR" 

 ----- Line : 70 
 select rowid from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 91 
 select rowid from trs_occ_exp where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 112 
 select rowid from trs_occ_cns where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 132 
 select count(*) from trs_itm where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 152 
 select * from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 174 
 select * from trs_occ_exp where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 196 
 select * from trs_occ_cns where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 216 
 select * from trs_itm where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and itm_nber = :v4 ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606"
--Bind 4   value=1 

 ----- Line : 241 
 select count(*) from trs_iti where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 263 
 select count(*) from trs_drv where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 284 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 297 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 308 
 insert into trs_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66,:v67,:v68,:v69,:v70,:v71) ;
 

 ----- Line : 315 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 328 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 341 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="CD" 

 ----- Line : 354 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 367 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="3" 

 ----- Line : 380 
 select mot_cod from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="3" 

 ----- Line : 396 
 select rowid from UNPRPTAB where CMP_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 409 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZTM" 

 ----- Line : 420 
 insert into trs_occ_exp values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;
 

 ----- Line : 425 
 insert into trs_occ_cns values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;
 

 ----- Line : 430 
 insert into trs_itm values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33) ;
 

 ----- Line : 435 
 select hs6_cod ,tar_pr1 into :b0,:b1  from untartab where (hs6_cod=:b2 and tar_pr1=:b3) ;

--Bind 0   value="630900"
--Bind 1   value="00" 

 ----- Line : 451 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK" 

 ----- Line : 465 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 478 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 491 
 select count(*) from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012" 

 ----- Line : 513 
 select count(*) from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012" 

 ----- Line : 534 
 select app_ser.*, app_ser.rowid from app_ser where app_year = :v0 and app_serial = :v1 and app_cuo = :v2  for update ;

--Bind 0   value="2012"
--Bind 1   value="D"
--Bind 2   value="TZDL" 

 ----- Line : 551 
 update app_ser set APP_YEAR='2012' , APP_CUO='TZDL', APP_SERIAL='D', APP_NBER='116420' where rowid = 'AAA7LgAAEAAAB5xABM' ;
 

 ----- Line : 558 
 insert into trs_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66,:v67,:v68,:v69,:v70,:v71) ;
 

 ----- Line : 565 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 578 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 591 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="CD" 

 ----- Line : 604 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 617 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="3" 

 ----- Line : 630 
 select mot_cod from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="3" 

 ----- Line : 646 
 select rowid from UNPRPTAB where CMP_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 659 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="2012"
--Bind 2   value="TZDL"
--Bind 3   value="100252155"
--Bind 4   value="KK012"
--Bind 5
--Bind 6
--Bind 7
--Bind 8   value="T1"
--Bind 9
--Bind 10
--Bind 11
--Bind 12
--Bind 13
--Bind 14
--Bind 15   value="1"
--Bind 16   value="341"
--Bind 17
--Bind 18   value="US"
--Bind 19   value="CD"
--Bind 20   value="T215ABQ/T235ABQ"
--Bind 21
--Bind 22   value="1"
--Bind 23   value="SAFMARINE CAMEROUN VOY:1203"
--Bind 24   value="US"
--Bind 25   value="3"
--Bind 26   value="TZDAR"
--Bind 27   value="Dar es Salaam"
--Bind 28   value="100252155"
--Bind 29   value="K & K CARGO SERVICES(T) LTD."
--Bind 30
--Bind 31   value="P.O.Box 70205   DAR ES SALAAM"
--Bind 32   value="TRANSIT"
--Bind 33
--Bind 34   value="252155T2"
--Bind 35   value="20121205"
--Bind 36   value="TEST"
--Bind 37
--Bind 38
--Bind 39   value="TZTM"
--Bind 40   value="TMU"
--Bind 41   value="DAR ES SALAAM LONG ROOM"
--Bind 42   value="20121205"
--Bind 43   value="236"
--Bind 44   value="DSA"
--Bind 45
--Bind 46   value="20121212"
--Bind 47   value="STUDENT01"
--Bind 48   value="TEST"
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
--Bind 60
--Bind 61
--Bind 62
--Bind 63
--Bind 64   value="STUDENT01"
--Bind 65
--Bind 66
--Bind 67
--Bind 68
--Bind 69
--Bind 70
--Bind 71   value="R"
--Bind 72 

 ----- Line : 850 
 insert into trs_occ_exp values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012"
--Bind 4   value="CALTEX TRADERS LLC"
--Bind 5   value="580 CENTRAL AVE"
--Bind 6   value="RIVERSIDE"
--Bind 7   value="USA"
--Bind 8 

 ----- Line : 883 
 insert into trs_occ_cns values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012"
--Bind 4   value="ETS INTRACO"
--Bind 5   value="LUBUMBASHI"
--Bind 6   value="D.R.C"
--Bind 7
--Bind 8 

 ----- Line : 915 
 insert into trs_itm values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33) ;
 

 ----- Line : 921 
 select hs6_cod ,tar_pr1 into :b0,:b1  from untartab where (hs6_cod=:b2 and tar_pr1=:b3) ;

--Bind 0   value="630900"
--Bind 1   value="00" 

 ----- Line : 937 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK"
--Bind 1   value="2012"
--Bind 2   value="TZDL"
--Bind 3   value="100252155"
--Bind 4   value="KK012"
--Bind 5   value="1"
--Bind 6   value="1X40' FCL"
--Bind 7
--Bind 8   value="63090000"
--Bind 9   value="Worn clothing and other worn articles."
--Bind 10
--Bind 11   value="USED SHOES"
--Bind 12   value="341"
--Bind 13   value="PK"
--Bind 14   value="7000.000"
--Bind 15   value="7000.000"
--Bind 16   value="IM1/2012-T-5187"
--Bind 17   value="FCL-TCKU965762-0"
--Bind 18
--Bind 19
--Bind 20
--Bind 21
--Bind 22
--Bind 23
--Bind 24
--Bind 25
--Bind 26
--Bind 27
--Bind 28
--Bind 29
--Bind 30
--Bind 31
--Bind 32
--Bind 33
--Bind 34 

 ----- Line : 1033 
 select  trs_dec_date, trs_dep_serial, trs_dep_nber, trs_dep_date, trs_dep_year, trs_dep_time, rowid from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   for update nowait ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012" 

 ----- Line : 1053 
 update trs_gen set TRS_DEC_DATE = :v0 , TRS_DEP_SERIAL = :v1 , TRS_DEP_NBER = :v2 , TRS_DEP_DATE = :v3 , TRS_DEP_YEAR = :v4 , TRS_DEP_TIME = :v5 where rowid = 'AAA7QVAAFAAHuimAAP' ;

--Bind 0   value="20121205"
--Bind 1   value="D"
--Bind 2   value="116420"
--Bind 3   value="20121205"
--Bind 4   value="2012"
--Bind 5   value="16:36:27" 

 ----- Line : 1081 
 select count(*) from trs_iti where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012" 

 ----- Line : 1101 
 insert into trs_iti values (:v0,:v1,:v2,:v3,:v4) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012"
--Bind 4   value="TZMU" 

 ----- Line : 1126 
 select count(*) from trs_drv where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012" 

 ----- Line : 1146 
 insert into trs_drv values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="KK012"
--Bind 4   value="MANGI"
--Bind 5   value="ANTONY"
--Bind 6   value="AB1327145"
--Bind 7   value="TZ"
--Bind 8   value="AE1020123333"
--Bind 9   value="TZ"
--Bind 10   value="T215ABQ"
--Bind 11   value="T235ABQ"
--Bind 12   value="TZ"
--Bind 13   value="CONTAINER SEALED WITH SEAL#1236544"
--Bind 14 

 ----- Line : 1199 
 select o.owner#,o.name,o.namespace,o.remoteowner,o.linkname,o.subname,o.dataobj#,o.flags from obj$ o where o.obj#=:1 ;

--Bind 0   value=7519 

 ----- Line : 1214 
 select app_ser.*, app_ser.rowid from app_ser where app_year = :v0 and app_serial = :v1  for update ;

--Bind 0   value="2012"
--Bind 1   value="A" 

 ----- Line : 1230 
 update app_ser set APP_YEAR='2012' , APP_CUO='', APP_SERIAL='A', APP_NBER='45870' where rowid = 'AAA7LgAAEAAAB5xAAo' ;
 

 ----- Line : 1238 
 insert into gtw_tab values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24) ;

--Bind 0   value="45870"
--Bind 1   value="STUDENT01"
--Bind 2   value="T1 Transit document"
--Bind 3   value="../tmp/GATEX4uU0c"
--Bind 4   value="0"
--Bind 5
--Bind 6
--Bind 7
--Bind 8
--Bind 9
--Bind 10   value="TZDL ../diam/DPUt1 "2012" "TZDL" "100252155" "KK012""
--Bind 11   value="T1"
--Bind 12   value="0"
--Bind 13   value="0"
--Bind 14   value="1"
--Bind 15   value="TZTM"
--Bind 16
--Bind 17
--Bind 18
--Bind 19
--Bind 20
--Bind 21
--Bind 22
--Bind 23
--Bind 24   value="P" 

>>> END
