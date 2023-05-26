<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc600ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc600ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B020" opts="00;40;50"/>								<!-- 품목계정 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var useStore = Ext.create('Ext.data.Store', {
        id : 'useComboStore',
		fields : ['text', 'value'],
        data   : [
            {text : '사용', value: '사용'},
            {text : '불용', value: '불용'}
        ]
    });
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc600ukr_mitService.selectList',
			update: 's_agc600ukr_mitService.updateList',
			create: 's_agc600ukr_mitService.insertList',
			destroy: 's_agc600ukr_mitService.deleteList',
			syncAll: 's_agc600ukr_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_agc600ukr_mitModel', {
	    fields: [  	    
	    	    {name : 'DIV_CODE'                    , text : '사업장'                 	        , type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'FR_DATE'                     , text : '조회시작월'                        , type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'TO_DATE'                     , text : '조회종료월'                        , type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'ITEM_CODE'                   , text : '품목코드'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	  , {name : 'SPEC'                        , text : '규격'                         	, type : 'string'                                           , editable : false}
	    	  , {name : 'BASIS_Q'                     , text : '기초수량'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'INSTOCK_Q'                   , text : '입고수량'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'SUBINSTOCK_Q'                , text : '대체입고'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'OUTSTOCK_Q'                  , text : '출고수량'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'SUBOUTSTOCK_Q'               , text : '대체출고'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'STOCK_Q'                     , text : '재고수량'                         	, type : 'uniQty'                                           , editable : false}
	    	  , {name : 'STOCK_P'                     , text : '단가'                           	, type : 'uniUnitPrice'                                     , editable : false}
	    	  , {name : 'STOCK_I'                     , text : '재고금액'                         	, type : 'uniPrice'                                         , editable : false}
	    	  , {name : 'NOIN_OVERAYEAR'              , text : '년이상미구매'                     	, type : 'string'            , store : Ext.data.StoreManager.lookup('useComboStore') }
	    	  , {name : 'NOOUT_OVERAYEAR'             , text : '년이상미출고'                     	, type : 'string'            , store : Ext.data.StoreManager.lookup('useComboStore') }
	    	  , {name : 'RESULT'                      , text : '결과'                           	, type : 'string'                                           , editable : false}
	    	  , {name : 'RESERVE_RATE'                , text : '설정비율'                         	, type : 'uniPercent'                                        }
	    	  , {name : 'ALLOWANCE_I'                 , text : '대손충당금'                        , type : 'uniPrice'                                     , editable : false}
	    	  , {name : 'FLAG'                     	  , text : 'FLAG'                   		, type : 'string'                							, editable : false }
	    	  , {name : 'REMARK'                      , text : '비고'                   			, type : 'string'                							, editable : false }
	    	   
	    	
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc600ukr_mitMasterStore',{
		model: 's_agc600ukr_mitModel',
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
									record.set("REMARK", "신규");
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
						masterGrid.getEl().mask()
						s_agc600ukr_mitService.selectNewList(param,  function(responseText, response) {
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel		: '조회월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			labelWidth      : 90,
			startDate		: UniDate.get('startOfYear'),
			endDate			: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       :  UserInfo.divCode,
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
			me.getField("FR_DATE").setReadOnly(disable);
			me.getField("TO_DATE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc600ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 80	,hidden : true}
        	, {dataIndex : 'ITEM_ACCOUNT'                     , width : 100	,hidden : true}
        	, {dataIndex : 'FR_DATE'                          , width : 80	,hidden : true}
        	, {dataIndex : 'TO_DATE'                          , width : 80	,hidden : true}
        	, {dataIndex : 'ITEM_CODE'                        , width : 150	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			}}
        	, {dataIndex : 'ITEM_NAME'                        , width : 150}
        	, {dataIndex : 'BASIS_Q'                          , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'INSTOCK_Q'                        , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'SUBINSTOCK_Q'                     , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'OUTSTOCK_Q'                       , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'SUBOUTSTOCK_Q'                    , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'STOCK_Q'                          , width : 100	, summaryType : 'sum'}
        	, {dataIndex : 'STOCK_P'                          , width : 100}
        	, {dataIndex : 'STOCK_I'                          , width : 110	, summaryType : 'sum'}
        	//, {dataIndex : 'NOIN_OVERAYEAR'                   , width : 100}
        	//, {dataIndex : 'NOOUT_OVERAYEAR'                  , width : 100}
        	//, {dataIndex : 'RESULT'                           , width : 100}
        	, {dataIndex : 'RESERVE_RATE'                     , width : 80 }
        	, {dataIndex : 'ALLOWANCE_I'                      , width : 110	, summaryType : 'sum'}
        	, {dataIndex : 'REMARK'                     	  , width : 40}
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc600ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "01");
			panelResult.setValue("FR_DATE", UniDate.get('startOfYear'));
			panelResult.setValue("TO_DATE", UniDate.get('today'));
			
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
					s_agc600ukr_mitService.deleteAll(param, function(responseText, response){
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
				case "RESERVE_RATE" :		
					var amount = newValue/100 * record.get("STOCK_I");
					record.set('ALLOWANCE_I', amount);
					break;
				case "NOIN_OVERAYEAR" :		
					var resultTxt = newValue + '/' + record.get("NOOUT_OVERAYEAR");
					record.set('RESULT', resultTxt);
					break;
				case "NOOUT_OVERAYEAR" :		
					var resultTxt = record.get("NOIN_OVERAYEAR")  + '/' + newValue ;
					record.set('RESULT', resultTxt);
					break;
				default:
					break;
			}
		
			return rv;
		}
	})			
};


</script>
