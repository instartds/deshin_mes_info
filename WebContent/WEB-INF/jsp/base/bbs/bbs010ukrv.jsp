<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    request.setAttribute("multiCompCode", ConfigUtil.getString("common.dataOption.multiCompCode", "false")); //multiCompCode 설정
%>
<t:appConfig pgmId="bbs010ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="BOR120"  pgmId="bbs010ukrv"/><!-- 사업장 -->
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
    var multiCompCode = '${multiCompCode}';
	//외상카드

	<c:if test="${multiCompCode == 'true'}">
	 var multiCompCodeProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa101ukrvService.selectDetailCodeList',
				create 	: 'bsa101ukrvService.insertCodes',
				update 	: 'bsa101ukrvService.updateCodes',
				destroy	: 'bsa101ukrvService.deleteCodes',
				syncAll	: 'bsa101ukrvService.saveAll'
			}
		});
	</c:if>
	<%@include file="./bbs010ukrvs8.jsp" %>
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'bbs010Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				{xtype:'ConfigCodeGrid', subCode:'B004', codeName:'<t:message code="system.label.base.currency" default="화폐"/>' 					<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B012', codeName:'<t:message code="system.label.base.countrycode" default="국가코드"/>'				<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B013', codeName:'<t:message code="system.label.base.unit" default="단위"/>'					<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B033', codeName:'<t:message code="system.label.base.customclosingdate" default="거래처마감일"/>'			<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B034', codeName:'<t:message code="system.label.base.paymentcondition" default="결제조건"/>'				<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B038', codeName:'<t:message code="system.label.base.payingmethod" default="결제방법"/>'				<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B608', codeName:'<t:message code="system.label.base.excelfielinfor" default="엑셀파일 정보"/>'	<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B609', codeName:'<t:message code="system.label.base.groupwearinfor" default="그룹웨어 정보"/>'<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'B610', codeName:'<t:message code="system.label.base.accordcollectsetting" default="가수금환경"/>'    <c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				card,
				{xtype:'ConfigCodeGrid', subCode:'B600', codeName:'<t:message code="system.label.base.noticesmanager" default="공지사항 관리자"/>'	<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>}
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
								if(newCard.getItemId() == "tab_card"){
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
								}
								else{
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
							}
		    			 }else {
		    			 	if(newCard.getItemId() == "tab_card"){
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
		id : 'bbs010ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel' ,'print'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{	
			var activeTab = panelDetail.down('#bbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_card"){
				bbs010ukrvs_8Store.loadStoreRecords();
			}else{
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())
			}
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#bbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_card"){
				var mainCode = 'YP17';
				
				var r = {
					MAIN_CODE : mainCode
				}
				
				panelDetail.down('#bbs010ukrvs_8Grid').createRow(r);
				
			}else{
				this.createTabData(activeTab, activeTab.getSubCode())
			}
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#bbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_card"){
				bbs010ukrvs_8Store.saveStore();
				
			}else{
				activeTab.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#bbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_card"){
				panelDetail.down('#bbs010ukrvs_8Grid').deleteSelectedRow();
				
			}else{
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
			if(itemId == "tab_card"){
				bbs010ukrvs_8Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_4Store').load();
			}else{
				tab.getStore().load({params:{'MAIN_CODE':mainCode}});
			}
		},
		createTabData: function(tab, mainCode){
			tab.createRow({'MAIN_CODE':mainCode}, 'SUB_CODE');
		}
		
	});
};


</script>
