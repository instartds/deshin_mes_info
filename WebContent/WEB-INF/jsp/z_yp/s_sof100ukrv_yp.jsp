<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof100ukrv_yp"  >
<t:ExtComboStore comboType="AU" comboCode="T019"/>  <!-- 국내외		-->
<t:ExtComboStore comboType="AU" comboCode="B004"/>  <!-- 화폐단위		-->
<t:ExtComboStore comboType="AU" comboCode="S002"/>  <!-- 수주구분		-->
<t:ExtComboStore comboType="AU" comboCode="S007"/>  <!-- 출고유형		-->
<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 판매단위		-->
<t:ExtComboStore comboType="AU" comboCode="B059"/>  <!-- 과세여부		-->
<t:ExtComboStore comboType="AU" comboCode="S014"/>  <!-- 계산서대상  -->
<t:ExtComboStore comboType="AU" comboCode="S003"/>  <!-- 단가구분		-->
<t:ExtComboStore comboType="AU" comboCode="S011"/>  <!-- 수주상태		-->
<t:ExtComboStore comboType="AU" comboCode="S010"/>  <!-- 담당자		-->
<t:ExtComboStore comboType="AU" comboCode="B038"/>  <!-- 결제방법		-->
<t:ExtComboStore comboType="AU" comboCode="S024"/>  <!-- 부가세유형  -->
<t:ExtComboStore comboType="AU" comboCode="S046"/>  <!-- 승인상태		-->
<t:ExtComboStore comboType="AU" comboCode="B030"/>  <!-- 세액포함여부	 -->
<t:ExtComboStore comboType="AU" comboCode="B116"/>  <!-- 단가계산기준	 -->
<t:ExtComboStore comboType="AU" comboCode="S065"/>  <!-- 주문구분		-->
<t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
<t:ExtComboStore comboType="AU" comboCode="B010"/>  <!-- 예/아니오  -->

<t:ExtComboStore comboType="AU" comboCode="T005"/>  <!--가격조건-->
<t:ExtComboStore comboType="AU" comboCode="T006"/>  <!--결제조건-->
<t:ExtComboStore comboType="AU" comboCode="T016"/>  <!-- 대금결제방법  -->
<t:ExtComboStore comboType="AU" comboCode="T004"/>
<t:ExtComboStore comboType="AU" comboCode="T010"/>
<t:ExtComboStore comboType="AU" comboCode="T011"/>
<t:ExtComboStore comboType="AU" comboCode="T008"/>
<t:ExtComboStore comboType="AU" comboCode="Z011"/>	<!-- 20210913:jhj 농공산구분  -->
<t:ExtComboStore comboType="BOR120" pgmId="s_sof100ukrv_yp"/><!-- 사업장	-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">
var SearchInfoWindow;			//SearchInfoWindow : 검색창
var referEstimateWindow;		//견적참조
var referOrderRecordWindow;		//수주이력참조
var excelWindow;				// 엑셀참조
var contextMenu;
var isLoad = false;				//로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var gsSaveRefFlag	= 'N';		//검색후에만 수정 가능하게 조회버튼 활성화..
var tempIndex		= 0;		//미등록상품 확인용..
var outDivCode		= UserInfo.divCode;

//controller에서 값을 받아서옴 model.Attribut()
var BsaCodeInfo = {
	gsBalanceOut	: '${gsBalanceOut}',
	gsCreditYn		: '${gsCreditYn}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: ${gsVatRate},
	gsProdtDtAutoYN	: '${gsProdtDtAutoYN}',
	gsSaleAutoYN	: '${gsSaleAutoYN}',
	gsSof100ukrLink	: '${gsSof100ukrLink}',
	gsSrq100UkrLink	: '${gsSrq100UkrLink}',
	gsStr100UkrLink	: '${gsStr100UkrLink}',
	gsSsa100UkrLink	: '${gsSsa100UkrLink}',
	gsProcessFlag	: '${gsProcessFlag}',
	gsCondShowFlag	: '${gsCondShowFlag}',
	gsDraftFlag		: '${gsDraftFlag}',
	gsApp1AmtInfo	: ${gsApp1AmtInfo},
	gsApp2AmtInfo	: ${gsApp2AmtInfo},
	gsTimeYN		: '${gsTimeYN}',
	gsScmUseYN		: '${gsScmUseYN}',
	gsPjtCodeYN		: '${gsPjtCodeYN}',
	gsPointYn		: '${gsPointYn}',
	gsUnitChack		: '${gsUnitChack}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsOrderTypeSaleYN: '${gsOrderTypeSaleYN}'
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: '',
	gsRefTaxInout	: ''
};

