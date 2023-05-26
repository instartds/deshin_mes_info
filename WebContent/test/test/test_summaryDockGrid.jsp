<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ page import="foren.framework.utils.*" %>
<%
		// <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

    	
		//request.setAttribute("DOC_TYPE", "PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"");
		
		
		
		//, maximum-scale=1.0 
%>
<!DOCTYPE html ${DOC_TYPE} >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=8" /><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Unilite</title>

<script type="text/javascript">
	var CPATH ='<%=request.getContextPath()%>';
</script>
<%
	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);
	request.setAttribute("isDevelopServer", isDevelopServer );
	//request.setAttribute("isDevelopServer", true);
	//request.setAttribute("isDevelopServer", false);
    	
    if (isDevelopServer) {
    	//request.setAttribute("ext_url", "/extjs/include-ext_4.2.2.gpl.js");
    	//request.setAttribute("ext_url", "/extjs/ext-all.js");
    	request.setAttribute("ext_url", "/extjs/ext-all-debug.js");
    	//request.setAttribute("ext_url", "/extjs/ext-all-dev_4.2.3_1370.js");
    	//request.setAttribute("ext_url", "/extjs/ext-all-debug_20140413-beta.js");
    	
    	//request.setAttribute("ext_url", "/extjs/ext-all-dev.js");
    	//request.setAttribute("ext_url", "/extjs/ext-all-debug-w-comments.js");
    } else {
    	request.setAttribute("ext_url", "/extjs/ext-all.js");
    }

	//request.setAttribute("css_url", "/extjs/resources/ext-theme-neptune-ko/ext-theme-neptune-all-debug.css");
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-unilite/ext-theme-unilite-all-new.css"); // classic
	request.setAttribute("css_url", "/extjs/resources/Z_temp4.22/index.css"); // 4.2.2    	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic_4.2.3/ext-theme-classic-all.css"); // 4.2.3    	
%>
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/app/Ext/ux/css/GroupTabPanel.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script> 
	
<script type="text/javascript">
	
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/extjs/src',
            	"Ext.ux": '${CPATH }/app/Ext/ux',
            	"Unilite": '${CPATH }/app/Unilite',
            	"Extensible": '${CPATH }/app/Extensible'
        }
	});
	Ext.require('*');
</script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-ko.js" />' ></script>
	
<c:choose>
<c:when test="${isDevelopServer }">	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/IFrame.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/DataTip.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/BoxReorderer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/ToolbarDroppable.js" />' ></script>
	
	<!--<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/MultiCellSelectionModel.js" />' ></script>-->
	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/GroupTabRenderer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/GroupTabPanel.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/form/NumericField.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/FiltersFeature.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/menu/ListMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/menu/RangeMenu.js" />' ></script>
	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/Filter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/BooleanFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/DateFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/DateTimeFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/NumericFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/StringFilter.js" />' ></script>	

	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/main/MainContentPanel.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/UniUtils.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/ValidateService.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/UniValidator.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/UniTypes.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/UniAppManager.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/UniAbstractApp.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/UniImg.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/menu/UniMenu.js" />' ></script>

    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/button/BaseButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/button/UniHoverButton.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/filter/UniListMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/filter/UniListFilter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniDateColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniPrice.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniNumber.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/UniTreeGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/UniGridMultiSorter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/UniSimpleGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/excel/Excel.js" />' ></script>
	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/BaseApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/BasePopupApp.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/BaseJSPopupApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/locale/Message-ko.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniWriter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/proxy/UniDirectProxy.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniTreeStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniAbstractStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniStoreSimple.js" />' ></script>
    
    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/data/UniTreeModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/state/UniStorageProvider.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/tab/UniTabPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/layout/UniTable.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniAbstractForm.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniSearchForm.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniSearchSubPanel.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniSearchPanel.js" />' ></script>
    
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniFieldSet.js" />' ></script>	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniDetailForm.js" />' ></script>	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniDetailFormSimple.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniCheckboxgroup.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/UniRadiogroup.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniFile.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniYearPicker.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniYearField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthRangeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniDateRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniDateFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniDateRangeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniDateField.js" />' ></script>	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniTimeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniNumberField.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/popup/UniPopupFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/popup/UniPopupAbstract.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/popup/UniPopupField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/popup/UniPopupColumn.js" />' ></script>
	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/window/UniWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/window/UniBaseWindowApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/window/UniDetailWindow.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/window/UniDetailFormWindow.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/UniPopup.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/panel/UploadPanel.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/excel/ExcelUploadWin.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/module/UniSales.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/module/UniAccnt.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/locale/unilite-lang-ko.js" />'> </script>

	<script type="text/javascript">
		var IS_DEVELOPE_SERVER = true;
	</script>
