<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb600skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb600skr_KOCIS" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A156" />			<!-- 부가세생성경로 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A170" />            <!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
	
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
//	var budgNameList = ${budgNameList};
//	var fields	= createModelField(budgNameList);
//	var columns	= createGridColumn(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb600skrService_KOCIS.selectList',
			update: 's_afb600skrService_KOCIS.updateDetail',
			create: 's_afb600skrService_KOCIS.insertDetail',
			destroy: 's_afb600skrService_KOCIS.deleteDetail',
			syncAll: 's_afb600skrService_KOCIS.saveAll'
		}
	});
	
	Unilite.defineModel('Afb600Model', {
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'          , type: 'string'},
            {name: 'DRAFT_SEQ'          , text: '순번'            , type: 'int'},
            {name: 'CHOICE_FLAG'        , text: '선택FLAG'        , type: 'string'},
            {name: 'DRAFT_NO'           , text: '기안번호'          , type: 'string'},
            {name: 'DRAFT_DATE'         , text: '기안일'           , type: 'uniDate'},
            {name: 'TITLE'              , text: '기안제목'          , type: 'string'},
            {name: 'AC_GUBUN'           , text: '회계구분'             ,type: 'string',comboType:'AU', comboCode:'A390'},
            {name: 'AC_TYPE'            , text: '원인행위'             ,type: 'string',comboType:'AU', comboCode:'A391'},
            {name: 'BUDG_CODE'          , text: '예산과목'          , type: 'string'},
            {name: 'BUDG_NAME_1'        , text: '부문'                 ,type: 'string'},
            {name: 'BUDG_NAME_4'        , text: '세부사업'              ,type: 'string'},
            {name: 'BUDG_NAME_6'        , text: '세목'                 ,type: 'string'},
            {name: 'BUDG_GUBUN'         , text: '예산구분'          , type: 'string',comboType:'AU', comboCode:'A170'},
            {name: 'BUDG_AMT'           , text: '기안예산금액'        , type: 'uniPrice'},
            {name: 'PAY_DRAFT_AMT'      , text: '지출결의금액'        , type: 'uniPrice'},
            {name: 'DRAFT_REMIND_AMT'   , text: '기안잔액'          , type: 'uniPrice'},
            {name: 'DRAFTER'            , text: '기안자'           , type: 'string'},
            {name: 'DEPT_CODE'          , text: '기관코드'      , type: 'string'},
            {name: 'DEPT_NAME'          , text: '기관'        , type: 'string'},
            {name: 'STATUS'             , text: '결재상태'            , type: 'string'},
            {name: 'CLOSE_YN'           , text: '마감여부'            , type: 'string'}
            
        ]
	});		// End of Ext.define('afb600skrModel', {
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb600MasterStore',{
		model: 'Afb600Model',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
