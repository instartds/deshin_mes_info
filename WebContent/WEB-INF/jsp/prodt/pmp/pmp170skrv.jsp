<%--
'   프로그램명 : 작업지시현황(공정별) (생산)
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
<t:appConfig pgmId="pmp170skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp170skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 		<!-- 진행상태 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Pmp170skrvModel', {
		fields: [
			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.status" default="상태"/>'				, type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'JAN_PRODT_Q'		, text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'			, type: 'uniQty'},
			{name: 'REMARK1'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
		// {name: 'PJT_CODE' , text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>' , type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'REMARK2'			, text: '<t:message code="system.label.product.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	, type: 'string'}	
		]
	});// End of Unilite.defineModel('Mtr170rkrvModel', {



	/** Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmp170skrvMasterStore1',{
		model: 'Pmp170skrvModel',
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
				read: 'pmp170skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'PROG_WORK_NAME'
	});// End of var directMasterStore1 =
		// Unilite.createStore('mtr170rkrvMasterStore1',{



	/** 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
		items:[{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				allowBlank:false,
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
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				width: 315,
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('sundayOfNextWeek'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_START_DATE_FR',newValue);
							// panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_START_DATE_TO',newValue);
							// panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.lotno" default="LOT번호"/>', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelResult.setValue('LOT_NO_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelResult.setValue('LOT_NO_TO', newValue);
						}
					}
				}]
			},
				Unilite.popup('DIV_PUMOK',{ // 20210825 수정: 품목 조회조건 표준화
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank: false,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('PROG_WORK_CODE',{ 
					fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROG_WORK_CODE', panelSearch.getValue('PROG_WORK_CODE'));
								panelResult.setValue('PROG_WORK_NAME', panelSearch.getValue('PROG_WORK_NAME'));																											
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PROG_WORK_CODE', '');
							panelResult.setValue('PROG_WORK_NAME', '');
						},
						applyextparam: function(popup){
							// if(panelSearch.getValue('WORK_SHOP_CODE') !=
							// null){
							if(!Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE'))){	
								
									popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')
								});
							}else{
								UniAppManager.app.checkForNewDetail();
								panelSearch.getField('WORK_SHOP_CODE').focus();
								
								return false;
							}
						}
					}
			}),{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelResult.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelResult.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{	
				xtype: 'radiogroup',							
				fieldLabel: '   ',											
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							// panelResult.getField('SALE_YN').setValue({SALE_YN:
							// newValue});
							panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
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
					// this.mask();
					}
				} else {
  					this.unmask();
  				}
				return r;
  			}
	});// End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items:[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				colspan:1,
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
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('sundayOfNextWeek'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_FR',newValue);
						// panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_TO',newValue);
						// panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.lotno" default="LOT번호"/>', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelSearch.setValue('LOT_NO_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelSearch.setValue('LOT_NO_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				allowBlank:false,
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
				Unilite.popup('DIV_PUMOK',{ // 20210825 수정: 품목 조회조건 표준화
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:true,// 默认true，设置成false时，手动删除内容，不影响组件value
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank: false,
					colspan:2,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('PROG_WORK_CODE',{ 
					fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PROG_WORK_CODE', panelResult.getValue('PROG_WORK_CODE'));
								panelSearch.setValue('PROG_WORK_NAME', panelResult.getValue('PROG_WORK_NAME'));																											
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('PROG_WORK_CODE', '');
							panelSearch.setValue('PROG_WORK_NAME', '');
						},
						applyextparam: function(popup){
							// if(panelSearch.getValue('WORK_SHOP_CODE') !=
							// null){
							if(!Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE'))){		
								
									popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
								});
							}else{
								UniAppManager.app.checkForNewDetail();					
								panelResult.getField('WORK_SHOP_CODE').focus();
								
								return false;
							}
						}
					}
			}),{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelSearch.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {	  
							panelSearch.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{	
				xtype: 'radiogroup',							
				fieldLabel: '   ',											
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					// panelSearch.getField('SALE_YN').setValue({SALE_YN:
					// newValue});
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
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
					// this.mask();
					}
				} else {
  					this.unmask();
  				}
				return r;
  			}
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{



	/** Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
	var masterGrid = Unilite.createGrid('pmp170skrvGrid1', {
		// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
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
		store: directMasterStore1,
		columns: [
			{dataIndex: 'WORK_END_YN'		, width: 40		, locked: false},
			{dataIndex: 'PROG_WORK_CODE'	, width: 70 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}},
			{dataIndex: 'PROG_WORK_NAME'	, width: 100	, locked: false},
			{dataIndex: 'WKORD_NUM'			, width: 130	, locked: false},
			{dataIndex: 'ITEM_CODE'			, width: 100	, locked: false},
			{dataIndex: 'ITEM_NAME'			, width: 146	, locked: false},
			{dataIndex: 'ITEM_NAME1'		, width: 146	, locked: false	, hidden: true},
			{dataIndex: 'SPEC'				, width: 100 	},
			{dataIndex: 'STOCK_UNIT'		, width: 40}, 
			{dataIndex: 'PRODT_START_DATE'	, width: 100 	},
			{dataIndex: 'PRODT_END_DATE'	, width: 100 	}, 
			{dataIndex: 'WKORD_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'			, width: 120, summaryType: 'sum'}, 
			{dataIndex: 'JAN_PRODT_Q'		, width: 120, summaryType: 'sum'}, 
			{dataIndex: 'REMARK1'			, width: 130},		
			{dataIndex: 'PROJECT_NO'		, width: 100},
// {dataIndex: 'PJT_CODE' , width: 100 ,hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_Q'			, width: 66 },
			{dataIndex: 'DVRY_DATE'			, width: 100},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'REMARK2'			, width: 66		,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 66		,hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 66		,hidden: true}
		]
	});// End of var masterGrid = Unilite.createGrid('mtr170rkrvGrid1', {
	
	
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],	
		id: 'pmp170rkrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','detail', 'save'], false);
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			
			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
// var viewLocked = masterGrid.lockedGrid.getView();
// var viewNormal = masterGrid.normalGrid.getView();
// console.log("viewLocked: ",viewLocked);
// console.log("viewNormal: ",viewNormal);
// viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
// viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				UniAppManager.setToolbarButtons('excel',true);
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true))
				return panelSearch.setAllFieldsReadOnly(true);
			else return false;
		}
	});// End of Unilite.Main( {
};
</script>