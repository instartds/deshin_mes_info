<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp500skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 --> 	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mrp500skrvModel', {
	    fields: [  	  
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},
	    	{name: 'SPEC'					,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
	    	{name: 'PAB_STOCK_Q'			,text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'		,type: 'uniQty'},
	    	{name: 'SAFETY_STOCK_Q'			,text: '<t:message code="system.label.purchase.safetystockqty" default="안전재고량"/>'		,type: 'uniQty'},
	    	{name: 'STOCK_Q'				,text: '<t:message code="system.label.purchase.inventoryqty" default="재고량"/>'		,type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q'	   		,text: '<t:message code="system.label.purchase.gooditemqty" default="양품량"/>'		,type: 'uniQty'},
	    	{name: 'BAD_STOCK_Q'	   		,text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'		,type: 'uniQty'},
	    	{name: 'INSTOCK_PLAN_Q'	   		,text: '<t:message code="system.label.purchase.receiptplannedqty" default="입고예정량"/>'		,type: 'uniQty'},
	    	{name: 'INSTOCK_PO_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		,type: 'uniQty'},
	    	{name: 'INSTOCK_IMP_Q'	   		,text: '<t:message code="system.label.purchase.importqty" default="수입량"/>'		,type: 'uniQty'},
	    	{name: 'INSTOCK_PDT_Q'	   		,text: '<t:message code="system.label.purchase.productionqty" default="생산량"/>'		,type: 'uniQty'},
	    	{name: 'OUTSTOCK_PLAN_Q'	   	,text: '<t:message code="system.label.purchase.issueresevationqty" default="출고예정량"/>'		,type: 'uniQty'},
	    	{name: 'OUTSTOCK_SO_Q'	   		,text: '<t:message code="system.label.purchase.soqty" default="수주량"/>'		,type: 'uniQty'},
	    	{name: 'OUTSTOCK_EXP_Q'	   		,text: '<t:message code="system.label.purchase.exportqty" default="수출량"/>'		,type: 'uniQty'},
	    	{name: 'OUTSTOCK_PDT_Q'	   		,text: '<t:message code="system.label.purchase.productionqty" default="생산량"/>'		,type: 'uniQty'},
	    	{name: 'OUTSTOCK_SUB_Q'	   		,text: '<t:message code="system.label.purchase.subcontractissueqty" default="외주출고량"/>'		,type: 'uniQty'},
	    	{name: 'SUBCON_STOCK_Q'	   		,text: '<t:message code="system.label.purchase.inventoryqty" default="재고량"/>'		,type: 'uniQty'},
	    	{name: 'SUBCON_GOOD_STOCK_Q'	,text: '<t:message code="system.label.purchase.gooditemqty" default="양품량"/>'		,type: 'uniQty'},
	    	{name: 'SUBCON_BAD_STOCK_Q'		,text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'		,type: 'uniQty'}	    			
		]
	});		// end of Unilite.defineModel('Mrp500skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrp500skrvMasterStore1',{
			model: 'Mrp500skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrp500skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param = Ext.getCmp('searchForm').getValues();
				param.STOCK_CONDITION = panelSearch.getField("STOCK_CONDITION").getValue().rdoSelect;
				if(panelSearch.getField("STOCK_CONDITION").getValue().rdoSelect == "C" && param.AVAIL_STOCK_QTY == "") {
					param.AVAIL_STOCK_QTY = "1";
				}
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: ''
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
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
	        	comboType:'BOR120', 
	        	allowBlank:false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{
		        fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        name:'ITEM_ACCOUNT', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'B020',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
	        }, {
		        fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
		        name:'BASE_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank:false,
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASE_DATE', newValue);
					}
				}
			}, 
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '~',
				valueFieldName: 'ITEM_CODE2', 
				textFieldName: 'ITEM_NAME2', 
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE2', newValue);
							panelResult.setValue('ITEM_CODE2', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME2', '');
								panelResult.setValue('ITEM_NAME2', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME2', newValue);
							panelResult.setValue('ITEM_NAME2', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE2', '');
								panelResult.setValue('ITEM_CODE2', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype: 'container', padding: 1, margin: 0, 
				layout: {type:'uniTable', columns:2},
				items: [{ 
							xtype: 'radiogroup',
							fieldLabel: '<t:message code="system.label.purchase.condition" default="조건"/>',
							id: 'rdoSelectS',
							name: 'STOCK_CONDITION',
							items: [{
								boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
								width: 50,
								name: 'rdoSelect',
								inputValue: 'A',
								checked: true
							}, {
								boxLabel: '부족',
								width: 50,
								inputValue: 'B',
								name: 'rdoSelect'
							}, {
								boxLabel: '여유',
								width: 45,
								inputValue: 'C',
								name: 'rdoSelect'
							}],
							listeners: {
								change: function (field, newValue, oldValue, eOpts) {
									panelResult.getField("STOCK_CONDITION").setValue(newValue);
									
									if(newValue.rdoSelect == "C") {
										panelSearch.getField("AVAIL_STOCK_QTY").setReadOnly(false);
									}
									else {
										panelSearch.getField("AVAIL_STOCK_QTY").setReadOnly(true);
									}
								}
							}
						},{
							fieldLabel: '',
							xtype: 'uniNumberfield',
							name: 'AVAIL_STOCK_QTY',
							readOnly: true,
							width: 50,
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {
									panelResult.setValue('AVAIL_STOCK_QTY', newValue);
								}
							}
						}
	    		  ]
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
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120', 
	        	allowBlank:false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{
		        fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        name:'ITEM_ACCOUNT', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'B020',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
	        }, {
		        fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
		        name:'BASE_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank:false,
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BASE_DATE', newValue);
					}
				}
			}, 
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '~',
				valueFieldName: 'ITEM_CODE2', 
				textFieldName: 'ITEM_NAME2', 
				textFieldWidth: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE2', newValue);
							panelResult.setValue('ITEM_CODE2', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME2', '');
								panelResult.setValue('ITEM_NAME2', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME2', newValue);
							panelResult.setValue('ITEM_NAME2', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE2', '');
								panelResult.setValue('ITEM_CODE2', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype: 'container', padding: 1, margin: 0, 
				layout: {type:'uniTable', columns:2},
				items: [{ 
							xtype: 'radiogroup',
							fieldLabel: '<t:message code="system.label.purchase.condition" default="조건"/>',
							id: 'rdoSelectR',
							name: 'STOCK_CONDITION',
							items: [{
								boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
								width: 70,
								name: 'rdoSelect',
								inputValue: 'A',
								checked: true
							}, {
								boxLabel: '부족',
								width: 70,
								inputValue: 'B',
								name: 'rdoSelect'
							}, {
								boxLabel: '여유',
								width: 45,
								inputValue: 'C',
								name: 'rdoSelect'
							}],
							listeners: {
								change: function (field, newValue, oldValue, eOpts) {
									panelSearch.getField("STOCK_CONDITION").setValue(newValue);
									
									if(newValue.rdoSelect == "C") {
										panelResult.getField("AVAIL_STOCK_QTY").setReadOnly(false);
									}
									else {
										panelResult.getField("AVAIL_STOCK_QTY").setReadOnly(true);
									}
								}
							}
						},{
							fieldLabel: '',
							xtype: 'uniNumberfield',
							name: 'AVAIL_STOCK_QTY',
							readOnly: true,
							width: 50,
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {
									panelSearch.setValue('AVAIL_STOCK_QTY', newValue);
								}
							}
						}
	    		  ]
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrp500skrvGrid1', {
    	// for tab    	
        layout: 'fit',
        region: 'center',
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
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: false 
        },
    	    {id: 'masterGridTotal', 	
    	    ftype: 'uniSummary',
    	    showSummaryRow: false} 
    	],
    	store: directMasterStore1,
        columns:  [  
        	{ dataIndex: 'ITEM_CODE'		     ,   width: 120},
        	{ dataIndex: 'ITEM_NAME'		     ,   width: 146},
        	{ dataIndex: 'SPEC'			     	 ,   width: 133},
        	{ dataIndex: 'PAB_STOCK_Q'			 ,   width: 120},
        	{ dataIndex: 'SAFETY_STOCK_Q'		 ,   width: 120},
        { text:'<t:message code="system.label.purchase.onhandstock" default="현재고"/>',
        columns: [
			{ dataIndex: 'STOCK_Q'				 ,   width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	   	 	 ,   width: 100},
			{ dataIndex: 'BAD_STOCK_Q'	   		 ,   width: 100}
		]}
		,{ text:'<t:message code="system.label.purchase.receiptplanned" default="입고예정"/>',
        columns: [
			{ dataIndex: 'INSTOCK_PLAN_Q'	   	 ,   width: 100},
			{ dataIndex: 'INSTOCK_PO_Q'	     	 ,   width: 100},
			{ dataIndex: 'INSTOCK_IMP_Q'	     ,   width: 100},
			{ dataIndex: 'INSTOCK_PDT_Q'	     ,   width: 100}
		]}
		,{ text:'<t:message code="system.label.purchase.issueresevation" default="출고예정"/>',
        columns:  [
			{ dataIndex: 'OUTSTOCK_PLAN_Q'	   	 ,   width: 100},
			{ dataIndex: 'OUTSTOCK_SO_Q'	   	 ,   width: 100},
			{ dataIndex: 'OUTSTOCK_EXP_Q'	   	 ,   width: 100},
			{ dataIndex: 'OUTSTOCK_PDT_Q'	   	 ,   width: 100},
			{ dataIndex: 'OUTSTOCK_SUB_Q'	   	 ,   width: 100}
		]}
		,{ text:'<t:message code="system.label.purchase.substock" default="외주재고"/>',
        columns:  [
			{ dataIndex: 'SUBCON_STOCK_Q'	   	 ,   width: 100},
			{ dataIndex: 'SUBCON_GOOD_STOCK_Q'	 ,   width: 100},
			{ dataIndex: 'SUBCON_BAD_STOCK_Q'	 ,   width: 100}
		]}
		] 
    });		// end of var masterGrid = Unilite.createGrid('mrp500skrvGrid1', {   
	
	
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'mrp500skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AVAIL_STOCK_QTY',1);
			panelResult.setValue('AVAIL_STOCK_QTY',1);

			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

};


</script>
