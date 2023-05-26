<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=8" /><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=1024" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Unilite</title>

<link rel="stylesheet" type="text/css" href='<c:url value="/extjs/resources/ext-theme-unilite/ext-theme-unilite-all-new.css" />' />
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite.css" />' />
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/ext-all.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/IFrame.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/Unilite.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-ko.js" />'></script>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/view/UniHeader.js" />' ></script>
<script type="text/javascript">
	var CPATH = '${CPATH}';

	Ext.onReady(function() {
		Ext.Loader.setConfig({
			enabled : true,
			paths : {
				"Ext" : '${CPATH }/app/Ext',
				"Unilite" : '${CPATH }/app/Unilite',
				"Extensible" : '${CPATH }/app/Extensible'
			}
		});
		Ext.require([ 'Ext.ux.IFrame',
	    'Ext.ux.statusbar.StatusBar',
	    'Ext.ux.statusbar.ValidationStatus' ]);


		Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));




		var treeStore = Ext.create('Ext.data.TreeStore', {
			root : {
				expanded : true,
				children : [ {
					text : "시스템",
					children : [ {
						text : "운영자공통코드등록",
						url : '/base/bsa100ukrv.do',
						prgID : 'bsa100ukrv',
						leaf : true
					}, {
						text : "(X)사용자 등록",
						prgID : 'cms100ukrv',
						leaf : true
					}, {
						text : "(X)영업조직 등록",
						leaf : true
					} ]
				}, {
					text : "고객관리 자료 등록",
					children : [ {
						text : "고객카드 관리",
						url : '/crm/cmb100ukrv.do',
						prgID : 'cmb100ukrv',
						leaf : true
					}, {
						text : "영업기회 관리",
						url : '/crm/cmb200ukrv.do',
						prgID : 'cmb200ukrv',
						leaf : true
					}, {
						text : "일일 영업활동 등록",
						url : '/crm/cmd100ukrv.do',
						prgID : 'cmd100ukrv',
						leaf : true
					}, {
						text : "(X)통합 파일등록/검색",
						leaf : true
					} ]
				}, {
					text : "고객관리 정보 조회",
					expanded : true,
					children : [ {
						text : "영업 현황 달력",
						url : '/app/calendar.jsp',
						prgID : 'cmdc100ukrv',
						leaf : true
					}, {
						text : "영업기회 진행 종합",
						url : '/crm/cmb200skrv.do',
						prgID : 'cmb200skrv',
						leaf : true
					}, {
						text : "영업기회 건별 세부 현황",
						url : '/crm/cmb210skrv.do',
						prgID : 'cmb210skrv',
						leaf : true
					} ]
				}, {
					text : "인사관리",
					expanded : false,
					children : [ {
						text : "(X)인사추가자료조회",
						url : '/human/hum210skr.do',
						prgID : 'hum210skr',
						leaf : true
					}, {
						text : "인사변동조회",
						url : '/human/hum220skr.do',
						prgID : 'hum220skr',
						leaf : true
					}, {
						text : "고과사항조회",
						url : '/human/hum240skr.do',
						prgID : 'hum240skr',
						leaf : true
					}, {
						text : "기간별인원현황조회",
						url : '/human/hum250skr.do',
						prgID : 'hum250skr',
						leaf : true
					}, {
						text : "(X)결혼생일자명단조회",
						url : '/human/hum270skr.do',
						prgID : 'hum270skr',
						leaf : true
					} , {
						text : "연간입퇴사자현황조회",
						url : '/human/hum280skr.do',
						prgID : 'hum280skr',
						leaf : true
					} , {
						text : "(V)사원조회",
						url : '/human/hum920skr.do',
						prgID : 'hum920skr',
						leaf : true
					} ]
				} ]
			}
		});

		var panelContent = new Ext.TabPanel({
			region : 'center',
			id : 'panelContent',
			margins : '1 1 5 1',
			//xtype : 'tabpanel',
			activeTab : 1,
			tabPosition : 'bottom',
			plain : true,
			defaults: {
				closable : true,
				autoScroll : true,
				border : 0
			},
			items : [ {
				contentEl : "center1",
				title : 'Best ERP',
				closable : false
			} ],
			listeners: {
//            	tabchange: function( tabPanel, tab ) {
//                	window.location.hash = '#'+ tab.itemId;
//                	console.log(window.location.hash);
//            	}
			}
		});



		var leftSystemMenuB = Ext.create('Ext.tree.Panel', {
			title : '시스템',
			width : 200,
			height : 150,
			store : treeStore,
			rootVisible : false,
			listeners : {
				itemclick : function(view, rec, item, index, eventObj) {
					if (rec.isLeaf()) {
						var url = rec.raw.url;
						if (typeof url !== "undefined") {
							openTab(rec, url);
						} else {
							alert("해당 프로그램이 등록 되지 않았습니다.");
						}
					} else if (rec.isExpanded()) {
						rec.collapse();
					} else {
						rec.expand();
					}
				}
			}
		});

		var panelSystem = {
			region : 'west',
			xtype:'container',
			width : 61,
			contentEl : 'elSystem',
			collapsible : false
			//,overflowY:'auto'
		};

		var panelNavigation = {
			collapsible : true,
			region : 'west',
			title : '고객관리',
			id : 'panelNavigation',
			width : 200,
			minWidth : 175,
			maxWidth : 300,
			split : true,
			margins : '0 0 5 0',
			xtype : 'tabpanel',
			plain : true,
			tabPosition : 'bottom',
			collapseMode: 'mini',
			items : [ leftSystemMenuB,  {
				title : '프로세스',
				html : '<p>Some settings in here.</p>'
			}, {
				title : '나의메뉴',
				html : '<p>Some info in here.</p>'

			} ]
		};
		var panelSouth = {
			collapsible : false,
			region : 'south',
			items : [Ext.create('Ext.ux.statusbar.StatusBar',{
		        dock: 'bottom',
		        border:0,
		        id: 'form-statusbar',
		        defaultText: 'Ready'
		    })]
		}



		var panelNorth = {
			id : 'panelNorth',
			region : 'north',
			contentEl : 'header-content',
			xtype: 'uniHeader',
			cls : 'uni-doc-header',
			height : 32

		};
		Ext.create('Ext.Viewport', {
			layout : 'border',
			title : 'G3ERP Layout01',
			defaults:{border:1},
			items : [panelNorth, panelSystem, panelNavigation, panelContent, panelSouth],
			renderTo : Ext.getBody()
		});

	});

	function openTab(rec, url, params) {

		}
