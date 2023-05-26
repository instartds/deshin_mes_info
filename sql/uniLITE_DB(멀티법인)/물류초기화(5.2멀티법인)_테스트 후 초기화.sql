BEGIN TRAN
-- COMMIT  ROLLBACK
DECLARE        @NEW_COMP        NVARCHAR(10)
			 , @NEW_COMP_NAME	NVARCHAR(40)

SET @NEW_COMP = 'HSPI'

DELETE FROM SAR000T where comp_code = @NEW_COMP
DELETE FROM SAR100T where comp_code = @NEW_COMP
DELETE FROM SAR200T where comp_code = @NEW_COMP
DELETE FROM SBI100T where comp_code = @NEW_COMP       
DELETE FROM SCM100T where comp_code = @NEW_COMP
DELETE FROM SCO100T where comp_code = @NEW_COMP       
DELETE FROM SCO200T where comp_code = @NEW_COMP       
DELETE FROM SDC100T where comp_code = @NEW_COMP       
DELETE FROM SES100T where comp_code = @NEW_COMP       
DELETE FROM SES110T where comp_code = @NEW_COMP       
--DELETE FROM SET100T where comp_code = @NEW_COMP       
DELETE FROM SFN100T where comp_code = @NEW_COMP       
DELETE FROM SOF100T where comp_code = @NEW_COMP        
DELETE FROM SOF110T where comp_code = @NEW_COMP        
DELETE FROM SRQ100T where comp_code = @NEW_COMP       
DELETE FROM SSA100T where comp_code = @NEW_COMP
DELETE FROM SSA110T where comp_code = @NEW_COMP
DELETE FROM SSP100T where comp_code = @NEW_COMP
DELETE FROM SSP200T where comp_code = @NEW_COMP
DELETE FROM STB100T	where comp_code = @NEW_COMP
DELETE FROM PBS400T where comp_code = @NEW_COMP
DELETE FROM PBS500T where comp_code = @NEW_COMP
DELETE FROM PMP100T where comp_code = @NEW_COMP
DELETE FROM PMP200T where comp_code = @NEW_COMP
DELETE FROM PMP300T where comp_code = @NEW_COMP
DELETE FROM PMP350T where comp_code = @NEW_COMP
DELETE FROM PMR100T where comp_code = @NEW_COMP
DELETE FROM PMR110T where comp_code = @NEW_COMP
DELETE FROM PMR150T where comp_code = @NEW_COMP
DELETE FROM PMR200T where comp_code = @NEW_COMP
DELETE FROM PMR300T where comp_code = @NEW_COMP
DELETE FROM PMR400T where comp_code = @NEW_COMP
DELETE FROM PMR600T where comp_code = @NEW_COMP
DELETE FROM PMR700T where comp_code = @NEW_COMP
DELETE FROM PPL100T where comp_code = @NEW_COMP
DELETE FROM PPL200T where comp_code = @NEW_COMP
DELETE FROM PPL250T where comp_code = @NEW_COMP
DELETE FROM MAP100T where comp_code = @NEW_COMP
DELETE FROM MAP200T where comp_code = @NEW_COMP
DELETE FROM MCL100T where comp_code = @NEW_COMP
DELETE FROM MCL200T where comp_code = @NEW_COMP
DELETE FROM MPO100T where comp_code = @NEW_COMP
DELETE FROM MPO200T where comp_code = @NEW_COMP
DELETE FROM MRP100T where comp_code = @NEW_COMP
DELETE FROM MRP200T where comp_code = @NEW_COMP
DELETE FROM MRP300T where comp_code = @NEW_COMP
DELETE FROM MRP310T where comp_code = @NEW_COMP
DELETE FROM MRP320T where comp_code = @NEW_COMP
DELETE FROM MRP330T where comp_code = @NEW_COMP
DELETE FROM MRP340T where comp_code = @NEW_COMP
DELETE FROM MRP350T where comp_code = @NEW_COMP
DELETE FROM MRP400T where comp_code = @NEW_COMP
DELETE FROM MRP500T where comp_code = @NEW_COMP
DELETE FROM BIV100T where comp_code = @NEW_COMP
DELETE FROM BIV200T where comp_code = @NEW_COMP
DELETE FROM BIV250T where comp_code = @NEW_COMP
DELETE FROM BIV300T where comp_code = @NEW_COMP
DELETE FROM BIV400T where comp_code = @NEW_COMP
DELETE FROM BIV500T where comp_code = @NEW_COMP
DELETE FROM BIV600T where comp_code = @NEW_COMP
DELETE FROM BIV700T where comp_code = @NEW_COMP
DELETE FROM BIV800T where comp_code = @NEW_COMP
DELETE FROM BIV900T where comp_code = @NEW_COMP
DELETE FROM BIZ100T where comp_code = @NEW_COMP
DELETE FROM BIZ200T where comp_code = @NEW_COMP
DELETE FROM BIZ300T where comp_code = @NEW_COMP
DELETE FROM BIZ400T where comp_code = @NEW_COMP
DELETE FROM BIZ600T where comp_code = @NEW_COMP
DELETE FROM BIZ800T where comp_code = @NEW_COMP
DELETE FROM BTR100T where comp_code = @NEW_COMP
DELETE FROM BTR200T where comp_code = @NEW_COMP
DELETE FROM QMS100T where comp_code = @NEW_COMP
DELETE FROM QMS200T where comp_code = @NEW_COMP
DELETE FROM QMS210T where comp_code = @NEW_COMP
DELETE FROM QMS300T where comp_code = @NEW_COMP
DELETE FROM QMS400T where comp_code = @NEW_COMP
DELETE FROM QMS410T where comp_code = @NEW_COMP
DELETE FROM QMS800T where comp_code = @NEW_COMP
DELETE FROM QMS900T where comp_code = @NEW_COMP
DELETE FROM QMS910T where comp_code = @NEW_COMP

