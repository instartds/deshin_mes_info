<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc850ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc850ukr_mit"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc850ukr_mitService.selectList',
			update: 's_agc850ukr_mitService.updateList',
			create: 's_agc850ukr_mitService.insertList',
			destroy: 's_agc850ukr_mitService.deleteList',
			syncAll: 's_agc850ukr_mitService.saveAll'
		}
	});	
	Unilite.defineModel('s_agc850ukr_mitModel', {
	    fields: [  	    
	    	    {name : 'DIV_CODE'                    , text : '사업장'       	, type : 'string'   	, editable : false}
	    	  , {name : 'DATE_MONTH'                  , text : '조회월'          	, type : 'uniMonth'		, editable : false}
	    	  , {name : 'TYPE_FLAG'                   , text : '구분'          	, type : 'string' 		, editable : false}
	    	  , {name : 'ITEM_ACCOUNT_NAME'           , text : '매출유형(계정)'   	, type : 'string' 		, editable : false}
	    	  , {name : 'ITEM_LEVEL_NAME'             , text : '소분류'         	, type : 'string'  		, editable : false}
	    	  , {name : 'SALE_GUBUN'                  , text : '내수/수출'      	, type : 'string'  		, editable : false}
	    	  , {name : 'CONTINENT'                   , text : '대륙'        		, type : 'string'   	, editable : false}
	    	  , {name : 'NATION_NAME'                 , text : '지역'        		, type : 'string'   	, editable : false}
	    	  , {name : 'MONEY_UNIT'                  , text : '화폐'           	, type : 'string'  		, editable : false}
	    	  //당기
	    	  , {name : 'THISYEAR_AMT_I'              , text : '외화'      		, type : 'uniFC'    	, editable : false}
	    	  , {name : 'THISYEAR_LOC_AMT_I'          , text : '원화'    			, type : 'uniPrice'	 	, editable : false}
	    	  , {name : 'THISYEAR_PERCENTAGE'         , text : '비중'    			, type : 'uniPercent'	, editable : false}
	    	  //전기
	    	  , {name : 'LASTYEAR_AMT_I'              , text : '외화'       		, type : 'uniFC'   		, editable : false}
	    	  , {name : 'LASTYEAR_LOC_AMT_I'          , text : '원화'       		, type : 'uniPrice' 	, editable : false}
	    	  , {name : 'LASTYEAR_PERCENTAGE'         , text : '비중'    			, type : 'uniPercent'	, editable : false}
	    	  //전전기
	    	  , {name : 'BEFORELASTYEAR_AMT_I'        , text : '외화'      		, type : 'uniFC'      	, editable : false}
	    	  , {name : 'BEFORELASTYEAR_LOC_AMT_I'    , text : '원화'     		, type : 'uniPrice'  	, editable : false}
	    	  , {name : 'BEFORELASTYEAR_PERCENTAGE'   , text : '비중'    			, type : 'uniPercent'	, editable : false}
	    	  , {name : 'REMARK'                      , text : '비고'           	, type : 'string'                         }
	    	  , {name : 'FLAG'                        , text : ' '           	, type : 'string'     	, editable : false}
	    	  
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc850ukr_mitMasterStore',{
		model: 's_agc850ukr_mitModel',
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
			var paramMaster = panelResult.getValues();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect( {
					params: [paramMaster],
					success:function()	{
						if(directMasterStore.getData())	{
							UniApp.setToolbarButtons(['deleteAll'], true);
						}
					}
				} );
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			colspan     : 3
		}]
	});	
	
    var masterGrid = Unilite.createGrid('s_agc850ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		filter: {
    			useFilter: true,		//컬럼 filter 사용 여부
    			autoCreate: true		//컬럼 필터 자동 생성 여부
    		},
    		expandLastColumn: false
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(UniUtils.indexOf(record.get('ITEM_ACCOUNT_NAME') , ['소계']) ) {
					cls = 'x-change-cell_light';
				} else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['0099','1099','1990','2990'])) { 
					cls = 'x-change-cell_normal';
				}  else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['9990'])) { 
					cls = 'x-change-cell_dark';
				}
				return cls;
	        }
	    },  
        columns:  [     
        	   {dataIndex : 'TYPE_FLAG'                        , width : 150,		hidden : true }
        	  , {dataIndex : 'ITEM_ACCOUNT_NAME'                , width : 100}
        	  , {dataIndex : 'ITEM_LEVEL_NAME'	, width : 100}
        	  , {dataIndex : 'SALE_GUBUN'		, width : 100}
        	  , {dataIndex : 'CONTINENT'		, width : 130}
        	  , {dataIndex : 'NATION_NAME'		, width : 150}
        	  , {dataIndex : 'MONEY_UNIT'		, width : 80  }
        	  , {text:'당기',		columns:[{dataIndex : 'THISYEAR_AMT_I'			, width : 110} , {dataIndex : 'THISYEAR_LOC_AMT_I'			, width : 110} , {dataIndex : 'THISYEAR_PERCENTAGE'			, width : 100}] }
        	  , {text:'전기',		columns:[{dataIndex : 'LASTYEAR_AMT_I'			, width : 110} , {dataIndex : 'LASTYEAR_LOC_AMT_I' 			, width : 110} , {dataIndex : 'LASTYEAR_PERCENTAGE'			, width : 100}] }
        	  , {text:'전전기',	columns:[{dataIndex : 'BEFORELASTYEAR_AMT_I'	, width : 110} , {dataIndex : 'BEFORELASTYEAR_LOC_AMT_I'	, width : 110} , {dataIndex : 'BEFORELASTYEAR_PERCENTAGE'	, width : 100}] }
        	  , {dataIndex : 'REMARK'			, flex : 1}  
        	  , {dataIndex : 'FLAG'				, width : 70}
		]
    });
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc850ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("DATE_MONTH", UniDate.get('today'));
			
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
					s_agc850ukr_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		}
	});
};


</script>