</c:when>
<c:otherwise>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/unilite.full.js" />'></script>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-ko.js" />' ></script>
</c:otherwise>
</c:choose>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/cm_common.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/ZeroClipboard/ZeroClipboard.min.js" />'></script>

<script type="text/javascript">
    
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
		     currency:  	'KRW',
		     userLang:		'KR',
		     compCountry:	'KR'
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
	function testTab() {
		alert("test:" + window.location.href);
	}
	Ext.onReady(function() {	
		//Ext.app.REMOTING_API.enableBuffer = 100;
		
		
 		Ext.enableFx=false;
		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
		Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);
				
		Ext.state.Manager.setProvider(Ext.create('Unilite.com.state.UniStorageProvider'));
		Ext.tip.QuickTipManager.init();
		
		var provider = Ext.state.Manager.getProvider();
		if(typeof SHT_INFO !== 'undefined') {
			var shtInfoArray = provider.decodeValue(SHT_INFO);
			
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
			appMain();
		} else {
			// alert ( ' onReady를 appMain function appMain() 으로 변경해 주세요 !');
		}
		
		
		Ext.require('Ext.ZIndexManager',
            function() {
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
        );
	});
	
	
	

</script>
<script type="text/javascript">
	
Ext.Loader.setConfig({
    enabled: true
});
Ext.Loader.setPath('Ext.ux', '../ux');

Ext.require([
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.form.field.Number',
    'Ext.form.field.Date',
    'Ext.tip.QuickTipManager',
    'Ext.ux.DataTip'
]);

Ext.define('Task', {
    extend: 'Ext.data.Model',
    idProperty: 'taskId',
    fields: [
        {name: 'projectId', type: 'int'},
        {name: 'project', type: 'string'},
        {name: 'taskId', type: 'int'},
        {name: 'description', type: 'string'},
        {name: 'estimate', type: 'float'},
        {name: 'rate', type: 'float'},
        {name: 'due', type: 'date', dateFormat:'m/d/Y'}
    ]
});

var data = [
    {projectId: 100, project: 'Ext Forms: Field Anchoring', taskId: 112, description: 'Integrate 2.0 Forms with 2.0 Layouts', estimate: 6, rate: 150, due:'06/24/2007'},
    {projectId: 100, project: 'Ext Forms: Field Anchoring', taskId: 113, description: 'Implement AnchorLayout', estimate: 4, rate: 150, due:'06/25/2007'},
    {projectId: 100, project: 'Ext Forms: Field Anchoring', taskId: 114, description: 'Add support for multiple<br>types of anchors', estimate: 4, rate: 150, due:'06/27/2007'},
    {projectId: 100, project: 'Ext Forms: Field Anchoring', taskId: 115, description: 'Testing and debugging', estimate: 8, rate: 0, due:'06/29/2007'},
    {projectId: 101, project: 'Ext Grid: Single-level Grouping', taskId: 101, description: 'Add required rendering "hooks" to GridView', estimate: 6, rate: 100, due:'07/01/2007'},
    {projectId: 101, project: 'Ext Grid: Single-level Grouping', taskId: 102, description: 'Extend GridView and override rendering functions', estimate: 6, rate: 100, due:'07/03/2007'},
    {projectId: 101, project: 'Ext Grid: Single-level Grouping', taskId: 103, description: 'Extend Store with grouping functionality', estimate: 4, rate: 100, due:'07/04/2007'},
    {projectId: 101, project: 'Ext Grid: Single-level Grouping', taskId: 121, description: 'Default CSS Styling', estimate: 2, rate: 100, due:'07/05/2007'},
    {projectId: 101, project: 'Ext Grid: Single-level Grouping', taskId: 104, description: 'Testing and debugging', estimate: 6, rate: 100, due:'07/06/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 105, description: 'Ext Grid plugin integration', estimate: 4, rate: 125, due:'07/01/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 106, description: 'Summary creation during rendering phase', estimate: 4, rate: 125, due:'07/02/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 107, description: 'Dynamic summary updates in editor grids', estimate: 6, rate: 125, due:'07/05/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 108, description: 'Remote summary integration', estimate: 4, rate: 125, due:'07/05/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 109, description: 'Summary renderers and calculators', estimate: 4, rate: 125, due:'07/06/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 110, description: 'Integrate summaries with GroupingView', estimate: 10, rate: 125, due:'07/11/2007'},
    {projectId: 102, project: 'Ext Grid: Summary Rows', taskId: 111, description: 'Testing and debugging', estimate: 8, rate: 125, due:'07/15/2007'}
];

