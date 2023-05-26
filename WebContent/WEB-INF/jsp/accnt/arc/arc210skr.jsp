<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc210skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Arc210skrModel', {
        fields:[
            {name: 'RECE_GUBUN'             , text: '채권구분'     , type: 'string', comboType:'AU', comboCode:'J501'},
            {name: 'RECE_COMP_CODE'         , text: '회사코드'     , type: 'string'},
            {name: 'RECE_COMP_NAME'         , text: '회사명'      , type: 'string'},  
            {name: 'CONF_RECE_NO'           , text: '채권번호'     , type: 'string'},
            {name: 'CUSTOM_CODE'            , text: '거래처코드'    , type: 'string'},
            {name: 'CUSTOM_NAME'            , text: '거래처명'     , type: 'string'},
            {name: 'TOP_NAME'               , text: '대표자'      , type: 'string'},
            {name: 'CONF_DRAFTER_NAME'      , text: '법무담당자'    , type: 'string'},
            {name: 'MNG_GUBUN'              , text: '구분'        , type: 'string', comboType:'AU', comboCode:'J504'},
            {name: 'TOT_CARRYOVER_AMT'      , text: '이월'        , type: 'uniPrice'},
            {name: 'TOT_RECEIVE_AMT'        , text: '접수'        , type: 'uniPrice'},
            {name: 'TOT_CONVERT_AMT'        , text: '사후전환'     , type: 'uniPrice'},
            {name: 'TOT_COLLECT_AMT'        , text: '수금'        , type: 'uniPrice'},
            {name: 'TOT_ADJUST_AMT'         , text: '조정'        , type: 'uniPrice'},
            {name: 'TOT_BALANCE_AMT'        , text: '잔액'        , type: 'uniPrice'},
            {name: 'TOT_DISPOSAL_AMT'       , text: '대손처리'     , type: 'uniPrice'},
            {name: 'TOT_BOOKVALUE_AMT'      , text: '장부가액'     , type: 'uniPrice'},
            {name: 'CONF_RECE_DATE'         , text: '이관일'       , type: 'uniDate'}
	   ]
	});	
			
	var directDetailStore = Unilite.createStore('Arc210skrdirectDetailStore',{
		model: 'Arc210skrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'arc210skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 360,
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
                fieldLabel: '조회기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('DATE_TO', newValue);                            
                    }
                }
            },
            Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }),     
            Unilite.popup('CONF_RECE',{
                fieldLabel: '채권번호', 
                valueFieldName:'CONF_RECE_NO',
                textFieldName:'CONF_RECE_CUSTOM_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_RECE_NO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_RECE_CUSTOM_NAME', newValue);                
                    }
                }
            }),         
            Unilite.popup('CUST',{
                fieldLabel: '거래처', 
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_NAME', newValue);              
                    }
                }
            }),    
            {
                xtype: 'uniCombobox',
                fieldLabel: '채권구분',
                name:'RECE_GUBUN',  
                comboType:'AU',
                comboCode:'J501',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('RECE_GUBUN', newValue);
                    }
                }
            },          
            Unilite.popup('Employee',{
                fieldLabel: '법무담당', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'CONF_DRAFTER',
                textFieldName:'CONF_DRAFTER_NAME',
//                extParam: {
//                    'ADD_QUERY': "Y"
//                },  
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER_NAME', newValue);             
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'ADD_QUERY': "Y"});                           
                    }
                }
            }),                     
            {
                xtype: 'uniCombobox',
                fieldLabel: '수금관리항목',
                name:'COLL_MANA',  
                comboType:'AU',
                comboCode:'J505',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('COLL_MANA', newValue);
                    }
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:300,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '잔액기준',
                    items: [{
                        boxLabel: '발생', 
                        width: 50,
                        name: 'RADIO_1',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel: '잔액', 
                        width: 70,
                        name: 'RADIO_1',
                        inputValue: '1' 
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('RADIO_1').setValue(newValue.RADIO_1);                 
                        }
                    }
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:300,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '장부가액',
                    items: [{
                        boxLabel: '발생', 
                        width: 50,
                        name: 'RADIO_2',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel: '잔액', 
                        width: 70,
                        name: 'RADIO_2',
                        inputValue: '1' 
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('RADIO_2').setValue(newValue.RADIO_2);                 
                        }
                    }
                }]
            }]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'DATE_FR',
            endFieldName: 'DATE_TO',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('DATE_TO', newValue);                            
                }
            }
        },
        Unilite.popup('COMP',{
            fieldLabel: '회사명', 
            valueFieldName:'RECE_COMP_CODE',
            textFieldName:'RECE_COMP_NAME',
            validateBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_NAME', newValue);                
                }
            }
        }),     
        Unilite.popup('CONF_RECE',{
            fieldLabel: '채권번호', 
            valueFieldName:'CONF_RECE_NO',
            textFieldName:'CONF_RECE_CUSTOM_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_RECE_NO', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_RECE_CUSTOM_NAME', newValue);                
                }
            }
        }),         
        Unilite.popup('CUST',{
            fieldLabel: '거래처', 
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            validateBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_NAME', newValue);              
                }
            }
        }),           
        {
            xtype: 'uniCombobox',
            fieldLabel: '채권구분',
            name:'RECE_GUBUN',  
            comboType:'AU',
            comboCode:'J501',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('RECE_GUBUN', newValue);
                }
            }
        },                    
        Unilite.popup('Employee',{
            fieldLabel: '법무담당', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'CONF_DRAFTER',
            textFieldName:'CONF_DRAFTER_NAME',
//            extParam: {
//                'ADD_QUERY': "Y"
//            },  
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER_NAME', newValue);             
                },
                applyextparam: function(popup){
                    popup.setExtParam({'ADD_QUERY': "Y"});                           
                }
            }
        }),                     
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:600,
            items :[{
                xtype: 'uniCombobox',
                fieldLabel: '수금관리항목',
                name:'COLL_MANA',  
                comboType:'AU',
                comboCode:'J505',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('COLL_MANA', newValue);
                    }
                }
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:600,
            items :[{
                xtype: 'radiogroup',                            
                fieldLabel: '잔액기준',
                items: [{
                    boxLabel: '발생', 
                    width: 50,
                    name: 'RADIO_1',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '잔액', 
                    width: 70,
                    name: 'RADIO_1',
                    inputValue: '1' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('RADIO_1').setValue(newValue.RADIO_1);                 
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '장부가액',
                items: [{
                    boxLabel: '발생', 
                    width: 50,
                    name: 'RADIO_2',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '잔액', 
                    width: 70,
                    name: 'RADIO_2',
                    inputValue: '1' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('RADIO_2').setValue(newValue.RADIO_2);                 
                    }
                }
            }]
        }]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Arc210skrGrid', {
        region : 'center',
        excelTitle: '법무채권 건별현황',
		store: directDetailStore,
