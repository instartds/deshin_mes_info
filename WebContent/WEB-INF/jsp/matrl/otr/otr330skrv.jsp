<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr330skrv">	
	<t:ExtComboStore comboType="BOR120"  />
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />
	<t:ExtComboStore comboType="O" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 */
	Unilite.defineModel('Otr330skrvModel', {
	    fields: [  	 
	    	{name: 'COMP_CODE',					text: 'COMP_CODE',			type:'string'},
	    	{name: 'DIV_CODE',					text: 'DIV_CODE',			type:'string'},
	    	{name: 'CONTROL_STATUS',			text: '<t:message code="system.label.purchase.statuscode" default="상태코드"/>',			type:'string'},
	    	{name: 'CONTROL_STATUS_NAME',		text: '<t:message code="system.label.purchase.status" default="상태"/>',				type:'string'},
	    	{name: 'CUSTOM_CODE',				text: '<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>',			type:'string'},
	    	{name: 'CUSTOM_NAME',				text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>',			type:'string'},
	    	{name: 'ORDER_NUM',					text: '<t:message code="system.label.purchase.pono" default="발주번호"/>',			type:'string'},
	    	{name: 'PITEM_CODE',				text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',			type:'string'},
	    	{name: 'PITEM_NAME',				text: '<t:message code="system.label.purchase.itemnamespec" default="품명/규격"/>',			type:'string'},
	    	{name: 'OPITEM_NAME',				text: '<t:message code="system.label.purchase.itemname2" default="품명"/>',				type:'string'},
	    	{name: 'ORDER_UNIT',				text: '<t:message code="system.label.purchase.unit" default="단위"/>',				type:'string'},
	    	{name: 'ORDER_DATE',				text: '<t:message code="system.label.purchase.podate" default="발주일"/>',				type:'uniDate'},
	    	{name: 'DVRY_DATE',					text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',				type:'uniDate'},
	    	{name: 'WH_CODE',					text: '<t:message code="system.label.purchase.deliverywarehousecode" default="납품창고코드"/>',		type:'string'},
	    	{name: 'WH_NAME',					text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',			type:'string'},
	    	{name: 'ORDER_UNIT_Q',				text: '<t:message code="system.label.purchase.poqty" default="발주량"/>',				type:'uniQty'},
	    	{name: 'ORDER_UNIT_INSTOCK_Q',		text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>',				type:'uniQty'},
	    	{name: 'ORDER_UNIT_BAL_Q',			text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>',				type:'uniQty'},
	    	{name: 'CITEM_CODE',				text: '<t:message code="system.label.purchase.materialitemcode" default="자재 품목코드"/>',		type:'string'},
	    	{name: 'CITEM_NAME',				text: '<t:message code="system.label.purchase.materialitemspec" default="자재 품명/규격"/>',		type:'string'},
	    	{name: 'OCITEM_NAME',				text: '<t:message code="system.label.purchase.materialitem" default="자재 품명"/>',			type:'string'},
	    	{name: 'CSTOCK_UNIT',				text: '<t:message code="system.label.purchase.unit" default="단위"/>',				type:'string'},
	    	{name: 'REQ_DATE',					text: '<t:message code="system.label.purchase.issuereserveddate" default="출고예약일"/>',			type:'uniDate'},
	    	{name: 'WCWH_CODE',					text: '<t:message code="system.label.purchase.issuewarehousecode" default="출고창고코드"/>',		type:'string'},
	    	{name: 'WCWH_NAME',					text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',			type:'string'},
	    	{name: 'UNIT_Q',					text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>',			type:'uniQty'},
	    	{name: 'LOSS_RATE',					text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>',				type:'uniPercent'},
	    	{name: 'GOOD_STOCK_Q',				text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>(<t:message code="system.label.purchase.goodstock" default="양품재고"/>)',	type:'uniQty'},
	    	{name: 'NEED_Q',					text: '<t:message code="system.label.purchase.needqty" default="필요수량"/>',			type:'uniQty'},
	    	{name: 'ALLOC_Q',					text: '<t:message code="system.label.purchase.issuereservedqty" default="출고예약량"/>',			type:'uniQty'},
	    	{name: 'OUTSTOCK_Q',				text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>',				type:'uniQty'},
	    	{name: 'ALLOC_BAL_Q',				text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>',			type:'uniQty'},
	    	{name: 'MINI_PACK_Q',				text: '<t:message code="system.label.purchase.minimumpackagingunit" default="최소포장단위"/>',		type:'uniQty'},
	    	{name: 'WKORD_NUM',					text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',		type:'string'},
	    	{name: 'WORK_SHOP_CODE',			text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>',			type:'string'},
	    	{name: 'WORK_SHOP_NAME',			text: '<t:message code="system.label.purchase.workcentername" default="작업장명"/>',			type:'string'}	    				    			
			]
	});		// end of Unilite.defineModel('Otr330skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 */					
	var directMasterStore1 = Unilite.createStore('otr330skrvMasterStore1',{
			model: 'Otr330skrvModel',
			uniOpt : {
            	isMaster  : false,			// 상위 버튼 연결 
            	editable  : false,			// 수정 모드 사용 
            	deletable : false,			// 삭제 가능 여부 
	            useNavi   : false				// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'otr330skrvService.selectList'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				this.load({
					params : param
				});
			},
			groupField: 'ORDER_NUM'		
	});		// end of var directMasterStore1 = Unilite.createStore('otr330skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items:[{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	labelWidth: 90,
	        	allowBlank: false,
	        	listeners: {
                    change: function(field, newValue, oldValue, eOpts) {   
                    	panelSearch.setValue('WH_CODE', '');
                    	panelSearch.setValue('WCWH_CODE', '');
                    }
	        	}
	        },
	        Unilite.popup('CUST',{ 
	                fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
	        		valueFieldName: 'CUSTOM_CODE', 
					textFieldName: 'CUSTOM_NAME',
	        		extParam: {'CUSTOM_TYPE':['1','2']},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_CODE', newValue);
									panelResult.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_NAME', '');
										panelResult.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_NAME', newValue);
									panelResult.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_CODE', '');
										panelResult.setValue('CUSTOM_CODE', '');
									}
								},
								applyextparam: function(popup){	
						    	popup.setExtParam({'CUSTOM_TYPE':['1','2']});
						    }
						}
	        	}),{
	        		fieldLabel: '<t:message code="system.label.purchase.issuereserveddate" default="출고예약일"/>',
	        		xtype: 'uniDateRangefield',
	        		startFieldName: 'ORDER_DATE_FR',
	        		endFieldName: 'ORDER_DATE_TO',
	        		startDate: UniDate.get('startOfMonth'),
	        		endDate: UniDate.get('today'),
	        		width: 315, 
	        		labelWidth: 90,
	        		onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('ORDER_DATE_TO',newValue);
				    	}
				    }
	        	},{ 
	        		fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
	        		name: 'WH_CODE', 
	        		xtype: 'uniCombobox',
	        		comboType  : 'O', 
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;   
                            })
                        }
                      }
					}
	        	},
	        		Unilite.popup('DIV_PUMOK',{
	        		    fieldLabel: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>',
	        			valueFieldName: 'PITEM_CODE', 
						textFieldName: 'PITEM_NAME',
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('PITEM_CODE', newValue);
										panelResult.setValue('PITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('PITEM_NAME', '');
											panelResult.setValue('PITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('PITEM_NAME', newValue);
										panelResult.setValue('PITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('PITEM_CODE', '');
											panelResult.setValue('PITEM_CODE', '');
										}
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE':panelResult.getValue("DIV_CODE")});
									}
							}
	        	}),{ 
	        		fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
	        		name: 'WCWH_CODE', 
	        		xtype: 'uniCombobox', 
	        		comboType  : 'O',
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WCWH_CODE', newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;   
                            })
                        }
                      }
					}
	        	},{
	        		fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>', 
	        		xtype: 'uniTextfield',
	        		name :'ORDER_NUM',
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_NUM', newValue);
						}
					}
	        	},
	        		Unilite.popup('DIV_PUMOK',{ 
	        		    fieldLabel: '<t:message code="system.label.purchase.materialitemcode" default="자재 품목코드"/>', 
	        			valueFieldName: 'CITEM_CODE', 
						textFieldName: 'CITEM_NAME',
	        			extParam:{'CUSTOM_TYPE':'3'},
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CITEM_CODE', newValue);
										panelResult.setValue('CITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CITEM_NAME', '');
											panelResult.setValue('CITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CITEM_NAME', newValue);
										panelResult.setValue('CITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CITEM_CODE', '');
											panelResult.setValue('CITEM_CODE', '');
										}
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE':panelResult.getValue("DIV_CODE")});
									}
							}
	        	}),{ 
	        		fieldLabel: '<t:message code="system.label.purchase.postatus" default="발주상태"/>',
	        		name: 'CONTROL_STATUS' , 
	        		xtype: 'uniCombobox', 
	        		comboType: 'AU',
	        		comboCode: 'M002',
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CONTROL_STATUS', newValue);
						}
					}
	        	},{ 
	    			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
	    			name: 'ITEM_ACCOUNT', 
	    			xtype: 'uniCombobox', 
	    			comboType: 'AU',
	    			comboCode: 'B020',
	    			labelWidth: 90,
	    			hidden:true,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
	   			},{ 
	    			fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
	    			name: 'WORK_SHOP_CODE',
	    			xtype: 'uniCombobox',
	    			hidden:true,
	    			store: Ext.data.StoreManager.lookup('wsList'),
	    			labelWidth: 90,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						}
					}
	    		},{
	    			fieldLabel: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
	    			xtype: 'uniTextfield',
	    			labelWidth: 90,
	    			name:'WKORD_NUM',
	    			hidden:true,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WKORD_NUM', newValue);
						}
					}
	    		}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	labelWidth: 90,
	        	allowBlank: false,
	        	listeners: {
                    change: function(field, newValue, oldValue, eOpts) {   
                        panelResult.setValue('WH_CODE', '');
                        panelResult.setValue('WCWH_CODE', '');
                    }
                }
	        },
	        	Unilite.popup('CUST',{ 
	        		fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
	        		valueFieldName: 'CUSTOM_CODE', 
					textFieldName: 'CUSTOM_NAME',
	        		extParam: {'CUSTOM_TYPE':['1','2']},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_CODE', newValue);
									panelResult.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_NAME', '');
										panelResult.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_NAME', newValue);
									panelResult.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_CODE', '');
										panelResult.setValue('CUSTOM_CODE', '');
									}
								},
								applyextparam: function(popup){	
						    	popup.setExtParam({'CUSTOM_TYPE':['1','2']});
						    }
						}
	        	}),{
	        		fieldLabel: '<t:message code="system.label.purchase.issuereserveddate" default="출고예약일"/>',
	        		xtype: 'uniDateRangefield',
	        		startFieldName: 'ORDER_DATE_FR',
	        		endFieldName: 'ORDER_DATE_TO',
	        		startDate: UniDate.get('startOfMonth'),
	        		endDate: UniDate.get('today'),
	        		width: 315, 
	        		labelWidth: 90,
	        		onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('ORDER_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('ORDER_DATE_TO',newValue);
				    	}
				    }
	        	},{ 
	        		fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
	        		name: 'WH_CODE', 
	        		xtype: 'uniCombobox',
	        		comboType  : 'O', 
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;   
                            })
                        }
                      }
					}
	        	},
	        		Unilite.popup('DIV_PUMOK',{
	        		    fieldLabel: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>',
	        			valueFieldName: 'PITEM_CODE', 
						textFieldName: 'PITEM_NAME',
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('PITEM_CODE', newValue);
										panelResult.setValue('PITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('PITEM_NAME', '');
											panelResult.setValue('PITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('PITEM_NAME', newValue);
										panelResult.setValue('PITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('PITEM_CODE', '');
											panelResult.setValue('PITEM_CODE', '');
										}
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE':panelResult.getValue("DIV_CODE")});
									}
							}
	        	}),{ 
	        		fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
	        		name: 'WCWH_CODE', 
	        		xtype: 'uniCombobox', 
	        		comboType  : 'O', 
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WCWH_CODE', newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;   
                            })
                        }
                      }
					}
	        	},{
	        		fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>', 
	        		xtype: 'uniTextfield',
	        		name :'ORDER_NUM',
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ORDER_NUM', newValue);
						}
					}
	        	},
	        		Unilite.popup('DIV_PUMOK',{ 
	        			fieldLabel: '<t:message code="system.label.purchase.materialitemcode" default="자재 품목코드"/>', 
	        			valueFieldName: 'CITEM_CODE', 
						textFieldName: 'CITEM_NAME',
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CITEM_CODE', newValue);
										panelResult.setValue('CITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CITEM_NAME', '');
											panelResult.setValue('CITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CITEM_NAME', newValue);
										panelResult.setValue('CITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CITEM_CODE', '');
											panelResult.setValue('CITEM_CODE', '');
										}
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE':panelResult.getValue("DIV_CODE")});
									}
							}
	        	}),{ 
	        		fieldLabel: '<t:message code="system.label.purchase.postatus" default="발주상태"/>',
	        		name: 'CONTROL_STATUS' , 
	        		xtype: 'uniCombobox', 
	        		comboType: 'AU',
	        		comboCode: 'M002',
	        		labelWidth: 90,
	        		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('CONTROL_STATUS', newValue);
						}
					}
	        	},{ 
	    			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
	    			name: 'ITEM_ACCOUNT', 
	    			xtype: 'uniCombobox', 
	    			comboType: 'AU',
	    			comboCode: 'B020',
	    			labelWidth: 90,
	    			hidden:true,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
	   			},{ 
	    			fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
	    			name: 'WORK_SHOP_CODE',
	    			xtype: 'uniCombobox',
	    			store: Ext.data.StoreManager.lookup('wsList'),
	    			labelWidth: 90,
	    			hidden:true,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
	    		},{
	    			fieldLabel: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
	    			xtype: 'uniTextfield',
	    			labelWidth: 90,
	    			name:'WKORD_NUM',
	    			hidden:true,
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WKORD_NUM', newValue);
						}
					}
	    		}],
	    		setAllFieldsReadOnly : setAllFieldsReadOnly
    });	
    /**
     * Master Grid1 정의(Grid Panel)
     */
    var masterGrid = Unilite.createGrid('otr330skrvGrid1', {
        layout : 'fit',
        region:'center',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
        	id: 'masterGridTotal', 	
        	ftype: 'uniSummary', 	 
        	showSummaryRow: true
        }],
    	store: directMasterStore1,
        columns:  [{ 
        	text:'<t:message code="system.label.purchase.subcontractorderdetail" default="외주발주내역"/>', 
			locked : true,     
        	columns: [
              	{ dataIndex: 'COMP_CODE',  				width: 53,  locked: true, hidden : true},
              	{ dataIndex: 'DIV_CODE',  				width: 53,  locked: true, hidden : true},
              	{ dataIndex: 'CONTROL_STATUS', 			width: 53,  locked: true, hidden : true},
              	{ dataIndex: 'CONTROL_STATUS_NAME',  	width: 86,  locked: true,
              	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
	                }
              	},
              	{ dataIndex: 'CUSTOM_CODE', 			width: 120,  locked: true, hidden : true},
              	{ dataIndex: 'CUSTOM_NAME',  			width: 150,  locked: true},
              	{ dataIndex: 'ORDER_NUM',  				width: 120,  locked: true},
              	{ dataIndex: 'PITEM_CODE',  			width: 120,  locked: true},
              	{ dataIndex: 'PITEM_NAME',  			width: 166,  locked: true},
              	{ dataIndex: 'OPITEM_NAME',  			width: 150,  locked: true, hidden : true},
              	{ dataIndex: 'ORDER_UNIT',  			width: 66,   locked: true,align:'center'},
              	{ dataIndex: 'ORDER_DATE',  			width: 86,   locked: true},
              	{ dataIndex: 'DVRY_DATE',  				width: 86,   locked: true},
              	{ dataIndex: 'WH_CODE', 				width: 100,  locked: true, hidden : true},
              	{ dataIndex: 'WH_NAME',  				width: 120,  locked: true},
              	{ dataIndex: 'ORDER_UNIT_Q',  			width: 100,  locked: true},
              	{ dataIndex: 'ORDER_UNIT_INSTOCK_Q',  	width: 100,  locked: true},
              	{ dataIndex: 'ORDER_UNIT_BAL_Q',  		width: 100,  locked: true} 				
            ]},
            { text:'<t:message code="system.label.purchase.issuereserveddetail" default="출고예약내역"/>',
        	columns: [
				{ dataIndex: 'CITEM_CODE',  			width: 120 },
				{ dataIndex: 'CITEM_NAME', 				width: 166 },
				{ dataIndex: 'OCITEM_NAME',  			width: 120,  hidden : true },
				{ dataIndex: 'CSTOCK_UNIT',  			width: 66 ,align:'center'},
				{ dataIndex: 'REQ_DATE',  				width: 86 },
				{ dataIndex: 'WCWH_CODE',  				width: 100,  hidden : true },
				{ dataIndex: 'WCWH_NAME',  				width: 120 },
				{ dataIndex: 'UNIT_Q',  				width: 100 },
				{ dataIndex: 'LOSS_RATE',  				width: 100 },
				{ dataIndex: 'GOOD_STOCK_Q', 			width: 100 , summaryType:'sum'},
				{ dataIndex: 'NEED_Q',  				width: 100 , summaryType:'sum'},
				{ dataIndex: 'ALLOC_Q',  				width: 100 , summaryType:'sum'},
				{ dataIndex: 'OUTSTOCK_Q',  			width: 100 , summaryType:'sum'},
				{ dataIndex: 'ALLOC_BAL_Q',  			width: 100 , summaryType:'sum'},
				{ dataIndex: 'MINI_PACK_Q',  			width: 100 },
				{ dataIndex: 'WKORD_NUM',  				width: 120 },
				{ dataIndex: 'WORK_SHOP_CODE',  		width: 100,  hidden : true },
				{ dataIndex: 'WORK_SHOP_NAME',  		width: 120,  hidden : true } 				
          	]}
        ]
    });
	
    Unilite.Main( {
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},panelSearch],	
		id  : 'otr330skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function()	{			
			masterGrid.getStore().loadStoreRecords();
			
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
	
    function setAllFieldsReadOnly(b) {
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
			//	this.mask();		    
			}
  		} else {
			this.unmask();
		}
		return r;
	}
};
</script>