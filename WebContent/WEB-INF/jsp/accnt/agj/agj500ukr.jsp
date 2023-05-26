<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj500ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A037" /> <!-- 구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var excelWindow; 
var buttonFlag ='';
function appMain() {
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create  : 'agj500ukrService.insertDetailButton',
            syncAll : 'agj500ukrService.saveAllButton'
        }
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agj500ukrService.selectList',
			update: 'agj500ukrService.updateDetail',
			create: 'agj500ukrService.insertDetail',
			destroy: 'agj500ukrService.deleteDetail',
			syncAll: 'agj500ukrService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agj500ukrModel', {
	    fields: [
	    	{name: 'ROW_NUMBER'			,text: 'NO'					,type: 'string'},
	    	{name: 'COMP_CODE'          ,text: 'COMP_CODE'          ,type: 'string'},
	    	{name: 'AUTO_NUM'           ,text: 'AUTO_NUM'           ,type: 'string'},
	    	{name: 'EXC_DATE'			,text: '전표일자'				,type: 'string',allowBlank:false,maxLength:8},
	    	{name: 'INSERT_USER_NAME'	,text: '입력자'				,type: 'string'},
	    	{name: 'EXC_NUM'			,text: '번호'					,type: 'int',allowBlank:false},
	    	{name: 'EXC_SEQ'			,text: '순번'					,type: 'int',allowBlank:false},
	    	{name: 'ACCNT'				,text: '계정코드'				,type: 'string',allowBlank:false},
	    	{name: 'ACCNT_NAME'			,text: '계정명'				,type: 'string'},
	    	{name: 'CUSTOM_CODE'		,text: '거래처코드'				,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '거래처명'				,type: 'string'},
	    	{name: 'MONEY_UNIT'			,text: '화폐단위'				,type: 'string'},
	    	{name: 'EXCHG_RATE_O'		,text: '환율'					,type: 'uniER'},
	    	{name: 'FOR_AMT_I'			,text: '외화금액'				,type: 'uniFC'},
	    	{name: 'DR_AMT_I'			,text: '차변금액'				,type: 'uniPrice'},
	    	{name: 'CR_AMT_I'			,text: '대변금액'				,type: 'uniPrice'},
	    	{name: 'REMARK'				,text: '적요'					,type: 'string'},
	    	{name: 'DEPT_CODE'			,text: '귀속부서코드'			,type: 'string',allowBlank:false},
	    	{name: 'DEPT_NAME'			,text: '귀속부서명'				,type: 'string'},
	    	{name: 'DIV_CODE'			,text: '귀속사업장코드'			,type: 'string',allowBlank:false},
	    	
	    	{name: 'SAVE_CODE'			,text: '통장'					,type: 'string'},
	    	{name: 'SAVE_NAME'			,text: '통장명'				,type: 'string'},
	    	{name: 'BANK_CODE'			,text: '은행코드'				,type: 'string'},
	    	{name: 'BANK_NAME'			,text: '은행명'				,type: 'string'},
	    	{name: 'PJT_CODE'			,text: '사업코드'				,type: 'string'},
	    	{name: 'PJT_NAME'			,text: '사업명'				,type: 'string'},
	    	{name: 'CRDT_NUM'			,text: '카드코드'				,type: 'string'},
	    	{name: 'CRDT_NAME'			,text: '법인카드명'				,type: 'string'},
	    	{name: 'NOTE_NUM'			,text: '어음번호'				,type: 'string'},
	    	{name: 'EXP_DATE'			,text: '만기일'				,type: 'string',maxLength:8},
	    	{name: 'LOANNO'				,text: '차입금번호'				,type: 'string'},
	    	{name: 'LOAN_NAME'			,text: '차입금명'				,type: 'string'},
	    	{name: 'PERSON_NUMB'		,text: '사번'					,type: 'string'},
	    	{name: 'PERSON_NAME'		,text: '성명'					,type: 'string'},
	    	{name: 'ASST'				,text: '자산코드'				,type: 'string'},//AISS300T
	    	{name: 'ASST_NAME'			,text: '자산명'				,type: 'string'},
	    	{name: 'PAY_EX_DATE'		,text: '지급예정일'				,type: 'string',maxLength:8},
	    	{name: 'REC_EX_DATE'		,text: '회수예정일'				,type: 'string',maxLength:8},
	    	
	    	{name: 'PROOF_KIND'			,text: '증빙유형'				,type: 'string'},
	    	{name: 'PUB_DATE'			,text: '계산서일'				,type: 'string',maxLength:8},
	    	{name: 'SUPPLY_AMT_I'		,text: '공급가액'				,type: 'uniPrice'},
	    	{name: 'TAX_AMT_I'			,text: '세액'					,type: 'uniPrice'},
	    	{name: 'EB_YN'				,text: '전자발행여부'			,type: 'string'},
	    	{name: 'CREDIT_NUM'			,text: '신용카드/영수증번호'		,type: 'string'},
	    	{name: 'REASON_CODE'		,text: '불공제사유'				,type: 'string'},
	    	{name: 'ORG_AC_DATE'		,text: '원전표일자'				,type: 'string',maxLength:8},
	    	{name: 'ORG_SLIP_NUM'		,text: '원전표번호'				,type: 'int'},
	    	{name: 'ORG_SLIP_SEQ'		,text: '원전표순번'				,type: 'int'},
	    	{name: 'EX_DATE'			,text: '결의일자'				,type: 'string',maxLength:8},
	    	{name: 'EX_NUM'				,text: '결의번호'				,type: 'string'},
	    	{name: 'EX_SEQ'				,text: '결의순번'				,type: 'int'}
		]
	});
	
