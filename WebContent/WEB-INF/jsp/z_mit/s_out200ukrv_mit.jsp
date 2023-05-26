<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_out200ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_out200ukrv_mit"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var excelWindow;

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_out200ukrv_mitService.selectList',
			update: 's_out200ukrv_mitService.updateList',
			create: 's_out200ukrv_mitService.insertList',
			destroy: 's_out200ukrv_mitService.deleteList',
			syncAll: 's_out200ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_out200ukrv_mitModel', {
	    fields: [  	
	    	  {name : 'DIV_CODE'                    , text : '사업장코드'                        	, type : 'string'           , isPk:true, pkGen:'user' 		, allowBlank : false, comboType:"BOR120"}
	    	, {name : 'BASIS_YYYYMM'                , text : '기준월	'                         	, type : 'string'           , isPk:true, pkGen:'user'		, allowBlank : false, convert:getMonthFormat}
	    	, {name : 'ITEM_CODE'                   , text : '품목코드'                         	, type : 'string'           , editable : false     	, allowBlank : false}
	    	, {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'           , editable : false     	, allowBlank : false}
	    	, {name : 'SPEC'                        , text : '규격'                         		, type : 'string'           , editable : false     	, allowBlank : false}
	    	, {name : 'ITEM_P'                      , text : '외주단가'                         	, type : 'uniUnitPrice'                                        }
	    ]
	});
	function getMonthFormat(v)	{
		return Ext.isDate(v) ? Ext.Date.format(v,'Y.m') : v;
	}
	var directMasterStore = Unilite.createStore('s_out200ukrv_mitMasterStore',{
		model: 's_out200ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
      
        	if(panelResult.getInvalidMessage())	{
    			panelResult.setDisablekeys(true);
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param
				});
        	}
		},
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				this.syncAllDirect({
					success:function()	{
						//UniAppManager.app.onQueryButtonDown()
					}
				});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       :  UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel		: '기준월',
			xtype			: 'uniMonthfield',
			name	        : 'BASIS_YYYYMM',
			endFieldName	: 'TO_DATE',
			value			: UniDate.get('today'),
			allowBlank	: false
		},Unilite.popup('DIV_PUMOK',{
			fieldLabel:'품목',
			valueFieldName:'ITEM_CODE',
			textFieldName:'ITEM_NAME',
			autoPopup : true
		}),{
			fieldLabel :'기준단가',
			xtype : 'uniRadiogroup',
			items : [
				{name:'SEARCH', boxLabel:'최근' , inputValue : ''  , width : 80, checked:true},
				{name:'SEARCH', boxLabel:'전체' , inputValue : 'A' , width : 80 }
			]
		}],
		setDisablekeys: function(disable) {
			var me = this;
			//me.getField("FR_DATE").setReadOnly(disable);
			//me.getField("TO_DATE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_out200ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,

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
				directMasterStore.loadData({});
	 			var appName = 'Unilite.com.excel.ExcelUploadWin';
	 			if(!excelWindow) {
	 				Unilite.Excel.defineModel('excel.s_out200ukrv_mit.sheet01', {
		 				fields: [
		 					{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
		 					{name: 'BASIS_YYYYMM'		, text: '기준월'				, type: 'string'	},
		 					{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	},
		 					{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'	},
		 					{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'	},
		 					{name: 'ITEM_P'				, text: '단가'			 ,type:'uniUnitPrice' , defaultValue: 0}
		 				]
		 			});
	 				excelWindow =  Ext.WindowMgr.get(appName);
	 				excelWindow = Ext.create( appName, {
		 				excelConfigName: 's_out200ukrv_mit',
	 					modal: false,
	 					extParam: {
	 						'DIV_CODE'				: panelResult.getValue('DIV_CODE')
	 					},
	 					grids: [ {
	 						itemId		: 'grid01',
	 						title		: '스텐트단가업로드',
	 						useCheckbox	: false,
	 						hidden      : true,
	 						model		: 'excel.s_out200ukrv_mit.sheet01',
	 						readApi		: 's_out200ukrv_mitService.selectExcelUploadSheet1',
	 						columns		: [
	 							{ dataIndex: 'BASIS_YYYYMM'	, width: 80	},
	 							{ dataIndex: 'ITEM_CODE'	, width: 120},
	 							{ dataIndex: 'ITEM_NAME'	, width: 120},
	 							{ dataIndex: 'SPEC'			, width: 120},
	 							{ dataIndex: 'ITEM_P'		, width: 120}
	 						]
	 					} ],
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

	 					},
	 					readGridData: function( jobId ) {
	 						var me = this;
	 						var param = {
	 							_EXCEL_JOBID: jobId
	 						}
	 						if (me.extParam) {
	 							param = Ext.apply(param, me.extParam);
	 						}
	 						
	 						for(i in this.grids) {
	 							var cfg = this.grids[i];
	 							var grid = me.down('#'+cfg.itemId);
	 							grid.getStore().load({
	 								params : param,
	 								callback:function(records, arg1, arg2)	{
	 									if(records && records.length > 0 )	{
	 										var valid = true;
	 										var loadData = [];
	 										var inValidData = [];
	 										var baseYm;
	 										Ext.each(records, function(rec) {
	 											if(rec.get('_EXCEL_HAS_ERROR') == "Y")	{
	 												valid = false;
	 												inValidData.push(rec);
	 											} else {
	 												if(Ext.isEmpty(baseYm))	{
	 													baseYm = rec.get("BASIS_YYYYMM")
	 												}
	 												loadData.push(rec);
	 											}
	 										});
	 										if(!Ext.isEmpty(baseYm))	{
	 											panelResult.setValue("BASIS_YYYYMM", baseYm);
	 										}
	 										grid.getStore().remove(loadData);
	 										//directMasterStore.loadData(loadData);
	 										UniAppManager.app.onQueryButtonDown();
	 										if(valid) me.close();
	 									}
	 								}
	 							});
	 						}
	 						
	 					}
	 				});
	 			}
	 			excelWindow.center();
	 			var grid = excelWindow.down('#grid01');
	 			if(grid && grid.isVisible()) {
	 				grid.hide();
	 			}
	 			excelWindow.down('tabpanel').setActiveTab(0);
	 			excelWindow.show();
	 		}
	 	}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
         	, {dataIndex : 'BASIS_YYYYMM'                       , width : 80	,
         		xtype :'uniMonthColumn', editor:{xtype:'uniMonthfield', format:'Y.m'}, format:'Y.m'}
         	, {dataIndex : 'ITEM_CODE'                        , width : 100	
         	   ,editor:Unilite.popup('DIV_PUMOK_G', {
	        		textFieldName:'ITEM_CODE',
	 				DBtextFieldName: 'ITEM_CODE',
	 				autoPopup : true,
	        		 listeners:{
	 	        		onSelected: {
	 						fn: function(records, type) {
	 							if(records) {
	 								var record = masterGrid.uniOpt.currentRecord;
	 								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
	 								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
	 								record.set('SPEC', records[0]["SPEC"]);
	 							}
	 						},
	 						scope: this
	 					},
	 					onClear: function(type) {
	 						var record = masterGrid.uniOpt.currentRecord;
	 						record.set('ITEM_CODE', '');
	 						record.set('ITEM_NAME', '');
	 						record.set('SPEC', '');
	 					},
	 					applyextparam: function(popup){
	 						var record = masterGrid.uniOpt.currentRecord;
	 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
	 					}
	 	        	}
        	 })}
         	, {dataIndex : 'ITEM_NAME'                        , width : 250 }
         	, {dataIndex : 'SPEC'                             , width : 250 }
         	, {dataIndex : 'ITEM_P'                       , width : 100 }
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom && (e.field == 'ITEM_CODE' || e.field == 'BASIS_YYYYMM') ){
					return true;
				} else if(e.field == 'ITEM_P')	{
					return true;
				} else {
					return false;
				}
			} 
		}
    });  
    
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_out200ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "01");
			panelResult.setValue("BASIS_YYYYMM", UniDate.get('today'));
			
			panelResult.setDisablekeys(false);
			
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var r = {
	            	'DIV_CODE': panelResult.getValue("DIV_CODE"),
	        	 	'BASIS_YYYYMM': Ext.Date.format(panelResult.getValue("BASIS_YYYYMM"), 'Y.m')
	        	};
            
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}
	});	
};


</script>
