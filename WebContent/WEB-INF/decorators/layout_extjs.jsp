<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.unilite.com.code.*" %>
<%@ page import="foren.unilite.com.constants.CommonConstants" %>
<%@ page import="foren.framework.model.LoginVO" %>

<%
		// <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


		//request.setAttribute("DOC_TYPE", "PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"");


		//, maximum-scale=1.0
%>
<!DOCTYPE html ${DOC_TYPE} >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");

	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);

	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    	if(extjsVersion.equals("4.2.2")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-dev.js");
    	}else{
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    	}
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all.js");
    }

	LoginVO userSession = (LoginVO)request.getSession().getAttribute(CommonConstants.SESSION_KEY);
	String CSS_TYPE = "";
	if(request.getAttribute("CSS_TYPE") != null)	{
		CSS_TYPE = ObjUtils.getSafeString(request.getAttribute("CSS_TYPE"), "");
	}
    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides"+CSS_TYPE+".css");

    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);
    request.setAttribute("mainDomain",  ConfigUtil.getString("servers[@domain]", ""));
    request.setAttribute("UserLangCode",  userSession.getLanguage().toUpperCase());
    request.setAttribute("Currency",  userSession.getCurrency().toUpperCase());
    request.setAttribute("excelMaxRow",  ConfigUtil.getIntValue("common.excel.maxRowsToCSV", 1000));

    /*String hostName = request.getScheme()+"://"+request.getServerName();
    int portNum = request.getServerPort();

    if(request.isSecure() || portNum==443) {
    	hostName ="https://"+request.getServerName();
    }
    */

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
<script type="text/javascript">
	var CPATH ='<%=request.getContextPath()%>';
	var EXTVERSION ='<%=extjsVersion%>';
	var docURL = document.URL;
	var scheme = docURL.substring(0,docURL.indexOf("//")+2);
	var CHOST = scheme + '${CHOST}'// 'request.getScheme()
	var EXCEL_MAX_ROWS = ${excelMaxRow};
	<c:if test="${not empty mainDomain}">
		document.domain = '${mainDomain}';
	</c:if>
</script>
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
<c:if test="${ext_version == '4.2.2' || ext_version == '5.1.2'}">
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
</c:if>
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/ux-overrides.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}${CSS_TYPE}.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-overrides.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
<!--  간트차트 css  -->
<link rel="stylesheet" href="<c:url value='/resources/js/scheduler-4.2.1/build/scheduler.stockholm.css' />" id="bryntum-theme">
<!--  피벗 js -->
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/pivottable-master/c3.min.css" />' />
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/d3.min.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/c3.min.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/jquery.min.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/jquery-ui.min.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/jquery.ui.touch-punch.min.js" />' ></script>
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/pivottable-master/pivot.css" />' />
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/pivot.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/c3_renderers.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/d3_renderers.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/export_renderers.js" />' ></script>
<script type="text/javascript" src='<c:url value="/resources/pivottable-master/pivot.${CUR_LANG}.js" />' ></script>
<!--  피벗 js end -->
<script type="text/javascript">
	var EXT_ROOT = '${ext_root}';

	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/${ext_root}/src',
            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
            	"Extensible": '${CPATH }/${ext_root}/app/Extensible',
            	"Joins": '${CPATH }/${ext_root}/app/Joins'
        }
	});
	Ext.require('*');
	//Ext.validIdRe = /^[a-z_][a-z0-9\-_.]*$/i;
	var SAVE_AUTH = "false";
	var USE_PIVOT = "false";
	var MODIFY_AUTH = "false";
</script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-popupText-${CUR_LANG}.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-JSText-${CUR_LANG}.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/locale/Unilite-common-JSMessage-${CUR_LANG}.js" />' ></script>

