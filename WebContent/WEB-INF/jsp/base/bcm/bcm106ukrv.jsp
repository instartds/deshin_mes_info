<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm106ukrv">
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B016" /><!-- 법인/개인-->
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->
	<t:ExtComboStore comboType="AU" comboCode="B017" /><!-- 원미만계산-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 계산서종류-->
	<t:ExtComboStore comboType="AU" comboCode="B038" /><!-- 결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!-- 결제조건-->
	<t:ExtComboStore comboType="AU" comboCode="B033" /><!-- 마감종류-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="B030" /><!-- 세액포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B051" /><!-- 세액계산법-->
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!-- 거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /><!-- 지역구분-->
	<t:ExtComboStore comboType="AU" comboCode="B057" /><!-- 미수관리방법-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /><!-- 주담당자-->
	<t:ExtComboStore comboType="AU" comboCode="B062" /><!-- 카렌더타입-->
	<t:ExtComboStore comboType="AU" comboCode="B086" /><!-- 카렌더타입 -->
	<t:ExtComboStore comboType="AU" comboCode="S051" /><!-- 전자문서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- 전자문서주담당여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B109" /><!-- 유통채널-->
	<t:ExtComboStore comboType="AU" comboCode="B232" /><!-- 신/구 주소구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!-- 예/아니오-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
