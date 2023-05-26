<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
	request.setAttribute("multiCompCode", ConfigUtil.getString("common.dataOption.multiCompCode", "false")); //multiCompCode 설정
%>

<t:appConfig pgmId="arc020ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!--사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="J508" />	<!--매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J505" /> <!--기표구분-->
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	var multiCompCode = '${multiCompCode}';
	
	<c:if test="${multiCompCode == 'true'}">
     var multiCompCodeProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'bsa101ukrvService.selectDetailCodeList',
                create  : 'bsa101ukrvService.insertCodes',
                update  : 'bsa101ukrvService.updateCodes',
                destroy : 'bsa101ukrvService.deleteCodes',
                syncAll : 'bsa101ukrvService.saveAll'
            }
        });
    </c:if>
	
	var systemYNStore = Unilite.createStore('sbs010ukrvsYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'한다'		, 'value':'1'},
			        {'text':'안한다'	, 'value':'2'}
	    		]
	});
	
	//회사별거래처코드
	<%@include file="./arc020ukrs1.jsp" %>
		
	//관리/수금구분>
	<%@include file="./arc020ukrs4.jsp" %>
	
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'arc020Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
	    		comp,     // 회사별 거래처코드
				{xtype:'ConfigCodeGrid', subCode:'J501', codeName:'채권구분' <c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'J502', codeName:'이관취소사유'<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				payments, // 관리/수금구분
				{xtype:'ConfigCodeGrid', subCode:'J505', codeName:'수금관리항목'<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'J506', codeName:'비용구분'<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>},
				{xtype:'ConfigCodeGrid', subCode:'J517', codeName:'법무담당사원'<c:if test="${multiCompCode == 'true'}">,proxy:multiCompCodeProxy</c:if>}
				

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
								if(newCard.getItemId() == "tab_comp" || newCard.getItemId() == "tab_payments"){
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
									}
								else{
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
							}
		    			 }else {
	    			 		if(newCard.getItemId() == "tab_comp" || newCard.getItemId() == "tab_payments"){
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
		id : 'sbs010ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{
			var activeTab = panelDetail.down('#arc020Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_comp"){
				arc020ukrs_1Store.loadStoreRecords();
				
			}else if(activeTab.getItemId() == "tab_payments"){
				arc020ukrs_4Store.loadStoreRecords();
			}	
			else{	
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())	
			}
		},
		
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#arc020Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_comp"){
				var mainCode = 'J509'
				
				var r = {
					MAIN_CODE : mainCode
				}
				
				panelDetail.down('#arc020ukrs_1Grid').createRow(r);
				
			}else if(activeTab.getItemId() == "tab_payments"){
				var mainCode = 'J504'
				
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#arc020ukrs_4Grid').createRow(r);
			}else{	
				this.createTabData(activeTab, activeTab.getSubCode())
			}
		},		
		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#arc020Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_comp"){
				arc020ukrs_1Store.saveStore();
				
			}else if(activeTab.getItemId() == "tab_payments"){
				arc020ukrs_4Store.saveStore();
			}	
			else{
				activeTab.getStore().saveStore();
			}
		},
		
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#arc020Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_comp"){
				panelDetail.down('#arc020ukrs_1Grid').deleteSelectedRow();
				
			}else if(activeTab.getItemId() == "tab_payments"){
				panelDetail.down('#arc020ukrs_4Grid').deleteSelectedRow();
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
			//var activeTab = panelDetail.down('#arc020Tab').getActiveTab();
			if(itemId == "tab_comp"){
				arc020ukrs_1Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_4Store').load();
				
			}else if(itemId == "tab_payments"){
				arc020ukrs_4Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_5Store').load();
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
