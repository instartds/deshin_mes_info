<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd121ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A014" />			<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> 		<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M302" />			<!-- 매입유형 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
//조회된 합계, 건수 계산용 변수 선언
var sumAmountTotI = 0;
	sumCheckedCount = 0;
	newYN = 0;

	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd121ukrService.runProcedure',
            syncAll	: 'agd121ukrService.callProcedure'
		}
	});	


	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd121Model', {
	   fields: [
			{name: 'CHOICE'					, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string',	comboType: 'BOR120'},					//코드값으로 명을 가져오게 하는 처리
			{name: 'CHANGE_BASIS_NUM'		, text: '<t:message code="system.label.purchase.purchaseslipno" default="매입전표번호"/>'			, type: 'string'},
			{name: 'BILL_DATE'				, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'				, type: 'uniDate'},
			{name: 'PROOF_KIND'				, text: '<t:message code="system.label.purchase.prooftype" default="증빙구분"/>'				, type: 'string',	comboType: "AU", comboCode: "A022"},
			{name: 'ACCOUNT_TYPE_VW'		, text: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>'				, type: 'string',	comboType: "AU", comboCode: "M302"},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ISSUE_EXPECTED_DATE'	, text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'				, type: 'uniDate'},
			{name: 'AMOUNT_I'				, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'VAT_AMOUNT_O'			, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'AMOUNT_TOT_I'			, text: '<t:message code="system.label.purchase.pruchaseamount" default="매입액"/>'				, type: 'uniPrice'},
			{name: 'BILL_DIV_CODE'			, text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'				, type: 'string',	comboType: 'BOR120'},
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'				, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'				, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'EX_DATE'      			, text: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>'				, type: 'uniDate'},
			{name: 'EX_NUM'			 		, text: '<t:message code="system.label.purchase.slipno" default="전표번호"/>'				, type: 'string'},
			{name: 'AP_STS'					, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'				, type: 'string',	comboType: "AU", comboCode: "A014"},
			{name: 'INSERT_DB_TIME'     	, text: '<t:message code="system.label.purchase.inputdate" default="입력일"/>'				, type: 'string'}
	    ]
	});		// End of Ext.define('Agd121ukrModel', {
	  
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('agd121MasterStore',{
		model: 'Agd121Model',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd121ukrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records.length > 0) {
           			//panelSearch.setReadOnly(true);
           			//panelResult.setReadOnly(true);

   				} else {
		   			//panelSearch.setReadOnly(false);
		   			//panelResult.setReadOnly(false);
		   			panelSearch.getField('PUB_DATE_FR').setReadOnly(false);
		   			panelSearch.getField('PUB_DATE_TO').setReadOnly(false);
		   			panelSearch.getField('INSERT_DATE_FR').setReadOnly(false);
		   			panelSearch.getField('INSERT_DATE_TO').setReadOnly(false);
		   			
		   			panelResult.getField('PUB_DATE_FR').setReadOnly(false);   
		   			panelResult.getField('PUB_DATE_TO').setReadOnly(false);   
		   			panelResult.getField('INSERT_DATE_FR').setReadOnly(false);
		   			panelResult.getField('INSERT_DATE_TO').setReadOnly(false);

           		}
           		
           		//그리드에서 체크되는 항목 갯수와 매출액 합계 구하기
           		var amountTotI = 0;
           		var count = masterGrid.getStore().getCount();  
				Ext.each(records, function(record,i){	
	        		 amountTotI = record.get('AMOUNT_TOT_I') +amountTotI	
		    	}); 
	    		addResult.setValue('TOT_SELECTED_AMT', amountTotI);
				addResult.setValue('TOT_COUNT',count); 
				if(panelSearch.getValue('WORK_DIVI') == 1 || addResult.getValue('WORK_DIVI') == 1){
//           		if(gsConfirmYN == "Y"){
       				Ext.getCmp('procCanc').setText('<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>');
       				Ext.getCmp('procCanc2').setText('<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>');
       			}else {
       				Ext.getCmp('procCanc').setText('<t:message code="system.label.purchase.slipcancel" default="기표취소"/>');
       				Ext.getCmp('procCanc2').setText('<t:message code="system.label.purchase.slipcancel" default="기표취소"/>');
       			}
           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {},
           	remove: function(store, record, index, isMove, eOpts) {}*/
		}/*,
		groupField: 'ITEM_NAME'*/
	});

    var buttonStore = Unilite.createStore('Agd121UkrButtonStore',{      
        uniOpt: {
            isMaster	: false,			// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
            useNavi		: false				// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var paramMaster				= panelSearch.getValues();
			paramMaster.OPR_FLAG		= buttonFlag;
			paramMaster.EXPECTED_DATE	= addResult.getValue('ISSUE_EXPECTED_DATE');				//지급예정일
			paramMaster.PUB_DATE		= Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;		//전표일 생성옵션
			paramMaster.WORK_DATE		= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));	//실행일
			paramMaster.SYS_DATE		= UniDate.getDbDateStr(UniDate.get('today'));				//시스템일자
            paramMaster.LANG_TYPE		= UserInfo.userLang
			paramMaster.CALL_PATH		= 'LIST';													//호출경로(Batch, List)

            
            if(inValidRecs.length == 0) {
                config = {
					params	: [paramMaster],
                    success : function(batch, option) {
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
                var grid = Ext.getCmp('agd121Grid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
	
	
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
//	        	addResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
//	        	addResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'PUB_DATE_FR',
	            endFieldName: 'PUB_DATE_TO',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,                	
				autoPopup: true,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('PUB_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PUB_DATE_TO', newValue);				    		
			    	}
			    }
	     	},{
				fieldLabel: '<t:message code="system.label.purchase.inputdate" default="입력일"/>',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'INSERT_DATE_FR',
	            endFieldName: 'INSERT_DATE_TO',
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
	     	},{ 
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},{
            	fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>',
            	name: 'ACCOUNT_TYPE',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'M302',
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('ACCOUNT_TYPE', newValue);
			    	}
	     		}
			},		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'CUSTOM_CODE_FR',
			    textFieldName:'CUSTOM_NAME_FR',
			  	colspan: 2,  
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME_FR', newValue);				
					},						
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_FR', panelSearch.getValue('CUSTOM_CODE_FR'));
							panelResult.setValue('CUSTOM_NAME_FR', panelSearch.getValue('CUSTOM_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_FR', '');
						panelResult.setValue('CUSTOM_NAME_FR', '');
					}
				}
		    }),		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '~',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'CUSTOM_CODE_TO',
			    textFieldName:'CUSTOM_NAME_TO',
			  	colspan: 2,  
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME_TO', newValue);				
					},						
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_TO', '');
						panelResult.setValue('CUSTOM_NAME_TO', '');
					}
				}
		    }),
				Unilite.popup('ACCNT_PRSN',{ 
				    fieldLabel: '<t:message code="system.label.purchase.accntperson" default="입력자"/>', 
				    validateBlank: true, 
				    popupWidth: 890,  
					valueFieldName:'CHARGE_CODE',
					textFieldName:'CHARGE_NAME',
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
				    fieldLabel: '<t:message code="system.label.purchase.inputdepartment" default="입력부서"/>', 
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
			}),{
				xtype: 'container',
				layout : {type : 'uniTable'},
				items:[{
					fieldLabel: '<t:message code="system.label.purchase.exslipapproveyn" default="결의전표승인여부"/>',
	            	name: 'AP_STS',
	            	xtype: 'uniCombobox',
	            	comboType: 'AU',
	            	comboCode: 'A014',
			 		tdAttrs: {align: 'right'},
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				    	panelResult.setValue('AP_STS', newValue);
				    	}
		     		}
				}]
			}]
		},{
			title: '<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
	        hidden: true,
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
	            xtype: 'uniDatefield',
			 	name: 'ISSUE_EXPECTED_DATE',
//			 	allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						addResult.setValue('ISSUE_EXPECTED_DATE', newValue);
					}
				}
	     	},{
				padding:'0 0 0 25',
				xtype:'component',
				width: 300,
				html: '※'+'<t:message code="system.label.purchase.explanation" default="전표의 관리항목 정보 생성에 사용됩니다."/>',
				style: {
					color: 'blue'				
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.executedate" default="실행일"/>',
	            xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
				readOnly:true,
			 	allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						addResult.setValue('WORK_DATE', newValue);
					}
				}
	     	},{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',						            		
				id: 'rdoSelect2',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>', 
					width: 70, 
					name: 'PUB_DATE',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.purchase.executedate" default="실행일"/>', 
					width: 70,
					name: 'PUB_DATE',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(panelSearch.getValue('PUB_DATE') == '1'){
							panelSearch.getField('WORK_DATE').setReadOnly(true);
							addResult.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}else{
							panelSearch.getField('WORK_DATE').setReadOnly(false);
							addResult.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}
					}
				}
			},{
				xtype: 'uniRadiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.worktype" default="작업구분"/>',						            		
				id: 'rdoSelect3',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>', 
					width: 70, 
					name: 'WORK_DIVI',
    				inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.purchase.slipcancel" default="기표취소"/>', 
					width: 70,
					name: 'WORK_DIVI',
    				inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						addResult.getField('WORK_DIVI').setValue(newValue.WORK_DIVI);

						/*if(Ext.getCmp('rdoSelect3').getChecked()[0].inputValue == '1'){
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
						}		
						if(Ext.getCmp('rdoSelect3').getChecked()[0].inputValue == '2'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
						}
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							UniAppManager.app.onQueryButtonDown();	
						}*/
					}
				}
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				items:[{				   
						xtype: 'button',
						name: 'CONFIRM_CHECK',
						id: 'procCanc',
						text: '<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>',
						width: 100,
			    		margin: '0 0 0 120',	
						handler : function() {
							//if(panelSearch.setAllFieldsReadOnly(true)){
								//자동기표일 때 SP 호출
								if(addResult.getValue('COUNT') != 0){  
									if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
											var param = panelSearch.getValues();
											panelSearch.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
											agd121ukrService.procButton(param, 
												function(provider, response) {
													if(provider) {	
														UniAppManager.updateStatus('<t:message code="system.message.purchase.message086" default="자동기표가 완료 되었습니다."/>');
													}
													console.log("response",response)
													panelSearch.getEl().unmask();
												}
											)
										//return panelSearch.setAllFieldsReadOnly(true);
									}
									//기표취소일 때 SP 호출
									if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
											var param = panelSearch.getValues();
											panelSearch.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
											agd121ukrService.cancButton(param, 
												function(provider, response) {
													if(provider) {	
														UniAppManager.updateStatus('<t:message code="system.message.purchase.message087" default="취소 되었습니다."/>');
													}
													console.log("response",response)
													panelSearch.getEl().unmask();
												}
											)
											//return panelSearch.setAllFieldsReadOnly(true);
									}
								}else {
									UniAppManager.updateStatus('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
								}
							//}
						}
					}
				]
			}]
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'PUB_DATE_FR',
	            endFieldName: 'PUB_DATE_TO',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,                	
				autoPopup: true,
	            tdAttrs: {width: 380},    
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('PUB_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('PUB_DATE_TO', newValue);				    		
			    	}
			    }
	     	},		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'CUSTOM_CODE_FR',
			    textFieldName:'CUSTOM_NAME_FR',
			    colspan: 2, 
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME_FR', newValue);				
					},						
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
							panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE_FR', '');
						panelSearch.setValue('CUSTOM_NAME_FR', '');
					}
				}
		    }),{
				fieldLabel: '<t:message code="system.label.purchase.inputdate" default="입력일"/>',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'INSERT_DATE_FR',
	            endFieldName: 'INSERT_DATE_TO',
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
	        	Unilite.popup('CUST',{
		        fieldLabel: '~',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'CUSTOM_CODE_TO',
			    textFieldName:'CUSTOM_NAME_TO',  
			    colspan: 2, 
			    listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME_TO', newValue);				
					},			    	
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
							panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE_TO', '');
						panelSearch.setValue('CUSTOM_NAME_TO', '');
					}
				}
		    }),{ 
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},
				Unilite.popup('ACCNT_PRSN',{ 
				    fieldLabel: '<t:message code="system.label.purchase.accntperson" default="입력자"/>', 
				    validateBlank: true, 
				    popupWidth: 890,  
					valueFieldName:'CHARGE_CODE',
					textFieldName:'CHARGE_NAME',
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
            	fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>',
            	name: 'ACCOUNT_TYPE',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'M302',
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('ACCOUNT_TYPE', newValue);
			    	}
	     		}
			},
				Unilite.popup('DEPT',{ 
				    fieldLabel: '<t:message code="system.label.purchase.inputdepartment" default="입력부서"/>', 
				    validateBlank: true, 
				    popupWidth: 890,  
					valueFieldName:'DEPT_CODE',
					textFieldName:'DEPT_NAME',
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
				xtype: 'container',
				layout : {type : 'uniTable'},
				items:[{
					fieldLabel: '<t:message code="system.label.purchase.exslipapproveyn" default="결의전표승인여부"/>',
	            	name: 'AP_STS',
	            	xtype: 'uniCombobox',
	            	comboType: 'AU',
	            	comboCode: 'A014',
			 		tdAttrs: {align: 'right'},
			 		labelWidth:150,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				    	panelSearch.setValue('AP_STS', newValue);
				    	}
		     		}
				}]
			}
		]
	});

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3, tdAttrs: {width: '100%'}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
/*		저장 버튼 사용 안 함, 자동기표 / 취소 버튼 사용		
 		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		},*/
		items: [{
			xtype: 'container',
			width: 500,
			colspan: 3,
			layout: {
				type: 'hbox'
			},
	    	items:[{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
		        xtype: 'uniDatefield',
		 		name: 'ISSUE_EXPECTED_DATE',
//		        allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ISSUE_EXPECTED_DATE', newValue);
					}
				}
		     },{
				padding:'5 0 4 10',
				xtype:'component',
				width: 300,
				html: '※' + '<t:message code="system.label.purchase.explanation" default="전표의 관리항목 정보 생성에 사용됩니다."/>',
				style: {
					color: 'blue'				
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 380},
	    	items:[{
				fieldLabel: '<t:message code="system.label.purchase.executedate" default="실행일"/>',
	            xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
				readOnly:true,
			 	allowBlank:false,
			 	width:220,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_DATE', newValue);
					}
				}
	     	},{
				xtype: 'radiogroup',		            		
				fieldLabel: '',						            		
				id: 'rdoSelect1',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>', 
					width: 70, 
					name: 'PUB_DATE',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.purchase.executedate" default="실행일"/>', 
					width: 70,
					name: 'PUB_DATE',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(addResult.getValue('PUB_DATE') == '1'){
							addResult.getField('WORK_DATE').setReadOnly(true);
							panelSearch.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}else{
							addResult.getField('WORK_DATE').setReadOnly(false);
							panelSearch.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}
					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
	    	items:[{
	    		xtype: 'uniRadiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.worktype" default="작업구분"/>',						            		
				id: 'rdoSelect4',
				tdAttrs: {align: 'left'},
				items: [{
					boxLabel: '<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>', 
					width: 90, 
					name: 'WORK_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.purchase.slipcancel" default="기표취소"/>', 
					width: 90,
					name: 'WORK_DIVI',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('WORK_DIVI').setValue(newValue.WORK_DIVI);

						if(newValue.WORK_DIVI == '1'){
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
						}		
						if(newValue.WORK_DIVI  == '2'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
						}
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
						}
					
						
						
						
/*						필수체크 팝업 2번 발생하여 주석처리
						if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
						}		
						if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
						}
						UniAppManager.app.onQueryButtonDown();*/
					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {align: 'right'},
			items:[{				   
				xtype: 'button',
				name: 'CONFIRM_CHECK',
				id: 'procCanc2',
				text: '<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>',
				width: 100,
		 		tdAttrs: {align: 'right'},
				handler : function() {
					//if(panelSearch.setAllFieldsReadOnly(true)){
						if(addResult.getValue('COUNT') != 0){  
							//자동기표일 때 SP 호출
							if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
					            var buttonFlag = 'N';
					            fnMakeLogTable(buttonFlag);
								//return panelSearch.setAllFieldsReadOnly(true);
							}
							//기표취소일 때 SP 호출
							if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
					            var buttonFlag = 'D';
					            fnMakeLogTable(buttonFlag);
								//return panelSearch.setAllFieldsReadOnly(true);
							}
						}else {
							alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
							return false;
						}
					//}
				}
			}]
		}/*,{
			//컬럼 맞춤용
			xtype: 'component'
		}*/,{
			xtype: 'container',
			layout : {type : 'uniTable', columns : 6, tdAttrs: {width: '100%'}},
			colspan: 3,
	    	items:[{
    			xtype: 'component'
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '<t:message code="system.label.purchase.totalamount" default="합계"/>(<t:message code="system.label.purchase.inquiry" default="조회"/>)',						            		
				width: 200,
//				labelWidth: 60,
				name: 'TOT_SELECTED_AMT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '<t:message code="system.label.purchase.selected" default="건수"/>(<t:message code="system.label.purchase.inquiry" default="조회"/>)',						            		
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
				fieldLabel: '<t:message code="system.label.purchase.totalamount" default="합계"/>(<t:message code="system.label.purchase.selection" default="선택"/>)',						            		
				width: 200,
				labelWidth: 60,
				name: 'SELECTED_AMT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '<t:message code="system.label.purchase.selected" default="건수"/>(<t:message code="system.label.purchase.selection" default="선택"/>)',						            		
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
    var masterGrid = Unilite.createGrid('agd121Grid1', {
    	layout : 'fit',
        region : 'center',
		store: MasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		//그리드 체크박스
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false  }),
    	uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
        columns: [    
        	{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},
			{dataIndex: 'DIV_CODE'				, width: 100/*,	locked: true*/}, 				
			{dataIndex: 'CHANGE_BASIS_NUM'		, width: 120/*,	locked: true*/}, 				
			{dataIndex: 'BILL_DATE'				, width: 80/*,	locked: true*/}, 				
			{dataIndex: 'PROOF_KIND'			, width: 100}, 				
			{dataIndex: 'ACCOUNT_TYPE_VW'		, width: 100}, 				
			{dataIndex: 'CUSTOM_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 180}, 				
			{dataIndex: 'ISSUE_EXPECTED_DATE'	, width: 80}, 				
			{dataIndex: 'AMOUNT_I'				, width: 100}, 				
			{dataIndex: 'VAT_AMOUNT_O'			, width: 80}, 				
			{dataIndex: 'AMOUNT_TOT_I'			, width: 100}, 				
			{dataIndex: 'BILL_DIV_CODE'			, width: 130}, 				
			{dataIndex: 'DEPT_CODE'				, width: 80}, 				
			{dataIndex: 'DEPT_NAME'				, width: 80}, 				
			{dataIndex: 'REMARK'				, width: 333}, 				
			{dataIndex: 'EX_DATE'      			, width: 80}, 				
			{dataIndex: 'EX_NUM'			 	, width: 70},
			{dataIndex: 'AP_STS'			 	, width: 70}, 				
			{dataIndex: 'INSERT_DB_TIME'     	, width: 126}
		],
		listeners: {
/*			//승인된 전표는 체크할 수 없도록 처리(기표 취소)
			beforeselect: function(rowSelection, record, index, eOpts) {
        		if(record.get('AP_STS') == '2'){
    				return false;
    			}else{
    				return true;
    			}
        	},*/
			select: function(grid, record, index, rowIndex, eOpts ){
    				sumAmountTotI = sumAmountTotI + record.get('AMOUNT_TOT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumAmountTotI)
	    			addResult.setValue('COUNT', sumCheckedCount)
          	},
			deselect:  function(grid, record, index, rowIndex, eOpts ){
				sumAmountTotI = sumAmountTotI - record.get('AMOUNT_TOT_I');
				sumCheckedCount = sumCheckedCount - 1;
    			addResult.setValue('SELECTED_AMT', sumAmountTotI)
    			addResult.setValue('COUNT', sumCheckedCount)
    		}
		}
    });    
    
    
    
	Unilite.Main( {
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
		id : 'agd121App',
		fnInitBinding : function() {
   			//panelSearch.setReadOnly(false);
   			//panelResult.setReadOnly(false);
   			panelSearch.getField('PUB_DATE_FR').setReadOnly(false);
   			panelSearch.getField('PUB_DATE_TO').setReadOnly(false);
   			panelSearch.getField('INSERT_DATE_FR').setReadOnly(false);
   			panelSearch.getField('INSERT_DATE_TO').setReadOnly(false);
   			
   			panelResult.getField('PUB_DATE_FR').setReadOnly(false);   
   			panelResult.getField('PUB_DATE_TO').setReadOnly(false);   
   			panelResult.getField('INSERT_DATE_FR').setReadOnly(false);
   			panelResult.getField('INSERT_DATE_TO').setReadOnly(false);
   			

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//공통코드(S024)에서 부가세 유형콤보 첫번째 값 가져오기
      		var billTypeSelect = Ext.data.StoreManager.lookup('CBS_AU_M302').getAt(0).get('value');
			panelSearch.setValue('ACCOUNT_TYPE', billTypeSelect);
			
			panelSearch.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('PUB_DATE_TO', UniDate.get('today'));
			panelResult.setValue('PUB_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('WORK_DATE', UniDate.get('today'));
			addResult.setValue('WORK_DATE', UniDate.get('today'));

			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);
	
			panelSearch.getField('PUB_DATE').setValue('1');
			addResult.getField('PUB_DATE').setValue('1');

			panelSearch.getField('WORK_DIVI').setValue('1');
			addResult.getField('WORK_DIVI').setValue('1');
			Ext.getCmp('procCanc').setText('<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>');
   			Ext.getCmp('procCanc2').setText('<t:message code="system.label.purchase.autoslipposting" default="자동기표"/>');
			
	   		panelSearch.setValue('TOT_SELECTED_AMT', 0);
			panelSearch.setValue('TOT_COUNT', 0); 
	   		addResult.setValue('TOT_SELECTED_AMT', 0);
			addResult.setValue('TOT_COUNT', 0); 
	
			panelSearch.setValue('SELECTED_AMT',0);
			panelSearch.setValue('COUNT',0);
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
			activeSForm.onLoadSelectText('PUB_DATE_FR');		
		},
		onQueryButtonDown : function()	{	
/*			//조회 시에는 지급예정일 필수체크 하지 않음
			panelSearch.getField('ISSUE_EXPECTED_DATE').allowBlank = true;
			addResult.getField('ISSUE_EXPECTED_DATE').allowBlank = true;*/
			//if(panelSearch.setAllFieldsReadOnly(true)){
				sumSaleTaxAmtI = 0;
				sumCheckedCount = 0;
				panelSearch.setValue('SELECTED_AMT',0);
				panelSearch.setValue('COUNT',0);
				addResult.setValue('SELECTED_AMT',0);
				addResult.setValue('COUNT',0);
				MasterStore.loadStoreRecords();
			/*}else{
				return false;
			}*/
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.reset();
			MasterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});


	
	
	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
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