//        selModel	: 'rowmodel',
		features: [{
    			id: 'detailGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'detailGridTotal',		
    			ftype: 'uniSummary',
    			showSummaryRow: true
    		}
    	],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
//			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        /*viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == 'S'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },*/
        columns:[
            {dataIndex: 'RECE_GUBUN'                      , width: 80,align:'center'},
            {dataIndex: 'RECE_COMP_CODE'                  , width: 100},
            {dataIndex: 'RECE_COMP_NAME'                  , width: 150,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            {dataIndex: 'CONF_RECE_NO'                    , width: 120},
            {dataIndex: 'CUSTOM_NAME'                     , width: 150},
            {dataIndex: 'TOP_NAME'                        , width: 80,align:'center'},
            {dataIndex: 'CONF_DRAFTER_NAME'               , width: 120},
            {dataIndex: 'MNG_GUBUN'                       , width: 100,align:'center'},
            {dataIndex: 'TOT_CARRYOVER_AMT'               , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_RECEIVE_AMT'                 , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_CONVERT_AMT'                 , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_COLLECT_AMT'                 , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_ADJUST_AMT'                  , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_BALANCE_AMT'                 , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_DISPOSAL_AMT'                , width: 120,summaryType: 'sum'},
            {dataIndex: 'TOT_BOOKVALUE_AMT'               , width: 120,summaryType: 'sum'}
        ],
		uniRowContextMenu:{
			items: [{
				text: '법무채권등록 보기',   
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		detailGrid.gotoArc200ukr(param.record);
            	}
        	},{	text: '법무채권원장조회 보기',   
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		detailGrid.gotoArc220skr(param.record);
            	}
        	}]
	    },
        listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	onGridDblClick:function(grid, record, cellIndex, colName) {
                detailGrid.gotoArc200ukr(record);
            }
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
      		return true;
      	},
		gotoArc200ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' 		 : 'arc210skr',
					'CONF_RECE_NO'   : record.data['CONF_RECE_NO'],
					'RECE_COMP_CODE' : record.data['RECE_COMP_CODE'],
					'RECE_COMP_NAME' : record.data['RECE_COMP_NAME'],
					'CONF_RECE_DATE' : record.data['CONF_RECE_DATE'],
					'RECE_AMT'		 : record.data['TOT_RECEIVE_AMT'],
					'RECE_GUBUN' 	 : record.data['RECE_GUBUN'],
					'CUSTOM_CODE' 	 : record.data['CUSTOM_CODE'],
					'CUSTOM_NAME' 	 : record.data['CUSTOM_NAME']
				}
		  		var rec1 = {data : {prgID : 'arc200ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/arc200ukr.do', params);
			}
    	},
		gotoArc220skr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' 		 : 'arc210skr',
					'RECE_COMP_CODE' : record.data['RECE_COMP_CODE'],
					'RECE_COMP_NAME' : record.data['RECE_COMP_NAME'],
					'CONF_RECE_DATE' : record.data['CONF_RECE_DATE'],
					'CUSTOM_CODE' 	 : record.data['CUSTOM_CODE'],
					'CUSTOM_NAME' 	 : record.data['CUSTOM_NAME']
				}
		  		var rec1 = {data : {prgID : 'arc220skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/arc220skr.do', params);
			}
    	}
    });   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'Arc210skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DATE_FR');
		},
		onQueryButtonDown : function()	{		
			if(!panelResult.getInvalidMessage()) return; //필수체크
			directDetailStore.loadStoreRecords();
			
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            detailGrid.reset();
            directDetailStore.clearData();
            this.fnInitBinding();
		}
	});	
};


</script>
