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

--delete TAA010T		--�����������
--delete TAA020T		--������񳻿�����
--delete TAA030T		--H.S �������
delete from TEA100T	where comp_code = @NEW_COMP	--OFFER ����
delete from TEA110T	where comp_code = @NEW_COMP	--OFFER �󼼳��� ����
delete from TEB100T	where comp_code = @NEW_COMP	--L/C ����
delete from TEB110T	where comp_code = @NEW_COMP	--L/C �󼼳��� ����
delete from TEB120T	where comp_code = @NEW_COMP	--L/C Amend ����
delete from TEB130T	where comp_code = @NEW_COMP	--L/C Amend �󼼳��� ����
delete from TEB140T	where comp_code = @NEW_COMP	--Local L/C ����
delete from TEB150T	where comp_code = @NEW_COMP	--Local L/C �󼼳��� ����
delete from TEB160T	where comp_code = @NEW_COMP	--Local L/C Amend ����
delete from TEB170T	where comp_code = @NEW_COMP	--Local L/C Amend �󼼳��� ����
delete from TEC100T	where comp_code = @NEW_COMP	--�������
delete from TEC110T	where comp_code = @NEW_COMP	--��� �󼼳��� ����
delete from TEC120T	where comp_code = @NEW_COMP	--Local ���� ����
delete from TEC130T	where comp_code = @NEW_COMP	--Local ���� �� ����
delete from TED100T	where comp_code = @NEW_COMP	--��������
delete from TED110T	where comp_code = @NEW_COMP	--���� �󼼳��� ����
delete from TEE100T	where comp_code = @NEW_COMP	--NEGO ����
--delete TEI100T		--
--delete TEI110T		--
--delete TEY200T		--
delete from TIA100T	where comp_code = @NEW_COMP	--Offer ����
delete from TIA110T	where comp_code = @NEW_COMP	--Offer �󼼳��� ����
delete from TIB100T	where comp_code = @NEW_COMP	--L/C ����
delete from TIB110T	where comp_code = @NEW_COMP	--L/C �� ���� ���
delete from TIB120T	where comp_code = @NEW_COMP	--L/C AMEND ����
delete from TIB130T	where comp_code = @NEW_COMP	--L/C AMEND �󼼳���
delete from TIB140T	where comp_code = @NEW_COMP	--LOCAL L/C ����
delete from TIB150T	where comp_code = @NEW_COMP	--LOCAL L/C �󼼳���
delete from TIC100T	where comp_code = @NEW_COMP	--���Լ���
delete from TIC110T	where comp_code = @NEW_COMP	--���Լ����󼼳���
delete from TIC200T	where comp_code = @NEW_COMP	--���Ժ��������
delete from TID100T	where comp_code = @NEW_COMP	--�������
delete from TID110T	where comp_code = @NEW_COMP	--��������󼼳���
delete from TIG100T	where comp_code = @NEW_COMP	--�δ���곻��
delete from TIH100T	where comp_code = @NEW_COMP	--���Դ�ݵ��
delete from TTB100T	where comp_code = @NEW_COMP	--�����꼭����
--delete TTR100T		--
delete from bautonot	where comp_code = @NEW_COMP		--1.  �ڵ�ä������




/*
delete J_SCM400T
delete J_SCM400T_POST
delete J_SCM500T
delete J_SCMDLDT
delete J_SCMGRDT
delete J_SCMGRHD
*/

/*
-- �������� ------------------------------------------------------------------
BEGIN TRAN
-- COMMIT  ROLLBACK
DECLARE        @NEW_COMP        NVARCHAR(10)
			 , @NEW_COMP_NAME	NVARCHAR(40)

SET @NEW_COMP = 'HSPI'

delete from bcm200t	where comp_code = @NEW_COMP	--3.  �ſ�ī��� ����
--select from bcm300t	--4.  �����ȣ����
delete from bcm400t where comp_code = @NEW_COMP	--5.  �޷�����
delete from bcm410t	where comp_code = @NEW_COMP --6.  �޷�����
delete from bcm420t	where comp_code = @NEW_COMP --7.  �޷�����
delete from bcm500t	where comp_code = @NEW_COMP --8.  ȯ������
delete from bcm510t	where comp_code = @NEW_COMP --9.  ȯ������
delete from bcm600t	where comp_code = @NEW_COMP --10. ������Ʈ����
delete from bcm610t	where comp_code = @NEW_COMP --11. ������Ʈ����

delete from bpr500t	where comp_code = @NEW_COMP --21. BOM����
delete from bpr600t	where comp_code = @NEW_COMP --22. ����ȯ������

delete from bpr300t	where comp_code = @NEW_COMP --19. ǰ��ŷ�ó����
delete from bpr400t	where comp_code = @NEW_COMP --20. ǰ��ŷ�ó�ܰ�����
delete from bcm100t where comp_code = @NEW_COMP	--2.  �ŷ�ó ����

delete from pbs300t where comp_code = @NEW_COMP 
delete from pbs200t where comp_code = @NEW_COMP
delete from set100t where comp_code = @NEW_COMP     -- SETǰ������
 

delete from bpr800t where comp_code = @NEW_COMP 
delete from bpr200t	where comp_code = @NEW_COMP --18. ����庰 ǰ������
delete from bpr100t	where comp_code = @NEW_COMP --17. ǰ������
delete from bpr000t	where comp_code = @NEW_COMP --16. ǰ��з�����

delete from bsa230t	where comp_code = @NEW_COMP --28. �۾�������
delete from bsa220t	where comp_code = @NEW_COMP --27. â������


--delete from bsa000t	--23. �޼�������
--delete from bsa100t	where comp_code = @NEW_COMP	--24. �����ڵ�����
delete from bsa110t	where comp_code = @NEW_COMP	--25. ������������������
delete from bsa300t	where comp_code = @NEW_COMP	--29. ���������
delete from bsa400t	where comp_code = @NEW_COMP	--30. ���α׷�����

delete from bsa210t	where comp_code = @NEW_COMP --26. �μ�����

delete from bsa410t	where comp_code = @NEW_COMP --31. �ڱ�޴�����
delete from bsa420t	where comp_code = @NEW_COMP --32. ����ں�ȭ�鼳��
delete from bsa430t	where comp_code = @NEW_COMP --33. ���μ����޴�����
delete from bsa500t	where comp_code = @NEW_COMP --34. ����ں���������


delete from bor130t	where comp_code = @NEW_COMP --14. ���ʹ�������
delete from bor110t	where comp_code = @NEW_COMP --13. ���������
delete from bor120t	where comp_code = @NEW_COMP --15. ���������
delete from bor100t	where comp_code = @NEW_COMP --12. ȸ������

*/