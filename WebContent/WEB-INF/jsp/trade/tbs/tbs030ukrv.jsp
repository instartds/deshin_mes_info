<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="tbs030ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="tbs030ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="T001" />			<!--무역구분-->
	<t:ExtComboStore comboType="AU" comboCode="T070" />			<!--수출경비구분-->
	<t:ExtComboStore comboType="AU" comboCode="T071" />			<!--수입경비구분-->
	<t:ExtComboStore comboType="AU" comboCode="T105" />			<!--부대비배부여부-->
	<t:ExtComboStore comboType="AU" comboCode="B010" />			<!--부가세기표-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />			<!--H.S단위-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >


var BsaCodeInfo = {
	gsMoneyUnit: '${gsMoneyUnit}'
}

function appMain() {

	var selectedMasterGrid = 'tbs030ukrvs1Grid'; 

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tbs030ukrsService.selectList1',
			create	: 'tbs030ukrsService.insertDetail1',
			update	: 'tbs030ukrsService.updateDetail1',
			destroy : 'tbs030ukrsService.deleteDetail1',
			syncAll	: 'tbs030ukrsService.saveAll1'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tbs030ukrsService.selectList2',
			create	: 'tbs030ukrsService.insertDetail2',
			update	: 'tbs030ukrsService.updateDetail2',
			destroy : 'tbs030ukrsService.deleteDetail2',
			syncAll	: 'tbs030ukrsService.saveAll2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tbs030ukrsService.selectList3',
			create	: 'tbs030ukrsService.insertDetail3',
			update	: 'tbs030ukrsService.updateDetail3',
			syncAll	: 'tbs030ukrsService.saveAll3'
		}
	});


	<%@include file="./tbs030ukrvModel.jsp" %>


	var panelDetail = Ext.create('Ext.panel.Panel', {
		layout	: 'fit',
		region	: 'center',
		disabled: false,
		items	: [{ 
			xtype		: 'grouptabpanel',
			itemId		: 'tbs030Tab',
			activeGroup	: 0,
			collapsible	: true,
			items		: [{
				defaults: {
					xtype	: 'uniDetailForm',
					disabled: false,
					border	: 0,
					layout	: {type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					padding	: '10 10 10 10'
				},
				items:[
					<%@include file="./tbs030ukrvs1.jsp" %> //경비정보등록
				]
			},{
				defaults:{
					xtype	: 'uniDetailForm',
					disabled: false,
					border	: 3,
					layout	: {type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					padding	: '10 10 10 10'
				},
				items:[
					<%@include file="./tbs030ukrvs2.jsp" %> //HS정보등록 
				]
			},{
				defaults:{
					xtype	: 'uniDetailForm',
					disabled: false,
					border	: 0,
					layout	: {type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					padding	: '10 10 10 10'
				},
				items:[
					<%@include file="./tbs030ukrvs3.jsp" %>  //품목별HS정보등록
				]
			}]
		}],
		listeners: {
			beforetabchange: function ( grouptabPanel, newCard, oldCard, eOpts ) {
				if(Ext.isObject(oldCard)) {
					if(UniAppManager.app._needSave()) {
						if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
							UniAppManager.app.onSaveDataButtonDown();
							this.setActiveTab(oldCard);
						} else {
							oldCard.getStore().rejectChanges();
							UniAppManager.app.fnInitBinding();
							UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());
						}
					} else {
						UniAppManager.app.fnInitBinding();
						UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
						UniAppManager.app.loadTabData(newCard, newCard.getItemId());
					}
				}
			}
		}
	});



	Unilite.Main({
		id			: 'tbs030ukrvApp',
		borderItems	: [ 
			panelDetail
		], 
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'], false);
			UniAppManager.setToolbarButtons(['query', 'newData']		, true);
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			if(activeTab.getId() == 'tbs030ukrvs1Tab'){
				panelDetail.down('#tbs030ukrvs1Tab').getField('CHARGE_TYPE2').setVisible(false);
			}
		},
		onResetButtonDown: function() {	// 초기화
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			if(activeTab.getId() == 'tbs030ukrvs1Tab'){
				UniAppManager.setToolbarButtons(['reset'],false);
				tbs030ukrvs1Store.clearData();
				panelDetail.down('#tbs030ukrvs1Grid').reset();
			} else if(activeTab.getId() == 'tbs030ukrvs2Tab') {
				UniAppManager.setToolbarButtons(['reset'],false);
				tbs030ukrvs2Store.clearData();
				panelDetail.down('#tbs030ukrvs2Grid').reset();
			} else if(activeTab.getId() == 'tbs030ukrvs3Tab') {
				UniAppManager.setToolbarButtons(['reset'],false);
				tbs030ukrvs3Store.clearData();
				panelDetail.down('#tbs030ukrvs3Grid').reset();
			}
		},
		onNewDataButtonDown : function() {
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			if(activeTab.getId() == 'tbs030ukrvs1Tab'){ 
				var param		= panelDetail.down('#tbs030ukrvs1Tab').getValues();
				var record		= Ext.getCmp('tbs030ukrvs1Tab').down('#tbs030ukrvs1Grid').getSelectedRecord();
				var compCode	= UserInfo.compCode;
				var tradeDiv	= param.TRADE_DIV;	
				var chargeType1	= param.CHARGE_TYPE1;
				var chargeType2	= param.CHARGE_TYPE2;
				var costDiv		= 'N';
				var taxDiv		= 'Y';

				var r = {
					COMP_CODE	: compCode,
					TRADE_DIV	: tradeDiv,
					CHARGE_TYPE1: chargeType1,
					CHARGE_TYPE2: chargeType2,
					COST_DIV	: costDiv,
					TAX_DIV		: taxDiv
				}
				UniAppManager.app.setHiddenGridColumn();
				panelDetail.down('#tbs030ukrvs1Grid').createRow(r);

			} else if(activeTab.getId() == 'tbs030ukrvs2Tab') {
				panelDetail.down('#tbs030ukrvs2Grid').createRow(r);	

			} else if(activeTab.getId() == 'tbs030ukrvs3Tab') {
				var param		=  panelDetail.down('#tbs030ukrvs3Tab').getValues();
				var remarkType	= param.REMARK_TYPE;
				var compCode	= UserInfo.compCode;

				var r = {
					COMP_CODE	: compCode,
					REMARK_TYPE	: remarkType
				}
				panelDetail.down('#tbs030ukrvs3Grid').createRow(r);	
			}
		},
		onQueryButtonDown : function() {
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			if(activeTab.getId() == 'tbs030ukrvs1Tab'){ 
				tbs030ukrvs1Store.loadStoreRecords();

			}  else if(activeTab.getId() == 'tbs030ukrvs2Tab') {
				tbs030ukrvs2Store.loadStoreRecords();

			} else if(activeTab.getId() == 'tbs030ukrvs3Tab') {
				tbs030ukrvs3Store.loadStoreRecords();
			}
		},
		onDeleteDataButtonDown : function() {
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			if(activeTab.getId() == 'tbs030ukrvs1Tab'){	
				var grid = panelDetail.down('#tbs030ukrvs1Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true) {
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			} else if(activeTab.getId() == 'tbs030ukrvs2Tab') {	
				var grid = panelDetail.down('#tbs030ukrvs2Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true) {
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			} else if(activeTab.getId() == 'tbs030ukrvs3Tab') {
				var grid = panelDetail.down('#tbs030ukrvs3Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true) {
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			} 
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#tbs030Tab').getActiveTab();
			if (activeTab.getId() == 'tbs030ukrvs1Tab') {
				 activeTab.down('#tbs030ukrvs1Grid').getStore().syncAll(); 
			} else if (activeTab.getId() == 'tbs030ukrvs2Tab'){
				 activeTab.down('#tbs030ukrvs2Grid').getStore().saveStore(); 
			} else if (activeTab.getId() == 'tbs030ukrvs3Tab'){
				 activeTab.down('#tbs030ukrvs3Grid').getStore().syncAll(); 
			}
		},
		loadTabData: function(tab, itemId){
			if (tab.getItemId() == 'tbs030ukrvs1Tab') {
				UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
				UniAppManager.setToolbarButtons(['query'],true);

			} else if(tab.getItemId() == "tbs030ukrvs2Tab") {
				UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
				UniAppManager.setToolbarButtons(['query'],true);

			} else if(tab.getItemId() == "tbs030ukrvs3Tab") {
				UniAppManager.setToolbarButtons(['newData', 'reset', 'excel' , 'save', 'delete'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			}
		},
		setHiddenFormColumn: function() {
			if(panelDetail.down('#tbs030ukrvs1Tab').getValue('TRADE_DIV') == 'E') {
				panelDetail.down('#tbs030ukrvs1Tab').getField('CHARGE_TYPE1').setVisible(true);
				panelDetail.down('#tbs030ukrvs1Tab').getField('CHARGE_TYPE2').setVisible(false);
			} else {
				panelDetail.down('#tbs030ukrvs1Tab').getField('CHARGE_TYPE1').setVisible(false);
				panelDetail.down('#tbs030ukrvs1Tab').getField('CHARGE_TYPE2').setVisible(true);
			}
		},
		setHiddenGridColumn: function() {
			if(panelDetail.down('#tbs030ukrvs1Tab').getValue('TRADE_DIV') == 'E') {
				panelDetail.down('#tbs030ukrvs1Grid').getColumn('CHARGE_TYPE1').setVisible(true);
				panelDetail.down('#tbs030ukrvs1Grid').getColumn('CHARGE_TYPE2').setVisible(false);
			} else {
				panelDetail.down('#tbs030ukrvs1Grid').getColumn('CHARGE_TYPE1').setVisible(false);
				panelDetail.down('#tbs030ukrvs1Grid').getColumn('CHARGE_TYPE2').setVisible(true);
			}
		}
	});
};
</script>