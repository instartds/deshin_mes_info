<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_out220ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_out220ukrv_mit"/>
	<t:ExtComboStore items="${WORKER_CODE}" storeId="workerCode" /> <!-- 작업자코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var excelWindow;

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_out220ukrv_mitService.selectList',
			update: 's_out220ukrv_mitService.updateList',
			create: 's_out220ukrv_mitService.insertList',
			destroy: 's_out220ukrv_mitService.deleteList',
			syncAll: 's_out220ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_out220ukrv_mitModel', {
	    fields: [  	
	    	  {name : 'DIV_CODE'                    , text : '사업장코드'                        	, type : 'string'           , allowBlank : false, comboType:"BOR120"}
	    	, {name : 'BASIS_YYYYMM'                , text : '현재월	'                         	, type : 'string'           , allowBlank : false}
	    	, {name : 'PRODT_PRSN'                  , text : '작업자코드'                        	, type : 'string'           , allowBlank : false          , store : Ext.data.StoreManager.lookup('workerCode')  }
	    	, {name : 'RETRO_AMT'                   , text : '소급비용'                         	, type : 'uniPrice'                                        }
	    	, {name : 'REMARK'                      , text : '비고'                           	, type : 'string'                                          }
	    ]
	});
	function getMonthFormat(v)	{
		return Ext.isDate(v) ? Ext.Date.format(v,'Y.m') : v;
	}
	var directMasterStore = Unilite.createStore('s_out220ukrv_mitMasterStore',{
		model: 's_out220ukrv_mitModel',
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
			fieldLabel		: '급여월',
			xtype			: 'uniMonthfield',
			name	        : 'BASIS_YYYYMM',
			endFieldName	: 'TO_DATE',
			value			: UniDate.get('today'),
			allowBlank	: false
		}],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("DIV_CODE").setReadOnly(disable);
			me.getField("BASIS_YYYYMM").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_out220ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,

        columns:  [     
        	    {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
        	  , {dataIndex : 'BASIS_YYYYMM'                     , width : 80    ,hidden : true}
        	  , {dataIndex : 'PRODT_PRSN'                       , width : 100                  }
        	  , {dataIndex : 'RETRO_AMT'                        , width : 150                  }
        	  , {dataIndex : 'REMARK'                           , width : 350                  }
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom)	{
					return true
				} else if(e.field == 'RETRO_AMT' || e.field == 'REMARK' ){
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
		id: 's_out220ukrv_mitApp',
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
			panelResult.setDisablekeys(true);
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
