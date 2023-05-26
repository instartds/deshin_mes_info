<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_out210ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_out210ukrv_mit"/>
	<t:ExtComboStore comboType="WU" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var excelWindow;

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_out210ukrv_mitService.selectList',
		}
	});	
	
	Unilite.defineModel('s_out210ukrv_mitModel', {
	    fields: [  	
	    	  {name : 'DIV_CODE'       	, text : '사업장코드' 		, type : 'string' 	}
	    	, {name : 'BASIS_YYYYMM'   	, text : '현재월	'      	, type : 'string' 	}
	    	, {name : 'ITEM_CODE'     	, text : '품목코드'      	, type : 'string' 	}
	    	, {name : 'ITEM_NAME'      	, text : '품목명'        	, type : 'string'  	}
	    	, {name : 'SPEC'           	, text : '규격'         	, type : 'string'  	}
	    	, {name : 'PRODT_PRSN_GROUP', text : '작업자'   	    , type : 'string'  	}
	    	, {name : 'PRODT_PRSN'    	, text : '작업자코드'   	, type : 'string'  	}
	    	, {name : 'PRODT_PRSN_NAME'	, text : '작업자명	'     	, type : 'string' 	}
	    	, {name : 'GOOD_WORK_Q'    	, text : '양품생산량'    	, type : 'uniQty' 	}
	    	, {name : 'BAD_WORK_Q'     	, text : '불량수량'      	, type : 'uniQty'  	}
	    	, {name : 'TOT_WORK_Q'     	, text : '총계'        	, type : 'uniQty'  	}
	    	, {name : 'ONEDAY_AMT'     	, text : '긴급작업비'    	, type : 'uniPrice'	}
	    	, {name : 'PROD_AMT'      	, text : '일반작업비'    	, type : 'uniPrice'	}
	    	, {name : 'TOT_AMT'       	, text : '총엮기비용'    	, type : 'uniPrice'	}
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_out210ukrv_mitMasterStore',{
		model: 's_out210ukrv_mitModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
      		
        	if(panelResult.getInvalidMessage())	{
        		this.clearFilter();
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param,
					callback:function(responseText, response) {
						if(response.success)	{
							if(Ext.isEmpty(responseText)){
								Unilite.messageBox("생산집계를 먼저 진행해주세요");
							}
						}
					}
				});
        	}
		},
		groupField : 'PRODT_PRSN'
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 6},
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
			fieldLabel		: '생산월',
			xtype			: 'uniMonthfield',
			name	        : 'BASIS_YYYYMM',
			endFieldName	: 'TO_DATE',
			value			: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '작업장'  ,
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			value       :  'W10',
			allowBlank	: false
		},{
			xtype : 'uniRadiogroup',
			fieldLabel : '집계방식',
			name:'INPUT_PATH',
			width : 300,
			items : [
				{name:'INPUT_PATH', boxLabel:'생산실적'   	, inputValue : 'P' , width : 90 , style : 'margin-left : 30px;', checked : true},
				{name:'INPUT_PATH', boxLabel:'엑셀업로드' 	, inputValue : 'E' , width : 90 }
			],
			listeners : {
				change : function(field, newValue, oldValue)	{
					if(newValue.INPUT_PATH != oldValue.INPUT_PATH){
						if(newValue.INPUT_PATH == "P")	{
							panelResult.down('#btnSum').setDisabled(false);
							panelResult.down('#btnExcel').setDisabled(true);
						} else {
							panelResult.down('#btnSum').setDisabled(true);
							panelResult.down('#btnExcel').setDisabled(false);
						}
					}
				}
			}
		},{
			xtype       : 'button',
			text        : '생산집계',
			itemId      : 'btnSum',
			width       : 100,
			tdAttrs     : {width : '120', align:'right'},
			handler     : function()	{
				if(panelResult.getInvalidMessage())	{
					Ext.getBody().mask();
					s_out210ukrv_mitService.excuteProduceCost(panelResult.getValues(), function(responseText) {
						Ext.getBody().unmask();
						if(responseText)	{
							UniAppManager.updateStatus("생산집계가 완료되었습니다.");
							UniAppManager.app.onQueryButtonDown();
						}
					});
				}
			}
		},{
	 		xtype    : 'button',
	 		text     : '엑셀 업로드',
	 		width    : 100,
	 		itemId   : 'btnExcel',
	 		disabled : true,
	 		tdAttrs  : {width : '120', align:'right'},
	 		handler  : function()	{
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
	 				Unilite.Excel.defineModel('excel.s_out210ukrv_mit.sheet01', {
		 				fields: [
		 					{name: 'BASIS_YYYYMMDD'		, text: '생산연월'	, type: 'string'	, comboType: 'BOR120'},
		 					{name: 'ITEM_CODE'			, text: '품목코드'				, type: 'string'	},
		 					{name: 'PRODT_PRSN'			, text: '작업자'			, type: 'string'	},
		 					{name: 'WORK_SHOP_CODE'		, text: '작업장'				, type: 'string'	},
		 					{name: 'GOOD_WORK_Q'		, text: '양품생산량'			 ,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
		 					{name: 'BAD_WORK_Q'			, text: '불량생산량'			 ,type:'uniQty' }
		 				]
		 			});
	 				excelWindow =  Ext.WindowMgr.get(appName);
	 				excelWindow = Ext.create( appName, {
		 				excelConfigName: 's_out210ukrv_mit',
	 					modal: false,
	 					extParam: {
	 						'DIV_CODE'				: panelResult.getValue('DIV_CODE')
	 					},
	 					grids: [{
	 						itemId		: 'grid01',
	 						title		: '생산집계업로드',
	 						useCheckbox	: false,
	 						model		: 'excel.s_out210ukrv_mit.sheet01',
	 						readApi		: 's_out210ukrv_mitService.selectExcelUploadSheet1',
	 						columns		: [
	 							{ dataIndex: 'BASIS_YYYYMMDD',			width: 120	},
	 							{ dataIndex: 'ITEM_CODE',			width: 120	},
	 							{ dataIndex: 'PRODT_PRSN',				width: 120	},
	 							{ dataIndex: 'WORK_SHOP_CODE',			width: 120	},
	 							{ dataIndex: 'GOOD_WORK_Q',			width: 120	},
	 							{ dataIndex: 'BAD_WORK_Q',			width: 120	}
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
	 					},
	 					readGridData: function( jobId ) {
		 					var me = this;
		 					var param = {
		 						_EXCEL_JOBID: jobId
		 					}
		 					if (me.extParam) {
		 						param = Ext.apply(param, me.extParam);
		 					}
		 					
	 						var cfg = this.grids[i];
	 						var grid = me.down('#'+cfg.itemId);
	 						grid.getStore().load({
	 							params : param,
	 							callback : function(responseText)	{
	 								if(responseText && responseText.length == 0 )	{
	 									Ext.getBody().mask();
	 									s_out210ukrv_mitService.selectExcelUpdatedList(param, function(responseText2){
	 										if(responseText2 && responseText2.length > 0 ) {
	 											directMasterStore.loadData(responseText2)
	 										}
		 									excelWindow.hide();
	 										Ext.getBody().unmask();	
	 									})
	 								} else {
	 									Ext.getBody().mask();
	 									s_out210ukrv_mitService.selectExcelUpdatedList(param, function(responseText2){
	 										if(responseText2 && responseText2.length > 0 ) {
	 											directMasterStore.loadData(responseText2)
	 										}
	 										Ext.getBody().unmask();	
	 									})
	 								}
	 							}
	 						});
	 					
	 					}
	 				});
	 			}
	 			excelWindow.extParam = {'DIV_CODE': panelResult.getValue('DIV_CODE')}
	 			excelWindow.center();
	 			excelWindow.show();
	 		}
	 	}]
	});	
	
    var masterGrid = Unilite.createGrid('s_out210ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt :{
    		filter: {
    			useFilter: true,		//컬럼 filter 사용 여부
    			autoCreate: true		//컬럼 필터 자동 생성 여부
    		}
    	},
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'PRODT_PRSN_GROUP'   	, width : 100	, hidden:true}
         	, {dataIndex : 'PRODT_PRSN_NAME'       	, width : 100  	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			  }}
         	, {dataIndex : 'PRODT_PRSN'   		, width : 100	}
         	, {dataIndex : 'ITEM_CODE'        	, width : 100	}
         	, {dataIndex : 'ITEM_NAME'        	, width : 200 	}
         	, {dataIndex : 'SPEC'            	, width : 200 	}
         	, {dataIndex : 'GOOD_WORK_Q'      	, width : 100  	 , summaryType : 'sum'}
         	, {dataIndex : 'BAD_WORK_Q'       	, width : 100    , summaryType : 'sum'}
         	, {dataIndex : 'TOT_WORK_Q'       	, width : 100    , summaryType : 'sum'}
         	, {dataIndex : 'ONEDAY_AMT'        	, width : 100    , summaryType : 'sum'}
         	, {dataIndex : 'PROD_AMT'          	, width : 100 	 , summaryType : 'sum'}
         	, {dataIndex : 'TOT_AMT'          	, width : 100 	 , summaryType : 'sum'}
		]
    });  
    
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_out210ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("BASIS_YYYYMM", UniDate.get('today'));
			panelResult.setValue("WORK_SHOP_CODE", "W10");
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		}
		
	});	
};


</script>
