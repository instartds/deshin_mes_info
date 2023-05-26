<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb700ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb700ukr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A170" />			<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A171" opts='${gsListA171}' /> 		<!-- 문서서식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A174"  /> 		<!-- 세부구분항목 -->
	<t:ExtComboStore comboType="AU" comboCode="A172"  /> 		<!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="A173"  /> 		<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"  /> 		<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A070"  /> 		<!-- 불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"  /> 		<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="A182"  /> 		<!-- 세부구분적요 -->
	<t:ExtComboStore comboType="AU" comboCode="A210"  /> 		<!-- 지급처구분 -->
										
	<t:ExtComboStore comboType="AU" comboCode="H032"  /> 		<!-- (급여공제) 지급구분 -->
	<t:ExtComboStore comboType="CBM600" comboCode="0"  /> 		<!-- (급여공제) Cost Pool(사업명)-->
	<t:ExtComboStore comboType="AU" comboCode="H181"  /> 		<!-- (급여공제) 사원그룹-->
	<t:ExtComboStore comboType="AU" comboCode="H173"  /> 		<!-- (급여공제) 직렬-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
	var referCorporationCardWindow;	//법인카드승인참조
	var referDraftNoWindow;	//예산기안참조
	var referPayDtlNoWindow;	//지급명세서참조
	var popDedAmtWindow;	//급여공제
	
	var budgNameList = ${budgNameList};
	var budgNameListLength = budgNameList.length;

	var useColList1 = ${useColList1};
	var useColList2 = ${useColList2};
	
var	gsAmtPoint ='${gsAmtPoint}';

var gsIdMapping   = '${gsIdMapping}';
var gsLinkedGW    = '${gsLinkedGW}';
var gsDraftRef    = '${gsDraftRef}';
var gsDtlMaxRows  = '${gsDtlMaxRows}';
var gsContents    = '${gsContents}';
var gsMultiCode   = '${gsMultiCode}';
var gsTotAmtIn    = '${gsTotAmtIn}';
var gsAppBtnUse   = '${gsAppBtnUse}';
var gsPendCodeYN  = '${gsPendCodeYN}';
var gsCrdtRef     = '${gsCrdtRef}';
var gsPayDtlRef   = '${gsPayDtlRef}';
	
var gsAccntGubun  = '${gsAccntGubun}';

var gsChargeCode  = '${gsChargeCode}';
var gsChargeDivi  = '${gsChargeDivi}';
	
var gsDrafter = '${gsDrafter}';
var gsDrafterNm = '${gsDrafterNm}';
var gsDeptCode = '${gsDeptCode}';
var gsDeptName = '${gsDeptName}';
var gsDivCode = '${gsDivCode}';

var gsAmender  = '${gsAmender}';
	
var gsBizRemark  = '${gsBizRemark}';
var gsBizGubun  = '${gsBizGubun}';

var gsPayDtlLinkedPgmID  = '${gsPayDtlLinkedPgmID}';
	
var gsPathInfo1 = '${gsPathInfo1}';
var gsPathInfo2 = '${gsPathInfo2}';
var gsPathInfo3 = '${gsPathInfo3}';
	
var gsBizGubunName  = '${gsBizGubunName}';

var gsAppBtnUser  = '${gsAppBtnUser}';
	

var gsCommonA171_Ref6 = "";
var gsExistYN = "";

var gsCrdtSetDate = "";

var saveSuccessCheck = "";	

var pendCode = "";
	
var budgPossAmt = 0;

var pendCodeNewValue = '';
var payCustomCodeNewValue = '';
var payCustomNameNewValue = '';

var supplyAmtINewValue = '';

var taxAmtINewValue = '';
var addReduceAmtINewValue = '';

var conditionCheck = '';
var firstRecord;

var checkMasterOnly = '';

var gsDraftSeq = '';
var gsDraftBudgCode = '';

function appMain() {
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb700ukrService.selectDetail',
			update: 'afb700ukrService.updateDetail',
			create: 'afb700ukrService.insertDetail',
			destroy: 'afb700ukrService.deleteDetail',
//			syncAll: checkMasterOnly == 'Y' ? 'afb700ukrService.syncMaster' : 'afb700ukrService.saveAll'
			syncAll: 'afb700ukrService.saveAll'
		}
	});	
	
	var directProxyDedAmt = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb700ukrService.selectDedAmtDetailList',
			update: 'afb700ukrService.updateDedAmtDetail',
			create: 'afb700ukrService.insertDedAmtDetail',
			destroy: 'afb700ukrService.deleteDedAmtDetail',
			syncAll: 'afb700ukrService.saveDedAmt'
		}
	});	
	
	Unilite.defineModel('Afb700ukrSubModel', {
		fields:fields
	});	
	  
	Unilite.defineModel('Afb700ukrModel', {
		fields: [  	  
			{name: 'COMP_CODE'     		, text: 'COMP_CODE' 		,type: 'string'},
	   	 	{name: 'PAY_DRAFT_NO'     	, text: 'PAY_DRAFT_NO' 		,type: 'string'},
	   	 	{name: 'SEQ'     			, text: '순번' 				,type: 'uniNumber'},
	   	 	{name: 'BUDG_GUBUN'     	, text: '예산구분' 			,type: 'string'},
	   	 	{name: 'BUDG_CODE'     		, text: '예산코드' 			,type: 'string',allowBlank:false},
	   	 	{name: 'BUDG_NAME'     		, text: '예산명' 				,type: 'string',allowBlank:false},
	   	 	{name: 'PJT_CODE'     		, text: '프로젝트코드' 			,type: 'string'},
	   	 	{name: 'PJT_NAME'     		, text: '프로젝트명' 			,type: 'string'},
	   	 	{name: 'SAVE_CODE'     		, text: '출금통장코드' 			,type: 'string'},
	   	 	{name: 'SAVE_NAME'     		, text: '출금계좌' 			,type: 'string'},
	   	 	{name: 'BANK_ACCOUNT'     	, text: '출금계좌번호' 			,type: 'string'},
	   	 	{name: 'BUDG_POSS_AMT'     	, text: '예산사용가능금액' 		,type: 'uniPrice'},
	   	 	{name: 'BIZ_REMARK'     	, text: '세부구분적요' 			,type: 'string',comboType:'AU', comboCode:'A182',allowBlank:false},
	   	 	{name: 'BIZ_GUBUN'     		, text: '부서구분'/*'sBizGubun(추후 수정)'*/ 	,type: 'string',comboType:'AU', comboCode:'A174',allowBlank:false},
	   	 	{name: 'BIZ_GUBUN_REF' 	    , text: '세부구분항목REF' 		,type: 'string'},
	   	 	{name: 'PAY_DIVI'     		, text: '결제방법' 			,type: 'string',comboType:'AU', comboCode:'A172',allowBlank:false},
	   	 	{name: 'PAY_DIVI_REF1'     	, text: '결제방법REF1' 		,type: 'string'},
	   	 	{name: 'PAY_DIVI_REF2'     	, text: '결제방법REF2' 		,type: 'string'},
	   	 	{name: 'PAY_DIVI_REF3'     	, text: '결제방법REF3' 		,type: 'string'},
	   	 	{name: 'PAY_DIVI_REF4'     	, text: '결제방법REF4' 		,type: 'string'},
	   	 	{name: 'PROOF_DIVI'     	, text: '증빙구분' 			,type: 'string',comboType:'AU', comboCode:'A173'},
	   	 	{name: 'PROOF_KIND'			, text: '증빙구분REF1' 		,type: 'string'},
	   	 	{name: 'REASON_ESS'     	, text: '증빙구분REF2' 		,type: 'string'},
	   	 	{name: 'PROOF_TYPE'     	, text: '증빙구분REF3' 		,type: 'string'},
	   	 	{name: 'CUSTOM_ESS'     	, text: '증빙구분REF5' 		,type: 'string'},
	   	 	{name: 'DEFAULT_EB'     	, text: '증빙구분REF6' 		,type: 'string'},
	   	 	{name: 'DEFAULT_REASON'     , text: '증빙구분REF7' 		,type: 'string'},
	   	 	{name: 'SUPPLY_AMT_I'     	, text: '공급가액' 			,type: 'uniPrice',allowBlank:false,maxLength:32},
	   	 	{name: 'TAX_AMT_I'     		, text: '세액' 				,type: 'uniPrice',maxLength:32},
	   	 	{name: 'ADD_REDUCE_AMT_I'   , text: '증가/차감액' 			,type: 'uniPrice',maxLength:32},
	   	 	{name: 'TOT_AMT_I'     		, text: '지급액' 				,type: 'uniPrice',maxLength:32},
	   	 	{name: 'PEND_CODE'     		, text: '지급처구분' 			,type: 'string',comboType:'AU', comboCode:'A210',allowBlank:false},
	   	 	{name: 'PEND_CODE_REF1'     , text: '지급처REF1' 			,type: 'string'},
	   	 	{name: 'PAY_CUSTOM_CODE'    , text: '지급처코드' 			,type: 'string'},
	   	 	{name: 'PAY_CUSTOM_NAME'    , text: '지급처명' 			,type: 'string'},
	   	 	{name: 'CUSTOM_CODE'     	, text: '거래처코드' 			,type: 'string'},
	   	 	{name: 'CUSTOM_NAME'     	, text: '거래처명' 			,type: 'string'},
	   	 	{name: 'AGENT_TYPE'     	, text: '거래처분류' 			,type: 'string',comboType:'AU', comboCode:'B055'},
	   	 	{name: 'IN_BANK_CODE'     	, text: '입금은행코드' 			,type: 'string'},
	   	 	{name: 'IN_BANK_NAME'     	, text: '입급은행명' 			,type: 'string'},
	   	 	{name: 'IN_BANKBOOK_NUM'    , text: '입금계좌' 			,type: 'string'},
	   	 	{name: 'IN_BANKBOOK_NAME'   , text: '예금주명' 			,type: 'string'},
	   	 	{name: 'INC_AMT_I'     		, text: '소득세' 				,type: 'uniPrice',maxLength:32},
	   	 	{name: 'LOC_AMT_I'     		, text: '주민세' 				,type: 'uniPrice',maxLength:32},
	   	 	{name: 'REAL_AMT_I'     	, text: '실지급액' 			,type: 'uniPrice'},
	   	 	{name: 'REMARK'     		, text: '적요' 				,type: 'string'},
	   	 	{name: 'EB_YN'     			, text: '전자세금</br>계산서발행' ,type: 'string',comboType:'AU', comboCode:'A149'},
	   	 	{name: 'CRDT_NUM'     		, text: '카드코드' 			,type: 'string',maxLength:20},
	   	 	{name: 'CRDT_FULL_NUM'     	, text: '법인카드' 			,type: 'string',maxLength:255},
	   	 	{name: 'APP_NUM'     		, text: '현금영수증' 			,type: 'string',maxLength:20},
	   	 	{name: 'SEND_DATE'     		, text: '지급예정일' 			,type: 'uniDate'},
	   	 	{name: 'BILL_DATE'     		, text: '계산서일/</br>카드승인일' ,type: 'uniDate'},
	   	 	{name: 'ACCNT'     			, text: '계정코드' 			,type: 'string',allowBlank:false},
	   	 	{name: 'ACCNT_NAME'     	, text: '계정명' 				,type: 'string'},
	   	 	{name: 'REASON_CODE'     	, text: '불공제사유' 			,type: 'string',comboType:'AU', comboCode:'A070'},
	   	 	{name: 'DEPT_CODE'     		, text: '귀속부서' 			,type: 'string'},
	   	 	{name: 'DEPT_NAME'     		, text: '귀속부서명' 			,type: 'string'},
	   	 	{name: 'DIV_CODE'     		, text: '귀속사업장' 			,type: 'string'},
	   	 	{name: 'REFER_NUM'     		, text: '법인카드승인참조번호' 	,type: 'string'},
	   	 	{name: 'CANCEL_YN'     		, text: '승인취소' 			,type: 'string'},
	   	 	{name: 'DRAFT_NO'     		, text: '예산기안번호' 			,type: 'string'},
	   	 	{name: 'DRAFT_SEQ'     		, text: '예산기안순번' 			,type: 'int'},
	   	 	{name: 'BUDG_NAME_4'     	, text: 'BUDG_NAME_4' 		,type: 'string'},
	   	 	{name: 'INSERT_DB_USER'     , text: 'INSERT_DB_USER' 	,type: 'string'},
	   	 	{name: 'INSERT_DB_TIME'     , text: 'INSERT_DB_TIME' 	,type: 'string'},
	   	 	{name: 'UPDATE_DB_USER'     , text: 'UPDATE_DB_USER' 	,type: 'string'},
	   	 	{name: 'UPDATE_DB_TIME'     , text: 'UPDATE_DB_TIME' 	,type: 'string'}
		]
	});	
	
	Unilite.defineModel('afb700ukrRef1Model', {	//법인카드승인참조 
	    fields: [
			{name: 'CRDT_COMP_CD'		,text: '카드사코드'			,type: 'string'},
			{name: 'CRDT_COMP_NM'		,text: '카드사'			,type: 'string'},
			{name: 'CRDT_NUM'			,text: '카드코드'			,type: 'string'},
			{name: 'CRDT_FULL_NUM'		,text: '카드번호'			,type: 'string'},
			{name: 'APPR_DATE'			,text: '승인일'			,type: 'string'},
			{name: 'CHAIN_NAME'			,text: '가맹점명'			,type: 'string'},
			{name: 'CHAIN_ID'			,text: '가맹점사업자번호'		,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'			,type: 'string'},
			{name: 'APPR_AMT_I'			,text: '승인금액'			,type: 'string'},
			{name: 'APPR_TAX_I'			,text: '부가세'			,type: 'string'},
			{name: 'APPR_NO'			,text: '승인번호'			,type: 'string'},
			{name: 'DEDUCT_YN'			,text: '공제대상여부'		,type: 'string'},
			{name: 'PAY_DIVI'			,text: '결제방법'			,type: 'string'},
			{name: 'PAY_CUSTOM_CODE'	,text: '지급처코드'			,type: 'string'},
			{name: 'PAY_CUSTOM_NAME'	,text: '지급처명'			,type: 'string'},
			{name: 'SEND_DATE'			,text: '지급예정일'			,type: 'string'},
			{name: 'REFER_NUM'			,text: '법인카드승인참조번호'	,type: 'string'},
			{name: 'CANCEL_YN'			,text: '승인취소'			,type: 'string'}
	    ]
	});
	Unilite.defineModel('afb700ukrRef2Model', {	//예산기안참조
	    fields: [
			{name: 'DRAFT_NO'			,text: '기안번호'			,type: 'string'},
			{name: 'DRAFT_DATE'			,text: '기안일'			,type: 'uniDate'},
			{name: 'DRAFTER'			,text: '기안자'			,type: 'string'},
			{name: 'PAY_USER'			,text: '사용자'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '예산부서코드'		,type: 'string'},
			{name: 'DEPT_NAME'			,text: '예산부서'			,type: 'string'},
			{name: 'DIV_NAME'			,text: '사업장'			,type: 'string'},
			{name: 'TITLE'				,text: '기안제목'			,type: 'string'},
			{name: 'BUDG_AMT'			,text: '추산금액'			,type: 'uniPrice'},
			{name: 'PAY_DRAFT_AMT'		,text: '지출결의금액'		,type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'	,text: '추산잔액'			,type: 'uniPrice'}
	    ]
	});
	Unilite.defineModel('afb700ukrRef3Model', {	//지급명세서참조
	    fields: [
			{name: 'PAY_DTL_NO'			,text: '명세서번호'			,type: 'string'},
			{name: 'PAY_DATE'			,text: '작성일'			,type: 'uniDate'},
			{name: 'DRAFTER'			,text: '기안자'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '예산부서코드'		,type: 'string'},
			{name: 'DEPT_NAME'			,text: '예산부서'			,type: 'string'},
			{name: 'DIV_NAME'			,text: '사업장'			,type: 'string'},
			{name: 'TITLE'				,text: '제목'				,type: 'string'},
			{name: 'TOT_AMT_I'			,text: '총금액'			,type: 'uniPrice'},
			{name: 'PAY_DRAFT_NO'		,text: '지출결의번호'		,type: 'string'}
	    ]
	});
	Unilite.defineModel('afb700ukrPop1Model', {	//급여공제
	    fields: [
			{name: 'SEQ'				,text: '순번'				,type: 'string'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PAY_DRAFT_NO'		,text: 'PAY_DRAFT_NO'	,type: 'string'},
			{name: 'DED_CODE'			,text: '공제코드'			,type: 'string'},
			{name: 'DED_NAME'			,text: '공제항목명'			,type: 'string'},
			{name: 'DED_AMOUNT_I'		,text: '공제금액'			,type: 'uniPrice'},
			
			{name: 'DED_AMOUNT_I_DUMMY'		,text: '공제금액'			,type: 'uniPrice'},
			
			{name: 'PAY_YYYYMM'			,text: '급여년월'			,type: 'string'},
			{name: 'SUPP_TYPE'			,text: '지급구분'			,type: 'string'},
			{name: 'COST_POOL'			,text: '사업명'			,type: 'string'},
			{name: 'PERSON_GROUP'		,text: '사원그룹'			,type: 'string'},
			{name: 'AFFIL_CODE'			,text: '직렬'				,type: 'string'},
			{name: 'FR_DEPT_CODE'		,text: 'FR_DEPT_CODE'	,type: 'string'},
			{name: 'FR_DEPT_NAME'		,text: 'FR_DEPT_NAME'	,type: 'string'},
			{name: 'TO_DEPT_CODE'		,text: 'TO_DEPT_CODE'	,type: 'string'},
			{name: 'TO_DEPT_NAME'		,text: 'TO_DEPT_NAME'	,type: 'string'},
			{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER'	,type: 'string'},
			{name: 'INSERT_DB_TIME'		,text: 'INSERT_DB_TIME'	,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'	,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'	,type: 'string'},
			{name: 'UPDATE_MODE'		,text: 'UPDATE_MODE'	,type: 'string'}
	    ]
	});
	var directMasterStore = Unilite.createStore('Afb700ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.selectMaster'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		/*if(directMasterStore.getCount() > 0){
           			UniAppManager.setToolbarButtons(['reset','newData','delete','deleteAll'],true);
           		}*/
           		UniAppManager.app.fnDispMasterData('QUERY');
           		UniAppManager.app.fnMasterDisable(false);
           		subStore.loadStoreRecords();
//           		alert('ddd');
//           		alert('sss');
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
		
		
	});
	var subStore = Unilite.createStore('Afb700ukrSubStore',{
		model: 'Afb700ukrSubModel',
		uniOpt: {
            isMaster: false,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable: false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.selectMainRef'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록	
			param.budgNameListLength = budgNameListLength;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var directDetailStore = Unilite.createStore('Afb700ukrDirectDetailStore',{
		model: 'Afb700ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi : false,				// prev | newxt 버튼 사용
	        deleteAll:true
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
//			checkMasterOnly = '';
			var paramMaster= detailForm.getValues();
			paramMaster.RETURN_CODE = gsCommonA171_Ref6;
			paramMaster.TOT_AMT_I =Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var confRecords = directDetailStore.data.items;
        	if(Ext.isEmpty(detailForm.getValue('PAY_DRAFT_NO')) && Ext.isEmpty(confRecords)){
        		Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0440);
        		
        		return false;
        	}
        	var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
//       		alert(toCreate);	//왜 phantom 인 신규 레코드 안들어오나
//       			alert(toUpdate);
//       				alert(toDelete);
       				
       			
//       		if(Ext.isEmpty(toCreate) && Ext.isEmpty(toUpdate) && Ext.isEmpty(toDelete)){
//       			checkMasterOnly = 'Y';
//       		}
//        	if(checkMasterOnly == 'Y'){
        		
        		if(!directDetailStore.isDirty())	{
					if(detailForm.isDirty())	{
        		
			       		detailForm.getForm().submit({
						params : paramMaster,
							success : function(form, action) {
				 				detailForm.getForm().wasDirty = false;
								detailForm.resetDirtyStatus();											
								UniAppManager.setToolbarButtons('save', false);	
				            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
		//		            	UniAppManager.app.onQueryButtonDown();
				            	UniAppManager.app.onQueryButtonDown();
		//						directMasterStore.loadStoreRecords();
								if(saveSuccessCheck == 'CS'){
					     			UniAppManager.app.fnCancSlip(); //자동기표취소
					     		}else if(saveSuccessCheck == 'AS'){
					     			UniAppManager.app.fnAutoSlip(); //자동기표
					     		}else if(saveSuccessCheck == 'RA'){
					     			UniAppManager.app.fnReAuto(); //재기표
					     		}else if(saveSuccessCheck == 'RC'){
						     		if(confirm(Msg.fSbMsgA0529)) {
						     			UniAppManager.app.fnReCancel(); //임의반려
						     		}
								}else if(saveSuccessCheck == 'AP'){
				     				UniAppManager.app.fnAppPro(); //지출승인
								}
					     		saveSuccessCheck = "";
							
							}	
						});
				
					}
				}else{
        		
//       		}else{
        	
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						
						var master = batch.operations[0].getResultSet();
						detailForm.setValue("PAY_DRAFT_NO", master.PAY_DRAFT_NO);
//						directMasterStore.loadStoreRecords();
						UniAppManager.app.onQueryButtonDown();
						if(saveSuccessCheck == 'CS'){
			     			UniAppManager.app.fnCancSlip(); //자동기표취소
			     		}else if(saveSuccessCheck == 'AS'){
			     			UniAppManager.app.fnAutoSlip(); //자동기표
			     		}else if(saveSuccessCheck == 'RA'){
			     			UniAppManager.app.fnReAuto(); //재기표
			     		}else if(saveSuccessCheck == 'RC'){
				     		if(confirm(Msg.fSbMsgA0529)) {
				     			UniAppManager.app.fnReCancel(); //임의반려
				     		}
						}else if(saveSuccessCheck == 'AP'){
		     				UniAppManager.app.fnAppPro(); //지출승인
						}
			     		saveSuccessCheck = "";
					}
				};
				
//				checkMasterOnly == 'Y' ?  this.syncMaster(config) : this.syncAllDirect(config);
				this.syncAllDirect(config);
				
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
       		}
		}
	});
	var corporationCardStore = Unilite.createStore('afb700ukrRef1Store', {//법인카드승인참조
		model: 'afb700ukrRef1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'afb700ukrService.selectCorporationCardList'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var detailRecords = directDetailStore.data.filterBy(directDetailStore.filterNewOnly);  
        			   var corporationCardRecords = new Array();
        			   if(detailRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(detailRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['REFER_NUM'] == item.data['REFER_NUM']) 
		   									  ) 
		   									{
		   										corporationCardRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(corporationCardRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= corporationCardSearch.getValues();	
			this.load({
				params : param
			});
		}
	});
	var draftNoStore = Unilite.createStore('afb700ukrRef2Store', {//예산기안참조
		model: 'afb700ukrRef2Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'afb700ukrService.selectDraftNoList'                	
            }
        },
        
        loadStoreRecords : function()	{
			var param= draftNoSearch.getValues();
			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(draftNoStore.getCount() == 0){
           			Ext.Msg.alert(Msg.sMB099,Msg.sMB015);
           		}
           	}
		}
	});
	
	var payDtlNoStore = Unilite.createStore('afb700ukrRef3Store', {//지급명세서참조
		model: 'afb700ukrRef3Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'afb700ukrService.selectPayDtlNoList'                	
            }
        },
       
        loadStoreRecords : function()	{
			var param= payDtlNoSearch.getValues();	
			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(payDtlNoStore.getCount() == 0){
           			Ext.Msg.alert(Msg.sMB099,Msg.sMB015);
           		}
           	}
		}
	});
	
	var dedAmtMasterStore = Unilite.createStore('afb700ukrPop1MasterStore', {//급여공제 마스터
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'afb700ukrService.selectDedAmtMasterList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= dedAmtSearch.getValues();	
			this.load({
				params : param
			});
		}
	});
	var dedAmtDetailStore = Unilite.createStore('afb700ukrPop1DetailStore', {//급여공제 디테일
		model: 'afb700ukrPop1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxyDedAmt,
        loadStoreRecords : function()	{
			var param= dedAmtSearch.getValues();	
			this.load({
				params : param
			});
		},
		saveStore : function(flagCheck)	{	
			var paramMaster= dedAmtSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(flagCheck == 'S'){
							dedAmtSearch.setValue('HDD_QUERY_FLAG','N');
							dedAmtSearch.setValue('HDD_DED_DATA_YN','Y');
						}
						
//						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				dedAmtGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var cancSlipStore = Unilite.createStore('Afb700ukrCancSlipStore',{		//자동기표취소 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.cancSlip'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var autoSlipStore = Unilite.createStore('Afb700ukrAutoSlipStore',{		//지출결의자동기표 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.autoSlip'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var reAutoStore = Unilite.createStore('Afb700ukrReAutoStore',{		//재기표 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.reAuto'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	var reCancelStore = Unilite.createStore('Afb700ukrReCancelStore',{	//임의반려 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.reCancel'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var appProStore = Unilite.createStore('Afb700ukrAppProStore',{	//지출승인 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb700ukrService.appPro'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	
	var detailForm = Unilite.createForm('detailForm',{
		split:true,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
    		fieldLabel: '지출작성일',
    		labelWidth:150,
		    xtype: 'uniDatefield',
		    name: 'PAY_DATE',
		    value: UniDate.get('today'),
		    allowBlank: false,tdAttrs: {width:1000/*align : 'center'*/},                	
            listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					detailForm.setValue('SLIP_DATE',newValue);
					UniAppManager.app.fnApplySlipDate(newValue);
				}
			}
		},
		Unilite.popup('Employee', {
			fieldLabel: '지출작성자', 
			labelWidth:150,
			valueFieldName: 'DRAFTER_PN',
    		textFieldName: 'DRAFTER_NM', 
    		autoPopup:true,
    		tdAttrs: {width:'100%',align : 'left'}, 
			listeners: {
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(detailForm.getValue('DRAFTER_PN'))){
							detailForm.setValue('PAY_USER_PN', detailForm.getValue('DRAFTER_PN'));
							detailForm.setValue('PAY_USER_NM', detailForm.getValue('DRAFTER_NM'));
							detailForm.setValue('DEPT_CODE', records[0]["DEPT_CODE"]);
							detailForm.setValue('DEPT_NAME', records[0]["DEPT_NAME"]);
							detailForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							
							UniAppManager.app.fnApplyToDetail();
						}
						
                	},
					scope: this
				},
				onClear: function(type)	{
					
				}
			}
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left',width:120},
			items :[{
	    		xtype: 'button',
	    		text: '결재상신',	
	    		id: 'btnProc',
	    		name: 'PROC',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
					}else{
						if(gsLinkedGW == 'Y'){
							UniAppManager.app.fnApproval(); //결재상신
						}else{
//							if(detailForm.down('#btnProc').getText(Msg.fSbMsgA0049)){
							if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
								if(directDetailStore.getCount() == 0){
									Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
									return false;
								}
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
									     		saveSuccessCheck = 'CS';
												UniAppManager.app.onSaveDataButtonDown();
									     		
									     	} else if(res === 'no') {
									     		UniAppManager.app.fnCancSlip(); //자동기표취소
									     	}
									     }
									});
								} else {
									UniAppManager.app.fnCancSlip(); //자동기표취소
								}
							}else if (detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
								if(directDetailStore.getCount() == 0){
									Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
									return false;
								}
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
									     		saveSuccessCheck = 'AS';
												UniAppManager.app.onSaveDataButtonDown();
									     		
									     	} else if(res === 'no') {
									     		UniAppManager.app.fnAutoSlip(); //자동기표
									     	}
									     }
									});
								} else {
									UniAppManager.app.fnAutoSlip(); //자동기표
								}
							}
						}
					}
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,tdAttrs: {width:1000/*align : 'center'*/},
			defaults : {enforceMaxLength: true},
			items :[{ 
	    		fieldLabel: '사용일(전표일)',
	    		labelWidth:150,
			    xtype: 'uniDatefield',
			    name: 'SLIP_DATE',
			    value: UniDate.get('today'),
			    allowBlank: false,                	
	            listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						UniAppManager.app.fnApplySlipDate(newValue);
					}
				}
			},{
				fieldLabel:'',
				xtype:'uniTextfield',
				name:'EX_NUM',
				width:50,
				readOnly:true,
				tdAttrs: {align : 'left'},
				fieldStyle: 'text-align: center;'
			}]
    	},{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 2},
		   width:500,
		   tdAttrs: {width:'100%',align : 'left'},
		   id:'hiddenContainerPR',
		   defaults : {enforceMaxLength: true},
		   items :[{
				fieldLabel:'비밀번호',
				labelWidth:150,
				xtype: 'uniTextfield',
				id:'passWord',
				name: 'PASSWORD',
				inputType: 'password',
				maxLength : 7,
				holdable: 'hold',
				allowBlank:false
			},{ 
	    		xtype: 'component',  
	    		html:'※ 주민번호 뒤 7자리 입력',
	    		id:'hiddenHtml',
	    		style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		           color: 'blue'
				},
	    		tdAttrs: {align : 'left'}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
				xtype:'component',
				html:'자동기표조회',
	    		id: 'btnLinkSlip',
	    		name: 'LINKSLIP',
	    		width: 110,	
	    		tdAttrs: {align : 'center'},
	    		componentCls : 'component-text_first',
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	UniAppManager.app.fnOpenSlip();
		                });
		            }
				}
			}]
    	},{ 
    		fieldLabel: '지출결의번호',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'PAY_DRAFT_NO',
		    readOnly:true,
		    tdAttrs: {width:1000/*align : 'center'*/}
		},
		Unilite.popup('Employee', {
			fieldLabel: '사용자', 
			labelWidth:150,
			valueFieldName: 'PAY_USER_PN',
    		textFieldName: 'PAY_USER_NM', 
    		autoPopup:true,
    		allowBlank:false,
    		tdAttrs: {width:'100%',align : 'left'},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(detailForm.getValue('PAY_USER_PN'))){
							detailForm.setValue('DEPT_CODE', records[0]["DEPT_CODE"]);
							detailForm.setValue('DEPT_NAME', records[0]["DEPT_NAME"]);
							detailForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							
							UniAppManager.app.fnApplyToDetail();
						}
						
                	},
					scope: this
				},
				onClear: function(type)	{
					
				}
			}
			
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '복사',	
	    		id: 'btnCopy',
	    		name: 'COPY',
	    		width: 110,	
				handler : function() {
					
					var bReferNum = false;
					
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						return false;
					}else{
						
						var records = directDetailStore.data.items;
						Ext.each(records, function(record,i){
							if(record.get('REFER_NUM') != '' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
								bReferNum = true;
							}	
						});
						if(bReferNum == true){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0439);	
						}
						
						
						detailGrid.reset();
						directDetailStore.clearData();
						var param = {"PAY_DRAFT_NO": detailForm.getValue('PAY_DRAFT_NO')
						};
						afb700ukrService.selectDetail(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.copyDataCreateRow();
					        		detailGrid.setNewDataCopy(record);
								});
							}
							
						});
						
