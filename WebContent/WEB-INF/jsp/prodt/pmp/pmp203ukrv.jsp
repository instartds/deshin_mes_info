<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp203ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow;	//

var BsaCodeInfo = {
	gsBomPathYN: '${gsBomPathYN}'
};

//var output ='';
//for(var key in BsaCodeInfo){
// output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

function appMain() {     
	
	var isAutoPath = true;
	if(BsaCodeInfo.gsBomPathYN=='Y')	{
		isAutoItem = false;
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp203ukrvService.selectDetailList',
			update: 'pmp203ukrvService.updateDetail',
			create: 'pmp203ukrvService.insertDetail',
			destroy: 'pmp203ukrvService.deleteDetail',
			syncAll: 'pmp203ukrvService.saveAll'
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
        	},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{ 
		        fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'PRODT_WKORD_DATE_FR',
				endFieldName: 'PRODT_WKORD_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_WKORD_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_WKORD_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},{ 
		        fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName: 'OUTSTOCK_REQ_DATE_TO',
				width: 315,
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('OUTSTOCK_REQ_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('OUTSTOCK_REQ_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		    	fieldLabel: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'OUTSTOCK_NUM',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OUTSTOCK_NUM', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 팝업창 표준화
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>', 
					validateBlank:false,
					valueFieldName: 'PITEM_CODE',
					textFieldName: 'PITEM_NAME',
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('PITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PITEM_NAME', '');
								panelSearch.setValue('PITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('PITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PITEM_CODE', '');
								panelSearch.setValue('PITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})
				,{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 60, 
					name: 'CONTROL_STATUS',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '2'
				},{
					boxLabel : '<t:message code="system.label.product.closing" default="마감"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '8'
				},{
					boxLabel : '<t:message code="system.label.product.completion" default="완료"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '9'		
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.issueapplyviewyn" default="출고반영 조회여부"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
					width: 60, 
					name: 'OUTSTOCK_VIEW_YN',
					inputValue: 'Y',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
					width: 60,
					name: 'OUTSTOCK_VIEW_YN',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('OUTSTOCK_VIEW_YN').setValue(newValue.OUTSTOCK_VIEW_YN);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.issuerequestcreate" default="출고요청생성"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 60, 
					name: 'OUTSTOCK_REQ_YN',
					inputValue: ''
				},{
					boxLabel : '<t:message code="system.label.product.yes" default="예"/>', 
					width: 60,
					name: 'OUTSTOCK_REQ_YN',
					inputValue: '1',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
					width: 60,
					name: 'OUTSTOCK_REQ_YN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('OUTSTOCK_REQ_YN').setValue(newValue.OUTSTOCK_REQ_YN);
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
        	},{ 
		        fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'PRODT_WKORD_DATE_FR',
				endFieldName: 'PRODT_WKORD_DATE_TO',
				//width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PRODT_WKORD_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_WKORD_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WKORD_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{ 
		        fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName: 'OUTSTOCK_REQ_DATE_TO',
				//width: 315,
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('OUTSTOCK_REQ_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('OUTSTOCK_REQ_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		    	fieldLabel: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'OUTSTOCK_NUM',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('OUTSTOCK_NUM', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		 
				fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 60, 
					name: 'CONTROL_STATUS',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '2'
				},{
					boxLabel : '<t:message code="system.label.product.closing" default="마감"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '8'
				},{
					boxLabel : '<t:message code="system.label.product.completion" default="완료"/>', 
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '9'		
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.issueapplyviewyn" default="출고반영 조회여부"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
					width: 60, 
					name: 'OUTSTOCK_VIEW_YN',
					inputValue: 'Y',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
					width: 60,
					name: 'OUTSTOCK_VIEW_YN',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('OUTSTOCK_VIEW_YN').setValue(newValue.OUTSTOCK_VIEW_YN);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.issuerequestcreate" default="출고요청생성"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 60, 
					name: 'OUTSTOCK_REQ_YN',
					inputValue: ''
				},{
					boxLabel : '<t:message code="system.label.product.yes" default="예"/>', 
					width: 60,
					name: 'OUTSTOCK_REQ_YN',
					inputValue: '1',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
					width: 60,
					name: 'OUTSTOCK_REQ_YN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('OUTSTOCK_REQ_YN').setValue(newValue.OUTSTOCK_REQ_YN);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>', 
					validateBlank:false,
					valueFieldName: 'PITEM_CODE',
					textFieldName: 'PITEM_NAME',
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('PITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PITEM_NAME', '');
								panelSearch.setValue('PITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('PITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PITEM_CODE', '');
								panelSearch.setValue('PITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})],
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	
	Unilite.defineModel('pmp203ukrvDetailModel', {
	    fields: [  	 
	    	{name: 'WKORD_STATUS'		  	,text:'<t:message code="system.label.product.status" default="상태"/>'			,type:'string'},
			{name: 'WKORD_STATUS_NM'	 	,text: '<t:message code="system.label.product.status" default="상태"/>'				,type:'string'},
			{name: 'ITEM_CODE'			 	,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			    ,type:'string'},
			{name: 'SPEC'				  	,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'PATH_CODE'				,text: '<t:message code="system.label.product.pathinfo" default="PATH정보"/>'			,type:'string'},
			{name: 'PATH_NAME'				,text: '<t:message code="system.label.product.pathinfo" default="PATH정보"/>'			,type:'string'},
			{name: 'OUTSTOCK_REQ_DATE'	 	,text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'			,type:'uniDate'},
			{name: 'OUTSTOCK_REQ_Q'	  		,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'			,type:'uniQty'},
			{name: 'OUTSTOCK_Q'		  		,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'			    ,type:'uniQty'},
			{name: 'ALLOCK_Q'				,text: '<t:message code="system.label.product.materialreservationqty" default="자재예약량"/>'			,type:'uniQty'},
			{name: 'MINI_PACK_Q'		  	,text: '<t:message code="system.label.product.minimumpackagingqty" default="최소포장량"/>'		,type:'uniQty'},
			{name: 'OUTSTOCK_OVER_Q'		,text: '<t:message code="system.label.product.overissueqty2" default="과출고수량"/>'			,type:'uniQty'},	
			{name: 'REF_WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'PRODT_WKORD_DATE'	  	,text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			,type:'uniDate'},
			{name: 'PITEM_CODE'				,text: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>'			,type:'string'},
			{name: 'PITEM_NAME'		  		,text: '<t:message code="system.label.product.parentitemname" default="모품목명"/>'			,type:'string'},
			{name: 'PSPEC'				  	,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},
			{name: 'PSTOCK_UNIT'		 	,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'OUTSTOCK_NUM'		 	,text: '<t:message code="system.label.product.requestno" default="요청번호"/>'			,type:'string'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'PJT_CODE'			  	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			    ,type:'string'},
			{name: 'REMARK'					,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			,type:'string'},
			{name: 'DIV_CODE'			 	,text: '<t:message code="system.label.product.division" default="사업장"/>'			    ,type:'string'},
			{name: 'WORK_SHOP_CODE'	  		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			    ,type:'string'},
			{name: 'CONTROL_STATUS'	  		,text: '<t:message code="system.label.product.processstatus" default="진행상태"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'			,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			    ,type:'string'},
			{name: 'UPDATE_DB_TIME'	  		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			    ,type:'uniDate'}
		]
	});
		
	var detailStore = Unilite.createStore('pmp203ukrvDetailStore', {
		model: 'pmp203ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {	
// var paramMaster= [];
// var app = Ext.getCmp('bpr100ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{										
					config = {
// params: [paramMaster],
							success: function(batch, option) {								
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
// panelResult.setActiveRecord(record);
				}	
			}
	});

    var detailGrid = Unilite.createGrid('pmp203ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
       		//useGroupSummary: true,
			useContextMenu: true
        },
    	store: detailStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],    
        columns: [        		
			{dataIndex: 'WKORD_STATUS'		 	, width: 100 , hidden: true}, 							
			{dataIndex: 'WKORD_STATUS_NM'	 	, width: 40}, 							
			{dataIndex: 'ITEM_CODE'				, width: 86,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
            	}
            }, 		
			{dataIndex: 'ITEM_NAME'				, width: 133},						
			{dataIndex: 'SPEC'				 	, width: 86},
			{dataIndex: 'STOCK_UNIT'		 	, width: 53}, 							
			{dataIndex: 'PATH_CODE'			 	, width: 66  , hidden: true}, 							
			{dataIndex: 'PATH_NAME'			  	, width: 80  , hidden: isAutoPath}, 								
			{dataIndex: 'OUTSTOCK_REQ_DATE'		, width: 100}, 												
			{dataIndex: 'OUTSTOCK_REQ_Q'	 	, width: 100 , summaryType: 'sum'},
			{dataIndex: 'OUTSTOCK_Q'		 	, width: 100 , summaryType: 'sum'}, 							
			{dataIndex: 'ALLOCK_Q'			 	, width: 100 , summaryType: 'sum'}, 							
			{dataIndex: 'MINI_PACK_Q'		  	, width: 100 , summaryType: 'sum'}, 								
			{dataIndex: 'OUTSTOCK_OVER_Q'		, width: 100 , summaryType: 'sum'}, 												
			{dataIndex: 'REF_WKORD_NUM'		 	, width: 120},
			{dataIndex: 'PRODT_WKORD_DATE'	 	, width: 100}, 							
			{dataIndex: 'PITEM_CODE'		 	, width: 100}, 							
			{dataIndex: 'PITEM_NAME'		  	, width: 166}, 								
			{dataIndex: 'PSPEC'					, width: 86}, 												
			{dataIndex: 'PSTOCK_UNIT'		 	, width: 53},
			{dataIndex: 'OUTSTOCK_NUM'		 	, width: 120}, 							
			{dataIndex: 'PROJECT_NO'		 	, width: 120}, 							
//			{dataIndex: 'PJT_CODE'			  	, width: 120}, 								
			{dataIndex: 'LOT_NO'				, width: 100}, 												
			{dataIndex: 'REMARK'			 	, width: 100},
			{dataIndex: 'COMP_CODE'			 	, width: 66  , hidden: true}, 							
			{dataIndex: 'DIV_CODE'			 	, width: 66  , hidden: true}, 							
			{dataIndex: 'WORK_SHOP_CODE'	  	, width: 66  , hidden: true}, 								
			{dataIndex: 'CONTROL_STATUS'		, width: 66  , hidden: true}, 												
			{dataIndex: 'UPDATE_DB_USER'	 	, width: 66  , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	 	, width: 66  , hidden: true}
		],
		listeners: {	
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if(e.record.data.WKORD_STATUS == '8' || e.record.data.WKORD_STATUS == '9'){
						if (UniUtils.indexOf(e.field, 
											['WKORD_STATUS','WKORD_STATUS_NM','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT',
											 'PATH_CODE','PATH_NAME','OUTSTOCK_REQ_DATE','OUTSTOCK_REQ_Q','OUTSTOCK_Q','ALLOCK_Q','MINI_PACK_Q',
											 'OUTSTOCK_OVER_Q','REF_WKORD_NUM','PRODT_WKORD_DATE','PITEM_CODE','PITEM_NAME','PSPEC','PSTOCK_UNIT',
											 'OUTSTOCK_NUM','PROJECT_NO','PJT_CODE','LOT_NO','REMARK','COMP_CODE','DIV_CODE','WORK_SHOP_CODE',
											 'CONTROL_STATUS','UPDATE_DB_USER','UPDATE_DB_TIME']) )
							return false;
					}
				}if(!e.record.phantom){
					if(e.record.data.WKORD_STATUS == '2'){
						if(UniUtils.indexOf(e.field,
											['WKORD_STATUS','WKORD_STATUS_NM','SPEC','STOCK_UNIT','ITEM_CODE','ITEM_NAME',
											 'PATH_CODE','PATH_NAME','OUTSTOCK_Q','ALLOCK_Q','MINI_PACK_Q',
											 'OUTSTOCK_OVER_Q','REF_WKORD_NUM','PRODT_WKORD_DATE','PITEM_CODE','PITEM_NAME','PSPEC','PSTOCK_UNIT',
											 'OUTSTOCK_NUM','PROJECT_NO','PJT_CODE','LOT_NO','COMP_CODE','DIV_CODE','WORK_SHOP_CODE',
											 'CONTROL_STATUS','UPDATE_DB_USER','UPDATE_DB_TIME']) )
							return false;
						}	
				}
			}
          }
    });
   
	Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		detailGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],	
		id: 'pmp203ukrvApp',
		
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset',  'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var param= panelSearch.getValues();
			detailStore.loadStoreRecords();	
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			detailGrid.reset();
			this.fnInitBinding();
			panelResult.getField('DIV_CODE').setReadOnly( false );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			panelSearch.getField('DIV_CODE').setReadOnly( false );
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly( false );	
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore(); 
		},
		onDeleteDataButtonDown: function() {
			var record = detailGrid.getSelectedRecord();
			var param= {
				'DIV_CODE': record.get('DIV_CODE'),
				'ITEM_CODE': record.get('ITEM_CODE'),
				'OUTSTOCK_NUM': record.get('OUTSTOCK_NUM'),
				'REF_WKORD_NUM': record.get('REF_WKORD_NUM'),
				'PATH_CODE': record.get('PATH_CODE')
			}
			pmp203ukrvService.selectDelete(param, function(provider, response) {           
				if(record.get('CONTROL_STATUS') == '8') {
					Unilite.messageBox('<t:message code="system.message.product.message027" default="이미 마감된 자료 입니다."/>');
				} else if(record.get('OUTSTOCK_NUM') == '' || record.get('OUTSTOCK_NUM') == '*') {
					Unilite.messageBox('<t:message code="system.message.product.message028" default="출고요청정보가 없으므로 삭제할 수 없습니다."/>');
				} else if(record.get('OUTSTOCK_Q') - record.get('CANCEL_Q') > '0') {
					Unilite.messageBox('<t:message code="system.message.product.message029" default="출고나 반품이 진행된 출고요청은 삭제가 불가능합니다."/>');
				} else {
					detailGrid.deleteSelectedRow();
				}
			});
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();
			
			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('pmp203ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_WKORD_DATE_FR',UniDate.get('startOfMonth'));
  			panelSearch.setValue('PRODT_WKORD_DATE_TO',new Date());
        	
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
		}
	});
		
    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUTSTOCK_REQ_Q" : //출고요청량
					if(newValue < 1 ){
//						양수만 입력 가능합니다.
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
					if(Ext.isNumeric(record.get('OUTSTOCK_REQ_Q')))
					{
						var outstockReqQ = record.get('OUTSTOCK_REQ_Q');
						var outStockQ = record.get('OUTSTOCK_Q');

						if(outstockReqQ < outStockQ ){
							rv='<t:message code="system.message.product.message055" default="출고요청량이 출고량보다 작습니다."/>';
							//출고요청량이 출고량보다 작습니다.
						}
						break;
					}
					
				case "OUTSTOCK_REQ_DATE" :// 출고요청일
				
				case "ITEM_CODE" : // 품목코드
					if(record.get('ITEM_CODE')   == ''){
						record.get('ITEM_NAME')  == '';
						record.get('SPEC') 		 == '';
						record.get('STOCK_UNIT') == '';
					}
				
				case "ITEM_NAME" : // 품목명
					if(record.get('ITEM_NAME')   == ''){
						record.get('ITEM_CODE')  == '';
						record.get('SPEC') 		 == '';
						record.get('STOCK_UNIT') == '';
					}		
			}
			return rv;
		}
	}); // validator
}
</script>