<c:if test="${ext_version == '5.1.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>
</c:if>
<c:if test="${ext_version == '4.2.2'}">
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
</c:if>
<c:choose>
<c:when test="${isDevelopServer }">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/IFrame.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/DataTip.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/BoxReorderer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/ToolbarDroppable.js" />' ></script>

	<!--<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/MultiCellSelectionModel.js" />' ></script>-->

    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/GroupTabRenderer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/GroupTabPanel.js" />' ></script>

	<c:if test="${ext_version != '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/form/trigger/Clear.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/form/NumericField.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/FiltersFeature.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/menu/ListMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/menu/RangeMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/SubTable.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/Filter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/BooleanFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/DateFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/DateTimeFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/NumericFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/grid/filter/StringFilter.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/statusbar/StatusBar.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/DataView/Draggable.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/CellDragDrop.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/MainContentPanel.js" />' ></script>


	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/ValidateService.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniValidator.js" />' ></script>
	<c:if test="${ext_version == '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTypes.js"/>' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAppManager.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAbstractApp.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniImg.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/menu/UniMenu.js" />' ></script>

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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridLiveSearch.js" />' ></script>

	<c:if test="${ext_version != '6.0.1'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridMultiSorter.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniSimpleGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/ExcelDownload.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniPivotComponent.js" />' ></script>


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
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniSearchSubPanel.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniSearchPanel.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniOperatePanel.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniFieldSet.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniDetailForm.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniDetailFormSimple.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniCheckboxgroup.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniRadiogroup.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<c:if test="${ext_version == '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<c:if test="${ext_version != '4.2.2'}">
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTagField.js" />' ></script>
	</c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniFile.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniYearPicker.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniYearField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthRangeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDateRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDateFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDateRangeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniDateField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTimeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniNumberField.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupAbstract.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniPopupColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniTreePopupAbstract.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/popup/UniTreePopupField.js" />' ></script>

    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniBaseWindowApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniDetailWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniDetailFormWindow.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/PDFPrintWindow.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniGroupTabPanel.js" />'></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniPopup.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniTemplatePopup.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTreePopup.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/UploadPanel.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/excel/ExcelUploadWin.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniSales.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniMatrl.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniAccnt.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniHuman.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniBase.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniCost.js" />'> </script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniTemplatePopup.js" />'> </script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/ConfigurationCode.js" />'> </script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDropView.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDragView.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDragandDropView.js" />'></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/openapi/UniNaverSearch.js" />'></script>

	<script type="text/javascript">
		var IS_DEVELOPE_SERVER = true;
	</script>
</c:when>
<c:otherwise>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/unilite.full.js" />'></script>
</c:otherwise>
</c:choose>


<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-${CUR_LANG}.js" />' ></script>
<!-- script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-${CUR_LANG}.js" />'> </script -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-${CUR_LANG}.js" />' ></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/cm_common.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/ZeroClipboard/ZeroClipboard.min.js" />'></script>

