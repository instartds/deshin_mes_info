<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc160skr"  >
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
	var tabTitle1 ='손익계산서';
	var tabTitle2 ='제조원가명세서';

	
	var hideTab1  = true;
	var hideTab2  = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc160skrModel', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});
	
	Unilite.defineModel('Agc160skrModel2', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율'		,type: 'uniPercent'},
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
	var directMasterStore = Unilite.createStore('agc160skrMasterStore1',{
		model: 'Agc160skrModel',
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
                read: 'agc160skrService.selectList1'                	
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
	
	var directMasterStore2 = Unilite.createStore('agc160skrMasterStore2',{
		model: 'Agc160skrModel2',
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
                read: 'agc160skrService.selectList2'                	
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
			},
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 1',
					allowBlank:false,
					valueFieldName: 'AC_PROJECT_CODE1',
					textFieldName: 'AC_PROJECT_NAME1',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE1', panelSearch.getValue('AC_PROJECT_CODE1'));
								panelResult.setValue('AC_PROJECT_NAME1', panelSearch.getValue('AC_PROJECT_NAME1'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE1', '');
							panelResult.setValue('AC_PROJECT_NAME1', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 2',
					valueFieldName: 'AC_PROJECT_CODE2',
					textFieldName: 'AC_PROJECT_NAME2',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE2', panelSearch.getValue('AC_PROJECT_CODE2'));
								panelResult.setValue('AC_PROJECT_NAME2', panelSearch.getValue('AC_PROJECT_NAME2'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE2', '');
							panelResult.setValue('AC_PROJECT_NAME2', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 3',
					valueFieldName: 'AC_PROJECT_CODE3',
					textFieldName: 'AC_PROJECT_NAME3',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE3', panelSearch.getValue('AC_PROJECT_CODE3'));
								panelResult.setValue('AC_PROJECT_NAME3', panelSearch.getValue('AC_PROJECT_NAME3'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE3', '');
							panelResult.setValue('AC_PROJECT_NAME3', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 4',
					valueFieldName: 'AC_PROJECT_CODE4',
					textFieldName: 'AC_PROJECT_NAME4',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE4', panelSearch.getValue('AC_PROJECT_CODE4'));
								panelResult.setValue('AC_PROJECT_NAME4', panelSearch.getValue('AC_PROJECT_NAME4'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE4', '');
							panelResult.setValue('AC_PROJECT_NAME4', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 5',
					valueFieldName: 'AC_PROJECT_CODE5',
					textFieldName: 'AC_PROJECT_NAME5',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE5', panelSearch.getValue('AC_PROJECT_CODE5'));
								panelResult.setValue('AC_PROJECT_NAME5', panelSearch.getValue('AC_PROJECT_NAME5'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE5', '');
							panelResult.setValue('AC_PROJECT_NAME5', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트 6',
					valueFieldName: 'AC_PROJECT_CODE6',
					textFieldName: 'AC_PROJECT_NAME6',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('AC_PROJECT_CODE6', panelSearch.getValue('AC_PROJECT_CODE6'));
								panelResult.setValue('AC_PROJECT_NAME6', panelSearch.getValue('AC_PROJECT_NAME6'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE6', '');
							panelResult.setValue('AC_PROJECT_NAME6', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
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
					inputValue: '0'
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
		},
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 1',
				allowBlank:false,
				valueFieldName: 'AC_PROJECT_CODE1',
				textFieldName: 'AC_PROJECT_NAME1',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE1', panelResult.getValue('AC_PROJECT_CODE1'));
							panelSearch.setValue('AC_PROJECT_NAME1', panelResult.getValue('AC_PROJECT_NAME1'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE1', '');
						panelSearch.setValue('AC_PROJECT_NAME1', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 2',
				valueFieldName: 'AC_PROJECT_CODE2',
				textFieldName: 'AC_PROJECT_NAME2',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE2', panelResult.getValue('AC_PROJECT_CODE2'));
							panelSearch.setValue('AC_PROJECT_NAME2', panelResult.getValue('AC_PROJECT_NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE2', '');
						panelSearch.setValue('AC_PROJECT_NAME2', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 3',
				valueFieldName: 'AC_PROJECT_CODE3',
				textFieldName: 'AC_PROJECT_NAME3',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE3', panelResult.getValue('AC_PROJECT_CODE3'));
							panelSearch.setValue('AC_PROJECT_NAME3', panelResult.getValue('AC_PROJECT_NAME3'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE3', '');
						panelSearch.setValue('AC_PROJECT_NAME3', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 4',
				valueFieldName: 'AC_PROJECT_CODE4',
				textFieldName: 'AC_PROJECT_NAME4',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE4', panelResult.getValue('AC_PROJECT_CODE4'));
							panelSearch.setValue('AC_PROJECT_NAME4', panelResult.getValue('AC_PROJECT_NAME4'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE4', '');
						panelSearch.setValue('AC_PROJECT_NAME4', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 5',
				valueFieldName: 'AC_PROJECT_CODE5',
				textFieldName: 'AC_PROJECT_NAME5',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE5', panelResult.getValue('AC_PROJECT_CODE5'));
							panelSearch.setValue('AC_PROJECT_NAME5', panelResult.getValue('AC_PROJECT_NAME5'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE5', '');
						panelSearch.setValue('AC_PROJECT_NAME5', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '프로젝트 6',
				valueFieldName: 'AC_PROJECT_CODE6',
				textFieldName: 'AC_PROJECT_NAME6',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE6', panelResult.getValue('AC_PROJECT_CODE6'));
							panelSearch.setValue('AC_PROJECT_NAME6', panelResult.getValue('AC_PROJECT_NAME6'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('AC_PROJECT_CODE6', '');
						panelSearch.setValue('AC_PROJECT_NAME6', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		})]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agc160skrGrid1', {
    	title  : tabTitle1,
    	hidden : hideTab1,
    	excelTitle: '프로젝트별재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
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
	        		UniAppManager.app.fnGotoAgc160rkr('20');
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
    
     var masterGrid2 = Unilite.createGrid('agc160skrGrid2', {
    	title  : tabTitle2,
    	hidden : hideTab2,
    	excelTitle: '프로젝트별재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
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
	        		UniAppManager.app.fnGotoAgc160rkr('30');
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
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2
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
    			
    			if(newCard.getItemId() == 'agc160skrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc160skrGrid2') {
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
		id : 'agc160skrApp',
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
			
			/* 그리드 기본 값 */
			masterGrid.down('#CHANGE_NAME1').setText('프로젝트1');
			masterGrid.down('#CHANGE_NAME2').setText('프로젝트2');
			masterGrid.down('#CHANGE_NAME3').setText('프로젝트3');
			masterGrid.down('#CHANGE_NAME4').setText('프로젝트4');
			masterGrid.down('#CHANGE_NAME5').setText('프로젝트5');
			masterGrid.down('#CHANGE_NAME6').setText('프로젝트6');
			

		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();
			
			if(!UniAppManager.app.isValidSearchForm()){
					return false;
			}else{
			
				if(activeTabId == 'agc160skrGrid1'){	
					
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
						masterGrid.down('#CHANGE_NAME1').setText(panelSearch.getValue('AC_PROJECT_NAME1'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
						masterGrid.down('#CHANGE_NAME1').setText('프로젝트1');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
						masterGrid.down('#CHANGE_NAME2').setText(panelSearch.getValue('AC_PROJECT_NAME2'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
						masterGrid.down('#CHANGE_NAME2').setText('프로젝트2');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
						masterGrid.down('#CHANGE_NAME3').setText(panelSearch.getValue('AC_PROJECT_NAME3'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
						masterGrid.down('#CHANGE_NAME3').setText('프로젝트3');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
						masterGrid.down('#CHANGE_NAME4').setText(panelSearch.getValue('AC_PROJECT_NAME4'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
						masterGrid.down('#CHANGE_NAME4').setText('프로젝트4');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
						masterGrid.down('#CHANGE_NAME5').setText(panelSearch.getValue('AC_PROJECT_NAME5'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
						masterGrid.down('#CHANGE_NAME5').setText('프로젝트5');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
						masterGrid.down('#CHANGE_NAME6').setText(panelSearch.getValue('AC_PROJECT_NAME6'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
						masterGrid.down('#CHANGE_NAME6').setText('프로젝트6');
					}
					directMasterStore.loadStoreRecords();			
				}else if(activeTabId == 'agc160skrGrid2'){	
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
						masterGrid2.down('#CHANGE_NAME7').setText(panelSearch.getValue('AC_PROJECT_NAME1'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
						masterGrid2.down('#CHANGE_NAME7').setText('프로젝트1');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
						masterGrid2.down('#CHANGE_NAME8').setText(panelSearch.getValue('AC_PROJECT_NAME2'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
						masterGrid2.down('#CHANGE_NAME8').setText('프로젝트2');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
						masterGrid2.down('#CHANGE_NAME9').setText(panelSearch.getValue('AC_PROJECT_NAME3'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
						masterGrid2.down('#CHANGE_NAME9').setText('프로젝트3');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
						masterGrid2.down('#CHANGE_NAME10').setText(panelSearch.getValue('AC_PROJECT_NAME4'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
						masterGrid2.down('#CHANGE_NAME10').setText('프로젝트4');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
						masterGrid2.down('#CHANGE_NAME11').setText(panelSearch.getValue('AC_PROJECT_NAME5'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
						masterGrid2.down('#CHANGE_NAME11').setText('프로젝트5');
					}
					
					if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
						masterGrid2.down('#CHANGE_NAME12').setText(panelSearch.getValue('AC_PROJECT_NAME6'));
					}
					else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
						masterGrid2.down('#CHANGE_NAME12').setText('프로젝트6');
					}
					directMasterStore2.loadStoreRecords();			
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
		fnGotoAgc160rkr: function(divi) {
			var params = {
				PGM_ID				: 'agc160skr',
				DATE_FR				: panelSearch.getValue('DATE_FR'),
				DATE_TO				: panelSearch.getValue('DATE_TO'),
				AC_PROJECT_CODE1	: panelSearch.getValue('AC_PROJECT_CODE1'),
				AC_PROJECT_CODE2	: panelSearch.getValue('AC_PROJECT_CODE2'),
				AC_PROJECT_CODE3	: panelSearch.getValue('AC_PROJECT_CODE3'),
				AC_PROJECT_CODE4	: panelSearch.getValue('AC_PROJECT_CODE4'),
				AC_PROJECT_CODE5	: panelSearch.getValue('AC_PROJECT_CODE5'),
				AC_PROJECT_CODE6	: panelSearch.getValue('AC_PROJECT_CODE6'),
				AC_PROJECT_NAME1	: panelSearch.getValue('AC_PROJECT_NAME1'),
				AC_PROJECT_NAME2	: panelSearch.getValue('AC_PROJECT_NAME2'),
				AC_PROJECT_NAME3	: panelSearch.getValue('AC_PROJECT_NAME3'),
				AC_PROJECT_NAME4	: panelSearch.getValue('AC_PROJECT_NAME4'),
				AC_PROJECT_NAME5	: panelSearch.getValue('AC_PROJECT_NAME5'),
				AC_PROJECT_NAME6	: panelSearch.getValue('AC_PROJECT_NAME6'),
				START_DATE			: panelSearch.getValue('START_DATE'),
				AMT_UNIT			: panelSearch.getValue('AMT_UNIT'),
				GUBUN				: panelSearch.getValue('GUBUN'),
				ACCOUNT_NAME		: panelSearch.getValues().ACCOUNT_NAME,
				DIVI				: divi
			};
			var rec = {data : {prgID : 'agc160rkr', 'text':''}};
			parent.openTab(rec, '/accnt/agc160rkr.do', params, CHOST+CPATH); 
        }
	});
};


</script>
