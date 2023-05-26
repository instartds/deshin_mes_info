<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo030ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP10" /> <!--지급유형-->  
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 지급담당 -->
</t:appConfig>
<script type="text/javascript" >

var referNoPayWindow;	//미지급참조

var CustomCodeInfo = {
	gsUnderCalBase: ''
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo030ukrvService.noPayList',
			update: 'mpo030ukrvService.updateDetail',
			create: 'mpo030ukrvService.insertDetail',
			destroy: 'mpo030ukrvService.deleteDetail',
			syncAll: 'mpo030ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mpo030ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},  	 	
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},  	 	
	    	{name: 'PAYMENT_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'			,type: 'int', allowBlank: false},
	    	{name: 'PAYMENT_NUM'		,text: '지급번호'		,type: 'string'},
	    	{name: 'CHANGE_BASIS_NUM'	,text: '<t:message code="system.label.purchase.purchaseslipno" default="매입전표번호"/>'	,type: 'string'},  	
	    	{name: 'BILL_NUM'			,text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'		,type: 'string'},  	 	
	    	{name: 'AMOUNT_I'			,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'		,type: 'uniPrice'},  	 	
	    	{name: 'VAT_AMOUNT_O'		,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		,type: 'uniPrice'},  	 	
	    	{name: 'SUM_O'				,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'		,type: 'uniPrice'},  	 	
	    	{name: 'PAYMENT_TYPE'		,text: '지급유형'		,type: 'string',comboType:'AU', comboCode:'YP10', allowBlank: false},  	 	
	    	{name: 'PAY_LOC_AMT'		,text: '지급액'		,type: 'uniPrice', allowBlank: false},  	 	
	    	{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			,type: 'string'}
			
		]  
	});		//End of Unilite.defineModel('Mpo030ukrvModel', {
	
	
	Unilite.defineModel('mpo030ukrvNOPAYModel', {	//미지급참조
	    fields: [
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},
	    	{name: 'CHANGE_BASIS_NUM'	,text: '<t:message code="system.label.purchase.purchaseslipno" default="매입전표번호"/>'	,type: 'string'},  	
	    	{name: 'CHANGE_BASIS_DATE'	,text: '전표일자'		,type: 'uniDate'},
	    	{name: 'BILL_NUM'			,text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'		,type: 'string'},
	    	{name: 'AMOUNT_I'			,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'		,type: 'uniPrice'},
	    	{name: 'VAT_AMOUNT_O'		,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		,type: 'uniPrice'},
	    	{name: 'SUM_O'				,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'		,type: 'uniPrice'},
	    	{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('mpo030ukrvMasterStore1',{
		model: 'Mpo030ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
	       		/*var records = masterGrid.getSelectedRecords();
				Ext.each(records,  function(record, index, records){
					masterForm.setValue('PAYMENT_NUM',record.get('PAYMENT_NUM'));
	           		masterForm.setValue('PAY_CUSTOM_CODE',record.get('PAY_CUSTOM_CODE'));
	           		masterForm.setValue('PAY_CUSTOM_NAME',record.get('PAY_CUSTOM_NAME'));
	           		masterForm.setValue('PAYMENT_PRSN',record.get('PAYMENT_PRSN'));
	           		masterForm.setValue('PAY_DIV_CODE',record.get('PAY_DIV_CODE'));
				});*/

           		
           		
           		if(directMasterStore1.getCount() > 0){
		           	masterForm.setValue('PAYMENT_NUM',directMasterStore1.data.items[0].get('PAYMENT_NUM'));
	           		masterForm.setValue('PAY_CUSTOM_CODE',directMasterStore1.data.items[0].get('PAY_CUSTOM_CODE'));
	           		masterForm.setValue('PAY_CUSTOM_NAME',directMasterStore1.data.items[0].get('CUSTOM_NAME'));
	           		masterForm.setValue('PAYMENT_PRSN',directMasterStore1.data.items[0].get('PAYMENT_PRSN'));
	           		masterForm.setValue('PAY_DIV_CODE',directMasterStore1.data.items[0].get('PAY_DIV_CODE'));
           		}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
			
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
				this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});		// End of var directMasterStore1 = Unilite.createStore('mpo030ukrvMasterStore1',{
	
	
	var noPayStore = Unilite.createStore('mpo030ukrvNoPayStore', {//미지급참조
		model: 'mpo030ukrvNOPAYModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'mpo030ukrvService.selectNoPay'                	
            }
        },
		listeners:{
        	load:function(store, records, successful, eOpts) {
				if(successful)	{
    			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
    			   var salesRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
    			   		console.log("store.items :", store.items);
    			   		console.log("records", records);
        			   	Ext.each(records, 
        			   		function(item, i)	{           			   								
	   							Ext.each(masterRecords.items, function(record, i)	{
	   								console.log("record :", record);
	   							
	   									if( (record.data['ITEM_CODE'] == item.data['ITEM_CODE']) 
	   											&& (record.data['CUSTOM_NAME'] == item.data['CUSTOM_NAME'])
	   									  ) 
	   									{
	   										salesRecords.push(item);
	   									}
	   							});		
        			   		});
        			   store.remove(salesRecords);
    			   }
        		}
        	}
        },
		loadStoreRecords: function()	{
			var param= noPaySearch.getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
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
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '지급일자',
				name: 'PAYMENT_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAYMENT_DATE', newValue);
					}
				}
	        },
			Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					textFieldWidth: 170, 
					allowBlank: false,
		            holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'),
											"PAYMENT_DATE": UniDate.getDbDateStr(masterForm.getValue('PAYMENT_DATE')).substring(0, 6),
											"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE')};
							
								mpo030ukrvService.checkBlanAmt(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										masterForm.setValue('BLAN_AMT', provider['BLAN_AMT']);
									}else{
										masterForm.setValue('BLAN_AMT', '');
									}
								})
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
				}),
			Unilite.popup('CUST', { 
					fieldLabel: '지급처', 
					valueFieldName: 'PAY_CUSTOM_CODE',
			   	 	textFieldName: 'PAY_CUSTOM_NAME',
					textFieldWidth: 170/*, 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_CODE', masterForm.getValue('CUST_CODE'));
								panelResult.setValue('CUST_NAME', masterForm.getValue('CUST_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult.setValue('CUST_CODE', '');
									panelResult.setValue('CUST_NAME', '');
						}
					}*/
				}),
			{
				fieldLabel: '지급담당',
				name:'PAYMENT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201'/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('', newValue);
					}
				}*/
			},{
				fieldLabel: '미지급잔액',
				name:'BLAN_AMT',
				xtype: 'uniNumberfield',
				readOnly:true
			},{
				fieldLabel: '지급번호',
				name:'PAYMENT_NUM',
				xtype: 'uniTextfield',
				readOnly:true
			},{
				fieldLabel: '지급사업장',
				name:'PAY_DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				readOnly:true
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '지급일자',
				name: 'PAYMENT_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('PAYMENT_DATE', newValue);
					}
				}
	        },
			Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					textFieldWidth: 170, 
					allowBlank: false,
		            holdable: 'hold',
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

    var noPaySearch = Unilite.createSearchForm('noPayForm', {//미지급참조
		layout: {type : 'uniTable', columns : 2},
		items :[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode
			},
			Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					textFieldWidth: 170
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				//startDate: UniDate.get('startOfMonth'),
				//endDate: UniDate.get('today'),
				width: 315
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
  			}
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('mpo030ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'noPayBtn',
					text: '미지급참조',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
								return false;
							}
						openNoPayWindow();
							noPaySearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
							noPaySearch.setValue('CHANGE_BASIS_DATE_TO',masterForm.getValue('PAYMENT_DATE'));
							noPaySearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
							noPaySearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
					}
				}]
			})
		}],  
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
        	{dataIndex:'COMP_CODE'						, width: 88 ,hidden:true},
        	{dataIndex:'DIV_CODE'						, width: 88 ,hidden:true},
        	{dataIndex:'PAYMENT_SEQ'					, width: 88 },
        	{dataIndex:'PAYMENT_NUM'					, width: 88 ,hidden:true},
        	{dataIndex:'CHANGE_BASIS_NUM'				, width: 88 },
        	{dataIndex:'BILL_NUM'						, width: 88 },
        	{dataIndex:'AMOUNT_I'						, width: 88 },
        	{dataIndex:'VAT_AMOUNT_O'					, width: 88 },
        	{dataIndex:'SUM_O'							, width: 88 },
        	{dataIndex:'PAYMENT_TYPE'					, width: 88 },
        	{dataIndex:'PAY_LOC_AMT'					, width: 88 },
        	{dataIndex:'REMARK'							, width: 88 }
        	
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        		if(e.record.phantom == false){
				if(rowIndex != beforeRowIndex){
					var records = masterGrid.getSelectedRecords();
				Ext.each(records,  function(record, index, records){
					masterForm.setValue('PAYMENT_NUM',record.get('PAYMENT_NUM'));
	           		masterForm.setValue('PAY_CUSTOM_CODE',record.get('PAY_CUSTOM_CODE'));
	           		masterForm.setValue('PAY_CUSTOM_NAME',record.get('CUSTOM_NAME'));
	           		masterForm.setValue('PAYMENT_PRSN',record.get('PAYMENT_PRSN'));
	           		masterForm.setValue('PAY_DIV_CODE',record.get('PAY_DIV_CODE'));
				})
				}
				beforeRowIndex = rowIndex;
        		}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['PAYMENT_SEQ','SUM_O'])){
						return false;
					}else{
						return true;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['PAYMENT_TYPE','PAY_LOC_AMT','REMARK'])){
						return true;
					}else{
						return false;
					}
				}
			}
		},
		setNoPayData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		//alert(grdRecord);
       		grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
       	    grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('CHANGE_BASIS_NUM'	, record['CHANGE_BASIS_NUM']);
			grdRecord.set('BILL_NUM'			, record['BILL_NUM']);
			grdRecord.set('AMOUNT_I'			, record['AMOUNT_I']);
			grdRecord.set('VAT_AMOUNT_O'		, record['VAT_AMOUNT_O']);
			grdRecord.set('SUM_O'				, record['SUM_O']);
		//	grdRecord.set('PAYMENT_TYPE'		, record['PAYMENT_TYPE']);
			grdRecord.set('PAY_LOC_AMT'			, record['PAY_LOC_AMT']);
			grdRecord.set('REMARK'				, record['REMARK']);
			
			
		}
    });		// End of masterGrid= Unilite.createGrid('mpo030ukrvGrid', {
    
	var noPayGrid = Unilite.createGrid('mpo030ukrvNoPayGrid', {//미지급참조
		layout: 'fit',
    	store: noPayStore,
    	uniOpt:{
            onLoadSelectFirst : false
        },
    	selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
        columns: [  
        	{dataIndex:'COMP_CODE'			, width: 88,hidden:true},
        	{dataIndex:'DIV_CODE'			, width: 88},
        	{dataIndex:'CHANGE_BASIS_NUM'	, width: 88},
        	{dataIndex:'CHANGE_BASIS_DATE'	, width: 88},
        	{dataIndex:'BILL_NUM'			, width: 88},
        	{dataIndex:'AMOUNT_I'			, width: 88},
        	{dataIndex:'VAT_AMOUNT_O'		, width: 88},
        	{dataIndex:'SUM_O'				, width: 88},
        	{dataIndex:'REMARK'				, width: 88}
		],
		listeners: {	
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_REQ_Q'])){
					return true;
				}else{
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
          	var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setNoPayData(record.data);								        
		    }); 
			this.getStore().remove(records);
			
          			
		}
	});
    
    
     function openNoPayWindow() {    		//미지급참조
		if(!referNoPayWindow) {
			referNoPayWindow = Ext.create('widget.uniDetailWindow', {
                title: '미지급참조',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [noPaySearch, noPayGrid],
                tbar: ['->',
					{	
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							if(!UniAppManager.app.checkForNewDetail2()){
								return false;
							}else if(UniAppManager.app.checkForNewDetail2()){
								noPayStore.loadStoreRecords();
							}
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '적용',
						handler: function() {
							noPayGrid.returnData();
							//record.set('DVRY_DATE',UniDate.get('today'));
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							noPayGrid.returnData();
							referNoPayWindow.hide();
							noPayGrid.reset();
							noPaySearch.clearForm();
					//		directMasterStore1.loadStoreRecords();
							//record.set('DVRY_DATE',UniDate.get('today'));
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							noPayGrid.reset();
							noPaySearch.clearForm();
							referNoPayWindow.hide();
						},
						disabled: false
					}
				],
                listeners: {
					beforehide: function(me, eOpt)	{
	    							//noPaySearch.clearForm();
	    							//otherorderGrid,reset();
	    			},
	    			beforeclose: function( panel, eOpts )	{
									//noPaySearch.clearForm();
	    							//otherorderGrid,reset();
	    			},
	    			beforeshow: function ( me, eOpts )	{
	    				//noPayStore.loadStoreRecords();
	    	//			noPaySearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
	    	//			noPaySearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
	    	//			noPaySearch.setValue('ITEM_LEVEL1',masterForm.getValue('ITEM_LEVEL1'));
	    	//			noPaySearch.setValue('ITEM_LEVEL2',masterForm.getValue('ITEM_LEVEL2'));
	    			}
                }
			})
		}
		referNoPayWindow.show();
	}

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
		id: 'mpo030ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('PAYMENT_DATE',UniDate.get('today'));
			panelResult.setValue('PAYMENT_DATE',UniDate.get('today'));
			masterForm.setValue('PAY_DIV_CODE',UserInfo.divCode);
		//	masterForm.setValue('ORDER_REQ_DATE',UniDate.get('today'));
		//	panelResult.setValue('ORDER_REQ_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				
				directMasterStore1.loadStoreRecords();
				beforeRowIndex = -1;
				/*
				masterGrid.getStore().load({
				success: function()	{
						masterForm.setAllFieldsReadOnly(true)
//						if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') 	{
//							checkDraftStatus = true;							
//						}
						masterForm.uniOpt.inLoading=false;
					
					masterForm.setValue('PAYMENT_NUM',directMasterStore1.data.items[0].get('PAYMENT_NUM'));
	           		masterForm.setValue('PAY_CUSTOM_CODE',directMasterStore1.data.items[0].get('PAY_CUSTOM_CODE'));
	           		masterForm.setValue('PAY_CUSTOM_NAME',directMasterStore1.data.items[0].get('CUSTOM_NAME'));
	           		masterForm.setValue('PAYMENT_PRSN',directMasterStore1.data.items[0].get('PAYMENT_PRSN'));
	           		masterForm.setValue('PAY_DIV_CODE',directMasterStore1.data.items[0].get('PAY_DIV_CODE'));
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				
				});*/
				
				
				
			}
			
			
			
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var divCode = masterForm.getValue('DIV_CODE');
				 var seq = directMasterStore1.max('PAYMENT_SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	 var paymentType ='A1';
            	 
            	 var r = {
					PAYMENT_SEQ: seq,
					DIV_CODE: divCode,
					PAYMENT_TYPE: paymentType
		        };
				masterGrid.createRow(r,seq-2);
				masterForm.setAllFieldsReadOnly(false);
				panelResult.setAllFieldsReadOnly(false);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			if(!directMasterStore1.isDirty())	{
				if(masterForm.isDirty())	{
					masterForm.saveForm();
				}
			}else {
				directMasterStore1.saveStore();
			}
			
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true), panelResult.setAllFieldsReadOnly(true);
        },
        checkForNewDetail2:function() { 
			return noPaySearch.setAllFieldsReadOnly(true);

        }
        
		
		
	});	
		Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PAY_LOC_AMT":
				if(record.get('SUM_O') > 0){
					if(newValue > record.get('SUM_O')){
						rv='지급액이 합계금액보다 큽니다.';
						break;
					}
				}
				
				//	masterForm.setValue('BLAN_AMT', record.get('SUM_O') - newValue);
			}
				return rv;
						}
			});	
			
	
};
</script>
