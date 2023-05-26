 ----- Line : 21 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 32 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 51 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 64 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 81 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 98 
 select * from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 117 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 130 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 149 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 168 
 select count(*) from car_bol_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 and carbol_status <> '3' ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 185 
 select  key_lin_nbr, carbol_sline_nber, key_bol_ref, carbol_typ_cod, carbol_nat_cod, carbol_status  from car_bol_gen where (key_cuo = :v0) and (key_voy_nber = :v1) and (key_dep_date = :v2)  and (carbol_status <> '3' ) order by key_lin_nbr, carbol_sline_nber  ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="TZDL"
--Bind 4   value="20120926MSCNEFELI"
--Bind 5   value="20120626"
--Bind 6   value="FXTDAR-194" 

 ----- Line : 215 
 select max(car_bol_ser) into :b0  from car_bol_ope where (((key_cuo=:b1 and key_voy_nber=:b2) and key_dep_date=:b3) and key_bol_ref=:b4) ;
 

 ----- Line : 221 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634283
--Bind 1   value="TZDL"
--Bind 2   value="20120926MSCNEFELI"
--Bind 3   value="20120626"
--Bind 4   value="FXTDAR-195" 

 ----- Line : 250 
 select * FROM car_bol_ope where car_bol_ser = :v0  ;

--Bind 0   value=2634284 

 ----- Line : 263 
 select rowid from UNCUOTAB where CUO_COD = :v0  and lst_ope <> 'D'  ;

--Bind 0   value="TZDL" 

 ----- Line : 276 
 select key_cuo, car_reg_year, car_reg_nber,car_reg_date from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 296 
 select count(*) from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 315 
 select count(*) from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3 

 ----- Line : 336 
 select count(*) from car_bol_ctn where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3 

 ----- Line : 355 
 insert into car_bol_gen values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13,:v14,:v15,:v16,:v17,:v18,:v19,:v20,:v21,:v22,:v23,:v24,:v25,:v26,:v27,:v28,:v29,:v30,:v31,:v32,:v33,:v34,:v35,:v36,:v37,:v38,:v39,:v40,:v41,:v42,:v43,:v44,:v45,:v46,:v47,:v48,:v49,:v50,:v51,:v52,:v53,:v54,:v55,:v56,:v57,:v58,:v59,:v60,:v61,:v62,:v63,:v64,:v65,:v66) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="3"
--Bind 5   value="0"
--Bind 6   value="0"
--Bind 7
--Bind 8   value="MST"
--Bind 9   value="23"
--Bind 10
--Bind 11   value="SDFfjhfgajfjdsafcd"
--Bind 12   value="FdsafdSFDSAFDS\"
--Bind 13   value="Fsdfdsafdsf"
--Bind 14
--Bind 15
--Bind 16
--Bind 17   value="Gama L.V"
--Bind 18   value="DSM"
--Bind 19
--Bind 20
--Bind 21
--Bind 22
--Bind 23   value="ADSGHGHFGFH"
--Bind 24   value="FSDFSDF"
--Bind 25
--Bind 26
--Bind 27
--Bind 28   value="OMSLL"
--Bind 29   value="TZDAR"
--Bind 30   value="1"
--Bind 31   value="PK"
--Bind 32   value="3"
--Bind 33   value="2500.000"
--Bind 34   value="45"
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

 ----- Line : 523 
 select count(*) from car_bol_gen where key_cuo = :v1 and key_voy_nber = :v2 and key_dep_date = :v3 and key_bol_ref = :v4 ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="TZDL"
--Bind 5   value="20120926MSCNEFELI"
--Bind 6   value="20120626"
--Bind 7   value="MBSA001" 

 ----- Line : 558 
 insert into car_bol_ope values (  :VA0,  :VA1,  :VA2,  :VA3,  :VA4,  :VA5,  :VA6,  :VA7,  :VA8,  :VA9,  :VA10,  :VA11,  :VA12,  :VA13,  :VA14,  :VA15,  :VA16,  :VA17,  :VA18,  :VA19,  :VA20,  :VA21,  :VA22,  :VA23,  :VA24,  :VA25,  :VA26,  :VA27,  :VA28, car_bol_ser.NEXTVAL) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="3"
--Bind 5   value="3.000000"
--Bind 6   value="2500.000000"
--Bind 7
--Bind 8
--Bind 9
--Bind 10
--Bind 11
--Bind 12
--Bind 13
--Bind 14   value="STO"
--Bind 15   value="20121205"
--Bind 16   value="07:24:23"
--Bind 17   value="1"
--Bind 18   value="0.000000"
--Bind 19   value="3.000000"
--Bind 20   value="0.000000"
--Bind 21   value="2500.000000"
--Bind 22
--Bind 23
--Bind 24
--Bind 25   value="0"
--Bind 26   value="0"
--Bind 27
--Bind 28   value="STUDENT01" 

 ----- Line : 640 
 update seq$ set increment$=:2,minvalue=:3,maxvalue=:4,cycle#=:5,order$=:6,cache=:7,highwater=:8,audit$=:9,flags=:10 where obj#=:1 ;

--Bind 0   value=1
--Bind 1   value=1
--Bind 2   value=999999999999999999999999999
--Bind 3   value=0
--Bind 4   value=0
--Bind 5   value=20
--Bind 6   value=2634305
--Bind 7   value="--------------------------------"
--Bind 8   value=0
--Bind 9   value=6407 

 ----- Line : 680 
 insert into car_bol_ctn values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="3"
--Bind 5   value="1"
--Bind 6   value="MCUS1256398"
--Bind 7   value="40RG"
--Bind 8   value="FUL"
--Bind 9
--Bind 10
--Bind 11
--Bind 12 

 ----- Line : 721 
 select user# from sys.user$ where name = 'OUTLN' ;
 

 ----- Line : 731 
 INSERT INTO car_bol_ctn_icd VALUES (    :b1        , :b2             , :b3             , :b4            ,    :b5              , :b6             , :b7              , NULL, NULL  ) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="6/26/2012 0:0:0"
--Bind 3   value="MBSA001"
--Bind 4   value="MCUS1256398"
--Bind 5   value="FUL"
--Bind 6 

 ----- Line : 761 
 COMMIT ;
 

 ----- Line : 769 
 select car_bl_nber,car_pac_nber, car_gros_mass, car_cntr_nbr ,rowid from car_gen where key_cuo = :v0 and key_voy_nber = :v1 and key_dep_date = :v2  for update nowait ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626" 

 ----- Line : 786 
 update car_gen set CAR_BL_NBER = :v0 , CAR_PAC_NBER = :v1 , CAR_GROS_MASS = :v2 , CAR_CNTR_NBR = :v3 where rowid = 'AAA7MGAAFAAAMPuAAM' ;

--Bind 0   value="3"
--Bind 1   value="19"
--Bind 2   value="7000.000"
--Bind 3   value="2" 

 ----- Line : 806 
 insert into car_spy values (:v0,:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9) ;

--Bind 0   value="TZDL"
--Bind 1   value="20120926MSCNEFELI"
--Bind 2   value="20120626"
--Bind 3   value="MBSA001"
--Bind 4   value="5"
--Bind 5   value="5"
--Bind 6   value="STUDENT01"
--Bind 7   value="20121205"
--Bind 8   value="07:24:23"
--Bind 9   value="1912" 

>>> END
