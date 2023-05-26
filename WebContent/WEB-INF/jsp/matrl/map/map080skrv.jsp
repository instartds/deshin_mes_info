<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map080skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="map080skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP36" /> <!-- 계산서 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="YP35" /> <!-- 지불일자 -->
	<t:ExtComboStore items="${COMBO_COLLECT_DAY}" storeId="collectDayList" /><!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #ffddb4;
}
.x-change-cell2 {
background-color: #fed9fe;
}
.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >

function appMain() {

var checkCount = 0;	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map080skrvService.selectList'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('map080skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'				, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'			, text: '매입처'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '매입처명'		, type: 'string'},
	    	{name: 'RECEIPT_DAY'			, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string',comboType:'AU', comboCode:'B034'},
	    	{name: 'TOP_NAME'				, text: '대표자명'		, type: 'string'},
	    	{name: 'AGENT_TYPE'				, text: '고객분류'		, type: 'string'},
	    	{name: 'BANK_NAME'				, text: '은행명'		, type: 'string'},
	    	{name: 'BANKBOOK_NUM'			, text: '계좌번호'		, type: 'string'},
	    	{name: 'BANKBOOK_NAME'			, text: '예금주'		, type: 'string'},
	    	{name: 'IN_CR_AMT_I'			, text: '매입액'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_I'				, text: '매출액'		, type: 'uniPrice'},
	    	{name: 'STOCK_AMT_I'			, text: '재고액'		, type: 'uniPrice'},
	    	{name: 'SALE_COST'				, text: '매출원가'		, type: 'uniPrice'},
	    	{name: 'PAY_AMT'				, text: '지불확정금액'	, type: 'uniPrice'},
	    	{name: 'COLLECT_DAY_MAP050_G'	, text: '차수'		, type: 'string'}
	    	
	    ]
	});//End of Unilite.defineModel('map080skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map080skrvMasterStore1', {
		model: 'map080skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,		// 수정 모드 사용 
        	deletable: false,		// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
      
           		
           		var count = masterGrid.getStore().getCount();  
           		if(count > 0){
	           		Ext.each(records, function(record,i)  {
	           			UniAppManager.setToolbarButtons(['print'], true);
	           		})
           		}
           		else{
           			UniAppManager.setToolbarButtons(['print'], false);
           		}
           	}
		}
		
		//groupField: 'CUSTOM_NAME'
			
	});//End of var directMasterStore1 = Unilite.createStore('map080skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				//holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.purchasedate" default="매입일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},
			{
				fieldLabel: '매출일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_SALE_DATE',
				endFieldName: 'TO_SALE_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
//				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_SALE_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_SALE_DATE',newValue);
			    	}
			    }
			},
			{
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
//	            value: UniDate.get('today'),
	            allowBlank: false,
	            //holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
	        },{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('COLLECT_DAY_MAP050', newValue);
						},
						expand: function(field,eOpts) {
							var maskedCombo = field.getPicker();
							
							maskedCombo.mask('loading...');
							var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
			 					"PAY_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6)
							};
							map080skrvService.getNewCollectDay(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});	
							
							
							/*UniliteComboServiceImpl.getCollectDay({}, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});*/
						},
						beforequery: function(queryPlan, eOpts ) {
//					        var pValue = masterForm.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6);
					        
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					       /* var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }*//*else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }*/
					     }
				}
			},{
	    		fieldLabel: 'PAY_DATE',
	    		name: 'PAY_DATE',
	    		xtype:'uniTextfield',
	    		hidden:true
			},/*{ 
				fieldLabel: '지불확정일자',
				xtype: 'uniTextfield',
		 		name: 'PAY_YYYYMM',
		 		enforceMaxLength: true,
		 		maxLength: '6',
		 		allowBlank: false,
				//holdable: 'hold',
				name: 'PAY_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            //holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_DATE', newValue);
						
						masterForm.setValue('BILL_DATE', newValue);
						panelResult.setValue('BILL_DATE', newValue);
						if(newValue == null){
							return false;
						}else{
							masterForm.setValue('S_PAY_YYYYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
							masterForm.setValue('S_COLLECT_DAY', UniDate.getDbDateStr(newValue).substring(6, 8));
						}
					}
				}
	        },*//*{
	    		fieldLabel: '지불일자',
		 		xtype: 'uniTextfield',
		 		name: 'COLLECT_DAY',
		 		allowBlank: false,
				//holdable: 'hold',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 		allowBlank: false,
				//holdable: 'hold',
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
//		 		allowBlank: false,
//				//holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_DAY', newValue);
						if(newValue == null){
						return false;
						}else{	
							if(masterForm.getValue('PAY_YYYYMM') != null){
								if(newValue.length == 2 ){
									masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6) + newValue);
								}else if(newValue.length == 1){
									masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(masterForm.getValue('PAY_YYYYMM')).substring(0, 6) + '0' +newValue);
								}else if(newValue == ''){
									masterForm.setValue('PAY_DATE','');
								}
							}
						}
						}
					}
			},*/
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_DAY', newValue);
					}
				}
			}/*,{
            	fieldLabel: '만단위 절사여부',
            	name: 'FLOOR',
//				id: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FLOOR', newValue);
					}
				}
    		},{
				fieldLabel:'지불확정일자',
				name:'PAY_DATE',
				xtype: 'uniTextfield',
				hidden: true
			},{
	        	fieldLabel:'저장용 차수(map050t collect_day)',
	        	name:'COLLECT_DAY_MAX',
	        	xtype:'uniTextfield',
	        	hidden: true
	        },{
				fieldLabel:'저장용지불년월',
				name:'S_PAY_YYYYMM',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'저장용지불일자',
				name:'S_COLLECT_DAY',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'<t:message code="system.label.purchase.departmencode" default="부서코드"/>',
				name:'DEPT_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'CHECKING',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
					width: 60,
					name: 'CHECKING' ,
					inputValue: 'B'
				},{
					boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
					width: 60,
					name: 'CHECKING' ,
					inputValue: 'C'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('CHECKING').setValue(newValue.CHECKING);
						}
					}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name: 'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력조건',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '기본',
					width: 60,
					name: 'OUTPUT',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '매입기준',
					width: 80,
					name: 'OUTPUT' ,
					inputValue: 'B'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('OUTPUT').setValue(newValue.OUTPUT);
						}
					}
			}*/]
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
  			},
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				//holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.purchasedate" default="매입일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},
			{
				fieldLabel: '매출일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_SALE_DATE',
				endFieldName: 'TO_SALE_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
//				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_SALE_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_SALE_DATE',newValue);
			    	}
			    }
			},{ 
				fieldLabel: '지불년월',
				name: 'PAY_YYYYMM',
	            xtype: 'uniMonthfield',
//	            value: UniDate.get('today'),
	            allowBlank: false,
	            //holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('PAY_YYYYMM', newValue);
					}
				}
	        },{
	    		fieldLabel: '차수',
	    		name: 'COLLECT_DAY_MAP050',
				xtype: 'uniCombobox',
//				store: Ext.data.StoreManager.lookup('collectDayList'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY_MAP050', newValue);
						},
						expand: function(field,eOpts) {
							var maskedCombo = field.getPicker();
							
							maskedCombo.mask('loading...');
							var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'),
			 					"PAY_YYYYMM": UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6)
							};
							map080skrvService.getNewCollectDay(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});	
							
							
							/*UniliteComboServiceImpl.getCollectDay({}, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.data.StoreManager.lookup('collectDayList').loadData(provider);
									maskedCombo.unmask();
								}
							});*/
						},
						beforequery: function(queryPlan, eOpts ) {
//					        var pValue = panelResult.getValue('DIV_CODE') + '-' + UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6);
					        queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('collectDayList'));
					        
					      /*  var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }*/
					     }
				}
			},/*{ 
				fieldLabel: '지불확정일자',
				xtype: 'uniTextfield',
		 		name: 'PAY_YYYYMM',
		 		enforceMaxLength: true,
		 		maxLength: '6',
		 		allowBlank: false,
				//holdable: 'hold',
				name: 'PAY_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            //holdable: 'hold',
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('PAY_DATE', newValue);
						
						masterForm.setValue('BILL_DATE', newValue);
						panelResult.setValue('BILL_DATE', newValue);
						if(newValue == null){
							return false;
						}else{	
							masterForm.setValue('S_PAY_YYYYMM', UniDate.getDbDateStr(newValue).substring(0, 6));
							masterForm.setValue('S_COLLECT_DAY', UniDate.getDbDateStr(newValue).substring(6, 8));
						}
					}
				}
	        },*//*{
	    		fieldLabel: '지불일자',
		 		xtype: 'uniTextfield',
		 		name: 'COLLECT_DAY',
		 		enforceMaxLength: true,
		 		maxLength: '2',
		 		allowBlank: false,
				//holdable: 'hold',
	    		name: 'COLLECT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'YP35',
//		 		allowBlank: false,
//				//holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('COLLECT_DAY', newValue);
							
					if(newValue == null){
						return false;
					}else{
						if(panelResult.getValue('PAY_YYYYMM') != null){
							if(newValue.length == 2 ){
								masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6) + newValue);
							}else if(newValue.length == 1){
								masterForm.setValue('PAY_DATE', UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6) + '0' +newValue);
							}else if(newValue == ''){
								masterForm.setValue('PAY_DATE','');
							}
						}
					}
						}
				}
			},*/
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RECEIPT_DAY', newValue);
					}
				}
			}/*,{
            	fieldLabel: '만단위 절사여부',
            	name: 'FLOOR',
//				id: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('FLOOR', newValue);
					}
				}
    		},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					labelWidth:90,
//					colspan:2,
					items : [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'CHECKING',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
						width: 60,
						name: 'CHECKING' ,
						inputValue: 'B'
					},{
						boxLabel: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
						width: 60,
						name: 'CHECKING' ,
						inputValue: 'C'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								masterForm.getField('CHECKING').setValue(newValue.CHECKING);
							}
						}
				},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name: 'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            width: 200,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력조건',						            		
				labelWidth:90,
//					colspan:2,
				items : [{
					boxLabel: '기본',
					width: 60,
					name: 'OUTPUT',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '매입기준',
					width: 80,
					name: 'OUTPUT' ,
					inputValue: 'B'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							masterForm.getField('OUTPUT').setValue(newValue.OUTPUT);
						}
					}
			}*/],
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map080skrvGrid1', {
    	// for tab    	
