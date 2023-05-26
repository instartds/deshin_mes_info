 ----- Line : 19 
 select KEY_CUO from SAD_GEN ;
 

 ----- Line : 24 
 select SAD_FLW from SAD_GEN ;
 

 ----- Line : 29 
 select SAD_TYP_PROC from SAD_GEN ;
 

 ----- Line : 34 
 select KEY_DEC from SAD_GEN ;
 

 ----- Line : 39 
 select SAD_TYP_TRANSIT from SAD_GEN ;
 

 ----- Line : 44 
 select SAD_REG_DATE from SAD_GEN ;
 

 ----- Line : 49 
 select SAD_STA from SAD_GEN ;
 

 ----- Line : 54 
 select LST_OPE from SAD_GEN ;
 

 ----- Line : 59 
 select SAD_NUM from SAD_GEN ;
 

 ----- Line : 64 
 select count(*) from SAD_GEN where  KEY_CUO = :va00  AND SAD_FLW = :va01  AND SAD_TYP_PROC = :va02  AND KEY_DEC = :va03  AND  SAD_TYP_TRANSIT is null  AND SAD_REG_DATE >= :va08 and SAD_REG_DATE <= :vb08  AND SAD_STA = :va09  AND LST_OPE = :va10  AND SAD_NUM = :va11  ;

--Bind 0   value="TZDL"
--Bind 1   value="1"
--Bind 2   value="8"
--Bind 3   value="100252155"
--Bind 4   value="20120101"
--Bind 5   value="20120331"
--Bind 6   value="A"
--Bind 7   value="U"
--Bind 8   value="0" 

 ----- Line : 100 
 select rowid  ,  KEY_CUO,SAD_REG_YEAR,SAD_REG_SERIAL,SAD_REG_NBER from SAD_GEN where  KEY_CUO = :va00  AND SAD_FLW = :va01  AND SAD_TYP_PROC = :va02  AND KEY_DEC = :va03  AND  SAD_TYP_TRANSIT is null  AND SAD_REG_DATE >= :va08 and SAD_REG_DATE <= :vb08  AND SAD_STA = :va09  AND LST_OPE = :va10  AND SAD_NUM = :va11  order by  KEY_CUO,SAD_REG_YEAR,SAD_REG_SERIAL,SAD_REG_NBER ;

--Bind 0   value="TZDL"
--Bind 1   value="1"
--Bind 2   value="8"
--Bind 3   value="100252155"
--Bind 4   value="20120101"
--Bind 5   value="20120331"
--Bind 6   value="A"
--Bind 7   value="U"
--Bind 8   value="0" 

 ----- Line : 136 
 select KEY_CUO, KEY_DEC, KEY_YEAR, KEY_NBER, SAD_TYP_DEC, SAD_TYP_PROC, SAD_ITM_TOTAL, SAD_CONSIGNEE, SAD_EXPORTER, SAD_REG_SERIAL, SAD_REG_NBER, SAD_REG_DATE, SAD_TOTAL_TAXES, SAD_GRTY_AMOUNT, SAD_ASMT_SERIAL, SAD_ASMT_NBER, SAD_ASMT_DATE, SAD_RCPT_SERIAL, SAD_RCPT_NBER from SAD_GEN where rowid = :va00 ;

--Bind 0   value="AAA7FgAAFAADQ1uAAG" 

 ----- Line : 147 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 160 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 171 
 select key_year, key_cuo, key_dec, key_nber,sad_reg_serial, sad_reg_nber, sad_reg_date, sad_reg_year ,sad_asmt_serial, sad_asmt_nber, sad_asmt_date, sad_asmt_year,sad_rcpt_serial, sad_rcpt_nber, sad_rcpt_date, lst_ope , sad_sta  from sad_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and sad_num = 0  for update nowait ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 191 
 select count(*)  into :b0  from sad_gen where (((((key_year=:b1 and key_dec=:b2) and key_cuo=:b3) and key_nber=:b4) and sad_typ_transit='1') and sad_num=0) ;

--Bind 0   value="2012"
--Bind 1   value="100252155"
--Bind 2   value="TZDL"
--Bind 3   value="822606" 

 ----- Line : 211 
 select rowid from sad_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 232 
 select rowid from sad_gen_vim where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 253 
 select rowid from sad_gen_vex where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 274 
 select rowid from sad_occ_exp where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 295 
 select rowid from sad_occ_cns where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 316 
 select rowid from sad_occ_fin where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 337 
 select rowid from sad_occ_dec where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 357 
 select count(*) from sad_trr where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 379 
 select count(*) from sad_itm where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 400 
 select rowid from sad_tax where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 421 
 select rowid from sad_itm_vim where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 442 
 select rowid from sad_itm_vex where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 462 
 select * from sad_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 484 
 select * from sad_occ_exp where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 506 
 select * from sad_occ_cns where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 528 
 select * from sad_itm where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and itm_nber = :v4 and sad_num = 0  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606"
