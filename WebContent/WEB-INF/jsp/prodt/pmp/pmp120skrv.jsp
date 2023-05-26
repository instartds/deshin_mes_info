<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp120skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp120skrv" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 		  <!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="W"/> <!-- 작업장 (전체)-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp120skrvService.selectList1'
		}
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Pmp120skrvModel', {
		fields: [
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.status" default="상태"/>'				,type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string' , comboType:'AU', comboType:'W'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'REMARK1'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type: 'string'},
			{name: 'SO_NUM'			,text: '<t:message code="system.label.product.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.product.soqty" default="수주량"/>'				,type: 'uniQty'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		,type: 'uniDate'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT NO"/>'				,type: 'string'},
			{name: 'REMARK2'			,text: '<t:message code="system.label.product.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'		,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionresult" default="생산실적"/>'	,type: 'uniPrice'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingunit" default="공정단위"/>'		,type: 'string'},
			{name: 'TREE_NAME'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string'},

			{name: 'SOF_CUSTOM_NAME'	,text: '수주처명'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '수주제품명'			,type:'string'},
			{name: 'DIV_CODE'		,text: 'DIV_CODE'			,type:'string'}
		]
	});		//End of Unilite.defineModel('Pmp120skrvModel', {

	Unilite.defineModel('Pmp120skrvModel2', {
		fields: [
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'		,type: 'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'	,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'	,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionresult" default="생산실적"/>'	,type: 'uniQty'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingunit" default="공정단위"/>'		,type: 'string'},
			{name: 'TREE_NAME'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore1 = Unilite.createStore('pmp120skrvMasterStore1',{
		model: 'Pmp120skrvModel',
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
				read: 'pmp120skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					panelSearch.setValue('WKORD_NUM',records[0].get('WKORD_NUM'));

					if(panelSearch.getValue('WKORD_NUM') != ''){
							MasterStore2.loadStoreRecords(records);
					}
				}else{
					panelSearch.setValue('WKORD_NUM','');
					masterGrid2.getStore().removeAll();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}//, groupField: 'ITEM_NAME'
	});		// End of var directMasterStore1 = Unilite.createStore('pmp120skrvMasterStore1',{

	var MasterStore2 = Unilite.createStore('pmp120skrvMasterStore2',{
		model: 'Pmp120skrvModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy:directProxy,
		loadStoreRecords: function(record){
			var param= panelSearch.getValues();
			this.load({
					params : record.data
			});
		}
	});



	/** 검색조건 (Search Panel)
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
				id: 'search_panel1',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
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
				endFieldName:'PRODT_START_DATE_TO',
				width: 415,
				startDateFieldWidth : 120,
				endDateFieldWidth:	120,
				pickerWidth : 420,
				pickerHeight : 280,
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('sundayOfNextWeek'),
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
				xtype: 'radiogroup',
				fieldLabel: '	',
				//name:'WORK_END_YN',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'F'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: 'WORK_SHOP_CODE',
					xtype: 'uniCombobox',
					comboType:'W',
					//20190502 주석
//					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						},
						beforequery:function( queryPlan, eOpts )   {
							var store = queryPlan.combo.store;
							var prStore = panelResult.getField('WORK_SHOP_CODE').store;
							store.clearFilter();
							prStore.clearFilter();
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
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
				Unilite.popup('DIV_PUMOK',{ // 20210825 수정: 품목 조회조건 표준화
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
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
				{
					xtype:'uniTextfield',
					fieldLabel:'수주번호',
					name:'SO_NUM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SO_NUM', newValue);
						}
					}
				}
			]}/*,{
				title:'<t:message code="system.label.product.additionalinfo" default="추가정보"/>',
   				id: 'search_panel2',
				itemId:'search_panel2',
				defaultType: 'uniTextfield',
				layout : {type : 'uniTable', columns : 1},
				defaultType: 'uniTextfield',

				items:[{
					fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
					xtype: 'uniDatefield',
					name: 'PRODT_START_DATE',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
					xtype: 'uniDatefield',
					name: 'PRODT_END_DATE',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
					xtype: 'uniNumberfield',
					name: 'WKORD_Q',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.productionqty" default="생산량"/>',
					xtype: 'uniNumberfield',
					name: 'PRODT_Q',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>',
					xtype: 'uniTextfield',
					name: 'REMARK1',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
					xtype: 'uniTextfield',
					name: 'PROJECT_NO',
					readOnly : true
				}
			]},{
				title:'참고 사항',
   				id: 'search_panel3',
				itemId:'search_panel3',
				defaultType: 'uniTextfield',
				layout : {type : 'uniTable', columns : 1},
				defaultType: 'uniTextfield',

				items:[{
					fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
					xtype: 'uniTextfield',
					name: 'SO_NUM',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.soqty" default="수주량"/>',
					xtype: 'uniTextfield',
					name: 'ORDER_Q',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
					xtype: 'uniTextfield',
					name: 'DVRY_DATE',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
					xtype: 'uniTextfield',
					name: 'REMARK2',
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM',
					readOnly : true,
					hidden: true
				}]
		}*/],
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
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
			endFieldName:'PRODT_START_DATE_TO',
			width: 415,
			startDateFieldWidth : 120,
			endDateFieldWidth:	120,
			pickerWidth : 420,
			pickerHeight : 280,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('sundayOfNextWeek'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_TO',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '	',
			//name:'WORK_END_YN',
			labelWidth: 90,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'N'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'F'
			}],
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
				//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
				panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				//20190502 주석
//					allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var psStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						psStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							psStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							psStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ // 20210825 수정: 품목 조회조건 표준화
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank:false,
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME',
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
			{
				xtype:'uniTextfield',
				fieldLabel:'수주번호',
				name:'SO_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SO_NUM', newValue);
					}
				}
			}
		]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pmp120skrvGrid1', {
		layout : 'fit',
		region:'center',
		store : MasterStore1,
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
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
			{ dataIndex: 'WORK_END_YN'		 	, width: 80 },
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 80},
			{ dataIndex: 'WKORD_NUM'			, width: 105},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 175},
			{ dataIndex: 'ITEM_NAME1'			, width: 175, hidden: true},
			{ dataIndex: 'SPEC'					, width: 130},
			{ dataIndex: 'STOCK_UNIT'	  		, width: 70},
			{ dataIndex: 'PRODT_START_DATE'		, width: 50, hidden: true},
			{ dataIndex: 'PRODT_END_DATE'  		, width: 50, hidden: true},
			{ dataIndex: 'WKORD_Q'			 	, width: 50, hidden: true},
			{ dataIndex: 'PRODT_Q'				, width: 50, hidden: true},
			{ dataIndex: 'REMARK1'				, width: 126},
			{ dataIndex: 'SO_NUM'			, width: 50, hidden: true},
			{ dataIndex: 'ORDER_Q'				, width: 50, hidden: true},
			{ dataIndex: 'DVRY_DATE'			, width: 50, hidden: true},
			{ dataIndex: 'LOT_NO'		  		, width: 125},
			{ dataIndex: 'REMARK2'				, width: 50, hidden: true},
			{ dataIndex: 'PROJECT_NO'	  		, width: 120},

			{dataIndex: 'SOF_CUSTOM_NAME'		, width: 150 ,hidden:true},
			{dataIndex: 'SOF_ITEM_NAME'			, width: 200 , hidden: true}

