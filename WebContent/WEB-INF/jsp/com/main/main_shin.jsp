<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");

	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);
	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    	if(extjsVersion.equals("4.2.2")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-dev.js");
    		request.setAttribute("ext_prefix", "ext-");
    		request.setAttribute("lang_prefix", "ext-lang");
    	}else if(extjsVersion.equals("5.1.0")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    		request.setAttribute("ext_prefix", "ext-");
    		request.setAttribute("lang_prefix", "ext-lang");
    	}else{
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    		request.setAttribute("ext_prefix", "");
    		request.setAttribute("lang_prefix", "locale");
    	}
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all.js");
    }

    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);

    request.setAttribute("mainPortal", ConfigUtil.getString("common.main.mainPortal", "MainPortalPanel")); //사이트 별 포털 뷰 클래스명
    request.setAttribute("showAllMenu", ConfigUtil.getString("common.main.showAllMenu", "true")); //사이트 별 포털 뷰 클래스명
    request.setAttribute("logoIco", ConfigUtil.getString("common.main.logoIco", "logo.ico")); //사이트 별 포털 뷰 클래스명

    String hostName = request.getServerName();
    int portNum = request.getServerPort();

    String strPortNum = "";
    if(80==portNum || 443 == portNum )	{
    	strPortNum = "";
    }else {
    	strPortNum = ":"+String.valueOf(portNum);
    }

    request.setAttribute("CHOST",   hostName+strPortNum);
%>
<!DOCTYPE html>
<html lang="${CUR_LANG}" xml:lang="${CUR_LANG}">
<head>

<%@include file='/WEB-INF/jspf/commonHead.jspf' %>

<link rel="shortcut icon" href='<c:url value="/resources/images/main/${logoIco}" />' type="image/x-icon" />
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/portal.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/nbox_${ext_version}.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/fullscreen.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url}" />'></script>
<c:if test="${ext_version != '4.2.2'}">
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root }/charts/classic/charts-all-debug.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/charts/ext-charts-debug.js" />'></script>
</c:if>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>

<script type="text/javascript">
	function detectmob() {
	 if( navigator.userAgent.match(/Android/i)
	 || navigator.userAgent.match(/webOS/i)
	 || navigator.userAgent.match(/iPhone/i)
	 || navigator.userAgent.match(/iPad/i)
	 || navigator.userAgent.match(/iPod/i)
	 || navigator.userAgent.match(/BlackBerry/i)
	 || navigator.userAgent.match(/Windows Phone/i)
	 ){
	    return true;
	  }
	 else {
	    return false;
	  }
	}

	var CPATH ='<%=request.getContextPath()%>';
	var docURL = document.URL;
	var scheme = docURL.substring(0,docURL.indexOf("//")+2);
	var CHOST = scheme + '${CHOST}';// 'request.getScheme()

	var CUR_LANG='${CUR_LANG}';
	var CUR_LANG_SUFFIX='${CUR_LANG_SUFFIX}';
	var EXT_ROOT = '${ext_root}';
	var EXTVERSION ='<%=extjsVersion%>';

	if(detectmob()) {
		//window.location.href = CPATH+"mMain.do";
	}

	Ext.Loader.setConfig({
		enabled : true,
		paths : {
			"Ext" : '${CPATH }/${ext_root}/src',
			"Ext.ux" : '${CPATH }/${ext_root}/app/Ext/ux',
			"Unilite" : '${CPATH }/${ext_root}/app/Unilite',
			"nbox" : '${CPATH }/${ext_root}/app/nbox',
			"Extensible" : '${CPATH }/${ext_root}/app/Extensible'
		}
	});
	Ext.validIdRe = /^[a-z_][a-z0-9\-_.]*$/i;

	var SAVE_AUTH = "false";
	var USE_PIVOT = "false";
	var MODIFY_AUTH = "false";
</script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-popupText-${CUR_LANG}.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-JSText-${CUR_LANG}.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-JSMessage-${CUR_LANG}.js" />' ></script>
<c:choose>
<c:when test="${isDevelopServer }">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/IFrame.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/statusbar/StatusBar.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/statusbar/ValidationStatus.js" />'></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/DataTip.js" />' ></script>
	<c:if test="${ext_version != '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/form/trigger/Clear.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/form/NumericField.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/FiltersFeature.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/menu/ListMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/menu/RangeMenu.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniImg.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/MainContentPanel.js" />' ></script>


	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/ValidateService.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniValidator.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTypes.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAppManager.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAbstractApp.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/button/BaseButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/button/UniHoverButton.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/filter/UniListMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/filter/UniListFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniMonthColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniDateColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniTimeColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniPriceColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniNumberColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniCellDragDrop.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniTreeGridPanel.js" />' ></script>
	<c:if test="${ext_version != '6.0.1'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridMultiSorter.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniSimpleGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/Excel.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BaseApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BasePopupApp.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BaseJSPopupApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniWriter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/proxy/UniDirectProxy.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniAbstractStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStoreSimple.js" />' ></script>
    <c:if test="${ext_version != '4.2.2'}">
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniFields.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniValidator.js" />' ></script>
    </c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/state/UniStorageProvider.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniTabPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniTabScrollerMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/layout/UniTable.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniAbstractForm.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniSearchForm.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<c:if test="${ext_version == '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDateField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDate.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupAbstract.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniPopup.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/portal/UniPortalColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/portal/UniPortalPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/portal/UniPortlet.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/portal/UniPortalDropZone.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/UploadPanel.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/menu/UniMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniBase.js" />'> </script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/MainTree.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/MainTreeForSystemMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/portal/MainPortalPanel.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/portal/MainPortalNotice.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/nbox/main/groupwareMenuTree.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniTransparentContainer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniActionContainer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniHeaderConfig.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniBaseWindowApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/uniDetailWindow.js" />' ></script>

