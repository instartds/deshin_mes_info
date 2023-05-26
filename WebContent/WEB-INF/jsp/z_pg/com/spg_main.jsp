<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
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
	
    //request.setAttribute("css_url", "/extjs/resources/ext-theme-classic-omega/ext-overrides.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);
%>
<!DOCTYPE html>
<html lang="${CUR_LANG}" xml:lang="${CUR_LANG}">
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0"> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Unilite</title>
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/fullscreen.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>

<script type="text/javascript">
	alert('${ext_version}');
	var CPATH ='<%=request.getContextPath()%>';
	var CUR_LANG='${CUR_LANG}';
	var CUR_LANG_SUFFIX='${CUR_LANG_SUFFIX}';
	var EXT_ROOT = '${ext_root}';
	
	Ext.Loader.setConfig({
		enabled : true,
		paths : {
			"Ext" : '${CPATH }/${ext_root}/src',
			"Ext.ux" : '${CPATH }/${ext_root}/app/Ext/ux',
			"Unilite" : '${CPATH }/${ext_root}/app/Unilite',
			"Extensible" : '${CPATH }/${ext_root}/app/Extensible'
		}
	});
		
</script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>

<c:choose>
<c:when test="${isDevelopServer }">	

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/IFrame.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/statusbar/StatusBar.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/statusbar/ValidationStatus.js" />'></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/ux/DataTip.js" />' ></script>
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

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniImg.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniTreeGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/Excel.js" />' ></script>
	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BaseApp.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BasePopupApp.js" />' ></script>	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniWriter.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/proxy/UniDirectProxy.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeStore.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStore.js" />' ></script>
	<c:if test="${ext_version != '4.2.2'}">
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniFields.js" />' ></script>
    </c:if>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeModel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/state/UniStorageProvider.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniTabPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/tab/UniTabScrollerMenu.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/layout/UniTable.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniAbstractForm.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/UniSearchForm.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthRangeFieldLayout.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthFieldForRange.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthRangeField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniMonthField.js" />' ></script>
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniPopup.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/panel/UploadPanel.js" />' ></script>	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/menu/UniMenu.js" />' ></script>
	
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/main/MainTree.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniTransparentContainer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniActionContainer.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/view/UniHeaderConfig.js" />' ></script>

</c:when>
<c:otherwise>
		<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/unilite.full.js" />'></script>
</c:otherwise>
</c:choose>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-${CUR_LANG}.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-${CUR_LANG}.js" />'> </script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-${CUR_LANG}.js" />' ></script>


