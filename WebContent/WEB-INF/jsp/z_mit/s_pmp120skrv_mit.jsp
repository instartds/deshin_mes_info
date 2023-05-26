<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp120skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp120skrv_mit" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 		  <!-- 진행상태 -->
	<t:ExtComboStore comboType="W"/> <!-- 작업장 (전체)-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var excelWindow;
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp120skrv_mitService.selectList1'
		}
	});

	Unilite.defineModel('Pmp120skrvModel', {
		fields: [
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.status" default="상태"/>'				,type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string' , comboType:'AU', comboType:'W'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string'},
			{name: 'PRODT_PRSN'			,text: '작업자코드'			,type: 'string'},
			{name: 'PRODT_PRSN_NAME'	,text: '작업자'				,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',type: 'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'PRODT_DATE'		,text: '생산일'	,type: 'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'REMARK1'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type: 'string'},
			{name: 'SO_NUM'				,text: '<t:message code="system.label.product.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'SO_SEQ'				,text: '수주순번'																		,type: 'string'},
			{name: 'PO_NUM'				,text: 'PO NO'																		,type: 'string'},
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
			{name: 'UPDATE_DB_USER'		,text: '등록자'			,type: 'string'},
			
			{name: 'SOF_CUSTOM_NAME'	,text: '수주처명'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '수주제품명'			,type:'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type:'string'}
		]
	});

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
	
	var masterStore1 = Unilite.createStore('s_pmp120skrv_mitmasterStore1',{
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
				read: 's_pmp120skrv_mitService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

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
				fieldLabel: '완료예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				width: 315,
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('endOfTwoNextMonth'), 	//UniDate.get('sundayOfNextWeek'),
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
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			
			Unilite.popup('ORDER_NUM',{
				fieldLabel: '수주번호',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ORDER_NUM', panelSearch.getValue('ORDER_NUM'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ORDER_NUM', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
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
			fieldLabel: '완료예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName:'PRODT_START_DATE_TO',
			width: 315,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('endOfTwoNextMonth'),	//UniDate.get('sundayOfNextWeek'),
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
			colspan:2,
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
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
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
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
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
		}),
			
		Unilite.popup('ORDER_NUM',{
			fieldLabel: '수주번호',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ORDER_NUM', panelResult.getValue('ORDER_NUM'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ORDER_NUM', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype:'button',
			text:'착수예정일 변경업로드',
			disabled:false,
			itemId:'btn1',
			width: 200,
//				tdAttrs: {align: 'right'},	
			margin: '0 0 0 100',
			handler: function(){
           		if(!panelSearch.getInvalidMessage()) return;   //필수체크
            	openExcelWindow();
			}
		}]
	});

	var masterGrid1 = Unilite.createGrid('s_pmp120skrv_mitGrid1', {
		layout : 'fit',
		region:'center',
		store : masterStore1,
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
		selModel: 'rowmodel',
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: false}
		],
		columns:  [
			{ dataIndex: 'WORK_END_YN'		 	, width: 80,align:'center'},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 120},
			{ dataIndex: 'WKORD_NUM'			, width: 120},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 250},
			{ dataIndex: 'ITEM_NAME1'			, width: 175, hidden: true},
			{ dataIndex: 'SPEC'					, width: 150},
			{ dataIndex: 'LOT_NO'		  		, width: 130},			
			{ dataIndex: 'STOCK_UNIT'	  		, width: 70,align:'center'},
			{ dataIndex: 'PRODT_PRSN'			, width: 100, hidden: true},
			{ dataIndex: 'PRODT_PRSN_NAME'		, width: 100},
			{ dataIndex: 'PRODT_START_DATE'		, width: 100},
			{ dataIndex: 'PRODT_END_DATE'  		, width: 100},
			{ dataIndex: 'PRODT_DATE'  			, width: 100},
			{ dataIndex: 'WKORD_Q'			 	, width: 100},			
			{ dataIndex: 'PRODT_Q'				, width: 100, hidden: true},
			{ dataIndex: 'REMARK1'				, width: 150},
			{ dataIndex: 'REMARK2'				, width: 50, hidden: true},
			{ dataIndex: 'SO_NUM'				, width: 120},
			{ dataIndex: 'SO_SEQ'				, width: 80, hidden: true},
			{ dataIndex: 'PO_NUM'				, width: 120},
			{ dataIndex: 'ORDER_Q'				, width: 100, hidden: true},
			{ dataIndex: 'DVRY_DATE'			, width: 100, hidden: true},			
			{dataIndex: 'SOF_CUSTOM_NAME'		, width: 150 },
			{dataIndex: 'SOF_ITEM_NAME'			, width: 200 , hidden: true},
			{ dataIndex: 'PROJECT_NO'	  		, width: 120},	
			{ dataIndex: 'UPDATE_DB_USER'	  		, width: 120}		
		]
	});

	function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
//            excelWindow.extParam.WORK_SHOP_CODE = panelSearch.getValue('WORK_SHOP_CODE');
        }
        if(!excelWindow) {
            excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                modal: false,
                excelConfigName: 's_pmp120skrv_mit',
                extParam: {
                    'PGM_ID': 's_pmp120skrv_mit',
                    'DIV_CODE': panelSearch.getValue('DIV_CODE')
//                    'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
                },
                listeners: {
                	show: function(){
                	},
                    close: function() {
                        this.hide();
                    }
                },
                
                
                uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
				 	frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.down('tabpanel').setActiveTab(1);
							Ext.Msg.alert('Success', UniUtils.getMessage('system.message.commonJS.excel.succesText','Upload 되었습니다.'));
							me.hide();
					
						},
						failure: function(form, action) {
							Ext.Msg.alert('Failed', action.result.msg);
						}
					});
				},
				
				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						},
						{
							xtype: 'button',
							text : 'Read Data',
							tooltip : 'Read Data', 
							hidden: true,
							handler: function() { 
								if(me.jobID != null)	{
									me.readGridData(me.jobID);
									me.down('tabpanel').setActiveTab(1);
								} else {
									alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
								}
							}
						},
						{
							xtype: 'button',
							hidden:true,
							text : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'), 
							handler: function() { 
								var grids = me.down('grid');
								var isError = false;
								if(Ext.isDefined(grids.getEl()))	{
									grids.getEl().mask();
								}
								Ext.each(grids, function(grid,i){
									if(me.grids[0].useCheckbox) {
										var records = grid.getSelectionModel().getSelection();
									} else {
										var records = grid.getStore().data.items;
									}
									return Ext.each(records, function(record,i){	
										if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
											console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
											isError = true;	 
											return false;
										}
									});
								}); 
								if(Ext.isDefined(grids.getEl()))	{
									grids.getEl().unmask();
								}
								if(!isError) {
									me.onApply();
								}else {
									alert(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
								}
							}
						},
						'->',
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
							handler: function() { 
								me.hide();
							}
						}
						
					]
				}
				
             });
        }
        excelWindow.center();
        excelWindow.show();
    }
	
	Unilite.Main({
		borderItems:[{
		 region:'center',
		 layout: 'border',
		 border: false,
		 items:[
			masterGrid1, panelResult
		 ]
	  },
		 panelSearch
	  ],
		id: 's_pmp120skrv_mitApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));

			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('endOfTwoNextMonth'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('endOfTwoNextMonth'));
		},
		onQueryButtonDown : function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			masterStore1.loadStoreRecords();
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			masterGrid1.reset();
			masterStore1.clearData();
			panelResult.clearForm();

			this.fnInitBinding();
		}
	});	
};
</script>

