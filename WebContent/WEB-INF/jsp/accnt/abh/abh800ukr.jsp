<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh800ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A014" /> 			<!-- 승인상태 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var newYN = 0;
var bottonText = '일괄자동기표';						//기표취소는 하나의 버튼에서 일괄 처리(일괄자동기표 버튼 사용)
var getChargeCode = '${getChargeCode}';

if(getChargeCode == '' ){
	getChargeCode = [{"SUB_CODE":""}];
}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'abh800ukrService.selectList',
			update	: 'abh800ukrService.updateDetail',
//			create	: 'abh800ukrService.insertDetail',
//			destroy	: 'abh800ukrService.deleteDetail',
			syncAll	: 'abh800ukrService.saveAll'
		}
	});	
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'abh800ukrService.runProcedure',
            syncAll	: 'abh800ukrService.callProcedure'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh800ukrModel1', {
		fields: [
	    	{name: 'STATE'				, text: '상태'				, type: 'string'  },
	    	{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'  },
	    	{name: 'REMIT_DAY'			, text: '집금일'				, type: 'uniDate' },
	    	{name: 'SEQ'				, text: '순번'				, type: 'string'  },
	    	{name: 'OUT_BANK'			, text: '출금은행'				, type: 'string'  },
	    	{name: 'OUT_BANK_NM'		, text: '출금은행명'			, type: 'string'  },
	    	{name: 'OUT_ACCT_NO'		, text: '출금계좌번호'			, type: 'string'  },
	    	{name: 'OUT_ACCT_NO_EXPOS'	, text: '출금계좌번호'			, type: 'string'		,allowBlank: false, defaultValue:'*************'},
	    	{name: 'OUT_SAVE_CODE'		, text: '출금통장코드'			, type: 'string'		,allowBlank:false		},
	    	{name: 'OUT_SAVE_NAME'      , text: '출금통장명'           , type: 'string'  },
	    	{name: 'IN_BANK'			, text: '임금은행'				, type: 'string'		,allowBlank:false		},
	    	{name: 'IN_BANK_NM'			, text: '입금은행명'			, type: 'string'		,allowBlank:false},
	    	{name: 'IN_ACCT_NO'			, text: '입금계좌번호'			, type: 'string'  },
	    	{name: 'IN_ACCT_NO_EXPOS'	, text: '입금계좌번호'			, type: 'string'		,allowBlank: false, defaultValue:'*************'},
	    	{name: 'IN_SAVE_CODE'		, text: '입금통장코드'			, type: 'string'  },
	    	{name: 'IN_SAVE_NAME'       , text: '입금통장명'           , type: 'string'  },
	    	{name: 'REMIT_AMT'			, text: '이체금액'				, type: 'uniPrice'},
	    	{name: 'FEE_AMT'			, text: '수수료'				, type: 'uniPrice'		,allowBlank:true		},
	    	{name: 'REMIT_CURBAL'		, text: '이체후잔액'			, type: 'uniPrice'		,allowBlank:true},
	    	{name: 'REMIT_TIME'			, text: '집금시작시간'			, type: 'string'		,allowBlank:false},
	    	{name: 'DEPT_CODE'			, text: '귀속부서'				, type: 'string'		,allowBlank:false  },
	    	{name: 'DEPT_NAME'			, text: '귀속부서명'			, type: 'string'		,allowBlank:true},
	    	{name: 'DIV_CODE'			, text: '귀속사업장'			, type: 'string'		,comboType: 'BOR120',allowBlank:false},
	    	{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER'	, type: 'string'		,allowBlank:false},
	    	{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME'	, type: 'uniDate' },
	    	{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'  },
	    	{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'uniDate' },
	    	{name: 'EX_DATE'			, text: '결의일자'				, type: 'uniDate' },
	    	{name: 'EX_NUM'				, text: '결의번호'				, type: 'int'     },
	    	{name: 'AGREE_YN'			, text: '승인여부'				, type: 'string'  },
	    	{name: 'AC_DATE'			, text: '회계일자'				, type: 'string'  },
	    	{name: 'SLIP_NUM'			, text: '회계번호'				, type: 'int'  },
	    	{name: 'DOC_ID'             , text: '자동순번'             , type: 'string'  }
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh800ukrmasterStore',{
		model	: 'abh800ukrModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: directProxy,
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			param.WORK_DIVI	= Ext.getCmp('rdoSelect2').getChecked()[0].inputValue;
			console.log( param );
			this.load({
				params : param
			});
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();
		},
		
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();        		
	   		var toDelete = this.getRemovedRecords();

	   		var rv = true;

			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			}else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	
    var buttonStore = Unilite.createStore('abh800ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: true,            // 수정 모드 사용 
            deletable	: false,        	// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			//폼에서 필요한 조건 가져올 경우
			var paramMaster		= panelSearch.getValues();
            paramMaster.AC_DATE = UniDate.getDbDateStr(addResult.getValue('AC_DATE'));
            paramMaster.WORK_DATE = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
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
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1,
           	tableAttrs	: {width: '100%'}
//			,tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
			},
           	defaultType	: 'uniTextfield',
		    items		: [{ 
    			fieldLabel		: '집금일',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'APPR_DATE_FR',
		        endFieldName	: 'APPR_DATE_TO',
		        startDate		: UniDate.get('today'),
		        endDate			: UniDate.get('today'),
		        allowBlank		: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('APPR_DATE_FR',newValue);
                	}
                	if(panelSearch) {
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('APPR_DATE_TO',newValue);
			    	}
                	if(panelSearch) {
                	}
			    }
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE' ,   
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				multiSelect	: true, 
				typeAhead	: false,
    			listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
				
			},
			Unilite.popup('BANK',{ 
			    fieldLabel	: '은행', 
			    valueFieldName: 'BANK_CODE',
				textFieldName: 'BANK_NAME',
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
							panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('BANK_CODE', '');
						panelResult.setValue('BANK_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('BANK_BOOK',{ 
			    fieldLabel	: '통장',
			    valueFieldName: 'SAVE_CODE',
				textFieldName: 'SAVE_NAME',
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('SAVE_CODE', panelSearch.getValue('SAVE_CODE'));
							panelResult.setValue('SAVE_NAME', panelSearch.getValue('SAVE_NAME'));	
							panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
							panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 	
							panelResult.setValue('BANK_CODE', records[0].BANK_CD);
							panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('SAVE_CODE', '');
						panelResult.setValue('SAVE_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}	   
			}), {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG',
                xtype: 'uniTextfield',
                hidden: true
            }, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'BTN_FLAG',
                xtype: 'uniTextfield',
                hidden: true
            }]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region		: 'north',
		layout		: {type : 'uniTable', columns : 2//,
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{ 
			fieldLabel		: '집금일',
	        xtype			: 'uniDateRangefield',
	        startFieldName	: 'APPR_DATE_FR',
	        endFieldName	: 'APPR_DATE_TO',
	        startDate		: UniDate.get('today'),
	        endDate			: UniDate.get('today'),
            tdAttrs			: {width: 380},   
	        allowBlank		: false, 
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('APPR_DATE_FR',newValue);
            	}
            	if(panelResult) {
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('APPR_DATE_TO',newValue);
		    	}
            	if(panelResult) {
            	}
		    }
        },{
			fieldLabel	: '사업장',  
			name		: 'DIV_CODE' , 
			xtype		: 'uniCombobox' ,
			comboType	: 'BOR120',
			multiSelect	: true, 
			typeAhead	: false,
            tdAttrs		: {width: 380},  
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
			
		},
		Unilite.popup('BANK',{ 
		    fieldLabel	: '은행', 
		    valueFieldName: 'BANK_CODE',
			textFieldName: 'BANK_NAME',
            tdAttrs		: {width: 380},   
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
						panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('BANK_CODE', '');
					panelSearch.setValue('BANK_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('BANK_BOOK',{ 
		    fieldLabel	: '통장', 
		    valueFieldName: 'SAVE_CODE',
			textFieldName: 'SAVE_NAME',
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('SAVE_CODE', panelResult.getValue('SAVE_CODE'));
						panelSearch.setValue('SAVE_NAME', panelResult.getValue('SAVE_NAME'));	
						panelResult.setValue('BANK_CODE', records[0].BANK_CD);
						panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
						panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
						panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('SAVE_CODE', '');
					panelSearch.setValue('SAVE_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}	   
		})]
    });  

	var addResult = Unilite.createSearchForm('detailForm', { 
		layout		: {type : 'uniTable', columns : 3, tdAttrs: {width: '100%'/*, style: 'border : 1px solid #ced9e7;'*/}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		disabled	: false,
		border		: true,
		padding		: '1',
		region		: 'center',
		items		: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {width: 380},    
	    	items	: [{
				fieldLabel	: '전표일',
			 	name		: 'AC_DATE',
	            xtype		: 'uniDatefield',
		        value		: UniDate.get('today'),
				readOnly	: true,
			 	allowBlank	: false,
			 	width		: 220,
	        	listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						
					}
				}
	     	},{		            		
				fieldLabel: '',	
				xtype	: 'radiogroup',					            		
				id		: 'rdoSelect1',
				items	: [{
					boxLabel: '집금일', 
					name	: 'WORK_DATE',
					width	: 70, 
	    			inputValue: '1'
				},{
					boxLabel: '실행일', 
					name	: 'WORK_DATE',
					width	: 70,
	    			inputValue: '2',
                    checked: true  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(addResult.getValue('WORK_DATE') == '1'){
							addResult.getField('AC_DATE').setReadOnly(true);
						}else{
							addResult.getField('AC_DATE').setReadOnly(false);
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
	    	items	: [{	            		
				fieldLabel: '작업구분',	
	    		xtype	: 'radiogroup',						            		
				id		: 'rdoSelect2',
				tdAttrs	: {align: 'left'},
				items	: [{
					boxLabel: '자동기표', 
					name	: 'WORK_DIVI',
					width	: 90, 
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel: '기표취소', 
					name	: 'WORK_DIVI',
					width	: 90,
	    			inputValue: '2'
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
			    		if(newValue.WORK_DIVI == 1){
		       				Ext.getCmp('procCanc').setText('일괄자동기표');
		       				Ext.getCmp('procCanc2').setText('개별자동기표');
		
		   				}else {
		       				Ext.getCmp('procCanc').setText('일괄기표취소');
		       				Ext.getCmp('procCanc2').setText('개별기표취소');
		       			}

						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							UniAppManager.app.onQueryButtonDown();	
						}	
					}
				}
			}]
		},{
			//컬럼 맞춤용
			xtype: 'component'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2, tdAttrs: {width: '100%'}
			},
			colspan	: 3,
	    	items:[{		            		
				fieldLabel: '합계(선택)',	
				name	: 'SELECTED_AMT',
				xtype	: 'uniNumberfield',		
				readOnly: true,
				tdAttrs	: {align: 'right'},
				value	: 0,			            		
				width	: 200,
				labelWidth: 60,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},{		            		
				fieldLabel: '건수(선택)',
				name	: 'COUNT',
				xtype	: 'uniNumberfield',	
				readOnly: true,
				tdAttrs	: {align: 'right'},
				value	: 0,					            		
				width	: 160,
				labelWidth: 100,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			}]
		}/*,{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
			width	: 210,
			items	: [{				   
				xtype	: 'button',
				id		: 'procCanc',
				text	: '일괄자동기표',
		 		tdAttrs	: {align: 'right'},
				width	: 100,
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					//자동기표일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
			            var buttonFlag = 'AS';								//일괄자동기표 FLAG		
			            fnMakeLogTable(buttonFlag);							//일괄자동기표취소 FLAG
					}
					//기표취소일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
    					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
						records = masterGrid.getSelectedRecords();
						Ext.each(records, function(record, index) {
			    			if (record.get('AGREE_YN') == '2') {
			    				alert('계산서번호 ' +record.get('PUB_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
			    				checkFlag = false; 
			    				return false;
			    			} 
						});
						if (checkFlag) {
				            var buttonFlag = 'AC';
				            fnMakeLogTable(buttonFlag);
						}
					}
				}
			},{				   
				xtype	: 'button',
				id		: 'procCanc2',
				text	: '개별자동기표',
		 		tdAttrs	: {align: 'right'},
				width	: 100,
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					//자동기표일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
			            var buttonFlag = 'IS';								//개별자동기표 FLAG
			            fnMakeLogTable(buttonFlag);							//개별자동기표취소 FLAG
					}
					//기표취소일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
    					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
						records = masterGrid.getSelectedRecords();
						Ext.each(records, function(record, index) {
			    			if (record.get('AGREE_YN') == '2') {
			    				alert('계산서번호 ' +record.get('PUB_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
			    				checkFlag = false; 
			    				return false;
			    			} 
						});
						if (checkFlag) {
				            var buttonFlag = 'IC';
				            fnMakeLogTable(buttonFlag);
						}
					}
				}
			}]
		}*/]
	});
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('abh800ukrGrid1', {  	
    	store	: masterStore,
        layout	: 'fit',
        region	:'center',
    	excelTitle: '기타소득자동기표(자동기표)',
        uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			sumSaleTaxAmtI = sumSaleTaxAmtI + selectRecord.get('SALE_TAX_AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)

	    			if(this.selected.getCount() > 0){
						Ext.getCmp('procCanc').enable();
						Ext.getCmp('procCanc2').enable();
					}
    			},
    			
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumSaleTaxAmtI = sumSaleTaxAmtI - selectRecord.get('SALE_TAX_AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)

	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('procCanc').disable();
						Ext.getCmp('procCanc2').disable();
	    			}
	    		}
    		}
        }),
		tbar: [{
            xtype	: 'button',
            text	: '집금결과 가져오기',  
            name	: '', 
            id		: 'btnConfirm',
            width	: 130,  
//          disabled:true,
            handler : function() {
				var param = panelSearch.getValues();
				param.LANG_TYPE	= UserInfo.userLang;
				masterGrid.getEl().mask('로딩중...','loading-indicator');
				abh800ukrService.getCollectionData(param, function(provider, response)	{
					if(provider){
						UniAppManager.updateStatus(Msg.sMB011);									//저장되었습니다.
					}
					masterGrid.unmask();
				});	
            }
        },'','',
        '->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->',{				   				   				   				   
			xtype	: 'button',
			id		: 'procCanc',
			text	: '일괄자동기표',
	 		tdAttrs	: {align: 'right'},
			width	: 100,
			handler : function() {
				if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
					return false;
				}
				//자동기표일 때 SP 호출
				if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
		            var buttonFlag = 'AS';								//일괄자동기표 FLAG	
		            panelSearch.setValue("BTN_FLAG", "AS");
		            fnMakeLogTable(buttonFlag);							//일괄자동기표취소 FLAG
				}
				//기표취소일 때 SP 호출
				if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
					records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, index) {
		    			if (record.get('AGREE_YN') == '2') {
		    				alert('계산서번호 ' +record.get('PUB_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
		    				checkFlag = false; 
		    				return false;
		    			} 
					});
					if (checkFlag) {
			            var buttonFlag = 'IC';
			            panelSearch.setValue("BTN_FLAG", "IC");
			            fnMakeLogTable(buttonFlag);
					}
				}
			}
		},{				   
			xtype	: 'button',
			id		: 'procCanc2',
			text	: '개별자동기표',
	 		tdAttrs	: {align: 'right'},
			width	: 100,
			handler : function() {
				if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
					return false;
				}
				//자동기표일 때 SP 호출
				if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
		            var buttonFlag = 'IS';								//개별자동기표 FLAG
		            panelSearch.setValue("BTN_FLAG", "IS");
		            fnMakeLogTable(buttonFlag);							//개별자동기표취소 FLAG
				}
				//기표취소일 때 SP 호출
				if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
					records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, index) {
		    			if (record.get('AGREE_YN') == '2') {
		    				alert('계산서번호 ' +record.get('PUB_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
		    				checkFlag = false; 
		    				return false;
		    			} 
					});
					if (checkFlag) {
			            var buttonFlag = 'IC';
			            panelSearch.setValue("BTN_FLAG", "IC");
			            fnMakeLogTable(buttonFlag);
					}
				}
			}
		}
        /*,'',''			//간격 띄우기
         * ,{
    		xtype: 'button',
    		text: '건별출력',	
	    	id: 'btnPrint',
    		name: '',
    		width: 80,	
			handler : function() {
				if(directDetailStore.getCount() > 0){
		         var param= Ext.getCmp('resultForm').getValues();
		         
		         var prgId = '';

		         var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/abh/abh220rkrPrint.do',
		            prgID: 'abh220rkr',
		               extParam: {
		                    COMP_CODE:       	param.COMP_CODE       
		               }
		            });
		            win.center();
		            win.show();
				}
			}
    	},{
    		xtype: 'button',
    		text: '지급처별 묶음출력',
    		id:'btnGroupPrint',
    		name: '',
    		width: 120,	
//    		disabled:true,
			handler : function() {
				
			}
    	}*/],
        columns:  [{
				xtype	: 'rownumberer', 
				sortable: false, 
				width	: 35,
				align	:'center  !important',
				resizable: true
			},
			{ dataIndex: 'STATE'			, width:80, hidden: true},
			{ dataIndex: 'COMP_CODE'		, width:80, hidden: true},
			{ dataIndex: 'REMIT_DAY'		, width:100},
			{ dataIndex: 'SEQ'				, width:80, hidden: true},
			{ dataIndex: 'OUT_BANK'			, width:100},
			{ dataIndex: 'OUT_BANK_NM'		, width:140},
			{ dataIndex: 'OUT_ACCT_NO'		, width:160, hidden: true},
        	{ dataIndex: 'OUT_ACCT_NO_EXPOS', width: 120 ,align:'center'},				
			{ dataIndex: 'OUT_SAVE_CODE'	, width:80, hidden: true},
			{ dataIndex: 'OUT_SAVE_NAME'    , width:100 },
			{ dataIndex: 'IN_BANK'			, width:100},
			{ dataIndex: 'IN_BANK_NM'		, width:140},
			{ dataIndex: 'IN_ACCT_NO'		, width:160, hidden: true},
        	{ dataIndex: 'IN_ACCT_NO_EXPOS' , width: 120 , align:'center'},
			{ dataIndex: 'IN_SAVE_CODE'		, width:80, hidden: true},
			{ dataIndex: 'IN_SAVE_NAME'     , width:100 },
			{ dataIndex: 'REMIT_AMT'		, width:120},
			{ dataIndex: 'FEE_AMT'			, width:100},
			{ dataIndex: 'REMIT_CURBAL'		, width:120},
			{ dataIndex: 'REMIT_TIME'		, width:120},
			{ dataIndex: 'DEPT_CODE'		, width:120,
				editor: Unilite.popup('DEPT_G', {
 					DBtextFieldName: 'TREE_CODE',
					autoPopup:true,
					listeners: {'onSelected': {
						fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
								rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
								rtnRecord.set('DIV_CODE', records[0]['DIV_CODE']);
								
							},
						scope: this	
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', '');
								rtnRecord.set('DEPT_NAME', '');
								rtnRecord.set('DIV_CODE', '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
			{ dataIndex: 'DEPT_NAME'		, width:140		,
				editor: Unilite.popup('DEPT_G', {
 	 				DBtextFieldName: 'TREE_NAME',
					autoPopup:true,
					listeners: {'onSelected': {
						fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
								rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
								rtnRecord.set('DIV_CODE', records[0]['DIV_CODE']);
							},
						scope: this	
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', '');
								rtnRecord.set('DEPT_NAME', '');
								rtnRecord.set('DIV_CODE', '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
			{ dataIndex: 'DIV_CODE'			, width:100},
			{ dataIndex: 'INSERT_DB_USER'	, width:80		, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'	, width:80		, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width:80		, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	, width:80		, hidden: true},
			{ dataIndex: 'EX_DATE'			, width:100		, align: 'center'/*		, hidden: true*/},
			{ dataIndex: 'EX_NUM'			, width:100/*		, hidden: true*/
			/*,renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
					if(record.get("EX_NUM") == 0){
						return '';
					}else{
						return val;
					}
				}		*/		
			},
			{ dataIndex: 'AGREE_YN'			, width:80/*		, hidden: true*/},
			{ dataIndex: 'AC_DATE'			, width:80		, hidden: true},
			{ dataIndex: 'SLIP_NUM'			, width:80		, hidden: true}
		],
		listeners:{
			beforeedit: function(editor, e){
              if (Ext.isEmpty(e.record.get('EX_DATE'))) {
                  if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_CODE', 'DEPT_NAME'])){
                      return true;    
                  }else{
                      return false;                  	
                  }
                  
              } else {
                  return false;
              }          
            },
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="OUT_ACCT_NO_EXPOS" || colName =="IN_ACCT_NO_EXPOS") {
					masterGrid.openCryptAcntNumPopup(record, colName);
				}
			}
		} ,
		openCryptAcntNumPopup:function( record, colName )	{
			if(record)	{
				if(colName =="OUT_ACCT_NO_EXPOS") {
					var params = {'BANK_ACCOUNT': record.get('OUT_ACCT_NO'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
					Unilite.popupCipherComm('grid', record, 'OUT_ACCT_NO_EXPOS', 'OUT_ACCT_NO', params);
				}else if(colName =="IN_ACCT_NO_EXPOS") {
					var params = {'BANK_ACCOUNT': record.get('IN_ACCT_NO'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
					Unilite.popupCipherComm('grid', record, 'IN_ACCT_NO_EXPOS', 'IN_ACCT_NO', params);
				}
			}
				
		}
    });  
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
    Unilite.Main( {
		id			: 'abh800ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
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
		
		fnInitBinding : function() {
			panelSearch.setValue('APPR_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('APPR_DATE_TO'	, UniDate.get('today'));
			
			panelResult.setValue('APPR_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('APPR_DATE_TO'	, UniDate.get('today'));

			addResult.setValue('AC_DATE', UniDate.get('today'));
			addResult.getField('WORK_DATE').setValue('2');
			addResult.getField('WORK_DIVI').setValue('1');
			
			Ext.getCmp('procCanc').setText('일괄자동기표');
   			Ext.getCmp('procCanc2').setText('개별자동기표');
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();

			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);

			UniAppManager.setToolbarButtons('save'		, false);
			UniAppManager.setToolbarButtons('detail'	, false);
			UniAppManager.setToolbarButtons('reset'		, false);
            
			var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('APPR_DATE_FR');		
			newYN = 0;	
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){			//조회 전 필수값 입력 여부 체크
				return false;
			}

			sumSaleTaxAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onSaveDataButtonDown: function () {
			if(!this.isValidSearchForm()){			//저장 전 필수값 입력 여부 체크
				return false;
			}
			
			masterStore.saveStore();
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			masterStore.clearData();
			masterStore2.clearData();
			newYN = 1;
			this.fnInitBinding();			
		},
		
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
/*			if (masterStore.getCount() > 0) {
				var seq = masterStore.max('SEQ') + 1;
			} else {
				var seq = 1
			}*/
			var r = {
//            	SEQ : seq
	        };
			masterGrid.createRow(r);
			
			UniAppManager.setToolbarButtons('delete',	true);
			UniAppManager.setToolbarButtons('deleteAll',true);
		},
		
		onDeleteDataButtonDown: function() {
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
				
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var record = masterGrid.getSelectedRecord.data;
				if(Ext.isEmpty(record.EX_DATE)) {
					masterGrid.deleteSelectedRow();
				} else {
					alert(Msg.sMA0422);
					return false;
				}
			}
		},
		
		onDeleteAllButtonDown: function() {			
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
					
				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
					}
					return false;
				}
			});
			
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		
			UniAppManager.setToolbarButtons('deleteAll', false);
		}
	});
	
	function fnMakeLogTable(buttonFlag) {
		records = masterGrid.getSelectedRecords();

		buttonStore.clearData();															//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;											//자동기표 flag
			record.data.AC_DATE		= UniDate.getDbDateStr(addResult.getValue('AC_DATE'));	//일괄자동기표일 때 전표일자 처리용(전표일)
			record.data.INPUT_PATH	= '75';													//입력경로 (집금자동기표)
			buttonStore.insert(index, record);   
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
            }
		});
		
	}

	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record = masterGrid.getSelectedRecord();

			if (newValue != oldValue && record.get('STATE') == '1') {			//상태가 진행일 경우에는 "N"으로 변경
				record.phantom = true;
			}
			
			return rv;
		}
	});

};
</script>
