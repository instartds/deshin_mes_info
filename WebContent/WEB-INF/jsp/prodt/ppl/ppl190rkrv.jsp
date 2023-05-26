<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl190rkrv"  >
	<t:ExtComboStore comboType="BOR120" /> 					 	 <!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->  
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var panelResult = Unilite.createSearchForm('ppl190rkrvForm', {
		region: 'center',
		padding:'1 1 1 1',
		border:false,
	 	layout : {type : 'uniTable', columns : 1},
    	items :[{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			store: Ext.data.StoreManager.lookup('wsList')
		},{
        	fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
        	name: 'BASIS_YYYYMM',
        	xtype: 'uniMonthfield',
	 		value: UniDate.get('startOfMonth'),
        	allowBlank: false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank:false,
			valueFieldName:'ITEM_CODE',
    		textFieldName:'ITEM_NAME'
		}),
		{
	    	fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
	    	name: 'TXTLV_L1',
	    	xtype: 'uniCombobox',
	    	store: Ext.data.StoreManager.lookup('itemLeve1Store'),
	    	child: 'TXTLV_L2'
		},{
		    fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
		    name: 'TXTLV_L2',
		    xtype: 'uniCombobox',
		    store: Ext.data.StoreManager.lookup('itemLeve2Store'),
		    child: 'TXTLV_L3'
		},{
		    fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
		    name: 'TXTLV_L3',
		    xtype: 'uniCombobox',
		    store: Ext.data.StoreManager.lookup('itemLeve3Store')
    	}]
	});
    Unilite.Main({
        border: false,
        items: [panelResult],
		id : 'ppl190rkrvApp',
		fnInitBinding : function(param) {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('BASIS_YYYYMM', UniDate.get('startOfMonth'));
			
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown : function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getForm().getValues();
			param.FR_DATE = UniDate.get('startOfMonth', param.BASIS_YYYYMM + '01'); //계획일(FROM)
			param.TO_DATE = UniDate.get('endOfMonth', param.BASIS_YYYYMM + '01');	//계획일(TO)
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/prodt/ppl190crkrv.do',
                prgID: 'ppl190rkrv',
                extParam: param
            });
			win.center();
			win.show();
    	}
	});
};
</script>

