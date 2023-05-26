<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv121skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="biv121skrv"/> 					<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 						<!-- 품목계정 --> 
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>				<!-- 창고   -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
</t:appConfig>
<style type="text/css">

.x-change-cell1 {			/* 중분류 소계  Class == 7  */
background-color: #ffddb4;
}

.x-change-cell2 {			/* 대분류 소계 Class == 9	*/
background-color: #fed9fe;
}

.x-change-cell3 {			/* 창고별 소계 Class == 11 */
background-color: #fcfac5;
}

.x-change-cell4 {			/* 총계 Class == 15 */
background-color: #E4F7BA;
}

.x-change-cell5 {			/* ???? */
background-color: #FAF4C0;
}


</style>
<script type="text/javascript" >


function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('biv121skrvModel', {
	    fields: [
	    	{name: 'CLASS',					text: '구분',					type:'string'},
	    	{name: 'COMP_CODE',				text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',				type:'string'},
	    	{name: 'DIV_CODE',				text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type:'string'},
	    	{name: 'WH_CODE',				text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type:'string'},
	    	{name: 'WH_NAME',				text: '창고명',				    type:'string'},
	    	/* 분류코드 */
	    	{name: 'ITEM_LEVEL1',			text: '대분류코드',				type:'string'},
	    	{name: 'ITEM_LEVEL2',			text: '중분류코드',				type:'string'},
	    	{name: 'ITEM_LEVEL3',			text: '소분류코드',				type:'string'},
	    	/* 분류명 */
	    	{name: 'LEVEL1_NAME',			text: '대분류명',				type:'string'},
	    	{name: 'LEVEL2_NAME',			text: '중분류명',				type:'string'},
	    	{name: 'LEVEL3_NAME',			text: '소분류명',				type:'string'},
	    	{name: 'SPEC',					text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type:'string'},
	    	{name: 'STOCK_UNIT',			text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',				type:'string', displayField: 'value'},
	    	{name: 'WH_CELL_CODE',			text: '창고셀코드',				type:'string'},
	    	{name: 'WH_CELL_NAME',			text: '창고셀명',				type:'string'},
	    	{name: 'LOT_NO',				text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				    type:'string'},
	    	
	    	{name: 'GOOD_STOCK_BOOK_Q',		text: '재고조사 전 양품수량',	type:'uniQty'},
	    	{name: 'BAD_STOCK_BOOK_Q',		text: '재고조사 전 불량수량',	type:'uniQty'},
	    	{name: 'STOCK_BOOK_I',			text: '재고조사 전 재고금액',	type:'uniPrice'},
	    	
	    	{name: 'GOOD_STOCK_Q',			text: '재고조사 후 양품수량',	type:'uniQty'},
	    	{name: 'BAD_STOCK_Q',			text: '재고조사 후 불량수량',	type:'uniQty'},
	    	{name: 'STOCK_I',				text: '재고조사 후 재고금액',	type:'uniPrice'},
	    	
	    	{name: 'GOOD_CAL_Q',			text: 'LOSS 양품수량',			type:'uniQty'},
	    	{name: 'BAD_CAL_Q',				text: 'LOSS 불량수량',			type:'uniQty'},
	    	{name: 'STOCK_CAL_I',			text: 'LOSS 재고금액',			type:'uniPrice'},
	    	
	    	{name: 'SELL_TEST',				text: '판매금액(추후에 추가)',	type:'uniPrice'},
	    	{name: 'SELL_TEST1',			text: '판매금액(추후에 추가)',	type:'uniPrice'}

		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biv121skrvMasterStore1',{
		model: 'biv121skrvModel',
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
			api: {read: 'biv121skrvService.selectList'}
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
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
				else{
					UniAppManager.setToolbarButtons(['print'], false);
				}
			}
		}
	});
	

	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',         
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
			title: '기본정보', 	
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
					value: UserInfo.divCode,
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},Unilite.popup('COUNT_DATE', { 
					fieldLabel: '실사일',
					fieldStyle: 'popup-align: center;', 
					textFieldWidth: 150, 
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								panelSearch.setValue('JASPER_DATE', countDATE);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								panelSearch.setValue('COUNT_DATE', countDATE);
								panelResult.setValue('COUNT_DATE', panelSearch.getValue('COUNT_DATE'));
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
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'ITEM_LEVEL2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
			        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL3', newValue);
						}
					}
				},{
					fieldLabel: '레포트파라미터용',
						name: 'JASPER_DATE',
						xtype: 'uniTextfield',
						hidden:true
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
					value: UserInfo.divCode,
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
					Unilite.popup('COUNT_DATE', { 
					fieldLabel: '실사일', 
					fieldStyle: 'popup-align: center;',
					textFieldWidth: 150, 
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								panelSearch.setValue('JASPER_DATE', countDATE);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								panelResult.setValue('COUNT_DATE', countDATE);
								panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
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
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'ITEM_LEVEL2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
			        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL3', newValue);
						}
					}
				}]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv121skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true,
                    onLoadSelectFirst : false
        },
    	store: directMasterStore1, 
        features: [ 
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],                                     
		columns:  [ {dataIndex: 'CLASS', 			width:50, hidden:true ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
					{dataIndex: 'COMP_CODE', 		width:50, hidden:true ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
        			{dataIndex: 'DIV_CODE', 		width:50, hidden:true ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
        			{dataIndex: 'WH_CODE', 			width:50, hidden:true ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
        			{text:'품목 분류',
           				columns:[ 
							{dataIndex:'WH_NAME'		, width:100 ,
								summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				            	},
				            	renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},		
							{dataIndex:'ITEM_LEVEL1'	, width:88 ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
							{dataIndex:'LEVEL1_NAME'	, width:130,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},		
							{dataIndex:'ITEM_LEVEL2'	, width:88,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
							{dataIndex:'LEVEL2_NAME'	, width:130,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},
							{dataIndex:'ITEM_LEVEL3'	, width:88,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							},	
							{dataIndex:'LEVEL3_NAME'	, width:130,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return value;
								}
							}
                    	]
           			},
           			{text:'수   량',  /* YSU_ver 에서는 불량수량 hidden */
           				columns:[ 
							{dataIndex:'GOOD_STOCK_BOOK_Q'		, width:140 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'GOOD_STOCK_Q'			, width:140 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'BAD_STOCK_BOOK_Q'		, width:140 , hidden: true , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'BAD_STOCK_Q'			, width:140 , hidden: true , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							}
                    	]
           			},
           			{text:'원가 금액',
           				columns:[ 
							{dataIndex:'STOCK_BOOK_I'		, width:140 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'STOCK_I'			, width:140 , summaryType: 'sum',
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							}
                    	]
           			},
           			{text:'판매 금액', /* 임시 대기 */
           				columns:[ 
							{dataIndex:'SELL_TEST'		, width:140, hidden:true , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'SELL_TEST1'		, width:140, hidden:true , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							}
                    	]
           			},
           			{text:'LOSS',
           				columns:[ 
							{dataIndex:'GOOD_CAL_Q'		, width:120 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'BAD_CAL_Q'		, width:120 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							},
							{dataIndex:'STOCK_CAL_I'	, width:140 , summaryType: 'sum' ,
								renderer: function(value, metaData, record) {
									/*if(record.get("CLASS") == '7'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '9') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '11') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '15') {
										metaData.tdCls = 'x-change-cell4';
									}*/
									if(record.get("CLASS") == '4'){
										metaData.tdCls = 'x-change-cell1';
									}
									else if(record.get("CLASS") == '6') {
										metaData.tdCls = 'x-change-cell2';
									}
									else if(record.get("CLASS") == '8') {
										metaData.tdCls = 'x-change-cell3';
									}
									else if(record.get("CLASS") == '13') {
										metaData.tdCls = 'x-change-cell4';
									}
									else if(record.get("CLASS") == '10') {
										metaData.tdCls = 'x-change-cell5';
									}
									return Ext.util.Format.number(value,'0,000');
								}
							}
                    	]
           			}
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
		id  : 'biv121skrvApp',
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
        },
        onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/biv/biv121rkrPrint.do',
	            prgID: 'biv121rkr',
	               extParam: {
					  COMP_CODE    	 	: UserInfo.compCode,
					  DIV_NAME			: panelSearch.getField("DIV_CODE").rawValue,
	                  DIV_CODE  		: param.DIV_CODE,
	                  COUNT_DATE 		: param.COUNT_DATE,
	                  WH_CODE  			: param.WH_CODE,
	                  ITEM_LEVEL1		: param.ITEM_LEVEL1,
	                  ITEM_LEVEL2		: param.ITEM_LEVEL2,
	                  ITEM_LEVEL3		: param.ITEM_LEVEL3,
	                  JASPER_DATE       : param.JASPER_DATE
	               }
	            });
	            win.center();
	            win.show();
	               
    	}
	});

};


</script>