//						UniAppManager.app.fnDispTotAmt();
						
							
						UniAppManager.app.fnDispMasterData("COPY");
						
						UniAppManager.app.fnMasterDisable(false);
						
//						Call goCnn.SetFrameButtonInfo("NW1:SV1")
//						If grdSheet1.Rows > csHeaderRowsCnt Then
//							Call goCnn.SetFrameButtonInfo("DL1:DA1")
//						End If


					}
				}
	    	}]
    	},{
			fieldLabel: '사업장',
			labelWidth:150,
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        comboType:'BOR120',
	        allowBlank:false,
	        tdAttrs: {width:1000/*align : 'center'*/},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {		
					UniAppManager.app.fnApplyToDetail();
				}
			}
		},
		Unilite.popup('DEPT',{ 
	    	fieldLabel: '예산부서', 
	    	labelWidth:150,
	    	valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			valueFieldWidth: 90,
		    textFieldWidth: 140,
	    	autoPopup:true,
	    	allowBlank:false,
	    	tdAttrs: {width:'100%',align : 'left'},
	    	listeners: {
				onSelected: {
					fn: function(records, type) {
						UniAppManager.app.fnApplyToDetail();
                	},
					scope: this
				},
				onClear: function(type)	{
					UniAppManager.app.fnApplyToDetail();
				}
			}
		}),	
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '재기표',	
	    		id: 'btnReAuto',
	    		name: 'REAUTO',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						return false;
					}else{
						if(directDetailStore.getCount() == 0){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
							return false;
						}
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	if (res === 'yes' ) {
							     		saveSuccessCheck = 'RA';
										UniAppManager.app.onSaveDataButtonDown();
							     		
							     	} else if(res === 'no') {
							     		UniAppManager.app.fnReAuto(); //재기표
							     	}
							     }
							});
						} else {
							UniAppManager.app.fnReAuto(); //재기표
						}	
					}
				}
	    	}]
    	},{
			fieldLabel: '예산구분',
			labelWidth:150,
			name:'BUDG_GUBUN',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A170', 
		    allowBlank: false,tdAttrs: {width:1000/*align : 'center'*/},
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						UniAppManager.app.fnApplyToDetail();
					}
				}
		},{ 
    		fieldLabel: '문서서식구분',
    		labelWidth:150,
		    name: 'ACCNT_GUBUN',
		    xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A171',
		    allowBlank: false,	
		    tdAttrs: {width:'100%',align : 'left'},
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		UniAppManager.app.fnGetA171RefCode();
		    		UniAppManager.app.fnApplyDedButton();
		      	}
     		}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
				xtype: 'button',
	    		text: '임의반려',	
	    		id: 'btnReCancel',
	    		name: 'RECANCEL',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						return false;
					}else{
						if(directDetailStore.getCount() == 0){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0515);	
							return false;
						}
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	if (res === 'yes' ) {
							     		saveSuccessCheck = 'RC';
										UniAppManager.app.onSaveDataButtonDown();
										
							     	} else if(res === 'no') {
							     		if(confirm(Msg.fSbMsgA0529)) {
							     			UniAppManager.app.fnReCancel(); //임의반려
							     		}
							     	}
							     }
							});
						} else {
							if(confirm(Msg.fSbMsgA0529)) {
								UniAppManager.app.fnReCancel(); //임의반려
							}
						}	
					}
				}
	    	}]
    	},{ 
    		fieldLabel: '지출건명(제목)',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 500,
		    allowBlank: false,
		    tdAttrs: {width:1000/*align : 'center'*/}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:600,
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:'100%',align : 'left'},
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
				labelWidth:150,
				id:'rdoStatus',
				items: [{
					boxLabel: '미상신', 
					width: 60,
					name: 'STATUS',
					inputValue: '0',
					readOnly: true,
					checked:true
				},{
					boxLabel: '결재중', 
					width: 60,
					name: 'STATUS',
					inputValue: '1',
					readOnly: true
				},{
					boxLabel: '반려', 
					width: 45,
					name: 'STATUS',
					inputValue: '5',
					readOnly: true
				},{
					boxLabel : '완결', 
					width: 45,
					name: 'STATUS',
					inputValue: '9',
					readOnly: true
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '지출승인',
				labelWidth:150,
				id:'rdoAppStatus',
				items: [{
					boxLabel: '미승인', 
					width: 60,
					name: 'APP',
					inputValue: '0',
					readOnly: true,
					checked:true
				},{
					boxLabel: '승인', 
					width: 60,
					name: 'APP',
					inputValue: '9',
					readOnly: true
				}]
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '급여공제',	
	    		id: 'btnDedAmt',
	    		name: 'DEDAMT',
	    		width: 110,	
				handler : function() {
					openDedAmtWindow();
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:900,
			id: 'tdTitleDesc',
			defaults : {enforceMaxLength: true},
			colspan:3,
			tdAttrs: {width:'100%'/*align : 'center'*/},
			items :[{
		    	fieldLabel:'내용',
		    	labelWidth:150,
		    	xtype:'textarea',
		    	name:'TITLE_DESC',
		    	width:900,
		    	tdAttrs: {width:900/*align : 'center'*/}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:900,
			defaults : {enforceMaxLength: true},
			colspan:2,tdAttrs: {width:1000/*align : 'center'*/},
			items :[{
				fieldLabel: '예산기안(추산)참조', 
				xtype:'uniTextfield',
				labelStyle: "color: red;",
				labelWidth:150,
				width:280,
				name:'DRAFT_NO',
				id:'draftNo',
				listeners: {
		            render: function(component) {
		                component.getEl().on('dblclick', function( event, el ) {
		                	openDraftNoWindow();
		                });
		            },
		            change: function(field, newValue, oldValue, eOpts) {
		            	if(Ext.isEmpty(detailForm.getValue('DRAFT_NO'))){
		            		detailForm.setValue('DRAFT_TITLE','');	
		            		subGrid.reset();
		            		subStore.clearData();
		            	}
		            	UniAppManager.app.fnApplyToDetail();
			      	}
        		}
			},{
				xtype:'uniTextfield',
				name:'DRAFT_TITLE',
				id:'draftTitle',
				width:250,
				readOnly:true
			},{ 
	    		xtype: 'component',  
	    		html:'※ 예산기안(추산)내역 참조시 팝업창을 띄어 선택합니다.',
	    		style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		           color: 'red'
				},
	    		tdAttrs: {align : 'left'}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
				fieldLabel:'',
				xtype:'uniNumberfield',
				id:'dedAmtTot',
				name:'DED_AMT_TOT',
				width: 110,	
				readOnly:true,
			   	tdAttrs: {align : 'left'}
		   	}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:1000,
			id:'trPayDtlNoApp',
			defaults : {enforceMaxLength: true},
			colspan:2,
//			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
			tdAttrs: {width:1000/*,style: 'border : 1px solid #ced9e7;'*//*align : 'center'*/},
			items :[{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 5},
				width:1000,
				id:'tdPayDtlNo',
				defaults : {enforceMaxLength: true},
				tdAttrs: {width:1000/*align : 'center'*/},
				items :[{
					fieldLabel: '지급명세서참조', 
					xtype:'uniTextfield',
					labelStyle: "color: red;",
					labelWidth:150,
					width:280,
					name:'PAY_DTL_NO',
					id:'payDtlNo',
					listeners: {
			            render: function(component) {
			                component.getEl().on('dblclick', function( event, el ) {
			                	openPayDtlNoWindow();
			                });
			            },
			            change: function(field, newValue, oldValue, eOpts) {
			            	if(Ext.isEmpty(detailForm.getValue('PAY_DTL_NO'))){
			            		detailForm.setValue('PAY_DTL_TITLE','');	
			            		detailForm.setValue('PAY_DTL_AMT','');	
			            	}
				      	},
				      	specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
		//						UniAppManager.app.onQueryButtonDown();
								detailForm.getField('PAY_DATE').focus();
								
							}
						}
	        		}
				},{
					xtype:'uniTextfield',
					name:'PAY_DTL_TITLE',
					id:'payDtlTitle',
					width:200,
					readOnly:true
				},{
					xtype:'uniNumberfield',
					name:'PAY_DTL_AMT',
					id:'payDtlAmt',
					width:50,
					readOnly:true
				},{ 
		    		xtype: 'component',  
		    		html:'※ 기타소득자의 지급명세서 참조시 팝업창을 띄어 선택합니다.&nbsp;&nbsp;&nbsp;',
		    		style: {
			           marginTop: '3px !important',
			           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
			           color: 'red'
					},
		    		tdAttrs: {align : 'left'}
				},{
		    		xtype: 'button',
		    		text: '참조정보클릭',	
		    		id: 'btnLinkDtl',
		    		name: 'LINKDTL',
		    		width: 90,	
					handler : function() {
						UniAppManager.app.fnOpenPayDtl();
					}
		    	}]		
	    	}]
		},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				id:'trAppPro',
				width:120,
				defaults : {enforceMaxLength: true},
				tdAttrs: {align : 'left'},
				items :[{
		    		xtype: 'button',
		    		text: '지출승인',	
		    		id: 'btnAppPro',
		    		name: 'APPPRO',
		    		width: 110,	
		    		hidden:true,
					handler : function() {
						if(detailForm.getValue('PAY_DRAFT_NO') == ''){
							return false;
						}else{
							if(directDetailStore.getCount() == 0){
								Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
								return false;
							}
							if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
								Ext.Msg.show({
								     title:'확인',
								     msg: Msg.sMB017 + "\n" + Msg.sMB061,
								     buttons: Ext.Msg.YESNOCANCEL,
								     icon: Ext.Msg.QUESTION,
								     fn: function(res) {
								     	if (res === 'yes' ) {
								     		saveSuccessCheck = 'AP';
											UniAppManager.app.onSaveDataButtonDown();
								     	} else if(res === 'no') {
								     		UniAppManager.app.fnAppPro(); //지출승인
								     	}
								     }
								});
							} else {
								UniAppManager.app.fnAppPro(); //지출승인

							}	
						}
					}
		    	}]
	    	},{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 7},
		   width:500,
		   colspan:3,
		   defaults : {width:200,labelWidth:130},
		   tdAttrs: {width:'100%'/*align : 'center'*/},
		   items :[{
	    		fieldLabel: '상태(HDD_STATUS)',
			    xtype: 'uniTextfield',
			    name: 'HDD_STATUS',
			    hidden:true
	    	},{
	    		fieldLabel: '지출상태(HDD_APP)',
			    xtype: 'uniTextfield',
			    name: 'HDD_APP',
			    hidden:true
	    	},{
	    		fieldLabel: '최초입력자(HDD_INSERT_DB_USER)',
			    xtype: 'uniTextfield',
			    name: 'HDD_INSERT_DB_USER',
			    hidden:true
	    	},{
	    		fieldLabel: '저장유형(HDD_SAVE_TYPE)',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_TYPE',
			    hidden:true
	    	},{
	    		fieldLabel: '복사자료(HDD_COPY_DATA)',
			    xtype: 'uniTextfield',
			    name: 'HDD_COPY_DATA',
			    hidden:true
	    	},{
	    		fieldLabel: '급여공제 관련(HDD_PAY_GUBUN)',
			    xtype: 'uniTextfield',
			    name: 'HDD_PAY_GUBUN',
			    hidden:true
	    	},{
	    		fieldLabel: '급여공제데이터 유무(HDD_DED_DATA_YN)',
			    xtype: 'uniTextfield',
			    name: 'HDD_DED_DATA_YN',
			    hidden:true
	    	}]
    	}],
    	api: {
//	 		load: 'atx700ukrService.selectForm'	,
	 		submit: 'afb700ukrService.syncMaster'	
		}
	});
	var subForm = Unilite.createSearchForm('subForm',{		
//		title:'상세입력',
//		split:true,
    	region: 'south', 
    	autoScroll: true,
    	border:true,
    	padding:'1 1 1 1',
    	layout : {type : 'uniTable', columns : 1},
    	items:[{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:200,
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:200/*,align : 'left'*/},
			items :[
			Unilite.popup('BUDG', {
				fieldLabel: '예산과목', 
				labelWidth:150,
				valueFieldWidth:150,
				textFieldWidth:200,
				valueFieldName: 'BUDG_CODE',
	    		textFieldName: 'BUDG_NAME', 
	    		autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var bFindData;
                    		var subRecords = subStore.data.items;
                    		
                    		if(detailForm.getValue('DRAFT_NO') != ''){
                    		
                    			bFindData = false;
	                    		Ext.each(subRecords, function(subRecord, i){
	                    			if(!Ext.isEmpty(subRecords)){
	                    				if(records[0]['BUDG_CODE'] == subRecord.get('BUDG_CODE')){
	                    					bFindData = true;
	                    				}
	                    			}
	                    		});
                    			
                    			if(bFindData == false){
                    				Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0452)	
                    				return false;
                    			}
                    		}
							
							
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							subForm.setValue('BUDG_NAME', records[0][budgName]);
							subForm.setValue('HDD_ACCNT_CODE', records[0]["ACCNT"]);
							subForm.setValue('HDD_ACCNT_NAME', records[0]["ACCNT_NAME"]);
							subForm.setValue('HDD_PJT_CODE', records[0]["PJT_CODE"]);
							subForm.setValue('HDD_PJT_NAME', records[0]["PJT_NAME"]);
							subForm.setValue('HDD_SAVE_CODE', records[0]["SAVE_CODE"]);
							subForm.setValue('HDD_SAVE_NAME', records[0]["SAVE_NAME"]);
							subForm.setValue('HDD_BANK_ACCOUNT', records[0]["BANK_ACCOUNT"]);
	                	},
						scope: this
					},
					onClear: function(type)	{
						subForm.setValue('BUDG_CODE', '');
						subForm.setValue('BUDG_NAME', '');
						subForm.setValue('HDD_ACCNT_CODE', '');
						subForm.setValue('HDD_ACCNT_NAME', '');
						subForm.setValue('HDD_PJT_CODE', '');
						subForm.setValue('HDD_PJT_NAME', '');
						subForm.setValue('HDD_SAVE_CODE', '');
						subForm.setValue('HDD_SAVE_NAME', '');
						subForm.setValue('HDD_BANK_ACCOUNT', '');
						
					},
					applyextparam: function(popup) {							
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4)});
				   		popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
				   		popup.setExtParam({'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
				   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"});
					}
				
				}
			}),
			{
	    		xtype: 'button',
	    		text: '일괄적용',	
	    		id: 'btnAllApply',
	    		name: 'ALLAPPLY',
	    		width: 90,	
				handler : function() {
					UniAppManager.app.fnAllApplybtn();
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 7},
			width:200,
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:200/*,align : 'left'*/},
			items :[
	    	{
	    		fieldLabel: 'HDD_ACCNT_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_ACCNT_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_ACCNT_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_ACCNT_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_PJT_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_PJT_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_PJT_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_PJT_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_SAVE_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_SAVE_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_BANK_ACCOUNT',
			    xtype: 'uniTextfield',
			    name: 'HDD_BANK_ACCOUNT',
			    hidden:true
	    	}]
    	}]
	});
	var corporationCardSearch = Unilite.createSearchForm('corporationCardForm', {//법인카드승인참조
		layout :  {type : 'uniTable', columns : 2},
    	items :[{ 
    		fieldLabel: '승인일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false
		},
		Unilite.popup('CREDIT_NO',{
			fieldLabel: '카드번호', 
			valueFieldName:'CRDT_NUM',
		    textFieldName:'CRDT_NAME'
		}),
		{
			fieldLabel:'사용일(전표일)',
			xtype:'uniTextfield',
			name:'SLIP_DATE',
			hidden:true
		},{
			fieldLabel:'사용자',
			xtype:'uniTextfield',
			name:'PAY_USER',
			hidden:true
		}]
    });
    var draftNoSearch = Unilite.createSearchForm('draftNoForm', {//예산기안참조
		layout :  {type : 'uniTable', columns : 2,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
    		fieldLabel: '기안일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
			endDate: UniDate.get('today'),
		    allowBlank: false
		},
		Unilite.popup('Employee', {
			fieldLabel: '기안자', 
			valueFieldName: 'DRAFTER_PN',
    		textFieldName: 'DRAFTER_NM', 
    		autoPopup:true
		}),
		{ 
    		fieldLabel: '기안번호',
		    xtype: 'uniTextfield',
		    name: 'DRAFT_NO'
		},
		Unilite.popup('DEPT', {
			fieldLabel: '예산부서', 
			valueFieldName: 'DEPT_CODE',
    		textFieldName: 'DEPT_NAME', 
    		autoPopup:true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:300,
			defaults : {enforceMaxLength: true},
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '지출결의',
				id:'draftNoQryType',
				items: [{
					boxLabel: '전체', 
					width: 50,
					name: 'QRY_TYPE',
					inputValue: 'A'
				},{
					boxLabel: '진행', 
					width: 50,
					name: 'QRY_TYPE',
					inputValue: 'I',
					checked:true
				},{
					boxLabel: '완결', 
					width: 50,
					name: 'QRY_TYPE',
					inputValue: 'E'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						draftNoStore.loadStoreRecords();
					}
				}
			}]
    	}]
    });
    
    var payDtlNoSearch = Unilite.createSearchForm('payDtlNoForm', {//지급명세서참조
		layout :  {type : 'uniTable', columns : 2,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
    		fieldLabel: '기안일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
			endDate: UniDate.get('today'),
		    allowBlank: false
		},
		Unilite.popup('Employee', {
			fieldLabel: '기안자', 
			valueFieldName: 'DRAFTER_PN',
    		textFieldName: 'DRAFTER_NM', 
    		autoPopup:true
		}),
		{ 
    		fieldLabel: '지급명세서번호',
		    xtype: 'uniTextfield',
		    name: 'PAY_DTL_NO'
		},
		Unilite.popup('DEPT', {
			fieldLabel: '예산부서', 
			valueFieldName: 'DEPT_CODE',
    		textFieldName: 'DEPT_NAME', 
    		autoPopup:true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:300,
			defaults : {enforceMaxLength: true},
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '지출결의참조',
				id:'payDtlNoQryType',
				items: [{
					boxLabel: '전체', 
					width: 50,
					name: 'QRY_TYPE',
					inputValue: 'A'
				},{
					boxLabel: '미등록', 
					width: 60,
					name: 'QRY_TYPE',
					inputValue: 'I',
					checked:true
				},{
					boxLabel: '등록', 
					width: 60,
					name: 'QRY_TYPE',
					inputValue: 'E'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						payDtlNoStore.loadStoreRecords();
					}
				}
			}]
    	}]
    });
    var dedAmtSearch = Unilite.createSearchForm('dedAmtForm', {//급여공제
		layout :  {type : 'uniTable', columns : 1,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
    		fieldLabel: '지출결의번호',
		    xtype: 'uniTextfield',
		    name: 'PAY_DRAFT_NO',
		    allowBlank: false,
		    readOnly:true
		},{ 
    		fieldLabel: '급여년월',
		    xtype: 'uniMonthfield',
		    name: 'PAY_YYMM',
		    allowBlank: false,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		},{
			fieldLabel: '지급구분',
			name:'SUPP_TYPE',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'H032',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		},{
			fieldLabel:'HDD_STATUS',
			xtype:'uniTextfield',
			name:'HDD_STATUS',
			hidden:true
		},{
			fieldLabel:'HDD_DED_DATA_YN',
			xtype:'uniTextfield',
			name:'HDD_DED_DATA_YN',
			hidden:true
		},{
			fieldLabel:'HDD_QUERY_FLAG',
			xtype:'uniTextfield',
			name:'HDD_QUERY_FLAG',
			hidden:true
		},{
			fieldLabel: '사업명',
			name:'COST_POOL',	
			xtype: 'uniCombobox',
		    comboType:'',
			comboCode:'',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		},{
			fieldLabel: '사원그룹',
			name:'PERSON_GROUP',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'H181',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		},{
			fieldLabel: '직렬',
			name:'AFFIL_CODE',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'H173',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'FR_DEPT_CODE', 
			textFieldName: 'FR_DEPT_NAME', 
			validateBlank:false,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		}),
		Unilite.popup('DEPT',{ 
			fieldLabel: '~', 
			valueFieldName: 'TO_DEPT_CODE', 
			textFieldName: 'TO_DEPT_NAME', 
			validateBlank:false,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) { 
		    		UniAppManager.app.fnDedAmtApplyToDetail();
		    		if(conditionCheck == 'Y'){
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						conditionCheck = 'N'
					}
		      	}
     		}
		})
		]
    });
	var subGrid = Unilite.createGrid('Afb700ukrSubGrid', {
    	features: [{
			id: 'subGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'subGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: true
		}],
		flex:0.6,
		split:true,
    	layout : 'fit',
        region : 'center',
		store: subStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			state: {
				useState: false,			
				useStateList: false		
			}
		},
        columns:columns,
        listeners: {
        	onGridDblClick: function(grid, record, cellIndex, colName) {
        		UniAppManager.app.fnNewData2Detail(record);
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				gsDraftSeq = record.get('DRAFT_SEQ');
				gsDraftBudgCode = record.get('BUDG_CODE');
			}
        }
    });   
    
    var detailGrid = Unilite.createGrid('Afb700ukrGrid', {
//    	id:'detailGridId',
//    	split:true,
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'south',
		store: directDetailStore,
		tbar: [{
			id: 'corporationCardBtn',
			text: '법인카드승인참조',
			handler: function() {
				openCorporationCardWindow();
			}
		}],
        bbar: ['->',
        	{
        	fieldLabel:'지급액 합계',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarDetailGridBbar',
        	name:'TOT_AMT_I',
        	readOnly:true
		}],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
        columns:[        
//        	{dataIndex: 'COMP_CODE'     	, width: 100,hidden:true},	//추후 보수 작업시 필요
//        	{dataIndex: 'PAY_DRAFT_NO'      , width: 100,hidden:true},	//추후 보수 작업시 필요
        	{dataIndex: 'SEQ'    			, width: 60, align: 'center'
//        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//        			if (val == 0){
//                        return '';
//                    }else{
//                    	return val;	
//                    }
//        		}
        	},
//        	{dataIndex: 'BUDG_GUBUN'     	, width: 100,hidden:true},	추후 보수 작업시 필요
        	{dataIndex: 'BUDG_CODE'     	, width: 150,
        		editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
	        			scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		
                    		var bFindData;
                    		var subRecords = subStore.data.items;
                    		
                    		if(detailForm.getValue('DRAFT_NO') != ''){
                    		
                    			bFindData = false;
	                    		Ext.each(subRecords, function(subRecord, i){
	                    			if(!Ext.isEmpty(subRecords)){
	                    				if(records[0]['BUDG_CODE'] == subRecord.get('BUDG_CODE')){
	                    					bFindData = true;
	                    				}
	                    			}
	                    		});
                    			
                    			if(bFindData == false){
                    				Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0452)	
                    				return false;
                    			}
                    		}
                    		
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		if(!UniAppManager.app.fnMultiBudgCodeAllowed(records[0]['BUDG_CODE'])){
								grdRecord.set('BUDG_CODE'		,'');
								grdRecord.set('BUDG_NAME'		,'');
								grdRecord.set('ACCNT'			,'');
	            				grdRecord.set('ACCNT_NAME'		,'');
	            				grdRecord.set('PJT_CODE'		,'');
	            				grdRecord.set('PJT_NAME'		,'');
	            				grdRecord.set('SAVE_CODE'		,'');
	            				grdRecord.set('SAVE_NAME'		,'');
	            				grdRecord.set('BANK_ACCOUNT'	,'');
	            				grdRecord.set('BUDG_POSS_AMT'	,'');
								
								return false;	
							}
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('ACCNT'			,records[0]['ACCNT']);
							grdRecord.set('ACCNT_NAME'		,records[0]['ACCNT_NAME']);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							grdRecord.set('SAVE_CODE'		,records[0]['SAVE_CODE']);
							grdRecord.set('SAVE_NAME'		,records[0]['SAVE_NAME']);
							grdRecord.set('BANK_ACCOUNT'	,records[0]['BANK_ACCOUNT']);
							
							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
							
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							grdRecord.set('ACCNT'			,'');
            				grdRecord.set('ACCNT_NAME'		,'');
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('SAVE_CODE'		,'');
            				grdRecord.set('SAVE_NAME'		,'');
            				grdRecord.set('BANK_ACCOUNT'	,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
							   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
	        	})
        	},
        	{dataIndex: 'BUDG_NAME'     	, width: 120,
        		editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
                    		var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		var bFindData;
                    		var subRecords = subStore.data.items;
                    		
                    		if(detailForm.getValue('DRAFT_NO') != ''){
                    		
                    			bFindData = false;
	                    		Ext.each(subRecords, function(subRecord, i){
	                    			if(!Ext.isEmpty(subRecords)){
	                    				if(records[0]['BUDG_CODE'] == subRecord.get('BUDG_CODE')){
	                    					bFindData = true;
	                    				}
	                    			}
	                    		});
                    			
                    			if(bFindData == false){
                    				Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0452)	
                    				return false;
                    			}
                    		}
                    		
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		if(!UniAppManager.app.fnMultiBudgCodeAllowed(records[0]['BUDG_CODE'])){
								grdRecord.set('BUDG_CODE'		,'');
								grdRecord.set('BUDG_NAME'		,'');
								grdRecord.set('ACCNT'			,'');
	            				grdRecord.set('ACCNT_NAME'		,'');
	            				grdRecord.set('PJT_CODE'		,'');
	            				grdRecord.set('PJT_NAME'		,'');
	            				grdRecord.set('SAVE_CODE'		,'');
	            				grdRecord.set('SAVE_NAME'		,'');
	            				grdRecord.set('BANK_ACCOUNT'	,'');
	            				grdRecord.set('BUDG_POSS_AMT'	,'');
								return false;	
							}
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('ACCNT'			,records[0]['ACCNT']);
							grdRecord.set('ACCNT_NAME'		,records[0]['ACCNT_NAME']);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							grdRecord.set('SAVE_CODE'		,records[0]['SAVE_CODE']);
							grdRecord.set('SAVE_NAME'		,records[0]['SAVE_NAME']);
							grdRecord.set('BANK_ACCOUNT'	,records[0]['BANK_ACCOUNT']);
							
							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							grdRecord.set('ACCNT'			,'');
            				grdRecord.set('ACCNT_NAME'		,'');
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('SAVE_CODE'		,'');
            				grdRecord.set('SAVE_NAME'		,'');
            				grdRecord.set('BANK_ACCOUNT'	,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
							   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
	        		}
	        	})
	        },
        	{dataIndex: 'PJT_CODE'     		, width: 100,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
					DBtextFieldName: 'AC_PROJECT_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
		                    var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
							accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
										grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
										grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
										grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							grdRecord.set('SAVE_CODE'		,'');	
							grdRecord.set('SAVE_NAME'		,'');	
							grdRecord.set('BANK_ACCOUNT'	,'');	
						}
        			}
        		})
        	},
        	{dataIndex: 'PJT_NAME'     		, width: 120,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
	        		autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
		                    var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
							accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
										grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
										grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
										grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							grdRecord.set('SAVE_CODE'		,'');	
							grdRecord.set('SAVE_NAME'		,'');	
							grdRecord.set('BANK_ACCOUNT'	,'');
						}
        			}
        		})
        	},
        	{dataIndex: 'SAVE_CODE'     	, width: 100,hidden:true,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].DEPOSIT_NUM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
						}
					}
				})
        	},
        	{dataIndex: 'SAVE_NAME'     	, width: 100,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].DEPOSIT_NUM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
						}
					}
				})
        	},
        	{dataIndex: 'BANK_ACCOUNT'      , width: 120},
        	{dataIndex: 'BUDG_POSS_AMT'     , width: 120},
        	{dataIndex: 'BIZ_REMARK'     	, width: 100},
        	{dataIndex: 'BIZ_GUBUN'     	, width: 100},
