<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_out100ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_out100ukrv_mit"/>
	<t:ExtComboStore items="${WORKER_CODE}" storeId="workerCode" /> <!-- 작업자코드 -->
	<t:ExtComboStore comboType="AU" comboCode="ZP11"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_out100ukrv_mitService.selectList',
			update: 's_out100ukrv_mitService.updateList',
			create: 's_out100ukrv_mitService.insertList',
			destroy: 's_out100ukrv_mitService.deleteList',
			syncAll: 's_out100ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_out100ukrv_mitModel', {
	    fields: [  	
    			  {name : 'SEQ_NO'              , text : '번호'     	, type : 'string'   	, editable : false		}
	    	    , {name : 'DIV_CODE'          	, text : '사업장코드'	, type : 'string'     	, allowBlank : false	}
	    	    , {name : 'GROUP_CODE'         	, text : '교육그룹'  	, type : 'string'    	, allowBlank : false	, comboType :'AU'  , comboCode:'ZP11'}
	    	    , {name : 'WORKER_NAME'     	, text : '성명(NAME)'	, type : 'string'      	}
	    	    , {name : 'WORKER_CODE'    		, text : '성명'  		, type : 'string'     	, allowBlank : false , store : Ext.data.StoreManager.lookup('workerCode') }
	    	    , {name : 'EDU_FR_DATE'       	, text : '교육시작일'	, type : 'uniDate'     	}
	    	    , {name : 'EDU_TO_DATE'       	, text : '교육종료일'	, type : 'uniDate'   	}
	    	    , {name : 'EDU_DAY'           	, text : '교육일수'	, type : 'int'        	}
	    	    , {name : 'EDU_CONTENTS'      	, text : '교육내용'	, type : 'string'    	}
	    	    , {name : 'DAY_EXPENSE_AMT'   	, text : '일비'  		, type : 'uniPrice'   	}
	    	    , {name : 'TOT_EXPENSE_AMT'  	, text : '총일비'   	, type : 'uniPrice'   	}
	    	    , {name : 'REMARK'            	, text : '비고'    	, type : 'string'      	}
	    		, 
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_out100ukrv_mitMasterStore',{
		model: 's_out100ukrv_mitModel',
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
						UniAppManager.app.onQueryButtonDown()
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
			fieldLabel		: '교육기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			labelWidth      : 90,
			startDate		: UniDate.get('startOfYear'),
			endDate			: UniDate.get('endOfMonth'),
			allowBlank	: false
		}],
		setDisablekeys: function(disable) {
			var me = this;
			//me.getField("FR_DATE").setReadOnly(disable);
			//me.getField("TO_DATE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_out100ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt:{
    		useContextMenu : true,
    		copiedRow : true
    	},
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
        	, {dataIndex : 'GROUP_CODE'                       , width : 100            ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			    }      
        	   }
        	, {dataIndex : 'WORKER_CODE'                      , width : 100                  }
        	, {dataIndex : 'EDU_FR_DATE'                      , width : 80                   }
        	, {dataIndex : 'EDU_TO_DATE'                      , width : 80                   }
        	, {dataIndex : 'EDU_DAY'                          , width : 80                   }
        	, {dataIndex : 'EDU_CONTENTS'                     , width : 300                  }
        	, {dataIndex : 'DAY_EXPENSE_AMT'                  , width : 80      , summaryType : 'sum'            }
        	, {dataIndex : 'TOT_EXPENSE_AMT'                  , width : 80      , summaryType : 'sum'            }
        	, {dataIndex : 'REMARK'                           , width : 150                  }
		],
		listeners :{
			beforePasteRecord : function( index, record, arg1, arg2)	{
				record.WORKER_CODE = '';
				record.WORKER_NAME = '';
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_out100ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "01");
			panelResult.setValue("FR_DATE", UniDate.get('startOfMonth'));
			panelResult.setValue("TO_DATE", UniDate.get('endOfMonth'));
			
			panelResult.setDisablekeys(false);
			
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var r = {};
            if(Ext.isEmpty(masterGrid.getSelectedRecord()))	{
            	r = {
	            	'DIV_CODE': panelResult.getValue("DIV_CODE"),
	        	 	'EDU_FR_DATE': UniDate.getDbDateStr(panelResult.getValue("FR_DATE")),
	        	 	'EDU_TO_DATE': UniDate.getDbDateStr(panelResult.getValue("FR_DATE")),
	        	 	'EDU_DAY' : 1
	        	};
            } else {
            	var record = masterGrid.getSelectedRecord();
            	r = {
            			  DIV_CODE        :  record.get("DIV_CODE")      
            			, EDU_FR_DATE     :  record.get("EDU_FR_DATE") 
            			, EDU_TO_DATE     :  record.get("EDU_TO_DATE") 
            			, EDU_DAY         :  record.get("EDU_DAY") 
            			, EDU_CONTENTS    :  record.get("EDU_CONTENTS") 
            			, REMARK          :  record.get("REMARK") 
            	}
            }
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
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "EDU_FR_DATE" :		
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(record.get("EDU_TO_DATE")) )	{
						var eduDay = UniDate.diffDays(newValue, record.get("EDU_TO_DATE"))+1;
						record.set('EDU_DAY', eduDay);
						record.set('TOT_EXPENSE_AMT',   Unilite.multiply(eduDay,record.get("DAY_EXPENSE_AMT")) );
					}
					break;
				case "EDU_TO_DATE" :	
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(record.get("EDU_FR_DATE")) )	{
						var eduDay = UniDate.diffDays(record.get("EDU_FR_DATE"), newValue)+1;
						record.set('EDU_DAY', eduDay);
						record.set('TOT_EXPENSE_AMT', Unilite.multiply(eduDay,record.get("DAY_EXPENSE_AMT")) );
					}
					break;
				case "GROUP_CODE" :		
					var groupStore = Ext.data.StoreManager.lookup("CBS_AU_ZP11");
					var dayFee = 0
					Ext.each(groupStore.getData().items, function(rec){
						if(rec.get("value") == newValue)	{
							dayFee = parseInt(rec.get("refCode1"));
							record.set('DAY_EXPENSE_AMT', dayFee);
						}
					});
					if(!Ext.isEmpty(record.get('EDU_DAY')) )	{
						record.set('TOT_EXPENSE_AMT', Unilite.multiply(record.get('EDU_DAY'),dayFee) );
					}
					break;
				case "EDU_DAY" :
					record.set('TOT_EXPENSE_AMT', Unilite.multiply(newValue, record.get('DAY_EXPENSE_AMT')) );
					break;
				case "WORKER_CODE" :		
					var workerStore = Ext.data.StoreManager.lookup("workerCode");
					Ext.each(workerStore.getData().items, function(rec){
						if(rec.get("value") == newValue)	{
							record.set('WORKER_NAME', rec.get('text'));
						}
					});
					break;
				default:
					break;
			}
		
			return rv;
		}
	})			
};


</script>
