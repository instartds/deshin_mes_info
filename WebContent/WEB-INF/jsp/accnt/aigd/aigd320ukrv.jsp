<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aigd320ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!-- 결제유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙구분-->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 전표승인여부-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var gsChargeCode = '${getChargeCode}';	
	
	var sumTotalAmtI = 0;
	sumCheckedCount = 0;
	newYN = 0;
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create  : 'aigd320ukrvService.runProcedure',
            syncAll : 'aigd320ukrvService.callProcedure'
        }
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aigd320ukrvModel', {
	    fields: [  	  
	    	{name: 'CHOICE'        		, text: '선택' 			,type: 'boolean'},
		    {name: 'COMP_CODE'			, text: '법인코드'			,type: 'string'},
		    {name: 'DIV_CODE'			, text: '사업장' 			,type: 'string', comboType:'BOR120'},
		    {name: 'ASST'	        	, text: '자산코드' 		,type: 'string'},
		    {name: 'ASST_NAME'     		, text: '자산명' 			,type: 'string'},
		    {name: 'ACQ_DATE'			, text: '취득일' 			,type: 'uniDate'},
		    {name: 'ACCNT'		    	, text: '계정과목' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정명' 			,type: 'string'},
		    {name: 'ACQ_AMT_I'			, text: '취득가액' 		,type: 'uniPrice'},
		    {name: 'SET_TYPE'	    	, text: '결제유형' 		,type: 'string', comboType: 'AU',  comboCode: 'A140'},
		    {name: 'PROOF_KIND'			, text: '증빙유형' 		,type: 'string', comboType: 'AU',  comboCode: 'A022'},
		    {name: 'CUSTOM_CODE'		, text: '거래처' 			,type: 'string'},
		    {name: 'CUSTOM_NAME'		, text: '거래처명' 		,type: 'string'},
		    {name: 'DEPT_CODE'			, text: '부서코드' 		,type: 'string'},
		    {name: 'DEPT_NAME'			, text: '부서명' 			,type: 'string'},
		    {name: 'SUPPLY_AMT_I'		, text: '공급가액' 		,type: 'uniPrice'},
		    {name: 'TAX_AMT_I'			, text: '세액' 			,type: 'uniPrice'},
		    {name: 'TOTAL_AMT_I'   		, text: '합계' 			,type: 'uniPrice'},
		    {name: 'EX_DATE'      		, text: '결의일' 		    ,type: 'uniDate'},
		    {name: 'EX_NUM'				, text: '결의번호' 		,type: 'string'},
		    {name: 'AP_STS'				, text: '승인여부' 		,type: 'string', comboType: 'AU',  comboCode: 'A014'},
		    {name: 'SAVE_CODE'			, text: '통장번호' 		,type: 'string'},
		    {name: 'SAVE_NAME'			, text: '신용카드번호' 		,type: 'string'},
		    {name: 'CRDT_NUM'			, text: '불공제사유' 		,type: 'string'},
		    {name: 'CRDT_NAME'			, text: '지급예정일' 		,type: 'uniDate'},
		    {name: 'REASON_CODE'		, text: '전자발행여부' 		,type: 'string'},
		    {name: 'PAY_DATE'			, text: '입력자' 			,type: 'string'},
		    {name: 'EB_YN'				, text: '입력일' 			,type: 'uniDate'},
		    {name: 'INSERT_DB_USER'		, text: '수정자' 			,type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '수정일' 			,type: 'uniDate'},
			{name: 'UPDATE_DB_USER' 	, text: '수정자' 			,type: 'string'},
			{name: 'UPDATE_DB_TIME' 	, text: '수정일' 			,type: 'string'}
		]          
	});

	/* Store 정의(Service 정의)
	 * @type	*/					
	var MasterStore = Unilite.createStore('aigd320MasterStore',{
		model: 'aigd320ukrvModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aigd320ukrvService.selectList'                	
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
           		if(records.length == 0) {
		   			panelSearch.getField('FR_ACQ_DATE').setReadOnly(false);
		   			panelSearch.getField('TO_ACQ_DATE').setReadOnly(false);
		   			panelSearch.getField('FR_INSERT_DATE').setReadOnly(false);
		   			panelSearch.getField('TO_INSERT_DATE').setReadOnly(false);
		   			
		   			panelResult.getField('FR_ACQ_DATE').setReadOnly(false);   
		   			panelResult.getField('TO_ACQ_DATE').setReadOnly(false);   
		   			panelResult.getField('FR_INSERT_DATE').setReadOnly(false);
		   			panelResult.getField('TO_INSERT_DATE').setReadOnly(false);

           		}
           		
           		//조회되는 항목 갯수와 매출액 합계 구하기
           		var totalAmtI = 0;
           		var count = masterGrid.getStore().getCount();  
				Ext.each(records, function(record, i){	
					totalAmtI = record.get('TOTAL_AMT_I') + totalAmtI	
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

    var buttonStore = Unilite.createStore('aigd320UkrButtonStore',{      
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

			var paramMaster			= panelSearch.getValues();
			Ext.Object.merge(paramMaster, addResult.getValues());
			paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.CALL_PATH	= 'LIST';													//호출경로(Batch, List)
		
            if(inValidRecs.length == 0) {
            	// 취득일/ 동일전표 / 전표생성 조건일 경우 동일한 취득일이 선택되어 있는 지 확인
            	if(addResult.getValues().DATE_OPTION == '1' 
						&& addResult.getValues().WORK_DIVI == "1" 
						&& addResult.getValues().PROC_TYPE == "2"  ) {
					if(!checkExtDate())	{
						return false
					}
				}
            	
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
                var grid = Ext.getCmp('aigd320Grid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });


	
	/* 검색조건 (Search Panel)
	 * @type	*/
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '취득일',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ACQ_DATE',
	            endFieldName: 'TO_ACQ_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,                	
				autoPopup: true,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('FR_ACQ_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_ACQ_DATE', newValue);				    		
			    	}
			    }
	     	},Unilite.popup('ACCNT',{ 
//				validateBlank: false,
				autoPopup: true,
		    	fieldLabel: '계정과목',
		    	listeners: {
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
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
					}
				}
			}),
			Unilite.popup('ASSET',{ 
				autoPopup: true,
		    	fieldLabel: '자산코드', 
		    	listeners: {
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
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		 }),{ 
				fieldLabel: '사업장',
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
			},			    
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
			})]
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
					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
				fieldLabel: '취득일',
	 		    width: 315,
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ACQ_DATE',
	            endFieldName: 'TO_ACQ_DATE',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,        
				autoPopup: true,
	            tdAttrs: {width: 380},    
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('FR_ACQ_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('TO_ACQ_DATE', newValue);				    		
			    	}
			    }
	     	},		    
	     	Unilite.popup('ACCNT',{ 
				autoPopup: true,
		    	fieldLabel: '계정과목',
				valueFieldWidth : 90,
				textFieldWidth: 140,
			    colspan: 2, 
		    	listeners: {
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
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
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
	     	},Unilite.popup('ASSET',{ 
				autoPopup: true,
		    	fieldLabel: '자산코드', 
			    colspan: 2, 
		    	listeners: {
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
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),		    
	        { 
				fieldLabel: '사업장',
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
	    		xtype: 'component'
			},
				Unilite.popup('DEPT',{ 
				    fieldLabel: '입력부서', 
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
					fieldLabel: '결의전표승인여부',
	            	name: 'AP_STS',
	            	xtype: 'uniCombobox',
	            	comboType: 'AU',
	            	comboCode: 'A014',
            		labelWidth:150,
			 		tdAttrs: {align: 'right'},
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
					boxLabel: '취득일', 
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
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aigd320ukrvGrid1', {
    	layout : 'fit',
        region : 'center',
        store : MasterStore, 
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
	    				var acqDate =  UniDate.getDbDateStr(selectRecord.get('ACQ_DATE')); 
	    				grid.chk = true;
	    				Ext.each(masterGrid.getSelectedRecords(), function(record, idx){
							if(acqDate != UniDate.getDbDateStr(record.get('ACQ_DATE')))	{
								grid.chk = false;
							}
						});
	    				if(!grid.chk){
	    					//전체선택시 메세지 여러번 뜨지 않도록 setTimeout 으로 설정)
	    					setTimeout(function() {
	    						if(!grid.chk){
	    							grid.chk = true;
	    							Unilite.messageBox("동일 전표로 생성하기 위해서는 같은 취득일의 고정자산을 선택해야 합니다.");
	    						}
	    					}, 1000);
	    					
	    				}
	    				return grid.chk;
    				}
    				return true;
    			},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				
    				sumTotalAmtI = sumTotalAmtI + selectRecord.get('TOTAL_AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
//					var grdRecord = masterGrid.getStore().getAt(rowIndex);
	    			sumTotalAmtI = sumTotalAmtI - selectRecord.get('TOTAL_AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumTotalAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
					selDesel = 0;
	    		}
    		}
        }),
        columns: [   
        	{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},							
			{dataIndex: 'DIV_CODE'				, width: 106},
			{dataIndex: 'ASST'	        		, width: 80 },
			{dataIndex: 'ASST_NAME'     		, width: 166}, 					
			{dataIndex: 'ACQ_DATE'				, width: 80 },
			{dataIndex: 'ACCNT'		    		, width: 66},
			{dataIndex: 'ACCNT_NAME'			, width: 120}, 					
			{dataIndex: 'ACQ_AMT_I'				, width: 100},
			{dataIndex: 'SET_TYPE'	    		, width: 100},
			{dataIndex: 'PROOF_KIND'			, width: 120}, 					
			{dataIndex: 'CUSTOM_CODE'			, width: 66},
			{dataIndex: 'CUSTOM_NAME'			, width: 166},
			{dataIndex: 'DEPT_CODE'				, width: 66}, 					
			{dataIndex: 'DEPT_NAME'				, width: 133},
			{dataIndex: 'SUPPLY_AMT_I'			, width: 100},
			{dataIndex: 'TAX_AMT_I'				, width: 86}, 					
			{dataIndex: 'TOTAL_AMT_I'   		, width: 100},
			{dataIndex: 'EX_DATE'      			, width: 80},
			{dataIndex: 'EX_NUM'				, width: 70 , align :'right'}, 					
			{dataIndex: 'AP_STS'				, width: 66},
			{dataIndex: 'SAVE_CODE'				, width: 100 , hidden: true},
			{dataIndex: 'SAVE_NAME'				, width: 100 , hidden: true}, 					
			{dataIndex: 'CRDT_NUM'				, width: 100 , hidden: true},
			{dataIndex: 'CRDT_NAME'				, width: 100 , hidden: true},
			{dataIndex: 'REASON_CODE'			, width: 100 , hidden: true}, 					
			{dataIndex: 'PAY_DATE'				, width: 100 , hidden: true},
			{dataIndex: 'EB_YN'					, width: 100 , hidden: true},
			{dataIndex: 'INSERT_DB_USER'		, width: 100 , hidden: true}, 					
			{dataIndex: 'INSERT_DB_TIME'		, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100 , hidden: true}
		]
    });                          
	function checkExtDate()	{
		var chk = true;
		var selectRecords = masterGrid.getSelectedRecords();
		if(selectRecords && selectRecords.length > 0)	{
			var acqDate =  UniDate.getDbDateStr(selectRecords[0].get('ACQ_DATE')); 
			Ext.each(masterGrid.getSelectedRecords(), function(record, idx){
				if(acqDate != UniDate.getDbDateStr(record.get('ACQ_DATE')))	{
					chk = false;
				}
			});
			if(!chk){
				Unilite.messageBox("동일 전표로 생성하기 위해서는 같은 취득일의 고정자산을 선택해야 합니다.");
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
		id : 'aigd320App',
		
		fnInitBinding : function() {
   			panelSearch.getField('FR_ACQ_DATE').setReadOnly(false);
   			panelSearch.getField('TO_ACQ_DATE').setReadOnly(false);
   			panelSearch.getField('FR_INSERT_DATE').setReadOnly(false);
   			panelSearch.getField('TO_INSERT_DATE').setReadOnly(false);
   			
   			panelResult.getField('FR_ACQ_DATE').setReadOnly(false);   
   			panelResult.getField('TO_ACQ_DATE').setReadOnly(false);   
   			panelResult.getField('FR_INSERT_DATE').setReadOnly(false);
   			panelResult.getField('TO_INSERT_DATE').setReadOnly(false);
   			

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);

			panelSearch.setValue('FR_ACQ_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_ACQ_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_ACQ_DATE', UniDate.get('today'));
			panelResult.setValue('TO_ACQ_DATE', UniDate.get('today'));
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
			activeSForm.onLoadSelectText('FR_ACQ_DATE');		
		},
		onQueryButtonDown : function()	{	
			selDesel = 0;
			checkCount = 0;
			sumTotalAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			MasterStore.loadStoreRecords();
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
