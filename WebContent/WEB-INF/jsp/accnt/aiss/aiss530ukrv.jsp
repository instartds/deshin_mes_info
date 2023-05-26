<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiss530ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="A" comboCode="A020" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="A" comboCode="A022" />	<!-- 증빙유형(매입) -->
	<t:ExtComboStore comboType="A" comboCode="A035" />	<!-- 상각완료여부 -->
	<t:ExtComboStore comboType="A" comboCode="A036" />	<!-- 상각방법 -->
	<t:ExtComboStore comboType="A" comboCode="A039" />	<!-- 매각/폐기구분 -->
	<t:ExtComboStore comboType="A" comboCode="A042" />	<!-- 자산구분 -->
	<t:ExtComboStore comboType="A" comboCode="A140" />	<!-- 결제유형 -->
	<t:ExtComboStore comboType="A" comboCode="A149" />	<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="A" comboCode="B004" />	<!-- 화폐단위 -->

</t:appConfig>
<style type="text/css">	
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {

var assRefWindow;																		//자산참조
	getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	checkAcDateRangeTextBox = true; 													//처분일 범위 체크

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aiss530ukrvService.selectList',
			update	: 'aiss530ukrvService.updateList',
			create	: 'aiss530ukrvService.insertList',
			destroy	: 'aiss530ukrvService.deleteList',
			syncAll	: 'aiss530ukrvService.saveAll'
		}
	});	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aiss530ukrvModel', {
	    fields: [
			{name: 'COMP_CODE'		 			,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'ALTER_DIVI'					,text: 'ALTER_DIVI' 	,type: 'string'},
	    	{name: 'ASST_DIVI'					,text: '자산구분' 			,type: 'string',	comboType: 'A',		comboCode: 'A042'},
	    	{name: 'SEQ'              			,text: 'SEQ' 			,type: 'int'},
	   		{name: 'ACCNT'   	 				,text: '계정코드' 			,type: 'string'},
	   		{name: 'ACCNT_NAME'   	 			,text: '계정명' 			,type: 'string'},
	   		{name: 'ASST'				 		,text: '자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'        			,text: '자산명' 			,type: 'string'},
	   		{name: 'SPEC'			 			,text: '규격' 			,type: 'string'},
	   		{name: 'ACQ_AMT_I'		 			,text: '취득가액' 			,type: 'uniPrice'},
	   		{name: 'ACQ_DATE'					,text: '취득일' 			,type: 'uniDate'},
	   		{name: 'STOCK_Q'					,text: 'STOCK_Q' 		,type: 'uniQty'},
	   		{name: 'WASTE_DIVI'					,text: '구분'				,type: 'string',	comboType: 'A',		comboCode: 'A039',	allowBlank: false}, //구분(매각/폐기)
	   		{name: 'ALTER_YYMM'					,text: '처분월' 			,type: 'string'},
	   		{name: 'ALTER_DATE'					,text: '처분일' 			,type: 'uniDate',	allowBlank: false},
	   		{name: 'ALTER_Q'					,text: '처분수량' 			,type: 'uniQty',	allowBlank: false},
	   		{name: 'MONEY_UNIT'					,text: '화폐단위' 			,type: 'string',	comboType: 'A',		comboCode: 'B004', displayField: 'value',	allowBlank: false},
	   		{name: 'EXCHG_RATE_O'				,text: '환율' 			,type: 'uniER'},
	   		{name: 'FOR_ALTER_AMT_I'			,text: '외화처분금액' 		,type: 'uniFC'},
	   		{name: 'ALTER_AMT_I'				,text: '처분액' 			,type: 'uniPrice',	allowBlank: false},
	   		{name: 'ALTER_REASON'				,text: '처분사유' 			,type: 'string'},
	   		{name: 'SET_TYPE'					,text: '결제유형' 			,type: 'string',	comboType: 'A',		comboCode: 'A140'},
	   		{name: 'PROOF_KIND'					,text: '증빙유형' 			,type: 'string',	comboType: 'A',		comboCode: 'A022'},
	   		{name: 'SUPPLY_AMT_I'				,text: '공급가액' 			,type: 'uniPrice'},
	   		{name: 'TAX_AMT_I'					,text: '세액' 			,type: 'uniPrice'},
	   		{name: 'CUSTOM_CODE'				,text: '거래처코드' 		,type: 'string'},
	   		{name: 'CUSTOM_NAME'				,text: '거래처명' 			,type: 'string'},
	   		{name: 'SAVE_CODE'					,text: '통장코드' 			,type: 'string'},
	   		{name: 'SAVE_NAME'					,text: '통장명' 			,type: 'string'},
	   		{name: 'PAY_SCD_DATE'				,text: '회수예정일' 		,type: 'uniDate'},
	   		{name: 'EB_YN'						,text: '전자발행여부' 		,type: 'string',	comboType: 'A',		comboCode: 'A149'},
	   		{name: 'ALTER_PROFIT'				,text: '처분손익' 			,type: 'uniPrice'},
	   		{name: 'EX_DATE'					,text: '전표일자' 			,type: 'string'},
	   		{name: 'EX_NUM'						,text: '전표번호' 			,type: 'string'},
	   		{name: 'INSERT_DB_USER'  			,text: 'INSERT_DB_USER' ,type: 'string'},
	   		{name: 'INSERT_DB_TIME'  			,text: 'INSERT_DB_TIME' ,type: 'string'},
	   		{name: 'UPDATE_DB_USER'  			,text: 'UPDATE_DB_USER' ,type: 'string'},
	   		{name: 'UPDATE_DB_TIME'  			,text: 'UPDATE_DB_TIME' ,type: 'string'},
	   		{name: 'REF_CODE1'  				,text: 'REF_CODE1'		,type: 'string'}
		]
	});
	
	Unilite.defineModel('aiss530ukrvAssRefModel', {
	    fields: [
			{name: 'COMP_CODE'		 			,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'ALTER_DIVI'					,text: 'ALTER_DIVI' 	,type: 'string'},
	    	{name: 'ASST_DIVI'					,text: '자산구분' 			,type: 'string',	comboType: 'A',		comboCode: 'A042'},
	   		{name: 'ACCNT' 		  	 			,text: '계정코드' 			,type: 'string'},
	   		{name: 'ACCNT_NAME'   	 			,text: '계정명' 			,type: 'string'},
	   		{name: 'ASST'				 		,text: '자산코드' 			,type: 'string'},
	   		{name: 'ASST_NAME'        			,text: '자산명' 			,type: 'string'},
	   		{name: 'SPEC'			 			,text: '규격' 			,type: 'string'},
	   		{name: 'ACQ_AMT_I'		 			,text: '취득가액' 			,type: 'uniPrice'},
	   		{name: 'ACQ_DATE'					,text: '취득일' 			,type: 'uniDate'},
	   		{name: 'ACQ_Q'						,text: '취득수량' 			,type: 'uniQty'},
	   		{name: 'STOCK_Q'					,text: 'STOCK_Q' 		,type: 'uniPrice'}
		]	
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aiss530ukrvMasterStore1',{
		model: 'aiss530ukrvModel',
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
       		
//			SET_TYPE변경에 따른 필수 체크
        	var list = [].concat(toUpdate,toCreate);
        	var isErr = false;
        	Ext.each(list, function(record, index) {
	        	if(record.get('WASTE_DIVI') != '1') {
					return false;
				} else {
					var alertMessage = '';
		        	if(!Ext.isEmpty(record.get('SET_TYPE'))) {
		        		if  (Ext.isEmpty(record.get('PROOF_KIND'))){
							alertMessage = alertMessage + ' 증빙유형';
							isErr = true;
		        		}
		        		if  (Ext.isEmpty(record.get('SUPPLY_AMT_I'))){
							alertMessage = alertMessage + ' 공급가액';
							isErr = true;
		        		}
		        		if  (Ext.isEmpty(record.get('TAX_AMT_I'))){
							alertMessage = alertMessage + ' 세액';
							isErr = true;
		        		}
		        		if  (Ext.isEmpty(record.get('CUSTOM_CODE'))){
							alertMessage = alertMessage + ' 고객코드';
							isErr = true;
		        		}
/*		        		if  (Ext.isEmpty(record.get('CUSTOM_NAME'))){
							alertMessage = alertMessage + '증빙유형';
							isErr = true;
		        		}*/
		        		if  (Ext.isEmpty(record.get('EB_YN'))){
							alertMessage = alertMessage + ' 전자발행여부';
							isErr = true;
		        		}
		        		if  (record.get('REF_CODE1') == '20' && Ext.isEmpty(record.get('SAVE_CODE'))){
							alertMessage = alertMessage + ' 통장코드';
							isErr = true;
		        		}
		        		
		        		if (Ext.isEmpty(alertMessage)) {
		        			isErr = false;
		        			return false;
		        		} else {
		        			alert ((index+1) + '행의' + alertMessage + ' 은(는) 필수 입력항목 입니다.')
							return false;
		        		}
					}
				}
        	});
        	if(isErr) return false;
    		
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
	        /*	Ext.each(records, function(record, index) {
					var param =  {"aParam0": "REF_CODE1",
								  "aParam1": "A140",
								  "aParam2": record.get('SET_TYPE'),
								  "aParam3": "",
								  "aParam4": UserInfo.compCode
					};
					accntCommonService.fnGetCommon(param, function(provider, response){					// EXCEPTION_JUMP로 리턴 받음
						var setTypeRef1 = provider.EXCEPTION_JUMP;
						record.set ('REF_CODE1',	setTypeRef1);
	        			masterStore.commitChanges();  
					});
	        	});*/
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
				
	var assRefStore = Unilite.createStore('aiss530ukrvAssRefStore',{	//자산참조 Store
		model: 'aiss530ukrvAssRefModel',
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
            	read    : 'aiss530ukrvService.selectList2'
            	
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
				fieldLabel	: '처분일',
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
			fieldLabel	: '처분일',
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
				fieldLabel	: '처분일',
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
					var checkAcDateRangeTextBox = UniAppManager.app.fnCheckAcDateRangeTextBox(alterDate)
					if (!checkAcDateRangeTextBox) {
						alert ('[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);
						return false;
					}
					
					var checkDate = 'Y';
					//조건에 맞는 내용은 적용 되는 로직
					records = masterStore.data.items;
					Ext.each(records, function(record, i) {
					if (checkAcDateRangeTextBox) {
						var acqDate = UniDate.getDbDateStr(record.get('ACQ_DATE'));
						if (acqDate <= alterDate) {
							record.set('ALTER_DATE', alterDate);
						} else {
							alert (Msg.fSbMsgA0539);
							return false;
						}
					}
					});
				}
			},{
    		xtype	: 'container',
			html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※자산정보를 참조하여 처분 적용 시, 좌측에 입력된 "처분일"이 일괄 반영됩니다.',
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

		}),{
     		fieldLabel	: '자산구분',
			name		: 'ASST_DIVI',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A042'
		}]
    });
    
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aiss530ukrvGrid1', {
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: masterStore, 
        title	: '자산매각폐기',
		uniOpt : {						
			useMultipleSorting	: true,			 	
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
	    	dblClickToEdit		: true,			
	    	useGroupSummary		: true,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
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
			{ dataIndex: 'COMP_CODE',				width: 100,		hidden: true},
			{ dataIndex: 'ALTER_DIVI',				width: 100,		hidden: true},
			{ dataIndex: 'ASST_DIVI',				width: 100},
			{ dataIndex: 'SEQ',            			width: 100,		hidden: true},
			{ dataIndex: 'ACCNT',   	 			width: 100,		hidden: true},
			{ dataIndex: 'ACCNT_NAME',   			width: 100,
	    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
	        	}
	        },
			{ dataIndex: 'ASST',					width: 100},
			{ dataIndex: 'ASST_NAME',      			width: 200},
			{ dataIndex: 'SPEC',					width: 66},
			{ dataIndex: 'ACQ_AMT_I',				width: 166, 	summaryType: 'sum'},
			{ dataIndex: 'ACQ_DATE',				width: 100},
			{ dataIndex: 'STOCK_Q',					width: 100,		hidden: true},
			{ dataIndex: 'WASTE_DIVI',				width: 100},
			{ dataIndex: 'ALTER_YYMM',				width: 100,		hidden: true},
			{ dataIndex: 'ALTER_DATE',				width: 100},
			{ dataIndex: 'ALTER_Q',		 			width: 100},
			{ dataIndex: 'MONEY_UNIT',				width: 100},
			{ dataIndex: 'EXCHG_RATE_O',			width: 100},
			{ dataIndex: 'FOR_ALTER_AMT_I',			width: 166},
			{ dataIndex: 'ALTER_AMT_I',				width: 166, 	summaryType: 'sum'},
			{ dataIndex: 'ALTER_REASON',			width: 100},
			{ dataIndex: 'SET_TYPE',				width: 100},
			{ dataIndex: 'PROOF_KIND',  			width: 100,
				editor:{
			  		xtype: 'uniCombobox',
			  		store: Ext.data.StoreManager.lookup('CBS_A_A022'),
			  		listeners:{
			  			beforequery:function(queryPlan, value)	{
			  				var record = masterGrid.getSelectedRecord();
			  				this.store.clearFilter();
			  				var asstDivi = masterGrid.uniOpt.currentRecord.get('ALTER_DIVI') ;
			  				this.store.filterBy(function(record){return record.get('refCode3') == asstDivi},this)
			  			}
			  		}
				}
			},
			{ dataIndex: 'SUPPLY_AMT_I',			width: 166},
			{ dataIndex: 'TAX_AMT_I',				width: 166},
			{ dataIndex: 'CUSTOM_CODE',				width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
	                    },
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
        			}
	        	})
        	},
			{ dataIndex: 'CUSTOM_NAME',				width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
	                    },
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
        			}
	        	})
        	},
			{ dataIndex: 'SAVE_CODE',				width: 100,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
						}
					}
				})
				
			},
			{ dataIndex: 'SAVE_NAME',				width: 100,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
						}
					}
				})
        	},
			{ dataIndex: 'PAY_SCD_DATE',			width: 100},
			{ dataIndex: 'EB_YN',					width: 100},
			{ dataIndex: 'ALTER_PROFIT',			width: 100},
			{ dataIndex: 'EX_DATE',					width: 100},
			{ dataIndex: 'EX_NUM',					width: 100},
			{ dataIndex: 'INSERT_DB_USER', 			width: 100,		hidden: true},
			{ dataIndex: 'INSERT_DB_TIME',			width: 100,		hidden: true},
			{ dataIndex: 'UPDATE_DB_USER',  		width: 100,		hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME',  		width: 100,		hidden: true},
			{ dataIndex: 'REF_CODE1',	 			width: 100,		hidden: true}
        ],
        listeners: {      		
        	beforeedit  : function( editor, e, eOpts ) {
      			if (UniUtils.indexOf(e.field,['ASST_DIVI', 'ACCNT_NAME', 'ASST', 'ASST_NAME'
			      							, 'SPEC', 'ACQ_AMT_I', 'ACQ_DATE'
			      							, 'ALTER_PROFIT', 'EX_DATE', 'EX_NUM'])){
					return false;
  				} 
      		}
		},
		setRefData: function(record) {
       		var grdRecord = this.getSelectedRecord();
       
			grdRecord.set('COMP_CODE',        UserInfo.compCode);               					
			grdRecord.set('SEQ',              '1');               					
			grdRecord.set('ALTER_DIVI',       record['ALTER_DIVI']);        		
			grdRecord.set('ASST_DIVI',        record['ASST_DIVI']);        			
			grdRecord.set('ACCNT',	      	  record['ACCNT']);       				
			grdRecord.set('ACCNT_NAME',       record['ACCNT_NAME']);       			
			grdRecord.set('ASST',             record['ASST']);              		
			grdRecord.set('ASST_NAME',        record['ASST_NAME']);         		
			grdRecord.set('SPEC',             record['SPEC']);              		
			grdRecord.set('ACQ_AMT_I',        record['ACQ_AMT_I']);         		
			grdRecord.set('ACQ_DATE',         record['ACQ_DATE']);          		
			grdRecord.set('STOCK_Q',		  record['STOCK_Q']);      				
			grdRecord.set('FN_GL_AMT_I',      record['FN_GL_AMT_I']);      			
			grdRecord.set('ALTER_YYMM',       UniDate.getDbDateStr(addResult.getValue('ALTER_DATE'))).toString(0,5);
			grdRecord.set('ALTER_DATE',       addResult.getValue('ALTER_DATE'));    
			grdRecord.set('MONEY_UNIT',       UserInfo.currency);
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
			{ dataIndex: 'ASST_DIVI', 			width: 80},
			{ dataIndex: 'ACCNT', 				width: 100,		hidden: true},
			{ dataIndex: 'ACCNT_NAME', 			width: 100},
			{ dataIndex: 'ASST', 				width: 100},
			{ dataIndex: 'ASST_NAME', 			width: 200},
			{ dataIndex: 'SPEC', 				width: 66},
			{ dataIndex: 'ACQ_AMT_I', 			width: 100},
			{ dataIndex: 'ACQ_DATE', 			width: 80},
			{ dataIndex: 'ACQ_Q', 				width: 70},
			{ dataIndex: 'STOCK_Q', 			width: 100,		hidden: true}
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
					text	: '매각적용',
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
		id  : 'aiss530ukrvApp',
		
		fnInitBinding : function() {
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
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {
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
/*			if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {  
				masterGrid.reset();
           	  	UniAppManager.setToolbarButtons('deleteAll', false);
			}*/
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
		
		//처분일 범위 체크로직
		fnCheckAcDateRangeTextBox: function(newValue){
			alterDate = newValue;
			frDate  = getStDt[0].STDT;
			toDate  = getStDt[0].TODT;

			if (!Ext.isEmpty(alterDate) && (alterDate < frDate || alterDate > toDate)) {
//				alert ('[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336);				//
				checkAcDateRangeTextBox = false;
			} else {
				checkAcDateRangeTextBox = true;
			}
			
			return checkAcDateRangeTextBox;
		},
	
		//매각/폐기구분 변경 시, 해당 Row의 데이터 초기화
		fnClearAlterInfo: function(record, newValue){
			if(newValue !== '1') {
				record.set ('MONEY_UNIT',		''); 
				record.set ('EXCHG_RATE_O',		''); 
				record.set ('FOR_ALTER_AMT_I',	''); 
				record.set ('ALTER_AMT_I',		''); 
				record.set ('SET_TYPE',			''); 
				record.set ('PROOF_KIND',		''); 
				record.set ('SUPPLY_AMT_I',		''); 
				record.set ('TAX_AMT_I',		''); 
				record.set ('CUSTOM_CODE',		''); 
				record.set ('CUSTOM_NAME',		''); 
				record.set ('SAVE_CODE',		''); 
				record.set ('SAVE_NAME',		''); 
				record.set ('PAY_SCD_DATE',		''); 
				record.set ('EB_YN',			''); 
				record.set ('ALTER_PROFIT',	''); 
			}
		},
		
		//동일월 체크
		fnCheckSameMonth: function(record, newValue){
			var records = masterStore.data.items;  
			var presentAsst = record.obj.data.ASST;
			    checkSameMonth = false;
			alterYYMM = UniDate.getDbDateStr(newValue).substring(0,6);
			
			Ext.each(records, function(record2, i)	{    
				if (presentAsst != record2.data['ASST']) {
					if( (record2.data['ALTER_YYMM'] == alterYYMM)){
//						alert(Msg.fSbMsgA0327);
						checkSameMonth = false;
						return false;
					} else {
						checkSameMonth = true;
					}
				}
			});

			return checkSameMonth;
		},
		
		//발생금액 자동계산
		fnCalAlterAmt: function(record, newValue, fieldName){
			if (fieldName ==  'EXCHG_RATE_O') {
				var exchgRateO = newValue;
				var forAlterAmtI = record.get('FOR_ALTER_AMT_I');
			} else {
				var exchgRateO = record.get('EXCHG_RATE_O');
				var forAlterAmtI = newValue
			}
			
			record.set('ALTER_AMT_I', Math.floor(exchgRateO * forAlterAmtI));
		},
		
/*		//결제유형이 변경됨에 따라 설정변경 - 로우별 필수커럼 처리 (savestore에서 처리)
		fnChangedSetType: function(record, newValue){
			if(record.get('WASTE_DIVI') != '1') {
				return false;
			} else {
				record.set ('SUPPLY_AMT_I',		record.get('ALTER_AMT_I')); 
			}
			
			if(record.get('WASTE_DIVI') != '1') {
				return false;
			} else {
				record.set ('SUPPLY_AMT_I',		record.get('ALTER_AMT_I')); 
				//1. 결제유형에 따른 필수입력컬럼 변경 (그리드 동적으로 필수 처리하는 로직은 구현되지 않음)
				if (!Ext.isEmpty(newValue)) {
					record.getColumn("PROOF_KIND").setConfig('allowBlank', false);  
					record.getColumn("SUPPLY_AMT_I").setConfig('allowBlank', false);  
					record.getColumn("TAX_AMT_I").setConfig('allowBlank', false);  
					record.getColumn("CUSTOM_CODE").setConfig('allowBlank', false);  
					record.getColumn("CUSTOM_NAME").setConfig('allowBlank', false);  
					record.getColumn("EB_YN").setConfig('allowBlank', false);  
				} else {
					record.getColumn("PROOF_KIND").setConfig('allowBlank', true);  
					record.getColumn("SUPPLY_AMT_I").setConfig('allowBlank', true);  
					record.getColumn("TAX_AMT_I").setConfig('allowBlank', true);  
					record.getColumn("CUSTOM_CODE").setConfig('allowBlank', true);  
					record.getColumn("CUSTOM_NAME").setConfig('allowBlank', true);  
					record.getColumn("EB_YN").setConfig('allowBlank', true);  
				}
				//2. 결제유형의 REF1에 따른 필수입력컬럼 변경 (그리드 동적으로 필수 처리하는 로직은 구현되지 않음)
				//2-1. REF_CODE1 조회
				var param =  {"aParam0": "REF_CODE1",
							  "aParam1": "A140",
							  "aParam2": newValue,
							  "aParam3": "",
							  "aParam4": UserInfo.compCode
				};

				accntCommonService.fnGetCommon(param, function(provider, response){					// EXCEPTION_JUMP로 리턴 받음
					var setTypeRef1 = provider.EXCEPTION_JUMP;
					//2-2 REF_CODE1에 따라 그리드 컬럼 동적으로 필수처리 (구현되지 않음)
					if (setTypeRef1 == '20') {
						record.getColumn("SAVE_CODE").setConfig('allowBlank', false);  
						record.getColumn("SAVE_NAME").setConfig('allowBlank', false);  
					} else {
						record.getColumn("SAVE_CODE").setConfig('allowBlank', true);  
						record.getColumn("SAVE_NAME").setConfig('allowBlank', true);  
					}
				});
				
				
			}
		},*/
		
		//세액 계산
		fnCalTaxAmt: function(record, newValue){
	    	var supplyAmtI = record.get('SUPPLY_AMT_I');
			var param =  {"aParam0": "REF_CODE2",
						  "aParam1": "A022",
						  "aParam2": /*Ext.isEmpty(newValue) ? '': */newValue,
						  "aParam3": "",
						  "aParam4": UserInfo.compCode
			};

			accntCommonService.fnGetCommon(param, function(provider, response){					// EXCEPTION_JUMP로 리턴 받음
				var taxRate = provider.EXCEPTION_JUMP;
		    	//세액 = 공급가액 * 세율
	//			taxAmtI    = fnRound(supplyAmtI * taxRate / 100, gsAmtPoint, gsFormatI)
				taxAmtI    = Math.floor(supplyAmtI * taxRate / 100);
				
				record.set('TAX_AMT_I', taxAmtI);
			});
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
				case "WASTE_DIVI"	:							//구분(매각/폐기)
					//자산구분 체크(부외자산은 추가 불가)
					if (newValue == '2' && record.get('ASST_DIVI') == '2') {
						rv = Msg.fSbMsgA0323;
						break;
					}
					UniAppManager.app.fnClearAlterInfo(record, newValue);
				break;
				
				
				case "ALTER_DATE"	:							
					//동일한 월에 자산변동내역 있는지 체크
					var checkSameMonthYN = UniAppManager.app.fnCheckSameMonth(record, newValue)
					if(!checkSameMonthYN) {
						rv = Msg.fSbMsgA0327;

					} else {
						//'회계기간 내에서 발생여부 체크
						var checkAcDateRangeTextBox = UniAppManager.app.fnCheckAcDateRangeTextBox(UniDate.getDbDateStr(newValue))
						if (!checkAcDateRangeTextBox) {
							rv = '[' + frDate + '~' + toDate + '] ' + Msg.fSbMsgA0336;

						}
					}
				break;
				
				
				case "ALTER_Q"	:							
					//재고수량 vs 처분수량
					if(record.get('STOCK_Q') < newValue) {
						rv = Msg.fSbMsgA0328;
					}
				break;
				
				
				case "EXCHG_RATE_O" :
				case "FOR_ALTER_AMT_I"	:	
					UniAppManager.app.fnCalAlterAmt(record, newValue, fieldName);
				break;
				
				
				case "ALTER_AMT_I"	:	
					//특별한 로직 없음
				break;
				
				
				case "SET_TYPE"	:	
					if(record.get('WASTE_DIVI') != '1') {
						break;
					} else {
						record.set ('SUPPLY_AMT_I',		record.get('ALTER_AMT_I')); 
						var param =  {"aParam0": "REF_CODE1",
									  "aParam1": "A140",
									  "aParam2": newValue,
									  "aParam3": "",
									  "aParam4": UserInfo.compCode
						};
						accntCommonService.fnGetCommon(param, function(provider, response){					// EXCEPTION_JUMP로 리턴 받음
							var setTypeRef1 = provider.EXCEPTION_JUMP;
							//2-2 REF_CODE1에 따라 그리드 컬럼 동적으로 필수처리 (구현되지 않음) - 임시컬럼에 저장하여 SAVESTORE에서 처리
							record.set ('REF_CODE1',	setTypeRef1);
//							if (setTypeRef1 == '20') {
//								record.getColumn("SAVE_CODE").setConfig('allowBlank', false);  
//								record.getColumn("SAVE_NAME").setConfig('allowBlank', false);  
//							} else {
//								record.getColumn("SAVE_CODE").setConfig('allowBlank', true);  
//								record.getColumn("SAVE_NAME").setConfig('allowBlank', true);  
//							}
						});
					}

				break;
				
				
				case "PROOF_KIND"	:
					if  (record.get('WASTE_DIVI') == '1') {
						UniAppManager.app.fnCalTaxAmt(record, newValue);
					}
				break;
				
				
				case "SUPPLY_AMT_I"	:	
					UniAppManager.app.fnCalTaxAmt(record);
				break;
				
			}
			return rv;
		}
	});
};


</script>