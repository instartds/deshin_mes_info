<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tbs010ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="BOR120"  pgmId="tbs010ukrv"/> 			<!--사업장 --> 
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
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'tbs010Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				{xtype:'ConfigCodeGrid', subCode:'T004', codeName:'<t:message code="system.label.trade.transportmethod" default="운송방법"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T009', codeName:'<t:message code="system.label.trade.customofficeinfo" default="세관정보"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T006', codeName:'<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T008', codeName:'<t:message code="system.label.trade.landingarrving" default="도착지/선적지"/>'},				
				{xtype:'ConfigCodeGrid', subCode:'T010', codeName:'<t:message code="system.label.trade.packagingconditiion" default="포장조건"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T011', codeName:'<t:message code="system.label.trade.inspecmethod" default="검사방법"/>'},					
				{xtype:'ConfigCodeGrid', subCode:'T013', codeName:'<t:message code="system.label.trade.importtype" default="수입유형"/>'},				
				{xtype:'ConfigCodeGrid', subCode:'T021', codeName:'<t:message code="system.label.trade.reporttype" default="신고유형"/>'},
				
				{xtype:'ConfigCodeGrid', subCode:'T025', codeName:'<t:message code="system.label.trade.farepayingmethod" default="운임지불방법"/>'},				
				{xtype:'ConfigCodeGrid', subCode:'T026', codeName:'<t:message code="system.label.trade.packagingtype" default="포장형태"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T027', codeName:'<t:message code="system.label.trade.transporttype" default="운송형태"/>'},
				
				{xtype:'ConfigCodeGrid', subCode:'T029', codeName:'<t:message code="system.label.trade.reporter" default="신고인(관세사)"/>'},				
				{xtype:'ConfigCodeGrid', subCode:'T030', codeName:'<t:message code="system.label.trade.lctype" default="L/C유형"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T060', codeName:'<t:message code="system.label.trade.collectiontypeinput" default="수금(입금)유형"/>'},
				{xtype:'ConfigCodeGrid', subCode:'T110', codeName:'<t:message code="system.label.trade.bondedwarehouse" default="보세창고"/>'}
				
	    	 ]
	    	 ,listeners:{
		    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
							}
		    			 }else  {
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
		id : 'tbs010ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','print'],false);
			UniAppManager.setToolbarButtons(['newData', 'excel'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{	
			var activeTab = panelDetail.down('#tbs010Tab').getActiveTab();
			
			this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode());
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#tbs010Tab').getActiveTab();
			
			this.createTabData(activeTab, activeTab.getSubCode());
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#tbs010Tab').getActiveTab();
			
			activeTab.getStore().saveStore();			
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#tbs010Tab').getActiveTab();
			
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
			tab.getStore().load({params:{'MAIN_CODE':mainCode}});
		},
		createTabData: function(tab, mainCode){
			tab.createRow({'MAIN_CODE':mainCode});
		}
		
	});
};


</script>
