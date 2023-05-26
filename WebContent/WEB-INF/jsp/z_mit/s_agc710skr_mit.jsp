<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc710skr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc710skr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B020"/>								<!-- 품목계정 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc710skr_mitService.selectList'
		}
	});	
	
	Unilite.defineModel('s_agc710skr_mitModel', {
	    fields: [  	    
	    	  {name : 'DIV_CODE'                    , text : '사업장'                 	        , type : 'string'            , allowBlank : false }
	    	, {name : 'ITEM_ACCOUNT'                , text : '품목계정'                         	, type : 'string'            , allowBlank : false , comboType:'AU', comboCode:'B020'}
	    	, {name : 'FR_DATE'                     , text : '조회시작월'                        	, type : 'string'            , allowBlank : false }
	    	, {name : 'TO_DATE'                     , text : '조회종료월'                        	, type : 'string'            , allowBlank : false }
	    	, {name : 'ITEM_CODE'                   , text : '품목코드'                         	    , type : 'string'            , allowBlank : false }
	    	, {name : 'ITEM_NAME'                   , text : '품목명'                         	, type : 'string'            , allowBlank : false }
	    	, {name : 'SALE_DATE'                   , text : '매출발생일'                          , type : 'uniDate'           , allowBlank : false }
	    	, {name : 'EXPIRATION_DATE'             , text : '무상보증기간'                    		, type : 'uniDate'                                }
	    	, {name : 'EXPIRATION_DAY'              , text : '무상보증기간(개월)'                   	, type : 'int'                                    }
	    	, {name : 'USED_M'                      , text : '사용월'                          	, type : 'int'                                    }
	    	, {name : 'REDEDU_M'                    , text : '잔여월'                          	, type : 'int'                                    }
	    	, {name : 'CUSTOM_CODE'                 , text : '매출처코드'                          , type : 'string'            , allowBlank : false }
	    	, {name : 'CUSTOM_NAME'                 , text : '매출처'                          	, type : 'string'            , allowBlank : false }
	    	, {name : 'DVRY_CUST_CD'                , text : '병원'                          	    , type : 'string'                                 }
	    	, {name : 'DVRY_CUST_NM'                , text : '병원명(장소)'                       	, type : 'string'                                 }
	    	, {name : 'SALE_AMT'                    , text : '금액'                         		, type : 'uniPrice'                               }
	    	
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc710skr_mitMasterStore',{
		model: 's_agc710skr_mitModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
      
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
		})]
	});	
	
    var masterGrid = Unilite.createGrid('s_agc710skr_mitGrid', {
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
        	, {dataIndex : 'EXPIRATION_DAY'                   , width : 130}
        	, {dataIndex : 'USED_M'                           , width : 80}
        	, {dataIndex : 'REDEDU_M'                         , width : 80 }
        	, {dataIndex : 'CUSTOM_CODE'                      , width : 80    ,hidden : true}
        	, {dataIndex : 'CUSTOM_NAME'                      , width : 170}
        	, {dataIndex : 'DVRY_CUST_CD'                     , width : 150   ,hidden : true}
        	, {dataIndex : 'DVRY_CUST_NM'                     , width : 100 }
        	, {dataIndex : 'SALE_AMT'                         , width : 100   , summaryType : 'sum'}
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc710skr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", "02");
			panelResult.setValue("FR_DATE", UniDate.get('startOfYear'));
			panelResult.setValue("TO_DATE", UniDate.get('today'));
			panelResult.setValue("ITEM_ACCOUNT", "10");
			
			
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
		}
	});
	
};


</script>
