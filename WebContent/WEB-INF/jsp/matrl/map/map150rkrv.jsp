<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map150rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map150rkrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="O" />    <!-- 창고   -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >
	function appMain() {
		var panelSearch = Unilite.createSearchForm('searchForm',{
				region: 'center',
				layout : {type : 'uniTable', columns : 1},
				padding:'1 1 1 1',
				border:true,
				items:[{
						xtype: 'radiogroup',		            		
						fieldLabel: '<t:message code="system.label.purchase.reporttype" default="보고서유형"/>',
						colspan:2,
						items:[{
							boxLabel: '<t:message code="system.label.purchase.itemby" default="품목별"/>', 
							width: 90, 
							name: 'rdoPrintItem',
							inputValue: '1',
							checked: true
						},{
							boxLabel : '<t:message code="system.label.purchase.customby" default="거래처별"/>', 
							width: 120,
							name: 'rdoPrintItem',
							inputValue: '2'
						}]
					},{
						fieldLabel:'<t:message code="system.label.purchase.division" default="사업장"/>',
						xtype: 'uniCombobox',
						comboType: 'BOR120',
						name:'DIV_CODE',
						allowBlank:false,
						value: UserInfo.divCode,
                        listeners : {
                           change : function(combo, newValue,oldValue, eOpts) {
                                panelSearch.setValue('WH_CODE', '');
                           }
                        }
					},{
						fieldLabel:'<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'FR_DATE',
	            		endFieldName:'TO_DATE',
	            		width:315,
	            		startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today'),
						allowBlank:false
					},{
						fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
						name: 'ORDER_TYPE', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'M001'
					},
					Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
						valueFieldName: 'CUSTOM_CODE',
                        textFieldName:'CUSTOM_NAME',
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUSTOM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUSTOM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUSTOM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUSTOM_CODE', '');
										}
									}
					}
					}),
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
						valueFieldName: 'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('ITEM_CODE', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('ITEM_NAME', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('ITEM_NAME', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('ITEM_CODE', '');
										}
									},
								applyextparam: function(popup){	// 2021.08 표준화 작업
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								}
							}
					}),{
						fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>', 
						name: 'INOUT_PRSN', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'M201'
					},{
						fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>', 
						name: 'INOUT_TYPE', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'M103'
					},{
						fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>', 
						name: 'WH_CODE', 
						xtype: 'uniCombobox', 
						comboType   : 'O',
						listeners : {
                         beforequery:function( queryPlan, eOpts )   {
                                var store = queryPlan.combo.store;
                                    store.clearFilter();
                                if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                                        store.filterBy(function(record){
                                        return record.get('option') == panelSearch.getValue('DIV_CODE');
                                    })
                                }else{
                                store.filterBy(function(record){
                                     return false;   
                                })
                             }
                           }
						}
					},{
						fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 
						name: 'ITEM_ACCOUNT', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'B020'
					},{ 
		                fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
		                name: 'ITEM_LEVEL1', 
		                xtype: 'uniCombobox',
		                store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		                child: 'ITEM_LEVEL2'
		            },{
						fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
		                name: 'ITEM_LEVEL2',
		                xtype: 'uniCombobox',
		                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
		                child: 'ITEM_LEVEL3'
					},{
						fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
		                name: 'ITEM_LEVEL3', 
		                xtype: 'uniCombobox',
		                store: Ext.data.StoreManager.lookup('itemLeve3Store')
					}
				]
		});
		Unilite.Main({
			borderItems:[{
				region:'center',
				layout: 'border',
				border: true,
				items:[
					panelSearch
				]
			}],
			id  : 'map150rkrvApp',
			fnInitBinding : function() {
                panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE',UniDate.get('today'));
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
				var param = panelSearch.getValues();
				if(param.rdoPrintItem=='1'){
					param.sPrintFlag = "ITEM";
					param.sPrintFlagStr = '<t:message code="system.label.purchase.itemby" default="품목별"/>';
					param["sTxtValue2_fileTitle"]='<t:message code="system.label.purchase.pendingslipprintitem" default="미지급결의출력(품목별)"/>';
					param["RPT_ID"]='map150rkrv1';
				}else if(param.rdoPrintItem=='2'){
					param.sPrintFlag = "CUSTOM";
					param.sPrintFlagStr = '<t:message code="system.label.purchase.customby" default="거래처별"/>';
					param["sTxtValue2_fileTitle"]='<t:message code="system.label.purchase.pendingslipprintcustom" default="미지급결의출력(거래처별)"/>';
					param["RPT_ID"]='map150rkrv2';
				}	
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/matrl/map150crkrv.do',
                    prgID: 'map150rkrv',
                    extParam: param
                });
					win.center();
					win.show();
            }
        });
	}
</script>