<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc810skr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc810skr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="M001" />								<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc810skr_mitService.selectList'
		}
	});	
	Unilite.defineModel('s_agc810skr_mitModel', {
	    fields: [  	    
	    	    {name : 'DIV_CODE'                    , text : '사업장'   	, type : 'string'            }
	    	  , {name : 'TARGET_COUNT'                , text : '집계대상'    	, type : 'string'            , comboType:'AU' , comboCode:'B143'}
	    	  , {name : 'LEVEL_NAME'                  , text : '품목'     	, type : 'string'            }
	    	  , {name : 'CUSTON_CODE'                 , text : '구입처코드' 	, type : 'string'            }
	    	  , {name : 'CUSTOM_NAME'                 , text : '구입처'    	, type : 'string'            }
	    	  , {name : 'MONEY_UNIT'                  , text : '통화'    		, type : 'string'            , comboType:'AU' , comboCode:'B004'}
	    	  , {name : 'ORDER_TYPE'                  , text : '내수/수입' 	, type : 'string'            , comboType:'AU' , comboCode:'M001'}
	    	  , {name : 'THISYEAR_FOR_O'              , text : '외화' 		, type : 'uniFC'            }
	    	  , {name : 'THISYEAR_I'                  , text : '원화' 		, type : 'uniPrice'          }
	    	  , {name : 'LASTYEAR_FOR_O'              , text : '외화'   		, type : 'uniFC'            }
	    	  , {name : 'LASTYEAR_I'                  , text : '원화' 		, type : 'uniPrice'          }
	    	  , {name : 'BEFORELASTYEAR_FOR_O'        , text : '외화' 		, type : 'uniFC'            }
	    	  , {name : 'BEFORELASTYEAR_I'            , text : '원화'  		, type : 'uniPrice'          }
	    	  
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc810skr_mitMasterStore',{
		model: 's_agc810skr_mitModel',
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
			multiSelect : true,
			colspan     : 3
		}]
	});	
	
    var masterGrid = Unilite.createGrid('s_agc810skr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		filter: {
    			useFilter: true,		//컬럼 filter 사용 여부
    			autoCreate: true		//컬럼 필터 자동 생성 여부
    		},
    	},
    	features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	    {dataIndex : 'TARGET_COUNT'                 , width : 100,  hidden:true}
        	  , {dataIndex : 'LEVEL_NAME'                   , width : 150,
	  				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
				}}
        	  , {dataIndex : 'ORDER_TYPE'                  , width : 110}
        	  , {dataIndex : 'CUSTOM_CODE'                 , width : 100, hidden : true}
        	  , {dataIndex : 'CUSTOM_NAME'                 , width : 200}
        	  , {dataIndex : 'MONEY_UNIT'                  , width : 100}
	    	  , {text:'당기', 	columns:[{dataIndex : 'THISYEAR_FOR_O'              , width : 130, summaryType : 'sum'} , {dataIndex : 'THISYEAR_I'                  , width : 130, summaryType : 'sum'}]}
	    	  , {text:'전기', 	columns:[{dataIndex : 'LASTYEAR_FOR_O'              , width : 130, summaryType : 'sum'} , {dataIndex : 'LASTYEAR_I'                  , width : 130, summaryType : 'sum'}]}
	    	  , {text:'전전기', 	columns:[{dataIndex : 'BEFORELASTYEAR_FOR_O'        , width : 130, summaryType : 'sum'} , {dataIndex : 'BEFORELASTYEAR_I'            , width : 130, summaryType : 'sum'}]}
		]
    });
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc810skr_mitApp',
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
		}
	});
};


</script>
