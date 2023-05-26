<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc860skr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc860skr_mit"/>
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc860skr_mitService.selectList1'
		}
	});	
	
	Unilite.defineModel('s_agc860skr_mitModel1', {
	    fields: [  	    
	    	    {name : 'TYPE_FLAG'                  , text : 'TYPE_FLAG'     	, type : 'string'   }
	    	  , {name : 'SALE_GUBUN'                 , text : '국내외'        	, type : 'string'   }
	    	  , {name : 'ITEM_ACCOUNT_NAME'          , text : '구분'       	, type : 'string'   }
	    	  , {name : 'ITEM_LEVEL_NAME'            , text : '품목군'       	, type : 'string'   }
	    	  , {name : 'SALE_Q'                     , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I'                     , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_01'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_01'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_02'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_02'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_03'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_03'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_04'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_04'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_05'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_05'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_06'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_06'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_07'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_07'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_08'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_08'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_09'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_09'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_10'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_10'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_11'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_11'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_12'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_12'                  , text : '금액'        	, type : 'uniPrice' }
	    	  
	    ]
	});
	
	var directMasterStore1 = Unilite.createStore('s_agc860skr_mitMasterStore1',{
		model: 's_agc860skr_mitModel1',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy1,
        loadStoreRecords: function() {
        	this.clearFilter(); 
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param
				});
        	}
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc860skr_mitService.selectList2'
		}
	});	
	
	Unilite.defineModel('s_agc860skr_mitModel2', {
	    fields: [  	    
	    	    {name : 'TYPE_FLAG'                  , text : '국내외'     	, type : 'string'   }
	    	  , {name : 'CONTINENT'                  , text : '대륙별'        , type : 'string'   }
	    	  , {name : 'NATION_NAME'          		 , text : '국가별'       	, type : 'string'   }
	    	  , {name : 'SALE_Q'                     , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I'                     , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_01'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_01'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_02'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_02'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_03'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_03'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_04'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_04'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_05'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_05'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_06'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_06'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_07'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_07'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_08'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_08'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_09'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_09'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_10'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_10'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_11'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_11'                  , text : '금액'        	, type : 'uniPrice' }
	    	  , {name : 'SALE_Q_12'                  , text : '수량'        	, type : 'uniQty'   }
	    	  , {name : 'SALE_I_12'                  , text : '금액'        	, type : 'uniPrice' }
	    	  
	    ]
	});
	
	var directMasterStore2 = Unilite.createStore('s_agc860skr_mitMasterStore2',{
		model: 's_agc860skr_mitModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy2,
        loadStoreRecords: function() {
        	this.clearFilter(); 
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param
				});
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
	
    var masterGrid1 = Unilite.createGrid('s_agc860skr_mitGrid1', {
        store: directMasterStore1,
        title: '품목군',
    	layout : 'fit',
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['0019','0029','1019','1029']) ) {
					cls = 'x-change-cell_light';
				} else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['0090','1090'])) { 
					cls = 'x-change-cell_normal';
				} else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['1990','2990'])) { 
					cls = 'x-change-cell_medium_dark';
				}  else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['9990'])) { 
					cls = 'x-change-cell_dark';
				}
				return cls;
	        }
	    },          
	    columns:  [     
        	  {dataIndex : 'TYPE_FLAG'                      , width : 80 , hidden:true}
        	, {dataIndex : 'SALE_GUBUN'                     , width : 80 }
        	, {dataIndex : 'ITEM_ACCOUNT_NAME'              , width : 80 }
        	, {dataIndex : 'ITEM_LEVEL_NAME'              	, width : 110 }
        	, {text : '함계'	, columns:[ {dataIndex : 'SALE_Q'		, width : 80}, {dataIndex : 'SALE_I'		, width : 100}]}
        	, {text : '1월'	, columns:[ {dataIndex : 'SALE_Q_01'	, width : 80}, {dataIndex : 'SALE_I_01'		, width : 100}]}
        	, {text : '2월'	, columns:[ {dataIndex : 'SALE_Q_02'	, width : 80}, {dataIndex : 'SALE_I_02'		, width : 100}]}
        	, {text : '3월'	, columns:[ {dataIndex : 'SALE_Q_03'	, width : 80}, {dataIndex : 'SALE_I_03'		, width : 100}]}
        	, {text : '4월'	, columns:[ {dataIndex : 'SALE_Q_04'	, width : 80}, {dataIndex : 'SALE_I_04'		, width : 100}]}
        	, {text : '5월'	, columns:[ {dataIndex : 'SALE_Q_05'	, width : 80}, {dataIndex : 'SALE_I_05'		, width : 100}]}
        	, {text : '6월'	, columns:[ {dataIndex : 'SALE_Q_06'	, width : 80}, {dataIndex : 'SALE_I_06'		, width : 100}]}
        	, {text : '7월'	, columns:[ {dataIndex : 'SALE_Q_07'	, width : 80}, {dataIndex : 'SALE_I_07'		, width : 100}]}
        	, {text : '8월'	, columns:[ {dataIndex : 'SALE_Q_08'	, width : 80}, {dataIndex : 'SALE_I_08'		, width : 100}]}
        	, {text : '9월'	, columns:[ {dataIndex : 'SALE_Q_09'	, width : 80}, {dataIndex : 'SALE_I_09'		, width : 100}]}
        	, {text : '10월'	, columns:[ {dataIndex : 'SALE_Q_10'	, width : 80}, {dataIndex : 'SALE_I_10'		, width : 100}]}
        	, {text : '11월'	, columns:[ {dataIndex : 'SALE_Q_11'	, width : 80}, {dataIndex : 'SALE_I_11'		, width : 100}]}
        	, {text : '12월'	, columns:[ {dataIndex : 'SALE_Q_12'	, width : 80}, {dataIndex : 'SALE_I_12'		, width : 100}]}
		]
    });  
    
    var masterGrid2 = Unilite.createGrid('s_agc860skr_mitGrid2', {
        store: directMasterStore2,
        title: '대륙별',
    	layout : 'fit',
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	console.log("record.get('TYPE_FLAG').substring(2,4) : ", record.get('TYPE_FLAG').substring(2,4))
	          	if(record.get('TYPE_FLAG').substring(2,4) =='90' ) {
					cls = 'x-change-cell_light';
				} else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['A999'])) { 
					cls = 'x-change-cell_normal';
				} else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['ZZ19','ZZ29'])) { 
					cls = 'x-change-cell_medium_dark';
				}  else if(UniUtils.indexOf(record.get('TYPE_FLAG') , ['ZZ99'])) { 
					cls = 'x-change-cell_dark';
				}
				return cls;
	        }
	    },          
	    columns:  [     
        	  {dataIndex : 'CONTINENT'    	, width : 80 }
        	, {dataIndex : 'NATION_NAME'   	, width : 110 }
        	, {text : '함계'	, columns:[ {dataIndex : 'SALE_Q'		, width : 80}, {dataIndex : 'SALE_I'		, width : 100}]}
        	, {text : '1월'	, columns:[ {dataIndex : 'SALE_Q_01'	, width : 80}, {dataIndex : 'SALE_I_01'		, width : 100}]}
        	, {text : '2월'	, columns:[ {dataIndex : 'SALE_Q_02'	, width : 80}, {dataIndex : 'SALE_I_02'		, width : 100}]}
        	, {text : '3월'	, columns:[ {dataIndex : 'SALE_Q_03'	, width : 80}, {dataIndex : 'SALE_I_03'		, width : 100}]}
        	, {text : '4월'	, columns:[ {dataIndex : 'SALE_Q_04'	, width : 80}, {dataIndex : 'SALE_I_04'		, width : 100}]}
        	, {text : '5월'	, columns:[ {dataIndex : 'SALE_Q_05'	, width : 80}, {dataIndex : 'SALE_I_05'		, width : 100}]}
        	, {text : '6월'	, columns:[ {dataIndex : 'SALE_Q_06'	, width : 80}, {dataIndex : 'SALE_I_06'		, width : 100}]}
        	, {text : '7월'	, columns:[ {dataIndex : 'SALE_Q_07'	, width : 80}, {dataIndex : 'SALE_I_07'		, width : 100}]}
        	, {text : '8월'	, columns:[ {dataIndex : 'SALE_Q_08'	, width : 80}, {dataIndex : 'SALE_I_08'		, width : 100}]}
        	, {text : '9월'	, columns:[ {dataIndex : 'SALE_Q_09'	, width : 80}, {dataIndex : 'SALE_I_09'		, width : 100}]}
        	, {text : '10월'	, columns:[ {dataIndex : 'SALE_Q_10'	, width : 80}, {dataIndex : 'SALE_I_10'		, width : 100}]}
        	, {text : '11월'	, columns:[ {dataIndex : 'SALE_Q_11'	, width : 80}, {dataIndex : 'SALE_I_11'		, width : 100}]}
        	, {text : '12월'	, columns:[ {dataIndex : 'SALE_Q_12'	, width : 80}, {dataIndex : 'SALE_I_12'		, width : 100}]}
		]
    });  
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid1,
	         masterGrid2
	    ]
    });
    
	Unilite.Main( {
		borderItems:[
			panelResult,tab
		],
		id: 's_agc860skr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("DATE_MONTH", UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			tab.getActiveTab().getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.reset();
			directMasterStore1.clearData();
			masterGrid2.reset();
			directMasterStore2.clearData();
			this.fnInitBinding();
		}
	});
};


</script>