</c:when>
<c:otherwise>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/unilite.full.js" />'></script>
</c:otherwise>
</c:choose>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-${CUR_LANG}.js" />' ></script>
<!-- script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-${CUR_LANG}.js" />'> </script -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-${CUR_LANG}.js" />' ></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js?group=com,main,base" />'></script>
<style>
	iframe {
		border: 0px !important;
	}
	.search {
	    background: url("resources/images/main/search-box.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
	    padding: 1px 0 0 25px !important;
	}
	.search .x-form-text {
	    background: none repeat scroll 0 center rgba(0, 0, 0, 0);
	}
	.search .x-form-text-wrap-default {
		border-width: 0px;
	}
</style>
<style>
	.x-tree-icon-parent-expanded {
	    background-image: url("resources/css/theme_01/tree-open.png") !important;
	}
	.x-grid-tree-node-expanded .x-tree-icon-parent {
	    background-image: url("resources/css/theme_01/tree-open.png") !important;
	}
	.x-tree-icon-parent {
	    background-image: url("resources/css/theme_01/tree-close.png") !important;
	}
	.x-tree-icon-leaf {
	    background-image: url("resources/css/theme_01/tree-leaf.png");
	}
	.x-tree-node-text {
	    cursor: pointer;
	}
	.x-tree-node-text-disable {
	    color: #bfbfbf !important;
	}
</style>

<script type="text/javascript">
	Ext.define("UserInfo", {
    		 singleton: true,
		     userID: 		"${loginVO.userID}",
		     userName: 		"${loginVO.userName}",
		     personNumb: 	"${loginVO.personNumb}",
		     divCode: 		"${loginVO.divCode}",
		     deptCode: 		"${loginVO.deptCode}",
		     deptName: 		"${loginVO.deptName}",
		     compCode: 		"${loginVO.compCode}",
		     currency:  	'KRW',
		     appOption: ${appOption}
		 }
	);
	Ext.define("UniFormat", {
    		singleton: true,
		 	Qty: 			'0,000', //						// 수량
		    UnitPrice: 		'0,000.00',		// "${loginVO.userID}",		// 단가
		    Price: 			'0,000',		// "${loginVO.userName}",		// 금액
		    FC: 			'0,000.00',  	// "${loginVO.personNumb}",	// 외화
		    ER: 			'0,000.00',  	//  ${loginVO.personNumb}",	// 환율
		    Percent: 		'0,000.00',		// "${loginVO.userID}",		// 확률
 			FDATE:			'Y-m-d', 		//  "${loginVO.fDate}",			// 날자
		    FYM: 			'Y-m' //"${loginVO.fYM}"			// 연월
		 }
	);
	var CommonMsg = {
		'errorTitle':{
			'ERROR':'<t:message code="unilite.msg.errorTitle" default="에러"/>',
			'WARNING':'<t:message code="unilite.msg.warnTitle" default="경고"/>',
			'INFO':'<t:message code="unilite.msg.infoTitle" default="정보"/>'
		}
	};
	var MODULE_GROUPWARE = {}; MODULE_GROUPWARE.ID = ''; MODULE_GROUPWARE.TITLE = 'Groupware', MODULE_GROUPWARE.ENABLE=false;	//Groupware Menu
	var MODULE_PROCESS = {}; MODULE_PROCESS.ID = 'processmenu';	// Process Menu ID
	var MODULE_MYMENU = {}; MODULE_MYMENU.ID = 'mymenu'//'99';	// MyMenu ID

	var compListData = ${compList};

	Ext.onReady(function() {
    	var mainView = {};
		Ext.require([
			'Ext.ux.IFrame',
			'Ext.ux.statusbar.StatusBar',
			'Ext.ux.statusbar.ValidationStatus'
		]);

		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
		Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);

		Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
		// Ext.state.Manager.setProvider(Ext.create('Unilite.com.state.UniStorageProvider'));


		Ext.tip.QuickTipManager.init();

 		Ext.enableFx=true;
		//var moduleWidth=137, moduleHeight=175;
 		var moduleWidth=90, moduleHeight=115;
		var moduleArray = ${modulesStr};

		var modules = new Array();
		var modulesOther = new Array();
		Ext.each(moduleArray,function(m,i){
			/*var t = {
				xtype:'uniImg',
				src: CPATH+'/resources/css/theme_01/module_'+m.id+CUR_LANG_SUFFIX+".png",
				title: m.title+m.id,
				//imgCls:'mainModuleButton',
				width: moduleWidth,
				height: moduleHeight,
                margin:'40 20 0 20',
				listeners: {
			        el: {
			            click: function(e, elem, eOpts) {
			            	var tabPanel = Ext.getCmp('panelNavigation');
			            	tabPanel.setActiveTab('leftSystemMenu');
			            	if(tabPanel.getCollapsed( )) {
			            		tabPanel.expand();
			            		//tabPanel.floatCollapsedPanel();
			            		 //tabPanel.slideOutFloatedPanel();
			            	}
			                elem.src = CPATH+'/resources/css/theme_01/module_'+m.id+'_click'+CUR_LANG_SUFFIX+".png";
			                moduleChange(m.id, m.title);
			                console.log('changed');
			            },
			            mouseover: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_'+m.id+'_over'+CUR_LANG_SUFFIX+".png";
			            },
			            mouseout: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_'+m.id+CUR_LANG_SUFFIX+".png";
			            }
			        }
			    }*/
				var imgSrc = CPATH+'/resources/css/theme_01/module_'+m.id+''+CUR_LANG_SUFFIX+".png";
			    var imgOverSrc = CPATH+'/resources/css/theme_01/module_'+m.id+'_over'+CUR_LANG_SUFFIX+".png";

			    if(m.show != "true")	{
			    	imgSrc = CPATH+'/resources/css/theme_01/module_'+m.id+'_disabled'+CUR_LANG_SUFFIX+".png";
			    	imgOverSrc = CPATH+'/resources/css/theme_01/module_'+m.id+'_disabled'+CUR_LANG_SUFFIX+".png";
			    }
				var t = {
					xtype: 'uniImg',
					src: CPATH+'/resources/css/theme_01/module_'+m.id+'_over'+CUR_LANG_SUFFIX+".png",
					//title: m.title+m.id,
					//imgCls:'mainModuleButton',
					width: moduleWidth,
					height: moduleHeight,
	                margin: '40 20 0 20',
					listeners: {
				        el: {
				            click: function(e, elem, eOpts) {
				            	var tabPanel = Ext.getCmp('panelNavigation');
				            	//tabPanel.setActiveTab('leftSystemMenu');
//				            	if(tabPanel.getCollapsed( )) {
//				            		tabPanel.expand();
//				            	}
				                moduleChange(m.id, m.title);
				                console.log('changed');
				            },
				            mouseover: function(e, elem, eOpts) {
				            	elem.src = CPATH+'/resources/css/theme_01/module_'+m.id+CUR_LANG_SUFFIX+".png";
				            },
				            mouseout: function(e, elem, eOpts) {
				            	elem.src = CPATH+'/resources/css/theme_01/module_'+m.id+'_over'+CUR_LANG_SUFFIX+".png";
				            }
				        }
				    }
				};
			modules.push(t);
			if(m.id == '38') {
				MODULE_GROUPWARE.ID = m.id;
				MODULE_GROUPWARE.TITLE = m.title;
				MODULE_GROUPWARE.ENABLE=true;
			}
		});
        // 프로세스 추가.
		modules.push({
                xtype: 'uniImg',
                src: CPATH+'/resources/css/theme_01/module_process_over'+CUR_LANG_SUFFIX+".png",
                //title: '<t:message code="main.menuTab.process" />',
                width: moduleWidth,
                height: moduleHeight,
                margin: '40 20 0 20',
                listeners: {
                    el: {
                        click: function() {
	                        var tabPanel = Ext.getCmp('panelNavigation');
//	                        tabPanel.setActiveTab('leftProcMenu');
//	                        if(tabPanel.getCollapsed( )) {
//	                        	tabPanel.expand();
//	                            //tabPanel.floatCollapsedPanel();
//	                        }
	                        moduleChange(MODULE_PROCESS.ID, '');
                        },
			            mouseover: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_process'+CUR_LANG_SUFFIX+".png";
			            },
			            mouseout: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_process_over'+CUR_LANG_SUFFIX+".png";
			            }
                    }
                }
        });
        // 즐겨찾기 추가.
        modules.push({
                xtype: 'uniImg',
                src: CPATH+'/resources/css/theme_01/module_bookmark_over'+CUR_LANG_SUFFIX+".png",
                //title: '<t:message code="main.menuTab.mymenu" />',
                width: moduleWidth,
                height: moduleHeight,
                margin: '40 20 0 20',
                listeners: {
                    el: {
                        click: function() {
                            var tabPanel = Ext.getCmp('panelNavigation');
//                            tabPanel.setActiveTab('leftMyMenu');
//                            if(tabPanel.getCollapsed( )) {
//                            	tabPanel.expand();
//                                //tabPanel.floatCollapsedPanel();
//                            }
                            moduleChange(MODULE_MYMENU.ID, '');
                        },
			            mouseover: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_bookmark'+CUR_LANG_SUFFIX+".png";
			            },
			            mouseout: function(e, elem, eOpts) {
			            	elem.src = CPATH+'/resources/css/theme_01/module_bookmark_over'+CUR_LANG_SUFFIX+".png";
			            }
                    }
                }
        });
		//바코드접수등록
        modulesOther.push({
                xtype: 'uniImg',
                src: CPATH+'/resources/css/theme_01/module_barcode1.png',
                //title: '<t:message code="main.menuTab.mymenu" />',
            	width: moduleWidth,
				height: moduleHeight,
                margin: '40 20 0 20',
                listeners: {
                    el: {
                        click: function() {
                         	window.open('matrl/mms131ukrv.do','_blank','width='+(1270)+',height='+(screen.availHeight)+'menubar=no,location=no,scrollbars=yes,resizable=no,top=0,left=0');
                        },
			            mouseover: function(e, elem, eOpts) {
			            	elem.src =  CPATH+'/resources/css/theme_01/module_barcode1_over.png';
			            },
			            mouseout: function(e, elem, eOpts) {
			            	elem.src =  CPATH+'/resources/css/theme_01/module_barcode1.png';
			            }
                    }
                }
        });
      	//현장등록시스템
        modulesOther.push({
                xtype: 'uniImg',
                src: CPATH+'/resources/css/theme_01/module_dsh1.png',
                //title: '<t:message code="main.menuTab.mymenu" />',
            	width: moduleWidth,
				height: moduleHeight,
                margin: '40 20 0 20',
                listeners: {
                    el: {
                        click: function() {
                         	window.open('z_dsh/s_dsh100ukrv_sh1.do','_self');
                        },
			            mouseover: function(e, elem, eOpts) {
			            	elem.src =  CPATH+'/resources/css/theme_01/module_dsh1_over.png';
			            },
			            mouseout: function(e, elem, eOpts) {
			            	elem.src =  CPATH+'/resources/css/theme_01/module_dsh1.png';
			            }
                    }
                }
        });
		function moduleChange(id, newTitle) {
			console.log("modulechange : ", id, newTitle);

			//var mStoreX = Ext.data.StoreManager.lookup("treeSystemMenuStore");

			var tabPanel = Ext.getCmp('panelNavigation');
			if(tabPanel.getCollapsed( )) {
            	tabPanel.expand();
            }

            //step1. activeTab 설정 (tabchange 이벤트 발생)
            if(id == MODULE_GROUPWARE.ID) {	// G/W 메뉴 처리
	        	tabPanel.items.each(function(item,i,len) {
		    		if( item.itemId == 'leftGroupWareMenu' ) {
		    			item.tab.show();
		    		} else {
		    			item.tab.hide();
		    		}
	        	});
	        	tabPanel.setActiveTab('leftGroupWareMenu');
	        	contentTabPanel.setActiveTab('groupware');
	        } else {	// 시스템 공통 메뉴 처리
	        	tabPanel.items.each(function(item,i,len) {
		    		if( item.itemId == 'leftGroupWareMenu' ) {
		    			item.tab.hide();
		    		} else {
		    			item.tab.show();
		    		}
	        	});
	        	if(id == MODULE_PROCESS.ID) {
	        		tabPanel.setActiveTab('leftProcMenu');
	        	}else if(id == MODULE_MYMENU.ID) {
	        		tabPanel.setActiveTab('leftMyMenu');
	        	}else{
	        		tabPanel.setActiveTab('leftSystemMenu');
	        		leftSystemMenuB.getStore().treeLoadRecords({
						params : {moduleId:id}
					},newTitle);
	        	}
	        }

	        //step2. panel title 변경 (위와 순서 주의)
           /* if( id != MODULE_PROCESS.ID && id != MODULE_MYMENU.ID ) {
	        	// 타이틀 설정 -------------------------------------------------------
				//tabPanel.suspendEvents( );
				//tabPanel.setTitle( newTitle );
				//tabPanel.resumeEvents( );

				//2014.05.15 modified by hjlee
				//tabPanel.setTitle() 사용 시 center 영역이 refresh 되는 문제 해결
	            header = tabPanel.header,
	            placeholder = tabPanel.placeholder;

		        tabPanel.title = newTitle;

		        if (header) {
		            if (header.isHeader) {
		                header.setTitle(newTitle);
		            } else {
		                header.title = newTitle;
		            }
		        }

		        if (placeholder) {
					var titleCmp = placeholder.titleCmp;
		        	if (titleCmp.rendered) {
			            titleCmp.textEl.update(newTitle || '&#160;');	// title || &nbsp;
			            //titleCmp.updateLayout();
			        }
		        } //end 타이틀 설정 ------------------------------------------------------
            }*/
		}



		/***********************************************************************
		 * Modules and Menu
		 */

		Ext.define('menuItemModel', {
			//extend:'Ext.data.Model',		//4.2.2
			extend:'Ext.data.TreeModel',	//5.0.0
			// pkGen : user, system(default)
			idProperty: 'prgID',
		    fields: [ 	{name: 'prgID' 		 	}
		    			,{name: 'text' 			}
		    			,{name: 'text_en' 		}
		    			,{name: 'text_cn' 		}
		    			,{name: 'text_jp' 		}
		    			,{name: 'text_vi' 		}
		    			,{name: 'cpath' 		}
		    			,{name: 'url' 			}
		    			,{name: 'viewYN'		}
		    			,{name: 'hideYN'		}
		    			,{name: 'authoUser'		}
		    			,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		    			,{name: 'index'}
				]
		});

		// System Menu Store
		var treeSystemMenuStore = Ext.create('Ext.data.TreeStore',{
			model: 'menuItemModel',
			storeId: 'treeSystemMenuStore',
	        autoLoad: false,
	        folderSort: true,
	        hasFilter:true,
	        filters: [
			   function(item) {
			    	return !item.data.hideYN || !Ext.isEmpty(item.data.children) ;
			   }
	         <c:if test="${showAllMenu == 'false'}">
	       		, function(item) {
			    	//return item.data.viewYN || !Ext.isEmpty(item.data.children) ;
	       			return item.data.viewYN ;
			    }
	        </c:if>
	        ],
	        proxy: {
	            type: 'direct',
	            api: {
	                read : 'mainMenuService.getMenuList'
	            }
	        },
	        treeLoadRecords:function(param, newTitle)	{
	        	var tabPanel = Ext.getCmp('panelNavigation');
	        	var oldTitle = tabPanel.title;
	        	if(!this.inLoading)	{
		        	this.inLoading = true;
		        	this.load(param);

		        	var header = tabPanel.header,
		                placeholder = tabPanel.placeholder;

			        tabPanel.title = newTitle;

			        if (header) {
			            if (header.isHeader) {
			                header.setTitle(newTitle);
			            } else {
			                header.title = newTitle;
			            }
			        }

			        if (placeholder) {
						var titleCmp = placeholder.titleCmp;
			        	if (titleCmp.rendered) {
				            titleCmp.textEl.update(newTitle || '&#160;');	// title || &nbsp;
				            //titleCmp.updateLayout();
				        }
			        }
	        	}else {
	        		tabPanel.title = oldTitle;
	        		Unilite.messageBox("이전 모듈 메뉴 로딩중입니다. 다시 시도하세요.")
	        	}
	        },
	        listeners: {
	        <c:choose>
	        	<c:when test="${ext_version == '4.2.2'}">
	        		load: function(store, node, records, successful, eOpts) { //4.2.2
	        	</c:when>
	        	<c:otherwise>
	        		load: function(store, records, successful, operation, node, eOpts) { //5.1.0
	        	</c:otherwise>
	        </c:choose>
	        			console.log("root System Menu load!");
	        			if(node) {
		        			var child = node.getChildAt( 0);
		        			if(child) {
		        				child.expand();
		        				if(child.hasChildNodes( ) ) {
		        					var child2 = child.getChildAt( 0);
		        					if(child2) {
		        						child2.expand();
		        					}
		        				}
		        			}
	        			}
	        			store.inLoading = false;
	        		}

	        }
		});


		// Process Menu Store
		var treeStoreProc = Ext.create('Ext.data.TreeStore',{
			model: 'menuItemModel',
			storeId: 'treeProcMenuStore',
	        autoLoad: true,
	        folderSort: true,
	        proxy: {
	            type: 'direct',
	            api: {
	                read : 'mainMenuService.getProcessMenu'
	            }
	        },
	        listeners: {
	        		load: function(store, node, eOpts) {
	        			console.log("root Process Menu load!");
	        		}
	        }
		});

		// My Menu Store
		var treeMyMenuStore = Ext.create('Ext.data.TreeStore',{
			model: 'menuItemModel',
			storeId: 'treeMyMenuStore',
	        autoLoad: true,
	        folderSort: true,
	        proxy: {
	            type: 'direct',
	            api: {
	                read : 'mainMenuService.getMyMenuList',
	                update: 'mainMenuService.updateMyMenuList'
	            }
	        },
	        listeners: {
	        		load: function(store, node, eOpts) {
	        			console.log("root My Menu load!");
	        		},
	        		nodemove: function(node,  oldParent, newParent, index, eOpts) {
	        			var me = this;
	        			var records = me.getUpdatedRecords( ) ;
	        			var records2 = me.getModifiedRecords( ) ;
		                    me.sync();

	        		}

	        }
		});

		var contextMenuForSystemMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '<t:message code="system.label.common.favoriteadd"  default="즐겨찾기에 등록"/>',
	                	handler: function(menuItem, event) {
	                		var t = menuItem.up('menu');
	                		console.log("NODDE:" , t.clikNode);
	                		var param = {
	                			pgmId:t.clikNode
	                		};
	                		mainMenuService.addMyMenu(param, function() {
	                			treeMyMenuStore.load();
	                		});
	                	}
	            	}
	        	]
    	});

    	var contextMenuForMyMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '<t:message code="system.label.common.favoritedelete"  default="즐겨찾기에서 삭제"/>',
	                	handler: function(menuItem, event) {
	                		var t = menuItem.up('menu');
	                		console.log("NODDE:" , t.clikNode);
	                		var param = {
	                			pgmId:t.clikNode
	                		};
	                		mainMenuService.removeMyMenu(param, function() {
	                			treeMyMenuStore.load();
	                		});
	                	}
	            	}
	        	]
    	});

    	// System Menu
		var leftSystemMenuB = Ext.create('Unilite.main.MainTreeForSystemMenu', {
			itemId: 'leftSystemMenu',
			store : treeSystemMenuStore,
			// dockedItems: [moduleNameBox],
			title:'<t:message code="system.label.common.system" default="시스템"/>',
			displayField:'text'+CUR_LANG_SUFFIX,

			listeners : {
				render: function() {
					Ext.getBody().on("contextmenu", Ext.emptyFn, null, {preventDefault: true});
					if(moduleArray.length > 0)
						moduleChange(moduleArray[0].id, moduleArray[0].title);
				},
				urlclick : function(rec, url, item) {
					if(url.substring(url.indexOf('/' , 1) +1, 7) == 'em'){//현황판 프로그램일 경우 window open으로 띄움
						window.open(CPATH + url,'_blank','width='+(screen.availWidth-10)+',height='+(screen.availHeight)+'menubar=no,location=no,scrollbars=yes,resizable=no,top=0,left=0');
						return;
					}
					if(url && rec.get('viewYN')) {
						if (typeof url !== "undefined") {
							openTab(rec, url, {authoUser:rec.get("authoUser")});
						} else {
							Unilite.messageBox("해당 프로그램이 등록 되지 않았습니다.");
						}
					}

				}
				,itemcontextmenu: function( tree, rec, item, index, event, eOpts ) {
					event.stopEvent();
					if(rec.isLeaf() && rec.get('viewYN') ) {
					// if(record.isLeaf() ) {
						contextMenuForSystemMenu.clikNode = rec.get("prgID");
						contextMenuForSystemMenu.showAt(event.getXY());
					}
				}
			}
		});

		// Process Menu
		var leftProcMenu = Ext.create('Unilite.main.MainTree', {
			itemId: 'leftProcMenu',
			store : treeStoreProc,
			// dockedItems: [moduleNameBoxProcess],
			title:'<t:message code="system.label.common.process" default="프로세스"/>',
			listeners : {
				urlclick : function(rec, url, item) {
					var processID = rec.get("prgID");
					openTab(rec, '/process.do?processID='+processID);

				}
			}
		});

		// My Menu
		var leftMyMenu = Ext.create('Unilite.main.MainTree', {
			itemId: 'leftMyMenu',
			store : treeMyMenuStore,
			// dockedItems: [moduleNameBoxMyMenu],
			title: '<t:message code="system.label.common.favorites" default="즐겨찾기"/>',
			viewConfig: {
				plugins: {
	                    ptype: 'treeviewdragdrop',
	                    containerScroll: true
				},
				listeners: {
					drop: function( node, data, overModel, dropPosition, eOpts ) {
					}
				}
			},
			listeners : {

				render: function() {
						Ext.getBody().on("contextmenu", Ext.emptyFn, null, {preventDefault: true});
					},
					urlclick : function(rec, url, item) {
						if(url && rec.get('viewYN')) {
							if (typeof url !== "undefined") {
								openTab(rec, url, {authoUser:rec.get("authoUser")});
							} else {
								Unilite.messageBox("해당 프로그램이 등록 되지 않았습니다.");
							}
						}

					}
				,itemcontextmenu: function( tree, record, item, index, event, eOpts ) {
					console.log("CONTEXT MENU");
					event.stopEvent();
					if(record.isLeaf()) {
						contextMenuForMyMenu.clikNode = record.get("prgID");
						contextMenuForMyMenu.showAt(event.getXY());
					}
				}
			}
		});

		// GroupWare Menu
		var leftGroupWareMenu ;
		if(MODULE_GROUPWARE.ENABLE) {
			leftGroupWareMenu =  <%@include file="mainGroupWareMenu.jsp" %>;
		}

		/***********************************************************************
		 * 시스템, 프로세스, 마이메뉴 panelNavigation
		 */
		var panelNavigationState = UniAppManager.getState('main.panelNavigationState');
