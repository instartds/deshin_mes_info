<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc720ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc720ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B020"/>								<!-- 품목계정 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc720ukr_mitService.selectList',
			update: 's_agc720ukr_mitService.updateList',
			create: 's_agc720ukr_mitService.insertList',
			destroy: 's_agc720ukr_mitService.deleteList',
			syncAll: 's_agc720ukr_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_agc720ukr_mitModel', {
	    fields: [  	    
	    	  {name : 'DIV_CODE'                    , text : '사업장'                 	        , type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'ITEM_ACCOUNT'                , text : '품목계정'                         	, type : 'string'            , allowBlank : false           , editable : false, comboType:'AU', comboCode:'B020'}
	    	, {name : 'FR_DATE'                     , text : '조회시작월'                        	, type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'TO_DATE'                     , text : '조회종료월'                        	, type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'ITEM_CODE'                   , text : '품목코드'                         	    , type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'SALE_DATE'                   , text : '매출일'                          	, type : 'uniDate'           , allowBlank : false           , editable : false}
	    	, {name : 'EXPIRATION_DATE'             , text : '무상보증기간'                    	, type : 'uniDate'                                          , editable : false}
	    	, {name : 'EXPIRATION_DAY'              , text : '무상보증기간(개월)'                       	, type : 'int'                                           , editable : false}
	    	, {name : 'USED_M'                      , text : '사용월'                          	, type : 'int'                                              , editable : false}
	    	, {name : 'REDEDU_M'                    , text : '잔여월'                          	, type : 'int'                                              , editable : false}
	    	, {name : 'CUSTOM_CODE'                 , text : '매출처코드'                          , type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'CUSTOM_NAME'                 , text : '매출처'                          	, type : 'string'            , allowBlank : false           , editable : false}
	    	, {name : 'DVRY_CUST_CD'                , text : '병원명(장소)코드'                          	, type : 'string'                                           , editable : false}
	    	, {name : 'DVRY_CUST_NM'                , text : '병원명(장소)'                          	, type : 'string'                                           , editable : false}
	    	, {name : 'SALE_AMT'                    , text : '매출금액'                         	, type : 'uniPrice'                                         , editable : false}
	    	, {name : 'COST_MATERIAL'               , text : '재료비'                          	, type : 'uniPrice'                                         , editable : false}
	    	, {name : 'COST_LABOR'                  , text : '인건비'                          	, type : 'uniPrice'                                                           }
	    	, {name : 'COST_SUM'                    , text : '비용계'                          	, type : 'uniPrice'                                         , editable : false}
	    	, {name : 'AVERCOST_PERM'               , text : '1개월평균'                        	, type : 'uniPrice'                                         , editable : false}
	    	, {name : 'SALEAMT_BYGUARANTYP'         , text : '매출액/무상보증기간'                   	, type : 'uniPrice'                                         , editable : false}
	    	
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc720ukr_mitMasterStore',{
		model: 's_agc720ukr_mitModel',
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
						masterGrid.getEl().mask()
						s_agc720ukr_mitService.selectNewList(param,  function(responseText, response) {
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
				}
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
			fieldLabel		: '조회월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			labelWidth       : 90,
			startDate		: UniDate.get('startOfYear'),
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
			comboCode   : 'B020',
			allowBlank	: false,
			value       : '10',
			readOnly    : true
		}
		,Unilite.popup('ITEM',{
			fieldLabel:'품목',
			valueFieldName:'ITEM_CODE',
			textFieldName:'ITEM_NAME',
			autoPopup : true
		})
		,Unilite.popup('CUST',{
			fieldLabel:'거래처',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			autoPopup : true
		})],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("FR_DATE").setReadOnly(disable);
			me.getField("TO_DATE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc720ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 80     ,hidden : true}
        	, {dataIndex : 'ITEM_ACCOUNT'                     , width : 100     ,hidden : true}
        	, {dataIndex : 'FR_DATE'                          , width : 80     ,hidden : true}
        	, {dataIndex : 'TO_DATE'                          , width : 80     ,hidden : true}
        	, {dataIndex : 'ITEM_CODE'                        , width : 120   ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			}}
        	, {dataIndex : 'ITEM_NAME'                        , width : 150}
        	, {dataIndex : 'SALE_DATE'                        , width : 80}
        	, {dataIndex : 'EXPIRATION_DATE'                  , width : 130}
        	, {dataIndex : 'EXPIRATION_DAY'                   , width : 110}
        	, {dataIndex : 'USED_M'                           , width : 80}
        	, {dataIndex : 'REDEDU_M'                         , width : 80 }
        	, {dataIndex : 'CUSTOM_CODE'                      , width : 80    ,hidden : true}
        	, {dataIndex : 'CUSTOM_NAME'                      , width : 170}
        	, {dataIndex : 'DVRY_CUST_NM'                     , width : 150}
        	, {dataIndex : 'SALE_AMT'                         , width : 100  , summaryType : 'sum'}
        	, {dataIndex : 'COST_MATERIAL'                    , width : 80   , summaryType : 'sum'}
        	, {dataIndex : 'COST_LABOR'                       , width : 80   , summaryType : 'sum'}
        	, {dataIndex : 'COST_SUM'                         , width : 80   , summaryType : 'sum'}
        	, {dataIndex : 'AVERCOST_PERM'                    , width : 80	 , hidden : true}
        	, {dataIndex : 'SALEAMT_BYGUARANTYP'              , width : 140   , summaryType : 'sum'}    
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc720ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "02");
			panelResult.setValue("FR_DATE", UniDate.get('startOfYear'));
			panelResult.setValue("TO_DATE", UniDate.get('today'));
			panelResult.setValue("ITEM_ACCOUNT", "10");
			
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
					s_agc720ukr_mitService.deleteAll(param, function(responseText, response){
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
				case "COST_LABOR" :		
					var costSum = (record.get("COST_SUM") - oldValue) + newValue;
					var month = parseInt(Ext.Date.format( panelResult.getValue('TO_DATE'), 'm'));
					var avercostPerm =  costSum / month;
					record.set('COST_SUM', costSum);
					record.set('AVERCOST_PERM', avercostPerm);
					break;
			}
		
			return rv;
		}
	})			
};


</script>
