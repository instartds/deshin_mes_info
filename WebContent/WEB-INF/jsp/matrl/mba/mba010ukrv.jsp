<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mba010ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="BOR120"  pgmId="mba010ukrv"/> 			<!--사업장 --> 
</t:appConfig>
<style type= "text/css">
.x-grid-cell {
    border-left: 0px !important;
    border-right: 0px !important;
}
.x-tree-icon-leaf {
    background-image:none;
}
.search-hr {
	height: 1px;
	border: 0;
	color: #fff;
	background-color: #330;
	width: 98%;
}
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>
<script type="text/javascript" >
function appMain() {     
	
	// 구매담당
<%@include file="./mba010ukrvs3.jsp" %>	
	
	// 수불담당
<%@include file="./mba010ukrvs4.jsp" %>
	
	
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'mba010Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				{xtype:'ConfigCodeGrid', subCode:'M103', codeName:'<t:message code="system.label.purchase.receipttype" default="입고유형"/>'},
				{xtype:'ConfigCodeGrid', subCode:'M104', codeName:'<t:message code="system.label.purchase.issuetype" default="출고유형"/>'},
				//{xtype:'ConfigCodeGrid', subCode:'M201', codeName:'<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'},
				//{xtype:'ConfigCodeGrid', subCode:'B024', codeName:'<t:message code="system.label.purchase.trancharge" default="수불담당"/>'},
				buy, // 구매담당
				inout, // 수불담당
				
				
				{xtype:'ConfigCodeGrid', subCode:'B072', codeName:'<t:message code="system.label.purchase.availableinventorycalculation" default="가용재고 산출기준"/>'},
				{xtype:'ConfigCodeGrid', subCode:'M405', codeName:'<t:message code="system.label.purchase.mrpactionmessage" default="MRP Action Message 적용여부"/>'}
	    	 ]
	    	 ,listeners:{
		    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								//oldCard.getStore().rejectChanges();
								UniAppManager.setToolbarButtons('save',false);
								if(newCard.getItemId() == "tab_buy" || newCard.getItemId() == "tab_inout"){
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
									}
								else{
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
							}
		    			 }else  {
	    			 		if(newCard.getItemId() == "tab_buy" || newCard.getItemId() == "tab_inout"){
	    			 			UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    			 		}
							else{
	    			 			UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
							}
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
		id : 'mba010ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','print'],false);
			UniAppManager.setToolbarButtons(['newData', 'excel'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{	
			var activeTab = panelDetail.down('#mba010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_buy"){
				mba010ukrvs_3Store.loadStoreRecords();
				
			}else if(activeTab.getItemId() == "tab_inout"){
				mba010ukrvs_4Store.loadStoreRecords();
			}	
			else{
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())
			}
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#mba010Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_buy"){
				var mainCode = 'M201'
				
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#mba010ukrvs_3Grid').createRow(r);
			}else if(activeTab.getItemId() == "tab_inout"){
				var mainCode = 'B024'
				
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#mba010ukrvs_4Grid').createRow(r);
			}else{	
				this.createTabData(activeTab, activeTab.getSubCode())
			}
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#mba010Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_buy"){
				mba010ukrvs_3Store.saveStore();
				
			}else if(activeTab.getItemId() == "tab_inout"){
				mba010ukrvs_4Store.saveStore();
			}	
			else{
				activeTab.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#mba010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_buy"){
				panelDetail.down('#mba010ukrvs_3Grid').deleteSelectedRow();
				
			}else if(activeTab.getItemId() == "tab_inout"){
				panelDetail.down('#mba010ukrvs_4Grid').deleteSelectedRow();
			}	
			else{
				activeTab.deleteSelectedRow();
			}
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
			if(itemId == "tab_buy"){
				mba010ukrvs_3Store.loadStoreRecords();
			}else if(itemId == "tab_inout"){
				mba010ukrvs_4Store.loadStoreRecords();
			}else{	
				tab.getStore().load({params:{'MAIN_CODE':mainCode}});
			}
		},
		createTabData: function(tab, mainCode){
			tab.createRow({'MAIN_CODE':mainCode});
		}
		
	});
};


</script>