//        	{dataIndex: 'BIZ_GUBUN_REF' 	, width: 100,hidden:true},	추후 보수 작업시 필요
        	{dataIndex: 'PAY_DIVI'     		, width: 100},
//        	{dataIndex: 'PAY_DIVI_REF1'     , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'PAY_DIVI_REF2'     , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'PAY_DIVI_REF3'     , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'PAY_DIVI_REF4'     , width: 100,hidden:true},	추후 보수 작업시 필요
        	{dataIndex: 'PROOF_DIVI'     	, width: 130},
//        	{dataIndex: 'PROOF_KIND'		, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'REASON_ESS'     	, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'PROOF_TYPE'     	, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'CUSTOM_ESS'     	, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'DEFAULT_EB'     	, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'DEFAULT_REASON'    , width: 100,hidden:true},//	추후 보수 작업시 필요
        	{dataIndex: 'SUPPLY_AMT_I'      , width: 100},
        	{dataIndex: 'TAX_AMT_I'     	, width: 100},
        	{dataIndex: 'ADD_REDUCE_AMT_I'  , width: 100},
        	{dataIndex: 'TOT_AMT_I'     	, width: 100},
        	{dataIndex: 'PEND_CODE'     	, width: 100},
//        	{dataIndex: 'PEND_CODE_REF1'    , width: 100,hidden:true},	추후 보수 작업시 필요
        	{dataIndex: 'PAY_CUSTOM_CODE'   , width: 100,
        		editor:Unilite.popup('PAY_CUSTOM_G', {
					autoPopup: true,
					textFieldName:'PAY_CUSTOM_NAME',
					DBtextFieldName: 'PAY_CUSTOM_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('CUSTOM_CODE'			, records[0].PAY_CUSTOM_CODE);	
								grdRecord.set('CUSTOM_NAME'			, records[0].PAY_CUSTOM_NAME);
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('IN_BANK_CODE'		, records[0].BANK_CODE);	
								grdRecord.set('IN_BANK_NAME'		, records[0].CUSTOM_NAME);	
								grdRecord.set('IN_BANKBOOK_NUM'		, records[0].BANKBOOK_NUM);	
								grdRecord.set('IN_BANKBOOK_NAME'	, records[0].BANKBOOK_NAME);	
								
							}
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');	
								grdRecord.set('CUSTOM_CODE'		, '');	
								grdRecord.set('CUSTOM_NAME'		, '');	
								grdRecord.set('AGENT_TYPE'		, '');	
								grdRecord.set('IN_BANK_CODE'	, '');	
								grdRecord.set('IN_BANK_NAME'	, '');	
								grdRecord.set('IN_BANKBOOK_NUM'	, '');	
								grdRecord.set('IN_BANKBOOK_NAME', '');	
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if(grdRecord.get('PEND_CODE') != ''){
									pendCode = grdRecord.get('PEND_CODE');
								}else{
									pendCode = grdRecord.get('PAY_DIVI_REF1');	
								}
								
								var param = {
									'PEND_CODE': pendCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'PAY_CUSTOM_NAME'   , width: 100,
        		editor:Unilite.popup('PAY_CUSTOM_G', {
					autoPopup: true,
					textFieldName:'PAY_CUSTOM_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('CUSTOM_CODE'			, records[0].PAY_CUSTOM_CODE);	
								grdRecord.set('CUSTOM_NAME'			, records[0].PAY_CUSTOM_NAME);
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('IN_BANK_CODE'		, records[0].BANK_CODE);	
								grdRecord.set('IN_BANK_NAME'		, records[0].CUSTOM_NAME);	
								grdRecord.set('IN_BANKBOOK_NUM'		, records[0].BANKBOOK_NUM);	
								grdRecord.set('IN_BANKBOOK_NAME'	, records[0].BANKBOOK_NAME);	
								
							}
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');	
								grdRecord.set('CUSTOM_CODE'		, '');	
								grdRecord.set('CUSTOM_NAME'		, '');	
								grdRecord.set('AGENT_TYPE'		, '');	
								grdRecord.set('IN_BANK_CODE'	, '');	
								grdRecord.set('IN_BANK_NAME'	, '');	
								grdRecord.set('IN_BANKBOOK_NUM'	, '');	
								grdRecord.set('IN_BANKBOOK_NAME', '');	
								
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if(grdRecord.get('PEND_CODE') != ''){
									pendCode = grdRecord.get('PEND_CODE');
								}else{
									pendCode = grdRecord.get('PAY_DIVI_REF1');	
								}
								
								var param = {
									'PEND_CODE': pendCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'CUSTOM_CODE'       , width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
		                    var param = {"CUSTOM_CODE": grdRecord.get('CUSTOM_CODE')};
							accntCommonService.fnCustInfo(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
									
			                    		if(gsPendCodeYN == 'Y'){
			                    			if(grdRecord.get('PAY_DIVI_REF2') == 'BC' ||	
			                    			   grdRecord.get('PAY_DIVI_REF2') == 'C'  ||
			                    			   grdRecord.get('PAY_DIVI_REF2') == 'CC'){
			                    			   	
			                    			}else{
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);
			                    				grdRecord.set('IN_BANK_CODE'	,provider.BANK_CODE);
			                    				grdRecord.set('IN_BANK_NAME'	,provider.BANK_NAME);
			                    				grdRecord.set('IN_BANKBOOK_NUM'	,provider.BANKBOOK_NUM);
			                    				grdRecord.set('IN_BANKBOOK_NAME',provider.BANKBOOK_NAME);
			                    			}
			                    		}else{
			                    			if(grdRecord.get('PAY_DIVI_REF2') == 'BC'){
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);	
			                    			}else{
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);
			                    				grdRecord.set('IN_BANK_CODE'	,provider.BANK_CODE);
			                    				grdRecord.set('IN_BANK_NAME'	,provider.BANK_NAME);
			                    				grdRecord.set('IN_BANKBOOK_NUM'	,provider.BANKBOOK_NUM);
			                    				grdRecord.set('IN_BANKBOOK_NAME',provider.BANKBOOK_NAME);
			                    			}
			                    		}
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('AGENT_TYPE'		,'');
            				grdRecord.set('IN_BANK_CODE'	,'');
            				grdRecord.set('IN_BANK_NAME'	,'');
            				grdRecord.set('IN_BANKBOOK_NUM'	,'');
            				grdRecord.set('IN_BANKBOOK_NAME','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CUSTOM_TYPE': ['1','2','3','4']
								}
								popup.setExtParam(param);
							}
						}
        			}
	        	})
        	},
        	{dataIndex: 'CUSTOM_NAME'       , width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
	        		autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
		                    var param = {"CUSTOM_CODE": grdRecord.get('CUSTOM_CODE')};
							accntCommonService.fnCustInfo(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
									
			                    		if(gsPendCodeYN == 'Y'){
			                    			if(grdRecord.get('PAY_DIVI_REF2') == 'BC' ||	
			                    			   grdRecord.get('PAY_DIVI_REF2') == 'C'  ||
			                    			   grdRecord.get('PAY_DIVI_REF2') == 'CC'){
			                    			   	
			                    			}else{
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);
			                    				grdRecord.set('IN_BANK_CODE'	,provider.BANK_CODE);
			                    				grdRecord.set('IN_BANK_NAME'	,provider.BANK_NAME);
			                    				grdRecord.set('IN_BANKBOOK_NUM'	,provider.BANKBOOK_NUM);
			                    				grdRecord.set('IN_BANKBOOK_NAME',provider.BANKBOOK_NAME);
			                    			}
			                    		}else{
			                    			if(grdRecord.get('PAY_DIVI_REF2') == 'BC'){
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);	
			                    			}else{
			                    				grdRecord.set('CUSTOM_CODE'		,provider.CUSTOM_CODE);	
			                    				grdRecord.set('CUSTOM_NAME'		,provider.CUSTOM_NAME);
			                    				grdRecord.set('AGENT_TYPE'		,provider.AGENT_TYPE);
			                    				grdRecord.set('IN_BANK_CODE'	,provider.BANK_CODE);
			                    				grdRecord.set('IN_BANK_NAME'	,provider.BANK_NAME);
			                    				grdRecord.set('IN_BANKBOOK_NUM'	,provider.BANKBOOK_NUM);
			                    				grdRecord.set('IN_BANKBOOK_NAME',provider.BANKBOOK_NAME);
			                    			}
			                    		}
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('AGENT_TYPE'		,'');
            				grdRecord.set('IN_BANK_CODE'	,'');
            				grdRecord.set('IN_BANK_NAME'	,'');
            				grdRecord.set('IN_BANKBOOK_NUM'	,'');
            				grdRecord.set('IN_BANKBOOK_NAME','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CUSTOM_TYPE': ['1','2','3','4']
								}
								popup.setExtParam(param);
							}
						}
        			}
        		})
        	},
        	{dataIndex: 'AGENT_TYPE'     	, width: 100},
        	{dataIndex: 'IN_BANK_CODE'      , width: 100,hidden:true,
        		editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					DBtextFieldName: 'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', records[0].BANK_CODE);
							grdRecord.set('IN_BANK_NAME', records[0].BANK_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', '');
							grdRecord.set('IN_BANK_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'IN_BANK_NAME'      , width: 100,
        		editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', records[0].BANK_CODE);
							grdRecord.set('IN_BANK_NAME', records[0].BANK_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', '');
							grdRecord.set('IN_BANK_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'IN_BANKBOOK_NUM'   , width: 120},
        	{dataIndex: 'IN_BANKBOOK_NAME'  , width: 100},
        	{dataIndex: 'INC_AMT_I'     	, width: 100},
        	{dataIndex: 'LOC_AMT_I'     	, width: 100},
        	{dataIndex: 'REAL_AMT_I'     	, width: 100},
        	{dataIndex: 'REMARK'     		, width: 100},
        	{dataIndex: 'EB_YN'     		, width: 100},
        	{dataIndex: 'CRDT_NUM'     		, width: 100,hidden:true,
        		editor:Unilite.popup('CREDIT_CARD2_G', {
					autoPopup: true,
					textFieldName:'CRDT_NAME',
					DBtextFieldName: 'CRDT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', records[0].CRDT_NUM);
							grdRecord.set('CRDT_FULL_NUM', records[0].CRDT_FULL_NUM);
							gsCrdtSetDate = records[0].SET_DATE;
							grdRecord.set('PAY_CUSTOM_CODE', records[0].CRDT_COMP_CD);
							grdRecord.set('PAY_CUSTOM_NAME', records[0].CRDT_COMP_NM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', '');
							grdRecord.set('CRDT_FULL_NUM', '');
						}
					}
				})
        	},
        	{dataIndex: 'CRDT_FULL_NUM'     , width: 100,
        		editor:Unilite.popup('CREDIT_CARD2_G', {
					autoPopup: true,
					textFieldName:'CRDT_NAME',
					DBtextFieldName: 'CRDT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', records[0].CRDT_NUM);
							grdRecord.set('CRDT_FULL_NUM', records[0].CRDT_FULL_NUM);
							gsCrdtSetDate = records[0].SET_DATE;
							grdRecord.set('PAY_CUSTOM_CODE', records[0].CRDT_COMP_CD);
							grdRecord.set('PAY_CUSTOM_NAME', records[0].CRDT_COMP_NM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', '');
							grdRecord.set('CRDT_FULL_NUM', '');
						}
					}
				})
        	},