//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	/**
	 * 자동채번 여부
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	/**
	 * 수주승인 방식
	 */
	var isDraftFlag = true;
	if(BsaCodeInfo.gsDraftFlag=='1')	{
		isDraftFlag = false;
	}





	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof100ukrv_ypService.selectDetailList',
			update	: 's_sof100ukrv_ypService.updateDetail',
			create	: 's_sof100ukrv_ypService.insertDetail',
			destroy	: 's_sof100ukrv_ypService.deleteDetail',
			syncAll	: 's_sof100ukrv_ypService.saveAll'
		}
	});





	/**
	 * 수주의 디테일 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('s_sof100ukrv_ypDetailModel', {
		fields: [
			{name: 'DIV_CODE'				, text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'				, type: 'string', allowBlank: false, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'ORDER_NUM'				, text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'				, type: 'string', allowBlank: isAutoOrderNum /*, isPk:true, pkGen:'user'*/},
			{name: 'SER_NO'					, text:'<t:message code="unilite.msg.sMSR003" default="순번"/>'				, type: 'int', allowBlank: false , editable:false},
			{name: 'OUT_DIV_CODE'			, text:'<t:message code="unilite.msg.sMSR291" default="출고사업장"/>'			, type: 'string', allowBlank: false , comboType: 'BOR120'},
			{name: 'SO_KIND'				, text:'<t:message code="unilite.msg.fSbMsgS0070" default="주문구분"/>'			, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S065', defaultValue: '10'},
			{name: 'ITEM_CODE'				, text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="unilite.msg.sMS688" default="품명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'<t:message code="unilite.msg.sMS763" default="품목계정"/>'				, type: 'string'},
			{name: 'SPEC'					, text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'				, type: 'string', editable:false},
			{name: 'ORDER_UNIT'				, text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>'				, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="unilite.msg.sMS767" default="단가구분"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun, comboType:'AU', comboCode:'B116'},
			{name: 'TRANS_RATE'				, text:'<t:message code="unilite.msg.sMSR010" default="입수"/>'				, type: 'uniQty', allowBlank: false, defaultValue: 1},
			{name: 'ORDER_Q'				, text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'				, type: 'uniQty', allowBlank: false, defaultValue: 0},
			{name: 'ORDER_P'				, text:'단가'																	, type: 'uniUnitPrice', allowBlank: false, defaultValue: 0},
			{name: 'ORDER_WGT_Q'			, text:'수주량(중량)'															, type: 'int', defaultValue: 0},
			{name: 'ORDER_WGT_P'			, text:'단가(중량)'																, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_Q'			, text:'수주량(부피)'															, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_P'			, text:'단가(부피)'																, type: 'int', defaultValue: 0},
			{name: 'ORDER_O'				, text:'<t:message code="unilite.msg.sMS681" default="금액"/>'				, type: 'uniPrice', allowBlank: false , defaultValue: 0},
			{name: 'TAX_TYPE'				, text:'<t:message code="unilite.msg.sMSR289" default="과세구분"/>'				, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B059'},
			{name: 'ORDER_TAX_O'			, text:'<t:message code="unilite.msg.sMS764" default="부가세액"/>'				, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O'			, text:'<t:message code="unilite.msg.sMS765" default="수주합계"/>'				, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'WGT_UNIT'				, text:'<t:message code="unilite.msg.sMR202" default="중량단위"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="unilite.msg.sMR201" default="단위중량"/>'				, type: 'int', defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'부피단위'																, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'단위부피'																, type: 'int', defaultValue: 0},
			{name: 'DVRY_DATE'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'				, type: 'uniDate', allowBlank: false},
			{name: 'DVRY_TIME'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/> <t:message code="unilite.msg.fSbMsgS0056" default="시간"/>'  , type:'uniTime' , format:'His'},
			{name: 'DISCOUNT_RATE'			, text:'<t:message code="unilite.msg.sMS716" default="할인율(%)"/>'			, type: 'uniPercent'},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="unilite.msg.sMSR049" default="매출대상"/>'				, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S014',  defaultValue: 'Y'},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="unilite.msg.sMS665" default="매출처"/><t:message code="unilite.msg.sMS603" default="코드"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="unilite.msg.sMS665" default="매출처"/>'				, type: 'string', allowBlank: false},
			{name: 'PRICE_YN'				, text:'<t:message code="unilite.msg.sMS767" default="단가구분"/>'				, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S003', defaultValue:'2'},
			{name: 'STOCK_Q'				, text:'<t:message code="unilite.msg.sMS768" default="재고수량"/>'				, type: 'uniQty', editable:false},
			{name: 'PROD_SALE_Q'			, text:'생산요청량'																, type: 'uniQty'},
			{name: 'PROD_Q'					, text:'<t:message code="unilite.msg.sMS769" default="생산요청량(재고단위)"/>'		, type: 'uniQty'},
			{name: 'PROD_END_DATE'			, text:'<t:message code="unilite.msg.sMS770" default="생산완료일"/>'				, type: 'uniDate'},
			{name: 'DVRY_CUST_CD'			, text:'<t:message code="unilite.msg.sMSR293" default="배송처"/><t:message code="unilite.msg.sMS603" default="코드"/>'			  , type: 'string'},
			{name: 'DVRY_CUST_NAME'			, text:'<t:message code="unilite.msg.sMSR293" default="배송처"/>'				, type: 'string'},
			{name: 'ORDER_STATUS'			, text:'<t:message code="unilite.msg.sMS771" default="강제마감"/>'				, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S011', defaultValue: 'N'},
			{name: 'PO_NUM'					, text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'				, type: 'string'},
			{name: 'PO_SEQ'					, text:'<t:message code="unilite.msg.sMS772" default="P/O 순번"/>'			, type: 'int'},
			{name: 'PROJECT_NO'				, text:'<t:message code="unilite.msg.sMR049" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'ISSUE_REQ_Q'			, text:'<t:message code="unilite.msg.sMS683" default="출하지시량"/>'				, type: 'uniQty' , defaultValue: 0},
			{name: 'OUTSTOCK_Q'				, text:'OUTSTOCK_Q'															, type: 'int', defaultValue: 0},
			{name: 'RETURN_Q'				, text:'RETURN_Q'															, type: 'int', defaultValue: 0},
			{name: 'SALE_Q'					, text:'SALE_Q'																, type: 'int', defaultValue: 0},
			{name: 'PROD_PLAN_Q'			, text:'PROD_PLAN_Q'														, type: 'int'},
			{name: 'ORDER_UNIT_Q'			, text:'ORDER_UNIT_Q'														, type: 'uniQty', allowBlank: false},
			{name: 'ESTI_NUM'				, text:'<t:message code="unilite.msg.sMS538" default="견적번호"/>'				, type: 'string', editable:false},
			{name: 'ESTI_SEQ'				, text:'<t:message code="unilite.msg.sMS773" default="견적순번"/>'				, type: 'int', editable:false},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'															, type: 'string'},
			{name: 'PRE_ACCNT_YN'			, text:'PRE_ACCNT_YN'														, type: 'string', defaultValue: 'Y'},
			{name: 'REF_ORDER_DATE'			, text:'REF_ORDER_DATE'														, type: 'string'},
			{name: 'REF_ORD_CUST'			, text:'REF_ORD_CUST'														, type: 'string'},
			{name: 'REF_ORDER_TYPE'			, text:'REF_ORDER_TYPE'														, type: 'string'},
			{name: 'REF_PROJECT_NO'			, text:'REF_PROJECT_NO'														, type: 'string'},
			{name: 'REF_TAX_INOUT'			, text:'REF_TAX_INOUT'														, type: 'string', defaultValue: '1'},
			{name: 'REF_MONEY_UNIT'			, text:'REF_MONEY_UNIT'														, type: 'string', defaultValue: BsaCodeInfo.gsMoneyUnit},
			{name: 'REF_EXCHG_RATE_O'		, text:'REF_EXCHG_RATE_O'													, type: 'int', defaultValue: 1},
			{name: 'REF_REMARK'				, text:'REF_REMARK'															, type: 'string'},
			{name: 'REF_BILL_TYPE'			, text:'REF_BILL_TYPE'														, type: 'string'},
			{name: 'REF_RECEIPT_SET_METH'	, text:'REF_RECEIPT_SET_METH'												, type: 'string'},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'															, type: 'int'},
			{name: 'REF_STOCK_CARE_YN'		, text:'REF_STOCK_CARE_YN'													, type: 'string'},
			{name: 'REF_WH_CODE'			, text:'REF_WH_CODE'														, type: 'string'},
			{name: 'REF_FLAG'				, text:'REF_FLAG'															, type: 'string', defaultValue: 'F'},
			{name: 'REF_ORDER_PRSN'			, text:'REF_ORDER_PRSN'														, type: 'string'},
			{name: 'REF_DVRY_CUST_NM'		, text:'REF_DVRY_CUST_NM'													, type: 'string'},
			{name: 'REQ_ISSUE_QTY'			, text:'REQ_ISSUE_QTY'														, type: 'int', defaultValue: '0'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'															, type: 'string', allowBlank: false , defaultValue: UserInfo.compCode},
			{name: 'REMARK'					, text:'<t:message code="unilite.msg.sMS742" default="비고"/>'				, type: 'string'},
			{name: 'STOCK_Q_TY'				, text:'STOCK_Q_TY'															, type: 'string'},
			{name: 'SCM_FLAG_YN'			, text:'SCM_FLAG_YN'														, type: 'string', defaultValue:'N'},
			{name: 'BARCODE'				, text:'바코드'																, type: 'string'},
			{name: 'DISCOUNT_MONEY'			, text:'할인가'																, type: 'uniPrice'},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'															, type: 'string'},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'															, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'														, type: 'string'},
			{name: 'OUT_WH_CODE'			, text:'출고창고'																, type: 'string'},
			{name: 'CUSTOM_ITEM_CODE'		, text:'주문상품코드'															, type: 'string'},
			{name: 'CUSTOM_ITEM_NAME'		, text:'주문상품명'																, type: 'string'},
			{name: 'PREV_ORDER_Q'			, text:'이전수주량'																, type: 'uniQty'},
			{name: 'EXP_ISSUE_DATE'			, text:'출하예정일'																, type: 'uniDate'},
//			202109 jhj:컬럼추가
			{name: 'GOODS_DIVISION'			, text:'농공산구분'																, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI'				, text:'원산지'																, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.common.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'FARM_CODE'				, text: '농가코드'																, type: 'string'},
			{name: 'CUSTOM_ITEM_DESC'		, text:'주문상품 설명'															, type: 'string'}
//			{name: 'OEM_ITEM_CODE'			, text:''																	, type: 'string'}
//			{name: 'TAX_TYPE'				, text:'TAX_TYPE'															, type: 'string'}
		]
	});






	//수주정보스토어
	var detailStore = Unilite.createStore('s_sof100ukrv_ypDetailStore', {
		model	: 's_sof100ukrv_ypDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: directProxy,
		listeners	: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum2();
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				console.log("modifiedFieldNames :",modifiedFieldNames)
				console.log("record :",record)
//				validation.validate( 'grid', modifiedFieldNames[0], record.get( modifiedFieldNames[0]), record.data[modifiedFieldNames[0]], record);
//				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum2();
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success) {
						panelSearch.setLoadRecord(records[0]);
					}
				}
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelSearch.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster	= panelSearch.getValues();	//syncAll 수정
			var paramTrade	= panelTrade.getValues();
			var params		= Ext.merge(paramMaster , paramTrade);
			var inValidRecs	= this.getInvalidRecords();

			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);

						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sof100ukrv_ypGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnOrderAmtSum: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder= Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sumTax	= Ext.isNumeric(this.sum('ORDER_TAX_O')) ? this.sum('ORDER_TAX_O'):0;
			var sumTot	= sumOrder+sumTax;
			panelSearch.setValue('ORDER_O'		,sumOrder);
			panelSearch.setValue('ORDER_TAX_O'	,sumTax);
			panelSearch.setValue('TOT_ORDER_AMT',sumTot);
			panelResult.setValue('ORDER_O'		,sumOrder);
			panelResult.setValue('ORDER_TAX_O'	,sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);
			panelSearch.fnCreditCheck();
		},
		fnOrderAmtSum2: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder= Ext.isNumeric(this.sum('ORDER_O'))		? this.sum('ORDER_O')		: 0;
			var sumTax	= Ext.isNumeric(this.sum('ORDER_TAX_O'))	? this.sum('ORDER_TAX_O')	: 0;
			var sumTot	= sumOrder+sumTax;
			panelSearch.setValue('ORDER_O'		,sumOrder);
			panelSearch.setValue('ORDER_TAX_O'	,sumTax);
			panelSearch.setValue('TOT_ORDER_AMT',sumTot);
			panelResult.setValue('ORDER_O'		,sumOrder);
			panelResult.setValue('ORDER_TAX_O'	,sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);
		}
	});






	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var panelSearch = Unilite.createSearchPanel('s_sof100ukrv_ypMasterForm', {
		title		: '<t:message code="unilite.msg.sMS178" default="수주정보"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			},
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty() || (basicForm.getField('PROJECT_NO').isDirty()) || (basicForm.getField('DVRY_DATE').isDirty()) ){
//					UniAppManager.setToolbarButtons('save', true);
				} else if(detailStore.getCount() != 0 && panelSearch.isDirty()) {
//					UniAppManager.setToolbarButtons('save', true);
				}
			}
		 },
		items	: [{
			title		: '기본정보',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS533" default="수주번호"/>',
				name		: 'ORDER_NUM',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '수주일자',
				name		: 'ORDER_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				allowBlank	: false,
				holdable		: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode = panelSearch.getValue('DIV_CODE');
							var CustomCode = panelSearch.getValue('CUSTOM_CODE');
							var orderDate = UniDate.getDbDateStr(newValue);
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						panelResult.setValue('DVRY_DATE', newValue);
						panelSearch.setValue('DVRY_DATE', newValue);
						panelResult.setValue('ORDER_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				id			: 'ORDER_TYPE_ID',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				id				: 'CUSTOM_ID',
				allowBlank		: false,
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
							CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
							CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
							CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];		//세액포함여부

							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
								panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
								panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							}

							if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
								//여신액 구하기
								var divCode		= panelSearch.getValue('DIV_CODE');
								var CustomCode	= panelSearch.getValue('CUSTOM_CODE');
								var orderDate	= panelSearch.getField('ORDER_DATE').getSubmitValue()
								var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
								//마스터폼에 여신액 set
								UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
							}

							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));

							panelSearch.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
							panelSearch.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
							panelResult.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
							panelResult.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCrYn		= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsRefTaxInout	= '';
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');

						panelSearch.setValue('SALE_CUST_CD', '');
						panelSearch.setValue('SALE_CUST_NM', '');
						panelResult.setValue('SALE_CUST_CD', '');
						panelResult.setValue('SALE_CUST_NM', '');
					}
				}
			}),{
				fieldLabel	: '납기일',
				name		: 'DVRY_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DVRY_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS717" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS986" default="세액포함여부"/>',
				name		: 'TAX_INOUT',
				id			: 'taxInout',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B030',
				allowBlank	: false,
				holdable	: 'hold',
				width		: 235,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('TAX_INOUT').setValue(newValue.TAX_INOUT);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS742" default="비고"/>',
				xtype		: 'uniTextfield',
				name		: 'REMARK',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			},{
				fieldLabel	: '국내외구분',
				name		: 'NATION_INOUT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T109',
				value		: '1',
				allowBlank	: false,
				holdable	: 'hold',
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('NATION_INOUT', newValue);
						if(panelSearch.getValue('NATION_INOUT') == '2') {	//국외일시만 무역폼 활성화
							//무역폼 readOnly: false
							panelSearch.getField('OFFER_NO').setReadOnly(false);
							panelResult.getField('OFFER_NO').setReadOnly(false);
							panelSearch.setValue('BILL_TYPE', '60');
							panelResult.setValue('BILL_TYPE', '60');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(false);
							});
							panelTrade.setConfig('collapsed', false);
						} else {
							//무역폼 readOnly: true
							panelSearch.getField('OFFER_NO').setReadOnly(true);
							panelResult.getField('OFFER_NO').setReadOnly(true);
							panelSearch.setValue('BILL_TYPE', '10');
							panelResult.setValue('BILL_TYPE', '10');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(true);
							});
							panelTrade.setConfig('collapsed', true);
						}
					}
				}
			},{
				fieldLabel	: '화폐',
				name		: 'MONEY_UNIT',
				comboType	: 'AU',
				comboCode	: 'B004',
				value		: BsaCodeInfo.gsMoneyUnit,
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				displayField: 'value',
				allowBlank	: false,
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
						if(isLoad){
							isLoad = false;
						}else{
							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			},{
				fieldLabel	: 'OFFER번호',
				name		: 'OFFER_NO',
				holdable	: 'hold',
				readOnly	: true,
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OFFER_NO', newValue);
					}
				}
			},{
				fieldLabel	: '환율',
				name		: 'EXCHANGE_RATE',
				xtype		: 'uniNumberfield',
				holdable	: 'hold',
				value		: 1,
				allowBlank	: false,
				hidden		: true,
				decimalPrecision: 4,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHANGE_RATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMB189" default="결제방법"/>',
				name		: 'RECEIPT_SET_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B038',
				holdable	: 'hold',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_SET_METH', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS573" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				holdable	: 'hold',
				allowBlank	: false,
//				hidden		: true,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				margin	: '0 0 0 95',
				xtype	: 'button',
				text	: '구매요청정보반영',
				itemId	: 'purchaseRequest1',
				holdable: 'hold',
				hidden	: true,
				handler	: function() {
					if(!Ext.isEmpty(panelSearch.getValue('ORDER_NUM') && panelSearch.getValue('ORDER_REQ_YN') == "N")){
						var param = {
							CompCode	: UserInfo.compCode,
							OrderNum	: panelSearch.getValue('ORDER_NUM'),
							DivCode		: panelSearch.getValue('DIV_CODE')
						}
						var me = this;
						s_sof100ukrv_ypService.insertPurchaseRequest(param, function(provider, response) {
							if(provider){
								UniAppManager.updateStatus("구매요청 정보가 반영되었습니다.");
								me.setDisabled(true);
							}

						});
					}
				}
			},{
				xtype	: 'container',
				padding : '0 0 3 95',
				layout	: {type:'uniTable', tdAttrs: {align: 'right'}},
				items	: [{
					xtype	: 'button',
					text	: 'SMS 발송',
					handler	: function()  {
						this.openPopup();
					},
					//공통팝업(SMS 전송팝업 호출)
					app			: 'Unilite.app.popup.SendSMS',
					api			: 'popupService.sendSMS',
					openPopup	: function() {
						var me		= this;
						var param	= {};

						param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
						param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
						param['TYPE']			= 'TEXT';
						param['pageTitle']		= me.pageTitle;

						if(me.app) {
							var fn = function() {
								var oWin =  Ext.WindowMgr.get(me.app);
								if(!oWin) {
									oWin = Ext.create( me.app, {
										id				: me.app,
										callBackFn		: me.processResult,
										callBackScope	: me,
										popupType		: 'TEXT',
										width			: 750,
										height			: 450,
										title			: 'SMS 전송',
										param			: param
									});
								}
								oWin.fnInitBinding(param);
								oWin.center();
								oWin.show();
							}
						}
					Unilite.require(me.app, fn, this, true);
					}
				}]
			}]
		},{
			title		: '기타정보',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('PROJECT',{
					fieldLabel		: '프로젝트번호',
					textFieldName	: 'PROJECT_NO',
					itemId			: 'project',
					holdable		: 'hold',
					validateBlank	: true,
					hidden			: true,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PROJECT_NO', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
						},
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_NO', newValue);
						}
					}
			}), {
				fieldLable	: 'gsAutoType',
				name		: 'gsAutoType',
				hidden		: true,
				value		: BsaCodeInfo.gsAutoType
			},{
				fieldLable	: 'gsDraftFlag',
				name		: 'gsDraftFlag',
				hidden		: true,
				value		: BsaCodeInfo.gsDraftFlag
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="unilite.msg.sMS665" default="매출처"/>',
				valueFieldName	: 'SALE_CUST_CD',
				textFieldName	: 'SALE_CUST_NM',
				holdable		: 'hold',
				listeners		: {
					onSelected		: {
						fn: function(records, type) {
							panelResult.setValue('SALE_CUST_CD', panelSearch.getValue('SALE_CUST_CD'));
							panelResult.setValue('SALE_CUST_NM', panelSearch.getValue('SALE_CUST_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('SALE_CUST_CD', '');
						panelResult.setValue('SALE_CUST_NM', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="unilite.msg.sMS176" default="수주금액"/>',
				name		: 'ORDER_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS764" default="부가세액"/>',
				name		: 'ORDER_TAX_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '수주총액',
				name		: 'TOT_ORDER_AMT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				xtype: 'container',
				items:[{
					fieldLabel	: '<t:message code="unilite.msg.sMS628" default="여신잔액"/>',
					name		: 'REMAIN_CREDIT',
					xtype		: 'uniNumberfield',
					value		: 0,
					readOnly	: true,
					hidden		: true
				}]
			},{
				fieldLabel	: '구매요청 반영여부',
				name		: 'ORDER_REQ_YN',
				xtype		: 'uniTextfield',
				hidden		: true
			}]
		},{
			title		: '승인정보',
			itemId		: 'DraftFields',
			layout		: {type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0007" default="1차승인자"/>',
					textFieldName	: 'APP_1_NM',
					valueFieldName	: 'APP_1_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'1차승인한도액',
				margin	: '0 0 0 10',
				width	: 150,
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp1AmtInfo, UniFormat.Price)+'원 이하</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0008" default="1차 승인일"/>',
				name		: 'APP_1_DATE',
				hidden		: true
			},{
				fieldLabel	: '1차 승인여부',
				name		: 'AGREE_1_YN',
				hidden		: true
			},
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0009" default="2차승인자"/>',
					textFieldName	: 'APP_2_NM',
					valueFieldName	: 'APP_2_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'2차승인한도액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+'원 이하</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0010" default="2차승인일"/>',
				name		: 'APP_2_DATE',
				hidden		: true
			},{
				fieldLabel	: '2차 승인여부',
				name		: 'AGREE_2_YN',
				hidden		: true
			},
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0011" default="3차승인자"/>',
					textFieldName	: 'APP_3_NM',
					valueFieldName	: 'APP_3_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'3차승인초과액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+'원 초과</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0012" default="3차승인일"/>',
				name		: 'APP_3_DATE',
				hidden		: true
			},{
				fieldLabel	: '3차 승인여부',
				name		: 'AGREE_3_YN',
				hidden		: true
			},{
				fieldLabel	: '상태',
				name		: 'STATUS',
				id			: 'status',
				xtype		: 'uniRadiogroup',
				//comboType: 'AU',
				//comboCode: 'S046',
				allowBlank	: false,
				value		: '1',
				colspan		: 2,
				width		: 330,
				layout		: {type: 'table', columns:3, tableAttrs:{width:'100%'}},
				items		: [{
						boxLabel	: '기안',
						name		: 'STATUS',
						inputValue	: '1',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '반려',
						name		: 'STATUS',
						inputValue	: '5',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '완결',
						name		: 'STATUS',
						inputValue	: '6',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '1차승인',
						name		: 'STATUS',
						inputValue	: '2',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '2차승인',
						name		: 'STATUS',
						inputValue	: '3',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '3차승인',
						name		: 'STATUS',
						inputValue	: '4',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					}
				]
			},{
				fieldLabel	: '반려사유',
				name		: 'RETURN_MSG',
				xtype		: 'textarea',
				height		: 50,
				readOnly	: true,
				colspan		: 2
			}]
		}],
		api: {
			load	: 's_sof100ukrv_ypService.selectMaster',
			submit	: 's_sof100ukrv_ypService.syncForm'
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},

		fnCreditCheck: function() {
			if(CustomCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
//		  me.setAllFieldsReadOnly(true);
		}

	}); //End of var panelSearch = Unilite.createForm('s_sof100ukrv_ypMasterForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4/*,
				tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			holdable	: 'hold',
			tdAttrs		: {width: 280},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS533" default="수주번호"/>',
			name		: 'ORDER_NUM',
			readOnly	: isAutoOrderNum,
			holdable	: isAutoOrderNum ? 'readOnly':'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '수주일자',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
						//여신액 구하기
						var divCode = panelSearch.getValue('DIV_CODE');
						var CustomCode = panelSearch.getValue('CUSTOM_CODE');
						var orderDate = UniDate.getDbDateStr(newValue);
						var moneyUnit = BsaCodeInfo.gsMoneyUnit;
						//마스터폼에 여신액 set
						UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
					}
					panelSearch.setValue('DVRY_DATE', newValue);
					panelResult.setValue('DVRY_DATE', newValue);
					panelSearch.setValue('ORDER_DATE', newValue);
				}
			}
		},{
			xtype	: 'container',
			padding : '0 0 3 95',
			layout	: {type:'uniTable', tdAttrs: {align: 'right'}},
			items	: [{
				xtype	: 'button',
				text	: 'SMS 발송',
				handler	: function()  {
					this.openPopup();
				},
				//공통팝업(SMS 전송팝업 호출)
				app			: 'Unilite.app.popup.SendSMS',
				api			: 'popupService.sendSMS',
				openPopup	: function() {
					var me		= this;
					var param	= {};

					param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
					param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
					param['TYPE']			= 'TEXT';
					param['pageTitle']		= me.pageTitle;

					if(me.app) {
						var fn = function() {
							var oWin =  Ext.WindowMgr.get(me.app);
							if(!oWin) {
								oWin = Ext.create( me.app, {
									id				: me.app,
									callBackFn		: me.processResult,
									callBackScope	: me,
									popupType		: 'TEXT',
									width			: 750,
									height			: 450,
									title			: 'SMS 전송',
									param			: param
								});
							}
							oWin.fnInitBinding(param);
							oWin.center();
							oWin.show();
						}
					}
				Unilite.require(me.app, fn, this, true);
				}
			}]
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			id			: 'ORDER_TYPE_ID2',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			allowBlank	: false,
			holdable	: 'hold',
			tdAttrs		: {width: 280},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '국내외구분',
			name		: 'NATION_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T109',
			value		: '1',
			allowBlank	: false,
			holdable	: 'hold',
			hidden		: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('NATION_INOUT', newValue);
					if(panelSearch.getValue('NATION_INOUT') == '2') {
						//무역폼 readOnly: false
						panelSearch.getField('OFFER_NO').setReadOnly(false);
						panelResult.getField('OFFER_NO').setReadOnly(false);
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(false);
						});
						panelSearch.setValue('ORDER_TYPE', '40');//직수출
						panelSearch.setValue('BILL_TYPE', '60');//직수출
						panelResult.setValue('ORDER_TYPE', '40');//직수출
						panelResult.setValue('BILL_TYPE', '60');//직수출

						panelTrade.setConfig('collapsed', false);
					} else {
						//무역폼 readOnly: true
						panelSearch.getField('OFFER_NO').setReadOnly(true);
						panelResult.getField('OFFER_NO').setReadOnly(true);
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(true);
						});
						panelSearch.setValue('ORDER_TYPE', '10');//직수출
						panelSearch.setValue('BILL_TYPE', '10');//직수출
						panelResult.setValue('ORDER_TYPE', '10');//직수출
						panelResult.setValue('BILL_TYPE', '10');//직수출
						panelTrade.setConfig('collapsed', true);
					}
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		:'<t:message code="unilite.msg.sMSR213" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			id				: 'CUSTOM_ID2',
			allowBlank		: false,
			holdable		: 'hold',
			colspan			: 2,
			tdAttrs			: {width: 370},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];	 //세액포함여부

						if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
							panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
						}

						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= panelSearch.getValue('DIV_CODE');
							var CustomCode	= panelResult.getValue('CUSTOM_CODE');
							var orderDate	= panelSearch.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}

						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));

						panelSearch.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
						panelSearch.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
						panelResult.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
						panelResult.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCrYn		= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsRefTaxInout	= '';

					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');

					panelSearch.setValue('SALE_CUST_CD', '');
					panelSearch.setValue('SALE_CUST_NM', '');
					panelResult.setValue('SALE_CUST_CD', '');
					panelResult.setValue('SALE_CUST_NM', '');
				},
					applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="unilite.msg.sMB189" default="결제방법"/>',
			name		: 'RECEIPT_SET_METH',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B038',
			holdable	: 'hold',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_SET_METH', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS176" default="수주금액"/>',
			name		: 'ORDER_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: 'OFFER번호',
			name		: 'OFFER_NO',
			holdable	: 'hold',
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OFFER_NO', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS717" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS986" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('TAX_INOUT').setValue(newValue.TAX_INOUT);
				}
			}
		},{
			fieldLabel	: '납기일',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			holdable	: 'hold',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DVRY_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS764" default="부가세액"/>',
			name		: 'ORDER_TAX_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS573" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			holdable	: 'hold',
//			hidden		: true,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="unilite.msg.sMS665" default="매출처"/>',
			valueFieldName	: 'SALE_CUST_CD',
			textFieldName	: 'SALE_CUST_NM',
			holdable		: 'hold',
			colspan			: 2,
			listeners		: {
				onSelected		: {
					fn: function(records, type) {
						panelSearch.setValue('SALE_CUST_CD', panelResult.getValue('SALE_CUST_CD'));
						panelSearch.setValue('SALE_CUST_NM', panelResult.getValue('SALE_CUST_NM'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('SALE_CUST_CD', '');
					panelSearch.setValue('SALE_CUST_NM', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel	: '수주총액',
			name		: 'TOT_ORDER_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true

		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS742" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			layout		: {type : 'uniTable', columns : 3},
			width		: 605,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REMARK', newValue);
				}
			}
		},{
			fieldLabel	: '화폐',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: BsaCodeInfo.gsMoneyUnit,
			allowBlank	: false,
			holdable	: 'hold',
			displayField: 'value',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
//					if(isLoad){
//						isLoad = false;
//					}else{
//						UniAppManager.app.fnExchngRateO();
//					}
				}
			}
		},{
			fieldLabel	: '환율',
			name		: 'EXCHANGE_RATE',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			value		: 1,
			allowBlank	: false,
			hidden		: true,
			decimalPrecision: 4,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EXCHANGE_RATE', newValue);
				}
			}
		},{
			xtype	: 'container',
			hidden	: true,
			items	: [{
				fieldLabel	: '<t:message code="unilite.msg.sMS628" default="여신잔액"/>',
				name		: 'REMAIN_CREDIT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			}]
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '프로젝트번호',
			itemId			: 'project',
			textFieldName	: 'PROJECT_NO',
			holdable		: 'hold',
			validateBlank	: true,
			textFieldWidth	: 150,
			colspan			: 2,
			hidden			: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PROJECT_NO', panelResult.getValue('PROJECT_NO'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PROJECT_NO', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_NO', newValue);
				}
			}
		}),{
			margin	: '0 0 0 95',
			xtype	: 'button',
			text	: '구매요청정보반영',
			itemId	: 'purchaseRequest2',
			holdable: 'hold',
			hidden	: true,
			handler	: function() {
				if(!Ext.isEmpty(panelSearch.getValue('ORDER_NUM') && panelSearch.getValue('ORDER_REQ_YN') == "N")){
					var param = {
						CompCode: UserInfo.compCode,
						OrderNum: panelSearch.getValue('ORDER_NUM'),
						DivCode: panelSearch.getValue('DIV_CODE')
					}
					var me = this;
					s_sof100ukrv_ypService.insertPurchaseRequest(param, function(provider, response) {
						if(provider){
							UniAppManager.updateStatus("구매요청 정보가 반영되었습니다.");
							me.setDisabled(true);
						}

					});
				}
			}
		}/*,{
			xtype	: 'component',
			width	: 10
		},{
			xtype	: 'container',
			padding : '0 0 3 95',
			layout	: {type:'uniTable', tdAttrs: {align: 'right'}},
			items	: [{
				xtype	: 'button',
				text	: 'SMS 발송',
				handler	: function()  {
					this.openPopup();
				},
				//공통팝업(SMS 전송팝업 호출)
				app			: 'Unilite.app.popup.SendSMS',
				api			: 'popupService.sendSMS',
				openPopup	: function() {
					var me		= this;
					var param	= {};

					param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
					param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
					param['TYPE']			= 'TEXT';
					param['pageTitle']		= me.pageTitle;

					if(me.app) {
						var fn = function() {
							var oWin =  Ext.WindowMgr.get(me.app);
							if(!oWin) {
								oWin = Ext.create( me.app, {
									id				: me.app,
									callBackFn		: me.processResult,
									callBackScope	: me,
									popupType		: 'TEXT',
									width			: 750,
									height			: 450,
									title			: 'SMS 전송',
									param			: param
								});
							}
							oWin.fnInitBinding(param);
							oWin.center();
							oWin.show();
						}
					}
				Unilite.require(me.app, fn, this, true);
				}
			}]
		}*/],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length == 0) {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}

						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}

					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	//무역 master정보 폼
	var panelTrade = Unilite.createSearchForm('tradeForm',{
		region		: 'south',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		collapsible	: true,
		extensible	: true,
		height		: 10,
		flex		: 0.4,
		autoScroll	: true,
		defaults	: {holdable: 'hold'},
		items		: [{
			xtype	: 'container',
			layout	: {type:'uniTable', column:2},
			defaults: {holdable: 'hold'},
			items	: [{
					name		: 'PAY_TERMS',
					fieldLabel	: '결제조건',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'T006',
					allowBlank	: false
				},{
					xtype		: 'uniNumberfield',
					name		: 'PAY_DURING',
					suffixTpl	: 'Days',
					width		: 80
				}
			]
		},{
			name		: 'PAY_METHODE1',
			fieldLabel	: '대금결제방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T016',
			allowBlank	: false
		},{
			name		: 'TERMS_PRICE',
			fieldLabel	: '가격조건',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T005',
			allowBlank	: false
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '대행자',
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
			name		: 'DATE_DEPART',
			fieldLabel	: '작성일',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false
		},{
			name		: 'DATE_EXP',
			fieldLabel	: '유효일',
			xtype		: 'uniDatefield',
			value		: new Date()
		},{
			name		: 'METH_CARRY',
			fieldLabel	: '운송방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T004'
		},{
			name		: 'COND_PACKING',
			fieldLabel	: '포장방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T010'
		},{
			name		: 'METH_INSPECT',
			fieldLabel	: '검사방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T011'
		},{
			name		: 'SHIP_PORT',
			fieldLabel	: '선적항',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},{
			name		: 'DEST_PORT',
			fieldLabel	: '도착항',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},
		Unilite.popup('BANK',{
			fieldLabel		: '송금은행',
			valueFieldName	: 'BANK_CODE',
			textFieldName	: 'BANK_NAME'
		})],
		listeners: {
//			uniOnChange: function(basicForm, dirty, eOpts) {
//				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty()){
//					UniAppManager.setToolbarButtons('save', true);
//				}
//			}
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
				if(invalid.length == 0) {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}

						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}

					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		},
		api: {
			load	: 's_sof100ukrv_ypService.selectMaster',
			submit	: 's_sof100ukrv_ypService.syncForm'
		}
	});






	/**
	 * 수주정보 그리드 Context Menu
	 */

	//수주정보 그리드
	var detailGrid = Unilite.createGrid('s_sof100ukrv_ypGrid', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,	//20210913 jhj:true->false 수정
			useRowNumberer		: false,
//			useContextMenu		: true,
			onLoadSelectFirst	: true,
			copiedRow			: true
		},
		margin	: 0,
		tbar	: [{
			xtype	: 'button',
			itemId	: 'refTool',
			text	: '참조...',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [/*{
					itemId	: 'estimateBtn',
					text	: '견적참조',
					handler	: function() {
						openEstimateWindow();
					}
				}, */{
					itemId	: 'refBtn',
					text	: '수주이력참조',
					handler	: function() {
						openRefWindow();
					}
				}/*, {
					itemId	: 'scmBtn',
					text	: '업체발주참조(SCM)',
					handler	: function() {
						openScmWindow();
					}
				}*/, {
					itemId	: 'excelBtn',
					text	: '엑셀참조',
					handler	: function() {
						openExcelWindow();
					}
				}]
			})
		},{
			xtype	: 'button',
			itemId	: 'procTool',
			text	: '프로세스...',  iconCls: 'icon-link',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'reqIssueLinkBtn',
					text	: '출하지시등록(양평)',
					handler	: function() {
						var params = {
							'PGM_ID'	: 's_sof100ukrv_yp',
							'record'	: detailStore.data.items,
							'formPram'	: panelSearch.getValues(),
							'ORDER_NUM' : panelSearch.getValue('ORDER_NUM')
						}
						var rec = {data : {prgID : 's_srq100ukrv_yp', 'text':'출하지시등록'}};
						parent.openTab(rec, '/z_yp/s_srq100ukrv_yp.do', params);
					}
				},{
					itemId	: 'issueLinkBtn',
					text	: '출고등록(개별)(양평)',
					handler	: function() {
						if(detailStore.isDirty()){
							alert(Msg.sMS027);
							return false;
						}
						if(detailStore.getCount() != 0){
							var params = {
								action		: 'select',
								'PGM_ID'	: 's_sof100ukrv_yp',
								'record'	: detailStore.data.items,
								'formPram'	: panelSearch.getValues()
							}

							var rec = {data : {prgID : 's_str103ukrv_yp', 'text':''}};
							parent.openTab(rec, '/z_yp/s_str103ukrv_yp.do', params, CHOST+CPATH);
						}
					}
				}/*, {
					itemId: 'saleLinkBtn',
					text: '매출등록',
					handler: function() {
						var params = {
							ORDER_NO : panelSearch.getValue('ORDER_NO')
						}
						var rec = {data : {prgID : 'ssa100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa100ukrv.do', params);
					}
				}*/]
			})
		}],
		store	: detailStore,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
			{dataIndex: 'SER_NO',			width: 60		, locked: true},
			{dataIndex: 'OUT_DIV_CODE',		width: 120		, hidden: true},
			{dataIndex: 'SO_KIND',			width: 80		, hidden: true},
		/* 	{dataIndex: 'ITEM_CODE',		width: 130		, locked: true,
			 editor: Unilite.popup('DIV_PUMOK_G', {
				textFieldName	: 'ITEM_CODE',
				DBtextFieldName	: 'ITEM_CODE',
				autoPopup		: true,
				extParam		: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
				useBarcodeScanner: false,
				listeners		: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
								}
								param = {
									DIV_CODE		: record.DIV_CODE,
									ITEM_CODE		: record.ITEM_CODE,
									CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
								}
								s_sof100ukrv_ypService.getCustomItemCode(param, function(provider, response){
									if(!Ext.isEmpty(provider)) {
										grdRecord = detailGrid.getSelectedRecord();
										if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
												grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
											}
										}
										if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
											grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
										}
									}
								});
							});
						},
						scope: this
					},
					'onClear': function(type) {
						detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
					},
					applyextparam: function(popup){
						var record = detailGrid.getSelectedRecord();
						var divCode = record.get('OUT_DIV_CODE');
						popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						popup.setExtParam({'DIV_CODE': divCode});
//						popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
//						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						if(BsaCodeInfo.gsBalanceOut == 'Y') {
							popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
						}
					}
				}
			})},
			{dataIndex: 'ITEM_NAME',		width: 150, locked: true,
			 editor: Unilite.popup('DIV_PUMOK_G', {
				extParam	: {SELMODEL: 'MULTI'},
//				useBarcodeScanner: false,
				autoPopup	: true,
				listeners	: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
								}
								param = {
									DIV_CODE		: record.DIV_CODE,
									ITEM_CODE		: record.ITEM_CODE,
									CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
								}
								s_sof100ukrv_ypService.getCustomItemCode(param, function(provider, response){
									if(!Ext.isEmpty(provider)) {
										grdRecord = detailGrid.getSelectedRecord();
										if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
												grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
											}
										}
										if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
											grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
										}
									}
								});
							});
						},
						scope: this
					},
					'onClear': function(type) {
						detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
					},
					applyextparam: function(popup){
						var record = detailGrid.getSelectedRecord();
						var divCode = record.get('OUT_DIV_CODE');
						popup.setExtParam({'SELMODEL': 'MULTI'});
						popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
						popup.setExtParam({'DIV_CODE': divCode});
 //						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						if(BsaCodeInfo.gsBalanceOut == 'Y') {
							popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
						}
					}
				}
			})}, */
			/*****2019-05-20 양평 품목 팝업으로 변경*****/
			{dataIndex: 'ITEM_CODE'			, width: 100	, locked: true,
				 editor: Unilite.popup('DIV_PUMOK_YP_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					extParam		: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
									param = {
										DIV_CODE		: record.DIV_CODE,
										ITEM_CODE		: record.ITEM_CODE,
										CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
									}
									s_sof101ukrv_ypService.getCustomItemCode(param, function(provider, response){
										if(!Ext.isEmpty(provider)) {
											grdRecord = detailGrid.getSelectedRecord();
											if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
												if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
													grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
												}
											}
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
												grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
											}
										}
									});
								});
							},
							scope: this
						},
						'onClear': function(type) {
//							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'PGM_ID': 'S_SOF101UKRV'});
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'ORDER_DATE': UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))});

							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(A.B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추가 쿼리
							}
						}
					}
				})},
				{dataIndex: 'ITEM_NAME'			, width: 150	, locked: true,
				 editor: Unilite.popup('DIV_PUMOK_YP_G', {
					autoPopup	: true,
					extParam	: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
									param = {
										DIV_CODE		: record.DIV_CODE,
										ITEM_CODE		: record.ITEM_CODE,
										CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
									}
									s_sof101ukrv_ypService.getCustomItemCode(param, function(provider, response){
										if(!Ext.isEmpty(provider)) {
											grdRecord = detailGrid.getSelectedRecord();
											if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
												if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
													grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
												}
											}
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
												grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
											}
										}
									});
								});
							},
							scope: this
						},
						'onClear': function(type) {
//							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'PGM_ID': 'S_SOF101UKRV'});
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'ORDER_DATE': UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))});
							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(A.B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
							}
						}
					}
				})},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 150	, hidden: true},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
			}},
			{dataIndex: 'TRANS_RATE'		, width: 90 },
			{dataIndex: 'ORDER_Q'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'PREV_ORDER_Q'		, width: 100	, hidden: true},
			{dataIndex: 'ORDER_P'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DISCOUNT_MONEY'	, width: 70		, hidden: true},
			{dataIndex: 'ORDER_O'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'ORDER_WGT_Q'		, width: 110	, hidden: true},
			{dataIndex: 'ORDER_WGT_P'		, width: 100	, hidden: true},
			{dataIndex: 'ORDER_VOL_Q'		, width: 110	, hidden: true},
			{dataIndex: 'ORDER_VOL_P'		, width: 100	, hidden: true},

			{dataIndex: 'TAX_TYPE'			, width: 80},
			//202109 jhj:컬럼 추가
			{dataIndex: 'GOODS_DIVISION'	, width: 90},
			{dataIndex: 'ORDER_TAX_O'		, width: 110	, summaryType: 'sum'},
			{dataIndex: 'ORDER_O_TAX_O'		, width: 110	, summaryType: 'sum'},
			{dataIndex: 'WGT_UNIT'			, width: 80		, hidden: true},
			{dataIndex: 'UNIT_WGT'			, width: 90		, hidden: true},
			{dataIndex: 'VOL_UNIT'			, width: 80		, hidden: true},
			{dataIndex: 'UNIT_VOL'			, width: 90		, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 90},
			{dataIndex: 'DISCOUNT_RATE'		, width: 80		, hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'	, width: 100	, hidden: true	,
			 editor: Unilite.popup('DELIVERY_G',{
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('s_sof100ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
							grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
							//var grdRecord = Ext.getCmp('s_sof100ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD','');
							grdRecord.set('DVRY_CUST_NAME','');
					},
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
					}
				}
			})},
			{dataIndex: 'DVRY_TIME'			, width: 100	, hidden: true},
			{dataIndex: 'OUT_WH_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'		, width: 80		, hidden: true},
			{dataIndex: 'PRICE_YN'			, width: 80		, hidden: true},
			{dataIndex: 'STOCK_Q'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_SALE_Q'		, width: 100	, hidden: true},
			{dataIndex: 'PROD_Q'			, width: 140	, hidden: true},
			{dataIndex: 'PROD_END_DATE'		, width: 90},
			{dataIndex: 'DVRY_CUST_CD'		, width: 100	, hidden: true},

			{dataIndex: 'ORDER_STATUS'		, width: 80		, hidden: true},
			{dataIndex: 'PO_NUM'			, width: 110	, hidden: true},
			{dataIndex: 'PO_SEQ'			, width: 80		, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 130	, hidden: true},
			{dataIndex: 'ISSUE_REQ_Q'		, width: 90		, hidden: true},
			{dataIndex: 'ESTI_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_SEQ'			, width: 80		, hidden: true},
			{dataIndex: 'BARCODE'			, width: 120	, hidden: true},
			{dataIndex: 'REMARK'			, width: 300	, hidden: true},
			{dataIndex: 'NATION_INOUT'		, width: 80		, hidden: true },
			{dataIndex: 'MONEY_UNIT'		, width: 80		, hidden: true },
			{dataIndex: 'OFFER_NO'			, width: 80		, hidden: true },
			{dataIndex: 'EXP_ISSUE_DATE'	, width: 90},
			//202109 jhj:컬럼 추가
			{dataIndex: 'CUSTOM_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'FARM_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'WONSANGI'			, width: 110,
			//202109 jhj: 원사지 팝업 추가 (양평농협 전용)
				editor: Unilite.popup('WONSANGI_G',{
										listeners: {
											onSelected: {
												fn: function(records, type) {
													debugger;
													console.log(records);
													var grdRecord = detailGrid.uniOpt.currentRecord;
													grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);	//거래처코드
													grdRecord.set('FARM_CODE',records[0]['FARM_CODE']);		//농가코드
													grdRecord.set('WONSANGI',records[0]['WONSANGI']);		//원산지

												 }
											},applyextparam: function(popup){
												var grdRecord	= detailGrid.getSelectedRecord();
												var wonsangi	= grdRecord.get('WONSANGI');
												popup.setExtParam({'WONSANGI': wonsangi});			//detailGrid에 입력된 WONSANGI
											}
										}
								 })
			},
			{dataIndex: 'CUSTOM_ITEM_CODE'	, width: 80		, hidden: true },
			{dataIndex: 'CUSTOM_ITEM_NAME'	, width: 120},
			{dataIndex: 'CUSTOM_ITEM_DESC'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'		, width: 110	, hidden: false	,
				editor: Unilite.popup('AGENT_CUST_G',{
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								//var grdRecord = Ext.getCmp('s_sof100ukrv_ypGrid').uniOpt.currentRecord;
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('SALE_CUST_CD',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							//var grdRecord = Ext.getCmp('s_sof100ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'STOCK_UNIT'   , width: 120, hidden: true}
		],
		listeners: {
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;

				var seq = detailStore.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;
				record.SER_NO = seq;

				return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(BsaCodeInfo.gsDraftFlag == 'Y' && Ext.getCmp('status').getChecked()[0].inputValue != '1')  {
					return false;
				}else if(e.record.phantom ) {
					if(UniUtils.indexOf(e.field, ['TRANS_RATE'])){
                       /*  if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
                            return true;
                        }else{
                            return false;
                        } */
                        return true;
                    }
					if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
						if (UniUtils.indexOf(e.field,
											['ITEM_CODE','ITEM_NAME','ORDER_UNIT','TRANS_RATE','TAX_TYPE','ACCOUNT_YNC','STOCK_Q','ORDER_STATUS',
											 'ESTI_NUM','ESTI_SEQ','PROD_Q','ORDER_O_TAX_O','WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL']))
							return false;

					} else {
						//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
//					  if(e.field=='ORDER_UNIT') {
//						  var outDivCode = e.grid.getSelectedRecord().get('OUT_DIV_CODE');
//						  var combo = e.column.field;
//
//						  /* for test
//						  if(e.rowIdx == 5) {
//							  combo.store.clearFilter();
//							  combo.store.filter('refCode1', outDivCode);
//
//						  }else{
//							  combo.store.clearFilter();
//						  }*/

//						  combo.filterByRefCode('refCode1', outDivCode);
//						  return true;
//					  }
						if (UniUtils.indexOf(e.field,
											['SPEC','STOCK_Q','ORDER_STATUS','ESTI_NUM','PROD_Q',
											'ORDER_O_TAX_O', 'WGT_UNIT', 'UNIT_WGT', 'VOL_UNIT', 'UNIT_VOL']))
							return false;

						if(panelSearch.getValue('BILL_TYPE') == '50')	{
							if(e.field=='TAX_TYPE') return false;
						}
					}
					if(e.record.data.TAX_TYPE != '1')	{
						if(e.field=='ORDER_TAX_O') return false;
					}
					if(e.record.data.ITEM_ACCOUNT == '00')  {
						if(e.field=='PROD_SALE_Q') return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['TRANS_RATE'])){
                       /*  if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
                            return true;
                        }else{
                            return false;
                        } */
                        return true;
                    }
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME']))
						return false;
					if(e.record.data.SALE_Q == 0)	{

						if(e.record.data.ISSUE_REQ_Q > 0 || e.record.data.OUTSTOCK_Q > 0)	{
							switch(e.field) {
								case 'ORDER_P':
									if(e.record.data.PRICE_YN != '1') return false;
									break;
								case 'PRICE_YN':
									if(e.record.data.PRICE_YN != '1') return false;
									break;
								case 'ACCOUNT_YNC':
									if(!Ext.isEmpty(e.record.data.ESTI_NUM)) return false;
									break;
								default:
									return false
									break;
							}
						} else {
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q','ESTI_NUM','ESTI_SEQ','PROD_Q','ORDER_O_TAX_O']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {

						switch(e.field) {
							case 'ORDER_P':
								if(e.record.data.PRICE_YN != '1') return false;
								break;
							case 'PRICE_YN':
								if(e.record.data.PRICE_YN != '1') return false;
								break;
							case 'ACCOUNT_YNC':
								if(!Ext.isEmpty(e.record.data.ESTI_NUM)) return false;
								break;
							default:
								return false
								break;
						}
					}
				}
			}
		},
		//// 프로세스 버튼 활성(false)/비활성화(true)
//	  disabledLinkButtons: function(b) {
//			  this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
//			  this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
//			  this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
//	  },
		////품목정보 팝업에서 선택된 데이타 수주정보 그리드에 추가하는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0);
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
//				grdRecord.set('PROD_END_DATE'	,'');
//				grdRecord.set('OEM_ITEM_CODE'	,"");
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'		, record['WH_CODE']);

				if(panelSearch.getValue('BILL_TYPE') != "50"){
					grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
				}else{
					grdRecord.set('TAX_TYPE'		, "2");
				}
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				grdRecord.set('OUT_DIV_CODE'		,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
//				grdRecord.set('OEM_ITEM_CODE'		,record['OEM_ITEM_CODE']);
				grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));

				UniSales.fnGetItemInfo(
					  grdRecord
					, UniAppManager.app.cbGetItemInfo
					, 'I'
					, UserInfo.compCode
					, panelSearch.getValue('CUSTOM_CODE')
					, CustomCodeInfo.gsAgentType
					, record['ITEM_CODE']
					, panelSearch.getValue('MONEY_UNIT')
					, record['SALE_UNIT']
					, record['STOCK_UNIT']
					, record['TRANS_RATE']
					, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
					, grdRecord.get('ORDER_Q')
					, record['WGT_UNIT']
					, record['VOL_UNIT']
					, record['UNIT_WGT']
					, record['UNIT_VOL']
					, record['PRICE_TYPE']
					, UserInfo.divCode
					, null
					, ''
				);
			}
		},
		setEstiData:function(record) {
			var grdRecord = this.getSelectedRecord();

			//grdRecord.set('DIV_CODE'		  , record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'		  , record['ESTI_UNIT']);
			grdRecord.set('TRANS_RATE'		  , record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'			 , record['ESTI_QTY']);
			grdRecord.set('ORDER_P'			 , record['ESTI_PRICE']);
			grdRecord.set('SCM_FLAG_YN'		 , 'N');
			if(panelSearch.getValue('TAX_INOUT') != 50)
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE'] );
			}
			if(Ext.isEmpty(panelSearch.getValue('DVRY_DATE')))	{

				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'		 , record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);
			grdRecord.set('STOCK_UNIT'		  , record['STOCK_UNIT']);
			grdRecord.set('ACCOUNT_YNC'		 , 'Y');

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,panelSearch.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,panelSearch.getValue('SALE_CUST_CD'));
			}

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'	 ,panelSearch.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'	 ,panelSearch.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'		 , 0);
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);
			grdRecord.set('REF_ORDER_DATE'	  , panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'	  , panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'	  , panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'	  ,gsExchageRate);
			grdRecord.set('REF_REMARK'		  , panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', panelSearch.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetItemInfo(grdRecord, UniAppManager.app.cbGetItemInfo
				, 'R'
				, UserInfo.compCode
				, panelSearch.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['ESTI_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
				, grdRecord.get('ORDER_Q')
				, record['WGT_UNIT']
				, record['VOL_UNIT']
				, record['UNIT_WGT']
				, record['UNIT_VOL']
				, record['PRICE_TYPE']
				, UserInfo.divCode
				, null
				, ''
			);


			//수주수량/단가(중량) 재계산
			var sUnitWgt	= record['UNIT_WGT'];
			var sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (record['ESTI_QTY'] * sUnitWgt));

			if( sUnitWgt == 0)  {
				grdRecord.set('ORDER_WGT_P'	 ,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (record['ESTI_PRICE'] / sUnitWgt))
			}

			//수주수량/단가(부피) 재계산
			var sUnitVol	= record['UNIT_VOL'];
			var sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (record['ESTI_QTY'] * sUnitVol));

			if( sUnitVol == 0)  {
				grdRecord.set('ORDER_VOL_P'	 ,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (record['ESTI_PRICE'] / sUnitVol))
			}

		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'		  , record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'		  , record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'			 , record['ORDER_Q']);
			grdRecord.set('ORDER_P'			 , record['ORDER_P']);
			grdRecord.set('SCM_FLAG_YN'		 , 'N');

			if(panelSearch.getValue('TAX_INOUT') != 50)
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);
			}
			if(Ext.isEmpty(panelSearch.getValue('DVRY_DATE')))	{

				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'		 , record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('STOCK_UNIT'		  , record['STOCK_UNIT']);
			grdRecord.set('ACCOUNT_YNC'		 , record['ACCOUNT_YNC']);


			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,panelSearch.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,panelSearch.getValue('SALE_CUST_CD'));
			}

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'	 ,panelSearch.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'	 ,panelSearch.getValue('SALE_CUST_NM'));
			}

			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'	  , record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'		 , 0);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'	  , panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'	  , panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'	  , panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'	  ,gsExchageRate);
			grdRecord.set('REF_REMARK'		  , panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', panelSearch.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetItemInfo(grdRecord
				, UniAppManager.app.cbGetItemInfo
				, 'R'
				, UserInfo.compCode
				, panelSearch.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['ORDER_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
				, grdRecord.get('ORDER_Q')
				, grdRecord.get('WGT_UNIT')
				, grdRecord.get('VOL_UNIT')
				, grdRecord.get('UNIT_WGT')
				, grdRecord.get('UNIT_VOL')
				, grdRecord.get('PRICE_TYPE')
				, record['OUT_DIV_CODE']
				, null
				, ''
			);

			//UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			//UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE']);
		},
		setExcelData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'		  , record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'		  , record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'			 , record['QTY']);
			grdRecord.set('ORDER_P'			 , record['PRICE']);
			grdRecord.set('SCM_FLAG_YN'		 , 'N');
			grdRecord.set('TAX_TYPE'			, '1');
			grdRecord.set('REF_ORDER_TYPE'	  , panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'	  , panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_MONEY_UNIT'			  , record['']);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'	  ,gsExchageRate);
			grdRecord.set('REF_REMARK'			  , panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'				, record['QTY']);
			grdRecord.set('STOCK_UNIT'		  , record['STOCK_UNIT']);
			grdRecord.set('REF_WH_CODE'		 , record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			grdRecord.set('OUT_WH_CODE'		 , record['OUT_WH_CODE']);
			// grdRecord.set('ORDER_O' , record['QTY'] * record['PRICE']);
			grdRecord.set('ORDER_O'			 , record['ORDER_O']);
			grdRecord.set('ORDER_TAX_O'		 , record['ORDER_TAX_O']);
			grdRecord.set('ORDER_O_TAX_O'		, record['ORDER_O_TAX_O']);

			UniSales.fnGetItemInfo(grdRecord
				, UniAppManager.app.cbGetItemInfo
				, 'R'
				, UserInfo.compCode
				, panelSearch.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['ESTI_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
				, grdRecord.get('ORDER_Q')
				, record['WGT_UNIT']
				, record['VOL_UNIT']
				, record['UNIT_WGT']
				, record['UNIT_VOL']
				, record['PRICE_TYPE']
			);

			//수주수량/단가(중량) 재계산
			var sUnitWgt	= grdRecord.get('UNIT_WGT');
			var sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));

			if( sUnitWgt == 0)  {
				grdRecord.set('ORDER_WGT_P'	 ,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (grdRecord.get('ORDER_P') / sUnitWgt))
			}

			//수주수량/단가(부피) 재계산
			var sUnitVol	= grdRecord.get('UNIT_VOL');
			var sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));

			if( sUnitVol == 0)  {
				grdRecord.set('ORDER_VOL_P'	 ,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (grdRecord.get('ORDER_P') / sUnitVol))
			}

			//UniAppManager.app.fnOrderAmtCal(grdRecord, "Q");
			//UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE') );
		},
		setEstimateLinkData:function(params){
			var grdRecord = this.getSelectedRecord();
			var seq = detailStore.max('SER_NO');
				 if(!seq) seq = 1;
				 else  seq += 1;
			grdRecord.set('ITEM_CODE',			  params.data.ITEM_CODE);
			grdRecord.set('ITEM_NAME',			  params.data.ITEM_NAME);
			grdRecord.set('ITEM_ACCOUNT',			params.data.ITEM_ACCOUNT);
			grdRecord.set('SPEC',					params.data.SPEC);
			grdRecord.set('ORDER_UNIT',			 params.data.ESTI_UNIT);
			grdRecord.set('TRANS_RATE',			 params.data.TRANS_RATE);
			grdRecord.set('ORDER_Q',				params.data.ESTI_QTY);
			grdRecord.set('ORDER_P',				params.data.ESTI_CFM_PRICE);
			if(panelSearch.getValue('BILL_TYPE') != '50')  {
				grdRecord.set('TAX_TYPE',			  params.data.TAX_TYPE);
			} else {
				grdRecord.set('TAX_TYPE',			  '2');
			}
			grdRecord.set('DVRY_DATE',			  panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_WH_CODE',			params.data.WH_CODE);
			grdRecord.set('REF_STOCK_CARE_YN',	  params.data.STOCK_CARE_YN);
			grdRecord.set('SALE_CUST_CD',			params.data.CUSTOM_CODE);
			grdRecord.set('CUSTOM_NAME',			params.data.CUSTOM_NAME);
			grdRecord.set('ESTI_NUM',				params.data.ESTI_NUM);
			grdRecord.set('ESTI_SEQ',				params.data.ESTI_SEQ);
			grdRecord.set('SER_NO',				 seq);
			grdRecord.set('DISCOUNT_RATE',		  '0');
			grdRecord.set('ACCOUNT_YNC',			'Y');
			grdRecord.set('PRICE_YN',				'2');
			grdRecord.set('ORDER_STATUS',			'N');
			grdRecord.set('ISSUE_REQ_Q',			'0');
			grdRecord.set('OUTSTOCK_Q',			 '0');
			grdRecord.set('RETURN_Q',				'0');
			grdRecord.set('SALE_Q',				 '0');
			grdRecord.set('PROD_PLAN_Q',			'0');
			grdRecord.set('PRE_ACCNT_YN',			'Y');
			grdRecord.set('REF_ORDER_DATE',		 panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST',			panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE',		 panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO',		 panelSearch.getValue('PLAN_NUM'));
			if(panelSearch.getValue('TAX_INOUT') == '1') {
				grdRecord.set('REF_TAX_INOUT',	  '1');
			} else {
				grdRecord.set('REF_TAX_INOUT',	  '2');
			}
			grdRecord.set('REF_MONEY_UNIT',		 BsaCodeInfo.gsMoneyUnit);
//			grdRecord.set('REF_EXCHG_RATE_O',		params.data.);
			grdRecord.set('REF_REMARK',			 panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q',				params.data.ESTI_QTY);
			grdRecord.set('REF_FLAG',				'F');
			grdRecord.set('REF_BILL_TYPE',		  panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH',	panelSearch.getValue('RECEIPT_SET_METH'));
		}
	});





	/** 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
				fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_ORDER_DATE',
				endFieldName: 'TO_ORDER_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				colspan:2
			},{
				fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>'		,
				name: 'ORDER_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' , validateBlank: false,colspan:2,
				listeners:{
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}}),
//			Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO', textFieldName:'PROJECT_NAME', validateBlank: false}),
			Unilite.popup('DIV_PUMOK',{
				colspan:2,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'		, name: 'ORDER_TYPE',	xtype:'uniCombobox',comboType:'AU', comboCode:'S002'},
			{fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>'			, name: 'PO_NUM'},
			{
				fieldLabel: '조회구분'  ,
				xtype: 'uniRadiogroup',
				allowBlank: false,
				width: 235,
				name:'RDO_TYPE',
				items: [
					{boxLabel:'마스터', name:'RDO_TYPE', inputValue:'master', checked:true},
					{boxLabel:'디테일', name:'RDO_TYPE', inputValue:'detail'}
				],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.RDO_TYPE=='detail') {
							if(orderNoMasterGrid) orderNoMasterGrid.hide();
							if(orderNoDetailGrid) orderNoDetailGrid.show();
						} else {
							if(orderNoDetailGrid) orderNoDetailGrid.hide();
							if(orderNoMasterGrid) orderNoMasterGrid.show();
						}
					}
				}
			}
		]
	}); // createSearchForm
	//검색 모델(마스터)
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'													, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'		, type: 'string', comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'	, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'		, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="unilite.msg.sMS669" default="수주담당"/>'		, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'PJT_CODE'			, text: '프로젝트코드'													, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트'														, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_O'			, text: '수주금액'														, type: 'uniPrice'},
			{name: 'NATION_INOUT'		, text: '국내외구분'														, type: 'string'},
			{name: 'OFFER_NO'			, text: 'OFFER번호'													, type: 'string'},
			{name: 'DATE_DELIVERY'		, text: '납기일'														, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐'														, type: 'string'},
			{name: 'EXCHANGE_RATE'		, text: '환율'														, type: 'string'},
			{name: 'RECEIPT_SET_METH'	, text: '결제방법'														, type: 'string'}
		]
	});
	//검색 스토어(마스터)
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model	: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_sof100ukrv_ypService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()  {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(마스터)
	var orderNoMasterGrid = Unilite.createGrid('s_sof100ukrv_ypOrderNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
					 { dataIndex: 'DIV_CODE'	, width: 80 }
					,{ dataIndex: 'CUSTOM_NAME'	, width: 150 }
					,{ dataIndex: 'ORDER_DATE'	, width: 80 }
					,{ dataIndex: 'ORDER_NUM'	, width: 120 }
					,{ dataIndex: 'ORDER_TYPE'	, width: 80 }
					,{ dataIndex: 'ORDER_PRSN'	, width: 80 }
					,{ dataIndex: 'PJT_NAME'	, width: 150 }
					,{ dataIndex: 'ORDER_Q'		, width: 110 }
					,{ dataIndex: 'ORDER_O'		, width: 120 }

		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					orderNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			CustomCodeInfo.gsAgentType	  = record.get("AGENT_TYPE");
			CustomCodeInfo.gsCustCrYn		= record.get("CREDIT_YN"); //원미만계산
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");
			CustomCodeInfo.gsRefTaxInout	= record.get("TAX_TYPE");	//세액포함여부
		}
	});
	//검색 모델(디테일)
	Unilite.defineModel('orderNoDetailModel', {
		fields: [
					 { name: 'DIV_CODE'		,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'		,type: 'string' ,comboType:'BOR120'}
					,{ name: 'ITEM_CODE'	,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'		,type: 'string' }
					,{ name: 'ITEM_NAME'	,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'			,type: 'string' }
					,{ name: 'SPEC'			,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'		,type: 'string' }

					,{ name: 'ORDER_DATE'	,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'		,type: 'uniDate'}
					,{ name: 'DVRY_DATE'	,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'		,type: 'uniDate'}

					,{ name: 'ORDER_Q'		,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'		,type: 'uniQty' }
					,{ name: 'ORDER_TYPE'	,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'		,type: 'string' ,comboType:'AU', comboCode:'S002'}
					,{ name: 'ORDER_PRSN'	,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'		,type: 'string' ,comboType:'AU', comboCode:'S010'}
					,{ name: 'PO_NUM'		,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'		,type: 'string' }
					,{ name: 'PROJECT_NO'	,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'		,type: 'string' }
					,{ name: 'ORDER_NUM'	,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'		,type: 'string' }
					,{ name: 'SER_NO'		,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'		,type: 'string' }
					,{ name: 'CUSTOM_CODE'	,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'		,type: 'string' }
					,{ name: 'CUSTOM_NAME'	,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'		,type: 'string' }
					,{ name: 'COMP_CODE'	,text:'COMP_CODE'		,type: 'string' }
					,{ name: 'PJT_CODE'		,text:'프로젝트코드'														,type: 'string' }
					,{ name: 'PJT_NAME'		,text:'프로젝트'														,type: 'string' }

			]
	});
	//검색 스토어(디테일)
	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model	: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read	: 's_sof100ukrv_ypService.selectOrderNumDetailList'
			}
		},
		loadStoreRecords : function()  {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(디테일)
	var orderNoDetailGrid = Unilite.createGrid('s_sof100ukrv_ypOrderNoDetailGrid', {
		layout	: 'fit',
		store	: orderNoDetailStore,
		uniOpt	:{
			useRowNumberer: false
		},
		hidden : true,
		columns: [
			 { dataIndex: 'DIV_CODE',  width: 80 }
			,{ dataIndex: 'ITEM_CODE',  width: 120 }
			,{ dataIndex: 'ITEM_NAME',  width: 150 }
			,{ dataIndex: 'SPEC',  width: 150 }
			,{ dataIndex: 'ORDER_DATE',  width: 80 }
			,{ dataIndex: 'DVRY_DATE',  width: 80 , hidden:true}
			,{ dataIndex: 'ORDER_Q',  width: 80 }
			,{ dataIndex: 'ORDER_TYPE',  width: 90 }
			,{ dataIndex: 'ORDER_PRSN',  width: 90 , hidden:true}
			,{ dataIndex: 'PO_NUM',  width: 100 }
			,{ dataIndex: 'PROJECT_NO',  width: 90 }
			,{ dataIndex: 'ORDER_NUM',  width: 120 }
			,{ dataIndex: 'SER_NO',  width: 70 , hidden:true}
			,{ dataIndex: 'CUSTOM_CODE',  width: 120 , hidden:true}
			,{ dataIndex: 'CUSTOM_NAME',  width: 200 }
			,{ dataIndex: 'COMP_CODE',  width: 80 ,hidden:true}
			,{ dataIndex: 'PJT_CODE',  width: 120 , hidden:true}
			,{ dataIndex: 'PJT_NAME',  width: 200 }
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record)
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.uniOpt.inLoading=true;
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			panelSearch.uniOpt.inLoading=false;
		}
	});
	//openSearchInfoWindow
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '수주번호검색',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar	: [
					'->',{
						itemId	: 'searchBtn',
						text	: '조회',
						handler	: function() {
							var rdoType = orderNoSearch.getValue('RDO_TYPE');
							console.log('rdoType : ',rdoType)
							if(rdoType.RDO_TYPE=='master')  {
								orderNoMasterStore.loadStoreRecords();
							}else {
								orderNoDetailStore.loadStoreRecords();
							}
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId	: 'closeBtn',
						text	: '닫기',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt) {
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							 beforeclose: function( panel, eOpts )  {
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							 show: function( panel, eOpts ) {
								var field = orderNoSearch.getField('ORDER_PRSN');
								field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
								orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
								orderNoSearch.setValue('ORDER_PRSN',panelSearch.getValue('ORDER_PRSN'));
								orderNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
								orderNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
								orderNoSearch.setValue('ORDER_TYPE',panelSearch.getValue('ORDER_TYPE'));
								orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')));
								orderNoSearch.setValue('TO_ORDER_DATE',panelSearch.getValue('ORDER_DATE'));
								orderNoSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								orderNoSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
							 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	/** 사업장별 영업담당 정보
	 */
	var divPrsnStore = Unilite.createStore('s_sof100ukrv_yp_DIV_PRSN', {
		fields: ["value","text","option"],
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		listeners: {
			load: function( store, records, successful, eOpts ) {
					console.log("영업담당 store",this);

					if(successful) {
						estimateSearch.setValue('ESTI_PRSN', panelSearch.getValue('ORDER_PRSN'));
					}
			}
		},
		loadStoreRecords: function() {
			var param= {
						'COMP_CODE' : UserInfo.compCode,
						'MAIN_CODE' : 'S010',
						'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
						'TYPE'	  :'DIV_PRSN'
				}
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 견적을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var estimateSearch = Unilite.createSearchForm('estimateForm', {

			layout :  {type : 'uniTable', columns : 2},
			items :[	Unilite.popup('AGENT_CUST',{fieldLabel:'견적처' , validateBlank: false})
						,{ fieldLabel: '<t:message code="unilite.msg.sMS538" default="견적번호"/>'  ,		name: 'ESTI_NUM'}
						,{ fieldLabel: '<t:message code="unilite.msg.sMS147" default="견적일"/>'
							,xtype: 'uniDateRangefield'
							,startFieldName: 'FR_ESTI_DATE'
							,endFieldName: 'TO_ESTI_DATE'
							,width: 350
							,startDate: UniDate.get('startOfMonth')
							,endDate: UniDate.get('today')
						 }
						 ,{fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'  , name: 'ESTI_PRSN',	xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('s_sof100ukrv_yp_DIV_PRSN') }
					]

	});
	//견적참조 모델
	Unilite.defineModel('s_sof100ukrv_ypESTIModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="unilite.msg.sMS774" default="견적처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="unilite.msg.sMS774" default="견적처"/>'		  , type: 'string'},
			{name: 'ESTI_DATE'		  ,text: '<t:message code="unilite.msg.sMSR002" default="견적일"/>'		 , type: 'uniDate'},
			{name: 'ESTI_NUM'			,text: '<t:message code="unilite.msg.sMS538" default="견적번호"/>'		 , type: 'string'},
			{name: 'ESTI_SEQ'			,text: '<t:message code="unilite.msg.sMSR003" default="순번"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		  ,text: '<t:message code="unilite.msg.sMS501" default="품목코드"/>'		 , type: 'string'},
			{name: 'ITEM_NAME'		  ,text: '<t:message code="unilite.msg.sMS688" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="unilite.msg.sMSR033" default="규격"/>'			, type: 'string'},
			{name: 'ESTI_UNIT'		  ,text: '<t:message code="unilite.msg.sMS690" default="판매단위"/>'		 , type: 'string'},
			{name: 'TRANS_RATE'		 ,text: '<t:message code="unilite.msg.sMSR010" default="입수"/>'			, type: 'string'},
			{name: 'ESTI_QTY'			,text: '<t:message code="unilite.msg.sMSR004" default="견적수량"/>'		, type: 'uniQty'},
			{name: 'ESTI_PRICE'		 ,text: '<t:message code="unilite.msg.sMSR005" default="견적단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ESTI_AMT'			,text: '<t:message code="unilite.msg.sMSR006" default="견적금액"/>'		, type: 'uniPrice'},
			{name: 'ESTI_TAX_AMT'		,text: '<t:message code="unilite.msg.sMS775" default="견적세액"/>'		 , type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="unilite.msg.sMSR289" default="과세구분"/>'		, type: 'string'},
			{name: 'MONEY_UNIT'		 ,text: '<t:message code="unilite.msg.sMSR047" default="화폐단위"/>'		, type: 'string'},
			{name: 'EXCHANGE_RATE'	  ,text: '<t:message code="unilite.msg.sMSR031" default="환율"/>'			, type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="unilite.msg.sMS698" default="창고코드"/>'		 , type: 'string'},
			{name: 'STOCK_UNIT'		 ,text: '<t:message code="unilite.msg.sMS700" default="재고단위"/>'		 , type: 'string'},
			{name: 'STOCK_CARE_YN'	  ,text: '<t:message code="unilite.msg.sMS776" default="재고관리여부"/>'	  , type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'													, type: 'string'}
		]
	});
	//견적참조 스토어
	var estimateStore = Unilite.createStore('s_sof100ukrv_ypEstiStore', {
			model: 's_sof100ukrv_ypESTIModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false		 // prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_sof100ukrv_ypService.selectEstiList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
						if(successful)  {
							var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
							var estiRecords = new Array();

							if(masterRecords.items.length > 0)	{
								console.log("store.items :", store.items);
								console.log("records", records);

								Ext.each(records,
									function(item, i)	{
										Ext.each(masterRecords.items, function(record, i)	{
											console.log("record :", record);

												if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
														&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
												  )
												{
													estiRecords.push(item);
												}
										});
								});
								store.remove(estiRecords);
							}
						}
				}
			}
			,loadStoreRecords : function()  {
				var param= estimateSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//견적참조 그리드
	var estimateGrid = Unilite.createGrid('s_sof100ukrv_ypEstimateGrid', {
		// title: '기본',
		layout : 'fit',
		store: estimateStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
					 { dataIndex: 'CUSTOM_NAME',  width: 150 }
					,{ dataIndex: 'ESTI_DATE',  width: 110 }
					,{ dataIndex: 'ESTI_NUM',  width: 140 }
					,{ dataIndex: 'ESTI_SEQ',  width: 60 }
					,{ dataIndex: 'ITEM_CODE',  width: 110 }
					,{ dataIndex: 'ITEM_NAME',  width: 150 }
					,{ dataIndex: 'SPEC',  width: 150 }
					,{ dataIndex: 'ESTI_UNIT',  width: 90 }
					,{ dataIndex: 'TRANS_RATE',  width: 60 }
					,{ dataIndex: 'ESTI_QTY',  width: 120 }
					,{ dataIndex: 'ESTI_PRICE',  width: 110 }
					,{ dataIndex: 'ESTI_AMT',  width: 100 }
					,{ dataIndex: 'ESTI_TAX_AMT',  width: 50 , hidden: true}
					,{ dataIndex: 'TAX_TYPE',  width: 50 , hidden: true}
					,{ dataIndex: 'MONEY_UNIT',  width: 50 , hidden: true}
					,{ dataIndex: 'EXCHANGE_RATE',  width: 50 , hidden: true}
					,{ dataIndex: 'WH_CODE',  width: 50 , hidden: true}
					,{ dataIndex: 'STOCK_UNIT',  width: 50 , hidden: true}
					,{ dataIndex: 'STOCK_CARE_YN',  width: 50 , hidden: true}
					,{ dataIndex: 'ITEM_ACCOUNT',  width: 50 , hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setEstiData(record.data);
			});
			//this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});
	//견적참조 메인
	function openEstimateWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		estimateSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
		estimateSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
		estimateSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')) );
		estimateSearch.setValue('TO_ESTI_DATE', panelSearch.getValue('ORDER_DATE'));
//		  estimateSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
//
//		  estimateSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
//		  estimateSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//		  estimateSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', panelResult.getValue('ORDER_DATE')) );
//		  estimateSearch.setValue('TO_ESTI_DATE', panelResult.getValue('ORDER_DATE'));
//		  estimateSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
		divPrsnStore.loadStoreRecords(); // 사업장별 영업사원 콤보

		if(!referEstimateWindow) {
			referEstimateWindow = Ext.create('widget.uniDetailWindow', {
				title: '견적참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [estimateSearch, estimateGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												estimateStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											text: '수주적용',
											handler: function() {
												estimateGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '수주적용 후 닫기',
											handler: function() {
												estimateGrid.returnData();
												referEstimateWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												if(detailStore.getCount() == 0){
													panelSearch.setAllFieldsReadOnly(false);
													panelResult.setAllFieldsReadOnly(false);
												}
												referEstimateWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt) {
											//estimateSearch.clearForm();
											//estimateGrid,reset();
										},
							 beforeclose: function( panel, eOpts )  {
											//estimateSearch.clearForm();
											//estimateGrid,reset();
										},
							 beforeshow: function ( me, eOpts ) {
								estimateStore.loadStoreRecords();
							 }
				}
			})
		}
		referEstimateWindow.center();
		referEstimateWindow.show();
	}



	/** 수주이력을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var refSearch = Unilite.createSearchForm('RefSForm', {
			layout :  {type : 'uniTable', columns : 3},
			items :[	Unilite.popup('AGENT_CUST',{fieldLabel:'수주처' , validateBlank: false,
						listeners:{
							applyextparam: function(popup){
								popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
								popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
							}
						}})
						,Unilite.popup('DIV_PUMOK',{validateBlank: false, colspan:2,
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}})
						,{ fieldLabel: '수주일'
							,xtype: 'uniDateRangefield'
							,startFieldName: 'FR_ORDER_DATE'
							,endFieldName: 'TO_ORDER_DATE'
							,width: 350
							,startDate: UniDate.get('startOfMonth')
							,endDate: UniDate.get('today')
						 },{
							fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'	 ,
							name: 'ORDER_PRSN',
							xtype:'uniCombobox',
							comboType:'AU',
							comboCode:'S010',
							onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
								if(eOpts){
									combo.filterByRefCode('refCode1', newValue, eOpts.parent);
								}else{
									combo.divFilterByRefCode('refCode1', newValue, divCode);
								}
							}
						 },{fieldLabel: '최근수주'	  , name: 'RDO_YN',	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010' , width:210, allowBlank:false, value:'Y'}
					]
	});
	//수주이력 모델
	Unilite.defineModel('s_sof100ukrv_ypRefModel', {
		fields: [
					 { name: 'CUSTOM_CODE'		  , text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' }
					,{ name: 'CUSTOM_NAME'		  , text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' }
					,{ name: 'ORDER_DATE'			, text:'<t:message code="unilite.msg.sMS508" default="수주일"/>' ,type : 'string' }
					,{ name: 'ORDER_NUM'			, text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>' ,type : 'string' }
					,{ name: 'SER_NO'				, text:'<t:message code="unilite.msg.sMSR003" default="순번"/>' ,type : 'int' }
					,{ name: 'ITEM_CODE'			, text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>' ,type : 'string' }
					,{ name: 'ITEM_NAME'			, text:'<t:message code="unilite.msg.sMS688" default="품명"/>' ,type : 'string' }
					,{ name: 'SPEC'				 , text:'<t:message code="unilite.msg.sMSR033" default="규격"/>' ,type : 'string' }
					,{ name: 'ORDER_UNIT'			, text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>' ,type : 'string' , comboType:'AU', comboCode:'B013', displayField: 'value'}
					,{ name: 'TRANS_RATE'			, text:'<t:message code="unilite.msg.sMSR010" default="입수"/>' ,type : 'uniQty' }
					,{ name: 'ORDER_Q'			  , text:'<t:message code="unilite.msg.sMS543" default="수주량"/>' ,type : 'uniQty' }
					,{ name: 'ORDER_P'			  , text:'개별단가'					,type : 'uniUnitPrice' }
					,{ name: 'ORDER_WGT_Q'		  , text:'수주량(중량)'				 ,type : 'uniQty' }
					,{ name: 'ORDER_WGT_P'		  , text:'단가(중량)'				  ,type : 'uniQty' }
					,{ name: 'ORDER_VOL_Q'		  , text:'수주량(부피)'				 ,type : 'uniUnitPrice' }
					,{ name: 'ORDER_VOL_P'		  , text:'단가(부피)'				  ,type : 'uniQty' }
					,{ name: 'ORDER_O'			  , text:'<t:message code="unilite.msg.sMS681" default="금액"/>' ,type : 'uniPrice' }
					,{ name: 'ORDER_TAX_O'		  , text:'ORDER_TAX_O'			 ,type : 'uniPrice' }
					,{ name: 'TAX_TYPE'			 , text:'TAX_TYPE'				,type : 'string' }
					,{ name: 'DIV_CODE'			 , text:'DIV_CODE'				,type : 'string' }
					,{ name: 'OUT_DIV_CODE'		 , text:'OUT_DIV_CODE'			,type : 'string' }
					,{ name: 'ACCOUNT_YNC'		  , text:'ACCOUNT_YNC'			 ,type : 'string' }
					,{ name: 'SALE_CUST_CD'		 , text:'SALE_CUST_CD'			,type : 'string' }
					,{ name: 'SALE_CUST_NM'		 , text:'SALE_CUST_NM'			,type : 'string' }
					,{ name: 'PRICE_YN'			 , text:'PRICE_YN'				,type : 'string' }
					,{ name: 'STOCK_Q'			  , text:'STOCK_Q'				 ,type : 'string' }
					,{ name: 'DVRY_CUST_CD'		 , text:'DVRY_CUST_CD'			,type : 'string' }
					,{ name: 'DVRY_CUST_NAME'		, text:'DVRY_CUST_NAME'		  ,type : 'string' }
					,{ name: 'STOCK_UNIT'			, text:'STOCK_UNIT'			  ,type : 'string' }
					,{ name: 'WH_CODE'			  , text:'WH_CODE'				 ,type : 'string' }
					,{ name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'			,type : 'string' }
					,{ name: 'DISCOUNT_RATE'		, text:'DISCOUNT_RATE'			,type : 'string' }
					,{ name: 'ITEM_ACCOUNT'		 , text:'ITEM_ACCOUNT'			,type : 'string' }
					,{ name: 'PRICE_TYPE'			, text:'PRICE_TYPE'			  ,type : 'string' }
					,{ name: 'WGT_UNIT'			 , text:'WGT_UNIT'				,type : 'string' }
					,{ name: 'UNIT_WGT'			 , text:'UNIT_WGT'				,type : 'string' }
					,{ name: 'VOL_UNIT'			 , text:'VOL_UNIT'				,type : 'string' }
					,{ name: 'UNIT_VOL'			 , text:'UNIT_VOL'				,type : 'string' }
					,{ name: 'SO_KIND'			  , text:'SO_KIND'				 ,type : 'string' }
				]
	});
	//수주이력 스토어
	var refStore = Unilite.createStore('s_sof100ukrv_ypRefStore', {
			model: 's_sof100ukrv_ypRefModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false		 // prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_sof100ukrv_ypService.selectRefList'

				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
						if(successful)  {
							var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
							var estiRecords = new Array();

							if(masterRecords.items.length > 0)	{
								console.log("store.items :", store.items);
								console.log("records", records);

								Ext.each(records,
									function(item, i)	{
										Ext.each(masterRecords.items, function(record, i)	{
											console.log("record :", record);

												if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
														&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
												  )
												{
													estiRecords.push(item);
												}
										});
								});
								store.remove(estiRecords);
							}
						}
				}
			}
			,loadStoreRecords : function()  {
				var param= refSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//수주이력 그리드
	var refGrid = Unilite.createGrid('s_sof100ukrv_ypRefGrid', {
		// title: '기본',
		layout : 'fit',
		store: refStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
					 { dataIndex: 'CUSTOM_CODE',  width: 50 , hidden:true}
					,{ dataIndex: 'CUSTOM_NAME',  width: 110 }
					,{ dataIndex: 'ORDER_DATE',  width: 80 }
					,{ dataIndex: 'ORDER_NUM',  width: 100 }
					,{ dataIndex: 'SER_NO',  width: 60 }
					,{ dataIndex: 'ITEM_CODE',  width: 00 }
					,{ dataIndex: 'ITEM_NAME',  width: 110 }
					,{ dataIndex: 'SPEC',  width: 130 }
					,{ dataIndex: 'ORDER_UNIT',  width: 80 }
					,{ dataIndex: 'TRANS_RATE',  width: 60 }
					,{ dataIndex: 'ORDER_Q',  width: 90 }
					,{ dataIndex: 'ORDER_P',  width: 80 }
					,{ dataIndex: 'ORDER_WGT_Q',  width: 90 , borderColor:'red'}
					,{ dataIndex: 'ORDER_WGT_P',  width: 90 }
					,{ dataIndex: 'ORDER_VOL_Q',  width: 90 }
					,{ dataIndex: 'ORDER_VOL_P',  width: 90 }
					,{ dataIndex: 'ORDER_O',  width: 90 }
					,{ dataIndex: 'ORDER_TAX_O',  width: 50 , hidden:true}
					,{ dataIndex: 'TAX_TYPE',  width: 50 , hidden:true}
					,{ dataIndex: 'DIV_CODE',  width: 50 , hidden:true}
					,{ dataIndex: 'OUT_DIV_CODE',  width: 50 , hidden:true}
					,{ dataIndex: 'ACCOUNT_YNC',  width: 50 , hidden:true}
					,{ dataIndex: 'SALE_CUST_CD',  width: 50 , hidden:true}
					,{ dataIndex: 'SALE_CUST_NM',  width: 50 , hidden:true}
					,{ dataIndex: 'PRICE_YN',  width: 50 , hidden:true}
					,{ dataIndex: 'STOCK_Q',  width: 50 , hidden:true}
					,{ dataIndex: 'DVRY_CUST_CD',  width: 50 , hidden:true}
					,{ dataIndex: 'DVRY_CUST_NAME',  width: 50 , hidden:true}
					,{ dataIndex: 'STOCK_UNIT',  width: 50 , hidden:true}
					,{ dataIndex: 'WH_CODE',  width: 50 , hidden:true}
					,{ dataIndex: 'STOCK_CARE_YN',  width: 50 , hidden:true}
					,{ dataIndex: 'DISCOUNT_RATE',  width: 50 , hidden:true}
					,{ dataIndex: 'ITEM_ACCOUNT',  width: 50 , hidden:true}
					,{ dataIndex: 'PRICE_TYPE',  width: 50 , hidden:true}
					,{ dataIndex: 'WGT_UNIT',  width: 50 , hidden:true}
					,{ dataIndex: 'UNIT_WGT',  width: 50 , hidden:true}
					,{ dataIndex: 'VOL_UNIT',  width: 50 , hidden:true}
					,{ dataIndex: 'UNIT_VOL',  width: 50 , hidden:true}
					,{ dataIndex: 'SO_KIND',  width: 50 , hidden:true}

		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setRefData(record.data);
			});
			this.getStore().remove(records);
		}
	});
	//수주이력 메인
	function openRefWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var field = refSearch.getField('ORDER_PRSN');
		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
		refSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
		refSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
		refSearch.setValue('ORDER_PRSN', panelSearch.getValue('ORDER_PRSN'));

		refSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
		refSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
		refSearch.setValue('ORDER_PRSN', panelResult.getValue('ORDER_PRSN'));

		if(!referOrderRecordWindow) {
			referOrderRecordWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주이력참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [refSearch, refGrid],
				tbar:  [
					'->',{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							refStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '수주적용',
						handler: function() {
							refGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '수주적용 후 닫기',
						handler: function() {
							refGrid.returnData();
							referOrderRecordWindow.hide();
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
							}
							referOrderRecordWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt) {
											//refSearch.clearForm();
											//refGrid.reset();
										},
							 beforeclose: function( panel, eOpts )  {
											//RefSearch.clearForm();
											//refGrid.reset();
										},
							  beforeshow: function ( me, eOpts )	{
								refStore.loadStoreRecords();
							 }
				}
			})
		}
		referOrderRecordWindow.center();
		referOrderRecordWindow.show();
	}



	// 엑셀참조
	Unilite.Excel.defineModel('excel.sof100.sheet01', {
		fields: [
				 {name: 'ITEM_CODE',	text:'품목코드',			type: 'string'},
				 {name: 'QTY',			text:'판매수량',			type: 'uniQty'},
				 {name: 'ITEM_NAME',	text:'품목명',				type: 'string'},
				 {name: 'SPEC',			text:'규격',				type: 'string'},
				 {name: 'PRICE',		text:'판매단가',			type: 'uniPrice'},
				 {name: 'ORDER_UNIT',	text:'판매단위',			type: 'string', displayField: 'value'},
				 {name: 'TRNS_RATE',	text:'입수',				type: 'string'},
				 {name: 'ITEM_ACCOUNT',	text:'품목계정',			type: 'string'},
				 {name: 'OUT_WH_CODE',	text:'출고창고',			type: 'string'},
				 {name: 'WH_CODE',		text:'주창고',				type: 'string'},
				 {name: 'ORDER_O',		text:'금액',				type: 'uniPrice'},
				 {name: 'ORDER_TAX_O',	text:'부가세액',			type: 'uniPrice'},
				 {name: 'ORDER_O_TAX_O',text:'수주계',				type: 'uniPrice'},
				 {name: 'STOCK_UNIT',	text:'재고단위',			type: 'string', displayField: 'value'},
				 {name: 'STOCK_CARE_YN',text:'재고관리대상여부',		type: 'string'},
				 {name: 'WGT_UNIT',		text:'중량단위',			type: 'string'},
				 {name: 'UNIT_WGT',		text:'단위중량',			type: 'string'},
				 {name: 'VOL_UNIT',		text:'부피단위',			type: 'string'},
				 {name: 'UNIT_VOL',		text:'단위부피',			type: 'string'}
		]
	});

	function openExcelWindow() {
			if(!UniAppManager.app.checkForNewDetail()) return false;

			var me = this;
			var vParam = {};
			var appName = 'Unilite.com.excel.ExcelUploadWin';


			if(!Ext.isEmpty(excelWindow)){
				excelWindow.extParam.DIV_CODE		= panelSearch.getValue('DIV_CODE');
				excelWindow.extParam.CUSTOM_CODE	= panelSearch.getValue('CUSTOM_CODE');
				excelWindow.extParam.MONEY_UNIT		= panelSearch.getValue('MONEY_UNIT');
				excelWindow.extParam.ORDER_DATE		= UniDate.getDateStr( panelSearch.getValue('ORDER_DATE'))	//수주일자
			}
			if(!excelWindow) {
				excelWindow =  Ext.WindowMgr.get(appName);
				excelWindow = Ext.create( appName, {
						modal: false,
						excelConfigName: 'sof100',
						extParam: {
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
							'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
							'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT'),
							'ORDER_DATE'	: UniDate.getDateStr( panelSearch.getValue('ORDER_DATE'))
						},
						grids: [{
								itemId: 'grid01',
								title: '수주정보',
								useCheckbox: true,
								model : 'excel.sof100.sheet01',
								readApi: 's_sof100ukrv_ypService.selectExcelUploadSheet1',
								columns: [
											 { dataIndex: 'ITEM_CODE',		  width: 120	  }
											,{ dataIndex: 'QTY',				width: 80		}
											,{ dataIndex: 'ITEM_NAME',		  width: 120	  }
											,{ dataIndex: 'SPEC',				width: 120	  }
											,{ dataIndex: 'PRICE',			  width: 80		}
											,{ dataIndex: 'ORDER_UNIT',		 width: 80		}
											,{ dataIndex: 'TRNS_RATE',		  width: 80		}
											,{ dataIndex: 'ITEM_ACCOUNT',		width: 100	  }
											,{ dataIndex: 'OUT_WH_CODE',		width: 100	  }
											,{ dataIndex: 'WH_CODE',			width: 100	  }
											,{ dataIndex: 'ORDER_O',			  width: 80		}
											,{ dataIndex: 'ORDER_TAX_O',		  width: 80		}
											,{ dataIndex: 'ORDER_O_TAX_O',		width: 80		}
								],
								listeners: {
									afterrender: function(grid) {
										var me = this;

											this.contextMenu = Ext.create('Ext.menu.Menu', {});
											this.contextMenu.add(
												{
													text: '상품정보 등록',	iconCls : '',
													handler: function(menuItem, event) {
														var records = grid.getSelectionModel().getSelection();
														var record = records[0];
														var params = {
															appId: UniAppManager.getApp().id,
															sender: me,
															action: 'excelNew',
															_EXCEL_JOBID: excelWindow.jobID,			//SOF112T Key1
															_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
															ITEM_CODE: record.get('ITEM_CODE'),
															DIV_CODE: panelSearch.getValue('DIV_CODE')
														}
														var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
														parent.openTab(rec, '/base/bpr101ukrv.do', params);
													}
												}
											);

											this.contextMenu.add(
												{
													text: '도서정보 등록',	iconCls : '',
													handler: function(menuItem, event) {
														var records = grid.getSelectionModel().getSelection();
														var record = records[0];
														var params = {
															appId: UniAppManager.getApp().id,
															sender: me,
															action: 'excelNew',
															_EXCEL_JOBID: excelWindow.jobID,			//SOF112T Key1
															_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
															ITEM_CODE: record.get('ITEM_CODE'),
															DIV_CODE: panelSearch.getValue('DIV_CODE')
														}
														var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};
														parent.openTab(rec, '/base/bpr102ukrv.do', params);
													}
												}
											);

											me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
												event.stopEvent();
												if(record.get('_EXCEL_HAS_ERROR') == 'Y')
													me.contextMenu.showAt(event.getXY());
											});


									}
								}

							}
						],
						listeners: {
							close: function() {
								this.hide();
							}
						},
						onApply:function()  {
							var grid = this.down('#grid01');
							var records = grid.getSelectionModel().getSelection();
							Ext.each(records, function(record,i){
								UniAppManager.app.onNewDataButtonDown();
								detailGrid.setExcelData(record.data);
							});
							//grid.getStore().remove(records);
							var beforeRM = grid.getStore().count();
							grid.getStore().remove(records);
							var afterRM = grid.getStore().count();
							if (beforeRM > 0 && afterRM == 0){
								excelWindow.close();
							}
						}
				 });
			}
			excelWindow.center();
			excelWindow.show();
	};





	/** main app
	 */
	Unilite.Main({
		id: 's_sof100ukrv_ypApp',
		focusField:panelSearch.getField('CUSTOM_CODE'),
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid, panelTrade
			]
		}
		,panelSearch
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
//			detailGrid.disabledLinkButtons(false);
//			Ext.getCmp('nationButton').setDisabled(true);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			} else {
				this.setDefault();
				if(params && params.ORDER_NUM ) {
					panelSearch.setValue('ORDER_NUM',params.ORDER_NUM);
					UniAppManager.app.onQueryButtonDown();
				}
				panelSearch.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
			}


			if(panelSearch.getValue('NATION_INOUT') == '2') {
				//무역폼 readOnly: false
				panelSearch.getField('OFFER_NO').setReadOnly(false);
				panelResult.getField('OFFER_NO').setReadOnly(false);
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(false);
				});
//				panelTrade.setConfig('collapsed', false);
				Ext.getCmp('tradeForm').setHidden(true);
			} else {
				//무역폼 readOnly: true
				panelSearch.getField('OFFER_NO').setReadOnly(true);
				panelResult.getField('OFFER_NO').setReadOnly(true);
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(true);
				});
//				panelTrade.setConfig('collapsed', true);
				Ext.getCmp('tradeForm').setHidden(true);
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_sof101ukrv_yp') {
				panelSearch.setValue('ORDER_NUM',params.ORDER_NUM);
				panelResult.setValue('ORDER_NUM',params.ORDER_NUM);

				UniAppManager.app.onQueryButtonDown();
			}
		},
		onQueryButtonDown: function() {
//		  panelSearch.setAllFieldsReadOnly(false);
//		  panelResult.setAllFieldsReadOnly(false);
			var orderNo = panelSearch.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				isLoad = true;
				var param= panelSearch.getValues();
				panelSearch.uniOpt.inLoading=true;
				panelSearch.getForm().load({
					params: param,
					success:function()  {
						panelResult.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						panelResult.setValue('TAX_INOUT', panelSearch.getValue('TAX_INOUT'));
						panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
						panelResult.getForm().findField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getForm().findField('CUSTOM_NAME').setReadOnly(true);
						gsSaveRefFlag = 'Y';
						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode = panelSearch.getValue('DIV_CODE');
							var CustomCode = panelSearch.getValue('CUSTOM_CODE');
							var orderDate = panelSearch.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						panelSearch.setAllFieldsReadOnly(true)
						panelResult.setAllFieldsReadOnly(true)
						panelTrade.setAllFieldsReadOnly(true);

//					  if(BsaCodeInfo.gsDraftFlag == 'Y' && panelSearch.getValue('STATUS') != '1')  {
//						  checkDraftStatus = true;
//					  }
						if(panelSearch.getValue('ORDER_REQ_YN') != "N"){ //구매요청정보 반영에 따른 버튼 disabled 처리
							panelSearch.down('#purchaseRequest1').setDisabled(true);
							panelResult.down('#purchaseRequest2').setDisabled(true);
						}else{
							panelSearch.down('#purchaseRequest1').setDisabled(false);
							panelResult.down('#purchaseRequest2').setDisabled(false);
						}

						panelSearch.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
						panelSearch.uniOpt.inLoading=false;
					}
				})
				panelTrade.getForm().load({
					params: param,
					success:function()  {
					},
					failure: function(form, action) {
						panelTrade.uniOpt.inLoading=false;
					}
				})
				detailStore.loadStoreRecords();

			}
		},
		onNewDataButtonDown: function() {
			if(panelSearch.getValue('NATION_INOUT') == 2 && Ext.isEmpty(panelSearch.getValue('OFFER_NO'))) {
				alert("OFFER번호는 필수입니다.");
				return true;
			}
			if(!this.checkForNewDetail()) return false;

			/**
			 * Detail Grid Default 값 설정
			 */
			 var orderNum = panelSearch.getValue('ORDER_NUM');

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 var taxType ='1';
			 if(panelSearch.getValue('BILL_TYPE')=='50' || panelSearch.getValue('BILL_TYPE')=='60' || panelSearch.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			 }

			 var dvryDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DVRY_DATE'))) {
				dvryDate = panelSearch.getValue('DVRY_DATE');
			 }else {
				dvryDate= new Date();
			 }

			 var prodEndDate	= '';
			 if(!Ext.isEmpty(panelSearch.getValue('DVRY_DATE'))) {
				prodEndDate = panelSearch.getValue('DVRY_DATE');
			 }else {
				prodEndDate= new Date();
			 }
			 prodEndDate = UniDate.add(prodEndDate, {days: -1});

			 var saleCustCd = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				saleCustCd=panelSearch.getValue('SALE_CUST_CD');
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_DATE'))) {
				refOrderDate=panelSearch.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				refOrdCust=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				customCode=panelSearch.getValue('SALE_CUST_CD');
			 }else{
				customCode=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM'))) {
				customName=panelSearch.getValue('SALE_CUST_NM');
			 }else{
				customName=panelSearch.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				refOrderType=panelSearch.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(panelSearch.getValue('PLAN_NUM'))) {
				projectNo=panelSearch.getValue('PLAN_NUM');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType=panelSearch.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(panelSearch.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=panelSearch.getValue('RECEIPT_SET_METH');
			 }

			 var r = {
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,							//납기일
				PROD_END_DATE		: prodEndDate,						//생산완료일
				EXP_ISSUE_DATE		: dvryDate,							//출하예정일
				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			panelTrade.setAllFieldsReadOnly(true);

			if(gsSaveRefFlag == "Y"){
				panelSearch.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
			}
		},
		onLinkNewData: function() {
			 var orderNum = panelSearch.getValue('ORDER_NUM')

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 var taxType ='1';
			 if(panelSearch.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			 }

			 var dvryDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DVRY_DATE'))) {
				dvryDate=panelSearch.getValue('DVRY_DATE');
			 }else {
				dvryDate= new Date();
			 }

			 var saleCustCd = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				saleCustCd=panelSearch.getValue('SALE_CUST_CD');
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_DATE'))) {
				refOrderDate=panelSearch.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				refOrdCust=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				customCode=panelSearch.getValue('SALE_CUST_CD');
			 }else{
				customCode=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM'))) {
				customName=panelSearch.getValue('SALE_CUST_NM');
			 }else{
				customName=panelSearch.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				refOrderType=panelSearch.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(panelSearch.getValue('PLAN_NUM'))) {
				projectNo=panelSearch.getValue('PLAN_NUM');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType=panelSearch.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(panelSearch.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=panelSearch.getValue('RECEIPT_SET_METH');
			 }

			 var r = {
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,
				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelTrade.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			panelTrade.clearForm();
			this.fnInitBinding();
			panelSearch.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
//		  if(detailStore.data.length == 0) {
//			  alert('수주상세정보를 입력하세요.');
//			  return;
//		  }
			/**
			 * 여신한도 확인
			 */
			if(!panelSearch.fnCreditCheck()) {
				return ;
			}

			if(isDraftFlag === false)	{ // 수동승인인 경우
				var amt = panelSearch.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(panelSearch.getValue("APP_1_ID")))	{
					alert("1차 승인자는 필수 입력입니다.");
					panelSearch.getField("APP_1_NM").focus();
					return false;
				}else if(amt > BsaCodeInfo.gsApp1AmtInfo)	{
					if(Ext.isEmpty(panelSearch.getValue("APP_2_ID")))	{
						alert("2차 승인자는 필수 입력입니다.");
						panelSearch.getField("APP_2_NM").focus();
						return false;
					}else  if(amt > BsaCodeInfo.gsApp2AmtInfo)  {
						if(Ext.isEmpty(panelSearch.getValue("APP_3_ID")))	{
							alert("3차 승인자는 필수 입력입니다.");
							panelSearch.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty())  {
				if(panelSearch.isDirty())	{
					this.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
			}
		},
		onSaveDataButtonDown2: function(config) {	//panelSearch.fnCreditCheck() 없는용..삭제시 호출

//		  if(detailStore.data.length == 0) {
//			  alert('수주상세정보를 입력하세요.');
//			  return;
//		  }
			/**
			 * 여신한도 확인
			 */
//		  if(!panelSearch.fnCreditCheck()) {
//			  return ;
//		  }

			if(isDraftFlag === false)	{ // 수동승인인 경우
				var amt = panelSearch.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(panelSearch.getValue("APP_1_ID")))	{
					alert("1차 승인자는 필수 입력입니다.");
					panelSearch.getField("APP_1_NM").focus();
					return false;
				}else if(amt > BsaCodeInfo.gsApp1AmtInfo)	{
					if(Ext.isEmpty(panelSearch.getValue("APP_2_ID")))	{
						alert("2차 승인자는 필수 입력입니다.");
						panelSearch.getField("APP_2_NM").focus();
						return false;
					}else  if(amt > BsaCodeInfo.gsApp2AmtInfo)  {
						if(Ext.isEmpty(panelSearch.getValue("APP_3_ID")))	{
							alert("3차 승인자는 필수 입력입니다.");
							panelSearch.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty())  {
				if(panelSearch.isDirty())	{
					this.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
			}
		},
		fnMasterSave: function(){
			var param = panelSearch.getValues();
			panelSearch.submit({
				params: param,
				success:function(comp, action)  {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);
				},
				failure: function(form, action){

				}
			});
		},
		fnNationSave: function(){
			var param = nationSearch.getValues();
			nationSearch.submit({
				params: param,
				success:function(comp, action)  {
					UniAppManager.updateStatus(Msg.sMB011);
				},
				failure: function(form, action){

				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		 onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						Ext.each(records, function(record,i) {
							if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
								alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown2();
						}
					}
					return false;
				}
			});
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}

		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_sof100ukrv_ypAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			if(detailStore.isDirty() )  {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			//무역 폼필드 readOnly
			panelTrade.getForm().getFields().each(function(field) {
				field.setReadOnly(true);
			});

			/*영업담당 filter set*/
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE',new Date());
			panelResult.setValue('ORDER_DATE',new Date());
			panelSearch.setValue('TAX_INOUT','1');
			panelResult.setValue('TAX_INOUT','1');
			panelSearch.setValue('STATUS','1');
			panelResult.setValue('STATUS','1');
			panelSearch.setValue('MONEY_UNIT','KRW');
			panelResult.setValue('MONEY_UNIT','KRW');
			panelSearch.setValue('EXCHANGE_RATE','1');
			panelResult.setValue('EXCHANGE_RATE','1');
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
//			panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
//			panelSearch.setValue('ORDER_PRSN','70');
//			panelResult.setValue('ORDER_PRSN', '70');
			panelSearch.setValue('NATION_INOUT','1');
			panelResult.setValue('NATION_INOUT','1');
			panelSearch.setValue('DVRY_DATE',new Date());
			panelResult.setValue('DVRY_DATE',new Date());
//			panelSearch.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); //영엽담당
//			panelResult.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); //영엽담당
			panelTrade.setValue('DATE_EXP', new Date());
			panelTrade.setValue('DATE_DEPART', new Date());

//			panelTrade.setValue('PAY_TERMS', Ext.data.StoreManager.lookup('CBS_AU_T006').getAt(0).get('value'));
//			panelTrade.setValue('PAY_METHODE1', Ext.data.StoreManager.lookup('CBS_AU_T006').getAt(0).get('value'));
//			panelTrade.setValue('TERMS_PRICE', Ext.data.StoreManager.lookup('CBS_AU_T005').getAt(0).get('value'));
//			panelTrade.setValue('METH_CARRY', Ext.data.StoreManager.lookup('CBS_AU_T004').getAt(0).get('value'));
//			panelTrade.setValue('COND_PACKING', Ext.data.StoreManager.lookup('CBS_AU_T010').getAt(0).get('value'));
//			panelTrade.setValue('METH_INSPECT', Ext.data.StoreManager.lookup('CBS_AU_T011').getAt(0).get('value'));
//			panelTrade.setValue('SHIP_PORT', Ext.data.StoreManager.lookup('CBS_AU_T008').getAt(0).get('value'));
//			panelTrade.setValue('DEST_PORT', Ext.data.StoreManager.lookup('CBS_AU_T008').getAt(0).get('value'));

			if( BsaCodeInfo.gsCreditYn == 'Y')  {
				panelSearch.getField('REMAIN_CREDIT').show();
				panelResult.getField('REMAIN_CREDIT').show();
			} else {
				panelSearch.getField('REMAIN_CREDIT').hide();
				panelResult.getField('REMAIN_CREDIT').show();
			}

			if(BsaCodeInfo.gsAutoType=='Y') {
				panelSearch.getField('ORDER_NUM').setReadOnly(true);
				panelResult.getField('ORDER_NUM').setReadOnly(true);
			} else {
				panelSearch.getField('ORDER_NUM').setReadOnly(false);
				panelResult.getField('ORDER_NUM').setReadOnly(false);
			}

			var billType = panelSearch.getField('BILL_TYPE');
			var orderType = panelSearch.getField('ORDER_TYPE');
			var receiptMeth = panelSearch.getField('RECEIPT_SET_METH');

			billType.select(billType.getStore().getAt(0));
			//판매유형 기본값 삭제(20171215)
//			orderType.select(orderType.getStore().getAt(0));
			receiptMeth.select(receiptMeth.getStore().getAt(0));

			if(BsaCodeInfo.gsDraftFlag=='1')	{
				panelSearch.down('#DraftFields').show();
			} else {
				panelSearch.down('#DraftFields').hide();
			}

//			if(BsaCodeInfo.gsScmUseYN=='Y') {
//				detailGrid.down().down('#scmBtn').show();
//			} else {
//				detailGrid.down().down('#scmBtn').hide();
//			}
			panelSearch.getField('ORDER_O').setReadOnly(true);
			panelSearch.getField('ORDER_TAX_O').setReadOnly(true);
			panelSearch.getField('TOT_ORDER_AMT').setReadOnly(true);
			UniAppManager.app.fnExchngRateO(true);
			gsSaveRefFlag = 'N';
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();

			panelSearch.getField('OFFER_NO').setReadOnly(true);
			panelResult.getField('OFFER_NO').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
		},
		setNationInfoData: function(record, dataClear) {
			panelSearch.setValue('CUSTOM_CODE_TEMP'		,nationSearch.getValue('CUSTOM_CODE'));
			panelSearch.setValue('CUSTOM_NAME_TEMP'		,nationSearch.getValue('CUSTOM_NAME'));
			panelSearch.setValue('DATE_DEPART'			 ,nationSearch.getValue('DATE_DEPART'));
			panelSearch.setValue('DATE_EXP'				,nationSearch.getValue('DATE_EXP'));
			panelSearch.setValue('PAY_METHODE1'			,nationSearch.getValue('PAY_METHODE1'));
			panelSearch.setValue('PAY_TERMS'				,nationSearch.getValue('PAY_TERMS'));
			panelSearch.setValue('PAY_DURING'			  ,nationSearch.getValue('PAY_DURING'));
			panelSearch.setValue('TERMS_PRICE'			 ,nationSearch.getValue('TERMS_PRICE'));
			panelSearch.setValue('COND_PACKING'			,nationSearch.getValue('COND_PACKING'));
			panelSearch.setValue('METH_CARRY'			  ,nationSearch.getValue('METH_CARRY'));
			panelSearch.setValue('METH_INSPECT'			,nationSearch.getValue('METH_INSPECT'));
			panelSearch.setValue('DEST_PORT'				,nationSearch.getValue('DEST_PORT'));
			panelSearch.setValue('DEST_PORT_NM'			,nationSearch.getValue('DEST_PORT_NM'));
			panelSearch.setValue('SHIP_PORT'				,nationSearch.getValue('SHIP_PORT'));
			panelSearch.setValue('SHIP_PORT_NM'			,nationSearch.getValue('SHIP_PORT_NM'));
			panelSearch.setValue('BANK_SENDING'			,nationSearch.getValue('BANK_CODE'));
			//record.set(''					,nationSearch.getValue(''));
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
				"MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
						alert('환율정보가 없습니다.');
					}
					panelSearch.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
					panelResult.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}

			});
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('ORDER_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}

			/**
			 * 여신한도 확인
			 */
			if(!panelSearch.fnCreditCheck()) {
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			panelResult.setAllFieldsReadOnly(true);
			return panelSearch.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue, taxType) {
			var dTransRate= sType=='R' ? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ= sType=='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q'),0);
			var dOrderP= sType=='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0); //단가
			var dOrderO= sType=='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0); //금액
			var dDcRate= sType=='C' ? nValue : Unilite.nvl(rtnRecord.get('DISCOUNT_RATE'),0);

			if(sType == 'P' || sType == 'Q')	{	//업종별 프로세스 적용
				var dOrderUnitQ = 0;
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO = dOrderQ * dOrderP * dTransRate;
				} else {
					dOrderO = dOrderQ * dOrderP;
				}
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_O', dOrderO);
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
				this.fnTaxCalculate(rtnRecord, dOrderO)
			} else if(sType == 'R') {
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			} else if(sType == 'O') {
				if(dOrderQ != 0)	{
					if(BsaCodeInfo.gsProcessFlag == 'PG') {
						dOrderP =dOrderO / (dOrderQ * dTransRate);
					}else {
						dOrderP = dOrderO / dOrderQ;
					}
				}
				rtnRecord.set('ORDER_P', dOrderP);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType)
			} else if(sType == 'C') {
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_P', dOrderP);
				if(BsaCodeInfo.gsProcessFlag == 'PG')	{
					dOrderO = dOrderQ * dOrderP * dTransRate ;
				} else {
					dOrderO = dOrderQ * dOrderP
				}
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType	  = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sTaxInoutType = Ext.getCmp('taxInout').getChecked()[0].inputValue;
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = 0;
			var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
			if(sTaxInoutType=="1") {
				dOrderAmtO = dOrderO;
				dTaxAmtO	= dOrderO * dVatRate / 100
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO,'3', numDigitOfPrice);
				if(UserInfo.compCountry == 'CN') {
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice);							  //세액은 절사처리함.
				} else {
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO, "2", numDigitOfPrice);							  //세액은 절사처리함.
				}
			} else if(sTaxInoutType=="2") {
				dAmountI = dOrderO;
				if(UserInfo.compCountry == 'CN') {
					dTemp	  = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
				} else {
					dTemp	  = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
				}
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
			}
			if(sTaxType == "2") {
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}

			rtnRecord.set('ORDER_O',dOrderAmtO);
			rtnRecord.set('ORDER_TAX_O',dTaxAmtO);
			rtnRecord.set('ORDER_O_TAX_O',dOrderAmtO+dTaxAmtO);
		},
		fnCheckNum: function(value, record, fieldName, fieldLabel) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" )	{
				if(value < 0)	{
					alert(fieldLabel+'은 '+Msg.sMB076);
					r=false;
					return r;
				}else if(value == 0)	{
					if(fieldName == "ORDER_TAX_O")  {
						if(BsaCodeInfo.gsVatRate != 0)  {
							alert(fieldLabel+'은 0보다 큰 값이 입력되어야 합니다.');
							r=false;
						}
					}else {
						alert(fieldLabel+'은 0보다 큰 값이 입력되어야 합니다.');
						r=false;
					}
				}
			}
			return r;
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params)  {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);

			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			if(params.sType=='I')	{

				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {							//단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'B')	{						//단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'C')	{						//단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				}else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}


				//판매단가 적용
				params.rtnRecord.set('ORDER_P',dSalePrice);
				params.rtnRecord.set('ORDER_WGT_P',dWgtPrice);
				params.rtnRecord.set('ORDER_VOL_P',dVolPrice);

				params.rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);

				//단가구분SET  //1:가단가 2:진단가
				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);
