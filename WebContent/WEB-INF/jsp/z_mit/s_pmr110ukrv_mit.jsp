<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr110ukrv_mit">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />
	<t:ExtComboStore comboType="AU" comboCode="B013" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >
var excelWindow;
var searchInfoWindow;

function appMain() {	
	var BsaCodeInfo = {
		gsMoneyUnit: '${gsMoneyUnit}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmr110ukrv_mitService.selectList',
			create	: 's_pmr110ukrv_mitService.updateList',
			syncAll	: 's_pmr110ukrv_mitService.saveAll'
		}
	});

	
	Unilite.defineModel('s_pmr110ukrv_mitModel', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: '엑셀업로드ID'		, type: 'string'	, allowBlank: false},
			{name: '_EXCEL_ROWNUM'      , text: '엑셀업로드RowNum'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'	, allowBlank: false, comboType: 'BOR120', editable:false},
			{name: 'SEQ'				, text: '순번'			, type: 'int'	    , allowBlank: false },
			{name: 'ITEM_CODE'			, text: '자품목코드'		, type: 'string'	, allowBlank: false, editable:false},
			{name: 'ITEM_NAME'			, text: '자품목명'			, type: 'string'	, editable:false},
			{name: 'SPEC'				, text: '규격'			, type: 'string'	, editable:false},
			{name: 'STOCK_UNIT'			, text: '단위'			, type: 'string' 	,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
			{name: 'UNIT_Q'		, text: '원단위량'			, type: 'uniQty'    },
			{name: 'ALLOCK_Q'			, text: '예약량'			, type: 'uniQty'    }
		]
	});
	
	var masterStore = Unilite.createStore('s_pmr110ukrv_mitMasterStore',{
		model	: 's_pmr110ukrv_mitModel',
	 	proxy	: directProxy,
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs	= this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var paramMaster= panelResult.getValues();
				var config = {
						params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							panelResult.setValue("WKORD_NUM", master.WKORD_NUM);
							UniAppManager.setToolbarButtons(['deleteAll'], true);
						}
				}
				this.syncAllDirect(config);
			} else {
		 		 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load : function(store, records) {
				if( !Ext.isEmpty(records))	{
					UniAppManager.setToolbarButtons(['deleteAll'], true);
				} else {
					UniAppManager.setToolbarButtons(['deleteAll'], false);
				}
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			value : UserInfo.divCode,
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype: 'uniTextfield',
			name: 'WKORD_NUM',
			readOnly: true
		},{
			fieldLabel: '실적일',
			name: 'WORK_DATE',
			xtype :'uniDatefield',
			allowBlank : false ,
			value : UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			holdable: 'hold',
			value : 'W40',
			allowBlank:false,
			listeners: {
				beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						 store.filterBy(function(record){
							 return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					}else{
						store.filterBy(function(record){
							return false;
					})
					}
				}
			}
		}, Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				holdable: 'hold',
				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('SPEC',records[0]["SPEC"]);
							panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
							panelResult.setValue('LOT_NO',records[0]["LOT_NO"]);
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('SPEC','');
						panelResult.setValue('PROG_UNIT','');
						panelResult.setValue('LOT_NO', '');

					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		}),{
			fieldLabel: 'LOT번호',
			xtype:'uniTextfield',
			name: 'LOT_NO',
			holdable: 'hold',
			allowBlank:false
		},{
				fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
				xtype: 'uniNumberfield',
				name: 'WKORD_Q',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var cgWkordQ = panelResult.getValue('WKORD_Q');

						if(Ext.isEmpty(cgWkordQ)) return false;
						var records = masterStore.data.items;
						if(records)	{
							Ext.each(records, function(record,i){
								record.set('ALLOCK_Q',(cgWkordQ * record.get("UNIT_Q")));
							});
						}
					}
				}
		},{
			fieldLabel	: '양불구분',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '양품',
				name		: 'ITEM_STATUS',
				inputValue	: '1',
				width		: 60
			},{
				boxLabel	: '불량',
				name		: 'ITEM_STATUS',
				inputValue	: '2',
				width		: 60
			}]
		},{
			fieldLabel: '<t:message code="system.label.product.specialremark" default="특기사항"/>',
			xtype:'uniTextfield',
			name: 'ANSWER',
			width: 570,
			colspan: 2
		},{
			xtype : 'uniTextfield', 
			name  : '_EXCEL_JOBID',
			hidden : true
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
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) ) {
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField) {
								var popupFC = item.up('uniPopupField');
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})
					}
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
				}
				return r;
			}
	});
	var masterGrid = Unilite.createGrid('s_pmr110ukrv_mitGrid', {
		store	: masterStore,
	 	region	: 'center',
	 	tbar    : [{
	 		xtype : 'button',
	 		text  : '<t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/>',
	 		width : 100,
	 		handler: function()	{
				if(UniAppManager.app._needSave())	{
					Unilite.messageBox("저장할 내용이 있습니다. 저장 후 엑셀업로드 하세요.")
					return;
				}
				if (!panelResult.getInvalidMessage()) { 
					return false;
				}
	 			masterStore.loadData({});
	 			var appName = 'Unilite.com.excel.ExcelUploadWin';
	 			if(!excelWindow) {
	 				Unilite.Excel.defineModel('excel.s_pmr110ukrv_mit.sheet01', {
		 				fields: [
		 					{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
		 					{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	},
		 					{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'	},
		 					{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'	},
		 					{name: 'STOCK_UNIT'			, text: '단위'			 ,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
		 					{name: 'UNIT_Q'				, text: '소요량'			 ,type:'uniQty' }
		 				]
		 			});
	 				excelWindow =  Ext.WindowMgr.get(appName);
	 				excelWindow = Ext.create( appName, {
		 				excelConfigName: 's_pmr110ukrv_mit',
	 					modal: false,
	 					extParam: {
	 						'DIV_CODE'				: panelResult.getValue('DIV_CODE'),
	 						'WH_CODE'               : panelResult.getValue('WORK_SHOP_CODE'),
	 						'WKORD_Q'               : panelResult.getValue('WKORD_Q'),
	 						'LOT_NO'                : panelResult.getValue('LOT_NO')
	 					},
	 					grids: [{
	 						itemId		: 'grid01',
	 						title		: '생산마감업로드',
	 						useCheckbox	: true,
	 						model		: 'excel.s_pmr110ukrv_mit.sheet01',
	 						readApi		: 's_pmr110ukrv_mitService.selectExcelUploadSheet1',
	 						columns		: [
	 							{ dataIndex: 'DIV_CODE',	width: 80	},
	 							{ dataIndex: 'ITEM_CODE',			width: 120	},
	 							{ dataIndex: 'ITEM_NAME',			width: 120	},
	 							{ dataIndex: 'SPEC',				width: 120	},
	 							{ dataIndex: 'STOCK_UNIT',			width: 120	},
	 							{ dataIndex: 'UNIT_Q',			width: 120	}
	 						]
	 					}],
	 					listeners: {
	 						close: function() {
	 							this.hide();
	 						},
	 						hide: function() {
	 							excelWindow.down('#grid01').getStore().loadData({});
	 							this.hide();
	 						}
	 					},
	 					onApply:function() {
	 						var grid = this.down('#grid01');
	 						var records = grid.getSelectionModel().getSelection();
	 						Ext.each(records, function(rec,i){
	 							rec.data.SEQ = i+1;
	 							masterGrid.createRow(rec.data);
	 							if(i==0)	{
	 								panelResult.setValue('_EXCEL_JOBID', rec.data._EXCEL_JOBID);
	 							}
	 						});
	 						grid.getStore().remove(records);
	 						grid.getView().refresh();
	 					}
	 				});
	 			}
	 			excelWindow.center();
	 			excelWindow.show();
	 		}
	 	}],
		columns:[
			{dataIndex: 'DIV_CODE'			, width: 93	, hidden: true},
			{dataIndex: 'SEQ'				, width: 80	},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 200},
			{dataIndex: 'STOCK_UNIT'		, width: 120},
			{dataIndex: 'UNIT_Q'			, width: 120},
			{dataIndex: 'ALLOCK_Q'			, width: 120}
			
		]
	});
	
	
	/**
	 * 작업지시를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	 //조회창 폼 정의
	var productionNoSearch = Unilite.createSearchForm('productionNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				hidden:true
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				allowBlank:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();

						if(!Ext.isEmpty(productionNoSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == productionNoSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_PRODT_DATE',
				endFieldName: 'TO_PRODT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);

								},
								scope: this
							},
							onClear: function(type) {

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name:'LOT_NO',
				width:315
			},{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name:'WKORD_NUM',
				width:315
			}]
	}); // createSearchForm

	// 조회창 모델 정의
	Unilite.defineModel('productionNoMasterModel', {
		fields: [
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	 , type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'PRODT_WKORD_DATE'	, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'		, type: 'uniDate'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	 , type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product. wkordq" default="작지수량"/>'			, type: 'uniQty'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.planno" default="계획번호"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		 , type: 'string' , comboType: 'WU'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'			 , type: 'string'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT_NO'			, type: 'string'},

			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'		, type: 'string'},

			{name: 'CUSTOM_NAME'				, text: '<t:message code="system.label.product.custom" default="거래처"/>'		 , type: 'string'},
			{name: 'REWORK_YN'			, text: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>'	, type: 'string'},
			{name: 'STOCK_EXCHG_TYPE'	, text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'		, type: 'string'},
			{name: 'WKORD_PRSN'			, text: 'WKORD_PRSN'		, type: 'string'}
		]
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr110ukrv_mitService.selectWorkNum'
		}
	});
	
	//조회창 스토어 정의
	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
		model: 'productionNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords : function() {
			var param= productionNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var productionNoMasterGrid = Unilite.createGrid('pmp110ukrvproductionNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: productionNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 120 },
			{ dataIndex: 'WKORD_NUM'		, width: 120 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 166 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_START_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_END_DATE'	, width: 80 },
			{ dataIndex: 'WKORD_Q'			, width: 73 },
			{ dataIndex: 'REMARK'			, width: 100 },
			{ dataIndex: 'PROJECT_NO'		, width: 100 },
			{ dataIndex: 'PJT_CODE'			, width: 100 },
			{ dataIndex: 'LOT_NO'			, width: 133 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
				return;
			}
			panelResult.setValues({
				'DIV_CODE':record.get('DIV_CODE'),				/*사업장*/		
				'WKORD_NUM':record.get('WKORD_NUM'),			/*작업지시번호*/
				'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'),	/* 작업장*/	
				'ITEM_CODE':record.get('ITEM_CODE'),			/*품목코드*/
				'ITEM_NAME':record.get('ITEM_NAME'),			/*품목명*/		
				'LOT_NO':record.get('LOT_NO'),
				'WKORD_Q':record.get('WKORD_Q'),
				'ANSWER':record.get('REMARK'),
				'ITEM_STATUS':record.get('ITEM_STATUS'),
				'WORK_DATE':record.get('PRODT_WKORD_DATE')
			});

			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('WKORD_NUM').setReadOnly( true );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('LOT_NO').setReadOnly( true );
			
			panelResult.getField('ITEM_STATUS').setReadOnly( true );

		}
	});
	
	//조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
				width: 830,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [productionNoSearch, productionNoMasterGrid],
				tbar:['->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							if(!productionNoSearch.getInvalidMessage()) {
								return false;
							}
							productionNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							searchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ){
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						productionNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						productionNoSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
						productionNoSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
						productionNoSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));

						productionNoSearch.setValue('FR_PRODT_DATE',UniDate.get('startOfMonth'));
						productionNoSearch.setValue('TO_PRODT_DATE',UniDate.get('today'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}
	
	Unilite.Main({
		id			: 's_pmr110ukrv_mitApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],

		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['newData'],false);
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("WORK_DATE", UniDate.get('today'));
			panelResult.setValue('WORK_SHOP_CODE','W40');
			panelResult.getField('ITEM_STATUS').setValue('2');
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			
		},

		onQueryButtonDown: function () {
			var orderNo = panelResult.getValue('WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow();

			} else {
				masterStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
				panelResult.getField('WKORD_Q').setReadOnly( false );
				panelResult.getField('ANSWER').setReadOnly( false );
	
			}
			
		},
		onDeleteAllButtonDown : function()	{
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = panelResult.getValue('DIV_CODE')
				var wkordNum = panelResult.getValue('WKORD_NUM');
				s_pmr110ukrv_mitService.deleteAll({
							DIV_CODE : divCode,
							WKORD_NUM : wkordNum
						}, function(responseText){
							if(responseText) {
								UniAppManager.updateStatus("삭제되었습니다.");
								UniAppManager.app.onResetButtonDown();
							}
						});
			}
		},
		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) { 
				return false;
			}
			masterStore.saveStore(config);	
		},				
				
		onResetButtonDown: function() {
			panelResult.clearForm();	
			masterGrid.getStore().loadData({});	
			masterStore.clearData();	
			panelResult.getField('DIV_CODE').setReadOnly( false );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			panelResult.getField('ITEM_CODE').setReadOnly( false );
			panelResult.getField('ITEM_NAME').setReadOnly( false );
			panelResult.getField('LOT_NO').setReadOnly( false );
			this.fnInitBinding();	
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

};
</script>