//	USP_ACCNT_AGJ500UKR_fnAgj110tInsert
//	USP_ACCNT_AGJ500UKR_fnAgj110tDelete
	
	var buttonStore = Unilite.createStore('Agj500ukrButtonStore',{      
        uniOpt  : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable   : false,            // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        proxy   : directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = panelResult.getValues();  //syncAll 수정
//            paramMaster.DED_TYPE = panelResult.getValue('DED_TYPE');
            paramMaster.BUTTON_FLAG = buttonFlag;
            paramMaster.WORK_TYPE = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue
//            panelResult.getValue('WORK_TYPE');
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        buttonFlag = '';
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                        buttonFlag = '';
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('agj500ukrGrid');
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
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('agj500ukrDetailStore', {
		model: 'Agj500ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
//						directDetailStore.loadStoreRecords();
						
						if (directDetailStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('agj500ukrGrid');
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
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
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
			items: [{ 
	    		fieldLabel: '전표일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'EXC_DATE_FR',
			    endFieldName: 'EXC_DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('EXC_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('EXC_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '기준',
				items: [{
					boxLabel: '일반전표', 
					width: 120,
					name: 'WORK_TYPE',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '미결반제전표', 
					width: 120,
					name: 'WORK_TYPE',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('WORK_TYPE').setValue(newValue.WORK_TYPE);					
//							UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        // value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, 
				Unilite.popup('USER',{
					textFieldWidth:170,
					fieldLabel: '입력자',
					valueFieldName:'USER_ID',
			    	textFieldName:'USER_NAME',
		    		autoPopup: true,
					validateBlank:false, 
					popupWidth: 710,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('USER_ID', panelResult.getValue('USER_ID'));
								panelResult.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('USER_ID', '');
							panelResult.setValue('USER_NAME', '');
						}
					}					
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '전표반영',
				items: [{
					boxLabel: '전체', 
					width: 60,
					name: 'HAVE_EX_DATE',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '예', 
					width: 60,
					name: 'HAVE_EX_DATE',
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width: 60,
					name: 'HAVE_EX_DATE',
					inputValue: 'N' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('HAVE_EX_DATE').setValue(newValue.HAVE_EX_DATE);					
//							UniAppManager.app.onQueryButtonDown();
					}
				}
			}/*,{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:300,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '결의전표반영',	
//		    		id: 'btnA',
		    		name: 'SEND',
		    		width: 120,	
		    		tdAttrs: {align : 'center'},
					handler : function() {
						var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            buttonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                                record.phantom = true;
                                buttonStore.insert(i, record);
                            });
                            buttonFlag = 'BATCH';
                            buttonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','결의전표반영 할 데이터를 선택해 주세요.'); 
                        }
					}
		    	},{
		    		xtype: 'button',
		    		text: '전표반영취소',	
//		    		id: 'btnB',
		    		name: 'SENDBY',
		    		width: 120,	
		    		tdAttrs: {align : 'center'},
					handler : function() {
						var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            buttonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                                record.phantom = true;
                                buttonStore.insert(i, record);
                            });
                            buttonFlag = 'CANCEL';
                            buttonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','전표반영취소 할 데이터를 선택해 주세요.'); 
                        }
					}
		    	}]
			}*/]	
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '전표일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'EXC_DATE_FR',
		    endFieldName: 'EXC_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('EXC_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('EXC_DATE_TO', newValue);				    		
		    	}
		    }
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '기준',
			id : 'rdoSelect1',
			items: [{
				boxLabel: '일반전표', 
				width: 120,
				name: 'WORK_TYPE',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '미결반제전표', 
				width: 120,
				name: 'WORK_TYPE',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('WORK_TYPE').setValue(newValue.WORK_TYPE);					
//							UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        // value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('USER',{
				textFieldWidth:170,
				fieldLabel: '입력자',
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
		    	autoPopup: true,
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('USER_ID', '');
						panelSearch.setValue('USER_NAME', '');
					}
				}					
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '전표반영',
			items: [{
				boxLabel: '전체', 
				width: 60,
				name: 'HAVE_EX_DATE',
				inputValue: '',
				checked: true  
			},{
				boxLabel: '예', 
				width: 60,
				name: 'HAVE_EX_DATE',
				inputValue: 'Y'
			},{
				boxLabel: '아니오', 
				width: 60,
				name: 'HAVE_EX_DATE',
				inputValue: 'N' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('HAVE_EX_DATE').setValue(newValue.HAVE_EX_DATE);					
//							UniAppManager.app.onQueryButtonDown();
				}
			}
		}/*,{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:300,
			tdAttrs: {align : 'right'},
			items :[{
	    		xtype: 'button',
	    		text: '결의전표반영',	
//		    		id: 'btnA',
	    		name: 'SEND',
	    		width: 120,	
	    		tdAttrs: {align : 'center'},
				handler : function() {
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BATCH';
                        buttonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','결의전표반영 할 데이터를 선택해 주세요.'); 
                    }
                }
	    	},{
	    		xtype: 'button',
	    		text: '전표반영취소',	
//		    		id: 'btnB',
	    		name: '2',
	    		width: 120,	
	    		tdAttrs: {align : 'center'},
				handler : function() {
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'CANCEL';
                        buttonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','전표반영취소 할 데이터를 선택해 주세요.'); 
                    }
                }
	    	}]
		}*/]
    });		
    var detailGrid = Unilite.createGrid('agj500ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '전표엑셀업로드',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
			onLoadSelectFirst: false,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		tbar: [{
//			itemId: 'fundingTargetBtn',
			text: '엑셀 Upload',
			handler: function() {
				openExcelWindow();
			}
    	},{
    		text: '결의전표반영',	
    		name: 'SEND',
    		width: 100,	
    		tdAttrs: {align : 'center'},
			handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                
                    buttonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        buttonStore.insert(i, record);
                    });
                    buttonFlag = 'BATCH';
                    buttonStore.saveStore();
                                            
                }else{
                    Ext.Msg.alert('확인','결의전표반영 할 데이터를 선택해 주세요.'); 
                }
            }
    	},{
    		text: '전표반영취소',	
    		name: '2',
    		width: 100,	
    		tdAttrs: {align : 'center'},
			handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                
                    buttonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        buttonStore.insert(i, record);
                    });
                    buttonFlag = 'CANCEL';
                    buttonStore.saveStore();
                                            
                }else{
                    Ext.Msg.alert('확인','전표반영취소 할 데이터를 선택해 주세요.'); 
                }
            }
    	}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var sm = detailGrid.getSelectionModel();
					var selRecords = detailGrid.getSelectionModel().getSelection();
					var records = directDetailStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('EXC_DATE') == record.get('EXC_DATE') 
						&& selectRecord.get('EXC_NUM') == record.get('EXC_NUM')){
							selRecords.push(record);
						}
					});
					sm.select(selRecords);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var sm = detailGrid.getSelectionModel();
					var selRecords = detailGrid.getSelectionModel().getSelection();
					var records = directDetailStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('EXC_DATE') != record.get('EXC_DATE')
						|| selectRecord.get('EXC_NUM') != record.get('EXC_NUM')){
							selRecords.splice(0, 10000); 
						}
	  				});
					Ext.each(records, function(record, index){
						if(selectRecord.get('EXC_DATE') == record.get('EXC_DATE')
						&& selectRecord.get('EXC_NUM') == record.get('EXC_NUM')){
							selRecords.push(record);
						}
					});
					sm.deselect(selRecords);
				}
			}
        }),
		columns: [
        	{ dataIndex: 'ROW_NUMBER'						,width:60, align:'center'},
        	{ dataIndex: 'COMP_CODE'                        ,width:60, hidden:true},
        	{ dataIndex: 'AUTO_NUM'                         ,width:60, hidden:true},
			{text: '전표기본정보',
				columns: [
					{ dataIndex: 'EXC_DATE'					,width:100/*,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}*/
					},
		        	{ dataIndex: 'INSERT_USER_NAME'			,width:100},
		        	{ dataIndex: 'EXC_NUM'					,width:100, format:'0'},
		        	{ dataIndex: 'EXC_SEQ'					,width:100},
		        	{ dataIndex: 'ACCNT'					,width:100},
		        	{ dataIndex: 'ACCNT_NAME'				,width:100}
				]
			},
			{text: '거래처정보',
				columns: [
					{ dataIndex: 'CUSTOM_CODE'				,width:100},
        			{ dataIndex: 'CUSTOM_NAME'				,width:100}
				]
			},
			{text: '금액정보',
				columns: [	
					{ dataIndex: 'MONEY_UNIT'				,width:100},
		        	{ dataIndex: 'EXCHG_RATE_O'				,width:100},
		        	{ dataIndex: 'FOR_AMT_I'				,width:100,summaryType: 'sum'},
		        	{ dataIndex: 'DR_AMT_I'					,width:100,summaryType: 'sum'},
		        	{ dataIndex: 'CR_AMT_I'					,width:100,summaryType: 'sum'}
        		]
			},
        	{ dataIndex: 'REMARK'					,width:100},
        	{text: '귀속정보',
				columns: [
					{ dataIndex: 'DEPT_CODE'				,width:100},
		        	{ dataIndex: 'DEPT_NAME'				,width:100},
		        	{ dataIndex: 'DIV_CODE'			,width:120}
				]
        	},
        	{text: '관리항목정보',
				columns: [
					{ dataIndex: 'SAVE_CODE'					,width:100},
					{ dataIndex: 'SAVE_NAME'					,width:100},
					{ dataIndex: 'BANK_CODE'					,width:100},
					{ dataIndex: 'BANK_NAME'					,width:100},
					{ dataIndex: 'PJT_CODE'						,width:100},
					{ dataIndex: 'PJT_NAME'						,width:100},
					{ dataIndex: 'CRDT_NUM'						,width:100},
					{ dataIndex: 'CRDT_NAME'					,width:100},
					{ dataIndex: 'NOTE_NUM'						,width:100},
					{ dataIndex: 'EXP_DATE'						,width:100},
					{ dataIndex: 'LOANNO'						,width:100},
					{ dataIndex: 'LOAN_NAME'					,width:100},
					{ dataIndex: 'PERSON_NUMB'					,width:100},
					{ dataIndex: 'PERSON_NAME'					,width:100},
					{ dataIndex: 'ASST'							,width:100},
					{ dataIndex: 'ASST_NAME'					,width:100},
					{ dataIndex: 'PAY_EX_DATE'					,width:100},
					{ dataIndex: 'REC_EX_DATE'					,width:100}
				]
        	},
        	{text: '부가세정보',
				columns: [
					{ dataIndex: 'PROOF_KIND'				,width:100},
		        	{ dataIndex: 'PUB_DATE'					,width:100},
		        	{ dataIndex: 'SUPPLY_AMT_I'				,width:100,summaryType: 'sum'},
		        	{ dataIndex: 'TAX_AMT_I'				,width:100,summaryType: 'sum'},
		        	{ dataIndex: 'EB_YN'					,width:100},
		        	{ dataIndex: 'CREDIT_NUM'				,width:150},
		        	{ dataIndex: 'REASON_CODE'				,width:100}
				]
        	},
        	{text: '미결발생 전표정보',
				columns: [
					{ dataIndex: 'ORG_AC_DATE'				,width:100},
		        	{ dataIndex: 'ORG_SLIP_NUM'				,width:100},
		        	{ dataIndex: 'ORG_SLIP_SEQ'				,width:100}
				]
        	},
        	{text: '전표생성정보',
				columns: [
					{ dataIndex: 'EX_DATE'					,width:100},
		        	{ dataIndex: 'EX_NUM'					,width:100},
		        	{ dataIndex: 'EX_SEQ'					,width:100}
				]
        	}
        ],
        listeners: {
        	afterrender:function()	{
        		
			},
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['ROW_NUMBER','ACCNT_NAME','CUSTOM_NAME','SAVE_NAME','CUSTOM_NAME','PJT_NAME','CRDT_NAME','LOAN_NAME','PERSON_NAME','ASST_NAME','EX_DATE','EX_NUM','EX_SEQ', 'INSERT_USER_NAME'])){
						return false;
					}else{
						return true;	
					}
				}else{
					if(e.record.data.EX_DATE == ''){
						if(UniUtils.indexOf(e.field, ['ROW_NUMBER','ACCNT_NAME','CUSTOM_NAME','SAVE_NAME','CUSTOM_NAME','PJT_NAME','CRDT_NAME','LOAN_NAME','PERSON_NAME','ASST_NAME','EX_DATE','EX_NUM','EX_SEQ', 'INSERT_USER_NAME'])){
							return false;
						}else{
							return true;	
						}
					}else{
						return false;
					}
				}
			/*	if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}
				}else{
					if(UniUtils.indexOf(e.field, ['DEPT_DIVI','ACCNT','ACCNT_NAME','COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}	
				}*/
				
				
			}
		}
    });   
    
  
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		},
			panelSearch
		],
		id  : 'agj500ukrApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('EXC_DATE_FR');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.setToolbarButtons('save', false);
		},
		
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('EX_DATE') == ''){
					detailGrid.deleteSelectedRow();
				}else{
					Ext.Msg.alert('확인','전표가 생성된 데이터 입니다.\n 삭제가 불가능 합니다.');
				}

			}
		},
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
		setDefault: function(){
		}
		
	});
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 'agj500ukr',
            	width: 600,
    			height: 200,
        		extParam: { 
        			'PGM_ID' : 'agj500ukr'
        			
        		},
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                uploadFile: function() {
				    var me = this,
					frm = me.down('#uploadForm');
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.down('tabpanel').setActiveTab(1);
							Ext.Msg.alert('Success', 'Upload 되었습니다.');
							
							me.hide();
								
							UniAppManager.app.onQueryButtonDown();
						},
			            failure: function(form, action) {
			                Ext.Msg.alert('Failed', action.result.msg);
//			            	Ext.Msg.alert('Failed', 'Upload 실패 하였습니다.');
			            }
						
					});
				},
             /*   onApply:function()	{
                        	//excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid2.setExcelData(record.data);
						        	//masterGrid.fnCulcSet(record.data);
						    }); 
							grid.getStore().remove(records);
                        	excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							mba031ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid2.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
				        	} else {
				        		alert("에러가있는 행은 적용 불가합니다.");
				        		return false;
				        	}
						
						}*/
               /* uploadFile: function() {
                	var me = this,
					frm = me.down('#uploadForm');
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							
//							alert('성공');
							
							
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.down('tabpanel').setActiveTab(1);
							Ext.Msg.alert('Success', 'Upload 되었습니다.');
							
							
						},
			            failure: function(form, action) {
			            	alert('실패');
			            	
//			                Ext.Msg.alert('Failed', action.result.msg);
			            }
						
					});
                },*/
				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : '업로드',
							tooltip : '업로드', 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						},
						/*{
							xtype: 'button',
							text : 'Read Data',
							tooltip : 'Read Data', 
							hidden: true,
							handler: function() { 
								if(me.jobID != null)	{
									me.readGridData(me.jobID);
									me.down('tabpanel').setActiveTab(1);
								} else {
									alert('Upload된 파일이 없습니다.')
								}
							}
						},*/
						'->',
						{
							xtype: 'button',
							text : '닫기',
							tooltip : '닫기', 
							handler: function() { 
								me.hide();
							}
						}
					]
				 }
			});
		}
        excelWindow.center();
        excelWindow.show();
	};
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	
			
};

</script>