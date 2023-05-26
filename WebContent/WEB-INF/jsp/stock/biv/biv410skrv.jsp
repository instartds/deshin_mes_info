<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv410skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="biv410skrv"/> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->  
	<t:ExtComboStore comboType="O" storeId="whList" />   			<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B036" />				<!-- 수불방법 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Biv410skrvModel', {
	    fields: [  	 
	    	{name: 'COMP_CODE',			text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',		type:'string'},
	    	{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
	    	{name: 'COMMON_CODE',		text: '<t:message code="system.label.inventory.accountcode" default="계정코드"/>',		type:'string'},
	    	{name: 'COMMON_NAME',		text: '<t:message code="system.label.inventory.account" default="계정"/>',			type:'string'},
	    	{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.majorgroupcode" default="대분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME1',	text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middlegroupcode" default="중분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME2',	text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.minorgroupcode" default="소분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME3',	text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',		type:'string'},
	    	{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',		type:'string'},
	    	{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.item" default="품목"/>',			type:'string'},
	    	{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
	    	{name: 'LOT_NO',            text: 'Lot No.',           type:'string'},
	    	{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type:'string'},
	    	{name: 'WGT_UNIT',			text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>',		type:'string'},
	    	{name: 'UNIT_WGT',			text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>',		type:'uniQty'},
	    	{name: 'PACK_UNIT',			text: '<t:message code="system.label.inventory.packagingunit" default="포장단위"/>',		type:'string'},
	    	{name: 'TRANS_RATE',		text: '<t:message code="system.label.inventory.packagingcontainedqty" default="포장입수"/>',		type:'uniQty'},
	    	{name: 'INOUT_DATE',		text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',		type:'uniDate'},
	    	{name: 'BOX_BASIS_Q',		text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_BASIS_Q',		text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'BASIS_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'BASIS_WEIGHT_Q',	text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'BASIS_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_IN_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'}, 
	    	{name: 'EA_IN_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},  
	    	{name: 'IN_Q',				text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'IN_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},  
	    	{name: 'IN_I',				text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_OUT_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},  
	    	{name: 'EA_OUT_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},  
	    	{name: 'OUT_Q',				text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},  
	    	{name: 'OUT_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},  
	    	{name: 'OUT_I',				text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_RTN_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_RTN_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'IN_RTN_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'OUT_RTN_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'RTN_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'IN_RTN_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'OUT_RTN_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_STOCK_Q',		text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_STOCK_Q',		text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'STOCK_WEIGHT_Q',	text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'STOCK_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
			{name: 'BOX_RTN_Q2',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_RTN_Q2',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'RTN_WEIGHT_Q2',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'}
	    	
		]
	});
	
	Unilite.defineModel('Biv410skrvModel2', {
	    fields:  [  	 
	    	{name: 'COMP_CODE',			text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',		type:'string'},
	    	{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
	    	{name: 'COMMON_CODE',		text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type:'string'},
	    	{name: 'COMMON_NAME',		text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',			type:'string'},
	    	{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.majorgroupcode" default="대분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME1',	text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middlegroupcode" default="중분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME2',	text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.minorgroupcode" default="소분류코드"/>',		type:'string'},
	    	{name: 'ITEM_LEVEL_NAME3',	text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',		type:'string'},
	    	{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',		type:'string'},
	    	{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.item" default="품목"/>',			type:'string'},
	    	{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
	    	{name: 'LOT_NO',            text: 'Lot No.',           type:'string'},
	    	{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type:'string'},
	    	{name: 'WGT_UNIT',			text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>',		type:'string'},
	    	{name: 'UNIT_WGT',			text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>',		type:'uniQty'},
	    	{name: 'PACK_UNIT',			text: '<t:message code="system.label.inventory.packagingunit" default="포장단위"/>',		type:'string'},
	    	{name: 'TRANS_RATE',		text: '<t:message code="system.label.inventory.packagingcontainedqty" default="포장입수"/>',		type:'uniQty'},
	    	{name: 'INOUT_DATE',		text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',		type:'uniDate'},
	    	{name: 'BOX_BASIS_Q',		text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_BASIS_Q',		text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'BASIS_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'BASIS_WEIGHT_Q',	text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'BASIS_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_IN_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'}, 
	    	{name: 'EA_IN_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},  
	    	{name: 'IN_Q',				text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'IN_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},  
	    	{name: 'IN_I',				text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_OUT_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},  
	    	{name: 'EA_OUT_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},  
	    	{name: 'OUT_Q',				text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},  
	    	{name: 'OUT_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},  
	    	{name: 'OUT_I',				text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_RTN_Q',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_RTN_Q',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'IN_RTN_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'OUT_RTN_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'RTN_WEIGHT_Q',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'IN_RTN_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'OUT_RTN_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_STOCK_Q',		text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_STOCK_Q',		text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.qty" default="수량"/>',			type:'uniQty'},
	    	{name: 'STOCK_WEIGHT_Q',	text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'},
	    	{name: 'STOCK_I',			text: '<t:message code="system.label.inventory.amount" default="금액"/>',			type:'uniPrice'},
	    	{name: 'BOX_RTN_Q2',			text: '<t:message code="system.label.inventory.packingqty" default="포장수량"/>',		type:'uniQty'},
	    	{name: 'EA_RTN_Q2',			text: '<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>',		type:'uniQty'},
	    	{name: 'RTN_WEIGHT_Q2',		text: '<t:message code="system.label.inventory.weight" default="중량"/>',			type:'uniQty'}
	    	
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biv410skrvMasterStore1',{
			model: 'Biv410skrvModel',
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
                api: {			
                	   read: 'biv410skrvService.selectMaster'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'COMMON_NAME',
			listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
	        }			
	});
	
	
	var directMasterStore2 = Unilite.createStore('biv410skrvMasterStore2',{
			model: 'Biv410skrvModel2',
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
                api: {			
                	   read: 'biv410skrvService.selectMaster2'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'COMMON_NAME',
			listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid2.setShowSummaryRow(true);
					}
				}
	        }			
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
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
	            		name: 'DIV_CODE',
	            		xtype: 'uniCombobox',
	            		comboType: 'BOR120',
	            		comboCode: 'B001',
						child:'WH_CODE',
	            		allowBlank: false,
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
	            	},{
	            		fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
	            		name: 'ITEM_ACCOUNT',
	            		xtype: 'uniCombobox', 
	            		comboType: 'AU',
						comboCode: 'B020',
	            		allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}
					},{ 
						fieldLabel: '<t:message code="system.label.inventory.transdate1" default="수불일자"/>',
						xtype: 'uniDateRangefield',
						startFieldName: 'FR_INOUT_DATE',
						endFieldName: 'TO_INOUT_DATE',
						startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today'),
						allowBlank:false,
						width:315,
						onStartDateChange: function(field, newValue, oldValue, eOpts) {
		                	if(panelResult) {
								panelResult.setValue('FR_INOUT_DATE',newValue);
								//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
								
		                	}
					    },
					    onEndDateChange: function(field, newValue, oldValue, eOpts) {
					    	if(panelResult) {
					    		panelResult.setValue('TO_INOUT_DATE',newValue);
					    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
					    	}
					    }
					},
						Unilite.popup('DIV_PUMOK',{ 
							fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
							valueFieldName: 'ITEM_CODE', 
							textFieldName: 'ITEM_NAME',
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
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.inventory.inquiryclass" default="조회구분"/>',
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.inventory.tranoccurrence" default="수불발생"/>',
						width:80,
						name:'INOUT_FLAG',
						inputValue: '1',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
						width:80,
						name:'INOUT_FLAG',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('INOUT_FLAG').setValue(newValue.INOUT_FLAG);
						}
					}
				}]			
	         },{
	         	title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>', 	
				itemId: 'search_panel2',
		       	layout: {type: 'uniTable', columns: 1},
		       	defaultType: 'uniTextfield',
				    items: [{ 
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
	            	},{
	            		fieldLabel: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>',
	            		name: 'INOUT_METH',
	            		xtype: 'uniCombobox',
	            		comboType:'AU', 
	            		comboCode:'B020'
	            	},{
	            		xtype: 'radiogroup',		            		
						fieldLabel: '<t:message code="system.label.inventory.itemstatus" default="품목상태"/>',
						//name: 'ITEM_STATUS',
						items: [{
							boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>', 
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.normal" default="정상"/>',
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '1'
						},{
							boxLabel: '<t:message code="system.label.inventory.defect" default="불량"/>',
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '2'
						}]
					},{
						xtype: 'radiogroup',		            		
						fieldLabel: '<t:message code="system.label.inventory.normalinputyn" default="정상수출여부"/>',	
						//name: 'NORMAL_INOUT_YN',
						labelWidth: 90,
						items: [{
							boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
							width: 60,
							name: 'NORMAL_INOUT_YN',
							inputValue: '',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'NORMAL_INOUT_YN' ,
							inputValue: 'Y'
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'NORMAL_INOUT_YN',
							inputValue: 'N'
						}]
					},{
						xtype: 'radiogroup',		            		
						fieldLabel: '<t:message code="system.label.inventory.inventorymanageobject" default="재고관리대상"/>',	
						labelWidth: 90,
						items: [{
							boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
							width: 60,
							name: 'STOCK_CARE_YN',
							inputValue: 'A',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'STOCK_CARE_YN' ,
							inputValue: 'Y'
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'STOCK_CARE_YN',
							inputValue: 'N'
						}]
					},{
						xtype: 'radiogroup',		            		
						fieldLabel: 'LOT 표시여부',	
						labelWidth: 90,
						items: [{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'LOT_DISPLAY_YN',
							inputValue: 'N',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'LOT_DISPLAY_YN' ,
							inputValue: 'Y'
						}]
					},{
                        xtype:'uniTextfield',
                        fieldLabel : 'Lot No.',
                        name:'LOT_NO',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('LOT_NO', newValue);
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
			   		alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {\

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
	    		comboCode: 'B001',
				child:'WH_CODE',
	    		allowBlank: false,
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	    	},{
	    		fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
	    		name: 'ITEM_ACCOUNT',
	    		xtype: 'uniCombobox', 
	    		comboType: 'AU',
	    		allowBlank: false,
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.inventory.transdate1" default="수불일자"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width:315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('FR_INOUT_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('TO_INOUT_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME',
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
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
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
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.inventory.inquiryclass" default="조회구분"/>',
				labelWidth:90,
				items : [{
					boxLabel: '<t:message code="system.label.inventory.tranoccurrence" default="수불발생"/>',
					width:80,
					name:'INOUT_FLAG',
					inputValue: '1',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
					width:80,
					name:'INOUT_FLAG',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelSearch.getField('INOUT_FLAG').setValue(newValue.INOUT_FLAG);
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
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv410skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        title: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
    	excelTitle: '<t:message code="system.label.inventory.dailytranstatusbyitem" default="일별수불현황(품목별)"/>',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	store: directMasterStore1,
    	
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{dataIndex: 'COMP_CODE',      	width: 66, hidden: true},				
			{dataIndex: 'DIV_CODE',      	width: 66, hidden: true},				
			{dataIndex: 'COMMON_CODE',      width: 66, hidden: true}, 				
			{dataIndex: 'COMMON_NAME',      width: 73, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.classficationtotal" default="분류계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
            }},				
			{dataIndex: 'ITEM_LEVEL1',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME1', width: 110, locked: true}, 				
			{dataIndex: 'ITEM_LEVEL2',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME2', width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL3',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME3',	width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_CODE',      	width: 120, locked: true},  				
			{dataIndex: 'ITEM_NAME',      	width: 166, locked: true},  				
			{dataIndex: 'SPEC',      		width: 150, locked: true},
			{dataIndex: 'LOT_NO',           width: 100, locked: true},
			{dataIndex: 'STOCK_UNIT',      	width: 66, locked: true},  				
			{dataIndex: 'WGT_UNIT',      	width: 66},  				
			{dataIndex: 'UNIT_WGT',      	width: 66},  				
			{dataIndex: 'PACK_UNIT',      	width: 66},  				
			{dataIndex: 'TRANS_RATE',      	width: 66},  				
			{dataIndex: 'INOUT_DATE',      	width: 80},  				
			{
				text:'<t:message code="system.label.inventory.basic" default="기초"/>',
           		columns:[ 
              		{dataIndex:'BOX_BASIS_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_BASIS_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'BASIS_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'BASIS_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'BASIS_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.receipt" default="입고"/>',
           		columns:[ 
              		{dataIndex:'BOX_IN_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_IN_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'IN_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'IN_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'IN_I',          width:80,  summaryType:'sum'}
                ]
          	},{	///////////////////////////////////////////////////////////////////////////////////////////////////////
          		text:'(<t:message code="system.label.inventory.purchase" default="매입"/>)<t:message code="system.label.inventory.return" default="반품"/>',
           		columns:[ 
              		{dataIndex:'BOX_RTN_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_RTN_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'IN_RTN_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'RTN_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'IN_RTN_I',          width:80,  summaryType:'sum'}
                ]
          	},{	///////////////////////////////////////////////////////////////////////////////////////////////////////
          		text:'<t:message code="system.label.inventory.issue" default="출고"/>',
           		columns:[ 
              		{dataIndex:'BOX_OUT_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_OUT_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'OUT_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'OUT_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'OUT_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'(<t:message code="system.label.inventory.sales" default="매출"/>)<t:message code="system.label.inventory.return" default="반품"/>',
           		columns:[ 
              		{dataIndex:'BOX_RTN_Q2',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_RTN_Q2',       width:80,  summaryType:'sum'},
        		    {dataIndex:'OUT_RTN_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'RTN_WEIGHT_Q2',   width:80,  summaryType:'sum'},
	                {dataIndex:'OUT_RTN_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.inventory" default="재고"/>',
           		columns:[ 
              		{dataIndex:'BOX_STOCK_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_STOCK_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'STOCK_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'STOCK_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'STOCK_I',          width:80,  summaryType:'sum'}
				]
			}
		] 
    });   
	
    var masterGrid2 = Unilite.createGrid('biv410skrvGrid2', {
    	region: 'center' ,
        layout : 'fit',
        title: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>',
    	excelTitle: '<t:message code="system.label.inventory.dailytranstatuswarehouse" default="일별수불현황(창고별)"/>',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],
        columns:  [
        	{dataIndex: 'COMP_CODE',      	width: 66, hidden: true},				
			{dataIndex: 'DIV_CODE',      	width: 66, hidden: true},				
			{dataIndex: 'COMMON_CODE',      width: 66, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.classficationtotal" default="분류계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
            }}, 				
			{dataIndex: 'COMMON_NAME',      width: 88, locked: true}, 				
			{dataIndex: 'ITEM_LEVEL1',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME1', width: 110, locked: true}, 				
			{dataIndex: 'ITEM_LEVEL2',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME2', width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL3',      width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL_NAME3',	width: 66, hidden: true}, 				
			{dataIndex: 'ITEM_CODE',      	width: 120, locked: true},  				
			{dataIndex: 'ITEM_NAME',      	width: 166, locked: true},  				
			{dataIndex: 'SPEC',      		width: 150, locked: true},
			{dataIndex: 'LOT_NO',           width: 100, locked: true},
			{dataIndex: 'STOCK_UNIT',      	width: 66, locked: true},  				
			{dataIndex: 'WGT_UNIT',      	width: 66},  				
			{dataIndex: 'UNIT_WGT',      	width: 66},  				
			{dataIndex: 'PACK_UNIT',      	width: 66},  				
			{dataIndex: 'TRANS_RATE',      	width: 66},  				
			{dataIndex: 'INOUT_DATE',      	width: 80},  				
			{
				text:'<t:message code="system.label.inventory.basic" default="기초"/>',
           		columns:[ 
              		{dataIndex:'BOX_BASIS_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_BASIS_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'BASIS_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'BASIS_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'BASIS_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.receipt" default="입고"/>',
           		columns:[ 
              		{dataIndex:'BOX_IN_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_IN_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'IN_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'IN_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'IN_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'(<t:message code="system.label.inventory.purchase" default="매입"/>)<t:message code="system.label.inventory.return" default="반품"/>',
           		columns:[ 
              		{dataIndex:'BOX_RTN_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_RTN_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'IN_RTN_Q',       width:80,  summaryType:'sum'},
    	            {dataIndex:'RTN_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'IN_RTN_I',       width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.issue" default="출고"/>',
           		columns:[ 
              		{dataIndex:'BOX_OUT_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_OUT_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'OUT_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'OUT_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'OUT_I',          width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'(<t:message code="system.label.inventory.sales" default="매출"/>)<t:message code="system.label.inventory.return" default="반품"/>',
           		columns:[ 
              		{dataIndex:'BOX_RTN_Q2',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_RTN_Q2',       width:80,  summaryType:'sum'},
        		    {dataIndex:'OUT_RTN_Q',      width:80,  summaryType:'sum'},
    	            {dataIndex:'RTN_WEIGHT_Q2',   width:80,  summaryType:'sum'},
	                {dataIndex:'OUT_RTN_I',      width:80,  summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.inventory" default="재고"/>',
           		columns:[ 
              		{dataIndex:'BOX_STOCK_Q',      width:80,  summaryType:'sum'},
              		{dataIndex:'EA_STOCK_Q',       width:80,  summaryType:'sum'},
        		    {dataIndex:'STOCK_Q',          width:80,  summaryType:'sum'},
    	            {dataIndex:'STOCK_WEIGHT_Q',   width:80,  summaryType:'sum'},
	                {dataIndex:'STOCK_I',          width:80,  summaryType:'sum'}
				]
			}
		] 
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ]
    });
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch  	
		],   
		id  : 'biv410skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			biv410skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown : function()	{	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal2 = masterGrid2.normalGrid.getView();
			var viewLocked2 = masterGrid2.lockedGrid.getView();
			if(activeTabId == 'biv410skrvGrid1'){				
				masterGrid.reset();
				directMasterStore1.loadStoreRecords();
				console.log("viewNormal : ",viewNormal);
				console.log("viewLocked : ",viewLocked);
		    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			}
			else if(activeTabId == 'biv410skrvGrid2'){
				masterGrid2.reset();
				directMasterStore2.loadStoreRecords();
				console.log("viewNormal2 : ",viewNormal2);
				console.log("viewLocked2 : ",viewLocked2);
		    	viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
		    	viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
		    	viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(true);
		    	viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			}
			UniAppManager.setToolbarButtons('reset', true); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			panelSearch.getField('ITEM_ACCOUNT').focus();
			panelResult.getField('ITEM_ACCOUNT').focus();
			directMasterStore1.clearData();
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));	
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));	
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));	
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));	
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