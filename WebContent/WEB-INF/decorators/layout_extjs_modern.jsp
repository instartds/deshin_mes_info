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
<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "6.0.1");

	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);

	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"_modern/ext-modern-all-debug.js");
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"_modern/ext-modern-all.js");
    }

    request.setAttribute("css_url", "/extjs_"+extjsVersion+"_modern/resources/theme-all.css");
    request.setAttribute("ext_root", "/extjs_"+extjsVersion+"_modern");
    request.setAttribute("ext_version", extjsVersion);
    request.setAttribute("mainDomain",  ConfigUtil.getString("servers[@domain]", ""));


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

	<c:if test="${not empty mainDomain}">
		document.domain = '${mainDomain}';
	</c:if>
</script>
<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/omegaplus_modern_${ext_version}.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>


<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/AppManager.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/AbstractApp.js" />' ></script>


<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_root}/app/OmegaPlus/BaseApp.js" />' ></script>

<script type="text/javascript">

	var EXT_ROOT = '${ext_root}';
	var CPATH = '${CPATH }';
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${ext_root}/src',
            	"OmegaPlus": '${ext_root}/app/OmegaPlus'
        }
	});

	Ext.require('*');
	Ext.require('Ext.viewport.Viewport');
	Ext.require('OmegaPlus.AbstractApp');
	Ext.require('OmegaPlus.AppManager');


	Ext.require('OmegaPlus.BaseApp');
</script>

<c:choose>
<c:when test="${isDevelopServer }">


	<script type="text/javascript">
		var IS_DEVELOPE_SERVER = true;
	</script>
</c:when>
<c:otherwise>
<script type="text/javascript">
		var IS_DEVELOPE_SERVER = false;
</script>
</c:otherwise>
</c:choose>


<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
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
		     compCountry:	'KR',
		     refItem:		"${loginVO.refItem}",
		     customCode:	"${loginVO.customCode}",	//외부사용자용
		     customName:	"${loginVO.customName}",	//외부사용자용
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
	var pgmInfo = {
		authoUser: '<%="null".equals(request.getParameter("authoUser")) ? "":request.getParameter("authoUser") %>'
	}

	Ext.onReady(function() {
		//Ext.app.REMOTING_API.enableBuffer = 100;



		var chk = false;
		if(typeof appMain !== 'undefined')  {
		 	if( Ext.isFunction(appMain)) {
				chk = true;
			}
		}


		Ext.application ( {
			name : 'OmegaPlus',
			launch: function () {
				Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);


				var data1 =  <%@include file="mobileMenu1.json" %>;
				var data2 =  <%@include file="mobileMenu2.json" %>;

				var mainApp = Ext.create('OmegaPlus.BaseApp', {
            		appItems:[
            			{
							xtype: 'image',
							src: CPATH+'/resources/css/theme_01/module_14_over.png',
							//title: m.title+m.id,
							//imgCls:'mainModuleButton',
							width: 90,
							height: 115,
			                margin: '40 20 0 20',
							listeners: {
						      tap: function() {
										treeSystemMenuStore.treeLoadRecords(data1,"발주");
										Ext.Viewport.showMenu('left');
						      }
						    }
						},{
							xtype: 'image',
							src: CPATH+'/resources/css/theme_01/module_16_over.png',
							//title: m.title+m.id,
							//imgCls:'mainModuleButton',
							width: 90,
							height: 115,
			                margin: '40 20 0 20',
							listeners: {
						            tap: function() {
										treeSystemMenuStore.treeLoadRecords(data2,"입고");
										Ext.Viewport.showMenu('left');

						            }

						    }
						}
            		]
				});


				var treeSystemMenuStore = Ext.create('Ext.data.TreeStore',{
					storeId: 'treeSystemMenuStore',
			        autoLoad: false,
			        folderSort: true,
		        		root:{
			        		expanded: true,
			        		text: 'All'
		        	},
				      /*
			        proxy: {
			            type: 'direct',
			            api: {
			                read : 'mainMenuService.getMenuList'
			            }
			        },*/
			        treeLoadRecords:function(param, newTitle)	{
			        	var listNav = Ext.getCmp('listNavigation');
			        	var oldTitle = listNav.title;

			        	this.inLoading = true;
			        	//this.getProxy().setExtraParams(param)
			        	//this.load();
			        	this.setRootNode(param);

			        	var header = listNav.header,
			                placeholder = listNav.placeholder;

				        listNav.title = newTitle;

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

			        }
				});

				Ext.define('menuItemModel', {
					extend: 'Ext.app.ViewModel',
					alias: 'viewmodel.menuItemModel'
				    ,stores:{
		        		navItems:Ext.data.StoreManager.lookup('treeSystemMenuStore')
		        	}
				});


				 var menu = Ext.create('Ext.Menu', {
				 	floated : true,
				    header : true,
				    titleAlign:'center',
				    viewModel: {
					        type: 'menuItemModel'
					    },
					 scrollable: 'y',
				     items: [{
				        xtype: 'treelist',
				        id :'listNavigation',
				        width:200,
				        store:treeSystemMenuStore,
				        selectOnExpander:true,
				        singleExpand :true,
				        selected:true,
				        reference: 'treelist',
                		//bind: '{navItems}',
                        listeners:{
                        	itemclick :function( list , item , eOpts )	{
                        		var u = item.node.get("url");
                        		if(!Ext.isEmpty(u))	{
                					window.location.href = u;
                        		}
                			}
                        }
				     }]
				 });
				var mainApp=appMain();

				var main = Ext.create('Ext.Container', {
		            layout: 'hbox',
		            items: [mainApp]
	            })
				Ext.Viewport.add(main);
				 Ext.Viewport.setMenu(menu, {
				     side: 'left',
				     // omitting the reveal config defaults the animation to 'cover'
				     reveal: false
				 });

				treeSystemMenuStore.treeLoadRecords(data1,"발주");


        }
		} )


	});

</script>

</head>
<body id="ext-body">
<decorator:body />
</body>
</html>