var protocol =	("https:" == document.location.protocol)? "https" : "http";
if(protocol == "https") {
	document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
}else {
	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var detailWin;


function appMain() {
	var BsaCodeInfo = {
		gsHiddenField		: '${gsHiddenField}',
		GetAutoCustomCodeYN	: '${GetAutoCustomCodeYN}',				//자동(10)/수동채번(20)
		gsAutoCustomCodeSP	: '${GetAutoCustomCodeSP}',				//자동채번일 경우, 호출 SP
		gsVatRate			: '${gsVatRate}'						//20210514 추가: 부가세율 가져오는 로직 추가
	}
	if(BsaCodeInfo.GetAutoCustomCodeYN == '20') {
		BsaCodeInfo.GetAutoCustomCodeYN = false;
	} else {
		BsaCodeInfo.GetAutoCustomCodeYN = true;
	}

	//인증서 이미지 등록에 사용되는 변수 선언
	var uploadWin;				//인증서 업로드 윈도우
	var photoWin;				//인증서 이미지 보여줄 윈도우
	var fid = '';				//인증서 ID
	var gsNeedPhotoSave	= false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm106ukrvService.selectList',
			update	: 'bcm106ukrvService.updateDetail',
			create	: 'bcm106ukrvService.insertDetail',
			destroy	: 'bcm106ukrvService.deleteDetail',
			syncAll	: 'bcm106ukrvService.saveAll'
		}
	});

	//SUB 프록시 (BCM130T - 계좌정보)
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm106ukrvService.getBankBookInfo',
			update	: 'bcm106ukrvService.updateList',
			create	: 'bcm106ukrvService.insertList',
			destroy	: 'bcm106ukrvService.deleteList',
			syncAll	: 'bcm106ukrvService.saveAll2'
		}
	});

	//SUB 프록시 (BCM120T - 전자문서정보)
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm106ukrvService.getSubInfo3',
			update	: 'bcm106ukrvService.updateList3',
			create	: 'bcm106ukrvService.insertList3',
			destroy : 'bcm106ukrvService.deleteList3',
			syncAll : 'bcm106ukrvService.saveAll3'
		}
	});

	//SUB 프록시 (BCM103T - 거래처 무역정보)
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm106ukrvService.getSubInfo4',
			update	: 'bcm106ukrvService.updateList4',
			create	: 'bcm106ukrvService.insertList4',
			destroy : 'bcm106ukrvService.deleteList4',
			syncAll : 'bcm106ukrvService.saveAll4'
		}
	});

	//품목 정보 관련 파일 업로드
	var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm106ukrvService.getItemInfo',
			update	: 'bcm106ukrvService.itemInfoUpdate',
			create	: 'bcm106ukrvService.itemInfoInsert',
			destroy : 'bcm106ukrvService.itemInfoDelete',
			syncAll : 'bcm106ukrvService.saveAll5'
		}
	});

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('bcm106ukrvModel', {
		// pkGen : user, system(default)
		 fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.base.customcode" default="거래처코드"/>'							,type:'string'	, isPk:true, pkGen:'user'},
			{name: 'CUSTOM_TYPE'		,text:'<t:message code="system.label.base.classfication" default="구분"/>'							,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.base.customname" default="거래처명"/>'								,type:'string'	,allowBlank:false},
			{name: 'CUSTOM_NAME1'		,text:'<t:message code="system.label.base.customname" default="거래처명"/>'+'1'							,type:'string'	},
			{name: 'CUSTOM_NAME2'		,text:'<t:message code="system.label.base.customname" default="거래처명"/>'+'2'							,type:'string'	},
			{name: 'CUSTOM_FULL_NAME'	,text:'<t:message code="system.label.base.customnamefull" default="거래처명(전명)"/>'						,type:'string'	,allowBlank:false},
			{name: 'NATION_CODE'		,text:'<t:message code="system.label.base.countrycode" default="국가코드"/>'							,type:'string'	,comboType:'AU',comboCode:'B012'},
			{name: 'COMPANY_NUM'		,text:'<t:message code="system.label.base.businessnumber" default="사업자번호"/>'						,type:'string'	},
			{name: 'TOP_NUM'			,text:'<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>'					,type:'string'	},
			{name: 'TOP_NAME'			,text:'<t:message code="system.label.base.representativename" default="대표자명"/>'						,type:'string'	},
			{name: 'BUSINESS_TYPE'		,text:'<t:message code="system.label.base.companytype" default="법인구분"/>'							,type:'string'	,comboType:'AU',comboCode:'B016'},
			{name: 'USE_YN'				,text:'<t:message code="system.label.base.photoflag" default="사진유무"/>'								,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
			{name: 'COMP_TYPE'			,text:'<t:message code="system.label.base.businessconditions" default="업태"/>'						,type:'string'	},
			{name: 'COMP_CLASS'			,text:'<t:message code="system.label.base.businesstype" default="업종"/>'								,type:'string'	},
			{name: 'AGENT_TYPE'			,text:'<t:message code="system.label.base.customclassfication" default="거래처분류"/>'					,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false, defaultValue:'1'},
			{name: 'AGENT_TYPE2'		,text:'<t:message code="system.label.base.customclassfication" default="거래처분류"/>'+'2'				,type:'string'	},
			{name: 'AGENT_TYPE3'		,text:'<t:message code="system.label.base.customclassfication" default="거래처분류"/>'+'3'				,type:'string'	},
			{name: 'AREA_TYPE'			,text:'<t:message code="system.label.base.area2" default="지역"/>'									,type:'string'	,comboType:'AU',comboCode:'B056'},
			// 20210510 종사업장번호 추가
			{name: 'SERVANT_COMPANY_NUM',text:'<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>'				,type:'string' , maxLength: 4},
			{name: 'ZIP_CODE'			,text:'<t:message code="system.label.base.zipcode" default="우편번호"/>'								,type:'string'	},
			{name: 'ADDR1'				,text:'<t:message code="system.label.base.address1" default="주소1"/>'								,type:'string'	},
			{name: 'ADDR2'				,text:'<t:message code="system.label.base.address2" default="주소2"/>'								,type:'string'	},
			{name: 'TELEPHON'			,text:'<t:message code="system.label.base.phoneno" default="전화번호"/>'								,type:'string'	},
			{name: 'FAX_NUM'			,text:'<t:message code="system.label.base.faxnumber" default="FAX번호"/>'								,type:'string'	},
			{name: 'HTTP_ADDR'			,text:'<t:message code="system.label.base.homepage" default="홈페이지"/>'								,type:'string'	},
			{name: 'MAIL_ID'			,text:'<t:message code="system.label.base.emailaddr" default="이메일주소"/>'								,type:'string'	},
			{name: 'WON_CALC_BAS'		,text:'<t:message code="system.label.base.decimalcalculation" default="원미만계산"/>'					,type:'string'	,comboType:'AU',comboCode:'B017'},
			{name: 'START_DATE'			,text:'<t:message code="system.label.base.transactionstartdate" default="거래시작일"/>'					,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
			{name: 'STOP_DATE'			,text:'<t:message code="system.label.base.transactionbreakdate" default="거래중단일"/>'					,type:'uniDate'	},
			{name: 'TO_ADDRESS'			,text:'<t:message code="system.label.base.sendaddress" default="송신주소"/>'							,type:'string'	},
			//20200106 수정: 기본값 "개별"
			{name: 'TAX_CALC_TYPE'		,text:'<t:message code="system.label.base.taxcalculationmethod" default="세액계산법"/>'					,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'2'},
			{name: 'RECEIPT_DAY'		,text:'<t:message code="system.label.base.payperiod" default="결제기간"/>'								,type:'string'	,comboType:'AU',comboCode:'B034'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.base.basiscurrency" default="기준화폐"/>'							,type:'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'TAX_TYPE'			,text:'<t:message code="system.label.base.taxincludedflag" default="세액포함여부"/>'						,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
			{name: 'BILL_TYPE'			,text:'<t:message code="system.label.base.billtype" default="계산서유형"/>'								,type:'string'	, comboType:'AU',comboCode:'A022'},
			{name: 'SET_METH'			,text:'<t:message code="system.label.base.payingmethod" default="결제방법"/>'							,type:'string'	, comboType:'AU',comboCode:'B038'},
			{name: 'VAT_RATE'			,text:'<t:message code="system.label.base.taxrate" default="세율"/>'									,type:'uniFC'	,defaultValue:0},
			{name: 'TRANS_CLOSE_DAY'	,text:'<t:message code="system.label.base.closingtype" default="마감종류"/>'							,type:'string'	, comboType:'AU',comboCode:'B033'},
			{name: 'COLLECT_DAY'		,text:'<t:message code="system.label.base.collectiondate" default="수금일"/>'							,type:'integer' ,defaultValue:1, minValue:1},
			{name: 'CREDIT_YN'			,text:'<t:message code="system.label.base.creditapplyyn" default="여신적용여부"/>'						,type:'string'	, comboType:'AU',comboCode:'B010', defaultValue: 'N'},
			{name: 'TOT_CREDIT_AMT'		,text:'<t:message code="system.label.base.creditloanamount2" default="여신(담보)액"/>'					,type:'uniPrice'},
			{name: 'CREDIT_AMT'			,text:'<t:message code="system.label.base.creditloanamount" default="신용여신액"/>'						,type:'uniPrice'},
			{name: 'CREDIT_YMD'			,text:'<t:message code="system.label.base.creditloanduedate" default="신용여신만료일"/>'					,type:'uniDate'	},
			{name: 'COLLECT_CARE'		,text:'<t:message code="system.label.base.armanagemethod" default="미수관리방법"/>'						,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
			{name: 'BUSI_PRSN'			,text:'<t:message code="system.label.base.maincharger" default="주담당자"/>'							,type:'string'	, comboType:'AU',comboCode:'S010'},
			{name: 'CAL_TYPE'			,text:'<t:message code="system.label.base.calendartype" default="카렌더 타입"/>'							,type:'string'	, comboType:'AU',comboCode:'B062'},
			{name: 'REMARK'				,text:'<t:message code="system.label.base.remarks" default="비고"/>'									,type:'string'	},
			{name: 'MANAGE_CUSTOM'		,text:'<t:message code="system.label.base.summarycustom" default="집계거래처"/>'							,type:'string'	},
			{name: 'MCUSTOM_NAME'		,text:'<t:message code="system.label.base.summarycustomname" default="집계거래처명"/>'					,type:'string'	},
			{name: 'COLLECTOR_CP'		,text:'<t:message code="system.label.base.collectioncustomer" default="수금거래처"/>'					,type:'string'	},
			{name: 'COLLECTOR_CP_NAME'	,text:'<t:message code="system.label.base.collectioncustomername" default="수금거래처명"/>'				,type:'string'	},
			{name: 'BANK_CODE'			,text:'<t:message code="system.label.base.financialinstitution" default="금융기관"/>'					,type:'string'	},
			{name: 'BANK_NAME'			,text:'<t:message code="system.label.base.financialinstitutionname" default="금융기관명"/>'				,type:'string'	},
			{name: 'BANKBOOK_NUM'		,text:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>'							,type:'string'	},
			{name: 'BANKBOOK_NUM_EXPOS'	,text:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>'							,type:'string'	},
			{name: 'BANKBOOK_NAME'		,text:'<t:message code="system.label.base.accountholder" default="예금주"/>'							,type:'string'	},
			{name: 'CUST_CHK'			,text:'<t:message code="system.label.base.changecustomerflag" default="거래처변경여부"/>'					,type:'string'	},
			{name: 'SSN_CHK'			,text:'<t:message code="system.label.base.socialsecuritynumberchangeflag" default="주민번호변경여부"/>'	,type:'string'	},
			{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.base.writer" default="작성자"/>'									,type:'string'	},
			{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.base.writtentiem" default="작성시간"/>'							,type:'uniDate'	},
			{name: 'PURCHASE_BANK'		,text:'<t:message code="system.label.base.purchasecardbank" default="구매카드은행"/>'						,type:'string'	},
			{name: 'PURBANKNAME'		,text:'<t:message code="system.label.base.purchasecardbankname" default="구매카드은행명"/>'				,type:'string'	},
			{name: 'BILL_PRSN'			,text:'<t:message code="system.label.base.electronicdocumentcharger" default="전자문서담당자"/>'			,type:'string'	},
			{name: 'HAND_PHON'			,text:'<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>'							,type:'string'	},
			{name: 'BILL_MAIL_ID'		,text:'<t:message code="system.label.base.electronicdocumentemail" default="전자문서Email"/>'			,type:'string'	},
			{name: 'BILL_PRSN2'			,text:'<t:message code="system.label.base.electronicdocumentcharger" default="전자문서담당자"/>'+'2'		,type:'string'	},
			{name: 'HAND_PHON2'			,text:'<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>'+'2'						,type:'string'	},
			{name: 'BILL_MAIL_ID2'		,text:'<t:message code="system.label.base.electronicdocumentemail" default="전자문서Email"/>'+'2'		,type:'string'	},
			{name: 'BILL_MEM_TYPE'		,text:'<t:message code="system.label.base.electronicbill" default="전자세금계산서"/>'						,type:'string'	},
			{name: 'ADDR_TYPE'			,text:'<t:message code="system.label.base.newoldaddressflag" default="신/구주소구분"/>'					,type:'string'	, comboType:'AU',comboCode:'B232'},
			{name: 'COMP_CODE'			,text:'COMP_CODE'																					,type:'string'	, defaultValue: UserInfo.compCode},
			{name: 'CHANNEL'			,text:'CHANNEL'																						,type:'string'	},
			{name: 'BILL_CUSTOM'		,text:'<t:message code="system.label.base.billcustomcode" default="계산서거래처코드"/>'					,type:'string'	},
			{name: 'BILL_CUSTOM_NAME'	,text:'<t:message code="system.label.base.billcustomname" default="계산서거래처명"/>'						,type:'string'	},
			{name: 'CREDIT_OVER_YN'		,text:'CREDIT_OVER_YN'																				,type:'string'	},
			{name: 'Flag'				,text:'Flag'																						,type:'string'	},
			{name: 'DEPT_CODE'			,text:'<t:message code="system.label.base.relateddepartments" default="관련부서"/>'						,type:'string'	},
			{name: 'DEPT_NAME'			,text:'<t:message code="system.label.base.Related departmentsname" default="관련부서명"/>'				,type:'string'	},
			{name: 'BILL_PUBLISH_TYPE'	,text:'<t:message code="system.label.base.electronicbillissuetype" default="전자세금계산서 발행유형"/>'		,type:'string'	, defaultValue:'1'}, //임시 2016.11.07
			// 추가(극동)
			{name: 'R_PAYMENT_YN'		,text:'<t:message code="system.label.base.regularpaymentflag" default="정기결제여부"/>'					,type:'string', allowBlank: false , comboType:'AU',comboCode:'B010', defaultValue: 'N' },
			{name: 'DELIVERY_METH'		,text:'<t:message code="system.label.base.transportmethod" default="운송방법"/>'						,type:'string'},
			//20190318 trade 추가(sof100t의 무역탭)
			{name: 'PAY_TERMS'			,text:'<t:message code="system.label.base.paymentcondition" default="결제조건"/>'						,type:'string'},
			{name: 'PAY_DURING'			,text:'PAY_DURING'						,type:'string'},
			{name: 'PAY_METHODE1'		,text:'<t:message code="system.label.base.payingmethod" default="대금결제방법"/>'							,type:'string'},
			{name: 'TERMS_PRICE'		,text:'<t:message code="system.label.base.pricecondition" default="가격조건"/>'							,type:'string'},
			{name: 'COND_PACKING'		,text:'<t:message code="system.label.base.packingmethod" default="포장방법"/>'							,type:'string'},
			{name: 'METH_CARRY'			,text:'<t:message code="system.label.base.transportmethod" default="운송방법"/>'						,type:'string'},
			{name: 'METH_INSPECT'		,text:'<t:message code="system.label.base.inspecmethod" default="검사방법"/>'							,type:'string'},
			{name: 'DEST_PORT'			,text:'<t:message code="system.label.base.arrivalport" default="도착항"/>'								,type:'string'},
			{name: 'SHIP_PORT'			,text:'<t:message code="system.label.base.shipmentport" default="선적항"/>'							,type:'string'},
			{name: 'AGENT_CODE'			,text:'<t:message code="system.label.base.agent" default="대행자"/>'									,type:'string'},
			{name: 'AGENT_NAME'			,text:'AGENT_NAME'																					,type:'string'},
			{name: 'OLD_CUSTOM_CODE'	,text:'<t:message code="system.label.base.interfacecode" default="인터페이스코드"/>'						,type:'string'},
			{name: 'CUSTOM_SALE_PRSN'	,text:'거래처영업담당자'																					,type:'string'}		// 20210723추가: 거래처영업담당자
		]
	});

	//SUB 모델 (BCM130T - 계좌정보)
	Unilite.defineModel('bcm106ukrvModel2', {
		fields: [
			{name: 'COMPC_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'			,type: 'string'},
			{name: 'SEQ'				,text: '<t:message code="system.label.base.seq" default="순번"/>'						,type: 'int'},
			{name: 'BOOK_CODE'			,text: '<t:message code="system.label.base.bankaccountcode" default="계좌코드"/>'		,type: 'string', maxLength: 20},
			{name: 'BOOK_NAME'			,text: '<t:message code="system.label.base.bankaccountname" default="계좌명"/>'		,type: 'string'},
			{name: 'BANK_CODE'			,text: '<t:message code="system.label.base.bankcode" default="은행코드"/>'				,type: 'string'},
			{name: 'BANK_NAME'			,text: '<t:message code="system.label.base.bankname" default="은행명"/>'				,type: 'string'},
			{name: 'BANKBOOK_NUM'		,text: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>'+'(DB)'	,type: 'string'},
			{name: 'BANKBOOK_NUM_EXPOS'	,text: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>'			,type: 'string'		,defaultValue: '***************'},
			{name: 'BANKBOOK_NAME'		,text: '<t:message code="system.label.base.accountholder" default="예금주"/>'			,type: 'string'},
			{name: 'MAIN_BOOK_YN'		,text: '<t:message code="system.label.base.mainaccount" default="주지급계좌"/>'			,type: 'string', comboType:'AU',comboCode:'B131'}
		]
	});

	//SUB 모델 (BCM120T - 전자문서정보)
	Unilite.defineModel('bcm106ukrvModel3', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'							,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'							,type: 'string'},
			{name: 'SEQ'				,text: '<t:message code="system.label.base.seq" default="순번"/>'										,type: 'int'},
			{name: 'PRSN_NAME'			,text: '<t:message code="system.label.base.chargername" default="담당자명"/>'							,type: 'string'	, allowBlank:false},	//20200224 수정: 필수
			{name: 'DEPT_NAME'			,text: '<t:message code="system.label.base.departmentname" default="부서명"/>'							,type: 'string'},
			{name: 'HAND_PHON'			,text: '<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>'							,type: 'string'},
			{name: 'TELEPHONE_NUM1'		,text: '<t:message code="system.label.base.phoneno" default="전화번호"/>'+'1'							,type: 'string'},
			{name: 'TELEPHONE_NUM2'		,text: '<t:message code="system.label.base.phoneno" default="전화번호"/>'+'2'							,type: 'string'},
			{name: 'FAX_NUM'			,text: '<t:message code="system.label.base.faxno" default="팩스번호"/>'									,type: 'string'},
			{name: 'MAIL_ID'			,text: '<t:message code="system.label.base.emailaddr" default="이메일주소"/>'							,type: 'string'	, allowBlank:false},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.base.electronicdocumentdivision" default="전자문서구분"/>'			,type: 'string'	, comboType:'AU',comboCode:'S051'},
			{name: 'MAIN_BILL_YN'		,text: '<t:message code="system.label.base.electronicdocumentchargerflag" default="전자문서담당자여부"/>'	,type: 'string'	, allowBlank: false		, comboType:'AU',comboCode:'A020'},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'									,type: 'string'}
		]
	 });




	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('bcm106ukrvMasterStore',{
		model	: 'bcm106ukrvModel',
		autoLoad: false,
		uniOpt	: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : true			// prev | next 버튼 사용
		},

		proxy	: directProxy,

		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기
		loadStoreRecords : function() {
			var param= Ext.getCmp('bcm106ukrvSearchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},

		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var isErr		= false;
			console.log("inValidRecords : ", inValidRecs);

			if (!BsaCodeInfo.GetAutoCustomCodeYN) {
				Ext.each(toCreate, function(createdRow, index) {
					if(Ext.isEmpty(createdRow.get('CUSTOM_CODE'))) {
						Unilite.messageBox('<t:message code="system.label.base.customcode" default="거래처코드"/>'
							+ '<t:message code="system.label.commonJS.form.invalidText" default="은(는) 필수입력 항목입니다."/>');			//거래처 코드은(는) 필수입력 항목입니다.
						isErr = true
						return false;
					}
				});
			}
			if(isErr) {
				return false;
			}
			//1. 마스터 정보 파라미터 구성
			var paramMaster				= panelResult.getValues();			//syncAll 수정
			paramMaster.CUSTOM_CODE_YN	= BsaCodeInfo.GetAutoCustomCodeYN;
			paramMaster.CUSTOM_CODE_SP	= BsaCodeInfo.gsAutoCustomCodeSP;

			if(inValidRecs.length == 0 ) {
				config = {
					params	: [paramMaster],
					success: function(batch, option) {
						setTimeout(function(){
							var selectRecord = masterGrid.getSelectedRecord();
							if(!Ext.isEmpty(selectRecord)) {
								detailForm.setValue('CUSTOM_CODE',selectRecord.get('CUSTOM_CODE'));
								masterStore.commitChanges();
								Ext.getCmp('autoCustomCodeFieldset').setHidden(true);
							}
						},50)
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)){
					detailForm.clearForm();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){
			}
		} // listeners
	});

	var accountStore = Unilite.createStore('bcm106ukrvAccountStore',{
		model: 'bcm106ukrvModel2',
		autoLoad: false,
		uniOpt : {
			isMaster: false,		// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy2,

		loadStoreRecords : function(getCustomCode) {
			var param= Ext.getCmp('bcm106ukrvSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode

			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				this.syncAllDirect(config);
			}else {
				accountGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			},
			load: function(store, records, successful, eOpts) {
				Ext.getCmp('detailForm').body.scrollTo('top', 0);
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save', true);
		} // onStoreUpdate

		,_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0) {
				this.setToolbarButtons(['sub_delete'], false);
			Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
			}else {
				if(this.uniOpt.deletable) {
					this.setToolbarButtons(['sub_delete'], true);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save'], true);
			}else {
				this.setToolbarButtons(['sub_save'], false);
			}
		},

		setToolbarButtons: function( btnName, state) {
			var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	var electroInfoStore = Unilite.createStore('bcm106ukrvElectroInfoStore',{
		model	: 'bcm106ukrvModel3',
		autoLoad: false,
		uniOpt	: {
			isMaster: false,		// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy3,

		loadStoreRecords : function(getCustomCode){
			var param= Ext.getCmp('bcm106ukrvSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode

			console.log( param );
			this.load({
				 params : param,
				 callback : function(records, operation, success) {
					// Ext.getCmp('detailForm').body.scrollTo('top', 0);
				 }
			});
		},

		saveStore : function(config)	 {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				 this.syncAllDirect(config);
			}else {
				 electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			},
			load: function(store, records, successful, eOpts) {
				Ext.getCmp('detailForm').body.scrollTo('top', 0);
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save3', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				 this.setToolbarButtons('sub_save3', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				 this.setToolbarButtons(['sub_delete3'], false);
				 Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':false}});
			}else {
				 if(this.uniOpt.deletable) {
					this.setToolbarButtons(['sub_delete3'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':true}});
				 }
			}
			if(store.isDirty()) {
				 this.setToolbarButtons(['sub_save3'], true);
			}else {
				 this.setToolbarButtons(['sub_save3'], false);
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = electroInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				 (state) ? obj.enable():obj.disable();
			}
		}
	 });




	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('bcm106ukrvSearchForm',{
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		defaults: {
			autoScroll:true
		},
		items:[{
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
				name		: 'CUSTOM_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.customname" default="거래처명"/>',
				name		: 'CUSTOM_NAME',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
				name		: 'CUSTOM_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B015',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
			}]
		}, {
			title		: '<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.area2" default="지역"/>',
				name		: 'AREA_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				fieldLabel	: '<t:message code="system.label.base.mainsalescharge" default="주영업담당"/>',
				name		: 'BUSI_PRSN' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				fieldLabel	: '<t:message code="system.label.base.clienttype" default="고객분류"/>'	 ,
				name		: 'AGENT_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '<t:message code="system.label.base.businesstype2" default="법인/개인"/>',
				name		: 'BUSINESS_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B016'
			},{
				fieldLabel	: '<t:message code="system.label.base.photoflag" default="사진유무"/>'	,
				name		: 'USE_YN',
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B010'
			},{
				fieldLabel	: '<t:message code="system.label.base.representativename" default="대표자명"/>'	,
				name		: 'TOP_NAME'
			},{
				fieldLabel	: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>',
				name		: 'COMPANY_NUM'
			 }/*,{
				fieldLabel: '사업자번호체크' ,
				name: 'CHK_COMPANY_NUM' ,
				xtype: 'checkboxfield'
			}*/]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	: -100,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
			name		: 'CUSTOM_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.customname" default="거래처명"/>',
			name		: 'CUSTOM_NAME',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
			name		: 'CUSTOM_TYPE' ,
			xtype		: 'uniCombobox' ,
			comboType	: 'AU',
			comboCode	: 'B015',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_TYPE', newValue);
				}
			}
		}]
	 });



	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('bcm106ukrvGrid', {
		store	: masterStore,
		region	: 'west',
		flex	: 1,
		uniOpt:{
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		border:true,
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80	, hideable:false, isLink:true},
				 {dataIndex:'CUSTOM_TYPE'		,width:80	, hidden:true},
				 {dataIndex:'CUSTOM_NAME'		,flex: 1	, minWidth:130	, hideable:false},
				 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_FULL_NAME'	,width:170	, hidden:true},
				 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				 {dataIndex:'COMPANY_NUM'		,width:100	, hidden:true},
				 {dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				 {dataIndex:'TOP_NAME'			,width:100	, hidden:true},
				 {dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
				 {dataIndex:'USE_YN'			,width:60	, hidden:true},
				 {dataIndex:'COMP_TYPE'			,width:140	, hidden:true},
				 {dataIndex:'COMP_CLASS'		,width:140	, hidden:true},
				 {dataIndex:'AGENT_TYPE'		,width:120	, hidden:true},
				 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				 {dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'ZIP_CODE'			,hidden:true,
					'editor' : Unilite.popup('ZIP_G',{
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type){
									var me = this;
									var grdRecord = Ext.getCmp('bcm106ukrvGrid').uniOpt.currentRecord;
									grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
									grdRecord.set('ADDR2',records[0]['ADDR2']);
								},
								scope: this
							},
							'onClear' : function(type){
								var me = this;
								var grdRecord = Ext.getCmp('bcm106ukrvGrid').uniOpt.currentRecord;
								grdRecord.set('ADDR1','');
								grdRecord.set('ADDR2','');
							 }
						}
					})
				},
				 {dataIndex:'ADDR1'				,width:200	, hidden:true},
				 {dataIndex:'ADDR2'				,width:200	, hidden:true},
				 {dataIndex:'TELEPHON'			,width:80	, hidden:true},
				 // 추가(극동)
				 {dataIndex:'R_PAYMENT_YN'		,width:100	, hidden:true},
				 {dataIndex:'DELIVERY_METH'		,width:80	, hidden:true},
				 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				 {dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				 {dataIndex:'START_DATE'		,width:110	, hidden:true},
				 {dataIndex:'STOP_DATE'			,width:110	, hidden:true},
				 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
				 {dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:120	, hidden:true},
				 {dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
				 {dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'SET_METH'			,width:90	, hidden:true},
				 {dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				 {dataIndex:'COLLECT_DAY'		,width:90	, hidden:true, maxValue: 31, minValue: 1},
				 {dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				 {dataIndex:'TOT_CREDIT_AMT'	,width:90	, hidden:true},
				 {dataIndex:'CREDIT_AMT'		,width:80	, hidden:true},
				 {dataIndex:'CREDIT_YMD'		,width:110	, hidden:true},
				 {dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
				 {dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
				 {dataIndex:'CAL_TYPE'			,width:110	, hidden:true},
				 {dataIndex:'REMARK'			,width:250	, hidden:true	, flex:1},
				 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
				,editor : Unilite.popup('CUST_G',{
								textFieldName:'MCUSTOM_NAME',
								autoPopup: true,
								listeners: {
									 'onSelected':function(records, type){
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
											grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
									 },
									 'onClear':function( type){
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('MCUSTOM_NAME','');
											grdRecord.set('MANAGE_CUSTOM','');
									 }
								} // listeners
							})
				},
				 {dataIndex:'COLLECTOR_CP'		,width:140	, hidden:true},
				 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
					,'editor' : Unilite.popup('CUST_G',	{
									textFieldName:'COLLECTOR_CP_NAME',
									autoPopup: true,
									listeners: {
										 'onSelected':function(records, type){
												var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
													grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
										 },
										 'onClear':function( type){
												var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('COLLECTOR_CP_NAME','');
												grdRecord.set('COLLECTOR_CP','');
										 }
									} // listeners
								})
				},
				 {dataIndex:'BANK_NAME',width: 100		, hidden: true
					,'editor' : Unilite.popup('BANK_G',	{
									textFieldName:'BANK_NAME',
									autoPopup: true,
									listeners: {
										 'onSelected': function(records, type){
												var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
												grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
										 },
										 'onClear':function( type){
												var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('BANK_NAME','');
												grdRecord.set('BANK_CODE','');
										 }
									} // listeners
								})
					},
				 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
				 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
				 {dataIndex:'CUST_CHK'			,width:90	, hidden:true},
				 {dataIndex:'SSN_CHK'			,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_USER'	,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_TIME'	,width:90	, hidden:true},
				 {dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
				 {dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
				 {dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
				 {dataIndex:'HAND_PHON'			,width:110	, hidden:true},
				 {dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
				 {dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'CHANNEL'			,width:80	, hidden:true},
				 {dataIndex:'BILL_CUSTOM'		,width:120	, hidden:true},
				 {dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
				 {dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
					,'editor' : Unilite.popup('CUST_G',{
									textFieldName:'BILL_CUSTOM_NAME',
									autoPopup: true,
									listeners: {
											 'onSelected':function(records, type){
													var grdRecord = masterGrid.uniOpt.currentRecord;
													grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
													grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
											 },
											 'onClear':function( type){
													var grdRecord = masterGrid.uniOpt.currentRecord;
													grdRecord.set('BILL_CUSTOM_NAME','');
													grdRecord.set('BILL_CUSTOM','');
											 }
										} //listeners
								})
				 },
				 {dataIndex:'PAY_TERMS'			,width:100	, hidden:true},
				 {dataIndex:'PAY_DURING'		,width:100	, hidden:true},
				 {dataIndex:'PAY_METHODE1'		,width:100	, hidden:true},
				 {dataIndex:'TERMS_PRICE'		,width:100	, hidden:true},
				 {dataIndex:'COND_PACKING'		,width:100	, hidden:true},
				 {dataIndex:'METH_CARRY'		,width:100	, hidden:true},
				 {dataIndex:'METH_INSPECT'		,width:100	, hidden:true},
				 {dataIndex:'DEST_PORT'			,width:100	, hidden:true},
				 {dataIndex:'SHIP_PORT'			,width:100	, hidden:true},
				 {dataIndex:'AGENT_CODE'		,width:100	, hidden:true},
				 {dataIndex:'AGENT_NAME'		,width:100	, hidden:true},
				 //20200123 추가
				 {dataIndex:'OLD_CUSTOM_CODE'	,width:100	, hidden:true},
				 // 20210510 추가
				 {dataIndex:'SERVANT_COMPANY_NUM',width:100	, hidden:true}
			],
			listeners: {
				beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_TYPE', 'CUSTOM_NAME'])){
						return false;
					}
				},
				selectionchangerecord:function(selected) {
					detailForm.setActiveRecord(selected)
					accountStore.loadStoreRecords(selected.get('CUSTOM_CODE'));
					electroInfoStore.loadStoreRecords(selected.get('CUSTOM_CODE'));
					if(selected.phantom == true){
						if(Ext.getCmp('autoCustomCodeFieldset').items.length > 0){
							Ext.getCmp('autoCustomCodeFieldset').setHidden(false);
						}
					}else{
						Ext.getCmp('autoCustomCodeFieldset').setHidden(true);

					}
					itemInfoStore.loadStoreRecords(selected.get('CUSTOM_CODE'));
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
				},
				hide:function() {
				},
				edit: function(editor, e) {
					var record = masterGrid.getSelectedRecord();
					detailForm.setActiveRecord(record);
				},cellclick: function(table, td, cellIndex, record) {
					Ext.getCmp('detailForm').body.scrollTo('top', 0);
	            }
			}
	});

	var masterGrid2 = Unilite.createGrid('bcm106ukrvGrid2', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: true,
			useMultipleSorting	: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		border:true,
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80	, hideable:false, isLink:true},
				 {dataIndex:'CUSTOM_TYPE'		,width:80	, hideable:false},
				 {dataIndex:'CUSTOM_NAME'		,width:130	, hideable:false},
				 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_FULL_NAME'	,width:170},
				 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				 {dataIndex:'COMPANY_NUM'		,width:100},
				 {dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				 {dataIndex:'TOP_NAME'			,width:100},
				 {dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
				 {dataIndex:'USE_YN'			,width:60	, hidden:true},
				 {dataIndex:'COMP_TYPE'			,width:140},
				 {dataIndex:'COMP_CLASS'		,width:140},
				 {dataIndex:'AGENT_TYPE'		,width:120},
				 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				 {dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'ZIP_CODE'			, hidden : true
					,'editor' : Unilite.popup('ZIP_G',{
									autoPopup: true,
									listeners: {
											 'onSelected': {
												fn: function(records, type){
													var me = this;
													var grdRecord = Ext.getCmp('bcm106ukrvGrid').uniOpt.currentRecord;
													grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
													grdRecord.set('ADDR2',records[0]['ADDR2']);
												},
												scope: this
											 },
											 'onClear' : function(type){
													var me = this;
													var grdRecord = Ext.getCmp('bcm106ukrvGrid').uniOpt.currentRecord;
													grdRecord.set('ADDR1','');
													grdRecord.set('ADDR2','');
											 }
										}
								})},
				 {dataIndex:'ADDR1'				,width:200	, hidden:true},
				 {dataIndex:'ADDR2'				,width:200	, hidden:true},
				 {dataIndex:'TELEPHON'			,width:80},
				 // 추가(극동)
				 {dataIndex:'R_PAYMENT_YN'		,width:100},
				 {dataIndex:'DELIVERY_METH'		,width:80},
					//
				 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				 {dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				 {dataIndex:'START_DATE'		,width:110	, hidden:true},
				 {dataIndex:'STOP_DATE'			,width:110	, hidden:true},
				 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
				 {dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:120	, hidden:true},
				 {dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
				 {dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'SET_METH'			,width:90	, hidden:true},
				 {dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				// {dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				 {dataIndex:'COLLECT_DAY'		,width:90	, hidden:true, maxValue: 31, minValue: 1},
				 {dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				 {dataIndex:'TOT_CREDIT_AMT'	,width:90	, hidden:true},
				 {dataIndex:'CREDIT_AMT'		,width:80	, hidden:true},
				 {dataIndex:'CREDIT_YMD'		,width:110	, hidden:true},
				 {dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
				 {dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
				 {dataIndex:'CAL_TYPE'			,width:110	, hidden:true},
				 {dataIndex:'REMARK'			,width:250	, flex:1},
				 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
				,editor : Unilite.popup('CUST_G',{
									textFieldName:'MCUSTOM_NAME',
									autoPopup: true,
									listeners: {
											 'onSelected':function(records, type){
													var grdRecord = masterGrid2.uniOpt.currentRecord;
													grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
													grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
											 }
											 ,'onClear':function( type){
													var grdRecord = masterGrid2.uniOpt.currentRecord;
													grdRecord.set('MCUSTOM_NAME','');
													grdRecord.set('MANAGE_CUSTOM','');
											 }
										} // listeners
								})
				},
				 {dataIndex:'COLLECTOR_CP'	,width:140	, hidden:true},
				 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
					,'editor' : Unilite.popup('CUST_G',	{
										textFieldName:'COLLECTOR_CP_NAME',
										autoPopup: true,
										listeners: {
												 'onSelected':function(records, type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
															grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
												 },
												 'onClear':function( type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('COLLECTOR_CP_NAME','');
														grdRecord.set('COLLECTOR_CP','');
												 }
											} // listeners
								})
				},
				 {dataIndex:'BANK_NAME',width: 100		, hidden: true
						,'editor' : Unilite.popup('BANK_G',	{
										textFieldName:'BANK_NAME',
										autoPopup: true,
										listeners: {
												 'onSelected': function(records, type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
														grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
												 },
												 'onClear':function( type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('BANK_NAME','');
														grdRecord.set('BANK_CODE','');
												 }
											} // listeners
								})
					},
				 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
				 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
				 {dataIndex:'CUST_CHK'			,width:90	, hidden:true},
				 {dataIndex:'SSN_CHK'			,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_USER'	,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_TIME'	,width:90	, hidden:true},
				 {dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
				 {dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
				 {dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
				 {dataIndex:'HAND_PHON'			,width:110	, hidden:true},
				 {dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
				 {dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'CHANNEL'			,width:80	, hidden:true},
				 {dataIndex:'BILL_CUSTOM'		,width:120	, hidden:true},
				 {dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
				 {dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
					,'editor' : Unilite.popup('CUST_G',{
										textFieldName:'BILL_CUSTOM_NAME',
										autoPopup: true,
										listeners: {
												 'onSelected':function(records, type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
														grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
												 },
												 'onClear':function( type){
														var grdRecord = masterGrid2.uniOpt.currentRecord;
														grdRecord.set('BILL_CUSTOM_NAME','');
														grdRecord.set('BILL_CUSTOM','');
												 }
											} //listeners
								})
				},
				//20200123 추가
				{dataIndex:'OLD_CUSTOM_CODE'	,width:100},
				// 20210510 추가
				{dataIndex:'SERVANT_COMPANY_NUM',width:100, hidden:true},
				// 20210723 추가
				{dataIndex:'CUSTOM_SALE_PRSN'	,width:130, hidden:true}
			],
			listeners: {
				beforeedit: function( editor, e, eOpts ) {
					if(e.record.phantom == false) {		// 신규데이터가 아닌것.
						if (UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_TYPE'/*, 'CUSTOM_NAME'*/])){
							return false;
						}
					} else {
						if(BsaCodeInfo.GetAutoCustomCodeYN) {
							if (UniUtils.indexOf(e.field, ['CUSTOM_CODE'])){
								return false;
							}
						} else {
							return true;
						}
					}
				},
				selectionchangerecord:function(selected) {
					detailForm.setActiveRecord(selected)
					accountStore.loadStoreRecords(selected.get('CUSTOM_CODE'));
					electroInfoStore.loadStoreRecords(selected.get('CUSTOM_CODE'));
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
				},
				hide:function() {
				},
				edit: function(editor, e) {
					var record = masterGrid.getSelectedRecord();
					detailForm.setActiveRecord(record);
				}
			}
	 });

	var accountGrid = Unilite.createGrid('bcm106ukrvGrid3', {
		store	: accountStore,
		border	: true,
		height	: 150,
		width	: 912,
		padding	: '0 0 5 0',
		sortableColumns : false,

		excelTitle: '<t:message code="system.label.base.accountinformation" default="계좌정보"/>',
		uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false
//			 enterKeyCreateRow	: true						//마스터 그리드 추가기능 삭제
		},
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				tooltip	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query',
				handler: function() {
					//if( me._needSave()) {
					var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
							title	:'<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										accountStore.saveStore();
									});
									saveTask.delay(500);

								} else if(res === 'no') {
									accountStore.loadStoreRecords(record.get('CUSTOM_CODE'));
								}
							}
						});
					} else {
						accountStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset" default="신규"/>',
				tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset',
				handler	: function() {
					var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										accountStore.saveStore();
									});
									saveTask.delay(500);

								} else if(res === 'no') {
									accountGrid.reset();
									accountStore.clearData();
									accountStore.setToolbarButtons('sub_save'	, false);
									accountStore.setToolbarButtons('sub_delete'	, false);
								}
							}
						});
					} else {
						accountGrid.reset();
						accountStore.clearData();
						accountStore.setToolbarButtons('sub_save'	, false);
						accountStore.setToolbarButtons('sub_delete'	, false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData',
				handler	: function() {
					var record			= masterGrid.getSelectedRecord();
					var compCode		= UserInfo.compCode;
					var customCode		= record.get('CUSTOM_CODE');
					var bankBookNumExpos= '';
					var mainBookYn		= 'N';

					var r = {
						COMP_CODE			: compCode,
						CUSTOM_CODE			: customCode,
						MAIN_BOOK_YN		: mainBookYn,
						BANKBOOK_NUM_EXPOS	: bankBookNumExpos
					};
					accountGrid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip	: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_delete',
				handler	: function() {
					var selRow = accountGrid.getSelectedRecord();
					if(selRow.phantom === true) {
						accountGrid.deleteSelectedRow();

					}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						accountGrid.deleteSelectedRow();
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip	: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = accountStore.getInvalidRecords();
					if(inValidRecs.length == 0 ) {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							accountStore.saveStore();
						});
						saveTask.delay(500);

					} else {
						accountGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		 }],

		columns:[
			{ dataIndex: 'BOOK_CODE'			, width: 120},
			{ dataIndex: 'BOOK_NAME'			, width: 100},
			{ dataIndex: 'BANK_CODE'			, width: 120,
				editor: Unilite.popup('BANK_G',{
					DBtextFieldName	: 'BANK_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = accountGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = accountGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			 },{ dataIndex: 'BANK_NAME'			, width: 160,
					editor		: Unilite.popup('BANK_G',{
					autoPopup	: true,
					listeners	:{
						'onSelected': {
							fn: function(records, type){
								var grdRecord = accountGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = accountGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			},
			{ dataIndex: 'BANKBOOK_NUM_EXPOS'	, width: 120	},
			{ dataIndex: 'BANKBOOK_NUM'			, width: 160,	hidden: true},
			{ dataIndex: 'BANKBOOK_NAME'		, width: 120},
			{ dataIndex: 'MAIN_BOOK_YN'			, width: 100}

		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BOOK_CODE'])){
					if(e.record.phantom){
						 return true;
					}else{
						 return false;
					}
				}else if(e.field == "BANKBOOK_NUM_EXPOS") {
					//e.grid.openCryptPopup( e.record );
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if(colName =="BANKBOOK_NUM_EXPOS") {
					grid.ownerGrid.openCryptBankAccntPopup(record);
					//팝업에서 직접입력(암호화팝업)으로 변경
//					grid.ownerGrid.openCryptBankAccntPopup(record);
				}
			}
		},
//		openCryptBankAccntPopup:function( record ) {
//			if(record) {
//				var params = {'BANK_ACCNT_CODE': record.get('BANKBOOK_NUM')};
//				Unilite.popupCryptBankAccnt('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
//			}
//		},
		openCryptBankAccntPopup:function(record) {
			if(record) {
				var params = {'BANK_ACCOUNT': record.get('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}
		}
	});

	var electroInfoGrid = Unilite.createGrid('bcm106ukrvGrid4', {
		store	: electroInfoStore,
		border	: true,
		height	: 150,
		width	: 912,
		padding	: '0 0 5 0',
		sortableColumns : false,

		excelTitle: '<t:message code="system.label.base.electronicdocumentinfo" default="전자문서정보"/>',
		uniOpt:{
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							 //마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
				xtype	: 'toolbar',
				dock	: 'top',
				items	: [{
					 xtype	: 'uniBaseButton',
					 text	: '<t:message code="system.label.base.inquiry" default="조회"/>',
					 tooltip: '<t:message code="system.label.base.inquiry" default="조회"/>',
					 iconCls: 'icon-query',
					 width	: 26,
					 height	: 26,
					 itemId	: 'sub_query3',
					 handler: function() {
						//if( me._needSave()) {
						var toolbar	= electroInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save3').isDisabled();
						var record	= masterGrid.getSelectedRecord();
						if(needSave) {
								Ext.Msg.show({
									title:'<t:message code="system.label.base.confirm" default="확인"/>',
									msg: Msg.sMB017 + "\n" + Msg.sMB061,
									buttons: Ext.Msg.YESNOCANCEL,
									icon: Ext.Msg.QUESTION,
									fn: function(res) {
										//console.log(res);
										if (res === 'yes' ) {
												var saveTask =Ext.create('Ext.util.DelayedTask', function(){
													 electroInfoStore.saveStore();
												});
												saveTask.delay(500);
										} else if(res === 'no') {
												electroInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
										}
									}
								});
						} else {
								electroInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
						}
					 }
				},{
					 xtype	: 'uniBaseButton',
					 text	: '<t:message code="system.label.base.reset" default="신규"/>',
					 tooltip: '<t:message code="system.label.base.reset2" default="초기화"/>',
					 iconCls: 'icon-reset',
					 width	: 26,
					 height	: 26,
					 itemId	: 'sub_reset3',
					 handler: function() {
						var toolbar	= electroInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save3').isDisabled();
						if(needSave) {
								Ext.Msg.show({
									title:'<t:message code="system.label.base.confirm" default="확인"/>',
									msg: Msg.sMB017 + "\n" + Msg.sMB061,
									buttons: Ext.Msg.YESNOCANCEL,
									icon: Ext.Msg.QUESTION,
									fn: function(res) {
										console.log(res);
										if (res === 'yes' ) {
												var saveTask =Ext.create('Ext.util.DelayedTask', function(){
													 electroInfoStore.saveStore();
												});
												saveTask.delay(500);
										} else if(res === 'no') {
												electroInfoGrid.reset();
												electroInfoStore.clearData();
												electroInfoStore.setToolbarButtons('sub_save3', false);
												electroInfoStore.setToolbarButtons('sub_delete3', false);
										}
									}
								});
						} else {
								electroInfoGrid.reset();
								electroInfoStore.clearData();
								electroInfoStore.setToolbarButtons('sub_save3', false);
								electroInfoStore.setToolbarButtons('sub_delete3', false);
						}
					 }
				},{
					 xtype	: 'uniBaseButton',
					 text	: '<t:message code="system.label.base.add" default="추가"/>',
					 tooltip: '<t:message code="system.label.base.add" default="추가"/>',
					 iconCls: 'icon-new',
					 width	: 26,
					 height	: 26,
					 itemId	: 'sub_newData3',
					 handler: function() {
						var record		= masterGrid.getSelectedRecord();
						var compCode	= UserInfo.compCode;
						var customCode	= record.get('CUSTOM_CODE');
						var seq			= electroInfoStore.max('SEQ');
						if(!seq){
								seq = 1;
						}else{
								seq += 1;
						}
						var r = {
								COMP_CODE	:	compCode,
								CUSTOM_CODE	:	customCode,
								SEQ			:	seq,
								BILL_TYPE	:	"1",
								MAIN_BILL_YN:	"Y"
						};
						electroInfoGrid.createRow(r);
					 }
				},{
					 xtype		: 'uniBaseButton',
					 text		: '<t:message code="system.label.base.delete" default="삭제"/>',
					 tooltip	: '<t:message code="system.label.base.delete" default="삭제"/>',
					 iconCls	: 'icon-delete',
					 disabled	: true,
					 width		: 26,
					 height		: 26,
					 itemId		: 'sub_delete3',
					 handler	: function() {
						var selRow = electroInfoGrid.getSelectedRecord();
						if(selRow.phantom === true) {
								electroInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
								electroInfoGrid.deleteSelectedRow();
						}
					 }
				},{
					 xtype		: 'uniBaseButton',
					 text		: '<t:message code="system.label.base.save" default="저장 "/>',
					 tooltip	: '<t:message code="system.label.base.save" default="저장 "/>',
					 iconCls	: 'icon-save',
					 disabled	: true,
					 width		: 26,
					 height		: 26,
					 itemId		: 'sub_save3',
					 handler	: function() {
						var inValidRecs = electroInfoStore.getInvalidRecords();
						if(inValidRecs.length == 0 )	 {
								var saveTask =Ext.create('Ext.util.DelayedTask', function(){
									 electroInfoStore.saveStore();
								});
								saveTask.delay(500);
						} else {
								electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					 }
				}]
		}],

		columns:[
				{ dataIndex: 'COMP_CODE'		, width: 80		,hidden:true},
				{ dataIndex: 'CUSTOM_CODE'		, width: 80		,hidden:true},
				{ dataIndex: 'SEQ'				, width: 60},
				{ dataIndex: 'PRSN_NAME'		, width: 100},
				{ dataIndex: 'DEPT_NAME'		, width: 100},
				{ dataIndex: 'HAND_PHON'		, width: 120},
				{ dataIndex: 'TELEPHONE_NUM1'	, width: 120},
				{ dataIndex: 'TELEPHONE_NUM2'	, width: 120},
				{ dataIndex: 'FAX_NUM'			, width: 100},
				{ dataIndex: 'MAIL_ID'			, width: 140},
				{ dataIndex: 'BILL_TYPE'		, width: 120},
				{ dataIndex: 'MAIN_BILL_YN'		, width: 150},
				{ dataIndex: 'REMARK'			, width: 100}
		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			}
		}
	});

	//품목 정보 관련 파일업로드
	Unilite.defineModel('itemInfoModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE'			,type: 'string'},
			//공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
			{name: 'FILE_TYPE'			,text: '<t:message code="system.label.base.classfication" default="구분"/>'				,type: 'string'		, allowBlank: false		, comboType: 'AU'	, comboCode: 'B702'},
			{name: 'MANAGE_NO'			,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'					,type: 'string'		, allowBlank: false},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'						,type: 'string'},
			{name: 'CERT_FILE'			,text: '<t:message code="system.label.base.filename" default="파일명"/>'					,type: 'string'},
			{name: 'FILE_ID'			,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'			,type: 'string'},
			{name: 'FILE_PATH'			,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'			,type: 'string'},
			{name: 'FILE_EXT'			,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'	,type: 'string'}
		]
	});
	var itemInfoStore = Unilite.createStore('itemInfoStore',{
		model	: 'itemInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},

		proxy: itemInfoProxy,

		loadStoreRecords : function(customCode){
			var param= Ext.getCmp('resultForm').getValues();
			param.CUSTOM_CODE = customCode;

			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			},
			load: function(store, records, successful, eOpts) {
				Ext.getCmp('detailForm').body.scrollTo('top', 0);
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable) {
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});
	var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
		store	: itemInfoStore,
		border	: true,
		height	: 180,
		width	: 865,
		padding	: '0 0 5 0',
		sortableColumns : false,
		excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				tooltip	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= masterGrid.getSelectedRecord();
					if (needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										itemInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
										itemInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
								}
							}
						});
					} else {
						itemInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset" default="신규"/>',
				tooltip	: '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
							Ext.Msg.show({
								title:'<t:message code="system.label.base.confirm" default="확인"/>',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
											var saveTask =Ext.create('Ext.util.DelayedTask', function(){
												itemInfoStore.saveStore();
											});
											saveTask.delay(500);
									} else if(res === 'no') {
											itemInfoGrid.reset();
											itemInfoStore.clearData();
											itemInfoStore.setToolbarButtons('sub_save4', false);
											itemInfoStore.setToolbarButtons('sub_delete4', false);
									}
								}
							});
					} else {
							itemInfoGrid.reset();
							itemInfoStore.clearData();
							itemInfoStore.setToolbarButtons('sub_save4', false);
							itemInfoStore.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					var record		= masterGrid.getSelectedRecord();
					var compCode	= UserInfo.compCode;
					var customCode	= record.get('CUSTOM_CODE');
					var r = {
						COMP_CODE		:	compCode,
						CUSTOM_CODE		:	customCode
					};
					itemInfoGrid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip		: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() {
					var selRow = itemInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							itemInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							itemInfoGrid.deleteSelectedRow();
						}
					} else {
						Unilite.messageBox(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip		: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var inValidRecs = itemInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							itemInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		}],

		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'CUSTOM_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'FILE_TYPE'			, width: 100 },
				{ dataIndex	: 'MANAGE_NO'			, width: 150},
				{ text		: '<t:message code="system.label.base.item" default="품목"/> <t:message code="system.label.base.relatedfile" default="관련파일"/>',
					columns:[
						{ dataIndex	: 'CERT_FILE'	, width: 230		, align: 'center'	,
							renderer: function (val, meta, record) {
								if (!Ext.isEmpty(record.data.CERT_FILE)) {
								  if(record.data.FILE_EXT == 'jpg' || record.data.FILE_EXT == 'png' || record.data.FILE_EXT == 'pdf'){
									  return '<font color = "blue" >' + val + '</font>';
								  }else{
									  var fileName = record.data.FILE_ID + '.' +  record.data.FILE_EXT;
									  var originFile = record.data.CERT_FILE;
									  var selItemCode = record.data.CUSTOM_CODE;
									  var manageNo = record.data.MANAGE_NO;
									  return  '<A href="'+ CHOST + CPATH + '/fileman/downloadItemFile/' + PGM_ID + '/' + selItemCode + '/' + manageNo  + '/false' + '">' + val + '</A>';
								  }
								} else {
									return '';
								}
							}
						},{
							text		: '',
							dataIndex	: 'REG_IMG',
							xtype		: 'actioncolumn',
							align		: 'center',
							padding		: '-2 0 2 0',
							width		: 30,
							items		: [{
								icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
								handler	: function(grid, rowIndex, colIndex, item, e, record) {
									itemInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}]
						}
					]
				},
				{ dataIndex	: 'REMARK'				, flex: 1	, minWidth: 30}/*,
				{
				  text		: '등록 버튼으로 구현 한 것',
				  align	: 'center',
				  width	: 50,
				  renderer	: function(value, meta, record) {
						var id = Ext.id();
						Ext.defer(function(){
							new Ext.Button({
								text	: '등록',
								margin	: '-2 0 2 0',
								handler : function(btn, e) {
									itemInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}).render(document.body, id);
						},50);
						return Ext.String.format('<div id="{0}"></div>', id);
					}
				}*/
		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {					//
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE'])){
						return false;
					}

				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 5 && !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadItemInfoImage/' + fid,
							prgID	: 'bpr300ukrv'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {

					}
				}
			}
		}
	});

	/** 상세 조회(Detail Form Panel)
	 * @type
	 */
	var detailForm = Unilite.createForm('detailForm', {
		masterGrid	: masterGrid,
		region		: 'center',
		flex		: 4,
		autoScroll	: true,
		border		: false,
		padding		: '0 0 0 1',
		defaults	: { padding: '10 15 15 10'},
		uniOpt:{
			store : masterStore
		},
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		defineEvent	: function(){
			var me = this;
			me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts ) {
				//var frm = Ext.getCmp('detailForm');
				if(me.getValue('CUSTOM_FULL_NAME') == "")
					me.setValue('CUSTOM_FULL_NAME',this.getValue());
			});
		},
		items : [<jsp:include page="${gsAutoCustomCode}" flush="false">
						<jsp:param name="aaa" value="bbb" />
					</jsp:include>
		{
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			defaultType	: 'uniTextfield',
			flex		: 1,
			defaults	: { labelWidth: 120},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 4
			},
			items :[{
				fieldLabel	: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
				name		: 'CUSTOM_CODE' ,
//				allowBlank	: false,
				readOnly	: true
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.businesstype2" default="법인/개인"/>',
				name		: 'BUSINESS_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B016'
			},{
				fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
				name		: 'CUSTOM_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B015' ,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.base.customabbreviationname" default="거래처(약명)"/>',
				name		: 'CUSTOM_NAME',
				allowBlank	: false,
				listenersX	:{blur : function(){
					var frm = Ext.getCmp('detailForm');
					if(frm.getValue('CUSTOM_FULL_NAME') == "")
						frm.setValue('CUSTOM_FULL_NAME',this.getValue());
				}}
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>',
				name		: 'COMPANY_NUM',
				listeners: {
					blur: function(field, event, eOpts ){
						if(field.lastValue != field.originalValue){
							var param = {
								'COMPANY_NUM':field.lastValue.replace(/-/gi,"")
							}
							bcm106ukrvService.checkCompanyNum(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									if(!Ext.isEmpty(provider.COMPANY_NUM)){
										if(!confirm("이미 존재하는 사업자번호 입니다."+"\n"+"그래도 저장하시겠습니까?")) {
											field.reset();
											return false;
										}
									}
								}
								field.originalValue = field.lastValue;
							})
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.businessconditions" default="업태"/>',
				name		: 'COMP_TYPE'
			},{
				fieldLabel	: '<t:message code="system.label.base.customabbreviationname1" default="거래처(약명1)"/>',
				name		: 'CUSTOM_NAME1'
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.representativename" default="대표자명"/>',
				name		: 'TOP_NAME'
			},{
				fieldLabel	: '<t:message code="system.label.base.businesstype" default="업종"/>',
				name		: 'COMP_CLASS'
			},{
				fieldLabel	: '<t:message code="system.label.base.customabbreviationname2" default="거래처(약명2)"/>',
				name		: 'CUSTOM_NAME2'
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>',
				name		: 'TOP_NUM_EXPOS',
				xtype		: 'uniTextfield',
				readOnly	: true,
				focusable	: false,
				listeners	: {
					afterrender:function(field) {
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick	: function(event, elm) {
					detailForm.openCryptRepreNoPopup();
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>',
				name		: 'TOP_NUM',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.base.clienttype" default="고객분류"/>',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '<t:message code="system.label.base.customfullname" default="거래처(전명)"/>',
				name		: 'CUSTOM_FULL_NAME',
				allowBlank	: false
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.area2" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				fieldLabel	: '<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>',
				name		: 'SERVANT_COMPANY_NUM',
				xtype		: 'uniTextfield',
				maxLength	: 4,
				listeners	: {
						blur: function( field, event, eOpts ) { 
							var newValue = field.getValue();
							// 숫자만 가능
							if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
						 		this.setValue('');
						 		return;
						 	}
							// 4자리보다 작을 경우
							if(field.value.length < 4) {
								// 빈값 0으로 세팅
								var strNewValue = newValue.length >= 4 ? newValue : new Array(4 - newValue.length+1).join('0') + newValue;
								this.setValue(strNewValue);
							}
						}
					}
			},{
				fieldLabel	: '<t:message code="system.label.base.transactionstartdate" default="거래시작일"/>',
				name		: 'START_DATE' ,
				xtype		: 'uniDatefield',
				allowBlank	: false
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '<t:message code="system.label.base.transactionbreakdate" default="거래중단일"/>',
				name		: 'STOP_DATE',
				xtype		: 'uniDatefield'
			},{
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name		: 'USE_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'Y' ,
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.base.businessnumberchangeflag" default="사업자번호변경여부"/>',
				name		: 'CUST_CHK',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.base.socialsecuritynumberchangeflag" default="주민번호변경여부"/>',
				name		: 'SSN_CHK', hidden:true
			}]
		 },{
			title		: '<t:message code="system.label.base.businessinformation" default="업무정보"/>',
			defaultType	: 'uniTextfield',
			flex		: 1,
			defaults	: { labelWidth: 120},
			//collapsible: true
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 3
			},

			items :[{
				fieldLabel	: '<t:message code="system.label.base.countrycode" default="국가코드"/>',
				name		: 'NATION_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B012',
				allowBlank: false
			},{
				fieldLabel	: '<t:message code="system.label.base.billtype" default="계산서유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A022'
			},{
				fieldLabel	: '<t:message code="system.label.base.creditloanamount2" default="여신(담보)액"/>',
				name		: 'TOT_CREDIT_AMT',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '<t:message code="system.label.base.basiscurrency" default="기준화폐"/>',
				name		: 'MONEY_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				allowBlank: false
			},{
				fieldLabel	: '<t:message code="system.label.base.payingmethod" default="결제방법"/>',
				name		: 'SET_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B038'
			},{
				fieldLabel	: '<t:message code="system.label.base.creditloanamount" default="신용여신액"/>',
				name		: 'CREDIT_AMT',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '<t:message code="system.label.base.taxincludedflag" default="세액포함여부"/>',
				name		: 'TAX_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B030',
				value		: '1' ,
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.base.paymentcondition" default="결제조건"/>',
				name		: 'RECEIPT_DAY',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B034'
			},{
				fieldLabel	: '<t:message code="system.label.base.creditloanduedate" default="신용여신만료일"/>',
				name		: 'CREDIT_YMD',
				xtype		: 'uniDatefield'
			},{
				fieldLabel	: '<t:message code="system.label.base.taxcalculationmethod" default="세액계산법"/>',
				name		: 'TAX_CALC_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B051',
				//20200106 수정: 기본값 "개별"
				value		: '2',
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.base.closingtype" default="마감종류"/>',
				name		: 'TRANS_CLOSE_DAY',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B033'
			},{
				fieldLabel	: '<t:message code="system.label.base.armanagemethod" default="미수관리방법"/>',
				name		: 'COLLECT_CARE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B057'
			},{
				fieldLabel	: '<t:message code="system.label.base.decimalcalculation" default="원미만계산"/>',
				name		: 'WON_CALC_BAS',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B017'
			},{
				fieldLabel	: '<t:message code="system.label.base.plandcollectiondate" default="수금(예정)일"/>',
				name		: 'COLLECT_DAY',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '<t:message code="system.label.base.mainsalescharge" default="주영업담당"/>',
				name		: 'BUSI_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				fieldLabel	: '<t:message code="system.label.base.taxrate" default="세율"/>',
				name		: 'VAT_RATE',
				xtype		: 'uniNumberfield',
				suffixTpl	: '&nbsp;%'
			},{
				fieldLabel	: '<t:message code="system.label.base.creditapplyyn" default="여신적용여부"/>',
				name		: 'CREDIT_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'N',
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.base.calendartype" default="카렌더 타입"/>',
				name		: 'CAL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B062'
			},
			Unilite.popup('DEPT',{
				fieldLabel		: '<t:message code="system.label.base.relateddepartments" default="관련부서"/>',
				textFieldName	: 'DEPT_NAME',
				valueFieldName	: 'DEPT_CODE',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				valueFieldWidth	: 57,
				textFieldWidth	: 110,
				listeners		: {
					'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
					},
					'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('DEPT_NAME','');
							grdRecord.set('DEPT_CODE','');
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.electronicdocumentcharger" default="전자문서담당자"/>'+'2',
				name		: 'BILL_PRSN2',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.base.electronicdocumencellphone" default="전자문서핸드폰"/>'+'2',
				name		: 'HAND_PHON2',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.base.electronicdocumentemail" default="전자문서Email"/>'+'2',
				name		: 'BILL_MAIL_ID2'
			},{
				fieldLabel	: '<t:message code="system.label.base.electronicdocumentdivision" default="전자문서구분"/>',
				name		: 'BILL_MEM_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S051'
			},{
				fieldLabel	: '<t:message code="system.label.base.regularpaymentflag" default="정기결제여부"/>',
				name		: 'R_PAYMENT_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'N',
				width		: 250,
				allowBlank	: false
			},/* {
				xtype: 'component'
			},{
				xtype: 'component'
			}, */{
				fieldLabel	: '<t:message code="system.label.base.transportmethod" default="운송방법"/>',
				name		: 'DELIVERY_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B260'
			 },{//20200224 추가: "전자세금계산서 발행유형"
				fieldLabel	: '<t:message code="system.label.sales.electronicbillissue" default="전자세금계산서 발행"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.issue2" default="정발행"/>',
					name		: 'BILL_PUBLISH_TYPE',
					inputValue	: '1',
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.backissue" default="역발행"/>',
					name		: 'BILL_PUBLISH_TYPE',
					inputValue	: '2',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.base.generalinfo" default="일반정보"/>',
			flex		: 1,
			defaultType	: 'uniTextfield',
			defaults	: { labelWidth: 120},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 3
			},
			items :[
				Unilite.popup('ZIP',{
					showValue		: false,
					textFieldName	: 'ZIP_CODE',
					DBtextFieldName	: 'ZIP_CODE',
					popupHeight		: 567,
					listeners		: {
						'onSelected': {fn: function(records, type){
							var frm = Ext.getCmp('detailForm');
							frm.setValue('ADDR1', records[0]['ZIP_NAME']);
							frm.setValue('ADDR2', records[0]['ADDR2']);
							//console.log("(records[0]['ZIP_CODE1_NAME'] : ", records[0]['ZIP_CODE1_NAME']);
							//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
						},
						scope: this
						},
						'onClear' : function(type) {
							var frm = Ext.getCmp('detailForm');
							frm.setValue('ADDR1', '');
							frm.setValue('ADDR2', '');
						}
					}
			}),{
				fieldLabel	: '<t:message code="system.label.base.homepage" default="홈페이지"/>',
				name		: 'HTTP_ADDR',
				labelWidth	: 138
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.base.summarycustom" default="집계거래처"/>', /* id:'MANAGE_CUSTOM', */
				valueFieldName	: 'MANAGE_CUSTOM',
				textFieldName	: 'MCUSTOM_NAME',
				DBvalueFieldName: 'CUSTOM_CODE',
				DBtextFieldName	: 'CUSTOM_NAME',
				valueFieldWidth	: 50,
				textFieldWidth	: 100,
				labelWidth		: 138,
				listeners		: {
					'onSelected': function(records, type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
						grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
					},
					'onClear':function( type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('MANAGE_CUSTOM','');
						grdRecord.set('MCUSTOM_NAME','');
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.mailingaddress" default="우편주소"/>',
				name		: 'ADDR1' ,
				id			: 'ADDR1_F'
			},{
				fieldLabel	: '<t:message code="system.label.base.emailaddr" default="이메일주소"/>',
				name		: 'MAIL_ID',
				labelWidth	: 138
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.base.collectioncustomer" default="수금거래처"/>',
				valueFieldName	: 'COLLECTOR_CP',
				textFieldName	: 'COLLECTOR_CP_NAME',
				DBvalueFieldName: 'CUSTOM_CODE',
				DBtextFieldName	: 'CUSTOM_NAME',
				valueFieldWidth	: 50,
				textFieldWidth	: 100,
				labelWidth		: 138,
				listeners		: {
					'onSelected': function(records, type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
						grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
					},
					'onClear':function( type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('COLLECTOR_CP','');
						grdRecord.set('COLLECTOR_CP_NAME','');
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.addressdetail" default="상세주소"/>',
				name		: 'ADDR2',
				id			: 'ADDR2_F'
			},
			Unilite.popup('BANK',{
				fieldLabel		: '<t:message code="system.label.base.financialinstitution" default="금융기관"/>',
				id				: 'BANK_CODE',
				valueFieldName	: 'BANK_CODE',
				textFieldName	: 'BANK_NAME' ,
				DBvalueFieldName: 'BANK_CODE',
				DBtextFieldName	: 'BANK_NAME',
				valueFieldWidth	: 50,
				textFieldWidth	: 100,
				labelWidth		: 138,
				listeners		: {
					'onSelected': function(records, type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
						grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
					},
					'onClear':function( type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('BANK_CODE','');
						grdRecord.set('BANK_NAME','');
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.base.billcustom" default="계산서거래처"/>',
				id				: 'BILL_CUSTOM',
				valueFieldName	: 'BILL_CUSTOM',
				textFieldName	: 'BILL_CUSTOM_NAME' ,
				DBvalueFieldName: 'CUSTOM_CODE',
				DBtextFieldName	: 'CUSTOM_NAME',
				valueFieldWidth	: 50,
				textFieldWidth	: 100,
				labelWidth		: 138,
				listeners		: {
					'onSelected': function(records, type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
						grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					},
					'onClear':function( type){
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('BILL_CUSTOM','');
						grdRecord.set('BILL_CUSTOM_NAME','');
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.phoneno" default="전화번호"/>',
				name		: 'TELEPHON'
			},{
				fieldLabel	: '<t:message code="system.label.base.faxnumber" default="FAX번호"/>',
				name		: 'FAX_NUM',
				labelWidth	: 138/*,	//20200123 주석
				colspan		: 2*/
			},{
				fieldLabel	: '거래처영업담당자',
				name		: 'CUSTOM_SALE_PRSN',
				labelWidth	: 138
			},{
				fieldLabel	: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>',
				name		: 'BANKBOOK_NUM_EXPOS',
				readOnly	: true,
				focusable	: false,
				listeners	: {
					afterrender:function(field) {
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick	: function(event, elm) {
					detailForm.openCryptBankAccntPopup();
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>',
				name		: 'BANKBOOK_NUM',
				xtype		: 'uniTextfield',
				maxLength	: 50,
				labelWidth	: 138,
				hidden		: true				//20210202 수정: false -> true
			},{
				fieldLabel	: '<t:message code="system.label.base.accountholder" default="예금주"/>',
				name		: 'BANKBOOK_NAME',
				labelWidth	: 138,
				//colspan		: 2,
				hidden		: false
			},{	//20200123 추가
				fieldLabel	: '<t:message code="system.label.base.interfacecode" default="인터페이스코드"/>',
				name		: 'OLD_CUSTOM_CODE',
				labelWidth	: 138
			},{
				fieldLabel	: '<t:message code="system.label.base.remarks" default="비고"/>',
				name		: 'REMARK',
				xtype		: 'textarea',
				width		: 902,
				height		: 80,
				colspan		: 3
			}]
		 },{
			title		: '무역정보',
			flex		: 1,
			defaultType	: 'uniTextfield',
			defaults	: { labelWidth: 120},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 3
			},
			items		: [{
				layout	: {type:'uniTable', column:2},
				xtype	: 'container',
				defaults: {holdable: 'hold'},
				items	: [{
						fieldLabel	: '<t:message code="system.label.base.paymentcondition" default="결제조건"/>',
						name		: 'PAY_TERMS',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'T006',
						allowBlank	: true,
						labelWidth	: 120
					},{
						xtype		: 'uniNumberfield',
						name		: 'PAY_DURING',
						suffixTpl	: 'Days',
						width		: 80
					}
				]
			},{
				fieldLabel	: '<t:message code="system.label.base.payingmethod" default="대금결제방법"/>',
				name		: 'PAY_METHODE1',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T016',
				allowBlank	: true
			},{
				fieldLabel	: '<t:message code="system.label.base.pricecondition" default="가격조건"/>',
				name		: 'TERMS_PRICE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T005',
				allowBlank	: true
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.base.agent" default="대행자"/>',
				valueFieldName	: 'AGENT_CODE',
				textFieldName	: 'AGENT_NAME',
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.transportmethod" default="운송방법"/>',
				name		: 'METH_CARRY',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T004'
			},{
				fieldLabel	: '<t:message code="system.label.base.packingmethod" default="포장방법"/>',
				name		: 'COND_PACKING',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T010'
			},{
				fieldLabel	: '<t:message code="system.label.base.inspecmethod" default="검사방법"/>',
				name		: 'METH_INSPECT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T011'
			},{
				fieldLabel	: '<t:message code="system.label.base.shipmentport" default="선적항"/>',
				name		: 'SHIP_PORT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T008'
			},{
				fieldLabel	: '<t:message code="system.label.base.arrivalport" default="도착항"/>',
				name		: 'DEST_PORT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T008'
			}]
		},{
			title		: '<t:message code="system.label.base.accountinformation" default="계좌정보"/>',
			defaultType	: 'uniTextfield',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign:'top'},
				columns	: 3
			},
			items		: [accountGrid]
		 },{
			title		: '<t:message code="system.label.base.electronicdocumentinfo" default="전자문서정보"/>',
			defaultType	: 'uniTextfield',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign:'top'},
				columns	: 3
			},
			items		: [electroInfoGrid]
		},{
			title	: '<t:message code="system.label.base.referfile" default="관련파일"/>',
			xtype	: 'panel',
//			xtype	: 'uniFieldset',
			width	: '100%',
			colspan	: 3,
			height	: 200,
			padding	: '0 5 20 5',
			items	: [itemInfoGrid]
		}],
		listeners:{
			hide:function() {
				masterGrid.show();
				if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
					panelResult.show();
				}
			}
		},
		openCryptBankAccntPopup:function() {
			var record = this;
			var params = {'BANK_ACCOUNT': this.getValue('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('form', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
		},
		openCryptRepreNoPopup:function() {
			var record = this;
			var params = {'REPRE_NUM':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
			Unilite.popupCipherComm('form', record, 'TOP_NUM_EXPOS', 'TOP_NUM', params);
		}
	}); // detailForm


	var tab = Unilite.createTabPanel('bcm106ukrvTab',{
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '<t:message code="system.label.base.default" default="기본"/>',
				xtype	: 'container',
				itemId	: 'bcm106ukrvTab1',
				border	: true,
				layout	: 'border',
				items	: [
					masterGrid, detailForm
				]
			},{
				title	: '<t:message code="system.label.base.whole" default="전체"/>',
				xtype	: 'container',
				itemId	: 'bcm106ukrvTab2',
				border	: true,
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts ) {
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 'hpa100skrTab1') {
				} else {
				}
			}
		}
	});



	Unilite.Main({
		id		: 'bcm106ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, panelResult, tab
			]
		}],
		fnInitBinding : function(params) {
			if(BsaCodeInfo.gsHiddenField == 'Y'){
				detailForm.getField('BANKBOOK_NAME').setHidden(true);
				detailForm.getField('BANKBOOK_NUM_EXPOS').setHidden(true);
			}else{
				detailForm.getField('BANKBOOK_NAME').setHidden(false);
				detailForm.getField('BANKBOOK_NUM_EXPOS').setHidden(false);
			}
			detailForm.setValue('BILL_PUBLISH_TYPE'	, '1');						//20200224 추가: 전자세금계산서 발행유형 추가
			detailForm.setValue('VAT_RATE'			, BsaCodeInfo.gsVatRate);	//20210514 추가: 부가세 가져오는 로직 추가

			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE'	, params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
			if(Ext.getCmp('autoCustomCodeFieldset').items.length == 0){
				Ext.getCmp('autoCustomCodeFieldset').setHidden(true);
			}
		},
		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('bcm106ukrvGrid');
			masterGrid.downloadExcelXml();
		},
		onQueryButtonDown : function() {
//			detailForm.clearForm ();
			masterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			//20210224 추가: 국가코드 기본값 설정
			var nationCodes	= Ext.data.StoreManager.lookup('CBS_AU_B012').data.items;
			var nationCode	= '';
			Ext.each(nationCodes,function(record, i) {
				if(record.get('refCode1') == 'Y') {
					nationCode = record.get('value');
				}
			})
			//20210224 추가: 기준화폐 기본값 설정
			var moneyUnits	= Ext.data.StoreManager.lookup('CBS_AU_B004').data.items;
			var moneyUnit	= '';
			Ext.each(moneyUnits,function(record2, i) {
				if(record2.get('refCode1') == 'Y') {
					moneyUnit = record2.get('value');
				}
			})

			var r = {
				DIV_CODE	: UserInfo.divCode,
				NATION_CODE	: nationCode,				//20210224 추가
				MONEY_UNIT	: moneyUnit,				//20210224 추가
				VAT_RATE	: BsaCodeInfo.gsVatRate		//20210514 추가: 부가세 가져오는 로직 추가
			};
			masterGrid.createRow(r);
			if(BsaCodeInfo.GetAutoCustomCodeYN) {
				detailForm.getField('CUSTOM_CODE').setReadOnly(true);
			} else {
				detailForm.getField('CUSTOM_CODE').setReadOnly(false);
			}
			Ext.each( Ext.getCmp('autoCustomCodeFieldset').query('field'), function(field) {
				field.reset();
			});
			Ext.getCmp('itemInfoGrid').enable();
//			openDetailWindow(null, true);
		},
		onPrevDataButtonDown:function() {
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:function() {
			masterGrid.selectNextRow();
		},
		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!detailForm.getInvalidMessage()) {
				return false;
			}
			masterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				masterGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailForm.clearForm();
			//20200224 추가: 전자세금계산서 발행유형 추가
			detailForm.setValue('BILL_PUBLISH_TYPE', '1');
			Ext.getCmp('autoCustomCodeFieldset').setHidden(true);
			Ext.getCmp('itemInfoGrid').disable();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function() {
			masterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		},
		confirmSaveData: function() {
			if(masterStore.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
			}
		}
	});	// Main

	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= itemInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			CUSTOM_CODE	: record.data.CUSTOM_CODE,
			MANAGE_NO	: record.data.MANAGE_NO,
			FILE_TYPE	: record.data.FILE_TYPE
		}

		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action) {
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}
	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.file" default="파일"/> <t:message code="system.label.base.entry" default="등록"/>',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm,
					{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: bcm106ukrvService.photoUploadFile
						},
						items		:[{
							xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.file" default="파일"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts) {
						var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= itemInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
								Unilite.messageBox('<t:message code="system.message.human.message002" default="필수입력사항을 입력하신 후 사진을 올려주세요."/>');
								return false;
							}
						} else {
							if (Ext.isEmpty(record)) {
								Unilite.messageBox('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
								return false;
							}
						}
					},
					show: function( window, eOpts) {
						window.center();
					}
				},
				afterSuccess: function() {
					var record	= masterGrid.getSelectedRecord();
					itemInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					this.afterSavePhoto();
				},
				afterSavePhoto: function() {
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function() {
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );

						/* if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							Unilite.messageBox('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						} */

						if(needSave) {
							gsNeedPhotoSave = needSave;
							itemInfoStore.saveStore();
						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function() {
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty()) {
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?')) {
//								var config = {
//									success : function() {
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}
	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: bcm106ukrvService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});
	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadItemInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
				}]
			}],
			listeners : {
				beforeshow: function( window, eOpts) {
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts) {
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					});
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function() {
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}
	Unilite.createValidator('validator01', {
		store : masterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName=='CUSTOM_CODE') {
				Ext.getBody().mask();
				var param = {
					'CUSTOM_CODE':newValue
				}
				var currentRecord = record;
				bcm106ukrvService.chkPK(param, function(provider, response) {
					Ext.getBody().unmask();
					console.log('provider', provider);
					if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
						Unilite.messageBox(Msg.fSbMsgZ0049);
						currentRecord.set('CUSTOM_CODE','');
					}
				});
			} else if( fieldName == 'CUSTOM_NAME' ) {		// 거래처(약명)
				if(newValue == '') {
					rv = Msg.sMB083;
				}else {
					if(record.get('CUSTOM_FULL_NAME') == '') {
						record.set('CUSTOM_FULL_NAME',newValue);
					}
				}
			} else if( fieldName == 'COMPANY_NUM') {		// '사업자번호'
				 record.set('CUST_CHK','T');
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) ) {
				 	// 10 자리인경에만 가능하도록
				 	if(newValue.trim().replace(/-/g,'').length !=10){
				 		Unilite.messageBox('사업자번호 10자리를 입력해주세요.');
				 		rv = false;
				 	} else {
						if(Unilite.validate('bizno', newValue) != true) {
							if(!confirm(Msg.sMB173+"\n"+Msg.sMB175)) {
								rv = false;
							}
						}else {
							newValue = newValue.replace(/-/g,'');
							var v = newValue.substring(0,3)+ "-"+ newValue.substring(3,5)+"-" + newValue.substring(5,10);
							if(type == 'grid') {
								e.cancel=true;
								record.set(fieldName, v);
							}else {
								editor.setValue(v);
							}
						}
				 	}
				}
			} /*else if( fieldName == 'TOP_NUM') {		// '주민번호'
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) ) {
					if(Unilite.validate('residentno', newValue) != true) {
						if(!confirm(Msg.sMB174+"\n"+Msg.sMB176)) {
							rv = false;
						}
					}else {
						newValue = newValue.replace(/-/g,'');
						var v = newValue.substring(0,6)+ "-"+ newValue.substring(6,13);
						if(type == 'grid') {
							e.cancel=true;
							record.set(fieldName, v);
						}else {
							editor.setValue(v);
						}
					}
				 }
			}*/ else if( fieldName == "MONEY_UNIT") {			// 기준화폐
				if(UserInfo.currency == newValue) {
					record.set('CREDIT_YN', 'Y');
				}else {
					record.set('CREDIT_YN', 'N');
				}
			} else if( fieldName == "CREDIT_YN" ) {			// 여신적용여부
				if(UserInfo.currency != record.get("MONEY_UNIT")) {
					console.log('GRID CREDIT_YN BLUR');
					if("Y" == newValue ) {
						record.set('CREDIT_YN','N');
						rv = Msg.sMB217;
					}
				}
			} else if( fieldName == "VAT_RATE" ) {			// 세율
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName == "TOT_CREDIT_AMT") {		// 여신(담보)액
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName == "COLLECT_DAY") {
				if(newValue < 1 || newValue > 31 ) {
					rv = Msg.sMB210;
				}
			}
			return rv;
		}
	}); // validator
	
	
	Unilite.createValidator('validator02', {
		store : masterStore,
		grid: masterGrid2,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {

			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			 if( fieldName == 'COMPANY_NUM') {		// '사업자번호'
				 record.set('CUST_CHK','T');
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) ) {
				 	// 10 자리인경에만 가능하도록
				 	if(newValue.trim().replace(/-/g,'').length !=10){
				 		Unilite.messageBox('사업자번호 10자리를 입력해주세요.');
				 		rv = false;
				 	} else {
						if(Unilite.validate('bizno', newValue) != true) {
							if(!confirm(Msg.sMB173+"\n"+Msg.sMB175)) {
								rv = false;
							}
						}else {
							newValue = newValue.replace(/-/g,'');
							var v = newValue.substring(0,3)+ "-"+ newValue.substring(3,5)+"-" + newValue.substring(5,10);
							if(type == 'grid') {
								e.cancel=true;
								record.set(fieldName, v);
							}else {
								editor.setValue(v);
							}
						}
				 	}
				}
			}	
			return rv;
		}
	});
	
	
}; // main
</script>