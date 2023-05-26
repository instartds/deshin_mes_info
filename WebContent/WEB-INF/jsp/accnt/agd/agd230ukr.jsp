<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd230ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 --> 
	<t:ExtComboStore comboType="A" comboCode="A118" /> 				<!-- 소득구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A014"/>
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var sumTotalAmtI = 0
  , sumCheckedCount = 0
  , newYN = 'N';

function appMain() {
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd230ukrService.insertDetailAutoSign',
            syncAll	: 'agd230ukrService.saveAllAutoSign'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd230ukrModel1', {
		fields: [
	    	{name: 'PERSON_NUMB'	 			,text: '소득자' 			,type: 'string'  },
	    	{name: 'PERSON_NAME'	 			,text: '소득자명' 			,type: 'string'  },
	    	{name: 'PAY_YYYYMM'		 			,text: '지급년월' 			,type: 'string'  },
	    	{name: 'SUPP_DATE'		 			,text: '지급일자' 			,type: 'uniDate' },
	    	{name: 'P_PAY_YYYYMM'	 			,text: '귀속년월' 			,type: 'string'  },
	    	{name: 'P_SUPP_DATE'	 			,text: '지급일' 			,type: 'uniDate' },
	    	{name: 'DED_TYPE'		 			,text: '소득구분' 			,type: 'string'  	, comboType: "AU"		, comboCode: "A118"},
	    	{name: 'DED_TYPE_NM'		 		,text: '소득코드명' 		,type: 'string'  },
	    	{name: 'DED_CODE'		 			,text: '기타소득구분'		,type: 'string'  },
	    	{name: 'DED_NAME'		 			,text: '기타소득구분명'		,type: 'string'  },
	    	{name: 'SUPPLY_AMT_I'	 			,text: '소득금액' 			,type: 'uniPrice'},
	    	{name: 'IN_TAX_I'		 			,text: '소득세' 			,type: 'uniPrice'},
	    	{name: 'LOCAL_TAX_I'	 			,text: '주민세' 			,type: 'uniPrice'},
	    	{name: 'CP_TAX_I'		 			,text: '법인세' 			,type: 'uniPrice'},
	    	{name: 'PAY_AMOUNT_I'	 			,text: '지급금액' 			,type: 'uniPrice'},
	    	{name: 'DEPT_CODE'		 			,text: '비용집행부서' 	    ,type: 'string'  },
	    	{name: 'DEPT_NAME'		 			,text: '비용집행부서명' 		,type: 'string'  },
	    	{name: 'PJT_CODE'		 			,text: '사업코드' 			,type: 'string'  },
	    	{name: 'PJT_NAME'		 			,text: '사업명' 			,type: 'string'  },
	    	{name: 'PROJECT_CODE'		 			,text: '프로젝트' 			,type: 'string'  },
	    	{name: 'PROJECT_NAME'		 			,text: '프로젝트명' 			,type: 'string'  },
	    	{name: 'REMARK'			 			,text: '적요' 			,type: 'string'  },
	    	{name: 'EX_DATE'		 			,text: '결의일' 		    ,type: 'uniDate' },
	    	{name: 'EX_NUM'			 			,text: '결의번호' 			,type: 'int'     , defaultValue : null},
	    	{name: 'AP_STS'			 			,text: '승인여부' 			,type: 'string'	 ,comboType:"AU" ,comboCode:"A014"},
	    	{name: 'EXEDEPT_NAME'				,text: '비용집행부서명' 		,type: 'string'	 },
	    	{name: 'SEQ'						,text: '순번' 			,type: 'int'	 }
		]
	});
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agd230ukrdirectMasterStore',{
		model	: 'Agd230ukrModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type: 'direct',
            api	: {			
            	   read: 'agd230ukrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			//var param= Ext.getCmp('searchForm').getValues();
			var param = Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());			
			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records.length == 0) {
		   			panelSearch.getField('SUPP_DATE_FR').setReadOnly(false);
		   			panelSearch.getField('SUPP_DATE_TO').setReadOnly(false);
		   			panelSearch.getField('INSERT_DATE_FR').setReadOnly(false);
		   			panelSearch.getField('INSERT_DATE_TO').setReadOnly(false);
		   			
		   			panelResult.getField('SUPP_DATE_FR').setReadOnly(false);   
		   			panelResult.getField('SUPP_DATE_TO').setReadOnly(false);   
		   			panelResult.getField('INSERT_DATE_FR').setReadOnly(false);
		   			panelResult.getField('INSERT_DATE_TO').setReadOnly(false);

           		}
           		
           		//조회되는 항목 갯수와 매출액 합계 구하기
           		var totalAmtI = 0;
           		var count = detailGrid.getStore().getCount();  
				Ext.each(records, function(record, i){	
					totalAmtI = record.get('SUPPLY_AMT_I') + totalAmtI	
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

    var buttonStore = Unilite.createStore('Agd230UkrButtonStore',{      
        uniOpt	: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,      		// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy	: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            
            var paramMaster = panelResult.getValues();  //syncAll 수정
            paramMaster.SUPP_DATE_FR = UniDate.getDbDateStr(panelResult.getValue('SUPP_DATE_FR'));
            paramMaster.SUPP_DATE_TO = UniDate.getDbDateStr(panelResult.getValue('SUPP_DATE_TO'));
            
            var paramMaster			= panelSearch.getValues();
			Ext.Object.merge(paramMaster, addResult.getValues());
			paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.CALL_PATH	= 'LIST';	
            
            if(inValidRecs.length == 0) {
            	if(addResult.getValues().DATE_OPTION == '1' 
						&& addResult.getValues().WORK_DIVI == "1" 
						&& addResult.getValues().PROC_TYPE == "2"  ) {
					if(!checkExtDate())	{
						return false
					}
				}
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
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
                var grid = Ext.getCmp('agd230ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });
    
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items	: [{ 
    			fieldLabel	: '지급일',
		        xtype		: 'uniDateRangefield',
		        startFieldName	: 'SUPP_DATE_FR',
		        endFieldName	: 'SUPP_DATE_TO',
//		        width: 470,
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SUPP_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SUPP_DATE_TO',newValue);
			    	}
			    }
			},
		    Unilite.popup('EARNER',{
		        fieldLabel		: '소득자',
		        validateBlank	: false,
			    valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'PERSON_NAME',
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NAME', newValue);				
					}
				}
			}),{
				fieldLabel	: '소득구분',
				name		: 'DED_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A118',   
				
//				allowBlank  : false,
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DED_TYPE', newValue);
			    	}
	     		}
				//value: '1'
			},
			Unilite.treePopup('PJT_TREE',{ 
		    	fieldLabel		: '사업코드',
		    	valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				valuesName		: 'DEPTS' ,
				selectChildren	: true,
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				autoPopup		: true,
				useLike			: false,
		    	listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelResult.setValue('PJT_CODE',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelResult.setValue('PJT_NAME',newValue);
					},
	                'onValuesChange':  function( field, records){
                    	var tagfield = panelResult.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				fieldLabel	: '입력일',
	            xtype		: 'uniDateRangefield',
	            startFieldName	: 'INSERT_DATE_FR',
	            endFieldName	: 'INSERT_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('INSERT_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INSERT_DATE_TO', newValue);				    		
			    	}
			    }
	     	},
			Unilite.popup('ACCNT_PRSN',{ 
			    fieldLabel		: '입력자', 
				valueFieldName	: 'CHARGE_CODE',
				textFieldName	: 'CHARGE_NAME',
			    validateBlank	: false, 
				listeners:		 {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_NAME', newValue);				
					}
				}
			}),{
	     		fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				multiSelect	: true, 
				typeAhead	: false,
				listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			}]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 2	
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '지급일',
// 		    width: 315,
	        xtype		: 'uniDateRangefield',
	        startFieldName	: 'SUPP_DATE_FR',
	        endFieldName	: 'SUPP_DATE_TO',
	        startDate	: UniDate.get('startOfMonth'),
	        endDate		: UniDate.get('today'),
	        allowBlank	: false,
            tdAttrs		: {width: 380},    
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SUPP_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SUPP_DATE_TO',newValue);
		    	}
		    }
        },
	    Unilite.popup('EARNER',{
	        fieldLabel	: '소득자',
		    valueFieldName	:'PERSON_NUMB',
		    textFieldName	:'PERSON_NAME',
		    tdAttrs		: {width: 380},  
	        validateBlank:false,  
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NAME', newValue);				
				}
			}
		}),{
			fieldLabel	: '소득구분',
			name		: 'DED_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'A',
			comboCode	: 'A118',   
//			allowBlank   : false,
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DED_TYPE', newValue);
		    	}
     		}
			//value: '1'
		},
		Unilite.treePopup('PJT_TREE',{ 
	    	fieldLabel		: '사업코드',
	    	valueFieldName	: 'PJT_CODE',
			textFieldName	: 'PJT_NAME',
			valuesName		: 'DEPTS' ,
			selectChildren	: true,
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			autoPopup		: true,
			useLike			: false,
	    	listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('PJT_CODE',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('PJT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel	: '입력일',
            xtype		: 'uniDateRangefield',
            startFieldName	: 'INSERT_DATE_FR',
            endFieldName	: 'INSERT_DATE_TO',
            tdAttrs		: {width: 380},    
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INSERT_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INSERT_DATE_TO', newValue);				    		
		    	}
		    }
     	},
		Unilite.popup('ACCNT_PRSN',{ 
		    fieldLabel: '입력자', 
		    validateBlank: false, 
			valueFieldName:'CHARGE_CODE',
			textFieldName:'CHARGE_NAME',
        	tdAttrs: {width: 380},    
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CHARGE_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CHARGE_NAME', newValue);				
				}
			}
		}),{
			xtype		: 'component'								//panel 모양 맞춤용
		},{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
            tdAttrs		: {width: 380}, 
			multiSelect	: true, 
			typeAhead	: false,   
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		}]
    });  

    
    var addResult = Unilite.createForm('detailForm', {   //createForm
        layout: {type : 'uniTable', columns : 3, tableAttrs:{width:'100%'},tdAttrs: {width: '100%'}},
        disabled: false,
        border: true,
        padding: '1 1 1 1',
        region: 'north',
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 380},    
            items:[{
                fieldLabel: '실행일',
                xtype: 'uniDatefield',
                name: 'WORK_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                width:220
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '',                                         
                id: 'rdoSelect1',
                items: [{
                    boxLabel: '지급일', 
                    width: 70, 
                    name: 'DATE_OPTION',
                    inputValue: '1'
                },{
                    boxLabel : '실행일', 
                    width: 70,
                    name: 'DATE_OPTION',
                    inputValue: '2',
                    checked: true  
                }],
                listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
						if(field.getValue().DATE_OPTION == '1' 
								&& addResult.getValues().WORK_DIVI == "1" 
								&& addResult.getValues().PROC_TYPE == "2"  ) {
							if(!checkExtDate())	{
								setTimeout(function() {addResult.setValue("DATE_OPTION", "2")}, 100);
								return false
							}
						}
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
						if(field.getValue().DATE_OPTION == '1' 
							&& addResult.getValue("WORK_DIVI").WORK_DIVI == "1" 
							&& addResult.getValue("PROC_TYPE").PROC_TYPE == "2"  ) {
							if(!checkExtDate())	{
								setTimeout(function(){addResult.setValue("DATE_OPTION", "2")}, 100);
								return false;
							}
						}
						
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
						}	

					}
				}
			},{
	    		xtype: 'uniRadiogroup',		            		
				fieldLabel: '전표생성',						            		
				id: 'rdoSelect3',
				tdAttrs: {align: 'left'},
				items: [{
					boxLabel: '건별로 전표 생성', 
					width: 120, 
					name: 'PROC_TYPE',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '동일 전표로 생성', 
					width: 120,
					name: 'PROC_TYPE',
	    			inputValue: '2'
				}],
				listeners : {
					change : function(field, newValue, oldValue,  eOpts) {	
						if(newValue.PROC_TYPE == '2' 
								&& addResult.getValues().WORK_DIVI == "1" 
								&& addResult.getValues().DATE_OPTION == "1"  ) {
							if(!checkExtDate())	{
								setTimeout(function() {addResult.setValue("PROC_TYPE", "1")}, 100);
								return false;
							}
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
				fieldLabel: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',						            		
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
				fieldLabel: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.selection" default="선택"/>)'	,						            		
				width: 200,
				labelWidth: 60,
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
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var detailGrid = Unilite.createGrid('agd230ukrGrid', {  	
    	store	: directMasterStore,
        layout	: 'fit',
        region	: 'center',
    	excelTitle: '기타소득자동기표(자동기표)',
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
    			beforeselect : function(grid, selectRecord, index, eOpts ) {
    				if(addResult.getValues().PROC_TYPE == "2" && addResult.getValues().DATE_OPTION == "1") {
	    				var acqDate =  UniDate.getDbDateStr(selectRecord.get('P_SUPP_DATE')); 
	    				grid.chk = true;
	    				Ext.each(detailGrid.getSelectedRecords(), function(record, idx){
							if(acqDate != UniDate.getDbDateStr(record.get('P_SUPP_DATE')))	{
								grid.chk = false;
							}
						});
	    				if(!grid.chk){
	    					//전체선택시 메세지 여러번 뜨지 않도록 setTimeout 으로 설정)
	    					setTimeout(function() {
	    						if(!grid.chk){
	    							grid.chk = true;
	    							Unilite.messageBox("동일 전표로 생성하기 위해서는 같은 지급일의 항목을 선택해야 합니다.");
	    						}
	    					}, 1000);
	    					
	    				}
	    				return grid.chk;
    				}
    				return true;
    			},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				
    				sumTotalAmtI = sumTotalAmtI + selectRecord.get('SUPPLY_AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumTotalAmtI = sumTotalAmtI - selectRecord.get('SUPPLY_AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
					selDesel = 0;
	    		}
    		}
        }),
        columns:  [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
			{ dataIndex: 'DED_TYPE'			, width:70},
			{ dataIndex: 'DED_TYPE_NM'		, width:100		, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width:60 },
			{ dataIndex: 'PERSON_NAME'		, width:70},
			{ dataIndex: 'PAY_YYYYMM'		, width:66		, hidden: true},
			{ dataIndex: 'SUPP_DATE'		, width:66		, hidden: true},
			{ dataIndex: 'P_PAY_YYYYMM'		, width:66 , align : 'center'},
			{ dataIndex: 'P_SUPP_DATE'		, width:86 },
			{ dataIndex: 'SUPPLY_AMT_I'		, width:80},
			{ dataIndex: 'IN_TAX_I'			, width:60 },
			{ dataIndex: 'LOCAL_TAX_I'		, width:60 },
			{ dataIndex: 'CP_TAX_I'			, width:60 },
			{ dataIndex: 'PAY_AMOUNT_I'		, width:90},
			{ dataIndex: 'DEPT_CODE'		, width:100 },
			{ dataIndex: 'DEPT_NAME'		, width:110},
			{ dataIndex: 'DED_CODE'			, width:90},
			{ dataIndex: 'DED_NAME'			, width:100},
			{ dataIndex: 'PROJECT_CODE'			, width:80 },
			{ dataIndex: 'PROJECT_NAME'			, width:110},
			{ dataIndex: 'REMARK'			, width:110},
			{ dataIndex: 'EX_DATE'			, width:80 },
			{ dataIndex: 'EX_NUM'			, width:70 },
			{ dataIndex: 'AP_STS'			, width:80 },
			{ dataIndex: 'EXEDEPT_NAME'		, width:110		, hidden: true} 
		] 
    });   
	
    function checkExtDate()	{
		var chk = true;
		var selectRecords = detailGrid.getSelectedRecords();
		if(selectRecords && selectRecords.length > 0)	{
			var acqDate =  UniDate.getDbDateStr(selectRecords[0].get('P_SUPP_DATE')); 
			Ext.each(detailGrid.getSelectedRecords(), function(record, idx){
				if(acqDate != UniDate.getDbDateStr(record.get('P_SUPP_DATE')))	{
					chk = false;
				}
			});
			if(!chk){
				Unilite.messageBox("동일 전표로 생성하기 위해서는 같은 지급일의 항목을 선택해야 합니다.");
			}
		}
		return 	chk;
	}
    
    Unilite.Main( {
    	borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, 
                detailGrid, 
                {
					region : 'north',
					xtype : 'container',
					layout : 'fit',
					items : [ addResult ]
				}
            ]
        },
            panelSearch
        ], 
        id  : 'agd230ukrApp',
		fnInitBinding : function() {
			//각 기본값 설정
			panelSearch.getField('SUPP_DATE_FR').setReadOnly(false);
   			panelSearch.getField('SUPP_DATE_TO').setReadOnly(false);
   			panelSearch.getField('INSERT_DATE_FR').setReadOnly(false);
   			panelSearch.getField('INSERT_DATE_TO').setReadOnly(false);
   			
   			panelResult.getField('SUPP_DATE_FR').setReadOnly(false);   
   			panelResult.getField('SUPP_DATE_TO').setReadOnly(false);   
   			panelResult.getField('INSERT_DATE_FR').setReadOnly(false);
   			panelResult.getField('INSERT_DATE_TO').setReadOnly(false);
   			
   			
			panelSearch.setValue('SUPP_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('SUPP_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelResult.setValue('SUPP_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('SUPP_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			addResult.setValue('WORK_DATE', UniDate.get('today'));
			addResult.getField('WORK_DIVI').setValue('1');
            
			Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.autoslipposting" default="자동기표"/>');
	   		
	   		addResult.setValue('TOT_SELECTED_AMT', 0);
			addResult.setValue('TOT_COUNT', 0); 
	
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			
			//toolbar button 설정
			UniAppManager.setToolbarButtons(['newData', 'save', 'delete', 'detail'], false);

			//화면 초기화 시 포커스 설정
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('SUPP_DATE_FR');		
			newYN = 'N';	
		},
		
		onQueryButtonDown : function()	{	
			
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
			addResult.clearForm();
			detailGrid.reset();
			directMasterStore.clearData();
			newYN = 'Y';
			this.fnInitBinding();
		}
	});
	
    function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = detailGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;							//자동기표 flag
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
};
</script>
