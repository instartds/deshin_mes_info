<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mba031ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mba031ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 구매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /> <!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MBA031ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MBA031ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MBA031ukrvLevel3Store" />
	
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referOtherOrderWindow;	//타발주참조
var excelWindow;	// 엑셀참조
var BsaCodeInfo = {
	gsDefaultMoney: '${gsDefaultMoney}'
};

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
			read: 'mba031ukrvService.gridDown',
			update: 'mba031ukrvService.updateDetail',
			create: 'mba031ukrvService.insertDetail',
			destroy: 'mba031ukrvService.deleteDetail',
			syncAll: 'mba031ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mba031ukrvModel', {
	    fields: [  	 	    
			{name: 'COMP_CODE'	 	 ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 		,type: 'string'},
			{name: 'DIV_CODE'	 	 ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string',comboType:'BOR120'},
	    	{name: 'ITEM_CODE'	 	 ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 		,type: 'string'},
	    	{name: 'ITEM_NAME'	 	 ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'SPEC'		 	 ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			,type: 'string'},
	    	{name: 'STOCK_UNIT'	 	 ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 		,type: 'string'},
	    	{name: 'ORDER_UNIT'	 	 ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 		,type: 'string'},
//	    	{name: 'SALE_COMMON_P'	 ,text: '기준단가(시중가)' 	,type: 'uniUnitPrice'},
	    	{name: 'SALE_BASIS_P'	 ,text: '<t:message code="system.label.purchase.sellingprice" default="판매단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'DOM_FORIGN'	 	 ,text: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>' 		,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'	 ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 		,type: 'string'},
	    	{name: 'ITEM_LEVEL1'	 ,text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>' 			,type: 'string', store: Ext.data.StoreManager.lookup('MBA031ukrvLevel1Store'), child:'ITEM_LEVEL2'},
	    	{name: 'ITEM_LEVEL2'	 ,text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>' 			,type: 'string', store: Ext.data.StoreManager.lookup('MBA031ukrvLevel2Store'), child:'ITEM_LEVEL3'},
	    	{name: 'ITEM_LEVEL3'	 ,text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>' 			,type: 'string', store: Ext.data.StoreManager.lookup('MBA031ukrvLevel3Store')}
		]  
	});		//End of Mba031ukrvModel
	
	Unilite.defineModel('Mba031ukrvModel2', {
		fields: [  	 	    
			{name: 'COMP_CODE'	 			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'TYPE'	 				,text: '<t:message code="system.label.purchase.type" default="타입"/>' 				,type: 'string'},
	    	{name: 'DIV_CODE'	 			,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 				,type: 'string'},
	    	{name: 'ITEM_CODE'	 			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 				,type: 'string'},
	    	{name: 'CUSTOM_CODE'	 		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>' 				,type: 'string', allowBlank: false},
	    	{name: 'CUSTOM_NAME'	 		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>' 				,type: 'string', allowBlank: false},
	    	{name: 'MONEY_UNIT'	 			,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>' 				,type: 'string',comboType:'AU',comboCode:'B004',displayField: 'value', allowBlank: false},
	    	{name: 'ORDER_UNIT'	 			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 				,type: 'string',comboType:'AU',comboCode:'B013',displayField: 'value', allowBlank: false,hidden:true},
//	    	{name: 'PURCHASE_TYPE'        	,text: '매입조건'				, type: 'string',comboType:'AU',comboCode:'YP08'},
//	    	{name: 'SALES_TYPE'         	,text: '판매형태'				, type: 'string',comboType:'AU',comboCode:'YP09'},
//	    	{name: 'SALE_COMMON_P'	 		,text: '기준단가(시중가)' 		,type: 'uniUnitPriceuniUnitPrice'},
	    	{name: 'SALE_BASIS_P'	 		,text: '<t:message code="system.label.purchase.sellingprice" default="판매단가"/>' 				,type: 'uniUnitPrice'},
	    	{name: 'ORDER_RATE'				,text: '<t:message code="system.label.purchase.orderrate" default="발주율"/>(%)' 			,type: 'uniER'},
//	    	{name: 'PURCHASE_RATE'			,text: '매입율(%)' 			,type: 'uniER'},
	    	{name: 'ITEM_P'					,text: '<t:message code="system.label.purchase.price" default="단가"/>' 				,type: 'uniUnitPrice', allowBlank: false},
	    	{name: 'APLY_START_DATE'		,text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>' 			,type: 'uniDate', allowBlank: false},
	    	{name: 'REMARK'		            ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 			,type: 'string'},
//	    	{name: 'APLY_END_DATE'			,text: '시작종료일' 			,type: 'uniDate', allowBlank: false},
//	    	{name: 'USE_YN'					,text: '사용여부' 				,type: 'string',comboType:'AU', comboCode:'B010'},
	    	{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER' 	,type: 'string'},
	      	{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME' 	,type: 'string'},
	      	{name: 'EXCEL_UPLOAD'			,text: 'EXCEL_UPLOAD' 			,type: 'string'}
		]  
	});		//End of Mba031ukrvModel2
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('mba031ukrvMasterStore1',{
		model: 'Mba031ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
				type: 'direct',
				api: {			
					read: 'mba031ukrvService.gridUp'                	
				}
			},
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
	       	load: function(store, records, successful, eOpts) {
	       		if(records[0] != null){
	       			masterForm.setValue('GRID_ITEM_CODE',records[0].get('ITEM_CODE'));
	       			masterForm.setValue('GRID_ORDER_UNIT',records[0].get('ORDER_UNIT'));
//	       			masterForm.setValue('SALE_COMMON_P',records[0].get('SALE_COMMON_P'));
	      			masterForm.setValue('SALE_BASIS_P',records[0].get('SALE_BASIS_P'));
	       		if((masterForm.getValue('GRID_ITEM_CODE') != '')) {
	       			directMasterStore2.loadStoreRecords(records);
	       		}
	       		}else{
	       			masterForm.setValue('GRID_ITEM_CODE','');
	       			masterForm.setValue('GRID_ORDER_UNIT','');
	           			masterGrid2.getStore().removeAll();
				}
			},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		
           	},
           	remove: function(store, record, index, isMove, eOpts) {	
           	}
		}
		
		
	});		// End of var directMasterStore1 = Unilite.createStore('mba031ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('mba031ukrvMasterStore2', {
		model: 'Mba031ukrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
//			allDeletable: true,
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			/*proxy: {
				type: 'direct',
				api: {			
					read: 'mba031ukrvService.gridDown'                	
				}
			},*/
			proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			param.DATE = UniDate.get('today'),
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					
					/*Ext.each(masterGrid2.getStore().data.items,  function(record, index, records){
						if(record.get('ITEM_P') <= 0){
							alert('단가가 0보다 작거나 같을 수 없습니다');
						}else if(record.get('ITEM_P') > 0){*/
//							this.syncAllDirect();
/*						}
							
						
					})*/
					config = {
//							params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();								
							var param = {KEY_VALUE: master.KEY_VALUE}
//							mba031ukrvService.goInterFace(param, function(provider, response)	{
//							});
						 } 
					};
					this.syncAllDirect(config);
					
				}else {
					masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});//End of var directMasterStore2 = Unilite.createStore('mms200ukrvMasterStore2', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.itemsearch" default="품목검색"/>',
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
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
				//	extParam: {DIV_CODE: '02'},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
						}
				}),
 			{ 
 				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
 				name: 'ITEM_LEVEL3', 
 				xtype: 'uniCombobox',  
 				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
 				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
 			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.pricesearch" default="단가검색"/>',
					id: 'radiog',
					items: [{
						boxLabel: '<t:message code="system.label.purchase.nowapplyprice" default="현재적용단가"/>', 
						width:  120, 
						name: 'UNIT_PRICE', 
						inputValue: 'A', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
						width :60, 
						name: 'UNIT_PRICE', 
						inputValue: 'B'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('UNIT_PRICE').setValue(newValue.UNIT_PRICE);
							if(masterGrid.getStore().getCount() > 0){
								directMasterStore2.loadStoreRecords();
							}
						}
					}
				},{ 
					fieldLabel: '그리드의 아이템코드값',
					name: 'GRID_ITEM_CODE', 
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '그리드의 구매단위값',
					name: 'GRID_ORDER_UNIT',
					xtype: 'uniTextfield',
					hidden: true
				}/*,{
					fieldLabel: '그리드의 기준단가(시중가)',
					name: 'SALE_COMMON_P',
					xtype: 'uniTextfield',
					hidden: true
				}*/,{
					fieldLabel: '그리드의 판매단가',
					name: 'SALE_BASIS_P',
					xtype: 'uniTextfield',
					hidden: true
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
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
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				labelWidth: 200,
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				labelWidth: 200,
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
						}
				}),
 			{ 
 				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
 				name: 'ITEM_LEVEL3', 
 				xtype: 'uniCombobox', 
 				labelWidth: 200,
 				store: Ext.data.StoreManager.lookup('MBA031ukrvLevel3Store'),
 				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
 				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ITEM_LEVEL3', newValue);
					}
				}
 			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.pricesearch" default="단가검색"/>',
					id: 'radiog2',
					labelWidth: 200,
					items: [{
						boxLabel: '<t:message code="system.label.purchase.nowapplyprice" default="현재적용단가"/>', 
						width:  120, 
						name: 'UNIT_PRICE', 
						inputValue: 'A', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
						width :60, 
						name: 'UNIT_PRICE', 
						inputValue: 'B'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.getField('UNIT_PRICE').setValue(newValue.UNIT_PRICE);
							if(masterGrid.getStore().getCount() > 0){
								directMasterStore2.loadStoreRecords();
							}
						}
					}
				}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
   
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('mba031ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '<t:message code="system.label.purchase.custombypurchaseregister" default="거래처별 구매단가등록"/>',
        selModel: 'rowmodel',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
//			onLoadSelectFirst: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
			}
        },
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
      			{dataIndex: 'COMP_CODE'	 		,width:80,hidden:true},
      			{dataIndex: 'DIV_CODE'	 		,width:146,hidden:true},
				{dataIndex: 'ITEM_CODE'	 		,width:150},
				{dataIndex: 'ITEM_NAME'	 		,width:300},
				{dataIndex: 'SPEC'		 		,width:200},
				{dataIndex: 'STOCK_UNIT'	 	,width:66,align:'center'},
				{dataIndex: 'ORDER_UNIT'	 	,width:66,align:'center',hidden:true},
