<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb140skr"  >

	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->       
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!--?-->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};				/* 당기시작년월 */
	var gsChargeCode = ${getChargeCode};	/* ChargeCode */
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('Agb140skrModel', {
		
	    fields: [{name: 'BOOK_DATA1' 			,text: '계정잔액1' 		,type: 'string'},	    		
				 {name: 'BOOK_NAME1' 			,text: '계정잔액명1' 		,type: 'string'},	    		
				 {name: 'BOOK_DATA2' 			,text: '계정잔액2' 		,type: 'string'},	    		
				 {name: 'BOOK_NAME2' 			,text: '계정잔액명2' 		,type: 'string'},	  
				 {name: 'BUSI_AMT'				,text: '거래합계'			,type: 'uniPrice'},
				 {name: 'IWAL_AMT_I' 			,text: '이월잔액' 			,type: 'uniPrice'},	    		
				 {name: 'DR_AMT_I'	 			,text: '차변금액' 			,type: 'uniPrice'},	    		
				 {name: 'CR_AMT_I'	 			,text: '대변금액' 			,type: 'uniPrice'},	    		
				 {name: 'JAN_AMT_I'	 			,text: '잔액' 			,type: 'uniPrice'},	    		
				 {name: 'DIV_CODE'	 			,text: 'DIV_CODE' 			,type: 'string'}					 
			]	
	});
		
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('agb140skrMasterStore',{
			model: 'Agb140skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agb140skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			
	});
	

	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',         
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
		    items : [{ 
		        fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}   	
			    }
				
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},		    
	    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
				allowBlank:false,	    			
//				extParam: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
//				    			'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '')"},  
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
							/**
							 * 계정과목 동적 팝업 생성된 필드가 팝업일시 필드name은 아래와 같음 opt: '1'
							 * 미결항목용 opt: '2' 계정잔액1,2용 opt: '3' 관리항목 1~6용
							 * valueFieldName textFieldName valueFieldName
							 * textFieldName valueFieldName textFieldName
							 * PEND_CODE PEND_NAME BOOK_CODE1(~2) BOOK_NAME1(~2)
							 * AC_DATA1(~6) AC_DATA_NAME1(~6)
							 * ---------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield,
							 * uniDatefield일시 필드 name은 아래와 같음 opt: '1' 미결항목용
							 * opt: '2' 계정잔액1,2용 opt: '3' 관리항목 1~6용 PEND_CODE
							 * BOOK_CODE1(~2) AC_DATA1(~6)
							 */
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								var dataMap = provider;
								var opt = '2'	// opt: '1' 미결항목용 opt: '2'
												// 계정잔액1,2용 opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
								
								//panelResult.down('#result_ViewPopup1').hide();
								//panelResult.down('#result_ViewPopup2').hide();
								//panelSearch.down('#serach_ViewPopup1').hide();
								//panelSearch.down('#serach_ViewPopup2').hide();
								
