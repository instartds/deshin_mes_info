<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp120skrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp120skrv_jw" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"  /> 			<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 			<!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp120skrv_jwService.selectList1'
		}
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pmp120skrv_jwModel', {
		fields: [
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.status" default="상태"/>'					,type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type: 'uniQty'},
			{name: 'REMARK1'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type: 'string'},
			//20181217 추가 (REWORK_YN)
			{name: 'REWORK_YN'			,text: '<t:message code="system.label.product.reworkorder" default="재작업지시"/>'			,type: 'string' , comboType:'AU', comboCode:'B131'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.product.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.product.soqty" default="수주량"/>'					,type: 'uniQty'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.product.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionresult" default="생산실적"/>'		,type: 'uniPrice'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingunit" default="공정단위"/>'			,type: 'string'},
			{name: 'TREE_NAME'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type: 'string'},
			{name: 'REMARK3'			,text: '<t:message code="system.label.product.woodeninfomation" default="목형정보"/>'		,type: 'string'},
			{name: 'TOP_WKORD_NUM'		,text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'	,type: 'string'	}
		]
	});		//End of Unilite.defineModel('s_pmp120skrv_jwModel', {

	Unilite.defineModel('s_pmp120skrv_jwModel2', {
		fields: [
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'		,type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionresult" default="생산실적"/>'	,type: 'uniQty'},
			{name: 'PROG_UNIT'  		,text: '<t:message code="system.label.product.routingunit" default="공정단위"/>'		,type: 'string'},
			{name: 'TREE_NAME'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore1 = Unilite.createStore('s_pmp120skrv_jwMasterStore1',{
		model: 's_pmp120skrv_jwModel',
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
				read: 's_pmp120skrv_jwService.selectList'
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
		}
	});		// End of var directMasterStore1 = Unilite.createStore('s_pmp120skrv_jwMasterStore1',{

	var MasterStore2 = Unilite.createStore('s_pmp120skrv_jwMasterStore2',{
		model: 's_pmp120skrv_jwModel2',
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
					params : param
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
				topSearch.show();
			},
			expand: function() {
				topSearch.hide();
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
							topSearch.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				width: 315,
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('sundayOfNextWeek'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(topSearch) {
							topSearch.setValue('PRODT_START_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(topSearch) {
							topSearch.setValue('PRODT_START_DATE_TO',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
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
							topSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: 'WORK_SHOP_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('wsList'),
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								topSearch.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE', '');
							topSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					//20181217 추가 (REWORK_YN)
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.product.reworkorder" default="재작업지시"/>',
					labelWidth: 90,
					items: [{
						boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: '',
						checked: true
					},{
						boxLabel : '<t:message code="system.label.product.yes" default="예"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.getField('REWORK_YN').setValue(newValue.REWORK_YN);
//							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			]},{
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
					name: 'ORDER_NUM',
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

						alert(labelText+Msg.sMB083);
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

	var topSearch = Unilite.createSimpleForm('topSearchForm', {
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
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				width: 315,
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
				fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
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
					store: Ext.data.StoreManager.lookup('wsList'),
					allowBlank: false,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', topSearch.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', topSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					//20181217 추가 (REWORK_YN)
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.product.reworkorder" default="재작업지시"/>',
					labelWidth: 90,
					items: [{
						boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: '',
						checked: true
					},{
						boxLabel : '<t:message code="system.label.product.yes" default="예"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
						width: 60,
						name: 'REWORK_YN',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.getField('REWORK_YN').setValue(newValue.REWORK_YN);
//							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
		]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_pmp120skrv_jwGrid1', {
		store : MasterStore1,
		layout : 'fit',
		region:'center',
		flex	: 2,
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
			{ dataIndex: 'WORK_END_YN'			, width: 80 },
			{ dataIndex: 'WKORD_NUM'			, width: 130},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 175},
			{ dataIndex: 'ITEM_NAME1'			, width: 175, hidden: true},
			{ dataIndex: 'SPEC'					, width: 130},
			{ dataIndex: 'STOCK_UNIT'			, width: 70},
			{ dataIndex: 'PRODT_START_DATE'		, width: 50, hidden: true},
			{ dataIndex: 'PRODT_END_DATE'		, width: 50, hidden: true},
			{ dataIndex: 'WKORD_Q'				, width: 90, hidden: false},
			{ dataIndex: 'PRODT_Q'				, width: 90, hidden: false},
			//20181217 추가 (REWORK_YN)
			{ dataIndex: 'REWORK_YN'			, width: 80},
			{ dataIndex: 'REMARK3'				, width: 250},
			{ dataIndex: 'REMARK1'				, width: 126},
			{ dataIndex: 'ORDER_NUM'			, width: 50, hidden: true},
			{ dataIndex: 'ORDER_Q'				, width: 50, hidden: true},
			{ dataIndex: 'DVRY_DATE'			, width: 50, hidden: true},
			{ dataIndex: 'LOT_NO'				, width: 125},
			{ dataIndex: 'CUSTOM_NAME'			, width: 50, hidden: true},
			{ dataIndex: 'PROJECT_NO'			, width: 120},
			{ dataIndex: 'TOP_WKORD_NUM'		, width: 130, hidden: true}
//			{ dataIndex: 'PJT_CODE'				, width: 129}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
			/*cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
				MasterStore2.loadStoreRecords(record);
				this.returnCell(record);
		},*/
//			selectionchange:function( model1, selected, eOpts ){
//				if(selected.length > 0)	{
//					var record = selected[0];
//					this.returnCell(record);
//					MasterStore2.loadData({})
//					MasterStore2.loadStoreRecords(record);
//				}
//			}
		},
		returnCell: function(record){
			var wkordNum		= record.get("WKORD_NUM");

			var prodtStartDate	= record.get("PRODT_START_DATE");
			var prodtEndDate	= record.get("PRODT_END_DATE");
			var wkordQ			= record.get("WKORD_Q");
			var prodtQ			= record.get("PRODT_Q");
			var remark1			= record.get("REMARK1");
			var projectNo		= record.get("PROJECT_NO");

			var orderNum		= record.get("ORDER_NUM");
			var orderQ			= record.get("ORDER_Q");
			var dvryDate		= record.get("DVRY_DATE");
			//var remark2			= record.get("REMARK2");


			panelSearch.setValues({'WKORD_NUM':wkordNum});

			panelSearch.setValues({'PRODT_START_DATE':prodtStartDate});
			panelSearch.setValues({'PRODT_END_DATE':prodtEndDate});
			panelSearch.setValues({'WKORD_Q':wkordQ});
			panelSearch.setValues({'PRODT_Q':prodtQ});
			panelSearch.setValues({'REMARK1':remark1});
			panelSearch.setValues({'PROJECT_NO':projectNo});

			panelSearch.setValues({'ORDER_NUM':orderNum});
			panelSearch.setValues({'ORDER_Q':orderQ});
			panelSearch.setValues({'DVRY_DATE':dvryDate});
			//panelSearch.setValues({'REMARK2':remark2});
		}
	});		//End of var masterGrid1 = Unilite.createGrid('s_pmp120skrv_jwGrid1', {

	/** Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('s_pmp120skrv_jwGrid2', {
		store	: MasterStore2,
		layout	: 'fit',
		region	: 'south',
		split	: true,
		flex	: 1,
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
			{dataIndex: 'PRODT_START_DATE'	, width: 153, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 153, hidden: true},
			{dataIndex: 'WKORD_Q'			, width: 140 },
			{dataIndex: 'PRODT_Q'			, width: 140 },
			{dataIndex: 'PROG_UNIT'			, width: 331 },
			{dataIndex: 'TREE_NAME'			, width: 112, hidden: true}
		]
	});		//End of var masterGrid2 = Unilite.createGrid('s_pmp120skrv_jwGrid2', {



	Unilite.Main({
		id: 's_pmp120skrv_jwApp',
		borderItems:[{
		 region:'center',
		 layout: 'border',
		 border: false,
		 items:[
			masterGrid1/*, masterGrid2*/, topSearch
		 ]
	  },
		 panelSearch
	  ],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			topSearch.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			topSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));

			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			topSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
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
	});		//End of Unilite.Main({
};
</script>

