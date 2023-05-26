<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    String extjsVersion ="4.2.2";
	
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
	
    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);
    	
%>
<!doctype html> 
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><t:message code="extensible.cal.title" default="영업 현황 달력" /></title>
    

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
    <link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Extensible/resources/css/extensible-all_comp.css"/>' >
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}.css" />' />
    <script type="text/javascript">
	    var CPATH ='<%=request.getContextPath()%>';
	</script>
    
    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url}" />'></script> 
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-overrides.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
	
	

    <script type="text/javascript">
    	var EXT_ROOT = '${ext_root}';
    	
	    Ext.Loader.setConfig({
			enabled : true,
			scriptCharset : 'UTF-8',
			paths: {
	                "Ext": '${CPATH }/${ext_root}/src',
	            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
	            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
	            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
	        }
		});
	    Ext.require('*');
	</script>

    <script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>   
      
    <% // ?group=Popup,base,crm,cm,Cmd %>
<c:choose>
<c:when test="${isDevelopServer }">
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
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridMultiSorter.js" />' ></script>
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
    </c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/state/UniStorageProvider.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniTabPanel.js" />' ></script>
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
	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniBaseWindowApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniDetailWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/UniDetailFormWindow.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/window/PDFPrintWindow.js" />'></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniPopup.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/UploadPanel.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/excel/ExcelUploadWin.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniSales.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniMatrl.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/module/UniAccnt.js" />'> </script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/ConfigurationCode.js" />'> </script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDropView.js" />'></script> 
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDragView.js" />'></script> 
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniDragandDropView.js" />'></script> 
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/openapi/UniNaverSearch.js" />'></script>

	
	
	
	
	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/Extensible.js" />' ></script>   
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/CalendarMappings.js" />'  ></script>  
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventMappings.js" />'  ></script>    
            
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/BoxLayout.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/DayHeader.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/DayBody.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/Month.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/CalendarScrollManager.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/StatusProxy.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DragZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DropZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DayDragZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DayDropZone.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventModel.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventStore.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/CalendarModel.js" />'  ></script>
        
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/util/WeekEventRenderer.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/form/field/ReminderCombo.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/form/field/CalendarCombo.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/util/ColorPicker.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/gadget/CalendarListMenu.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/gadget/CalendarListPanel.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/menu/Event.js" />'  ></script>
        
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/AbstractCalendar.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MonthDayDetail.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Month.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/DayHeader.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/DayBody.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Day.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MultiDay.js" />'  ></script> 
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Week.js" />'  ></script> 
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MultiWeek.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/CalendarPanel.js" />'  ></script> 
    
    
</c:when>
<c:otherwise>    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/unilite.full.js" />'></script>  
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar.full.js" />'></script> 
</c:otherwise>
</c:choose>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-${CUR_LANG}.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-${CUR_LANG}.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-${CUR_LANG}.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/locale/extensible-lang-${CUR_LANG}.js" />'></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
    
    <script type="text/javascript">
    
        Ext.onReady(function() {	
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);   
            Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);
        
        	Ext.define('Extensible.store.DirectCalendarStore', {
				extend : 'Ext.data.Store',
				model : 'Extensible.calendar.data.CalendarModel',
				autoLoad : true,
				proxy : {
					type : 'direct',
					directFn : calendarService.readCalendars
				}
			});
			
        	Ext.define('Extensible.store.DirectEventStore', {
			    extend: 'Ext.data.Store',
			    model: 'Extensible.calendar.data.EventModel',
			    deferLoad: true,
			    
			    proxy: {
					type: 'direct',
				    api: {
				        read: calendarService.read,
				        create: calendarService.create,
				        update: calendarService.updatePlan,
				        destroy: calendarService.destroy
				    }		
				}
			
			});
        
        
        	var eventStore = Ext.create('Extensible.store.DirectEventStore');
        	var calendarStore = Ext.create('Extensible.store.DirectCalendarStore');
        	
            var cp =  {
            	xtype:'extensible.calendarpanel',
            	id:'uniCalendarPanel01',
                eventStore: eventStore,
                calendarStore: calendarStore,
                viewConfig: {
                     enableFx: false,
                     //ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
                     //viewStartHour: 6,
                     //viewEndHour: 18,
                     //minEventDisplayMinutes: 15
                     showTime: true
                 },
                    
                 monthViewCfg: {
                     showHeader: true,
                     showWeekLinks: true,
                     showWeekNumbers: true
                 },
                    
                 multiWeekViewCfg: {
                     //weekCount: 3
                 },
                 // Some optional CalendarPanel configs to experiment with:
                 readOnly: false,
                 showDayView: false,
                 //showMultiDayView: true,
                 //showWeekView: false,
                 //showMultiWeekView: false,
                 //showMonthView: false,
                 showNavJump:false,
                 showNavBar: true,
                 howTodayText: true,
                 showTime: false,
                 editModal: true,
                 enableEditDetails: false,
                 uniPopupUrl : '<c:url value="/cm/cmd100ukrv.do" />'   // AbstractCalendar.js, CalendarPanel.js
            };
            Ext.create('Ext.Viewport', {
				layout : {
					type : 'fit'
				},
				title : '영업활동',
				items : [ cp ],
				renderTo : Ext.getBody()
			})
        });
        
        function refresh() {
        	var cp = Ext.getCmp('uniCalendarPanel01');
        	cp._refresh();
        }
    </script>
</head>
<body>
    <div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
    	<img src='<c:url value="/resources/css/icons/icon-cal-MP.png" />' /> <t:message code="extensible.cal.calType.MP" default="계획" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MR.png" />' /> <t:message code="extensible.cal.calType.MR" default="결과" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MPR.png" />' /> <t:message code="extensible.cal.calType.MPR" default="전체(계획+결과)" />
    </div>
    <div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
   		
	    일정유형  
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="A" checked="false"><t:message code="extensible.cal.filter.private" default="개인" /></label>
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="B" checked="false"><t:message code="extensible.cal.filter.department" default="부서" /></label>
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="C" checked="true"><t:message code="extensible.cal.filter.all" default="전사" /></label>
    </div>
    <form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
</body>
</html>