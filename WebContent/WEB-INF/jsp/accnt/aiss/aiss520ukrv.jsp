<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiss520ukrv"  >
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
	checkAcDateRangeTextBox = true; 													//처리일 범위 체크

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aiss520ukrvService.selectList',
			update	: 'aiss520ukrvService.updateList',
			create	: 'aiss520ukrvService.insertList',
			destroy	: 'aiss520ukrvService.deleteList',
			syncAll	: 'aiss520ukrvService.saveAll'
		}
	});	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aiss520ukrvModel', {
	    fields: [
			{name: 'COMP_CODE'		 			,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'ALTER_DIVI'					,text: 'ALTER_DIVI' 	,type: 'string'},
	    	{name: 'SEQ'              			,text: 'SEQ' 			,type: 'int'},
	   		{name: 'ACCNT'   	 				,text: '계정코드' 			,type: 'string'},
	   		{name: 'ACCNT_NAME'   	 			,text: '계정명' 			,type: 'string'},
	   		{name: 'ASST'				 		,text: '자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'        			,text: '자산명' 			,type: 'string'},
	   		{name: 'SPEC'			 			,text: '규격' 			,type: 'string'},
	   		{name: 'ACQ_AMT_I'		 			,text: '취득가액' 			,type: 'uniPrice'},
	   		{name: 'ACQ_DATE'					,text: '취득일' 			,type: 'uniDate'},
	   		{name: 'FN_GL_AMT_I'				,text: '장부가액' 			,type: 'uniPrice'},
	   		{name: 'ALTER_DATE'					,text: '처리일' 			,type: 'uniDate',		allowBlank: false},
	   		{name: 'ALTER_AMT_I'				,text: '회수가능금액' 		,type: 'uniPrice',		allowBlank: false},
	   		{name: 'COLPSB_AMT_I'				,text: 'COLPSB_AMT_I' 	,type: 'uniPrice',		allowBlank: false},
	   		{name: 'ALTER_REASON'				,text: '손상사유' 			,type: 'string'},
	   		{name: 'COLPSB_LIM_AMT_I'			,text: '회수가능한한도액' 	,type: 'uniPrice'},
	   		{name: 'DMGLOS_EX_I'	    		,text: '손상차손' 			,type: 'uniPrice'},
	   		{name: 'DMGLOS_IN_I'	    		,text: '손상차손환입' 		,type: 'uniPrice'},
	   		{name: 'INSERT_DB_USER'  			,text: 'INSERT_DB_USER' ,type: 'string'},
	   		{name: 'INSERT_DB_TIME'  			,text: 'INSERT_DB_TIME' ,type: 'string'},
	   		{name: 'UPDATE_DB_USER'  			,text: 'UPDATE_DB_USER' ,type: 'string'},
	   		{name: 'UPDATE_DB_TIME'  			,text: 'UPDATE_DB_TIME' ,type: 'string'}
		]
	});
	
	Unilite.defineModel('aiss520ukrvAssRefModel', {
	    fields: [
			{name: 'COMP_CODE'		 			,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'ALTER_DIVI'					,text: 'ALTER_DIVI' 	,type: 'string'},
	   		{name: 'ACCNT' 		  	 			,text: '계정코드' 			,type: 'string'},
	   		{name: 'ACCNT_NAME'   	 			,text: '계정명' 			,type: 'string'},
	   		{name: 'ASST'				 		,text: '자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'        			,text: '자산명' 			,type: 'string'},
	   		{name: 'SPEC'			 			,text: '규격' 			,type: 'string'},
	   		{name: 'ACQ_AMT_I'		 			,text: '취득가액' 			,type: 'uniPrice'},
	   		{name: 'ACQ_DATE'					,text: '취득일' 			,type: 'uniDate'},
	   		{name: 'FN_GL_AMT_I'				,text: '장부가액' 			,type: 'uniPrice'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aiss520ukrvMasterStore1',{
		model: 'aiss520ukrvModel',
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
        		var saveData = toCreate.concat(toUpdate) ;
           		var dateChk = true;
           		Ext.each(saveData, function(record, idx){
           			if(UniDate.getDbDateStr(addResult.getValue("ALTER_DATE")) < UniDate.getDbDateStr(record.get("ACQ_DATE"))) {
           				dateChk = false;
           			}
           		});
           		if(!dateChk)	{
           			Unilite.messageBox("처리일이 취특일 보다 빠릅니다.");
           			return;
        		}
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
				
	var assRefStore = Unilite.createStore('aiss520ukrvAssRefStore',{	//자산참조 Store
		model: 'aiss520ukrvAssRefModel',
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
            	read    : 'aiss520ukrvService.selectList2'
            	
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
				fieldLabel	: '처리일',
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
//				value		: UserInfo.divCode,
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
			fieldLabel	: '처리일',
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
//			value		: UserInfo.divCode,
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
				fieldLabel	: '처리일',
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
			html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※자산정보를 참조하여 회수가능액 입력 시, 좌측에 입력된 "처리일"이 일괄 반영됩니다.',
			style	: {
//				marginTop: '3px !important',
//				font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
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
		    listeners      : {
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
//			value		: UserInfo.divCode,
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
            tdAttrs			: {width: 380}
		}),
			Unilite.popup('IFRS_ASSET',{ 
			fieldLabel		: '~', 
			valueFieldName	: 'ASSET_CODE_TO', 
			textFieldName	: 'ASSET_NAME_TO', 
			popupWidth		: 710,
			autoPopup		: true,
			listeners: {
				onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
						assRefStore.loadStoreRecords();
                    }
                }
			}

		})]
    });
    
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aiss520ukrvGrid1', {
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: masterStore, 
        title	: '자산손상',
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
		        	openAssRefWindow();
			}
		}],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [        
			{ dataIndex: 'COMP_CODE', 				width: 100,		hidden: true},
			{ dataIndex: 'ALTER_DIVI', 				width: 100,		hidden: true},
			{ dataIndex: 'SEQ', 					width: 100,		hidden: true},
			{ dataIndex: 'ACCNT', 					width: 100,		hidden: true},
			{ dataIndex: 'ACCNT_NAME', 				width: 100,
	    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
	        	}
	        },
			{ dataIndex: 'ASST', 					width: 100},
			{ dataIndex: 'ASST_NAME', 				width: 200},
			{ dataIndex: 'SPEC', 					width: 66},
			{ dataIndex: 'ACQ_AMT_I', 				width: 120},
			{ dataIndex: 'ACQ_DATE', 				width: 100},
			{ dataIndex: 'FN_GL_AMT_I', 			width: 120},
			{ dataIndex: 'ALTER_DATE', 				width: 100},
			{ dataIndex: 'ALTER_AMT_I', 			width: 120, 	summaryType: 'sum'},
			{ dataIndex: 'COLPSB_AMT_I', 			width: 120,		hidden: true},
			{ dataIndex: 'ALTER_REASON', 			width: 100},
			{ dataIndex: 'COLPSB_LIM_AMT_I', 		width: 120},
			{ dataIndex: 'DMGLOS_EX_I', 			width: 120, 	summaryType: 'sum'},
			{ dataIndex: 'DMGLOS_IN_I', 			width: 120, 	summaryType: 'sum'},
			{ dataIndex: 'INSERT_DB_USER', 			width: 100,		hidden: true},
			{ dataIndex: 'INSERT_DB_TIME', 			width: 100,		hidden: true},
			{ dataIndex: 'UPDATE_DB_USER', 			width: 100,		hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME', 			width: 100,		hidden: true}
        ],
        listeners: {      		
        	beforeedit  : function( editor, e, eOpts ) {
      			if (!UniUtils.indexOf(e.field,['ALTER_AMT_I', 'ALTER_REASON'])){
					return false;
  				} 
      		}
		},
		setRefData: function(record) {
       		var grdRecord = this.getSelectedRecord();
       
			grdRecord.set('COMP_CODE',        UserInfo.compCode);               					
			grdRecord.set('SEQ',              '1');               					//순번
			grdRecord.set('ALTER_DIVI',       record['ALTER_DIVI']);        		//변동구분
			grdRecord.set('ACCNT',	      	  record['ACCNT']);       				//계정코드
			grdRecord.set('ACCNT_NAME',       record['ACCNT_NAME']);       			//계정명
			grdRecord.set('ASST',             record['ASST']);              		//자산코드
			grdRecord.set('ASST_NAME',        record['ASST_NAME']);         		//자산명
			grdRecord.set('SPEC',             record['SPEC']);              		//규격
			grdRecord.set('ACQ_AMT_I',        record['ACQ_AMT_I']);         		//취득가액
			grdRecord.set('ACQ_DATE',         record['ACQ_DATE']);          		//취득일
			grdRecord.set('FN_GL_AMT_I',      record['FN_GL_AMT_I']);      			//최종장부금액
			grdRecord.set('ALTER_DATE',       addResult.getValue('ALTER_DATE'));    //처리일
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
	    	dblClickToEdit		: true,		//masterGrid의 uniOpt와 충돌 (false -> true 변경)			
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
			{ dataIndex: 'COMP_CODE', 			width: 100,		hidden: true},
			{ dataIndex: 'ALTER_DIVI', 			width: 100,		hidden: true},
			{ dataIndex: 'ACCNT', 				width: 105,		hidden: true},
			{ dataIndex: 'ACCNT_NAME', 			width: 100},
			{ dataIndex: 'ASST', 				width: 100},
			{ dataIndex: 'ASST_NAME', 			width: 200},
			{ dataIndex: 'SPEC', 				width: 66},
			{ dataIndex: 'ACQ_AMT_I', 			width: 120},
			{ dataIndex: 'ACQ_DATE', 			width: 100},
			{ dataIndex: 'FN_GL_AMT_I', 		flex: 1}
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
					text	: '손상적용',
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
		id  : 'aiss520ukrvApp',
		
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
			
			this.processParams(params);
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			
			}
		},
		onNewDataButtonDown: function()	{
			 // masterGrid Default 값 설정
	    	 var r = {
				COMP_CODE		:			'',
				ALTER_DIVI		:			'',
				SEQ				:			'',
				ACCNT_NAME		:			'',
				ASST			:			'',
				ASST_NAME		:			'',
				SPEC			:			'',
				ACQ_AMT_I		:			'',
				ACQ_DATE		:			'',
				FN_GL_AMT_I		:			'',
				ALTER_DATE		:			'',
				ALTER_AMT_I		:			'',
				COLPSB_AMT_I	:			'',
				ALTER_REASON	:			'',
				COLPSB_LIM_AMT_I:			'',
				DMGLOS_EX_I		:			'',
				DMGLOS_IN_I		:			'',
				INSERT_DB_USER	:			'',	
				INSERT_DB_TIME	:			'',
				UPDATE_DB_USER	:			'',
				UPDATE_DB_TIME	:			''
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
			} else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		},

		onDeleteAllButtonDown : function() {
			if(confirm("모두 삭제 됩니다." + "\n" + '전체 삭제하시겠습니까?')) {  
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
		
		//처리일 범위 체크로직
		fnCheckAcDateRangeTextBox: function(newValue){
			alterDate = newValue;
			frDate  = getStDt[0].STDT;
			toDate  = getStDt[0].TODT;

			if (!Ext.isEmpty(alterDate) && (alterDate < frDate || alterDate > toDate)) {
				alert ('[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);				//
				checkAcDateRangeTextBox = false;
			} else {
				checkAcDateRangeTextBox = true;
			}
			
			return checkAcDateRangeTextBox;
		},
		
		processParams: function(params) {		// 링크
			if(params)	{
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
				case "ALTER_AMT_I"	:							// 행사수량
					record.set('COLPSB_AMT_I', newValue);
				break;
			}
			return rv;
		}
	});
	
};


</script>