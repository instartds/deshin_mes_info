<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr130rkrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당(=수불담당?) -->
   <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 (O) -->
   <t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 품목계정 B004? -->
   <t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
   <t:ExtComboStore comboType="AU" comboCode="M505" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 통화 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	var BsaCodeInfo = {
		gsInOutPrsn: '${gsInOutPrsn}'
	};
	function appMain() {
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[{
				xtype: 'radiogroup',
        		fieldLabel: '<t:message code="system.label.purchase.reporttype" default="보고서유형"/>',
    			items: [{
    				boxLabel: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
    				name: 'PRINT_GB',
                    width:70,
    				inputValue: 'S',
    				checked: true
    			},{
    				boxLabel: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
    				name: 'PRINT_GB' ,
    				inputValue: 'T'
    			}]
			},{
				fieldLabel:'<t:message code="system.label.purchase.division" default="사업장"/>',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				child: 'WH_CODE',
				allowBlank:false,
				value: UserInfo.divCode
			},{
				fieldLabel:'<t:message code="system.label.purchase.salesdate" default="매출일"/>',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'FR_DATE',
        		endFieldName:'TO_DATE',
        		width:315,
        		startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'M001'
			},Unilite.popup('AGENT_CUST', {
                fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME',
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
            }),Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
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
				comboCode: 'B024'
           },{
           		fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>',
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M103'
           },{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
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
				child: 'TXTLV_L2'
           },{
           		fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
           },{
           		fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
           }]
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
			id  : 'mtr130rkrvApp',
			fnInitBinding : function() {
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE',UniDate.get('today'));
                panelSearch.setValue('PRINT_GB','S');
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
				var param = panelSearch.getValues();
				if(param.PRINT_GB=='S'){
					param.sPrintFlag = "ITEM";
					param.sPrintFlagStr = "품목별";
					param["sTxtValue2_fileTitle"]='입고현황(품목별)';
					param["RPT_ID"]='mtr130rkrv1';
				}else{
					param.sPrintFlag = "CUSTOM";
					param.sPrintFlagStr = "거래처별";
					param["sTxtValue2_fileTitle"]='입고현황(거래처별)';
					param["RPT_ID"]='mtr130rkrv2';
				}
				param["PGM_ID"]='mtr130rkrv';
				param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();

				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/matrl/mtr130crkrv.do',
                    prgID: 'mtr130rkrv',
                    extParam: param
                });
					win.center();
					win.show();

			}
		});
	}
</script>