//        	{dataIndex: 'APP_NUM'     		, width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'SEND_DATE'     	, width: 100,hidden:true},	추후 보수 작업시 필요
        	{dataIndex: 'BILL_DATE'     	, width: 100},
        	{dataIndex: 'ACCNT'     		, width: 100,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"GROUP_YN = 'N' AND BUDG_YN = 'Y' AND " +
											"(AC_CODE1 = 'A7' OR AC_CODE2 = 'A7' OR AC_CODE3 = 'A7' OR AC_CODE4 = 'A7' OR AC_CODE5 = 'A7' OR AC_CODE6 = 'A7')"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
        	
        	},
        	{dataIndex: 'ACCNT_NAME'     	, width: 100,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"GROUP_YN = 'N' AND BUDG_YN = 'Y' AND " +
											"(AC_CODE1 = 'A7' OR AC_CODE2 = 'A7' OR AC_CODE3 = 'A7' OR AC_CODE4 = 'A7' OR AC_CODE5 = 'A7' OR AC_CODE6 = 'A7')"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
        	},
        	{dataIndex: 'REASON_CODE'       , width: 150},
        	{dataIndex: 'DEPT_CODE'     	, width: 100,hidden:true,
        		editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'DEPT_NAME'     	, width: 100,hidden:true,
        		editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
						}
					}
				})
        	}
