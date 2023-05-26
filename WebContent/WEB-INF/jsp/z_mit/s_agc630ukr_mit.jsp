<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc630ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc630ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B020" opts="00;10"/>					<!-- 품목계정 -->
	<t:ExtComboStore comboType="OU"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc630ukr_mitService.selectList',
			update: 's_agc630ukr_mitService.updateList',
			create: 's_agc630ukr_mitService.insertList',
			destroy: 's_agc630ukr_mitService.deleteList',
			syncAll: 's_agc630ukr_mitService.saveAll'
		}
	});	
	//계정	창고	구분	품목	품명	규격	단위	Lot No. 	비고	폐기수량	반품수량	폐기수량-반품수량	단가	금액
	Unilite.defineModel('s_agc630ukr_mitModel', {
	    fields: [  	    
	    	    {name : 'DIV_CODE'                    , text : '사업장'                 	       	, type : 'string'            , allowBlank : false           , editable : false, child :'WH_CODE'}
	    	  , {name : 'DATE_MONTH'                  , text : '조회시작월'                     	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'ITEM_ACCOUNT'                , text : '계정'                           	, type : 'string'                                          	, comboType:'AU'  , comboCode : 'B020'		, editable : false}
	    	  , {name : 'WH_CODE'                     , text : '창고'                           	, type : 'string'                                          	, comboType:'OU'		, editable : false}
	    	  , {name : 'ITEM_LEVEL1'                 , text : '구분'                           	, type : 'string'            , store: Ext.data.StoreManager.lookup('itemLeve1Store')}
		      , {name : 'ITEM_CODE'                   , text : '품목코드'                       	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'SPEC'                   	  , text : '규격'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'ORDER_UNIT'                  , text : '단위'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'LOT_NO'                      , text : 'LOT 번호'                       	, type : 'string'            , allowBlank : false          	, editable : false }
	    	  
	    	  // 규격, 폐기수량, 반품수량
	    	  , {name : 'REMARKS'                     , text : '비고'                           	, type : 'string'                                          }
	    	  , {name : 'DISPOSAL_DATE'               , text : '폐기일자'                       	, type : 'string'                                        , editable : false }  // '' -> null 저장되지 않기 위해 uniDate 에서 string으로 변경, 
	    	  , {name : 'DISPOSAL_Q'                  , text : '폐기수량'                       	, type : 'uniQty'                                        , editable : false }
	    	  , {name : 'INOUT_Q'                     , text : '반품수량'                       	, type : 'uniQty'                                        , editable : false }
	    	  , {name : 'RETURN_DISPOSAL_Q'           , text : '폐기수량-반품수량'              	, type : 'uniQty'                                        , editable : false }
	    	  , {name : 'STOCK_P'                     , text : '단가'                           	, type : 'uniUnitPrice'                                  }
	    	  , {name : 'STOCK_I'                     , text : '금액'                         	, type : 'uniPrice'                                      , editable : false   }
	    	  , {name : 'FLAG'                        , text : ' '                         	    , type : 'string'                                        , editable : false }
		         
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc630ukr_mitMasterStore',{
		model: 's_agc630ukr_mitModel',
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
        	this.clearFilter(); 
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
			this.clearFilter();
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
						masterGrid.getEl().mask()
						s_agc630ukr_mitService.selectNewList(param,  function(responseText, response) {
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
							masterGrid.getEl().unmask()
						})
					}, 100)
				} */
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
			fieldLabel		: '조회월',
			xtype			: 'uniMonthfield',
			name	        : 'DATE_MONTH',
			endFieldName	: 'TO_DATE',
			value			: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       :  UserInfo.divCode,
			allowBlank	: false,
			colspan     : 3,
			child : 'WH_CODE'
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
	
    var masterGrid = Unilite.createGrid('s_agc630ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		expandLastColumn: false
    	},
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
        	, {dataIndex : 'DATE_MONTH'                       , width : 80	,hidden : true}
        	, {dataIndex : 'ITEM_ACCOUNT'					  , width : 80 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			 }}
        	, {dataIndex : 'WH_CODE'                          , width : 100  , hidden : true}
        	, {dataIndex : 'ITEM_LEVEL1'                      , width : 100}
        	, {dataIndex : 'ITEM_CODE'                        , width : 150	}
        	, {dataIndex : 'ITEM_NAME'                        , width : 150}
        	, {dataIndex : 'SPEC'                        	  , width : 150}
        	, {dataIndex : 'ORDER_UNIT'                       , width : 100}
        	, {dataIndex : 'LOT_NO'                           , width : 100}
        	, {dataIndex : 'REMARKS'                          , width : 150}
        	//, {dataIndex : 'DISPOSAL_DATE'                 	  , width : 80  , hidden : true}
        	, {dataIndex : 'DISPOSAL_Q'                       , width : 80  , summaryType : 'sum'}
        	, {dataIndex : 'INOUT_Q'                          , width : 80  , summaryType : 'sum'}
        	, {dataIndex : 'RETURN_DISPOSAL_Q'                , width : 150 , summaryType : 'sum'}
        	, {dataIndex : 'STOCK_P'                          , width : 80 }
        	, {dataIndex : 'STOCK_I'                          , width : 100 , summaryType : 'sum'}
        	, {dataIndex : 'FLAG'                          	  , flex  : 1 }
	         
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc630ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "01");
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
					s_agc630ukr_mitService.deleteAll(param, function(responseText, response){
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
		validate: function(type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;	
			if(newValue == oldValue)	{
				return true;
			}
			switch(fieldName) {	
				case 'STOCK_P': 
						var stockI = parseInt(record.get("RETURN_DISPOSAL_Q")) * newValue;
						record.set("STOCK_I", stockI)
					break;
			}
			return rv;
		}
	});
	
};


</script>