//			param.budgNameInfoList = budgNameList;	//예산목록	
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
                        UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
                fieldLabel: '기안일',
                xtype: 'uniDateRangefield',
                startFieldName: 'DRAFT_DATE_FR',
                endFieldName: 'DRAFT_DATE_TO',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DRAFT_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DRAFT_DATE_TO', newValue);
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
            Unilite.popup('Employee', {
                fieldLabel: '기안자',
                valueFieldName: 'DRAFTER',
                textFieldName: 'DRAFT_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('DRAFTER', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('DRAFT_NAME', newValue);                
                    }
                }
            }),
            Unilite.popup('BUDG_KOCIS', {
                fieldLabel: '예산과목', 
                valueFieldName: 'BUDG_CODE',
                textFieldName: 'BUDG_NAME', 
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("DRAFT_DATE_FR")).substring(0,4)});
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
					xtype: 'radiogroup',		            		
					fieldLabel: '마감여부',
					id: 'CLOSE_YN_RDO',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'CLOSE_YN',
						checked: true  
					},{
						boxLabel: '아니오', 
						width: 60,
						name: 'CLOSE_YN',
						inputValue: 'N'
					},{
						boxLabel : '예', 
						width: 45,
						name: 'CLOSE_YN',
						inputValue: 'Y'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('CLOSE_YN').setValue(newValue.CLOSE_YN);
							if(Ext.getCmp('CLOSE_YN_RDO').getChecked()[0].inputValue == 'N') {
								Ext.getCmp('DATA_CHECK').setDisabled(false);
								Ext.getCmp('DATA_CHECK2').setDisabled(false);
								Ext.getCmp('DATA_CHECK').setText('기안마감');
								Ext.getCmp('DATA_CHECK2').setText('기안마감');
							} else if(Ext.getCmp('CLOSE_YN_RDO').getChecked()[0].inputValue == 'Y') {
								Ext.getCmp('DATA_CHECK').setDisabled(false);
								Ext.getCmp('DATA_CHECK2').setDisabled(false);
								Ext.getCmp('DATA_CHECK').setText('마감취소');
								Ext.getCmp('DATA_CHECK2').setText('마감취소');
							} else {
								Ext.getCmp('DATA_CHECK').setText('기안마감');
								Ext.getCmp('DATA_CHECK2').setText('기안마감');
								Ext.getCmp('DATA_CHECK').setDisabled(true);
								Ext.getCmp('DATA_CHECK2').setDisabled(true);
							}
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
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
							panelResult.getField('STATUS').setValue(newValue.STATUS);					
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		//padding: '0 0 0 0',
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
		        }
			]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [
				
					/*{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        //value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('DEPT',{ 
		    	fieldLabel: '예산부서', 
		    	valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME'
			}),
			Unilite.popup('PJT',{ 
		    	fieldLabel: '프로젝트', 
		    	valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME'
			}),*/{ 
	    		fieldLabel: '예산기안번호',
			    xtype: 'uniTextfield',
			    name: 'DRAFT_NO'
			},{
	    		xtype: 'button',
	    		text: '기안마감',	
	    		margin: '0 0 0 100',
	    		id: 'DATA_CHECK',
	    		name: 'EXECUTE_TYPE',
		    	//inputValue: '1',
	    		width: 90,	
				handler : function() {
					Ext.getBody().mask('로딩중...','loading-indicator');
					MasterStore.saveStore();
					Ext.getBody().unmask();
				}
	    	}]
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '기안일',
            xtype: 'uniDateRangefield',
            startFieldName: 'DRAFT_DATE_FR',
            endFieldName: 'DRAFT_DATE_TO',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('DRAFT_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('DRAFT_DATE_TO', newValue);
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
        },
		Unilite.popup('Employee', {
            fieldLabel: '기안자',
            valueFieldName: 'DRAFTER',
            textFieldName: 'DRAFT_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('DRAFTER', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('DRAFT_NAME', newValue);                
                }
            }
        }),
		Unilite.popup('BUDG_KOCIS', {
            fieldLabel: '예산과목', 
            valueFieldName: 'BUDG_CODE',
            textFieldName: 'BUDG_NAME', 
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue("DRAFT_DATE_FR")).substring(0,4)});
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
			xtype: 'radiogroup',		            		
			fieldLabel: '마감여부',
			id: 'CLOSE_YN_RDO2',
			items: [{
				boxLabel: '전체', 
				width: 45,
				name: 'CLOSE_YN',
				checked: true  
			},{
				boxLabel: '아니오', 
				width: 60,
				name: 'CLOSE_YN',
				inputValue: 'N'
			},{
				boxLabel : '예', 
				width: 45,
				name: 'CLOSE_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('CLOSE_YN').setValue(newValue.CLOSE_YN);
					if(Ext.getCmp('CLOSE_YN_RDO2').getChecked()[0].inputValue == 'N') {
							Ext.getCmp('DATA_CHECK').setDisabled(false);
							Ext.getCmp('DATA_CHECK2').setDisabled(false);
							Ext.getCmp('DATA_CHECK').setText('기안마감');
							Ext.getCmp('DATA_CHECK2').setText('기안마감');
					} else if(Ext.getCmp('CLOSE_YN_RDO2').getChecked()[0].inputValue == 'Y') {
						Ext.getCmp('DATA_CHECK').setDisabled(false);
						Ext.getCmp('DATA_CHECK2').setDisabled(false);
						Ext.getCmp('DATA_CHECK').setText('마감취소');
						Ext.getCmp('DATA_CHECK2').setText('마감취소');
					} else {
						Ext.getCmp('DATA_CHECK').setText('기안마감');
						Ext.getCmp('DATA_CHECK2').setText('기안마감');
						Ext.getCmp('DATA_CHECK').setDisabled(true);
						Ext.getCmp('DATA_CHECK2').setDisabled(true);
					}
				}
			}
		},{
			xtype: 'container',
			layout : {type : 'uniTable', columns: 3},
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
//			    		padding: '-2 0 0 -100',
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
	        },{
                xtype: 'button',
                text: '기안마감',   
                id: 'DATA_CHECK2',
                name: 'EXECUTE_TYPE',
                //inputValue: '1',
                width: 90,  
                handler : function() {
                    Ext.getBody().mask('로딩중...','loading-indicator');
                    MasterStore.saveStore();
                    Ext.getBody().unmask();
                }
            }]
		}]
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb600Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true,
                dock:'bottom'
    		}
    	],
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false}),
    	layout : 'fit',
        region : 'center',
		store: MasterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false
		},
        columns:[  
            {dataIndex: 'COMP_CODE'                         , width: 100,hidden:true},
            {dataIndex: 'DRAFT_SEQ'                         , width: 60},  
            {dataIndex: 'CHOICE_FLAG'                       , width: 100,hidden:true},  
            {dataIndex: 'DRAFT_NO'                          , width: 120},  
            {dataIndex: 'DRAFT_DATE'                        , width: 80,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },  
            {dataIndex: 'TITLE'                             , width: 250},  
            {dataIndex: 'AC_GUBUN'                          , width: 100},  
            {dataIndex: 'AC_TYPE'                           , width: 100},  
            {dataIndex: 'BUDG_CODE'                         , width: 150},  
            {dataIndex: 'BUDG_NAME_1'                       , width: 150},  
            {dataIndex: 'BUDG_NAME_4'                       , width: 150},  
            {dataIndex: 'BUDG_NAME_6'                       , width: 150},  
            {dataIndex: 'BUDG_GUBUN'                        , width: 100},  
            {dataIndex: 'BUDG_AMT'                          , width: 100,summaryType:'sum'},  
            {dataIndex: 'PAY_DRAFT_AMT'                     , width: 100,summaryType:'sum'},  
            {dataIndex: 'DRAFT_REMIND_AMT'                  , width: 100,summaryType:'sum'},  
            {dataIndex: 'DRAFTER'                           , width: 100},  
            {dataIndex: 'DEPT_CODE'                         , width: 100,hidden:true},  
            {dataIndex: 'DEPT_NAME'                         , width: 100},  
            {dataIndex: 'STATUS'                            , width: 100},
            {dataIndex: 'CLOSE_YN'                            , width: 100,hidden:true}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	select: function(grid, selectRecord, index, rowIndex, eOpts) {
    			selectRecord.set('CHOICE_FLAG', 'Y');
				UniAppManager.setToolbarButtons('save',false);
			},
    		deselect:  function(grid, selectRecord, index, eOpts ) {
    			selectRecord.set('CHOICE_FLAG', '');
				UniAppManager.setToolbarButtons('save',false);
    		}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산기안(추산)등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb600(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					//action:'select',
					'PGM_ID'			: 's_afb600skr_KOCIS',
					'DRAFT_NO' 			: record.data['DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb600ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb600ukr.do', params);
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
		id : 'Afb600App',
		fnInitBinding : function() {
			
			UniAppManager.app.fnInitInputFields();   
		/*	var activeSForm;
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
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
*/		},
		onQueryButtonDown : function()	{		
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			MasterStore.loadStoreRecords();
		},
		fnInitInputFields: function(){
			var activeSForm;
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
	
/*	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'ORDER_SEQ'			, text: '순번'			, type: 'int'},
			{name: 'CHOICE'				, text: '선택'			, type: 'string'},
			{name: 'CHOICE_FLAG'		, text: '선택FLAG'		, type: 'string'},
			{name: 'STATUS'				, text: '상태'			, type: 'string'},
			{name: 'DRAFT_NO'			, text: '기안번호'			, type: 'string'},
			{name: 'SEQ'				, text: '순번'			, type: 'int'},
			{name: 'DRAFT_DATE'			, text: '기안일'			, type: 'uniDate'},
			{name: 'TITLE'				, text: '기안제목'			, type: 'string'},
			{name: 'TOTAL_AMT_I'		, text: '총금액'			, type: 'uniPrice'},
			{name: 'BUDG_CODE'			, text: '예산과목'			, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'PJT_CODE'			, text: '프로젝트코드'		, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트명'		, type: 'string'},
			{name: 'BUDG_GUBUN'			, text: '예산구분'			, type: 'string'},
			{name: 'BUDG_AMT'			, text: '기안예산금액'		, type: 'uniPrice'},
			{name: 'EXPEN_REQ_AMT'		, text: '지출요청금액'		, type: 'uniPrice'},
			{name: 'PAY_DRAFT_AMT'		, text: '지출결의금액'		, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'	, text: '기안잔액'			, type: 'uniPrice'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'},
			{name: 'CLOSE_YN'			, text: '마감여부'			, type: 'string'},
			{name: 'CLOSE_YN_NM'		, text: '마감여부'			, type: 'string'},
			{name: 'CONFIRM_YN_NM'		, text: '확정여부'			, type: 'string'},
			{name: 'AGREE_YN_NM'		, text: '완결여부'			, type: 'string'},
			{name: 'CLOSE_DATE'			, text: '기안마감일'		, type: 'uniDate'},
			{name: 'DRAFTER'			, text: '기안자'			, type: 'string'},
			{name: 'PAY_USER'			, text: '사용자'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'},
			{name: 'DIV_NAME'			, text: '사업장'			, type: 'string'},
			{name: 'GWIF_ID'			, text: '그룹웨어연동번호'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
//        	{dataIndex: 'COMP_CODE'					, width: 50, hidden: true}, 	
			{dataIndex: 'ORDER_SEQ'					, width: 50,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            }, 	
//			{dataIndex: 'CHOICE'					, width: 40, hidden: true}, 	
//  			{dataIndex: 'CHOICE_FLAG'				, width: 40, hidden: true},
			{dataIndex: 'STATUS'					, width: 66}, 	
			{dataIndex: 'DRAFT_NO'					, width: 100}, 	
//			{dataIndex: 'SEQ'						, width: 50, hidden: true}, 	
			{dataIndex: 'DRAFT_DATE'				, width: 80}, 	
			{dataIndex: 'TITLE'						, width: 200}, 	
//			{dataIndex: 'TOTAL_AMT_I'				, width: 100, hidden: true}, 	
			{dataIndex: 'BUDG_CODE'					, width: 133} 	
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
//		columns.push({dataIndex: 'PJT_CODE'					, width: 85, hidden: true}); 	
		columns.push({dataIndex: 'PJT_NAME'					, width: 133}); 	
		columns.push({dataIndex: 'BUDG_GUBUN'				, width: 66}); 	
		columns.push({dataIndex: 'BUDG_AMT'					, width: 100, summaryType: 'sum'}); 	
//		columns.push({dataIndex: 'EXPEN_REQ_AMT'			, width: 100, hidden: true}); 	
		columns.push({dataIndex: 'PAY_DRAFT_AMT'			, width: 100, summaryType: 'sum'});	
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'			, width: 100, summaryType: 'sum'}); 	
		columns.push({dataIndex: 'REMARK'					, width: 200}); 	
//		columns.push({dataIndex: 'CLOSE_YN'					, width: 66, hidden: true}); 	
		columns.push({dataIndex: 'CLOSE_YN_NM'				, width: 66}); 	
		columns.push({dataIndex: 'CONFIRM_YN_NM'			, width: 66}); 	
		columns.push({dataIndex: 'AGREE_YN_NM'				, width: 66}); 	
		columns.push({dataIndex: 'CLOSE_DATE'				, width: 80}); 	
		columns.push({dataIndex: 'DRAFTER'					, width: 80}); 	
		columns.push({dataIndex: 'PAY_USER'					, width: 80}); 	
//		columns.push({dataIndex: 'DEPT_CODE'				, width: 100, hidden: true}); 	
		columns.push({dataIndex: 'DEPT_NAME'				, width: 100}); 	
//		columns.push({dataIndex: 'DIV_CODE'					, width: 100, hidden: true}); 	
		columns.push({dataIndex: 'DIV_NAME'					, width: 100}); 	
		columns.push({dataIndex: 'GWIF_ID'					, width: 120});
		return columns;
	}	*/
};
</script>
