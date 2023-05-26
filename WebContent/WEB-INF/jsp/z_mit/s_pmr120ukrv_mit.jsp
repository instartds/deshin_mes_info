<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr120ukrv_mit">
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
			read	: 's_pmr120ukrv_mitService.selectList',
			create	: 's_pmr120ukrv_mitService.updateList',
			syncAll	: 's_pmr120ukrv_mitService.saveAll'
		}
	});

	
	Unilite.defineModel('s_pmr120ukrv_mitModel', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: '엑셀업로드ID'		, type: 'string'	, allowBlank: false, editable:false},
			{name: '_EXCEL_ROWNUM'      , text: '엑셀업로드RowNum'	, type: 'string'	, allowBlank: false, editable:false},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'	, allowBlank: false, comboType: 'BOR120', editable:false},
			{name: 'WKORD_NUM'			, text: '작업지시번호'	, type: 'string'	, allowBlank: false},
			{name: 'PRODT_MONTH'		, text: '작업월'			, type: 'string'	, editable:false},
			{name: 'PRODT_DATE'			, text: '생산일'			, type: 'string'	, editable:false},
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'	, editable:false},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'	, editable:false},
			{name: 'SPEC'				, text: '규격'			, type: 'string'	, editable:false},
			{name: 'PRODT_Q'			, text: '생산량'			, type: 'uniQty'    , editable:false}
		]
	});
	
	var masterStore = Unilite.createStore('s_pmr120ukrv_mitMasterStore',{
		model	: 's_pmr120ukrv_mitModel',
	 	proxy	: directProxy,
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false,			// prev | next 버튼 사용
			allDeletable: true
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
		layout	: {type : 'uniTable', columns : 3
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
			fieldLabel: '작업월',
			name: 'PRODT_MONTH',
			xtype :'uniMonthfield',
			allowBlank : false ,
			value : UniDate.get('today')
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
	var masterGrid = Unilite.createGrid('s_pmr120ukrv_mitGrid', {
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
	 				Unilite.Excel.defineModel('excel.s_pmr120ukrv_mit.sheet01', {
		 				fields: [
		 					{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
		 					{name: 'PRODT_DATE'          , text: '생산일'	, type: 'string'},
		 					{name: 'WKORD_NUM'			, text: '작업지시번호'	, type: 'string'    },
		 					{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	},
		 					{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'	},
		 					{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'	},
		 					{name: 'PRODT_Q'			, text: '생산량'			 ,type:'uniQty' }
		 				]
		 			});
	 				excelWindow =  Ext.WindowMgr.get(appName);
	 				excelWindow = Ext.create( appName, {
		 				excelConfigName: 's_pmr120ukrv_mit',
	 					modal: false,
	 					extParam: {
	 						'DIV_CODE'				: panelResult.getValue('DIV_CODE'),
	 						'PRODT_MONTH'               : panelResult.getValue('PRODT_MONTH')
	 					},
	 					grids: [{
	 						itemId		: 'grid01',
	 						title		: '생산실적업로드',
	 						useCheckbox	: true,
	 						model		: 'excel.s_pmr120ukrv_mit.sheet01',
	 						readApi		: 's_pmr120ukrv_mitService.selectExcelUploadSheet1',
	 						columns		: [
	 							{ dataIndex: 'DIV_CODE',	width: 80	},
	 							{ dataIndex: 'PRODT_DATE',			width: 120	, hidden : true},
	 							{ dataIndex: 'WKORD_NUM',			width: 120	},
	 							{ dataIndex: 'ITEM_CODE',			width: 120	},
	 							{ dataIndex: 'ITEM_NAME',			width: 120	},
	 							{ dataIndex: 'SPEC',				width: 120	},
	 							{ dataIndex: 'PROD_Q',			width: 120	}
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
	 						UniAppManager.app.onSaveDataButtonDown();
	 						excelWindow.hide();
	 					},
	 					readGridData: function( jobId ) {
		 					var me = this;
		 					panelResult.setValue('_EXCEL_JOBID', jobId);
		 					
		 					var param = {
		 						_EXCEL_JOBID: jobId,
		 						'DIV_CODE'	  : panelResult.getValue('DIV_CODE'),
		 						'PRODT_MONTH' : panelResult.getValue('PRODT_MONTH')
		 					}
		 					if (me.extParam) {
		 						param = Ext.apply(param, me.extParam);
		 					}
	 						var grid = me.down('#grid01');
	 						grid.getStore().load({
	 							params : param,
	 							callback : function(responseText)	{
	 								if(responseText && responseText.length > 0 )	{
	 									Ext.getBody().mask();
	 									grid.getSelectionModel().selectAll();
	 									excelWindow.onApply();
	 								} 
	 							}
	 						});
	 					
	 					}
	 				});
	 			}
	 			excelWindow.extParam = {
						'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
						'PRODT_MONTH'	: UniDate.getMonthStr(panelResult.getValue('PRODT_MONTH'))
					};
	 			excelWindow.center();
	 			excelWindow.show();
	 		}
	 	}],
		columns:[
			{dataIndex: 'DIV_CODE'			, width: 93	, hidden: true},
			{dataIndex: 'WKORD_NUM'				, width: 120	},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 200},
			{dataIndex: 'PRODT_DATE'		, width: 120, align:'center'},
			{dataIndex: 'PRODT_Q'			, width: 120}
			
		]
	});

	
	Unilite.Main({
		id			: 's_pmr120ukrv_mitApp',
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
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			
		},

		onQueryButtonDown: function () {
			masterStore.loadStoreRecords();
		},
		onDeleteAllButtonDown : function()	{
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = panelResult.getValue('DIV_CODE')
				var excelJobId = panelResult.getValue('_EXCEL_JOBID');
				s_pmr120ukrv_mitService.deleteAll({
							DIV_CODE : divCode,
							_EXCEL_JOBID : excelJobId
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
			panelResult.getField('PRODT_MONTH').setReadOnly( false );
			this.fnInitBinding();	
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

};
</script>