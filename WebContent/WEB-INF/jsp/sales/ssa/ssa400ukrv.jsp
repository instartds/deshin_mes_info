<%--
'   프로그램명 : 매출등록 (영업)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa400ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa400ukrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />						<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A"/>							<!-- 출고창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>						<!-- 수불타입 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S065"/>						<!-- 주문구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

var BsaCodeInfo = {
	gsCreditYn		: '${gsCreditYn}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: ${gsVatRate},
	gsInvStatus		: '${gsInvStatus}',
	gsOptDivCode	: '${gsOptDivCode}',
	gsProcessFlag	: '${gsProcessFlag}',
	gsBusiPrintYN	: '${gsBusiPrintYN}',
	gsBusiPrintPgm	: '${gsBusiPrintPgm}',
	gsMoneyExYn		: '${gsMoneyExYn}',
	gsAdvanUseYn	: '${gsAdvanUseYn}',
	gsPointYn		: '${gsPointYn}',
	gsUnitChack		: '${gsUnitChack}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsCustManageYN	: '${gsCustManageYN}',
	gsPrsnManageYN	: '${gsPrsnManageYN}',
	grsOutType		: ${grsOutType},
	gsSaleAutoYN	: '${gsSaleAutoYN}',
	grsSalePrsn		: ${grsSalePrsn}
};

/*var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxCalType	: '',
	gsRefTaxInout	: ''
};*/

function appMain() {
	var isCreditYn = false;
	if(BsaCodeInfo.gsCreditYn != 'Y'){
		isCreditYn = true;
	}

	//자동채번 여부
	var isAutoBillNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoBillNum = true;
	}

	var isCustManageYN = false;
	if(BsaCodeInfo.gsCustManageYN=='N') {
		isCustManageYN = true;
	}

	var isPrsnManageYN = false;
	if(BsaCodeInfo.gsPrsnManageYN=='N') {
		isPrsnManageYN = true;
	}

	var gsLastDay;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa400ukrvService.selectDetailList',
			update	: 'ssa400ukrvService.updateDetail',
			create	: 'ssa400ukrvService.insertDetail',
			destroy	: 'ssa400ukrvService.deleteDetail',
			syncAll	: 'ssa400ukrvService.saveAll'
		}
	});

	//마스터 폼
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,	tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
//			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.maintenance" default="유지보수"/>',
				name		: 'ENTRY_YN',
				itemId		: 'ENTRY_YN',