//		layout: 'fit',
		region: 'center',
		excelTitle: '매입대비 매출/재고/원가금액 조회',
		
        uniOpt: {
        	onLoadSelectFirst: false, 
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
        columns: [
//		    {dataIndex: 'COMP_CODE'				, width: 90 , hidden:true},
//		    {dataIndex: 'DIV_CODE'				, width: 90 , hidden:true},
		    {dataIndex: 'CUSTOM_CODE'			, width: 70 , locked: true,isLink:true},
		    {dataIndex: 'CUSTOM_NAME'			, width: 150, locked: true,
		    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
		    },
		    {dataIndex: 'TOP_NAME'				, width: 90},
		    {dataIndex: 'BANK_NAME'				, width: 90},
		    {dataIndex: 'BANKBOOK_NUM'			, width: 90},
		    {dataIndex: 'BANKBOOK_NAME'			, width: 90},
		    {dataIndex: 'IN_CR_AMT_I'			, width: 120, summaryType: 'sum'},
		    {dataIndex: 'SALE_AMT_I'			, width: 120, summaryType: 'sum'},
		    {dataIndex: 'STOCK_AMT_I'			, width: 120, summaryType: 'sum'},
		    {dataIndex: 'SALE_COST'				, width: 120, summaryType: 'sum'},
		    {dataIndex: 'PAY_AMT'				, width: 120, summaryType: 'sum'}
		],
		listeners: {
			afterrender: function(grid) {	
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
					this.contextMenu.add(
						{
					        xtype: 'menuseparator'
					    },{	
					    	text: '거래처정보',   iconCls : '',
		                	handler: function(menuItem, event) {	
		                		var record = grid.getSelectedRecord();
								var params = {
									action:'select',
									'CUSTOM_CODE' : record.data['CUSTOM_CODE']
								}
								var rec = {data : {prgID : 'bcm104ukrv', 'text':''}};									
								parent.openTab(rec, '/base/bcm104ukrv.do', params);
		                	}
		            	}
	       			)
				},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
							var params = {
								action:'select',
								'CUSTOM_CODE' : record.data['CUSTOM_CODE']
								
								/*'SALE_DATE' 		: panelSearch.setValue('SALE_DATE'),
								'POS_NO' 			: panelSearch.setValue('POS_NO'),
								'POS_NAME'  		: panelSearch.setValue('POS_NAME'),
								'RECEIPT_NO' 		: panelSearch.setValue('RECEIPT_NO')    */
							}
							var rec = {data : {prgID : 'bcm104ukrv', 'text':''}};							
							parent.openTab(rec, '/base/bcm104ukrv.do', params);
							
							break;		
					default:
							break;
	      			}
          		}
          	}
          }        
        
        
		
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],
		id: 'map080skrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			masterForm.setValue('FR_SALE_DATE',UniDate.get('startOfMonth'));
			masterForm.setValue('TO_SALE_DATE',UniDate.get('today'));
			panelResult.setValue('FR_SALE_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_SALE_DATE',UniDate.get('today'));			
			
			masterForm.setValue('PAY_DATE',UniDate.get('today'));
			
			masterForm.setValue('BILL_DATE',UniDate.get('today'));
			panelResult.setValue('BILL_DATE',UniDate.get('today'));
			
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('PAY_YYYYMM',UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM',UniDate.get('today'));

			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			return panelResult.setAllFieldsReadOnly(true);
			/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons(['print'], false);
			
			this.fnInitBinding();
		},
        
        onPrintButtonDown: function() {
	         //var records = masterForm.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
		         var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/map/map081rkrPrint.do',
		            prgID: 'map081rkr',
		               extParam: {
		               	  COMP_CODE	    : param.COMP_CODE,
		                  DIV_CODE  	: param.DIV_CODE,
		                  DEPT_CODE		: param.DEPT_CODE,
		                  FR_DATE		: param.FR_DATE,
		                  TO_DATE		: param.TO_DATE,
		                  FR_SALE_DATE	: param.FR_SALE_DATE,
		                  TO_SALE_DATE	: param.TO_SALE_DATE,
		                  PAY_YYYYMM	: param.PAY_YYYYMM,
		                  COLLECT_DAY   : param.COLLECT_DAY,
		                  CUSTOM_CODE	: param.CUSTOM_CODE,
		                  AGENT_TYPE    : param.AGENT_TYPE,
		                  RECEIPT_DAY   : param.RECEIPT_DAY,
		                  COLLECT_DAY_MAP050 : param.COLLECT_DAY_MAP050
		                  
		               }
		            });
	            win.center();
	            win.show();
	    },
        onSaveAsExcelButtonDown: function() {
        	var masterGrid = Ext.getCmp('map080skrvGrid1');
			 masterGrid.downloadExcelXml();
		}
	});

};


</script>
