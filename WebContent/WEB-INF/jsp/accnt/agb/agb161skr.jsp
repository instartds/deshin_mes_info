<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb161skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A077" /> <!-- 미결구분 -->  
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

///////////////////////////////// 페이지 개발 전 확인사항 /////////////////////////////////
// 계정과목 팝업 선택시 미결항목 팝업이 유동적으로 변함(구현이 안되있어서 거래처 팝업으로 대체함.)
// 마스터그리드에서 조건에 따라서 페이지 링크가 달라짐(534Line & 595Line 확인해서 링크로 넘어간 페이지 파라미터 받을것.)

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agb161skrModel1', {
		
	    fields: [{name: 'ORG_AC_DATE'    	,text: '발생일' 		,type: 'string'},    		
				 {name: 'ORG_SLIP_NUM'   	,text: '번호' 		,type: 'string'},    		
				 {name: 'ORG_SLIP_SEQ'   	,text: '순번' 		,type: 'string'},    		
				 {name: 'ACCNT'   		 	,text: '계정코드' 		,type: 'string'},    		
				 {name: 'ACCNT_NAME'   	 	,text: '계정과목명' 	,type: 'string'},    		
				 {name: 'AC_NAME'   	 	,text: '미결항목' 		,type: 'string'},    		
				 {name: 'PEND_DATA_CODE' 	,text: '미결코드' 		,type: 'string'},    		
				 {name: 'PEND_DATA_NAME' 	,text: '미결코드명' 	,type: 'string'},    		
				 {name: 'ORG_AMT_I'		 	,text: '발생금액' 		,type: 'uniPrice'},    		
				 {name: 'J_AMT_I'  		 	,text: '반제금액' 		,type: 'uniPrice'},    		
				 {name: 'BLN_I'  		 	,text: '잔액' 		,type: 'uniPrice'},    		
				 {name: 'REMARK'		 	,text: '적요' 		,type: 'string'},    		
				 {name: 'MONEY_UNIT'   	 	,text: '화폐' 		,type: 'string'},    		
				 {name: 'EXCHG_RATE_O'   	,text: '환율' 		,type: 'uniPrice'},    		
				 {name: 'FOR_ORG_AMT_I'  	,text: '발생외화금액' 	,type: 'uniFC'},    		
				 {name: 'FOR_J_AMT_I'    	,text: '반제외화금액' 	,type: 'uniFC'},    		
				 {name: 'FOR_BLN_I'   	 	,text: '외화잔액' 		,type: 'uniFC'},    		
				 {name: 'EXPECT_DATE'    	,text: '예정일' 		,type: 'string'},    		
				 {name: 'INPUT_PATH'   		,text: 'INPUT_PATH' ,type: 'string'},    		
				 {name: 'AP_STS'  			,text: 'AP_STS' 	,type: 'string'},    		
				 {name: 'DIV_CODE'    		,text: 'DIV_CODE' 	,type: 'string'},    		
				 {name: 'INPUT_DIVI'   	 	,text: 'INPUT_DIVI' ,type: 'string'},    		
				 {name: 'PEND_CODE'  		,text: 'PEND_CODE' 	,type: 'string'},    		
				 {name: 'DEPT_CODE'    		,text: 'DEPT_CODE' 	,type: 'string'},    		
				 {name: 'DEPT_NAME' 	  	,text: 'DEPT_NAME'  ,type: 'string'}    		
				 	
			]
	});
	
	Unilite.defineModel('Agb161skrModel2', {
		
	    fields: [{name: 'J_DATE'   		    ,text: '반제일' 		,type: 'string'},  		
				 {name: 'J_SLIP_NUM'      	,text: '번호' 		,type: 'string'},  		
				 {name: 'J_SLIP_SEQ'      	,text: '순번' 		,type: 'string'},  		
				 {name: 'J_AMT_I'   	    ,text: '반제금액' 		,type: 'uniPrice'},  		
				 {name: 'FOR_J_AMT_I'     	,text: '반제외화금액' 	,type: 'uniFC'},  		
				 {name: 'MONEY_UNIT'	    ,text: '화폐' 		,type: 'string'},  		
				 {name: 'EXCHG_RATE_O'    	,text: '환율' 		,type: 'uniER'},  		
				 {name: 'INPUT_PATH'     	,text: 'INPUT_PATH' ,type: 'string'},  		
				 {name: 'AP_STS'	    	,text: 'AP_STS' 	,type: 'string'},  		
				 {name: 'DIV_CODE'    		,text: 'DIV_CODE' 	,type: 'string'}				 	 	
			]
	});				
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('agb161skrMasterStore1',{
			model: 'Agb161skrModel1',
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
                	   read: 'agb161skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		//PRINT 버튼 일단 대기
//	           		var count = masterGrid1.getStore().getCount();  
//	           		if(count > 0){
//		           		UniAppManager.setToolbarButtons(['print'], true);
//	           		}else{
//	           			UniAppManager.setToolbarButtons(['print'], false);
//	           		}
	           		
	           	}
			}
			
	});
	
	var directMasterStore2 = Unilite.createStore('agb161skrMasterStore2',{
			model: 'Agb161skrModel2',
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
                	   read: 'agb161skrService.selectDetail'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();		
				console.log( param );
				this.load({
					params : param
				});
				
			}	
	});	

	/**
	 * 검색조건 (Search Panel)
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
					fieldLabel		: '발생일',
					xtype			: 'uniDateRangefield',
		            startFieldName	: 'FR_DATE',
		            endFieldName	: 'TO_DATE',
		            startDate		: UniDate.get('startOfMonth'), 
                    endDate			: UniDate.get('today'), 
				 	allowBlank		: false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE', newValue);				    		
				    	}
				    }
				}/*,{
					xtype: 'container',
					layout : {type : 'uniTable'},
					items:[{ 
	    			fieldLabel: '발생일',
					xtype: 'uniDatefield',
//					value: UniDate.get('startOfMonth'),
					width: 197,
					name: 'FR_DATE',
					value: UniDate.get('startOfMonth'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('FR_DATE', newValue);
						}
					}
				},{ 
	    			fieldLabel: '~',
	    			allowBlank:false,
					xtype: 'uniDatefield',
					width: 127,
					labelWidth: 18,
					name: 'TO_DATE',
					value: UniDate.get('today'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TO_DATE', newValue);
						}
					}
				}]
	        }*/,{
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
			},{
				fieldLabel: '미결여부',
				xtype: 'uniRadiogroup', 
	        	name: 'CHK_YN',
	        	width: 300,
				items: [{
		        	boxLabel: '전체',
		        	name: 'CHK_YN',
		        	inputValue: '0'
		        },{
		        	boxLabel: '완결',
		        	name: 'CHK_YN',
		        	inputValue: '1'
		        },{
		        	boxLabel: '미결',
		        	name: 'CHK_YN',
		        	inputValue: '2',
		        	checked: true
		        }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('CHK_YN').setValue(newValue);
					}
				}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
	//	    	validateBlank:false,	 
		    	valueFieldName: 'ACCNT_CODE',
		    	textFieldName: 'ACCNT_NAME',
	     		child: 'ITEM',
	     		autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
							
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								//UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);
								var dataMap = provider;
								var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
								
								panelSearch.down('#formFieldArea1').show();
								panelResult.down('#formFieldArea1').show();
								
								panelResult.down('#result_ViewPopup1').hide();
								panelSearch.down('#serach_ViewPopup1').hide();

                               // UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(false);
							});
						},
						scope: this
					},
					
					onClear: function(type)	{
                        panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						
						panelSearch.down('#formFieldArea1').hide();
						panelResult.down('#formFieldArea1').hide();
						
						panelResult.down('#result_ViewPopup1').show();
						panelSearch.down('#serach_ViewPopup1').show();
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
						
                    //    UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(false);
					},
					
                    focusleave:function(form, event) {
                        if(event.fromComponent.name == "ACCNT_CODE" || event.fromComponent.name == "ACCNT_NAME" ) {
                            UniAppManager.app.getTopToolbar().getComponent("query").disable();
                            setTimeout( function() { UniAppManager.app.getTopToolbar().getComponent("query").enable()}, 1000 );
                        }
                    },
                    
