<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb560skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb560skr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A133" />			<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />			<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};
	var budgNameList = ${budgNameList};
	var amtPointList = ${amtPointList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb510Model1', {
		fields: fields
	});		// End of Ext.define('afb560skrModel', {
	
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb510MasterStore',{
		model: 'Afb510Model1',
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
                read: 'afb560skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var budgGubun = parseInt(param.BUDG_GUBUN1) + parseInt(param.BUDG_GUBUN2);
			param.budgNameInfoList = budgNameList;		//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint
			param.BUDG_GUBUN = budgGubun;				// 예산실적집계
			param.BG_YYYY = UniDate.getDbDateStr(panelSearch.getValue('BG_DATE_FR')).substring(0,4);	// 예산년월
			console.log( param );
			this.load({
				params : param
			});
		},
		group: 'DEPT_NAME'
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
		        	fieldLabel: '예산년월',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'BG_DATE_FR',
					endFieldName: 'BG_DATE_TO',
					allowBlank:false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('BG_DATE_FR',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('BG_DATE_TO',newValue);			    		
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
		        	fieldLabel: '전용년월',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'DV_DATE_FR',
					endFieldName: 'DV_DATE_TO',
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('DV_DATE_FR',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('DV_DATE_TO',newValue);			    		
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
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BG_DATE_FR'))});
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
				        fieldLabel: '전용부서',
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
				        fieldLabel: '전용예산과목',
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
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BG_DATE_FR'))});
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
				}
			]	
		}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		},
		api: {
	 		load: 'afb560skrService.selectDeptBudg'	
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
	        	fieldLabel: '예산년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'BG_DATE_FR',
				endFieldName: 'BG_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('BG_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('BG_DATE_TO',newValue);			    		
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
	        	fieldLabel: '전용년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'DV_DATE_FR',
				endFieldName: 'DV_DATE_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('DV_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('DV_DATE_TO',newValue);			    		
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
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BG_DATE_FR'))});
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
			        fieldLabel: '전용부서',
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
			        fieldLabel: '전용예산과목',
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
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BG_DATE_FR'))});
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
	    ],	
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb510Grid1', {
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
        title: '월별',
		store: MasterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
        columns:columns
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
		id : 'Afb510App',
		fnInitBinding : function(params) {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BG_DATE_FR');
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.setValue('BG_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('BG_DATE_TO', UniDate.get('today'));
			panelResult.setValue('BG_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('BG_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.getForm().load({
				params : param,
				success: function(form, action) {
					MasterStore.loadStoreRecords();
				}
			});
		},
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
	    		panelSearch.setValue('ST_DATE', newValue)
			}
        }
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'DEPT_NAME'				, text: '부서'				, type: 'string'},
			{name: 'BUDG_CODE'				, text: '예산코드'				, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'BUDG_YYYYMM' 			, text: '예산년월'				, type: 'string'},
			{name: 'DIVERT_DIVI'			, text: '구분'				, type: 'string', comboType: 'AU', comboCode: 'A133'},
			{name: 'DIVERT_BUDG_I'			, text: '금액'				, type: 'uniPrice'},
			{name: 'DIVERT_YYYYMM'			, text: '전용월'				, type: 'string'},
			{name: 'DIVERT_BUDG_CODE'		, text: '전용예산코드'			, type: 'string'},
			{name: 'DIVERT_BUDG_NAME'		, text: '전용예산과목'			, type: 'string'},
			{name: 'DIVERT_DEPT_NAME'		, text: '전용부서'				, type: 'string'},
			{name: 'REMARK'					, text: '비고'				, type: 'string'},
			{name: 'TREE_LEVEL'				, text: 'TREE_LEVEL'		, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'DEPT_NAME'					, width: 80,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            }, 	
			{dataIndex: 'BUDG_CODE'					, width: 133}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 86});	
		});
		columns.push({dataIndex: 'BUDG_YYYYMM' 			, width: 66}); 	
		columns.push({dataIndex: 'DIVERT_DIVI'			, width: 66});
		columns.push({dataIndex: 'DIVERT_BUDG_I'		, width: 100, summaryType: 'sum'});
		columns.push({dataIndex: 'DIVERT_YYYYMM'		, width: 66});
		columns.push({dataIndex: 'DIVERT_BUDG_CODE'		, width: 133});
		columns.push({dataIndex: 'DIVERT_BUDG_NAME'		, width: 233});
		columns.push({dataIndex: 'DIVERT_DEPT_NAME'		, width: 100});
		columns.push({dataIndex: 'REMARK'				, width: 100});
		columns.push({dataIndex: 'TREE_LEVEL'			, width: 66, hidden: true});
		return columns;
	}	
};
</script>
