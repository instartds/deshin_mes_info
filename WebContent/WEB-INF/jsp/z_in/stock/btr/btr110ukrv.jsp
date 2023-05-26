<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr110ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="btr110ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!--담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011" /> <!--마감정보-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--양불구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var MoveRequestWindow; // 이동요청 참조
var gsWhCode = '';		//창고코드

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsInvstatus: 		'${gsInvstatus}',
	gsMoneyUnit: 		'${gsMoneyUnit}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}'
};

var outDivCode = UserInfo.divCode;

/*var output =''; 	// 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain() {
	var Autotype = true;	
	if(BsaCodeInfo.gsAutotype =='N')	{
		Autotype = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'btr110ukrvService.selectMaster',
			update: 'btr110ukrvService.updateDetail',
			create: 'btr110ukrvService.insertDetail',
			destroy: 'btr110ukrvService.deleteDetail',
			syncAll: 'btr110ukrvService.saveAll'
		}
	});
	
	var masterForm = Unilite.createSearchPanel('btr110ukrvMasterForm',{		// 메인
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
	        	fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
	        	name: 'DIV_CODE', 
    			value: UserInfo.divCode,
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
				child:'WH_CODE',
				holdable: 'hold',
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
 				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
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
 				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
 				name:'INOUT_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_CODE', newValue);
					}
				}
 			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
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
				fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
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
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>',
				name:'WH_CELL_CODE',
				xtype: 'hiddenfield', 
				holdable: 'hold',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CELL_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.currency" default="화폐"/>', 
				name:'MONEY_UNIT', 
				xtype: 'hiddenfield', 
				comboType: 'AU', 
				comboCode: 'B004', 
				displayField: 'value',
				holdable: 'hold',
				allowBlank:false,
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
	        	name: 'DIV_CODE', 
    			value: UserInfo.divCode,
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120', 
				value: '01',
				child:'WH_CODE',
				holdable: 'hold',
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
 				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
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
 				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
 				name:'INOUT_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_CODE', newValue);
					}
				}
 			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
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
				fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
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
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>',
				name:'WH_CELL_CODE',
				xtype: 'hiddenfield', 
				holdable: 'hold',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('WH_CELL_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.currency" default="화폐"/>', 
				name:'MONEY_UNIT', 
				xtype: 'hiddenfield', 
				comboType: 'AU', 
				comboCode: 'B004', 
				displayField: 'value',
				holdable: 'hold',
				allowBlank:false,
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('MONEY_UNIT', newValue);
					}
				}
			}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        /*if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else*/ {
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
	
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
		    	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>'  ,
		    	name: 'DIV_CODE',
		    	xtype:'uniCombobox',
				child:'WH_CODE',
		    	comboType:'BOR120',
//		    	value:UserInfo.divCode,
		    	allowBlank:false,
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
 				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
 				name:'WH_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
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
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
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
		],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        /*if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else*/ {
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
    
    var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//이동요청 참조
        	layout :  {type : 'uniTable', columns : 2},
            items :[
            	{
	        		fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
	        		name: 'DIV_CODE', 
	        		xtype: 'uniCombobox', 
					allowBlank: false,
	        		comboType: 'BOR120',
					child:'WH_CODE',
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
			    	listeners: {
			    		onSelected: {
							fn: function(records, type) {
								gsWhCode = records[0]['WH_CODE'];
									var whStore = otherOrderSearch.getField('WH_CODE').getStore();							
									console.log("whStore : ",whStore);							
									whStore.clearFilter(true);
									whStore.filter([
										 {property:'option', value:otherOrderSearch.getValue('DIV_CODE')},
										 {property:'value', value: records[0]['WH_CODE']}
									]);
									otherOrderSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
								popup.setExtParam({'DIV_CODE': otherOrderSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
		   		}),{
 					fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
 					name:'WH_CODE',
 					xtype: 'uniCombobox',
					allowBlank: false,
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
					fieldLabel: '<t:message code="system.label.inventory.issuerequestdate" default="출고희망일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					width: 350,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				}
			],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        /*if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else*/ {
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
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('btr110ukrvModel', {	// 메인
	    fields: [  	  
	    	{name: 'INOUT_NUM'							,text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>'     				,type: 'string'},
		    {name: 'INOUT_SEQ'							,text: '<t:message code="system.label.inventory.seq" default="순번"/>'     					,type: 'int', allowBlank: false},
		    {name: 'INOUT_TYPE'							,text: '<t:message code="system.label.inventory.trantype1" default="수불타입"/>'     				,type: 'string'},
		    {name: 'INOUT_METH'							,text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>'     				,type: 'string'},
		    {name: 'INOUT_TYPE_DETAIL'					,text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'     				,type: 'string'},
		    {name: 'INOUT_CODE_TYPE'					,text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'    				,type: 'string'},
		    {name: 'IN_ITEM_STATUS'						,text: '<t:message code="system.label.inventory.receiptgooddefect" default="입고양불구분"/>'   			,type: 'string'},
		    {name: 'BASIS_NUM'							,text: '<t:message code="system.label.inventory.basisno" default="근거번호"/>'     				,type: 'string'},
		    {name: 'BASIS_SEQ'							,text: '<t:message code="system.label.inventory.basisseq" default="근거순번"/>'     				,type: 'int'},
		    {name: 'ORDER_NUM'							,text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>'     				,type: 'string'},
		    {name: 'ORDER_SEQ'							,text: '<t:message code="system.label.inventory.requestseq" default="요청순번"/>'     				,type: 'int'},
		    {name: 'DIV_CODE'							,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'    				,type: 'string'},
		    {name: 'WH_CODE'							,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'     				,type: 'string'},
		    {name: 'WH_CELL_CODE'						,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>' 				,type: 'string'},
		    {name: 'INOUT_DATE'							,text: '<t:message code="system.label.inventory.transdate" default="수불일"/>'      				,type: 'uniDate'},
		    {name: 'ORIGIN_Q'							,text: '<t:message code="system.label.inventory.existinginoutqty" default="기존수불량"/>'    				,type: 'uniQty'},
		    {name: 'INOUT_FOR_P'						,text: '<t:message code="system.label.inventory.tranprice" default="수불단가"/>'     				,type: 'uniUnitPrice'},
		    {name: 'INOUT_FOR_O'						,text: '<t:message code="system.label.inventory.tranamount" default="수불금액"/>'     				,type: 'uniPrice'},
		    {name: 'EXCHG_RATE_O'						,text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'       				,type: 'string'},
		    {name: 'MONEY_UNIT'							,text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'     				,type: 'string'},
		    {name: 'TO_DIV_CODE'						,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'    				,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
		    {name: 'INOUT_CODE'							,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'     				,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
		    {name: 'INOUT_NAME'							,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'     				,type: 'string',store: Ext.data.StoreManager.lookup('whList')},
		    {name: 'INOUT_CODE_DETAIL'					,text: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>' 				,type: 'string'},
		    {name: 'INOUT_NAME_DETAIL'					,text: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>' 				,type: 'string'},
	    	{name: 'DEPT_CODE'							,text: '<t:message code="system.label.inventory.department" default="부서"/>'					,type: 'string'},
	    	{name: 'DEPT_NAME'							,text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'						,type: 'string'},
		    {name: 'ITEM_CODE'							,text: '<t:message code="system.label.inventory.item" default="품목"/>'     				,type: 'string', allowBlank: false},
		    {name: 'ITEM_NAME'							,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'      				,type: 'string'},
		    {name: 'SPEC'								,text: '<t:message code="system.label.inventory.spec" default="규격"/>'     					,type: 'string'},
		    {name: 'STOCK_UNIT'							,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'     				,type: 'string', displayField: 'value'},
		    {name: 'ITEM_STATUS'						,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'     				,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
		    {name: 'INOUT_Q'							,text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'      				,type: 'uniQty', allowBlank: false},
		    {name: 'GOOD_STOCK_Q'						,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'    				,type: 'uniQty'},
		    {name: 'BAD_STOCK_Q'						,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'    				,type: 'uniQty'},
		    {name: 'INOUT_PRSN'							,text: '<t:message code="system.label.inventory.trancharge" default="수불담당"/>'     				,type: 'string',comboType:'AU', comboCode:'B024'},
		    {name: 'LOT_NO'								,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'   					,type: 'string'},
		    {name: 'REMARK'								,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'       				,type: 'string'},
		    {name: 'PROJECT_NO'							,text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'     			,type: 'string'},
		    {name: 'UPDATE_DB_USER'						,text: 'UPDATE_DB_USER'				,type: 'string'},
		    {name: 'UPDATE_DB_TIME'						,text: 'UPDATE_DB_TIME'    			,type: 'string'},
		    {name: 'COMP_CODE'							,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'					,type: 'string'},
		    {name: 'ITEM_ACCOUNT'						,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'          			,type: 'string'},
		    {name: 'PURCHASE_CUSTOM_CODE'				,text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'					,type: 'string'},
		    {name: 'PURCHASE_TYPE'						,text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'					,type: 'string'},
		    {name: 'SALES_TYPE'							,text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'					,type: 'string'},
		    {name: 'PURCHASE_RATE'						,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'						,type: 'uniPercent'},
		    {name: 'PURCHASE_P'							,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'						,type: 'uniUnitPrice'},
		    {name: 'SALE_P'								,text: '<t:message code="system.label.inventory.price" default="단가"/>'						,type: 'uniUnitPrice'}
		    
		]
	}); //End of Unilite.defineModel('btr110ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
	    fields: [
	    	{name: 'DEPT_CODE'				, text: '<t:message code="system.label.inventory.department" default="부서"/>'			, type: 'string'},
	    	{name: 'DEPT_NAME'				, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'			, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
	    	{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
	    	{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'				, type: 'string', displayField: 'value'},
	    	{name: 'INOUT_DATE'				, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'			, type: 'uniDate'},
	    	{name: 'INOUT_Q'				, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'			, type: 'uniQty'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'		, type: 'string'},
	    	{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'		, type: 'string'},
	    	{name: 'TO_DIV_CODE'			, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'		, type: 'string', comboType: 'BOR120'},
	    	{name: 'INOUT_CODE'				, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
	    	{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'		, type: 'string'},
	    	{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			, type: 'string'},
	    	{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'			, type: 'string',comboType:'AU', comboCode:'B024'},
	    	{name: 'INOUT_NUM'				, text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'			, type: 'string'}
		]
	});
	
	Unilite.defineModel('btr110ukrvOTHERModel', {	//이동요청 참조 
	    fields: [
			{name: 'DIV_CODE'						, text: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>'    			, type: 'string', comboType: 'BOR120'},
			{name: 'WH_CODE'						, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>'    			, type: 'string'},
			{name: 'WH_NAME'						, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>'    			, type: 'string'},
			{name: 'WH_CELL_CODE'					, text: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>'   	, type: 'string'},
			{name: 'WH_CELL_NAME'					, text: '<t:message code="system.label.inventory.receiptwarehousecellname" default="받을창고Cell명"/>' 	, type: 'string'},
			{name: 'REQSTOCK_NUM'					, text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>'    					, type: 'string'},
			{name: 'REQSTOCK_SEQ'					, text: '<t:message code="system.label.inventory.seq" default="순번"/>'    				    		, type: 'string'},
			{name: 'DEPT_CODE'						, text: '<t:message code="system.label.inventory.department" default="부서"/>'						, type: 'string'},
	    	{name: 'DEPT_NAME'						, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'					, type: 'string'},
			{name: 'ITEM_CODE'						, text: '<t:message code="system.label.inventory.item" default="품목"/>'    							, type: 'string'},
			{name: 'ITEM_NAME'						, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'    					, type: 'string'},
			{name: 'SPEC'							, text: '<t:message code="system.label.inventory.spec" default="규격"/>'    				    		, type: 'string'},
			{name: 'STOCK_UNIT'						, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'    				, type: 'string', displayField: 'value'},
			{name: 'REQ_PRSN'						, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'    						, type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'REQSTOCK_Q'						, text: '<t:message code="system.label.inventory.requestqty" default="요청량"/>'    					, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'						, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'    					, type: 'uniQty'},
			{name: 'NOTOUTSTOCK_Q'					, text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>'    				, type: 'uniQty'},
			{name: 'OUTSTOCK_DATE'					, text: '<t:message code="system.label.inventory.issuerequestdate" default="출고희망일"/>'    			, type: 'uniDate'},
			{name: 'GOOD_STOCK_Q'					, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'    				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'					, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'    		, type: 'uniQty'},
			{name: 'OUT_DIV_CODE'					, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'    				, type: 'string'},
			{name: 'OUT_WH_CODE'					, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'    				, type: 'string'},
			{name: 'OUT_WH_CELL_CODE'				, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'    		, type: 'string'},
			{name: 'LOT_NO'							, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'    			    		, type: 'string'},
			{name: 'REMARK'							, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'    				    	, type: 'string'},
			{name: 'ITEM_ACCOUNT'					, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'					, type: 'string'}
		]
	});
	
	var directMasterStore1 = Unilite.createStore('Btr110ukrvMasterStore1',{		// 메인
		model: 'btr110ukrvModel',
		uniOpt : {
            	isMaster: true,		// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable: true,	// 삭제 가능 여부 
	            useNavi : false,	// prev | next 버튼 사용
				allDeletable: true	// 전체 삭제 가능 여부		// prev | next 버튼 사용
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
						var reqstockNum = masterForm.getValue('INOUT_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['INOUT_NUM'] != inoutNum) {
								record.set('INOUT_NUM', inoutNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('Btr110ukrvMasterStore1',{
	
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
               	read: 'btr110ukrvService.selectDetail'
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
	});		// End of var directMasterStore1 = Unilite.createStore('Btr110ukrvMasterStore1',{
	
	var otherOrderStore = Unilite.createStore('btr110ukrvOtherOrderStore', {//이동요청 참조
			model: 'btr110ukrvOTHERModel',
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
                	read: 'btr110ukrvService.selectDetail2'               	
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
			   						});		
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
    
    var masterGrid = Unilite.createGrid('btr110ukrvGrid', {		// 메인
    	// for tab    	
        layout : 'fit',
        region:'center',
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
					itemId: 'MoveRequestBtn',
					text: '<t:message code="system.label.inventory.movingrequestrefer" default="이동요청참조"/>',
					handler: function() {
						openMoveRequestWindow();
					}
				}]
			})
		}],
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        			
			{dataIndex: 'INOUT_NUM'				        , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_SEQ'				        , width: 40}, 
			{dataIndex: 'INOUT_TYPE'				    , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_METH'				    , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_TYPE_DETAIL'		        , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_CODE_TYPE'		        , width: 10, hidden: true}, 
			{dataIndex: 'IN_ITEM_STATUS'			    , width: 10, hidden: true }, 
			{dataIndex: 'BASIS_NUM'				        , width: 10, hidden: true }, 
			{dataIndex: 'BASIS_SEQ'				        , width: 10, hidden: true }, 
			{dataIndex: 'ORDER_NUM'				        , width: 10, hidden: true }, 
			{dataIndex: 'ORDER_SEQ'				        , width: 10, hidden: true }, 
			{dataIndex: 'DIV_CODE'				        , width: 10, hidden: true }, 
			{dataIndex: 'WH_CODE'				        , width: 10, hidden: true }, 
			{dataIndex: 'WH_CELL_CODE'			        , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_DATE'				    , width: 10, hidden: true }, 
			{dataIndex: 'ORIGIN_Q'				        , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_FOR_P'			        , width: 10, hidden: true }, 
			{dataIndex: 'INOUT_FOR_O'			        , width: 10, hidden: true }, 
			{dataIndex: 'EXCHG_RATE_O'			        , width: 10, hidden: true }, 
			{dataIndex: 'MONEY_UNIT'				    , width: 10, hidden: true }, 
			{dataIndex: 'TO_DIV_CODE'			        , width: 80 }, 
			{dataIndex: 'INOUT_CODE'				    , width: 100}, 
			{dataIndex: 'INOUT_NAME'				    , width: 80, hidden: true }, 
			{dataIndex: 'INOUT_CODE_DETAIL'		        , width: 80, hidden: true }, 
			{dataIndex: 'INOUT_NAME_DETAIL'		        , width: 80, hidden: true }, 
       		{dataIndex: 'DEPT_CODE'				, width:100, hidden: true	
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
											autoPopup: true,
											listeners: {'onSelected': {
				 								fn: function(records, type) {
				 									UniAppManager.app.fnDeptChange(records);		
				 								},
				 								scope: this
				 							},
				 							'onClear': function(type) {
												var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
		                						grdRecord.set('DEPT_CODE','');
						                    	grdRecord.set('DEPT_NAME','');
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
							})
			},
			{dataIndex: 'DEPT_NAME'				, width:170	, hidden: true
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
											autoPopup: true,
											listeners: {'onSelected': {
				 								fn: function(records, type) {
				 									UniAppManager.app.fnDeptChange(records);	
				 								},
				 								scope: this
				 							},
				 							'onClear': function(type) {
				 								var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('DEPT_CODE','');
						                    	grdRecord.set('DEPT_NAME','');
				 							}
				 				}
							})
			 },
			{dataIndex: 'ITEM_CODE'			            , width: 120,
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
			{dataIndex: 'ITEM_NAME'			            , width: 120, 
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
			{dataIndex: 'SPEC'					        , width: 130 }, 
			{dataIndex: 'STOCK_UNIT'				    , width: 80, displayField: 'value' }, 
			{dataIndex: 'ITEM_STATUS'			        , width: 80 }, 
			{dataIndex: 'INOUT_Q'				        , width: 80 }, 
			{dataIndex: 'GOOD_STOCK_Q'			        , width: 80 }, 
			{dataIndex: 'BAD_STOCK_Q'			        , width: 80 }, 
			{dataIndex: 'INOUT_PRSN'				    , width: 77 }, 
			{dataIndex: 'LOT_NO'					    , width: 120,
				editor: Unilite.popup('LOTNO_G', {		
						textFieldName: 'LOTNO_CODE',
						DBtextFieldName: 'LOTNO_CODE',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var rtnRecord;
									Ext.each(records, function(record,i) {
										if(i==0){
											rtnRecord = masterGrid.uniOpt.currentRecord
										}else{
											rtnRecord = masterGrid.getSelectedRecord()
										}
										rtnRecord.set('LOT_NO', record['LOT_NO']);
										rtnRecord.set('PURCHASE_TYPE', record['PURCHASE_TYPE']);
										rtnRecord.set('SALES_TYPE', record['SALES_TYPE']);
										rtnRecord.set('PURCHASE_RATE', record['PURCHASE_RATE']);
										rtnRecord.set('PURCHASE_P', record['PURCHASE_P']);
										rtnRecord.set('SALE_P', record['SALE_BASIS_P']);	
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								var record1 = masterGrid.getSelectedRecord();
								record1.set('LOT_NO', '');
								record1.set('PURCHASE_TYPE', '');
								record1.set('SALES_TYPE', '');
								record1.set('PURCHASE_RATE', '');
								record1.set('PURCHASE_P', '');
								record1.set('SALE_P', '');
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
			{dataIndex: 'REMARK'					    , width: 133 }, 
			{dataIndex: 'PROJECT_NO'				    , width: 133 }, 
			{dataIndex: 'UPDATE_DB_USER'			    , width: 66, hidden: true }, 
			{dataIndex: 'UPDATE_DB_TIME'			    , width: 66, hidden: true }, 
			{dataIndex: 'COMP_CODE'				        , width: 10, hidden: true }, 
			{dataIndex: 'ITEM_ACCOUNT'			        , width: 66, hidden: true },
			{dataIndex: 'PURCHASE_CUSTOM_CODE'			, width: 100, hidden: true },		
			{dataIndex: 'PURCHASE_TYPE'					, width: 100, hidden: true },		
			{dataIndex: 'SALES_TYPE'					, width: 100, hidden: true },		
			{dataIndex: 'PURCHASE_RATE'					, width: 100, hidden: true },		
			{dataIndex: 'PURCHASE_P'					, width: 100, hidden: true },		
			{dataIndex: 'SALE_P'						, width: 100, hidden: true }		
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
	        beforeedit  : function( editor, e, eOpts ) {
	        	//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
				if(e.field=='INOUT_PRSN') {
					record = this.getSelectedRecord();
					var toDivCode = record.get('TO_DIV_CODE');
					var combo = e.column.field;
					
					if(e.rowIdx == 5) {								
						combo.store.clearFilter();
						combo.store.filter('refCode1', toDivCode);
					} else {
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', toDivCode);
					return true;
				}
	        	if(e.record.phantom == false) {
  					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE', 'INOUT_CODE', 'ITEM_CODE', 'ITEM_STATUS',
												  'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO'])) 
					{ 
						return true;
      				} else {
      					return false;
      				}
				} else {
					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE', 'INOUT_CODE', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
				   								  'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO'])) 
				   	{
						return true;
      				} else {
      					return false;
      				}
				}
			}
       	},
       	
       	////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			//grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);                              
       			grdRecord.set('DEPT_CODE'			, masterForm.getValue('DEPT_CODE'));                              
				grdRecord.set('DEPT_NAME'			, masterForm.getValue('DEPT_NAME'));                              
       			grdRecord.set('ITEM_CODE'			, '');                              
				grdRecord.set('ITEM_NAME'			, '');                              	
				grdRecord.set('SPEC'				, '');                              
				grdRecord.set('STOCK_UNIT'			, '');                              
				grdRecord.set('ITEM_STATUS'			, '1');                              
				grdRecord.set('INOUT_Q'				, '');                              
				grdRecord.set('GOOD_STOCK_Q'		, 0);                    	
				grdRecord.set('BAD_STOCK_Q'			, 0);                    
				grdRecord.set('INOUT_PRSN'			, '');                         
				grdRecord.set('LOT_NO'				, '');                         
				grdRecord.set('REMARK'				, '');                         	
				grdRecord.set('PROJECT_NO'			, '');
       		} else {                                
       			//grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);                               
       			grdRecord.set('DEPT_CODE'			, masterForm.getValue('DEPT_CODE'));                              
				grdRecord.set('DEPT_NAME'			, masterForm.getValue('DEPT_NAME'));        
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);   
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);            
				grdRecord.set('SPEC'				, record['SPEC']);        
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);  
				grdRecord.set('ITEM_STATUS'			, '1');            
				grdRecord.set('INOUT_Q'				, record['INOUT_Q']);     
//				grdRecord.set('GOOD_STOCK_Q'		, '0');
				grdRecord.set('BAD_STOCK_Q'			, 0); 
				grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));            
				grdRecord.set('LOT_NO'				, record['LOT_NO']);       
				grdRecord.set('REMARK'				, record['REMARK']);       
				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);  
			
				UniAppManager.app.fnQtySet(grdRecord);
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
       		
		},
		
		setEstiData: function(record) {						// 이동요청참조 셋팅        
       		var grdRecord = this.getSelectedRecord();                           
       		grdRecord.set('TO_DIV_CODE'	, record['DIV_CODE']);                  
       		grdRecord.set('INOUT_CODE'	, record['WH_CODE']);
       		grdRecord.set('DEPT_CODE'	, masterForm.getValue('DEPT_CODE'));
       		grdRecord.set('DEPT_NAME'	, masterForm.getValue('DEPT_NAME'));
       		grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
       		grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
       		grdRecord.set('SPEC'		, record['SPEC']);
       		grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
       		grdRecord.set('INOUT_PRSN'	, record['REQ_PRSN']);
       		grdRecord.set('ITEM_STATUS'	,'1');
       		grdRecord.set('INOUT_Q'		, record['REQSTOCK_Q']);
       		grdRecord.set('GOOD_STOCK_Q', record['GOOD_STOCK_Q']);
       		grdRecord.set('BAD_STOCK_Q'	, record['BAD_STOCK_Q']);
		}
    });	//End of   var masterGrid1 = Unilite.createGrid('btr110ukrvGrid1', {
	
    var orderNoMasterGrid = Unilite.createGrid('btr110ukrvOrderNoMasterGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',       
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
        columns:  [ 
					 { dataIndex: 'ITEM_CODE'			   ,  width: 100}, 
					 { dataIndex: 'ITEM_NAME'			   ,  width: 133}, 
					 { dataIndex: 'DEPT_CODE'			   ,  width: 100}, 
					 { dataIndex: 'DEPT_NAME'			   ,  width: 133}, 
					 { dataIndex: 'SPEC'				   ,  width: 133}, 
					 { dataIndex: 'STOCK_UNIT'			   ,  width: 66, hidden: true, displayField: 'value'}, 
					 { dataIndex: 'INOUT_DATE'			   ,  width: 73}, 
					 { dataIndex: 'INOUT_Q'				   ,  width: 80}, 
					 { dataIndex: 'DIV_CODE'			   ,  width: 80, hidden: true}, 
					 { dataIndex: 'WH_CODE'				   ,  width: 100}, 
					 { dataIndex: 'WH_CELL_CODE'		   ,  width: 100, hidden: true}, 
					 { dataIndex: 'TO_DIV_CODE'			   ,  width: 80}, 
					 { dataIndex: 'INOUT_CODE'			   ,  width: 100}, 
					 { dataIndex: 'INOUT_CODE_DETAIL'	   ,  width: 100, hidden: true}, 
					 { dataIndex: 'LOT_NO'				   ,  width: 106, hidden: true}, 
					 { dataIndex: 'INOUT_PRSN'			   ,  width: 66}, 
					 { dataIndex: 'INOUT_NUM'			   ,  width: 106}
          ] ,
          listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	orderNoMasterGrid.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	SearchInfoWindow.hide();
	          }
          },
          returnData: function(record)	{
          		if(Ext.isEmpty(record))	{
          			record = this.getSelectedRecord();
          		}
          		masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'WH_CODE':record.get('WH_CODE'), 'INOUT_DATE':record.get('INOUT_DATE'),
          		 				      'INOUT_NUM':record.get('INOUT_NUM'), 'INOUT_PRSN':record.get('INOUT_PRSN'), 'DEPT_CODE':record.get('DEPT_CODE'), 'DEPT_NAME':record.get('DEPT_NAME')});
	   	  }
    });
    
    var otherOrderGrid = Unilite.createGrid('btr110ukrvOtherOrderGrid', {	//이동요청 참조
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
        columns: [  
			 { dataIndex: 'DIV_CODE'						,  width: 80},
			 { dataIndex: 'WH_CODE'							,  width: 66, hidden: true},
			 { dataIndex: 'WH_NAME'							,  width: 80},
			 { dataIndex: 'WH_CELL_CODE'					,  width: 66, hidden: true},
			 { dataIndex: 'WH_CELL_NAME'					,  width: 80, hidden: true},
			 { dataIndex: 'REQSTOCK_NUM'					,  width: 93},
			 { dataIndex: 'REQSTOCK_SEQ'					,  width: 33},
			 { dataIndex: 'ITEM_CODE'						,  width: 93},
			 { dataIndex: 'ITEM_NAME'						,  width: 120},
			 { dataIndex: 'DEPT_CODE'						,  width: 93},
			 { dataIndex: 'DEPT_NAME'						,  width: 120},
			 { dataIndex: 'SPEC'							,  width: 100},
			 { dataIndex: 'STOCK_UNIT'						,  width: 80, displayField: 'value'},
			 { dataIndex: 'REQ_PRSN'						,  width: 80},
			 { dataIndex: 'REQSTOCK_Q'						,  width: 80},
			 { dataIndex: 'OUTSTOCK_Q'						,  width: 80, hidden: true},
			 { dataIndex: 'NOTOUTSTOCK_Q'					,  width: 80},
			 { dataIndex: 'OUTSTOCK_DATE'					,  width: 100},
			 { dataIndex: 'GOOD_STOCK_Q'					,  width: 80, hidden: true},
			 { dataIndex: 'BAD_STOCK_Q'						,  width: 80, hidden: true},
			 { dataIndex: 'OUT_DIV_CODE'					,  width: 66, hidden: true},
			 { dataIndex: 'OUT_WH_CODE'						,  width: 66, hidden: true},
			 { dataIndex: 'OUT_WH_CELL_CODE'				,  width: 66, hidden: true},
			 { dataIndex: 'LOT_NO'							,  width: 100, hidden: true},
			 { dataIndex: 'REMARK'							,  width: 80},
			 { dataIndex: 'ITEM_ACCOUNT'					,  width: 80, hidden: true}
       ],
       listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {}
       },
       returnData: function(record) {
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i){	
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);								        
			}); 
			this.deleteSelectedRow();
       	}
    });
    
    function openSearchInfoWindow() {	//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.inventory.inventorymovementissuenosearch" default="재고이동출고번호검색"/>',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [orderNoSearch, orderNoMasterGrid], //masterGrid],
                tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
						if(orderNoSearch.setAllFieldsReadOnly(true) == false){
							return false;
						}
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
				listeners : {beforehide: function(me, eOpt)	
					{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();	                							
                	},
                	beforeclose: function( panel, eOpts )	{
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
    
    function openMoveRequestWindow() {    	//이동요청 참조	
  		if(!MoveRequestWindow) {
			MoveRequestWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.inventory.movingrequestrefer" default="이동요청참조"/>',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherOrderSearch, otherOrderGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler: function() {
							if(!otherOrderSearch.getInvalidMessage()) {
								return false;
							} else {
								otherOrderStore.loadStoreRecords();
								if(otherOrderSearch.setAllFieldsReadOnly(true) == false){
									return false;
								}
							}
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
							MoveRequestWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							MoveRequestWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {beforehide: function(me, eOpt)	{
                							otherOrderSearch.clearForm();
                							otherOrderGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											otherOrderSearch.clearForm();
                							otherOrderGrid.reset();
                			 			},
                			 beforeshow: function ( me, eOpts )	{
		                		field = otherOrderSearch.getField('INOUT_PRSN');
		                		field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
                			 	otherOrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		                		otherOrderSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
		                		otherOrderSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
		                		otherOrderSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));	
		                		otherOrderSearch.setValue('TO_INOUT_DATE',masterForm.getValue('INOUT_DATE'));
		                		otherOrderSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
//                				otherOrderStore.loadStoreRecords();
                			 }
                }
			})
		}
		MoveRequestWindow.show();
    }
		
    Unilite.Main( {
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
		id: 'btr110ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', true); 
			this.setDefault();
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			btr110ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown: function()	{		// 조회버튼 눌렀을때	
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow() 
			} else {
				if(!this.isValidSearchForm()) {
					return false;
				}
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
		setDefault: function() {		// 기본값
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
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
         	
         	var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
         	btr110ukrvService.deptWhcode(param, function(provider, response){	
				if(!Ext.isEmpty(provider)){						
					 masterForm.setValue('WH_CODE', provider['WH_CODE']);					
				}
			});
		},
		onResetButtonDown: function() {		// 초기화
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
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						var count = masterGrid.getStore().getCount();
						/*---------삭제전 로직 구현 시작----------*/
						if(count < 2) {
							alert(Msg.sMB016);
							return false;
						} else {
							Ext.each(records, function(record,i) {								
								if(record.get('BASIS_NUM') != '') {	
									alert(Msg.sMS236);	//이동입고가 진행된 출고건은 수정/삭제가 불가능합니다.
									deletable = false;
									return false;
								}
							});
						}
						/*---------삭제전 로직 구현 끝----------*/
						
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}													
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
			
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{		// 행추가
				/**
				 * Detail Grid Default 값 설정
				 */
			var compCode = UserInfo.compCode; 
			var divCode = masterForm.getValue('DIV_CODE');
			var whCode = masterForm.getValue('WH_CODE');
			var inoutNum = masterForm.getValue('INOUT_NUM');
			var seq = directMasterStore1.max('INOUT_SEQ');
            	if(!seq) seq = 1;
            	else  seq += 1;
            var inoutType = '2';
            var inoutMeth = '3';
            var inoutTypeDetail = '99';
            var inoutCodeType = '2';
            var toDivCode = masterForm.getValue('DIV_CODE');
            var inoutCode = masterForm.getValue('INOUT_CODE');
            var whCellCode = masterForm.getValue('WH_CELL_CODE');
            var deptCode = masterForm.getValue('DEPT_CODE');
            var deptName = masterForm.getValue('DEPT_NAME');
            var inoutDate = UniDate.get('today');
            var itemStatus = '1';
            var inItemStatus = '1';
            var inoutPrsn = masterForm.getValue('INOUT_PRSN');
            var inoutForP = '0';
            var inoutForO = '0';
            var moneyUnit = masterForm.getValue('MONEY_UNIT');
            var exchgRateO = '1.00';
            var basisSeq = '0';
            var inoutQ = '0';
            var goodStockQ ='0';
            var badStockQ = '0';
            var orderSeq = '0';
            	
            var r = {
            	COMP_CODE: compCode,
            	DIV_CODE: divCode,
            	WH_CODE: whCode,
				INOUT_NUM: inoutNum,
				INOUT_SEQ: seq,
				INOUT_TYPE: inoutType,	
				INOUT_METH: inoutMeth,
				INOUT_TYPE_DETAIL: inoutTypeDetail,
				INOUT_CODE_TYPE: inoutCodeType,
				TO_DIV_CODE: toDivCode, 		
				INOUT_CODE: inoutCode, 		
				WH_CELL_CODE: whCellCode, 
				DEPT_CODE: deptCode,
				DEPT_NAME: deptName,
				INOUT_DATE: inoutDate, 	
				ITEM_STATUS: itemStatus,	
				IN_ITEM_STATUS: inItemStatus,
				INOUT_PRSN: inoutPrsn,	
				INOUT_FOR_P: inoutForP,	
				INOUT_FOR_O	: inoutForO,
				MONEY_UNIT: moneyUnit,	
				EXCHG_RATE_O: exchgRateO,
				BASIS_SEQ: basisSeq,		
				INOUT_Q: inoutQ,		
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				ORDER_SEQ: orderSeq
		    };
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
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
			var fp = Ext.getCmp('btr110ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnQtySet : function(record) {
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'), 
						 "WH_CODE": masterForm.getValue('WH_CODE'), "ITEM_CODE": record.get('ITEM_CODE')};
			btr110ukrvService.QtySet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				record.set('GOOD_STOCK_Q', provider['STOCK_Q']);
//				record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//				record.set('AVERAGE_P', provider['AVERAGE_P']);
				}
			})
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INOUT_Q" :
					if(newValue <= 0) {
						rv= Msg.sMB076;		
						break;
					}
					if(BsaCodeInfo.gsInvStatus == "+") {
						if(record.get('ITEM_STATUS') == "1") {
							if(newValue > record.get('GOOD_STOCK_Q') + record.get('ORIGIN_Q')) {
								rv= Msg.sMS210;		
								break;
							}
						} else {
							if(newValue > record.get('BAD_STOCK_Q') + record.get('ORIGIN_Q')) {
								rv= Msg.sMS210;		
								break;
							}
						}
					}
				break;
			}
			return rv;
		}
	});
};
		
</script>