//			{ dataIndex: 'PJT_CODE'				, width: 129}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
			/*cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
		  		MasterStore2.loadStoreRecords(record);
		  		this.returnCell(record);
   		  },*/
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					MasterStore2.loadStoreRecords(record);

				}
		  	}
		}
/*			returnCell: function(record){
		  	var wkordNum				= record.get("WKORD_NUM");

		  	var prodtStartDate		  = record.get("PRODT_START_DATE");
		  	var prodtEndDate			= record.get("PRODT_END_DATE");
		  	var wkordQ					= record.get("WKORD_Q");
		  	var prodtQ					= record.get("PRODT_Q");
		  	var remark1				= record.get("REMARK1");
		  	var projectNo				= record.get("PROJECT_NO");

		  	var soNum				= record.get("SO_NUM");
		  	var orderQ					= record.get("ORDER_Q");
		  	var dvryDate				= record.get("DVRY_DATE");
		  	var remark2				= record.get("REMARK2");


		  	panelSearch.setValues({'WKORD_NUM':wkordNum});

		  	panelSearch.setValues({'PRODT_START_DATE':prodtStartDate});
		  	panelSearch.setValues({'PRODT_END_DATE':prodtEndDate});
		  	panelSearch.setValues({'WKORD_Q':wkordQ});
		  	panelSearch.setValues({'PRODT_Q':prodtQ});
		  	panelSearch.setValues({'REMARK1':remark1});
		  	panelSearch.setValues({'PROJECT_NO':projectNo});

		  	panelSearch.setValues({'SO_NUM':soNum});
		  	panelSearch.setValues({'ORDER_Q':orderQ});
		  	panelSearch.setValues({'DVRY_DATE':dvryDate});
		  	panelSearch.setValues({'REMARK2':remark2});
		  }*/
	});		//End of var masterGrid1 = Unilite.createGrid('pmp120skrvGrid1', {

	/**
	 * Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('pmp120skrvGrid2', {
		layout : 'fit',
		region:'south',
		store : MasterStore2,
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
	   /* tbar: [{
			text:'상세보기',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
		}],	*/
			features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
			{dataIndex: 'LINE_SEQ'			, width: 89},
			{dataIndex: 'PROG_WORK_CODE'	, width: 113 },
			{dataIndex: 'PROG_WORK_NAME'	, width: 210 },
			{dataIndex: 'LOT_NO'			, width: 110 },
			{dataIndex: 'PRODT_START_DATE'	, width: 153, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 153, hidden: true},
			{dataIndex: 'WKORD_Q'			, width: 140 },
			{dataIndex: 'PRODT_Q'			, width: 140 },
			{dataIndex: 'PROG_UNIT'			, width: 331 },
			{dataIndex: 'TREE_NAME'			, width: 112, hidden: true}
		]
	});		//End of var masterGrid2 = Unilite.createGrid('pmp120skrvGrid2', {

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
		id: 'pmp120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));

			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{


			MasterStore1.loadStoreRecords();
			beforeRowIndex = -1;
			UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid1.reset();
			masterGrid2.reset();
			panelResult.reset();

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