Ext.onReady(function(){
    
    Ext.tip.QuickTipManager.init();
    
    var store = Ext.create('Ext.data.Store', {
        model: 'Task',
        data: data,
        sorters: {property: 'due', direction: 'ASC'},
        groupField: 'project'
    });

    var cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
        clicksToEdit: 1
    });
    var showSummary = true;
    
    //var grid = Ext.create('Ext.grid.Panel', {
    var grid = Unilite.createGrid('agj100ukrAccGrid1', {
    	uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        region: 'center',
        width: 800,
        height: 450,
        frame: true,
        title: 'Sponsored Projects',
        iconCls: 'icon-grid',
       
        columnLines : true,
        store: store,
        
        listeners: {
            beforeshowtip: function(grid, tip, data) {
                var cellNode = tip.triggerEvent.getTarget(tip.view.getCellSelector());
                if (cellNode) {
                    data.colName = tip.view.headerCt.columnManager.getHeaderAtIndex(cellNode.cellIndex).text;
                }
            }
        },
        selModel: {
            selType: 'cellmodel'
        },
        dockedItems: [{
            dock: 'top',
            xtype: 'toolbar',
            items: [{
                tooltip: 'Toggle the visibility of the summary row',
                text: 'Toggle Summary',
                enableToggle: true,
                pressed: true,
                handler: function() {
                    showSummary = !showSummary;
                    var view = grid.lockedGrid.getView();
                    view.getFeature('group').toggleSummaryRow(showSummary);
                    view.refresh();
                    view = grid.normalGrid.getView();
                    view.getFeature('group').toggleSummaryRow(showSummary);
                    view.refresh();
                }
            }]
        }],
        features: [ {
            ftype: 'summary',
            dock: 'bottom'
        }],
        columns: [{
            text: 'Task',
            width: 300,
            tdCls: 'task',
            sortable: true,
            dataIndex: 'description',
            hideable: false,
            summaryType: 'count',
            summaryRenderer: function(value, summaryData, dataIndex) {
                return ((value === 0 || value > 1) ? '(' + value + ' Tasks)' : '(1 Task)');
            },
            field: {
                xtype: 'textfield'
            }
        }, {
            header: 'Schedule',
            columns: [{
                header: 'Due Date',
                width: 125,
                sortable: true,
                dataIndex: 'due',
                summaryType: 'max',
                renderer: Ext.util.Format.dateRenderer('m/d/Y'),
                summaryRenderer: Ext.util.Format.dateRenderer('m/d/Y'),
                field: {
                    xtype: 'datefield'
                }
            }, {
                header: 'Estimate',
                width: 125,
                sortable: true,
                dataIndex: 'estimate',
                summaryType: 'sum',
                renderer: function(value, metaData, record, rowIdx, colIdx, store, view){
                    return value + ' hours';
                },
                summaryRenderer: function(value, summaryData, dataIndex) {
                    return value + ' hours';
                },
                field: {
                    xtype: 'numberfield'
                }
            }, {
                header: 'Rate',
                width: 125,
                sortable: true,
                renderer: Ext.util.Format.usMoney,
                summaryRenderer: Ext.util.Format.usMoney,
                dataIndex: 'rate',
                summaryType: 'average',
                field: {
                    xtype: 'numberfield'
                }
            }, {
                header: 'Cost',
                width: 114,
                flex: true,
                sortable: false,
                groupable: false,
                renderer: function(value, metaData, record, rowIdx, colIdx, store, view) {
                    return Ext.util.Format.usMoney(record.get('estimate') * record.get('rate'));
                },
                summaryType: function(records){
                    var i = 0,
                        length = records.length,
                        total = 0,
                        record;

                    for (; i < length; ++i) {
                        record = records[i];
                        total += record.get('estimate') * record.get('rate');
                    }
                    return total;
                },
                summaryRenderer: Ext.util.Format.usMoney
            }]
        }]
    });
    var slipContainer = {
		xtype:'panel',
		layout:{type:'border'},
		flex: 0.35,
		renderTo: document.body,
	 	items:[
	 		grid
	 	]
	}
});


</script>
