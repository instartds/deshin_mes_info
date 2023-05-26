<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr300ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmr300ukrv_mit"/>
	<t:ExtComboStore comboType="WU"/>								<!-- 작업장 -->
	<t:ExtComboStore comboType="OU"/>                               <!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="P003"/> 
	<t:ExtComboStore comboType="AU" comboCode="Z033"/> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var defaultWhCode = {
		divCode  : UserInfo.divCode,
		frWhCode : '${FR_WH_CODE}',
		frWhCellCode : '${FR_WH_CELL_CODE}',
		toWhCode : '${TO_WH_CODE}',
		toWhCellCode : '${TO_WH_CELL_CODE}'
	}
	
function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr300ukrv_mitService.selectList',
			update: 's_pmr300ukrv_mitService.updateList',
			create: 's_pmr300ukrv_mitService.insertList',
			destroy: 's_pmr300ukrv_mitService.deleteList',
			syncAll: 's_pmr300ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_pmr300ukrv_mitModel', {
	    fields: [  	    
    	    {name : 'DIV_CODE'                    , text : '사업장'                 	       	, type : 'string'          	, allowBlank : false         , child:'FR_WH_CELL_CODE'  }
    	  , {name : 'ITEM_CODE'                   , text : '품목코드'                         	, type : 'string'          	, allowBlank : false           }
    	  , {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'          	, allowBlank : false           }
    	  , {name : 'SPEC'                        , text : '규격'                         	, type : 'string'          	, allowBlank : false         , editable:false}
    	  , {name : 'MANAGE_NO'                   , text : '관리번호'                         	, type : 'string'  , isPk:true, pkGen:'user'}
    	  , {name : 'MANAGE_SEQ'                  , text : '순번'                           	, type : 'int'     , isPk:true, pkGen:'user'}
    	  , {name : 'WORK_SHOP_CODE'              , text : '작업장'                          	, type : 'string'  }
    	  , {name : 'INOUT_DATE'                  , text : '발생일'                          	, type : 'uniDate'  }
    	  , {name : 'BAD_CODE'                    , text : '불량코드'                         	, type : 'string'  }
    	  , {name : 'BAD_NAME'                    , text : '불량유형'                         	, type : 'string'  , allowBlank : false}
    	  , {name : 'LOT_NO'                      , text : 'LOT NO'                       	, type : 'string'  , allowBlank : false}
    	  , {name : 'BAD_Q'                       , text : '불량수량'                         	, type : 'uniPrice'}
    	  , {name : 'REMARK'                      , text : '비고'                           	, type : 'string'  }
    	  , {name : 'FR_WH_CODE'                  , text : '출고창고'                         	, type : 'string'           , comboType:'OU',  child : 'FR_WH_CELL_CODE',  parent    : 'DIV_CODE', editable :false}
    	  , {name : 'FR_WH_CELL_CODE'             , text : '출고창고CELL'                     	, type : 'string'           , store		: Ext.data.StoreManager.lookup('whCellList')             , editable :false}
    	  , {name : 'TO_WH_CODE'                  , text : '입고창고'                         	, type : 'string'           , comboType:'OU',  child : 'FR_WH_CELL_CODE',  parent    : 'DIV_CODE' }
    	  , {name : 'TO_WH_CELL_CODE'             , text : '입고창고CELL'                     	, type : 'string'           , store		: Ext.data.StoreManager.lookup('whCellList')              }
    	  , {name : 'INOUT_NUM'                   , text : '이동출고번호'                      	, type : 'string'  }
    	  , {name : 'INOUT_SEQ'                   , text : '이동출고순번'                      	, type : 'int'}
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_pmr300ukrv_mitMasterStore',{
		model: 's_pmr300ukrv_mitModel',
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
				this.syncAllDirect({});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records){


			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners   :{
				change  : function(field, newValue, oldValue)	{
					if(newValue != oldValue && !Ext.isEmpty(newValue))	{
						UniAppManager.app.getDefaultWhCode(newValue);
					}
				}
			}
		},{
			fieldLabel	: '작업장'  ,
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			allowBlank	: false,
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
		},{
			fieldLabel	: '발생일',
			xtype	    : 'uniDatefield',
			name	    : 'INOUT_DATE',
			endDate			: UniDate.get('today'),
			allowBlank	: false
		}
		,Unilite.popup('ITEM',{
			fieldLabel:'품목',
			valueFieldName:'ITEM_CODE',
			textFieldName:'ITEM_NAME',
			autoPopup : true,
			colspan : 2
		})],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("DIV_CODE").setReadOnly(disable);
			me.getField("WORK_SHOP_CODE").setReadOnly(disable);
			me.getField("INOUT_DATE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_pmr300ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt:{
    		expandLastColumn: false
    	},
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'MANAGE_NO'                        , width : 100  	, hidden : true      }
        	, {dataIndex : 'MANAGE_SEQ'                       , width : 80    	, hidden : true      }
        	, {dataIndex : 'WORK_SHOP_CODE'                   , width : 80    	, hidden : true      }
        	, {dataIndex : 'INOUT_DATE'                       , width : 80   	, hidden : true      }
        	, {dataIndex : 'ITEM_CODE'                        , width : 100     , 
        	   editor:Unilite.popup('DIV_PUMOK_G', {
        		textFieldName:'ITEM_CODE',
 				DBtextFieldName: 'ITEM_CODE',
 				autoPopup : true,
        		 listeners:{
 	        		onSelected: {
 						fn: function(records, type) {
 							if(records) {
 								var record = masterGrid.uniOpt.currentRecord;
 								record.set('DIV_CODE', records[0]["DIV_CODE"]);
 								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
 								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
 								record.set('SPEC', records[0]["SPEC"]);
 	     						record.set('LOT_NO', records[0]["LOT_NO"]);
 							}
 						},
 						scope: this
 					},
 					onClear: function(type) {
 						var record = masterGrid.uniOpt.currentRecord;
 						record.set('DIV_CODE', '');
 						record.set('ITEM_CODE', '');
 						record.set('ITEM_NAME', '');
 						record.set('SPEC', '');
 						record.set('LOT_NO', '');
 					},
 					applyextparam: function(popup){
 						var record = masterGrid.uniOpt.currentRecord;
 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
 					}
 	        	}
        	 })}
        	, {dataIndex : 'ITEM_NAME'                        , width : 150  ,
        		editor:Unilite.popup('DIV_PUMOK_G', {
     				autoPopup : true,
            		 listeners:{
     	        		onSelected: {
     						fn: function(records, type) {
     							if(records) {
     								var record = masterGrid.uniOpt.currentRecord;
     								record.set('DIV_CODE', records[0]["DIV_CODE"]);
     								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
     								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
     								record.set('SPEC', records[0]["SPEC"]);
     	     						record.set('LOT_NO', records[0]["LOT_NO"]);
     							}
     						},
     						scope: this
     					},
     					onClear: function(type) {
     						var record = masterGrid.uniOpt.currentRecord;
     						record.set('DIV_CODE', '');
     						record.set('ITEM_CODE', '');
     						record.set('ITEM_NAME', '');
     						record.set('SPEC', '');
     						record.set('LOT_NO', '');
     					},
     					applyextparam: function(popup){
     						var record = masterGrid.uniOpt.currentRecord;
     						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
     					}
     	        	}
            	 })
              }
        	, {dataIndex : 'SPEC'                        	  , width : 150                          }
        	, {dataIndex : 'BAD_CODE'                         , width : 100    	, hidden : true      }
        	, {dataIndex : 'BAD_NAME'                         , width : 200  ,
         		editor:Unilite.popup('BAD_CODE_G', {
      				autoPopup : true,
             		 listeners:{
      	        		onSelected: {
      						fn: function(records, type) {
      							if(records) {
      								var record = masterGrid.uniOpt.currentRecord;
      								record.set('BAD_CODE', records[0]["BAD_CODE"]);
      								record.set('BAD_NAME', records[0]["BAD_NAME"]);
      							}
      						},
      						scope: this
      					},
      					onClear: function(type) {
      						var record = masterGrid.uniOpt.currentRecord;
      						record.set('BAD_CODE', '');
							record.set('BAD_NAME', '');
      					},
      					applyextparam: function(popup){
      						var record = masterGrid.uniOpt.currentRecord;
      						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE")});
      					}
      	        	}
             	 })
        	  }
        	, {dataIndex : 'LOT_NO'                           , width : 100      ,
        		editor:Unilite.popup('LOTNO_G', {
        			validateBlank : false,
             		 listeners:{
      	        		onSelected: {
      						fn: function(records, type) {
      							if(records) {
      								var record = masterGrid.uniOpt.currentRecord;
      								record.set('LOT_NO', records[0]["LOTNO_CODE"]);
      							}
      						},
      						scope: this
      					},
      					onClear: function(type) {

      					},
      					applyextparam: function(popup){
      						var record = masterGrid.uniOpt.currentRecord;
      						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"),
      							               'ITEM_CODE': record.get("ITEM_CODE"), 
      							               'ITEM_NAME': record.get("ITEM_NAME"), 
      							               'S_WH_CODE': record.get("FR_WH_CODE"), 
      							               'S_WH_CELL_CODE': record.get("FR_WH_CELL_CODE")});
      					}
      	        	}
             	 })
        	  }
        	, {dataIndex : 'BAD_Q'                            , width : 80     	, summaryType :'sum' }
        	, {dataIndex : 'REMARK'                           , width : 150                          }
        	, {dataIndex : 'FR_WH_CODE'                       , width : 110  }
        	, {dataIndex : 'FR_WH_CELL_CODE'                  , width : 110  }
        	, {dataIndex : 'TO_WH_CODE'                       , width : 110 , 
	           editor : {
	         	   xtype : 'uniCombobox',
	       		   comboType : 'OU' ,
		           listeners : {
						beforequery: function(queryPlan, eOpt) {
							var store = queryPlan.combo.store;
							var record = masterGrid.uniOpt.currentRecord;
							if(record && record.get("DIV_CODE"))	{
								store.clearFilter();
								store.filterBy(function(item){
									return item.get('option') == record.get("DIV_CODE") ;
								})
							} else {
								store.clearFilter();
							}
						}
					}                        
	     	     } 
        	  }
        	, {dataIndex : 'TO_WH_CELL_CODE'                  , width : 110  }
        	, {dataIndex : 'INOUT_NUM'                        , width : 100   	, hidden : true      }
        	, {dataIndex : 'INOUT_SEQ'                        , width : 80    	, hidden : true      }
        	  
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_pmr300ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("INOUT_DATE", UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage())	{
				return;
			}
			panelResult.setDisablekeys(true);
			if(Ext.isEmpty(defaultWhCode.frWhCode) || Ext.isEmpty(defaultWhCode.frWhCellCode))	{
				Unilite.messageBox("부적합이동 기본창고를 등록하세요.");
				return;
			}
            var r = {
            	'DIV_CODE'			: panelResult.getValue("DIV_CODE"),
        	 	'WORK_SHOP_CODE'	: panelResult.getValue("WORK_SHOP_CODE"),
        	 	'INOUT_DATE'		: panelResult.getValue("INOUT_DATE"),
        	 	'FR_WH_CODE' 		: defaultWhCode.frWhCode,
        	 	'FR_WH_CELL_CODE' 	: defaultWhCode.frWhCellCode,
        	 	'TO_WH_CODE' 		: defaultWhCode.toWhCode,
        	 	'TO_WH_CELL_CODE' 	: defaultWhCode.toWhCellCode
	        };
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			panelResult.setDisablekeys(false);
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
		},
		onDeleteAllButtonDown: function() {
			if(panelResult.getInvalidMessage())	{
				if(confirm("저장된 데이터가 삭제됩니다. 그래도 하시겠습니까?’"))	{
					var param = panelResult.getValues();
					s_pmr300ukrv_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		},
		getDefaultWhCode:function(divCode){
			var whCodeDefaultStore = Ext.data.StoreManager.lookup("CBS_AU_Z033");
			var defaultDataRecord ;
			if(!Ext.isEmpty(whCodeDefaultStore))	{
				defaultDataRecord = whCodeDefaultStore.getAt(whCodeDefaultStore.find("value", divCode));
			}
			if(Ext.isEmpty(defaultDataRecord)){
				Unilite.messageBox("부적합이동 기본창고를 등록하세요.");
				defaultWhCode = {
					'divCode'      : divCode,
					'frWhCode'     : '',
					'frWhCellCode' : '',
					'toWhCode'     : '',
					'toWhCellCode' : ''
				}
			} else {
				defaultWhCode = {
					'divCode'      : divCode,
					'frWhCode'     : defaultDataRecord.get("refCode1"),
					'frWhCellCode' : defaultDataRecord.get("refCode2"),
					'toWhCode'     : defaultDataRecord.get("refCode3"),
					'toWhCellCode' : defaultDataRecord.get("refCode4")
				}
			}
		}
	});
};


</script>
