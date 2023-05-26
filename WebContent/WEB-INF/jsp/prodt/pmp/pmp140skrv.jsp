<%--
'   프로그램명 : 자재예약현황(생산)
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
<t:appConfig pgmId="pmp140skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp140skrv" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  />		  <!-- 상태  -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  />		  <!-- 출고방법  -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {	 
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Pmp140skrvModel', {
		fields: [  	
			{name: 'WORK_END_YN'		, text:'<t:message code="system.label.product.status" default="상태"/>'				, type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'DIV_CODE'			, text:'<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text:'<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text:'<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ITEM_NAME1'			, text:'<t:message code="system.label.product.itemname" default="품목명"/>1'			, type: 'string'},
			{name: 'WKORD_NUM'			, text:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'SPEC'				, text:'<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string'},
			{name: 'PRODT_START_DATE'	, text:'<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text:'<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'WKORD_Q'			, text:'<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text:'<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'WORK_SHOP_CODE'		, text:'<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'LOT_NO'				, text:'<t:message code="system.label.product.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'REMARK'				, text:'<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text:'<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text:'<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'WH_NAME'			, text:'<t:message code="system.label.product.mainwarehouse" default="주창고"/>'		, type: 'string'},
			{name: 'UNIT_Q'				, text:'<t:message code="system.label.product.originunitqty" default="원단위량"/>'		, type: 'uniQty'},
			{name: 'ALLOCK_Q'			, text:'<t:message code="system.label.product.allocationqty" default="예약량"/>'		, type: 'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	, text:'<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'	, type: 'uniDate'},
			{name: 'OUT_METH'			, text:'<t:message code="system.label.product.issuemethod" default="출고방법"/>'		, type: 'string'},
			{name: 'OUTSTOCK_REQ_Q'		, text:'<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'	, type: 'uniQty'}
		]						 
	});		// End of Unilite.defineModel('Pmp140skrvModel', {
	
		Unilite.defineModel('Pmp140skrvModel2', {
		fields: [  	 
			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.status" default="상태"/>'				, type: 'string'  , comboType:'AU', comboCode:'P001'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.childitemcode" default="자품목코드"/>'	, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.childitemname" default="자품목명"/>'		, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.product.childitemname" default="자품목명"/>1'	, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.product.mainwarehouse" default="주창고"/>'		, type: 'string'},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'		, type: 'float', decimalPrecision: 4, format:'0,000.000000'},
			{name: 'ALLOCK_Q'			, text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'		, type: 'float', decimalPrecision: 4, format:'0,000.000000'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'	, type: 'uniDate'},
			{name: 'OUT_METH'			, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'		, type: 'string' , comboType:'AU' , comboCode:'B039'},
			{name: 'OUTSTOCK_REQ_Q'		, text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'	, type: 'float', decimalPrecision: 4, format:'0,000.000000'},
			{name: 'WEIGHT_RATE'		, text: '<t:message code="system.label.base.weight" default="가중치"/>'					, type: 'float', decimalPrecision: 4, format:'0,000.000000'}
		]
	});		//End of Unilite.defineModel('Pmp140skrvModel2', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pmp140skrvMasterStore1',{
			model: 'Pmp140skrvModel',
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
					read: 'pmp140skrvService.selectList'
				}
			},
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					panelSearch.setValue('WKORD_NUM',records[0].get('WKORD_NUM'));
	  
					if(panelSearch.getValue('WKORD_NUM') != ''){
							directMasterStore2.loadStoreRecords(records);
					}
				}else{
					panelSearch.setValue('WKORD_NUM',''); 
					directMasterStore2/*.getStore()*/.removeAll();
				}
			},
			add: function(store, records, index, eOpts) {
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				
			},
			remove: function(store, record, index, isMove, eOpts) {	
			}
		}
