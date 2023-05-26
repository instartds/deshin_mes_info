<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd160ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A047" opts='D1;D3'/> <!-- 어음구분 -->
	<t:ExtComboStore comboType="M007"  /> 			<!-- 승인여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {   
var sumAmountTotI = 0;
var checkCount = 0;
var selDesel = 0;

	//SP 실행을 위한 Proxy
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd160ukrService.runProcedure',
            syncAll	: 'agd160ukrService.callProcedure'
		}
	});	

	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd160ukrModel', {
	    fields: [  	  
	    	{name: 'CHK'					, text: '선택' 			,type: 'boolean'},
		    {name: 'NOTE_NUM'				, text: '어음번호'			,type: 'string'},
		    {name: 'OC_AMT_I'				, text: '금액' 			,type: 'uniPrice'},
		    {name: 'AMT_I'					, text: '결제예정금액' 		,type: 'uniPrice'},
		    {name: 'EXP_DATE'				, text: '만기일' 			,type: 'uniDate'},
		    {name: 'CUSTOM_CODE'			, text: '거래처코드' 		,type: 'string'},
		    {name: 'CUSTOM_NAME'			, text: '거래처명' 		,type: 'string'},
		    {name: 'REMARK'                 , text: '적요'         ,type: 'string'},
		    {name: 'AC_DATE'				, text: '전표일' 			,type: 'uniDate'},
		    {name: 'SLIP_NUM'				, text: '번호' 			,type: 'string'},
		    {name: 'SLIP_SEQ'				, text: '순번' 			,type: 'string'},
		    {name: 'J_AMT_I'				, text: '결제금액' 		,type: 'uniPrice'},
		    {name: 'EX_DATE'					, text: '결의일' 			,type: 'uniDate'},
		    {name: 'AGREE_YN'				, text: '승인여부' 		,type: 'string'}

		]          		
	});   
	
	Unilite.defineModel('Agd160ukrModel2', {
	    fields: [  	  
	    	{name: 'CHK'					, text: '선택' 			,type: 'boolean'},
	    	{name: 'NOTE_NUM'				, text: '어음번호' 			,type: 'string'},
	    	{name: 'OC_AMT_I'				, text: '금액' 			,type: 'uniPrice'},
	    	{name: 'J_AMT_I'				, text: '걸제금액' 			,type: 'uniPrice'},
	    	{name: 'EXP_DATE'				, text: '만기일' 			,type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'			, text: '거래처코드' 		,type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '거래처명' 			,type: 'string'},
	    	{name: 'EX_DATE'				, text: '결의일' 			,type: 'uniDate'},
	    	{name: 'EX_NUM'					, text: '번호' 			,type: 'string'},
	    	{name: 'AGREE_YN'				, text: '승인여부' 			,type: 'string', comboType: 'AU', comboCode: 'M007'},
	    	{name: 'COMP_CODE'				, text: '법인코드' 			,type: 'string'},
	    	{name: 'DIV_CODE'				, text: '사업장' 			,type: 'string'},
	    	{name: 'OLD_SLIP_NUM'			, text: '회계번호'			,type: 'string'},
	    	{name: 'OLD_AC_DATE'			, text: '회계일'			,type: 'uniDate'}
		]          		
	});   

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agd160ukrdirectMasterStore',{
		model: 'Agd160ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd160ukrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agd160ukrdirectMasterStore',{
		model: 'Agd160ukrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd160ukrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//SP 실행을 위한 Store
	var buttonStore = Unilite.createStore('agd160ukrButtonStore',{ 
        proxy	: directButtonProxy,     
        uniOpt	: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,            // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var activeTabId = tab.getActiveTab().getId();			

			var paramMaster = Table.getValues();
            paramMaster.LANG_TYPE	= UserInfo.userLang
            paramMaster.OPR_FLAG	= buttonFlag;
            
			if(activeTabId == 'tab_1'){								//자동기표일 때 마스터로그테이블(L_AGD160T_M)에 insert
	            paramMaster.OPR_FLAG	= buttonFlag;
				paramMaster.CHARGE_CODE	= (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE;
			}

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
				var activeTabId = tab.getActiveTab().getId();			
				if(activeTabId == 'tab_1'){				
	                var grid = Ext.getCmp('agd160ukrGrid1');
	                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
	                
				} else if (activeTabId == 'tab_2') {
	                var grid = Ext.getCmp('agd160ukrGrid2');
	                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
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
    	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
	        	fieldLabel: '만기일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'EXT_DATE_FR',
				endFieldName: 'EXT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('EXT_DATE_FR',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('EXT_DATE_TO',newValue);
			    	}   	
			    }
			},{
				fieldLabel: '어음구분',
				name:'AC_CODE',	
            	id:  'AC_CODE_ID',
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A047',
				value:'D1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_CODE', newValue);
					}
				}
			},{
            	xtype: 'container',
            	id:  'EX_NUM_ID',
            	hidden: true,
            	items:[{
	            	xtype: 'container',
	    			defaultType: 'uniTextfield',
	    			layout: {type: 'uniTable', columns: 2},
	    			items: [{
	    				fieldLabel: '결의번호',
	    				//suffixTpl: '&nbsp;~&nbsp;',
	    				name: 'EX_NUM_FR',
						width: 200,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('EX_NUM_FR', newValue);
							}
						}
	    			}, {
						fieldLabel: '~',
	    				name: 'EX_NUM_TO',
						labelWidth: 15,
						width: 135,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('EX_NUM_TO', newValue);
							}
						}
	    			}] 
				}]
			},
			Unilite.popup('CUST',{ 
		    	fieldLabel: '거래처', 
            	id:  'CUST_ID',	
	            allowBlank:true,
				autoPopup:false,
				validateBlank:false,
		    	valueFieldName: 'CUST_CODE_FR',
				textFieldName: 'CUST_NAME_FR',
		    	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUST_CODE_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_FR', '');
									panelSearch.setValue('CUST_NAME_FR', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUST_NAME_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_FR', '');
									panelSearch.setValue('CUST_CODE_FR', '');
								}
							}
				}
			}),
				Unilite.popup('CUST',{ 
			    	fieldLabel: '~', 
            		id:  'CUST2_ID',	
		            allowBlank:true,
					autoPopup:false,
					validateBlank:false,            		
			    	valueFieldName: 'CUST_CODE_TO',
					textFieldName: 'CUST_NAME_TO',
			    	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUST_CODE_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_TO', '');
									panelSearch.setValue('CUST_NAME_TO', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUST_NAME_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_TO', '');
									panelSearch.setValue('CUST_CODE_TO', '');
								}
							}
					}
			}),{
	            xtype: 'uniCombobox',
	            name: 'SP_STS',
            	id:  'SP_STS_ID',
            	hidden: true,
	            fieldLabel: '승인여부',
	            comboType:'AU',
				comboCode:'M007',
				value: '1',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SP_STS', newValue);
					}
				}
	         },{
				xtype: 'uniNumberfield',
				name: 'TOTAL_AMT',
				fieldLabel:'합계금액',
		    	readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TOTAL_AMT', newValue);
					}
				}
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tdAttrs: {align: 'center'},	
				items:[{
					xtype: 'button',
					text: '자동기표',	
					name: '',
					id: 'AUTO_CHECK',
					itemId: 'btnViewAutoSlip',
					width: 80,				   	
					handler : function(records) {
						var activeTabId = tab.getActiveTab().getId();			
						if(activeTabId == 'tab_1'){								//Table	
							if(!Table.getInvalidMessage()){						//자동기표 전 필수 입력값 체크
								return false;
							}
				            var buttonFlag = 'N';								//자동기표 FLAG
				            fnMakeLogTable(buttonFlag);
							
						} else if (activeTabId == 'tab_2') {					//Table2
				            var buttonFlag = 'D';								//자동기표취소 FLAG
				            fnMakeLogTable(buttonFlag);
							
						}
					}
				}]
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
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
	        	fieldLabel: '만기일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'EXT_DATE_FR',
				endFieldName: 'EXT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
	        	tdAttrs		: {width: 350},
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('EXT_DATE_FR',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('EXT_DATE_TO',newValue);
			    	}   	
			    }
			},{
				fieldLabel: '어음구분',
				name:'AC_CODE',
            	id:  'AC_CODE_ID2',	
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A047',
				value:'D1',
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_CODE', newValue);
					},
	    			
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	panelResult.getField('CUST_CODE_FR').focus();  
	                	}
	                }
	    		}
			},{
            	xtype: 'container',
            	id:  'EX_NUM_ID2',
            	hidden: true,
            	items:[{
	            	xtype: 'container',
	    			defaultType: 'uniTextfield',
	    			layout: {type: 'uniTable', columns: 2},
	    			items: [{
	    				fieldLabel: '결의번호',
	    				//suffixTpl: '&nbsp;~&nbsp;',
	    				name: 'EX_NUM_FR',
						width: 200,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('EX_NUM_FR', newValue);
							}
						}
	    			}, {
						fieldLabel: '~',
	    				name: 'EX_NUM_TO',
						labelWidth: 15,
						width: 135,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('EX_NUM_TO', newValue);
							}
						}
	    			}] 
				}]
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tdAttrs: {align: 'right'},	
				colspan:2,
				items:[{
					xtype: 'button',
					text: '자동기표',	
					name: '',
					id: 'AUTO_CHECK2',
					itemId: 'btnViewAutoSlip',
					width: 80,				   	
					handler : function(records, grid, record) {
						var activeTabId = tab.getActiveTab().getId();			
						if(activeTabId == 'tab_1'){								//Table	
							if(!Table.getInvalidMessage()){						//자동기표 전 필수 입력값 체크
								return false;
							}
				            var buttonFlag = 'N';								//자동기표 FLAG
				            fnMakeLogTable(buttonFlag);
							
						} else if (activeTabId == 'tab_2') {					//Table2
				            var buttonFlag = 'D';								//자동기표취소 FLAG
				            fnMakeLogTable(buttonFlag);
							
						}
					}	
				}]
			},{
            	xtype: 'container',
            	id:  'CUST_ID2',	
    			defaultType: 'uniTextfield',
    			layout: {type: 'uniTable'},
    			colspan:2,
    			items: [
    				Unilite.popup('CUST',{ 
				    	fieldLabel: '거래처', 
						allowBlank:true,
						autoPopup:false,
						validateBlank:false,				    	
				    	valueFieldName: 'CUST_CODE_FR',
						textFieldName: 'CUST_NAME_FR',
				    	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUST_CODE_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_FR', '');
									panelSearch.setValue('CUST_NAME_FR', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUST_NAME_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_FR', '');
									panelSearch.setValue('CUST_CODE_FR', '');
								}
							},
			    			onTextSpecialKey: function(elm, e){
			                    if (e.getKey() == e.ENTER) {
			                    	UniAppManager.app.onQueryButtonDown();  
			                	}
			                }
						}
				}),
					Unilite.popup('CUST',{ 
				    	fieldLabel: '~', 
				    	labelWidth: 15,
						allowBlank:true,
						autoPopup:false,
						validateBlank:false,					    	
				    	valueFieldName: 'CUST_CODE_TO',
						textFieldName: 'CUST_NAME_TO',
				    	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUST_CODE_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_TO', '');
									panelSearch.setValue('CUST_NAME_TO', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUST_NAME_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_TO', '');
									panelSearch.setValue('CUST_CODE_TO', '');
								}
							},
							applyextparam: function(popup){							
								//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				})] 
			},{
	            xtype: 'uniCombobox',
	            name: 'SP_STS',
	            id: 'SP_STS_ID2',
	            hidden: true,
	            fieldLabel: '승인여부',
	            comboType:'AU',
				comboCode:'M007',
				value: '1',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SP_STS', newValue);
					},
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	UniAppManager.app.onQueryButtonDown();  
	                	}
	                }
				}
	        },{
				xtype: 'component'
				
			},{
				xtype: 'uniNumberfield',
				name: 'TOTAL_AMT',
				fieldLabel:'합계금액',
				padding: '0 20 0 0',
				tdAttrs: {align: 'right'},	
		    	readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TOTAL_AMT', newValue);
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
	
	var Table = Unilite.createForm('detailForm', {
		layout: {type: 'uniTable', columns: 1
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		disabled: false,
		border: true,
		padding: '1',
		region: 'center',
		items: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
	    	items	: [
				Unilite.popup('ACCNT',{
			    	fieldLabel: '상대계정코드',
				    id: 'ACCOUNT_CODE_TEMP1', 
			    	valueFieldName: 'ACCNT_CODE',
			    	textFieldName: 'ACCNT_NAME',
		 			allowBlank:false,
					/*extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
				    			'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'"}, */ 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var param = {ACCNT_CD : Table.getValue('ACCNT_CODE')};
								accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
									var dataMap = provider;
									var opt = '3';	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
									//UniAccnt.addMadeFields(Table, dataMap, null, opt);
									
									if(panelSearch.getValue('AC_CODE') == 'D1') {
										dataMap.AC_CTL1 = provider.DR_CTL1;
										dataMap.AC_CTL2 = provider.DR_CTL2;
										dataMap.AC_CTL3 = provider.DR_CTL3;
										dataMap.AC_CTL4 = provider.DR_CTL4;
										dataMap.AC_CTL5 = provider.DR_CTL5;
										dataMap.AC_CTL6 = provider.DR_CTL6;
									}
									else {
										dataMap.AC_CTL1 = provider.CR_CTL1;
										dataMap.AC_CTL2 = provider.CR_CTL2;
										dataMap.AC_CTL3 = provider.CR_CTL3;
										dataMap.AC_CTL4 = provider.CR_CTL4;
										dataMap.AC_CTL5 = provider.CR_CTL5;
										dataMap.AC_CTL6 = provider.CR_CTL6;
									}
									
									UniAccnt.addMadeFields(Table, dataMap, Table, '');
									Table.down('#serach_ViewPopup').setVisible(false);
								});			 																							
							},
							scope: this
						},
						onClear: function(type)	{
							Table.setValue('ACCNT_CODE', '');
							Table.setValue('ACCNT_NAME', '');
							/**
							 * onClear시 removeField..
							 */
							UniAccnt.removeField(Table);
						}
					}
		 		}),{
			 		fieldLabel: '전표일',
			 		xtype: 'uniDatefield',
			 		labelWidth: 115,
			 		name: 'SLIP_DATE',
				    id: 'SLIP_DATE_TEMP1',
					value: UniDate.get('today'),
			 		allowBlank:false
				}
			]},{
			  	xtype: 'container',
			  	//colspan:  ?,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:3,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			},{
			  	xtype: 'container',
			  	//colspan:  ?,
			  	itemId: 'serach_ViewPopup', 
			  	layout: {
			   		type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		},
		  		items:[
					Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목1',
					readOnly:true,
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목2',
					readOnly:true,
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목3',
					readOnly:true,
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목4',
					readOnly:true,
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목5',
					readOnly:true,
			    	validateBlank:false
			    }),
			    Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '관리항목6',
					readOnly:true,
			    	validateBlank:false
			    })]
			 }
		]
	});
	
	var Table2 = Unilite.createForm('detailForm2', {
		layout: {type: 'uniTable', columns: 2},
		disabled: false,
		border: true,
		padding: '1',
		region: 'center',
		items: [
			Unilite.popup('ACCNT',{
		    	fieldLabel: '상대계정코드',	
			    id: 'ACCOUNT_CODE_TEMP2', 
		    	valueFieldName: 'ACCNT_CODE',
		    	textFieldName: 'ACCNT_NAME',
				/*extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
			    			'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'"}, */ 
				listeners: {
					onSelected: {
						fn: function(records, type) {
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
							var param = {ACCNT_CD : Table.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								var dataMap = provider;
								var opt = '3'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
								UniAccnt.addMadeFields(Table, dataMap, null, opt);
							});			 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(Table);
					}
				}
 			}),{
		 		fieldLabel: '전표일',
		 		xtype: 'uniDatefield',
		 		name: 'SLIP_DATE',
			    id: 'SLIP_DATE_TEMP2',
				value: UniDate.get('today'),
		 		allowBlank:false
			},{
			  	xtype: 'container',
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
			  	}
			}
		],
		api: {
			submit: 'agd160ukrService.syncMaster'				
		}
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agd160ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        title: '자동기표',
    	excelTitle: '만기어음(자동기표)',
        store : directMasterStore, 
        uniOpt:{
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
		//그리드 체크박스
    	//selModel: Ext.create('Ext.selection.CheckboxModel'),
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false,
    		listeners: {  	
				checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
					directMasterStore.commitChanges();
					UniAppManager.setToolbarButtons('save', false);
				},
				select: function(grid, record, index, rowIndex, eOpts ){
					checkCount++;
					if(checkCount > 0){
				   		panelSearch.down('#btnViewAutoSlip').enable();		//자동기표 활성화
				   		panelResult.down('#btnViewAutoSlip').enable();		//자동기표 활성화
					} else if (checkCount <= 0){
				   		panelSearch.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
				   		panelResult.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
						selDesel = 0;
					}
	    			sumAmountTotI = sumAmountTotI + record.get('OC_AMT_I');
	    			panelSearch.setValue('TOTAL_AMT', sumAmountTotI);
	    			panelResult.setValue('TOTAL_AMT', sumAmountTotI);
	          	},
				deselect:  function(grid, record, index, rowIndex, eOpts ){
					selDesel = 0;
					checkCount--;
					if(checkCount > 0){
				   		panelSearch.down('#btnViewAutoSlip').enable();		//자동기표 활성화
				   		panelResult.down('#btnViewAutoSlip').enable();		//자동기표 활성화
					}else if (checkCount <= 0){
				   		panelSearch.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
				   		panelResult.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
						selDesel = 0;
					}
					sumAmountTotI = sumAmountTotI - record.get('OC_AMT_I');
	    			panelSearch.setValue('TOTAL_AMT', sumAmountTotI);
	    			panelResult.setValue('TOTAL_AMT', sumAmountTotI);
	    		}
			}
        }),
        columns: [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},				
			{dataIndex: 'NOTE_NUM'		, width: 100}, 				
			{dataIndex: 'OC_AMT_I'		, width: 120},
			{dataIndex: 'AMT_I'			, width: 120},
			{dataIndex: 'EXP_DATE'		, width: 86},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 166},
			{dataIndex: 'REMARK'        , width: 166},
			{dataIndex: 'AC_DATE'		, width: 100},
			{dataIndex: 'SLIP_NUM'		, width: 66}, 				
			{dataIndex: 'SLIP_SEQ'		, width: 66}, 				
			{dataIndex: 'J_AMT_I'		, width: 120 , hidden:true},
			{dataIndex: 'EX_DATE'		, width: 53  , hidden:true},
			{dataIndex: 'AGREE_YN'		, width: 53  , hidden:true}
		]         	        
    });  
    
    var masterGrid2 = Unilite.createGrid('agd160ukrGrid2', {
    	layout : 'fit',
        region : 'center',
        title: '자동기표취소',
    	excelTitle: '만기어음(자동기표취소)',
        store : directMasterStore2, 
        uniOpt:{
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
		//그리드 체크박스
    	//selModel: Ext.create('Ext.selection.CheckboxModel'),
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        tbar: [{
			xtype: 'button',
           	itemId:'procTool',
			text: '자동기표조회',
			handler: function() {
				var record = masterGrid2.getSelection();
				
				if(record.length >= '1'){
					record = record[0].data;
					
					if(!Ext.isEmpty(record)){
						var params = {
								action:'select',
								'PGM_ID'  : 'agd160ukr',
								'EX_NUM'  : (record.AGREE_YN == '1' ? record.EX_NUM  : record.OLD_SLIP_NUM),
								'EX_DATE' : (record.AGREE_YN == '1' ? record.EX_DATE : record.OLD_AC_DATE),
								'INPUT_PATH' : '57'
						}
					}
				}else if(record.length == '0'){
					Ext.Msg.alert("확인","자동기표 조회 할 데이터가 없습니다.");
				}
				
				if(record.AGREE_YN == '1'){
    				var rec = {data : {prgID : 'agj105ukr', 'text':'결의전표입력(건별)'}};							
    				parent.openTab(rec, '/accnt/agj105ukr.do', params);
				}else if(record.AGREE_YN == '2'){
					var rec = {data : {prgID : 'agj205ukr', 'text':'회계전표입력(건별)'}};                          
                    parent.openTab(rec, '/accnt/agj205ukr.do', params);
					
				}else{
					Ext.Msg.alert("확인","자동기표 조회 할 데이터가 없습니다.");
				}
				
				
				/* if(record.length >= '1'){
					record = record[0].data;
										
					if(!Ext.isEmpty(record)){ 
						var params = {
	                        action:'select', 
	                        'PGM_ID' : 'agd160ukr', 
	                        'EX_NUM' : record.OLD_SLIP_NUM,
	                        'EX_DATE' : record.OLD_AC_DATE,
	                        'INPUT_PATH' : '57'
	                    }
				}} */
			}
        }],
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false,
    		listeners: {  	
				checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
					directMasterStore.commitChanges();
					UniAppManager.setToolbarButtons('save', false);
				},
				select: function(grid, record, index, rowIndex, eOpts ){
					checkCount++;
				
					if(checkCount > 0) {
				   		panelSearch.down('#btnViewAutoSlip').enable();		//자동기표 활성화
				   		panelResult.down('#btnViewAutoSlip').enable();		//자동기표 활성화
					} else if (checkCount <= 0) {
				   		panelSearch.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
				   		panelResult.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
						selDesel = 0;
					}
	    			sumAmountTotI = sumAmountTotI + record.get('OC_AMT_I');
	    			panelSearch.setValue('TOTAL_AMT', sumAmountTotI);
	    			panelResult.setValue('TOTAL_AMT', sumAmountTotI);
	    			
	    			
	          	},
				deselect:  function(grid, record, index, rowIndex, eOpts ){
					selDesel = 0;
					checkCount--;
					if(checkCount > 0) {
				   		panelSearch.down('#btnViewAutoSlip').enable();		//자동기표 활성화
				   		panelResult.down('#btnViewAutoSlip').enable();		//자동기표 활성화
					} else if (checkCount <= 0) {
				   		panelSearch.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
				   		panelResult.down('#btnViewAutoSlip').disable(true);		//자동기표 비활성화
						selDesel = 0;
					}
					sumAmountTotI = sumAmountTotI - record.get('OC_AMT_I');
	    			panelSearch.setValue('TOTAL_AMT', sumAmountTotI);
	    			panelResult.setValue('TOTAL_AMT', sumAmountTotI);
	    		},
	    		onGridDbClick: function(grid, record, cellIndex, colName){
	    			masterGrid.gotoAgj(record);
	    		}
			}
        }),
        columns: [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
	    	{dataIndex: 'NOTE_NUM'					, width: 100},
	    	{dataIndex: 'OC_AMT_I'					, width: 120},
	    	{dataIndex: 'J_AMT_I'					, width: 120, hidden: true},
	    	{dataIndex: 'EXP_DATE'					, width: 100},
	    	{dataIndex: 'CUSTOM_CODE'				, width: 133},
	    	{dataIndex: 'CUSTOM_NAME'				, width: 200},
	    	{dataIndex: 'EX_DATE'					, width: 100},
	    	{dataIndex: 'EX_NUM'					, width: 66},
	    	{dataIndex: 'AGREE_YN'					, width: 80},
	    	{dataIndex: 'COMP_CODE'					, width: 80, hidden: true},
	    	{dataIndex: 'DIV_CODE'					, width: 80, hidden: true},
	    	{dataIndex: 'OLD_SLIP_NUM'				, hidden: true},
	    	{dataIndex: 'OLD_AC_DATE'				, hidden: true}
		]}
	); 
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [{
	    	title: '자동기표',
			xtype:'container',
			id: 'tab_1',
			layout:{type:'vbox', align:'stretch'},
			items:[Table, masterGrid]
		},{
			title: '자동기표취소',
			xtype:'container',
			id: 'tab_2',
			layout:{type:'vbox', align:'stretch'},
			items:[Table2, masterGrid2]
		}],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newTab, oldTab, eOpts )  {
	     		if (newTab == oldTab) return false;
	     		if (newTab == Ext.getCmp('tab_1')) {
	     			UniAppManager.app.selectTabFirst();
	     			var poSearch = Ext.getCmp('AC_CODE_ID');
				    poSearch.setVisible(true);
				    var poSearch2 = Ext.getCmp('AC_CODE_ID2');
				    poSearch2.setVisible(true);
	     			var poSearch3 = Ext.getCmp('CUST_ID');
				    poSearch3.setVisible(true);
				    var poSearch4 = Ext.getCmp('CUST2_ID');
				    poSearch4.setVisible(true);
				    var poSearch5 = Ext.getCmp('CUST_ID2');
				    poSearch5.setVisible(true);
				    
	     			var poSearch6 = Ext.getCmp('EX_NUM_ID');
				    poSearch6.setVisible(false);
				    var poSearch7 = Ext.getCmp('EX_NUM_ID2');
				    poSearch7.setVisible(false);
	     			var poSearch8 = Ext.getCmp('SP_STS_ID');
				    poSearch8.setVisible(false);
				    var poSearch9 = Ext.getCmp('SP_STS_ID2');
				    poSearch9.setVisible(false);
				    
	     		} else {
	     			UniAppManager.app.selectTabSecond();
	     			var poSearch = Ext.getCmp('AC_CODE_ID');
				    poSearch.setVisible(false);
				    var poSearch2 = Ext.getCmp('AC_CODE_ID2');
				    poSearch2.setVisible(false);
	     			var poSearch3 = Ext.getCmp('CUST_ID');
				    poSearch3.setVisible(false);
				    var poSearch4 = Ext.getCmp('CUST2_ID');
				    poSearch4.setVisible(false);
				    var poSearch5 = Ext.getCmp('CUST_ID2');
				    poSearch5.setVisible(false);
				    
	     			var poSearch6 = Ext.getCmp('EX_NUM_ID');
				    poSearch6.setVisible(true);
				    var poSearch7 = Ext.getCmp('EX_NUM_ID2');
				    poSearch7.setVisible(true);
	     			var poSearch8 = Ext.getCmp('SP_STS_ID');
				    poSearch8.setVisible(true);
				    var poSearch9 = Ext.getCmp('SP_STS_ID2');
				    poSearch9.setVisible(true);
				    
				    
	     		}
	     	}
	     }
    });
    
	Unilite.Main( {
	 	border: false,
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
		id : 'agd160ukrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('EXT_DATE_FR');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
	   		panelSearch.down('#btnViewAutoSlip').disable(true);	//자동기표 비활성화
	   		panelResult.down('#btnViewAutoSlip').disable(true);	//자동기표 비활성화
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'tab_1'){				
				directMasterStore.loadStoreRecords();				
			} else if (activeTabId == 'tab_2') {
				directMasterStore2.loadStoreRecords();		
			}
		},
		selectTabFirst: function() {
			Ext.getCmp('AUTO_CHECK').setText('자동기표');
			Ext.getCmp('AUTO_CHECK2').setText('자동기표');
			Ext.getCmp('ACCOUNT_CODE_TEMP1').setVisible(true);
 			Ext.getCmp('SLIP_DATE_TEMP1').setVisible(true);
			panelSearch.setValue('TOTAL_AMT', '0');
			panelResult.setValue('TOTAL_AMT', '0');
			sumAmountTotI	= 0;
			checkCount		= 0;
			
			directMasterStore.loadStoreRecords();	
		},
		selectTabSecond: function() {
			Ext.getCmp('AUTO_CHECK').setText('기표취소');
			Ext.getCmp('AUTO_CHECK2').setText('기표취소');
			Ext.getCmp('ACCOUNT_CODE_TEMP2').setVisible(false);
 			Ext.getCmp('SLIP_DATE_TEMP2').setVisible(false);
			panelSearch.setValue('TOTAL_AMT', '0');
			panelResult.setValue('TOTAL_AMT', '0');
			sumAmountTotI	= 0;
			checkCount		= 0;
			
 			directMasterStore2.loadStoreRecords();
		}
	});
	
	function fnMakeLogTable(buttonFlag) {														//자동기표 (insert log table  및 call SP)
		var activeTabId = tab.getActiveTab().getId();			
		if(activeTabId == 'tab_1'){				
			records = masterGrid.getSelectedRecords();
            
		} else if (activeTabId == 'tab_2') {
			records = masterGrid2.getSelectedRecords();
		}
		buttonStore.clearData();																//clear buttonStore
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;												//자동기표 flag
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}

};


</script>