// 	                onValueFieldChange: function(field, newValue, oldValue){  
//                         if (oldValue != newValue) {
//                         	   UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);
//                         }
// 	                },  
// 	                onTextFieldChange: function(field, newValue, oldValue){ 
// 	                	if (oldValue != newValue) {
// 	                		   UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);
// 	                	}
// 	                },
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
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
			    	fieldLabel: '미결항목',
			    	validateBlank:false
			    })]
			 },{
		 		fieldLabel: 'ACCNT',
		 		xtype: 'uniTextfield',
		 		name: 'ACCNT_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'ORG_AC_DATE',
		 		xtype: 'uniTextfield',
		 		name: 'ORG_AC_DATE_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'ORG_SLIP_NUM',
		 		xtype: 'uniTextfield',
		 		name: 'ORG_SLIP_NUM_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'ORG_SLIP_SEQ',
		 		xtype: 'uniTextfield',
		 		name: 'ORG_SLIP_SEQ_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'PEND_DATA_CODE',
		 		xtype: 'uniTextfield',
		 		name: 'PEND_DATA_CODE_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'J_DATE_FR',
		 		xtype: 'uniDatefield',
		 		name: 'J_DATE_FR_TEMP',
		 		hidden: true
			},{
		 		fieldLabel: 'J_DATE_TO',
		 		xtype: 'uniDatefield',
		 		name: 'J_DATE_TO_TEMP',
		 		hidden: true
			}]
		}, {
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
    			fieldLabel: '반제일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'J_DATE_FR',
		        endFieldName: 'J_DATE_TO',
		        width: 470
	        },  
		        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        valueFieldName: 'DEPT_CODE',
		    	textFieldName: 'DEPT_NAME'
		    }),
		      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        valueFieldName: 'PEND_DEPT_CODE',
		    	textFieldName: 'PEND_DEPT_NAME'
		    })/*,{
				fieldLabel: '잔액기준',
				xtype: 'uniCheckboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '발생일기준',
		        	name: 'CHK_JAN',
		        	inputValue: 'Y'
		        }]
			},{
	    		xtype: 'uniCheckboxgroup',		            		
	    		fieldLabel: '출력조건',
	    		id: 'printKind',
	    		items: [{
	    			boxLabel: '계정별 페이지 처리',
	    			width: 150,
	    			name: 'CHECK',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N'
	    		}]
	        }*/]		
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
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});	   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	    
			fieldLabel		: '발생일',
			xtype			: 'uniDateRangefield',
            startFieldName	: 'FR_DATE',
            endFieldName	: 'TO_DATE',
            startDate		: UniDate.get('startOfMonth'), 
            endDate			: UniDate.get('today'), 
		 	allowBlank		: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);				    		
		    	}
		    }
		}/*,{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{ 
    			fieldLabel: '발생일',
				xtype: 'uniDatefield',
//				value: UniDate.get('startOfMonth'),
				width: 197,
				name: 'FR_DATE',
				value: UniDate.get('startOfMonth'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FR_DATE', newValue);
					}
				}
			},{ 
    			fieldLabel: '~',
    			allowBlank:false,
				xtype: 'uniDatefield',
				width: 127,
				name: 'TO_DATE',
				labelWidth: 18,
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TO_DATE', newValue);
					}
				}
			}]
        }*/,{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
	        colspan:2,
			width: 325,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
        },
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
//	    	validateBlank:false,	 
	    	valueFieldName: 'ACCNT_CODE',
	    	textFieldName: 'ACCNT_NAME',
