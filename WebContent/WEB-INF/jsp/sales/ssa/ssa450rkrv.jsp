<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa450rkrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="ssa450rkrv"  />          <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
    <t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >
	function appMain() {
		var panelSearch =  Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 2},
			padding:'1 1 1 1',
			border:true,
			items:[{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.reporttype" default="보고서유형"/>',
				colspan:2,
				items:[{
					boxLabel: '<t:message code="system.label.sales.itemby" default="품목별"/>',
					width: 90,
					name: 'rdoPrintItem',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.sales.clientby" default="고객별"/>',
					width: 70,
					name: 'rdoPrintItem',
					inputValue: '2'
				},{
					boxLabel : '<t:message code="system.label.sales.saleschargeby" default="영업담당별"/>',
					width: 100,
					name: 'rdoPrintItem',
					inputValue: '3'
				}]
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' ,
                name: 'SALE_PRSN',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'S010',
                colspan:2
			},{
				fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				allowBlank:true,
				value: UserInfo.divCode,
                colspan:2
			},
			Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					colspan:2,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					validateBlank	: false,
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					colspan			: 2,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
				{
            		fieldLabel:'<t:message code="system.label.sales.salesdate" default="매출일"/>',
            		xtype: 'uniDateRangefield',
            		startFieldName: 'FR_DATE',
            		endFieldName:'TO_DATE',
            		width:315,
                	colspan:2,
            		startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},{
					fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>' ,
	                name: 'BILL_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'S024'
				},{
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' ,
	                name: 'PROJECT_NO'
				},{
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' ,
	                name: 'AGENT_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B055'
				},{
	                fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
	                name: 'AREA_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B056'
	            },{
					fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
	                name: 'INOUT_TYPE_DETAIL',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'S007'
				},{
	                fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'  ,
	                name: 'ORDER_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'S002'
	            },{
	                fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
	                name: 'ITEM_LEVEL1',
	                xtype: 'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve1Store'),
	                child: 'ITEM_LEVEL2',
	                colspan:2
	            },{
					fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
	                name: 'ITEM_LEVEL2',
	                xtype: 'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
	                child: 'ITEM_LEVEL3',
	                colspan:2
				},{
					fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
	                name: 'ITEM_LEVEL3',
	                xtype: 'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve3Store'),
	                colspan:2
				},
				Unilite.popup('ITEM_GROUP',{
	                fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
	                textFieldName: 'ITEM_GROUP_CODE',
	                valueFieldName: 'ITEM_GROUP_NAME',
	                validateBlank: false,
	                popupWidth: 710,
	                colspan:2
	             }),
	            Unilite.popup('AGENT_CUST',{
	                fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
	                validateBlank: false,
	                valueFieldName: 'MANAGE_CUSTOM',
	                textFieldName: 'MANAGE_CUSTOM_NAME',
	                id: 'ssa450rkrvvCustPopup',
	                colspan:2,
	                listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('MANAGE_CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('MANAGE_CUSTOM', '');
							}
						}
					}
	            }),
	            	{
				 	 	xtype: 'container',
			   			defaultType: 'uniNumberfield',
						layout: {type: 'hbox', align:'stretch'},
						width:325,
						margin:0,
						colspan:2,
						items:[{
							fieldLabel:'<t:message code="system.label.sales.salesqty" default="매출량"/>',
							suffixTpl:'&nbsp;~&nbsp;',
							name: 'FR_ORDER_QTY',
							width:218
						}, {
							name: 'TO_ORDER_QTY',
							width:107
					}]
				},{
	            	xtype: 'radiogroup',
            		fieldLabel: '<t:message code="system.label.sales.salesslipyn" default="매출기표유무"/>',
            		colspan:2,
            		items:[{
            				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
            				name: 'SALE_YN',
                            width:70,
            				inputValue: 'A',
            				checked: true
            			},{
            				boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>',
            				name: 'SALE_YN',
                            width:70,
            				inputValue: 'Y'
            			},{
            				boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
            				name: 'SALE_YN',
                            width:70,
            				inputValue: 'N'
            			}
            		]
	            },{
	            	xtype: 'radiogroup',
            		fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
            		items:[{
            				boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
            				name: 'TRADE_OUT',
                            width:70,
            				inputValue: 'S',
            				checked: true
            			},{
            				boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
            				name: 'TRADE_OUT',
                            width:70,
            				inputValue: 'T'
            			}
            		]
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
					}
				],
				id  : 'ssa450rkrvApp',
				fnInitBinding : function() {
					UniAppManager.setToolbarButtons('print',true);
					UniAppManager.setToolbarButtons('query',false);

					panelSearch.setValue('rdoPrintItem','1');
                    panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                    panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                    panelSearch.setValue('TO_DATE',UniDate.get('today'));
                    panelSearch.setValue('SALE_YN','A');
                    panelSearch.setValue('TRADE_OUT','S');
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
							param.sPrintFlagStr = "<t:message code="system.label.sales.itemtotal" default="품목계"/>";
							param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.notbillingstatusprint" default="미매출현황출력"/>(<t:message code="system.label.sales.itemtotal" default="품목계"/>)';
							param["RPT_ID"]='ssa450rkrv1';
						}else if(param.rdoPrintItem=='2'){
							param.sPrintFlag = "CUSTOM";
							param.sPrintFlagStr = "<t:message code="system.label.sales.clienttotal" default="고객계"/>";
							param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.notbillingstatusprint" default="미매출현황출력"/>(<t:message code="system.label.sales.clienttotal" default="고객계"/>)';
							param["RPT_ID"]='ssa450rkrv2';
						}else{
							param.sPrintFlag = "PRSN";
							param.sPrintFlagStr = "<t:message code="system.label.sales.saleschargetotal" default="영업담당계"/>";
							param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.notbillingstatusprint" default="미매출현황출력"/>(<t:message code="system.label.sales.saleschargetotal" default="영업담당계"/>)';
							param["RPT_ID"]='ssa450rkrv3';
						}
						param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
						if(param.TRADE_OUT=='S'){
							param["TRADE_OUT"]='S'
						}else{
							param["TRADE_OUT"]='T'
						}
						var win = Ext.create('widget.CrystalReport', {
		                    url: CPATH+'/sales/ssa450crkrv.do',
		                    prgID: 'ssa450rkrv',
		                    extParam: param
		                });
							win.center();
							win.show();



				}
		});
	}
</script>