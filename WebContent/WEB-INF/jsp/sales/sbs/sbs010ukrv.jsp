<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="sbs010ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="BOR120"  pgmId="sbs010ukrv"/><!--사업장 --> 
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
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
	var systemYNStore = Unilite.createStore('sbs010ukrvsYNStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'예'		, 'value':'1'},
			{'text':'아니오'	, 'value':'2'}
		]
	});

//판매유형
<%@include file="./sbs010ukrvs1.jsp" %>

//영업/구매담당
<%@include file="./sbs010ukrvs4.jsp" %>

// 수불담당
<%@include file="./sbs010ukrvs5.jsp" %>

	var panelDetail = Ext.create('Ext.panel.Panel', {
		layout	: 'fit',
		region	: 'center',
		disabled: false,
		items	: [{ 
			xtype		: 'grouptabpanel',
			itemId		: 'sbs010Tab',
			cls			: 'human-panel',
			activeGroup	: 0,
			collapsible	: true,
			items		: [
				//{xtype:'ConfigCodeGrid', subCode:'S002', codeName:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>', showRefCodes:['REF_CODE11']},
				saleType,
				{xtype:'ConfigCodeGrid', subCode:'S007', codeName:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'},
				{xtype:'ConfigCodeGrid', subCode:'S008', codeName:'<t:message code="system.label.sales.returntype" default="반품유형"/>'},
				//{xtype:'ConfigCodeGrid', subCode:'S010', codeName:'영업/수금담당'},
				//{xtype:'ConfigCodeGrid', subCode:'B024', codeName:'<t:message code="system.label.sales.trancharge" default="수불담당"/>'},
				sales,		// 영업/수금담당
				payments,	// 수불담당
				//{xtype:'ConfigCodeGrid', subCode:'', codeName:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'},
				//{xtype:'ConfigCodeGrid', subCode:'', codeName:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'},
				{xtype:'ConfigCodeGrid', subCode:'S017', codeName:'<t:message code="system.label.sales.collectiontype" default="수금유형"/>'}
			],
			listeners:{
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
					//var activeTab = grouptabPanel.getActiveTab();
					if(Ext.isObject(oldCard)) {
						if(UniAppManager.app._needSave()) {
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							} else {
								//oldCard.getStore().rejectChanges();
								UniAppManager.setToolbarButtons('save',false);
								if(newCard.getItemId() == "tab_sales" || newCard.getItemId() == "tab_payments") {
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());
								} else {
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
							}
						} else {
							if(newCard.getItemId() == "tab_saleType" || newCard.getItemId() == "tab_sales" || newCard.getItemId() == "tab_payments") {
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());
							} else {
								UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
							}
						}
					}
				}
			}
		}]
	})



	Unilite.Main({
		id			: 'sbs010ukrvApp',
		borderItems	: [ 
			panelDetail
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'excel'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function() {
			var activeTab = panelDetail.down('#sbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_sales") {
				sbs010ukrvs_4Store.loadStoreRecords();
			} else if(activeTab.getItemId() == "tab_payments") {
				sbs010ukrvs_5Store.loadStoreRecords();
			} else if(activeTab.getItemId() == "tab_saleType") {
				sbs010ukrv1Store.loadStoreRecords();
			}else {
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode());
			}
		},
		onNewDataButtonDown : function() {
			var activeTab = panelDetail.down('#sbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_sales") {
				var mainCode = 'S010'
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#sbs010ukrvs_4Grid').createRow(r);
			} else if(activeTab.getItemId() == "tab_payments") {
				var mainCode = 'B024'
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#sbs010ukrvs_5Grid').createRow(r);
			} else if(activeTab.getItemId() == "tab_saleType") {
				var mainCode = 'S002'
				var r = {
					MAIN_CODE : mainCode
				}
				panelDetail.down('#saleTypeGrid').createRow(r, 'SUB_CODE');
			}else {
				this.createTabData(activeTab, activeTab.getSubCode())
			}
		},
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#sbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_sales") {
				sbs010ukrvs_4Store.saveStore();
			} else if(activeTab.getItemId() == "tab_payments") {
				sbs010ukrvs_5Store.saveStore();
			} else if(activeTab.getItemId() == "tab_saleType") {
				sbs010ukrv1Store.saveStore();
			} else {
				activeTab.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function() {
			var activeTab = panelDetail.down('#sbs010Tab').getActiveTab();
			if(activeTab.getItemId() == "tab_sales") {
				panelDetail.down('#sbs010ukrvs_4Grid').deleteSelectedRow();
			} else if(activeTab.getItemId() == "tab_payments") {
				panelDetail.down('#sbs010ukrvs_5Grid').deleteSelectedRow();
			} else if(activeTab.getItemId() == "tab_saleType") {
				panelDetail.down('#saleTypeGrid').deleteSelectedRow();
			} else {
				activeTab.deleteSelectedRow();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		loadTabData: function(tab, itemId, mainCode) {
			//tab.down('#'+itemId).getStore().loadStoreRecords({'MAIN_CODE':mainCode});
			//var activeTab = panelDetail.down('#sbs010Tab').getActiveTab();
			if(itemId == "tab_sales") {
				sbs010ukrvs_4Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_4Store').load();
				
			} else if(itemId == "tab_payments") {
				sbs010ukrvs_5Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_5Store').load();
			} else if(itemId == "tab_saleType") {
				sbs010ukrv1Store.loadStoreRecords();
				//panelDetail.down('#sbs010ukrvs_5Store').load();
			} else {
				tab.getStore().load({params:{'MAIN_CODE':mainCode}});
			}
		},
		createTabData: function(tab, mainCode) {
			tab.createRow({'MAIN_CODE':mainCode});
		}
	});
};
</script>