--delete TAA010T		--무역경비정보
--delete TAA020T		--무역경비내역정보
--delete TAA030T		--H.S 정보등록
delete from TEA100T	where comp_code = @NEW_COMP	--OFFER 정보
delete from TEA110T	where comp_code = @NEW_COMP	--OFFER 상세내역 정보
delete from TEB100T	where comp_code = @NEW_COMP	--L/C 정보
delete from TEB110T	where comp_code = @NEW_COMP	--L/C 상세내역 정보
delete from TEB120T	where comp_code = @NEW_COMP	--L/C Amend 정보
delete from TEB130T	where comp_code = @NEW_COMP	--L/C Amend 상세내역 정보
delete from TEB140T	where comp_code = @NEW_COMP	--Local L/C 정보
delete from TEB150T	where comp_code = @NEW_COMP	--Local L/C 상세내역 정보
delete from TEB160T	where comp_code = @NEW_COMP	--Local L/C Amend 정보
delete from TEB170T	where comp_code = @NEW_COMP	--Local L/C Amend 상세내역 정보
delete from TEC100T	where comp_code = @NEW_COMP	--통관정보
delete from TEC110T	where comp_code = @NEW_COMP	--통관 상세내역 정보
delete from TEC120T	where comp_code = @NEW_COMP	--Local 매출 정보
delete from TEC130T	where comp_code = @NEW_COMP	--Local 매출 상세 내역
delete from TED100T	where comp_code = @NEW_COMP	--선적정보
delete from TED110T	where comp_code = @NEW_COMP	--선적 상세내역 정보
delete from TEE100T	where comp_code = @NEW_COMP	--NEGO 정보
--delete TEI100T		--
--delete TEI110T		--
--delete TEY200T		--
delete from TIA100T	where comp_code = @NEW_COMP	--Offer 정보
delete from TIA110T	where comp_code = @NEW_COMP	--Offer 상세내역 정보
delete from TIB100T	where comp_code = @NEW_COMP	--L/C 정보
delete from TIB110T	where comp_code = @NEW_COMP	--L/C 상세 내역 등록
delete from TIB120T	where comp_code = @NEW_COMP	--L/C AMEND 정보
delete from TIB130T	where comp_code = @NEW_COMP	--L/C AMEND 상세내역
delete from TIB140T	where comp_code = @NEW_COMP	--LOCAL L/C 정보
delete from TIB150T	where comp_code = @NEW_COMP	--LOCAL L/C 상세내역
delete from TIC100T	where comp_code = @NEW_COMP	--수입선적
delete from TIC110T	where comp_code = @NEW_COMP	--수입선적상세내역
delete from TIC200T	where comp_code = @NEW_COMP	--수입보세입출고
delete from TID100T	where comp_code = @NEW_COMP	--수입통관
delete from TID110T	where comp_code = @NEW_COMP	--수입통관상세내역
delete from TIG100T	where comp_code = @NEW_COMP	--부대비계산내역
delete from TIH100T	where comp_code = @NEW_COMP	--수입대금등록
delete from TTB100T	where comp_code = @NEW_COMP	--매출계산서정보
--delete TTR100T		--
delete from bautonot	where comp_code = @NEW_COMP		--1.  자동채번정보




