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
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script> 
	
<script type="text/javascript">
	
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
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
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/statusbar/StatusBar.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/DataView/Draggable.js" />' ></script>	

	
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniTimeColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniPriceColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniNumberColumn.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/form/field/UniMonthRangeField.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/window/PDFPrintWindow.js" />'></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/UniPopup.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/panel/UploadPanel.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/excel/ExcelUploadWin.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/module/UniSales.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/module/UniAccnt.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/locale/unilite-lang-ko.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/ConfigurationCode.js" />'> </script>

	<script type="text/javascript">
		var IS_DEVELOPE_SERVER = true;
	</script>
</c:when>
<c:otherwise>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/unilite.full.js" />'></script>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-ko.js" />' ></script>
</c:otherwise>
</c:choose>


<script type="text/javascript" charset="UTF-8" src='<c:url value="/api-debug.do" />'></script>
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

</head>
<body id="ext-body">

</body>
</html>

<t:appConfig pgmId="ssa450skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Ssa450skrvModel1', {
	    fields: [    {name: 'SALE_CUSTOM_CODE'	        	,text:'거래처코드'		,type:'string'}
	    			,{name: 'SALE_CUSTOM_NAME'				,text:'거래처명'		,type:'string'}
	    			,{name: 'BILL_TYPE'						,text:'부가세유형'		,type:'string', comboType:"AU", comboCode:"S024"}
	    			,{name: 'SALE_DATE'						,text:'매출일'		,type:'uniDate'}
	    			,{name: 'INOUT_TYPE_DETAIL'	        	,text:'출고유형'		,type:'string',comboType:"AU", comboCode:"S007"}	    			
	    			,{name: 'ITEM_CODE'						,text:'품목코드'		,type:'string'}
	    			,{name: 'ITEM_NAME'						,text:'품명'			,type:'string'}
	    			,{name: 'CREATE_LOC'					,text:'생성경로'		,type:'string',comboType:"AU", comboCode:"B031"}
	    			,{name: 'SPEC'							,text:'규격'			,type:'string'}
	    			,{name: 'SALE_UNIT'						,text:'단위'			,type:'string'}
	    			,{name: 'PRICE_TYPE'					,text:'단가구분'		,type:'string'}
	    			,{name: 'TRANS_RATE'					,text:'입수'			,type:'string'}
	    			,{name: 'SALE_Q'						,text:'매출량'		,type:'uniQty'}
	    			,{name: 'SALE_WGT_Q'					,text:'매출량(중량)'	,type:'folat'}
	    			,{name: 'SALE_VOL_Q'					,text:'매출량(부피)'	,type:'string'}	    			
	    			,{name: 'CUSTOM_CODE'					,text:'수주거래처'		,type:'string'}
	    			,{name: 'CUSTOM_NAME'					,text:'수주거래처명'	,type:'string'}	    					
	    			,{name: 'SALE_P'						,text:'단가'			,type:'uniPrice'}
	    			,{name: 'SALE_FOR_WGT_P'				,text:'단가(중량)'		,type:'float'}	    			
	    			,{name: 'SALE_FOR_VOL_P'				,text:'단가(부피)'		,type:'string'}    			
	    			,{name: 'MONEY_UNIT'					,text:'화폐'			,type:'string'}
	    			,{name: 'EXCHG_RATE_O'					,text:'환율'			,type:'uniER'}
	    			,{name: 'SALE_LOC_AMT_F'				,text:'매출액(외화)'	,type:'uniPrice'}
	    			,{name: 'SALE_LOC_AMT_I'				,text:'매출액'		,type:'uniPrice'}
	    			,{name: 'TAX_TYPE'						,text:'과세여부'		,type:'string', comboType:"AU", comboCode:"B059"}
	    			,{name: 'TAX_AMT_O'						,text:'세액'			,type:'uniPrice'}
	    			,{name: 'SUM_SALE_AMT'					,text:'매출계'		,type:'uniPrice'}    			
	    			,{name: 'ORDER_TYPE'					,text:'판매유형'		,type:'string',comboType:"AU", comboCode:"S002"}
	    			,{name: 'DIV_CODE'						,text:'사업장'		,type:'string',comboType:"BOR120"}
	    			,{name: 'SALE_PRSN'						,text:'영업담당'		,type:'string',comboType:"AU", comboCode:"S010"}
	    			,{name: 'MANAGE_CUSTOM'					,text:'집계거래처'		,type:'string'}
	    			,{name: 'MANAGE_CUSTOM_NM'				,text:'집계거래처명'	,type:'string'}
	    			,{name: 'AREA_TYPE'						,text:'지역'			,type:'string',comboType:"AU", comboCode:"B056"}
	    			,{name: 'AGENT_TYPE'					,text:'거래처분류'		,type:'string',comboType:"AU", comboCode:"B055"}	    			
	    			,{name: 'PROJECT_NO'					,text:'관리번호'		,type:'string'}
	    			,{name: 'PUB_NUM'						,text:'계산서번호'		,type:'string'}
	    			,{name: 'EX_NUM'						,text:'전표번호'		,type:'string'}
	    			,{name: 'BILL_NUM'						,text:'매출번호'		,type:'string'}
	    			,{name: 'ORDER_NUM'						,text:'수주번호'		,type:'string'}
	    			,{name: 'DISCOUNT_RATE'					,text:'할인율(%)'		,type:'float'}	    			
	    			,{name: 'PRICE_YN'						,text:'단가구분'		,type:'string', comboType:"AU", comboCode:"S003"}
	    			,{name: 'WGT_UNIT'						,text:'중량단위'		,type:'string'}
	    			,{name: 'UNIT_WGT'						,text:'단위중량'		,type:'string'}
	    			,{name: 'VOL_UNIT'						,text:'부피단위'		,type:'string'}
	    			,{name: 'UNIT_VOL'						,text:'단위부피'		,type:'string'}
	    			,{name: 'COMP_CODE'						,text:'법인코드'		,type:'string'}
	    			,{name: 'BILL_SEQ'						,text:'계산서 순번'		,type:'string'}
	    			
	    			
	    			
	    			
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa450skrvMasterStore1',{
			model: 'Ssa450skrvModel1',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa450skrvService.selectList1'                	
                }
            }
			,loadStoreRecords : function()	{	
				
				 var form = panelSearch.getForm();
	            
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'SALE_CUSTOM_NAME'
					
			
	});
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
	            	layout : {type : 'vbox', align : 'stretch'},
	            	items : [{	xtype:'container',
	            				layout : {type : 'uniTable', columns : 3},
	            			 	items:[ {fieldLabel: '사업장'		,name:'DIV_CODE', xtype: 'uniCombobox', comboType:'BOR120', allowBlank:false }
	            			 		   , Unilite.popup('CUST',{ fieldLabel: '거래처', textFieldWidth:170, validateBlank:false,  id:'bpr400ukrvCustPopup'
	            			 		   							, extParam:{'CUSTOM_TYPE':'3'}, colspan:2, valueFieldName: 'SALE_CUSTOM_CODE', textFieldName:'SALE_CUSTOM_NAME'})	
					            	   ,{fieldLabel: '영업담당'	,name:'SALE_PRSN', xtype: 'uniCombobox', comboType:'AU',comboCode:'S010'}
					            	   , Unilite.popup('ITEM', { fieldLabel: '품목코드', textFieldWidth:170, validateBlank:false})
					            	   ,{xtype:'uniTextfield',name:'PROJECT_NO', fieldLabel:'관리번호'}
					            	   ,{ fieldLabel: '품목계정',name:'ITEM_ACCOUNT', xtype: 'uniCombobox', comboType:'AU',comboCode:'B020'}
            			 		       ,{ fieldLabel: '매출일'
            			 		       ,width:315
						               ,xtype: 'uniDateRangefield'
						               ,startFieldName: 'SALE_FR_DATE'
						               ,endFieldName: 'SALE_TO_DATE'
						               ,startDate: UniDate.get('startOfMonth')
						               ,endDate: UniDate.get('today')
						               
						            	 }
						               ,{
						            		xtype: 'radiogroup',
						            		fieldLabel: '매출기표유무',
						            		id: 'rdoSelect1',
						            		items : [{boxLabel  : '전체', width:50 ,name: 'SALE_YN', inputValue: 'A', checked: true  }
						                    		,{boxLabel  : '기표', width:50 ,name: 'SALE_YN' , inputValue: 'Y'}
						                    		,{boxLabel  : '미기표', width:70 ,name: 'SALE_YN' , inputValue: 'N'}						                    		
						                    		]}  	 
					            	   ,{fieldLabel: '생성경로',name:'TXT_CREATE_LOC', xtype: 'uniCombobox', comboType:'AU',comboCode:'B031'} 
					            	   ,{fieldLabel: '부가세유형',name:'BILL_TYPE', xtype: 'uniCombobox', comboType:'AU',comboCode:'S024'}	
					            	   ,{fieldLabel: '월',name:'SALE_MON', xtype: 'uniMonthfield'}
					            	   ,{ fieldLabel: '매출월'
	            			 		       ,width:315
							               ,xtype: 'uniMonthRangefield'
							               ,startFieldName: 'SALE_FR_MONTH'
							               ,endFieldName: 'SALE_TO_MONTH'
							               ,startDate: UniDate.get('startOfMonth')
							               ,endDate: UniDate.get('today')
							               ,allowBlank: false
						            	 }
					            	   ,{fieldLabel: 'activeTab', name:'ACTIVE_TAB', hidden:false, xtype:'hiddenfield'}
	            			 	    ]	
	            			 },
	            			 {
	            			 	 xtype: 'container',
	            			     defaultType: 'uniTextfield',
	            			 	 layout: {type: 'uniTable', columns: 3},
	            			 	 hidden: true,
	            			 	 id : 'AdvanceSerch',
	            			 	 items: [ 
	            			 	 		  {fieldLabel: '거래처분류'	,name:'AGENT_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'B055'  }
	            			 	 		 , Unilite.popup('ITEM2',{ fieldLabel: '대표모델', textFieldWidth:170, validateBlank:false})
	            			 	 		 ,{fieldLabel: '출고유형',name:'INOUT_TYPE_DETAIL', xtype: 'uniCombobox', comboType:'AU',comboCode:'S007'}
	            			 	 		 ,{fieldLabel: '지역'		,name:'AREA_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'B056'  }
	            			 	 		 , Unilite.popup('CUST',{ fieldLabel: '집계거래처', validateBlank:false,textFieldWidth:170,valueFieldName: 'MANAGE_CUSTOM', textFieldName:'MANAGE_CUSTOM_NAME'
					            								 ,id:'ssa450skrvvCustPopup', extParam:{'CUSTOM_TYPE':''}})
	            			 	 		 ,{fieldLabel: '판매유형'	,name:'ORDER_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'S002'}	            			 	 		 
			            			 	 ,{ fieldLabel: '대분류'    ,name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  child: 'TXTLV_L2'}
			            			 	 ,{ 
			            			 	 	xtype: 'container',
	            			 				layout: {type: 'hbox', align:'stretch'},
	            			 				width:325,
	            			 				defaultType: 'uniTextfield',	            			 				
	            			 				items:[{fieldLabel:'매출번호', suffixTpl:'&nbsp;~&nbsp;', name: 'BILL_FR_NO', width:218},	            			 				
	            			 				{hideLabel : true, name: 'BILL_TO_NO', width:107}
	            			 				] 
							             }
							             ,{fieldLabel: '매출량'		,name:'SALE_FR_Q' , suffixTpl:'&nbsp;이상'}
							             ,{ fieldLabel: '중분류'	,name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  child: 'TXTLV_L3'}
							             ,{ 
			            			 	 	xtype: 'container',
	            			 				layout: {type: 'hbox', align:'stretch'},
	            			 				width:325,
	            			 				defaultType: 'uniTextfield',	            			 				
	            			 				items:[{fieldLabel:'계산서번호', suffixTpl:'&nbsp;~&nbsp;', name: 'PUB_FR_NUM', width:218},	            			 				
	            			 				{hideLabel : true, name: 'PUB_TO_NUM', width:107}
	            			 				] 
							             },{fieldLabel:' ',name:'SALE_TO_Q', suffixTpl:'&nbsp;이하'}
							             ,{ fieldLabel: '소분류'	,name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' }
								         ,{ fieldLabel: '출고일'
							               ,xtype: 'uniDateRangefield'
							               ,startFieldName: 'INOUT_FR_DATE'
							               ,endFieldName: 'INOUT_TO_DATE'							               
							               ,width:315							              
							              }
	            			 	]
	            			 
	            			 }
	            		
		          ]
    });    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('ssa450skrvGrid1', {
    	// for tab
    	//title: '거래처별',
        layout : 'fit',    
		syncRowHeight: true,    
    	store: directMasterStore1,
    	uniOpt: { 
    		useRowNumberer: false,
    		useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
    		useContextMenu: true,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
    	},
//    	selModel: Ext.create('Ext.ux.MultiCellSelectionModel',{
//                mode: 'MULTI',
//                allowDeselect: true
//        }),     
        multiSelect: true,
    	selType: 'cellmodel',
    	tbar: [{
        	text:'상세보기...',
        	handler: function() {
        		
        	}
        },{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'estimateBtn',
					text: '견적참조',
					handler: function() {
						openEstimateWindow();
						}
				}, {
					itemId: 'refBtn',
					text: '수주이력참조',
		        	handler: function() {
			        		openRefWindow();
		        		}
				}, {
					itemId: 'scmBtn',
					text: '업체발주참조(SCM)',
		        	handler: function() {
			        		openScmWindow();
		        		}
				}, {
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        		openExcelWindow();
			        	}
				}]
			})
		},'-', {
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'reqIssueLinkBtn',
					text: '출하지시등록',
					handler: function() {
						}
				}, {
					itemId: 'issueLinkBtn',
					text: '출고등록',
		        	handler: function() {
		        		}
				}, {
					itemId: 'saleLinkBtn',
					text: '매출등록',
		        	handler: function() {
			        		openScmWindow();
		        		}
				}]
			})
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true, dock:'top' },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: true} ],
        columns:  [        
               		 { dataIndex:'SALE_CUSTOM_CODE'	        		,		   	width:80, filter: {type: 'uniList'}, 
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');										
                    }} 			
					,{ dataIndex:'SALE_CUSTOM_NAME'			,		   	width:100, filter: {type: 'string'} } 	
					,{ dataIndex:'BILL_TYPE'				,		   	width:80}	
					,{ dataIndex:'SALE_DATE'				,		   	width:80, filter: {type: 'date'}} 				     
					,{ dataIndex:'INOUT_TYPE_DETAIL'	 	,		   	width:123}				     
					,{ dataIndex:'ITEM_CODE'				,		   	width:123} 				     
					,{ dataIndex:'ITEM_NAME'				,		   	width:123 , filter: {type: 'uniList'}}					
					,{ dataIndex:'SPEC'						,		   	width:123 } 				 
					,{ dataIndex:'SALE_UNIT'				,		   	width:53, align:'center', filter: {type: 'uniList'}} 				     
					,{ dataIndex:'PRICE_TYPE'				,		   	width:53, hidden:true} 			
					,{ dataIndex:'TRANS_RATE'				,		   	width:53, align:'right'}						
					,{ dataIndex:'SALE_Q'					,		   	width:80, summaryType:'sum'} 				     
					,{ dataIndex:'SALE_WGT_Q'				,		   	width:100, hidden:true } 			
					,{ dataIndex:'SALE_VOL_Q'				,		   	width:80, hidden:true},
					{ dataIndex:'CUSTOM_CODE'				,		   	width:80} 				     
					,{ dataIndex:'CUSTOM_NAME'				,		   	width:113 }
					,{ dataIndex:'SALE_P'					,		   	width:113 } 				     
					,{ dataIndex:'SALE_FOR_WGT_P'			,		   	width:113, hidden:true } 	
					,{ dataIndex:'SALE_FOR_VOL_P'			,		   	width:113, hidden:true} 	
					,{ dataIndex:'MONEY_UNIT'				,		   	width:80} 				     
					,{ dataIndex:'EXCHG_RATE_O'				,		   	width:80, align:'right'} 		
					,{ dataIndex:'SALE_LOC_AMT_F'			,		   	width:113, summaryType:'sum'} 				     	
					,{ dataIndex:'SALE_LOC_AMT_I'			,		   	width:113, summaryType:'sum' } 				     
					,{ dataIndex:'TAX_TYPE'					,		   	width:80, align:'center'} 				     
					,{ dataIndex:'TAX_AMT_O'				,		   	width:113, summaryType:'sum'}				     
					,{ dataIndex:'SUM_SALE_AMT'				,		   	width:113, summaryType:'sum' }				 
					,{ dataIndex:'ORDER_TYPE'				,		   	width:100 } 				 
					,{ dataIndex:'DIV_CODE'					,		   	width:100 } 				 
					,{ dataIndex:'SALE_PRSN'				,		   	width:100} 				     
					,{ dataIndex:'MANAGE_CUSTOM'			,		   	width:80} 				     
					,{ dataIndex:'MANAGE_CUSTOM_NM'			,		   	width:113 }				     
					,{ dataIndex:'AREA_TYPE'				,		   	width:66 }			         
					,{ dataIndex:'AGENT_TYPE'				,		   	width:113 }
					,{ dataIndex:'PROJECT_NO'				,		   	width:113} 				     
					,{ dataIndex:'PUB_NUM'					,		   	width:80} 				     
					,{ dataIndex:'EX_NUM'					,		   	width:93 } 				     
					,{ dataIndex:'BILL_NUM'					,		   	width:106 } 				 
					,{ dataIndex:'ORDER_NUM'				,		   	width:106 } 				 
					,{ dataIndex:'DISCOUNT_RATE'			,		   	width:106 } 				 
					,{ dataIndex:'PRICE_YN'					,	    	width:106 }					
					,{ dataIndex:'WGT_UNIT'					,	    	width:106, hidden:true }
					,{ dataIndex:'UNIT_WGT'					,	    	width:106, hidden:true }
					,{ dataIndex:'VOL_UNIT'					,	    	width:106, hidden:true }
					,{ dataIndex:'UNIT_VOL'					,	    	width:106, hidden:true }
					,{ dataIndex:'COMP_CODE'				,	    	width:106, hidden:true }
					,{ dataIndex:'BILL_SEQ'					,	    	width:106, hidden:true }
					,{ dataIndex:'CREATE_LOC'				,		   	width:80 }
					
          ] 
    });
	
    Unilite.Main( {
		items : [panelSearch, 	masterGrid1],
		id  : 'ssa450skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			
			directMasterStore1.loadStoreRecords();	
			
			/*
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			
			var masterGridSubTotal, masterGridTotal;
			
			masterGridSubTotal = viewLocked.getFeature('masterGridSubTotal'); 
			if(!Ext.isEmpty(masterGridSubTotal)) masterGridSubTotal.toggleSummaryRow(true);
			masterGridTotal = viewLocked.getFeature('masterGridTotal');
			if(!Ext.isEmpty(masterGridTotal)) masterGridTotal.toggleSummaryRow(true);
			
			masterGridSubTotal = viewNormal.getFeature('masterGridSubTotal'); 
			if(!Ext.isEmpty(masterGridSubTotal)) masterGridSubTotal.toggleSummaryRow(true);
			masterGridTotal = viewNormal.getFeature('masterGridTotal');
			if(!Ext.isEmpty(masterGridTotal)) masterGridTotal.toggleSummaryRow(true);		*/	
	
		},		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
