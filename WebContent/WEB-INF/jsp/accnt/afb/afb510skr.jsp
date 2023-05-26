<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb510skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb510skr" /> 	<!-- 사업장 --> 
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
	/*var deptBudg = true;	
	if(Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue == '1')	{
		deptBudg = false;
	}*/
	
	Unilite.defineModel('Afb510Model1', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'					, text: '부서명'				, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'					, text: '예산과목'				, type: 'string'},
			{name: 'CODE_LEVEL'					, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'BUDG_I'						, text: '연간예산'				, type: 'uniPrice'},
			{name: 'ACT_I'						, text: '연간집행'				, type: 'uniPrice'},
			{name: 'BAL_I'						, text: '잔액'				, type: 'uniPrice'},
			{name: 'BUDG_I01'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I01'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I02'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I02'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I03'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I03'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I04'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I04'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I05'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I05'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I06'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I06'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I07'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I07'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I08'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I08'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I09'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I09'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I10'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I10'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I11'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I11'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I12'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I12'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '구분'				, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ]
	});		// End of Ext.define('afb510skrModel', {
	
	Unilite.defineModel('Afb510Model2', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'					, text: '부서명'				, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'					, text: '예산과목'				, type: 'string'},
			{name: 'CODE_LEVEL'					, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'BUDG_I'						, text: '연간예산'				, type: 'uniPrice'},
			{name: 'ACT_I'						, text: '연간집행'				, type: 'uniPrice'},
			{name: 'BAL_I'						, text: '잔액'				, type: 'uniPrice'},
			{name: 'BUDG_I01'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I01'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I02'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I02'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I03'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I03'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_I04'					, text: '예산'				, type: 'uniPrice'},
			{name: 'ACT_I04'					, text: '실적'				, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '구분'				, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ]
	});	
	  
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
                read: 'afb510skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var budgGubun = parseInt(param.BUDG_GUBUN1) + parseInt(param.BUDG_GUBUN2);
			param.budgNameInfoList = budgNameList;		//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint
			param.BUDG_GUBUN = budgGubun;				// 예산실적집계
			console.log( param );
			this.load({
				params : param
			});
		},
		group: 'DEPT_NAME'
	});
	
	var MasterStore2 = Unilite.createStore('Afb510MasterStore',{
		model: 'Afb510Model2',
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
                read: 'afb510skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var budgGubun = parseInt(param.BUDG_GUBUN1) + parseInt(param.BUDG_GUBUN2);
			param.budgNameInfoList = budgNameList;		//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint
			param.BUDG_GUBUN = budgGubun;				// 예산실적집계
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
	 		load: 'afb510skrService.selectDeptBudg'	
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
		    			id: 'LOWER_DEPT_CHECK2',
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
        title: '월별',
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
        	{dataIndex: 'BUDG_I'							, width: 110,
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
        	{dataIndex: 'ACT_I'								, width: 110,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('ACT_I');
						}
					});			 	
				 	return sumData;
			 	}
            },
        	{dataIndex: 'BAL_I'								, width: 110,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BAL_I');
						}
					});			 	
				 	return sumData;
			 	}
            },
        	{text: '1월',
				columns:[
		        	{dataIndex: 'BUDG_I01'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I01');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I01'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I01');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '2월',
				columns:[
		        	{dataIndex: 'BUDG_I02'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I02');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I02'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I02');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '3월',
				columns:[
		        	{dataIndex: 'BUDG_I03'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I03');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I03'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I03');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '4월',
				columns:[
		        	{dataIndex: 'BUDG_I04'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I04');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I04'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I04');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '5월',
				columns:[
		        	{dataIndex: 'BUDG_I05'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I05');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I05'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I05');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '6월',
				columns:[
		        	{dataIndex: 'BUDG_I06'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I06');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I06'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I06');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '7월',
				columns:[
		        	{dataIndex: 'BUDG_I07'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I07');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I07'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I07');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '8월',
				columns:[
		        	{dataIndex: 'BUDG_I08'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I08');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I08'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I08');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '9월',
				columns:[
		        	{dataIndex: 'BUDG_I09'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I09');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I09'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I09');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '10월',
				columns:[
		        	{dataIndex: 'BUDG_I10'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I10');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I10'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I10');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '11월',
				columns:[
		        	{dataIndex: 'BUDG_I11'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I11');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I11'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I11');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{text: '12월',
				columns:[
		        	{dataIndex: 'BUDG_I12'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I12');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I12'							, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I12');
								}
							});			 	
						 	return sumData;
					 	}
		            }
        		]
        	},
        	{dataIndex: 'BUDG_TYPE'							, width: 80}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts, column )	{  
        		if(column, ['ACT_I01','ACT_I02','ACT_I03','ACT_I04','ACT_I05','ACT_I06',
        					'ACT_I07','ACT_I08','ACT_I09','ACT_I10','ACT_I11','ACT_I12']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산집행현황 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb540(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb540:function(grid, record, cellIndex, colName)	{
			if(record)	{
				switch(colName)	{
					case 'BUDG_I01' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '01',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '01',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I02' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '02',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '02',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I03' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '03',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '03',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I04' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '04',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '04',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I05' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '05',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '05',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I06' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '06',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '06',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I07' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '07',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '07',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I08' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '08',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '08',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I09' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '09',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '09',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I10' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '10',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '10',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I11' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '11',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '11',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I12' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '12',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '12',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				}
			}
    	}
    });   
    
    var masterGrid2 = Unilite.createGrid('Afb510Grid2', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
        title: '분기별',
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
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false
		},
        columns: [
        	{dataIndex: 'COMP_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'DEPT_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'DEPT_NAME'						, width: 80},
        	{dataIndex: 'BUDG_CODE'						, width: 133, 
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
        	{dataIndex: 'BUDG_NAME'						, width: 200},
        	{dataIndex: 'CODE_LEVEL'					, width: 66, hidden: true},
        	{dataIndex: 'BUDG_I'						, width: 110,
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
        	{dataIndex: 'ACT_I'							, width: 110,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('ACT_I');
						}
					});			 	
				 	return sumData;
			 	}
            },
        	{dataIndex: 'BAL_I'							, width: 110,
				summaryType:function(values) {
					var sumData = 0;
				 	Ext.each(values, function(value, index) {
						if(value.get('CODE_LEVEL') == '1') {
							sumData = sumData + value.get('BAL_I');
						}
					});			 	
				 	return sumData;
			 	}
            },
        	{text: '1분기',
				columns:[
		        	{dataIndex: 'BUDG_I01'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I01');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I01'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I01');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '2분기',
				columns:[
		        	{dataIndex: 'BUDG_I02'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I02');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I02'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I02');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '3분기',
				columns:[
		        	{dataIndex: 'BUDG_I03'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I03');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I03'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I03');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{text: '4분기',
				columns:[
		        	{dataIndex: 'BUDG_I04'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('BUDG_I04');
								}
							});			 	
						 	return sumData;
					 	}
		            },
		        	{dataIndex: 'ACT_I04'						, width: 110,
						summaryType:function(values) {
							var sumData = 0;
						 	Ext.each(values, function(value, index) {
								if(value.get('CODE_LEVEL') == '1') {
									sumData = sumData + value.get('ACT_I04');
								}
							});			 	
						 	return sumData;
					 	}
		            }
		        ]
        	},
        	{dataIndex: 'BUDG_TYPE'						, width: 80}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts, column )	{  
        		if(column, ['ACT_I01','ACT_I02','ACT_I03','ACT_I04']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산집행현황 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb540(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb540:function(grid, record, cellIndex, colName)	{
			if(record)	{
				switch(colName)	{
					case 'BUDG_I01' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '01',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '03',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I02' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '04',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '06',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I03' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '07',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '09',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I04' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 'afb510skr',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '10',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '12',
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
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				}
			}
    	}
    });  
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ],
	     listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'afb510Grid1':
						
						
						break;
					
					case 'afb510Grid2':
						
						
						break;
						
					default:
						break;
				}
	     	}
	     }
	});
    
	 Unilite.Main( {
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
		id : 'Afb510App',
		fnInitBinding : function(params) {
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
			if(params.PGM_ID == 'afb500skr') {
				panelSearch.setValue('AC_YYYY',params.AC_YYYY);
				panelSearch.setValue('BUDG_CODE_FR',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME_FR',params.BUDG_NAME);
				panelSearch.setValue('BUDG_CODE_TO',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME_TO',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);	
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);	
				panelResult.setValue('AC_YYYY',params.AC_YYYY);
				panelResult.setValue('BUDG_CODE_FR',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME_FR',params.BUDG_NAME);
				panelResult.setValue('BUDG_CODE_TO',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME_TO',params.BUDG_NAME);
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
				masterGrid2.getColumn('DEPT_NAME').setVisible(true);
			} else {
				masterGrid.getColumn('DEPT_NAME').setVisible(false);
				masterGrid2.getColumn('DEPT_NAME').setVisible(false);
			}
		}
	});
};
</script>