<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/cm_common.js" />'></script>

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
		     currency:  'KRW',
		     appOption: {
		     	collapseMenuOnOpen: true,
		     	showPgmId: false,
		     	collapseLeftSearch: true
		     }
		 }
	);
	
	Ext.onReady(function() {
		var mainView = {};
		Ext.require([ 'Ext.ux.IFrame', 'Ext.ux.statusbar.StatusBar','Ext.ux.statusbar.ValidationStatus' ]);

		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
		Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);

		Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
		Ext.tip.QuickTipManager.init();
		
 		Ext.enableFx=true;
 		var treeStore = Ext.create('Ext.data.TreeStore', {
			root : {
				expanded : true,
					children : [ 
					{
						text : "사용자공통코드등록",
						url : '/base/bsa110ukrv.do',
						prgID : 'bsa110ukrv',
						leaf : true
					},{
						text : "사용자 등록",
						url : '/base/bsa300ukrv.do',
						prgID : 'bsa300ukrv',
						leaf : true
					},{
						text : "부서 등록",
						url : '/base/bor130ukrv.do',
						prgID : 'bor130ukrv',
						leaf : true
					},{
						text : "사용자별 권한 등록",
						url : '/base/bsa500ukrv.do',
						prgID : 'bsa500ukrv',
						leaf : true
					},{
						text : "거래처 등록",
						url : '/base/bcm100ukrv.do',
						prgID : 'bcm100ukrv',
						leaf : true
					},
					{
						text : "파일분류등록",
						url : '/base/spg_bdc110ukrv.do',
						prgID : 'spg_bdc110ukrv',
						leaf : true
					} ,
					{
						text : "파일관리",
						url : '/base/spg_bdc100ukrv.do',
						prgID : 'spg_bdc100ukrv',
						leaf : true
					} ]
			}
		});
		
	
		Ext.define('menuItemModel', {
			extend:'Ext.data.Model',
			// pkGen : user, system(default)
			idProperty: 'prgID',
		    fields: [ 	{name: 'prgID' 		 	}
		    			,{name: 'text' 			}
		    			,{name: 'text_en' 		}
		    			,{name: 'text_cn' 		}
		    			,{name: 'text_jp' 		}
		    			,{name: 'url' 			}
		    			,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		    			,{name: 'index'}
				]
		});
		

		var leftSystemMenuB = Ext.create('Unilite.main.MainTree', {
			flex:1,
			store : treeStore,
			margins: '0 0 0 5',
			listeners : {
				urlclick : function(rec, url, item) {
					if(url) {
						if (typeof url !== "undefined") {
							openTab(rec, url);
						} else {
							alert("해당 프로그램이 등록 되지 않았습니다.");
						}
					}
					
				}
			}
		});
		
		var panelNavigation = {
			xtype: 'panel',
			collapsible : true,
			region : 'west',
			id : 'panelNavigation',
			header: {
					title:'파일관리시스템',
					height:42,
					//baseCls: 'mainSubLogo',
					cls: 'moduleNameBox'
			},
			width: 220,
			minWidth: 175,
			maxWidth: 300,
			//split: true,
			split: {
				size: 8,
				frame: true
			},
			tabBar: {
				cls: 'main-x-tab-bar-horizontal'
			},
			minTabWidth: 70,
			frameHeader: false,
			margins: '0 0 0 9',
			//padding : '0 0 5 5',
			plain: true,
			tabPosition : 'bottom',
			//collapseMode:  'header',  // undefined : 접힐때 타일틀 나오며 마우스 클릭 하면 임시로 메뉴 나옴.
			//collapseMode:  'mini',
			items : [leftSystemMenuB ]
		};
		
		
		// Main Contents
		var contentTabPanel = new Ext.TabPanel({
			// for viewPort
			region : 'center',
			padding: 0,
			// 
			id : 'contentTabPanel',
			plugins:[{
                ptype: 'uniTabscrollermenu',
                maxText  : 20,
                pageSize : 10
            }],
			margins : '0 1 5 1',
			activeTab : 1,
			flex:1,
			tabPosition : 'bottom',
			plain : true,
			defaults: {
				closable : true,
				autoScroll : false,
				style: {
					'border-top': 'none !important'
				}
			},
			items : [  {
				//contentEl : "center1",
				title : 'Home',
				closable : false,
				bodyPadding: 10,
				flex:1,
				defaults: {
			    	bodyStyle: 'padding:15px;',
			        frame: true,
			        boder: true
			    },
				layout: {
					type:'table', 
					columns:2,
					border:10,
					tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%',
			                'vertical-align': 'top',
			                padding: '5px'
			            }
			        }
			    },
				items : [
					{ title: '',
					  flex:1,
					  colspan: 2,
					  html: '<br/><br/><br/><br/><br/><br/><br/><br/>...'
					}
				]
			} ],
			listeners: {
            	tabchange: function( tabPanel, tab ) {
//                	window.location.hash = '#'+ tab.itemId;
//                	console.log("tabchange : " + window.location.hash);
                	updateTitle(tab.title);
            	}
			}
		});

		
		var panelSouth = {
			region: 'south',
			border:1,
			items: [Ext.create('Ext.ux.statusbar.StatusBar',{
				        id: 'UNILITE_PG_STATUS',
				        dock: 'bottom',
				        border:0,
		            	iconCls: 'x-status-valid',
		            	defaultText: 'Ready'
				    ,
			        items: [{
				          xtype: "uniTransparentContainer",
				          flex: 1
				        },
				        '-',
				        " ${contextName}.${loginVO.compCode}",
				        '-',
				        '${loginVO.compName } / ${loginVO.divName } / ${loginVO.deptName } / ${loginVO.userName }(${loginVO.userID }) '
				        ,
				        '-',
				         { 
				        	xtype:"uniTransparentContainer",
				        	contentEl: "logOutDiv"
				        },
				        '-',' '
				        ]
				    }
			)]
		}
		
		var panelNorth = {
		  	region : 'north',
			id : 'panelNorth',
	        xtype: "container",
	        layout: "hbox",
	        defaults: {
		         xtype: "uniTransparentContainer",
  				padding: "5 20 0 0"
		  	},		
		  	cls : 'uni-doc-header',	  
		  	height:32,
	        items: [
		        { 
		        	contentEl: "logo-content",
		        	padding: "8 20 0 10"
		        },  
		        {
		          flex: 1
		        },
		        {
		          id:'UNILITE_PG_TITLE',
		          cls: 'uni-pg-title',
		          padding: "8 00 0 00",
		          layout:'fit',
		          html:''
		        },	
		        {
		          flex: 1
		        },
		        	/*{
		          xtype: "searchcontainer",
		          id: "search-container",
		          width: 230,
		          margin: "4 0 0 0"
		        },*/
	        	{
		          xtype: "uniHeaderConfig",
		          padding: "8 10 0 0"
		        }, 
		        { 
		        	xtype:"uniActionContainer",
		        	contentEl: "config-module_postion",
		        	padding: "8 10 0 0",
		        	onClick:function() {
		        		changeModulePosition();
		        	}
		        },
		        { 
		        	xtype:"uniActionContainer",
		        	contentEl: "config-maximize",
		        	padding: "8 10 0 0",
		        	onClick:function() {
		        		windowMaximize();
		        	}
		        }
		        
		     ] // items	

		}; // panelNorth
		


		// desktop
		mainView = Ext.create('Ext.Viewport', {
			layout : {
				type:'border'
			},
			title : 'Unilite',
			defaults:{
				collapsible: false
			},
			//items : [panelNorth, panelModulesLeft, panelNavigation, contentTabPanel , panelSouth ],
			items : [panelNorth, panelNavigation, contentTabPanel , panelSouth ],
			renderTo : Ext.getBody()
		});

	});	// Ext.onReady();
	
	<%@include file="mainCommon.jsp" %>
		
</script>
<style>
iframe {
	border: 0px !important;
}
.search {
    background: url("./resources/images/main/search-box.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
    padding: 2px 0 0 25px;
}

</style>
</head>
<body id="ext-body">
	<div id="loading">
		<span class="title">Loading .....</span><span class="logo"></span>
	</div>
	<!-- use class="x-hide-display" to prevent a brief flicker of the content -->
	<div id="logo-content" class="x-hide-display"><a href="${pageContext.request.contextPath}/"><img src="<c:url value='/resources/images/main/g3erp_logo.gif' />"  /></a></div>
	<div id="config-content" class="x-hide-display"><img src="<c:url value='/resources/css/icons/component-s.png' />" /></div>
	<div id="config-module_postion" class="x-hide-display"><img src="<c:url value='/resources/css/icons/icon_module_position.png' />" /></div>
	<div id="config-maximize" class="x-hide-display"><img src="<c:url value='/resources/css/icons/icon_maximize.png' />" /></div>
	<div id="logOutDiv" class="x-hide-display"><a href="<c:url value='/login/actionLogout.do' />" target="_top" class="logout">Logout</a></div>


	<div id="center1" class="x-hide-display">
		Demo
	</div>
	
	
</body>
</html>
