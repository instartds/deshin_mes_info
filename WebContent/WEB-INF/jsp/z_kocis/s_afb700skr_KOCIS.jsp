<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb700skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb700skr_KOCIS" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A395" />			<!-- 지급방법 -->
	<t:ExtComboStore comboType="AU" comboCode="A134" />            <!-- 결재상태 --> 
	<t:ExtComboStore comboType="AU" comboCode="A174" />			<!-- 부서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A170"  /> 		<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A171" /> 		<!-- 문서서식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B111" />			<!-- 거래처분류2 -->
	<t:ExtComboStore comboType="AU" comboCode="B112" />			<!-- 거래처분류3 -->
	
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Afb700skrModel', {
	   fields: [
            
            {name: 'DOC_NO'             , text: '문서번호'              , type: 'string'},
            {name: 'SEQ'                , text: '순번'                , type: 'int'},
            {name: 'STATUS'             , text: '결재상태'                , type: 'string',comboType:'AU', comboCode:'A134'},
            {name: 'AC_GUBUN'           , text: '회계구분'             ,type: 'string',comboType:'AU', comboCode:'A390'},
            {name: 'AC_TYPE'            , text: '원인행위'             ,type: 'string',comboType:'AU', comboCode:'A391'},
            {name: 'PAY_DRAFT_NO'       , text: '지출결의번호'            , type: 'string'},
            {name: 'PAY_DATE'           , text: '지출작성일'             , type: 'uniDate'},
            {name: 'TITLE'              , text: '지출건명(제목)'          , type: 'string'},
            {name: 'TOT_AMT_I'          , text: '지급액(현지화)'          ,type:'uniUnitPrice'},//, type: 'float',decimalPrecision: 2, format:'0,000.00'},
            {name: 'LOC_AMT_I'          , text: '지급액(외화)'          ,type:'uniUnitPrice'},//, type: 'float',decimalPrecision: 2, format:'0,000.00'},
            {name: 'BUDG_CODE'          , text: '예산과목'              , type: 'string'},
            {name: 'BUDG_NAME_1'        , text: '부문'                 ,type: 'string'},
            {name: 'BUDG_NAME_4'        , text: '세부사업'              ,type: 'string'},
            {name: 'BUDG_NAME_6'        , text: '세목'                 ,type: 'string'},
            {name: 'BUDG_GUBUN'         , text: '예산구분'              , type: 'string',comboType:'AU', comboCode:'A170'},
            {name: 'PAY_DIVI'           , text: '지급방법'              , type: 'string',comboType:'AU', comboCode:'A395'},
//            {name: 'PAY_DRAFT_AMT'      , text: '지출결의금액'            , type: 'uniPrice'},
            {name: 'CUSTOM_NAME'        , text: '거래처명'              , type: 'string'},
//            {name: 'AGENT_TYPE'         , text: '거래처분류'             , type: 'string'},
//            {name: 'IN_BANK_NAME'       , text: '입금은행'              , type: 'string'},
//            {name: 'IN_BANKBOOK_NUM'    , text: '입금계좌'              , type: 'string'},
            {name: 'DEPT_CODE'          , text: '기관코드'              , type: 'string'},
            {name: 'DEPT_NAME'          , text: '기관'                , type: 'string'},
            {name: 'PAY_USER_NAME'            , text: '지출결의자'         , type: 'string'}
        ]
	});		
	  
	var directMasterStore = Unilite.createStore('Afb700skrdirectMasterStore',{
		model: 'Afb700skrModel',
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
                read: 's_afb700skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
//		groupField:'PAY_DRAFT_NO',
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
                fieldLabel: '지출작성일',
                xtype: 'uniDateRangefield',
                startFieldName: 'PAY_DATE_FR',
                endFieldName: 'PAY_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank: false,                  
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('PAY_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('PAY_DATE_TO', newValue);                          
                    }
                }
			},{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',  
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
			},{
                fieldLabel: '원인행위',
                name: 'AC_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A391',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AC_TYPE', newValue);
                    }
                }
			},
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE',
                textFieldName:'BUDG_NAME',
                autoPopup:true,
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('PAY_DATE_FR')).substring(0, 4)}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
            {
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{ 
	    		fieldLabel: '지출건명',
			    xtype: 'uniTextfield',
			    name: 'TITLE',
			    width: 325,	
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('TITLE', newValue);
			      	}
	     		}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
