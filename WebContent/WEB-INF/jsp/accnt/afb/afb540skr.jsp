<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb540skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb540skr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />			<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};
	var budgNameList = ${budgNameList};
	var chargeGubunList = ${chargeGubunList};
	var amtPointList = ${amtPointList};
	
	Unilite.defineModel('Afb510Model1', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'					, text: '부서명'				, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'					, text: '예산과목'				, type: 'string'},
			{name: 'CODE_LEVEL'					, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'BUDG_I_TOT'					, text: '연간예산(A)'			, type: 'uniPrice'},
			{name: 'BUDG_CONF_I'				, text: '확정예산'				, type: 'uniPrice'},
			{name: 'BUDG_CONV_I'				, text: '전용예산'				, type: 'uniPrice'},
			{name: 'BUDG_ASGN_I'				, text: '배정예산'				, type: 'uniPrice'},
			{name: 'BUDG_SUPP_I'				, text: '추경예산'				, type: 'uniPrice'},
			{name: 'BUDG_IWALL_I'				, text: '이월예산'				, type: 'uniPrice'},
			{name: 'ACT_I_01'					, text: '합계'				, type: 'uniPrice'},
			{name: 'ACT_I_02'					, text: '집행금액'				, type: 'uniPrice'},
			{name: 'ACT_I_02_1'					, text: '집행금액'				, type: 'uniPrice'},
			{name: 'ACT_I_02_2'					, text: '집행금액'				, type: 'uniPrice'},
			{name: 'ACT_I_03'					, text: '집행금액'				, type: 'uniPrice'},
			{name: 'ACT_I_03_1'					, text: '추산잔액'				, type: 'uniPrice'},
			{name: 'ACT_I_03_2'					, text: '집행금액'				, type: 'uniPrice'},
			{name: 'BAL_I'						, text: '&nbsp&nbsp(A-B)'				, type: 'uniPrice'},
			{name: 'NON_PAY_I'					, text: '&nbsp&nbsp미지급액'				, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '수지구분'				, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ]
	});		// End of Ext.define('afb540skrModel', {
	
	  
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
                read: 'afb540skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var budgGubun = parseInt(param.BUDG_GUBUN1) + parseInt(param.BUDG_GUBUN2);
			param.budgNameInfoList = budgNameList;		//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint
			param.BUDG_GUBUN = budgGubun;				// 예산실적집계
			param.AC_YYYY = UniDate.getDbDateStr(panelSearch.getValue('FR_YYYYMM')).substring(0,4);	// 예산년월
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
					startFieldName: 'FR_YYYYMM',
					endFieldName: 'TO_YYYYMM',
					allowBlank:false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_YYYYMM',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_YYYYMM',newValue);			    		
				    	}
				    }
				},
		         Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE_FR',
					    textFieldName:'BUDG_NAME_FR',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_FR', records[0][name]);	
									panelResult.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
									panelResult.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_FR', '');
								panelResult.setValue('BUDG_NAME_FR', '');
								panelSearch.setValue('BUDG_CODE_FR', '');
								panelSearch.setValue('BUDG_NAME_FR', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_YYYYMM'))});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),
		         Unilite.popup('BUDG',{
				        fieldLabel: '~',
					    valueFieldName:'BUDG_CODE_TO',
					    textFieldName:'BUDG_NAME_TO',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_TO', records[0][name]);	
									panelResult.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE_TO'));
									panelResult.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME_TO'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_TO', '');
								panelResult.setValue('BUDG_NAME_TO', '');
								panelSearch.setValue('BUDG_CODE_TO', '');
								panelSearch.setValue('BUDG_NAME_TO', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_YYYYMM'))});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),
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
		         },{
					xtype: 'radiogroup',		            		
					fieldLabel: '집계구분',
					id: 'RDO_SELECT',
					items: [{
						boxLabel: '부서/예산코드', 
						width: 115,
						name: 'RDO',
						inputValue: '1',
						checked: true  
					},{
						boxLabel: '예산코드', 
						width: 70,
						name: 'RDO',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('RDO').setValue(newValue.RDO);	
							UniAppManager.app.setHiddenColumn();
							UniAppManager.app.onQueryButtonDown();
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
		         },
		         Unilite.popup('AC_PROJECT',{
				        fieldLabel: '프로젝트',
					    valueFieldName:'AC_PROJECT_CODE',
					    textFieldName:'AC_PROJECT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('AC_PROJECT_CODE', panelSearch.getValue('AC_PROJECT_CODE'));
									panelResult.setValue('AC_PROJECT_NAME', panelSearch.getValue('AC_PROJECT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('AC_PROJECT_CODE', '');
								panelResult.setValue('AC_PROJECT_CODE', '');
								panelSearch.setValue('AC_PROJECT_NAME', '');
								panelSearch.setValue('AC_PROJECT_NAME', '');
							}
						}
			    }),{
		    		xtype: 'uniCheckboxgroup',	
		    		fieldLabel: '예산실적집계',
		    		items: [{
		    			boxLabel: '본예산',
		    			width: 60,
		    			name: 'BUDG_GUBUN1',
		    			id: 'BUDG_GUBUN_CHECK1',
			        	inputValue: '1',
						uncheckedValue: '0',
						checked: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('BUDG_GUBUN1', newValue);
							}
						}
		    		},{
		    			boxLabel: '이월예산',
		    			width: 130,
		    			name: 'BUDG_GUBUN2',
		    			id: 'BUDG_GUBUN_CHECK2',
			        	inputValue: '2',
						uncheckedValue: '0',
						checked: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('BUDG_GUBUN2', newValue);
							}
						}
		    		}]
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
	 		load: 'afb540skrService.selectDeptBudg'	
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
				startFieldName: 'FR_YYYYMM',
				endFieldName: 'TO_YYYYMM',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_YYYYMM',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_YYYYMM',newValue);			    		
			    	}
			    }
			},
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE_FR',
				    textFieldName:'BUDG_NAME_FR',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_FR', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE_FR'));
								panelSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE_FR', '');
							panelSearch.setValue('BUDG_NAME_FR', '');
							panelResult.setValue('BUDG_CODE_FR', '');
							panelResult.setValue('BUDG_NAME_FR', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_YYYYMM'))});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
		    }),{
				xtype: 'container',
				layout : {type : 'uniTable'},
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
	         Unilite.popup('BUDG',{
			        fieldLabel: '~',
				    valueFieldName:'BUDG_CODE_TO',
				    textFieldName:'BUDG_NAME_TO',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_TO', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_TO', panelResult.getValue('BUDG_CODE_TO'));
								panelSearch.setValue('BUDG_NAME_TO', panelResult.getValue('BUDG_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BUDG_CODE_TO', '');
							panelResult.setValue('BUDG_NAME_TO', '');
							panelSearch.setValue('BUDG_CODE_TO', '');
							panelSearch.setValue('BUDG_NAME_TO', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_YYYYMM'))});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
		    }),{
				xtype: 'radiogroup',		            		
				fieldLabel: '집계구분',
				id: 'RDO_SELECT2',
				items: [{
					boxLabel: '부서/예산코드', 
					width: 115,
					name: 'RDO',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '예산코드', 
					width: 70,
					name: 'RDO',
					inputValue: '2'  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('RDO').setValue(newValue.RDO);	
						UniAppManager.app.setHiddenColumn();				
						UniAppManager.app.onQueryButtonDown();
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
	         },
	         Unilite.popup('AC_PROJECT',{
			        fieldLabel: '프로젝트',
				    valueFieldName:'AC_PROJECT_CODE',
				    textFieldName:'AC_PROJECT_NAME',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('AC_PROJECT_CODE', panelResult.getValue('AC_PROJECT_CODE'));
								panelSearch.setValue('AC_PROJECT_NAME', panelResult.getValue('AC_PROJECT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('AC_PROJECT_CODE', '');
							panelResult.setValue('AC_PROJECT_CODE', '');
							panelSearch.setValue('AC_PROJECT_NAME', '');
							panelSearch.setValue('AC_PROJECT_NAME', '');
						}
					}
		    }),{
	    		xtype: 'uniCheckboxgroup',	
	    		fieldLabel: '예산실적집계',
	    		items: [{
	    			boxLabel: '본예산',
	    			width: 60,
	    			name: 'BUDG_GUBUN1',
		        	inputValue: '1',
					uncheckedValue: '0',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BUDG_GUBUN1', newValue);
						}
					}
	    		},{
	    			boxLabel: '이월예산',
	    			width: 130,
	    			name: 'BUDG_GUBUN2',
		        	inputValue: '2',
					uncheckedValue: '0',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BUDG_GUBUN2', newValue);
						}
					}
	    		}]
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
		store: MasterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: true,
			onLoadSelectFirst 	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true
		},
        columns: [
        	{dataIndex: 'COMP_CODE'							, width: 66, hidden: true},
        	{dataIndex: 'DEPT_CODE'							, width: 66, hidden: true},
        	{dataIndex: 'DEPT_NAME'							, width: 80},
        	{dataIndex: 'BUDG_CODE'							, width: 133, 
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
        	{dataIndex: 'BUDG_NAME'							, width: 200},
        	{dataIndex: 'CODE_LEVEL'						, width: 66, hidden: true},
        	{dataIndex: 'BUDG_I_TOT'						, width: 115,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_I_TOT');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{dataIndex: 'BUDG_CONF_I'						, width: 115,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_CONF_I');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{dataIndex: 'BUDG_CONV_I'						, width: 115,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_CONV_I');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{dataIndex: 'BUDG_ASGN_I'						, width: 115,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_ASGN_I');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{dataIndex: 'BUDG_SUPP_I'						, width: 115,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_SUPP_I');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{dataIndex: 'BUDG_IWALL_I'						, width: 115, hidden: true,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_IWALL_I');
						}
					});			 	
				 	return sumData;
			 	}
	        },
        	{text: '집행금액',
	        	columns:[
	        		{text: '집행액',
						columns:[
				        	{dataIndex: 'ACT_I_01'							, width: 115,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_01');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_02'							, width: 115, hidden: true,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_02');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_02_1'						, width: 115, hidden: true,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_02_1');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_02_2'						, width: 115, hidden: true,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_02_2');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_03'							, width: 115, hidden: true,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_03');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_03_1'						, width: 115,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_03_1');
										}
									});			 	
								 	return sumData;
							 	}
					        },
				        	{dataIndex: 'ACT_I_03_2'						, width: 115,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('ACT_I_03_2');
										}
									});			 	
								 	return sumData;
							 	}
					        }
        				]
	        		}
	        	]
        	},
        	{text: '집행잔액',
	        	columns:[
	        		{text: '(A-B)',
						columns:[
        					{dataIndex: 'BAL_I'								, width: 115,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('BAL_I');
										}
									});			 	
								 	return sumData;
							 	}
					        }
        				]
	        		}
	        	]
        	},
        	{text: '미지급액',
	        	columns:[
	        		{text: '미지급액',
						columns:[
        					{dataIndex: 'NON_PAY_I'							, width: 115,
								summaryType:function(values) {
									var sumData = 0;
								 	Ext.each(values, function(value, index) {
										if(value.get('CODE_LEVEL') == '1') {
											sumData = sumData + value.get('NON_PAY_I');
										}
									});			 	
								 	return sumData;
							 	}
					        }
        				]
	        		}
	        	]
        	},
        	{text: '구분',
	        	columns:[
	        		{text: '수지구분',
						columns:[
	        				{dataIndex: 'BUDG_TYPE'							, width: 80}
	        			]
	        		}
	        	]
	        }
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}/*,
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn();
			}*/
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산집행상세내역조회 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb555(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb555:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb540skr',
					'FR_YYYYMM'			: panelSearch.getValue('FR_YYYYMM'),
					'TO_YYYYMM'			: panelSearch.getValue('TO_YYYYMM'),
					'BUDG_CODE'			: record.data['BUDG_CODE'],
					'BUDG_NAME'			: record.data['BUDG_NAME'],
					'DEPT_CODE'			: record.data['DEPT_CODE'],
					'DEPT_NAME'			: record.data['DEPT_NAME'],
					'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
					'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
					'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
					'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
					'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
		    	}
		  		var rec1 = {data : {prgID : 'afb555skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb555skr.do', params);
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
		id : 'Afb540App',
		fnInitBinding : function(params) {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_YYYYMM');
			if(chargeGubunList[0].ACCDEPT_GUBUN != 'N') {
				if(chargeGubunList[0].CHARGE_GUBUN == '1') {	
					panelSearch.setValue('RDO', '1');
					panelResult.setValue('RDO', '1');
				} else {
					panelSearch.setValue('RDO', '2');
					panelResult.setValue('RDO', '2');
				}
			}/* else {
				panelSearch.setValue('RDO', '2')
				panelResult.setValue('RDO', '2');
			}*/
			//UniAppManager.app.setHiddenColumn();
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('FR_YYYYMM', UniDate.get('startOfYear'));
			panelResult.setValue('FR_YYYYMM', UniDate.get('startOfYear'));
			panelSearch.setValue('TO_YYYYMM', UniDate.get('endOfMonth'));
			panelResult.setValue('TO_YYYYMM', UniDate.get('endOfMonth'));
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
        },
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb510skr') {
				panelSearch.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelSearch.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				panelResult.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelResult.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
				panelResult.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelResult.setValue('RDO',params.RDO);
				panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelResult.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelResult.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				
			}
			MasterStore.loadStoreRecords();
        },
		setHiddenColumn: function() {
			if(Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue == '1' && Ext.getCmp('RDO_SELECT2').getChecked()[0].inputValue == '1') {
				masterGrid.getColumn('DEPT_NAME').setVisible(true);
			} else {
				masterGrid.getColumn('DEPT_NAME').setVisible(false);
			}
		}
	});
};
</script>