<script type="text/javascript">
	if(EXTVERSION != '4.2.2' && EXTVERSION != '5.1.0')	{
    	Ext.enableAriaButtons = false;
    	Ext.enableAriaPanels = false;
	}

	var clipper;
	Ext.define("UserInfo", {
    		 singleton: true,
		     userID: 		"${loginVO.userID}",
		     userName: 		"${loginVO.userName}",
		     personNumb: 	"${loginVO.personNumb}",
		     divCode: 		"${loginVO.divCode}",
		     deptCode: 		"${loginVO.deptCode}",
		     deptName: 		"${loginVO.deptName}",
		     compCode: 		"${loginVO.compCode}",
		     currency:  	"${Currency}",
		     userLang:		"${UserLangCode}",
		     compCountry:	"${UserLangCode}",
		     refItem:		"${loginVO.refItem}",
		     customCode:	"${loginVO.customCode}",	//외부사용자용
		     customName:	"${loginVO.customName}",	//외부사용자용
		     deptAuthYn:	"${loginVO.deptAuthYn}",
		     appOption: 	(Ext.isDefined(parent) && Ext.isDefined(parent.UserInfo) ) ? parent.UserInfo.appOption:{}
		 }
	);
	//Ext.define("CommonMsg", {
	var CommonMsg = {
		'errorTitle':{
			'ERROR':'<t:message code="unilite.msg.errorTitle" default="에러"/>',
			'WARNING':'<t:message code="unilite.msg.warnTitle" default="경고"/>',
			'INFO':'<t:message code="unilite.msg.infoTitle" default="정보"/>'
		}
	};
	//)
	/*Ext.define("UniFormat", {
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
	*/
	var pgmInfo = {
		authoUser: '<%="null".equals(request.getParameter("authoUser")) ? "":request.getParameter("authoUser") %>'
	}

	var CSS_TYPE = '${CSS_TYPE}';

	Ext.onReady(function() {
		//Ext.app.REMOTING_API.enableBuffer = 100;


 		Ext.enableFx=false;
		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
		Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);

		Ext.state.Manager.setProvider(Ext.create('Unilite.com.state.UniStorageProvider'));
		Ext.tip.QuickTipManager.init();

		var provider = Ext.state.Manager.getProvider();
		var shtInfoArray ;
		if(typeof SHT_INFO !== 'undefined') {
			shtInfoArray = new Array();
			if(SHT_INFO && SHT_INFO.indexOf("^") > -1)	{

				var shtInfoSplit = SHT_INFO.split("^")

				var shtInfoArray = new Array();
				Ext.each(shtInfoSplit, function(sInfo){
					shtInfoArray.push(provider.decodeValue(sInfo));
				});
			} else {
				shtInfoArray = provider.decodeValue(SHT_INFO);
			}
			//grid별 기본설정으로 지정된 설정정보
			provider.setStore( Ext.create('Ext.data.Store', {
					storeId: "STATE_STORE",
				 	fields: ["id","shtInfo"],
				 	idProperty : 'id',
				 	data: shtInfoArray
			}));
		}
		if(typeof PGM_ID !== 'undefined') {
			Unilite.com.UniAppManager.id =PGM_ID;
		}

		var chk = false;
		if(typeof appMain !== 'undefined')  {
		 	if( Ext.isFunction(appMain)) {
				chk = true;
			}
		}
		if(chk) {
			//try{
				appMain();
			//}catch(e){
			//	console.log("#################################################");
			//	console.log("###", e);
			//	console.log("#################################################")
			//}
		} else {
			// alert ( ' onReady를 appMain function appMain() 으로 변경해 주세요 !');
		}


		Ext.require('Ext.ZIndexManager'
		<c:if test="${ext_version == '4.2.2'}">
			,function() {
                Ext.override(Ext.ZIndexManager, {
                    _setActiveChild: function(comp, oldFront) {
                        var front = this.front;
                        if (comp !== front) {


                            if (front && !front.destroying) {
                                front.setActive(false, comp);
                            }
                            this.front = comp;
                            if (comp && comp != oldFront) {
                                if (!(oldFront instanceof Ext.tip.ToolTip)) {
                                    comp.setActive(true);
                                    if (comp.modal) {
                                        this._showModalMask(comp);
                                    }
                                }
                            }
                        }
                    }

                });
            }
        </c:if>
        );


	});

	document.onkeydown = onKeydownHandlerOverrides;
	function onKeydownHandlerOverrides(event) {
	    switch (event.keyCode) {
	         case 117 : // 'F6'
	            if(Ext.isIE)	{
	            	event.returnValue = false;
	            	event.keyCode = 0;
	            	if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(UniAppManager.app && UniAppManager.app._clickToolBarButton)	{

	                	if(!(event.shiftKey || event.ctrlKey || event.altKey )) {
	                		UniAppManager.app._clickToolBarButton('delete');
	                	} else if(!event.shiftKey && event.ctrlKey && !event.altKey ) {
	                		UniAppManager.app._clickToolBarButton('deleteAll');
	                	}

	                }
	                return false;
	        	} else {
	        		if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(!(event.shiftKey || event.ctrlKey || event.altKey )) {
                		UniAppManager.app._clickToolBarButton('delete');
                	} else if(!event.shiftKey && event.ctrlKey && !event.altKey ) {
                		UniAppManager.app._clickToolBarButton('deleteAll');
                	}
	        	}
	            break;
	         case 118 : // 'F7'
	            if(Ext.isIE)	{
	            	event.returnValue = false;
	            	event.keyCode = 0;
	            	if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(UniAppManager.app && UniAppManager.app._clickToolBarButton)	{
	                	UniAppManager.app._clickToolBarButton('save');
	                }
	                return false;
	        	} else {
	        		if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(UniAppManager.app && UniAppManager.app._clickToolBarButton)	{
	                	UniAppManager.app._clickToolBarButton('save');
	                }
	        	}
	            break;
	            case 112 : // 'F1'
	            if(Ext.isIE)	{
	            	event.returnValue = false;
	            	event.keyCode = 0;
	            	if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(UniAppManager.app && UniAppManager.app.onManualButtonDown)	{
	                	if(Ext.isDefined(MANUAL_YN) && MANUAL_YN == 'Y')  {
	                		UniAppManager.app.onManualButtonDown();
	                	}
	                }
	                return false;
	        	} else {
	        		if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(UniAppManager.app && UniAppManager.app.onManualButtonDown)	{
	                	if(Ext.isDefined(MANUAL_YN) && MANUAL_YN == 'Y')  {
	                		UniAppManager.app.onManualButtonDown();
	                	}
	                }
	        	}
	            break;
	            case 187 : // 'F1'
	            if(Ext.isIE)	{

	        	} else {

	        	}
	            break;

	    }
	}
	window.onhelp =function() {
	    return false;
	}
</script>

<style>
    .nbox-x-panel-body {
        font-size: 12px;
        font-weight: normal;
        border-style: none;
    }
    .x-tab-bar-strip-default {
        border-style: none;
        background-color: #FFFFFF;
    }
    .x-horizontal-box-overflow-body {
        float: left;
        background-color: white;
    }

    .x-panel-nbox-footer {
        background:#ccc;
    }

</style>
</head>
<body id="ext-body">
<decorator:body />
</body>
</html>