//				params.rtnRecord.set('PRICE_TYPE',provider['PRICE_TYPE']);
			}
			//if(params.qty > 0)  UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice);

			if(params.qty > 0 && dSalePrice > 0 )  {
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice)
			}else{
				var dTransRate = Unilite.nvl(params.rtnRecord.get('TRANS_RATE'),1);
				var dOrderQ = Unilite.nvl(params.rtnRecord.get('ORDER_Q'),0);
				var dOrderUnitQ = 0;

				dOrderUnitQ = dOrderQ * dTransRate;
				params.rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			};

		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params)	{
			UniAppManager.app.cbGetPriceInfo(provider, params);
			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnStockQ callback 함수
		cbStockQ: function(provider, params)	{
			var rtnRecord = params.rtnRecord;
			rtnRecord.set('STOCK_Q', provider['STOCK_Q']);

			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = rtnRecord.get('TRANS_RATE');

			if(!Ext.isEmpty(rtnRecord.get('STOCK_Q')))  {
				dStockQ = rtnRecord.get('STOCK_Q');
			}

			if(!Ext.isEmpty(rtnRecord.get('ORDER_Q')))  {
				dOrderQ = rtnRecord.get('ORDER_Q');
			}

			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	//'재고량 > 수주량
					rtnRecord.set('PROD_SALE_Q'	 ,0);
					rtnRecord.set('PROD_Q'	  ,0);
					rtnRecord.set('PROD_END_DATE'		,'');
//					rtnRecord.set('EXP_ISSUE_DATE'		,'');
				} else {
					if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
						rtnRecord.set('PROD_SALE_Q'	 ,0);
						rtnRecord.set('PROD_Q'	  ,0);
						rtnRecord.set('PROD_END_DATE'		,'');
//						rtnRecord.set('EXP_ISSUE_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )  {
							rtnRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));
							rtnRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );
							rtnRecord.set('PROD_END_DATE'	, UniDate.add(rtnRecord.get('DVRY_DATE'), {days: -1}));
							rtnRecord.set('EXP_ISSUE_DATE'	, rtnRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
						rtnRecord.set('PROD_SALE_Q'	 ,0);
						rtnRecord.set('PROD_Q'	  ,0);
						rtnRecord.set('PROD_END_DATE'		,'');
//						rtnRecord.set('EXP_ISSUE_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )  {
							rtnRecord.set('PROD_SALE_Q'	 ,dOrderQ);
							rtnRecord.set('PROD_Q'		  ,(dOrderQ * lTrnsRate ) );

						}
					}
			}

			if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
				var dProdtQ = 0;
				if(!Ext.isEmpty(rtnRecord.get('PROD_SALE_Q')))  {
					dProdtQ = rtnRecord.get('PROD_SALE_Q');
				}

				if(dProdtQ > 0) {
					rtnRecord.set('PROD_END_DATE'		,UniDate.add(rtnRecord.get('DVRY_DATE'), {days: -1}));
					rtnRecord.set('EXP_ISSUE_DATE'		,rtnRecord.get('DVRY_DATE'));
				}

			}
			rtnRecord.set('PRICE_YN'		,provider['PRICE_TYPE']);

		},
		fnGetCustCredit: function(divCode, customCode, sDate, moneyUnit){
			var param = {"DIV_CODE": divCode, "CUSTOM_CODE": customCode, "SALE_DATE": sDate, "MONEY_UNIT": moneyUnit}
			s_sof100ukrv_ypService.getCustCredit(param, function(provider, response) {
				var credit = Ext.isEmpty(provider[0]['CREDIT'])? 0 : provider[0]['CREDIT'];
				panelSearch.setValue('REMAIN_CREDIT', credit);
				panelResult.setValue('REMAIN_CREDIT', credit);
			});
		}
	});

	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUT_DIV_CODE" :
					var itemCode = record.get('ITEM_CODE');
					if(itemCode != "")  {
						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response)  {
															if(Ext.isEmpty(provider))	{
																alert(Msg.sMS288);
																Ext.getBody().unmask();
															} else {
																console.log("provider",provider)
																if(!Ext.isEmpty('provider')) detailGrid.setItemData(provider[0],false);
																else detailGrid.setItemData(null, true);

															}
														});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  record.get("DIV_CODE") = newValue;

					break;

				case "ORDER_UNIT" :

					UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
													, 'I'
													, UserInfo.compCode
													, panelSearch.getValue('CUSTOM_CODE')
													, CustomCodeInfo.gsAgentType
													, record.get('ITEM_CODE')
													, BsaCodeInfo.gsMoneyUnit
													, newValue
													, record.get('STOCK_UNIT')
													, record.get('TRANS_RATE')
													, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
													, record.get('ORDER_Q')
													, record.get('WGT_UNIT')
													, record.get('VOL_UNIT')
													, record.get('UNIT_WGT')
													, record.get('UNIT_VOL')
													, record.get('PRICE_TYPE')
													);

					UniAppManager.app.fnOrderAmtCal(record, "R");

					break;
				case "PRICE_YN" :
