<%@page language="java" contentType="text/html; charset=utf-8"%><%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
</style>
<script type="text/javascript" >
function appMain() {   
	
	var systemYNStore = Unilite.createStore('cbm200ukrvsYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'1'},
			        {'text':'아니오'	, 'value':'2'}
	    		]
	});
	
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'cbm200Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	
	    	items: [
				{xtype:'ConfigCodeGrid', tdStyle:{width:250}, cellWidth:250, subCode:'CA03', codeName:'비목을 부문별로<br/>&nbsp;&nbsp;&nbsp;집계시 배부기준'},
				{xtype:'ConfigCodeGrid', subCode:'CA05', codeName:'보조부문을 제조<br/>&nbsp;&nbsp;&nbsp;부문별로 배부시<br/>&nbsp;&nbsp;&nbsp;배부기준'}
	    	 ]
	    	 ,listeners:{
		    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		//var activeTab = grouptabPanel.getActiveTab();
		    		
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								//oldCard.getStore().rejectChanges();
								UniAppManager.setToolbarButtons('save',false);
								if(newCard.getItemId() == "tab_sales" || newCard.getItemId() == "tab_payments"){
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
									}
								else{
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
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
		id : 'cbm200ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm200Tab').getActiveTab();
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())	
		},
		
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm200Tab').getActiveTab();
			this.createTabData(activeTab, activeTab.getSubCode())
		},		
		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm200Tab').getActiveTab();
			activeTab.getStore().saveStore();
			
		},
		
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm200Tab').getActiveTab();
			activeTab.deleteSelectedRow();
		},
		
		loadTabData: function(tab, itemId, mainCode){
			tab.getStore().load({params:{'MAIN_CODE':mainCode}});
			
		},
		createTabData: function(tab, mainCode){
			tab.createRow({'MAIN_CODE':mainCode});
		}
		
	});
};


</script>
