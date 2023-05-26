<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiss500ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aiss500ukrv" />			<!-- 사업장 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!-- 자산구분-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오-->
	<t:ExtComboStore comboType="AU" comboCode="A039" /> <!-- 매각/폐기구분-->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 상각완료여부-->
	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!-- 결재유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="A036" /> <!-- 상각방법-->
	
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- 사업장-->
	<t:ExtComboStore comboType="AU" comboCode="A149" /> <!-- 전자발행여부-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >
var gsGubun = '${gsGubun}';	//재무제표 양식차수
var	gsAmtPoint ='${gsAmtPoint}';
var retrunValue= '';
var retunValue = '';
var csHeaderRowsCnt = 1;

function appMain() {	
	var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt};
	var gsChargeCode = '${getChargeCode}';
	var activeGridId = 'aiss500ukrvDetailGrid1'; // 선택된 그리드 (detailGrid포함)

	// uniDateRange specialKey 공통개발 필요한 상태 (08.19)
	// fnProofPopUp(oSheet, Row) Grid1 증빙유형에 따른 증빙자료(신용카드번호,현금영수증) 팝업 작업 필요 (08.22)
	var eprYYMM = '';	// tbar 최종상각월 표시 작업필요 (08.24)
	
	
	/**
	*	Model 정의 
	* @type 
	*/
	Unilite.defineModel('Aiss500ukrvMasterModel', {	//마스터 그리드
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST_DIVI'					, text: '자산구분'					,type: 'string' , comboType:'AU', comboCode:'A042'},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ASST_NAME'					, text: '자산명'					,type: 'string'},
			{name: 'SPEC'						, text: '규격'					,type: 'string'},
			{name: 'DIV_CODE'					, text: '사업장'					,type: 'string' , comboType:'BOR120'},
			{name: 'PJT_NAME'					, text: '사업명'					,type: 'string'},
			{name: 'ACCNT_NAME'					, text: '계정과목'					,type: 'string'},
			{name: 'ACQ_DATE'					, text: '취득일'					,type: 'uniDate'},
			{name: 'USE_DATE'					, text: '사용일'					,type: 'uniDate'},
			{name: 'ACQ_Q'						, text: '취득수량'					,type: 'uniQty'},
			{name: 'ACQ_AMT_I'					, text: '취득가액'					,type: 'uniPrice'},
			{name: 'PAT_YN'						, text: '분할여부'					,type: 'string' , comboType:'AU', comboCode:'A020'},
			{name: 'DPR_YYMM'					, text: '최종상각월'					,type: 'string'},
			{name: 'STOCK_Q'					, text: 'STOCK_Q'				,type: 'uniQty'},
			{name: 'DRB_YEAR'					, text: 'BRB_YEAR'				,type: 'string'},
			{name: 'DEP_CTL'					, text: 'DEP_CTL'				,type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'					,type: 'string'},
			{name: 'DEPT_NAME'					, text: '부서명'					,type: 'string'},
			{name: 'FI_CAPI_TOT_I'				, text: 'FI_CAPI_TOT_I'			,type: 'uniPrice'},
			{name: 'FI_SALE_TOT_I'				, text: 'FI_SALE_TOT_I'			,type: 'uniPrice'},
			{name: 'FI_SALE_DPR_TOT_I'			, text: 'FI_SALE_DPR_TOT_I'		,type: 'uniPrice'},
			{name: 'FI_REVAL_TOT_I'				, text: 'FI_REVAL_TOT_I'		,type: 'uniPrice'},
			{name: 'FI_DPR_TOT_I'				, text: 'FI_DPR_TOT_I'			,type: 'uniPrice'},
			{name: 'FI_DMGLOS_TOT_I'			, text: 'FI_DMGLOS_TOT_I'		,type: 'uniPrice'},
			{name: 'FL_BALN_I'					, text: 'FL_BALN_I'				,type: 'uniPrice'},
			{name: 'FL_ACQ_AMT_I'				, text: 'FL_ACQ_AMT_I'			,type: 'uniPrice'}
		]
	});
	
	
	Unilite.defineModel('Aiss500ukrvDetailModel1', { //디테일 탭1
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int' , allowBlank: false, editable: false},
			{name: 'ALTER_YYMM'					, text: '발생월'					,type: 'string'},
			{name: 'ALTER_DATE'					, text: '발생일'					,type: 'uniDate', allowBlank: false},
			{name: 'MONEY_UNIT'					, text: '화폐단위'					,type: 'string' , comboType: 'AU', comboCode: 'B004', allowBlank: false,displayField: 'value' , maxLength: 30},
			{name: 'EXCHG_RATE_O'				, text: '환율'					,type: 'uniER' , maxLength: 38},
			{name: 'FOR_ALTER_AMT_I'			, text: '외화발생금액'				,type: 'uniFC' , maxLength: 38},
			{name: 'ALTER_AMT_I'				, text: '발생금액'					,type: 'uniPrice' , allowBlank: false , maxLength: 38},
			{name: 'ALTER_REASON'				, text: '변동사유'					,type: 'string' , maxLength: 100},
			{name: 'SET_TYPE'					, text: '결제유형'					,type: 'string' , comboType: 'AU', comboCode: 'A140' , maxLength: 30},
			{name: 'PROOF_KIND'					, text: '증빙유형'					,type: 'string' , comboType:'AU', comboCode:'A022' , maxLength: 30},  // refCode3 == 1 Grid 처리
			{name: 'SUPPLY_AMT_I'				, text: '공급가액'					,type: 'uniPrice' , maxLength: 38},
			{name: 'TAX_AMT_I'					, text: '세액'					,type: 'uniPrice' , maxLength: 38},
			{name: 'CUSTOM_CODE'				, text: '거래처코드'					,type: 'string' , maxLength: 8},
			{name: 'CUSTOM_NAME'				, text: '거래처명'					,type: 'string' , maxLength: 40},
			{name: 'SAVE_CODE'					, text: '통장코드'					,type: 'string' , maxLength: 8},
			{name: 'SAVE_NAME'					, text: '통장명'					,type: 'string' , maxLength: 40},
			{name: 'CREDIT_NUM'					, text: '신용카드번호'				,type: 'string' , maxLength: 20},
			{name: 'CREDIT_NAME'				, text: '신용카드명'					,type: 'string' , maxLength: 40},
			{name: 'REASON_CODE'				, text: '불공제사유코드'				,type: 'string'},
			{name: 'PAY_SCD_DATE'				, text: '지급예정일'					,type: 'uniDate'},
			{name: 'EB_YN'						, text: '전자발행여부'				,type: 'string' , comboType: 'AU', comboCode: 'A149' , maxLength: 30, allowBlank: false, defaultValue:'N'},
			{name: 'EX_DATE'					, text: '전표일자'					,type: 'uniDate'},
			{name: 'EX_NUM'						, text: '전표번호'					,type: 'string'},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	Unilite.defineModel('Aiss500ukrvDetailModel2', { //디테일 탭2
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int' , allowBlank: false, editable: false},
			{name: 'WASTE_DIVI'					, text:'구분'						,type: 'string', comboType: 'AU', comboCode: 'A039' , allowBlank: false},		//(매각/폐기)
			{name: 'ALTER_YYMM'					, text:'처분월'					,type: 'string'},
			{name: 'ALTER_DATE'					, text:'처분일'					,type: 'uniDate', allowBlank: false},
			{name: 'ALTER_Q'					, text:'처분수량'					,type: 'uniQty' , maxLength: 38 , allowBlank: false},
			{name: 'MONEY_UNIT'					, text:'화폐단위'					,type: 'string' , maxLength: 30, comboType: 'AU', comboCode: 'B004', allowBlank: false, displayField: 'value'},
			{name: 'EXCHG_RATE_O'				, text:'환율'						,type: 'uniER' , maxLength: 38},
			{name: 'FOR_ALTER_AMT_I'			, text:'외화처분금액'					,type: 'uniFC' , maxLength: 38},
			{name: 'ALTER_AMT_I'				, text:'처분액'					,type: 'uniPrice' , maxLength: 38 , defaultValue:0},
			{name: 'ALTER_REASON'				, text:'처분사유'					,type: 'string' , maxLength: 100},
			{name: 'SET_TYPE'					, text:'결제유형'					,type: 'string' , maxLength: 30 , comboType: 'AU', comboCode: 'A140'},
			{name: 'PROOF_KIND'					, text:'증빙유형'					,type: 'string' , maxLength: 30 , comboType:'AU', comboCode:'A022'}, // refCode3 == 2 Grid 처리
			{name: 'SUPPLY_AMT_I'				, text:'공급가액'					,type: 'uniPrice' , maxLength: 38},
			{name: 'TAX_AMT_I'					, text:'세액'						,type: 'uniPrice' , maxLength: 38},
			{name: 'CUSTOM_CODE'				, text:'거래처코드'					,type: 'string' , maxLength: 8},
			{name: 'CUSTOM_NAME'				, text:'거래처명'					,type: 'string' , maxLength: 40},
			{name: 'SAVE_CODE'					, text:'통장코드'					,type: 'string' , maxLength: 8},
			{name: 'SAVE_NAME'					, text:'통장명'					,type: 'string' , maxLength: 40},
			{name: 'PAY_SCD_DATE'				, text:'회수예정일'					,type: 'uniDate'},
			{name: 'EB_YN'						, text:'전자발행여부'					,type: 'string' , maxLength: 30 , comboType: 'AU', comboCode: 'A149', allowBlank: false, defaultValue:'N'},
			{name: 'ALTER_PROFIT'				, text:'처분손익'					,type: 'string'},
			{name: 'EX_DATE'					, text:'전표일자'					,type: 'uniDate'},
			{name: 'EX_NUM'						, text:'전표번호'					,type: 'string'},
   		 	{name: 'SALE_ACQ_AMT_I' 	  		, text: '취득가액'					,type: 'uniPrice'},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	Unilite.defineModel('Aiss500ukrvDetailModel3', { //디테일 탭3
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int' , allowBlank: false, editable: false},
			{name:	'ALTER_YYMM'				, text: '처분월'					,type: 'string'},
			{name:	'ALTER_DATE'				, text: '변경일'					,type: 'uniDate', allowBlank: false},
			{name:	'BF_DRB_YEAR'				, text: '변경전'					,type: 'uniNumber'},
			{name:	'AF_DRB_YEAR'				, text: '변경후'					,type: 'uniNumber' , maxLength: 3 , allowBlank: false},
			{name:	'ALTER_REASON'				, text: '변경사유'					,type: 'string' , maxLength: 100},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	Unilite.defineModel('Aiss500ukrvDetailModel4', { //디테일 탭4
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int' , allowBlank: false, editable: false},
			{name:	'ALTER_YYMM'				, text: '처분월'					,type: 'string'},
			{name:	'ALTER_DATE'				, text: '변경일'					,type: 'uniDate' , allowBlank: false},
			{name:	'BF_DEP_CTL'				, text: '변경전'					,type: 'string' , comboType: 'AU', comboCode: 'A036'},
			{name:	'AF_DEP_CTL'				, text: '변경후'					,type: 'string' , comboType: 'AU', comboCode: 'A036' , allowBlank: false},
			{name:	'ALTER_REASON'				, text: '변경사유'					,type: 'string' , maxLength: 100},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	Unilite.defineModel('Aiss500ukrvDetailModel5', { //디테일 탭5
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int' , allowBlank: false, editable: false},
			{name:	'ALTER_YYMM'				, text: '처분월'					,type: 'string'},
			{name:	'ALTER_DATE'				, text: '이동일'					,type: 'uniDate' , allowBlank: false},
			{name:	'BF_DEPT_CODE'				, text: '이동 전 부서'				,type: 'string'},
			{name:	'BF_DEPT_NAME'				, text: '이동 전 부서명'				,type: 'string'},
			{name:	'BF_DIV_CODE'				, text: '이동 전 사업장'				,type: 'string' , comboType: 'BOR120'},
			{name:	'AF_DEPT_CODE'				, text: '이동 후 부서'				,type: 'string' , allowBlank: false},
			{name:	'AF_DEPT_NAME'				, text: '이동 후 부서명'				,type: 'string' , allowBlank: false},
			{name:	'AF_DIV_CODE'				, text: '이동 후 사업장'				,type: 'string' , comboType: 'BOR120' , allowBlank: false},
			{name:	'ALTER_REASON'				, text: '변경사유'					,type: 'string' , maxLength: 100},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	Unilite.defineModel('Aiss500ukrvDetailModel6', { //디테일 탭6
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'					,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'ASST'						, text: '자산코드'					,type: 'string'},
			{name: 'ALTER_DIVI'					, text: '변동구분'					,type: 'string'},
			{name: 'SEQ'						, text: '순번'					,type: 'int'  , allowBlank: false, editable: false},
			{name: 'ALTER_YYMM'					, text: '처분월'					,type: 'string'},
			{name: 'ALTER_DATE'					, text: '분할일'					,type: 'uniDate' , allowBlank: false},
			{name: 'PAT_ASST'					, text: '분할자산코드'				,type: 'string' , maxLength: 15, allowBlank: false},
			{name: 'ALTER_Q'					, text: '분할수량'					,type: 'uniQty' , maxLength: 38 , allowBlank: false},
			{name: 'PAT_ACQ_AMT_I'				, text: '분할취득가액'				,type: 'uniPrice' , maxLength: 38 , maxLength: 38 },
			{name: 'PAT_FI_CAPI_TOT_I'			, text: '분할자본적지출액'				,type: 'uniPrice' , maxLength: 38 , maxLength: 38 },
			{name: 'PAT_FI_SALE_TOT_I'			, text: '분할매각폐기금액'				,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FI_SALE_DPR_TOT_I'		, text: '분할매각폐기상각감소액'			,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FI_REVAL_TOT_I'			, text: '분할재평가액'				,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FI_DPR_TOT_I'			, text: '분할상각누계액'				,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FI_DMGLOS_TOT_I'		, text: '분할손상차손누계액'			,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FL_BALN_I'				, text: '분할미상각잔액'				,type: 'uniPrice' , maxLength: 38 },
			{name: 'PAT_FL_ACQ_AMT_I'			, text: '분할전기취득가액'				,type: 'uniPrice' },
			{name: 'ALTER_REASON'				, text: '분할사유'					,type: 'string' , maxLength: 100},
			{name: 'PAT_YN'						, text: '분할실행여부'				,type: 'string' , comboType: 'AU', comboCode: 'A020'},
			{name: 'INSERT_DB_USER'				, text: '입력자'					,type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'					,type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'					,type: 'uniDate'}
		]
	});
	
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectMasterList'
		}
	});
	
	var directDetailProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList1',
			update: 'aiss500ukrvService.updateDetail1',
			create: 'aiss500ukrvService.insertDetail1',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	var directDetailProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList2',
			update: 'aiss500ukrvService.updateDetail2',
			create: 'aiss500ukrvService.insertDetail2',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	var directDetailProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList3',
			update: 'aiss500ukrvService.updateDetail3',
			create: 'aiss500ukrvService.insertDetail3',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	var directDetailProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList4',
			update: 'aiss500ukrvService.updateDetail4',
			create: 'aiss500ukrvService.insertDetail4',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	var directDetailProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList5',
			update: 'aiss500ukrvService.updateDetail5',
			create: 'aiss500ukrvService.insertDetail5',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	var directDetailProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aiss500ukrvService.selectDetailList6',
			update: 'aiss500ukrvService.updateDetail6',
			create: 'aiss500ukrvService.insertDetail6',
			destroy: 'aiss500ukrvService.deleteDetail',
			syncAll: 'aiss500ukrvService.saveAll'
		}
	});
	
	
	/**
	* Store 정의(Service 정의)
	* @type 
	*/
	var directMasterStore = Unilite.createStore('aiss500ukrvMasterStore1',{
		model: 'Aiss500ukrvMasterModel',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directMasterProxy,
		loadStoreRecords: function() {
			var param  = Ext.getCmp('searchForm').getValues();
			var param2 = Ext.getCmp('searchForm').getValues();
			//var param2 = Ext.getCmp('detailForm').getValues();
			
			var params = Ext.merge(param, param2);
			
			console.log( param );
			this.load({
				params : params
			});
		},
		saveStore : function()	{
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if (store.getCount() > 0) {
					UniAppManager.setToolbarButtons('newData', true);
				}
				else {
					UniAppManager.setToolbarButtons('newData', false);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
			},
			datachanged : function(store,  eOpts) {
			}
		}
	});
	
	
	var directDetailStore1 = Unilite.createStore('aiss500ukrvDetailStore',{
		model: 'Aiss500ukrvDetailModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy1,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST'), ALTER_DIVI : '1'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var isErr = false;
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var list = [].concat(toUpdate,toCreate); 
			Ext.each(list, function(record, index) {
				if(getStDt[0].STDT > UniDate.getDbDateStr(record.get('ALTER_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(record.get('ALTER_DATE'))){
					var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
					var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
					alert(Msg.sMA0290 + '\n' + stDate + ' ~ ' + toDate); 
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
//					if(records != null && records.length > 0 ){
//						UniAppManager.setToolbarButtons('delete', true);
//					}else{
//						UniAppManager.setToolbarButtons('delete', false);
//					}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if(store.isDirty() || directDetailStore2.isDirty() || directDetailStore3.isDirty() && activeTabId == 'ass500ukrvDetailGrid1')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore2 = Unilite.createStore('aiss500ukrvDetailStore2',{
		model: 'Aiss500ukrvDetailModel2',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy2,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST') , ALTER_DIVI : '2'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var isErr = false;
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var list = [].concat(toUpdate,toCreate); 
			Ext.each(list, function(record, index) {
				if(getStDt[0].STDT > UniDate.getDbDateStr(record.get('ALTER_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(record.get('ALTER_DATE'))){
					var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
					var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
					alert(Msg.sMA0291 + '\n' + stDate + ' ~ ' + toDate); 
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
//					if(records != null && records.length > 0 ){
//						UniAppManager.setToolbarButtons('delete', true);
//					}else{
//						UniAppManager.setToolbarButtons('delete', false);
//					}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || store.isDirty() || directDetailStore3.isDirty() && activeTabId == 'ass500ukrvDetailGrid2')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore3 = Unilite.createStore('aiss500ukrvDetailStore3',{
		model: 'Aiss500ukrvDetailModel3',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy3,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST'), ALTER_DIVI : '5'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
//					if(records != null && records.length > 0 ){
//						UniAppManager.setToolbarButtons('delete', true);
//					}else{
//						UniAppManager.setToolbarButtons('delete', false);
//					}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || directDetailStore2.isDirty() || store.isDirty() && activeTabId == 'ass500ukrvDetailGrid3')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore4 = Unilite.createStore('aiss500ukrvDetailStore4',{
		model: 'Aiss500ukrvDetailModel4',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy4,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST'), ALTER_DIVI : '6'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
//					if(records != null && records.length > 0 ){
//						UniAppManager.setToolbarButtons('delete', true);
//					}else{
//						UniAppManager.setToolbarButtons('delete', false);
//					}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || directDetailStore2.isDirty() || store.isDirty() && activeTabId == 'ass500ukrvDetailGrid3')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore5 = Unilite.createStore('aiss500ukrvDetailStore5',{
		model: 'Aiss500ukrvDetailModel5',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy5,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST'), ALTER_DIVI : '7'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
//					if(records != null && records.length > 0 ){
//						UniAppManager.setToolbarButtons('delete', true);
//					}else{
//						UniAppManager.setToolbarButtons('delete', false);
//					}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || directDetailStore2.isDirty() || store.isDirty() && activeTabId == 'ass500ukrvDetailGrid3')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore6 = Unilite.createStore('aiss500ukrvDetailStore6',{
		model: 'Aiss500ukrvDetailModel6',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy6,
		loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST'), ALTER_DIVI : '8'}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
					UniAppManager.app.fnSetActivityPatButton();
				}
			}
			this.syncAllDirect(config);
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
					UniAppManager.app.fnSetActivityPatButton();
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || directDetailStore2.isDirty() || store.isDirty() && activeTabId == 'ass500ukrvDetailGrid3')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	
	/**
	* 검색조건 (Search Panel)
	* @type 
	*/
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
				items: [
				Unilite.popup('IFRS_ASSET',{
					fieldLabel: '자산코드', 
					valueFieldName: 'FR_ASST_CODE',
					textFieldName: 'FR_ASST_NAME',
					autoPopup : true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('FR_ASST_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_ASST_NAME', newValue);
								panelResult.setValue('FR_ASST_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('FR_ASST_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_ASST_CODE', newValue);
								panelResult.setValue('FR_ASST_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('IFRS_ASSET',{
					fieldLabel: '~',
					valueFieldName: 'TO_ASST_CODE',
					textFieldName: 'TO_ASST_NAME',
					autoPopup : true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('TO_ASST_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_ASST_NAME', newValue);
								panelResult.setValue('TO_ASST_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TO_ASST_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_ASST_CODE', newValue);
								panelResult.setValue('TO_ASST_CODE', newValue);
							}
						}
					}
				}),{
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					multiSelect: true,
					typeAhead: false,
					comboType:'BOR120',
					width: 325,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '자산구분',
					name:'ASST_DIVI',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A042' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ASST_DIVI', newValue);
						}
					}
				}]
			},{
				title: '추가검색',	
				itemId: 'search_panel2',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
				items:[
				Unilite.popup('ACCNT',{
					fieldLabel: '계정과목',
					valueFieldName: 'FR_ACCNT_CODE',
					textFieldName: 'FR_ACCNT_NAME',
					validateBlank: false,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});		//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});					//bParam(3)
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('FR_ACCNT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_ACCNT_NAME', newValue);
								panelResult.setValue('FR_ACCNT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('FR_ACCNT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_ACCNT_CODE', newValue);
								panelResult.setValue('FR_ACCNT_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('ACCNT',{
					fieldLabel: '~',
					valueFieldName: 'TO_ACCNT_CODE',
					textFieldName: 'TO_ACCNT_NAME',
					validateBlank: false,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});		//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});					//bParam(3)
						},
						onTextSpecialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_DEPT_CODE').focus();
							}
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('TO_ACCNT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_ACCNT_NAME', newValue);
								panelResult.setValue('TO_ACCNT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TO_ACCNT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_ACCNT_CODE', newValue);
								panelResult.setValue('TO_ACCNT_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('DEPT',{
					fieldLabel: '부서',
					validateBlank: false,
					valueFieldName: 'FR_DEPT_CODE', 
					textFieldName: 'FR_DEPT_NAME',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('FR_DEPT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_DEPT_NAME', newValue);
								panelResult.setValue('FR_DEPT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('FR_DEPT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_DEPT_CODE', newValue);
								panelResult.setValue('FR_DEPT_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('DEPT',{
					fieldLabel: '~',
					validateBlank: false,
					valueFieldName: 'TO_DEPT_CODE',
					textFieldName: 'TO_DEPT_NAME',
					listeners: {
						onTextSpecialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_PJT_CODE').focus();
							}
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('TO_DEPT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_DEPT_NAME', newValue);
								panelResult.setValue('TO_DEPT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TO_DEPT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_DEPT_CODE', newValue);
								panelResult.setValue('TO_DEPT_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '사업코드',
					validateBlank: false,
					valueFieldName: 'FR_PJT_CODE',
					textFieldName: 'FR_PJT_NAME',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('FR_PJT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_PJT_NAME', newValue);
								panelResult.setValue('FR_PJT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('FR_PJT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('FR_PJT_CODE', newValue);
								panelResult.setValue('FR_PJT_CODE', newValue);
							}
						}
					}
				}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '~',
					validateBlank: false,
					valueFieldName: 'TO_PJT_CODE',
					textFieldName: 'TO_PJT_NAME',
					listeners: {
						onTextSpecialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('CAPI_YN').focus();
							}
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('TO_PJT_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_PJT_NAME', newValue);
								panelResult.setValue('TO_PJT_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TO_PJT_NAME', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('TO_PJT_CODE', newValue);
								panelResult.setValue('TO_PJT_CODE', newValue);
							}
						}
					}
				}),{
					fieldLabel: '자본적지출여부',
					name:'CAPI_YN',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A020',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('WASTE_SW').focus();
							}
						}
					}
				},{
					fieldLabel: '매각/폐기구분',
					name:'WASTE_SW',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A039',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('CHG_DRB_YEAR_YN').focus();
							}
						}
					}
				},{
					fieldLabel: '내용년수변경여부',
					name:'CHG_DRB_YEAR_YN',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A020',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('CHG_DEP_CTL_YN').focus();
							}
						}
					}
				},{
					fieldLabel: '삼각방법변경여부',
					name:'CHG_DEP_CTL_YN',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A020',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('MOVE_YN').focus();
							}
						}
					}
				},{
					fieldLabel: '이동여부',
					name:'MOVE_YN',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A020',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('PAT_YN').focus();
							}
						}
					}
				},{
					fieldLabel: '분할여부',
					name:'PAT_YN',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A020',
					colspan:2,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('DPR_STS').focus();
							}
						}
					}
				},{
					fieldLabel: '상각완료여부',
					name:'DPR_STS2',	
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A035' ,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_DRB_YEAR').focus();
							}
						}
					}
				},{
					xtype: 'container',
					items:[{
						xtype: 'container',
						defaultType: 'uniNumberfield',
						layout: {type: 'uniTable', columns: 2},
						items: [{
							fieldLabel: '내용년수',
							name: 'FR_DRB_YEAR',
							width: 195
						}, {
							fieldLabel: '~',
							name: 'TO_DRB_YEAR',
							labelWidth: 5,
							width: 120,
							listeners: {
								specialKey: function(elm, e){
									if (e.getKey() == e.ENTER) {
										panelSearch.getField('FR_ACQ_DATE').focus();
									}
								}
							}
						}] 
					}]
				},{
					fieldLabel: '취득일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_ACQ_DATE',
					endFieldName: 'TO_ACQ_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_CAPI_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '자본적지출일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_CAPI_DATE',
					endFieldName: 'TO_CAPI_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_WASTE_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '매각/폐기일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_WASTE_DATE',
					endFieldName: 'TO_WASTE_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_CHG_DRB_YEAR_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '내용년수변경일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_CHG_DRB_YEAR_DATE',
					endFieldName: 'TO_CHG_DRB_YEAR_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_CHG_DEP_CTL_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '삼각방법변경일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_CHG_DEP_CTL_DATE',
					endFieldName: 'TO_CHG_DEP_CTL_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_MOVE_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '이동일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_MOVE_DATE',
					endFieldName: 'TO_MOVE_DATE',
					width:315,
					listeners: {
						specialKey: function(elm, e){
							if (e.getKey() == e.ENTER) {
								panelSearch.getField('FR_PAT_DATE').focus();
							}
						}
					}
				},{
					fieldLabel: '분할일',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_PAT_DATE',
					endFieldName: 'TO_PAT_DATE',
					width:315
				}
			]
		}]
	});
	
