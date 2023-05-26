<%--
'	프로그램명 : 견적기준정보등록
'	작  성  자 : 시너지 시스템즈 개발팀
'	작  성  일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	request.setAttribute("multiCompCode", ConfigUtil.getString("common.dataOption.multiCompCode", "false"));	//multiCompCode 설정
%>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="seb100ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="seb100ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>			<!-- 예/아니오 -->
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />'/>
<script type="text/javascript">


function appMain() {
	var multiCompCode = '${multiCompCode}';
	<c:if test="${multiCompCode == 'true'}">
	var multiCompCodeProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa101ukrvService.selectDetailCodeList',
			create	: 'bsa101ukrvService.insertCodes',
			update	: 'bsa101ukrvService.updateCodes',
			destroy	: 'bsa101ukrvService.deleteCodes',
			syncAll	: 'bsa101ukrvService.saveAll'
		}
	});
	</c:if>

	<%@include file="./seb100ukrvs1.jsp"%>			//견적기준 - 20210629 추가
	<%@include file="./seb100ukrvs2.jsp"%>			//표준이익율
	<%@include file="./seb100ukrvs5.jsp"%>			//표준원가정보
	<%@include file="./seb100ukrvs6.jsp"%>			//생산파트
	<%@include file="./seb100ukrvs7.jsp"%>			//연구파트
	<%@include file="./seb100ukrvs8.jsp"%>			//충전단위
	<%@include file="./seb100ukrvs10.jsp"%>			//견적승인사용여부 - 20210630 추가
	
	var panelDetail = Ext.create('Ext.panel.Panel', {
		layout	: 'fit',
		region	: 'center',
		disabled: false,
		items	: [{ 
			xtype		: 'grouptabpanel',
			itemId		: 'seb100ukrvTab',
			cls			: 'human-panel',
			activeGroup	: 0,
			collapsible	: true,
			items		: [
				//견적기준, 견적가구분, 견적승인사용여부는 따로 페이지 필요 없음, 20210629 견적기준도 따로 페이지 생성, 20210630 견적승인사용여부도 따로 페이지 생성.. ㅡ.ㅡ;;
//				{xtype: 'ConfigCodeGrid', subCode:'SE01'	, codeName: '견적기준'			<c:if test="${multiCompCode == 'true'}">	, proxy: multiCompCodeProxy</c:if>},
				basisInfo,
				standardProfitRate,
				{xtype: 'ConfigCodeGrid', subCode:'SE03'	, codeName: '견적가구분'			<c:if test="${multiCompCode == 'true'}">	, proxy: multiCompCodeProxy</c:if>},
				standardCostPrice,
				productionPart,
				researchPart,
				chargingUnit,
				agreeYn
//				{xtype: 'ConfigCodeGrid', subCode:'SE010'	, codeName: '견적승인사용여부'		<c:if test="${multiCompCode == 'true'}">	, proxy: multiCompCodeProxy</c:if>}
			],
			listeners:{
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
					if(Ext.isObject(oldCard)) {
						if(UniAppManager.app._needSave()) {
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							} else {
								UniAppManager.setToolbarButtons('save', false);
								if(newCard.getItemId() == 'tab_basisInfo'			//20210629 추가
								|| newCard.getItemId() == 'tab_standardProfitRate'
								|| newCard.getItemId() == 'tab_standardCostPrice'
								|| newCard.getItemId() == 'tab_productionPart'
								|| newCard.getItemId() == 'tab_researchPart'
								|| newCard.getItemId() == 'tab_chargingUnit'
								|| newCard.getItemId() == 'tab_agreeYn') {			//표준이익율, 표준원가정보, 생산파트, 연구파트, 충전단위, 20210630 견적승인사용여부 추가
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());
								} else {
									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
								}
							}
						} else {
							if(newCard.getItemId() == 'tab_basisInfo'			//20210629 추가
							|| newCard.getItemId() == 'tab_standardProfitRate'
							|| newCard.getItemId() == 'tab_standardCostPrice'
							|| newCard.getItemId() == 'tab_productionPart'
							|| newCard.getItemId() == 'tab_researchPart'
							|| newCard.getItemId() == 'tab_chargingUnit'
							|| newCard.getItemId() == 'tab_agreeYn') {			//표준이익율, 표준원가정보, 생산파트, 연구파트, 충전단위, 20210630 견적승인사용여부 추가
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());
							} else{
								UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
							}
						}
					}
				}
			}
		}]
	})


	Unilite.Main({
		id			: 'seb100ukrvApp',
		borderItems	: [
			panelDetail
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel' ,'print'], false);
			UniAppManager.setToolbarButtons(['newData'], true);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function() {
			var activeTab = panelDetail.down('#seb100ukrvTab').getActiveTab();
			if(activeTab.getItemId() == 'tab_basisInfo') {					//20210629 추가: 견적기준
				seb100ukrvStore1.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_standardProfitRate') {	//표준이익율
				seb100ukrvStore2.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_standardCostPrice') {	//표준원가정보
				seb100ukrvStore5.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_productionPart') {		//생산파트
				seb100ukrvStore6.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_researchPart') {		//연구파트
				seb100ukrvStore7.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_chargingUnit') {		//충전단위
				seb100ukrvStore8.loadStoreRecords();
			} else if(activeTab.getItemId() == 'tab_agreeYn') {				//20210630 추가 - 견적승인사용여부
				seb100ukrvStore10.loadStoreRecords();
			} else {
				this.loadTabData(activeTab, activeTab.getItemId(), activeTab.getSubCode())
			}
		},
		onNewDataButtonDown : function() {
			var activeTab = panelDetail.down('#seb100ukrvTab').getActiveTab();
			if(activeTab.getItemId() == 'tab_basisInfo') {					//20210629 추가: 견적기준
				var mainCode = 'SE01';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid1').createRow(r);
			} else if(activeTab.getItemId() == 'tab_standardProfitRate') {	//표준이익율
				var mainCode = 'SE02';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid2').createRow(r);
			} else if(activeTab.getItemId() == 'tab_standardCostPrice') {	//표준원가정보
				var mainCode = 'SE05';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid5').createRow(r);
			} else if(activeTab.getItemId() == 'tab_productionPart') {		//생산파트
				var mainCode = 'SE06';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid6').createRow(r);
			} else if(activeTab.getItemId() == 'tab_researchPart') {		//연구파트
				var mainCode = 'SE07';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid7').createRow(r);
			} else if(activeTab.getItemId() == 'tab_chargingUnit') {		//충전단위
				var mainCode = 'SE08';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid8').createRow(r);
			}  else if(activeTab.getItemId() == 'tab_agreeYn') {			//20210630 추가 - 견적승인사용여부
				var mainCode = 'SE10';
				var r = {
					MAIN_CODE: mainCode
				}
				panelDetail.down('#seb100ukrvGrid10').createRow(r);
			} else {
				this.createTabData(activeTab, activeTab.getSubCode());
			}
		},
		onDeleteDataButtonDown : function() {
			var activeTab = panelDetail.down('#seb100ukrvTab').getActiveTab();
			if(activeTab.getItemId() == 'tab_basisInfo') {					//20210629 추가: 견적기준
				panelDetail.down('#seb100ukrvGrid1').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_standardProfitRate') {	//표준이익율
				panelDetail.down('#seb100ukrvGrid2').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_standardCostPrice') {	//표준원가정보
				panelDetail.down('#seb100ukrvGrid5').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_productionPart') {		//생산파트
				panelDetail.down('#seb100ukrvGrid6').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_researchPart') {		//연구파트
				panelDetail.down('#seb100ukrvGrid7').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_chargingUnit') {		//충전단위
				panelDetail.down('#seb100ukrvGrid8').deleteSelectedRow();
			} else if(activeTab.getItemId() == 'tab_agreeYn') {				//20210630 추가 - 견적승인사용여부
				panelDetail.down('#seb100ukrvGrid10').deleteSelectedRow();
			} else {
				activeTab.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#seb100ukrvTab').getActiveTab();
			if(activeTab.getItemId() == 'tab_basisInfo') {					//20210629 추가: 견적기준
				seb100ukrvStore1.saveStore();
			} else if(activeTab.getItemId() == 'tab_standardProfitRate') {	//표준이익율
				seb100ukrvStore2.saveStore();
			} else if(activeTab.getItemId() == 'tab_standardCostPrice') {	//표준원가정보
				seb100ukrvStore5.saveStore();
			} else if(activeTab.getItemId() == 'tab_productionPart') {		//생산파트
				seb100ukrvStore6.saveStore();
			} else if(activeTab.getItemId() == 'tab_researchPart') {		//연구파트
				seb100ukrvStore7.saveStore();
			} else if(activeTab.getItemId() == 'tab_chargingUnit') {		//충전단위
				seb100ukrvStore8.saveStore();
			} else if(activeTab.getItemId() == 'tab_agreeYn') {				//20210630 추가 - 견적승인사용여부
				seb100ukrvStore10.saveStore();
			} else {
				activeTab.getStore().saveStore();
			}
		},
		loadTabData: function(tab, itemId, mainCode) {
			if(itemId == 'tab_basisInfo') {						//20210629 추가: 견적기준
				seb100ukrvStore1.loadStoreRecords();
			} else if(itemId == 'tab_standardProfitRate') {		//표준이익율
				seb100ukrvStore2.loadStoreRecords();
			} else if(itemId == 'tab_standardCostPrice') {		//표준원가정보
				seb100ukrvStore5.loadStoreRecords();
			} else if(itemId == 'tab_productionPart') {			//생산파트
				seb100ukrvStore6.loadStoreRecords();
			} else if(itemId == 'tab_researchPart') {			//연구파트
				seb100ukrvStore7.loadStoreRecords();
			} else if(itemId == 'tab_chargingUnit') {			//충전단위
				seb100ukrvStore8.loadStoreRecords();
			} else if(itemId == 'tab_agreeYn') {				//20210630 추가 - 견적승인사용여부
				seb100ukrvStore10.loadStoreRecords();
			} else {
				tab.getStore().load({
					params: {'MAIN_CODE': mainCode}
				});
			}
		},
		createTabData: function(tab, mainCode) {
			tab.createRow({'MAIN_CODE': mainCode}, 'SUB_CODE');
		}
	});
};
</script>