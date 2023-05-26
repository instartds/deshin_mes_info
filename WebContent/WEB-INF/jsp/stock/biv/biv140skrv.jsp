<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv140skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="biv140skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 --> 
	//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore comboType="O" storeId="whList" />     <!--창고(전체) -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsSumTypeLot: 	'${gsSumTypeLot}',
	gsSumTypeCell: 	'${gsSumTypeCell}'
};

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Biv140skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE',			text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',		type:'string'},
	    	{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
	    	{name: 'WH_CODE',			text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type:'string'},
	    	{name: 'COUNT_DATE',		text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',		type:'uniDate'},
	    	{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.large" default="대"/>',			type:'string'},
	    	{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middle" default="중"/>',			type:'string'},
	    	{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.small" default="소"/>',			type:'string'},
	    	{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',		type:'string'},
	    	{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',		type:'string'},
	    	{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
	    	{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type:'string', displayField: 'value'},
	    	{name: 'WH_CELL_CODE',		text: '<t:message code="system.label.inventory.warehousecellcode" default="창고Cell코드"/>',	type:'string'},
	    	{name: 'WH_CELL_NAME',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		type:'string'},
	    	{name: 'LOT_NO',			text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',		type:'string'},
	    	{name: 'GOOD_STOCK_BOOK_Q',	text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
	    	{name: 'BAD_STOCK_BOOK_Q',	text: '<t:message code="system.label.inventory.defect" default="불량"/>',			type:'uniQty'},
	    	{name: 'LOCATION',			text: 'Location',	type:'string'},
	    	{name: 'COUNT_CONT_DATE',	text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>',		type:'uniDate'},
	    	{name: 'GOOD_STOCK_Q',	text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
	    	{name: 'BAD_STOCK_Q',	text: '<t:message code="system.label.inventory.defect" default="불량"/>',			type:'uniQty'},
	    	{name: 'OVER_GOOD_STOCK_Q',	text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
	    	{name: 'OVER_BAD_STOCK_Q',	text: '<t:message code="system.label.inventory.defect" default="불량"/>',			type:'uniQty'},
	    	{name: 'TAG_NO',	text: 'TAG NO',			type:'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biv140skrvMasterStore1',{
		model: 'Biv140skrvModel',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv140skrvService.selectList'}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			/*var cOUNTdATE = panelSearch.getValue('COUNT_DATE').replace('.','');
			param.COUNT_DATE = cOUNTdATE;*/
			console.log( param );
			this.load({params : param});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
           		if(records[0].get('REF_CODE1') == 'Y'){
           			masterGrid.getColumn("WH_CELL_CODE").setHidden(false);  
           			masterGrid.getColumn("WH_CELL_NAME").setHidden(false);  
           		}else{
           			masterGrid.getColumn("WH_CELL_CODE").setHidden(true);  
       			    masterGrid.getColumn("WH_CELL_NAME").setHidden(true); 
       			}
           	}
		},
		groupField: 'CUSTOM_NAME'
	});
	

	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
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
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001',
					child:'WH_CODE',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},Unilite.popup('COUNT_DATE', { 
					fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
					fieldStyle: 'popup-align: center;', 
					textFieldWidth: 150, 
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								panelSearch.setValue('COUNT_DATE', countDATE);
								panelResult.setValue('COUNT_DATE', panelSearch.getValue('COUNT_DATE'));
								panelSearch.setValue('WH_CODE', records[0]['WH_CODE']);
								panelResult.setValue('WH_CODE', panelSearch.getValue('WH_CODE'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('COUNT_DATE', '');
							panelResult.setValue('WH_CODE', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WH_CODE': panelSearch.getValue('WH_CODE')});
						}
					} 
				}),{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
//					autoPopup: false,
					validateBlank: false,
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
				})
			]
		},{
			title:'<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'ITEM_LEVEL2'
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3'
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
			        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
			        levelType:'ITEM'
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
						//	this.mask();		    
		   				}
			  		} else {
	  					this.unmask();
	  				}
					return r;
	  			}
	});//End of var panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				comboCode:'B001',
				child:'WH_CODE',
				value: '01',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('COUNT_DATE', { 
			fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>', 
			fieldStyle: 'popup-align: center;',
			textFieldWidth: 150, 
			allowBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
						countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
						panelResult.setValue('COUNT_DATE', countDATE);
						panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
						panelResult.setValue('WH_CODE', records[0]['WH_CODE']);
						panelSearch.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('COUNT_DATE', '');
					panelSearch.setValue('WH_CODE', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					popup.setExtParam({'WH_CODE': panelResult.getValue('WH_CODE')});
				}
			}
		}),{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
//				autoPopup: true,
				validateBlank: false,
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
			})
		]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv140skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	store: directMasterStore1, 
        features: [ 
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],                                     
		columns:  [ {dataIndex: 'COMP_CODE', 		width:50, hidden:true},
        			{dataIndex: 'DIV_CODE', 		width:50, hidden:true},
        			{dataIndex: 'WH_CODE', 			width:50, hidden:true},
        			{dataIndex: 'COUNT_DATE', 		width:50, hidden:true},
        			{dataIndex: 'ITEM_ACCOUNT', 	width:120},
        			{text:'<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
           				columns:[ 
							{dataIndex:'ITEM_LEVEL1', width:140},
							{dataIndex:'ITEM_LEVEL2', width:140},
							{dataIndex:'ITEM_LEVEL3', width:140}
                    	]
           			},
           			{dataIndex: 'ITEM_CODE',      width:140},
        			{dataIndex: 'ITEM_NAME',      width:133},
        			{dataIndex: 'SPEC',      	  width:150},
        			{dataIndex: 'STOCK_UNIT',     width:66, displayField: 'value'},
        			{dataIndex: 'WH_CELL_CODE',   width:110,  hidden:true},
        			{dataIndex: 'WH_CELL_NAME',   width:100, hidden:true},
        			{dataIndex: 'LOT_NO',      	  width:100},
        			{ 
						text:'<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
           				columns:[ 
							{dataIndex:'GOOD_STOCK_BOOK_Q', width:80},
							{dataIndex:'BAD_STOCK_BOOK_Q',  width:80}
                    	]
           			 },
           			{ 
 						text:'<t:message code="system.label.inventory.stockcountingqty" default="실사수량"/>',
            				columns:[ 
 							{dataIndex:'GOOD_STOCK_Q', width:80},
 							{dataIndex:'BAD_STOCK_Q',  width:80}
                     	]
            			 },
            			 { 
     						text:'<t:message code="system.label.inventory.shortageqty" default="과부족량"/>',
                				columns:[ 
     							{dataIndex:'OVER_GOOD_STOCK_Q', width:80},
     							{dataIndex:'OVER_BAD_STOCK_Q',  width:80}
                         	]
                			 },
        			{dataIndex: 'LOCATION',			width:80},
        			{dataIndex: 'COUNT_CONT_DATE',  width:80, hidden:true},
        			{dataIndex: 'TAG_NO',  width:80}
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
		},
			panelSearch  	
		],
		id  : 'biv140skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewNormal = masterGrid.getView();
			}
			UniAppManager.setToolbarButtons('reset', true); 	
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			panelSearch.getField('WH_CODE').focus();
			panelResult.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

};


</script>
