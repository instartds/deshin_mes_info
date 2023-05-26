<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd400ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 --> 
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {   
//조회된 합계, 건수 계산용 변수 선언
var sumSaleTaxAmtI	= 0;
	sumCheckedCount	= 0;
	newYN 			= 0;

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd400ukrService.runProcedure',
            syncAll	: 'agd400ukrService.callProcedure'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agd400ukrModel', {
	   fields: [
			{name: 'COMP_CODE'			, text: '법인'					, type: 'string'  },					//코드값으로 명을 가져오게 하는 처리
			{name: 'ORG_AC_DATE'		, text: '전표일자'					, type: 'string'  },
			{name: 'ORG_SLIP_NUM'		, text: '번호'					, type: 'int'     },
			{name: 'ORG_SLIP_SEQ'		, text: '순번'					, type: 'int'     },
			{name: 'ACCNT'				, text: '계정과목'					, type: 'string'  },
			{name: 'ACCNT_NAME'			, text: '계정과목명'				, type: 'string'  },
			{name: 'GUBUN'				, text: '구분'					, type: 'string'  },
			{name: 'PJT_CODE'			, text: '사업/제품코드'				, type: 'string'  },
			{name: 'PJT_NAME'			, text: '사업명/제품명'				, type: 'string'  },
			{name: 'REMARK'				, text: '적요'					, type: 'string'  },
			{name: 'AMT_I'				, text: '금액'					, type: 'uniPrice'},
			{name: 'DIV_CODE'			, text: '사업장'					, type: 'string'		, comboType: 'BOR120'},
			{name: 'DEPT_CODE'			, text: '귀속부서'					, type: 'string'  },
			{name: 'DEPT_NAME'			, text: '귀속부서명'				, type: 'string'  },
			{name: 'AC_DATE'			, text: '회계전표일'				, type: 'string'  },
			{name: 'SLIP_NUM'			, text: '회계번호'					, type: 'string'  },
			{name: 'RE_AC_DATE'			, text: '선급비용 -> 비용 회계일자'		, type: 'string'  },
			{name: 'RE_SLIP_NUM'		, text: '선급비용 -> 비용 회계번호'		, type: 'string'  },
			{name: 'INSERT_DB_USER'		, text: '입력자'					, type: 'string'  },
			{name: 'INSERT_DB_TIME'		, text: '입력일'					, type: 'uniDate' },
			{name: 'UPDATE_DB_USER'		, text: '수정자'					, type: 'string'  },
			{name: 'UPDATE_DB_TIME'		, text: '수정일'					, type: 'uniDate' }
	    ]
	});		// End of Ext.define('agd400ukrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agd400ukrmasterStore',{
		model	: 'agd400ukrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type	: 'direct',
            api	: {			
                read: 'agd400ukrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.WORK_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));
			param.WORK_DIVI	= Ext.getCmp('rdoSelect2').getChecked()[0].inputValue;
			console.log( param );
			this.load({
				params : param
			});
			Ext.getCmp('procCanc').disable();
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

    var buttonStore = Unilite.createStore('agd400ukrButtonStore',{ 
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

            var paramMaster = panelSearch.getValues();
            paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));
            paramMaster.LANG_TYPE	= UserInfo.userLang

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
                var grid = Ext.getCmp('agd400ukrGrid');
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
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand	: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title		: '기본정보', 	
	   		itemId		: 'search_panel1',
	        layout		: {type: 'uniTable', columns: 1},
	        defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '전표일',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'AC_DATE_FR',
	            endFieldName: 'AC_DATE_TO',
	            startDate	: UniDate.get('startOfMonth'),
	            endDate		: UniDate.get('today'),
	            allowBlank	: false,                	
				autoPopup	: true,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO', newValue);				    		
			    	}
			    }
	     	},{
	     		fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				multiSelect	: true, 
				typeAhead	: false,
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},
			Unilite.popup('DEPT', { 
				fieldLabel		: '귀속부서', 
				valueFieldName	: 'DEPT_CODE',
		   	 	textFieldName	: 'DEPT_NAME',
				listeners		: {
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
					},
					applyextparam: function(popup){							
						var authoInfo	= pgmInfo.authoUser;					//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode	= UserInfo.deptCode;					//부서정보
						var divCode		= '';									//사업장
						if (authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							
						} else if(authoInfo == "5"){							//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),    
        	Unilite.popup('ACCNT',{
		        fieldLabel		: '선급비용계정',
			    valueFieldName	: 'ACCNT_CODE',
			    textFieldName	: 'ACCNT_NAME',
	            allowBlank		: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME', newValue);				
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "PROFIT_DIVI = 'A'"});			//선급비용만 팝업 오픈시 조회
					}
				}
		    }),	{	            		
				fieldLabel	: '구분',	
	    		xtype		: 'radiogroup',						            		
				id			: 'rdoSelect1-1',
				items		: [{
					boxLabel	: '사업단위', 
					name		: 'UNIT',
	    			inputValue	: '1',
					width		: 90, 
					checked		: true  
				},{
					boxLabel	: '제품단위', 
					name		: 'UNIT',
	    			inputValue	: '2',
					width		: 90
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('UNIT', newValue.UNIT);	
						
						if(newValue.UNIT == 1){
							panelSearch.down('#pjtCodePopup').setVisible(true);
							panelResult.down('#pjtCodePopup').setVisible(true);
							panelSearch.down('#itemCodePopup').setVisible(false);
							panelResult.down('#itemCodePopup').setVisible(false);
							
		   				} else {
							panelSearch.down('#pjtCodePopup').setVisible(false);
							panelResult.down('#pjtCodePopup').setVisible(false);
							panelSearch.down('#itemCodePopup').setVisible(true);
							panelResult.down('#itemCodePopup').setVisible(true);
		   				}
					}
				}
			},{
				xtype	: 'container',
				layout	: {type : 'hbox'},
		    	items	: [
			    	Unilite.treePopup('PJT_TREE',{ 
				    	fieldLabel		: '사업/제품코드',
		        		itemId			: 'pjtCodePopup',
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
			                }/*,
							onTextSpecialKey: function(elm, e){
			                    if (e.getKey() == e.ENTER) {
									masterStore.loadStoreRecords();
			                    }
			                }*/
						}
					}),
		        	Unilite.popup('ITEM',{
			        	fieldLabel		: '사업/제품코드',
		        		itemId			: 'itemCodePopup',
			        	valueFieldName	: 'CUST_ITEM_CODE',
			        	textFieldName	: 'CUST_ITEM_NAME',
			        	listeners		: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_ITEM_CODE', panelSearch.getValue('CUST_ITEM_CODE'));
									panelResult.setValue('CUST_ITEM_NAME', panelSearch.getValue('CUST_ITEM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_ITEM_CODE', '');
								panelResult.setValue('CUST_ITEM_NAME', '');
							}
						}
			        })
				]}
		]}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '전표일',
            xtype		: 'uniDateRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            startDate	: UniDate.get('startOfMonth'),
            endDate		: UniDate.get('today'),
            allowBlank	: false,                	
			autoPopup	: true,
            tdAttrs		: {width: 380},    
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('AC_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    }
     	},{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
            tdAttrs		: {width: 380},       
            colspan		: 2,
			listeners	: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		},
		Unilite.popup('DEPT', { 
			fieldLabel		: '귀속부서', 
			valueFieldName	: 'DEPT_CODE',
	   	 	textFieldName	: 'DEPT_NAME',
			listeners		: {
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
				},
				applyextparam: function(popup){							
					var authoInfo	= pgmInfo.authoUser;					//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode	= UserInfo.deptCode;					//부서정보
					var divCode		= '';									//사업장
					if (authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						
					} else if(authoInfo == "5"){							//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),		    
    	Unilite.popup('ACCNT',{
	        fieldLabel		: '선급비용계정',
	        //validateBlank:false,
		    valueFieldName	: 'ACCNT_CODE',
		    textFieldName	: 'ACCNT_NAME',
            tdAttrs			: {width: 380},    
			allowBlank		: false,
            colspan			: 2,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY': "PROFIT_DIVI = 'A'"});			//선급비용만 팝업 오픈시 조회
				}
			}
	    }),{	            		
			fieldLabel	: '구분',	
    		xtype		: 'radiogroup',						            		
			id			: 'rdoSelect1-2',
			items		: [{
				boxLabel	: '사업단위', 
				name		: 'UNIT',
    			inputValue	: '1',
				width		: 90, 
				checked		: true  
			},{
				boxLabel	: '제품단위', 
				name		: 'UNIT',
    			inputValue	: '2',
				width		: 90
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('UNIT', newValue.UNIT);
	
					if(newValue.UNIT == 1){
						panelSearch.down('#pjtCodePopup').setVisible(true);
						panelResult.down('#pjtCodePopup').setVisible(true);
						panelSearch.down('#itemCodePopup').setVisible(false);
						panelResult.down('#itemCodePopup').setVisible(false);
						
	   				}else {
						panelSearch.down('#pjtCodePopup').setVisible(false);
						panelResult.down('#pjtCodePopup').setVisible(false);
						panelSearch.down('#itemCodePopup').setVisible(true);
						panelResult.down('#itemCodePopup').setVisible(true);
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'hbox'},
	    	items	: [
				Unilite.treePopup('PJT_TREE',{ 
			    	fieldLabel		: '사업/제품코드',
		    		itemId			: 'pjtCodePopup',
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
		                }/*,
						onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
								masterStore.loadStoreRecords();
		                    }
		                }*/
					}
				}),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '사업/제품코드',
		        	itemId			: 'itemCodePopup',
		        	valueFieldName	: 'CUST_ITEM_CODE',
		        	textFieldName	: 'CUST_ITEM_NAME',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE', panelResult.getValue('CUST_ITEM_CODE'));
								panelSearch.setValue('CUST_ITEM_NAME', panelResult.getValue('CUST_ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE', '');
							panelSearch.setValue('CUST_ITEM_NAME', '');
						}
					}
		        })
	        ]
		}]
	});
	
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout	: {type : 'uniTable', columns : 3, tdAttrs: {width: '100%'/*, style: 'border : 1px solid #ced9e7;'*/}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		disabled: false,
		border	: true,
		padding	: '1',
		region	: 'center',
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {width: 380},    
	    	items	: [{
				fieldLabel	: '실행일',
	            xtype		: 'uniDatefield',
			 	name		: 'WORK_DATE',
		        value		: UniDate.get('today'),
			 	allowBlank	: false,
			 	width		: 220,
	        	listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	     	},{
				xtype	: 'component',
			 	width	: 155
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
	    	items	: [{	            		
				fieldLabel	: '작업구분',	
	    		xtype		: 'radiogroup',						            		
				id			: 'rdoSelect2',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel	: '자동기표', 
					name		: 'WORK_DIVI',
	    			inputValue	: '1',
					width		: 90, 
					checked		: true  
				},{
					boxLabel	: '기표취소', 
					name		: 'WORK_DIVI',
	    			inputValue	: '2',
					width		: 90
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
			    		if(newValue.WORK_DIVI == 1){
		       				Ext.getCmp('procCanc').setText('자동기표');
		
		   				}else {
		       				Ext.getCmp('procCanc').setText('기표취소');
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
			xtype: 'container',
			layout : {type : 'uniTable', columns : 2, tdAttrs: {width: '100%'}
			},
			colspan: 2,
	    	items:[{	            		
				fieldLabel	: '합계(선택)',	
				name		: 'SELECTED_AMT',	
				xtype		: 'uniNumberfield',	
				tdAttrs		: {align: 'right'},				            		
				width		: 200,
				labelWidth	: 60,
				readOnly	: true,
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},{		            		
				fieldLabel	: '건수(선택)',	
				name		: 'COUNT',
				xtype		: 'uniNumberfield',	
				tdAttrs		: {align: 'right'},				            		
				width		: 160,
				labelWidth	: 100,
				readOnly	: true,
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
			width	: 120,
			items	: [{				   
				xtype	: 'button',
				//name: 'CONFIRM_CHECK',
				id		: 'procCanc',
				text	: '자동기표',
				width	: 100,
		 		tdAttrs	: {align: 'right'},
				handler	: function() {
					//자동기표일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
						if(!addResult.getInvalidMessage()){						//자동기표 전 필수 입력값 체크
							return false;
						}
			            var buttonFlag = 'N';								//자동기표 FLAG
			            fnMakeLogTable(buttonFlag);
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
				            var buttonFlag = 'D';
				            fnMakeLogTable(buttonFlag);
						}
					}
				}
			}]
		}]
	});

	
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agd400ukrGrid', {
		store	: masterStore,
    	layout	: 'fit',
        region	: 'center',
    	features: [
    		{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
    		{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
    	],
    	uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: { 
    			beforeselect: function( grid , record , index , eOpts ) {
    			},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			sumSaleTaxAmtI	= sumSaleTaxAmtI + selectRecord.get('AMT_I');
					sumCheckedCount	= sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT'	, sumSaleTaxAmtI)
	    			addResult.setValue('COUNT'			, sumCheckedCount)
	    			
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('procCanc').enable();
	    			}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumSaleTaxAmtI	= sumSaleTaxAmtI - selectRecord.get('AMT_I');
					sumCheckedCount	= sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT'	, sumSaleTaxAmtI)
	    			addResult.setValue('COUNT'			, sumCheckedCount)
	    			
	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('procCanc').disable();
	    			}
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
			{dataIndex: 'ORG_AC_DATE'   		, width: 100}, 									//전표일자	
			{dataIndex: 'ORG_SLIP_NUM'			, width: 100, format:'0'}, 									//전표번호
			{dataIndex: 'ORG_SLIP_SEQ'         	, width: 100}, 									//전표순번
			{dataIndex: 'ACCNT'         		, width: 80 }, 									//계정과목
			{dataIndex: 'ACCNT_NAME'			, width: 140}, 									//계정과목명
			{dataIndex: 'GUBUN'					, width: 120		, hidden: true},			//구분(1:사업단위, 2:제품단위)	
			{dataIndex: 'PJT_CODE'				, width: 120}, 									//사업/제품코드	
			{dataIndex: 'PJT_NAME'				, width: 140}, 									//사업/제품명
			{dataIndex: 'REMARK'				, width: 300}, 									//적요
			{dataIndex: 'AMT_I'					, width: 120}, 									//금액	
			{dataIndex: 'DIV_CODE'			   	, width: 80 }, 									//결의사업장코드
			{dataIndex: 'DEPT_CODE'				, width: 80 }, 									//귀속부서(코드)
			{dataIndex: 'DEPT_NAME'				, width: 140}, 									//귀속부서명	
			{dataIndex: 'AC_DATE'      			, width: 100}, 									//결의전표일	
			{dataIndex: 'SLIP_NUM'				, width: 100}, 									//결의전표번호 				
			{dataIndex: 'RE_AC_DATE'      		, width: 100		, hidden: true},	
			{dataIndex: 'RE_SLIP_NUM'			, width: 100		, hidden: true}
		] ,
        listeners: {
        }
    });    
    
	Unilite.Main( {
		id			: 'agd400ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid	, panelResult	,
				{
					xtype	: 'container',
					region	: 'north',
					layout	: 'fit',
					highth	: 20,
					items	: [ addResult ]
				}
			]
		},
		panelSearch  	
		], 
		
		fnInitBinding : function() {
			panelSearch.down('#pjtCodePopup').setVisible(false);
			panelResult.down('#pjtCodePopup').setVisible(false);
			panelSearch.down('#itemCodePopup').setVisible(true);
			panelResult.down('#itemCodePopup').setVisible(true);

			this.setDefault();
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('AC_DATE_FR');	

			//버튼 flag 초기화
			newYN = 0;	
		},

		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			sumSaleTaxAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT'	, 0);
			addResult.setValue('COUNT'			, 0);
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset'	, true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			
			newYN = 1;
			this.fnInitBinding();
		},
		
		//초기 개체 값 및 숨김, 버튼 세팅
		setDefault: function() {
			//초기값 세팅
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('AC_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO', UniDate.get('today'));
			panelResult.setValue('AC_DATE_TO', UniDate.get('today'));

			//초기화 시 구분이 사업단위이므로 "사업코드팝업"은 보이고, "품목코드팝업"은 숨김
			panelSearch.down('#pjtCodePopup').setVisible(true);
			panelResult.down('#pjtCodePopup').setVisible(true);
			panelSearch.down('#itemCodePopup').setVisible(false);
			panelResult.down('#itemCodePopup').setVisible(false);
			
			addResult.setValue('WORK_DATE', UniDate.get('today'));

			addResult.getField('WORK_DIVI').setValue('1');
   			Ext.getCmp('procCanc').setText('자동기표');
			Ext.getCmp('procCanc').disable();

			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			
		}
	});

	function fnMakeLogTable(buttonFlag) {														//자동기표 (insert log table  및 call SP)
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();																//clear buttonStore
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;												//자동기표 flag
			record.data.WORK_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));	//일괄자동기표일 때 전표일자 처리용(실행일자)
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
};
</script>