//				{dataIndex: 'SALE_COMMON_P'		,width:105},
				{dataIndex: 'SALE_BASIS_P'		,width:105},
				{dataIndex: 'DOM_FORIGN'	 	,width:86,align:'center'},
				{dataIndex: 'ITEM_ACCOUNT'		,width:90,align:'center'},
				{dataIndex: 'ITEM_LEVEL1'		,width:120},
				{dataIndex: 'ITEM_LEVEL2'		,width:120},
				{dataIndex: 'ITEM_LEVEL3'		,width:120}
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('GRID_ITEM_CODE',record.get('ITEM_CODE'));
					masterForm.setValue('GRID_ORDER_UNIT',record.get('ORDER_UNIT'));
//					masterForm.setValue('SALE_COMMON_P',record.get('SALE_COMMON_P'));
					masterForm.setValue('SALE_BASIS_P',record.get('SALE_BASIS_P'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			},
        	
			beforeedit  : function( editor, e, eOpts ) {
			
			},
			render: function(grid, eOpts){
			  var girdNm = grid.getItemId();
			  grid.getEl().on('click', function(e, t, eOpt) {
			   var prevGrid = Ext.getCmp('mba031ukrvGrid2');
			   grid.changeFocusCls(prevGrid);
			  })
			 }
		}
    });		// End of masterGrid= Unilite.createGrid('mba031ukrvGrid', {

	var masterGrid2 = Unilite.createGrid('mba031ukrvGrid2', {
		layout: 'fit',
		region: 'south',
		excelTitle: '˂t:message code="system.label.purchase.custombypurchaseregister" default="거래처별 구매단가등록"/˃(detail)',		
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
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore2,
	    tbar: [{
			itemId: 'excelBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.excelrefer" default="엑셀참조"/></div>',
        	handler: function() {
	        	openExcelWindow();
	        }
		}],
		columns: [
				{dataIndex: 'COMP_CODE'	 		,width:10,hidden:true},
				{dataIndex: 'TYPE'	 			,width:100,hidden:true},
				{dataIndex: 'DIV_CODE'	 		,width:146,hidden:true},
				{dataIndex: 'ITEM_CODE'	 		,width:106,hidden:true},
				{dataIndex: 'CUSTOM_CODE'	 	,width:150,
					editor: Unilite.popup('CUST_G',{
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_CODE',
						extParam: {'CUSTOM_TYPE': ['1','2']},
		                autoPopup: true,
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type  ){
//			                    	var grdRecord = masterGrid2.getSelectedRecord();
		                    		var grdRecord = masterGrid2.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
		                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  	}
						}
					})
				},
				
				{dataIndex: 'CUSTOM_NAME'	 	,width:300,
					editor: Unilite.popup('CUST_G',{
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_CODE',
						extParam: {'CUSTOM_TYPE': ['1','2']},
		                autoPopup: true,
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type){
			                    	var grdRecord = masterGrid2.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
		                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  	}
						}
					})
				}, 
				{dataIndex: 'MONEY_UNIT'	 	,width:100, align: 'center'},
				{dataIndex: 'ORDER_UNIT'	 	,width:100, align: 'center'},
