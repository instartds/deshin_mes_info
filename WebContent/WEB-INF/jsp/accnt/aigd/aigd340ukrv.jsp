<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aigd340ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aigd340ukrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A180" /> 				<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> 				<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> 				<!-- 결제유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 				<!-- 증빙구분-->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> 				<!-- 전표승인여부-->
	<t:ExtComboStore comboType="AU" comboCode="B131" />                 <!-- 전표승인여부 (AGREE_YN) -->
<style type="text/css">
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() { 
	
	var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
    var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	
    var sumTotalAmtI = 0;
	var sumCheckedCount = 0;
	var newYN = 0;
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'aigd340ukrvService.runProcedure',
            syncAll	: 'aigd340ukrvService.callProcedure'
		}
	});	

	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aigd340ukrvModel', {
	    fields: [
	    	{name: 'CHOICE' 					,text: '선택' 					,type: 'string'    },
	    	{name: 'COMP_CODE' 					,text: '법인코드' 					,type: 'string'    },
	    	{name: 'ALTER_DIVI' 				,text: 'ALTER_DIVI' 			,type: 'string'    },
	    	{name: 'WASTE_DIVI' 				,text: 'WASTE_DIVI' 			,type: 'string'    },
	    	{name: 'SEQ' 						,text: '순번' 					,type: 'int'       },
	    	{name: 'CONV_ALTER_DIVI' 			,text: '변동구분' 					,type: 'string'		, comboType: 'AU'	, comboCode: 'A142'},
	    	{name: 'ALTER_DATE' 				,text: '변동일자' 					,type: 'uniDate'   },
	    	{name: 'ASST' 						,text: '자산코드' 					,type: 'string'    },
	    	{name: 'ASST_NAME' 					,text: '자산명' 					,type: 'string'    },
	    	{name: 'ASST_DIVI' 					,text: '자산구분' 					,type: 'string'		, comboType: 'AU'	, comboCode: 'A042'},
	    	{name: 'ACCNT' 						,text: '계정과목' 					,type: 'string'    },
	    	{name: 'ACCNT_NAME' 				,text: '계정과목명' 				,type: 'string'    },
	    	{name: 'ACQ_AMT_I' 					,text: '취득가액' 					,type: 'uniPrice'  },
	    	{name: 'ALTER_AMT_I' 				,text: '변동금액' 					,type: 'uniPrice'  },
	    	{name: 'ALTER_REASON' 				,text: '변동사유' 					,type: 'string'    },
	    	{name: 'MONEY_UNIT' 				,text: '화폐단위' 					,type: 'string'    },
	    	{name: 'EXCHG_RATE_O' 				,text: '환율' 					,type: 'uniPercent'},
	    	{name: 'FOR_ALTER_AMT_I' 			,text: '외화변동금액' 				,type: 'uniFC'  },
	    	{name: 'SET_TYPE' 					,text: '결제유형' 					,type: 'string' , comboType: 'AU',  comboCode: 'A140'   },
	    	{name: 'PROOF_KIND' 				,text: '증빙유형' 					,type: 'string' , comboType: 'AU',  comboCode: 'A022'   },
	    	{name: 'SUPPLY_AMT_I' 				,text: '공급가액' 					,type: 'uniPrice'  },
	    	{name: 'TAX_AMT_I' 					,text: '세액' 					,type: 'uniPrice'  },
	    	{name: 'CUSTOM_CODE' 				,text: '거래처코드' 				,type: 'string'    },
	    	{name: 'CUSTOM_NAME' 				,text: '거래처명' 					,type: 'string'    },
	    	{name: 'EX_DATE' 					,text: '결의일' 					,type: 'uniDate'   },
	    	{name: 'EX_NUM' 					,text: '결의번호' 					,type: 'string'    },
	    	{name: 'DIV_CODE' 					,text: '사업장' 					,type: 'string'	   , comboType:'BOR120'},
	    	{name: 'AGREE_YN' 					,text: '승인여부' 					,type: 'string'	   , comboType:'AU', comboCode: 'B131'} //,
	    	//{name: 'AP_STS' 					,text: '승인여부' 					,type: 'string'    , comboType: 'AU',  comboCode: 'A014'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aigd340ukrvMasterStore1',{
		model: 'aigd340ukrvModel',
		uniOpt : {								
			isMaster	: true,			// 상위 버튼 연결 	
			editable	: false,			// 수정 모드 사용 	
			deletable	: false,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용	
		},
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'aigd340ukrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			Ext.Object.merge(param, addResult.getValues());
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records.length == 0) {
		   			panelSearch.getField('FR_DATE').setReadOnly(false);
		   			panelSearch.getField('TO_DATE').setReadOnly(false);
		   			panelSearch.getField('FR_INSERT_DATE').setReadOnly(false);
		   			panelSearch.getField('TO_INSERT_DATE').setReadOnly(false);
		   			
		   			panelResult.getField('FR_DATE').setReadOnly(false);   
		   			panelResult.getField('TO_DATE').setReadOnly(false);   
		   			panelResult.getField('FR_INSERT_DATE').setReadOnly(false);
		   			panelResult.getField('TO_INSERT_DATE').setReadOnly(false);

           		}
           		
           		//조회되는 항목 갯수와 매출액 합계 구하기
           		var totalAmtI = 0;
           		var count = masterGrid.getStore().getCount();  
				Ext.each(records, function(record, i){	
					totalAmtI = record.get('ALTER_AMT_I') + totalAmtI	
		    	}); 
	    		
	    		addResult.setValue('TOT_SELECTED_AMT', totalAmtI);
				addResult.setValue('TOT_COUNT',count); 
				if(addResult.getValue('WORK_DIVI') == 1 ){
       				Ext.getCmp('procCanc2').setText('자동기표');
       			}else {
       				Ext.getCmp('procCanc2').setText('기표취소');
       			};
           	}
		}
	});
		

    var buttonStore = Unilite.createStore('aigd340ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster = panelSearch.getValues();
            Ext.Object.merge(paramMaster, addResult.getValues());
            paramMaster.OPR_FLAG	= buttonFlag;
            paramMaster.CALL_PATH	= 'LIST';	

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aigd340ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

	/* 검색조건 (Search Panel)
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
				fieldLabel	: '변동일',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'FR_DATE',
	            endFieldName: 'TO_DATE',
	            startDate	: getStDt[0].STDT,
	            endDate		: getStDt[0].TODT,
	            allowBlank	: false,                	
				autoPopup	: true,
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
	     	},		    
		    Unilite.popup('ACCNT',{
		    	fieldLabel		: '계정과목',
		    	valueFieldName	: 'ACCNT_CODE',
		    	textFieldName	: 'ACCNT_NAME',
		    	autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
		    }),{
				fieldLabel: '변동구분',
				name:'ALTER_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A142',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ALTER_DIVI', newValue);
					}
				}
			},
			Unilite.popup('IFRS_ASSET', {
				fieldLabel		: '자산코드', 
				valueFieldName	: 'ASSET_CODE', 
				textFieldName	: 'ASSET_NAME', 
				autoPopup		: true,
			    extParam		: {'ADD_QUERY': "ASST_DIVI = '1'"}, 
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
					}
				}
			}),{
				fieldLabel: '자산구분',
				name:'ASST_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A042',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ASST_DIVI', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '입력일',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_INSERT_DATE',
	            endFieldName: 'TO_INSERT_DATE',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('FR_INSERT_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_INSERT_DATE', newValue);				    		
			    	}
			    }
	     	},
				Unilite.popup('ACCNT_PRSN',{ 
				    fieldLabel: '<t:message code="system.label.sales.accntperson" default="입력자"/>', 
				    validateBlank: true, 
				    popupWidth: 890,  
					valueFieldName:'CHARGE_CODE',
					textFieldName:'CHARGE_NAME',
					valueFieldWidth : 90,
					textFieldWidth: 140,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CHARGE_CODE', panelSearch.getValue('CHARGE_CODE'));
								panelResult.setValue('CHARGE_NAME', panelSearch.getValue('CHARGE_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CHARGE_CODE', '');
							panelResult.setValue('CHARGE_NAME', '');
						}
					}
			}),
				Unilite.popup('DEPT',{ 
				    fieldLabel: '<t:message code="system.label.sales.inputdepartment" default="입력부서"/>', 
				    validateBlank: true, 
				    popupWidth: 890,  
					valueFieldName:'DEPT_CODE',
					textFieldName:'DEPT_NAME',
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
							panelResult.setValue('DEPT_NAME', '');
						}
					}
			}),			    
	        {
            	fieldLabel: '결의전표승인여부',
            	name: 'AP_STS',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'A014',
            	listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('AP_STS', newValue);
			    	}
	     		}
			}]
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3 },
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel	: '변동일',
            xtype		: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            startDate	: getStDt[0].STDT,
            endDate		: getStDt[0].TODT,
            allowBlank	: false,                	
			autoPopup	: true,   
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
     	},	    
		Unilite.popup('IFRS_ASSET', {
			fieldLabel		: '자산코드', 
			valueFieldName	: 'ASSET_CODE', 
			textFieldName	: 'ASSET_NAME', 
			autoPopup		: true,
            tdAttrs			: {width: 380}, 
		    extParam		: {'ADD_QUERY': "ASST_DIVI = '1'"},  
			colspan         : 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE', '');
					panelSearch.setValue('ASSET_NAME', '');
				}
			}
		}),{
			fieldLabel: '입력일',
 		    width: 315,
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_INSERT_DATE',
            endFieldName: 'TO_INSERT_DATE',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_INSERT_DATE', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_INSERT_DATE', newValue);				    		
		    	}
		    }
     	},		    
	    Unilite.popup('ACCNT',{
	    	fieldLabel		: '계정과목',
	    	valueFieldName	: 'ACCNT_CODE',
	    	textFieldName	: 'ACCNT_NAME',
			valueFieldWidth : 90,
			textFieldWidth: 140,
	    	autoPopup		: true,
            tdAttrs			: {width: 380},  
			colspan         : 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
	    }),{
			fieldLabel: '변동구분',
			name:'ALTER_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A142',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ALTER_DIVI', newValue);
				}
			}
		},
		Unilite.popup('ACCNT_PRSN',{ 
		    fieldLabel: '입력자', 
		    validateBlank: true, 
		    popupWidth: 890,  
			valueFieldName:'CHARGE_CODE',
			textFieldName:'CHARGE_NAME',
			valueFieldWidth : 90,
			textFieldWidth: 140,
		    colspan: 2, 
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CHARGE_CODE', panelResult.getValue('CHARGE_CODE'));
						panelSearch.setValue('CHARGE_NAME', panelResult.getValue('CHARGE_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CHARGE_CODE', '');
					panelSearch.setValue('CHARGE_NAME', '');
				}
			}
	}),{
			fieldLabel: '자산구분',
			name:'ASST_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			}
		},
			Unilite.popup('DEPT',{ 
			    fieldLabel: '입력부서', 
			    validateBlank: true, 
			    popupWidth: 890,  
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME',
				colspan         : 2,
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
						panelSearch.setValue('DEPT_NAME', '');
					}
				}
		}),{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{
				fieldLabel: '결의전표승인여부',
	        	name: 'AP_STS',
	        	xtype: 'uniCombobox',
	        	comboType: 'AU',
	        	comboCode: 'A014',
	    		labelWidth:150,
	    		width :325,
		 		tdAttrs: {align: 'right'},
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    	panelSearch.setValue('AP_STS', newValue);
			    	}
	     		}
			}]
		}]
	});
	
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {
			type : 'uniTable', 
			columns : 3 ,
			tdAttrs: { width: '100%'},
			tableAttrs: {style: 'padding-right : 10px;'}
		},
		disabled: false,
		border:true,
		padding:'1 1 1 1',
		region: 'center',
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 380},    
			items:[{
				fieldLabel: '실행일',
	            xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
				readOnly:true,
			 	allowBlank:false,
			 	width:220
	     	},{
				xtype: 'radiogroup',		            		
				fieldLabel: '',						            		
				id: 'rdoSelect1',
//				width:140,
				items: [{
					boxLabel: '변동일', 
					width: 70, 
					name: 'DATE_OPTION',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '실행일', 
					width: 70,
					name: 'DATE_OPTION',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.DATE_OPTION == '1'){
							addResult.getField('WORK_DATE').setReadOnly(true);
						}else{
							addResult.getField('WORK_DATE').setReadOnly(false);
						}
					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable', column : 2},
	    	items:[{
	    		xtype: 'uniRadiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.worktype" default="작업구분"/>',						            		
				id: 'rdoSelect2',
				tdAttrs: {align: 'left'},
				items: [{
					boxLabel: '<t:message code="system.label.sales.autoslipposting" default="자동기표"/>', 
					width: 90, 
					name: 'WORK_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.sales.slipcancel" default="기표취소"/>', 
					width: 90,
					name: 'WORK_DIVI',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						
						if(newValue.WORK_DIVI == '1'){
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
						}		
						if(newValue.WORK_DIVI == '2'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
						}
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
						}	

					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {align: 'right'},
			items:[{				   
				xtype: 'button',
				id: 'procCanc2',
				text: '<t:message code="system.label.sales.autoslipposting" default="자동기표"/>',
				width: 100,
		 		tdAttrs: {align: 'right'},
				handler : function() {
						if(addResult.getValue('COUNT') != 0){  
							//자동기표일 때 SP 호출
							if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
					            var buttonFlag = 'N';
					            fnMakeLogTable(buttonFlag);
							}
							//기표취소일 때 SP 호출
							if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
					            var buttonFlag = 'D';
					            fnMakeLogTable(buttonFlag);
							}
						}else {
							alert('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
							return false;
						}
					}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable', columns : 6, tdAttrs: { width: '100%'}
			},
			colspan: 3,
	    	items:[{
    			xtype: 'component'
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '변동금액(<t:message code="system.label.sales.inquiry" default="조회"/>)',						            		
				width: 200,
//				labelWidth: 60,
				name: 'TOT_SELECTED_AMT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '<t:message code="system.label.sales.selected" default="건수"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',						            		
				width: 160,
				labelWidth: 100,
				name: 'TOT_COUNT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			},{
	    		xtype: 'component',
				html:'/',
				width: 30,
				tdAttrs: {align: 'center'},
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}			
 			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '변동금액합계(<t:message code="system.label.sales.selection" default="선택"/>)'	,						            		
				width: 200,
				labelWidth: 110,
				name: 'SELECTED_AMT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '<t:message code="system.label.sales.selectedcount" default="건수(선택)"/>',						            		
				width: 160,
				labelWidth: 100,
				name: 'COUNT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			}]
		}]
	});
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aigd340ukrvGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt : {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				
    				sumTotalAmtI = sumTotalAmtI + selectRecord.get('ALTER_AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
//					var grdRecord = masterGrid.getStore().getAt(rowIndex);
	    			sumTotalAmtI = sumTotalAmtI - selectRecord.get('ALTER_AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
					selDesel = 0;
	    		}
    		}
        }),
        columns:  [ 
        	{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},
			{dataIndex: 'CONV_ALTER_DIVI' 						    , width:86},
			{dataIndex: 'ALTER_DATE' 	 						    , width:86},
			{dataIndex: 'ASST' 			 						    , width:100},
			{dataIndex: 'ASST_NAME' 		 						, width:180},
			{dataIndex: 'ASST_DIVI' 		 						, width:73},
			{dataIndex: 'ACCNT' 			 						, width:86},
			{dataIndex: 'ACCNT_NAME' 	 						    , width:120},
			{dataIndex: 'ACQ_AMT_I' 		 						, width:100},
			{dataIndex: 'ALTER_AMT_I' 	 						    , width:100},
			{dataIndex: 'ALTER_REASON' 	 						    , width:120},
			{dataIndex: 'MONEY_UNIT' 	 						    , width:66},
			{dataIndex: 'EXCHG_RATE_O' 	 						    , width:100},
			{dataIndex: 'FOR_ALTER_AMT_I' 						    , width:100},
			{dataIndex: 'SET_TYPE' 		 						    , width:100},
			{dataIndex: 'PROOF_KIND' 	 						    , width:100},
			{dataIndex: 'SUPPLY_AMT_I' 	 						    , width:100},
			{dataIndex: 'TAX_AMT_I' 		 						, width:100},
			{dataIndex: 'CUSTOM_CODE' 	 						    , width:100},
			{dataIndex: 'CUSTOM_NAME' 	 						    , width:180},
			{dataIndex: 'DIV_CODE' 		 						    , width:86},
			{dataIndex: 'EX_DATE' 		 						    , width:86},
			{dataIndex: 'EX_NUM' 		 						    , width:70 , align : 'right'},
			{dataIndex: 'AGREE_YN' 		 						    , width:80}
        ],
        listeners: {      		
        	beforeedit  : function( editor, e, eOpts ) {
      			return false;
      		}
		}
    });   

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, 
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ addResult ]
				}
			]
		},
			panelSearch  	
		], 	
		id  : 'aigd340ukrvApp',
		fnInitBinding : function(params) {
			panelSearch.getField('FR_DATE').setReadOnly(false);
   			panelSearch.getField('TO_DATE').setReadOnly(false);
   			panelSearch.getField('FR_INSERT_DATE').setReadOnly(false);
   			panelSearch.getField('TO_INSERT_DATE').setReadOnly(false);
   			
   			panelResult.getField('FR_DATE').setReadOnly(false);   
   			panelResult.getField('TO_DATE').setReadOnly(false);   
   			panelResult.getField('FR_INSERT_DATE').setReadOnly(false);
   			panelResult.getField('TO_INSERT_DATE').setReadOnly(false);
   			

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);

			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('WORK_DATE', UniDate.get('today'));
			addResult.setValue('WORK_DATE', UniDate.get('today'));


			addResult.getField('WORK_DIVI').setValue('1');
   			Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.autoslipposting" default="자동기표"/>');
	   		
	   		addResult.setValue('TOT_SELECTED_AMT', 0);
			addResult.setValue('TOT_COUNT', 0); 
	
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);

			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('FR_DATE');	
		},
		onQueryButtonDown : function()	{
			selDesel = 0;
			checkCount = 0;
			sumTotalAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('FR_DATE',		getStDt[0].STDT);
			panelResult.setValue('FR_DATE',		getStDt[0].STDT);
	 		panelSearch.setValue('TO_DATE', 	getStDt[0].TODT);
	 		panelResult.setValue('TO_DATE', 	getStDt[0].TODT);
		},
		selectTabFirst: function() {
			Ext.getCmp('AUTO_CHECK').setText('자동기표');
			Ext.getCmp('AUTO_CHECK2').setText('자동기표');
			panelSearch.setValue('TOTAL_AMT', '0');
			panelResult.setValue('TOTAL_AMT', '0');
			directMasterStore.loadStoreRecords();	
		},
		selectTabSecond: function() {
			Ext.getCmp('AUTO_CHECK').setText('기표취소');
			Ext.getCmp('AUTO_CHECK2').setText('기표취소');
			panelSearch.setValue('TOTAL_AMT', '0');
			panelResult.setValue('TOTAL_AMT', '0');
 			directMasterStore.loadStoreRecords();
		}
	});

	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직									여기할 차례
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();								//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
};


</script>