/*
delete J_SCM400T
delete J_SCM400T_POST
delete J_SCM500T
delete J_SCMDLDT
delete J_SCMGRDT
delete J_SCMGRHD
*/

/*
-- 기준정보 ------------------------------------------------------------------
BEGIN TRAN
-- COMMIT  ROLLBACK
DECLARE        @NEW_COMP        NVARCHAR(10)
			 , @NEW_COMP_NAME	NVARCHAR(40)

SET @NEW_COMP = 'HSPI'

delete from bcm200t	where comp_code = @NEW_COMP	--3.  신용카드사 정보
--select from bcm300t	--4.  우편번호정보
delete from bcm400t where comp_code = @NEW_COMP	--5.  달력정보
delete from bcm410t	where comp_code = @NEW_COMP --6.  달력정보
delete from bcm420t	where comp_code = @NEW_COMP --7.  달력정보
delete from bcm500t	where comp_code = @NEW_COMP --8.  환율정보
delete from bcm510t	where comp_code = @NEW_COMP --9.  환율정보
delete from bcm600t	where comp_code = @NEW_COMP --10. 프로젝트정보
delete from bcm610t	where comp_code = @NEW_COMP --11. 프로젝트정보

delete from bpr500t	where comp_code = @NEW_COMP --21. BOM정보
delete from bpr600t	where comp_code = @NEW_COMP --22. 단위환산정보

delete from bpr300t	where comp_code = @NEW_COMP --19. 품목거래처정보
delete from bpr400t	where comp_code = @NEW_COMP --20. 품목거래처단가정보
delete from bcm100t where comp_code = @NEW_COMP	--2.  거래처 정보

delete from pbs300t where comp_code = @NEW_COMP 
delete from pbs200t where comp_code = @NEW_COMP
delete from set100t where comp_code = @NEW_COMP     -- SET품목정보
 

delete from bpr800t where comp_code = @NEW_COMP 
delete from bpr200t	where comp_code = @NEW_COMP --18. 사업장별 품목정보
delete from bpr100t	where comp_code = @NEW_COMP --17. 품목정보
delete from bpr000t	where comp_code = @NEW_COMP --16. 품목분류정보

delete from bsa230t	where comp_code = @NEW_COMP --28. 작업장정보
delete from bsa220t	where comp_code = @NEW_COMP --27. 창고정보


--delete from bsa000t	--23. 메세지정보
--delete from bsa100t	where comp_code = @NEW_COMP	--24. 공통코드정보
delete from bsa110t	where comp_code = @NEW_COMP	--25. 업무별숫자포멧정보
delete from bsa300t	where comp_code = @NEW_COMP	--29. 사용자정보
delete from bsa400t	where comp_code = @NEW_COMP	--30. 프로그램정보

delete from bsa210t	where comp_code = @NEW_COMP --26. 부서정보

delete from bsa410t	where comp_code = @NEW_COMP --31. 자기메뉴정보
delete from bsa420t	where comp_code = @NEW_COMP --32. 사용자별화면설정
delete from bsa430t	where comp_code = @NEW_COMP --33. 프로세스메뉴정보
delete from bsa500t	where comp_code = @NEW_COMP --34. 사용자별권한정보


delete from bor130t	where comp_code = @NEW_COMP --14. 손익단위정보
delete from bor110t	where comp_code = @NEW_COMP --13. 사업부정보
delete from bor120t	where comp_code = @NEW_COMP --15. 사업장정보
delete from bor100t	where comp_code = @NEW_COMP --12. 회사정보

*/