//				holdable	: 'hold',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.nonentry" default="미등록"/>',
					name		: 'ENTRY_YN',
					inputValue	: 'N',
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.entry" default="등록"/>',
					name		: 'ENTRY_YN',
					inputValue	: 'Y',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.ENTRY_YN == 'Y') {
							masterGrid.getColumn('BILL_NUM').setHidden(false);
							masterGrid.getColumn('BILL_SEQ').setHidden(false);

						} else {
							masterGrid.getColumn('BILL_NUM').setHidden(true);
							masterGrid.getColumn('BILL_SEQ').setHidden(true);
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesmonth" default="매출월"/>',
			name		: 'SALE_YM',
			xtype		: 'uniMonthfield',
			value		: new Date(),
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					fnGetLastDay(newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('SALE_CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			xtype: 'component',
			width: 30
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			width	: 300,
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.billingdate" default="청구일"/>',
				name		: 'CHARGE_FR_DAY',
				xtype		: 'uniNumberfield',
				width		: 155,
				value		: 1,
//				readOnly	: true,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts)	{
					}
				}
			},{
				xtype	: 'component',
				html	: '~',
				width	: 20,
				padding	: '0 0 0 5',
				style	: {
					marginTop	: '3px !important',
					font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '',
				name		: 'CHARGE_TO_DAY',
				xtype		: 'uniNumberfield',
				allowBlank	: false,
				width		: 55,
				value		: UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8),
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts)	{
						if (!Ext.isEmpty(panelResult.getValue('CHARGE_FR_DAY'))) {
							var minSeq = panelResult.getValue('CHARGE_FR_DAY')
							if(panelResult.getValue('CHARGE_TO_DAY') < minSeq) {
								Unilite.messageBox('<t:message code="system.message.sales.message135" default="앞의 날짜 보다 크거나 같은 날짜를 입력하세요."/>');
								this.setValue(UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8));
								return false;
							}
							if(panelResult.getValue('CHARGE_TO_DAY') > gsLastDay) {
								Unilite.messageBox(gsLastDay + '<t:message code="system.message.sales.message134" default="일 이하의 날짜을 입력하세요."/>');
								this.setValue(UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8));
								return false;
							}
						}
					}
				}
			},{
				fieldLabel	: '',
				name		: 'VAT_RATE',
				xtype		: 'uniNumberfield',
				allowBlank	: false,
				hidden		: true,
				value		: parseInt(BsaCodeInfo.gsVatRate),
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts)	{
					}
				}
			}
		]}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
			}
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
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
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{

	//마스터 모델
	Unilite.defineModel('Ssa101ukrvModel',{
		fields: [
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			, type: 'uniDate'},
			{name: 'CHUNGGU_CNT'		, text: '<t:message code="system.label.sales.numberofbilling" default="청구회차"/>'		, type: 'int', allowBlank: false},
			{name: 'REMAIN_CHUNGGU_CNT'	, text: '<t:message code="system.label.sales.remainingcount" default="잔여회차"/>'		, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'		, type: 'uniPrice', defaultValue: '0', allowBlank: false},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniPrice', defaultValue: '0', allowBlank: true},
			{name: 'ORDER_O_TAX_O'		, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'			, type: 'uniPrice', defaultValue: '0', editable: false},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>'		, type: 'string'},	//SCN100T.CONT_NUM
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int'},	//SCN100T.CONT_SEQ
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false},
			/* hiiden, ref 필드 - SELECT 된 필드*/
			{name: 'DIV_CODE'			, text: 'DIV_CODE'				, type: 'string',comboType: "BOR120", allowBlank: false},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'		, type: 'string', comboType: 'BOR120', allowBlank: false},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				, type: 'uniQty', defaultValue: '0'},
			{name: 'SALE_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'					, type: 'uniUnitPrice', defaultValue: '0'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			, type: 'string',comboType: 'AU', comboCode: 'S002', allowBlank: false},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			, type: 'string',comboType: 'AU', comboCode: 'S024', allowBlank: false},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'			, type: 'string'},	//'2'
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'		, type: 'string',comboType:'AU', comboCode: 'B059', allowBlank: false},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'			, type: 'int'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string',comboType:'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'		, type: 'string'},
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'			, type: 'string' , defaultValue: '2',comboType:'AU', comboCode: 'S003', allowBlank: false},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'				, type: 'string'},
			{name: 'BILL_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int'},
			/* hiiden, ref 필드 - SELECT 안 된 필드*/
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			, type: 'uniQty', defaultValue: '1', allowBlank: false},
			{name: 'DISCOUNT_RATE'		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'		, type: 'uniPercent', defaultValue: '0'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.sales.inventoryqty" default="재고량"/>'			, type: 'uniQty', defaultValue: '0', editable: false},
			{name: 'DVRY_CUST_CD'		, text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'	, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			, type: 'uniDate', allowBlank: true},
			{name: 'PUB_NUM'			, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				, type: 'string'},
			{name: 'SALE_LOC_AMT_I'		, text: 'SALE_LOC_AMT_I'		, type: 'uniPrice', defaultValue: '0'},
			{name: 'SER_NO'				, text: 'SER_NO'				, type: 'int'},
			{name: 'STOCK_UNIT'			, text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'ITEM_STATUS'		, text: 'ITEM_STATUS'			, type: 'string', defaultValue: '1'},
			{name: 'ACCOUNT_YNC'		, text: 'ACCOUNT_YNC'			, type: 'string', defaultValue: 'Y'},
			{name: 'ORIGIN_Q'			, text: 'ORIGIN_Q'				, type: 'uniQty', defaultValue: '0'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string',comboType:'AU', comboCode: 'S010'},
			{name: 'REF_CUSTOM_CODE'	, text: 'REF_CUSTOM_CODE'		, type: 'string'},
			{name: 'REF_SALE_DATE'		, text: 'REF_SALE_DATE'			, type: 'uniDate'},
			{name: 'REF_BILL_TYPE'		, text: 'REF_BILL_TYPE'			, type: 'string'},
			{name: 'REF_CARD_CUST_CD'	, text: 'REF_CARD_CUST_CD'		, type: 'string'},
			{name: 'REF_SALE_TYPE'		, text: 'REF_SALE_TYPE'			, type: 'string'},
			{name: 'REF_REMARK'			, text: 'REF_REMARK'			, type: 'string'},
			{name: 'REF_EX_NUM'			, text: 'REF_EX_NUM'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: 'MONEY_UNIT'			, type: 'string'},
			{name: 'REF_EXCHG_RATE_O'	, text: 'REF_EXCHG_RATE_O'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'			, type: 'string'},
			{name: 'UNSALE_Q'			, text: 'UNSALE_Q'				, type: 'string', defaultValue: '0'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'SRC_CUSTOM_CODE'	, text: 'SRC_CUSTOM_CODE'		, type: 'string'},
			{name: 'SRC_CUSTOM_NAME'	, text: 'SRC_CUSTOM_NAME'		, type: 'string'},
			{name: 'SRC_ORDER_PRSN'		, text: 'SRC_ORDER_PRSN'		, type: 'string'},
			{name: 'REF_CODE2'			, text: 'REF_CODE2'				, type: 'string'},
			{name: 'SOF110T_ACCOUNT_YNC', text: 'SOF110T_ACCOUNT_YNC'   , type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string', allowBlank: false},
			{name: 'INOUT_CUSTOM_CODE'	, text: 'INOUT_CUSTOM_CODE'		, type: 'string'},
			{name: 'INOUT_CUSTOM_NAME'	, text: 'INOUT_CUSTOM_NAME'		, type: 'string'},
			{name: 'INOUT_AGENT_TYPE'	, text: 'INOUT_AGENT_TYPE'		, type: 'string'},
			{name: 'ADVAN_YN'			, text: 'ADVAN_YN'				, type: 'string'},
			{name: 'TAX_IN_OUT'			, text: 'TAX_IN_OUT'			, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: 'TAX_CALC_TYPE'			, type: 'string'},
			{name: 'SAVE_FLAG'			, text: 'SAVE_FLAG'				, type: 'string'},
			//20200131 프로젝트코드 / 명 추가
			{name: 'PROJECT_NO'			, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false}
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa101ukrvDetailStore',{
		model	: 'Ssa101ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			param.ENTRY_YN	= panelResult.getValue('ENTRY_YN').ENTRY_YN;

			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			// 1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			if((inValidRecs.length == 0)) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						// 3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						detailStore.loadStoreRecords();

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ssa400ukrvGrid');
				if(!Ext.isEmpty(inValidRecs)){
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);}
				// Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
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

	// 마스터 그리드
	var masterGrid = Unilite.createGrid('ssa400ukrvGrid',{
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			copiedRow			: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false ,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var proccessGubun = panelResult.getValue('ENTRY_YN').ENTRY_YN;
					if(proccessGubun == 'N') {
						selectRecord.set('SAVE_FLAG', 'N');
					} else {
						selectRecord.set('SAVE_FLAG', 'D');
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SAVE_FLAG', '');
				}
			}
		}),
		columns	: [
			{dataIndex: 'CUSTOM_CODE'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'			, width: 200},
			{dataIndex: 'SALE_DATE'				, width: 80	},
			{dataIndex: 'CHUNGGU_CNT'			, width: 80	},
			{dataIndex: 'REMAIN_CHUNGGU_CNT'	, width: 80	},
			{dataIndex: 'ITEM_CODE'				, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = masterGrid.uniOpt.currentRecord;
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 200,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										if(i==0) {
											masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
										}
									});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = masterGrid.uniOpt.currentRecord;
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SALE_AMT_O'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT_O'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'ORDER_O_TAX_O'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'				, width: 120},
			{dataIndex: 'ORDER_SEQ'				, width: 100, hidden: false, align:'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 100, hidden: false, align:'center'},
			/* hiiden, ref 필드 - SELECT 된 필드*/
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true},
			{dataIndex: 'OUT_DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'SALE_Q'				, width: 100, hidden: false, summaryType: 'sum'},
			{dataIndex: 'SALE_P'				, width: 120, hidden: true, summaryType: 'sum'},
			{dataIndex: 'ORDER_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'BILL_TYPE'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'TAX_TYPE'				, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'INOUT_NUM'				, width: 120, hidden: true},
			{dataIndex: 'INOUT_SEQ'				, width: 100, hidden: true, align:'center'},
			{dataIndex: 'SALE_UNIT'				, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},
			{dataIndex: 'PRICE_YN'				, width: 100, hidden: true, align:'center'},
			{dataIndex: 'BILL_NUM'				, width: 120, hidden: true},
			{dataIndex: 'BILL_SEQ'				, width: 100, hidden: true, align:'center'},
			/* hiiden, ref 필드 - SELECT 안 된 필드*/
			{dataIndex: 'TRANS_RATE'			, width: 100, hidden: true},
			{dataIndex: 'LOT_NO'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_DATE'			, width: 100, hidden: true},
			{dataIndex: 'PUB_NUM'				, width: 120, hidden: true},
			{dataIndex: 'SALE_LOC_AMT_I'		, width: 100, hidden: true},
			{dataIndex: 'STOCK_UNIT'			, width: 100, hidden: true},
			{dataIndex: 'ITEM_STATUS'			, width: 100, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			, width: 100, hidden: true},
			{dataIndex: 'ORIGIN_Q'				, width: 100, hidden: true},
			{dataIndex: 'SALE_PRSN'				, width: 100, hidden: true},
			{dataIndex: 'REF_CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'REF_SALE_DATE'			, width: 100, hidden: true},
			{dataIndex: 'REF_BILL_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'REF_CARD_CUST_CD'		, width: 100, hidden: true},
			{dataIndex: 'REF_SALE_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'REF_REMARK'			, width: 100, hidden: true},
			{dataIndex: 'REF_EX_NUM'			, width: 100, hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width: 100, hidden: true},
			{dataIndex: 'REF_EXCHG_RATE_O'		, width: 100, hidden: true},
			{dataIndex: 'STOCK_CARE_YN'			, width: 100, hidden: true},
			{dataIndex: 'UNSALE_Q'				, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true},
			{dataIndex: 'SRC_CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SRC_CUSTOM_NAME'		, width: 133, hidden: true},
			{dataIndex: 'SRC_ORDER_PRSN'		, width: 100, hidden: true},
			{dataIndex: 'REF_CODE2'				, width: 100, hidden: true},
			{dataIndex: 'SOF110T_ACCOUNT_YNC'	, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_CUSTOM_NAME'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_AGENT_TYPE'		, width: 100, hidden: true},
			{dataIndex: 'ADVAN_YN'				, width: 100, hidden: true},
			{dataIndex: 'TAX_IN_OUT'			, width: 100, hidden: true},
			{dataIndex: 'TAX_CALC_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'SAVE_FLAG'				, width: 100, hidden: true},
			//20200131 프로젝트코드 / 명 추가,
			{dataIndex: 'PROJECT_NO'			, width: 100,
				editor: Unilite.popup('PROJECT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('PROJECT_NO'	, record['PJT_CODE']);
										grdRecord.set('PJT_NAME'	, record['PJT_NAME']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROJECT_NO'	, '');
							grdRecord.set('PJT_NAME'	, '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'PJT_NAME'				, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, [/*"ITEM_CODE", "ITEM_NAME", */"SALE_AMT_O", "SALE_Q"/*, "TAX_AMT_O"*/
											//20200131 추가
											, 'PROJECT_NO'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('SALE_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('WH_CODE'			,"");
				grdRecord.set('TAX_TYPE'		,"1");
				grdRecord.set('TRANS_RATE'		,1);
				grdRecord.set('DISCOUNT_RATE'	,0);
				//20190802 금액 계산부분 주석 - 고정
//				grdRecord.set('SALE_Q'			,0);
//				grdRecord.set('SALE_P'			,0);
//				grdRecord.set('SALE_AMT_O'		,0);
//				grdRecord.set('TAX_AMT_O'		,0);
			} else {
				var sRefCode2 = grdRecord.get('REF_CODE2');
				var sTrRate = record['TRNS_RATE'];

				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('SALE_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);

				if(Ext.isEmpty(grdRecord.get('WH_CODE'))){
					grdRecord.set('WH_CODE'		, record['WH_CODE']);
				}

				if(panelResult.getValue('BILL_TYPE') != "50"){
					grdRecord.set('TAX_TYPE'	, record['TAX_TYPE']);
				}else{
					grdRecord.set('TAX_TYPE'	, "2");
				}
				grdRecord.set('STOCK_CARE_YN'	, 'N');

				//20190802 금액 계산부분 주석 - 고정
/*				if(sRefCode2 != "94" && sRefCode2 != "<AU>"){
					grdRecord.set('STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
					UniSales.fnGetPriceInfo(grdRecord, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,panelResult.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,grdRecord.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,grdRecord.get('SALE_UNIT')
												,grdRecord.get('STOCK_UNIT')
												,record['TRNS_RATE']
												,UniDate.getDbDateStr(panelResult.getValue('SALE_DATE'))
												)
				}else{
					grdRecord.set('STOCK_CARE_YN'	, 'N');
				}*/
			}
		}
	});







	Unilite.Main( {
		id			: 'ssa400ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['newData']	, false);
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ENTRY_YN'			, 'N');
			panelResult.setValue('SALE_YM'			, new Date());
			panelResult.setValue('CHARGE_FR_DAY'	, 1);
			panelResult.setValue('CHARGE_TO_DAY'	, UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8));
			panelResult.setValue('VAT_RATE'			, parseInt(BsaCodeInfo.gsVatRate));

			fnGetLastDay(new Date());

			//거래처 정보
//			CustomCodeInfo.gsAgentType		= '';
//			CustomCodeInfo.gsCustCreditYn	= '';
//			CustomCodeInfo.gsUnderCalBase	= '';
//			CustomCodeInfo.gsTaxCalType		= '';
//			CustomCodeInfo.gsRefTaxInout	= '';

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);

			//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.Price);
			//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',6);
			masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			panelResult.setAllFieldsReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		}/*,	//20190802 주석 - 계산로직 일반적인 부분과 다름
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('SALE_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			if(panelResult.uniOpt.inLoading)
				return;
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		},
		// UniSales.fnGetPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			if(params.sType=='I') {
				params.rtnRecord.set('SALE_P', dSalePrice);
				params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
			}

			if(params.rtnRecord.get('SALE_Q') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType) {
			var dOrderQ		= fieldName=='SALE_Q'			? nValue : Unilite.nvl(rtnRecord.get('SALE_Q'),0);
			var dOrderP		= fieldName=='SALE_P'			? nValue : Unilite.nvl(rtnRecord.get('SALE_P'),0);
			var dOrderO		= fieldName=='SALE_AMT_O'		? nValue : Unilite.nvl(rtnRecord.get('SALE_AMT_O'),0);
			var dTransRate	= fieldName=='TRANS_RATE'		? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dDcRate		= fieldName=='DISCOUNT_RATE'	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);

			if(sType == "P" || sType == "Q"){	//단가 수량 변경시
				dOrderO = dOrderQ * dOrderP
				rtnRecord.set('SALE_AMT_O', dOrderO);
				rtnRecord.set('SALE_LOC_AMT_I', dOrderO * panelResult.getValue('EXCHG_RATE_O'));
//				this.fnTaxCalculate(rtnRecord, dOrderO);
//			}else if(sType == "O"){ //금액 변경시
//				if(dOrderQ > 0){
//					if(rtnRecord.get('ADVAN_YN') != "Y"){
//						dOrderP = dOrderO / dOrderQ;
//					}
//					rtnRecord.set('SALE_P', dOrderP);
//					if(rtnRecord.get('ADVAN_YN') == "Y"){	//수주참조(선매출)탭에서 참조해온 데이터만 금액변경시 매출량 변경토록
//						dOrderQ = (rtnRecord.get('SALE_AMT_O') / rtnRecord.get('SALE_P')) * dOrderQ;
//					}
//				}
//				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
//			}
//		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType 	 = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sTaxInoutType = rtnRecord.get('REF_TAX_INOUT');
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);

			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = dOrderO;
			var dTemp = 0;
			var sWonCalBas = CustomCodeInfo.gsUnderCalBase;
			//20190624 화폐단위 관련로직 추가
			if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");

			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO = dOrderO;
				dTaxAmtO = dOrderO * dVatRate / 100
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);

				if(UserInfo.currency == "CN"){
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice);
				}else{
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
				}
			}else if(sTaxInoutType=="2") {	//포함
				dAmountI = dOrderO;
				if(UserInfo.currency == "CN"){
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "3", numDigitOfPrice)
				}else{
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI - dTaxAmtO, sWonCalBas, numDigitOfPrice);

			}
			if(sTaxType == "2") {	//면세
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}
			rtnRecord.set('SALE_AMT_O'		, dOrderAmtO);	//금액
			rtnRecord.set('SALE_LOC_AMT_I'	, dOrderAmtO * rtnRecord.get('EXCHG_RATE_O'));
			rtnRecord.set('TAX_AMT_O'		, dTaxAmtO);	//부가세액
			rtnRecord.set('ORDER_O_TAX_O'	, dOrderAmtO + dTaxAmtO);	//매출계
		}*/
	});// End of Unilite.Main( {


	function fnGetLastDay(newValue) {
		if(newValue.getFullYear) {
			gsLastDay = new Date(newValue.getFullYear(), newValue.getMonth()+1, 0).getDate();
		}
	}
	//Validation
	Unilite.createValidator('validator01',{
		store	: detailStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ',{'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(record.phantom && Ext.isEmpty(record.get('REF_EX_NUM')) && record.get('REF_EX_NUM' != "0")){//신규일때
				rv = '<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>';	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다.
			}else if(record.phantom && Ext.isEmpty(record.get('PUB_NUM'))){
				rv = '<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>';	//계산서가 발행된 건은 삭제할 수 없습니다.
			}else{
				switch(fieldName) {
					case "SALE_AMT_O" :
						var dTaxAmtO	= record.get('TAX_AMT_O');
						var dOrderOTaxO	= record.get('ORDER_O_TAX_O');

						if(newValue > dOrderOTaxO) {
							rv = '<t:message code="system.message.sales.message133" default="공급가액은 총액보다 작아야 합니다."/>';
							break;
						}

						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
							break;
						}

						if(newValue > 0){
							if(dTaxAmtO > newValue){
								rv = '<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>'; //매출금액은 세액보다 커야 합니다.
								break;
							}
						}else{
							if(dTaxAmtO < newValue){
								rv = '<t:message code="system.message.sales.message083" default="매출금액은 세액보다 작아야 합니다."/>' //매출금액은 세액보다 작아야 합니다.
								break;
							}
						}

						record.set('SALE_LOC_AMT_I'	, newValue);
						record.set('TAX_AMT_O'		, dOrderOTaxO - newValue);	//부가세액

//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
						break;

					case "TAX_AMT_O" :			//부가세액
						var dSaleAmtO = 0;
						var sRefCode2 = record.get('REF_CODE2');
						if(sRefCode2 == "94" || sRefCode2 == "95"){ //'에누리/반품환입
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv =  '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';	//음수만 입력 가능합니다.
								break;
							}
						}else if(sRefCode2 == "AU"){ //금액보정
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						}else{
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						}

						if(record.get('ACCOUNT_YNC') == "N"){	//미매출대상인 경우
							if(newValue != 1){
								rv = '<t:message code="system.message.sales.message081" default="매출대상이 NO 인 경우, 숫자 0만 입력가능합니다."/>'; //매출대상이 'NO'인 경우, 숫자 0만 입력가능합니다.
								break;
							}
							record.set('SALE_AMT_O', 0);
							record.set('SALE_LOC_AMT_I', 0);
							record.set('SALE_P', 0);
						}else{
							dSaleAmtO = record.get('SALE_AMT_O');
							if(record.get('TAX_TYPE')  == "2"){
								if(newValue != 0){
									rv = '<t:message code="system.message.sales.message084" default="과세구분이 면세인 경우, 부가세액은 0입니다."/>'; //과세구분이 면세인 경우, 부가세액은 0입니다.
									break;
								}
							}else{
								if(dSaleAmtO > 0){
									if(dSaleAmtO < newValue){
										rv = '<t:message code="system.message.sales.message085" default="세액은 매출액보다 작아야 합니다."/>'; //세액은 매출액보다 작아야 합니다.
										break;
									}
								}else{
									if(dSaleAmtO > newValue){
										rv = '<t:message code="system.message.sales.message086" default="세액은 매출액보다 커야 합니다."/>'; //세액은 매출액보다 커야 합니다.
										break;
									}
								}
							}
							var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
							if(UserInfo.currency == "CN"){
								record.set('TAX_AMT_O', UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice));
							}else{
								record.set('TAX_AMT_O',UniSales.fnAmtWonCalc(dTaxAmtO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice));
							}
						}
						record.set('ORDER_O_TAX_O', record.get('SALE_AMT_O') + newValue);
						break;
					case "SALE_Q" :
						 var totAmt = record.get('SALE_P') * newValue ;
						 var suplyAmt = Math.round(totAmt / 1.1);
						 var taxAmt = totAmt - suplyAmt;
						if(record.get('TAX_TYPE')  == "2"){//면세인 경우는 부가세 0
							record.set('SALE_AMT_O', totAmt); //공급가액
							record.set('TAX_AMT_O', 0);		  //부가세액
							record.set('ORDER_O_TAX_O', totAmt);//총금액
						}else{
							record.set('SALE_AMT_O', suplyAmt);
							record.set('TAX_AMT_O', taxAmt);
							record.set('ORDER_O_TAX_O', totAmt);
						}
					break;
				}
			}
			return rv;
		}
	}); // validator
};
</script>