//					id:'rdoStatusPS',
				items: [{
					boxLabel: '전체', 
					width: 45,
					name: 'STATUS',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '미상신', 
					width: 60,
					name: 'STATUS',
					inputValue: '0'
				},{
					boxLabel: '결재중', 
					width: 60,
					name: 'STATUS',
					inputValue: '1'
				},{
					boxLabel: '반려', 
					width: 45,
					name: 'STATUS',
					inputValue: '5'
				},{
					boxLabel : '완결', 
					width: 45,
					name: 'STATUS',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('STATUS').setValue(newValue.STATUS);					
//							UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		// padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		items: [{
	    			boxLabel: '반려제외',
	    			width: 130,
	    			name: 'STOP_CHECK',
	    			inputValue: '1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('STOP_CHECK', newValue);
						}
					}
	    		}]
	        }]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//			tableAttrs: { width: '100%'},
//        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'left'/*,width: '100%'*/}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '지출작성일',
            xtype: 'uniDateRangefield',
            startFieldName: 'PAY_DATE_FR',
            endFieldName: 'PAY_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false,                  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('PAY_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('PAY_DATE_TO', newValue);                          
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',  
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },{
            fieldLabel: '원인행위',
            name: 'AC_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'A391',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('AC_TYPE', newValue);
                }
            }
        },{ 
            fieldLabel: '지출건명',
            xtype: 'uniTextfield',
            name: 'TITLE',
            width: 325, 
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('TITLE', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE',
            textFieldName:'BUDG_NAME',
            autoPopup:true,
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('PAY_DATE_FR')).substring(0, 4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        {
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'container',
            layout : {type : 'uniTable', columns: 2},
            colspan:2,
            items:[{
                xtype: 'radiogroup',                            
                fieldLabel: '상태',
                items: [{
                    boxLabel: '전체', 
                    width: 45,
                    name: 'STATUS',
                    checked: true  
                },{
                    boxLabel: '미상신', 
                    width: 60,
                    name: 'STATUS',
                    inputValue: '0'
                },{
                    boxLabel: '결재중', 
                    width: 60,
                    name: 'STATUS',
                    inputValue: '1'
                },{
                    boxLabel: '반려', 
                    width: 45,
                    name: 'STATUS',
                    inputValue: '5'
                },{
                    boxLabel : '완결', 
                    width: 45,
                    name: 'STATUS',
                    inputValue: '9'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('STATUS').setValue(newValue.STATUS);                   
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            },{
                xtype: 'uniCheckboxgroup',  
//                      padding: '-2 0 0 -100',
                fieldLabel: '',
                items: [{
                    boxLabel: '반려제외',
                    width: 130,
                    name: 'STOP_CHECK',
                    inputValue: '1',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('STOP_CHECK', newValue);
                        }
                    }
                }]
            }]
        }]
	});
	
    var masterGrid = Unilite.createGrid('Afb700skrGrid', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true//, enableGroupingMenu:false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
//    		useGroupSummary		: true,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,			
				useStateList: false		
			}
        },
        uniRowContextMenu:{
			items: [{	text: '지출결의등록 보기',   
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb700ukr(param.record);
            	}
        	}]
	    },