//			extParam: {'CHARGE_CODE': (Ext.isEmpty(getChargeCode) && Ext.isEmpty(getChargeCode[0])) ? '':getChargeCode[0].SUB_CODE ,
//		    			'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'"},  
     		child: 'ITEM',
     		autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
                        //UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);

                        panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));	
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
						 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
						 * */
						var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							var dataMap = provider;
							var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
							UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
							UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
							
							panelSearch.down('#formFieldArea1').show();
							panelResult.down('#formFieldArea1').show();
							
							panelResult.down('#result_ViewPopup1').hide();
							panelSearch.down('#serach_ViewPopup1').hide();	
							
                            //UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(false);
						
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{

                    panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
					
					panelSearch.down('#formFieldArea1').hide();
					panelResult.down('#formFieldArea1').hide();
					
					panelResult.down('#result_ViewPopup1').show();
					panelSearch.down('#serach_ViewPopup1').show();
					/**
					 * onClear시 removeField..
					 */
					UniAccnt.removeField(panelSearch, panelResult);
					
             //       UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(false);
				},
                    
                focusleave:function(form, event) {
                    if(event.fromComponent.name == "ACCNT_CODE" || event.fromComponent.name == "ACCNT_NAME" ) {
                        UniAppManager.app.getTopToolbar().getComponent("query").disable();
                        setTimeout( function() { UniAppManager.app.getTopToolbar().getComponent("query").enable()}, 1000 );
                    }
                },

