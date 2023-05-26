<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc760ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc760ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="Z035"/>
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc760ukr_mitService.selectList',
			create: 's_agc760ukr_mitService.insertList',
			update: 's_agc760ukr_mitService.updateList',
			syncAll: 's_agc760ukr_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_agc760ukr_mitModel', {
	    fields: [  	    
	    	      {name : 'DIV_CODE'                    , text : '사업장'        	, type : 'string'      , allowBlank : false  	, editable : false}
	    	    , {name : 'BASIS_DATE'                  , text : '조회기준일'     	, type : 'uniDate'     , allowBlank : false    	, editable : false}
	    	    , {name : 'GUBUN'                       , text : '연도별구분'    	, type : 'string'      , allowBlank : false    	, editable : false	, comboType : 'AU'  , comboCode:'Z035'}
	    	    , {name : 'FR_DATE'                     , text : '조회시작일'    	, type : 'uniDate'                       		, editable : false}
	    	    , {name : 'TO_DATE'                     , text : '조회종료일'     	, type : 'uniDate'                       		, editable : false}
	    	    , {name : 'FR_MONTH'                    , text : '조회시작월'    	, type : 'string'                       		, editable : false, convert : monthFormat}
	    	    , {name : 'TO_MONTH'                    , text : '조회종료월'     	, type : 'string'                       		, editable : false, convert : monthFormat}
	    	    , {name : 'SALE_AMT'                    , text : '매출'        	, type : 'int'                    			}
	    	    , {name : 'COST_AMT'                    , text : '비용'        	, type : 'int'                   			}
	    	    , {name : 'SALE_COST_RATE'              , text : '비율'        	, type : 'uniPercent'                  			, editable : false}
	    	    
	    ]
	});
	function monthFormat (value){
	    value = Ext.isEmpty(value) ? '' : value.replace(".","");
		return Ext.isEmpty(value) ? '' : value.substring(0,4)+"."+value.substring(4,6);
	}
	var directMasterStore = Unilite.createStore('s_agc760ukr_mitMasterStore',{
		model: 's_agc760ukr_mitModel',
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
        	this.clearFilter(); 
        	if(panelResult.getInvalidMessage())	{
    			panelResult.setDisablekeys(true);
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param/* ,
					callback: function(records, operation, success) {
						if(success){
							Ext.each(records, function(record, idx)	{
								if(record.get("FLAG") == "S")	{
									record.set("REMARK", "신규");
								}
							});
						}
					} */
				});
        	}
		},
		saveStore : function()	{	
			this.clearFilter();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				this.syncAllDirect( {
					success:function()	{
						if(directMasterStore.getData())	{
							UniApp.setToolbarButtons(['deleteAll'], true);
						}
					}
				} );
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records){
				if(!records || (records && records.length == 0))	{
       				UniApp.setToolbarButtons(['deleteAll'], false);
					setTimeout(function() {
						var param= Ext.getCmp('resultForm').getValues();	
						//저장된 데이터가 없을 경우 신규데이터 조회
						masterGrid.getEl().mask()
						s_agc760ukr_mitService.selectNewList(param,  function(responseText, response) {
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
							//UniAppManager.app.setYearSummary();
						})
					}, 100)
				}else {
					UniApp.setToolbarButtons(['deleteAll'], true);
				} 
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '조회일',
			xtype		: 'uniDatefield',
			name	    : 'BASIS_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       :  UserInfo.divCode,
			allowBlank	: false,
			readOnly:true,
			colspan     : 3,
			child : 'WH_CODE'
		}],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("BASIS_DATE").setReadOnly(disable);
			me.getField("DIV_CODE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc760ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
        columns:  [     
        	    {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
        	  , {dataIndex : 'BASIS_DATE'                       , width : 100   ,hidden : true}
        	  , {dataIndex : 'GUBUN'                            , width : 300   }
        	  , {dataIndex : 'FR_DATE'                          , width : 100   ,hidden : true}
        	  , {dataIndex : 'TO_DATE'                          , width : 100   ,hidden : true}
        	  , {dataIndex : 'FR_MONTH'                         , width : 100   ,align : 'center'}
        	  , {dataIndex : 'TO_MONTH'                         , width : 100   ,align : 'center'}
        	  , {dataIndex : 'SALE_AMT'                         , width : 150   }
        	  , {dataIndex : 'COST_AMT'                         , width : 150   }
        	  , {dataIndex : 'SALE_COST_RATE'                   , width : 80    }
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
   				if(e.field == 'COST_AMT')	{
	   				if(!UniUtils.indexOf(e.record.get("GUBUN") , [ '110','130']))	{
						return true;
					}
   				}
   				if(e.field == 'SALE_AMT')	{
	   				if(UniUtils.indexOf(e.record.get("GUBUN") , [ '010','020','030','040']))	{
						return true;
					}
   				}
    			return false;
        	}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc760ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "02");
			panelResult.setValue("BASIS_DATE", UniDate.get('today'));
			
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
					s_agc760ukr_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		},
		setGridData : function(gubun, fieldName, newValue) {
			var dataList = directMasterStore.getData();
			/*
				비율계산
			*/
			var saleCostRate = 0;
			var saleCostRateSum = 0;
			if(UniUtils.indexOf(gubun , [ '010','020','030','040']))	{
				Ext.each(dataList.items, function(record, idx){
					if(UniUtils.indexOf(record.get("GUBUN") , [ '010','020','030','040']))	{
						if(fieldName == "SALE_AMT" )	{
							var saleAmt = 0;
							if(Ext.isEmpty(newValue))	newValue = 0;
							
							if(gubun == record.get("GUBUN") )	{
								saleAmt = newValue;
							}else {
								saleAmt = record.get("SALE_AMT");
							}
							if(saleAmt != 0)	{
								if(gubun == record.get("GUBUN") )	{
									saleCostRate = Math.round(record.get("COST_AMT")/newValue * 100 * 100)/100 ;
								}else {
									saleCostRate = Math.round(record.get("COST_AMT")/record.get(fieldName) * 100 *100)/100;
								}
							} 
						}
						if(fieldName == "COST_AMT" )	{
							var saleAmt = record.get("SALE_AMT");
							if(Ext.isEmpty(newValue))	newValue = 0;
							
							if(saleAmt != 0)	{
								if(gubun == record.get("GUBUN") )	{
									saleCostRate = Math.round(newValue/saleAmt * 100 * 100)/100;
								}else {
									saleCostRate = Math.round(record.get(fieldName)/saleAmt * 100 *100)/100;
								}
							}
						}
						if(gubun == record.get("GUBUN"))	{
							record.set("SALE_COST_RATE", saleCostRate);
						}
						saleCostRateSum += saleCostRate;
					}
				});
			}
			var checkChange = true;
		/* 	if(saleCostRateSum == 0)	{
				checkChange = false;
				var checkSum = 0;
				Ext.each(dataList.items, function(record, idx){
					if(UniUtils.indexOf(record.get("GUBUN") , [ '010','020','030','040']))	{
						if(fieldName == "SALE_AMT" || fieldName == "COST_AMT")	{
							checkSum += parseInt(record.get(fieldName))
						}
					}
				})
				if(checkSum == 0)	{
					checkChange = true;
				}
			} */
			if(checkChange)	{
				var saleCostRateAvg = Math.round(saleCostRateSum/4*100)/100;
				Ext.each(dataList.items, function(record, idx){
					if(UniUtils.indexOf(record.get("GUBUN") , [ '050','060','070','080','090','100']))	{
						record.set("COST_AMT",  Math.round( Unilite.multiply( record.get("SALE_AMT") , saleCostRateAvg)/100) );
						record.set("SALE_COST_RATE", saleCostRateAvg);
						saleCostRateSum += saleCostRate;
					}
				});
			}
			//summary data
			this.setYearSummary(gubun, fieldName, newValue)
			
		},
		setYearSummary: function(gubun, fieldName, newValue)	{
			var dataList = directMasterStore.getData();
			var yearRecord ,costRecord;
			var sumValue = 0 , avgSum=0, avgCount=0, avgRate=0;
			var lastYearValue = 0

			Ext.each(dataList.items, function(record, idx){
				if(record.get("GUBUN") == "110")	{
					yearRecord = record;
				}
				if(record.get("GUBUN") == "120")	{
					if(gubun == "120")	{
						lastYearValue = newValue;
					} else {
						lastYearValue = record.get("COST_AMT");
					}
				}
				if(record.get("GUBUN") == "130")	{
					costRecord = record;
				}
				if(UniUtils.indexOf(record.get("GUBUN") , [ '050','060','070','080','090','100']) && fieldName == "COST_AMT")	{
					if(gubun == record.get("GUBUN"))	{
						if(Ext.isEmpty(newValue))	newValue = 0;
						sumValue +=	parseInt(newValue);
					}else {
						sumValue +=	parseInt(record.get("COST_AMT"));
					}
				} else if(UniUtils.indexOf(record.get("GUBUN") , [ '050','060','070','080','090','100'])) {
					sumValue +=	parseInt(record.get("COST_AMT"));
				}
				
			});
			yearRecord.set("COST_AMT", sumValue);
			costRecord.set("COST_AMT", sumValue - lastYearValue);
			
		}
	});
	
	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(newValue == oldValue)	{
				return;
			}
			if(fieldName == "SALE_AMT" || fieldName == "COST_AMT" ) { 
				if( newValue == Math.round(oldValue))	{
					return;
				}
			}
			var rv = true;
			switch(fieldName) {
				 case "SALE_AMT" : 
					 if(Math.round(newValue) != Math.round(oldValue))	{
						UniAppManager.app.setGridData(record.get("GUBUN"), fieldName, newValue);
					 } else{
						 return;
					 }
					break;
				case "COST_AMT":
					if(record.get("GUBUN") == '120')	{
						UniAppManager.app.setYearSummary(record.get("GUBUN") , fieldName , newValue);
					} else if(UniUtils.indexOf(record.get("GUBUN") , [ '050','060','070','080','090','100']))	{
						if(record.get("SALE_AMT") != 0)	{
							record.set("SALE_COST_RATE", Math.round(newValue/record.get("SALE_AMT") * 100 *100)/100);
						} else {
							record.set("SALE_COST_RATE", 0);
						}
						UniAppManager.app.setYearSummary(record.get("GUBUN"), fieldName, newValue);
					} else if(UniUtils.indexOf(record.get("GUBUN") , [ '010','020','030','040']))	{
						UniAppManager.app.setGridData(record.get("GUBUN"), fieldName, newValue);
					}
						
					break;
				default:
					break;
			}
			return rv;
		}
	}); // validator
};


</script>