//		viewConfig: {
//	        getRowClass: function(record, rowIndex, rowParams, store){
//				if(record.get('TYPE_FLAG') == '1'){
//					return 'x-change-cell_dark';	
//				}
//	        }
//	    },
        columns:[
        	{dataIndex: 'DOC_NO'          ,    width: 100},
            {dataIndex: 'SEQ'             ,    width: 60,hidden:true},  
            {dataIndex: 'STATUS'          ,    width: 100},   
            {dataIndex: 'AC_GUBUN'        ,    width: 100},   
            {dataIndex: 'AC_TYPE'         ,    width: 100},   
            {dataIndex: 'PAY_DRAFT_NO'    ,    width: 100,hidden:true},   
            {dataIndex: 'PAY_DATE'        ,    width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },   
            {dataIndex: 'TITLE'           ,    width: 300},   
            {dataIndex: 'TOT_AMT_I'       ,    width: 130,summaryType:'sum'},   
            {dataIndex: 'LOC_AMT_I'       ,    width: 130,summaryType:'sum'},   
            {dataIndex: 'BUDG_CODE'       ,    width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },   
            {dataIndex: 'BUDG_NAME_1'     ,    width: 150},   
            {dataIndex: 'BUDG_NAME_4'     ,    width: 150},   
            {dataIndex: 'BUDG_NAME_6'     ,    width: 150},   
            {dataIndex: 'BUDG_GUBUN'      ,    width: 100},   
            {dataIndex: 'PAY_DIVI'        ,    width: 100},   
//            {dataIndex: 'PAY_DRAFT_AMT'   ,    width: 100},   
            {dataIndex: 'CUSTOM_NAME'     ,    width: 150},   
//            {dataIndex: 'AGENT_TYPE'      ,    width: 100},   
//            {dataIndex: 'IN_BANK_NAME'    ,    width: 100},   
//            {dataIndex: 'IN_BANKBOOK_NUM' ,    width: 100},   
            {dataIndex: 'DEPT_CODE'       ,    width: 100,hidden:true},   
            {dataIndex: 'DEPT_NAME'       ,    width: 150},   
            {dataIndex: 'PAY_USER_NAME'         ,    width: 100}
        ],
		listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                masterGrid.gotoAfb700ukr(record);
            }
		},
		gotoAfb700ukr:function(record) {
			if(record) {
		    	var params = {
					'PGM_ID' : 's_afb700skr_KOCIS',
					'PAY_DRAFT_NO' : record.data['PAY_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 's_afb700ukr_kocis', 'text':''}};							
				parent.openTab(rec1, '/z_kocis/s_afb700ukr_kocis.do', params);
			}
    	}
    });
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id : 'Afb700skrApp',
		fnInitBinding : function(params) {
	/*		var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_USER_NAME');
			
			this.setDefault(params);
			*/
			
			this.setDefault(params);
            
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()) return false;		
				directMasterStore.loadStoreRecords();
			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		setDefault: function(params){
			UniAppManager.app.fnInitInputFields();
			
			if(!Ext.isEmpty(params.PGM_ID)){
				this.processParams(params);
			}else{
				panelSearch.setValue('PAY_DATE_FR', UniDate.get('startOfMonth'));
				panelSearch.setValue('PAY_DATE_TO', UniDate.get('today'));
				panelResult.setValue('PAY_DATE_FR', UniDate.get('startOfMonth'));
				panelResult.setValue('PAY_DATE_TO', UniDate.get('today'));
			}
              

		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb720skr') {
				panelSearch.setValue('PAY_DATE_FR',params.PAY_DATE_FR);
				panelSearch.setValue('PAY_DATE_TO',params.PAY_DATE_TO);
				panelResult.setValue('PAY_DATE_FR',params.PAY_DATE_FR);
				panelResult.setValue('PAY_DATE_TO',params.PAY_DATE_TO);
				
				panelSearch.setValue('TRANS_DATE_FR',params.TRANS_DATE_FR);
				panelSearch.setValue('TRANS_DATE_TO',params.TRANS_DATE_TO);
				
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				
				panelSearch.setValue('BIZ_GUBUN',params.BIZ_GUBUN);
				
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				
				if(params.CHECK_FLAG == '9'){
					panelSearch.getField('STATUS').setValue('9');
					panelResult.getField('STATUS').setValue('9');
				}else{
					panelSearch.getField('STATUS').setValue('');
					panelResult.getField('STATUS').setValue('');
				}
				
				this.onQueryButtonDown();
			}
		},
        fnInitInputFields: function(){
/*            var activeSForm;
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DRAFT_DATE_FR');
            var param= Ext.getCmp('searchForm').getValues();
            panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('DRAFT_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('DRAFT_DATE_TO', UniDate.get('today'));
            panelResult.setValue('DRAFT_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DRAFT_DATE_TO', UniDate.get('today'));
            Ext.getCmp('DATA_CHECK').setDisabled(true);
            Ext.getCmp('DATA_CHECK2').setDisabled(true);
            */
            
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
        }
	});
};


</script>
