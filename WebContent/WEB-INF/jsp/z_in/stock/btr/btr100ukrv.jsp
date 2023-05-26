<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr100ukrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="btr100ukrv"/> 			<!-- 사업장 -->  
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
<t:ExtComboStore comboType="AU" comboCode="B024" /> 				<!--담당자-->
<t:ExtComboStore comboType="AU" comboCode="S011" /> 				<!--마감정보-->
<t:ExtComboStore comboType="AU" comboCode="B021" /> 				<!--양불구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var AvailableStockWindow; // 가용재고 참조

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴
	gsInvstatus: 		'${gsInvstatus}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}'
};

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

/*var output =''; 
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
			read: 'btr100ukrvService.selectMaster',
			update: 'btr100ukrvService.updateDetail',
			create: 'btr100ukrvService.insertDetail',
			destroy: 'btr100ukrvService.deleteDetail',
			syncAll: 'btr100ukrvService.saveAll'
		}
	});
	
	var masterForm = Unilite.createSearchPanel('btr100ukrvMasterForm',{		// 메인
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
    			fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				value: '01',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//						var field = panelResult.getField('REQ_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
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
				fieldLabel: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',
				name: 'REQSTOCK_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('REQSTOCK_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.requestno" default="요청번호"/>',
				name:'REQSTOCK_NUM',	
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('REQSTOCK_NUM', newValue);
					}
				}
			},{	
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'REQ_PRSN',	
				xtype: 'uniCombobox', 
				holdable: 'hold',
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
						panelResult.setValue('REQ_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
				name:'OUT_DIV_CODE',	
				xtype: 'uniCombobox', 
				comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OUT_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>',
				name:'WH_CELL_CODE',
				xtype: 'hiddenfield', 
				store: Ext.data.StoreManager.lookup('whList')
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
    			fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				value: '01',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//						var field = masterForm.getField('REQ_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
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
				fieldLabel: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',
				name: 'REQSTOCK_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('REQSTOCK_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.requestno" default="요청번호"/>',
				name:'REQSTOCK_NUM',	
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: Autotype,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('REQSTOCK_NUM', newValue);
					}
				}
			},{	
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'REQ_PRSN',	
				xtype: 'uniCombobox', 
				holdable: 'hold',
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
						masterForm.setValue('REQ_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
				name:'OUT_DIV_CODE',	
				xtype: 'uniCombobox', 
				comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('OUT_DIV_CODE', newValue);
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
						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
	
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
        		fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
        		name: 'DIV_CODE', 
        		xtype: 'uniCombobox', 
				allowBlank: false,
        		comboType: 'BOR120',
				child:'WH_CODE',
        		//hidden: true,
		   	 	value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//						var field = orderNoSearch.getField('REQ_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
        	},{
 				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
 				name:'WH_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},{
				fieldLabel: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',
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
				name:'REQ_PRSN', 
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
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
    
    var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//가용재고 참조
        layout :  {type : 'uniTable', columns : 3},
        items :[
        	/*{
        		fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
        		name: 'DIV_CODE', 
        		xtype: 'uniCombobox', 
				allowBlank: false,
        		comboType: 'BOR120',
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
//						var field = orderNoSearch.getField('REQ_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
        	},{
 				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
 				name:'WH_CODE',
 				colspan: 2,
				allowBlank: false,
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},*/
           	Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
		    	textFieldName: 'ITEM_NAME',
				allowBlank: false,
				extraFieldsConfig: [
					{extraFieldName: 'SPEC', extraFieldWidth: 100},
					{extraFieldName: 'STOCK_UNIT', extraFieldWidth: 100}
				],
				listeners: {'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							//alert("store reload");
							otherOrderStore.loadStoreRecords();
						},
						scope: this
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			})
		],
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('btr100ukrvModel', {		// 메인
	    fields: [  	  
	    	{name: 'REQSTOCK_NUM'				,text: '<t:message code="system.label.inventory.moverequestno" default="이동요청번호"/>'			,type: 'string'},
		    {name: 'REQSTOCK_SEQ'				,text: '<t:message code="system.label.inventory.seq" default="순번"/>'					,type: 'int', allowBlank: false},
		    {name: 'OUT_DIV_CODE'				,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'				,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
		    {name: 'OUT_WH_CODE'				,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
		    {name: 'OUT_WH_NAME'				,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				,type: 'string',store: Ext.data.StoreManager.lookup('whList')},
		    {name: 'OUT_WH_CELL_CODE'			,text: '<t:message code="system.label.inventory.issuewarehousecellcode" default="출고창고Cell코드"/>'		,type: 'string'},
		    {name: 'OUT_WH_CELL_NAME'			,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			,type: 'string'},
		    {name: 'ITEM_CODE'					,text: '<t:message code="system.label.inventory.item" default="품목"/>'				,type: 'string', allowBlank: false},  
		    {name: 'ITEM_NAME'					,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'					,type: 'string'},
		    {name: 'SPEC'						,text: '<t:message code="system.label.inventory.spec" default="규격"/>'					,type: 'string'},
		    {name: 'STOCK_UNIT'					,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'				,type: 'string', displayField: 'value'},
		    {name: 'ITEM_STATUS'				,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'				,type: 'string', comboType:'AU', comboCode:'B021', allowBlank: false},
		    {name: 'REQSTOCK_Q'					,text: '<t:message code="system.label.inventory.requestqty" default="요청량"/>'				    ,type: 'uniQty', allowBlank: false},
		    {name: 'OUTSTOCK_Q'					,text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'				    ,type: 'uniQty'},
		    {name: 'NOTSTOCK_Q'					,text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>'				,type: 'uniQty'},   
		    {name: 'GOOD_STOCK_Q'				,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'				,type: 'uniQty'},
		    {name: 'BAD_STOCK_Q'				,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'				,type: 'uniQty'},
		    {name: 'OUTSTOCK_DATE'				,text: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>'				,type: 'uniDate'},
		    {name: 'CLOSE_YN'					,text: '<t:message code="system.label.inventory.requestclosing" default="요청마감"/>'				,type: 'string', comboType:'AU', comboCode:'H153', allowBlank: false},
		    {name: 'DIV_CODE'					,text: '<t:message code="system.label.inventory.receiptdivision2" default="받을사업장"/>'				,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
		    {name: 'WH_CODE'					,text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>'				,type: 'string',store: Ext.data.StoreManager.lookup('whList')},   
		    {name: 'WH_CELL_CODE'				,text: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>'		,type: 'string'},
		    {name: 'REQ_PRSN'					,text: '<t:message code="system.label.inventory.charger" default="담당자"/>'				    ,type: 'string', comboType:'AU', comboCode:'B024'},
		    {name: 'REQSTOCK_DATE'				,text: '<t:message code="system.label.inventory.requestdate" default="요청일"/>'				    ,type: 'uniDate'},
		    {name: 'LOT_NO'						,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				    ,type: 'string'},
		    {name: 'REMARK'						,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					,type: 'string'},
		    {name: 'PROJECT_NO'					,text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'			,type: 'string'},   
		    {name: 'UPDATE_DB_USER'				,text: '<t:message code="system.label.inventory.writer" default="작성자"/>'				    ,type: 'string'},
		    {name: 'UPDATE_DB_TIME'				,text: '<t:message code="system.label.inventory.writtendate" default="작성일"/>'				,type: 'string'},
		    {name: 'COMP_CODE'					,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'ITEM_ACCOUNT'				,text: '<t:message code="system.label.inventory.itemqty" default="품목수량"/>'				,type: 'string'}
		    
		]
	}); //End of Unilite.defineModel('btr100ukrvModel', {
	
	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
	    fields: [
	    	{name: 'ITEM_CODE'					, text: '<t:message code="system.label.inventory.item" default="품목"/>'				, type: 'string'},
	    	{name: 'ITEM_NAME'					, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				    , type: 'string'},
	    	{name: 'SPEC'						, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				    , type: 'string'},
	    	{name: 'STOCK_UNIT'					, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'				, type: 'string', displayField: 'value'},
	    	{name: 'OUTSTOCK_DATE'				, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'				, type: 'uniDate'},
	    	{name: 'NOTSTOCK_Q'					, text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>'				, type: 'uniQty'},
	    	{name: 'DIV_CODE'					, text: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>'			, type: 'string'},
	    	{name: 'WH_CODE'					, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>'			, type: 'string'},
	    	{name: 'WH_NAME'					, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>'				, type: 'string'},
	    	{name: 'WH_CELL_CODE'				, text: '<t:message code="system.label.inventory.receivecellwarehousecode" default="받을창고 Cell코드"/>'		, type: 'string'},
	    	{name: 'WH_CELL_NAME'				, text: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고Cell"/>'			, type: 'string'},
	    	{name: 'OUT_DIV_CODE'				, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string', comboType: 'BOR120'},
	    	{name: 'OUT_WH_CODE'				, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				, type: 'string'},
	    	{name: 'OUT_WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			, type: 'string'},
	    	{name: 'LOT_NO'						, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			    , type: 'string'},
	    	{name: 'REQ_PRSN'					, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'CLOSE_YN'					, text: '<t:message code="system.label.inventory.closingyn" default="마감여부"/>'				, type: 'string'},
	    	{name: 'REQSTOCK_NUM'				, text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'				, type: 'string'},
	    	{name: 'REQSTOCK_DATE'				, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'				, type: 'string'},
	    	{name: 'REQSTOCK_SEQ'				, text: '<t:message code="system.label.inventory.issueseq" default="출고순번"/>'				, type: 'string'}
		]
	});
	
	Unilite.defineModel('btr100ukrvOTHERModel', {	//가용재고 참조 
	    fields: [
			{name: 'DIV_CODE'		   	, text: '<t:message code="system.label.inventory.division" default="사업장"/>'    		 , type: 'string', comboType: 'BOR120'},
			{name: 'WH_NAME'		   	, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'    		 , type: 'string'},
			{name: 'WH_CODE'		   	, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'    		     , type: 'string'},
			{name: 'ITEM_CODE'     		, text: '<t:message code="system.label.inventory.item" default="품목"/>'    		 , type: 'string'},
			{name: 'STOCK_Q'		   	, text: '<t:message code="system.label.inventory.onhandstock" default="현재고"/>'    		 , type: 'string'},
			{name: 'GOOD_STOCK_Q'	   	, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'    		 , type: 'string'},
			{name: 'BAD_STOCK_Q'	   	, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'    		 , type: 'string'},
			{name: 'NOT_IN_Q'		   	, text: '<t:message code="system.label.inventory.receiptplanned" default="입고예정"/>'    		 , type: 'string'},
			{name: 'NOT_OUT_Q'		   	, text: '<t:message code="system.label.inventory.issueresevation" default="출고예정"/>'    		 , type: 'string'},
			{name: 'SAFE_STOCK_Q'	   	, text: '<t:message code="system.label.inventory.safetystock" default="안전재고"/>'    		 , type: 'string'},
			{name: 'USE_STOCK_Q'	   	, text: '<t:message code="system.label.inventory.availableinventory" default="가용재고"/>'    		 , type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('Btr100ukrvMasterStore1',{		// 메인
		model: 'btr100ukrvModel',
		uniOpt : {
            	isMaster: true,		// 상위 버튼 연결 
            	editable: true,		// 수정 모드 사용 
            	deletable: true,	// 삭제 가능 여부 
	            useNavi : false,	// prev | next 버튼 사용
				allDeletable: true	// 전체 삭제 가능 여부
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
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			var reqstockNum = masterForm.getValue('REQSTOCK_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['REQSTOCK_NUM'] != reqstockNum) {
					record.set('REQSTOCK_NUM', reqstockNum);
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
						masterForm.setValue("REQSTOCK_NUM", master.REQSTOCK_NUM);
						panelResult.setValue("REQSTOCK_NUM", master.REQSTOCK_NUM);
						var reqstockNum = masterForm.getValue('REQSTOCK_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['REQSTOCK_NUM'] != reqstockNum) {
								record.set('REQSTOCK_NUM', reqstockNum);
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
	});		// End of var directMasterStore1 = Unilite.createStore('btr100ukrvMasterStore1',{
	
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
                	read: 'btr100ukrvService.selectDetail'
                }
            },
            loadStoreRecords: function() {
			var param= orderNoSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
	});		// End of var directMasterStore1 = Unilite.createStore('Btr100ukrvMasterStore1',{
	
	var otherOrderStore = Unilite.createStore('btr100ukrvOtherOrderStore', {//가용재고 참조
			model: 'btr100ukrvOTHERModel',
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
                	read: 'btr100ukrvService.selectDetail2'                	
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
    
    var masterGrid = Unilite.createGrid('btr100ukrvGrid', {		// 메인
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
					itemId: 'AvailableStockBtn',
					text: '<t:message code="system.label.inventory.availableinventoryrefer" default="가용재고참조"/>',
					handler: function() {
						openAvailableStockWindow();
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
			{dataIndex: 'REQSTOCK_NUM'		            , width: 100 , hidden: true},
			{dataIndex: 'REQSTOCK_SEQ'		            , width: 50  }, 
			{dataIndex: 'OUT_DIV_CODE'		            , width: 80  },
			{dataIndex: 'OUT_WH_CODE'		            , width: 100 },
			{dataIndex: 'OUT_WH_NAME'		            , width: 100 , hidden: true},
			{dataIndex: 'OUT_WH_CELL_CODE'	            , width: 66 , hidden: true},
			{dataIndex: 'OUT_WH_CELL_NAME'	            , width: 100, hidden: true }, 
			{dataIndex: 'ITEM_CODE'			            , width: 93 ,
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
												}
										}
					})
			},
			{dataIndex: 'SPEC'				            , width: 93 },
			{dataIndex: 'STOCK_UNIT'		            , width: 66 }, 
			{dataIndex: 'ITEM_STATUS'		            , width: 66 },
			{dataIndex: 'REQSTOCK_Q'		            , width: 80 }, 
			{dataIndex: 'OUTSTOCK_Q'		            , width: 80 },
			{dataIndex: 'NOTSTOCK_Q'		            , width: 80  , hidden: true}, 
			{dataIndex: 'GOOD_STOCK_Q'		            , width: 80 },
			{dataIndex: 'BAD_STOCK_Q'		            , width: 80 }, 
			{dataIndex: 'OUTSTOCK_DATE'		            , width: 80 },
			{dataIndex: 'CLOSE_YN'			            , width: 66 }, 
			{dataIndex: 'DIV_CODE'			            , width: 100 , hidden: true},
			{dataIndex: 'WH_CODE'			        	, width: 100 , hidden: true}, 
			{dataIndex: 'WH_CELL_CODE'		            , width: 66  , hidden: true},
			{dataIndex: 'REQ_PRSN'			            , width: 100 }, 
			{dataIndex: 'REQSTOCK_DATE'		            , width: 66  , hidden: true},
			{dataIndex: 'LOT_NO'			            , width: 120 }, 
			{dataIndex: 'REMARK'			            , width: 133 },
			{dataIndex: 'PROJECT_NO'		            , width: 100 }, 
			{dataIndex: 'UPDATE_DB_USER'	            , width: 66  , 	hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	            , width: 66  , hidden: true}, 
			{dataIndex: 'COMP_CODE'			            , width: 66  , hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'		            , width: 66  , hidden: true}			
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
					var seq = directMasterStore1.max('REQSTOCK_SEQ');
	            	if(!seq) seq = 1;
	            	else  seq += 1;
	          		record.REQSTOCK_SEQ = seq;

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
				if(e.field=='REQ_PRSN') {
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
				}
      			if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['OUT_DIV_CODE', 'OUT_WH_CODE', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
											      'REQSTOCK_Q', 'OUTSTOCK_DATE', 'CLOSE_YN', 'REQ_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO'])) 
					{
						return true;
      				} else {
      					return false;
      				}
				} else {
					if(UniUtils.indexOf(e.field, ['OUT_DIV_CODE', 'OUT_WH_CODE', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
											      'REQSTOCK_Q', 'OUTSTOCK_DATE', 'CLOSE_YN', 'REQ_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO'])) 
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
       			//grdRecord.set('REQSTOCK_SEQ'			, record['REQSTOCK_SEQ']);	             	         
       			grdRecord.set('OUT_DIV_CODE'			, "");	             	 
				grdRecord.set('OUT_WH_CODE'				, "");		                
				grdRecord.set('ITEM_CODE'				, '');		             	      
				grdRecord.set('ITEM_NAME'				, '');		             	            
				grdRecord.set('SPEC'					, '');			             	
				grdRecord.set('STOCK_UNIT'				, '');		                      
				grdRecord.set('ITEM_STATUS'				, '1');		                  
				grdRecord.set('REQSTOCK_Q'				, 0);		                        
				grdRecord.set('OUTSTOCK_Q'				, 0);		                      
				grdRecord.set('GOOD_STOCK_Q'			, 0);	             	          
				grdRecord.set('BAD_STOCK_Q'				, 0);		
				grdRecord.set('OUTSTOCK_DATE'			, masterForm.getValue('REQSTOCK_DATE'));
				grdRecord.set('CLOSE_YN'				, 'N');		
				grdRecord.set('REQ_PRSN'				, '');		
				grdRecord.set('LOT_NO'					, '');			
				grdRecord.set('REMARK'					, '');			
				grdRecord.set('PROJECT_NO'   			, '');   
       		} else {                                                                              		          
       			//grdRecord.set('REQSTOCK_SEQ'			, record['REQSTOCK_SEQ']);	
       			if(!Ext.isEmpty(masterForm.getValue('OUT_DIV_CODE'))) {
       				grdRecord.set('OUT_DIV_CODE'			, masterForm.getValue('OUT_DIV_CODE'));
       			}
//				grdRecord.set('OUT_WH_CODE'				, "");		
				grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);		             	      
				grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);		             	            
				grdRecord.set('SPEC'					, record['SPEC']);			             	
				grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);		                      
				grdRecord.set('ITEM_STATUS'				, '1');		                  
				grdRecord.set('REQSTOCK_Q'				, record['REQSTOCK_Q']);		                        
				grdRecord.set('OUTSTOCK_Q'				, record['OUTSTOCK_Q']);		                      
				//grdRecord.set('GOOD_STOCK_Q'			, record['GOOD_STOCK_Q']);	             	          
				grdRecord.set('BAD_STOCK_Q'				, 0);		
				grdRecord.set('OUTSTOCK_DATE'			, masterForm.getValue('REQSTOCK_DATE'));
				grdRecord.set('CLOSE_YN'				, 'N');		
				grdRecord.set('REQ_PRSN'				, record['REQ_PRSN']);		
				grdRecord.set('LOT_NO'					, record['LOT_NO']);			
				grdRecord.set('REMARK'					, record['REMARK']);			
				grdRecord.set('PROJECT_NO'   			, record['PROJECT_NO']);
				
				UniAppManager.app.fnQtySet(grdRecord);
				
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		},
		
		setEstiData: function(record) {						// 가용재고참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('OUT_DIV_CODE'	, record['DIV_CODE']);
			grdRecord.set('OUT_WH_CODE'		, record['WH_CODE']);
			//grdRecord.set('OUT_WH_NAME'		, masterForm.getValue('WH_CODE'));
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, otherOrderSearch.getValue('ITEM_NAME'));
			grdRecord.set('SPEC'			, otherOrderSearch.getValue('SPEC'));
			grdRecord.set('STOCK_UNIT'		, otherOrderSearch.getValue('STOCK_UNIT'));
			grdRecord.set('ITEM_STATUS'		, '1');	
			grdRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
			grdRecord.set('OUTSTOCK_DATE'	, masterForm.getValue('REQSTOCK_DATE'));
			grdRecord.set('CLOSE_YN'		, 'N');
			grdRecord.set('REQ_PRSN'		, masterForm.getValue('REQ_PRSN'));
		}		
    });	//End of   var masterGrid1 = Unilite.createGrid('btr100ukrvGrid1', {
	
    var orderNoMasterGrid = Unilite.createGrid('btr100ukrvOrderNoMasterGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',       
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
        columns:  [ 
			{ dataIndex: 'ITEM_CODE'			    ,  width: 100}, 
			{ dataIndex: 'ITEM_NAME'			    ,  width: 133}, 
			{ dataIndex: 'SPEC'				        ,  width: 133}, 
			{ dataIndex: 'STOCK_UNIT'			    ,  width: 80}, 
			{ dataIndex: 'OUTSTOCK_DATE'		    ,  width: 73}, 
			{ dataIndex: 'NOTSTOCK_Q'			    ,  width: 80}, 
			{ dataIndex: 'DIV_CODE'			        ,  width: 66, hidden: true}, 
			{ dataIndex: 'WH_CODE'			        ,  width: 66, hidden: true}, 
			{ dataIndex: 'WH_NAME'			        ,  width: 100}, 
			{ dataIndex: 'WH_CELL_CODE'		        ,  width: 66, hidden: true}, 
			{ dataIndex: 'WH_CELL_NAME'		        ,  width: 100, hidden: true}, 
			{ dataIndex: 'OUT_DIV_CODE'		        ,  width: 100}, 
			{ dataIndex: 'OUT_WH_CODE'		        ,  width: 100}, 
			{ dataIndex: 'OUT_WH_CELL_CODE'	        ,  width: 100, hidden: true}, 
			{ dataIndex: 'LOT_NO'				    ,  width: 100, hidden: true}, 
			{ dataIndex: 'REQ_PRSN'			        ,  width: 66}, 
			{ dataIndex: 'CLOSE_YN'			        ,  width: 100}, 
			{ dataIndex: 'REQSTOCK_NUM'		        ,  width: 80}, 
			{ dataIndex: 'REQSTOCK_DATE'		    ,  width: 66, hidden: true}, 
			{ dataIndex: 'REQSTOCK_SEQ'		        ,  width: 66, hidden: true}
       ],
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
          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'REQSTOCK_NUM':record.get('REQSTOCK_NUM'),
          						  'REQSTOCK_DATE':record.get('REQSTOCK_DATE'), 'WH_CODE':record.get('WH_CODE'),
          						  'REQ_PRSN':record.get('REQ_PRSN')});
	   }
    });
    
    var otherOrderGrid = Unilite.createGrid('btr100ukrvotherOrderGrid', {	//가용재고 참조
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
        columns:  [
			{ dataIndex: 'DIV_CODE'				,  width: 100},
			{ dataIndex: 'WH_NAME'				,  width: 100},
			{ dataIndex: 'WH_CODE'				,  width: 100, hidden: true},
			{ dataIndex: 'ITEM_CODE'     		,  width: 100, hidden: true},
			{ dataIndex: 'STOCK_Q'				,  width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'			,  width: 100, hidden: true},
			{ dataIndex: 'BAD_STOCK_Q'			,  width: 100, hidden: true},
			{ dataIndex: 'NOT_IN_Q'				,  width: 100},
			{ dataIndex: 'NOT_OUT_Q'			,  width: 100},
			{ dataIndex: 'SAFE_STOCK_Q'			,  width: 100},
			{ dataIndex: 'USE_STOCK_Q'			,  width: 100}
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
                title: '<t:message code="system.label.inventory.inventorymovementrequestnosearch" default="재고이동요청번호검색"/>',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [orderNoSearch, orderNoMasterGrid], //masterGrid],
                tbar:  ['->',
					{ itemId : 'saveBtn',
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
				listeners : {beforehide: function(me, eOpt)	
					{
//						orderNoSearch.clearForm();
//						orderNoMasterGrid.reset();	                							
                	},
                	beforeclose: function( panel, eOpts )	{
//						orderNoSearch.clearForm();
                	},
                	beforeshow: function( panel, eOpts )	{
                		field = orderNoSearch.getField('REQ_PRSN');
                		field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
                		orderNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
                		orderNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
                		orderNoSearch.setValue('REQ_PRSN',masterForm.getValue('REQ_PRSN'));
                		//orderNoSearch.setValue('REQSTOCK_DATE',masterForm.getValue('REQSTOCK_DATE'));								
                	}
                }		
			})
		}
		SearchInfoWindow.show();
    }
    
    function openAvailableStockWindow() {    	//가용재고 참조	
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
		if(!AvailableStockWindow) {
			AvailableStockWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.inventory.availableinventorysearch" default="가용재고검색"/>',
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
							AvailableStockWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							AvailableStockWindow.hide();
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
		                	beforeshow: function( panel, eOpts )	{
		                		otherOrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		                		otherOrderSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));	
		                	}
                }
			})
		}
		
		AvailableStockWindow.show();
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
		id: 'btr100ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			btr100ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
			this.setDefault();
		},
		onQueryButtonDown: function()	{	// 조회
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var reqstockNo = masterForm.getValue('REQSTOCK_NUM');
			if(Ext.isEmpty(reqstockNo)) {
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
		fnGetreqPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.reqPrsn, function(item, i)	{
        		if(item['refCode1'] == subCode) {
        			fRecord = item['codeNo'];
        			return false;
        		}
        	});
        	return fRecord;
        },
		setDefault: function() {	// 기본값
			var field = masterForm.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('REQ_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			field = orderNoSearch.getField('REQ_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			
			var reqPrsn = UniAppManager.app.fnGetreqPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
			
			masterForm.setValue('DIV_CODE', UserInfo.divCode);			
			masterForm.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
        	panelResult.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
        	orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
        	orderNoSearch.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
        	masterForm.setValue('REQSTOCK_DATE',UniDate.get('today'));
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
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
			var fp = Ext.getCmp('btr100ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.inventory.message015" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterForm.reset();
			panelResult.reset();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
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
					if(confirm('<t:message code="system.message.inventory.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						
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
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{		// 행추가
			if(!this.checkForNewDetail()) return false;

			//Detail Grid Default 값 설정
			var reqstockNum = masterForm.getValue('REQSTOCK_NUM');
			var seq = directMasterStore1.max('REQSTOCK_SEQ');
            	if(!seq) seq = 1;
            	else  seq += 1;
            var divCode = masterForm.getValue('DIV_CODE');
            var whCode = masterForm.getValue('WH_CODE');
            var whCellCode = masterForm.getValue('WH_CELL_CODE');
            var outDivCode = masterForm.getValue('OUT_DIV_CODE');
            var reqstockDate = UniDate.get('today');
            var outstockDate = UniDate.get('today');
            var itemStatus = '1';
            var reqstockQ = '0';
            var outstockQ = '0';
            var notstockQ ='0';
            var goodStockQ = '0';
            var badStockQ = '0';
            var closeYn = 'N';
            var lotNo = '';
            var Remark = '';
            var reqPrsn = masterForm.getValue('REQ_PRSN');
            var compCode = UserInfo.compCode; 
            
            var r = {
				REQSTOCK_NUM: reqstockNum,
				REQSTOCK_SEQ: seq,
				DIV_CODE: divCode,
				WH_CODE: whCode,
				WH_CELL_CODE: whCellCode,
				OUT_DIV_CODE: outDivCode,
				REQSTOCK_DATE: reqstockDate,
				OUTSTOCK_DATE: outstockDate,
				ITEM_STATUS: itemStatus,
				REQSTOCK_Q: reqstockQ,
				OUTSTOCK_Q:	outstockQ,
				NOTSTOCK_Q:	notstockQ,
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				CLOSE_YN: closeYn,	
				LOT_NO: lotNo,		
				REMARK: Remark,		
				REQ_PRSN: reqPrsn,	
				COMP_CODE: compCode
		    };
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons('reset', true);
		},
		checkForNewDetail: function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('ORDER_NUM')))	{
				alert('<t:message code="system.label.inventory.sono" default="수주번호"/>:<t:message code="system.message.inventory.datacheck003" default="필수입력 항목입니다."/>');
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
		},
		fnQtySet : function(record) {
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'), 
						 "WH_CODE": masterForm.getValue('WH_CODE'), "ITEM_CODE": record.get('ITEM_CODE')};
			btr100ukrvService.QtySet(param, function(provider, response)	{
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
				case "REQSTOCK_Q" :
					if(newValue <= 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';	
						break;
					}
					break;
					
				case "OUTSTOCK_DATE" :
					if(newValue < UniDate.get('today')) {
						rv= '<t:message code="system.message.inventory.message020" default="입고희망일은 현재일보다 커야합니다."/>';
						break;
					}
					break;
					
				case "OUT_WH_CODE" :
					if(newValue == masterForm.getValue('WH_CODE')) {
						rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
						break;
					}
					break;
			}
			return rv;
		}
	});
};

</script>
