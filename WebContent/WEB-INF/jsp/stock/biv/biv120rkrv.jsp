<%@page language="java" contentType="text/html; charset=utf-8"%>
    <t:appConfig pgmId="biv120rkrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="biv120rkrv"/>                    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                         <!-- 품목계정 -->
    //<t:ExtComboStore items="${COMBO_WH_LIST}"       storeId="whList" />         <!-- 창고-->
    <t:ExtComboStore comboType="O" storeId="whList" />     <!--창고(전체) -->
    <t:ExtComboStore items="${COMBO_WH_CELL_LIST}"  storeId="whCellList" />     <!-- 창고Cell-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}"   storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}"   storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}"   storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = { // 컨트롤러에서 값을 받아옴
    gsSumTypeLot  : '${gsSumTypeLot}',
    gsSumTypeCell : '${gsSumTypeCell}'
};

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
	    	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120',
	    	comboCode:'B001',
			child:'WH_CODE',
	    	allowBlank:false,
	    	value: UserInfo.divCode
    	},{
            fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
            name:'WH_CODE',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('whList'),
            child: 'WH_CELL_CODE',
            allowBlank: false
        },{
            fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>',
            name: 'WH_CELL_CODE',
            xtype:'uniCombobox',
            store: Ext.data.StoreManager.lookup('whCellList')
        },
            Unilite.popup('COUNT_DATE', { 
                fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>', 
                //fieldStyle: 'text-align: center;',
                allowBlank: false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        	if(!Ext.isEmpty(records)){
                        		var countDate = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
                                countDate = countDate.substring(0, 4) + '.' + countDate.substring(4, 6) + '.' + countDate.substring(6, 8);
                                panelResult.setValue('COUNT_DATE', countDate);
                                panelResult.setValue('WH_CODE', records[0]['WH_CODE']);
                        	}
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('COUNT_DATE', '');
                        panelResult.setValue('WH_CODE', '');
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
			comboCode:'B020'
		},{
            fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
            name: 'TXTLV_L1', 
            xtype: 'uniCombobox',  
            store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
            child: 'TXTLV_L2'
        },{
            fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
            name: 'TXTLV_L2', 
            xtype: 'uniCombobox',  
            store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
            child: 'TXTLV_L3'
        },{
            fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>', 
            name: 'TXTLV_L3', 
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
            parentNames:['TXTLV_L1','TXTLV_L2'],
            levelType:'ITEM'
        }]
    });		

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}	
		],	
		id  : 'biv120rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('print', true);
			UniAppManager.setToolbarButtons('query', false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(this.onFormValidate()) {
                var param = panelResult.getValues();
                
                param.gsSumTypeLot  = BsaCodeInfo.gsSumTypeLot;
                param.gsSumTypeCell = BsaCodeInfo.gsSumTypeCell;
                        
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/stock/biv120crkrv.do',
                    prgID: 'biv120crkrv',
                        extParam: param
                    });
                    win.center();
                    win.show();
            }
        },
	    onFormValidate: function() {
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );
   	
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
			}
			return r;
	    }
	});
};

</script>