//		var panelNavigation = {
//			xtype: 'tabpanel',
		var panelNavigation = new Ext.TabPanel({
			region : 'west',
			id : 'panelNavigation',
			stateId: 'main.panelNavigation',
			stateful: true,
			stateEvents: ['collapse', 'expand'],
			collapsible: true,
			collapsed: Ext.isDefined(UserInfo.appOption.collapseMenuOnOpen) ? UserInfo.appOption.collapseMenuOnOpen:true,
			floatable: false,
			animCollapse: false,

			header: {
				title: '',
				titlePosition: 2,
				height: 32,
				cls: 'moduleNameBox',
				tools:[{
				    type: 'expand',
				    tooltip: '<t:message code="system.label.common.menuexpand" default="메뉴펼치기"/>',
				    callback: function(header, tool, event) {
				    	var tab = panelNavigation.getActiveTab();
				    	if(Ext.isDefined(tab.expandAll)) {
					    	var tools = header.getTools()

					    	tab.getEl().mask('Expanding tree...');

					    	tools.forEach(function(btn) {
					    		btn.disable();
					    	});

							tab.expandAll(function() {
									tab.getEl().unmask();
									tools.forEach(function(btn) {
							    		btn.enable();
							    	});
							});
				    	};
				    }
				},{
				    type: 'collapse',
				    tooltip: '<t:message code="system.label.common.menucollapse" default="메뉴접기"/>',
				    callback: function(header, tool, event) {
				        var tab = panelNavigation.getActiveTab();
				        if(Ext.isDefined(tab.collapseAll)) {
					    	var tools = header.getTools()

					    	tools.forEach(function(btn) {
					    		btn.disable();
					    	});

							tab.collapseAll(function() {
									tools.forEach(function(btn) {
							    		btn.enable();
							    	});
							});
				        };
				    }
				},{
				    type: 'left',
				    tooltip: '<t:message code="system.label.common.menupanelcollapse" default="메뉴패널 접기"/>',
				    callback: function(header, tool, event) {
				        panelNavigation.collapse();
				    }
				}]
			},
//			header: {
//					title: '',
//					height: 32,
//					// baseCls: 'mainSubLogo',
//					cls: 'moduleNameBox'
//			},
			width: 220,
			minWidth: 175,
			maxWidth: 300,
			// split: true,
			split: {
				size: 4,
				frame: true
			},
			tabBar: {
				cls: 'main-x-tab-bar-horizontal'
			},
			minTabWidth: 70,
			frameHeader: false,
			//margins: '0 0 0 9',
            margins: '0 0 0 0',
			// padding : '0 0 5 5',
			plain: true,
			tabPosition : 'bottom',
			// collapseMode: 'header', // undefined : 접힐때 타일틀 나오며 마우스 클릭 하면 임시로
			// 메뉴 나옴.
			// collapseMode: 'mini',
			items : [ leftSystemMenuB,  leftProcMenu, leftMyMenu, leftGroupWareMenu ],
			uniOpt : {
			},
			listeners: {
            	tabchange: function( tabPanel, newCard, oldCard ) {
            		if(oldCard.itemId == 'leftSystemMenu' || oldCard.itemId == 'leftGroupWareMenu') {
            			tabPanel.uniOpt.oldTitle = tabPanel.title;
            		}
            		if(newCard.itemId != 'leftSystemMenu' || oldCard.itemId != 'leftGroupWareMenu') {
            			tabPanel.setTitle(newCard.title);
            		} else {
            			tabPanel.setTitle(tabPanel.uniOpt.oldTitle);
            		}
            	},
            	titlechange: function( p, newTitle, oldTitle, eOpts ){
                	console.log("title change : " +oldTitle + " => " + newTitle);
            	},
            	collapse: function( p, eOpts ) {
            		this.getSplitter().hide();
            		console.log('collapsed');
            	},
            	expand: function( p, eOpts ) {
            		this.getSplitter().show();
            		console.log('expanded');
            	}
			},
			getSplitter: function() {
				return Ext.getCmp('panelNavigation-splitter');
			}
		});

		// Main Contents Tab
		//tab1: home
		var tabContents = new Array();
		tabContents.push(<%@include file="main_homeContentsShin.jsp" %>);

		//tab2: portal
		var portal = Ext.create('Unilite.main.portal.${mainPortal}');
		portal.setTitle('<t:message code="system.label.common.portal" default="Portal"/>');
		tabContents.push(portal);

		//tab3: groupware
		if(MODULE_GROUPWARE.ENABLE) {
			tabContents.push(<%@include file="main_groupwareContents.jsp" %>);
		}
		var contentTabPanel = new Ext.TabPanel({
			// for viewPort
			region : 'center',
			padding: 0,
			maxTabNumber:20,
			id : 'contentTabPanel',
			plugins:[{
                ptype: 'uniTabscrollermenu',
                maxText  : 20,
                pageSize : 10
            }],
            tabBar : {
				height : 26
			},
            margins : '0 1 0 1',
			activeTab : 1,
			flex:1,
			tabPosition : 'bottom',
			plain : true,
			closeAction: 'hide',
			defaults: {
				closable : true,
				autoScroll : false,
				style: {
					'border-top': 'none !important'
				}
			},
			items : tabContents,
			listeners: {
            	tabchange: function( tabPanel, tab ) {
                	//window.location.hash = '#'+ tab.itemId;
                	//updateTitle(tab.uniOpt.title, tab.uniOpt.prgID);
					updateStatus(' ');
                	//console.log("tabchange : " + window.location.hash);
            },
            	beforeadd:function( tabPanel , component , index , eOpts)	{
            		if(tabPanel.items.length  >= tabPanel.maxTabNumber  )	{
            			component.destroy();
            			Unilite.messageBox('<t:message code="system.message.common.main006" default="Tab은 최대 10개까지만 가능하니 다른 Tab을 닫고 실행해주세요."/>');
            			return false
            		}
            	}
			}
		});
		//contentTabPanel.setActiveTab('home');

		// 하단 status
		var panelSouth = {
			region: 'south',
			border:1,
			items: [Ext.create('Ext.ux.statusbar.StatusBar',{
				        id: 'UNILITE_PG_STATUS',
				        dock: 'bottom',
				        border:0,
		            	iconCls: 'x-status-valid',
		            	defaultText: 'Ready',
				        items: [
                            {
					          xtype: "uniTransparentContainer",
					          flex: 1
					        },
					        '-',
					        '${loginVO.compName } / ${loginVO.divName } / ${loginVO.deptName }',
					        '-',
					        '${loginVO.userName }(${loginVO.userID }) '
					        ,
					        ' '
                            /*,
					         {
					        	xtype:"uniTransparentContainer",
					        	contentEl: "logOutDiv"
					        },
					        '-',' '*/
				        ]
				    }
			)]
		}

		var panelNorth =  <%@include file="main_panelNorth.jsp" %>; // panelNorth


       var viewCnfg = {
                layout : {
                    type:'border'
                },
                title : 'DeltaMES',
                defaults:{
                    collapsible: false
                },

                items : [panelNorth, panelNavigation, contentTabPanel , panelSouth,{
                	xtype:'uxiframe',
                	src:'about:blank',
                	id:'exceldownload',
                	width:0,
                	height:0,
                	region:'south'
                } ],
                renderTo : Ext.getBody(),
                listeners: {
//                    render: function() {
//                        hideAddressBar(); // for Mobile이나 chrome mobile지원 안됨.
//                    }
                }
            };

            if(Unilite.isMobile()) {
                var mWidth = window.screen.width,
                    mHeight = window.screen.height;
                var maxSide = Math.max(mWidth, mHeight);
                var mCnfg = null;
                var scale = Unilite.getScale();
                // mobile중 긴변 길이가 1024면 tablet 모드로 인식.
                if (maxSide >= 1024) {
                    if( maxSide == mWidth ) {
                        mCnfg = {width: mWidth, height: mHeight };
                    } else {
                        mCnfg = {width: mHeight, height: mWidth };
                    }
                    console.log("Your browser is tablet. " + mWidth + " x " + mHeight + ' scale : ' + scale);
                } else {
                    if( maxSide == mWidth ) {
                        mCnfg = {width: mWidth * 2, height: mHeight * 2 };
                    } else {
                        mCnfg = { width: mHeight * 2, height: mWidth * 2};
                    }
                    console.log("Your browser is mobile. " + mWidth + " x " + mHeight+ ' scale : ' + scale);
                }
                console.log("mCnfg:",mCnfg);
                viewCnfg= Ext.apply(viewCnfg, mCnfg );
                mainView = Ext.create('Ext.container.Container', viewCnfg);
            } else {            //메인 화면 렌더링 완료
                mainView = Ext.create('Ext.Viewport', viewCnfg);
            }



			//메인 화면 초기 동작 제어
			if(UserInfo.appOption.collapseMenuOnOpen) panelNavigation.collapse();
			else panelNavigation.expand();

			//메인 화면 초기 tab 제어
			contentTabPanel.setActiveTab('home');
	});	// Ext.onReady();

	<%@include file="mainCommon.jsp" %>

	var compListStore = Ext.data.StoreManager.lookup('compList');
	if(compListStore) compListStore.loadData(compListData)

</script>

</head>
<body id="ext-body" style="margin: 0; padding: 0;">
    <div id="home_notice" class="x-hide-display uni-pageTitle" >
		${companyTitle}
	</div>
</body>
</html>