//	var inputTable = Unilite.createSearchForm('detailForm', { // sub Form
//		layout : {type : 'uniTable', columns : 3},
//		disabled: false,
//		border:true,
//		padding:'1 1 1 1',
//		region: 'north',
//		items: [
//			Unilite.popup('ACCNT',{
//				fieldLabel: '계정과목',
//				valueFieldName: 'FR_ACCNT_CODE', 
//				textFieldName: 'FR_ACCNT_NAME',
//				validateBlank: false,
//				listeners: {
//					applyextparam: function(popup){
//						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});		//WHERE절 추카 쿼리
//						popup.setExtParam({'CHARGE_CODE': gsChargeCode});					//bParam(3)
//					}
//				}
//			}),
//				Unilite.popup('ACCNT',{
//				fieldLabel: '~',
//				valueFieldName: 'TO_ACCNT_CODE', 
//				textFieldName: 'TO_ACCNT_NAME',
//				validateBlank: false,
//				listeners: {
//					applyextparam: function(popup){
//						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI IN ('K', 'K2')"});		//WHERE절 추카 쿼리
//						popup.setExtParam({'CHARGE_CODE': gsChargeCode});					//bParam(3)
//					},
//					onTextSpecialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_DEPT_CODE').focus();
//						}
//					}
//				}
//			}),{
//				fieldLabel: '상각완료여부',
//				name:'DPR_STS',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A035',
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_DRB_YEAR').focus();
//						}
//					}
//				}
//			},Unilite.popup('DEPT',{
//				fieldLabel: '부서',
//				validateBlank: false,
//				valueFieldName: 'FR_DEPT_CODE', 
//				textFieldName: 'FR_DEPT_NAME'
//			}),
//				Unilite.popup('DEPT',{
//				fieldLabel: '~',
//				validateBlank: false,
//				valueFieldName: 'TO_DEPT_CODE', 
//				textFieldName: 'TO_DEPT_NAME',
//				listeners: {
//					onTextSpecialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_PJT_CODE').focus();
//						}
//					}
//				}
//			}),{
//				xtype: 'container',
//				items:[{
//					xtype: 'container',
//					defaultType: 'uniNumberfield',
//					layout: {type: 'uniTable', columns: 2},
//					items: [{
//						fieldLabel: '내용년수',
//						name: 'FR_DRB_YEAR',
//						width: 200
//					}, {
//						fieldLabel: '~',
//						name: 'TO_DRB_YEAR',
//						labelWidth: 15,
//						width: 135,
//						listeners: {
//							specialKey: function(elm, e){
//								if (e.getKey() == e.ENTER) {
//									inputTable.getField('FR_ACQ_DATE').focus();
//								}
//							}
//						}
//					}] 
//				}]
//			},
//				Unilite.popup('AC_PROJECT',{
//				fieldLabel: '프로젝트',
//				validateBlank: false,
//				valueFieldName: 'FR_PJT_CODE',
//				textFieldName: 'FR_PJT_NAME'
//			}),
//				Unilite.popup('AC_PROJECT',{
//				fieldLabel: '~',
//				validateBlank: false,
//				valueFieldName: 'TO_PJT_CODE',
//				textFieldName: 'TO_PJT_NAME',
//				listeners: {
//					onTextSpecialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('CAPI_YN').focus();
//						}
//					}
//				}
//			}),{
//				fieldLabel: '취득일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_ACQ_DATE',
//				endFieldName: 'TO_ACQ_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_CAPI_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '자본적지출여부',
//				name:'CAPI_YN',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A020',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('WASTE_SW').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '자본적지출일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_CAPI_DATE',
//				endFieldName: 'TO_CAPI_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_WASTE_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '매각/폐기구분',
//				name:'WASTE_SW',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A039',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('CHG_DRB_YEAR_YN').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '매각/폐기일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_WASTE_DATE',
//				endFieldName: 'TO_WASTE_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_CHG_DRB_YEAR_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '내용년수변경여부',
//				name:'CHG_DRB_YEAR_YN',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A020',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('CHG_DEP_CTL_YN').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '내용년수변경일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_CHG_DRB_YEAR_DATE',
//				endFieldName: 'TO_CHG_DRB_YEAR_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_CHG_DEP_CTL_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '삼각방법변경여부',
//				name:'CHG_DEP_CTL_YN',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A020',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('MOVE_YN').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '삼각방법변경일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_CHG_DEP_CTL_DATE',
//				endFieldName: 'TO_CHG_DEP_CTL_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_MOVE_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '이동여부',
//				name:'MOVE_YN',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A020',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('PAT_YN').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '이동일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_MOVE_DATE',
//				endFieldName: 'TO_MOVE_DATE',
//				width:315,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('FR_PAT_DATE').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '분할여부',
//				name:'PAT_YN',	
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'A020',
//				colspan:2,
//				listeners: {
//					specialKey: function(elm, e){
//						if (e.getKey() == e.ENTER) {
//							inputTable.getField('DPR_STS').focus();
//						}
//					}
//				}
//			},{
//				fieldLabel: '분할일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_PAT_DATE',
//				endFieldName: 'TO_PAT_DATE',
//				width:315
//			}	
//		]
//	});
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items :[
		Unilite.popup('IFRS_ASSET',{ 
			fieldLabel: '자산코드', 
			valueFieldName: 'FR_ASST_CODE',
			textFieldName: 'FR_ASST_NAME',
			autoPopup : true,
//			allowBlank:false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
//						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('ASSET_CODE', '');
//					panelSearch.setValue('ASSET_NAME', '');
//				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('FR_ASST_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('FR_ASST_NAME', newValue);
						panelResult.setValue('FR_ASST_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('FR_ASST_NAME', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('FR_ASST_CODE', newValue);
						panelResult.setValue('FR_ASST_CODE', newValue);
					}
				}
			}
		}),
		Unilite.popup('IFRS_ASSET',{
			fieldLabel: '~',
			valueFieldName: 'TO_ASST_CODE',
			textFieldName: 'TO_ASST_NAME',
			autoPopup : true,
//			allowBlank:false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ASSET_CODE2', panelResult.getValue('ASSET_CODE2'));
//						panelSearch.setValue('ASSET_NAME2', panelResult.getValue('ASSET_NAME2'));
//					},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('ASSET_CODE2', '');
//					panelSearch.setValue('ASSET_NAME2', '');
//				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('TO_ASST_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('TO_ASST_NAME', newValue);
						panelResult.setValue('TO_ASST_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('TO_ASST_NAME', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('TO_ASST_CODE', newValue);
						panelResult.setValue('TO_ASST_CODE', newValue);
					}
				}
			}
		}),{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true,
			typeAhead: false,
			comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '자산구분',
			name:'ASST_DIVI',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			}
		}]
	});
		
	var masterGrid = Unilite.createGrid('aiss500ukrvMasterGrid', {
		layout : 'fit',
		//region : 'north',
		store : directMasterStore,
		uniOpt: {
//			expandLastColumn: false,
			useRowNumberer: true
//			copiedRow: true
//			useContextMenu: true,
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
//			{dataIndex: 'COMP_CODE'							, width: 100},
			{dataIndex: 'ASST_DIVI'							, width: 100},
			{dataIndex: 'ASST'								, width: 100},
			{dataIndex: 'ASST_NAME'							, width: 200},
			{dataIndex: 'SPEC'								, width: 100},
			{dataIndex: 'DIV_CODE'							, width: 100},
			{dataIndex: 'PJT_NAME'							, width: 166},
			{dataIndex: 'ACCNT_NAME'						, width: 100},
			{dataIndex: 'ACQ_DATE'							, width: 100},
			{dataIndex: 'USE_DATE'							, width: 100},
			{dataIndex: 'ACQ_Q'								, width: 100},
			{dataIndex: 'ACQ_AMT_I'							, width: 166},
			{dataIndex: 'PAT_YN'							, width: 100},
			{dataIndex: 'DPR_YYMM'							, width: 100},
			{dataIndex: 'STOCK_Q'							, width: 100 , hidden: true},
			{dataIndex: 'DRB_YEAR'							, width: 100 , hidden: true},
			{dataIndex: 'DEP_CTL'							, width: 166 , hidden: true},
			{dataIndex: 'DEPT_CODE'							, width: 100 , hidden: true},
			{dataIndex: 'DEPT_NAME'							, width: 100 , hidden: true},
			{dataIndex: 'FI_CAPI_TOT_I'						, width: 100 , hidden: true},
			{dataIndex: 'FI_SALE_TOT_I'						, width: 100 , hidden: true},
			{dataIndex: 'FI_SALE_DPR_TOT_I' 				, width: 166 , hidden: true},
			{dataIndex: 'FI_REVAL_TOT_I'					, width: 100 , hidden: true},
			{dataIndex: 'FI_DPR_TOT_I'						, width: 100 , hidden: true},
			{dataIndex: 'FI_DMGLOS_TOT_I'					, width: 100 , hidden: true},
			{dataIndex: 'FL_BALN_I'							, width: 90  , hidden: true},
			{dataIndex: 'FL_ACQ_AMT_I'						, width: 100 , hidden: true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					eprYYMM = record.get('DPR_YYMM');
					
					var activeGridId = tab.getActiveTab().id;
					if(activeGridId == 'aiss500ukrvDetailGrid1')	{
						directDetailStore1.loadData({});
						if(!record.phantom){
							directDetailStore1.loadStoreRecords(record);
						}
					}else if(activeGridId == 'aiss500ukrvDetailGrid2'){
						directDetailStore2.loadData({});
						if(!record.phantom){
							directDetailStore2.loadStoreRecords(record);
						}
					}else if(activeGridId == 'aiss500ukrvDetailGrid3'){
						directDetailStore3.loadData({});
						if(!record.phantom){
							directDetailStore3.loadStoreRecords(record);
						}
					}else if(activeGridId == 'aiss500ukrvDetailGrid4'){
						directDetailStore4.loadData({});
						if(!record.phantom){
							directDetailStore4.loadStoreRecords(record);
						}
					}else if(activeGridId == 'aiss500ukrvDetailGrid5'){
						directDetailStore5.loadData({});
						if(!record.phantom){
							directDetailStore5.loadStoreRecords(record);
						}
					}else if(activeGridId == 'aiss500ukrvDetailGrid6'){
						directDetailStore6.loadData({});
						if(!record.phantom){
//							Ext.getCmp('textLabel1').setText("<font color = 'red' >※ 변경 전 내용년수는 자산마스터 정보를 기준으로 합니다. 따라서, 등록하려는 변경일의 이전월까지 감가상각계산을 완료하셔야 합니다. 현재 최종상각월은</font>"  + UniDate.getDbDateStr(record.get('DPR_YYMM')) + "입니다.");
							directDetailStore6.loadStoreRecords(record);
						}
					}
				}
			},
			render: function(grid, eOpts){
				grid.getEl().on('click', function(e, t, eOpt) {
//					if(tabCount == 1){
						UniAppManager.setToolbarButtons(['newData'], false);
						UniAppManager.setToolbarButtons(['delete'], false);
//						tabCount = 0;
//					}
				});
			},	
			beforeselect : function ( gird, record, index, eOpts ){
//				if( tabCount > 0) return true;
				var isNewCardShow = true;		//newCard 보여줄것인지?
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(activeGridId)	{
					case 'aiss500ukrvDetailGrid1':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore
										inValidRecs = directDetailStore1.getInvalidRecords();
										activeStore = directDetailStore1;	
										
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										masterGrid.getSelectionModel().select(index);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid2':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore
										inValidRecs = directDetailStore2.getInvalidRecords();
										activeStore = directDetailStore2;
										
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										masterGrid.getSelectionModel().select(index);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid3':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL, 
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore
										inValidRecs = directDetailStore3.getInvalidRecords();
										activeStore = directDetailStore3;
										
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										masterGrid.getSelectionModel().select(index);
									}else{
										
									}
								}
							});
						}
						break;
					default:
						break;
				}
				return isNewCardShow;
			},
			beforeedit  : function( editor, e, eOpts ) {
				return false;
//				if (UniUtils.indexOf(e.field,['SEQ', 'ACCNT_CD'])) {
//					if(e.record.phantom){
//						return true;
//					}else{
//						return false;
//					}
//				}else if (UniUtils.indexOf(e.field,['ACCNT_NAME', 'ACCNT_NAME2', 'ACCNT_NAME3', 'OPT_DIVI', 'RIGHT_LEFT', 'DIS_DIVI'])) {
//					return true;
//				}else if (UniUtils.indexOf(e.field,['KIND_DIVI'])) {
//					return true;
//				}else{
//					return false;
//				}
			},
			itemmouseenter:function(view, record, item, index, e, eOpts )	{
				view.ownerGrid.setCellPointer(view, item);
			}
