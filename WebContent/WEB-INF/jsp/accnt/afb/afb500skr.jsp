<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb500skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb500skr" /> 	<!-- 사업장 --> 
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
	
	Unilite.defineModel('Afb600Model', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'					, text: '부서명'				, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'					, text: '예산과목'				, type: 'string'},
			{name: 'CODE_LEVEL'					, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'BUDG_I_TOT'					, text: '연간예산'				, type: 'uniPrice'},
			{name: 'BUDG_I'						, text: '편성예산'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I'				, text: '확정예산'				, type: 'uniPrice'},
			{name: 'LAST_CONF_I'				, text: '전년도 이월예산'			, type: 'uniPrice'},
			{name: 'BUDG_CONV_I'				, text: '전용예산'				, type: 'uniPrice'},
			{name: 'BUDG_ASGN_I'				, text: '배정예산'				, type: 'uniPrice'},
			{name: 'BUDG_SUPP_I'				, text: '추경예산'				, type: 'uniPrice'},
			{name: 'BUDG_IWALL_I'				, text: '이월예산'				, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '수지구분'				, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ]
	});		// End of Ext.define('afb500skrModel', {
	  
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
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb500skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;		//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint	
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
		            xtype: 'uniYearField',
		            name: 'AC_YYYY',
		            fieldLabel: '사업년도',
		            value: new Date().getFullYear(),
		            fieldStyle: 'text-align: center;',
		            allowBlank:false,
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
							UniAppManager.app.fnSetStDate(newValue);
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
							applyextparam: function(popup) {							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
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
							applyextparam: function(popup) {							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
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
						width: 100,
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
	 		load: 'afb500skrService.selectDeptBudg'	
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            fieldLabel: '사업년도',
	            value: new Date().getFullYear(),
	            fieldStyle: 'text-align: center;',
	            allowBlank:false,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_YYYY', newValue);
						UniAppManager.app.fnSetStDate(newValue);
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
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
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
							panelSearch.setValue('BUDG_CODE_TO', '');
							panelSearch.setValue('BUDG_NAME_TO', '');
							panelResult.setValue('BUDG_CODE_TO', '');
							panelResult.setValue('BUDG_NAME_TO', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
						}
					}
		    }),{
				xtype: 'radiogroup',		            		
				fieldLabel: '집계구분',
				id: 'RDO_SELECT2',
				items: [{
					boxLabel: '부서/예산코드', 
					width: 100,
					name: 'RDO',
					inputValue: '1' ,
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
		    })
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
    var masterGrid = Unilite.createGrid('Afb600Grid1', {
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
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false
		},
        columns: [
        	{dataIndex: 'COMP_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'DEPT_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'DEPT_NAME'						, width: 120},
        	{dataIndex: 'BUDG_CODE'						, width: 133,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
        	{dataIndex: 'BUDG_NAME'						, width: 200},
        	{dataIndex: 'CODE_LEVEL'					, width: 66, hidden: true},
        	{dataIndex: 'BUDG_I_TOT'					, width: 120,
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
        	{dataIndex: 'BUDG_I'						, width: 120,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BUDG_I');
						}
					});			 	
				 	return sumData;
			 	}
            },
        	{dataIndex: 'BUDG_CONF_I'					, width: 120,
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
        	{dataIndex: 'LAST_CONF_I'					, width: 120, hidden: true,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('LAST_CONF_I');
						}
					});			 	
				 	return sumData;
			 	}
        	},
        	{dataIndex: 'BUDG_CONV_I'					, width: 120,
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
        	{dataIndex: 'BUDG_ASGN_I'					, width: 120,
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
        	{dataIndex: 'BUDG_SUPP_I'					, width: 120,
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
        	{dataIndex: 'BUDG_IWALL_I'					, width: 120,
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
        	{dataIndex: 'BUDG_TYPE'						, width: 80}
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
	            {	text: '예산실적비교표',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb510(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb510:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb500skr',
					'AC_YYYY' 			: panelSearch.getValue('AC_YYYY'),
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
		  		var rec1 = {data : {prgID : 'afb510skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb510skr.do', params);
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
		id : 'Afb500App',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
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
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
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