//					UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
//													, 'I'
//													, UserInfo.compCode
//													, panelSearch.getValue('CUSTOM_CODE')
//													, CustomCodeInfo.gsAgentType
//													, record.get('ITEM_CODE')
//													, BsaCodeInfo.gsMoneyUnit
//													, record.get('ORDER_UNIT')
//													, record.get('STOCK_UNIT')
//													, record.get('TRANS_RATE')
//													, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
//													, record.get('ORDER_Q')
//													, record.get('WGT_UNIT')
//													, record.get('VOL_UNIT')
//													, record.get('UNIT_WGT')
//													, record.get('UNIT_VOL')
//													, newValue
//													);
//					UniAppManager.app.fnOrderAmtCal(record, "P");
//					detailStore.fnOrderAmtSum();
//					record.set('DISCOUNT_RATE', 0);
					break;
				case "TRANS_RATE" :
					if(newValue <= 0)	{
						rv=Msg.sMB076;
						record.set('TRANS_RATE',oldValue);
						break
					}
					UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
											,'R'
											,UserInfo.compCode
											,panelSearch.getValue('CUSTOM_CODE')
											,CustomCodeInfo.gsAgentType
											,record.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,record.get('ORDER_UNIT')
											,record.get('STOCK_UNIT')
											,newValue
											,UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
											,record.get('ORDER_Q')
											, record.get('WGT_UNIT')
											, record.get('VOL_UNIT')
											, record.get('UNIT_WGT')
											, record.get('UNIT_VOL')
											, record.get('PRICE_TYPE')
											)
					UniAppManager.app.fnOrderAmtCal(record, "R", newValue);
					break;

				case "ORDER_Q" :
					if(newValue <= 0)	{
						rv=Msg.sMB076;
						record.set('ORDER_Q',oldValue);
						break
					}

					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
						record.set('ORDER_Q',oldValue, fieldName);
						break;
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q')))	dStockQ = record.get('STOCK_Q');
					if(Ext.isNumeric(record.get('ORDER_Q')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q'	, 0);
							record.set('PROD_Q'			, 0);
							record.set('PROD_END_DATE'	, '');
//							record.set('EXP_ISSUE_DATE'	, '');
						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ = (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ = (dOrderQ * lTrnsRate - dStockQ)
							record.set('PROD_SALE_Q', dProdSaleQ);
							record.set('PROD_Q', dProdQ);
							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE'	, '');
//								record.set('EXP_ISSUE_DATE'	, '');
							} else {
								record.set('PROD_END_DATE'	, UniDate.add(record.get('DVRY_DATE'), {days: -1}));
								record.set('EXP_ISSUE_DATE'	, record.get('DVRY_DATE'));
							}
						}
					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q', dOrderQ);
						record.set('PROD_Q', dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue);
					detailStore.fnOrderAmtSum();
					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE'	, UniDate.add(record.get('DVRY_DATE'), {days: -1}));
							record.set('EXP_ISSUE_DATE'	, record.get('DVRY_DATE'));
						}
					}else{
						record.set('PROD_END_DATE'	, UniDate.add(record.get('DVRY_DATE'), {days: -1}));
						record.set('EXP_ISSUE_DATE'	, record.get('DVRY_DATE'));
					}

					break;

				case "ORDER_P" :
					if(oldValue != newValue) {
						if(newValue <= 0)	{
							rv=Msg.sMB076;
							record.set('ORDER_P',oldValue);
							break
						}

						if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'개별단가') )  {
							record.set('ORDER_P',oldValue);
							break;
						}
						UniAppManager.app.fnOrderAmtCal(record, "P", newValue)
						detailStore.fnOrderAmtSum();
						record.set('DISCOUNT_RATE', 0);
					}
					break;

				case "ORDER_O" :
					rv = true;
					if(oldValue != newValue) {
						if(newValue <= 0)	{
							rv=Msg.sMB076;
							record.set('ORDER_O',oldValue);
							rv = false;
							break
						}
						if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS681" default="금액"/>') )	{
							record.set('ORDER_O',oldValue);
							rv = false;
							break;
						}
						var dTaxAmtO = Unilite.nvl(record.get('ORDER_TAX_O'),0);
						if(newValue > 0 && dTaxAmtO > newValue)	 {
							rv=Msg.sMS224;
						}else {
							UniAppManager.app.fnOrderAmtCal(record, "O", newValue);
							detailStore.fnOrderAmtSum();
						}
					}
					break;

				case "DISCOUNT_MONEY" :



				case "TAX_TYPE" :

					if(panelSearch.getValue('BILL_TYPE')=="50")  {
						rv=Msg.sMS313;
						record.set('TAX_TYPE', '2');
					}


					//업종별 프로세스 적용
					if(BsaCodeInfo.gsProcessFlag == 'PG')	{
						var dOrderO=record.get('ORDER_Q')*record.get('ORDER_P')*record.get('TRANS_RATE');
						record.set('ORDER_O', dOrderO);
					}else {
						var dOrderO=record.get('ORDER_Q')*record.get('ORDER_P');
						record.set('ORDER_O', dOrderO);
					}

					UniAppManager.app.fnOrderAmtCal(record, "O", dOrderO, newValue);
					detailStore.fnOrderAmtSum();

					break;

				case "ORDER_TAX_O" :
					if(newValue <= 0)	{
						rv=Msg.sMB076;
						record.set('ORDER_TAX_O',oldValue);
						break
					}

					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName, '<t:message code="unilite.msg.sMS764" default="부가세액"/>')) {
						record.set('ORDER_TAX_O', oldValue);
					}
					var dSaleAmtO = Unilite.nvl(record.get('ORDER_O'),0);
					if(dSaleAmtO > 0)	{
						if( dSaleAmtO < newValue)	{
							rv=Msg.sMS226;
							break;
						}
					}
					var dOrderOTaxO = record.get('ORDER_O')+record.get('ORDER_TAX_O');
					record.set('ORDER_O_TAX_O', dOrderOTaxO);
					detailStore.fnOrderAmtSum();
					break;

				case "DVRY_DATE" :
					if(newValue < panelSearch.getValue('ORDER_DATE')) {
						rv = Msg.sMS217;
						break;
					}
					var dvryDate = UniDate.getDbDateStr(newValue);
					if(dvryDate.length == 8) {
						if(Ext.isNumeric(record.get('PROD_SALE_Q')) && record.get('PROD_SALE_Q')==0)	{
							record.set('PROD_END_DATE'	, '');
//							record.set('EXP_ISSUE_DATE'	, '');
						}else {
							record.set('PROD_END_DATE'	, UniDate.add(newValue, {days: -1}));
							record.set('EXP_ISSUE_DATE'	, newValue);
						}
					}
					break;

				case "DISCOUNT_RATE" :
					if(newValue < 0)	{
						rv=Msg.sMB076;
						record.set('DISCOUNT_RATE', oldValue);
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, "C", newValue);
					detailStore.fnOrderAmtSum();
					break;

				case "ACCOUNT_YNC" :
					if(record.phantom && !Ext.isEmpty(record.get('PRE_ACCNT_YN')))  {
						if(newValue != record.get('PRE_ACCNT_YN'))  {
							if(confirm(Msg.sMS251+'/n'+Msg.sMS357)) {
								record.set('REF_FLAG', newValue);
							}else {
								record.set('REF_FLAG', 'F');
							}
						}else {
							record.set('REF_FLAG', 'F');
						}
					}

					break;

				case "PROD_SALE_Q" :
					if(!Ext.isEmpty(record.get('PROD_END_DATE')))	{
						if(Ext.isEmpty(newValue) || newValue == 0)  {
							rv=Msg.sMB083;
						}
						break;
					}

					var lTrnsRate = record.get("TRANS_RATE");
					var chkValue=0;
					var dProdQ=0;

					if(newValue  < 0 )  {
						rv = Msg.sMB076;
						record.set('PROD_SALE_Q', oldValue);
						if(Ext.isEmpty(oldValue))	oldValue = 0;
						record.set('PROD_Q', (oldValue*lTrnsRate));
						break;
					}

					if(!Ext.isNumeric(newValue) || newValue==0) {
						record.set('PROD_END_DATE'	,'');
//						record.set('EXP_ISSUE_DATE'	,'');
						record.set('PROD_SALE_Q'	,0);
						record.set('PROD_Q'			,0);
					}else {
						record.set('PROD_END_DATE'	, UniDate.add(record.get('DVRY_DATE'), {days: -1}));
						record.set('EXP_ISSUE_DATE'	, record.get('DVRY_DATE'));
						record.set('PROD_Q'			,(newValue*lTrnsRate) );
					}
					break;

				case "PROD_END_DATE" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE', oldValue);
						break;
					}

					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
						rv = Msg.sMS217;
						record.set('PROD_END_DATE', oldValue);
						break;
					}

					if(newValue > record.get('DVRY_DATE'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE', oldValue);
						break;
					}
					break;

				case "EXP_ISSUE_DATE" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE', oldValue);
						break;
					}

					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
						rv = Msg.sMS217;
						record.set('EXP_ISSUE_DATE', oldValue);
						break;
					}

					if(newValue > record.get('DVRY_DATE'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE', oldValue);
						break;
					}
					if(Ext.isNumeric(record.get('PROD_SALE_Q')) && record.get('PROD_SALE_Q')==0)	{
						record.set('PROD_END_DATE'	, '');
					}else {
						record.set('PROD_END_DATE'	, UniDate.add(newValue, {days: -1}));
					}
					break;
				case "GOODS_DIVISION" :	//20210913 jhj:컬럼추가
				debugger;
					break;
				case "CUSTOM_ITEM_NAME" :
					if(Ext.isEmpty(record.get('ITEM_CODE'))) {
						var param = {
							"DIV_CODE"			: panelSearch.getValue('DIV_CODE'),
							"CUSTOM_CODE"		: panelSearch.getValue('CUSTOM_CODE'),
							"CUSTOM_ITEM_NAME"	: newValue
						}
						s_sof100ukrv_ypService.getItemCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								detailGrid.setItemData(provider, false, detailGrid.getSelectedRecord());
							} else {
								detailGrid.setItemData(null,true, detailGrid.getSelectedRecord());
							}
						});
					}
					break;
			}
			return rv;
		}
	}); // validator
}
</script>