</script>
<style>
iframe {
	border: 0px
}

a {
	margin: 5;
	text-decoration: none !important
}
</style>
</head>
<body id="ext-body">
	<div id="loading">
		<span class="title">Loading .....</span><span class="logo"></span>
	</div>
	<!-- use class="x-hide-display" to prevent a brief flicker of the content -->
	<div id="header-content" class="x-hide-display">
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr  >
					<td height="32" valign="middle" >
						<img src="<c:url value='resources/images/main/g3erp_logo.gif' />" style="vertical-align: middle; margin: 0 0 0 20 !important" />
					</td>
					<td  width="10" valign="middle"><div id="icon-config"><img src="<c:url value='resources/css/icons/component-s.png' />" /></div></td>
					<td width="*" align="right">설정 : [] / 법인 :    / ${loginVO.compName } / ${loginVO.userName }(${loginVO.userID }) &nbsp;&nbsp;&nbsp;&nbsp; <a
						href="<c:url value='/login/actionLogout.do' />" target="_top">Logout</a>
					</td>
					<td width="10"></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div id="center2" class="x-hide-display"></div>
	<div id="center1" class="x-hide-display">
</div>
	<div id="props-panel" class="x-hide-display" style="width: 200px; height: 200px; overflow: hidden;"></div>


	<div id="elSystem" class="x-hide-display">
		<img src="resources/images/main/sys_01.png" title="기준" onclick="" /><br />
		<img src="resources/images/main/sys_02.png" title="인사" onclick="" /><br />
		<img src="resources/images/main/sys_03.png" title="회계" onclick="" /><br />
		<img src="resources/images/main/sys_04.png" title="영업" onclick="" /><br />
		<img src="resources/images/main/sys_05.png" title="생산" onclick="" /><br />
		<img src="resources/images/main/sys_06.png" title="자재" onclick="" /><br />
		<img src="resources/images/main/sys_07.png" title="재고" onclick="" /><br />
		<img src="resources/images/main/sys_08.png" title="무역" onclick="" /><br />
		<img src="resources/images/main/sys_09.png" title="원가" onclick="" /><br />
		<img src="resources/images/main/sys_10.png" title="고객관리" onclick="" /><br />
	</div>


</body>
</html>
