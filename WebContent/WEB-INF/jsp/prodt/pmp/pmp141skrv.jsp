<%--
'   프로그램명 : 예약자재출고현황(생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp141skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp141skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />							<!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Pmp141skrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type:'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type:'string'},
			{name: 'WKORD_STATUS'		, text:'<t:message code="system.label.product.status" default="상태"/>'						, type:'string'},
			{name: 'WKORD_STATUS_NAME'	, text: '<t:message code="system.label.product.status" default="상태"/>'						, type:'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			, type:'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type:'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type:'string'},
			{name: 'PITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'						, type:'string'},
			{name: 'PITEM_NAME'			, text: '<t:message code="system.label.product.itemnamespec" default="품명 / 규격"/>'			, type:'string'},
			{name: 'OPITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type:'string'},
			{name: 'OPITEM_NAME1'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'					, type:'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type:'string'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'				, type:'uniQty'},
			{name: 'GOOD_PRODT_Q'		, text: '<t:message code="system.label.product.productiongoodqty" default="생산양품량"/>'		, type:'uniQty'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			, type:'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			, type:'uniDate'},
			{name: 'CITEM_CODE'			, text: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>'		, type:'string'},
			{name: 'CITEM_NAME'			, text: '<t:message code="system.label.product.materialitemanamespec" default="자재품명/규격"/>'	, type:'string'},
			{name: 'OCITEM_NAME'		, text: '<t:message code="system.label.product.materialitemname" default="자재품명"/>'			, type:'string'},
			{name: 'OCITEM_NAME1'		, text: '<t:message code="system.label.product.materialitemname" default="자재품명"/>1'			, type:'string'},
			{name: 'CITEM_LOT_NO'		, text: '<t:message code="system.label.product.materiallot" default="자재LOT"/>'				, type:'string'},
			{name: 'CSTOCK_UNIT'		, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type:'string'},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'				, type:'uniQty'},
			{name: 'ALLOCK_Q'			, text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'				, type:'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productioninputqty" default="생산투입량"/>'		, type:'uniQty'},
			{name: 'UN_PRODT_Q'			, text: '<t:message code="system.label.product.productionnotinputqty" default="생산미투입량"/>'	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'			, type:'uniDate'},
			{name: 'WH_CODE'			, text: 'WH_CODE'	, type:'string'},
			{name: 'WH_CODE_NAME'		, text: '<t:message code="system.label.product.requestwarehouse" default="요청창고"/>'			, type:'string'},
			{name: 'OUT_METH'			, text: 'OUT_METH'	, type:'string'},
			{name: 'OUT_METH_NAME'		, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'				, type:'string'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.product.requestwarehousestock" default="요청창고재고"/>'	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_Q' 	, text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'			, type:'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.product.issueqty" default="출고량"/>'					, type:'uniQty'},
			{name: 'LOT_NO'			, text: 'LOT NO'	, type:'string'},
			{name: 'UN_OUTSTOCK_Q'		, text: '<t:message code="system.label.product.unissuedqty" default="미출고량"/>'				, type:'uniQty'},
			{name: 'MINI_PACK_Q'		, text: '<t:message code="system.label.product.minimumpackagingunit" default="최소포장단위"/>'	, type:'string'},
			//20190212 추가(통합작업지시번호)
			{name: 'TOP_WKORD_NUM'	, text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'			, type: 'string'}
		]
	});		//End of Unilite.defineModel('Pmp141skrvModel', {

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmp141skrvMasterStore1',{
		model: 'Pmp141skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp141skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'WKORD_NUM'
	});		//End of var directMasterStore1 = Unilite.createStore('pmp141skrvMasterStore1',{



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				topSearch.show();
			},
			expand: function() {
				topSearch.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
 			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					value : UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
				 },{
					fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'ORDER_DATE_FR',
					endFieldName:'ORDER_DATE_TO',
					width: 315,
					startDate: UniDate.get('todayOfLastWeek'),
					endDate: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(topSearch) {
							topSearch.setValue('ORDER_DATE_FR',newValue);
							//topSearch.getField('ISSUE_REQ_DATE_FR').validate();
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(topSearch) {
							topSearch.setValue('ORDER_DATE_TO',newValue);
							//topSearch.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = topSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
				{
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('WKORD_NUM', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 모품목코드 팝업창 표준화
					fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>',
					valueFieldName: 'PROD_ITEM_CODE',
					textFieldName: 'PROD_ITEM_NAME',
					validateBlank: false,
					//extParam: {DIV_CODE: panelSearch.getValue("DIV_CODE")},
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							topSearch.setValue('PROD_ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('PROD_ITEM_NAME', '');
								panelSearch.setValue('PROD_ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							topSearch.setValue('PROD_ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('PROD_ITEM_CODE', '');
								panelSearch.setValue('PROD_ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							if(Ext.isDefined(panelSearch)){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
								//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
							}
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 자재품목코드 팝업창 표준화
					fieldLabel: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>',
					valueFieldName: 'CITEM_CODE',
					textFieldName: 'CITEM_NAME',
					validateBlank: false,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							topSearch.setValue('CITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('CITEM_NAME', '');
								panelSearch.setValue('CITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							topSearch.setValue('CITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('CITEM_CODE', '');
								panelSearch.setValue('CITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							if(Ext.isDefined(panelSearch)){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
								//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
							}
						}
					}
			}),{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'ITEM_ACCOUNT',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.goods" default="제품"/>',
					width: 60,
					name: 'ITEM_ACCOUNT' ,
					inputValue: '10'
				},{
					boxLabel: '<t:message code="system.label.product.halffinished" default="반제품"/>',
					width: 60,
					name: 'ITEM_ACCOUNT' ,
					inputValue: '20'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//topSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
							topSearch.getField('ITEM_ACCOUNT').setValue(newValue.ITEM_ACCOUNT);
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.workorderstatus" default="작업지시현황"/>',
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '8'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WKORD_STATUS' ,
					inputValue: '9'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//topSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
							topSearch.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.issuestatus" default="출고상태"/>',
					labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'OUT_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'OUT_STATUS',
					inputValue: '3'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'OUT_STATUS',
					inputValue: '9'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//topSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
							topSearch.getField('OUT_STATUS').setValue(newValue.OUT_STATUS);
						}
					}
			}]
		}],
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

						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
				} else {
				//	this.mask();
					}
				} else {
				this.unmask();
			}
			return r;
		}
	});	// End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
			items: [{
					fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					value : UserInfo.divCode,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						topSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName : 'ORDER_DATE_TO',
				width: 315,
				startDate: UniDate.get('todayOfLastWeek'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_TO',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'ITEM_ACCOUNT',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.goods" default="제품"/>',
					width: 60,
					name: 'ITEM_ACCOUNT' ,
					inputValue: '10'
				},{
					boxLabel: '<t:message code="system.label.product.halffinished" default="반제품"/>',
					width: 60,
					name: 'ITEM_ACCOUNT' ,
					inputValue: '20'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelSearch.getField('ITEM_ACCOUNT').setValue(newValue.ITEM_ACCOUNT);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(topSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == topSearch.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == topSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 모품목코드 팝업창 표준화
			fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>',
			valueFieldName: 'PROD_ITEM_CODE',
			textFieldName: 'PROD_ITEM_NAME',
			validateBlank: false,
			listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('PROD_ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('PROD_ITEM_NAME', '');
							panelSearch.setValue('PROD_ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('PROD_ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('PROD_ITEM_CODE', '');
							panelSearch.setValue('PROD_ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						if(Ext.isDefined(panelSearch)){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
							//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
						}
					}
				}
			}),{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.workorderstatus" default="작업지시현황"/>',
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '8'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WKORD_STATUS',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelSearch.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
					}
				}
			},{
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 자재품목코드 팝업창 표준화
				fieldLabel: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>',
				valueFieldName: 'CITEM_CODE',
				textFieldName: 'CITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('CITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('CITEM_NAME', '');
							panelSearch.setValue('CITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('CITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('CITEM_CODE', '');
							panelSearch.setValue('CITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						if(Ext.isDefined(panelSearch)){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
							//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
						}
					}
				}
		}),{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.product.issuestatus" default="출고상태"/>',
			labelWidth:90,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'OUT_STATUS',
				inputValue: '',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'OUT_STATUS',
				inputValue: '3'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'OUT_STATUS',
				inputValue: '9'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('OUT_STATUS').setValue(newValue.OUT_STATUS);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pmp141skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			},
			state: {
		    	useState: false,	//그리드 설정 버튼 사용 여부
		   		useStateList: false	//그리드 설정 목록 사용 여부
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [{
			text: '<t:message code="system.label.product.workorderdetails" default="작업지시내역"/>',
			columns:[
				{dataIndex: 'WKORD_NUM'			, width: 130	},
				{dataIndex: 'TOP_WKORD_NUM'		, width: 130	, hidden: true},
				{dataIndex: 'WKORD_STATUS_NAME'	, width: 53		},
				{dataIndex: 'WORK_SHOP_NAME'	, width: 66		},
				{dataIndex: 'PITEM_CODE'		, width: 88		},
				{dataIndex: 'PITEM_NAME'		, width: 180	},
				{dataIndex: 'OPITEM_NAME1'		, width: 180	, hidden: true},
				{dataIndex: 'STOCK_UNIT'		, width: 53		},
				{dataIndex: 'WKORD_Q'			, width: 100	},
				{dataIndex: 'GOOD_PRODT_Q'		, width: 100	},
				{dataIndex: 'PRODT_START_DATE'	, width: 80		},
				{dataIndex: 'PRODT_END_DATE'	, width: 80		}
			]},{
			text: '<t:message code="system.label.product.materialreservationdetails" default="자재예약내역"/>',
			columns: [
				{dataIndex: 'CITEM_CODE'		, width: 100	},
				{dataIndex: 'CITEM_NAME'		, width: 180	},
				{dataIndex: 'OCITEM_NAME1'		, width: 180	, hidden: true},
				{dataIndex: 'CITEM_LOT_NO'		, width: 110	,tdCls:'x-change-cell2'},
				{dataIndex: 'CSTOCK_UNIT'		, width: 53		},
				{dataIndex: 'UNIT_Q'			, width: 80		},
				{dataIndex: 'ALLOCK_Q'			, width: 80		, summaryType: 'sum'},
				{dataIndex: 'PRODT_Q'			, width: 100	, summaryType: 'sum',tdCls:'x-change-cell2'},
				{dataIndex: 'UN_PRODT_Q'		, width: 100	, summaryType: 'sum'}
			]},{
			text: '<t:message code="system.label.product.issuerequestdetails" default="출고요청내역"/>',
			columns: [
				{dataIndex: 'OUTSTOCK_REQ_DATE'	, width: 80		},
				{dataIndex: 'WH_CODE_NAME'		, width: 100	},
				{dataIndex: 'OUT_METH_NAME'		, width: 80		},
				{dataIndex: 'GOOD_STOCK_Q'		, width: 100	, summaryType: 'sum'},
				{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100	, summaryType: 'sum'},
				{dataIndex: 'OUTSTOCK_Q'		, width: 80		, summaryType: 'sum'},
				{dataIndex: 'LOT_NO'		, width: 100, hidden: true	},
				{dataIndex: 'UN_OUTSTOCK_Q'		, width: 80		, summaryType: 'sum'},
				{dataIndex: 'MINI_PACK_Q'		, width: 93		}
			]},
			{dataIndex: 'COMP_CODE'			, width: 0	, hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 0	, hidden:true},
			{dataIndex: 'WKORD_STATUS'		, width: 0	, hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 0	, hidden:true},
			{dataIndex: 'WH_CODE'			, width: 0	, hidden:true},
			{dataIndex: 'OUT_METH'			, width: 0	, hidden:true},
			{dataIndex: 'OPITEM_NAME'		, width: 0	, hidden:true},
			{dataIndex: 'OCITEM_NAME'		, width: 0	, hidden:true}
			//{dataIndex: 'GOOD_STOCK_Q'	, width: 0	, hidden:true}
		]
	});		//End of var masterGrid1 = Unilite.createGrid('pmp141skrvGrid1', {



	Unilite.Main({
		id: 'pmp141skrvApp',
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				masterGrid1, topSearch
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			topSearch.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('todayOfLastWeek'));
			topSearch.setValue('ORDER_DATE_FR', UniDate.get('todayOfLastWeek'));

			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			topSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid1.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid1.reset();
			topSearch.reset();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});		// End of Unilite.Main({
};
</script>
