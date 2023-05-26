<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_map130rkrv_yg"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa460rkrv"  />
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="AU" comboCode="S801" />
	<t:ExtComboStore comboType="AU" comboCode="S802" />
	<t:ExtComboStore comboType="AU" comboCode="S804" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
	    	fieldLabel: '신고사업장',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode,
	    	child: 'WH_CODE'
    	},{
    		fieldLabel: '계산서일',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'FR_DATE',
    		endFieldName: 'TO_DATE',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315,
    		allowBlank:false
		},{
    		fieldLabel: '결의일',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'FR_DATE2',
    		endFieldName: 'TO_DATE2',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315
		},Unilite.popup('CUST',{
            fieldLabel: '거래처',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME'
        }),{
			fieldLabel: '입고창고',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel: '매입형태',
			name: 'ACCOUNT_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'M302'
		},{
			fieldLabel: '발주형태',
			name: 'ORDER_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'M001'
		},{
			fieldLabel: '품목계정',
			name: 'ITEM_ACCOUNT',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020'
		},{ 
			fieldLabel: '대분류', 
			name: 'ITEM_LEVEL1', 
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
			child: 'ITEM_LEVEL2'
		},{ 
			fieldLabel: '중분류', 
			name: 'ITEM_LEVEL2', 
			xtype: 'uniCombobox', 
			store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			child: 'ITEM_LEVEL3'
		},{ 
			fieldLabel: '소분류', 
			name: 'ITEM_LEVEL3', 
			xtype: 'uniCombobox', 
			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
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
		}],	
		id  : 's_map130rkrv_ygApp',
		fnInitBinding : function() {

            panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE2',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE2',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			
			param["sTxtValue2_fileTitle"]='외상매입금내역';
			param["RPT_ID"]='s_map130rkrv_yg';
			param["PGM_ID"]='s_map130rkrv_yg';
			
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_yg/s_map130crkrv_yg.do',
                prgID: 's_map130rkrv_yg',
                extParam: param
            });
				win.center();
				win.show();
        	
		}
	});
};

</script>