//				{dataIndex: 'PURCHASE_TYPE'		,width:88, align: 'center'},
//				{dataIndex: 'SALES_TYPE'	 	,width:88, align: 'center'},
//				{dataIndex: 'SALE_COMMON_P'	 	,width:88, hidden:true},
				{dataIndex: 'SALE_BASIS_P'	 	,width:100, hidden:true},
				{dataIndex: 'ORDER_RATE'		,width:100, hidden:true},
//				{dataIndex: 'PURCHASE_RATE'		,width:88},
				{dataIndex: 'ITEM_P'			,width:100},
				{dataIndex: 'APLY_START_DATE'	,width:100},
				{dataIndex: 'REMARK'	        ,width:500},
//				{dataIndex: 'APLY_END_DATE'		,width:88},
//				{dataIndex: 'USE_YN'			,width:88, hidden:true},
				{dataIndex: 'UPDATE_DB_USER'	,width:66,hidden:true},
				{dataIndex: 'UPDATE_DB_TIME'	,width:66,hidden:true},
				{dataIndex: 'EXCEL_UPLOAD'	    ,width:66,hidden:true}	
		],
		listeners: {

			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					
					if (UniUtils.indexOf(e.field, 
							['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','ORDER_UNIT','ITEM_P','APLY_START_DATE','REMARK']))
							{	
								return true;
							}else{
								return false;
							}					
				}else{
					if(e.field == 'ITEM_P')
						{	
							return true;
						}else{
							return false;
						}
				}
			},
			
			 render: function(grid, eOpts){
			  var girdNm = grid.getItemId();
			  grid.getEl().on('click', function(e, t, eOpt) {
			   var prevGrid = Ext.getCmp('mba031ukrvGrid');
			   grid.changeFocusCls(prevGrid);
			  })
			 }
			

		},
		setCustData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			
       		} else {
       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
       		}
		},
        setExcelData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE' 			, UserInfo.compCode);
			grdRecord.set('DIV_CODE' 			, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE' 			, record['ITEM_CODE']);
			grdRecord.set('CUSTOM_CODE' 		, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME' 		, record['CUSTOM_NAME']);
			grdRecord.set('MONEY_UNIT' 			, record['MONEY_UNIT']);
			grdRecord.set('ORDER_UNIT' 			, 'EA');
			grdRecord.set('ITEM_P' 				, record['ITEM_P']);
			grdRecord.set('APLY_START_DATE' 	, record['APLY_START_DATE']);
			grdRecord.set('TYPE' 				, '1');
			grdRecord.set('SALE_BASIS_P' 		, record['SALE_BASIS_P']);
			grdRecord.set('ORDER_RATE' 			, '1');
			grdRecord.set('EXCEL_UPLOAD' 		, 'Y');
		}
	});//End of var masterGrid = Unilite.createGrid('mba031ukrvGrid1', {
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.mba031.sheet01', {
	    fields: [
	    	{name: '_EXCEL_JOBID' 		 	 ,text:'EXCEL_JOBID',type: 'string'},
	    	{name: 'COMP_CODE' 		 		 ,text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
	    	{name: 'DIV_CODE' 		 		 ,text:'<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},	
	    	{name: 'ITEM_CODE' 		 		 ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},			 
			{name: 'ITEM_NAME' 		 		 ,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},	
			{name: 'CUSTOM_CODE' 		 	 ,text:'<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string'},	 
			{name: 'CUSTOM_NAME' 		 	 ,text:'<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type: 'string'},	
			{name: 'MONEY_UNIT' 		 	 ,text:'<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		,type: 'string'},	
			{name: 'ORDER_UNIT' 		 	 ,text:'<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		,type: 'string'},	
			{name: 'ORDER_RATE' 		 	 ,text:'<t:message code="system.label.purchase.orderrate" default="발주율"/>(%)'	,type: 'int'},	
//			{name: 'PURCHASE_RATE' 		 	 ,text:'매입율(%)'	,type: 'int'},	
//			{name: 'PURCHASE_TYPE' 		 	 ,text:'매입조건'		,type: 'string'},	
//			{name: 'SALES_TYPE' 		 	 ,text:'판매형태'		,type: 'string'},	
			{name: 'ITEM_P' 		 		 ,text:'<t:message code="system.label.purchase.price" default="단가"/>'			,type: 'uniUnitPrice'},	
			{name: 'SALE_BASIS_P' 		 	 ,text:'<t:message code="system.label.purchase.sellingprice" default="판매단가"/>'		,type: 'uniUnitPrice'},	
			{name: 'TYPE' 		 		 	 ,text:'<t:message code="system.label.purchase.type" default="타입"/>'			,type: 'string'},	
//			{name: 'USE_YN' 		 		 ,text:'사용여부'		,type: 'string'},	
			{name: 'APLY_START_DATE' 		 ,text:'<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'		,type: 'uniDate'}	
//			{name: 'APLY_END_DATE' 		 	 ,text:'적용종료일'		,type: 'uniDate'}
		]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'mba031',
                		extParam: { 
                			'DIV_CODE': masterForm.getValue('DIV_CODE')
                			//'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')
                		},
                        grids: [{
                        		itemId: 'grid01',
                        		title: '<t:message code="system.label.purchase.priceinfo" default="단가정보"/>',                        		
                        		useCheckbox: false,
                        		model : 'excel.mba031.sheet01',
                        		readApi: 'mba031ukrvService.selectExcelUploadSheet1',
                        		columns: [
                        			{dataIndex: '_EXCEL_JOBID' 		 	, 		width: 80, hidden: true},
                        			{dataIndex: 'COMP_CODE' 		 	, 		width: 80},
                        			{dataIndex: 'DIV_CODE' 			 	, 		width: 110},
                        			{dataIndex: 'ITEM_CODE' 			, 		width: 200},
                        			{dataIndex: 'ITEM_NAME' 		 	, 		width: 100},
                        			{dataIndex: 'CUSTOM_CODE' 	 		, 		width: 100},
                        			{dataIndex: 'CUSTOM_NAME' 	 		, 		width: 100},
                        			{dataIndex: 'MONEY_UNIT' 	 		, 		width: 100, align: 'center'},
                        			{dataIndex: 'ORDER_UNIT' 	 		, 		width: 100},
                        			{dataIndex: 'ORDER_RATE' 	 		, 		width: 100},
                        			{dataIndex: 'PURCHASE_RATE' 	 	, 		width: 100},
//                        			{dataIndex: 'PURCHASE_TYPE' 	 	, 		width: 100},
//                        			{dataIndex: 'SALES_TYPE' 	 		, 		width: 100},
                        			{dataIndex: 'ITEM_P' 		 		, 		width: 100},
                        			{dataIndex: 'SALE_BASIS_P' 	 		, 		width: 100},
                        			{dataIndex: 'TYPE' 		 	 		, 		width: 100},
//                        			{dataIndex: 'USE_YN' 		 		, 		width: 100},
                        			{dataIndex: 'APLY_START_DATE' 		, 		width: 100}
//                        			{dataIndex: 'APLY_END_DATE' 	 	, 		width: 100}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
                        	/*//excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid2.setExcelData(record.data);
						        	//masterGrid.fnCulcSet(record.data);
						    }); 
							grid.getStore().remove(records);*/
                        	excelWindow.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							mba031ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid2.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
				        	/*} else {
				        		alert("에러가있는 행은 적용 불가합니다.");
				        		return false;
				        	}*/
						
						}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, masterGrid2, panelResult
			]
		},
			masterForm  	
		],	
		id: 'mba031ukrvApp',
		fnInitBinding: function() {
			//masterForm.getField('CUSTOM_CODE').focus();
			//panelResult.getField('CUSTOM_CODE').focus();
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			/*masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow() 
			} else {*/
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				/*var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success: function()	{
						masterForm.setAllFieldsReadOnly(true)

						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				})*/
				directMasterStore1.loadStoreRecords();	
				beforeRowIndex = -1;	
				
				UniAppManager.setToolbarButtons(['newData'], true);
				masterForm.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode = UserInfo.compCode;  
				var type = '1';
				var divCode = masterForm.getValue('DIV_CODE');
				var itemCode = masterForm.getValue('GRID_ITEM_CODE');
			
				 var customCode = '';
				 var customName = '';
				 var moneyUnit = BsaCodeInfo.gsDefaultMoney;
				 var orderUnit = masterForm.getValue('GRID_ORDER_UNIT');
				 var orderRate = 100;
				 
				 var purChaseType = '1';
				 var salesType = '1';
				 var purChaseRate = 100;
//				 var itemP = masterForm.getValue('SALE_COMMON_P');
//				 var saleCommonP = masterForm.getValue('SALE_COMMON_P');
				 
				 var itemP = masterForm.getValue('SALE_BASIS_P');
				 var saleBasisP = masterForm.getValue('SALE_BASIS_P');
				 var aplyStartDate = UniDate.get('today');
				 var aplyEndDate = '2999.12.31';
				 var useYn = 'Y';

            	 var r = {
            	 	COMP_CODE:			compCode,
            	 	TYPE:				type,
            	 	DIV_CODE:			divCode,
            	 	ITEM_CODE:			itemCode,
            	 	CUSTOM_CODE:		customCode,
            	 	CUSTOM_NAME:		customName,
            	 	MONEY_UNIT:			moneyUnit,
            	 	ORDER_UNIT:			orderUnit,
//            	 	PURCHASE_TYPE:		purChaseType,
//					SALES_TYPE:			salesType,
					PURCHASE_RATE:		purChaseRate,
					ORDER_RATE:			orderRate,
					ITEM_P:				itemP,
//					SALE_COMMON_P:		saleCommonP,
					SALE_BASIS_P:		saleBasisP,
					APLY_START_DATE:	aplyStartDate
//					APLY_END_DATE:		aplyEndDate,
//					USE_YN:				useYn
		        };
				masterGrid2.createRow(r);
				masterForm.setAllFieldsReadOnly(false);
				
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
			var saveFlag = true;
				if(UniAppManager.app.setAplyDate()){
					Ext.each(masterGrid2.getStore().data.items,  function(record, index, records){
						if(record.get('ITEM_P') <= 0){
							alert('<t:message code="system.message.purchase.message022" default="단가가 0보다 작거나 같을 수 없습니다."/>');
							saveFlag = false;
							return false;

						}
							
					})
					if(saveFlag){
						directMasterStore2.saveStore();
					}

					
					
					
				}
			});
			saveTask.delay(500);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid2.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid2.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
//				if(selRow.get('ITEM_CODE') > 1)
//				{
//					alert('<t:message code="unilite.msg.sMM435"/>');
//				}else{
					UniAppManager.app.setEndDate();
					masterGrid2.deleteSelectedRow();
//				}
			}
		},
		
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore2.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						if(deletable){		
							masterGrid2.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid2.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        },
        setAplyDate: function() {
        	var isSuccess = true;
        	var totRecords = directMasterStore2.data.items;				//그리드의 모든 레코드
        	var duplRecord = new Array();								//거래처, 매입조건, 판매형태가 같은 신규 레코드들
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드
        	var insertRec;												//적용시작될 레코드
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var duReci = 0;
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..
        	
        	Ext.each(totRecords, function(record1,i){
        		if(record1.phantom && record1.get('EXCEL_UPLOAD') != 'Y'){
        			Ext.each(totRecords, function(record1_1,i_1){
	        			if( record1.get('CUSTOM_CODE') 	   == record1_1.get('CUSTOM_CODE') &&
//		        			record1.get('PURCHASE_TYPE')   == record1_1.get('PURCHASE_TYPE') &&
//		        			record1.get('SALES_TYPE') 	   == record1_1.get('SALES_TYPE') &&
		        			record1_1.phantom
		        		){	        			
		        			duplRecord[duReci] = record1_1;					
		        			duReci++;  
		        		}	        		
	        		});
	        		if(duplRecord.length > 1 && isSuccess){
	        			alert('<t:message code="system.message.purchase.message023" default="중복되는 자료가 입력되었습니다. 저장후 입력하여 주십시요. 매입처명: "/>' + duplRecord[0].get('CUSTOM_NAME'));
	        			isSuccess = false;
	        			duplRecord = [];
    					return isSuccess;
	        		}	
	        		
        			Ext.each(totRecords, function(record2,j){
	        			if( record1.get('CUSTOM_CODE') 	   == record2.get('CUSTOM_CODE') &&
//		        			record1.get('PURCHASE_TYPE')   == record2.get('PURCHASE_TYPE') &&
//		        			record1.get('SALES_TYPE') 	   == record2.get('SALES_TYPE') &&
		        			!record2.phantom
		        		){	        			
		        			compareRecords[reci] = record2;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
		        			reci++;  
		        		}	        		
	        		});
	        		
	        		
//		        var recordI;
//		        var recordJ;
//		        var temp = new Array();
//		        for(var i = 0; i < compareRecords.length-1; i++){
//		        	for(var j = 0; j < compareRecords.length-1; j++){	        		
//		        		if(compareRecords[j].get('APLY_START_DATE') < compareRecords[j+1].get('APLY_START_DATE')){
//		        			temp = compareRecords[j];
//		        			compareRecords[j] = compareRecords[j+1];
//		        			compareRecords[j+1] = temp;
//		        		}		        	
//		        	}
//		        }
//	        Ext.each(compareRecords, function(record3,i){
//	        	alert(record3.get('APLY_START_DATE'));
//	        });		
	        		
	        		if(compareRecords.length > 0){
//	        			if(compareRecords.length > 1){
//	        				alert('중복되는 자료가 입력되었습니다.\n 매입처명:' + compareRecords[0].get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;	 	        			
//	        			}
	        			Ext.each(compareRecords, function(record3,i){
	        				if(UniDate.getDbDateStr(record3.get('APLY_START_DATE')) > aplyStartDate){
	        					aplyStartDate = UniDate.getDbDateStr(record3.get('APLY_START_DATE'));
	        					updateRec = record3;        					
	        					insertRec = record1;
	        				}        			
	    				});
//	    				if(updateRec.phantom && isSuccess){
//	    					alert('중복되는 자료가 입력되었습니다.\n 매입처명:' + updateRec.get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;   					
//	    				}
	    				if(updateRec && insertRec && isSuccess){
	    					if(UniDate.getDbDateStr(insertRec.get('APLY_START_DATE')) >  UniDate.getDbDateStr(updateRec.get('APLY_START_DATE'))){
//	    						updateRec.set('APLY_END_DATE', UniDate.add(insertRec.get('APLY_START_DATE'),  {days: -1}));
//								insertRec.set('APLY_END_DATE', '29991231');
	    					}		    				
	    				}	    				
	        		}
	        		compareRecords = [];	        		
	        		reci = 0;
	        		duReci = 0;
	        		aplyStartDate = '';
	        		updateRec = null;
	        		insertRec = null;
	        		isSuccess = true;
        		}        		
		    });
		    if(isSuccess){
		    	return true;
		    }else{
		    	return false;
		    }
        },
        setEndDate: function() {
        	var deleteRecord = masterGrid2.getSelectedRecord();				//삭제될 레코드
			if(deleteRecord.phantom) return false;        	
			
        	var totRecords = directMasterStore2.data.items;					//그리드의 모든 레코드        	
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드        	
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..        	
        	
        	Ext.each(totRecords, function(record1,i){    
    			if( record1.get('CUSTOM_CODE') 	   == deleteRecord.get('CUSTOM_CODE') &&
//        			record1.get('PURCHASE_TYPE')   == deleteRecord.get('PURCHASE_TYPE') &&
//        			record1.get('SALES_TYPE') 	   == deleteRecord.get('SALES_TYPE') &&
        			!record1.phantom
        		){	        			
        			compareRecords[reci] = record1;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
        			reci++;  
        		}
		    });
		    if(compareRecords.length > 0){        			
    			Ext.each(compareRecords, function(record2,i){
    				if(UniDate.getDbDateStr(record2.get('APLY_START_DATE')) > aplyStartDate && UniDate.getDbDateStr(record2.get('APLY_START_DATE')) != UniDate.getDbDateStr(deleteRecord.get('APLY_START_DATE'))){
    					aplyStartDate = UniDate.getDbDateStr(record2.get('APLY_START_DATE'));
    					updateRec = record2; 
    				}        			
				});

				if(updateRec){
//					updateRec.set('APLY_END_DATE', '29991231');
				}	    				
    		}
        }
		
	});		// End of Unilite.Main({
	Unilite.createValidator('validator01', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PURCHASE_RATE" :
					
					//시중가 * 매입율 / 100 = 단가
//					record.set('ITEM_P',record.get('SALE_COMMON_P') * newValue / '100');
					//판매단가 * 매입율 / 100 = 단가
					record.set('ITEM_P',Math.round(record.get('SALE_BASIS_P') * newValue / '100'));
				
				
					break;
				case "ITEM_P" :
					
					if(newValue <= 0 ){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					
					//단가 / 시중가  * 100 = 매입율
//					record.set('PURCHASE_RATE',newValue / record.get('SALE_COMMON_P') * '100');
					//단가 / 판매단가  * 100 = 매입율
					record.set('PURCHASE_RATE',Math.round(newValue / record.get('SALE_BASIS_P') * '100'));
					
					break;
				
				
				
					
			}
				return rv;
						}
			});
			
};
</script>
