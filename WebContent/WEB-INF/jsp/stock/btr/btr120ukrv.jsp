<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr120ukrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="btr120ukrv"/> 						<!-- 사업장 -->  
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
<t:ExtComboStore comboType="AU" comboCode="B024" /> 			<!--담당자-->
<t:ExtComboStore comboType="AU" comboCode="B013" /> 			<!--단위-->
<t:ExtComboStore comboType="AU" comboCode="B021" /> 			<!--양불구분-->
<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!--품목계정-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" >
	
var SearchInfoWindow; // 검색창
var outDivCode = UserInfo.divCode;
var MoveReleaseWindow; // 이동출고 참조
var gsWhCode = '';		//창고코드

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	// 입고내역 셋팅(메인)
	gsInvstatus: 		'${gsInvstatus}',
	gsMoneyUnit: 		'${gsMoneyUnit}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',	
	gsAutotype:			'${gsAutotype}'
};
	
//var output =''; 	// 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	var Autotype = true;	
	if(BsaCodeInfo.gsAutotype =='N')	{
		Autotype = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'btr120ukrvService.selectMaster',
			update: 'btr120ukrvService.updateDetail',
			create: 'btr120ukrvService.insertDetail',
			destroy: 'btr120ukrvService.deleteDetail',
			syncAll: 'btr120ukrvService.saveAll'
		}
	});
	
	var masterForm = Unilite.createSearchPanel('btr120ukrvMasterForm',{		// 메인
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>', 	
			itemId: 'search_panel1',
       		layout: {type: 'uniTable', columns: 1},
       		defaultType: 'uniTextfield',
	    	items: [{
        		fieldLabel: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
        		name: 'DIV_CODE', 
    			value: UserInfo.divCode,
        		xtype: 'uniCombobox', 
        		comboType: 'BOR120',
				holdable: 'hold',
				child:'WH_CODE',
        		allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = panelResult.getField('INOUT_PRSN');	
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
        	Unilite.popup('DEPT', { 
			   		fieldLabel: '<t:message code="system.label.inventory.department" default="부서"/>', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
			    	allowBlank: false,
			    	holdable: 'hold',
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
			       				panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
			       				gsWhCode = records[0]['WH_CODE'];
								var whStore = masterForm.getField('WH_CODE').getStore();							
								console.log("whStore : ",whStore);							
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:masterForm.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								masterForm.getField('WH_CODE').setValue(records[0]['WH_CODE']);
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
			        		panelResult.setValue('DEPT_CODE', '');
			        		panelResult.setValue('DEPT_NAME', '');
			     		},
			     		applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
		    		}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',	
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
    			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_PRSN', newValue);
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
					alert(labelText+Msg.sMB083);
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
	}); //End of var masterForm = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
        		fieldLabel: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
        		name: 'DIV_CODE', 
    			value: UserInfo.divCode,
        		xtype: 'uniCombobox', 
        		comboType: 'BOR120',
				holdable: 'hold',
				child:'WH_CODE',
        		allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//						var field = masterForm.getField('INOUT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
        	},
				Unilite.popup('DEPT', { 
		   		fieldLabel: '<t:message code="system.label.inventory.department" default="부서"/>', 
		   		valueFieldName: 'DEPT_CODE',
		        textFieldName: 'DEPT_NAME',
		    	allowBlank: false,
		    	holdable: 'hold',
		    	listeners: {
		     		onSelected: {
		      			fn: function(records, type) {
		       				masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
		       				masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
		       				gsWhCode = records[0]['WH_CODE'];
							var whStore = panelResult.getField('WH_CODE').getStore();							
							console.log("whStore : ",whStore);							
							whStore.clearFilter(true);
							whStore.filter([
								 {property:'option', value:panelResult.getValue('DIV_CODE')}
								,{property:'value', value: records[0]['WH_CODE']}
							]);
							panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
		                },
		      			scope: this
		     		},
		     		onClear: function(type) {
		        		masterForm.setValue('DEPT_CODE', '');
		        		masterForm.setValue('DEPT_NAME', '');
		     		},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
		    	}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',	
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
    			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_PRSN', newValue);
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
					alert(labelText+Msg.sMB083);
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
		
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
			    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			    name:'DIV_CODE',
		        allowBlank: false,
			    xtype: 'uniCombobox',
			    comboType:'BOR120',
			    holdable: 'hold',
				child:'WH_CODE',
			    value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = orderNoSearch.getField('INOUT_PRSN');	
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..					
					}
				}
		   },
		   Unilite.popup('DEPT', { 
		   		fieldLabel: '<t:message code="system.label.inventory.department" default="부서"/>', 
		   		valueFieldName: 'DEPT_CODE',
		        textFieldName: 'DEPT_NAME',
		        allowBlank: false,
		    	valueFieldWidth: 50,
		    	textFieldWidth: 185,
		    	holdable: 'hold',
		    	listeners: {
		    		onSelected: {
						fn: function(records, type) {
							gsWhCode = records[0]['WH_CODE'];
								var whStore = orderNoSearch.getField('WH_CODE').getStore();							
								console.log("whStore : ",whStore);							
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:orderNoSearch.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								orderNoSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
	                	},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
					},
		    		applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
		    	}
		   }),{
 				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
 				name:'WH_CODE',
		        allowBlank: false,
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						/*onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},*/
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>', 
				name:'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}
		]
  	}); // createSearchForm
    
    var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//이동출고 참조
    	layout: {type : 'uniTable', columns : 2},
        items:[
        	{
			    fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
			    comboType:'BOR120',
			    allowBlank:false,
				child:'WH_CODE',
			    holdable: 'hold',
			    value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//							var field = otherOrderSearch.getField('INOUT_PRSN');
//							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
		   },
		   Unilite.popup('DEPT', { 
		   		fieldLabel: '<t:message code="system.label.inventory.department" default="부서"/>', 
		   		valueFieldName: 'DEPT_CODE',
		        textFieldName: 'DEPT_NAME',
		    	valueFieldWidth: 50,
		    	textFieldWidth: 185,
		    	allowBlank: false,
		    	holdable: 'hold',
		    	listeners: {
		    		onSelected: {
						fn: function(records, type) {
							gsWhCode = records[0]['WH_CODE'];
								var whStore = otherOrderSearch.getField('WH_CODE').getStore();							
								console.log("whStore : ",whStore);							
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:otherOrderSearch.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								otherOrderSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
	                	},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
					},
		    		applyextparam: function(popup) {							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': otherOrderSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
		    	}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name:'WH_CODE',
		    	allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>', 
				name:'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issueperiod" default="출고기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name:'IN_WH_CODE',
				xtype: 'uniTextfield',
				hidden:true
			}
		]
    });
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('btr120ukrvModel', {		// 메인
	    fields: [  	  
	    	{name: 'INOUT_NUM'				,text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>'					,type: 'string'},
	    	{name: 'INOUT_SEQ'				,text: '<t:message code="system.label.inventory.seq" default="순번"/>'						,type: 'int', allowBlank: false},
	    	{name: 'INOUT_TYPE'				,text: '<t:message code="system.label.inventory.trantype1" default="수불타입"/>'					,type: 'string'},
	    	{name: 'INOUT_METH'				,text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>'					,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'					,type: 'string'},
	    	{name: 'DEPT_CODE'				,text: '<t:message code="system.label.inventory.department" default="부서"/>'					,type: 'string'},
	    	{name: 'DEPT_NAME'				,text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'					    ,type: 'string'},
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'					,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'					,type: 'string'},
	    	{name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'						,type: 'string'},
	    	{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'					,type: 'string', displayField: 'value'},
	    	{name: 'DIV_CODE'				,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'					,type: 'string'},
	    	{name: 'WH_CODE'				,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'					,type: 'string'},
	    	{name: 'WH_CELL_CODE'			,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'				,type: 'string'},
	    	{name: 'INOUT_DATE'				,text: '<t:message code="system.label.inventory.transdate" default="수불일"/>'					    ,type: 'uniDate'},
	    	{name: 'INOUT_CODE_TYPE'		,text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'					,type: 'string'},
	    	{name: 'TO_DIV_CODE'			,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'					,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
	    	{name: 'INOUT_CODE'				,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'					,type: 'string'},
	    	{name: 'INOUT_NAME'				,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'					,type: 'string'},
	    	{name: 'INOUT_CODE_DETAIL'		,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'				,type: 'string'},
	    	{name: 'INOUT_NAME_DETAIL'		,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'				,type: 'string'},
	    	{name: 'ITEM_STATUS'			,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'					,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
	    	{name: 'INOUT_Q'				,text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>'					,type: 'uniQty', allowBlank: false},
	    	{name: 'INOUT_FOR_P'			,text: '<t:message code="system.label.inventory.foreigntranprice" default="외화수불단가"/>'				,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'			,text: '<t:message code="system.label.inventory.foreigntranamount" default="외화수불금액"/>'				,type: 'uniFC'},
	    	{name: 'EXCHG_RATE_O'			,text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'						,type: 'string'},
	    	{name: 'INOUT_P'				,text: '<t:message code="system.label.inventory.tranprice" default="수불단가"/>'					,type: 'uniUnitPrice'},
	    	{name: 'INOUT_I'				,text: '<t:message code="system.label.inventory.tranamount" default="수불금액"/>'					,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'					,type: 'string'},
	    	{name: 'INOUT_PRSN'				,text: '<t:message code="system.label.inventory.charger" default="담당자"/>'					    ,type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'BASIS_NUM'				,text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'					,type: 'string', allowBlank: false},
	    	{name: 'BASIS_SEQ'				,text: '<t:message code="system.label.inventory.basisseq" default="근거순번"/>'					,type: 'string'},
	    	{name: 'LOT_NO'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'					    ,type: 'string'},
	    	{name: 'REMARK'					,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					    ,type: 'string'},
	    	{name: 'PROJECT_NO'				,text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'				,type: 'string'},
	    	{name: 'UPDATE_DB_USER'			,text: '<t:message code="system.label.inventory.writer" default="작성자"/>'					    ,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			,text: '<t:message code="system.label.inventory.writtendate" default="작성일"/>'					,type: 'string'},
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'					,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'					,type: 'string', comboType: 'AU', comboCode: 'B020'},
		    {name: 'PURCHASE_CUSTOM_CODE'	,text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'					,type: 'string'},
		    {name: 'PURCHASE_TYPE'			,text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'					,type: 'string'},
		    {name: 'SALES_TYPE'				,text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'					,type: 'string'},
		    {name: 'PURCHASE_RATE'			,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'					    ,type: 'string'},
		    {name: 'PURCHASE_P'				,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'					    ,type: 'uniUnitPrice'},
		    {name: 'SALE_P'					,text: '<t:message code="system.label.inventory.price" default="단가"/>'						,type: 'uniUnitPrice'}
		    
		]
	});
	
	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
	    fields: [
	    	{name: 'DEPT_CODE'				, text: '<t:message code="system.label.inventory.department" default="부서"/>'				, type: 'string'},
	    	{name: 'DEPT_NAME'				, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'				, type: 'string'},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'				, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				    , type: 'string'},
	    	{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				    , type: 'string'},
	    	{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'				    , type: 'string', displayField: 'value'},
	    	{name: 'INOUT_DATE'				, text: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>'				, type: 'uniDate'},
	    	{name: 'INOUT_Q'				, text: '<t:message code="system.label.inventory.qty" default="수량"/>'				    , type: 'uniQty'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'			, type: 'string'},
	    	{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'				, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'			, type: 'string'},
	    	{name: 'TO_DIV_CODE'			, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string'},
	    	{name: 'TO_DIV_NAME'			, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string'},
	    	{name: 'INOUT_CODE'				, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				, type: 'string'},
	    	{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			, type: 'string'},
	    	{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			    , type: 'string'},
	    	{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'INOUT_NUM'				, text: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>'				, type: 'string'}
		]
	});
	
	Unilite.defineModel('btr120ukrvOTHERModel', {	//이동출고 참조 
	    fields: [
	    	{name: 'DEPT_CODE'					, text: '<t:message code="system.label.inventory.department" default="부서"/>'				, type: 'string'},
	    	{name: 'DEPT_NAME'					, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'					, text: '<t:message code="system.label.inventory.item" default="품목"/>'    			, type: 'string'},
			{name: 'ITEM_NAME'					, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'    				, type: 'string'},
			{name: 'SPEC'						, text: '<t:message code="system.label.inventory.spec" default="규격"/>'    				, type: 'string'},
			{name: 'STOCK_UNIT'					, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'    			, type: 'string', displayField: 'value'},
			{name: 'INOUT_DATE'					, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'    			, type: 'uniDate'},
			{name: 'DIV_CODE'					, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'    		, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'WH_CODE'					, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'    		, type: 'string'},
			{name: 'WH_NAME'					, text: '<t:message code="system.label.inventory.issuewarehousename" default="출고창고명"/>'    			, type: 'string'},
			{name: 'WH_CELL_CODE'				, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'    	, type: 'string'},
			{name: 'WH_CELL_NAME'				, text: '<t:message code="system.label.inventory.issuewarehousecellname" default="출고창고Cell명"/>'    		, type: 'string'},
			{name: 'IN_ITEM_STATUS'				, text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'    			, type: 'string', comboType: 'AU', comboCode: 'B021'},
			{name: 'INOUT_Q'					, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'    			, type: 'uniQty'},
			{name: 'INOUT_NUM'					, text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'    			, type: 'string'},
			{name: 'INOUT_SEQ'					, text: '<t:message code="system.label.inventory.issueseq" default="출고순번"/>'    			, type: 'string'},
			{name: 'TO_DIV_CODE'				, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'    		, type: 'string'},
			{name: 'INOUT_CODE'					, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'    			, type: 'string'},
			{name: 'INOUT_CODE_DETAIL'			, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'    		, type: 'string'},
			{name: 'INOUT_P'					, text: '<t:message code="system.label.inventory.price" default="단가"/>'    				, type: 'uniUnitPrice'},
			{name: 'INOUT_I'					, text: '<t:message code="system.label.inventory.amount" default="금액"/>'    				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'					, text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'    			, type: 'string'},
			{name: 'INOUT_FOR_P'				, text: '<t:message code="system.label.inventory.foreigncurrencyunit" default="외화단가"/>'    			, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'				, text: '<t:message code="system.label.inventory.foreigncurrencyamount" default="외화금액"/>'    			, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'				, text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'    				, type: 'string'},
			{name: 'LOT_NO'						, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'    			, type: 'string'},
			{name: 'REMARK'						, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'    				, type: 'string'},
			{name: 'PROJECT_NO'					, text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'    		, type: 'string'},
			{name: 'ITEM_ACCOUNT'				, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'    			, type: 'string'},
		    {name: 'PURCHASE_CUSTOM_CODE'		, text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'			, type: 'string'},
		    {name: 'PURCHASE_TYPE'				, text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'				, type: 'string'},
		    {name: 'SALES_TYPE'					, text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'				, type: 'string'},
		    {name: 'PURCHASE_RATE'				, text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'				, type: 'string'},
		    {name: 'PURCHASE_P'					, text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				, type: 'uniUnitPrice'},
		    {name: 'SALE_P'						, text: '<t:message code="system.label.inventory.price" default="단가"/>'					, type: 'uniUnitPrice'}
		]
	});
			
	var directMasterStore1 = Unilite.createStore('btr120ukrvMasterStore1',{		// 메인
		model: 'btr120ukrvModel',
		uniOpt : {
            	isMaster: true,		// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable: true,	// 삭제 가능 여부 
	            useNavi : false		// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			var inoutNum = masterForm.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
                        masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
                        panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
                        var inoutNum = masterForm.getValue('INOUT_NUM');
                        Ext.each(list, function(record, index) {
                            if(record.data['INOUT_NUM'] != inoutNum) {
                                record.set('INOUT_NUM', inoutNum);
                            }
                        })
						
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('Btr120ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('Btr120ukrvMasterStore1',{
	
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
			model: 'orderNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read: 'btr120ukrvService.selectDetail'
                }
            },
            loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}	
			console.log(param);
			this.load({
				params : param
			});
		}
	});		// End of var directMasterStore1 = Unilite.createStore('Btr120ukrvMasterStore1',{
	
	var otherOrderStore = Unilite.createStore('btr120ukrvOtherOrderStore', {//이동출고 참조
			model: 'btr120ukrvOTHERModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read: 'btr120ukrvService.selectDetail2'                	
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts) {
            		if(successful)	{
            		   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
            		   var refRecords = new Array();
            		   if(masterRecords.items.length > 0) {
            		   		console.log("store.items :", store.items);
            		   		console.log("records", records);
            		   		Ext.each(records, 
	            		   		function(item, i) {           			   								
			   						Ext.each(masterRecords.items, function(record, i) {
			   							console.log("record :", record);
			   						
			   								if((record.data['BASIS_NUM'] == item.data['INOUT_NUM']) 
			   								&& (record.data['BASIS_SEQ'] == item.data['INOUT_SEQ'])
			   								){
			   									refRecords.push(item);
			   								}
			   							}
			   						);		
	            			   	}
	            			);
	            			store.remove(refRecords);
            			}
            		}
            	}
            },
            loadStoreRecords : function()	{
				var param= otherOrderSearch.getValues();	
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(otherOrderSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}	
				console.log( param );
				this.load({
					params : param
				});
			}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('btr120ukrvGrid', {		// 메인
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt: {
		 	expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.inventory.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'MoveReleaseBtn',
					text: '<t:message code="system.label.inventory.movingissuerefer" default="이동출고참조"/>',
					handler: function() {
						openMoveReleaseWindow();
					}
				}]
			})
		}],		
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],    	
    	store: directMasterStore1,
        columns: [        			
			{dataIndex: 'INOUT_NUM'				, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_SEQ'				, width: 50}, 
			{dataIndex: 'INOUT_TYPE'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_METH'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 100, hidden: true}, 
			{dataIndex: 'ITEM_CODE'                      , width: 120,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                                    textFieldName: 'ITEM_CODE',
                                    DBtextFieldName: 'ITEM_CODE',
                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                                                }
                                        }
                     })
            },
            {dataIndex: 'ITEM_NAME'                     , width: 200, 
                editor: Unilite.popup('DIV_PUMOK_G', {
                                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
                                    listeners: {'onSelected': {
                                                        fn: function(records, type) {
                                                                console.log('records : ', records);
                                                                Ext.each(records, function(record,i) {                                                                     
                                                                                    if(i==0) {
                                                                                                masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                                                                            } else {
                                                                                                UniAppManager.app.onNewDataButtonDown();
                                                                                                masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                                                                            }
                                                                }); 
                                                        },
                                                        scope: this
                                                },
                                                'onClear': function(type) {
                                                    masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                                },
                                                applyextparam: function(popup){                         
                                                    popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                                                }
                                        }
                    })
            }, 
			{dataIndex: 'DEPT_CODE'				, width: 120, hidden: true}, 
			{dataIndex: 'DEPT_NAME'				, width: 120, hidden: true},
			{dataIndex: 'SPEC'					, width: 120}, 
			{dataIndex: 'STOCK_UNIT'			, width: 100, displayField: 'value'}, 
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true}, 
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true}, 
			{dataIndex: 'WH_CELL_CODE'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_DATE'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 100, hidden: true}, 
			{dataIndex: 'TO_DIV_CODE'			, width: 100}, 
			{dataIndex: 'INOUT_CODE'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_NAME'			, width: 100}, 
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_NAME_DETAIL'		, width: 93, hidden: true}, 
			{dataIndex: 'ITEM_STATUS'			, width: 100}, 
			{dataIndex: 'INOUT_Q'				, width: 100}, 
			{dataIndex: 'INOUT_FOR_P'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_FOR_O'			, width: 100, hidden: true}, 
			{dataIndex: 'EXCHG_RATE_O'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_P'				, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_I'				, width: 100, hidden: true}, 
			{dataIndex: 'MONEY_UNIT'			, width: 100, hidden: true}, 
			{dataIndex: 'INOUT_PRSN'			, width: 100}, 
			{dataIndex: 'BASIS_NUM'				, width: 120}, 
			{dataIndex: 'BASIS_SEQ'				, width: 100, hidden: true}, 
			{dataIndex: 'LOT_NO'				, width: 120,
				editor: Unilite.popup('LOTNO_G', {		
						textFieldName: 'LOTNO_CODE',
						DBtextFieldName: 'LOTNO_CODE',
						autoPopup: true,
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord;
									Ext.each(records, function(record,i) {
										if(i==0){
											rtnRecord = masterGrid.uniOpt.currentRecord
										}else{
											rtnRecord = masterGrid.getSelectedRecord()
										}
									}); 
								},
							scope: this
							},
							'onClear': function(type) {
								masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
							},
							applyextparam: function(popup){
								var record = masterGrid.getSelectedRecord();
								var divCode = masterForm.getValue('DIV_CODE');
								var itemCode = record.get('ITEM_CODE');
								var itemName = record.get('ITEM_NAME');
								var whCode = record.get('WH_CODE');
								popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
							}									
						}
				})
			}, 
			{dataIndex: 'REMARK'				, width: 66}, 
			{dataIndex: 'PROJECT_NO'			, width: 100}, 
			{dataIndex: 'UPDATE_DB_USER'		, width: 100, hidden: true}, 
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true}, 
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true}, 
			{dataIndex: 'ITEM_ACCOUNT'			, width: 100},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'			, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_TYPE'					, width: 100, hidden: true},		
			{dataIndex: 'SALES_TYPE'					, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_RATE'					, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_P'					, width: 100, hidden: true},		
			{dataIndex: 'SALE_P'						, width: 100, hidden: true}
		],	
		
		listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{	
					text: '<t:message code="system.label.inventory.iteminfo" default="품목정보"/>',   iconCls : '',
		        	handler: function(menuItem, event) {	
		        		var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};									
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
		        	}
		        },{	
		        	text: '<t:message code="system.label.inventory.custominfo" default="거래처정보"/>',   iconCls : '',
		            handler: function(menuItem, event) {				                		
						var params = {
							CUSTOM_CODE : masterForm.getValue('CUSTOM_CODE'),
							COMP_CODE : UserInfo.compCode
						}
						var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};									
						parent.openTab(rec, '/base/bcm100ukrv.do', params);
		            }
		        })
			},
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {					
				if(!UniAppManager.app.checkForNewDetail()) return false;		 
					var seq = directMasterStore1.max('INOUT_SEQ');
	            	if(!seq) seq = 1;
	            	else  seq += 1;
	          		record.INOUT_SEQ = seq;

	          		return true;
	        },
	        //contextMenu의 복사한 행 삽입 실행 후
	        afterPasteRecord: function(rowIndex, record) {
	        	masterForm.setAllFieldsReadOnly(true);
	        }
		},
		listeners: {	          	
			beforeedit: function( editor, e, eOpts ) {
				//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
				/*if(e.field=='REQ_PRSN') {
					record = this.getSelectedRecord();
					var outDivCode = record.get('OUT_DIV_CODE');
					var combo = e.column.field;
					
					if(e.rowIdx == 5) {								
						combo.store.clearFilter();
						combo.store.filter('refCode1', outDivCode);
					} else {
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', outDivCode);
					return true;
				}*/
				if(e.record.phantom == false) {
        		 	if(UniUtils.indexOf(e.field))
				   	{
						return false;
      				}
        		} else {
					if(e.field=='INOUT_PRSN') {
						return true;
					} else {
						return false;
					}
				}
			}
		},
	    setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('LOT_NO'				, '');
				
       		} else {
       			grdRecord.set('LOT_NO'				, record['LOT_NO']);
       		}
		},
		setEstiData: function(record) {						// 이동출고참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('INOUT_TYPE'			, '1');
			grdRecord.set('INOUT_METH'			, '3');
			grdRecord.set('INOUT_TYPE_DETAIL'	, '99');
			grdRecord.set('INOUT_CODE_TYPE'		, '2');
			grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
			grdRecord.set('DEPT_CODE'			, masterForm.getValue('DEPT_CODE'));
			grdRecord.set('DEPT_NAME'			, masterForm.getValue('DEPT_NAME'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);						
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, record['IN_ITEM_STATUS']);
			grdRecord.set('TO_DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('INOUT_CODE'			, record['WH_CODE']);
			grdRecord.set('INOUT_NAME'			, record['WH_NAME']);
			grdRecord.set('INOUT_CODE_DETAIL'	, record['WH_CELL_CODE']);
			grdRecord.set('INOUT_NAME_DETAIL'	, record['WH_CELL_NAME']);
			grdRecord.set('DIV_CODE'			, record['TO_DIV_CODE']);
			grdRecord.set('WH_CODE'				, record['INOUT_CODE']);
			grdRecord.set('WH_CELL_CODE'		, record['INOUT_CODE_DETAIL']);
			grdRecord.set('INOUT_Q'				, record['INOUT_Q']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_FOR_P'			, record['INOUT_FOR_P']);
			grdRecord.set('INOUT_FOR_O'			, record['INOUT_FOR_O']);
			grdRecord.set('INOUT_P'				, record['INOUT_P']);
			grdRecord.set('INOUT_I'				, record['INOUT_I']);			
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('INOUT_PRSN'			, record['INOUT_PRSN']);
			grdRecord.set('BASIS_NUM'			, record['INOUT_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('PURCHASE_CUSTOM_CODE', record['PURCHASE_CUSTOM_CODE']);
			grdRecord.set('PURCHASE_TYPE'		, record['PURCHASE_TYPE']);
			grdRecord.set('SALES_TYPE'			, record['SALES_TYPE']);
			grdRecord.set('PURCHASE_RATE'		, record['PURCHASE_RATE']);
			grdRecord.set('PURCHASE_P'			, record['PURCHASE_P']);
			grdRecord.set('SALE_P'				, record['SALE_P']);
		}		
    });	//End of   var masterGrid1 = Unilite.createGrid('btr120ukrvGrid1', {
    
    var orderNoMasterGrid = Unilite.createGrid('btr120ukrvOrderNoMasterGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',       
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
        columns:  [ 
        	{ dataIndex: 'DEPT_CODE'			   	,  width: 120}, 
			{ dataIndex: 'DEPT_NAME'			   	,  width: 133}, 
			{ dataIndex: 'ITEM_CODE'			   	,  width: 120}, 
			{ dataIndex: 'ITEM_NAME'			   	,  width: 133}, 
			{ dataIndex: 'SPEC'				   		,  width: 133}, 
			{ dataIndex: 'STOCK_UNIT'			   	,  width: 53, hidden: true, displayField: 'value'}, 
			{ dataIndex: 'INOUT_DATE'			   	,  width: 80}, 
			{ dataIndex: 'INOUT_Q'			   		,  width: 80}, 
			{ dataIndex: 'DIV_CODE'			   		,  width: 80, hidden: true}, 
			{ dataIndex: 'WH_CODE'			   		,  width: 86}, 
			{ dataIndex: 'WH_CELL_CODE'		   		,  width: 100, hidden: true}, 
			{ dataIndex: 'TO_DIV_CODE'		   		,  width: 86, hidden: true}, 
			{ dataIndex: 'TO_DIV_NAME'		   		,  width: 86}, 
			{ dataIndex: 'INOUT_CODE'				,  width: 80}, 
			{ dataIndex: 'INOUT_CODE_DETAIL'		,  width: 100, hidden: true}, 
			{ dataIndex: 'LOT_NO'					,  width: 106, hidden: true}, 
			{ dataIndex: 'INOUT_PRSN'				,  width: 53}, 
			{ dataIndex: 'INOUT_NUM'				,  width: 106}
        ],
        listeners: {	
       		onGridDblClick:function(grid, record, cellIndex, colName) {
  				orderNoMasterGrid.returnData(record);
		       	UniAppManager.app.onQueryButtonDown();
		       	SearchInfoWindow.hide();
          		//UniAppManager.setToolbarButtons('save', true);
  			}
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE')});
          	masterForm.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
          	masterForm.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
          	panelResult.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
          	panelResult.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
          	masterForm.setValues({'WH_CODE':record.get('WH_CODE')});
          	masterForm.setValues({'INOUT_DATE':record.get('INOUT_DATE')});
          	masterForm.setValues({'INOUT_NUM':record.get('INOUT_NUM')});
          	masterForm.setValues({'INOUT_PRSN':record.get('INOUT_PRSN')});
        }   
    });
    
    var otherOrderGrid = Unilite.createGrid('btr120ukrvOtherOrderGrid', {//이동출고 참조 
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
        columns: [  
        	{ dataIndex: 'DEPT_CODE'				,  width: 120},
			{ dataIndex: 'DEPT_NAME'				,  width: 133},
			{ dataIndex: 'ITEM_CODE'				,  width: 120},
			{ dataIndex: 'ITEM_NAME'				,  width: 133},
			{ dataIndex: 'SPEC'						,  width: 86},
			{ dataIndex: 'STOCK_UNIT'				,  width: 86, displayField: 'value'},
			{ dataIndex: 'INOUT_DATE'				,  width: 73},
			{ dataIndex: 'DIV_CODE'					,  width: 80},
			{ dataIndex: 'WH_CODE'					,  width: 66, hidden: true},
			{ dataIndex: 'WH_NAME'					,  width: 80},
			{ dataIndex: 'WH_CELL_CODE'				,  width: 66, hidden: true},
			{ dataIndex: 'WH_CELL_NAME'				,  width: 80, hidden: true},
			{ dataIndex: 'IN_ITEM_STATUS'			,  width: 86},
			{ dataIndex: 'INOUT_Q'					,  width: 100},
			{ dataIndex: 'INOUT_NUM'				,  width: 93},
			{ dataIndex: 'INOUT_SEQ'				,  width: 93},
			{ dataIndex: 'TO_DIV_CODE'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_CODE'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_CODE_DETAIL'		,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_P'					,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_I'					,  width: 100, hidden: true},
			{ dataIndex: 'MONEY_UNIT'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_FOR_P'				,  width: 100, hidden: true},
			{ dataIndex: 'INOUT_FOR_O'				,  width: 100, hidden: true},
			{ dataIndex: 'EXCHG_RATE_O'				,  width: 100, hidden: true},
			{ dataIndex: 'LOT_NO'					,  width: 80},
			{ dataIndex: 'REMARK'					,  width: 133},
			{ dataIndex: 'PROJECT_NO'				,  width: 133},
			{ dataIndex: 'ITEM_ACCOUNT'				,  width: 133, hidden: true},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'			, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_TYPE'					, width: 100, hidden: true},		
			{dataIndex: 'SALES_TYPE'					, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_RATE'					, width: 100, hidden: true},		
			{dataIndex: 'PURCHASE_P'					, width: 100, hidden: true},		
			{dataIndex: 'SALE_P'						, width: 100, hidden: true}
        ], 
        listeners: {	
          	onGridDblClick:function(grid, record, cellIndex, colName) {}
       	}, 
       	returnData: function()	{
       		var records = this.getSelectedRecords();
       		
			Ext.each(records, function(record,i) {	
		       	UniAppManager.app.onNewDataButtonDown();
		       	masterGrid.setEstiData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}
    });
    
    function openSearchInfoWindow() {	//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.inventory.inventorymovementreceiptnosearch" default="재고이동입고번호검색"/>',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [orderNoSearch, orderNoMasterGrid], 
                tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();	                							
                	},
                	beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
       	 			},
                	beforeshow: function( panel, eOpts )	{
                		field = orderNoSearch.getField('INOUT_PRSN');
                		field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
                		orderNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
                		orderNoSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
                		orderNoSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
                		orderNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));	
                		orderNoSearch.setValue('TO_INOUT_DATE',masterForm.getValue('INOUT_DATE'));
                		orderNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
                	}
                }		
			})
		}
		SearchInfoWindow.show();
    }
    
    function openMoveReleaseWindow() {    	//이동출고 참조	
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		/*otherOrderSearch.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
  		otherOrderSearch.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));*/
  		otherOrderSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth') );
  		otherOrderSearch.setValue('TO_INOUT_DATE', UniDate.get('today', masterForm.getValue('ORDER_DATE')));
  		otherOrderSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));      		
  		otherOrderStore.loadStoreRecords();
  		
		if(!MoveReleaseWindow) {
			MoveReleaseWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.inventory.movingissuerefer" default="이동출고참조"/>',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherOrderSearch, otherOrderGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.inventory.receiptapply" default="입고적용"/>',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.inventory.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							otherOrderGrid.returnData();
							MoveReleaseWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							MoveReleaseWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {beforehide: function(me, eOpt)	
                	{
                		otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	},
                	beforeclose: function(panel, eOpts)
                	{
						otherOrderSearch.clearForm();
                		otherOrderGrid.reset();
                	},
                	beforeshow: function (me, eOpts)	
                	{
                		field = otherOrderSearch.getField('INOUT_PRSN');
                		field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
        			 	otherOrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
                		/*otherOrderSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
                		otherOrderSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
                		otherOrderSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));*/	
                		otherOrderSearch.setValue('TO_INOUT_DATE',masterForm.getValue('INOUT_DATE'));
                		otherOrderSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
                		otherOrderSearch.setValue('IN_WH_CODE',masterForm.getValue('WH_CODE'));
        				otherOrderStore.loadStoreRecords();
        			 }
                }
			})
		}
		MoveReleaseWindow.show();
    }

    Unilite.Main ({
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
		id: 'btr120ukrvApp',
		fnInitBinding: function() {
			masterForm.getField('DIV_CODE').focus();
			//UniAppManager.setToolbarButtons(['reset', 'deleteAll', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			btr120ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		
		onQueryButtonDown: function()	{
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow() 
			} else {
				var param= masterForm.getValues();
				directMasterStore1.loadStoreRecords();
				if(masterForm.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}	
			}
			UniAppManager.setToolbarButtons('reset', true); 
		},
		
		onNewDataButtonDown: function()	{	// 행추가 버튼
			var inoutNum = masterForm.getValue('INOUT_NUM')
			var seq = directMasterStore1.max('INOUT_SEQ');
            if(!seq) seq = 1;
            else seq += 1;
            var r = {
				INOUT_NUM: inoutNum,
				INOUT_SEQ: seq
		    };
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			masterForm.setAllFieldsReadOnly(false);
		}, 

		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
			}
		},
		
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			masterForm.reset();
			panelResult.reset();
			orderNoSearch.reset();
			otherOrderSearch.reset();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			orderNoMasterGrid.reset();
			otherOrderGrid.reset();
			this.fnInitBinding();
			masterForm.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();
			
			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('btr120ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)	{
        		if(item['refCode1'] == subCode) {
        			fRecord = item['codeNo'];
        			return false;
        		}
        	});
        	return fRecord;
        },
        
		setDefault: function() {	// 화면 초기화
			var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			field = orderNoSearch.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			field = otherOrderSearch.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			
			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
			
			masterForm.setValue('DIV_CODE', UserInfo.divCode);			
			masterForm.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
        	panelResult.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
        	orderNoSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	otherOrderSearch.setValue('DIV_CODE', UserInfo.divCode);
        	otherOrderSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        	masterForm.setValue('INOUT_DATE',UniDate.get('today')); 
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
		},
        	
		checkForNewDetail: function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			return masterForm.setAllFieldsReadOnly(true);
        },
        
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};

</script>