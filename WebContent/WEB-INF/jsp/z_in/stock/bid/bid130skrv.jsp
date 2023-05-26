<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bid130skrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="bid130skrv" />          <!-- 사업장 -->   
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고 -->
   <t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell {
background-color: #fed9fe;
}
</style>
<script type="text/javascript" >

var gsWhCode = '';		//창고코드

function appMain() {

	Unilite.defineModel('Bid130skrvModel', {
		fields: [
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'	,type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.inventory.division" default="사업장"/>'	,type: 'string',comboType:'BOR120'},
			{name: 'WH_NAME'				,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'	,type: 'string'}, 
			{name: 'WH_CODE'				,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('whList')}, 
//			{name: '', 	text: '창고명', 	type: 'string'}, 
			
			{name: 'ITEM_LEVEL1'			,text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>'	,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
            {name: 'ITEM_LEVEL2'			,text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>'	,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
            {name: 'ITEM_LEVEL3'			,text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>'	,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE'				,text: '품번'		,type: 'string'}, 
			{name: 'ITEM_NAME'				,text: '품명'		,type: 'string'}, 
			{name: 'PURCHASE_CUSTOM_CODE'	,text: '매입사'	,type: 'string'}, 
			{name: 'CUSTOM_NAME'			,text: '매입사명'	,type: 'string'}, 
			
			{name: 'SALE_BASIS_P'			,text: '판매가'	,type: 'uniUnitPrice'},
			{name: 'PURCHASE_P'				,text: '매입가'	,type: 'uniUnitPrice'}, 
			{name: 'PURCHASE_RATE'			,text: '매입률(%)',type: 'uniER'}, 
			{name: 'STOCK_Q'				,text: '현재고'	,type: 'uniQty'},
			{name: 'STOCK_I'				,text: '재고금액'	,type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Bid130skrvModel', {
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('bid130skrvMasterStore1',{
		model: 'Bid130skrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: false,         // 수정 모드 사용 
			deletable:false,         // 삭제 가능 여부 
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {         
					read: 'bid130skrvService.selectList'                   
				}
			},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField:'WH_NAME'
	});//End of var directMasterStore1 = Unilite.createStore('bid130skrvMasterStore1',{

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        	panelSearch.down('#itemSearchForm').setWidth(388);
	        },
	        expand: function() {
	        	panelResult.hide();	
	        	panelSearch.down('#itemSearchForm').setWidth(245);
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>', 
				name:'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
        			xtype: 'uniTextfield',
		            name: 'ITEM_CODE',  		
	    			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_CODE', newValue);
						}
					}
	    		},{
        			xtype: 'uniTextfield',
		            name: 'ITEM_NAME',  		
	    			fieldLabel: '<t:message code="system.label.inventory.itemname" default="품목명"/>' ,
		        	width: 300,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_NAME', newValue);
						}
					}
	    		},
				Unilite.popup('CUST', {
					fieldLabel: '거래처',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
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
				}),
				{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}				
			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '현재고 조건',					            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'INCLUSION',
						checked: true  
					},{
						boxLabel : '0만조회', 
						width: 70,
						inputValue: 'Y',
						name: 'INCLUSION'
					},{
						boxLabel : '미포함', 
						width: 55,
						inputValue: 'N',
						name: 'INCLUSION'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('INCLUSION').setValue(newValue.INCLUSION);
						}
					}
			},{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>', 
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
			        parentNames:['TXTLV_L1','TXTLV_L2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L3', newValue);
						}
					}
				}
			]                         
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					var field2 = panelSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>', 
				name:'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{		
    			xtype: 'uniTextfield',
				name: 'ITEM_CODE',  		
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>' ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_CODE', newValue);
					}
				}
			},{
    			xtype: 'uniTextfield',
	            name: 'ITEM_NAME',  		
    			fieldLabel: '<t:message code="system.label.inventory.itemname" default="품목명"/>' ,
		        width: 300,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_NAME', newValue);
					}
				}
    		},
			Unilite.popup('CUST', {
					fieldLabel: '거래처',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
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
					fieldLabel: '고객분류', 
					name: 'AGENT_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AGENT_TYPE', newValue);
						}
					}
			  },{
					xtype: 'radiogroup',		            		
					fieldLabel: '현재고 조건',					            		
					id: 'rdoSelect2',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'INCLUSION',
						checked: true  
					},{
						boxLabel : '0만조회', 
						width: 70,
						inputValue: 'Y',
						name: 'INCLUSION'
					},{
						boxLabel : '미포함', 
						width: 55,
						inputValue: 'N',
						name: 'INCLUSION'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelSearch.getField('INCLUSION').setValue(newValue.INCLUSION);
						}
					}
			},{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>', 
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
			        parentNames:['TXTLV_L1','TXTLV_L2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
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
	var masterGrid = Unilite.createGrid('bid130skrvGrid', {
       // for tab       
		//layout: 'fit',
		excelTitle: '부서별 현재고 조회',
		region:'center',
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 80, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 80, hidden: true},
			{dataIndex: 'WH_CODE'				, width: 100, align:'center', align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            },
			{dataIndex: 'WH_NAME'				, width: 85, align:'center'},
			{dataIndex: 'ITEM_LEVEL1'			, width: 120, align:'center'},             
            {dataIndex: 'ITEM_LEVEL2'			, width: 100, align:'center'},
            {dataIndex: 'ITEM_LEVEL3'			, width: 100, align:'center'},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 250},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'	, width: 60},
			{dataIndex: 'CUSTOM_NAME'			, width: 200},
			
			{dataIndex: 'SALE_BASIS_P'			, width: 80,summaryType: 'average'},
			{dataIndex: 'PURCHASE_P'			, width: 80,summaryType: 'average'},
			{dataIndex: 'PURCHASE_RATE'			, width: 80},
			{dataIndex: 'STOCK_Q'				, width: 80,summaryType: 'sum',tdCls:'x-change-cell'},
			{dataIndex: 'STOCK_I'				, width: 120,summaryType: 'sum',tdCls:'x-change-cell'}
		] 
	});//End of var masterGrid = Unilite.createGrid('bid130skrvGrid', {   

	Unilite.Main( {
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
		id: 'bid130skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			bid130skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {  
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords(); 
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};


</script>