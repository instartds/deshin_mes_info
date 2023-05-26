<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc750ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc750ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B020"  opts="40;50;60"/>								<!-- 품목계정 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var itemAccount = '10';
	
	var ynStore = Unilite.createStore('ynStore', {  // 조합원 여부
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
	    		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc750ukr_mitService.selectList',
			update: 's_agc750ukr_mitService.updateList',
			create: 's_agc750ukr_mitService.insertList',
			destroy: 's_agc750ukr_mitService.deleteList',
			syncAll: 's_agc750ukr_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_agc750ukr_mitModel', {
	    fields: [  	    
	    	    {name : 'DIV_CODE'                    , text : '사업장'                 	       	, type : 'string'          	, allowBlank : false          	, editable : false}
	    	  , {name : 'ITEM_ACCOUNT'                , text : '계정'                        		, type : 'string'           , allowBlank : false          	, editable : false, comboType:'AU', comboCode:'B020', defaultValue:'10'}
		      , {name : 'DATE_MONTH'                  , text : '조회시작월'                       	, type : 'string'          	, allowBlank : false          	, editable : false}
	    	  , {name : 'ITEM_CODE'                   , text : '품목코드'                         	, type : 'string'          	, allowBlank : false          	, editable : false}
	    	  , {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'          	, allowBlank : false          	, editable : false}
	    	  , {name : 'SPEC'                        , text : '규격'                         	, type : 'string'                                           , editable : false}
	    	  , {name : 'STOCK_UNIT'                  , text : '단위'                         	, type : 'string'                                           , editable : false}
	    	  , {name : 'STOCK_Q'                     , text : '재고수량'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'STOCK_I'                     , text : '재고금액'                         	, type : 'uniPrice'                                         , editable : false}
	    	  
	    	  , {name : 'USE_YN'                      , text : '사용여부'                         	, type : 'string'                                          	, store : Ext.data.StoreManager.lookup("ynStore")}
	    	  , {name : 'COMMENT_USE'                 , text : '사용가능설명'                     	, type : 'string'                                         	}
	    	  , {name : 'COMMENT_NOUSE'               , text : '불용시설명'                       	, type : 'string'                                         	}
	    	  , {name : 'USAGE_RATE'                  , text : '장비사용율'                       	, type : 'uniPercent'                                      	}
	    	  , {name : 'DETAIL_DESC'                 , text : '상세내역'                         	, type : 'string'                                          	}
	    	  , {name : 'REMARK'                      , text : '비고'                           	, type : 'string'                                          	}
	    	  , {name : 'AMOUNT'                      , text : '금액'                           	, type : 'uniPrice'                                        	, editable : false}
	    	  , {name : 'DAMAGE_AMOUNT'               , text : '손상금액'                         	, type : 'uniPrice'                                        	, editable : false}
	    	  , {name : 'FLAG'                        , text : '신규여부'                         	, type : 'string'                                           , editable : false}
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc750ukr_mitMasterStore',{
		model: 's_agc750ukr_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
            allDeletable: true,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	if(panelResult.getInvalidMessage())	{
    			panelResult.setDisablekeys(true);
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param,
					callback: function(records, operation, success) {
						if(success){
							Ext.each(records, function(record, idx)	{
								if(record.get("FLAG") == "S")	{
									record.set("FLAG", "신규");
								}
							});
						}
					}
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
				/* if(!records || (records && records.length == 0))	{
					setTimeout(function() {
						var param= Ext.getCmp('resultForm').getValues();	
						//저장된 데이터가 없을 경우 신규데이터 조회
						masterGrid.getEl().mask("조회중...")
						s_agc750ukr_mitService.selectNewList(param,  function(responseText, response) {
							if(responseText && responseText.length > 0)	{
								Ext.each(responseText, function(record, rowIndex) {
									var newRecord =  Ext.create (store.model);
									if(record)	{
										Ext.each(Object.keys(record), function(key, idx){
											newRecord.set(key, record[key]);
										});
									}
									newRecord.phantom = true;
									//console.log("newRowIndex 1= " ,rowIndex );
									//newRecord = grid.store.insert(rowIndex, newRecord);
									store.insert(rowIndex, newRecord);
								});
								masterGrid.select(0);
							}
							masterGrid.getEl().unmask();
						})
					}, 100)
				} */
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
			fieldLabel	: '조회월',
			xtype	    : 'uniMonthfield',
			name	    : 'DATE_MONTH',
			endDate			: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       : '02',
			readOnly    : true,
			allowBlank	: false
		},{
			fieldLabel	: '계정'  ,
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode   : 'B020'
		}
		,Unilite.popup('ITEM',{
			fieldLabel:'품목',
			valueFieldName:'ITEM_CODE',
			textFieldName:'ITEM_NAME',
			autoPopup : true
		})],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("DATE_MONTH").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc750ukr_mitGrid', {
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
        	    {dataIndex : 'ITEM_ACCOUNT'                     , width : 80                    }
        	  , {dataIndex : 'DATE_MONTH'                       , width : 80    ,               hidden:true}
        	  , {dataIndex : 'ITEM_CODE'                        , width : 120   ,
  				 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
  					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
  			    }}
        	  , {dataIndex : 'ITEM_NAME'                        , width : 150}
        	  , {dataIndex : 'SPEC'                        		, width : 150}
        	  , {dataIndex : 'STOCK_UNIT'                          , width : 80 }
        	  , {dataIndex : 'STOCK_Q'                          , width : 80           , summaryType : 'sum'       }
        	  , {dataIndex : 'STOCK_I'                          , width : 80           , summaryType : 'sum'       }
        	  , {dataIndex : 'USE_YN'                           , width : 80                    }
        	  , {dataIndex : 'COMMENT_USE'                      , width : 150                  }
        	  , {dataIndex : 'COMMENT_NOUSE'                    , width : 150                  }
        	  , {dataIndex : 'USAGE_RATE'                       , width : 110                  }
        	  , {dataIndex : 'DETAIL_DESC'                      , width : 150                  }
        	  , {dataIndex : 'REMARK'                           , width : 150                  }
        	  , {dataIndex : 'AMOUNT'                           , width : 100            , summaryType : 'sum'      }
        	  , {dataIndex : 'DAMAGE_AMOUNT'                    , width : 100            , summaryType : 'sum'      }
        	  , {dataIndex : 'FLAG'                             , flex  : 1                  }
        	  
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc750ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "02");
			panelResult.setValue("DATE_MONTH", UniDate.get('today'));
			
			panelResult.setDisablekeys(false);
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
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
		},
		onDeleteAllButtonDown: function() {
			if(panelResult.getInvalidMessage())	{
				if(confirm("저장된 데이터가 삭제됩니다. 그래도 하시겠습니까?’"))	{
					var param = panelResult.getValues();
					s_agc750ukr_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
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
				case "USAGE_RATE" :		
					if(!Ext.isEmpty(newValue))	{
						var amount = Unilite.multiply(record.get("STOCK_I") , newValue/100) ;
						record.set("AMOUNT", amount);
						
						var demageAmount = record.get("STOCK_I") - amount
						record.set('DAMAGE_AMOUNT', demageAmount);
					}
					break;
			}
		
			return rv;
		}
	})			
};


</script>
