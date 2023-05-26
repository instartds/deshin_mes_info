<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc200skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
	<t:ExtComboStore comboType="AU" comboCode="J503" /> <!-- 접수상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
	<t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Arc200skrModel', {
        fields:[
            {name: 'CONF_RECE_NO'           , text: '이관채권번호'  , type: 'string'},
            {name: 'CONF_RECE_DATE'         , text: '이관일'      , type: 'uniDate'},
		    {name: 'RECE_COMP_CODE'         , text: '회사코드'     , type: 'string'},
            {name: 'RECE_COMP_NAME'         , text: '회사명'      , type: 'string'},  
            {name: 'CUSTOM_CODE'            , text: '거래처'      , type: 'string'},
            {name: 'CUSTOM_NAME'            , text: '거래처명'     , type: 'string'},
            {name: 'TOP_NAME'               , text: '대표자'      , type: 'string'},
            {name: 'MNG_GUBUN'              , text: '구분'       , type: 'string', comboType:'AU', comboCode:'J504'},
		    {name: 'RECE_GUBUN'             , text: '채권구분'     , type: 'string', comboType:'AU', comboCode:'J501'},
		    {name: 'RECE_AMT'               , text: '금액'        , type: 'uniPrice'},
            {name: 'COLLECT_AMT'            , text: '수금액'       , type: 'uniPrice'},
            {name: 'TOT_ADJUST_AMT'         , text: '조정'        , type: 'uniPrice'},
            {name: 'TOT_BALANCE_AMT'        , text: '잔액'        , type: 'uniPrice'},
            {name: 'TOT_DISPOSAL_AMT'       , text: '대손처리'     , type: 'uniPrice'},
            {name: 'TOT_BOOKVALUE_AMT'      , text: '장부가액'     , type: 'uniPrice'},
            {name: 'CONF_DRAFTER_NAME'      , text: '법무담당자'    , type: 'string'}
	   ]
	});	
			
	var directDetailStore = Unilite.createStore('Arc200skrdirectDetailStore',{
		model: 'Arc200skrModel',
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
                read: 'arc200skrService.selectList'                	
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
                fieldLabel: '이관일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CONF_RECE_DATE_FR',
                endFieldName: 'CONF_RECE_DATE_TO',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CONF_RECE_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CONF_RECE_DATE_TO', newValue);                            
                    }
                }
            },
			Unilite.popup('COMP',{
                fieldLabel: '회사정보', 
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
                fieldLabel: '채권구분',
                name:'RECE_GUBUN',  
                comboType:'AU',
                comboCode:'J501',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('RECE_GUBUN', newValue);
                    }
                }
            },{
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
            }]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [
                Unilite.popup('CONF_RECE',{
                fieldLabel: '채권번호', 
                valueFieldName:'CONF_RECE_NO',
                textFieldName:'CONF_RECE_CUSTOM_NAME'
            }),     
			{
                xtype: 'uniCombobox',
                fieldLabel: '구분',
                name:'MNG_GUBUN',   
                comboType:'AU',
                comboCode:'J504'
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
            fieldLabel: '이관일',
            xtype: 'uniDateRangefield',
            startFieldName: 'CONF_RECE_DATE_FR',
            endFieldName: 'CONF_RECE_DATE_TO',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CONF_RECE_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CONF_RECE_DATE_TO', newValue);                            
                }
            }
        },
        Unilite.popup('COMP',{
            fieldLabel: '회사정보', 
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
                fieldLabel: '채권구분',
                name:'RECE_GUBUN',  
                comboType:'AU',
                comboCode:'J501',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('RECE_GUBUN', newValue);
                    }
                }
            }]
        },{
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
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Arc200skrGrid', {
        region : 'center',
        excelTitle: '법무채권내역조회',
		store: directDetailStore,
//        selModel	: 'rowmodel',
		features: [{
    			id: 'detailGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'detailGridTotal',		
    			ftype: 'uniSummary',
    			dock:'bottom',
    			showSummaryRow: false
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
			useRowContext		: true,
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
            {dataIndex: 'CONF_RECE_NO'             , width: 120, hidden:true},
        	{dataIndex: 'CONF_RECE_DATE'           , width: 88},
            {dataIndex: 'RECE_COMP_CODE'           , width: 100},
            {dataIndex: 'RECE_COMP_NAME'           , width: 150},
            {dataIndex: 'CUSTOM_CODE'              , width: 88},
            {dataIndex: 'CUSTOM_NAME'              , width: 150},
            {dataIndex: 'TOP_NAME'                 , width: 88,align:'center'},
            {dataIndex: 'MNG_GUBUN'                , width: 88,align:'center'},
            {dataIndex: 'RECE_GUBUN'               , width: 88,align:'center'},
            {dataIndex: 'RECE_AMT'                 , width: 88},
            {dataIndex: 'COLLECT_AMT'              , width: 88},
            {dataIndex: 'TOT_ADJUST_AMT'           , width: 88},
            {dataIndex: 'TOT_BALANCE_AMT'          , width: 88},
            {dataIndex: 'TOT_DISPOSAL_AMT'         , width: 88},
            {dataIndex: 'TOT_BOOKVALUE_AMT'        , width: 88},
            {dataIndex: 'CONF_DRAFTER_NAME'        , width: 88,align:'center'}
        ],
		uniRowContextMenu:{
			items: [
	            {	text: '법무채권등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		detailGrid.gotoArc200ukr(param.record);
	            	}
	        	}
	        ]
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
					'PGM_ID' : 'arc200skr',
					'CONF_RECE_NO'	 : record.data['CONF_RECE_NO'],
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
		id : 'Arc200skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('CONF_RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('CONF_RECE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('CONF_RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('CONF_RECE_DATE_TO', UniDate.get('today'));
			
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('CONF_RECE_DATE_FR');
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
