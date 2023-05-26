<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa200ukrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="ssa200ukrv"  /> 			<!-- 사업장 --> 	
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' /> <!--생성경로-->	
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var beforeRowIndex;	//마스터그리드 같은row중복 클릭시 다시 load되지 않게
function appMain() {
/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssa200ukrvModel1', {
		
	    fields: [{name: 'COMP_CODE'				,text: 'COMP_CODE' 	,type: 'string'},	 
				 {name: 'DIV_CODE'				,text: 'DIV_CODE' 	,type: 'string'},	 
				 {name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 	,type: 'string'},	 
				 {name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 		,type: 'string'},	 
				 {name: 'CREATE_LOC'			,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>' 		,type: 'string'},	 
				 {name: 'SALE_DATE'				,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>' 		,type: 'string'},	 
				 {name: 'SALE_PRSN'				,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' 		,type: 'string', comboType : 'AU', comboCode: 'S010'},	 
				 {name: 'BILL_NUM'				,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>' 		,type: 'string'},	 
				 {name: 'BILL_SEQ'				,text: '<t:message code="system.label.sales.seq" default="순번"/>' 		,type: 'int'},	 
				 {name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>' 		,type: 'string'},	 
				 {name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 		,type: 'string'},	 
				 {name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>' 		,type: 'string'},	 
				 {name: 'SALE_UNIT'				,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>' 		,type: 'string', displayField: 'value'},	 
				 {name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>' 		,type: 'uniQty'},	 
				 {name: 'QUANTITY'				,text: '잔량' 		,type: 'uniQty'},	 
				 {name: 'WGT_UNIT'				,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>' 		,type: 'string'},	 
				 {name: 'UNIT_WGT'				,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>' 		,type: 'string'},	 
				 {name: 'SALE_WGT_Q'			,text: '수량(중량)' 	,type: 'uniQty'},	 
				 {name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>' 	,type: 'uniUnitPrice'},	 
				 {name: 'VOL_UNIT'				,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>' 		,type: 'string'},	 
				 {name: 'UNIT_VOL'				,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>' 		,type: 'string'},	 
				 {name: 'SALE_VOL_Q'			,text: '수량(부피)' 	,type: 'uniQty'},	 
				 {name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>' 	,type: 'uniUnitPrice'},	 
				 {name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>' 		,type: 'uniPrice'},	 
				 {name: 'TAX_AMT_O'				,text: '<t:message code="system.label.sales.taxamount" default="세액"/>' 		,type: 'uniPrice'},	 
				 {name: 'TOT_SALE_AMT_O'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>' 		,type: 'uniPrice'}			                                       	
		]
	});
	
	Unilite.defineModel('Ssa200ukrvModel2', {
		
	    fields: [{name: 'COMP_CODE'      ,text: 'COMP_CODE' 	,type: 'string'},
				 {name: 'DIV_CODE'       ,text: 'DIV_CODE' 		,type: 'string'},
				 {name: 'ITEM_CODE'      ,text: '<t:message code="system.label.sales.item" default="품목"/>' 		,type: 'string'},
				 {name: 'ITEM_NAME'      ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			,type: 'string'},
				 {name: 'SPEC'           ,text: '<t:message code="system.label.sales.spec" default="규격"/>' 			,type: 'string'},
				 {name: 'CHOICE'         ,text: '<t:message code="system.label.sales.selection" default="선택"/>' 			,type: 'string'},
				 {name: 'INOUT_NUM'      ,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>' 		,type: 'string'},
				 {name: 'INOUT_SEQ'      ,text: '<t:message code="system.label.sales.seq" default="순번"/>' 			,type: 'string'},
				 {name: 'INOUT_DATE'     ,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>' 			,type: 'uniDate'},
				 {name: 'ORDER_UNIT'     ,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value'},
				 {name: 'NOT_SALE_Q'     ,text: '<t:message code="system.label.sales.notbillingqty" default="미매출량"/>' 		,type: 'uniQty'},
				 {name: 'ORDER_UNIT_Q'   ,text: '<t:message code="system.label.sales.tranqty" default="수불량"/>' 			,type: 'uniQty'},
				 {name: 'ORDER_UNIT_P'   ,text: '<t:message code="system.label.sales.price" default="단가"/>' 			,type: 'uniUnitPrice'},
				 {name: 'WGT_UNIT'       ,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>' 		,type: 'string'},
				 {name: 'UNIT_WGT'       ,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>' 		,type: 'string'},
				 {name: 'INOUT_WGT_Q'    ,text: '수량(중량)' 		,type: 'uniQty'},
				 {name: 'INOUT_FOR_WGT_P',text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>' 		,type: 'uniUnitPrice'},
				 {name: 'VOL_UNIT'       ,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>' 		,type: 'string'},
				 {name: 'UNIT_VOL'       ,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>' 		,type: 'string'},
				 {name: 'INOUT_VOL_Q'    ,text: '수량(부피)' 		,type: 'uniQty'},
				 {name: 'INOUT_FOR_VOL_P',text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>' 		,type: 'uniUnitPrice'},
				 {name: 'BILL_NUM'       ,text: 'BILL_NUM' 		,type: 'string'},
				 {name: 'BILL_SEQ'       ,text: 'BILL_SEQ' 		,type: 'string'},
				 {name: 'CREATE_LOC'     ,text: 'CREATE_LOC'	,type: 'string'},
				 {name: 'STATUS' 	     ,text: 'STATUS'		,type: 'string'}
				 
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('ssa200ukrvMasterStore1',{
			model: 'Ssa200ukrvModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa200ukrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(store.getCount() > 0){
	           			panelSearch.setAllFieldsReadOnly(true);
	           			panelResult.setAllFieldsReadOnly(true);
	           		}
	           		if(!Ext.isEmpty(records)){
	           			detailStore.loadStoreRecords(records[0]);
	           		}else{
	           			detailStore.removeAll('clear');           		
	           		}
           		}
			}
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ssa200ukrvService.detailList',
    	   update: 'ssa200ukrvService.updateDetail',
    	   syncAll: 'ssa200ukrvService.saveAll'
		}
	});	
	var detailStore = Unilite.createStore('ssa200ukrvMasterStore2',{
			model: 'Ssa200ukrvModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords : function(record){
				var gridParam = record.data; 
				var formParam = {};
				formParam.CALCULATE_YN = panelSearch.getField('RDO_YN').getValue() ? "Y" : "N";
				var params = Ext.merge(gridParam, formParam);				
				this.load({
					params : params
				});
			}, 
			saveStore: function(config) {
//				var masterRecord = masterGrid.getSelectedRecord();
//				var masterGridParam = { MDIV_CODE: masterRecord.get('DIV_CODE'),
//									  MBILL_NUM: masterRecord.get('BILL_NUM'),
//									  MBILL_SEQ: masterRecord.get('BILL_SEQ'),
//									  MCREATE_LOC: masterRecord.get('CREATE_LOC')};												  
//				var arr1 = detailGrid.getSelectedRecords()[0].data;
//				var arr2 = detailGrid.getSelectedRecords()[1].data;
//				var detailGridParam = {detailRecord1: arr1, detailRecord2: arr2};
//				detailGridParam.put({detailRecord1: arr1});
//				detailGridParam.put({detailRecord2: arr2});
//				var params = Ext.merge(masterGridParam, detailGridParam);
//				
//				if(panelSearch.getField('RDO_YN').getValue()){		//정산여부 Y일시					
//					ssa200ukrvService.insertTypeY(params, function(provider, response)	{							
//						
//					})
//				}else{	//정산여부 N일시
//					ssa200ukrvService.insertTypeN(params, function(provider, response)	{							
//						
//					})
//				}
				var masterRecord = masterGrid.getSelectedRecord();
				config = {					
					params: [{MDIV_CODE: masterRecord.get('DIV_CODE'),
							  MBILL_NUM: masterRecord.get('BILL_NUM'),
							  MBILL_SEQ: masterRecord.get('BILL_SEQ'),
							  MCREATE_LOC: masterRecord.get('CREATE_LOC')}],
					success: function(batch, option) {
						UniAppManager.setToolbarButtons('save', false);	
						masterStore.loadStoreRecords();
					} 
				};
				this.syncAllDirect(config);
			}
			
	});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */    
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{					
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			allowBlank:false,
    			holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}, { 
    			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_SALE_DATE',
		        endFieldName: 'TO_SALE_DATE',
		        isDateRangefield: true,
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),		        
    			allowBlank:false,            
//    			holdable: 'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_SALE_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_SALE_DATE',newValue);
			    	}
			    }
	        },
    			Unilite.popup('AGENT_CUST',{
		        fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
		        
		        holdable: 'hold',
	        	listeners: {
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
    			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
    			name:'SALE_PRSN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'S010',
    			holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_PRSN', newValue);
					}
				}
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'	,
    			name:'CREATE_LOC', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'B031',
    			holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}
    		},
		    	Unilite.popup('DIV_PUMOK',{
		    	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		    	
		    	holdable: 'hold',
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				}
		    }),{
				xtype: 'radiogroup',                            
				fieldLabel: '정산여부',				
				holdable: 'hold',
				items: [{
				       boxLabel: '예',
				       width: 50,
				       name: 'RDO_YN',
				       inputValue: 'Y'
				}, {
				       boxLabel: '아니오',
				       width: 60, name: 'RDO_YN',
				       inputValue: 'N',
				       checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('RDO_YN').setValue(newValue.RDO_YN);
					}
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
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
//						if(item.isDateRangefield)	{
//							var popupFC = item.up('uniDateRangefield')	;							
//							if(popupFC.holdable == 'hold') {
//								popupFC.setReadOnly(true);
//							}
//						}
					})
   				}
	  		} else {
				//this.unmask();
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{					
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, { 
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_SALE_DATE',
	        endFieldName: 'TO_SALE_DATE',
	        isDateRangefield: true,
	        width: 470,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),		        
			allowBlank:false,              	
//			holdable: 'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_SALE_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_SALE_DATE',newValue);
		    	}
		    }
        },
			Unilite.popup('AGENT_CUST',{
	        fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
	        
	        holdable: 'hold',
        	listeners: {
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
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name:'SALE_PRSN', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'S010',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'	,
			name:'CREATE_LOC', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'B031',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CREATE_LOC', newValue);
				}
			}
		},
	    	Unilite.popup('DIV_PUMOK',{
	    	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	    	
	    	holdable: 'hold',
        	listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				}
			}
	    }),{
			xtype: 'radiogroup',                            
			fieldLabel: '정산여부',
			holdable: 'hold',
			items: [{
			       boxLabel: '예',
			       width: 50,
			       name: 'RDO_YN',
			       inputValue: 'Y'
			}, {
			       boxLabel: '아니오',
			       width: 60, name: 'RDO_YN',
			       inputValue: 'N',
				       checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('RDO_YN').setValue(newValue.RDO_YN);
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');							
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
					if(Ext.isDefined(item.holdable) ){
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;  		
		}	
    });    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa200ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: masterStore,
    	uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },    	           	
        columns:  [{ dataIndex: 'COMP_CODE'				,	 width: 66, hidden: true },
        		   { dataIndex: 'DIV_CODE'				,	 width: 66, hidden: true },
        		   { dataIndex: 'CUSTOM_CODE'			,	 width: 66, hidden: true },
        		   { dataIndex: 'CUSTOM_NAME'			,	 width: 166 },
        		   { dataIndex: 'CREATE_LOC'			,	 width: 66, hidden: true },
        		   { dataIndex: 'SALE_DATE'				,	 width: 80 },
        		   { dataIndex: 'SALE_PRSN'				,	 width: 80 },
        		   { dataIndex: 'BILL_NUM'				,	 width: 100 },
        		   { dataIndex: 'BILL_SEQ'				,	 width: 66 },
        		   { dataIndex: 'ITEM_CODE'				,	 width: 110 },
        		   { dataIndex: 'ITEM_NAME'				,	 width: 166 },
        		   { dataIndex: 'SPEC'					,	 width: 133 },
        		   { dataIndex: 'SALE_UNIT'				,	 width: 66 },
        		   { dataIndex: 'SALE_Q'				,	 width: 93 },
        		   { dataIndex: 'QUANTITY'				,	 width: 93 },
        		   { dataIndex: 'WGT_UNIT'				,	 width: 80, hidden: true },
        		   { dataIndex: 'UNIT_WGT'				,	 width: 80, hidden: true },
        		   { dataIndex: 'SALE_WGT_Q'			,	 width: 93, hidden: true },
        		   { dataIndex: 'SALE_FOR_WGT_P'		,	 width: 106, hidden: true },
        		   { dataIndex: 'VOL_UNIT'				,	 width: 80, hidden: true },
        		   { dataIndex: 'UNIT_VOL'				,	 width: 80, hidden: true },
        		   { dataIndex: 'SALE_VOL_Q'			,	 width: 93, hidden: true },
        		   { dataIndex: 'SALE_FOR_VOL_P'		,	 width: 106, hidden: true },
        		   { dataIndex: 'SALE_LOC_AMT_I'		,	 width: 106 },
        		   { dataIndex: 'TAX_AMT_O'				,	 width: 93 },
        		   { dataIndex: 'TOT_SALE_AMT_O'		,	 width: 106 }       		   	  
        ],
        listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			}
       }
        
    });

    
    var detailGrid = Unilite.createGrid('ssa200ukrvGrid2', {
    	// for tab    	
        layout : 'fit',
        region:'south',
	    uniOpt: {
			expandLastColumn: true,
			onLoadSelectFirst: false,
			useRowNumberer: false
	    },
        flex: 1,
    	store: detailStore,    	
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			record.set('STATUS', panelSearch.getField('RDO_YN').getValue() ? "Y" : "N");
        		},
				select: function(grid, record, index, eOpts ){					
					
	          	},
				deselect:  function(grid, record, index, eOpts ){
					record.set('STATUS', '');
					if(this.getCount() == 0){
						UniAppManager.setToolbarButtons('save',false);
					}
        		}
        	}
        }),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'				,	 width: 33, hidden: true },
        		   { dataIndex: 'DIV_CODE'				,	 width: 33, hidden: true },
        		   { dataIndex: 'ITEM_CODE'				,	 width: 110 },
        		   { dataIndex: 'ITEM_NAME'				,	 width: 166 },
        		   { dataIndex: 'SPEC'			    	,	 width: 133 },
//        		   { dataIndex: 'CHOICE'				,	 width: 33 },
        		   { dataIndex: 'INOUT_NUM'				,	 width: 100 },
        		   { dataIndex: 'INOUT_SEQ'				,	 width: 66 },
        		   { dataIndex: 'INOUT_DATE'			,	 width: 80 },
        		   { dataIndex: 'ORDER_UNIT'			,	 width: 66, align: 'center' },
        		   { dataIndex: 'NOT_SALE_Q'			,	 width: 93 },
        		   { dataIndex: 'ORDER_UNIT_Q'			,	 width: 93 },
        		   { dataIndex: 'ORDER_UNIT_P'			,	 width: 93 },
        		   { dataIndex: 'WGT_UNIT'				,	 width: 66, hidden: true },
        		   { dataIndex: 'UNIT_WGT'				,	 width: 93, hidden: true },
        		   { dataIndex: 'INOUT_WGT_Q'			,	 width: 93, hidden: true },
        		   { dataIndex: 'INOUT_FOR_WGT_P'		,	 width: 93, hidden: true },
        		   { dataIndex: 'VOL_UNIT'				,	 width: 66, hidden: true },
        		   { dataIndex: 'UNIT_VOL'				,	 width: 93, hidden: true },
        		   { dataIndex: 'INOUT_VOL_Q'			,	 width: 93, hidden: true },
        		   { dataIndex: 'INOUT_FOR_VOL_P'		,	 width: 93, hidden: true },
        		   { dataIndex: 'BILL_NUM'				,	 width: 66, hidden: true },
        		   { dataIndex: 'BILL_SEQ'				,	 width: 66, hidden: true },
        		   { dataIndex: 'CREATE_LOC'			,	 width: 66, hidden: true },
        		   { dataIndex: 'STATUS'				,	 width: 66, hidden: true }
        ]         
    });
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid, detailGrid
			]	
		}		
		,panelSearch 
		],
		id  : 'ssa200ukrvApp',
		fnInitBinding : function() {
			panelSearch.getField('RDO_YN').setValue("N");
			panelSearch.setValue('TO_SALE_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_SALE_DATE',UniDate.get('startOfMonth', panelSearch.getValue('TO_SALE_DATE')));
			panelResult.setValue('TO_SALE_DATE', UniDate.get('today'));
			panelResult.setValue('FR_SALE_DATE',UniDate.get('startOfMonth', panelResult.getValue('TO_SALE_DATE')));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save',false);
//			Ext.getCmp('rdo').setReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailGrid.reset();
			this.fnInitBinding();
		},
		onQueryButtonDown : function()	{
			beforeRowIndex = -1;
			masterGrid.getStore().loadStoreRecords();			
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},		
		onSaveDataButtonDown: function(config) {			
			detailStore.saveStore();
		}
	});

};


</script>
