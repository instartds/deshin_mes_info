<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd210ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A014" /> 	<!-- 승인여부 -->      
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 	<!-- 증빙유형 -->      
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 	<!-- 화폐단위 -->      
	<t:ExtComboStore comboType="AU" comboCode="T001" /> 	<!-- 무역구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="T070" /> 	<!-- 진행구분(수출) -->      
	<t:ExtComboStore comboType="AU" comboCode="T071" /> 	<!-- 진행구분(수입) -->
	<t:ExtComboStore comboType="AU" comboCode="T072" /> 	<!-- 지급유형 -->      
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
//조회된 합계, 건수 계산용 변수 선언
var sumChargeAmtWon = 0;									//원화금액합계(CHARGE_AMT_WON)
	sumChargeAmt = 0;											//세액합계 (TAX_AMT_I)
	
	checkCount = 0;
	newYN = 0;

	/*  Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd210ukrModel', {
		fields: [
			{name: 'CHOICE'              		,text: '선택' 					,type: 'boolean'},
    		{name: 'COMP_CODE'		     		,text: 'COMP_CODE' 				,type: 'string'},
    		{name: 'DIV_CODE'		     		,text: '사업장' 					,type: 'string'},
    		{name: 'TRADE_DIVI'			 		,text: 'TRADE_DIVI' 				,type: 'string'},
    		{name: 'CHARGE_TYPE'		 		,text: 'CHARGE_TYPE' 			,type: 'string'},
    		{name: 'CHARGE_TYPE_NAME'	 		,text: '진행구분' 					,type: 'string'},
    		{name: 'CHARGE_SER'			 		,text: '순번' 					,type: 'string'},
    		{name: 'BASIC_PAPER_NO'		 		,text: '근거번호' 					,type: 'string'},
    		{name: 'TRADE_CUSTOM_CODE'	 		,text: 'TRADE_CUSTOM_CODE' 		,type: 'string'},
    		{name: 'TRADE_CUSTOM_NAME'	 		,text: '수입자' 					,type: 'string'},
    		{name: 'CHARGE_CODE'		 		,text: '경비' 					,type: 'string'},
    		{name: 'CHARGE_NAME'		 		,text: '경비명' 					,type: 'string'},
    		{name: 'CUSTOM_CODE'		 		,text: '지급처' 					,type: 'string'},
    		{name: 'CUSTOM_NAME'		 		,text: '지급처명' 					,type: 'string'},
    		{name: 'VAT_CUSTOM_CODE'	 		,text: '공급처' 					,type: 'string'},
    		{name: 'VAT_CUSTOM_NAME'	 		,text: '공급처명' 					,type: 'string'},
    		{name: 'OCCUR_DATE'			 		,text: '발생일자' 					,type: 'uniDate'},
    		{name: 'CHARGE_AMT'			 		,text: '외화금액' 					,type: 'uniFC'},
    		{name: 'MONEY_UNIT'			 		,text: '화폐' 					,type: 'string'},
    		{name: 'EXCHANGE_RATE'		 		,text: '환율' 					,type: 'uniER'},
    		{name: 'CHARGE_AMT_WON'		 		,text: '원화금액' 					,type: 'uniPrice'},
    		{name: 'SUPPLY_AMT_I'		 		,text: '공급가액' 					,type: 'uniPrice'},
    		{name: 'PROOF_KIND'			 		,text: '증빙유형' 					,type: 'string'},
    		{name: 'TAX_AMT_I'			 		,text: '부가세액' 					,type: 'uniPrice'},
    		{name: 'PAY_TYPE'			 		,text: '지급유형' 					,type: 'string',	comboType: "AU", comboCode: "T072"},
    		{name: 'OFFER_SER_NO'		 		,text: 'OFFER번호' 				,type: 'string'},
    		{name: 'LC_NO'				 		,text: 'LC번호' 					,type: 'string'},
    		{name: 'BL_NO'				 		,text: 'BL번호' 					,type: 'string'},
    		{name: 'EX_DATE'			 		,text: '결의일' 					,type: 'uniDate'},
    		{name: 'EX_NUM'				 		,text: '번호' 					,type: 'string'},
    		{name: 'AP_STS'				 		,text: '승인여부' 					,type: 'string', comboType:'AU', comboCode:'A014'},
    		{name: 'INSERT_DB_USER'		 		,text: '입력일자' 					,type: 'uniDate'},
    		{name: 'INSERT_DB_TIME'		 		,text: '입력일' 					,type: 'uniDate'},
    		{name: 'UPDATE_DB_USER'		 		,text: '수정자' 					,type: 'string'},
    		{name: 'UPDATE_DB_TIME'		 		,text: '수정일' 					,type: 'uniDate'}
	    ]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('MasterStore',{
		model: 'Agd210ukrModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd210ukrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();		
			Ext.apply(param, addResult.getValues());
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		addResult.setValue("SUM_CHARGE_AMT_WON", store.sum("CHARGE_AMT_WON"));
           		addResult.setValue("SUM_CHARGE_AMT", store.sum("CHARGE_AMT"));
           		addResult.setValue("COUNT_CHARGE", store.count());
           	}
		}
	});
	
	/*
	 * 자동기표 Model
	 */
	Unilite.defineModel('Agd210ukrModel_LOG', {
		fields: [
    		{name: 'TRADE_DIVI'			 		,text: 'TRADE_DIVI' 				,type: 'string'},
    		{name: 'CHARGE_TYPE'		 		,text: 'CHARGE_TYPE' 			,type: 'string'},
    		{name: 'CHARGE_SER'			 		,text: '순번' 					,type: 'string'}
	    ]
	});
	
	/*자동기표 처리를 위한 Store*/
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		 create : 'agd210ukrService.insert'
		 ,syncAll:'agd210ukrService.saveAll' 
		}
	});
	var logStore = Unilite.createStore('logStore',{
		model: 'Agd210ukrModel_LOG',
		uniOpt : {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        saveStore : function()	{
        	var paramMaster = panelSearch.getValues();
        		Ext.apply(paramMaster, addResult.getValues())
        		paramMaster.CALL_PATH = "LIST";
        		paramMaster.DATE_OPTION = addResult.getValue("PUB_DATE").PUB_DATE;
        		if(addResult.getValue("PUB_DATE").PUB_DATE == "1")	{
        			paramMaster.WORK_DATE = "";
        		}
        		
        		paramMaster.INPUT_USER_ID =  UserInfo.userID;
				paramMaster.INPUT_DATE = UniDate.getDbDateStr(UniDate.today());
							
				var config = {
						params: [paramMaster],
						success: function(batch, option) {
							if(addResult.getValue("WORK_DIVI").WORK_DIVI == "1")	{
								alert("자동기표 처리되었습니다.");
							}else {
								alert("기표취소 처리되었습니다.");
							}
							UniAppManager.app.onQueryButtonDown();
						} 
				}
				this.syncAllDirect(config);
				
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
    			fieldLabel: '발생일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank : false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    	}
			    }
	        },{
    			fieldLabel: '무역구분'	,
    			name:'TRADE_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'T001',
    			allowBlank:false,
    			listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('TRADE_DIVI', newValue);
					}
				}
    		},	    
	        	Unilite.popup('EXPENSE',{
		        fieldLabel: '경비코드',
		        id: 'chargeCode1',
		        //validateBlank:false,
		        valueFieldName:'CHARGE_CODE',
			    textFieldName:'CHAGE_NAME',
			  	colspan: 2,  
		  		readOnly: true,
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
		    }),{ 
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'INSERT_DATE_FR',
		        endFieldName: 'INSERT_DATE_TO',
		        width: 470,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INSERT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INSERT_DATE_TO',newValue);
			    	}
			    }
	        },{
    			fieldLabel: '진행구분'	,
    			name:'CHARGE_TYPE', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'T071',
    			listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('CHARGE_TYPE', newValue);
						if (!Ext.isEmpty(panelSearch.getValue('CHARGE_TYPE'))){
							Ext.getCmp('chargeCode1').setReadOnly(false);
							Ext.getCmp('chargeCode2').setReadOnly(false);
						} else {
							Ext.getCmp('chargeCode1').setReadOnly(true);
							Ext.getCmp('chargeCode2').setReadOnly(true);
						}
					}
				}
    		},
		    	Unilite.popup('CUST',{
		    	fieldLabel: '지급처',
		    	validateBlank:true,
		    	autoPopup:true,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			  	colspan: 2,  
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);				
					},					
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
		    }),{					
    			fieldLabel: '사업장',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '전표승인여부',
				name:'AP_STS', 
				id:'apSts1',
				itemId:'apSts',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A014',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('AP_STS', newValue);
					}
				}
			}/*,{
			    xtype: 'box',
			    autoEl: {tag: 'hr'}
			}*/,{ 
    			fieldLabel: '기표발생일',
				xtype: 'uniDatefield',
				name:'WORK_DATE', 
				value: UniDate.get('today'),
				allowBlank:false,
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_DATE', newValue);
					}
				}
			},{
		    	xtype: 'container',
		    	id:'autoSpip',
		    	itemId:'autoSpip',
		    	margin: '0 0 0 60', 
				hidden: true,
		    	layout: {
		    		type: 'hbox'
//					align: 'center'
//					pack:'center'
		    	},
		    	items:[{
		    		xtype: 'button',
		    		text: '개별자동기표',
		    		width: 100,
		    		margin: '0 0 0 0',
		    		handler : function() {
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
	   				}
		    	},{
		    		xtype: 'button',
		    		text: '일괄자동기표',
		    		width: 100,
		    		margin: '0 0 0 0',                                                       
		    		handler : function() {
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
	   				}
		    	}]
		    },{
	    		xtype: 'button',
	    		text: '기표취소',
	    		width: 100,
	    		margin: '0 0 0 120',      
	    		id:'cancPosting',
	    		itemId:'cancPosting',
				hidden: true,
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
   				}
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
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})  
   				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '발생일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DATE_FR',
	        endFieldName: 'DATE_TO',
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank : false,
			tdAttrs: {width: 380},    
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO',newValue);
		    	}
		    }
        },{
			fieldLabel: '무역구분'	,
			name:'TRADE_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'T001',
    		allowBlank:false,
			tdAttrs: {width: 380},    
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('TRADE_DIVI', newValue);
				}
			}
		},	    
        	Unilite.popup('EXPENSE',{
	        fieldLabel: '경비코드',
			id: 'chargeCode2',
		    valueFieldName:'CHARGE_CODE',
		    textFieldName:'CHARGE_NAME',
		  	colspan: 2,  
		  	readOnly: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CHARGE_CODE', panelSearch.getValue('CHARGE_CODE'));
						panelSearch.setValue('CHARGE_NAME', panelSearch.getValue('CHARGE_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CHARGE_CODE', '');
					panelSearch.setValue('CHARGE_NAME', '');
				}
			}
	    }),{ 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INSERT_DATE_FR',
	        endFieldName: 'INSERT_DATE_TO',
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INSERT_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INSERT_DATE_TO',newValue);
		    	}
		    }
        },{
			fieldLabel: '진행구분'	,
			name:'CHARGE_TYPE', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'T071',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('CHARGE_TYPE', newValue);
					if (!Ext.isEmpty(panelSearch.getValue('CHARGE_TYPE'))){
						Ext.getCmp('chargeCode1').setReadOnly(false);
						Ext.getCmp('chargeCode2').setReadOnly(false);
					} else {
						Ext.getCmp('chargeCode1').setReadOnly(true);
						Ext.getCmp('chargeCode2').setReadOnly(true);
					}
				}
			}
		},
	    	Unilite.popup('CUST',{
	    	fieldLabel: '지급처',
	    	validateBlank:true,
	    	autoPopup:true,
	    	valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
		  	colspan: 2,  
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);				
				},				
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
	    }),{					
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '전표승인여부',
			name:'AP_STS', 
			id:'apSts',
			itemId:'apSts',
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A014',
			colspan:2,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('AP_STS', newValue);
				}
			}
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
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})  
   				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});  
	
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 8, tableAttrs: {width: '100%', border:0}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'}
		},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		items: [{
				fieldLabel: '전표일',
				xtype: 'uniDatefield',
				name:'WORK_DATE', 
				value: UniDate.get('today'),
				allowBlank:false,
				readOnly:true,
				width:200,
				tdAttrs:{width: 200}
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '',
			    name: 'PUB_DATE',
			    items : [{
			    	boxLabel: '발생일',
			    	name: 'PUB_DATE',
			    	inputValue: '1',
			    	width:70,
			    	checked: true
			    }, {
			    	boxLabel: '실행일',
			    	name: 'PUB_DATE',
			    	inputValue: '2',
			    	labelWidth: 1
//			    	width:70
			    }],
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						if(newValue.PUB_DATE == '1'){
							addResult.getField('WORK_DATE').setReadOnly(true);
						}else{
							addResult.getField('WORK_DATE').setReadOnly(false);
						}
					}
				}
	    	},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tdAttrs: {align: 'left'},
				colspan: 2,
				tdAttrs:{width: 340},
		    	items:[{
				    xtype: 'radiogroup',
				    fieldLabel: '작업구분',
					id: 'rdoSelect4',
					name: 'WORK_DIVI',
				    items : [{
				    	boxLabel: '자동기표',
				    	name: 'WORK_DIVI',
				    	inputValue: '1',
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '기표취소',
				    	name: 'WORK_DIVI',
				    	inputValue: '2',
				    	width:80
				    }],
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {					
							/*if(masterGrid.getStore().getCount() > 0){
								MasterStore2.loadStoreRecords();
							}*/
							if(newValue.WORK_DIVI == '1'){
								UniAppManager.app.selectRdoFirst();
							}else{
								UniAppManager.app.selectRdoSecond();
							}
						}
					}
		    	}]
			},{
				xtype: 'container',
				colspan:3,
				tdAttrs:{width: '80%'},
				html:'&nbsp;'
	    	},{
		    	xtype: 'container',
		    	itemId:'autoSpip',
		    	//layout : {type:'hbox', align:'stretch'},
				tdAttrs: {align:'right',width:120, style:'padding-right:20px;'},
		    	items:[{
		    		xtype: 'button',
		    		text: '자동기표',
		    		width: 100,
		    		margin: '0 0 0 0',
		    		id:'autoSpip2',
		    		handler : function() {
						addResult.execAutoslip();
					}
		    	},{
		    		xtype: 'button',
		    		text: '기표취소',
		    		width: 100,
		    		id:'cancPosting2',
		    		itemId:'cancPosting',
		    		handler : function() {
		    			addResult.execAutoslip();
		    		}
		    	}]
		    },{
				fieldLabel: '원화합계(조회)',
				name:'SUM_CHARGE_AMT_WON', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 200,
				tdAttrs:{width: 200}
			},{
				fieldLabel: '외화합계(조회)',
				name:'SUM_CHARGE_AMT', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 200,
				tdAttrs:{width: 200}
			},{
				fieldLabel: '건수(조회)',
				name:'COUNT_CHARGE', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 130,
				tdAttrs:{width: 130}
			},{
				fieldLabel: '원화합계(선택)',
				name:'SUM_SELECTED_CHARGE_AMT_WON', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 200,
				tdAttrs:{width: 200}
			},{
				fieldLabel: '외화합계(선택)',
				name:'SUM_SELECTED_CHARGE_AMT', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 200,
				tdAttrs:{width: 200}
			},{
				fieldLabel: '건수(선택)',
				name:'COUNT_SELECTED_CHARGE', 
				xtype: 'uniNumberfield',
				value: '0',
				readOnly: true,						            		
				width: 130,
				tdAttrs:{width: 130}
	    },{
				xtype: 'container',
				colspan: 2,
				tdAttrs:{width: '90%'},
				html:'&nbsp;'
	    }]
	    ,
	    execAutoslip:function()	{
	    	if(panelSearch.setAllFieldsReadOnly(true)){
				//자동기표일 때 SP 호출
				if(masterGrid.selModel.getCount() > 0){  
					logStore.loadData({});
					var records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, idx)	{
						if(   (Ext.isEmpty(record.get("EX_DATE")) && addResult.getValue("WORK_DIVI").WORK_DIVI == "1" ) //기표
							||(!Ext.isEmpty(record.get("EX_DATE")) && addResult.getValue("WORK_DIVI").WORK_DIVI == "2" ) //기표취소		
						)	{
							var newRecord =  Ext.create(logStore.model);
							
							newRecord.set("TRADE_DIVI",  record.get("TRADE_DIVI"));
							newRecord.set("CHARGE_TYPE",  record.get("CHARGE_TYPE"));
							newRecord.set("CHARGE_SER",  record.get("CHARGE_SER"));
							
							
							if(addResult.getValue("WORK_DIVI").WORK_DIVI == "1")	{
								newRecord.set("OPR_FLAG", "N");
							} else {
								newRecord.set("OPR_FLAG", "D");
							}
							logStore.insert(idx, newRecord);
						} else {
							if(addResult.getValue("WORK_DIVI").WORK_DIVI == "1")	{
								alert("이미 기표된 자료가 있습니다. ( 순번 : "+record.get("CHARGE_SER")+" )");
							} else if(addResult.getValue("WORK_DIVI").WORK_DIVI == "2"){
								alert("미기표 자료가 있습니다. ( 순번 : "+record.get("CHARGE_SER")+" )");
							}
							logStore.loadData({});
							return;
						}
					})
					logStore.saveStore();	
				}else {
					UniAppManager.updateStatus("선택된 자료가 없습니다.");
				}
			}
	    }
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agd210ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        excelTitle: '무역경비자동기표',
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
    	store: MasterStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				if(addResult.getValue('WORK_DIVI')=='2'){
	       				var sm = masterGrid.getSelectionModel();
						var selRecords = masterGrid.getSelectionModel().getSelection();
						var records = MasterStore.data.items;
						
						for(var i = 0; i < records.length; i++) {
							if(UniDate.getDbDateStr(selectRecord.data.EX_DATE) == UniDate.getDbDateStr(records[i].get('EX_DATE'))
								&& selectRecord.data.EX_NUM == records[i].get('EX_NUM')
							){
								selRecords.push(records[i]);
							}
						}
						sm.select(selRecords);
    				}
					sumChargeAmtWon = sumChargeAmtWon + selectRecord.get('CHARGE_AMT_WON');
					sumChargeAmt = sumChargeAmt + selectRecord.get('CHARGE_AMT');
					addResult.setValue('SUM_SELECTED_CHARGE_AMT_WON', sumChargeAmtWon);
					addResult.setValue('SUM_SELECTED_CHARGE_AMT', sumChargeAmt);
					addResult.setValue('COUNT_SELECTED_CHARGE', addResult.getValue('COUNT_SELECTED_CHARGE')+1);
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
    				if(addResult.getValue('WORK_DIVI')=='2'){
	       				var sm = masterGrid.getSelectionModel();
						var selRecords = masterGrid.getSelectionModel().getSelection();
						var records = MasterStore.data.items;
					 	selRecords.splice(0, selRecords.length);	
						
						for(var i = 0; i < records.length; i++) {
							if(UniDate.getDbDateStr(selectRecord.data.EX_DATE) == UniDate.getDbDateStr(records[i].get('EX_DATE'))
								&& selectRecord.data.EX_NUM == records[i].get('EX_NUM')
							){
								selRecords.push(records[i]);
							}
						};
						sm.deselect(selRecords);
						
    				} 
    				sumChargeAmtWon = sumChargeAmtWon - selectRecord.get('CHARGE_AMT_WON');
    				sumChargeAmt = sumChargeAmt - selectRecord.get('CHARGE_AMT');
					addResult.setValue('SUM_SELECTED_CHARGE_AMT_WON', sumChargeAmtWon)
					addResult.setValue('SUM_SELECTED_CHARGE_AMT', sumChargeAmt)
					addResult.setValue('COUNT_SELECTED_CHARGE', addResult.getValue('COUNT_SELECTED_CHARGE')-1)
	    		}
    		}
        }),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