--Bind 4   value=1 

 ----- Line : 552 
 select rowid from sad_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   and sad_num = 0  for update nowait ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 573 
 select CRE_COD,EEA_DOV from UNCRETAB where CRE_COD = :va00  and  EEA_DOV <= :d0 and (EEA_EOV is null or EEA_EOV >= :d1) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 592 
 select CRE_COD,EEA_DOV from UNCRETAB where CRE_COD = :va00  and  EEA_DOV <= :d0 and (EEA_EOV is null or EEA_EOV >= :d1) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 611 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 624 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 635 
 insert into trs_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66,:v67,:v68,:v69,:v70,:v71) ;
 

 ----- Line : 642 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 655 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 668 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="CD" 

 ----- Line : 681 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 694 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="3" 

 ----- Line : 707 
 select mot_cod from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="3" 

 ----- Line : 723 
 select rowid from UNPRPTAB where CMP_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 736 
 select cmp_cod from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 747 
 select cre_tot from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 766 
 select cre_del from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 785 
 select cre_sta from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 802 
 select max(gty_ser) into :b0  from csh_gty_mvt where cre_cod=:b1 ;

--Bind 0   value="252155T2" 

 ----- Line : 813 
 select * FROM csh_gty_mvt where gty_ser = :v0 ;

--Bind 0   value=1268819 

 ----- Line : 826 
 select cmp_cod from UNCRETAB where CRE_COD = :v0  and  EEA_DOV <= :d0 and (EEA_EOV is null or EEA_EOV >= :d1) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 845 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZTM" 

 ----- Line : 856 
 insert into trs_occ_exp values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;
 

 ----- Line : 861 
 insert into trs_occ_cns values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;
 

 ----- Line : 866 
 insert into trs_itm values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33) ;
 

 ----- Line : 873 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK" 

 ----- Line : 884 
 select cre_tot from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) for update ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205"
--Bind 3   value="252155T2" 

 ----- Line : 908 
 select * FROM csh_gty_mvt where gty_ser = :v0 ;

--Bind 0   value=1268819 

 ----- Line : 919 
 insert into csh_gty_mvt values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17) ;
 

 ----- Line : 924 
 insert into csh_gty_mvt values ( '252155T2','5','TRE','20121205','15:42:24','10598297.900000','0.000000','-14891633612.900000','5104','','','','','','','','',gty_ser.NEXTVAL) ;
 

 ----- Line : 934 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 947 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 960 
 select count(*) from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3  ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 981 
 select app_ser.*, app_ser.rowid from app_ser where app_year = :v0 and app_serial = :v1 and app_cuo = :v2  for update ;

--Bind 0   value="2012"
--Bind 1   value="D"
--Bind 2   value="TZDL" 

 ----- Line : 998 
 update app_ser set APP_YEAR='2012' , APP_CUO='TZDL', APP_SERIAL='D', APP_NBER='116419' where rowid = 'AAA7LgAAEAAAB5xABM' ;
 

 ----- Line : 1005 
 insert into trs_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66,:v67,:v68,:v69,:v70,:v71) ;
 

 ----- Line : 1012 
 select rowid from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 1025 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 1038 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="CD" 

 ----- Line : 1051 
 select rowid from UNCTYTAB where CTY_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="US" 

 ----- Line : 1064 
 select rowid from UNMOTTAB where MOT_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="3" 

 ----- Line : 1077 
 select mot_cod from UNCUOMOT where CUO_COD = :v0  and MOT_COD = :v1 and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="3" 

 ----- Line : 1093 
 select rowid from UNPRPTAB where CMP_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 1106 
 select cmp_cod from UNDECTAB where DEC_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="100252155" 

 ----- Line : 1119 
 select cre_tot from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 1138 
 select cre_del from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 1157 
 select cre_sta from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205"
--Bind 3   value="252155T2" 

 ----- Line : 1181 
 select * FROM csh_gty_mvt where gty_ser = :v0 ;

--Bind 0   value=1268819 

 ----- Line : 1194 
 select cmp_cod from UNCRETAB where CRE_COD = :v0  and  EEA_DOV <= :d0 and (EEA_EOV is null or EEA_EOV >= :d1) ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205" 

 ----- Line : 1213 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZTM"
