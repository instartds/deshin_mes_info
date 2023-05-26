<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiss510ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
<style type="text/css">
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

var assRefWindow;																		//자산참조
	getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	checkAcDateRangeTextBox = true; 													//재평가일 범위 체크

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aiss510ukrvService.selectList',
			update	: 'aiss510ukrvService.updateList',
			create	: 'aiss510ukrvService.insertList',
			destroy	: 'aiss510ukrvService.deleteList',
			syncAll	: 'aiss510ukrvService.saveAll'
		}
	});	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aiss510ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE' 					,text: '법인코드' 				,type: 'string'},
	    	{name: 'ALTER_DIVI' 				,text: 'ALTER_DIVI' 		,type: 'string'},
	    	{name: 'SEQ' 						,text: '순번' 				,type: 'int'},
	    	{name: 'ACCNT_NAME' 				,text: '계정명' 				,type: 'string'},
	    	{name: 'ASST' 						,text: '자산코드' 				,type: 'string'},
	    	{name: 'ASST_NAME' 					,text: '자산명' 				,type: 'string'},
	    	{name: 'SPEC' 						,text: '규격' 				,type: 'string'},
	    	{name: 'ACQ_AMT_I' 					,text: '취득가액' 				,type: 'uniPrice'},
	    	{name: 'ACQ_DATE' 					,text: '취득일' 				,type: 'uniDate'},
	    	{name: 'FN_GL_AMT_I' 				,text: '최종장부가액' 			,type: 'uniPrice'},
	    	{name: 'ALTER_DATE' 				,text: '재평가일' 				,type: 'uniDate', allowBlank: false},
	    	{name: 'ALTER_AMT_I' 				,text: '재평가금액' 			,type: 'uniPrice', defaultValue:0},
	    	{name: 'COLPSB_AMT_I' 				,text: '회수가능금액' 			,type: 'uniPrice', defaultValue:0},
	    	{name: 'ALTER_REASON' 				,text: '사유' 				,type: 'string'},
	    	{name: 'ASST_VARI_AMT_I' 			,text: '자산증감' 				,type: 'uniPrice'},
	    	{name: 'REVAL_VARI_AMT_I' 			,text: '재평가증감' 			,type: 'uniPrice'},
	    	{name: 'SP_VARI_AMT_I' 				,text: '잉여금차이' 			,type: 'uniPrice'},
	    	{name: 'REVAL_VARI_TOT_I' 			,text: '재평가증감누적' 			,type: 'uniPrice'},
	    	{name: 'REVAL_DPR_AMT_I' 			,text: '상각감소액' 			,type: 'uniPrice'},
	    	{name: 'COLPSB_LIM_AMT_I' 			,text: '회수가능한도액' 			,type: 'uniPrice'},
	    	{name: 'DMGLOS_EX_I' 				,text: '손상차손' 				,type: 'uniPrice'},
	    	{name: 'DMGLOS_IN_I' 				,text: '손상차손환입' 			,type: 'uniPrice'},
	    	{name: 'INSERT_DB_USER' 			,text: '입력자' 				,type: 'string'},
	    	{name: 'INSERT_DB_TIME' 			,text: '입력일' 				,type: 'uniDate'},
	    	{name: 'UPDATE_DB_USER' 			,text: '수정자' 				,type: 'string'},
	    	{name: 'UPDATE_DB_TIME' 			,text: '수정일' 				,type: 'uniDate'},
	    	{name: 'WORK_FLAG' 					,text: 'WORK_FLAG' 			,type: 'string'}
			]
	});
	
	Unilite.defineModel('aiss510ukrvAssRefModel', {
	    fields: [
	    	{name: 'CHOICE' 					,text: '선택' 				,type: 'string'},
	    	{name: 'COMP_CODE' 					,text: '법인코드' 				,type: 'string'},
	    	{name: 'ALTER_DIVI' 				,text: 'ALTER_DIVI' 		,type: 'string'},
	    	{name: 'ACCNT_NAME' 				,text: '계정명' 				,type: 'string'},
	    	{name: 'ASST' 						,text: '자산코드' 				,type: 'string'},
	    	{name: 'ASST_NAME' 					,text: '자산명' 				,type: 'string'},
	    	{name: 'SPEC' 						,text: '규격' 				,type: 'string'},
	    	{name: 'ACQ_AMT_I' 					,text: '취득가액' 				,type: 'uniPrice'},
	    	{name: 'ACQ_DATE' 					,text: '취득일' 				,type: 'uniDate'},
	    	{name: 'FN_GL_AMT_I' 				,text: '정부가액' 				,type: 'uniPrice'},
	    	{name: 'FN_ALTER_DATE' 				,text: '최종재평가일' 			,type: 'uniDate'},
	    	{name: 'FN_ALTER_AMT_I' 			,text: '최종재평가액' 			,type: 'uniPrice'},
	    	{name: 'FN_ALTER_REASON' 			,text: '최종재평가사유' 			,type: 'string'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aiss510ukrvMasterStore1',{
		model: 'aiss510ukrvModel',
		uniOpt : {								
			isMaster	: true,			// 상위 버튼 연결 	
			editable	: true,			// 수정 모드 사용 	
			deletable	: true,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용	
		},
        autoLoad: false,
        proxy	: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
    		
//			폼에서 필요한 조건 가져올 경우
			var paramMaster = Ext.getCmp('searchForm').getValues();
       		var rv = true;
       		
        	if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
//				alert(Msg.sMB083);
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
		
		listeners: {
			load: function(store, records, successful, eOpts) {
				if (this.getCount() > 0) {
					UniAppManager.setToolbarButtons('deleteAll', true);
				} else {
					UniAppManager.setToolbarButtons('deleteAll', false);
				}  
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
				
	var assRefStore = Unilite.createStore('aiss510ukrvAssRefStore',{	//자산참조 Store
		model: 'aiss510ukrvAssRefModel',
		uniOpt : {								
					isMaster	: false,			// 상위 버튼 연결 	
					editable	: false,			// 수정 모드 사용 	
					deletable	: false,			// 삭제 가능 여부 	
					useNavi 	: false				// prev | newxt 버튼 사용	
		},
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	read    : 'aiss510ukrvService.selectList2'
            	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('assRefForm').getValues();	
			param.ALTER_DATE = UniDate.getDbDateStr(addResult.getValue('ALTER_DATE'));
			console.log( param );
			this.load({
				params : param
			});
		},
		
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(successful)	{
					var masterRecords = masterStore.data.filterBy(masterStore.filterNewOnly);  
					var assRefRecords = new Array();
    			   
					if(masterRecords.items.length > 0)	{
						Ext.each(records, function(item, i)	{           			   								
   							Ext.each(masterRecords.items, function(record, i)	{
   								console.log("record :", record);
								if( (record.data['ASST'] == item.data['ASST'])){
									assRefRecords.push(item);
								}
 							});		
						});
						store.remove(assRefRecords);
					}
    			}
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel	: '재평가일',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'DATE_FR',
	            endFieldName: 'DATE_TO',
	            startDate	: getStDt[0].STDT,
	            endDate		: getStDt[0].TODT,
	            allowBlank	: false,                	
				autoPopup	: true,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO', newValue);				    		
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
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel		: '계정과목',
		    	valueFieldName	: 'ACCNT_CODE_FR',
		    	textFieldName	: 'ACCNT_NAME_FR',
		    	autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE_FR', panelSearch.getValue('ACCNT_CODE_FR'));
							panelResult.setValue('ACCNT_NAME_FR', panelSearch.getValue('ACCNT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE_FR', '');
						panelResult.setValue('ACCNT_NAME_FR', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                              'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                              'ADD_QUERY': "SPEC_DIVI IN ('K')"
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel		: '~',
				valueFieldName	: 'ACCNT_CODE_TO',
		    	textFieldName	: 'ACCNT_NAME_TO',  	
		    	autoPopup		: true, 
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE_TO', panelSearch.getValue('ACCNT_CODE_TO'));
							panelResult.setValue('ACCNT_NAME_TO', panelSearch.getValue('ACCNT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE_TO', '');
						panelResult.setValue('ACCNT_NAME_TO', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                              'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                              'ADD_QUERY': "SPEC_DIVI IN ('K')"
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
	    	}),
			Unilite.popup('IFRS_ASSET', {
				fieldLabel		: '자산코드', 
				valueFieldName	: 'ASSET_CODE_FR', 
				textFieldName	: 'ASSET_NAME_FR', 
				autoPopup		: true,
			    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"}, 
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_FR', panelSearch.getValue('ASSET_CODE_FR'));
							panelResult.setValue('ASSET_NAME_FR', panelSearch.getValue('ASSET_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE', '');
						panelResult.setValue('ASSET_NAME', '');
					}
				}
			}),
			Unilite.popup('IFRS_ASSET',{ 
				fieldLabel		: '~', 
				valueFieldName	: 'ASSET_CODE_TO', 
				textFieldName	: 'ASSET_NAME_TO', 
				popupWidth		: 710,
				autoPopup		: true,
			    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"}, 
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASSET_CODE_TO', panelSearch.getValue('ASSET_CODE_TO'));
							panelResult.setValue('ASSET_NAME_TO', panelSearch.getValue('ASSET_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASSET_CODE_TO', '');
						panelResult.setValue('ASSET_NAME_TO', '');
					}
				}
			})]
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
//		tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel	: '재평가일',
            xtype		: 'uniDateRangefield',
            startFieldName: 'DATE_FR',
            endFieldName: 'DATE_TO',
            startDate	: getStDt[0].STDT,
            endDate		: getStDt[0].TODT,
            allowBlank	: false,                	
			autoPopup	: true,
            tdAttrs		: {width: 380},   
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO', newValue);				    		
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
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		},		    
	    Unilite.popup('ACCNT',{
	    	fieldLabel		: '계정과목',
	    	valueFieldName	: 'ACCNT_CODE_FR',
	    	textFieldName	: 'ACCNT_NAME_FR',
	    	autoPopup		: true,
            tdAttrs			: {width: 380},  
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE_FR', panelResult.getValue('ACCNT_CODE_FR'));
						panelSearch.setValue('ACCNT_NAME_FR', panelResult.getValue('ACCNT_NAME_FR'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE_FR', '');
					panelSearch.setValue('ACCNT_NAME_FR', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                          'ADD_QUERY': "SPEC_DIVI IN ('K')"
                        }
                        popup.setExtParam(param);
                    }
                }
			}
	    }),	    
	    Unilite.popup('ACCNT',{
	    	fieldLabel		: '~',
			valueFieldName	: 'ACCNT_CODE_TO',
	    	textFieldName	: 'ACCNT_NAME_TO',  	
	    	autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE_TO', panelResult.getValue('ACCNT_CODE_TO'));
						panelSearch.setValue('ACCNT_NAME_TO', panelResult.getValue('ACCNT_NAME_TO'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE_TO', '');
					panelSearch.setValue('ACCNT_NAME_TO', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                          'ADD_QUERY': "SPEC_DIVI IN ('K')"
                        }
                        popup.setExtParam(param);
                    }
                }
			}
    	}),
		Unilite.popup('IFRS_ASSET', {
			fieldLabel		: '자산코드', 
			valueFieldName	: 'ASSET_CODE_FR', 
			textFieldName	: 'ASSET_NAME_FR', 
			autoPopup		: true,
            tdAttrs			: {width: 380}, 
		    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"},  
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE_FR', panelResult.getValue('ASSET_CODE_FR'));
						panelSearch.setValue('ASSET_NAME_FR', panelResult.getValue('ASSET_NAME_FR'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE', '');
					panelSearch.setValue('ASSET_NAME', '');
				}
			}
		}),
		Unilite.popup('IFRS_ASSET',{ 
			fieldLabel		: '~', 
			valueFieldName	: 'ASSET_CODE_TO', 
			textFieldName	: 'ASSET_NAME_TO', 
			popupWidth		: 710,
			autoPopup		: true,
		    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"}, 
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASSET_CODE_TO', panelResult.getValue('ASSET_CODE_TO'));
						panelSearch.setValue('ASSET_NAME_TO', panelResult.getValue('ASSET_NAME_TO'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASSET_CODE_TO', '');
					panelSearch.setValue('ASSET_NAME_TO', '');
				},
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						UniAppManager.app.onQueryButtonDown();
                    }
                }
			}
		})]
	});

	var addResult = Unilite.createSearchForm('detailForm', { 	//createForm
		layout		: {type : 'uniTable', columns : 1, tdAttrs: {width: '100%'}},
		disabled	: false,
		border		: true,
		padding		: '1 1 1 1',
		region		: 'center',
		items		: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
//			tdAttrs: {width: 380},    
	    	items:[{
				fieldLabel	: '재평가일',
	            xtype		: 'uniDatefield',
			 	name		: 'ALTER_DATE',
		        value		: getStDt[0].TODT,
				readOnly	: false,
			 	allowBlank	: false,
				listeners: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							addResult.down('#apply').focus();   
						}
					},
			    	change: function(field, newValue, oldValue, eOpts) {      
			    	}
	     		}
	     	},{			   
				labelText : '',
				xtype	: 'button',
				id		: 'apply',
				itemId	: 'apply',
				text	: '반영',
				margin	: '0 0 2 5',
				width	: 100,
				tdAttrs	: {align: 'left'},
				handler : function() {
					var alterDate = UniDate.getDbDateStr(addResult.getValue('ALTER_DATE'));
					UniAppManager.app.fnCheckAcDateRangeTextBox(alterDate);
					
					var checkDate = 0;
					//조건에 맞는 내용은 적용 되는 로직
					records = masterStore.data.items;
					Ext.each(records, function(record, i) {
						if (checkAcDateRangeTextBox) {
							var acqDate = UniDate.getDbDateStr(record.get('ACQ_DATE'));
							if (acqDate <= alterDate) {
								record.set('ALTER_DATE', alterDate);
							} else {
								checkDate = checkDate + 1
							}
						}
					});
					
					if (checkDate > 0) {
						alert (Msg.fSbMsgA0539);
					}
					//조건에 맞지 않는 내용이 하나라도 있으면 모든 내용이 적용되지 않는 로직
/*					if (checkAcDateRangeTextBox) {
						records = masterStore.data.items;
						Ext.each(records, function(record, i) {
							if (checkDate == 'Y'){
								var acqDate = UniDate.getDbDateStr(record.get('ACQ_DATE'));
								if (acqDate > alterDate) {
									alert (Msg.fSbMsgA0539);
									//조건이 맞지 않으면 checkDate는 'N'이 되어 아래 데이터 업데이트 로직을 타지 않음 (모든 데이터 변경 안 됨)
									checkDate = 'N';
									return false;
								}
							}
						});
						
						if (checkDate == 'Y'){
							Ext.each(records, function(record, i) {
								//위에서 조건을 체크 했을 때, N이 하나도 없으므로 그냥 데이터 업데이트만 하면 됨
								record.set('ALTER_DATE', alterDate);
							});
						}
					}*/
				}
			},{
    		xtype	: 'container',
			html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※자산정보를 참조하여 회수가능액 입력 시, 좌측에 입력된 "재평가일"이 일괄 반영됩니다.',
			style	: {
				color: 'blue'				
			}			
		}]
		}]
	});
	
	var assRefPanel = Unilite.createSearchForm('assRefForm', {	//자산참조
		layout :  {type : 'uniTable', columns : 2},
    	items :[		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel		: '계정과목',
	    	valueFieldName	: 'ACCNT_CODE',
	    	textFieldName	: 'ACCNT_NAME',
	    	autoPopup		: true,
            tdAttrs			: {width: 380},  
		    listeners     : {
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE,
                          'ADD_QUERY': "SPEC_DIVI IN ('K')"
                        }
                        popup.setExtParam(param);
                    }
                }
            }
	    }),{
     		fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		},
		Unilite.popup('IFRS_ASSET', {
			fieldLabel		: '자산코드', 
			valueFieldName	: 'ASSET_CODE_FR', 
			textFieldName	: 'ASSET_NAME_FR', 
			autoPopup		: true,
		    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"}, 
            tdAttrs			: {width: 380}
		}),
		Unilite.popup('IFRS_ASSET',{ 
			fieldLabel		: '~', 
			valueFieldName	: 'ASSET_CODE_TO', 
			textFieldName	: 'ASSET_NAME_TO', 
			popupWidth		: 710,
			autoPopup		: true,
		    extParam		: {'ADD_QUERY': "ASST_DIVI = '1' AND ISNULL(PAT_YN, 'N') = 'N'"}, 
			listeners: {
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						assRefStore.loadStoreRecords();
                    }
                }
			}

		})/*,{
			fieldLabel	: '재평가일',
            xtype		: 'uniDatefield',
		 	name		: 'ALTER_DATE',
	        value		: addResult.getValue('ALTER_DATE'),
			readOnly	: false,
		 	allowBlank	: false
     	}*/]
    });
    
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aiss510ukrvGrid1', {
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: masterStore, 
        title	: '자산재평가',
		uniOpt : {						
			useMultipleSorting	: true,			 	
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
	    	dblClickToEdit		: true,			
	    	useGroupSummary		: true,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: true,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			copiedRow			: false,			
			filter: {					
				useFilter	: false,			
				autoCreate	: true			
			}					
		},
    	tbar: [{
				itemId	: 'assRefBtn',
				text	: '자산참조',
	        	handler	: function() {
	        		var alterDate = UniDate.getDbDateStr(addResult.getValue('ALTER_DATE'));
					var frDate  = getStDt[0].STDT;
					var toDate  = getStDt[0].TODT;
		
					if (!Ext.isEmpty(alterDate) && (alterDate < frDate || alterDate > toDate)) {
						alert (Msg.sMA0447 + '[' + frDate.substring(0,4) + '.' + frDate.substring(4,6) + '.' + frDate.substring(6,8) + '~'
								+ toDate.substring(0,4) + '.' + toDate.substring(4,6) + '.' + toDate.substring(6,8) + ']');				
					} else {
						openAssRefWindow();
					}
	        		
	        		
//	        		var alterDate = UniDate.getDbDateStr(addResult.getValue('ALTER_DATE'));
//	        		UniAppManager.app.fnCheckAcDateRangeTextBox(alterDate);
//		        	openAssRefWindow();
			}
		}],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [ 
			//{dataIndex: 'COMP_CODE' 					, width:66},
			//{dataIndex: 'ALTER_DIVI' 				    , width:66},
			//{dataIndex: 'SEQ' 						    , width:66},
			{dataIndex: 'ACCNT_NAME' 				    , width:80,
	    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
	        	}
	        },
			{dataIndex: 'ASST' 						    , width:80},
			{dataIndex: 'ASST_NAME' 					, width:160},
			{dataIndex: 'SPEC' 						    , width:66},
			{dataIndex: 'ACQ_AMT_I' 					, width:100},
			{dataIndex: 'ACQ_DATE' 					    , width:100},
			{dataIndex: 'FN_GL_AMT_I' 				    , width:110},
			{dataIndex: 'ALTER_DATE' 				    , width:110},
			{dataIndex: 'ALTER_AMT_I' 				    , width:110, 	summaryType: 'sum'},
			{dataIndex: 'COLPSB_AMT_I' 				    , width:110, 	summaryType: 'sum'},
			{dataIndex: 'ALTER_REASON' 				    , width:110},
			{dataIndex: 'ASST_VARI_AMT_I' 			    , width:100},
			{dataIndex: 'REVAL_VARI_AMT_I' 			    , width:100},
			{dataIndex: 'SP_VARI_AMT_I' 				, width:100},
			{dataIndex: 'REVAL_VARI_TOT_I' 			    , width:110},
			{dataIndex: 'REVAL_DPR_AMT_I' 			    , width:100},
			{dataIndex: 'COLPSB_LIM_AMT_I' 			    , width:110},
			{dataIndex: 'DMGLOS_EX_I' 				    , width:100},
			{dataIndex: 'DMGLOS_IN_I' 				    , width:110},
			{dataIndex: 'WORK_FLAG' 				    , width:110, hidden: true}
			//{dataIndex: 'INSERT_DB_USER' 			    , width:66},
			//{dataIndex: 'INSERT_DB_TIME' 			    , width:66},
			//{dataIndex: 'UPDATE_DB_USER' 			    , width:66},
			//{dataIndex: 'UPDATE_DB_TIME' 			    , width:66}
        ],
        listeners: {      		
        	beforeedit  : function( editor, e, eOpts ) {
      			if(UniUtils.indexOf(e.field, ['ALTER_AMT_I', 'COLPSB_AMT_I', 'ALTER_REASON'])) {
					return true;
				} else {
					return false;
				}
      		}
		},
		setRefData: function(record) {						// 참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('COMP_CODE'				, UserInfo.compCode);
       		grdRecord.set('INSERT_DB_USER'			, record['UserInfo.userID']);
       		grdRecord.set('INSERT_DB_TIME'			, UniDate.get('today'));
       		grdRecord.set('UPDATE_DB_USER'			, record['UserInfo.userID']);
       		grdRecord.set('UPDATE_DB_TIME'			, UniDate.get('today'));
       		grdRecord.set('ALTER_DIVI'				, record['ALTER_DIVI']);
       		grdRecord.set('SEQ'						, "1");
       		grdRecord.set('ACCNT_NAME'				, record['ACCNT_NAME']);
       		grdRecord.set('ASST'					, record['ASST']);
       		grdRecord.set('ASST_NAME'				, record['ASST_NAME']);
       		grdRecord.set('SPEC'					, record['SPEC']);
       		grdRecord.set('ACQ_AMT_I'				, record['ACQ_AMT_I']);
       		grdRecord.set('ACQ_DATE'				, record['ACQ_DATE']);
       		grdRecord.set('FN_GL_AMT_I'				, record['FN_GL_AMT_I']);
       		grdRecord.set('ALTER_DATE'				, addResult.getValue('ALTER_DATE'));
       		grdRecord.set('ALTER_AMT_I'				, record['FN_ALTER_AMT_I']);
       		grdRecord.set('COLPSB_AMT_I'			, record['FN_ALTER_AMT_I']);
       		grdRecord.set('ALTER_REASON'			, record['FN_ALTER_REASON']);
       		grdRecord.set('WORK_FLAG'				, 'N');
		}
    });   

    var assRefGrid = Unilite.createGrid('assRefGrid', {			//자산참조
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: assRefStore,
        excelTitle: '자산참조',
		uniOpt : {						
			useMultipleSorting	: true,			 	
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: false,	//체크박스모델은 false로 변경		
	    	dblClickToEdit		: false,			
	    	useGroupSummary		: false,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			copiedRow			: true,			
			filter: {					
				useFilter	: false,			
				autoCreate	: true			
			}					
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				//참조적용 버튼 활성화
    				assRefWindow.down('#applyDamage').setDisabled(false);   

    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() == 0) {
	    				//참조적용 버튼 비활성화
    					assRefWindow.down('#applyDamage').setDisabled(true);   
	    				
	    			}
	    		}
    		}
        }),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [  
//        	{ dataIndex: 'CHOICE' 						,  width: 100},
//        	{ dataIndex: 'COMP_CODE' 					,  width: 100},
//        	{ dataIndex: 'ALTER_DIVI' 					,  width: 100},
        	{ dataIndex: 'ACCNT_NAME' 					,  width: 130},
        	{ dataIndex: 'ASST' 						,  width: 100},
        	{ dataIndex: 'ASST_NAME' 					,  width: 130},
        	{ dataIndex: 'SPEC' 						,  width: 100},
        	{ dataIndex: 'ACQ_AMT_I' 					,  width: 100},
        	{ dataIndex: 'ACQ_DATE' 					,  width: 100},
        	{ dataIndex: 'FN_GL_AMT_I' 					,  width: 100},
        	{ dataIndex: 'FN_ALTER_DATE' 				,  width: 100},
        	{ dataIndex: 'FN_ALTER_AMT_I' 				,  width: 100},
        	{ dataIndex: 'FN_ALTER_REASON'				,  width: 100}
        ],
        listeners: {
        
        },
		returnData: function()	{
			var records = this.getSelectedRecords();       		
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setRefData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}
    });

    function openAssRefWindow() {    		//자산참조 창
		if(!assRefWindow) {
			assRefWindow = Ext.create('widget.uniDetailWindow', {
                title	: '자산참조',
                width	: 1080,				                
                height	: 580,
                layout	: {type:'vbox', align:'stretch'},
                items	: [assRefPanel, assRefGrid],
                tbar	: ['->',{	
					itemId	: 'queryBtn',
					text	: '조회',
					handler	: function() {
						assRefStore.loadStoreRecords();
					},
					disabled: false
				},{	
					itemId	: 'applyDamage',
					text	: '참조적용',
					handler	: function() {
						assRefGrid.returnData();
						assRefWindow.hide();
						assRefGrid.reset();
						assRefPanel.clearForm();
					},
					disabled: true
				},
					
				{
					itemId	: 'closeBtn',
					text	: '닫기',
					handler	: function() {
						assRefWindow.hide();
						assRefGrid.reset();
						assRefPanel.clearForm();
					},
					disabled: false
				}],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
					
		 			beforeclose: function( panel, eOpts )	{
		 			},
		 			
		 			show: function ( panel, eOpts )	{
		 			},
		 			
        			beforeshow: function ( me, eOpts )	{
        				assRefStore.loadStoreRecords();
        			}
				}
			})
		}
		assRefWindow.center();
		assRefWindow.show();
    }

    Unilite.Main({
		borderItems:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, 
				panelResult,
				{
					region	: 'north',
					xtype	: 'container',
					highth	: 20,
					layout	: 'fit',
					items	: [ addResult ]
				}
			]
		},
			panelSearch  	
		],	
		id  : 'aiss510ukrvApp',
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('save',		false);
			UniAppManager.setToolbarButtons('reset',	true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DATE_FR');
			
			this.setDefault();
			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			
			}
		},
		onNewDataButtonDown: function()	{	// 행추가 버튼
            var r = {
				COMP_CODE		: '',
				INSERT_DB_USER	: '',
				INSERT_DB_TIME	: '',
				UPDATE_DB_USER	: '',
				UPDATE_DB_TIME	: '',
				ALTER_DIVI		: '',
				SEQ				: '',
				ACCNT_NAME		: '',
				ASST			: '',
				ASST_NAME		: '',
				SPEC			: '',
				ACQ_AMT_I		: '',
				ACQ_DATE		: '',
				FN_GL_AMT_I		: '',
				ALTER_DATE		: '',
				ALTER_AMT_I		: '',
				COLPSB_AMT_I	: '',	
				ALTER_REASON	: ''	
		    };
			masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectedRecord();						
			console.log("selRow",selRow);
			
			if (selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if (confirm('선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		},
		onDeleteAllButtonDown : function() {
			if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {  
				masterGrid.reset();
           	  	UniAppManager.setToolbarButtons('deleteAll', false);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('DATE_FR',		getStDt[0].STDT);
			panelResult.setValue('DATE_FR',		getStDt[0].STDT);
	 		panelSearch.setValue('DATE_TO', 	getStDt[0].TODT);
	 		panelResult.setValue('DATE_TO', 	getStDt[0].TODT);
	 		
	 		addResult.setValue('ALTER_DATE', 	getStDt[0].TODT);
		},
		//재평가일 범위 체크로직
		fnCheckAcDateRangeTextBox: function(newValue) {
			alterDate = newValue;
					frDate  = getStDt[0].STDT;
					toDate  = getStDt[0].TODT;

			if (!Ext.isEmpty(alterDate) && (alterDate < frDate || alterDate > toDate)) {
				alert (Msg.sMA0447 + '[' + frDate.substring(0,4) + '.' + frDate.substring(4,6) + '.' + frDate.substring(6,8) + '~'
						+ toDate.substring(0,4) + '.' + toDate.substring(4,6) + '.' + toDate.substring(6,8) + ']');				
			} else {
				checkAcDateRangeTextBox = true;
			}
			
			return checkAcDateRangeTextBox;
		},
		processParams: function(params) {		// 링크
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'aiss500skrv') {
				panelSearch.setValue('ALTER_DATE',params.ALTER_DATE);
				panelSearch.setValue('ASSET_CODE_FR',params.ASST);
				panelSearch.setValue('ASSET_NAME_FR',params.ASST_NAME);
				panelSearch.setValue('ASSET_CODE_TO',params.ASST);
				panelSearch.setValue('ASSET_NAME_TO',params.ASST_NAME);
				panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
				panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
				
				panelResult.setValue('ALTER_DATE',params.ALTER_DATE);
				panelResult.setValue('ASSET_CODE_FR',params.ASST);
				panelResult.setValue('ASSET_NAME_FR',params.ASST_NAME);
				panelResult.setValue('ASSET_CODE_TO',params.ASST);
				panelResult.setValue('ASSET_NAME_TO',params.ASST_NAME);
				panelResult.setValue('ACCNT_CODE_FR',params.ACCNT);
				panelResult.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
				panelResult.setValue('ACCNT_CODE_TO',params.ACCNT);
				panelResult.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);

				this.onQueryButtonDown();

				//masterGrid1.getStore().loadStoreRecords();
			}
		}
	});

	//그리드 변경시 발생하는 로직
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var param	= masterGrid.getSelectedRecord;

			switch(fieldName) {		
				case "ALTER_AMT_I"	:							// 재평가금액
					record.set('COLPSB_AMT_I', newValue);
				break;
			}
			return rv;
		}
	});
	
};


</script>