//			onGridDblClick: function(grid, record, cellIndex, colName) {
//				var params = {
//					appId: UniAppManager.getApp().id,
//					sender: this,
//					action: 'new',
//					ASST: record.get('ASST'),
//					ASST_NAME: record.get('ASST_NAME')
//				}
//				var rec = {data : {prgID : 'ass300ukr', 'text':''}};
//				parent.openTab(rec, '/accnt/ass300ukr.do', params);
//			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			//menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [
				{	text	: '자산정보 등록',
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAss300skr(param.record);
					}
				}
			]
		},
		gotoAss300skr:function(record)	{
			if(record)	{
				var params = record;
				
				params.PGM_ID		= 'aiss500ukrv';
				params.ASST			= record.get('ASST');
				params.ASST_NAME	= record.get('ASST_NAME');
			}
			var rec1 = {data : {prgID : 'aiss300ukrv', 'text':''}};
			parent.openTab(rec1, '/accnt/aiss300ukrv.do', params);
		}
	});
	
	/**
	* Master Grid2 정의(Grid Panel)
	* @type 
	*/
	var detailGrid1 = Unilite.createGrid('aiss500ukrvDetailGrid1', {
		title : '자본적지출',
		excelTitle:'자본적지출',
		//region : 'south',
		layout : 'fit',
		store : directMasterStore, 
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		store: directDetailStore1,
		features: [{
			id: 'masterGridSubTotal1',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal1',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'COMP_CODE'							, width: 100, hidden:true},
			{dataIndex: 'ASST'								, width: 100, hidden:true},
			{dataIndex: 'ALTER_DIVI'						, width: 100, hidden:true},
			{dataIndex: 'SEQ'								, width: 66},
			{dataIndex: 'ALTER_YYMM'						, width: 100, hidden:true},
			{dataIndex: 'ALTER_DATE'						, width: 88},
			{dataIndex: 'MONEY_UNIT'						, width: 88},
			{dataIndex: 'EXCHG_RATE_O'						, width: 88},
			{dataIndex: 'FOR_ALTER_AMT_I'					, width: 100},
			{dataIndex: 'ALTER_AMT_I'						, width: 100},
			{dataIndex: 'ALTER_REASON'						, width: 100},
			{dataIndex: 'SET_TYPE'							, width: 100},
			{dataIndex: 'PROOF_KIND'						, width: 150
				,editor:{
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
					listeners:{
						beforequery:function(queryPlan, value)	{
							this.store.clearFilter();
							this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
						}
					}
				}
			},
			{dataIndex: 'SUPPLY_AMT_I'						, width: 100},
			{dataIndex: 'TAX_AMT_I'							, width: 100},
			{dataIndex: 'CUSTOM_CODE'						, width: 100,
				editor: Unilite.popup('CUST_G', {
						autoPopup: true,
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
										rtnRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', '');
										rtnRecord.set('CUSTOM_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'CUSTOM_NAME'						, width: 150,
				editor: Unilite.popup('CUST_G', {
						autoPopup: true,
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
										rtnRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', '');
										rtnRecord.set('CUSTOM_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'SAVE_CODE'							, width: 100,
				editor: Unilite.popup('BANK_BOOK_G', {
						autoPopup: true,
						textFieldName: 'SAVE_CODE',
						DBtextFieldName: 'SAVE_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', records[0]['BANK_BOOK_CODE']);
										rtnRecord.set('SAVE_NAME', records[0]['BANK_BOOK_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', '');
										rtnRecord.set('SAVE_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'SAVE_NAME'							, width: 100,
				editor: Unilite.popup('BANK_BOOK_G', {
						autoPopup: true,
						textFieldName: 'SAVE_CODE',
						DBtextFieldName: 'SAVE_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', records[0]['BANK_BOOK_CODE']);
										rtnRecord.set('SAVE_NAME', records[0]['BANK_BOOK_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', '');
										rtnRecord.set('SAVE_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'CREDIT_NUM'						, width: 100,
				editor: Unilite.popup('CREDIT_NO_G', {
						autoPopup: true,
						textFieldName: 'CREDIT_NUM',
						DBtextFieldName: 'CREDIT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CREDIT_NUM', records[0]['CREDIT_NO_CODE']);
										rtnRecord.set('CREDIT_NAME', records[0]['CREDIT_NO_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CREDIT_NUM', '');
										rtnRecord.set('CREDIT_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'CREDIT_NAME'						, width: 100,
				editor: Unilite.popup('CREDIT_NO_G', {
						autoPopup: true,
						textFieldName: 'CREDIT_NUM',
						DBtextFieldName: 'CREDIT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CREDIT_NUM', records[0]['CREDIT_NO_CODE']);
										rtnRecord.set('CREDIT_NAME', records[0]['CREDIT_NO_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid1.uniOpt.currentRecord;
										rtnRecord.set('CREDIT_NUM', '');
										rtnRecord.set('CREDIT_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'REASON_CODE'						, width: 100},
			{dataIndex: 'PAY_SCD_DATE'						, width: 88},
			{dataIndex: 'EB_YN'								, width: 100, allowBlank: false},
			{dataIndex: 'EX_DATE'							, width: 88}, 
			{dataIndex: 'EX_NUM'							, width: 66},
			{dataIndex: 'INSERT_DB_USER'					, width: 100, hidden:true},
			{dataIndex: 'INSERT_DB_TIME'					, width: 100, hidden:true},	
			{dataIndex: 'UPDATE_DB_USER'					, width: 100, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'					, width: 100, hidden:true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore1.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
					activeGridId = girdNm;
				});
			},
			beforedeselect : function ( gird, record, index, eOpts ){
			},
			beforeedit : function( editor, e, eOpts ) {
				if(masterGrid.getSelectedRecord().get('PAT_YN') == 'Y'){
					return false;
				}
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'EX_DATE' || e.field == 'EX_NUM'){
						return false;
					}
				}
			}
		}
	});
	
	var detailGrid2 = Unilite.createGrid('aiss500ukrvDetailGrid2', {
		layout : 'fit',
		//region : 'south',
		title : '매각/폐기',
		excelTitle:'매각/폐기',
		store : directDetailStore2,
		features: [{
			id: 'masterGridSubTotal2',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
			},{
			id: 'masterGridTotal2',	
			ftype: 'uniSummary',
			showSummaryRow: false
		}], 
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		columns: [		
			{dataIndex: 'COMP_CODE'							, width: 100 , hidden:true},
			{dataIndex: 'ASST'								, width: 100 , hidden:true},
			{dataIndex: 'ALTER_DIVI'						, width: 100 , hidden:true},
			{dataIndex: 'SEQ'								, width: 66},
			{dataIndex: 'WASTE_DIVI'						, width: 100},
			{dataIndex: 'ALTER_YYMM'						, width: 100 , hidden:true},
			{dataIndex: 'ALTER_DATE'						, width: 100},
			{dataIndex: 'ALTER_Q'							, width: 100},
			{dataIndex: 'MONEY_UNIT'						, width: 100},
			{dataIndex: 'EXCHG_RATE_O'						, width: 100},
			{dataIndex: 'FOR_ALTER_AMT_I'					, width: 100},
			{dataIndex: 'ALTER_AMT_I'						, width: 100},
			{dataIndex: 'ALTER_REASON'						, width: 100},
			{dataIndex: 'SET_TYPE'							, width: 100},
			{dataIndex: 'PROOF_KIND'						, width: 150,
				editor:{
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
					listeners:{
						beforequery:function(queryPlan, value)	{
							this.store.clearFilter();
							this.store.filterBy(function(record){return record.get('refCode3') == '2'},this);
						}
					}
				}
			},
			{dataIndex: 'SUPPLY_AMT_I'						, width: 100},
			{dataIndex: 'TAX_AMT_I'							, width: 100},
			{dataIndex: 'CUSTOM_CODE'						, width: 100,
				editor: Unilite.popup('CUST_G', {
						autoPopup: true,
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
										rtnRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', '');
										rtnRecord.set('CUSTOM_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'CUSTOM_NAME'						, width: 100,
				editor: Unilite.popup('CUST_G', {
						autoPopup: true,
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
										rtnRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('CUSTOM_CODE', '');
										rtnRecord.set('CUSTOM_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'SAVE_CODE'							, width: 100,
				editor: Unilite.popup('BANK_BOOK_G', {
						autoPopup: true,
						textFieldName: 'SAVE_CODE',
						DBtextFieldName: 'SAVE_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', records[0]['BANK_BOOK_CODE']);
										rtnRecord.set('SAVE_NAME', records[0]['BANK_BOOK_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', '');
										rtnRecord.set('SAVE_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			},
			{dataIndex: 'SAVE_NAME'							, width: 100,
				editor: Unilite.popup('BANK_BOOK_G', {
						autoPopup: true,
						textFieldName: 'SAVE_CODE',
						DBtextFieldName: 'SAVE_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', records[0]['BANK_BOOK_CODE']);
										rtnRecord.set('SAVE_NAME', records[0]['BANK_BOOK_NAME']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid2.uniOpt.currentRecord;
										rtnRecord.set('SAVE_CODE', '');
										rtnRecord.set('SAVE_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			}, 
			{dataIndex: 'PAY_SCD_DATE'						, width: 100},
			{dataIndex: 'EB_YN'								, width: 100, allowBlank: false},
			{dataIndex: 'ALTER_PROFIT'						, width: 100},
			{dataIndex: 'EX_DATE'							, width: 100},
			{dataIndex: 'EX_NUM'							, width: 100},
		    {dataIndex: 'SALE_ACQ_AMT_I' 	 		       	, width: 100 , hidden:true},
			{dataIndex: 'INSERT_DB_USER'					, width: 100 , hidden:true},
			{dataIndex: 'INSERT_DB_TIME'					, width: 100 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'					, width: 100 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'					, width: 100 , hidden:true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore2.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(masterGrid.getSelectedRecord().get('PAT_YN') == 'Y'){
					return false;
				}
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'ALTER_PROFIT' || e.field == 'EX_DATE' || e.field == 'EX_NUM'){
						return false;
					}
				}
			}
		}
	});
	
	var detailGrid3 = Unilite.createGrid('aiss500ukrvDetailGrid3', {
		layout : 'fit',
		//region : 'south',
		title : '내용년수변경',
		excelTitle:'내용년수변경',
		store : directDetailStore3,
		features: [{
			id: 'masterGridSubTotal3',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal3',
			ftype: 'uniSummary',
			showSummaryRow: false
		}], 
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		tbar:[{
				border: false,
				xtype: 'label',
				id: 'textLabel1',
				html: "<font color = 'red' >※ 변경 전 내용년수는 자산마스터 정보를 기준으로 합니다. 따라서, 등록하려는 변경일의 이전월까지 감가상각계산을 완료하셔야 합니다.</font>"
			}
		],
		columns: [
			{dataIndex: 'COMP_CODE'							, width: 100 , hidden: true},
			{dataIndex: 'ASST'								, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DIVI'						, width: 100 , hidden: true},
			{dataIndex: 'SEQ'								, width: 66},
			{dataIndex: 'ALTER_YYMM'						, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DATE'						, width: 100},
			{dataIndex: 'BF_DRB_YEAR'						, width: 100},
			{dataIndex: 'AF_DRB_YEAR'						, width: 100},
			{dataIndex: 'ALTER_REASON'						, width: 100 , flex: 1},
			{dataIndex: 'INSERT_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_TIME'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'					, width: 100 , hidden: true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore3.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'BF_DRB_YEAR'){
						return false;
					}
				}
			}
		}
	});
	
	var detailGrid4 = Unilite.createGrid('aiss500ukrvDetailGrid4', {
		layout : 'fit',
		//region : 'south',
		title : '상각방법변경',
		excelTitle:'상각방법변경',
		store : directDetailStore4,
		features: [{
			id: 'masterGridSubTotal4',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal4',
			ftype: 'uniSummary',
			showSummaryRow: false
		}], 
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		tbar:[{
				xtype: 'component',
				border: false,
				html: "<font color = 'red' >※ 변경 전 상각방법은 자산마스터 정보를 기준으로 합니다. 따라서, 등록하려는 변경일의 이전월까지 감가상각계산을 완료하셔야 합니다.</font>"
			}
		],
		columns: [
			{dataIndex: 'COMP_CODE'							, width: 100 , hidden: true},
			{dataIndex: 'ASST'								, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DIVI'						, width: 100 , hidden: true},
			{dataIndex: 'SEQ'								, width: 66},
			{dataIndex: 'ALTER_YYMM'						, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DATE'						, width: 100},
			{dataIndex: 'BF_DEP_CTL'						, width: 100},
			{dataIndex: 'AF_DEP_CTL'						, width: 100},
			{dataIndex: 'ALTER_REASON'						, width: 100 , flex: 1},
			{dataIndex: 'INSERT_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_TIME'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'					, width: 100 , hidden: true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore4.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'BF_DEP_CTL'){
						return false;
					}
				}
			}
		}
	});
	
	var detailGrid5 = Unilite.createGrid('aiss500ukrvDetailGrid5', {
		layout : 'fit',
		//region : 'south',
		title : '이동',
		excelTitle:'이동',
		store : directDetailStore5,
		features: [{
			id: 'masterGridSubTotal5',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal5',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		tbar:[{
			 xtype: 'component',
				border: false,
				html: "<font color = 'red' >※ 이동 전 부서 및 사업장은 자산마스터 정보를 기준으로 합니다. 따라서, 등록하려는 이동일의 이전월까지 감가상각계산을 완료하셔야 합니다.</font>"
			}
		],
		columns: [
			{dataIndex: 'COMP_CODE'							, width: 100 , hidden: true},
			{dataIndex: 'ASST'								, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DIVI'						, width: 100 , hidden: true},
			{dataIndex: 'SEQ'								, width: 66},
			{dataIndex: 'ALTER_YYMM'						, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DATE'						, width: 100},
			{dataIndex: 'BF_DEPT_CODE'						, width: 100 ,
				editor: Unilite.popup('DEPT_G', {
						autoPopup: true,
						textFieldName: 'BF_DEPT_CODE',
						DBtextFieldName: 'BF_DEPT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
										var rtnRecord = detailGrid5.uniOpt.currentRecord;
										rtnRecord.set('BF_DEPT_CODE', records[0]['TREE_CODE']);
										rtnRecord.set('BF_DEPT_NAME', records[0]['TREE_NAME']);
										rtnRecord.set('BF_DIV_CODE', records[0]['DIV_CODE']);
									},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
										rtnRecord.set('BF_DEPT_CODE', '');
										rtnRecord.set('BF_DEPT_NAME', '');
										rtnRecord.set('BF_DIV_CODE', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			}, 
			{dataIndex: 'BF_DEPT_NAME'						, width: 150,
				editor: Unilite.popup('DEPT_G', {
						autoPopup: true,
						textFieldName: 'BF_DEPT_CODE',
						DBtextFieldName: 'BF_DEPT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('BF_DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('BF_DEPT_NAME', records[0]['TREE_NAME']);
									rtnRecord.set('BF_DIV_CODE', records[0]['DIV_CODE']);
								},
								scope: this	
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('BF_DEPT_CODE', '');
									rtnRecord.set('BF_DEPT_NAME', '');
									rtnRecord.set('BF_DIV_CODE', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			}, 
			{dataIndex: 'BF_DIV_CODE'						, width: 120},
			{dataIndex: 'AF_DEPT_CODE'						, width: 100,
				editor: Unilite.popup('DEPT_G', {
						autoPopup: true,
						textFieldName: 'AF_DEPT_CODE',
						DBtextFieldName: 'AF_DEPT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('AF_DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('AF_DEPT_NAME', records[0]['TREE_NAME']);
									rtnRecord.set('AF_DIV_CODE', records[0]['DIV_CODE']);
								},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('AF_DEPT_CODE', '');
									rtnRecord.set('AF_DEPT_NAME', '');
									rtnRecord.set('AF_DIV_CODE', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			}, 
			{dataIndex: 'AF_DEPT_NAME'						, width: 150,
				editor: Unilite.popup('DEPT_G', {
						autoPopup: true,
						textFieldName: 'AF_DEPT_CODE',
						DBtextFieldName: 'AF_DEPT_NAME',
							listeners: {'onSelected': {
								fn: function(records, type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('AF_DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('AF_DEPT_NAME', records[0]['TREE_NAME']);
								},
								scope: this
								},
								'onClear': function(type) {
									var rtnRecord = detailGrid5.uniOpt.currentRecord;
									rtnRecord.set('AF_DEPT_CODE', '');
									rtnRecord.set('AF_DEPT_NAME', '');
								},
								applyextparam: function(popup){
									
								}
							}
						})
			}, 
			{dataIndex: 'AF_DIV_CODE'						, width: 120},
			{dataIndex: 'ALTER_REASON'						, width: 100 , flex: 1},
			{dataIndex: 'INSERT_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_TIME'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'					, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'					, width: 100 , hidden: true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore5.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'BF_DEPT_CODE' || e.field == 'BF_DEPT_NAME' || e.field == 'BF_DIV_CODE'){
						return false;
					}
				}
			}
		}
	});
	
	var detailGrid6 = Unilite.createGrid('aiss500ukrvDetailGrid6', {
		layout : 'fit',
		// region : 'south',
		title : '분할',
		excelTitle:'분할',
		store : directDetailStore6,
		features: [{
			id: 'masterGridSubTotal6',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
			},{
			id: 'masterGridTotal6',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true,
			onLoadSelectFirst: false
//			useContextMenu: true,
		},
		tbar:[
			//'->',		//분할 버튼 작업 일시 보류
			{
				xtype:'button',
				text:'분할실행',
				itemId:'start',
				handler:function()	{
					if(confirm(Msg.fSbMsgA0330)){
						var param = {
							S_COMP_CODE : UserInfo.compCode,
							ASST		: masterGrid.getSelectedRecords()[0].data.ASST,
							ALTER_DATE  :UniDate.getDbDateStr(directDetailStore6.data.items[0].data.ALTER_DATE)
						}
						detailGrid6.getEl().mask('로딩중...','loading-indicator');
						aiss500ukrvService.fnAiss500Proc(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								alert(Msg.sMB021);	// 작업이 완료 되었습니다.
							}/*else{
								alert(Msg.sMB004);	// 자료조회중 오류가 발생하였습니다.
							}*/
							detailGrid6.getEl().unmask();
							UniAppManager.app.onQueryButtonDown();
						});
					}
				}
			},
			{
				xtype:'button',
				text:'분할취소',
				itemId:'cancel',
				handler:function()	{
					if(confirm(Msg.fSbMsgA0332)){
						var param = {
							S_COMP_CODE : UserInfo.compCode,
							ASST		: masterGrid.getSelectedRecords()[0].data.ASST,
							ALTER_DATE  :UniDate.getDbDateStr(directDetailStore6.data.items[0].data.ALTER_DATE)
						}
						detailGrid6.getEl().mask('로딩중...','loading-indicator');
						aiss500ukrvService.fnAiss500Canc(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								alert(Msg.sMB021);	// 작업이 완료 되었습니다.
							}/*else{
								alert(Msg.sMB004);	// 자료조회중 오류가 발생하였습니다.
							}*/
							detailGrid6.getEl().unmask();
							UniAppManager.app.onQueryButtonDown();
						});
					}
				}
			},
			{
				border: false,
				xtype: 'component',
				html: "&nbsp;" + eprYYMM,
				width:20
			},
			{
				border: false,
				xtype: 'component',
				html: "<font color = 'blue' >※ 분할취득가액을 입력하면 비율에 의해 나머지 금액은 자동 분할 계산됩니다. 저장 후 [분할실행] 버튼을 눌러야 분할됩니다.</font></br><font color = 'red' >※ 분할대상금액은 자산마스터 정보를 기준으로 합니다. 따라서, 등록하려는 분할일의 이전월까지 감가상각계산을 완료하셔야 합니다. </font>"
				+ eprYYMM,
				width:730
			}
		],
		columns: [
			{dataIndex: 'COMP_CODE'									, width: 100 , hidden: true},
			{dataIndex: 'ASST'										, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DIVI'								, width: 100 , hidden: true},
			{dataIndex: 'SEQ'										, width: 66},
			{dataIndex: 'ALTER_YYMM'								, width: 100 , hidden: true},
			{dataIndex: 'ALTER_DATE'								, width: 100},
			{dataIndex: 'PAT_ASST'									, width: 100},
			{dataIndex: 'ALTER_Q'									, width: 100},
			{dataIndex: 'PAT_ACQ_AMT_I'								, width: 120},
			{dataIndex: 'PAT_FI_CAPI_TOT_I'							, width: 140},
			{dataIndex: 'PAT_FI_SALE_TOT_I'							, width: 140},
			{dataIndex: 'PAT_FI_SALE_DPR_TOT_I'						, width: 165},
			{dataIndex: 'PAT_FI_REVAL_TOT_I'						, width: 140},
			{dataIndex: 'PAT_FI_DPR_TOT_I'							, width: 140},
			{dataIndex: 'PAT_FI_DMGLOS_TOT_I'						, width: 140},
			{dataIndex: 'PAT_FL_BALN_I'								, width: 140},
			{dataIndex: 'PAT_FL_ACQ_AMT_I'							, width: 140 , hidden: true},
			{dataIndex: 'ALTER_REASON'								, width: 100},
			{dataIndex: 'PAT_YN'									, width: 100 , flex: 1},
			{dataIndex: 'INSERT_DB_USER'							, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_TIME'							, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'							, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'							, width: 100 , hidden: true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				var mLength = directMasterStore.data.items.length;
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
					if(directDetailStore6.data.items.length > 0){
						UniAppManager.setToolbarButtons('delete', true);
					}else{
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom || e.record.phantom){
					if(e.field == 'SEQ' || e.field == 'PAT_YN'){
						return false;
					}
				}
			}
		}
	});
	
	
	var tab = Unilite.createTabPanel('tabPanel',{
		//region:'south',
		items: [
			detailGrid1,
			detailGrid2,
			detailGrid3,
			detailGrid4,
			detailGrid5,
			detailGrid6
		],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
//				if( tabCount > 0) return true; 
				var newTabId = newCard.getId();
				var isNewCardShow = true;		//newCard 보여줄것인지?
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(newTabId)	{
					case 'aiss500ukrvDetailGrid1':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore
										if(directDetailStore2.isDirty()){
											inValidRecs = directDetailStore2.getInvalidRecords();
											activeStore = directDetailStore2;
										}else if(directDetailStore3.isDirty()){
											inValidRecs = directDetailStore3.getInvalidRecords();
											activeStore = directDetailStore3;
										}else if(directDetailStore4.isDirty()){
											inValidRecs = directDetailStore4.getInvalidRecords();
											activeStore = directDetailStore4;
										}else if(directDetailStore5.isDirty()){
											inValidRecs = directDetailStore5.getInvalidRecords();
											activeStore = directDetailStore5;
										}else if(directDetailStore6.isDirty()){
											inValidRecs = directDetailStore6.getInvalidRecords();
											activeStore = directDetailStore6;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
//											tabCount = 1;
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid2':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore;
										if(directDetailStore1.isDirty()){
											inValidRecs = directDetailStore1.getInvalidRecords();
											activeStore = directDetailStore1;
										}else if(directDetailStore3.isDirty()){
											inValidRecs = directDetailStore3.getInvalidRecords();
											activeStore = directDetailStore3;
										}else if(directDetailStore4.isDirty()){
											inValidRecs = directDetailStore4.getInvalidRecords();
											activeStore = directDetailStore4;
										}else if(directDetailStore5.isDirty()){
											inValidRecs = directDetailStore5.getInvalidRecords();
											activeStore = directDetailStore5;
										}else if(directDetailStore6.isDirty()){
											inValidRecs = directDetailStore6.getInvalidRecords();
											activeStore = directDetailStore6;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid3':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore;
										if(directDetailStore1.isDirty()){
											inValidRecs = directDetailStore1.getInvalidRecords();
											activeStore = directDetailStore1;
										}else if(directDetailStore2.isDirty()){
											inValidRecs = directDetailStore2.getInvalidRecords();
											activeStore = directDetailStore2;
										}else if(directDetailStore4.isDirty()){
											inValidRecs = directDetailStore4.getInvalidRecords();
											activeStore = directDetailStore4;
										}else if(directDetailStore5.isDirty()){
											inValidRecs = directDetailStore5.getInvalidRecords();
											activeStore = directDetailStore5;
										}else if(directDetailStore6.isDirty()){
											inValidRecs = directDetailStore6.getInvalidRecords();
											activeStore = directDetailStore6;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid4':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore;
										if(directDetailStore1.isDirty()){
											inValidRecs = directDetailStore1.getInvalidRecords();
											activeStore = directDetailStore1;
										}else if(directDetailStore2.isDirty()){
											inValidRecs = directDetailStore2.getInvalidRecords();
											activeStore = directDetailStore2;
										}else if(directDetailStore3.isDirty()){
											inValidRecs = directDetailStore3.getInvalidRecords();
											activeStore = directDetailStore3;
										}else if(directDetailStore5.isDirty()){
											inValidRecs = directDetailStore5.getInvalidRecords();
											activeStore = directDetailStore5;
										}else if(directDetailStore6.isDirty()){
											inValidRecs = directDetailStore6.getInvalidRecords();
											activeStore = directDetailStore6;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid5':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore;
										if(directDetailStore1.isDirty()){
											inValidRecs = directDetailStore1.getInvalidRecords();
											activeStore = directDetailStore1;
										}else if(directDetailStore2.isDirty()){
											inValidRecs = directDetailStore2.getInvalidRecords();
											activeStore = directDetailStore2;
										}else if(directDetailStore3.isDirty()){
											inValidRecs = directDetailStore3.getInvalidRecords();
											activeStore = directDetailStore3;
										}else if(directDetailStore4.isDirty()){
											inValidRecs = directDetailStore4.getInvalidRecords();
											activeStore = directDetailStore4;
										}else if(directDetailStore6.isDirty()){
											inValidRecs = directDetailStore6.getInvalidRecords();
											activeStore = directDetailStore6;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;
						
					case 'aiss500ukrvDetailGrid6':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									//console.log(res);
									if (res === 'yes' ) {
										var inValidRecs;
										var activeStore;
										if(directDetailStore1.isDirty()){
											inValidRecs = directDetailStore1.getInvalidRecords();
											activeStore = directDetailStore1;
										}else if(directDetailStore2.isDirty()){
											inValidRecs = directDetailStore2.getInvalidRecords();
											activeStore = directDetailStore2;
										}else if(directDetailStore3.isDirty()){
											inValidRecs = directDetailStore3.getInvalidRecords();
											activeStore = directDetailStore3;
										}else if(directDetailStore4.isDirty()){
											inValidRecs = directDetailStore4.getInvalidRecords();
											activeStore = directDetailStore4;
										}else if(directDetailStore5.isDirty()){
											inValidRecs = directDetailStore5.getInvalidRecords();
											activeStore = directDetailStore5;
										}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
									}else if(res === 'no'){
//										tabCount = 1;
										UniAppManager.setToolbarButtons('save', false);
										tabPanel.setActiveTab(newCard);
									}else{
										
									}
								}
							});
						}
						break;	
					default:
						break;
				}
				return isNewCardShow;
			},
			tabchange: function( tabPanel, newCard, oldCard ) {
//				tabCount = 0;
				var record = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)){
					if(newCard.getId() == 'aiss500ukrvDetailGrid1')	{
						directDetailStore1.loadData({});
						directDetailStore1.loadStoreRecords(record);
						detailGrid1.focus();
					}else if(newCard.getId() == 'aiss500ukrvDetailGrid2'){	
						directDetailStore2.loadData({});
						directDetailStore2.loadStoreRecords(record);
						detailGrid2.focus();
					}else if(newCard.getId() == 'aiss500ukrvDetailGrid3'){
						directDetailStore3.loadData({});
						directDetailStore3.loadStoreRecords(record);
						detailGrid3.focus();
					}else if(newCard.getId() == 'aiss500ukrvDetailGrid4'){
						directDetailStore4.loadData({});
						directDetailStore4.loadStoreRecords(record);
						detailGrid4.focus();
					}else if(newCard.getId() == 'aiss500ukrvDetailGrid5'){
						directDetailStore5.loadData({});
						directDetailStore5.loadStoreRecords(record);
						detailGrid5.focus();
					}else if(newCard.getId() == 'aiss500ukrvDetailGrid6'){
						directDetailStore6.loadData({});
						directDetailStore6.loadStoreRecords(record);
						detailGrid6.focus();
					}
					activeGridId = newCard.getId();
					UniAppManager.setToolbarButtons('newData', true);
				}
			}
		}
	});
	
	var textField = Unilite.createForm('aiss500ukrvText', {
		width: 100,
//		layout : {type : 'uniTable', columns : 3},
		disabled: false,
		border:true,
		padding: '1',
		title:'※ 자산의 변동내역은 변동월의 감가상각계산을 실행하여야 자산마스터에 반영됩니다.'
	});
	
	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult,
//				inputTable,
				masterGrid,
				textField,
				tab
			]
		},
			panelSearch
		]
		, 
		id : 'aiss500ukrvApp',
		fnInitBinding : function() {
//			var gubun = Ext.data.StoreManager.lookup( 'CBS_AU_A093' ).getAt(0).get ('value' );
//			panelSearch.setValue('GUBUN', gsGubun);
//			panelResult.setValue('GUBUN', gsGubun);
			
//			tab.setActiveTab(detailGrid2);
//			alert(getStDt[0].STDT);
//			alert(getStDt[0].TODT);
			UniAppManager.setToolbarButtons(['newData'],false);
			//UniAppManager.setToolbarButtons(['reset'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_ASST_CODE');
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
		}, 
		onNewDataButtonDown : function()	{
			var record = masterGrid.getSelectedRecord();
			if(activeGridId == 'aiss500ukrvDetailGrid1' )	{
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				if(record.get('ASST_DIVI') == '2'){
					alert(Msg.fSbMsgA0323);	// 부외자산은 등록할 수 없습니다.
					return false;
				}
				
				var seq = directDetailStore1.max('SEQ');
				//var alterDate = detailGrid1.getSelectedRecord().data.ALTER_DATE;
				if(!seq) seq = 1;
				else  seq += 1;
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '1',
					
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					MONEY_UNIT: UserInfo.currency,
					SAVE_FLAG: 'N'
				}
				
				detailGrid1.createRow(r, 'ALTER_DATE');
			}else if(activeGridId == 'aiss500ukrvDetailGrid2'){
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				var seq = directDetailStore2.max('SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '2',
					
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					MONEY_UNIT: UserInfo.currency,
					SAVE_FLAG: 'N',
					SALE_ACQ_AMT_I : record.get('ACQ_AMT_I')
				}
				detailGrid2.createRow(r, 'WASTE_DIVI');
				
			}else if(activeGridId == 'aiss500ukrvDetailGrid3')	{
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				if(record.get('ASST_DIVI') == '2'){
					alert(Msg.fSbMsgA0323);	// 부외자산은 등록할 수 없습니다.
					return false;
				}
				
				var seq = directDetailStore3.max('SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '5',
					
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					BF_DRB_YEAR : record.get('DRB_YEAR'),
					SAVE_FLAG: 'N'
				}
				detailGrid3.createRow(r, 'ALTER_DATE');
				
				//자산의 최종상각월과 변동월 비교 
				UniAppManager.app.fnCheckLastDprYYMM(UniDate.get('today'));
			}
			else if(activeGridId == 'aiss500ukrvDetailGrid4')	{
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				if(record.get('ASST_DIVI') == '2'){
					alert(Msg.fSbMsgA0323);	// 부외자산은 등록할 수 없습니다.
					return false;
				}
				
				var seq = directDetailStore4.max('SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '6',
					
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					BF_DEP_CTL: record.get('DEP_CTL'),
					SAVE_FLAG: 'N'
				}
				detailGrid4.createRow(r, 'ALTER_DATE');
				
				//자산의 최종상각월과 변동월 비교 
				UniAppManager.app.fnCheckLastDprYYMM(UniDate.get('today'));
			}
			else if(activeGridId == 'aiss500ukrvDetailGrid5')	{
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				var seq = directDetailStore5.max('SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '7',
					
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					BF_DEPT_CODE: record.get('DEPT_CODE'),
					BF_DEPT_NAME: record.get('DEPT_NAME'),
					BF_DIV_CODE: record.get('DIV_CODE'),
					SAVE_FLAG: 'N'
				}
				detailGrid5.createRow(r, 'ALTER_DATE');
				var toCreate = directDetailStore5.getNewRecords();
				//자산의 최종상각월과 변동월 비교 
				UniAppManager.app.fnCheckLastDprYYMM(UniDate.get('today'));
			}
			else if(activeGridId == 'aiss500ukrvDetailGrid6')	{
				if(record.get('PAT_YN') == 'Y'){
					alert(Msg.fSbMsgA0333);	// 이미 분할처리된 자산이므로, 자산 내역의 변경이 불가합니다.
					return false;
				}
				
				if(record.get('ASST_DIVI') == '2'){
					alert(Msg.fSbMsgA0323);	// 부외자산은 등록할 수 없습니다.
					return false;
				}
				
				var seq = directDetailStore6.max('SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
				var count = 0;
				
				if(seq < 10){			// 100 자리 넘으면 짜르게 수정필요
					count = '0' + seq;
				}else{
					count = seq;
				}
				
				var r = {
					COMP_CODE : UserInfo.compCode,
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DIVI: '8',
					ALTER_DATE: UniDate.get('today'),
					ALTER_YYMM: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6),
					
					PAT_ASST : record.get('ASST') + '-' + count,
					PAT_YN : 'N',
					SAVE_FLAG: 'N'
				}
				
				detailGrid6.createRow(r, 'ALTER_DATE');
				//신규행의 분할금액 계산(마스터 금액- 이전행에 입력한 금액Sum)
				var patAcqAmtSum		= 0;
				var patCapiTotAmtSum	= 0;
				var patSaleTotAmtSum	= 0;
				var patSaleDprTotAmtSum = 0;
				var patRevalTotAmtSum	= 0;
				var patDprTotAmtSum		= 0;
				var patDmgLosTotAmtSum	= 0;
				var patBalnAmtSum		= 0;
				var patFlAcqAmtSum		= 0;
				var records = directDetailStore6.data.items;
				
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_ACQ_AMT_I')){
						patAcqAmtSum = patAcqAmtSum + record6.data.PAT_ACQ_AMT_I;
					}
					if(record6.get('PAT_FI_CAPI_TOT_I')){
						patCapiTotAmtSum = patCapiTotAmtSum + record6.data.PAT_FI_CAPI_TOT_I;
					}
					if(record6.get('PAT_FI_SALE_TOT_I')){
						patSaleTotAmtSum = patSaleTotAmtSum + record6.data.PAT_FI_SALE_TOT_I;
					}
					if(record6.get('PAT_FI_SALE_DPR_TOT_I')){
						patSaleDprTotAmtSum = patSaleDprTotAmtSum + record6.data.PAT_FI_SALE_DPR_TOT_I;
					}
					if(record6.get('PAT_FI_REVAL_TOT_I')){
						patRevalTotAmtSum = patRevalTotAmtSum + record6.data.PAT_FI_REVAL_TOT_I;
					}
					if(record6.get('PAT_FI_DPR_TOT_I')){
						patDprTotAmtSum = patDprTotAmtSum + record6.data.PAT_FI_DPR_TOT_I;
					}
					if(record6.get('PAT_FI_DMGLOS_TOT_I')){
						patDmgLosTotAmtSum = patDmgLosTotAmtSum + record6.data.PAT_FI_DMGLOS_TOT_I;
					}
					if(record6.get('PAT_FL_BALN_I')){
						patBalnAmtSum = patBalnAmtSum + record6.data.PAT_FL_BALN_I;
					}
					if(record6.get('PAT_FL_ACQ_AMT_I')){
						patFlAcqAmtSum = patFlAcqAmtSum + record6.data.PAT_FL_ACQ_AMT_I;
					}
				});
				
				detailGrid6.getSelectedRecord().set('PAT_ACQ_AMT_I'			, record.get('ACQ_AMT_I')			- patAcqAmtSum);		//분할취득가액
				detailGrid6.getSelectedRecord().set('PAT_FI_CAPI_TOT_I'		, record.get('FI_CAPI_TOT_I')		- patCapiTotAmtSum);	//분할자본적지출액
				detailGrid6.getSelectedRecord().set('PAT_FI_SALE_TOT_I'		, record.get('FI_SALE_TOT_I')		- patSaleTotAmtSum);	//분할매각폐기금액
				detailGrid6.getSelectedRecord().set('PAT_FI_SALE_DPR_TOT_I' , record.get('FI_SALE_DPR_TOT_I')	- patSaleDprTotAmtSum);	//분할매각폐기상각감소액
				detailGrid6.getSelectedRecord().set('PAT_FI_REVAL_TOT_I'	, record.get('FI_REVAL_TOT_I')		- patRevalTotAmtSum);	//분할재평가액
				detailGrid6.getSelectedRecord().set('PAT_FI_DPR_TOT_I'		, record.get('FI_DPR_TOT_I')		- patDprTotAmtSum);		//분할상각누계액
				detailGrid6.getSelectedRecord().set('PAT_FI_DMGLOS_TOT_I'	, record.get('FI_DMGLOS_TOT_I')		- patDmgLosTotAmtSum);	//분할손상차손누계액
				detailGrid6.getSelectedRecord().set('PAT_FL_BALN_I'			, record.get('FL_BALN_I')			- patBalnAmtSum);		//분할미상각잔액
				detailGrid6.getSelectedRecord().set('PAT_FL_ACQ_AMT_I'		, record.get('FL_ACQ_AMT_I')		- patFlAcqAmtSum);		//분할전기취득가액
				
				//자산의 최종상각월과 변동월 비교 
				UniAppManager.app.fnCheckLastDprYYMM(UniDate.get('today'));
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			if(activeGridId == 'aiss500ukrvDetailGrid1')	{
				detailGrid1.reset();
				directDetailStore1.clearData();
			}else if(activeGridId == 'aiss500ukrvDetailGrid2')	{
				detailGrid2.reset();
				directDetailStore2.clearData();
			}else if(activeGridId == 'aiss500ukrvDetailGrid3')	{
				detailGrid3.reset();
				directDetailStore3.clearData();
			}else if(activeGridId == 'aiss500ukrvDetailGrid4')	{
				detailGrid4.reset();
				directDetailStore4.clearData();
			}else if(activeGridId == 'aiss500ukrvDetailGrid5')	{
				detailGrid5.reset();
				directDetailStore5.clearData();
			}else if(activeGridId == 'aiss500ukrvDetailGrid6')	{
				detailGrid6.reset();
				directDetailStore6.clearData();
			}
			
			this.fnInitBinding();
			
			UniAppManager.setToolbarButtons(['save'],false);
			UniAppManager.setToolbarButtons(['delete'],false);
		},
		onSaveDataButtonDown: function () {
			var inValidRecs;
			var activeGrid;
			var activeStore;
			
			if(activeGridId == 'aiss500ukrvDetailGrid1' )	{
				inValidRecs = directDetailStore1.getInvalidRecords();
				activeGrid = detailGrid1;
				activeStore = directDetailStore1;
			}else if(activeGridId == 'aiss500ukrvDetailGrid2'){
				inValidRecs = directDetailStore2.getInvalidRecords();
				activeGrid = detailGrid2;
				activeStore = directDetailStore2;
			}else if(activeGridId == 'aiss500ukrvDetailGrid3'){
				inValidRecs = directDetailStore3.getInvalidRecords();
				activeGrid = detailGrid3;
				activeStore = directDetailStore3;
			}else if(activeGridId == 'aiss500ukrvDetailGrid4'){
				inValidRecs = directDetailStore4.getInvalidRecords();
				activeGrid = detailGrid4;
				activeStore = directDetailStore4;
			}else if(activeGridId == 'aiss500ukrvDetailGrid5'){
				inValidRecs = directDetailStore5.getInvalidRecords();
				activeGrid = detailGrid5;
				activeStore = directDetailStore5;
			}else if(activeGridId == 'aiss500ukrvDetailGrid6'){
				inValidRecs = directDetailStore6.getInvalidRecords();
				activeGrid = detailGrid6;
				activeStore = directDetailStore6;
			}
			
			if(inValidRecs.length != 0)	{
				activeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				return false;
			}else{
				activeStore.saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			if(activeGridId == 'aiss500ukrvDetailGrid1')	{
				var selRow = detailGrid1.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid1.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid1.deleteSelectedRow();
					}
				}
			}else if(activeGridId == 'aiss500ukrvDetailGrid2'){
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid2.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid2.deleteSelectedRow();
					}
				}
			}else if(activeGridId == 'aiss500ukrvDetailGrid3'){
				var selRow = detailGrid3.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid3.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid3.deleteSelectedRow();
					}
				}
			}else if(activeGridId == 'aiss500ukrvDetailGrid4'){
				var selRow = detailGrid4.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid4.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid4.deleteSelectedRow();
					}
				}
			}else if(activeGridId == 'aiss500ukrvDetailGrid5'){
				var selRow = detailGrid5.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid5.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid5.deleteSelectedRow();
					}
				}
			}else if(activeGridId == 'aiss500ukrvDetailGrid6'){
				var selRow = detailGrid6.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid6.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid6.deleteSelectedRow();
					}
				}
			}
		},
		
		/**
		* 동일월 체크 -- 자산의 변동내역은 월에 한 번만 등록이 가능합니다.
		*/
		fnCheckSameMonth : function(applyRecord, newValue, data){
			var alterDate = '';
			var alterYYMM = '';
			var count = 0;
			alterDate = newValue;
			alterYYMM = UniDate.getDbDateStr(alterDate).substring(0, 6);
			
			var records = '';
			
			if(data == 'detailGrid2'){
				records = directDetailStore2.data.items;
			}else if(data == 'detailGrid3'){
				records = directDetailStore3.data.items;
			}else if(data == 'detailGrid4'){
				records = directDetailStore4.data.items;
			}else if(data == 'detailGrid5'){
				records = directDetailStore4.data.items;
			}
			Ext.each(records, function(record6,i){
				if(record6.get('ALTER_YYMM') == alterYYMM ){
					count = count + 1;
				}
			});
			
			if(count > 1){
				if(data == 'detailGrid2'){
					retunValue = '2back';
				}else if(data == 'detailGrid3'){
					retunValue = '3back';
				}else if(data == 'detailGrid4'){
					retunValue = '4back';
				}else if(data == 'detailGrid5'){
					retunValue = '5back';
				}
			}else{
				retunValue = '';
			}
		},
		
		/**
		* 자산의 최종상각월과 변동월 비교
		*/
		fnCheckLastDprYYMM : function(newValue){
			var lastDprYYMM = '';
			var reqDprYYMM  = '';
			var temp = '';
			
			lastDprYYMM = UniDate.getDbDateStr(masterGrid.getSelectedRecords()[0].data.DPR_YYMM);
			reqDprYYMM  = UniDate.getDbDateStr(newValue);
			
			temp = reqDprYYMM.substring(0,4) + '/' + reqDprYYMM.substring(4,6) + '/' + reqDprYYMM.substring(6,8);
			var transDate = new Date(temp);
			reqDprYYMM = UniDate.add(transDate, {months: -1});
			
			lastDprYYMM = lastDprYYMM.replace(".","");
			reqDprYYMM  = UniDate.getDbDateStr(reqDprYYMM);
			reqDprYYMM  = reqDprYYMM.substring(0,6);
			
			var textlastDprYYMM = lastDprYYMM.substring(0,4)+ '.' +lastDprYYMM.substring(4,6);
			var textreqDprYYMM  = reqDprYYMM.substring(0,4)+ '.' +reqDprYYMM.substring(4,6);
			
			if(lastDprYYMM < reqDprYYMM){
				alert('자산의 최종상각월은  ' + textlastDprYYMM + '  월입니다.	' + textreqDprYYMM + '  월까지 감가상각계산을 실행한 후, 자료를 재조회하여 자산변동내역을 등록하십시오. 그대로 진행하시면 자산정보 및 상각금액에 차이가 발생할 수 있습니다.');
				//alert(Msg.fSbMsgA0362)
				// 자산의 최종상각월은 '&1'월입니다. '&2'월까지 감가상각계산을 실행한 후, 자료를 재조회하여 자산변동내역을 등록하십시오. 그대로 진행하시면 자산정보 및 상각금액에 차이가 발생할 수 있습니다.
			}
		},
		
		/**
		* 발생금액/처분액 자동계산
		*/
		fnCalAlterAmt : function(applyRecord, newValue, data){
			var exchgRateO	 = 0;
			var forAlterAmtI = 0;
			var alterAmtI	 = 0;
			
			if(data == 'exchgRateO'){
				exchgRateO = newValue;
			}else{
				exchgRateO = applyRecord.get('EXCHG_RATE_O');
			}
			if(data == 'forAlterAmtI'){
				forAlterAmtI = newValue;
			}else{
				forAlterAmtI = applyRecord.get('FOR_ALTER_AMT_I');
			}
			
			alterAmtI = Math.floor(exchgRateO * forAlterAmtI, gsAmtPoint);
			applyRecord.set('ALTER_AMT_I'	, Math.floor(alterAmtI));	
		},
		
		/**
		* 세액 자동계산
		*/
		fnCalTaxAmt : function(applyRecord, newValue, data){
			var supplyAmtI	= 0;
			var dTaxRate	= 0;
			
			var proofKind	= '';
			if(data == 'supply'){
				supplyAmtI = newValue;
			}else{
				supplyAmtI = applyRecord.get('SUPPLY_AMT_I');
			}
			if(data == 'proofKind'){
				proofKind = newValue;
			}else{
				proofKind = applyRecord.get('PROOF_KIND');
			}
			
			if(proofKind == ''){
				applyRecord.set('TAX_AMT_I'	, Math.floor((supplyAmtI / 10) , gsAmtPoint ));
			}
			else{
				var param = {"PROOF_KIND": proofKind}
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						dTaxRate = provider.TAX_RATE;
	/*					dTaxRate = dTaxRate / 100;
						
						dTax_Amt_I = UniAccnt.fnAmtWonCalc((supplyAmtI * dTaxRate), gsAmtPoint);
						
						*/
						
						dTaxRate = supplyAmtI * (dTaxRate / 100);
						dTax_Amt_I = UniAccnt.fnAmtWonCalc(dTaxRate, gsAmtPoint);
						applyRecord.set('TAX_AMT_I'	, Math.floor(dTax_Amt_I));
					}
				});
			}
		},
		
		/**
		* 결제유형이 변경됨에 따라 설정변경
		*/
		fnChangedSetType : function(applyRecord, newValue){
			var setType = '';
			setType = newValue;
			
			if(activeGridId == 'aiss500ukrvDetailGrid2'){
				if(applyRecord.get('WASTE_DIVI') != '1'){	// '매각/폐기구분이 "매각"이 아니면 Skip.
					return false;
				}
			}
			
			//공급가액 = 발생금액
			applyRecord.set('SUPPLY_AMT_I', applyRecord.get('ALTER_AMT_I'));
			
			if(setType != ''){
				detailGrid1.getColumn('PROOF_KIND').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('SUPPLY_AMT_I').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('TAX_AMT_I').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('EB_YN').setConfig('tdCls','x-change-cell_Background_essRow');		//필수 관련 추후 수정필요
			}else{
				detailGrid1.getColumn('PROOF_KIND').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('SUPPLY_AMT_I').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('TAX_AMT_I').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
				detailGrid1.getColumn('EB_YN').setConfig('tdCls','x-change-cell_Background_optRow');		//필수 관련 추후 수정필요
			}
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') AS REF_CODE1",
				ADD_QUERY2: '',
				MAIN_CODE: 'A140',
				SUB_CODE: setType
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					var setTypeRef1 = provider.REF_CODE1;
					/**
					* 결제유형의 REF1에 따른 필수입력컬럼 변경
					*/
					if(activeGridId == 'aiss500ukrvDetailGrid1'){
						if(setTypeRef1 == '20'){
							detailGrid1.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NUM').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
						}else if(setTypeRef1 == '30'){
							detailGrid1.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NUM').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NAME').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
						}else{
							detailGrid1.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NUM').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('CREDIT_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
						}
					}
					else if(activeGridId == 'aiss500ukrvDetailGrid2'){
						if(setTypeRef1 == '20'){
							detailGrid1.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_essRow');	//필수 관련 추후 수정필요
						}
						else{
							detailGrid1.getColumn('SAVE_CODE').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
							detailGrid1.getColumn('SAVE_NAME').setConfig('tdCls','x-change-cell_Background_optRow');	//필수 관련 추후 수정필요
						}
					}
				}
			});
		},
		
		
		/**
		* 증빙유형에 따른 증빙자료(신용카드번호,현금영수증) 팝업
		*/
		fnProofPopUp : function(applyRecord, newValue){
			
			var reasonCode = applyRecord.get('REASON_CODE');
			var creditNum  = applyRecord.get('CREDIT_NUM');
			
			if(newValue == '54' || newValue == '61'){		// '매입세액불공제/고정자산매입(불공)
				
			}
			else if(newValue == '53' || newValue == '68'){	// '신용카드매입/신용카드매입(고정자산)
				
			}
			else if(newValue == '62' || newValue == '69'){	// '현금영수증매입/현금영수증(고정자산)
				
			}
		},
		
		/**
		* 매각/폐기구분 변경 시, 해당 Row의 데이터 초기화
		*/
		fnClearAlterInfo : function(applyRecord, newValue){
			
			if(newValue == '1'){
				return false;
			}else{
				applyRecord.set('MONEY_UNIT', '');
				applyRecord.set('EXCHG_RATE_O', '');
				applyRecord.set('FOR_ALTER_AMT_I', '');
				applyRecord.set('ALTER_AMT_I', '');
				applyRecord.set('SET_TYPE', '');
				applyRecord.set('PROOF_KIND', '');
				applyRecord.set('SUPPLY_AMT_I', '');
				applyRecord.set('TAX_AMT_I', '');
				applyRecord.set('CUSTOM_CODE', '');
				applyRecord.set('CUSTOM_NAME', '');
				applyRecord.set('SAVE_CODE', '');
				applyRecord.set('SAVE_NAME', '');
				applyRecord.set('PAY_SCD_DATE', '');
				applyRecord.set('EB_YN', '');
				applyRecord.set('ALTER_PROFIT', '');
			}
		},
		
		/**
		* 자산정보의 금액과 비교
		*/
		fnCompareOrgAmt : function(applyRecord, newValue, data, oldValue){
			
			var patCol = 0;
			var orgAmt = 0;
			var patAmt = 0;

			var patAcqAmtSum		= 0;
			var patCapiTotAmtSum	= 0;
			var patSaleTotAmtSum	= 0;
			var patSaleDprTotAmtSum = 0;
			var patRevalTotAmtSum	= 0;
			var patDprTotAmtSum		= 0;
			var patDmgLosTotAmtSum	= 0;
			var patBalnAmtSum		= 0;
			var patFlAcqAmtSum		= 0;
			var records = directDetailStore6.data.items;
			
			if(data == 'patAcqAmtI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.ACQ_AMT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_ACQ_AMT_I')){
						patAcqAmtSum = patAcqAmtSum + record6.data.PAT_ACQ_AMT_I;
						
					}
				});
				patCol = newValue + patAcqAmtSum - oldValue;
			}
			else if(data == 'patFiCapiTotI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_CAPI_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_CAPI_TOT_I')){
						patCapiTotAmtSum = patCapiTotAmtSum + record6.data.PAT_FI_CAPI_TOT_I;
					}
				});
				patCol = newValue + patCapiTotAmtSum - oldValue;
			}
			else if(data == 'patFiSaleTotI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_SALE_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_SALE_TOT_I')){
						patSaleTotAmtSum = patSaleTotAmtSum + record6.data.PAT_FI_SALE_TOT_I;
					}
				});
				patCol = newValue + patSaleTotAmtSum - oldValue;
			}
			else if(data == 'patFiSaleDprTotI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_SALE_DPR_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_SALE_DPR_TOT_I')){
						patSaleDprTotAmtSum = patSaleDprTotAmtSum + record6.data.PAT_FI_SALE_DPR_TOT_I;
					}
				});
				patCol = newValue + patSaleDprTotAmtSum - oldValue;
			}
			else if(data == 'patFiRevalTotI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_REVAL_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_REVAL_TOT_I')){
						patRevalTotAmtSum = patRevalTotAmtSum + record6.data.PAT_FI_REVAL_TOT_I;
					}
				});
				patCol = newValue + patRevalTotAmtSum - oldValue;
			}
			else if(data == 'patFiDprTotI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_DPR_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_DPR_TOT_I')){
						patDprTotAmtSum = patDprTotAmtSum + record6.data.PAT_FI_DPR_TOT_I;
					}
				});
				patCol = newValue + patDprTotAmtSum - oldValue;
			}
			else if(data == 'patFiDmglosToti'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FI_DMGLOS_TOT_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FI_DMGLOS_TOT_I')){
						patDmgLosTotAmtSum = patDmgLosTotAmtSum + record6.data.PAT_FI_DMGLOS_TOT_I;
					}
				});
				patCol = newValue + patDmgLosTotAmtSum - oldValue;
			}
			else if(data == 'patFlBalnI'){
				orgAmt = masterGrid.getSelectedRecords()[0].data.FL_BALN_I;
				Ext.each(records, function(record6,i){
					if(record6.get('PAT_FL_BALN_I')){
						patBalnAmtSum = patBalnAmtSum + record6.data.PAT_FL_BALN_I;
					}
				});
				patCol = newValue + patBalnAmtSum - oldValue;
			}
			patAmt = patCol;
			
			if(patAmt > orgAmt){
				retrunValue = 'return';
			} else {
				retrunValue = '';
			}
		},
		
		/**
		* 각종 분할금액 자동계산
		*/
		fnCalPatAmt : function(applyRecord, newValue, data){
			var orgAcqAmt  = 0;
			var patAcqAmt  = 0;
			var patPercent = 0;
			
			orgAcqAmt = masterGrid.getSelectedRecords()[0].data.ACQ_AMT_I;
			if(data == 'patAcqAmtI'){
				patAcqAmt = newValue;
			}else{
				patAcqAmt = applyRecord.get('SUPPLY_AMT_I');
			}
			if(orgAcqAmt == 0){
				patPercent = 0;
			}else{
				applyRecord.set('PAT_FI_CAPI_TOT_I'		, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_CAPI_TOT_I		* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FI_SALE_TOT_I'		, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_SALE_TOT_I		* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FI_SALE_DPR_TOT_I'	, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_SALE_DPR_TOT_I	* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FI_REVAL_TOT_I'	, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_REVAL_TOT_I		* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FI_DPR_TOT_I'		, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_DPR_TOT_I		* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FI_DMGLOS_TOT_I'	, Math.floor(masterGrid.getSelectedRecords()[0].data.FI_DMGLOS_TOT_I	* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FL_BALN_I'			, Math.floor(masterGrid.getSelectedRecords()[0].data.FL_BALN_I			* patAcqAmt / orgAcqAmt , gsAmtPoint));
				applyRecord.set('PAT_FL_ACQ_AMT_I'		, Math.floor(masterGrid.getSelectedRecords()[0].data.FL_ACQ_AMT_I		* patAcqAmt / orgAcqAmt , gsAmtPoint));
			}
		},
		
		/**
		* 분할실행/분할취소 버튼 활성화 설정
		*/
		fnSetActivityPatButton : function(){
			if(detailGrid6.getStore().getCount() == 0){
				detailGrid6.down('#start').setDisabled(true);
				detailGrid6.down('#cancel').setDisabled(true);
			}else{
				if(masterGrid.getSelectedRecords()[0].data.PAT_YN == 'Y'){
					detailGrid6.down('#start').setDisabled(true);
					detailGrid6.down('#cancel').setDisabled(false);
				}else{
					detailGrid6.down('#start').setDisabled(false);
					detailGrid6.down('#cancel').setDisabled(true);
				}
			}
		},
		
		/**
		* 회계기간 내에서 발생여부 체크
		*/
		fnCheckAcDateRange: function(newValue, grid){
			alterDate = newValue;
			frDate  = getStDt[0].STDT;
			toDate  = getStDt[0].TODT;
			
			if (!Ext.isEmpty(alterDate) && (alterDate >= frDate || alterDate <= toDate)) {
				if(grid == detailGrid1){
					alert (Msg.sMA0290 +'[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);		// 발생일은 회사정보에 등록된 회계기간에 속해야
				}
				else if(grid == detailGrid2){
					alert (Msg.fSbMsgA0324 +'[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);	// 처분일은 회사정보에 등록된 회계기간에 속해야
				}
				else if(grid == detailGrid3 || grid == detailGrid4){
					alert (Msg.fSbMsgA0325 +'[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);	// 변경일은 회사정보에 등록된 회계기간에 속해야
				}
				else if(grid == detailGrid5){
					alert (Msg.sMA0448 +'[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);		// 이동일은 회사정보에 등록된 회계기간에 속해야
				}
				else if(grid == detailGrid6){
					alert (Msg.fSbMsgA0326 +'[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);	// 분할일은 회사정보에 등록된 회계기간에 속해야
				}
				fnCheckAcDateRange = false;
			} else {
				fnCheckAcDateRange = true;
			}
			
			return fnCheckAcDateRange;
		}
	});

	Unilite.createValidator('validator01', {
		store: directDetailStore1,
		grid: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "FOR_ALTER_AMT_I" :
					// 발생금액/처분액 자동계산
					UniAppManager.app.fnCalAlterAmt(record, newValue, 'forAlterAmtI');
					break;
				
				case "EXCHG_RATE_O" :
					// 발생금액/처분액 자동계산
					UniAppManager.app.fnCalAlterAmt(record, newValue, 'exchgRateO');
					break;
				
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;
					}else{	
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid1');
					break;
					
				case "SET_TYPE":
					UniAppManager.app.fnChangedSetType(record, newValue);
					break;
					
				case "SUPPLY_AMT_I" :
					// 세액 자동 계산
					UniAppManager.app.fnCalTaxAmt(record, newValue, 'supply');
					break;
					
				case "PROOF_KIND" :
					UniAppManager.app.fnProofPopUp(record, newValue);
					// 세액 자동 계산
					UniAppManager.app.fnCalTaxAmt(record, newValue, 'proofKind');
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: directDetailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "WASTE_DIVI" :
					//자산구분 체크(부외자산은 추가 불가)
					if(newValue == '2' && masterGrid.getSelectedRecords()[0].data.ASST_DIVI == '2'){
						alert(Msg.fSbMsgA0323);	//부외자산은 등록할 수 없습니다.
						return false;
					}	
					//UniAppManager.app.fnClearAlterInfo(record, newValue); // 매각/폐기구분 변경 시, 해당 Row의 데이터 초기화
					break;
				
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0291 + '</br>' + stDate + ' ~ ' + toDate;
					}else{
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					
					// 동일한 월에 자산변동내역 있는지 체크
					UniAppManager.app.fnCheckSameMonth(record, newValue, 'detailGrid2');
					if(retunValue == '2back'){
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv= Msg.fSbMsgA0327;
						//break;
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid2');
					break;
					
				case "ALTER_Q" :
					if(masterGrid.getSelectedRecords()[0].data.STOCK_Q < newValue){
						alert(Msg.fSbMsgA0328); // 처분수량은 재고수량을 초과할 수 없습니다.
						return false;
					}
					
				case "FOR_ALTER_AMT_I" :
					// 발생금액/처분액 자동계산
					UniAppManager.app.fnCalAlterAmt(record, newValue, 'forAlterAmtI');
					break;
				
				case "EXCHG_RATE_O" :
					// 발생금액/처분액 자동계산
					UniAppManager.app.fnCalAlterAmt(record, newValue, 'exchgRateO');
					break;
					
				case "SET_TYPE":
					//결제유형가 변경됨에 따라 설정변경
					UniAppManager.app.fnChangedSetType(record, newValue);
					break;
				
				case "PROOF_KIND" :
					if(record.get('WASTE_DIVI') == '1'){
					// 세액 자동 계산
						UniAppManager.app.fnCalTaxAmt(record, newValue, 'proofKind');
					}
					break;
					
				case "SUPPLY_AMT_I" :
					// 세액 자동 계산
					UniAppManager.app.fnCalTaxAmt(record, newValue, 'supply');	
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator03', {
		store: directDetailStore3,
		grid: detailGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;
					}else{
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					// 동일한 월에 자산변동내역 있는지 체크
					UniAppManager.app.fnCheckSameMonth(record, newValue, 'detailGrid3');
					if(retunValue == '3back'){
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv= Msg.fSbMsgA0327;
						break;
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid3');
					
					// 자산의 최종상각월과 변동월 비교
					UniAppManager.app.fnCheckLastDprYYMM(newValue);
					break;
					
				case "BF_DRB_YEAR" :
				case "AF_DRB_YEAR" :
				if(isNaN(newValue)){
					rv = Msg.sMB074;	//숫자만 입력가능합니다.
					break;
				}
				if(newValue < 0 && !Ext.isEmpty(newValue))	{
					rv=Msg.sMB076;	//양수만 입력 가능합니다.
					break;
				}
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator04', {
		store: directDetailStore4,
		grid: detailGrid4,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;
					}else{
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					// 동일한 월에 자산변동내역 있는지 체크
					UniAppManager.app.fnCheckSameMonth(record, newValue, 'detailGrid4');
					if(retunValue == '4back'){
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv= Msg.fSbMsgA0327;
						break;
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid4');
					
					// 자산의 최종상각월과 변동월 비교
					UniAppManager.app.fnCheckLastDprYYMM(newValue);
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator05', {
		store: directDetailStore5,
		grid: detailGrid5,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;
					}else{
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					// 동일한 월에 자산변동내역 있는지 체크
					UniAppManager.app.fnCheckSameMonth(record, newValue, 'detailGrid5');
					if(retunValue == '5back'){
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv= Msg.fSbMsgA0327;
						break;
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid5');
					
					// 자산의 최종상각월과 변동월 비교
					UniAppManager.app.fnCheckLastDprYYMM(newValue);
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator06', {
		store: directDetailStore6,
		grid: detailGrid6,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						record.set('ALTER_YYMM', UniDate.getDbDateStr(oldValue).substring(0, 6));
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;
					}else{
						record.set('ALTER_YYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					
					// 회계기간 내에서 발생여부 체크
					UniAppManager.app.fnCheckAcDateRange(newValue, 'detailGrid6');
					
					// 자산의 최종상각월과 변동월 비교
					UniAppManager.app.fnCheckLastDprYYMM(newValue);	
					break;
					
				
				case "PAT_ACQ_AMT_I" :
					// '자산정보의 금액과 비교
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patAcqAmtI', oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					// '각종 금액 자동계산
					UniAppManager.app.fnCalPatAmt(record, newValue, 'patAcqAmtI');
					break;
					
				case "PAT_FI_CAPI_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiCapiTotI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FI_SALE_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiSaleTotI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FI_SALE_DPR_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiSaleDprTotI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FI_REVAL_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiRevalTotI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FI_DPR_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiDprTotI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FI_DMGLOS_TOT_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFiDmglosToti' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
				case "PAT_FL_BALN_I" :
					UniAppManager.app.fnCompareOrgAmt(record, newValue , 'patFlBalnI' , oldValue);
					if(retrunValue == 'return'){
						rv= Msg.fSbMsgA0329;
						break;
					}
					break;
			}
			return rv;
		}
	});
};
</script>
