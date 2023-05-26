<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo060ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo060ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MPO060ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MPO060ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MPO060ukrvLevel3Store" />
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<script type="text/javascript" >

var referSalesWindow;	//매출내역참조
var referReceptionWindow;	//매입처 품목참조

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}',
	gsOrderPrsnYN: '${gsOrderPrsnYN}'
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
var aa = 0;
function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo060ukrvService.purchaseRequest',
			update: 'mpo060ukrvService.updateDetail',
			create: 'mpo060ukrvService.insertDetail',
			destroy: 'mpo060ukrvService.deleteDetail',
			syncAll: 'mpo060ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mpo060ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string', editable:false},
	    	{name: 'SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'uniQty', allowBlank: true},
			{name: 'ITEM_LEVEL1'	, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'			, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'	, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'			, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store')},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'AUTHOR1'		, text: '저자'			, type: 'string'},
			{name: 'PUBLISHER'		, text: '출판사'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '매입처코드'		, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'	, text: '매입처'			, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string',   comboType   : 'OU'},
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'ORDER_REQ_Q'	, text: '주문수량'			, type: 'uniQty', allowBlank: false},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'}
		]  
	});
	
	Unilite.defineModel('mpo060ukrvSALESModel', {	//매출내역참조 
	    fields: [
	    	{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_LEVEL1'	, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'	, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store')},
			{name: 'ITEM_CODE'	    , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'	    , text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'    	, type: 'string'},
			{name: 'AUTHOR1'	    , text: '저자'    	, type: 'string'},
			{name: 'PUBLISHER'		, text: '출판사'    	, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '매입처코드'	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '매입처'    	, type: 'string'},
			{name: 'SALE_COMMON_P'	, text: '시중가'    	, type: 'uniUnitPrice'},
			{name: 'SALE_BASIS_P'	, text: '판매가'    	, type: 'uniUnitPrice'},
			{name: 'SALE_Q'	    	, text: '판매수량'    	, type: 'uniQty'},
			{name: 'SALE_AMT_O'	    , text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'    	, type: 'uniPrice'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'    	, type: 'string',   comboType   : 'OU'},
			{name: 'STOCK_Q'	    , text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'    	, type: 'uniQty'},
			{name: 'ORDER_REQ_Q'	, text: '주문수량'    	, type: 'uniQty'}
		]
	});
	
	Unilite.defineModel('mpo060ukrvRECEPTIONModel', {	//매입처 품목참조
	    fields: [
	    	{name: 'COMP_CODE'					, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'				    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
	    	{name: 'ITEM_LEVEL1'				, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'				, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store')},
			{name: 'PURCHASE_CUSTOM_CODE'	    , text: '매입처코드'	, type: 'string'},
			{name: 'CUSTOM_NAME'	   			, text: '매입처명'    	, type: 'string'},
			{name: 'ITEM_CODE'	   			 	, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'					, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'    	, type: 'string'},
			{name: 'SALE_BASIS_P'				, text: '판매가'		, type: 'uniUnitPrice'},
			{name: 'TRNS_RATE'				    , text: '구매입수'		, type: 'uniQty'},
			{name: 'SAFETY_Q'					, text: '적정재고량'	, type: 'uniQty'},
			{name: 'EOQ'						, text: '경제주문량'	, type: 'uniQty'},
			{name: 'STOCK_Q'					, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'    	, type: 'uniQty'},
			{name: 'AUTHOR1'	    			, text: '저자'    	, type: 'string'},
			{name: 'PUBLISHER'					, text: '출판사'    	, type: 'string'},	
			{name: 'SALE_COMMON_P'				, text: '시중가'    	, type: 'uniUnitPrice'},
			{name: 'WH_CODE'					, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'    	, type: 'string',   comboType   : 'OU'},
			{name: 'ORDER_REQ_Q'				, text: '주문수량'    	, type: 'uniQty'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('mpo060ukrvMasterStore1',{
		model: 'Mpo060ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
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
	});	
	
	var salesStore = Unilite.createStore('mpo060ukrvSalesStore', {//매출내역참조
		model: 'mpo060ukrvSALESModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'mpo060ukrvService.salesHistory'                	
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
	   									  ){
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
			var param= salesSearch.getValues();		
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'
	});
	
	var receptionStore = Unilite.createStore('mpo060ukrvReceptionStore', {// 매입처 품목참조
		model: 'mpo060ukrvRECEPTIONModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'mpo060ukrvService.ReceptionHistory'                	
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
	   									  ){
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
			var param= receptionSearch.getValues();		
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(receptionSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '요청조건',
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
				child: 'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				holdable: 'hold',
				allowBlank:false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{ 
				fieldLabel: '구매요청일',
				name: 'ORDER_REQ_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_REQ_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
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
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			holdable: 'hold',
			child: 'WH_CODE',
			value: UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = masterForm.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
					var field2 = masterForm.getField('WH_CODE');		
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
						panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
						masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
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
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU',
			allowBlank: false,
			holdable: 'hold',
			colspan: '2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			holdable: 'hold',
			allowBlank:false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ORDER_PRSN', newValue);
				}
			}
		},{ 
			fieldLabel: '구매요청일',
			name: 'ORDER_REQ_DATE',
	        xtype: 'uniDatefield',
	        value: UniDate.get('today'),
	        allowBlank: false,
	        width: 200,
	        holdable: 'hold',
	        listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ORDER_REQ_DATE', newValue);
				}
			}
	    },{
			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), 
			child: 'ITEM_LEVEL2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ITEM_LEVEL1', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store'), 
			child: 'ITEM_LEVEL3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ITEM_LEVEL2', newValue);
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

    var salesSearch = Unilite.createSearchForm('salesForm', {//매출내역참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			child:'WH_CODE',
			readOnly: true,
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field2 = salesSearch.getField('WH_CODE');		
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
		 	textFieldName: 'DEPT_NAME',
			allowBlank: false,
			readOnly: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						salesSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
                   	},
					scope: this
				},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU',
			allowBlank: false,
			readOnly: true
		},{
			fieldLabel: '매출기간',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALES_DATE_FR',
			endFieldName: 'SALES_DATE_TO',
			startDate: UniDate.get('yesterday'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false
		},{
			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), 
			child: 'ITEM_LEVEL2'
		},{
			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store'), 
			child: 'ITEM_LEVEL3'
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
    
    var receptionSearch = Unilite.createSearchForm('receptionForm', {//매입처품목참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			child:'WH_CODE',
			value: UserInfo.divCode,
			readOnly: true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field2 = receptionSearch.getField('WH_CODE');		
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
		 	textFieldName: 'DEPT_NAME',
			allowBlank: false,
			readOnly: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						receptionSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
                   	},
					scope: this
				},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU',
			allowBlank: false,
			readOnly: true
		},
		Unilite.popup('CUST', { 
			fieldLabel: '매입처', 
			valueFieldName: 'CUSTOM_CODE',
		 	textFieldName: 'CUSTOM_NAME'
		}),{
			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel1Store'), 
			child: 'ITEM_LEVEL2'
		},{
			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2', 
			xtype: 'uniCombobox',  
			store: Ext.data.StoreManager.lookup('MPO060ukrvLevel2Store'), 
			child: 'ITEM_LEVEL3'
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
    var masterGrid= Unilite.createGrid('mpo060ukrvGrid', {
    	region: 'center',
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
        excelTitle: '구매요청등록',
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'salesBtn',
					text: '매출내역참조',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
							return false;
						}
						openSalesWindow();
					}
				},{
					itemId: 'receptionBtn',
					text: '매입처 품목참조',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
							return false;
						}
						openReceptionWindow();
					}
				}]
			})
		},{
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'refLinkBtn',
					text: '<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>',
					handler: function() {
						var params = {
							action: 'newMpo060',
							'DIV_CODE' : masterForm.getValue('DIV_CODE'),
							'DEPT_CODE' : masterForm.getValue('DEPT_CODE'),
							'DEPT_NAME' : masterForm.getValue('DEPT_NAME'),
							'WH_CODE' : masterForm.getValue('WH_CODE'),
							'ORDER_PRSN' : masterForm.getValue('ORDER_PRSN'),
							'ORDER_EXPECTED_FR' : masterForm.getValue('ORDER_REQ_DATE'),
							'ORDER_EXPECTED_TO' : masterForm.getValue('ORDER_REQ_DATE')
						}
						var rec = {data : {prgID : 'mpo201ukrv', 'text':'<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>'}};							
						parent.openTab(rec, '/matrl/mpo201ukrv.do', params);	
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
        	{dataIndex:'COMP_CODE'			, width: 88 ,hidden: true},
        	{dataIndex:'DIV_CODE'			, width: 88 ,hidden: true},
        	{dataIndex:'SEQ'				, width: 80},
        	{dataIndex:'ITEM_LEVEL1'		, width: 150,hidden: true},
        	{dataIndex:'ITEM_LEVEL2'		, width: 150,hidden: true},
        	{dataIndex:'ITEM_CODE'			, width: 120,
        		editor: Unilite.popup('DIV_PUMOK_G', {		
			 		textFieldName: 'ITEM_CODE',
			 		DBtextFieldName: 'ITEM_CODE',
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			 		useBarcodeScanner: false,
		            autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
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
							var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
							masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
							if(aa == 0){
								if(a != ''){
									alert("미등록상품입니다.");
									aa++;
								}
							}else{
								aa=0;	
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
        	},
        	{dataIndex:'ITEM_NAME'			, width: 300,
        		editor: Unilite.popup('DIV_PUMOK_G', {
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		            autoPopup: true,
					listeners: {
						'onSelected': {
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
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
        	},
        	{dataIndex:'AUTHOR1'			, width: 88,hidden:true},
        	{dataIndex:'PUBLISHER'	 		, width: 88,hidden:true},
        	{dataIndex: 'CUSTOM_CODE'	 	,width:150,
				editor: Unilite.popup('CUST_G',{
					textFieldName: 'CUSTOM_CODE',
					DBtextFieldName: 'CUSTOM_CODE',
		            autoPopup: true,
					listeners:{ 
						'onSelected': {
		                   	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
	                    	},
                    		scope: this
           	   			},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
	                  	}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'	 	,width:300,
				editor: Unilite.popup('CUST_G',{
		            autoPopup: true,
					listeners:{ 
						'onSelected': {
		                   	fn: function(records, type  ){
		                    	var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
	                    	},
                    		scope: this
              	   		},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
	                  	}
					}
				})
			},
        	{dataIndex:'WH_CODE'	 		, width: 88},
        	{dataIndex:'STOCK_Q'	 		, width: 88},
        	{dataIndex:'ORDER_REQ_Q'		, width: 88},
        	{dataIndex:'REMARK'				, width: 400}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == false){
					if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME','ORDER_REQ_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME','ITEM_CODE','ITEM_NAME','ORDER_REQ_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
				}
			}
		},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#refLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
       			grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
       			var param = {"ITEM_CODE": record['ITEM_CODE']};
				mpo060ukrvService.fnAuthPubli(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						grdRecord.set('AUTHOR1', provider['AUTHOR1']);
						grdRecord.set('PUBLISHER', provider['PUBLISHER']);
					}
				});
				var param = {"ITEM_CODE": record['ITEM_CODE'],
					"DIV_CODE": record['DIV_CODE']};
				mpo060ukrvService.fnCustom(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						grdRecord.set('CUSTOM_CODE', provider['CUSTOM_CODE']);
						grdRecord.set('CUSTOM_NAME', provider['CUSTOM_NAME']);
					}
				});
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ2, UserInfo.compCode, masterForm.getValue('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		},
		setSalesData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		masterForm.setValue('DEPT_CODE'		,salesSearch.getValue('DEPT_CODE'));
			masterForm.setValue('DEPT_NAME'		,salesSearch.getValue('DEPT_NAME'));
			masterForm.setValue('WH_CODE'		,salesSearch.getValue('WH_CODE'));
			masterForm.setValue('ITEM_LEVEL1'	,salesSearch.getValue('ITEM_LEVEL1'));
			masterForm.setValue('ITEM_LEVEL2'	,salesSearch.getValue('ITEM_LEVEL2'));
			panelResult.setValue('DEPT_CODE'	,salesSearch.getValue('DEPT_CODE'));
			panelResult.setValue('DEPT_NAME'	,salesSearch.getValue('DEPT_NAME'));
			panelResult.setValue('WH_CODE'		,salesSearch.getValue('WH_CODE'));
			panelResult.setValue('ITEM_LEVEL1'	,salesSearch.getValue('ITEM_LEVEL1'));
			panelResult.setValue('ITEM_LEVEL2'	,salesSearch.getValue('ITEM_LEVEL2'));
       		grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
       	    grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
			grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('AUTHOR1'				, record['AUTHOR1']);
			grdRecord.set('PUBLISHER'			, record['PUBLISHER']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('STOCK_Q'				, record['STOCK_Q']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('REMARK'				, record['REMARK']);
		},
		setReceptionData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		masterForm.setValue('DEPT_CODE'		,receptionSearch.getValue('DEPT_CODE'));
			masterForm.setValue('DEPT_NAME'		,receptionSearch.getValue('DEPT_NAME'));
			masterForm.setValue('WH_CODE'		,receptionSearch.getValue('WH_CODE'));
			masterForm.setValue('ITEM_LEVEL1'	,receptionSearch.getValue('ITEM_LEVEL1'));
			masterForm.setValue('ITEM_LEVEL2'	,receptionSearch.getValue('ITEM_LEVEL2'));
			panelResult.setValue('DEPT_CODE'	,receptionSearch.getValue('DEPT_CODE'));
			panelResult.setValue('DEPT_NAME'	,receptionSearch.getValue('DEPT_NAME'));
			panelResult.setValue('WH_CODE'		,receptionSearch.getValue('WH_CODE'));
			panelResult.setValue('ITEM_LEVEL1'	,receptionSearch.getValue('ITEM_LEVEL1'));
			panelResult.setValue('ITEM_LEVEL2'	,receptionSearch.getValue('ITEM_LEVEL2'));
       		grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
       	    grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
			grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('AUTHOR1'				, record['AUTHOR1']);
			grdRecord.set('PUBLISHER'			, record['PUBLISHER']);
			grdRecord.set('CUSTOM_CODE'			, record['PURCHASE_CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('STOCK_Q'				, record['STOCK_Q']);
			grdRecord.set('ORDER_REQ_Q'			, record['ORDER_REQ_Q']);
			grdRecord.set('REMARK'				, record['REMARK']);
		}
    });	
    
	var salesGrid = Unilite.createGrid('mpo060ukrvSalesGrid', {//매출내역참조
		excelTitle: '구매요청등록(매출참조)',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,  
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
			id: 'salesGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'salesGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: salesStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick:false }), 
        columns: [  
        	{dataIndex:'COMP_CODE'			, width: 88,hidden:true},
        	{dataIndex:'DIV_CODE'			, width: 88,hidden:true},
        	{dataIndex:'ITEM_LEVEL1'		, width: 88},
        	{dataIndex:'ITEM_LEVEL2'		, width: 88},
        	{dataIndex:'ITEM_CODE'			, width: 120},
        	{dataIndex:'ITEM_NAME'			, width: 138},
        	{dataIndex:'AUTHOR1'			, width: 88},
        	{dataIndex:'PUBLISHER'	 		, width: 88},
        	{dataIndex:'CUSTOM_CODE'		, width: 88},
        	{dataIndex:'CUSTOM_NAME'		, width: 88},
        	{dataIndex:'SALE_COMMON_P'	 	, width: 88,hidden:true},
        	{dataIndex:'SALE_BASIS_P'		, width: 88,hidden:true},
        	{dataIndex:'SALE_Q'				, width: 88},
        	{dataIndex:'SALE_AMT_O'			, width: 88},
        	{dataIndex:'WH_CODE'	 		, width: 88},
        	{dataIndex:'STOCK_Q'	 		, width: 88},
        	{dataIndex:'ORDER_REQ_Q'		, width: 88}
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
//          	var records = this.getSelectedRecords();
			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setSalesData(record.data);
		    }); 
			this.getStore().remove(records);
		}
	});
    function openSalesWindow() {    		//매출내역참조
    	if(!referSalesWindow) {
			referSalesWindow = Ext.create('widget.uniDetailWindow', {
	    	    title: '매출내역참조',
	            width: 1000,			                
	            height: 500,
	            layout: {type:'vbox', align:'stretch'},
	            items: [salesSearch, salesGrid],
	            tbar: ['->',{	
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(!UniAppManager.app.checkForNewDetail2()){
							return false;
						}else if(UniAppManager.app.checkForNewDetail2()){
							salesStore.loadStoreRecords();
						}
					},
					disabled: false
				},{	
					itemId : 'confirmBtn',
					text: '요청적용',
					handler: function() {
						salesGrid.returnData();
						UniAppManager.setToolbarButtons('delete', true);
					},
					disabled: false
				},{	
					itemId : 'confirmCloseBtn',
					text: '요청적용 후 닫기',
					handler: function() {
						salesGrid.returnData();
						referSalesWindow.hide();
						salesGrid.reset();
						salesSearch.clearForm();
						UniAppManager.setToolbarButtons('delete', true);
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						salesGrid.reset();
						salesSearch.clearForm();
						referSalesWindow.hide();
					},
					disabled: false
				}],
	            listeners: {
					beforehide: function(me, eOpt)	{
		    			salesSearch.clearForm();
		    		},
		    		beforeclose: function( panel, eOpts )	{
						salesSearch.clearForm();
		    		},
		    		beforeshow: function ( me, eOpts )	{
	    				salesSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
	    				salesSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
	    				salesSearch.setValue('SALES_DATE_FR',UniDate.get('yesterday'));
						salesSearch.setValue('SALES_DATE_TO',UniDate.get('today'));
						setTimeout(function(){
							salesSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
						}, 500)
		    				salesSearch.setValue('ITEM_LEVEL1',masterForm.getValue('ITEM_LEVEL1'));
		    				salesSearch.setValue('ITEM_LEVEL2',masterForm.getValue('ITEM_LEVEL2'));
		    				salesSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		    		}
	            }
			})
		}
		referSalesWindow.center();
		referSalesWindow.show();
	}
    
	var receptionGrid = Unilite.createGrid('mpo060ukrvReceptionGrid', {//매입처 품목참조
		excelTitle: '구매요청등록(매입처 품목참조)',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,  
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
			id: 'receptionGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'receptionGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: receptionStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick:false }), 
        columns: [  
        	{dataIndex:'COMP_CODE'				, width: 88,hidden:true},
        	{dataIndex:'DIV_CODE'				, width: 88,hidden:true},
        	{dataIndex:'PURCHASE_CUSTOM_CODE'	, width: 88},
        	{dataIndex:'CUSTOM_NAME'			, width: 88},
        	{dataIndex:'ITEM_LEVEL1'			, width: 88,hidden:true},
        	{dataIndex:'ITEM_LEVEL2'			, width: 88,hidden:true},
        	{dataIndex:'ITEM_CODE'				, width: 110},
        	{dataIndex:'ITEM_NAME'				, width: 130},
        	{dataIndex:'SALE_BASIS_P'			, width: 88},
        	{dataIndex:'TRNS_RATE'		    	, width: 88},
        	{dataIndex:'SAFETY_Q'	 			, width: 88},
        	{dataIndex:'EOQ'					, width: 88},
        	{dataIndex:'STOCK_Q'				, width: 88},
        	{dataIndex:'ORDER_REQ_Q'	 		, width: 88},
        	{dataIndex:'AUTHOR1'				, width: 88,hidden:true},
        	{dataIndex:'PUBLISHER'	 			, width: 88,hidden:true},
        	{dataIndex:'SALE_COMMON_P'			, width: 88,hidden:true},
        	{dataIndex:'WH_CODE'				, width: 88,hidden:true}
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
//          	var records = this.getSelectedRecords();
			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setReceptionData(record.data);
		    }); 
			this.getStore().remove(records);	
		}
	});	
	function openReceptionWindow() {    		//매입처 품목참조
		if(!referReceptionWindow) {
			referReceptionWindow = Ext.create('widget.uniDetailWindow', {
                title: '매입처 품목참조',
                width: 1000,			                
                height: 500,
                layout: {type:'vbox', align:'stretch'},
                items: [receptionSearch, receptionGrid],
                tbar: ['->',{	
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(!UniAppManager.app.checkForNewDetail3()){
							return false;
						}else if(UniAppManager.app.checkForNewDetail3()){
							receptionStore.loadStoreRecords();
						}
					},
					disabled: false
				},{	
					itemId : 'confirmBtn',
					text: '요청적용',
					handler: function() {
						receptionGrid.returnData();
						UniAppManager.setToolbarButtons('delete', true);
					},
					disabled: false
				},{	
					itemId : 'confirmCloseBtn',
					text: '요청적용 후 닫기',
					handler: function() {
						receptionGrid.returnData();
						referReceptionWindow.hide();
						receptionGrid.reset();
						receptionSearch.clearForm();
						UniAppManager.setToolbarButtons('delete', true);
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						receptionGrid.reset();
						receptionSearch.clearForm();
						referReceptionWindow.hide();
					},
					disabled: false
				}],
                listeners: {
					beforehide: function(me, eOpt)	{
	    				receptionSearch.clearForm();
	    			},
	    			beforeclose: function( panel, eOpts )	{
						receptionSearch.clearForm();
	    			},
	    			beforeshow: function ( me, eOpts )	{
	    				receptionSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
	    				receptionSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
						setTimeout(function(){
							receptionSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
						}, 500)
	    				receptionSearch.setValue('ITEM_LEVEL1',masterForm.getValue('ITEM_LEVEL1'));
	    				receptionSearch.setValue('ITEM_LEVEL2',masterForm.getValue('ITEM_LEVEL2'));
	    				receptionSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
	    			}
                }
			})
		}
		referReceptionWindow.center();
		referReceptionWindow.show();
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
		id: 'mpo060ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('ORDER_REQ_DATE',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_REQ_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			masterGrid.disabledLinkButtons(false);
			this.setDefault();
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			masterForm.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			mpo060ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();	
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			var seq = directMasterStore1.max('SEQ');
            if(!seq) seq = 1;
            else  seq += 1;
            var itemLevel1 = masterForm.getValue('ITEM_LEVEL1');
		    var itemLevel2 = masterForm.getValue('ITEM_LEVEL2');
		    var whCode = masterForm.getValue('WH_CODE');
		    var divCode = masterForm.getValue('DIV_CODE');
		    var compCode = UserInfo.compCode;
		    var r = {
		    	SEQ: 			seq,
		        ITEM_LEVEL1:	itemLevel1,
		        ITEM_LEVEL2:	itemLevel2,
		        WH_CODE:		whCode,
		        DIV_CODE:		divCode,
		        COMP_CODE:		compCode
		    };
				masterGrid.createRow(r);
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.clearData();
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
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
		},
		cbStockQ2: function(provider, params)	{  
	    	var rtnRecord = params.rtnRecord;
			var dStockQ = provider['STOCK_Q'];
	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
	    	var dBadStockQ = provider['BAD_STOCK_Q'];
	    	rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    },
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
        },
        checkForNewDetail2:function() { 
			return salesSearch.setAllFieldsReadOnly(true);
        },
        checkForNewDetail3:function() { 
			return receptionSearch.setAllFieldsReadOnly(true);
        }
	});	
	Unilite.createValidator('validator01', {
		store: salesStore,
		grid: salesGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_REQ_Q" :
					var sm = this.grid.getSelectionModel();
					if(newValue != 0){						
						var selRecords = this.grid.getSelectionModel().getSelection();
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( 
								(rec.get("COMP_CODE") 		==  record.get("COMP_CODE")) && 
								(rec.get("DIV_CODE") 		==  record.get("DIV_CODE")) && 
								(rec.get("ITEM_LEVEL1") 	==  record.get("ITEM_LEVEL1")) && 
								(rec.get("ITEM_LEVEL2") 	==  record.get("ITEM_LEVEL2")) &&
								(rec.get("ITEM_CODE") 		==  record.get("ITEM_CODE")) && 
								(rec.get("ITEM_NAME") 		==  record.get("ITEM_NAME")) &&
								(rec.get("AUTHOR1") 		==  record.get("AUTHOR1")) && 
								(rec.get("PUBLISHER") 		==  record.get("PUBLISHER")) &&
								(rec.get("CUSTOM_CODE") 	==  record.get("CUSTOM_CODE")) && 
								(rec.get("CUSTOM_NAME") 	==  record.get("CUSTOM_NAME")) &&
								(rec.get("SALE_COMMON_P") 	==  record.get("SALE_COMMON_P")) && 
								(rec.get("SALE_BASIS_P") 	==  record.get("SALE_BASIS_P")) &&
								(rec.get("SALE_Q") 			==  record.get("SALE_Q")) && 
								(rec.get("SALE_AMT_O") 		==  record.get("SALE_AMT_O")) &&
								(rec.get("WH_CODE") 		==  record.get("WH_CODE")) && 
								(rec.get("STOCK_Q") 		==  record.get("STOCK_Q"))
							){
								return rec;
							}
						})
						selRecords.push(this.grid.getStore().getAt(currRec));
						sm.select(selRecords);
					}else{
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( 
								(rec.get("COMP_CODE") 		==  record.get("COMP_CODE")) && 
								(rec.get("DIV_CODE") 		==  record.get("DIV_CODE")) && 
								(rec.get("ITEM_LEVEL1") 	==  record.get("ITEM_LEVEL1")) && 
								(rec.get("ITEM_LEVEL2") 	==  record.get("ITEM_LEVEL2")) &&
								(rec.get("ITEM_CODE") 		==  record.get("ITEM_CODE")) && 
								(rec.get("ITEM_NAME") 		==  record.get("ITEM_NAME")) &&
								(rec.get("AUTHOR1") 		==  record.get("AUTHOR1")) && 
								(rec.get("PUBLISHER") 		==  record.get("PUBLISHER")) &&
								(rec.get("CUSTOM_CODE") 	==  record.get("CUSTOM_CODE")) && 
								(rec.get("CUSTOM_NAME") 	==  record.get("CUSTOM_NAME")) &&
								(rec.get("SALE_COMMON_P") 	==  record.get("SALE_COMMON_P")) && 
								(rec.get("SALE_BASIS_P") 	==  record.get("SALE_BASIS_P")) &&
								(rec.get("SALE_Q") 			==  record.get("SALE_Q")) && 
								(rec.get("SALE_AMT_O") 		==  record.get("SALE_AMT_O")) &&
								(rec.get("WH_CODE") 		==  record.get("WH_CODE")) && 
								(rec.get("STOCK_Q") 		==  record.get("STOCK_Q")) 
							){
								return rec;
							}
						})
						sm.deselect(this.grid.getStore().getAt(currRec));
					}
					break;
			}
				return rv;
		}
	});
			
	Unilite.createValidator('validator02', {
		store: receptionStore,
		grid: receptionGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_REQ_Q" :
					var sm = this.grid.getSelectionModel();
					if(newValue != 0){						
						var selRecords = this.grid.getSelectionModel().getSelection();
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( 
								(rec.get("COMP_CODE") 				==  record.get("COMP_CODE")) &&
								(rec.get("DIV_CODE") 				==  record.get("DIV_CODE")) && 
								(rec.get("PURCHASE_CUSTOM_CODE") 	==  record.get("PURCHASE_CUSTOM_CODE")) && 
								(rec.get("CUSTOM_NAME") 			==  record.get("CUSTOM_NAME")) && 
								(rec.get("ITEM_LEVEL1") 			==  record.get("ITEM_LEVEL1")) && 
								(rec.get("ITEM_LEVEL2") 			==  record.get("ITEM_LEVEL2")) && 
								(rec.get("ITEM_CODE") 				==  record.get("ITEM_CODE")) && 
								(rec.get("ITEM_NAME") 				==  record.get("ITEM_NAME")) && 
								(rec.get("SALE_BASIS_P") 			==  record.get("SALE_BASIS_P")) && 
								(rec.get("SAFETY_Q") 				==  record.get("SAFETY_Q")) && 
								(rec.get("EOQ") 					==  record.get("EOQ")) && 
								(rec.get("STOCK_Q") 				==  record.get("STOCK_Q")) && 
								(rec.get("AUTHOR1") 				==  record.get("AUTHOR1")) && 
								(rec.get("PUBLISHER") 				==  record.get("PUBLISHER")) && 
								(rec.get("SALE_COMMON_P") 			==  record.get("SALE_COMMON_P")) && 
								(rec.get("WH_CODE") 				==  record.get("WH_CODE")) 
							){
								return rec;
							}
						})
						selRecords.push(this.grid.getStore().getAt(currRec));
						sm.select(selRecords);
					}else{
						var currRec = this.grid.getStore().findBy(function(rec,id){
							if( 
								(rec.get("COMP_CODE") 				==  record.get("COMP_CODE")) &&
								(rec.get("DIV_CODE") 				==  record.get("DIV_CODE")) && 
								(rec.get("PURCHASE_CUSTOM_CODE") 	==  record.get("PURCHASE_CUSTOM_CODE")) && 
								(rec.get("CUSTOM_NAME") 			==  record.get("CUSTOM_NAME")) && 
								(rec.get("ITEM_LEVEL1") 			==  record.get("ITEM_LEVEL1")) && 
								(rec.get("ITEM_LEVEL2") 			==  record.get("ITEM_LEVEL2")) && 
								(rec.get("ITEM_CODE") 				==  record.get("ITEM_CODE")) && 
								(rec.get("ITEM_NAME") 				==  record.get("ITEM_NAME")) && 
								(rec.get("SALE_BASIS_P") 			==  record.get("SALE_BASIS_P")) && 
								(rec.get("SAFETY_Q") 				==  record.get("SAFETY_Q")) && 
								(rec.get("EOQ") 					==  record.get("EOQ")) && 
								(rec.get("STOCK_Q") 				==  record.get("STOCK_Q")) && 
								(rec.get("AUTHOR1") 				==  record.get("AUTHOR1")) && 
								(rec.get("PUBLISHER") 				==  record.get("PUBLISHER")) && 
								(rec.get("SALE_COMMON_P") 			==  record.get("SALE_COMMON_P")) && 
								(rec.get("WH_CODE") 				==  record.get("WH_CODE"))
							){
								return rec;
							}
						})
						sm.deselect(this.grid.getStore().getAt(currRec));
					}
					break;
			}
			return rv;
		}
	});
};
</script>