//			{ dataIndex: 'CHOICE'               , 				width:40, 	locked: true,	locked: true},
        	{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},
	   		{ dataIndex: 'COMP_CODE'		    , 				width:66, 	hidden: true/*,	locked: true*/},
	   		{ dataIndex: 'DIV_CODE'		    	, 				width:106,	hidden: true/*,	locked: true*/},
	   		{ dataIndex: 'TRADE_DIVI'			, 				width:60,	hidden: true/*,	locked: true*/},
			{ dataIndex: 'CHARGE_TYPE'			, 				width:6,	hidden: true/*,	locked: true*/},
			{ dataIndex: 'CHARGE_TYPE_NAME'		, 				width:80/*,	locked: true*/},
			{ dataIndex: 'CHARGE_SER'			, 				width:46/*,	locked: true*/},
			{ dataIndex: 'BASIC_PAPER_NO'		, 				width:120/*,	locked: true*/},
			{ dataIndex: 'TRADE_CUSTOM_CODE'	, 				width:66,	hidden: true/*,	locked: true*/},
			{ dataIndex: 'TRADE_CUSTOM_NAME'	, 				width:133/*,	locked: true*/},
			{ dataIndex: 'CHARGE_CODE'			, 				width:55/*,	locked: true*/},
			{ dataIndex: 'CHARGE_NAME'			, 				width:133/*,	locked: true*/},
			{ dataIndex: 'CUSTOM_CODE'			, 				width:66},
			{ dataIndex: 'CUSTOM_NAME'			, 				width:200},
			{ dataIndex: 'VAT_CUSTOM_CODE'		, 				width:66},
			{ dataIndex: 'VAT_CUSTOM_NAME'		, 				width:200},
			{ dataIndex: 'OCCUR_DATE'			, 				width:80},
			{ dataIndex: 'CHARGE_AMT'			, 				width:100},
			{ dataIndex: 'MONEY_UNIT'			, 				width:46},
			{ dataIndex: 'EXCHANGE_RATE'		, 				width:66},
			{ dataIndex: 'CHARGE_AMT_WON'		, 				width:100},
			{ dataIndex: 'SUPPLY_AMT_I'			, 				width:100},
			{ dataIndex: 'PROOF_KIND'			, 				width:120,	comboType: "AU", comboCode: "A022"},
			{ dataIndex: 'TAX_AMT_I'			, 				width:100},
			{ dataIndex: 'PAY_TYPE'				, 				width:86,	comboType: "AU", comboCode: "T072"},
			{ dataIndex: 'OFFER_SER_NO'			, 				width:130},
			{ dataIndex: 'LC_NO'				, 				width:130},
			{ dataIndex: 'BL_NO'				, 				width:130},
			{ dataIndex: 'EX_DATE'				, 				width:80},
			{ dataIndex: 'EX_NUM'				, 				width:60},
			{ dataIndex: 'AP_STS'				, 				width:80},
			{ dataIndex: 'INSERT_DB_USER'		, 				width:80,	hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'		, 				width:80,	hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, 				width:80,	hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, 				width:80,	hidden: true}
        ]
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
		id  : 'agd210ukrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//초기값 세팅			
			Ext.getCmp('chargeCode1').setReadOnly(true);
			Ext.getCmp('chargeCode2').setReadOnly(true);
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			panelSearch.setValue('WORK_DATE', UniDate.get('today'));
			addResult.setValue('WORK_DATE', UniDate.get('today'));
			//합계 field 초기화
			panelSearch.setValue('SUM_CHARGE_AMT_WON', 0);
			panelSearch.setValue('SUM_TAX_AMT_I', 0); 
			panelSearch.setValue('SUM_AMT_I', 0); 
	   		addResult.setValue('SUM_CHARGE_AMT_WON', 0);
	   		addResult.setValue('SUM_TAX_AMT_I', 0);
			addResult.setValue('SUM_AMT_I', 0); 
			//라디오버튼 초기화
			addResult.getField('PUB_DATE').setValue('1');
			addResult.getField('WORK_DIVI').setValue('1');
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params); 
            }
            
			//상단 툴바버튼 세팅
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			//작업구분에 따른 초기 panel 세팅
			UniAppManager.app.selectRdoFirst();

			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DATE_FR');		
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
        
            //경비내역 등록 (tix100ukrv)에서 링크 
            panelSearch.setValue('DIV_CODE', params.DIV_CODE);
            panelSearch.setValue('DATE_FR', params.FRORDERDATE);
            panelSearch.setValue('DATE_TO', params.TOORDERDATE);
            panelSearch.setValue('TRADE_DIVI', params.TRADE_DIVI);
            
            panelResult.setValue('DIV_CODE', params.DIV_CODE);
            panelResult.setValue('DATE_FR', params.FRORDERDATE);
            panelResult.setValue('DATE_TO', params.TOORDERDATE);
            panelResult.setValue('TRADE_DIVI', params.TRADE_DIVI);
            
            UniAppManager.app.onQueryButtonDown();
        },
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true)){
				sumChargeAmtWon = 0;									//원화금액합계(CHARGE_AMT_WON)초기화
				sumTaxAmtI = 0;											//세액합계 (TAX_AMT_I)초기화
				sumAmtI = 0;											//합계 초기화
				addResult.setValue('SUM_CHARGE_AMT_WON',0);
				addResult.setValue('SUM_CHARGE_AMT',0);
				addResult.setValue('COUNT_CHARGE',0);
				
				addResult.setValue('SUM_SELECTED_CHARGE_AMT_WON',0);
				addResult.setValue('SUM_SELECTED_CHARGE_AMT',0);
				addResult.setValue('COUNT_SELECTED_CHARGE',0);
				MasterStore.loadStoreRecords();
			}else{
				return false;
			}
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
		},
		selectRdoFirst: function() {
			Ext.getCmp('autoSpip2').setVisible(true);
			
 			Ext.getCmp('cancPosting2').setVisible(false); 		
 			Ext.getCmp('apSts').setVisible(false); 		
 			Ext.getCmp('apSts1').setVisible(false); 		
		},
		selectRdoSecond: function() {
			Ext.getCmp('autoSpip2').setVisible(false);
			
 			Ext.getCmp('cancPosting2').setVisible(true); 		
 			Ext.getCmp('apSts').setVisible(true); 		
 			Ext.getCmp('apSts1').setVisible(true); 		
		}
	});
};

</script>
