<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb560skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb560skr_KOCIS" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003" /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A133" />			<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />			<!-- 금액단위 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb560Model1', {
        fields: [
            {name: 'AP_STS'                 , text: '결재상태'          , type: 'string',comboType:'AU', comboCode:'A134'},
            {name: 'DEPT_CODE'              , text: '문화원코드'          , type: 'string'},
            {name: 'DEPT_NAME'              , text: '문화원'          , type: 'string'},
            {name: 'B'                      , text: '문서번호'         , type: 'string'},
//            {name: 'BUDG_CODE'              , text: '예산과목'          , type: 'string'},
            {name: 'BUDG_NAME_1'            , text: '부문'            , type: 'string'},
            {name: 'BUDG_NAME_4'            , text: '단위사업'         , type: 'string'},
            {name: 'BUDG_NAME_6'            , text: '세목'            , type: 'string'},
            {name: 'BUDG_YYYYMM'            , text: '예산년월'         , type: 'string'},
            {name: 'DIVERT_BUDG_I'          , text: '금액'            , type: 'uniUnitPrice'},
            {name: 'DIVERT_YYYYMM'          , text: '조정월'           , type: 'string'},
            {name: 'DIVERT_BUDG_CODE'       , text: '조정예산과목'       , type: 'string'},
            {name: 'DIVERT_BUDG_NAME'       , text: '조정예산과목'       , type: 'string'},
            {name: 'BUDG_CODE'              , text: '세목조정할 예산과목'   , type: 'string'},
            {name: 'REMARK'                 , text: '비고'             , type: 'string'}
            
        ]
    }); 
	  
	/* Store 정의(Service 정의) @type
	 */					
	var masterStore = Unilite.createStore('Afb560masterStore',{
		model: 'Afb560Model1',
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
                read: 's_afb560skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
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
                fieldLabel: '조정년월',
                xtype: 'uniMonthRangefield',  
                startFieldName: 'DIVERT_YYYYMM_FR',
                endFieldName: 'DIVERT_YYYYMM_TO',
                width: 315,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DIVERT_YYYYMM_FR',newValue);            
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DIVERT_YYYYMM_TO',newValue);                        
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',  
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },
			Unilite.popup('BUDG_KOCIS_NORMAL', {
                fieldLabel: '예산과목', 
                valueFieldName: 'BUDG_CODE',
                textFieldName: 'BUDG_NAME', 
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("DIVERT_YYYYMM_FR")).substring(0,4)}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
			Unilite.popup('BUDG_KOCIS_NORMAL', {
                fieldLabel: '조정예산과목', 
                valueFieldName: 'DIVERT_BUDG_CODE',
                textFieldName: 'DIVERT_BUDG_NAME', 
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('DIVERT_BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('DIVERT_BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("DIVERT_YYYYMM_FR")).substring(0,4)}),
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
            }		
																				
																					
																						
																							
             /*   { 
		        	fieldLabel: '예산년월',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'BUDG_YYYYMM_FR',
					endFieldName: 'BUDG_YYYYMM_TO',
					allowBlank:false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('BUDG_YYYYMM_FR',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('BUDG_YYYYMM_TO',newValue);			    		
				    	}
				    }
				},
		        Unilite.popup('DEPT',{
				        fieldLabel: '부서',
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
									panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
								panelSearch.setValue('DEPT_NAME', '');
							}
						}
			    }),{
		    		xtype: 'uniCheckboxgroup',	
		    		//padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'LOWER_DEPT_CHECK',
		    		items: [{
		    			boxLabel: '하위부서포함',
		    			width: 130,
		    			name: 'LOWER_DEPT',
			        	inputValue: 'Y',
						uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('LOWER_DEPT', newValue);
							}
						}
		    		}]
		        },{ 
		        	fieldLabel: '조정년월',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'DIVERT_YYYYMM_FR',
					endFieldName: 'DIVERT_YYYYMM_TO',
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('DIVERT_YYYYMM_FR',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('DIVERT_YYYYMM_TO',newValue);			    		
				    	}
				    }
				},
				Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE',
					    textFieldName:'BUDG_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME', records[0][name]);	
									panelResult.setValue('BUDG_CODE', panelSearch.getValue('BUDG_CODE'));
									panelResult.setValue('BUDG_NAME', panelSearch.getValue('BUDG_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE', '');
								panelResult.setValue('BUDG_NAME', '');
								panelSearch.setValue('BUDG_CODE', '');
								panelSearch.setValue('BUDG_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM_FR'))});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'BUDG_TYPE',
		            comboType:'AU',
					comboCode:'A132',
	            	value: '2',
		            fieldLabel: '수지구분',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_TYPE', newValue);
						}
					}
		        },
		        Unilite.popup('DEPT',{
				        fieldLabel: '조정부서',
					    valueFieldName:'DV_DEPT_CODE',
					    textFieldName:'DV_DEPT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DV_DEPT_CODE', panelSearch.getValue('DV_DEPT_CODE'));
									panelResult.setValue('DV_DEPT_NAME', panelSearch.getValue('DV_DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DV_DEPT_CODE', '');
								panelResult.setValue('DV_DEPT_CODE', '');
								panelSearch.setValue('DV_DEPT_NAME', '');
								panelSearch.setValue('DV_DEPT_NAME', '');
							}
						}
			    }),
				Unilite.popup('BUDG',{
				        fieldLabel: '조정예산과목',
					    valueFieldName:'DV_BUDG_CODE',
					    textFieldName:'DV_BUDG_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('DV_BUDG_NAME', records[0][name]);	
									panelResult.setValue('DV_BUDG_CODE', panelSearch.getValue('DV_BUDG_CODE'));
									panelResult.setValue('DV_BUDG_NAME', panelSearch.getValue('DV_BUDG_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DV_BUDG_CODE', '');
								panelResult.setValue('DV_BUDG_NAME', '');
								panelSearch.setValue('DV_BUDG_CODE', '');
								panelSearch.setValue('DV_BUDG_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM_FR'))});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'BUGUN',
		            comboType:'AU',
					comboCode:'A133',
		            fieldLabel: '구분',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUGUN', newValue);
						}
					}
		        },{
		            xtype: 'uniCombobox',
		            name: 'MONEY_UNIT',
		            comboType:'AU',
					comboCode:'B042',
					value: '1',
		            fieldLabel: '금액단위',
		            allowBlank:false,
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('MONEY_UNIT', newValue);
						}
					}
		         },{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'DEPT_CODE',
	    			name:'DEPT_CODE2',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'CHARGE_GUBUN',
	    			name:'CHARGE_GUBUN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'ACCDEPT_GUBUN',
	    			name:'ACCDEPT_GUBUN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'ACCDEPT_USEYN',
	    			name:'ACCDEPT_USEYN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'REF_CODE1',
	    			name:'REF_CODE1',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'AMT_POINT',
	    			name:'AMT_POINT',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				}*/
			]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
            fieldLabel: '조정년월',
            xtype: 'uniMonthRangefield',  
            startFieldName: 'DIVERT_YYYYMM_FR',
            endFieldName: 'DIVERT_YYYYMM_TO',
            width: 315,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('DIVERT_YYYYMM_FR',newValue);            
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('DIVERT_YYYYMM_TO',newValue);                        
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',  
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL', {
            fieldLabel: '예산과목', 
            valueFieldName: 'BUDG_CODE',
            textFieldName: 'BUDG_NAME', 
            autoPopup:true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("DIVERT_YYYYMM_FR")).substring(0,4)}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        Unilite.popup('BUDG_KOCIS_NORMAL', {
            fieldLabel: '조정예산과목', 
            valueFieldName: 'DIVERT_BUDG_CODE',
            textFieldName: 'DIVERT_BUDG_NAME', 
            autoPopup:true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('DIVERT_BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('DIVERT_BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue("DIVERT_YYYYMM_FR")).substring(0,4)}),
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
        }     
			
				
					
						
							
								
									
										
											
												
													
														
															
		/*														
            { 
	        	fieldLabel: '예산년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'BUDG_YYYYMM_FR',
				endFieldName: 'BUDG_YYYYMM_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('BUDG_YYYYMM_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('BUDG_YYYYMM_TO',newValue);			    		
			    	}
			    }
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				colspan: 2,
				items:[
			         Unilite.popup('DEPT',{
					        fieldLabel: '부서',
						    valueFieldName:'DEPT_CODE',
						    textFieldName:'DEPT_NAME',
					        //validateBlank:false,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
										panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
									},
									scope: this
								},
								onClear: function(type)	{
									panelSearch.setValue('DEPT_CODE', '');
									panelSearch.setValue('DEPT_CODE', '');
									panelResult.setValue('DEPT_NAME', '');
									panelResult.setValue('DEPT_NAME', '');
								}
							}
				    }),{
			    		xtype: 'uniCheckboxgroup',	
	//			    		padding: '-2 0 0 -100',
			    		fieldLabel: '',
		    			id: 'LOWER_DEPT_CHECK2',
			    		items: [{
			    			boxLabel: '하위부서포함',
			    			width: 130,
			    			name: 'LOWER_DEPT',
				        	inputValue: 'Y',
							uncheckedValue: 'N',
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {						
									panelSearch.setValue('LOWER_DEPT', newValue);
								}
							}
			    		}]
			        }
			]},{ 
	        	fieldLabel: '조정년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'DIVERT_YYYYMM_FR',
				endFieldName: 'DIVERT_YYYYMM_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('DIVERT_YYYYMM_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('DIVERT_YYYYMM_TO',newValue);			    		
			    	}
			    }
			},
			Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE',
				    textFieldName:'BUDG_NAME',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME', records[0][name]);	
								panelSearch.setValue('BUDG_CODE', panelResult.getValue('BUDG_CODE'));
								panelSearch.setValue('BUDG_NAME', panelResult.getValue('BUDG_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BUDG_CODE', '');
							panelResult.setValue('BUDG_NAME', '');
							panelSearch.setValue('BUDG_CODE', '');
							panelSearch.setValue('BUDG_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM_FR'))});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'BUDG_TYPE',
	            comboType:'AU',
				comboCode:'A132',
            	value: '2',
	            fieldLabel: '수지구분',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_TYPE', newValue);
					}
				}
	        },
	        Unilite.popup('DEPT',{
			        fieldLabel: '조정부서',
				    valueFieldName:'DV_DEPT_CODE',
				    textFieldName:'DV_DEPT_NAME',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DV_DEPT_CODE', panelResult.getValue('DV_DEPT_CODE'));
								panelSearch.setValue('DV_DEPT_NAME', panelResult.getValue('DV_DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DV_DEPT_CODE', '');
							panelResult.setValue('DV_DEPT_CODE', '');
							panelSearch.setValue('DV_DEPT_NAME', '');
							panelSearch.setValue('DV_DEPT_NAME', '');
						}
					}
		    }),
			Unilite.popup('BUDG',{
			        fieldLabel: '조정예산과목',
				    valueFieldName:'DV_BUDG_CODE',
				    textFieldName:'DV_BUDG_NAME',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('DV_BUDG_NAME', records[0][name]);	
								panelSearch.setValue('DV_BUDG_CODE', panelResult.getValue('DV_BUDG_CODE'));
								panelSearch.setValue('DV_BUDG_NAME', panelResult.getValue('DV_BUDG_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DV_BUDG_CODE', '');
							panelResult.setValue('DV_BUDG_NAME', '');
							panelSearch.setValue('DV_BUDG_CODE', '');
							panelSearch.setValue('DV_BUDG_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM_FR'))});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'BUGUN',
	            comboType:'AU',
				comboCode:'A133',
	            fieldLabel: '구분',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUGUN', newValue);
					}
				}
	        },{
	            xtype: 'uniCombobox',
	            name: 'MONEY_UNIT',
	            comboType:'AU',
				comboCode:'B042',
				value: '1',
	            fieldLabel: '금액단위',
	            allowBlank:false,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MONEY_UNIT', newValue);
					}
				}
	        }
	        */
	        
	        
	    ]
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb560Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: false,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
		selModel:'rowmodel',
        columns:[
            {dataIndex: 'AP_STS'           , width: 100},
            {dataIndex: 'DEPT_CODE'           , width: 100,hidden:true},
            {dataIndex: 'DEPT_NAME'           , width: 100,
            summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },  
            {dataIndex: 'B'                   , width: 100},         
//            {dataIndex: 'BUDG_CODE'           , width: 200},         
            {dataIndex: 'BUDG_NAME_1'         , width: 150},         
            {dataIndex: 'BUDG_NAME_4'         , width: 150},         
            {dataIndex: 'BUDG_NAME_6'         , width: 150},         
            {dataIndex: 'BUDG_YYYYMM'         , width: 80, align:'center',
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 4) + '.' + val.substring(4, 6));
                }
            },         
            {dataIndex: 'DIVERT_BUDG_I'       , width: 100,summaryType:'sum'},         
            {dataIndex: 'DIVERT_YYYYMM'       , width: 80, align:'center',
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 4) + '.' + val.substring(4, 6));
                }
            },         
            {dataIndex: 'DIVERT_BUDG_CODE'    , width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },         
            {dataIndex: 'DIVERT_BUDG_NAME'    , width: 150},         
            {dataIndex: 'BUDG_CODE'           , width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },         
            {dataIndex: 'REMARK'              , width: 250}
        ]
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
		id : 'Afb560App',
		fnInitBinding : function(params) {
		/*	var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDG_YYYYMM_FR');
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.setValue('BUDG_YYYYMM_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('BUDG_YYYYMM_TO', UniDate.get('today'));
			panelResult.setValue('BUDG_YYYYMM_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('BUDG_YYYYMM_TO', UniDate.get('today'));
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}*/
			
			UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown : function()	{		
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            masterStore.loadStoreRecords();
		},
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DIVERT_YYYYMM_FR');
            
            panelSearch.setValue('DIVERT_YYYYMM_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('DIVERT_YYYYMM_TO', UniDate.get('today'));
            panelResult.setValue('DIVERT_YYYYMM_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DIVERT_YYYYMM_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
            
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