// //				onValueFieldChange: function(field, newValue, oldValue){  
// //                    if (oldValue != newValue) {
// //                        UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);
//                     }
// 				},  
// 				onTextFieldChange: function(field, newValue, oldValue){   
//                     if (oldValue != newValue) {
//                         UniAppManager.app.getTopToolbar().getComponent('query').setDisabled(true);
//                     }
// 				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
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
		    	fieldLabel: '미결항목',
		    	validateBlank:false
		    })]
		 },{
			fieldLabel: '미결여부',
			xtype: 'uniRadiogroup', 
        	name: 'CHK_YN',
        	width: 300,
			items: [{
	        	boxLabel: '전체',
	        	name: 'CHK_YN',
	        	inputValue: '0'
	        },{
	        	boxLabel: '완결',
	        	name: 'CHK_YN',
	        	inputValue: '1'
	        },{
	        	boxLabel: '미결',
	        	name: 'CHK_YN',
	        	inputValue: '2',
	        	checked: true
	        }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('CHK_YN').setValue(newValue);
				}
			}
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
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});	
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('agb161skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	excelTitle: '미결현황',
    	store: directMasterStore1,
		selModel : 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [{ dataIndex: 'ORG_AC_DATE'    	, width: 80	, align:'center',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       			return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
        			}},
        		   { dataIndex: 'ORG_SLIP_NUM'   	, width: 40, align:'center'},
        		   { dataIndex: 'ORG_SLIP_SEQ'   	, width: 40, align:'center'},
        		   { dataIndex: 'ACCNT'   		 	, width: 80	},
        		   { dataIndex: 'ACCNT_NAME'   	 	, width: 140	},
        		   { dataIndex: 'AC_NAME'   	 	, width: 80	},
        		   { dataIndex: 'PEND_DATA_CODE' 	, width: 80	},
        		   { dataIndex: 'PEND_DATA_NAME' 	, width: 160	},
        		   { dataIndex: 'ORG_AMT_I'		 	, width: 113, summaryType: 'sum'},
        		   { dataIndex: 'J_AMT_I'  		 	, width: 113, summaryType: 'sum'},
        		   { dataIndex: 'BLN_I'  		 	, width: 116, summaryType: 'sum'},
        		   { dataIndex: 'REMARK'		 	, width: 233	},
//        		   { dataIndex: 'MONEY_UNIT'   	 	, width: 66	},
//        		   { dataIndex: 'EXCHG_RATE_O'   	, width: 153	},
        		   { dataIndex: 'FOR_ORG_AMT_I'  	, width: 140, summaryType: 'sum'},
        		   { dataIndex: 'FOR_J_AMT_I'    	, width: 140, summaryType: 'sum'},
        		   { dataIndex: 'FOR_BLN_I'   	 	, width: 140, summaryType: 'sum'},
//        		   { dataIndex: 'EXPECT_DATE'    	, width: 80	},
//        		   { dataIndex: 'INPUT_PATH'    	, width: 80, hidden: true	},
//        		   { dataIndex: 'AP_STS'    		, width: 80, hidden: true	},
        		   { dataIndex: 'DIV_CODE'    		, width: 80, hidden: true	},
//        		   { dataIndex: 'INPUT_DIVI'    	, width: 80, hidden: true	},    		
        		   { dataIndex: 'PEND_CODE'    		, width: 80, hidden: true	},    		
        		   { dataIndex: 'DEPT_CODE'    		, width: 80, hidden: true	},    		
        		   { dataIndex: 'DEPT_NAME'    		, width: 80, hidden: true	}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	selectionchange:function( model1, selected, eOpts ){
        		if(selected.length > 0)	{
	        		//var record = selected[0];
	        		var record = masterGrid1.getSelectedRecord();
	        		this.returnCell(record);  
					directMasterStore2.loadData({})
					directMasterStore2.loadStoreRecords(record);
        		}
          	},
          	onGridDblClick :function( grid, record, cellIndex, colName ) {
                masterGrid1.gotoAgj(record);
          	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{   
			if(record.get('INPUT_DIVI') == '2') {
				menu.down('#linkAgj200ukr').hide();
	      		menu.down('#linkDgj100ukr').hide();
	      		
				menu.down('#linkAgj205ukr').show();
			} else if(record.get('INPUT_PATH') == 'Z3') {
				menu.down('#linkAgj200ukr').hide();
	      		menu.down('#linkAgj205ukr').hide();
	      		
				menu.down('#linkDgj100ukr').show();
			} else {
				menu.down('#linkAgj205ukr').hide();
	      		menu.down('#linkDgj100ukr').hide();
	      		
				menu.down('#linkAgj200ukr').show();
			}
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '결의전표입력 이동',  
	            	itemId	: 'linkDgj100ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid1.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력(일괄/매입매출) 이동',   
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid1.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력(건별) 이동',  
	            	itemId	: 'linkAgj205ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid1.gotoAgj(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgj:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'agb161skr',
					'DIV_CODE' 			: record.data['DIV_CODE'],
					'AC_DATE' 			: record.data['ORG_AC_DATE'],
					'INPUT_PATH' 		: record.data['INPUT_PATH'],
					'SLIP_NUM' 		: record.data['ORG_SLIP_NUM'],
					'SLIP_SEQ' 		: record.data['ORG_SLIP_SEQ']
				}
				if(record.data['INPUT_PATH'] == 'A0' || record.data['INPUT_PATH'] == 'A1') {
					alert(Msg.sMA0304);								//기초잔액에서 등록된 자료이므로 전표가 존재하지 않습니다.
  				} else {
  					if(record.data['INPUT_DIVI'] == '2') {
						var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
						parent.openTab(rec1, '/accnt/agj205ukr.do', params);
						
					} else if(record.data['INPUT_PATH'] == 'Z3') {
						var rec2 = {data : {prgID : 'dgj100ukr', 'text':''}};							
						parent.openTab(rec2, '/accnt/dgj100ukr.do', params);
						
					} else {
						var rec3 = {data : {prgID : 'agj200ukr', 'text':''}};							
						parent.openTab(rec3, '/accnt/agj200ukr.do', params);
					}
  				}
			}
    	},
       	returnCell: function(record) {
        	var account			= record.get("ACCNT");
        	var orgAcDate		= record.get("ORG_AC_DATE");
        	var orgAcDate2		= orgAcDate.replace(".","");
        	var orgAcDate3		= orgAcDate2.replace(".","");
        	var orgSlipNum 		= record.get("ORG_SLIP_NUM");
        	var orgSlipSeq		= record.get("ORG_SLIP_SEQ");
        	var pendDataCode	= record.get("PEND_DATA_CODE");
        	var jDateFr			= panelSearch.getValue("J_DATE_FR");
        	var jDateTo			= panelSearch.getValue("J_DATE_TO");
            panelSearch.setValues({'ACCNT_TEMP':account});
            panelSearch.setValues({'ORG_AC_DATE_TEMP':orgAcDate3});
            panelSearch.setValues({'ORG_SLIP_NUM_TEMP':orgSlipNum});
            panelSearch.setValues({'ORG_SLIP_SEQ_TEMP':orgSlipSeq});
            panelSearch.setValues({'PEND_DATA_CODE_TEMP':pendDataCode});
            panelSearch.setValues({'J_DATE_FR_TEMP':jDateFr});
            panelSearch.setValues({'J_DATE_TO_TEMP':jDateTo});
        }
    }); 

    var masterGrid2 = Unilite.createGrid('agb161skrGrid2', {
    	// for tab    	
        layout : 'fit',
        region:'south',
    	excelTitle: '미결현황',
    	store: directMasterStore2,
    	selModel : 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'J_DATE'   		    , width: 133},       		   		 
        		   { dataIndex: 'J_SLIP_NUM'      	, width: 113},       		   		 
        		   { dataIndex: 'J_SLIP_SEQ'      	, width: 113},       		   		 
        		   { dataIndex: 'J_AMT_I'   	    , width: 200},       		   		 
        		   { dataIndex: 'FOR_J_AMT_I'     	, width: 200},       		   		 
        		   { dataIndex: 'MONEY_UNIT'	    , width: 100},       		   		 
        		   { dataIndex: 'EXCHG_RATE_O'    	, width: 66},       		   		 
        		   { dataIndex: 'INPUT_PATH'    	, width: 66, hidden: true},       		   		 
        		   { dataIndex: 'AP_STS'    		, width: 66, hidden: true},       		   		 
        		   { dataIndex: 'DIV_CODE'    		, width: 66, hidden: true}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	masterGrid2.gotoAgj(record);
            }
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{   
			if(record.data['INPUT_PATH'] == 'Y1' || record.data['INPUT_PATH'] == 'Z1') {
				if(record.data['INPUT_DIVI'] == '2') {
		      		menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
				
					menu.down('#linkAgj105ukr').show();

				} else {
					menu.down('#linkAgj105ukr').hide();
					menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
				
		      		menu.down('#linkAgj100ukr').show();
				}
				
			} else { 
				if(record.get('INPUT_DIVI') == '2') {
		      		menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj105ukr').hide();
					menu.down('#linkAgj200ukr').hide();
				
		      		menu.down('#linkAgj205ukr').show();
	
	      		} else {
		      		menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj105ukr').hide();
					menu.down('#linkAgj205ukr').hide();
				
		      		menu.down('#linkAgj200ukr').show();
				}
			}
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '결의전표입력(일괄/매입매출) 이동',  
	            	itemId	: 'linkAgj100ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgj(param.record);
	            	}
	        	},{	text: '결의전표입력(건별) 이동',  
	            	itemId	: 'linkAgj105ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력(일괄/매입매출) 이동',   
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력(건별) 이동',  
	            	itemId	: 'linkAgj205ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgj(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgj:function(record)	{
			if(record)	{
		    	var params = {
					action			: 'select',
					'PGM_ID'		: 'agb161skr',
					'AC_DATE'		: record.data['J_DATE'],
					'INPUT_PATH'	: record.data['INPUT_PATH'],
					'SLIP_NUM'		: record.data['J_SLIP_NUM'],
					'SLIP_SEQ'		: record.data['J_SLIP_SEQ'],
					'AP_STS'		: record.data['AP_STS'],
					'DIV_CODE'		: record.data['DIV_CODE']
				}
				if(record.data['INPUT_PATH'] == 'A0' || record.data['INPUT_PATH'] == 'A1') {
					alert(Msg.sMA0304);								//기초잔액에서 등록된 자료이므로 전표가 존재하지 않습니다.

				} else {
					if(record.data['INPUT_PATH'] == 'Y1' || record.data['INPUT_PATH'] == 'Z1') {
	  					if(record.data['INPUT_DIVI'] == '2') {
							var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	  					
	  					
	  					} else {
							var rec2 = {data : {prgID : 'agj100ukr', 'text':''}};							
							parent.openTab(rec2, '/accnt/agj100ukr.do', params);
						}
						
					} else {
	  					if(record.data['INPUT_DIVI'] == '2') {
							var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agj205ukr.do', params);
	  					
						} else {
							var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agj200ukr.do', params);
						}
					}					
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
				masterGrid1, masterGrid2, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'agb161skrApp',
		fnInitBinding : function() {
//			panelSearch.setValue('CHK_JAN', 'Y');
//			panelSearch.setValue('ACCNT_DIV_CODE'	, UserInfo.divCode);
//			panelSearch.setValue('PEND_YN'			, '1');
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
//			masterGrid1.reset();
//			directMasterStore1.clearData();
//			masterGrid2.reset();
//			directMasterStore2.clearData();
			
			directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {		// 기본값
//			panelSearch.setValue('PEND_YN'			, '1');
        	panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
         	panelSearch.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
		}/*,
		onPrintButtonDown: function() {		// 출력 파라미터 넘김
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var params 	 = Ext.getCmp('searchForm').getValues();
	         var divName     = '';
			 var prgId 		 = '';
	         
			 if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
			 	divName = Msg.sMAW002;  // 전체
			 }else{
			 	divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			 }
			 
 			 if(panelSearch.getValue('CHECK') == 'Y') {
			 	prgId      = 'agb160rkr'; 
			 } else {
			 	prgId      = 'agb161rkr';  
			 }
			 
			 var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/accnt/agb160rkrPrint.do',
	            prgID: prgId,
	               extParam: {
	                  COMP_CODE		 		: UserInfo.compCode,
	                  FR_DATE  				: params.FR_DATE,			
	                  TO_DATE				: params.TO_DATE,			
	                  ACCNT_DIV_CODE		: params.ACCNT_DIV_CODE,	
	                  ACCNT_DIV_NAME		: divName,					
	                  ACCNT_CODE			: params.ACCNT_CODE,		
	                  ACCNT_NAME			: params.ACCNT_NAME,
	                  ACCNT_PRSN			: params.ACCNT_PRSN,
//					  PEND_YN               : params.PEND_YN,
					  J_DATE_FR             : params.J_DATE_FR,
					  J_DATE_TO             : params.J_DATE_TO,
					  DEPT_CODE             : params.DEPT_CODE,
					  DEPT_NAME             : params.DEPT_NAME,
					  PEND_DEPT_CODE        : params.PEND_DEPT_CODE,
					  PEND_DEPT_NAME        : params.PEND_DEPT_NAME,
					  CHECK		            : params.CHECK
	               	}
	            });
	            win.center();
	            win.show();     
	    }*/
	});
};


</script>
