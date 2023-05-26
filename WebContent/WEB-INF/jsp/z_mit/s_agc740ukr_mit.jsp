<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc740ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc740ukr_mit"/>
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
			read: 's_agc740ukr_mitService.selectList',
			update: 's_agc740ukr_mitService.updateList',
			create: 's_agc740ukr_mitService.insertList',
			destroy: 's_agc740ukr_mitService.deleteList',
			syncAll: 's_agc740ukr_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_agc740ukr_mitModel', {
	    fields: [  	    
	    	      {name : 'DIV_CODE'                    , text : '사업장'                 	       	, type : 'string'          	, allowBlank : false          	, editable : false}
	    	    , {name : 'DATE_YEAR'                   , text : '조회연도'                         	, type : 'string'          	, allowBlank : false           }
	    	    , {name : 'DATE_MONTH'                  , text : '월'                            	, type : 'string'           , allowBlank : false           }
	    	    , {name : 'AMOUNT'                      , text : '금액'                           	, type : 'uniPrice'                                        }
	    	    , {name : 'HOUR'                        , text : '시간'                           	, type : 'float'           	, decimalPrecision:2, format:'0,000.00' }
	    	    , {name : 'PERSON_NUM'                  , text : '인원'                           	, type : 'int'                                             }
	    	    , {name : 'CAL_LABORCOST'               , text : '인건비안분'                        	, type : 'uniPrice'                                        }
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc740ukr_mitMasterStore',{
		model: 's_agc740ukr_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
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
				if(!records || (records && records.length == 0))	{
					setTimeout(function() {
						var param= Ext.getCmp('resultForm').getValues();	
						//저장된 데이터가 없을 경우 신규데이터 조회
						masterGrid.getEl().mask("조회중...")
						s_agc740ukr_mitService.selectNewList(param,  function(responseText, response) {
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
								UniAppManager.setToolbarButtons('deleteAll',true);
							} else {
								UniAppManager.setToolbarButtons('deleteAll',false);
							}
							masterGrid.getEl().unmask();
						})
					}, 100)
					UniAppManager.setToolbarButtons('deleteAll',false);
				} else {
					UniAppManager.setToolbarButtons('deleteAll',true);
				}
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
			fieldLabel	: '조회연도',
			xtype	    : 'uniYearField',
			name	    : 'DATE_YEAR',
			endDate			: UniDate.get('today'),
			allowBlank	: false,
			minValue: '2015',
		   	maxValue: '2050',
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       : '02',
			readOnly    : true,
			allowBlank	: false
		}],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("DATE_YEAR").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc740ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	    {dataIndex : 'DATE_YEAR'                        , width : 100                   , hidden:true }
        	  , {dataIndex : 'DATE_MONTH'                       , width : 100,
   				 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
   					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
   			    }}
        	  , {dataIndex : 'AMOUNT'                           , width : 110                  }
        	  , {dataIndex : 'HOUR'                             , width : 110                  }
        	  , {dataIndex : 'PERSON_NUM'                       , width : 110                  }
        	  , {dataIndex : 'CAL_LABORCOST'                    , width : 110    , summaryType : 'sum'}
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc740ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "02");
			panelResult.setValue("DATE_YEAR", new Date().getFullYear());
			
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
					s_agc740ukr_mitService.deleteAll(param, function(responseText, response){
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
				case "AMOUNT" :		
					if(!Ext.isEmpty(newValue))	{
						if(record.get("PERSON_NUM") != 0)	{
							var cal_laborCost = newValue * record.get("HOUR") / record.get("PERSON_NUM");
							record.set('CAL_LABORCOST', cal_laborCost);
						}
					}
					break;
				case "HOUR" :		
					if(!Ext.isEmpty(newValue))	{
						if(record.get("PERSON_NUM") != 0)	{
							var cal_laborCost = newValue * record.get("AMOUNT") / record.get("PERSON_NUM");
							record.set('CAL_LABORCOST', cal_laborCost);
						}
					}
					break;
				case "PERSON_NUM" :		
					if(!Ext.isEmpty(newValue))	{
						if(newValue != 0)	{
							var cal_laborCost =  record.get("AMOUNT") * record.get("HOUR") /newValue ;
							record.set('CAL_LABORCOST', cal_laborCost);
						}
					}
					break;
			}
		
			return rv;
		}
	})			
};


</script>
