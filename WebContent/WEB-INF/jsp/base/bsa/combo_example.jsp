<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="O" />
<t:ExtComboStore comboType="W" />
<t:ExtComboStore comboType="OU" />
<t:ExtComboStore comboType="WU" />
<t:ExtComboStore items="${WH_LIST}" storeId="pgmId_WhList" />
<t:ExtComboStore items="${WHU_LIST}" storeId="pgmId_WhUList" />
<t:ExtComboStore items="${WS_LIST}" storeId="pgmId_WsList" />
<t:ExtComboStore items="${WSU_LIST}" storeId="pgmId_WsUList" />
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
   	var detailForm = Unilite.createForm('pgmId_Detail', {
	    id : 'bcm100ukrvDetail',
	    layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
	    defaultType: 'fieldset',
	    defaults : { margin: '5 5 5 5',anchor: '100%'},
	    disabled: false,
	    items : [
	    		/*{
					fieldLabel : '창고', //(combType :W) 
					name : 'WH_CODE',
					xtype : 'uniCombobox',					
					store: Ext.data.StoreManager.lookup('pgmId_WhList')
				} , {
					fieldLabel : '창고',//(combType :WU) 
					name : 'WHU_CODE',
					xtype : 'uniCombobox',
					store: Ext.data.StoreManager.lookup('pgmId_WhUList')
				} , {
					fieldLabel : '작업장', //(combType :O) 
					name : 'WORK_SHOP_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('pgmId_WsList')
				} , {
					fieldLabel : '작업장', //(combType :OU) 
					name : 'WORK_SHOP_USE_CODE',
					xtype : 'uniCombobox',
					store: Ext.data.StoreManager.lookup('pgmId_WsUList')
					
				} 
				
				, */{
					fieldLabel : '창고(O)', //(combType :OU) 
					name : 'WH_CODE',
					xtype : 'uniCombobox',
					comboType:'O'
				},
				{
					fieldLabel : '창고(OU)', 
					name : 'WHU_CODE',
					xtype : 'uniCombobox',
					comboType:'OU'
				},{
					fieldLabel : '작업쟝(W)',
					name : 'WS_CODE',
					xtype : 'uniCombobox',
					comboType:'W'
				},{
					fieldLabel : '작업쟝(WU)', 
					name : 'WSU_CODE',
					xtype : 'uniCombobox',
					comboType:'W'
				}
	      ]
    
    });
    
    Unilite.Main( {
			 items 	: [ detailForm]
		})
}
</script>