//			,groupField: 'COMP_CODE'
	});
	
	var directMasterStore2 = Unilite.createStore('pmp140skrvMasterStore2',{
			model: 'Pmp140skrvModel2',
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결 
				editable: false,			// 수정 모드 사용 
				deletable: false,			// 삭제 가능 여부 
				useNavi: false			// prev | next 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {			
					   read: 'pmp140skrvService.selectDetailList'
				}
			},
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}
//			,groupField: 'COMP_CODE'
	});		//End of var directMasterStore2 = Unilite.createStore('pmp140skrvMasterStore2',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_START_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_START_DATE_TO',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelResult.getField('WORK_SHOP_CODE').store;
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
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName:'ITEM_CODE_FR',
					textFieldName:'ITEM_NAME_FR',
					validateBlank:false,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
					valueFieldName:'ITEM_CODE_TO',
					textFieldName:'ITEM_NAME_TO',
					validateBlank:false,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				name:'WKORD_NUM',
				xtype: 'uniTextfield',
				hidden: true
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
	});		//End of var panelSearch = Unilite.createSearchForm('searchForm',{	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
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
				value:UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				width: 315,
				colspan:2,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);	
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
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
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName:'ITEM_CODE_FR',
					textFieldName:'ITEM_NAME_FR',
					validateBlank:false,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
					valueFieldName:'ITEM_CODE_TO',
					textFieldName:'ITEM_NAME_TO',
					validateBlank:false,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				name:'WKORD_NUM',
				xtype: 'uniTextfield',
				hidden: true
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
	});	
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('pmp140skrvGrid1', {
		layout : 'fit',
		region:'center',
		store : directMasterStore1, 
		uniOpt:{
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
		features: [ 
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false} 
		],
		columns: [  
			{dataIndex: 'WORK_END_YN'		, width: 80},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 90},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'ITEM_NAME1'		, width: 150, hidden:true},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 55, align:'center'},
			{dataIndex: 'PRODT_START_DATE'	, width: 80},
			{dataIndex: 'PRODT_END_DATE'	, width: 80},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 66	, hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100},
			{dataIndex: 'LOT_NO'			, width: 120},
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'PROJECT_NO'		, width: 100},
//			{dataIndex: 'PJT_CODE'			, width: 100},
			{dataIndex: 'DIV_CODE'			, width: 66	, hidden:true},
			{dataIndex: 'ORDER_NUM'			, width: 66	, hidden:true}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
		   /*  cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {		
				directMasterStore2.loadStoreRecords(record);
			this.returnCell(record, colName);			
   		  }*/
   			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					this.returnCell(record);  
					directMasterStore2.loadData({})
					directMasterStore2.loadStoreRecords(record);
					
				}
			}  
		},
		 returnCell: function(record){
			var wkordNum		 = record.get("WKORD_NUM");
			
			panelSearch.setValues({'WKORD_NUM':wkordNum});
			
	
		  } 
	});		//End of  var masterGrid1 = Unilite.createGrid('pmp140skrvGrid1', {
	
	/**
	 * Master Grid2 정의(Grid Panel)
	 * @type 
	 */
  var masterGrid2 = Unilite.createGrid('pmp140skrvGrid2', {
		layout : 'fit',
		region:'south',
		uniOpt:{	
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
		store: directMasterStore2,
//			features: [{
//				id: 'masterGridSubTotal', 
//				ftype: 'uniGroupingsummary',
//				showSummaryRow: true 
//			},{
//				id: 'masterGridTotal',
//				ftype: 'uniSummary',
//				showSummaryRow: true
//		}],
		columns: [ 
			{dataIndex: 'DIV_CODE'				,	width: 66	, hidden:true},
			{dataIndex: 'WKORD_NUM'				,	width: 93	, hidden:true},
			{dataIndex: 'ITEM_CODE'				,	width: 90},
			{dataIndex: 'ITEM_NAME'				,	width: 150},
			{dataIndex: 'ITEM_NAME1'			,	width: 150	, hidden:true},
			{dataIndex: 'SPEC'					,	width: 150},
			{dataIndex: 'STOCK_UNIT'			,	width: 55, align:'center'},
			{dataIndex: 'WH_NAME'				,	width: 140},
			{dataIndex: 'UNIT_Q'				,	width: 90},
			{dataIndex: 'ALLOCK_Q'				,	width: 100},
			{dataIndex: 'OUTSTOCK_REQ_DATE'		,	width: 82	, hidden:true},
			{dataIndex: 'OUT_METH'				,	width: 70},
			{dataIndex: 'OUTSTOCK_REQ_Q'		,	width: 90},
			{dataIndex: 'WEIGHT_RATE'			,	width: 90	, hidden:true},
			{dataIndex: 'REMARK'				,	width: 133},
			{dataIndex: 'PROJECT_NO'			,	width: 100}
//			{dataIndex: 'PJT_CODE'				,	width: 100}
		] 
	});		//End of var masterGrid2 = Unilite.createGrid('pmp140skrvGrid2', {   

	Unilite.Main({
		borderItems:[{
		 region:'center',
		 layout: 'border',
		 border: false,
		 items:[
			masterGrid1, masterGrid2, panelResult
		 ]
	  },
		 panelSearch
	  ],
		id: 'pmp140skrvApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('today'));
			
			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('startOfNextMonth'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('startOfNextMonth'));
		},
		onQueryButtonDown : function(){		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			masterGrid1.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true); 
			}
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
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
	});		//End of Unilite.Main({
};		
</script>