//								panelSearch.down('#conArea1').show();
//								panelSearch.down('#conArea2').show();
//								panelResult.down('#conArea1').show();
//								panelResult.down('#conArea2').show();
								panelSearch.down('#formFieldArea1').show();
								panelSearch.down('#formFieldArea2').show();
								panelResult.down('#formFieldArea1').show();
								panelResult.down('#formFieldArea2').show();
								
								if(!Ext.isEmpty(provider.BOOK_NAME1)){
									masterGrid.getColumn('BOOK_DATA1').setText(provider.BOOK_NAME1);
									masterGrid.getColumn('BOOK_NAME1').setText(provider.BOOK_NAME1 + '명');
									
									panelResult.down('#result_ViewPopup1').hide();
									panelSearch.down('#serach_ViewPopup1').hide();
									panelSearch.down('#serach_ViewPopup3').show();
									panelResult.down('#result_ViewPopup3').show();

									
								} if(Ext.isEmpty(provider.BOOK_NAME1)){
									masterGrid.getColumn('BOOK_DATA1').setText('코드1');
									masterGrid.getColumn('BOOK_NAME1').setText('코드명1');
								}
								if(!Ext.isEmpty(provider.BOOK_NAME2)){
									masterGrid.getColumn('BOOK_DATA2').setText(provider.BOOK_NAME2);
									masterGrid.getColumn('BOOK_NAME2').setText(provider.BOOK_NAME2 + '명');
									
									panelResult.down('#result_ViewPopup2').hide();
									panelSearch.down('#serach_ViewPopup2').hide();
									
									panelResult.down('#result_ViewPopup3').hide();
									panelSearch.down('#serach_ViewPopup3').hide();
									
								}if(Ext.isEmpty(provider.BOOK_NAME2)){
									masterGrid.getColumn('BOOK_DATA2').setText('코드2');
									masterGrid.getColumn('BOOK_NAME2').setText('코드명2');
									
									panelResult.down('#result_ViewPopup2').hide();
									panelSearch.down('#serach_ViewPopup2').hide();
									
									panelSearch.down('#formFieldArea2').hide();
									panelResult.down('#formFieldArea2').hide();
								}
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '')"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE});			//bParam(3)			
					}
				}
		    }),{
		    	xtype: 'container',
		    	itemId: 'conArea1',
		    	items:[{
				  	xtype: 'container',
				  	colspan: 1,
				  	itemId: 'formFieldArea1', 
				  	layout: {
				   		type: 'table', 
				   		columns:1,
				   		itemCls:'table_td_in_uniTable',
				   		tdAttrs: {
				    		width: 350
				   		}
			  		}
				}]
		    },{
		    	xtype: 'container',
		    	itemId: 'conArea2',
		    	items:[{
				  	xtype: 'container',
				  	colspan: 1,
				  	itemId: 'formFieldArea2', 
				  	layout: {
				   		type: 'table', 
				   		columns:1,
				   		itemCls:'table_td_in_uniTable',
				   		tdAttrs: {
				    		width: 350
				   		}
			  		}
				}]
		    },{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'serach_ViewPopup1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
					Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정항목1',
			    	validateBlank:false
			    })]
			 },{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'serach_ViewPopup3', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[{
					xtype: 'component'
				}
			]},{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'serach_ViewPopup2', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
				    Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
				    	fieldLabel: '계정항목2',
				    	validateBlank:false
				    })
			]},{
				xtype: 'radiogroup',		            		
				fieldLabel: '거래합계',
				id:'PANEL_SUM',
				items: [{
					boxLabel: '미출력', 
					width: 70, 
					name: 'SUM',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '출력', 
					width: 70,
					name: 'SUM',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {		
						panelSearch.getField('SUM').setValue(newValue.SUM);
						
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						}else{					
							if(newValue.SUM == '1' ){
								masterGrid.getColumn('BUSI_AMT').setVisible(false);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}else if(newValue.SUM == '2' ){
								masterGrid.getColumn('BUSI_AMT').setVisible(true);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '금액기준',
				id:'JAN',
				items: [{
					boxLabel: '발생', 
					width: 70, 
					name: 'JAN',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel : '잔액', 
					width: 70,
					name: 'JAN',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('JAN').setValue(newValue.JAN);
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						}else{					
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}]
		}, {
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'START_DATE',
		 		allowBlank:false
			},  
		        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_FR',
				textFieldName: 'DEPT_NAME_FR',
				listeners: {
					onClear: function(type)	{
                    	panelSearch.setValue('DEPT_CODE_FR', '');
                        panelSearch.setValue('DEPT_NAME_FR', '');
                        UniAccnt.removeField(panelSearch, panelResult);
					}
				}
		    }),
		      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_TO',
				textFieldName: 'DEPT_NAME_TO',
				listeners: {
					onClear: function(type)	{
                    	panelSearch.setValue('DEPT_CODE_TO', '');
                        panelSearch.setValue('DEPT_NAME_TO', '');
                        UniAccnt.removeField(panelSearch, panelResult);
					}
				}
		    })]		
		}]
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
		        fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}   	
			    }
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},		    
	    	Unilite.popup('ACCNT',{
			    	fieldLabel: '계정과목',
					allowBlank:false,
//					extParam: {'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
//				    			'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '')"},  
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
								panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
								/**
								 * 계정과목 동적 팝업 생성된 필드가 팝업일시 필드name은 아래와 같음 opt:
								 * '1' 미결항목용 opt: '2' 계정잔액1,2용 opt: '3' 관리항목
								 * 1~6용 valueFieldName textFieldName
								 * valueFieldName textFieldName valueFieldName
								 * textFieldName PEND_CODE PEND_NAME
								 * BOOK_CODE1(~2) BOOK_NAME1(~2) AC_DATA1(~6)
								 * AC_DATA_NAME1(~6)
								 * -------------------------------------------------------------------------------------------------------------------------
								 * 생성된 필드가 uniTextfield, uniNumberfield,
								 * uniDatefield일시 필드 name은 아래와 같음 opt: '1' 미결항목용
								 * opt: '2' 계정잔액1,2용 opt: '3' 관리항목 1~6용
								 * PEND_CODE BOOK_CODE1(~2) AC_DATA1(~6)
								 */
								var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
								accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
									var dataMap = provider;
									var opt = '2'	// opt: '1' 미결항목용 opt: '2'
													// 계정잔액1,2용 opt: '3' 관리항목
													// 1~6용
									UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
									UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
									
									//panelResult.down('#result_ViewPopup3').hide();
									//panelResult.down('#result_ViewPopup1').hide();
									//panelResult.down('#result_ViewPopup2').hide();
									//panelSearch.down('#serach_ViewPopup1').hide();
									//panelSearch.down('#serach_ViewPopup2').hide();
									
//									panelSearch.down('#conArea1').show();
//									panelSearch.down('#conArea2').show();
//									panelResult.down('#conArea1').show();
//									panelResult.down('#conArea2').show();
									panelSearch.down('#formFieldArea1').show();
									panelSearch.down('#formFieldArea2').show();
									panelResult.down('#formFieldArea1').show();
									panelResult.down('#formFieldArea2').show();
								
									
									if(!Ext.isEmpty(provider.BOOK_NAME1)){
										masterGrid.getColumn('BOOK_DATA1').setText(provider.BOOK_NAME1);
										masterGrid.getColumn('BOOK_NAME1').setText(provider.BOOK_NAME1 + '명');
										
										panelResult.down('#result_ViewPopup1').hide();
										panelSearch.down('#serach_ViewPopup1').hide();
										panelSearch.down('#serach_ViewPopup3').show();
										panelResult.down('#result_ViewPopup3').show();
									}
									if(Ext.isEmpty(provider.BOOK_NAME1)){
										masterGrid.getColumn('BOOK_DATA1').setText('코드1');
										masterGrid.getColumn('BOOK_NAME1').setText('코드명1');
									}
									if(!Ext.isEmpty(provider.BOOK_NAME2)){
										masterGrid.getColumn('BOOK_DATA2').setText(provider.BOOK_NAME2);
										masterGrid.getColumn('BOOK_NAME2').setText(provider.BOOK_NAME2 + '명');
										
										panelResult.down('#result_ViewPopup2').hide();
										panelSearch.down('#serach_ViewPopup2').hide();
										panelSearch.down('#serach_ViewPopup3').hide();
										panelResult.down('#result_ViewPopup3').hide();
										
									}
									if(Ext.isEmpty(provider.BOOK_NAME2)){
										masterGrid.getColumn('BOOK_DATA2').setText('코드2');
										masterGrid.getColumn('BOOK_NAME2').setText('코드명2');
										
										panelResult.down('#result_ViewPopup2').hide();
										panelSearch.down('#serach_ViewPopup2').hide();
										
										panelSearch.down('#formFieldArea2').hide();
										panelResult.down('#formFieldArea2').hide();
									}
								})
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_CODE', '');
							panelSearch.setValue('ACCNT_NAME', '');
							/**
							 * onClear시 removeField..
							 */
							UniAccnt.removeField(panelSearch, panelResult);
						},
						applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '')"});			//WHERE절 추카 쿼리
							popup.setExtParam({'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE});			//bParam(3)			
						}
					}
		    }),{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'result_ViewPopup1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
				    Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
				    	fieldLabel: '계정항목1',
				    	validateBlank:false
				    })
			]},{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				colspan: 2,
				items:[{
			    	xtype: 'container',
			    	itemId: 'conArea1',
			    	items:[{
					  	xtype: 'container',
					  	colspan: 1,
					  	itemId: 'formFieldArea1', 
					  	layout: {
					   		type: 'table', 
					   		columns:1,
					   		itemCls:'table_td_in_uniTable',
					   		tdAttrs: {
					    		width: 350
					   		}
				  		}
					}]
			    },{
					xtype: 'radiogroup',		            		
					fieldLabel: '거래합계',
					items: [{
						boxLabel: '미출력', 
						width: 70, 
						name: 'SUM',
						inputValue: '1',
						checked: true  
					},{
						boxLabel : '출력', 
						width: 70,
						name: 'SUM',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {		
							panelSearch.getField('SUM').setValue(newValue.SUM);
							
							if(!UniAppManager.app.isValidSearchForm()){
								return false;
							}else{					
								if(newValue.SUM == '1' ){
									masterGrid.getColumn('BUSI_AMT').setVisible(false);
									masterGrid.reset();
									UniAppManager.app.onQueryButtonDown();
								}else if(newValue.SUM == '2' ){
									masterGrid.getColumn('BUSI_AMT').setVisible(true);
									masterGrid.reset();
									UniAppManager.app.onQueryButtonDown();
								}
							}
						}
					}
				}]
			},{
				xtype: 'component'
			},/*
				 * { xtype: 'component' },
				 */{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'result_ViewPopup2', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
				    Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
				    	fieldLabel: '계정항목2',
				    	validateBlank:false
				    })
			]},{
			  	xtype: 'container',
			  	colspan: 1,
			  	itemId: 'result_ViewPopup3', 
			  	//hidden: true,
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[{
					xtype: 'component'
				}
			]}
			,{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{
			    	xtype: 'container',
			    	itemId: 'conArea2',
			    	items:[{
					  	xtype: 'container',
					  	colspan: 1,
					  	itemId: 'formFieldArea2', 
					  	layout: {
					   		type: 'table', 
					   		columns:1,
					   		itemCls:'table_td_in_uniTable',
					   		tdAttrs: {
					    		width: 350
					   		}
				  		}
					}]
			    },{
					xtype: 'radiogroup',		            		
					fieldLabel: '금액기준',
					items: [{
						boxLabel: '발생', 
						width: 70, 
						name: 'JAN',
						inputValue: 'Y',
						checked: true  
					},{
						boxLabel : '잔액', 
						width: 70,
						name: 'JAN',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('JAN').setValue(newValue.JAN);
							if(!UniAppManager.app.isValidSearchForm()){
								return false;
							}else{					
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}]
			}]	
    });
    
    var panelSouth = Unilite.createSearchForm('southForm',{
    	region: 'south',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
					xtype:'component',
					width: 400
				},{
					xtype:'component',
					width: 400
				},{
			 		fieldLabel: '(잔액차액)',
			 		xtype: 'uniNumberfield',
			 		name: 'DIFF_JAN_AMT',
			 		readOnly:true
			}]	
    });
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('agb140skrGrid1', {
    	// for tab
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
/*    	uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
		*/
		uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        tbar: [{
        	text:'계정명세출력',
        	handler: function() {
				var params = {
					'FR_DATE'		: panelSearch.getValue('FR_DATE'),
					'TO_DATE'		: panelSearch.getValue('TO_DATE'),
					'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT_CODE'	: panelSearch.getValue('ACCNT_CODE'),
					'ACCNT_NAME'	: panelSearch.getValue('ACCNT_NAME'),
					'DEPT_CODE_FR'	: panelSearch.getValue('DEPT_CODE_FR'),
					'DEPT_NAME_FR'	: panelSearch.getValue('DEPT_NAME_FR'),
					'DEPT_CODE_TO'	: panelSearch.getValue('DEPT_CODE_TO'),
					'DEPT_NAME_TO'	: panelSearch.getValue('DEPT_NAME_TO'),
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'PANEL_SUM'		: Ext.getCmp('PANEL_SUM').getChecked()[0].inputValue,
					'JAN'			: Ext.getCmp('JAN').getChecked()[0].inputValue
				}
				
        		//전송
          		var rec1 = {data : {prgID : 'agb140rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb140rkr.do', params);	
        	}
        }],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns:  [{ dataIndex: 'BOOK_DATA1' 	, width: 100 ,
        			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}
        		   },
        		   { dataIndex: 'BOOK_NAME1' 	, width: 160},
        		   { dataIndex: 'BOOK_DATA2' 	, width: 100 },
        		   { dataIndex: 'BOOK_NAME2' 	, width: 160},
        		   { dataIndex: 'IWAL_AMT_I' 	, width: 133 , summaryType: 'sum'},
        		   { dataIndex: 'BUSI_AMT'		, width: 133 , summaryType: 'sum' , hidden: true},
        		   { dataIndex: 'DR_AMT_I'	 	, width: 133 , summaryType: 'sum'},
        		   { dataIndex: 'CR_AMT_I'	 	, width: 133 , summaryType: 'sum'},
        		   { dataIndex: 'JAN_AMT_I'	 	, width: 133 , summaryType: 'sum'}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	masterGrid.gotoAgb110skr(record);
                /*if(grid.grid.contextMenu) {
                    var menuItem = grid.grid.contextMenu.down('#agb110Item');
                    if(menuItem) {
                        menuItem.handler();
                    }
                }*/
            }
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	                itemId:'agb110Item',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb110skr(param.record);
	            	}
	        	}
	        ]
	    },
	    
	    gotoAgb110skr:function(record)	{
			if(record)	{
		    	var params = {
		    		action				:'select',
			    	'PGM_ID' 			: 'agb140skr',
			    	'START_DATE' 		: panelSearch.getValue('START_DATE'),
			    	'FR_DATE' 			: panelSearch.getValue('FR_DATE'),
			    	'TO_DATE' 			: panelSearch.getValue('TO_DATE'),
			    	'ACCNT_CODE' 		: panelSearch.getValue('ACCNT_CODE'),
			    	'ACCNT_NAME' 		: panelSearch.getValue('ACCNT_NAME'),
			    	
			    	'BOOK_DATA1'		:  record.data['BOOK_DATA1'],  						
			    	'BOOK_NAME1'		:  record.data['BOOK_NAME1'],	  	 						
			    	
			    	'BOOK_DATA2' 		:  record.data['BOOK_DATA2'],								
			    	'BOOK_NAME2' 		:  record.data['BOOK_NAME2'],								
			    	'DIV_CODE' 		:  record.data['DIV_CODE']							
		    	}
		    	var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);
			}
    	}
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult ,panelSouth
			]
		},
			panelSearch  	
		],
		id  : 'agb140skrApp',
		fnInitBinding : function(params) {
			
	/*		panelResult.down('#formFieldArea1').show();
			panelResult.down('#formFieldArea2').show();*/
			
			panelSearch.down('#serach_ViewPopup3').hide();
			panelResult.down('#result_ViewPopup3').hide();
			
//			panelSearch.down('#conArea1').hide();
//			panelSearch.down('#conArea2').hide();
//			panelResult.down('#conArea1').hide();
//			panelResult.down('#conArea2').hide();
			panelSearch.down('#formFieldArea1').hide();
			panelSearch.down('#formFieldArea2').hide();
			panelResult.down('#formFieldArea1').hide();
			panelResult.down('#formFieldArea2').hide();
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			// panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
				accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
					var dataMap = provider;
					var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
					UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
					UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
					if(!Ext.isEmpty(params.BOOK_DATA1)){
						panelSearch.setValue('BOOK_CODE1',params.BOOK_DATA1);
						panelSearch.setValue('BOOK_CODE2',params.BOOK_DATA2);
						panelSearch.setValue('BOOK_NAME1',params.BOOK_NAME1);
						panelSearch.setValue('BOOK_NAME2',params.BOOK_NAME2);
						panelResult.setValue('BOOK_CODE1',params.BOOK_DATA1);
						panelResult.setValue('BOOK_CODE2',params.BOOK_DATA2);
						panelResult.setValue('BOOK_NAME1',params.BOOK_NAME1);
						panelResult.setValue('BOOK_NAME2',params.BOOK_NAME2);
						
						panelSearch.down('#conArea1').show();
						panelSearch.down('#conArea2').show();
						panelResult.down('#conArea1').show();
						panelResult.down('#conArea2').show();
						panelSearch.down('#formFieldArea1').show();
						panelSearch.down('#formFieldArea2').show();
						panelResult.down('#formFieldArea1').show();
						panelResult.down('#formFieldArea2').show();
						
						panelResult.down('#result_ViewPopup1').hide();
						panelSearch.down('#serach_ViewPopup1').hide();
						panelResult.down('#result_ViewPopup2').hide();
						panelSearch.down('#serach_ViewPopup2').hide();
					}
					
					var viewNormal = masterGrid.getView();
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					UniAppManager.app.onQueryButtonDown();
//					masterStore.loadStoreRecords();
				})
			}
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{

				directMasterStore.loadStoreRecords();	
				
				var param = {
							"COMP_CODE"		 : UserInfo.compCode,
							"ACCNT_DIV_CODE" : panelSearch.getValue('ACCNT_DIV_CODE'),
							
							"START_DATE" 	 : UniDate.getDbDateStr(panelSearch.getValue('START_DATE')).substring(0, 6),
							
							"TO_DATE" 		 : UniDate.getDbDateStr(panelSearch.getValue('TO_DATE')),
							"ACCNT_CODE" 	 : UniDate.getDbDateStr(panelSearch.getValue('ACCNT_CODE')),
							
							"DEPT_CODE_FR"	 : panelSearch.getValue('DEPT_CODE_FR'),
							"DEPT_CODE_TO"	 : panelSearch.getValue('DEPT_CODE_TO'),
							
							"SUM"			 : Ext.getCmp('PANEL_SUM').getChecked()[0].inputValue
				};
					agb140skrService.fnDiffJanAmt(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						panelSouth.setValue('DIFF_JAN_AMT',provider['JAN_DIS_AMT_I'] );	
					}
				})
				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}	
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if (params.PGM_ID == 'agb101skr' ||params.PGM_ID == 'agb120skr' || params.PGM_ID == 'agb125skr') {
				panelSearch.setValue('FR_DATE',params.AC_DATE_FR);
				panelSearch.setValue('TO_DATE',params.AC_DATE_TO);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelResult.setValue('FR_DATE',params.AC_DATE_FR);
				panelResult.setValue('TO_DATE',params.AC_DATE_TO);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}
		},
/*		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},*/
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});

};


</script>
