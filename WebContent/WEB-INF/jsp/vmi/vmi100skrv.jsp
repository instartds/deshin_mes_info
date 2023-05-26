<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="vmi100skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="vmi100skrv"  /> 			<!-- 사업장 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #fed9fe;
}
</style>

<script type="text/javascript" >
var PGM_TITLE = "VMI재고현황조회(vmi100skrv)";

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('vmi100skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'				, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
	    	{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
	    	{name: 'DEPT_CODE'				, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'			, type: 'string'},
	    	{name: 'DEPT_NAME'				, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name: 'WH_CODE'				, text: '창고코드'			, type: 'string'},
	    	{name: 'WH_NAME'				, text: '창고명'			, type: 'string'},
	    	{name: 'STOCK_Q'				, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			, type: 'uniQty'},
	    	{name: 'BEFORE_SIX'				, text: '오늘-6'			, type: 'uniQty'},
	    	{name: 'BEFORE_FIVE'			, text: '오늘-5'			, type: 'uniQty'},
	    	{name: 'BEFORE_FOUR'			, text: '오늘-4'			, type: 'uniQty'},
	    	{name: 'BEFROE_THREE'			, text: '오늘-3'			, type: 'uniQty'},
	    	{name: 'BEFORE_TWO'				, text: '오늘-2'			, type: 'uniQty'},
	    	{name: 'BEFORE_ONE'				, text: '오늘-1'			, type: 'uniQty'},
	    	{name: 'TO_QTY'					, text: '오늘판매량'		, type: 'uniQty'}
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('vmi100skrvMasterStore',{
			model: 'vmi100skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'vmi100skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners : {
				load: function(store, records) {
					
					
				}
			}
	});		// End of var MasterStore 
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
	    		fieldLabel: '기준일자',
		 		xtype: 'uniDatefield',
        		allowBlank: false,
		 		name: 'TO_DATE',
		 		value: UniDate.get('today'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TO_DATE', newValue);
						}
					}
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				readOnly : true
			}),{
            	fieldLabel: '판매된 품목',
            	name: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FLOOR', newValue);
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
	    		fieldLabel: '기준일자',
		 		xtype: 'uniDatefield',
        		allowBlank: false,
		 		name: 'TO_DATE',
		 		value: UniDate.get('today'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TO_DATE', newValue);
						}
					}
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				readOnly : true
			}),{
            	fieldLabel: '판매된 품목',
            	name: 'FLOOR',
				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 125,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FLOOR', newValue);
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('vmi100skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex:'COMP_CODE'	 		, width: 100 , hidden:true ,locked:true},
        	{dataIndex:'DIV_CODE'	 		, width: 100 , hidden:true ,locked:true},
			{dataIndex:'ITEM_CODE'	 	, width: 120 ,locked:true
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
            },
			{dataIndex:'ITEM_NAME'	 			, width: 280 ,locked:true},
			{dataIndex:'STOCK_UNIT'				, width: 66  ,locked:true},
			{dataIndex:'DEPT_CODE'		 		, width: 100 ,hidden:true ,locked:true},
			{dataIndex:'DEPT_NAME'				, width: 100 ,locked:true},
			{dataIndex:'WH_CODE'		 		, width: 100 ,hidden:true ,locked:true},
			{dataIndex:'WH_NAME'				, width: 100 ,locked:true},
			{dataIndex:'STOCK_Q'		 		, width: 100 , summaryType: 'sum' ,locked:true , tdCls:'x-change-cell'},
			{dataIndex:'BEFORE_SIX'		 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'BEFORE_FIVE'	 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'BEFORE_FOUR'	 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'BEFROE_THREE'	 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'BEFORE_TWO'		 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'BEFORE_ONE'		 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'TO_QTY'			 		, width: 100 , summaryType: 'sum'}
			
		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'vmi100skrvApp',
	    uniOpt: {
	    	showToolbar: true,
	    	isManual : false
	    },
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			panelResult.setValue('CUSTOM_CODE',UserInfo.customCode);
			panelSearch.setValue('CUSTOM_CODE',UserInfo.customCode);
			
			panelResult.setValue('CUSTOM_NAME',UserInfo.customName);
			panelSearch.setValue('CUSTOM_NAME',UserInfo.customName);
			
			UniAppManager.setToolbarButtons('save',false);
			
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}

			masterGrid.getStore().loadStoreRecords();
			
			var date_six = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-6});
			var date_five = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-5});
			var date_four = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-4});
			var date_three = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-3});
			var date_two = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-2});
			var date_one = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-1});
			var date = UniDate.add(panelSearch.getValue('TO_DATE'), {days:-0});
			
			//if(records.length > 0){
				
				masterGrid.getColumn('BEFORE_SIX').setText(Ext.Date.format(date_six, 'Y.m.d'));
				masterGrid.getColumn('BEFORE_FIVE').setText(Ext.Date.format(date_five, 'Y.m.d'));
				masterGrid.getColumn('BEFORE_FOUR').setText(Ext.Date.format(date_four, 'Y.m.d'));
				masterGrid.getColumn('BEFROE_THREE').setText(Ext.Date.format(date_three, 'Y.m.d'));
				masterGrid.getColumn('BEFORE_TWO').setText(Ext.Date.format(date_two, 'Y.m.d'));
				masterGrid.getColumn('BEFORE_ONE').setText(Ext.Date.format(date_one, 'Y.m.d'));
				masterGrid.getColumn('TO_QTY').setText(Ext.Date.format(date, 'Y.m.d'));		
			//}
			
		},onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
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
