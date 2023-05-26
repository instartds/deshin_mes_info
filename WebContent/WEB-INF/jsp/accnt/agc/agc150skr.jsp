<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc150skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}


function appMain() {     
	
	var len = fnSetFormTitle.length; 
	var tabTitle1 ='대차대조표';
	var tabTitle2 ='손익계산서';
	var tabTitle3 ='제조원가명세서';
	var hideTab1  = true;
	var hideTab2  = true;
	var hideTab3  = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '10'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab3 = false;
			}
			tabTitle3 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc150skrModel', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율' 		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});
	
	Unilite.defineModel('Agc150skrModel2', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율' 		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});
	
	Unilite.defineModel('Agc150skrModel3', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율' 		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});

	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc150skrMasterStore1',{
		model: 'Agc150skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc150skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agc150skrMasterStore2',{
		model: 'Agc150skrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc150skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('agc150skrMasterStore3',{
		model: 'Agc150skrModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc150skrService.selectList3'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    	}   	
			    }
			},{ 
				fieldLabel: '사업장1',
				name: 'DIV_CODE1',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
		        allowBlank:false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE1', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장2',
				name: 'DIV_CODE2',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE2', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장3',
				name: 'DIV_CODE3',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE3', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장4',
				name: 'DIV_CODE4',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE4', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장5',
				name: 'DIV_CODE5',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE5', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장6',
				name: 'DIV_CODE6',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				comboType: 'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE6', newValue);
					}
				}
			}
		]},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
    		defaultType: 'uniTextfield',
    		layout : {type : 'uniTable', columns : 1},
    		defaultType: 'uniTextfield',
    		items:[{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '금액단위',
		 		name:'AMT_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B042',
		 		allowBlank:false,
		 		listeners: {
				    afterrender: function(combo) {
				        var recordSelected = combo.getStore().getAt(0);                     
				        combo.setValue(recordSelected.get('value'));
				    }
				}
	 		},{
		 		fieldLabel: '재무제표양식차수',
		 		name:'GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value: BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',		
				items: [{
					boxLabel: '과목명1', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '0',
					checked:true
				},{
					boxLabel : '과목명2', 
					width: 70,
					name: 'ACCOUNT_NAME',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '2' 
				}]
	 		}]			
		}]			
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
        	fieldLabel: '전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
			allowBlank:false,
			width: 315,
			colspan:2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);
					UniAppManager.app.fnSetStDate(newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO',newValue);
		    	}   	
		    }
		},{ 
			fieldLabel: '사업장1',
			name: 'DIV_CODE1',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
	        allowBlank:false,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE1', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장2',
			name: 'DIV_CODE2',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE2', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장3',
			name: 'DIV_CODE3',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE3', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장4',
			name: 'DIV_CODE4',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE4', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장5',
			name: 'DIV_CODE5',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE5', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장6',
			name: 'DIV_CODE6',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE6', newValue);
				}
			}
		}]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agc150skrGrid1', {
    	layout : 'fit',
    	title  : tabTitle1,
    	hidden : hideTab1,
    	excelTitle: '사업장별재무제표' + '   (' + tabTitle1 + ')',
        region : 'center',
        store : directMasterStore, 
        uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc150rkr('10');
        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOT_AMT_I'		, width: 133},
			{itemId:'CHANGE_NAME1',
					columns:[{ dataIndex: 'AMT_I1'		, width: 150},
							 { dataIndex: 'RATE_1'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME2',
					columns:[{ dataIndex: 'AMT_I2'		, width: 150},
							 { dataIndex: 'RATE_2'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME3',
					columns:[{ dataIndex: 'AMT_I3'		, width: 150},
							 { dataIndex: 'RATE_3'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME4',
					columns:[{ dataIndex: 'AMT_I4'		, width: 150},
							 { dataIndex: 'RATE_4'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME5',
					columns:[{ dataIndex: 'AMT_I5'		, width: 150},
							 { dataIndex: 'RATE_5'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME6',
					columns:[{ dataIndex: 'AMT_I6'		, width: 150},
							 { dataIndex: 'RATE_6'		, width: 70}
					]	
			}
		]              	        
    });   
    
    var masterGrid2 = Unilite.createGrid('agc150skrGrid2', {
    	layout : 'fit',
    	title  : tabTitle2,
    	hidden : hideTab2,
    	excelTitle: '사업장별재무제표' + '   (' + tabTitle2 + ')',
        region : 'center',
        store : directMasterStore2, 
        uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc150rkr('20');
	        	}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOT_AMT_I'		, width: 133},
			{itemId:'CHANGE_NAME7',
					columns:[{ dataIndex: 'AMT_I1'		, width: 150},
							 { dataIndex: 'RATE_1'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME8',
					columns:[{ dataIndex: 'AMT_I2'		, width: 150},
							 { dataIndex: 'RATE_2'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME9',
					columns:[{ dataIndex: 'AMT_I3'		, width: 150},
							 { dataIndex: 'RATE_3'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME10',
					columns:[{ dataIndex: 'AMT_I4'		, width: 150},
							 { dataIndex: 'RATE_4'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME11',
					columns:[{ dataIndex: 'AMT_I5'		, width: 150},
							 { dataIndex: 'RATE_5'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME12',
					columns:[{ dataIndex: 'AMT_I6'		, width: 150},
							 { dataIndex: 'RATE_6'		, width: 70}
					]	
			}
		]              	        
    }); 
    
    var masterGrid3 = Unilite.createGrid('agc150skrGrid3', {
    	layout : 'fit',
    	title  : tabTitle3,
    	hidden : hideTab3,
    	excelTitle: '사업장별재무제표' + '   (' + tabTitle3 + ')',
        region : 'center',
        store : directMasterStore3, 
        uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc150rkr('30');
	        	}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOT_AMT_I'		, width: 133},
			{itemId:'CHANGE_NAME13',
					columns:[{ dataIndex: 'AMT_I1'		, width: 150},
							 { dataIndex: 'RATE_1'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME14',
					columns:[{ dataIndex: 'AMT_I2'		, width: 150},
							 { dataIndex: 'RATE_2'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME15',
					columns:[{ dataIndex: 'AMT_I3'		, width: 150},
							 { dataIndex: 'RATE_3'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME16',
					columns:[{ dataIndex: 'AMT_I4'		, width: 150},
							 { dataIndex: 'RATE_4'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME17',
					columns:[{ dataIndex: 'AMT_I5'		, width: 150},
							 { dataIndex: 'RATE_5'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME18',
					columns:[{ dataIndex: 'AMT_I6'		, width: 150},
							 { dataIndex: 'RATE_6'		, width: 70}
					]	
			}
		]              	        
    }); 
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2,
	         masterGrid3
	    ],
	    listeners:{
	    	beforetabchange: function( tabPanel, newCard, oldCard, eOpts ) {	
    			if(!UniAppManager.app.fnCheckData(true)){
					return false;
				}
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			
    			if(newCard.getItemId() == 'agc150skrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc150skrGrid2') {
    				UniAppManager.app.onQueryButtonDown();
    			}
    			else if(newCard.getItemId() == 'agc150skrGrid3') {
    				UniAppManager.app.onQueryButtonDown();
    			}
    		}
    	}
    });
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		], 
		id : 'agc150skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			masterGrid.down('#CHANGE_NAME1').setText('사업장1');
			masterGrid.down('#CHANGE_NAME2').setText('사업장2');
			masterGrid.down('#CHANGE_NAME3').setText('사업장3');
			masterGrid.down('#CHANGE_NAME4').setText('사업장4');
			masterGrid.down('#CHANGE_NAME5').setText('사업장5');
			masterGrid.down('#CHANGE_NAME6').setText('사업장6');
			
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				var activeTabId = tab.getActiveTab().getId();			
				if(activeTabId == 'agc150skrGrid1'){				
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){			
						masterGrid.down('#CHANGE_NAME1').setText(panelSearch.getField('DIV_CODE1').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){
						masterGrid.down('#CHANGE_NAME1').setText('사업장1');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid.down('#CHANGE_NAME2').setText(panelSearch.getField('DIV_CODE2').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid.down('#CHANGE_NAME2').setText('사업장2');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid.down('#CHANGE_NAME3').setText(panelSearch.getField('DIV_CODE3').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid.down('#CHANGE_NAME3').setText('사업장3');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid.down('#CHANGE_NAME4').setText(panelSearch.getField('DIV_CODE4').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid.down('#CHANGE_NAME4').setText('사업장4');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid.down('#CHANGE_NAME5').setText(panelSearch.getField('DIV_CODE5').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid.down('#CHANGE_NAME5').setText('사업장5');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid.down('#CHANGE_NAME6').setText(panelSearch.getField('DIV_CODE6').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid.down('#CHANGE_NAME6').setText('사업장6');
					}
					
					directMasterStore.loadStoreRecords();
					
				}else if(activeTabId == 'agc150skrGrid2'){
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){
						masterGrid2.down('#CHANGE_NAME7').setText(panelSearch.getField('DIV_CODE1').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){
						masterGrid2.down('#CHANGE_NAME7').setText('사업장1');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid2.down('#CHANGE_NAME8').setText(panelSearch.getField('DIV_CODE2').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid2.down('#CHANGE_NAME8').setText('사업장2');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid2.down('#CHANGE_NAME9').setText(panelSearch.getField('DIV_CODE3').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid2.down('#CHANGE_NAME9').setText('사업장3');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid2.down('#CHANGE_NAME10').setText(panelSearch.getField('DIV_CODE4').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid2.down('#CHANGE_NAME10').setText('사업장4');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid2.down('#CHANGE_NAME11').setText(panelSearch.getField('DIV_CODE5').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid2.down('#CHANGE_NAME11').setText('사업장5');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid2.down('#CHANGE_NAME12').setText(panelSearch.getField('DIV_CODE6').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid2.down('#CHANGE_NAME12').setText('사업장6');
					}
					
					directMasterStore2.loadStoreRecords();			
					
				}else if(activeTabId == 'agc150skrGrid3'){	
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){
						masterGrid3.down('#CHANGE_NAME13').setText(panelSearch.getField('DIV_CODE1').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE1'))){
						masterGrid3.down('#CHANGE_NAME13').setText('사업장1');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid3.down('#CHANGE_NAME14').setText(panelSearch.getField('DIV_CODE2').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE2'))){
						masterGrid3.down('#CHANGE_NAME14').setText('사업장2');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid3.down('#CHANGE_NAME15').setText(panelSearch.getField('DIV_CODE3').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE3'))){
						masterGrid3.down('#CHANGE_NAME15').setText('사업장3');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid3.down('#CHANGE_NAME16').setText(panelSearch.getField('DIV_CODE4').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE4'))){
						masterGrid3.down('#CHANGE_NAME16').setText('사업장4');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid3.down('#CHANGE_NAME17').setText(panelSearch.getField('DIV_CODE5').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE5'))){
						masterGrid3.down('#CHANGE_NAME17').setText('사업장5');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid3.down('#CHANGE_NAME18').setText(panelSearch.getField('DIV_CODE6').getRawValue());
					}
					else if(Ext.isEmpty(panelSearch.getValue('DIV_CODE6'))){
						masterGrid3.down('#CHANGE_NAME18').setText('사업장6');
					}
					
					directMasterStore3.loadStoreRecords();				
				}
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnCheckData:function(newValue){
			var dateFr = panelSearch.getField('DATE_FR').getSubmitValue();  // 전표일 FR
			var dateTo = panelSearch.getField('DATE_TO').getSubmitValue();  // 전표일 TO
			// 전기전표일


			var r= true
			
			if(dateFr > dateTo) {
				alert('시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('DATE_FR',dateFr);
				panelResult.setValue('DATE_FR',dateFr);						
				panelSearch.getField('DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
		},
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
		fnGotoAgc150rkr: function(divi) {
			var params = {
				PGM_ID			: 'agc150skr',
				DATE_FR			: panelSearch.getValue('DATE_FR'),
				DATE_TO			: panelSearch.getValue('DATE_TO'),
				DIV_CODE1		: panelSearch.getValue('DIV_CODE1'),
				DIV_CODE2		: panelSearch.getValue('DIV_CODE2'),
				DIV_CODE3		: panelSearch.getValue('DIV_CODE3'),
				DIV_CODE4		: panelSearch.getValue('DIV_CODE4'),
				DIV_CODE5		: panelSearch.getValue('DIV_CODE5'),
				DIV_CODE6		: panelSearch.getValue('DIV_CODE6'),
				START_DATE		: panelSearch.getValue('START_DATE'),
				AMT_UNIT		: panelSearch.getValue('AMT_UNIT'),
				GUBUN			: panelSearch.getValue('GUBUN'),
				ACCOUNT_NAME	: panelSearch.getValues().ACCOUNT_NAME,
				DIVI			: divi
			};
			var rec = {data : {prgID : 'agc150rkr', 'text':''}};
			parent.openTab(rec, '/accnt/agc150rkr.do', params, CHOST+CPATH); 
        }
	});
};


</script>
