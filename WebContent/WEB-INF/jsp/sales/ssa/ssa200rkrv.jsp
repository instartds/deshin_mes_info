<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa200rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa200rkrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="O" />     <!--창고(전체) -->
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 2},
			padding:'1 1 1 1',
			border:true,
			items:[{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.reporttype" default="보고서유형"/>',
				colspan:2,
					items:[{
						boxLabel: '<t:message code="system.label.sales.clientby" default="고객별"/>',
						width: 90,
						name: 'rdoPrintItem',
						inputValue: "1",
						checked: true
					},{
						boxLabel : '<t:message code="system.label.sales.itemby" default="품목별"/>',
						width: 70,
						name: 'rdoPrintItem',
						inputValue: "2"
					}]
				},{
					fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					name:'DIV_CODE',
					allowBlank:true,
					value: UserInfo.divCode,
					colspan:2
				},{
					fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>' ,
	                name: 'INOUT_PRSN',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B024',
					colspan:2
				},{
	                fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
	                name: 'WH_CODE',
	            	xtype: 'uniCombobox',
	            	comboType: 'O',
					colspan:2
				},Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					colspan:2,
					listeners:{
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
				Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					validateBlank	: false,
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					colspan:2,
					listeners:{
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
				}),{
					fieldLabel:'<t:message code="system.label.sales.issuedate" default="출고일"/>',
            		xtype: 'uniDateRangefield',
            		startFieldName: 'FR_DATE',
            		endFieldName:'TO_DATE',
            		width:315,
            		startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					colspan:2
				},{
                    fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
                    xtype: 'uniTextfield',
                    name: 'INOUT_NUM_FR'/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('INOUT_NUM_FR', newValue);
                        }
                    } */
                },{
                    fieldLabel: '~',
                    xtype: 'uniTextfield',
                    name: 'INOUT_NUM_TO',
                    labelWidth: 12/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('INOUT_NUM_TO', newValue);
                        }
                    } */
                },{
                	fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>' ,
	                name: 'PROJECT_NO',
					colspan:2
                },{
                	fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' ,
	                name: 'AGENT_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B055',
					colspan:2
                },{
                	fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
	                name: 'AREA_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B056',
					colspan:2
                },{
                	fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
	                name: 'INOUT_TYPE',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'S007',
					colspan:2
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
				},Unilite.popup('ITEM_GROUP',{
	                fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
	                textFieldName: 'ITEM_GROUP_CODE',
	                valueFieldName: 'ITEM_GROUP_NAME',
	                validateBlank: false,
	                popupWidth: 710,
					colspan:2
	             }),{
	             	fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>' ,
	                name: 'ITEM_ACCOUNT',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'B020',
					colspan:2
	             },{
	             	fieldLabel: '<t:message code="system.label.sales.salessubject" default="매출대상"/>' ,
	                name: 'ACCOUNT_YN',
	                xtype: 'uniCombobox',
	                comboType: 'AU',
	                comboCode: 'S014',
					colspan:2
	             },{
	             	xtype: 'radiogroup',
            		fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
            		items:[
            			{
            				boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
            				name: 'TRADE_YN',
                            width:70,
            				inputValue: 'Y',
            				checked: true
            			},{
            				boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
            				name: 'TRADE_YN',
                            width:70,
            				inputValue: 'N'
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
				id  : 'ssa200rkrvApp',
				fnInitBinding : function() {
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
						param.sPrintFlag = "CUSTOM";
						param.sPrintFlagStr = "<t:message code="system.label.sales.clienttotal" default="고객계"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.notbillingstatusprint" default="미매출현황출력"/>(<t:message code="system.label.sales.clienttotal" default="고객계"/>)';
						param["RPT_ID"]='ssa200rkrv1';
					}else if(param.rdoPrintItem=='2'){
						param.sPrintFlag = "ITEM";
						param.sPrintFlagStr = "<t:message code="system.label.sales.itemtotal" default="품목계"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.notbillingstatusprint" default="미매출현황출력"/>(<t:message code="system.label.sales.itemtotal" default="품목계"/>)';
						param["RPT_ID"]='ssa200rkrv2';
					}
					param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
					param["SALE_PRSN"] = panelSearch.getField('INOUT_PRSN').getRawValue();
					param["WH_NAME"] = panelSearch.getField('WH_CODE').getRawValue();
					var win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/sales/ssa200crkrv.do',
	                    prgID: 'ssa200rkrv',
	                    extParam: param
	                });
						win.center();
						win.show();
				}
		});
	}
</script>