--Bind 1   value="2012"
--Bind 2   value="TZDL"
--Bind 3   value="100252155"
--Bind 4   value="822606"
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
--Bind 16   value="682"
--Bind 17
--Bind 18   value="US"
--Bind 19   value="CD"
--Bind 20   value="NIL"
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
--Bind 33   value="10598297.9"
--Bind 34   value="252155T2"
--Bind 35   value="20121205"
--Bind 36   value="TEST"
--Bind 37   value="2012&TZDL&T&5187"
--Bind 38
--Bind 39   value="TZTM"
--Bind 40   value="TMU"
--Bind 41
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

 ----- Line : 1405 
 insert into trs_occ_exp values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606"
--Bind 4   value="CALTEX TRADERS LLC"
--Bind 5   value="580 CENTRAL AVE"
--Bind 6   value="RIVERSIDE"
--Bind 7   value="USA"
--Bind 8 

 ----- Line : 1438 
 insert into trs_occ_cns values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8) ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606"
--Bind 4   value="ETS INTRACO"
--Bind 5   value="LUBUMBASHI"
--Bind 6   value="D.R.C"
--Bind 7
--Bind 8 

 ----- Line : 1470 
 insert into trs_itm values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33) ;
 

 ----- Line : 1477 
 select rowid from UNPKGTAB where PKG_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="PK"
--Bind 1   value="2012"
--Bind 2   value="TZDL"
--Bind 3   value="100252155"
--Bind 4   value="822606"
--Bind 5   value="1"
--Bind 6   value="1X40' FCL"
--Bind 7
--Bind 8   value="63090000"
--Bind 9   value="Worn clothing and other worn articles."
--Bind 10
--Bind 11   value="USED SHOES"
--Bind 12   value="682"
--Bind 13   value="PK"
--Bind 14   value="15422.000"
--Bind 15   value="15422.000"
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

 ----- Line : 1573 
 select  trs_dec_date, trs_dep_serial, trs_dep_nber, trs_dep_date, trs_dep_year, trs_dep_time, rowid from trs_gen where key_year = :v0 and key_cuo = :v1 and key_dec = :v2 and key_nber = :v3   for update nowait ;

--Bind 0   value="2012"
--Bind 1   value="TZDL"
--Bind 2   value="100252155"
--Bind 3   value="822606" 

 ----- Line : 1593 
 update trs_gen set TRS_DEC_DATE = :v0 , TRS_DEP_SERIAL = :v1 , TRS_DEP_NBER = :v2 , TRS_DEP_DATE = :v3 , TRS_DEP_YEAR = :v4 , TRS_DEP_TIME = :v5 where rowid = 'AAA7QVAAFAAHuimAAR' ;

--Bind 0   value="20121205"
--Bind 1   value="D"
--Bind 2   value="116419"
--Bind 3   value="20121205"
--Bind 4   value="2012"
--Bind 5   value="15:42:38" 

 ----- Line : 1618 
 select trs_transit_place ,trs_grty_ref ,trs_grty_amount into :b0:b1,:b2:b3,:b4:b5  from trs_gen where (((key_year=:b6 and key_dec=:b7) and key_cuo=:b8) and key_nber=:b9) ;

--Bind 0   value="2012"
--Bind 1   value="100252155"
--Bind 2   value="TZDL"
--Bind 3   value="822606" 

 ----- Line : 1638 
 update sad_gen  set sad_typ_transit='1' where (((sad_asmt_serial=:b0 and sad_asmt_nber=:b1) and key_cuo=:b2) and sad_asmt_year=:b3) ;

--Bind 0   value="T"
--Bind 1   value="5187"
--Bind 2   value="TZDL"
--Bind 3   value="2012" 

 ----- Line : 1660 
 select cre_tot from uncretab where cre_cod = :v0 and (EEA_DOV <= :egdate and (EEA_EOV is null or EEA_EOV >= :egdate)) for update ;

--Bind 0   value="252155T2"
--Bind 1   value="20121205"
--Bind 2   value="20121205"
--Bind 3   value="252155T2" 

 ----- Line : 1684 
 select * FROM csh_gty_mvt where gty_ser = :v0 ;

--Bind 0   value=1268819 

 ----- Line : 1695 
 insert into csh_gty_mvt values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17) ;
 

 ----- Line : 1701 
 insert into csh_gty_mvt values ( '252155T2','5','TRE','20121205','15:42:40','10598297.900000','0.000000','-14891633612.900000','5104','TZDL','D','116419','20121205','','','','',gty_ser.NEXTVAL) ;
 

>>> END