//        	{dataIndex: 'DIV_CODE'     		, width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'REFER_NUM'     	, width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'CANCEL_YN'     	, width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'DRAFT_NO'     		, width: 100,hidden:true},//	추후 보수 작업시 필요
//        	{dataIndex: 'DRAFT_SEQ'     	, width: 100,hidden:true}//	추후 보수 작업시 필요
//        	{dataIndex: 'BUDG_NAME_4'       , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'INSERT_DB_USER'    , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'INSERT_DB_TIME'    , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'UPDATE_DB_USER'    , width: 100,hidden:true},	추후 보수 작업시 필요
//        	{dataIndex: 'UPDATE_DB_TIME'    , width: 100,hidden:true}	추후 보수 작업시 필요
    	],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		
      	 		var bEditable;	
        		
        		bEditable = true;
        		
        		if(Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
        			bEditable = false;
        		}
        		
        		if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
        			bEditable = true;	
        		}
        		
        		if(bEditable == false){
        			return false;
        		}
        		
        		if(UniUtils.indexOf(e.field, ['CRDT_NUM','CRDT_FULL_NUM'])){
	        		if(e.record.data.PAY_DIVI_REF2 == 'C' ||
	        		   e.record.data.PAY_DIVI_REF2 == 'BC' ||
	        		   e.record.data.PAY_DIVI_REF2 == 'CC'){
	        			return true;
	        		}else{
        				return false;
        			}
        		}else if(UniUtils.indexOf(e.field, ['APP_NUM'])){
        			if(e.record.data.PROOF_TYPE == 'A'){
	        			return true;
	        		}else{
        				return false;
        			}
        		}else if(UniUtils.indexOf(e.field, ['BILL_DATE'])){
        			if(e.record.data.REFER_NUM != '' &&
        			   e.record.data.PAY_DIVI_REF2 == 'C' ||
        			   e.record.data.PAY_DIVI_REF2 == 'BC' ||
        			   e.record.data.PAY_DIVI_REF2 == 'CC'){
	        			return false;
	        		}else{
        				return true;
        			}
        		}else if(UniUtils.indexOf(e.field, ['TOT_AMT_I'])){
        			if(gsTotAmtIn == 'Y'){
	        			return true;
	        		}else{
        				return false;
        			}
        		}else if(UniUtils.indexOf(e.field, ['SEQ','BUDG_POSS_AMT','AGENT_TYPE','REAL_AMT_I','PJT_CODE','PJT_NAME'])){
        			return false;
        		}else{
    				return true;
    			}
			},
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn1();
			}
        },
        
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'     		,record['COMP_CODE']);
//			grdRecord.set('PAY_DRAFT_NO'        ,record['PAY_DRAFT_NO']);
//			grdRecord.set('SEQ'     			,record['SEQ']);
			grdRecord.set('BUDG_GUBUN'     	    ,record['BUDG_GUBUN']);
			grdRecord.set('BUDG_CODE'     		,record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'     		,record['BUDG_NAME']);
			grdRecord.set('PJT_CODE'     		,record['PJT_CODE']);
			grdRecord.set('PJT_NAME'     		,record['PJT_NAME']);
			grdRecord.set('SAVE_CODE'     		,record['SAVE_CODE']);
			grdRecord.set('SAVE_NAME'     		,record['SAVE_NAME']);
			grdRecord.set('BANK_ACCOUNT'        ,record['BANK_ACCOUNT']);
			grdRecord.set('BUDG_POSS_AMT'       ,record['BUDG_POSS_AMT']);
			grdRecord.set('BIZ_REMARK'     	    ,record['BIZ_REMARK']);
			grdRecord.set('BIZ_GUBUN'     		,record['BIZ_GUBUN']);
			grdRecord.set('BIZ_GUBUN_REF' 	    ,record['BIZ_GUBUN_REF']);
			grdRecord.set('PAY_DIVI'     		,record['PAY_DIVI']);
			grdRecord.set('PAY_DIVI_REF1'       ,record['PAY_DIVI_REF1']);
			grdRecord.set('PAY_DIVI_REF2'       ,record['PAY_DIVI_REF2']);
			grdRecord.set('PAY_DIVI_REF3'       ,record['PAY_DIVI_REF3']);
			grdRecord.set('PAY_DIVI_REF4'       ,record['PAY_DIVI_REF4']);
			grdRecord.set('PROOF_DIVI'     	    ,record['PROOF_DIVI']);
			grdRecord.set('PROOF_KIND'			,record['PROOF_KIND']);
			grdRecord.set('REASON_ESS'     	    ,record['REASON_ESS']);
			grdRecord.set('PROOF_TYPE'     	    ,record['PROOF_TYPE']);
			grdRecord.set('CUSTOM_ESS'     	    ,record['CUSTOM_ESS']);
			grdRecord.set('DEFAULT_EB'     	    ,record['DEFAULT_EB']);
			grdRecord.set('DEFAULT_REASON'      ,record['DEFAULT_REASON']);
			grdRecord.set('SUPPLY_AMT_I'        ,record['SUPPLY_AMT_I']);
			grdRecord.set('TAX_AMT_I'     		,record['TAX_AMT_I']);
			grdRecord.set('ADD_REDUCE_AMT_I'    ,record['ADD_REDUCE_AMT_I']);
			grdRecord.set('TOT_AMT_I'     		,record['TOT_AMT_I']);
			grdRecord.set('PEND_CODE'     		,record['PEND_CODE']);
			grdRecord.set('PEND_CODE_REF1'      ,record['PEND_CODE_REF1']);
			grdRecord.set('PAY_CUSTOM_CODE'     ,record['PAY_CUSTOM_CODE']);
			grdRecord.set('PAY_CUSTOM_NAME'     ,record['PAY_CUSTOM_NAME']);
			grdRecord.set('CUSTOM_CODE'         ,record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'         ,record['CUSTOM_NAME']);
			grdRecord.set('AGENT_TYPE'     	    ,record['AGENT_TYPE']);
			grdRecord.set('IN_BANK_CODE'        ,record['IN_BANK_CODE']);
			grdRecord.set('IN_BANK_NAME'        ,record['IN_BANK_NAME']);
			grdRecord.set('IN_BANKBOOK_NUM'     ,record['IN_BANKBOOK_NUM']);
			grdRecord.set('IN_BANKBOOK_NAME'    ,record['IN_BANKBOOK_NAME']);
			grdRecord.set('INC_AMT_I'     		,record['INC_AMT_I']);
			grdRecord.set('LOC_AMT_I'     		,record['LOC_AMT_I']);
			grdRecord.set('REAL_AMT_I'     	    ,record['REAL_AMT_I']);
			grdRecord.set('REMARK'     		    ,record['REMARK']);
			grdRecord.set('EB_YN'     			,record['EB_YN']);
			grdRecord.set('CRDT_NUM'     		,record['CRDT_NUM']);
			grdRecord.set('CRDT_FULL_NUM'       ,record['CRDT_FULL_NUM']);
			grdRecord.set('APP_NUM'     		,record['APP_NUM']);
			grdRecord.set('SEND_DATE'     		,record['SEND_DATE']);
			grdRecord.set('BILL_DATE'     		,record['BILL_DATE']);
			grdRecord.set('ACCNT'     			,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'     	    ,record['ACCNT_NAME']);
			grdRecord.set('REASON_CODE'         ,record['REASON_CODE']);
			grdRecord.set('DEPT_CODE'     		,record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'     		,record['DEPT_NAME']);
			grdRecord.set('DIV_CODE'     		,record['DIV_CODE']);
			grdRecord.set('REFER_NUM'     		,record['REFER_NUM']);
			grdRecord.set('CANCEL_YN'     		,record['CANCEL_YN']);
			grdRecord.set('DRAFT_NO'     		,record['DRAFT_NO']);
			grdRecord.set('DRAFT_SEQ'     		,record['DRAFT_SEQ']);
			grdRecord.set('BUDG_NAME_4'         ,record['BUDG_NAME_4']);
			
			UniAppManager.app.fnCalcTotAmt(grdRecord, record['TAX_AMT_I'], record['ADD_REDUCE_AMT_I']);
		},
		
		setCorporationCardData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CRDT_NUM'     		,record['CRDT_NUM']);	
			grdRecord.set('CRDT_FULL_NUM'     	,record['CRDT_FULL_NUM']);	
			grdRecord.set('BILL_DATE'     		,record['APPR_DATE']);	
			grdRecord.set('CUSTOM_NAME'     	,record['CHAIN_NAME']);	
			grdRecord.set('SUPPLY_AMT_I'     	,record['APPR_AMT_I']);
			grdRecord.set('TAX_AMT_I'     		,0);
//			grdRecord.set('TAX_AMT_I'     		,record['APPR_TAX_I']);
			grdRecord.set('PAY_DIVI'     		,record['PAY_DIVI']);	
			grdRecord.set('PAY_CUSTOM_CODE'     ,record['PAY_CUSTOM_CODE']);	
			grdRecord.set('PAY_CUSTOM_NAME'     ,record['PAY_CUSTOM_NAME']);	
			grdRecord.set('SEND_DATE'     		,record['SEND_DATE']);	
			grdRecord.set('REFER_NUM'     		,record['REFER_NUM']);	
			grdRecord.set('CANCEL_YN'     		,record['CANCEL_YN']);	
			grdRecord.set('REMARK'				,(record['APPR_DATE'] + record['CHAIN_NAME']));
			
			grdRecord.set('DRAFT_SEQ'     		,gsDraftSeq);	
			grdRecord.set('BUDG_CODE'     		,gsDraftBudgCode);
			UniAppManager.app.fnCalcTaxAmt(grdRecord, record['APPR_AMT_I']);
			
			if(!Ext.isEmpty(gsDraftBudgCode)){
			
				var param = {"AC_YYYY": UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
							"BUDG_CODE": gsDraftBudgCode,
							"ADD_QUERY" : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
						   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'",
							"budgNameInfoList" : budgNameList					
							};
				popupService.budgPopup(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						var budgName = "BUDG_NAME_L"+provider[0]["CODE_LEVEL"];
	            		
	            		grdRecord.set('BUDG_CODE'		,provider[0]['BUDG_CODE']);
						grdRecord.set('BUDG_NAME'		,provider[0][budgName]);
						grdRecord.set('ACCNT'			,provider[0]['ACCNT']);
						grdRecord.set('ACCNT_NAME'		,provider[0]['ACCNT_NAME']);
						grdRecord.set('PJT_CODE'		,provider[0]['PJT_CODE']);
						grdRecord.set('PJT_NAME'		,provider[0]['PJT_NAME']);
						grdRecord.set('SAVE_CODE'		,provider[0]['SAVE_CODE']);
						grdRecord.set('SAVE_NAME'		,provider[0]['SAVE_NAME']);
						grdRecord.set('BANK_ACCOUNT'	,provider[0]['BANK_ACCOUNT']);
						
						UniAppManager.app.fnGetBudgPossAmt(grdRecord);
						UniAppManager.app.fnCalcTaxAmt(grdRecord, record['APPR_AMT_I']);
					}
				});
			}
		}
    });   
    var corporationCardGrid = Unilite.createGrid('afb700ukrCorporationCardGrid', {//법인카드승인참조
        layout : 'fit',
        excelTitle: '법인카드승인참조',
    	store: corporationCardStore,
    	uniOpt: {
    		onLoadSelectFirst: false  
        },
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
        columns:  [  
//			{ dataIndex: 'CRDT_COMP_CD'			, width:88,hidden:true},	추후 보수 작업시 필요
			{ dataIndex: 'CRDT_COMP_NM'			, width:100},
//			{ dataIndex: 'CRDT_NUM'				, width:88,hidden:true},	추후 보수 작업시 필요
			{ dataIndex: 'CRDT_FULL_NUM'		, width:150},
			{ dataIndex: 'APPR_DATE'			, width:100},
			{ dataIndex: 'CHAIN_NAME'			, width:150},
			{ dataIndex: 'CHAIN_ID'				, width:120},
//			{ dataIndex: 'CUSTOM_CODE'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'CUSTOM_NAME'			, width:88,hidden:true},	추후 보수 작업시 필요
			{ dataIndex: 'APPR_AMT_I'			, width:100},
			{ dataIndex: 'APPR_TAX_I'			, width:100},
			{ dataIndex: 'APPR_NO'				, width:100},
			{ dataIndex: 'DEDUCT_YN'			, width:88}
//			{ dataIndex: 'PAY_DIVI'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'PAY_CUSTOM_CODE'		, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'PAY_CUSTOM_NAME'		, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'SEND_DATE'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'REFER_NUM'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'CANCEL_YN'			, width:88,hidden:true}		추후 보수 작업시 필요
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn2();
			}
		},
		returnData: function()	{
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	detailGrid.setCorporationCardData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}
    });
    
    var draftNoGrid = Unilite.createGrid('afb700ukrDraftNoGrid', {//예산기안참조
        layout : 'fit',
        excelTitle: '예산기안참조',
    	store: draftNoStore,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        columns:  [  
			{ dataIndex: 'DRAFT_NO'				, width:120},
			{ dataIndex: 'DRAFT_DATE'			, width:88},
			{ dataIndex: 'DRAFTER'				, width:88,hidden:true},
			{ dataIndex: 'PAY_USER'				, width:88},
			{ dataIndex: 'DEPT_CODE'			, width:88,hidden:true},
			{ dataIndex: 'DEPT_NAME'			, width:88},
			{ dataIndex: 'DIV_NAME'				, width:120},
			{ dataIndex: 'TITLE'				, width:250},
			{ dataIndex: 'BUDG_AMT'				, width:100},
			{ dataIndex: 'PAY_DRAFT_AMT'		, width:100},
			{ dataIndex: 'DRAFT_REMIND_AMT'		, width:100}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				draftNoGrid.returnData(record);
				referDraftNoWindow.hide();
				subStore.loadStoreRecords();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      		record = this.getSelectedRecord();
      	}
      	detailForm.setValues({
      		'DRAFT_NO':record.get('DRAFT_NO'),
      		'TITLE':record.get('TITLE'),
      		'DRAFT_TITLE':record.get('TITLE')
      		});
       	}
    });
    
    var payDtlNoGrid = Unilite.createGrid('afb700ukrPayDtlNoGrid', {//지급명세서참조
        layout : 'fit',
        excelTitle: '지급명세서참조',
    	store: payDtlNoStore,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        columns:  [  
			{ dataIndex: 'PAY_DTL_NO'			, width:120},
			{ dataIndex: 'PAY_DATE'				, width:88},
			{ dataIndex: 'DRAFTER'				, width:88},
			{ dataIndex: 'DEPT_CODE'			, width:88,hidden:true},
			{ dataIndex: 'DEPT_NAME'			, width:88},
			{ dataIndex: 'DIV_NAME'				, width:120},
			{ dataIndex: 'TITLE'				, width:250},
			{ dataIndex: 'TOT_AMT_I'			, width:100},
			{ dataIndex: 'PAY_DRAFT_NO'			, width:120}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				payDtlNoGrid.returnData(record);
				referPayDtlNoWindow.hide();
				payDtlNoStore.loadStoreRecords();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      		record = this.getSelectedRecord();
      	}
      	detailForm.setValues({
			'PAY_DTL_NO':record.get('PAY_DTL_NO'),
      		'PAY_DTL_TITLE':record.get('TITLE'),
      		'PAY_DTL_AMT':record.get('TOT_AMT_I')
      		});
       	}
    });
    var dedAmtGrid = Unilite.createGrid('afb700ukrDedAmtGrid', {//급여공제
        layout : 'fit',
        excelTitle: '급여공제',
    	store: dedAmtDetailStore,
    	uniOpt: {
    		onLoadSelectFirst: false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false
    		
        },
        bbar: ['->',{
        	fieldLabel:'공제금액 합계',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarDedAmtBbar',
        	name:'DED_AMT',
        	readOnly:true
		}],
        columns:  [  
			{ dataIndex: 'SEQ'						, width:66},
//			{ dataIndex: 'COMP_CODE'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'PAY_DRAFT_NO'				, width:88,hidden:true},	추후 보수 작업시 필요
			{ dataIndex: 'DED_CODE'					, width:100},
			{ dataIndex: 'DED_NAME'					, width:150},
			{ dataIndex: 'DED_AMOUNT_I'				, width:120}
//			{ dataIndex: 'PAY_YYYYMM'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'SUPP_TYPE'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'COST_POOL'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'PERSON_GROUP'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'AFFIL_CODE'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'FR_DEPT_CODE'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'FR_DEPT_NAME'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'TO_DEPT_CODE'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'TO_DEPT_NAME'				, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'INSERT_DB_USER'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'INSERT_DB_TIME'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'UPDATE_DB_USER'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'UPDATE_DB_TIME'			, width:88,hidden:true},	추후 보수 작업시 필요
//			{ dataIndex: 'UPDATE_MODE'				, width:88,hidden:true}		추후 보수 작업시 필요
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				dedAmtGrid.returnData(record);
				popDedAmtWindow.hide();
				
			}
		},
		setDedAmtNewData:function(record){
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('SEQ'						,record.data.SEQ);
			grdRecord.set('COMP_CODE'				,record.data.COMP_CODE);
			grdRecord.set('PAY_DRAFT_NO'			,record.data.PAY_DRAFT_NO);
			grdRecord.set('DED_CODE'				,record.data.DED_CODE);
			grdRecord.set('DED_NAME'				,record.data.DED_NAME);
			grdRecord.set('DED_AMOUNT_I'			,record.data.DED_AMOUNT_I_DUMMY);//쿼리에 A.DED_AMOUNT_I AS DED_AMOUNT_I_DUMMY
			grdRecord.set('PAY_YYYYMM'				,record.data.PAY_YYYYMM);
			grdRecord.set('SUPP_TYPE'				,record.data.SUPP_TYPE);
			grdRecord.set('COST_POOL'				,record.data.COST_POOL);
			grdRecord.set('PERSON_GROUP'			,record.data.PERSON_GROUP);
			grdRecord.set('AFFIL_CODE'				,record.data.AFFIL_CODE);
			grdRecord.set('FR_DEPT_CODE'			,record.data.FR_DEPT_CODE);
			grdRecord.set('FR_DEPT_NAME'			,record.data.FR_DEPT_NAME);
			grdRecord.set('TO_DEPT_CODE'			,record.data.TO_DEPT_CODE);
			grdRecord.set('TO_DEPT_NAME'			,record.data.TO_DEPT_NAME);
			grdRecord.set('UPDATE_MODE'				,record.data.UPDATE_MODE);

		},
		returnData: function()	{
				if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	panelSeach.setValues({});
          	detailForm.setValues({});
       	}
    });
    function openCorporationCardWindow() {    		//법인카드승인참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
		if(!referCorporationCardWindow) {
			referCorporationCardWindow = Ext.create('widget.uniDetailWindow', {
                title: '법인카드승인참조',
                width: 1100,				                
                height: 350,
                layout:{type:'vbox', align:'stretch'},
                items: [corporationCardSearch, corporationCardGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							corporationCardStore.loadStoreRecords();
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '참조적용',
						handler: function() {
							corporationCardGrid.returnData();
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '참조적용 후 닫기',
						handler: function() {
							corporationCardGrid.returnData();
							referCorporationCardWindow.hide();
							corporationCardGrid.reset();
							corporationCardSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							referCorporationCardWindow.hide();
							corporationCardGrid.reset();
							corporationCardSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
						corporationCardSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
						corporationCardSearch.setValue('TO_DATE',UniDate.get('today'));
						corporationCardSearch.setValue('SLIP_DATE',UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')));
						corporationCardSearch.setValue('PAY_USER',detailForm.getValue('PAY_USER_PN'));
		 			}
				}
			})
		}
		referCorporationCardWindow.center();
		referCorporationCardWindow.show();
    }
    function openDraftNoWindow() {    		//예산기안참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!referDraftNoWindow) {
			referDraftNoWindow = Ext.create('widget.uniDetailWindow', {
                title: '예산기안참조',
                width: 1100,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [draftNoSearch, draftNoGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!draftNoSearch.getInvalidMessage()) return;
							draftNoStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							referDraftNoWindow.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
		 				draftNoSearch.setValue('DRAFT_NO','');
		 				draftNoSearch.setValue('FR_DATE', (UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4)) + '0101');
						draftNoSearch.setValue('TO_DATE', detailForm.getValue('PAY_DATE'));
						draftNoSearch.setValue('DRAFTER_PN', detailForm.getValue('DRAFTER_PN'));
						draftNoSearch.setValue('DRAFTER_NM', detailForm.getValue('DRAFTER_NM'));
						draftNoSearch.setValue('DEPT_CODE', detailForm.getValue('DEPT_CODE'));
						draftNoSearch.setValue('DEPT_NAME', detailForm.getValue('DEPT_NAME'));
						
						if(gsChargeDivi == '1'){
							draftNoSearch.getField('DEPT_CODE').setReadOnly(false);
							draftNoSearch.getField('DEPT_NAME').setReadOnly(false);	
						}else{
							draftNoSearch.getField('DEPT_CODE').setReadOnly(true);
							draftNoSearch.getField('DEPT_NAME').setReadOnly(true);	
						}
						if(!draftNoSearch.getInvalidMessage()) return;
						draftNoStore.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		referDraftNoWindow.center();
		referDraftNoWindow.show();
    }
    
    function openPayDtlNoWindow() {    		//지급명세서참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
		if(!referPayDtlNoWindow) {
			referPayDtlNoWindow = Ext.create('widget.uniDetailWindow', {
                title: '지급명세서참조',
                width: 1000,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [payDtlNoSearch, payDtlNoGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!payDtlNoSearch.getInvalidMessage()) return;
							payDtlNoStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							referPayDtlNoWindow.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
		 				payDtlNoSearch.setValue('FR_DATE', (UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4)) + '0101');
						payDtlNoSearch.setValue('TO_DATE', detailForm.getValue('PAY_DATE'));
						payDtlNoSearch.setValue('DRAFTER_PN', detailForm.getValue('DRAFTER_PN'));
						payDtlNoSearch.setValue('DRAFTER_NM', detailForm.getValue('DRAFTER_NM'));
//						gsChargeDivi
						payDtlNoSearch.setValue('DEPT_CODE', detailForm.getValue('DEPT_CODE'));
						payDtlNoSearch.setValue('DEPT_NAME', detailForm.getValue('DEPT_NAME'));
						
						if(gsChargeDivi == '1'){
							draftNoSearch.getField('DEPT_CODE').setReadOnly(false);
							draftNoSearch.getField('DEPT_NAME').setReadOnly(false);	
						}else{
							draftNoSearch.getField('DEPT_CODE').setReadOnly(true);
							draftNoSearch.getField('DEPT_NAME').setReadOnly(true);	
						}
						if(!payDtlNoSearch.getInvalidMessage()) return;
						payDtlNoStore.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		referPayDtlNoWindow.center();
		referPayDtlNoWindow.show();
    }
	function openDedAmtWindow() {    		//급여공제
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
		if(!popDedAmtWindow) {
			popDedAmtWindow = Ext.create('widget.uniDetailWindow', {
                title: '급여공제',
                width: 470,				                
                height: 600,
                layout:{type:'vbox', align:'stretch'},
                items: [dedAmtSearch, dedAmtGrid],
                tbar:  ['->',
					{	
						text: '조회',
						handler: function() {
							if(!dedAmtSearch.getInvalidMessage()) return;	//필수체크

							UniAppManager.app.fnDedAmtQueryBtn();
						},
						disabled: false
					},{	
						text: '저장',
						handler: function() {
							
							if(!dedAmtSearch.getInvalidMessage()) return;	//필수체크 

							dedAmtDetailStore.saveStore('S');

						},
						disabled: false
					},{	
						text: '전체삭제',
						handler: function() {
							
							UniAppManager.app.onDedAmtDeleteAllBtn();
						},
						disabled: false
					},{
						text: '확인',
						handler: function() {
							UniAppManager.app.onDedAmtOkBtn();
							
							popDedAmtWindow.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							UniAppManager.app.onDedAmtCancBtn();
							
							popDedAmtWindow.hide();
							
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

                		dedAmtGrid.reset();
						dedAmtSearch.clearForm();
						Ext.getCmp('bbarDedAmtBbar').setValue(0);
                		dedAmtSearch.getField("SUPP_TYPE").setConfig('allowBlank',true);	
					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			show: function ( panel, eOpts )	{
		 				dedAmtSearch.setValue('PAY_DRAFT_NO', detailForm.getValue('PAY_DRAFT_NO'));
		 				dedAmtSearch.setValue('PAY_YYMM', UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 6));
		 				dedAmtSearch.setValue('HDD_STATUS', detailForm.getValue('HDD_STATUS'));
		 				dedAmtSearch.setValue('HDD_DED_DATA_YN', detailForm.getValue('HDD_DED_DATA_YN'));
		 				
		 				gsExistYN = dedAmtSearch.getValue('HDD_DED_DATA_YN');
						dedAmtSearch.setValue('HDD_QUERY_FLAG', 'N');
						
						if(gsExistYN == 'Y'){
							
							if(!dedAmtSearch.getInvalidMessage()) return; //필수체크
							conditionCheck = 'Y';
							
							UniAppManager.app.fnDedAmtQueryBtn();
						}
		 			}
				}
			})
		}
		popDedAmtWindow.center();
		popDedAmtWindow.show();
    }
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				subGrid,subForm, detailGrid, detailForm
			]
		}], 
		id : 'Afb700ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'], false);

			detailForm.getField('PAY_DTL_TITLE').setReadOnly(true);
//			Ext.getCmp('detailGridId').getBottomToolbar().getEl().dom.style.background = 'black';
			this.setDefault(params);
			detailForm.onLoadSelectText('PAY_DATE');
			
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			directDetailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function(copyCheck)	{
			if(!detailForm.getInvalidMessage()) return false;
			
			var compCode      = UserInfo.compCode;
			var payDraftNo    = detailForm.getValue('PAY_DRAFT_NO');
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var budgGubun     = detailForm.getValue('BUDG_GUBUN');
			var bizRemark     = gsBizRemark;
			var bizGubun      = gsBizGubun;
			var addReduceAmtI = 0;
			var ebYn	      = 'N';
			var deptCode      = detailForm.getValue('DEPT_CODE');
			var deptName      = detailForm.getValue('DEPT_NAME');
			var divCode       = detailForm.getValue('DIV_CODE');
			var draftNo	      = detailForm.getValue('DRAFT_NO');
			var billDate      = detailForm.getValue('SLIP_DATE');
			
			
            var r = {
            	COMP_CODE : compCode,     
				PAY_DRAFT_NO : payDraftNo,
				SEQ	 		 : seq,
				BUDG_GUBUN : budgGubun,
				BIZ_REMARK : bizRemark,    
				BIZ_GUBUN : bizGubun,     
				ADD_REDUCE_AMT_I : addReduceAmtI,
				EB_YN : ebYn,	     
				DEPT_CODE : deptCode,     
				DEPT_NAME : deptName,    
				DIV_CODE : divCode,     
				DRAFT_NO : draftNo,	     
				BILL_DATE : billDate
	        };
	        if(copyCheck == 'Y'){
	        	detailGrid.createRow(r);	
	        }else{
				detailGrid.createRow(r,'BUDG_CODE');
	        }
				
		},
		copyDataCreateRow: function()	{
			var seq = directDetailStore.max('SEQ');
        	if(!seq){
        		seq = 1;
        	}else{
        		seq += 1;
        	}
            var r = {  
				SEQ	 		 : seq
	        };
			detailGrid.createRow(r);
		},
		onDedAmtNewDataCreateRow: function()	{
			dedAmtGrid.createRow();
		},
		
		onResetButtonDown: function() {		
			detailForm.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.app.fnMasterDisable(false);
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
		},
		onSaveDataButtonDown: function(config) {
			if(!detailForm.getInvalidMessage()) return false; 
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var records = directDetailStore.data.items;
			var selRow = detailGrid.getSelectedRecord();
			var lCnt = 0;
			var sPayDraftNo = '';
			
			var realAmtI;
			var oldTotAmtI;
			var newTotAmtI;
			
			if(detailForm.getValue('EX_NUM') != '' || detailForm.getValue('HDD_STATUS') != '0' || detailForm.getValue('HDD_APP') != '0'){
				sPayDraftNo = selRow.get('PAY_DRAFT_NO');
				
				Ext.each(records, function(record,i){
					if(sPayDraftNo == record.get('PAY_DRAFT_NO')){
						lCnt = lCnt + 1;	
					}
				})
				
				if(lCnt < 2){
					Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0531);
					return false;
				}
			}						
			
			
			if(selRow.phantom === true)	{
				oldTotAmtI = Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
				realAmtI = selRow.get('REAL_AMT_I');
				
				detailGrid.deleteSelectedRow();
				
				Ext.getCmp('bbarDetailGridBbar').setValue(oldTotAmtI-realAmtI);
				
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				oldTotAmtI = Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
				realAmtI = selRow.get('REAL_AMT_I');
				
				detailGrid.deleteSelectedRow();
				
				Ext.getCmp('bbarDetailGridBbar').setValue(oldTotAmtI-realAmtI);
				
			}
		},
		onDeleteAllButtonDown: function() {
			
			if(!detailForm.getInvalidMessage()) return;   
				       
			if(confirm('전체삭제 하시겠습니까?')) {
				var encryptPass = new String;
				
				if(gsIdMapping == 'Y'){
					encryptPass = detailForm.getValue('PASSWORD');
				}else{
//				var encryptPass = new String;
				var temp1 = new Array();
				var temp2 = new Array();
				var textSize = detailForm.getValue('PASSWORD').length;
				    for (i = 0; i < textSize; i++) {
				        rnd = Math.round(Math.random() * 122) + 68;
				        temp1[i] = detailForm.getValue('PASSWORD').charCodeAt(i) + rnd;
				        temp2[i] = rnd;
				    }
				    for (i = 0; i < textSize; i++) {
				        encryptPass += String.fromCharCode(temp1[i], temp2[i]);
				    }
				}
				
				var param = {
					PAY_DRAFT_NO: detailForm.getValue('PAY_DRAFT_NO'),
					DRAFTER_PN  : detailForm.getValue('DRAFTER_PN'),
					PASSWORD  : encryptPass
//					PASSWORD  : detailForm.getValue('PASSWORD')
				}
				detailForm.getEl().mask('전체삭제 중...','loading-indicator');
				subForm.getEl().mask('전체삭제 중...','loading-indicator');
				subGrid.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid.getEl().mask('전체삭제 중...','loading-indicator');
				afb700ukrService.afb700ukrDelA(param, function(provider, response)	{							
					if(provider){	
						UniAppManager.updateStatus(Msg.sMB013);
						
						UniAppManager.app.onResetButtonDown();		
					}
					detailForm.getEl().unmask();		
					subForm.getEl().unmask();		
					subGrid.getEl().unmask();		
					detailGrid.getEl().unmask();
					
				});
			}else{
				return false;	
			}
		},

		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb700skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'afb710skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'afb555skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'agd340ukr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'afb900ukr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}
		},
		setDefault: function(params){
			
			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.PAY_DRAFT_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		/**
		 * 프로그램별 사용 컬럼 공통코드B114 관련	
		 */
		setHiddenColumn1: function() {
			Ext.each(useColList1, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					detailGrid.getColumn(record.REF_CODE3).setHidden(true);
				}
			});
		},
		setHiddenColumn2: function() {
			Ext.each(useColList2, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					corporationCardGrid.getColumn(record.REF_CODE3).setHidden(true);
				}
			});
		},
		/**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 */
		fnInitInputProperties: function() {
			
			 /* '프로그램의 사업장권한이 전체(멀티)권한이 아닌 경우, 사업장 비활성화 처리
    If gsAuParam(0) <> "N" Then
        cboDivCode.disabled	= True
        btnDivCode.disabled = True
    End If*/
			
			//지출관리 아이디와 1:1 매핑
			if(gsIdMapping == 'Y'){
					
				detailForm.getField('DRAFTER_PN').setReadOnly(true);
				detailForm.getField('DRAFTER_NM').setReadOnly(true);
				
				detailForm.getField("DRAFTER_PN").setConfig('allowBlank',true);
				detailForm.getField("DRAFTER_NM").setConfig('allowBlank',true);
				
				Ext.getCmp('passWord').setHidden(true);
				Ext.getCmp('hiddenHtml').setHidden(true);
				
				detailForm.getField("PASSWORD").setConfig('allowBlank',true);
			}else{
					
				detailForm.getField('DRAFTER_PN').setReadOnly(false);
				detailForm.getField('DRAFTER_NM').setReadOnly(false);
				
				detailForm.getField("DRAFTER_PN").setConfig('allowBlank',false);
				detailForm.getField("DRAFTER_NM").setConfig('allowBlank',false);
				
				Ext.getCmp('passWord').setHidden(false);
				Ext.getCmp('hiddenHtml').setHidden(false);
				
				detailForm.getField("PASSWORD").setConfig('allowBlank',false);
			}
			
			//지출결의 그룹웨어 연동여부
			if(gsLinkedGW == 'Y'){
				
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0437);
				Ext.getCmp('rdoStatus').setHidden(false);
				
				if(gsAmender == 'Y'){
					
					Ext.getCmp('btnReAuto').setHidden(false);
					Ext.getCmp('btnReCancel').setHidden(false);
				}else{
					
					Ext.getCmp('btnReAuto').setHidden(true);
					Ext.getCmp('btnReCancel').setHidden(true);
				}
				
				
			}else{
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0438);
				Ext.getCmp('btnReAuto').setHidden(true);
				Ext.getCmp('btnReCancel').setHidden(true);
				Ext.getCmp('rdoStatus').setHidden(true);
			}
			
			//예산기안참조 필수 여부
			if(gsDraftRef == 'Y'){
				detailForm.getField("DRAFT_NO").setConfig('allowBlank',false);
			}else{
				detailForm.getField("DRAFT_NO").setConfig('allowBlank',true);	
			}
			
			//지급명세서참조 사용(N) and 지출결의_지출승인 프로세스 사용(N)안하면 trPayDtlNoApp hidden 처리
			if(gsPayDtlRef == 'N' && gsAppBtnUse == 'N'){
				Ext.getCmp('tdPayDtlNo').setHidden(true);
				Ext.getCmp('btnAppPro').setHidden(true);
			}else{
				Ext.getCmp('tdPayDtlNo').setHidden(false);
				Ext.getCmp('btnAppPro').setHidden(false);
			}
			
			//지급명세서참조 사용여부
			if(gsPayDtlRef == 'Y'){
				Ext.getCmp('tdPayDtlNo').setHidden(false);
			}else{
				Ext.getCmp('tdPayDtlNo').setHidden(true);
			}
			
			//내용 표시여부
			if(gsContents == 'Y'){
				Ext.getCmp('tdTitleDesc').setHidden(false);				
			}else{
				Ext.getCmp('tdTitleDesc').setHidden(true);	
			}
			
			//지출결의_지출승인 프로세스 사용
			if(gsAppBtnUse == 'Y'){
				Ext.getCmp('rdoAppStatus').setHidden(false);
				
				if(gsAppBtnUser == 'Y'){
					Ext.getCmp('btnAppPro').setHidden(false);		
				}else{
					Ext.getCmp('btnAppPro').setHidden(true);
				}
			}else{
				Ext.getCmp('rdoAppStatus').setHidden(true);	
				Ext.getCmp('btnAppPro').setHidden(true);
				
			}
			
			detailForm.getField('PAY_DATE').focus();
		},

		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){
			//지출작성일
			detailForm.setValue('PAY_DATE', UniDate.get('today'));
			
			//지출작성자
			detailForm.setValue('DRAFTER_PN',gsDrafter);
			detailForm.setValue('DRAFTER_NM',gsDrafterNm);
			
			//사용일(전표일)
			detailForm.setValue('SLIP_DATE', UniDate.get('today'));
			detailForm.setValue('EX_NUM','');
			
			//비밀번호
			detailForm.setValue('PASSWORD','');	
			
			//지출결의번호
			detailForm.setValue('PAY_DRAFT_NO','');
			
			//사용자
			detailForm.setValue('PAY_USER_PN',gsDrafter);
			detailForm.setValue('PAY_USER_NM',gsDrafterNm);
			
			//사업장
			detailForm.setValue('DIV_CODE', gsDivCode);
			
			//예산부서
			detailForm.setValue('DEPT_CODE',gsDeptCode);
			detailForm.setValue('DEPT_NAME',gsDeptName);
			
			//예산구분
			detailForm.setValue('BUDG_GUBUN','1');
			
			//회계구분
			detailForm.setValue('ACCNT_GUBUN', gsAccntGubun);
			
			//문서서식구분 A171의 REF_CODE6값
			UniAppManager.app.fnGetA171RefCode();
			
			//지출건명
			detailForm.setValue('TITLE','');	
			
			//상태(미상신)
			detailForm.getField('STATUS').setValue('0');
			
			//지출승인(미승인)
			detailForm.getField('APP').setValue('0');
			
			//내용
			detailForm.setValue('TITLE_DESC','');
			
			//예산기안참조
			detailForm.setValue('DRAFT_NO','');
			detailForm.setValue('DRAFT_TITLE','');
			
			//지급명세서참조
			detailForm.setValue('PAY_DTL_NO','');
			detailForm.setValue('PAY_DTL_TITLE','');
			detailForm.setValue('PAY_DTL_AMT','');
			
			//실지급액 합계
			Ext.getCmp('bbarDetailGridBbar').setValue('');
			//상태
			detailForm.setValue('HDD_STATUS','0');
			
			//지출상태
			detailForm.setValue('HDD_APP','0');
			
			//최초입력자
			detailForm.setValue('HDD_INSERT_DB_USER','');
			
			//저장유형
			detailForm.setValue('HDD_SAVE_TYPE','N');
			
			//복사자료
			detailForm.setValue('HDD_COPY_DATA','');
			
			//급여공제데이터 유무
			detailForm.setValue('HDD_DED_DATA_YN','');
			
			//급여공제합계
			detailForm.setValue('DED_AMT_TOT',0);
			
			detailForm.getField('PAY_DATE').focus();
		},
		
		/**
		 * 지출결의 마스터정보 표시
		 */
		fnDispMasterData:function(qryType){
			if(qryType == 'COPY'){
				//지출작성일
				detailForm.setValue('PAY_DATE',UniDate.get('today'));
				
				//지출작성자
				detailForm.setValue('DRAFTER_PN',gsDrafter);
				detailForm.setValue('DRAFTER_NM',gsDrafterNm);
				
				//사용일(전표일)
				detailForm.setValue('SLIP_DATE',UniDate.get('today'));
				detailForm.setValue('EX_NUM','');
				
				//지출결의번호
				detailForm.setValue('PAY_DRAFT_NO','');
				
				//상태
				detailForm.getField('STATUS').setValue('0');
				
				//지출승인상태
				detailForm.getField('APP').setValue('0');
				
				//상태
				detailForm.setValue('HDD_STATUS','0');
				
				//지출결의 그룹웨어 연동여부 AND 지출승인 버튼 사용유무
				if(gsLinkedGW == 'N' && gsAppBtnUse == 'Y'){
					detailForm.setValue('HDD_APP','0');
					detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0527);
					Ext.getCmp('btnProc').setDisabled(false);
				}
				
				//최초입력자
				detailForm.setValue('HDD_INSERT_DB_USER','');
				
				//저장유형
				detailForm.setValue('HDD_SAVE_TYPE','N');
				
				//복사자료
				detailForm.setValue('HDD_COPY_DATA','Y');
				
				//급여공제데이터 유무
				detailForm.setValue('HDD_DED_DATA_YN','');
				
				//급여공제합계
				detailForm.setValue('DED_AMT_TOT',0);
				
//				UniAppManager.app.fnDispRealAmt(),,,,;
			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					
					
					//지출작성일
					detailForm.setValue('PAY_DATE','');
					
					//지출작성자
					detailForm.setValue('DRAFTER_PN','');
					detailForm.setValue('DRAFTER_NM','');
					
					//사용일(전표일)
					detailForm.setValue('SLIP_DATE','');
					detailForm.setValue('EX_NUM','');
					
					
					//사용자
					detailForm.setValue('PAY_USER_PN','');
					detailForm.setValue('PAY_USER_NM','');
					
					//사업장
					detailForm.setValue('DIV_CODE','');
					
					//예산부서
					detailForm.setValue('DEPT_CODE','');
					detailForm.setValue('DEPT_NAME','');	
					
					//예산구분
					detailForm.setValue('BUDG_GUBUN','');
					
					//회계구분
					detailForm.setValue('ACCNT_GUBUN','');
					
					//지출건명
					detailForm.setValue('TITLE','');

					//상태
					detailForm.getField('STATUS').setValue('0');
					
					//지출승인상태
					detailForm.getField('APP').setValue('0');
					
					//내용
					detailForm.setValue('TITLE_DESC','');
					
					//예산기안참조
					detailForm.setValue('DRAFT_NO','');
					detailForm.setValue('DRAFT_TITLE','');
					
					//지급명세서참조
					detailForm.setValue('PAY_DTL_NO','');
					detailForm.setValue('PAY_DTL_TITLE','');
					detailForm.setValue('PAY_DTL_AMT','');
					
					//실지급액 합계
					Ext.getCmp('bbarDetailGridBbar').setValue(0);
					//상태
					detailForm.setValue('HDD_STATUS','0');
					
					//지출결의 그룹웨어 연동여부 AND 지출승인 버튼 사용유무
					if(gsLinkedGW == 'N' && gsAppBtnUse == 'Y'){
						detailForm.setValue('HDD_APP','0');
						detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0527);
						Ext.getCmp('btnProc').setDisabled(false);
					}
					
					//최초입력자
					detailForm.setValue('HDD_INSERT_DB_USER','');
					
					//저장유형
					detailForm.setValue('HDD_SAVE_TYPE','N');
					
					//복사자료
					detailForm.setValue('HDD_COPY_DATA','');
					
					//급여공제데이터 유무
					detailForm.setValue('HDD_DED_DATA_YN','');
					
					//급여공제합계
					detailForm.setValue('DED_AMT_TOT',0);
						
						
					Ext.Msg.alert(Msg.sMB099,Msg.sMB025);
					
					return false;
				}else{
					
					var masterRecord = directMasterStore.data.items[0];
					
					//지출작성일
					detailForm.setValue('PAY_DATE',masterRecord.data.PAY_DATE);
					
					//사용일(전표일)
					detailForm.setValue('SLIP_DATE',masterRecord.data.SLIP_DATE);
					detailForm.setValue('EX_NUM',masterRecord.data.EX_NUM);
					
					//지출결의번호
					detailForm.setValue('PAY_DRAFT_NO',masterRecord.data.PAY_DRAFT_NO);
					
					//상태
					detailForm.getField('STATUS').setValue(masterRecord.data.STATUS);
					
					//지출상태
					detailForm.getField('APP').setValue(masterRecord.data.STATUS);
					
					//지출작성자
					detailForm.setValue('DRAFTER_PN',masterRecord.data.DRAFTER);
					detailForm.setValue('DRAFTER_NM',masterRecord.data.DRAFTER_NM);
					
					//사용자
					detailForm.setValue('PAY_USER_PN',masterRecord.data.PAY_USER);
					detailForm.setValue('PAY_USER_NM',masterRecord.data.PAY_USER_NM);
					
					//사업장
					detailForm.setValue('DIV_CODE',masterRecord.data.DIV_CODE);
					
					//예산부서
					detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
					detailForm.setValue('DEPT_NAME',masterRecord.data.DEPT_NAME);
					
					//예산구분
					detailForm.setValue('BUDG_GUBUN',masterRecord.data.BUDG_GUBUN);
					
					//회계구분
					detailForm.setValue('ACCNT_GUBUN',masterRecord.data.ACCNT_GUBUN);
					
					//문서서식구분 A171의 REF_CODE6값
					UniAppManager.app.fnGetA171RefCode();
					
					//지출건명
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
					
					//내용
					detailForm.setValue('TITLE_DESC',masterRecord.data.TITLE_DESC);
					
					//예산기안참조
					detailForm.setValue('DRAFT_NO',masterRecord.data.DRAFT_NO);
					detailForm.setValue('DRAFT_TITLE',masterRecord.data.DRAFT_TITLE);
					
					//지급명세서참조
					detailForm.setValue('PAY_DTL_NO',masterRecord.data.PAY_DTL_NO);
					detailForm.setValue('PAY_DTL_TITLE',masterRecord.data.PAY_DTL_TITLE);
					detailForm.setValue('PAY_DTL_AMT',masterRecord.data.PAY_DTL_AMT);
					
					//실지급액 합계
					Ext.getCmp('bbarDetailGridBbar').setValue(masterRecord.data.TOT_AMT_I);
					//상태
					detailForm.setValue('HDD_STATUS',masterRecord.data.STATUS);
					
					//지출결의 그룹웨어 연동여부 AND 지출승인 버튼 사용유무
					if(gsLinkedGW == 'N' && gsAppBtnUse == 'Y'){
						//지출상태
						detailForm.setValue('HDD_APP',masterRecord.data.STATUS);	
						
						if(masterRecord.data.STATUS == '9'){
							detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0528);
							
							if(gsAmender == 'Y'){
								Ext.getCmp('btnProc').setDisabled(false);
							}else{
								Ext.getCmp('btnProc').setDisabled(true);	
							}
						}else{
							detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0527);	
							Ext.getCmp('btnProc').setDisabled(false);
						}
					}
					
					//최초입력자
					detailForm.setValue('HDD_INSERT_DB_USER',masterRecord.data.INSERT_DB_USER);
					
					//저장유형
					detailForm.setValue('HDD_SAVE_TYPE','');
					
					//복사자료
					detailForm.setValue('HDD_COPY_DATA','');
					
					//급여공제버튼 사용여부
					detailForm.setValue('HDD_PAY_GUBUN',masterRecord.data.PAY_GUBUN);
					
					if(masterRecord.data.PAY_GUBUN == 'Y'){
						Ext.getCmp('btnDedAmt').setHidden(false);
						Ext.getCmp('dedAmtTot').setHidden(false);		
					
						if(detailForm.getValue('PAY_DRAFT_NO') == ''){
							Ext.getCmp('btnDedAmt').setDisabled(true);	
						}else{
							Ext.getCmp('btnDedAmt').setDisabled(false);	
						}
					}else{
						Ext.getCmp('btnDedAmt').setHidden(true);
						Ext.getCmp('dedAmtTot').setHidden(true);			
					}
					
					//급여공제데이터 유무
					detailForm.setValue('HDD_DED_DATA_YN',masterRecord.data.DED_DATA_YN);
					
					//급여공제합계
					detailForm.setValue('DED_AMT_TOT',masterRecord.data.DED_AMT_TOT);
				}
			}			
		},
		/**
		 * 프리폼 입력제어 처리
		 */
		fnMasterDisable:function(bBool){
			var bExcept;
			
			bExcept = false;
			
			//조건1) 자동기표 되었거나 상신되었으면 입력란의 수정불가
			if(detailForm.getValue('EX_NUM') != '' || Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
				bBool = true;
			}
			
			//조건2) 등록된 수정자이며 "반려"가 아니라면 입력란의 수정가능
			if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
				if(bBool == true){
					bExcept = true;
					bBool = false;
				}
			}
			
			//지출작성일
			detailForm.getField('PAY_DATE').setReadOnly(bBool);
			
			//지출작성자
			if(gsIdMapping == 'Y'){
				detailForm.getField('DRAFTER_PN').setReadOnly(true);	
				detailForm.getField('DRAFTER_NM').setReadOnly(true);	
			}else{
				detailForm.getField('DRAFTER_PN').setReadOnly(bBool);	
				detailForm.getField('DRAFTER_NM').setReadOnly(bBool);		
			}
			
			//사용일(전표일)
			detailForm.getField('SLIP_DATE').setReadOnly(bBool);
			
			//사용자
			detailForm.getField('PAY_USER_PN').setReadOnly(bBool);	
			detailForm.getField('PAY_USER_NM').setReadOnly(bBool);	
			
			//사용자
			detailForm.getField('DIV_CODE').setReadOnly(bBool);
			
			//예산부서
			detailForm.getField('DEPT_CODE').setReadOnly(bBool);	
			detailForm.getField('DEPT_NAME').setReadOnly(bBool);	
			
			//예산구분
			detailForm.getField('BUDG_GUBUN').setReadOnly(bBool);
			
			//회계구분
			detailForm.getField('ACCNT_GUBUN').setReadOnly(bBool);
			
			//지출건명
			detailForm.getField('TITLE').setReadOnly(bBool);
			
			//내용
			detailForm.getField('TITLE_DESC').setReadOnly(bBool);
			
			//예산기안참조
			detailForm.getField('DRAFT_NO').setReadOnly(bBool);
			
			//지급명세서참조
			detailForm.getField('PAY_DTL_NO').setReadOnly(bBool);
			
			//법인카드승인참조 탭(버튼)
			Ext.getCmp('corporationCardBtn').setDisabled(bBool);
			
			if(bBool == true){
				UniAppManager.setToolbarButtons(['newData','delete','deleteAll'],false);
			}else{
				UniAppManager.setToolbarButtons(['newData'],true);	
				if(directMasterStore.getCount() > 0 && bExcept == false){
					UniAppManager.setToolbarButtons(['delete','deleteAll'],true);		
				}else{
					UniAppManager.setToolbarButtons('delete',true);		
					UniAppManager.setToolbarButtons('deleteAll',false);
				}
			}
			
			//자동기표조회, 출력버튼: 자동기표 되었으면 활성화
			
			if(detailForm.getValue('EX_NUM') == ''){
				Ext.getCmp('btnLinkSlip').setDisabled(true);
//				Ext.getCmp('출력버튼').setDisabled(true);	출력버튼 관련 pdf로
			}else{
				Ext.getCmp('btnLinkSlip').setDisabled(false);
//				Ext.getCmp('출력버튼').setDisabled(false);	출력버튼 관련 pdf로
			}
			
			//결재상신/지출결의자동기표 버튼 : 자동기표 되었으면(그룹웨어 연동 아닐때) 자동기표취소로 활성
			if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0049);		
			}else if(detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0438);	
			}else if(Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
				Ext.getCmp('btnProc').setDisabled(true);		
			}else{
				Ext.getCmp('btnProc').setDisabled(bBool);
			}
			
			//지출결의 그룹웨어 연동여부 AND 지출승인 버튼 사용유무
			if(gsLinkedGW == 'N' && gsAppBtnUse == 'Y'){
				if(detailForm.getValue('HDD_APP') == '9'){
					if(gsAmender == 'Y'){
						Ext.getCmp('btnProc').setDisabled(false);			
					}else{
						Ext.getCmp('btnProc').setDisabled(true);	
					}
				}else{
					Ext.getCmp('btnProc').setDisabled(false);
				}
			}
			
			//재기표 버튼 : 등록된 수정자이며 상태가 반려가 아니면 활성
			if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
				Ext.getCmp('btnReAuto').setDisabled(false);	
			}else{
				Ext.getCmp('btnReAuto').setDisabled(true);		
			}
			
			//임의반려 버튼 : 등록된 수정자이며 상태가 결재중 또는 완결일 경우만 활성
			if(gsAmender == 'Y' && (Ext.getCmp('rdoStatus').getValue().STATUS == '1' || Ext.getCmp('rdoStatus').getValue().STATUS == '9')){
				Ext.getCmp('btnReCancel').setDisabled(false);	
			}else{
				Ext.getCmp('btnReCancel').setDisabled(true);
			}
			
			if(detailForm.getValue('PAY_DTL_NO') == ''){
				Ext.getCmp('btnLinkDtl').setDisabled(true);
			}else{
				Ext.getCmp('btnLinkDtl').setDisabled(false);	
			}
			
			//급여공제 버튼이 활성화된 경우
			if(Ext.getCmp('btnDedAmt').hidden == false ){
				if(detailForm.getValue('PAY_DRAFT_NO') != ''){
					Ext.getCmp('btnDedAmt').setDisabled(false);	
				}else{
					Ext.getCmp('btnDedAmt').setDisabled(true);		
				}
			}
		},
		
		/**
		 * 공통코드 A171의  REF_CODE6
		 */
		fnGetA171RefCode: function(){
			var param = {"MAIN_CODE": 'A171',
				"SUB_CODE": detailForm.getValue('ACCNT_GUBUN'),
				"field":'refCode6'
			};
			
			if(!Ext.isEmpty(UniAccnt.fnGetRefCode(param))){
				gsCommonA171_Ref6 = UniAccnt.fnGetRefCode(param);
			}else{
				gsCommonA171_Ref6 = '';	
			}
				
		},
		/**
		 * 선택된 문서서식구분(회계구분)에 따라 [급여공제] 버튼 활성화 처리/지급처필드 활성화 처리
		 */
		fnApplyDedButton: function(){
			var sAccntGubun;
			
			if(Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
				return false;
			}
			
			sAccntGubun = detailForm.getValue('ACCNT_GUBUN');
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE4,'') ACCNT_GUBUN_REF4",
				ADD_QUERY2: '',
				MAIN_CODE: 'A171',
				SUB_CODE: sAccntGubun
				
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{					
				if(provider.ACCNT_GUBUN_REF4 == 'Y'){
					Ext.getCmp('btnDedAmt').setHidden(false);
					Ext.getCmp('dedAmtTot').setHidden(false);	
					
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						Ext.getCmp('btnDedAmt').setDisabled(true);		
					}else{
						Ext.getCmp('btnDedAmt').setDisabled(false);			
					}
					
					detailGrid.getColumn("PAY_CUSTOM_CODE").setHidden(true);
					detailGrid.getColumn("PAY_CUSTOM_NAME").setHidden(true);
					
				}else if(provider.ACCNT_GUBUN_REF4 == 'P'){
					Ext.getCmp('btnDedAmt').setHidden(true);
					Ext.getCmp('dedAmtTot').setHidden(true);
					
					detailGrid.getColumn("PAY_CUSTOM_CODE").setHidden(false);
					detailGrid.getColumn("PAY_CUSTOM_NAME").setHidden(false);
				}else{
					Ext.getCmp('btnDedAmt').setHidden(true);
					Ext.getCmp('dedAmtTot').setHidden(true);
					
					detailGrid.getColumn("PAY_CUSTOM_CODE").setHidden(true);
					detailGrid.getColumn("PAY_CUSTOM_NAME").setHidden(true);
				}
			});
			
		},
		
		/**
		 *  사용일(전표일) 변경 시, 증빙구분이 있는 지출결의디테일에도 반영
		 */
		fnApplySlipDate: function(slipDate){
			var records = directDetailStore.data.items;
			Ext.each(records, function(record, i){
				if(record.get('PAY_DIVI_REF2') != 'C' && 
				   record.get('PAY_DIVI_REF2') != 'BC' &&
				   record.get('PAY_DIVI_REF2') != 'CC'){
						record.set('BILL_DATE', UniDate.getDbDateStr(slipDate));
				   }
			});
		},
		/**
		 *  "사업장", "부서", "예산구분" 변경 시, 지출결의디테일에도 반영
		 */
		fnApplyToDetail: function(){
			var records = directDetailStore.data.items;
			
			Ext.each(records, function(record, i){
				record.set('BUDG_GUBUN',detailForm.getValue('BUDG_GUBUN'));
				record.set('DEPT_CODE',detailForm.getValue('DEPT_CODE'));
				record.set('DEPT_NAME',detailForm.getValue('DEPT_NAME'));
				record.set('DIV_CODE',detailForm.getValue('DIV_CODE'));
				
				if(record.get('DRAFT_NO') != detailForm.getValue('DRAFT_NO')){
					record.set('DRAFT_NO',detailForm.getValue('DRAFT_NO'));	
					record.set('DRAFT_SEQ',0);	
				}
				
				if(record.get('PEND_CODE') == 'A6'){
					record.set('PAY_CUSTOM_CODE',detailForm.getValue('PAY_USER_PN'));	
					record.set('PAY_CUSTOM_NAME',detailForm.getValue('PAY_USER_NM'));	
				}
			});
		},
		/**
		 * 다중예산코드 입력가능여부 체크
		 * 'A169의 sub_code = '43'인 경우 다중예산코드 입력허용 안되는 옵션 적용
		 */
		fnMultiBudgCodeAllowed: function(pBudgCode){

			var detailRecord = directDetailStore.data.items[0];
			
			if(!Ext.isEmpty(detailRecord)){
				if(pBudgCode == detailRecord.data.BUDG_CODE){
					return true;
				}
				if(gsMultiCode == 'N'){
					Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0503);
					return false;
				}
			}
			
			return true;
			
			
		},
		/**
		 * 예산기안내역에서 선택한 예산과목을 지출결의상세내역에 추가
		 */
		fnNewData2Detail: function(record){
			var sParentBudgCode = '';
			
			sParentBudgCode = record.get('BUDG_CODE');
			
			if(!UniAppManager.app.fnMultiBudgCodeAllowed(sParentBudgCode)){
				Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0503);
				return false;	
			}
			UniAppManager.app.onNewDataButtonDown();///,,,,확인필요 필수 체크 후 
			/*if(!UniAppManager.app.onNewDataButtonDown()){
				return false;
			}else{
				UniAppManager.app.onNewDataButtonDown();*/
			var grdRecord = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(grdRecord)){
				grdRecord.set('DRAFT_NO',record.get('DRAFT_NO'));
				grdRecord.set('DRAFT_SEQ',record.get('DRAFT_SEQ'));
				detailForm.setValue('BUDG_GUBUN',record.get('BUDG_GUBUN'));
				
				grdRecord.set('BUDG_CODE',record.get('BUDG_CODE'));
				
				
				
				var param = {"AC_YYYY": UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
							"BUDG_CODE": record.get('BUDG_CODE'),
							"ADD_QUERY" : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
						   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'",
							"budgNameInfoList" : budgNameList					
							};
				popupService.budgPopup(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						var budgName = "BUDG_NAME_L"+provider[0]["CODE_LEVEL"];
	            		var bFindData;
	            		var subRecords = subStore.data.items;
	            		
	            		if(detailForm.getValue('DRAFT_NO') != ''){
	            		
	            			bFindData = false;
	                		Ext.each(subRecords, function(subRecord, i){
	                			if(!Ext.isEmpty(subRecords)){
	                				if(provider[0]['BUDG_CODE'] == subRecord.get('BUDG_CODE')){
	                					bFindData = true;
	                				}
	                			}
	                		});
	            			
	            			if(bFindData == false){
	            				Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0452)	
	            				return false;
	            			}
	            		}
	            		
	            		if(!UniAppManager.app.fnMultiBudgCodeAllowed(provider[0]['BUDG_CODE'])){
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							grdRecord.set('ACCNT'			,'');
	        				grdRecord.set('ACCNT_NAME'		,'');
	        				grdRecord.set('PJT_CODE'		,'');
	        				grdRecord.set('PJT_NAME'		,'');
	        				grdRecord.set('SAVE_CODE'		,'');
	        				grdRecord.set('SAVE_NAME'		,'');
	        				grdRecord.set('BANK_ACCOUNT'	,'');
	        				grdRecord.set('BUDG_POSS_AMT'	,'');
							return false;	
						}
	            		
	            		grdRecord.set('BUDG_CODE'		,provider[0]['BUDG_CODE']);
						grdRecord.set('BUDG_NAME'		,provider[0][budgName]);
						grdRecord.set('ACCNT'			,provider[0]['ACCNT']);
						grdRecord.set('ACCNT_NAME'		,provider[0]['ACCNT_NAME']);
						grdRecord.set('PJT_CODE'		,provider[0]['PJT_CODE']);
						grdRecord.set('PJT_NAME'		,provider[0]['PJT_NAME']);
						grdRecord.set('SAVE_CODE'		,provider[0]['SAVE_CODE']);
						grdRecord.set('SAVE_NAME'		,provider[0]['SAVE_NAME']);
						grdRecord.set('BANK_ACCOUNT'	,provider[0]['BANK_ACCOUNT']);
						
						UniAppManager.app.fnGetBudgPossAmt(grdRecord);
						
					}
				});
			}
		},
		
		/**
		 * 결재상신 관련
		 */
		fnApproval: function(){
			Ext.Msg.alert("버튼이 결재상신 일때","빌드중(추후개발예정)");
		},
		/**
		 * 자동기표취소
		 */
		fnCancSlip: function(){
			var param= Ext.getCmp('detailForm').getValues();
			cancSlipStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(false);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0329);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 지출결의자동기표
		 */
		fnAutoSlip: function(){
			var param= Ext.getCmp('detailForm').getValues();
			autoSlipStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 자동기표조회 링크 관련
		 */
		fnOpenSlip: function(){
			if(detailForm.getValue('EX_NUM') == ''){
				return false;	
			}
			var params = {
//				action:'select', 
				'PGM_ID' : 'afb700ukr',
				'SLIP_DATE' : detailForm.getValue('SLIP_DATE'),
				'INPUT_PATH' : '80',
				'EX_NUM' : detailForm.getValue('EX_NUM'),
				'iRcvSlipSeq' : '1',	//?
				'AP_STS' : '',
				'DIV_CODE' : detailForm.getValue('DIV_CODE')
			}
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', params);
		},
		/**
		 *  참조정보 링크 관련
		 */
		fnOpenPayDtl: function(){
			if(detailForm.getValue('PAY_DTL_NO') == ''){
				return false;	
			}
			
			var params = {
				action:'select', 
				'PGM_ID' : 'afb700ukr',
				'PAY_DTL_NO' : detailForm.getValue('PAY_DTL_NO')
			}
	  		var rec1 = {data : {prgID : gsPayDtlLinkedPgmID}};							
			parent.openTab(rec1, '/accnt/'+gsPayDtlLinkedPgmID+'.do', params);
		},
		/**
		 * 재기표 관련
		 */
		fnReAuto: function(){
			var param= Ext.getCmp('detailForm').getValues();
			reAutoStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 임의반려 관련
		 */
		fnReCancel: function(){
			var param= Ext.getCmp('detailForm').getValues();
			reCancelStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 지출승인 관련
		 */
		fnAppPro: function(){
			var param= Ext.getCmp('detailForm').getValues();
			appProStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_APP',records[0].data.STATUS);
						
						detailForm.getField('APP').setValue(records[0].data.STATUS);
						
							//지출결의 그룹웨어 연동여부 AND 지출승인 버튼 사용유무
						if(gsLinkedGW == 'N' && gsAppBtnUse == 'Y'){
							//지출상태	
							
							if(detailForm.getValue('HDD_APP') == '9'){
								detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0528); //승인취소
								
								if(gsAmender == 'Y'){
									Ext.getCmp('btnProc').setDisabled(false);
								}else{
									Ext.getCmp('btnProc').setDisabled(true);	
								}
							}else{
								detailForm.down('#btnAppPro').setText(Msg.fSbMsgA0527); //지출승인
								Ext.getCmp('btnProc').setDisabled(false);
							}
						}
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 일괄적용 버튼 관련
		 */
		fnAllApplybtn: function(){
			var copyRow = -1;
			var draftNo = '';
			var draftSeq = '';
			
			if(!UniAppManager.app.fnMultiBudgCodeAllowed(subForm.getValue('BUDG_CODE'))){
			Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0503);	
				return false;
			}
			var detailRecords = directDetailStore.data.items;
			
			var indexRecord = directDetailStore.data.items[copyRow];
			
			firstRecord = [];
			
			Ext.each(detailRecords, function(record, i){
				if(Ext.isEmpty(record.get('ACCNT'))){
					record.set('ACCNT'			,subForm.getValue('HDD_ACCNT_CODE'));
					record.set('ACCNT_NAME'		,subForm.getValue('HDD_ACCNT_NAME'));
				}	
				
				if(Ext.isEmpty(record.get('PJT_CODE'))){
					record.set('PJT_CODE'		,subForm.getValue('HDD_PJT_CODE'));
					record.set('PJT_NAME'		,subForm.getValue('HDD_PJT_NAME'));
				}	
				
				if(Ext.isEmpty(record.get('SAVE_CODE'))){
					record.set('SAVE_CODE'		,subForm.getValue('HDD_SAVE_CODE'));
					record.set('SAVE_NAME'		,subForm.getValue('HDD_SAVE_NAME'));
					record.set('BANK_ACCOUNT'	,subForm.getValue('HDD_BANK_ACCOUNT'));
				}	
				
				if(Ext.isEmpty(record.get('BUDG_CODE'))){
					record.set('BUDG_CODE'		,subForm.getValue('BUDG_CODE'));
					record.set('BUDG_NAME'		,subForm.getValue('BUDG_NAME'));

					if(copyRow == -1){
						budgPossAmt = 0;
						firstRecord = [];
						
						var subRecords = subStore.data.items;
						
						if(record.get('DRAFT_NO') != '' &&
						   record.get('DRAFT_SEQ') == '' ){
						   	
						   	if(Ext.isEmpty(subRecords)){
						   		return false;	
						   	}
						   	Ext.each(subRecords,function(subRecord, i){
						   		if(record.get('BUDG_CODE') != subRecord.get('BUDG_CODE')){
						   			return false;	//로직 재확인 필요
						   		}
						   		if(subRecord.get('BUDG_GUBUN') == record.get('BUDG_GUBUN') && 
						   		   subRecord.get('PJT_CODE') == record.get('PJT_CODE')	){
						   		   	
						   		   	record.set('DRAFT_NO',subRecord.get('DRAFT_NO'));
						   		   	record.set('DRAFT_SEQ',subRecord.get('DRAFT_SEQ'));	
								}
						   	});
						}
						firstRecord = directDetailStore.data.items[0];

						copyRow = i;
					}else{
						record.set('DRAFT_NO'		, firstRecord.data.DRAFT_NO);
						record.set('DRAFT_SEQ'		, firstRecord.data.DRAFT_SEQ);
					}
				}	
			});
				
			Ext.each(detailRecords, function(record, i){	
				var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
							"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
							"BUDG_CODE": record.get('BUDG_CODE'),
							"BUDG_GUBUN": record.get('BUDG_GUBUN'),
							"DRAFT_NO": record.get('DRAFT_NO'),
							"DRAFT_SEQ" : Ext.isEmpty(record.get('DRAFT_SEQ')) ? "0" : record.get('DRAFT_SEQ')							
							};
				accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						budgPossAmt = provider.BUDG_POSS_AMT;
						record.set('BUDG_POSS_AMT'	,budgPossAmt);
					}else{
						budgPossAmt = 0;
						record.set('BUDG_POSS_AMT'	,budgPossAmt);
					}
				});
			});
		},
		/**
		* 급여공제 팝업 조회버튼
		*/
		fnDedAmtQueryBtn: function(){
//			var record = dedAmtDetailStore.data
			var param= dedAmtSearch.getValues();
			dedAmtDetailStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						var dedAmtData = records;
						if(dedAmtDetailStore.getCount() == 0){
							Ext.Msg.alert(Msg.sMB099,Msg.sMB015);		
						}else{
							if(records[0].data.UPDATE_MODE == 'N'){
								if(dedAmtSearch.getValue('HDD_QUERY_FLAG') == 'Y'){
									Ext.each(dedAmtData, function(record,i){	
										record.set('DED_AMOUNT_I',record.get('DED_AMOUNT_I_DUMMY'));//record.get('DED_AMOUNT_I'));
									});								//쿼리에 A.DED_AMOUNT_I AS DED_AMOUNT_I_DUMMY
								}else{
									dedAmtGrid.reset();
									dedAmtDetailStore.clearData();
									Ext.each(dedAmtData, function(record,i){
										UniAppManager.app.onDedAmtNewDataCreateRow();
										dedAmtGrid.setDedAmtNewData(record);
									});
								}
							}else if(dedAmtSearch.getValue('HDD_QUERY_FLAG') == 'Y'){
								Ext.each(dedAmtData, function(record,i){	
									record.set('DED_AMOUNT_I',record.get('DED_AMOUNT_I_DUMMY'));//record.get('DED_AMOUNT_I'));
								});									//쿼리에 A.DED_AMOUNT_I AS DED_AMOUNT_I_DUMMY
							}
							
							
							UniAppManager.app.fnDedAmtDisp(dedAmtData);
							
							if(dedAmtSearch.getValue('HDD_DED_DATA_YN') == 'Y' && dedAmtSearch.getValue('HDD_QUERY_FLAG') != 'Y'){
								
								
								dedAmtMasterStore.load({
									params : param,
									callback : function(records, operation, success) {
										if(success)	{
											UniAppManager.app.fnDedAmtDispMasterData(records);
										}else{
											return false;	
										}
									}
								})
								
							}
							
							
							dedAmtSearch.getField("SUPP_TYPE").setConfig('allowBlank',false);	
						}	
						
						
					}else{
						return false;
					}
				}
			});
		},
		/**
		* 급여공제 팝업 전체삭제버튼
		*/
		onDedAmtDeleteAllBtn: function() {			
			if(confirm('전체삭제 하시겠습니까?')) {
				dedAmtGrid.reset();
				dedAmtDetailStore.saveStore();
				UniAppManager.app.fnDedAmtInitInputFields();
			}
		},
		/**
		* 급여공제 팝업 확인버튼
		*/
		onDedAmtOkBtn: function(){
			if(dedAmtDetailStore.getCount() == 0){
				detailForm.setValue('DED_AMT_TOT',Ext.getCmp('bbarDedAmtBbar').getValue());
				detailForm.setValue('HDD_DED_DATA_YN',dedAmtSearch.getValue('HDD_DED_DATA_YN'));
			}else{
					
				if(!dedAmtSearch.getInvalidMessage()) return;
				dedAmtDetailStore.saveStore('S');
				detailForm.setValue('DED_AMT_TOT',Ext.getCmp('bbarDedAmtBbar').getValue());
				detailForm.setValue('HDD_DED_DATA_YN',dedAmtSearch.getValue('HDD_DED_DATA_YN'));
			}
			
		},
		/**
		* 급여공제 팝업 닫기버튼
		*/
		onDedAmtCancBtn: function(){
			detailForm.setValue('DED_AMT_TOT',Ext.getCmp('bbarDedAmtBbar').getValue());
			detailForm.setValue('HDD_DED_DATA_YN',dedAmtSearch.getValue('HDD_DED_DATA_YN'));
		},
		
		
		
		/**
		* 급여공제 공제금액합계
		*/
		fnDedAmtDisp: function(dedAmtData){
			var sumAmt = 0; 
			
			Ext.each(dedAmtData, function(record,i){	
				sumAmt = sumAmt + record.get('DED_AMOUNT_I_DUMMY');   //쿼리에 A.DED_AMOUNT_I AS DED_AMOUNT_I_DUMMY		
			});
			Ext.getCmp('bbarDedAmtBbar').setValue(sumAmt);
		},
		
		/**
		* 급여공제 마스터정보 
		*/
		fnDedAmtDispMasterData: function(records){
			dedAmtSearch.setValue('PAY_DRAFT_NO'	,records[0].data.PAY_DRAFT_NO);
			dedAmtSearch.setValue('PAY_YYMM'		,records[0].data.PAY_YYYYMM);
			dedAmtSearch.setValue('SUPP_TYPE'		,records[0].data.SUPP_TYPE);
			dedAmtSearch.setValue('COST_POOL'		,records[0].data.COST_POOL);
			dedAmtSearch.setValue('PERSON_GROUP'	,records[0].data.PERSON_GROUP);
			dedAmtSearch.setValue('AFFIL_CODE'		,records[0].data.AFFIL_CODE);
			dedAmtSearch.setValue('FR_DEPT_CODE'	,records[0].data.FR_DEPT_CODE);
			dedAmtSearch.setValue('FR_DEPT_NAME'	,records[0].data.FR_DEPT_NAME);
			dedAmtSearch.setValue('TO_DEPT_CODE'	,records[0].data.TO_DEPT_CODE);
			dedAmtSearch.setValue('TO_DEPT_NAME'	,records[0].data.TO_DEPT_NAME);
			Ext.getCmp('bbarDedAmtBbar').setValue(records[0].data.DED_AMT_TOT);
		},

		/**
		* 급여공제 입력란 초기값 설정
		*/
		fnDedAmtInitInputFields: function(){
			
			dedAmtSearch.setValue('COST_POOL'		,'');
			dedAmtSearch.setValue('PERSON_GROUP'	,'');
			dedAmtSearch.setValue('AFFIL_CODE'		,'');
			dedAmtSearch.setValue('FR_DEPT_CODE'	,'');
			dedAmtSearch.setValue('FR_DEPT_NAME'	,'');
			dedAmtSearch.setValue('TO_DEPT_CODE'	,'');
			dedAmtSearch.setValue('TO_DEPT_NAME'	,'');
			dedAmtSearch.setValue('HDD_DED_DATA_YN'	,'N');
			dedAmtSearch.setValue('HDD_QUERY_FLAG'	,'N');
			Ext.getCmp('bbarDedAmtBbar').setValue(0);			
		},
		/**
		* 급여공제 조건변경시, 재조회 했다는 flag 구분 관련
		*/
		fnDedAmtApplyToDetail: function(){
			if(dedAmtSearch.getValue('HDD_DED_DATA_YN') == 'Y'){
				dedAmtSearch.setValue('HDD_QUERY_FLAG','Y');	
				
			}
		},
		
		
		/**
		 * 예산사용가능금액 관련
		 */
		fnGetBudgPossAmt: function(applyRecord){
			budgPossAmt = 0;
			firstRecord = [];
			
			var subRecords = subStore.data.items;
			
			if(applyRecord.get('DRAFT_NO') != '' &&
			   applyRecord.get('DRAFT_SEQ') == '' ){
			   	
			   	if(Ext.isEmpty(subRecords)){
			   		return false;	
			   	}
			   	Ext.each(subRecords,function(subRecord, i){
			   		if(applyRecord.get('BUDG_CODE') != subRecord.get('BUDG_CODE')){
			   			return false;	//로직 재확인 필요
			   		}
			   		if(subRecord.get('BUDG_GUBUN') == applyRecord.get('BUDG_GUBUN') && 
			   		   subRecord.get('PJT_CODE') == applyRecord.get('PJT_CODE')	){
			   		   	
			   		   	applyRecord.set('DRAFT_NO',subRecord.get('DRAFT_NO'));
			   		   	applyRecord.set('DRAFT_SEQ',subRecord.get('DRAFT_SEQ'));	
					}
			   	});
			}
			
			var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
						"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
						"BUDG_CODE": applyRecord.get('BUDG_CODE'),
						"BUDG_GUBUN": applyRecord.get('BUDG_GUBUN'),
						"DRAFT_NO": applyRecord.get('DRAFT_NO'),
						"DRAFT_SEQ" : Ext.isEmpty(applyRecord.get('DRAFT_SEQ')) ? "0" : applyRecord.get('DRAFT_SEQ')
						
						
						};
			accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)	{

				if(!Ext.isEmpty(provider)){
					applyRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
					firstRecord = directDetailStore.data.items[0];
				}else{
					applyRecord.set('BUDG_POSS_AMT', 0);
					firstRecord = directDetailStore.data.items[0];
				}
			});
		},
		/**
		 * 선택된 경비구분에 따라 법인카드/ 통장 필수처리
		 */
		fnSetPropertiesbyPayDivi: function(applyRecord, newValue){
			var sPayDivi = '';
			
			sPayDivi = newValue;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1, '') PAY_DIVI_REF1, " +
							"ISNULL(REF_CODE2, '') PAY_DIVI_REF2, " +
						 	"ISNULL(REF_CODE3, '') PAY_DIVI_REF3, " +
						    "ISNULL(REF_CODE4, '') PAY_DIVI_REF4", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A172',
				SUB_CODE: sPayDivi
				
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				if(gsCrdtRef == 'Y' &&  provider.PAY_DIVI_REF2 == 'C' && applyRecord.get('REFER_NUM') == ''){
					Ext.Msg(Msg.sMB099,Msg.fSbMsgA0453);
					applyRecord.set('PAY_DIVI','');
					
					return false;
				}
				
				applyRecord.set('PAY_DIVI_REF1'	,provider.PAY_DIVI_REF1);
				applyRecord.set('PAY_DIVI_REF2'	,provider.PAY_DIVI_REF2);
				applyRecord.set('PAY_DIVI_REF3'	,provider.PAY_DIVI_REF3);
				applyRecord.set('PAY_DIVI_REF4'	,provider.PAY_DIVI_REF4);
				
				applyRecord.set('PEND_CODE'		,applyRecord.get('PAY_DIVI_REF1'));
				
				if(provider.PAY_DIVI_REF2 == 'BC'){
					applyRecord.set('PAY_CUSTOM_CODE',applyRecord.get('PAY_DIVI_REF4'));	
				}
				
				UniAppManager.app.fnSetEssCustomField(applyRecord);	//거래처 필수입력여부 설정
				
				UniAppManager.app.fnSetEssPayMethodField(applyRecord); //지급방법유형 필수입력여부 설정
				
				UniAppManager.app.fnSetBankAccount(applyRecord, newValue); //통장정보 예금주/계좌번호/은행에 반영(PAY_DIVI_REF2 = 'BC'인 경우만)
			});
		},
		
		/**
		 * 선택된 세부구분적요에 따라 세부구분항목 값 관련
		 */
		fnSetPropertiesbyBizRemark: function(applyRecord, newValue){
			var sBizRemark = '';
			
			sBizRemark = newValue
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') BIZ_REMARK_REF1", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A182',
				SUB_CODE: sBizRemark
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				applyRecord.set('BIZ_GUBUN',provider.BIZ_REMARK_REF1);
			});
		},
		
		/**
		 *  선택된 세부구분항목에 따라 부가세여부 값 관련
		 */
		fnSetPropertiesbyBizGubun: function(applyRecord, newValue){
			var sBizGubun = '';
			
			sBizGubun = newValue
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE2,'') BIZ_GUBUN_REF", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A174',
				SUB_CODE: sBizGubun
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				applyRecord.set('BIZ_GUBUN_REF',provider.BIZ_GUBUN_REF);
			});
		},
		/**
		 * 선택된 증빙구분에 따라 증빙유형,계산서일,전자계산서발행 기본값설정, 필수입력컬럼 설정
		 */
		fnSetPropertiesbyProofKind: function(applyRecord, newValue){
			var sProofDivi = '';
			
			sProofDivi = newValue;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE4,'') REF_CODE4, " +
							"ISNULL(REF_CODE1,'') REF_CODE1, " +
							"ISNULL(REF_CODE2,'') REF_CODE2, " +
							"ISNULL(REF_CODE3,'') REF_CODE3, " +
							"ISNULL(REF_CODE5,'') REF_CODE5, " +
							"ISNULL(REF_CODE6,'') REF_CODE6, " +
							"ISNULL(REF_CODE7,'') REF_CODE7",
				ADD_QUERY2: '',
				MAIN_CODE: 'A173',
				SUB_CODE: sProofDivi
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				applyRecord.set('PROOF_KIND'	,provider.REF_CODE1);
				applyRecord.set('REASON_ESS'	,provider.REF_CODE2);
				applyRecord.set('PROOF_TYPE'	,provider.REF_CODE3);
				applyRecord.set('CUSTOM_ESS'	,provider.REF_CODE5);
				applyRecord.set('DEFAULT_EB'	,provider.REF_CODE6);
				applyRecord.set('DEFAULT_REASON',provider.REF_CODE7);
				
				UniAppManager.app.fnSetEssReasonField(applyRecord); //불공제사유 필수입력여부 설정
			
				UniAppManager.app.fnSetEssCustomField(applyRecord); //거래처 필수입력여부 설정
				
			
				applyRecord.set('EB_YN',applyRecord.get('DEFAULT_EB')); //전자발행여부 기본값설정
				
				applyRecord.set('REASON_CODE',applyRecord.get('DEFAULT_REASON'));	//불공제사유 기본값설정
				
				
				//증빙구분에 따른 계산서일, 전자발행여부 기본값 설정
				if(applyRecord.get('PAY_DIVI_REF2') != 'C' &&
				   applyRecord.get('PAY_DIVI_REF2') != 'BC' &&
				   applyRecord.get('PAY_DIVI_REF2') != 'CC' ){
					if(newValue != ''){
						applyRecord.set('BILL_DATE' ,detailForm.getValue('SLIP_DATE'));		
					}else{
						applyRecord.set('EB_YN'		,'N');		
					}
				}
				
				if(provider.REF_CODE4 != 'Y'){
					if(applyRecord.get('PROOF_KIND') == ''){
						Ext.Msg(Msg.sMB099,Msg.fSbMsgA0504);
					}
				}
			});
		},
		/**
		 * 선택된 지급처구분에 따라 참조코드값 가져오기
		 */
		fnSetPropertiesbyPendCode: function(applyRecord, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue){
			var sPendCode = '';
			var sPayCustomCode = '';
			
			if(pendCodeNewValue == ''){
				sPendCode = applyRecord.get('PEND_CODE');
			}else{
				sPendCode = pendCodeNewValue;
			}
			
			var param1 = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') PEND_CODE_REF1, " +
							"ISNULL(REF_CODE2,'') PEND_CODE_REF2", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A210',
				SUB_CODE: sPendCode
			}
			accntCommonService.fnGetRefCodes(param1, function(provider, response)	{
				applyRecord.set('PEND_CODE_REF1'	,provider.PEND_CODE_REF1);
				
				if(applyRecord.get('PEND_CODE_REF1') != ''){
					applyRecord.set('CUSTOM_CODE'	,provider.PEND_CODE_REF2);	
										
					var param2 = {"CUSTOM_CODE": applyRecord.get('CUSTOM_CODE')};
					accntCommonService.fnCustInfo(param2, function(provider, response)	{
						applyRecord.set('CUSTOM_CODE'	,provider.CUSTOM_CODE);
						applyRecord.set('CUSTOM_NAME'	,provider.CUSTOM_NAME);
						applyRecord.set('AGENT_TYPE'	,provider.AGENT_TYPE);
						
						if(payCustomCodeNewValue == ''){
							sPayCustomCode = applyRecord.get('PAY_CUSTOM_CODE');
						}else{
							sPayCustomCode = payCustomCodeNewValue;
						}
						
						if(sPayCustomCode == ''){
							applyRecord.set('CUSTOM_CODE'	,'');
							applyRecord.set('CUSTOM_NAME'	,'');
						}
						
					});
				}
			});
		},
		
		/**
		 * 거래처 필수입력여부 설정
		 */
		fnSetEssCustomField: function(applyRecord){
			if(applyRecord.get('CUSTOM_ESS') == 'Y'){
				detailGrid.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}else if(applyRecord.get('PAY_DIVI_REF1') == 'A4' &&
			 applyRecord.get('PAY_DIVI_REF2') == 'C' &&
			 applyRecord.get('PAY_DIVI_REF2') == 'BC' &&
			 applyRecord.get('PAY_DIVI_REF2') == 'CC'){
				detailGrid.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}else{
				detailGrid.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			}
		},
		
		/**
		 * 지급방법 필수입력여부 설정
		 */
		fnSetEssPayMethodField: function(applyRecord){
			if(applyRecord.get('PAY_DIVI_REF2') == 'C' ||
			 applyRecord.get('PAY_DIVI_REF2') == 'BC' ||
			 applyRecord.get('PAY_DIVI_REF2') == 'CC'){
			 	detailGrid.getColumn('CRDT_NUM').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('CRDT_FULL_NUM').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			 	
			 	detailGrid.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 }else if(applyRecord.get('PAY_DIVI_REF2') == 'B'){
			 	detailGrid.getColumn('CRDT_NUM').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('CRDT_FULL_NUM').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	
			 	detailGrid.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			 }else{
			 	detailGrid.getColumn('CRDT_NUM').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('CRDT_FULL_NUM').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	
			 	detailGrid.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 	detailGrid.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			 }
		},
		
		/**
		 * 통장정보 예금주/계좌번호/은행에 반영(PAY_DIVI_REF2 = 'BC'인 경우만)
		 */
		fnSetBankAccount: function(applyRecord, newValue){
			var param = {"PAY_DIVI": newValue}
			afb700ukrService.selectDeposit(param, function(provider, response){
				if(applyRecord.get('PAY_DIVI_REF2') == 'BC'){
					applyRecord.set('IN_BANK_CODE'		,provider.IN_BANK_CODE);
					applyRecord.set('IN_BANK_NAME'		,provider.IN_BANK_NAME);
					applyRecord.set('IN_BANKBOOK_NUM'	,provider.IN_BANKBOOK_NUM);
					applyRecord.set('IN_BANKBOOK_NAME'	,provider.IN_BANKBOOK_NAME);
				}else{
					applyRecord.set('IN_BANK_CODE'		,'');
					applyRecord.set('IN_BANK_NAME'		,'');
					applyRecord.set('IN_BANKBOOK_NUM'	,'');
					applyRecord.set('IN_BANKBOOK_NAME'	,'');
				}
			});
		},
		
		/**
		 * 불공제사유 필수입력여부 설정
		 */
		fnSetEssReasonField: function(applyRecord){
			if(applyRecord.get('REASON_ESS') == 'Y'){
				detailGrid.getColumn('REASON_CODE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}else{
				detailGrid.getColumn('REASON_CODE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			}
		},
		
		/**
		 * 지급예정일 필수입력여부 설정
		 */
		fnSetEssSendDateField: function(applyRecord){
			/*주석처리 되있는 로직
			 * 
			 * if(applyRecord.get('PEND_CODE') == 'A4'){
				detailGrid.getColumn('SEND_DATE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}else{
				detailGrid.getColumn('SEND_DATE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			}*/	
		},
		
		/**
		 * 증빙유형 or 공급가액 변경 시, 세액 & 지급액 계산
		 */
		fnCalcTaxAmt: function(applyRecord, supplyAmtINewValue){
			var dTot_Amt_I = 0;
			var dTaxRate = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			
			if(Ext.isEmpty(supplyAmtINewValue)){
				dSupply_Amt_I = applyRecord.get('SUPPLY_AMT_I');
			}else{
				dSupply_Amt_I = supplyAmtINewValue;
			}
						
			if(applyRecord.get('PROOF_KIND') == ''){
				dTot_Amt_I = dSupply_Amt_I;
				dTax_Amt_I = 0;
				
				applyRecord.set('TAX_AMT_I'	,dTax_Amt_I);
				applyRecord.set('TOT_AMT_I'	,dTot_Amt_I);
				
				
				UniAppManager.app.fnCalcRealAmt(applyRecord);
			}else{
				dTot_Amt_I = 0;
				dTax_Amt_I = 0;
				
				
				var param = {"PROOF_KIND": applyRecord.get('PROOF_KIND')}
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					dTaxRate = provider.TAX_RATE;
					dTax_Amt_I = dSupply_Amt_I * (dTaxRate / 100); 
					
					dTax_Amt_I = UniAccnt.fnAmtWonCalc(dTax_Amt_I, gsAmtPoint);  
					
					if(applyRecord.get('BIZ_GUBUN_REF') == 'Y'){
						dTot_Amt_I = 0;
					}else{
						dTot_Amt_I	= dSupply_Amt_I + dTax_Amt_I;
					}
					
					applyRecord.set('TAX_AMT_I'	,dTax_Amt_I);
					applyRecord.set('TOT_AMT_I'	,dTot_Amt_I);
					
					UniAppManager.app.fnCalcRealAmt(applyRecord);	//실지급액 계산
				});
			}
		},
		
		/**
		 * 지급액 = 공급가액 + 세액으로 자동 계산
		 */
		fnCalcTotAmt: function(applyRecord, taxAmtINewValue, addReduceAmtINewValue){
			var dTot_Amt_I = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			var dAddReduce_Amt_I = 0;
			
			dSupply_Amt_I = applyRecord.get('SUPPLY_AMT_I');
			
			
			if(Ext.isEmpty(taxAmtINewValue)){
				dTax_Amt_I = applyRecord.get('TAX_AMT_I');
			}else{
				dTax_Amt_I = taxAmtINewValue;
			}
			
			if(Ext.isEmpty(addReduceAmtINewValue)){
				dAddReduce_Amt_I = applyRecord.get('ADD_REDUCE_AMT_I');
			}else{
				dAddReduce_Amt_I = addReduceAmtINewValue;
			}
			
			if(applyRecord.get('BIZ_GUBUN_REF') == 'Y'){
				applyRecord.set('TOT_AMT_I'	,0);	
			}else{
				applyRecord.set('TOT_AMT_I'	, dSupply_Amt_I + dTax_Amt_I + dAddReduce_Amt_I);	
			}
			
			UniAppManager.app.fnCalcRealAmt(applyRecord);	//실지급액 계산
		},
		
		/**
		 * 공급가액 = 지급액 / 1.1 자동계산
'        * 세   액 = 지급액 - 공급가액
		 */
		
		fnCalcSupplyAmt: function(applyRecord, newValue){
			var dTaxRate = 0;
			var dTot_Amt_I = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			
			dTot_Amt_I = newValue;
			
			if(applyRecord.get('PROOF_KIND') == ''){
				dSupply_Amt_I = dTot_Amt_I;
				dTax_Amt_I = 0;
				
				applyRecord.set('SUPPLY_AMT_I'	,dSupply_Amt_I);
				applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
				applyRecord.set('TOT_AMT_I'		,dTot_Amt_I);
				
				UniAppManager.app.fnCalcRealAmt(applyRecord);	//실지급액 계산
				
			}else{
				dSupply_Amt_I = 0
				dTax_Amt_I    = 0	
				
				var param = {"PROOF_KIND": applyRecord.get('PROOF_KIND')}
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					dTaxRate = provider.TAX_RATE;
					dSupply_Amt_I = dTot_Amt_I / ((100 + dTaxRate) / 100);
					
					dSupply_Amt_I = UniAccnt.fnAmtWonCalc(dSupply_Amt_I, gsAmtPoint);  
					
					if(applyRecord.get('BIZ_GUBUN_REF') == 'Y'){
						dTax_Amt_I = dTot_Amt_I - dSupply_Amt_I;
						dTot_Amt_I = 0;
						
					}else{
						dTax_Amt_I = dTot_Amt_I - dSupply_Amt_I;
					}

					applyRecord.set('SUPPLY_AMT_I'	,dSupply_Amt_I);
					applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
					applyRecord.set('TOT_AMT_I'		,dTot_Amt_I);
					
					UniAppManager.app.fnCalcRealAmt(applyRecord);	//실지급액 계산
				});
			}
		},
		/**
		 * 실지급액 = 지급액 - 소득세 - 주민세로 자동 계산
		 */
		
		fnCalcRealAmt: function(applyRecord){
			var dTotAmtI = 0;
			var dIncAmtI = 0;
			var dLocAmtI = 0;	
			
			dTotAmtI = applyRecord.get('TOT_AMT_I');
			
			if(applyRecord.get('PEND_CODE_REF1') != ''){
				
				if(applyRecord.get('PEND_CODE_REF1') == '2'){
					
					dIncAmtI = 0;
					dLocAmtI = 0;
					
					if(dTotAmtI > 250000){
						dIncAmtI = (dTotAmtI - (dTotAmtI * 0.8)) * 0.2;	//소득세
						
						dIncAmtI = UniAccnt.fnAmtWonCalc(dIncAmtI / 10, 1); //10원미만 절사  
						
						dLocAmtI = dIncAmtI * 0.1; //주민세
						
						dLocAmtI = UniAccnt.fnAmtWonCalc(dLocAmtI / 10, 1); //10원미만 절사
					}
					
				}else if(applyRecord.get('PEND_CODE_REF1') == '1'){
					
					dIncAmtI = 0;
					dLocAmtI = 0;
					
					dIncAmtI = (dTotAmtI * 0.03);	//소득세
					
					dIncAmtI = UniAccnt.fnAmtWonCalc(dIncAmtI / 10, 1); //10원미만 절사  
					
					if(dIncAmtI < 1000){
						dIncAmtI = 0;	
					}
					
					dLocAmtI = dIncAmtI * 0.1;	//주민세
					
					dLocAmtI = UniAccnt.fnAmtWonCalc(dLocAmtI / 10, 1); //10원미만 절사
					
				}else{
					dIncAmtI = 0;
            		dLocAmtI = 0;
					
				}
			}else{
				dIncAmtI = 0;
        		dLocAmtI = 0;
			}
			
			applyRecord.set('INC_AMT_I'	,dIncAmtI);
			applyRecord.set('LOC_AMT_I'	,dLocAmtI);
			
			applyRecord.set('REAL_AMT_I'	, dTotAmtI - dIncAmtI - dLocAmtI);
			
			UniAppManager.app.fnDispRealAmt();
		},
		
		/**
		 * 화면 하단의 "실지급액 합계" 계산
		 */
		fnDispRealAmt: function(){
			var dTot_Amt_I = 0;
			var dTotal	= 0;
			
			var records = directDetailStore.data.items;
			Ext.each(records, function(record, i){
				dTot_Amt_I = record.get('TOT_AMT_I');
				dTotal     = dTotal + dTot_Amt_I; 
			});
			
			Ext.getCmp('bbarDetailGridBbar').setValue(dTotal);
		},
		
		/**
		 * 지급처 자동설정
		 */
		fnSetPayCustom : function(applyRecord){
			if(applyRecord.get('PAY_DIVI_REF1') =='A6'){
				applyRecord.set('PEND_CODE', 'A6');
				applyRecord.set('PAY_CUSTOM_CODE', detailForm.getValue('PAY_USER_PN'));
				applyRecord.set('PAY_CUSTOM_NAME', detailForm.getValue('PAY_USER_NM'));
			}else{
				if(applyRecord.get('PAY_DIVI_REF2') =='C' || applyRecord.get('PAY_DIVI_REF2') =='CC'){
					applyRecord.set('SEND_DATE', gsCrdtSetDate);
					
				}else if(applyRecord.get('PAY_DIVI_REF2') =='BC'){
					applyRecord.set('PAY_CUSTOM_CODE', applyRecord.get('PAY_DIVI_REF4'));
					
				}else{
					applyRecord.set('SEND_DATE', '');
					
					if(gsPendCodeYN != 'Y'){
						if(applyRecord.get('PEND_CODE') == 'A4' && applyRecord.get('PAY_DIVI_REF1') == 'A4'){
							applyRecord.set('PAY_CUSTOM_CODE', applyRecord.get('CUSTOM_CODE'));
							applyRecord.set('PAY_CUSTOM_NAME', applyRecord.get('CUSTOM_NAME'));
						}
					}
				}
			}
		},
		/**
		 * 신용카드 지급예정일 계산
		 */
		fnSetCrdtSetDate: function(setDate){
			var sSendDate = '';
			
			sSendDate = (UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 6)) + '01';
			
			var tempDate = '';
			tempDate = sSendDate.substring(0,4) + '/' + sSendDate.substring(4,6) + '/' + sSendDate.substring(6,8);
			
			var transDate = new Date(tempDate);
			
			sSendDate = UniDate.add(transDate, {months: +1});
			
			if(Ext.isEmpty(setDate)){
				sSendDate = UniDate.add((UniDate.add(sSendDate, {months: +1})), {days: -1});
				gsCrdtSetDate = UniDate.getDbDateStr(sSendDate);
				
			}else{
				gsCrdtSetDate =	 (UniDate.getDbDateStr(sSendDate).substring(0, 6) + setDate);
			} 
		}
	});
	
	/**
	 * 모델필드 생성
	 */
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'},
			{name: 'DRAFT_NO'			, text: 'DRAFT_NO'			, type: 'string'},
			{name: 'DRAFT_SEQ'			, text: '순번'				, type: 'string'},
			{name: 'BUDG_GUBUN'			, text: '구분'				, type: 'string',comboType:'AU',comboCode:'A170'},
			{name: 'BUDG_CODE'			, text: '예산과목'				, type: 'string'},
			{name: 'PJT_CODE'			, text: '프로젝트코드'			, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트명'			, type: 'string'},
			{name: 'BUDG_AMT'			, text: '추산금액'				, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'	, text: '추산잔액'				, type: 'uniPrice'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	/**
	 * 그리드 컬럼 생성
	 */
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'COMP_CODE'				, width: 88,hidden:true},
        	{dataIndex: 'DRAFT_NO'				, width: 88,hidden:true},
        	{dataIndex: 'DRAFT_SEQ'				, width: 66,align:'center'},
        	{dataIndex: 'BUDG_GUBUN'			, width: 88},
        	{dataIndex: 'BUDG_CODE'				, width: 150,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
        	}
		];
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 120});	
		});
		columns.push({dataIndex: 'PJT_CODE'				, width: 110}); 	
		columns.push({dataIndex: 'PJT_NAME'				, width: 120}); 			
		columns.push({dataIndex: 'BUDG_AMT'				, width: 120,summaryType: 'sum'}); 		
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'		, width: 100,summaryType: 'sum'}); 		
		
		return columns;
	}	
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PAY_DIVI" :
					UniAppManager.app.fnSetPropertiesbyPayDivi(record, newValue);
					
					UniAppManager.app.fnSetPayCustom(record);
					
					UniAppManager.app.fnSetEssSendDateField(record);
					break;
				case "BIZ_REMARK" :
					UniAppManager.app.fnSetPropertiesbyBizRemark(record, newValue);
					break;
				
				case "BIZ_GUBUN" :
					UniAppManager.app.fnSetPropertiesbyBizGubun(record, newValue);
					break;
					
				case "PEND_CODE" :
					record.set('PAY_CUSTOM_CODE'	, '');	
					record.set('PAY_CUSTOM_NAME'	, '');	
					record.set('CUSTOM_CODE'		, '');	
					record.set('CUSTOM_NAME'		, '');	
					record.set('AGENT_TYPE'			, '');	
					record.set('IN_BANK_CODE'		, '');	
					record.set('IN_BANK_NAME'		, '');	
					record.set('IN_BANKBOOK_NUM'	, '');	
					record.set('IN_BANKBOOK_NAME'	, '');	
				
					pendCodeNewValue = newValue;
					payCustomCodeNewValue = '';
					payCustomNameNewValue = '';
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					
					supplyAmtINewValue = '';
					UniAppManager.app.fnCalcTaxAmt(record, supplyAmtINewValue);	//,,,
					break;
					
				case "PROOF_DIVI" :
					UniAppManager.app.fnSetPropertiesbyProofKind(record,newValue);
					
					supplyAmtINewValue = '';
					UniAppManager.app.fnCalcTaxAmt(record, supplyAmtINewValue);
					break;
					
				case "SUPPLY_AMT_I" :
				
					supplyAmtINewValue = newValue;
					UniAppManager.app.fnCalcTaxAmt(record, supplyAmtINewValue);
					break;	
					
				case "TAX_AMT_I" :
				
					taxAmtINewValue = newValue;
					addReduceAmtINewValue = '';
					UniAppManager.app.fnCalcTotAmt(record, taxAmtINewValue, addReduceAmtINewValue);
					break;	
					
				case "ADD_REDUCE_AMT_I" :
					
					taxAmtINewValue = '';
					addReduceAmtINewValue = newValue;
					UniAppManager.app.fnCalcTotAmt(record, taxAmtINewValue, addReduceAmtINewValue);
					break;	
					
				case "TOT_AMT_I" :
				
				//세부구분항목이 부가세인 경우는 지급액이 항상 0이므로 수정시에도 0으로 변함이 없어 강제로 before값을 셋팅해준다.
					if(record.get('BIZ_GUBUN_REF') == 'Y'){
						oldValue = 99999999999999;
					}
				
					UniAppManager.app.fnCalcSupplyAmt(record, newValue);
					break;	
					
				case "INC_AMT_I" :
					UniAppManager.app.fnCalcRealAmt(record);
					break;		
					
				case "LOC_AMT_I" :
					UniAppManager.app.fnCalcRealAmt(record);
					break;		
					
				case "CUSTOM_CODE" :
					UniAppManager.app.fnSetPayCustom(record);
					break;		
					
				case "CUSTOM_NAME" :
					UniAppManager.app.fnSetPayCustom(record);
					break;	
					
				case "CRDT_NUM" :
					UniAppManager.app.fnSetPayCustom(record);
					break;		
					
				case "CRDT_FULL_NUM" :
					UniAppManager.app.fnSetPayCustom(record);
					break;		
						
				case "PAY_CUSTOM_CODE" :
					
					pendCodeNewValue = '';
					payCustomCodeNewValue = newValue;
					payCustomNameNewValue = '';
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					break;		
					
				case "PAY_CUSTOM_NAME" :
				
					pendCodeNewValue = '';
					payCustomCodeNewValue = '';
					payCustomNameNewValue = newValue;		
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					break;		
					
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.setToolbarButtons('save',true);
					break;
			}
			return rv;
		}
	});
};
</script>
