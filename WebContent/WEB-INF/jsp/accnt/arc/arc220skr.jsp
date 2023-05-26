<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc220skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Arc220skrModel', {
        fields:[
            {name: 'MNG_DATE'               , text: '일자'        , type: 'uniDate'},
            {name: 'MNG_GUBUN_NAME'         , text: '구분'        , type: 'string'},
            {name: 'REMARK'                 , text: '내용'        , type: 'string'},
            {name: 'RECEIVE_AMT'        	, text: '접수'        , type: 'uniPrice'},
            {name: 'COLLECT_AMT'            , text: '수금'        , type: 'uniPrice'},
            {name: 'ADJUST_AMT'         	, text: '조정'        , type: 'uniPrice'},
            {name: 'BALANCE_AMT'        	, text: '잔액'        , type: 'uniPrice'}
	   ]
	});	
			
	var directDetailStore = Unilite.createStore('Arc220skrdirectDetailStore',{
		model: 'Arc220skrModel',
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
                read: 'arc220skrService.selectList'                	
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
//                validateBlank: false,
                allowBlank: false,
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
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }),         
            Unilite.popup('CUST',{
                fieldLabel: '거래처', 
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
//                validateBlank: false,
                allowBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_NAME', newValue);              
                    }
                }
            })]
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
//            validateBlank: false,
            allowBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_NAME', newValue);                
                }
            }
        }),     
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:600,
            items :[
            Unilite.popup('CONF_RECE',{
                fieldLabel: '채권번호', 
                valueFieldName:'CONF_RECE_NO',
                textFieldName:'CONF_RECE_CUSTOM_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('CONF_RECE_NO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            })]
        },         
        Unilite.popup('CUST',{
            fieldLabel: '거래처', 
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
//            validateBlank: false,
            allowBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_NAME', newValue);              
                }
            }
        })]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Arc220skrGrid', {
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
            {dataIndex: 'MNG_DATE'               , width: 100},
            {dataIndex: 'MNG_GUBUN_NAME'         , width: 100	,align:'center'},
            {dataIndex: 'REMARK'                 , width: 200},
            {dataIndex: 'RECEIVE_AMT'        	 , width: 100},
            {dataIndex: 'COLLECT_AMT'            , width: 100},
            {dataIndex: 'ADJUST_AMT'         	 , width: 100},
            {dataIndex: 'BALANCE_AMT'        	 , width: 100}
        ],
//		uniRowContextMenu:{
//			items: [
//	            {	text: '법무채권등록 보기',   
//	            	handler: function(menuItem, event) {
//	            		var param = menuItem.up('menu');
//	            		detailGrid.gotoArc200ukr(param.record);
//	            	}
//	        	}
//	        ]
//	    },
        listeners: {
//	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
//	        	view.ownerGrid.setCellPointer(view, item);
//        	}
		}
//		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
//      		return true;
//      	},
//		gotoArc200ukr:function(record)	{
//			if(record)	{
//		    	var params = {
//					action:'select', 
//					'PGM_ID' : 'arc220skr',
//					'CONF_RECE_NO' : record.data['CONF_RECE_NO']
//					
//					//파라미터 추후 추가
//				}
//		  		var rec1 = {data : {prgID : 'arc200ukr', 'text':''}};							
//				parent.openTab(rec1, '/accnt/arc200ukr.do', params);
//			}
//    	}
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
		id : 'Arc220skrApp',
		fnInitBinding : function(params) {
            this.setDefault(params);
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false; //필수체크
			}
			directDetailStore.loadStoreRecords();
			
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            detailGrid.reset();
            directDetailStore.clearData();
            this.fnInitBinding();
        },
        
        setDefault: function(params){
            
            if(!Ext.isEmpty(params.PGM_ID)){
                this.processParams(params);
                
            }else{
                UniAppManager.app.fnInitInputFields();  
            }
        },

        processParams: function(params) {
            detailGrid.reset();
            directDetailStore.clearData();

            this.uniOpt.appParams = params;
            
            if(params.PGM_ID == 'arc210skr') {
                panelSearch.setValue('RECE_COMP_CODE'	,params.RECE_COMP_CODE);
                panelSearch.setValue('RECE_COMP_NAME'	,params.RECE_COMP_NAME);
                panelSearch.setValue('CUSTOM_CODE'		,params.CUSTOM_CODE);
                panelSearch.setValue('CUSTOM_NAME'		,params.CUSTOM_NAME);
                panelSearch.setValue('DATE_FR'			,params.CONF_RECE_DATE);
                panelSearch.setValue('DATE_TO'			,params.CONF_RECE_DATE);
                panelSearch.setValue('RECE_GUBUN'		,params.RECE_GUBUN);
                
                panelResult.setValue('RECE_COMP_CODE'	,params.RECE_COMP_CODE);
                panelResult.setValue('RECE_COMP_NAME'	,params.RECE_COMP_NAME);
                panelResult.setValue('CUSTOM_CODE'		,params.CUSTOM_CODE);
                panelResult.setValue('CUSTOM_NAME'		,params.CUSTOM_NAME);
                panelResult.setValue('DATE_FR'			,params.CONF_RECE_DATE);
                panelResult.setValue('DATE_TO'			,params.CONF_RECE_DATE);
                panelResult.setValue('RECE_GUBUN'		,params.RECE_GUBUN);
            }
            
            directDetailStore.loadStoreRecords();
        },

        fnInitInputFields: function(){
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
        }
	});	
};


</script>
