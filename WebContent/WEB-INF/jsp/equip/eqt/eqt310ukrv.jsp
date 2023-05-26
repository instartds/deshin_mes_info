<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="eqt310ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />

</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{
	    	xtype: 'grouptabpanel',
	    	itemId: 'eqt310Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				{xtype:'ConfigCodeGrid', subCode:'P700', codeName:'<t:message code="system.label.product.stopmachinecode" default="비가동코드"/>'},
				{xtype:'ConfigCodeGrid', subCode:'P003', codeName:'<t:message code="system.label.product.defecttype" default="불량유형"/>'}
			]
	    	 ,listeners:{
		    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								oldCard.getStore().rejectChanges();
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
							}
		    			 }else {
		    			 	UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
		    			 }
		    		}
		    	}
		    }
	    }]
    })


	 Unilite.Main( {
		borderItems:[
			panelDetail
		],
		id : 'eqt310ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData','print'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{
			var activeTab = panelDetail.down('#eqt310Tab').getActiveTab();
			this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#eqt310Tab').getActiveTab();
			this.createTabData(activeTab, activeTab.getSubCode())
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#eqt310Tab').getActiveTab();
			activeTab.getStore().saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#eqt310Tab').getActiveTab();
			activeTab.deleteSelectedRow();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		loadTabData: function(tab, itemId, mainCode){
			//tab.down('#'+itemId).getStore().loadStoreRecords({'MAIN_CODE':mainCode});
			tab.getStore().load({params:{'MAIN_CODE':mainCode}});
		},
		createTabData: function(tab, mainCode){
			tab.createRow({'MAIN_CODE':mainCode});
		}

	});
};


</script>
