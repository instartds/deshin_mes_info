<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.unilite.com.constants.*" %>
<%@ page import="foren.framework.utils.*" %>
<%
//로컬 사용자 아이피 확인
String REMOTE_IP = request.getRemoteAddr();

%>
<%
	request.setAttribute("mainUrl", foren.unilite.com.constants.Unilite.getMainUrl());
	//String[] langs = {"ko","zh","en","ja"};
	String[] langs = (String[])request.getAttribute("SUPPORT_LANG");

	request.setAttribute("langs", langs);
	request.setAttribute("contexts",Unilite.getContextList());
%>
var currentModulePositionIsLeft = true;

<c:if test="${ext_version == '6.0.1'}">
if(EXTVERSION != '4.2.2' && EXTVERSION != '5.1.0')	{
    Ext.enableAriaButtons = false;
    Ext.enableAriaPanels = false;
}
</c:if>

function changeModulePosition() {
	var lModule = Ext.getCmp('panelModulesLeft');
	var tModule = Ext.getCmp('panelModulesTop');
	if(currentModulePositionIsLeft) {
		lModule.hide();
		tModule.show();
	} else {
		tModule.hide();
		lModule.show();

	}
	currentModulePositionIsLeft = ! currentModulePositionIsLeft;
}
function windowMaximize() {

	if (screenfull.enabled) {
	    screenfull.toggle(window.document.getElementById('ext-body'));//request();
	} else {
		Unilite.messageBox("현재 사용 하시는 브라우져는 Full Screen 모드를 자동으로 지원할수 없습니다. F11 키나 브라우져 메뉴 상에서 전체화면 기능을 이용해 주시기 바랍니다.");
	}
}
function windowAnysupport() {
	window.open("http://13.209.28.250/start/",'_blank');
}
function logSave() {


 	var today = new Date();

 	var year = today.getFullYear();
 	var month = ('0' + (today.getMonth() + 1)).slice(-2);
 	var day = ('0' + today.getDate()).slice(-2);
 	var hours = ('0' + today.getHours()).slice(-2);
 	var minutes = ('0' + today.getMinutes()).slice(-2);
 	var seconds = ('0' + today.getSeconds()).slice(-2);

 	var dateString, paramUserid ;

 	dateString = year + '-' + month  + '-' + day + ' '+hours + ':' + minutes  + ':' + seconds + '.000' ;

	paramUserid = "${loginVO.userID}";

 	var paramData = {
 		    'crtfcKey' : "$5$API$VUI5NgewCRf7zbB.nF4IkMtGVS5TW7qi52eG0IiWLN4",
 		    'logDt' : dateString,
 		    'useSe' : "종료",
 		    'sysUser' : paramUserid,
 		    'conectIp' : "<%=REMOTE_IP%>",
 		    'dataUsgqty' : "100"
 		};

 	$.ajax({
 	    type : "POST",
 	    url : "https://log.smart-factory.kr/apisvc/sendLogData.json",
 	    data : paramData,
 	    cache : false,
 	    dataType : "json",
 	    contentType : "application/x-www-form-urlencoded; charset=utf-8",
 	    success : function(data, textStatus, jqXHR) {
 	        var result = data.result;
 	      	//실행결과 출력

 	         //alert(result.recptnRsltCd);

 	    },
 	    error : function(jqXHR, textStatus, errorThrown) {
 	    alert("로그에러");
 	    },
 	    complete : function() {
 	    }
 	});




}
function updateStatus(message) {
	var sb = Ext.getCmp('UNILITE_PG_STATUS');
	if(typeof sb !== 'undefined') {
		message = message || {};
        if (Ext.isString(message)) {
            message = {text:message,
            	iconCls: 'x-status-custom'
            	/*,
            	clear: {
			        wait: 10000,
			        anim: false,
			        useDefaults: false
			    }
			    */};
        }
		sb.setStatus(message);
	}
};
/**
 * 하위 Tab에서 프로그램 타이틀 변경시 적용
 */
function updateProgramTitle(title) {
	var tabPanel = Ext.getCmp('contentTabPanel');
	if(tabPanel) {
		var activeTab = tabPanel.getActiveTab( );
		if(activeTab) {
			if( Ext.isEmpty(activeTab.tab.getText()))	{
				activeTab.tab.setText(title);
			}
			activeTab.fireEvent('changeheadertitle', UserInfo.appOption.showPgmId);
		}
	}
}

function openTab(rec, url, params) {
	UniAppManager.setAppParams(params);

	var tabPanel = Ext.getCmp('contentTabPanel');
	var prgID = '';
	var tabID = '';
	if (rec.data.prgID === "undefined") {
		prgID = 'undefined';
	} else {
		prgID = rec.data.prgID;
	}
	tabID = 'CTAB_' + prgID;
	var fullurl = CPATH + url ;
	if( (Ext.isFunction(rec.get) && !Ext.isEmpty(rec) && !Ext.isEmpty(rec.get("cpath"))))	{
		fullurl = rec.get("cpath") + url ;
	}
	if(typeof params !== 'undefined') {
		var i =0;
		Ext.Object.each(params, function(key, value) {
			if(i == 0) {
				fullurl = fullurl + "?";
			}
			if( i > 0) {
				fullurl = fullurl +"&";
			}
			fullurl = fullurl + key + "=" + value
			i ++;
			console.log(fullurl );
		});
	}
//			if(Unilite.isMobile()) {
//				window.open(fullurl,'_blank');
//				return true;
//			}

	var tabCheck = tabPanel.getChildByElement(tabID);
	console.log("PARAM : ", params);

	if( !tabCheck )  { // 기존 Tab이 없으면

		var programTitle = '';// rec.get('text'+CUR_LANG_SUFFIX);
		if(rec.get) {
			programTitle = rec.get('text'+CUR_LANG_SUFFIX);
		}
		//var url ='<iframe src="about:blank" id="iframeEl" data-ref="iframeEl" name="iframe-name" width="100%" height="100%" frameborder="0"></iframe>';
		//var tab = Ext.create('Ext.panel.Panel',{
		//var tab = Ext.create('Unilite.main.MainContentPanel',{
		var tab = {
		//var tab = Ext.create('Ext.ux.IFrame',{
			xtype: 'uniMainContent',       //Unilite.main.MainContentPanel
			src  : fullurl,

			title : programTitle, // +'('+ tabID+')',
			itemId: tabID,
			id: tabID,
			layout	: 'fit',
			buttons: Ext.MessageBox.YESNOCANCEL,
			uniOpt: {
				'prgID': prgID,
				'title': programTitle
			},
			listeners: {
                load:  function () {
                	this.up('tabpanel').body.unmask();
                },
                render: function () {
                    this.up('tabpanel').body.mask('Loading...');
                },
                error: function() {
                	this.up('tabpanel').body.unmask();
                	Unilite.messageBox( '<t:message code="system.message.common.main005" default="대상 프로그램을 열수 없습니다."/>');
                	this.up('tabpanel').remove(this);
                },
                changeheadertitle: function(checked) {
                	var me = this;
                	var oExt = me.getWin().Ext;
                	if(oExt)	{
						var tltleObj = oExt.getCmp('UNILITE_PG_TITLE');
						if(tltleObj) {
							var title = me.uniOpt.title + (checked ? " ("+me.uniOpt.prgID+")" : "");
							tltleObj.update(title);
						}
                	}
                }
                /* ,
                beforedestroy: function ( frame, eOpts ) {
                        console.log("beforedestroy");
    					// return '저장되지 않은 자료가 있습니다. 저장하지 않은채로 다른 페이지로 가시겠습니까?';
                       return true;
                }
                */
            }
		};
		tabPanel.add(tab).show();
	} else {
		// 기존 Tab이 있는 경우
		var activedTab = tabPanel.setActiveTab(tabID);
		if(activedTab instanceof Ext.ux.IFrame) {
			var body = activedTab.getWin();
			if(body && body.UniAppManager && body.UniAppManager.app) {
				if(params) {
					body.UniAppManager.app.fnInitBinding(params);
					console.log("fnInitBinding");
				}
			}

		}
	}

	if(UserInfo.appOption.collapseMenuOnOpen) {
		Ext.getCmp('panelNavigation').collapse();
	}else{
		Ext.getCmp('panelNavigation').expand();
	}

};

/********************************
 *
 * @type
 */

var aboutWin = null;
function saveUI(param)	{
	if(Ext.isDefined(Ext.app.REMOTING_API) && Ext.isDefined(Ext.app.REMOTING_API.actions.mainCommonService))	{
		mainCommonService.saveUserUI(param)
	}
}
var configMenus = [
	{
		text : '<t:message code="system.label.common.usersetup" default="사용자 설정"/>',
		//iconCls : 'icon-pinfo',
		menu: {
			plain: true,
			items: [
				{
					itemId: 'collapseMenuOnOpen',
			        xtype: 'menucheckitem',
			        text: '<t:message code="system.label.common.menupanelcollapse" default="메뉴패널 접기"/>',
			        checked: UserInfo.appOption.collapseMenuOnOpen,
			        listeners: {
			        	checkchange: function( menu, checked, eOpts )  {
			        		UserInfo.appOption.collapseMenuOnOpen = checked;
			        		if(checked) {
								Ext.getCmp('panelNavigation').collapse();
								saveUI({'HIDE_MENU_PANEL':'1'});
							}else{
								Ext.getCmp('panelNavigation').expand();
								saveUI({'HIDE_MENU_PANEL':'0'});
							}
			        	}
			        }
			    },{
					itemId: 'collapseLeftSearch',
			        xtype: 'menucheckitem',
			        text: '<t:message code="system.label.common.searchpanelcollapse" default="검색창 접기"/>',
			        checked: UserInfo.appOption.collapseLeftSearch,
			        listeners: {
			        	checkchange: function( menu, checked, eOpts )  {
							UserInfo.appOption.collapseLeftSearch = checked;
							var tab = Ext.getCmp('contentTabPanel').getActiveTab();
							if( tab && (tab instanceof Ext.ux.IFrame) ) {
								var uniSearchPanel = tab.getWin().UniAppManager.getApp().down('uniSearchPanel');
								if(uniSearchPanel) {
									checked ? uniSearchPanel.collapse() : uniSearchPanel.expand();
								}
							}
							if(checked) {
								saveUI({'HIDE_SEARCH_PANEL':'1'});
							}else {
								saveUI({'HIDE_SEARCH_PANEL':'0'});
							}
			        	}
			        }
			    },{
					itemId: 'showTitleWithPgmID',
			        xtype: 'menucheckitem',
			        text: '<t:message code="system.label.common.showrprogramid" default="프로그램 ID 보이기"/>',
			        checked: UserInfo.appOption.showPgmId,
			        listeners: {
			        	checkchange: function( menu, checked, eOpts )  {
			        		UserInfo.appOption.showPgmId = checked;
			        		var frame = Ext.getCmp('contentTabPanel').getActiveTab();
							frame.fireEvent('changeheadertitle', checked);
							if(checked) {
								saveUI({'SHOW_PGMID':'1'});
							}else {
								saveUI({'SHOW_PGMID':'0'});
							}
			        	}
			        }
			    },{ xtype:'container',
			    	layout:'vbox',
			    	items:[
			    		{
					        xtype: 'component',
					        margin :'5 5 5 0',
					        html: '▣&nbsp;&nbsp;<t:message code="system.label.common.downEnterKey" default="Enter Key 누른 후 이동 방향"/>'
			    		},{
							itemId: 'showTitleWithPgmID',
					        xtype: 'uniCombobox',
					        margin :'5 5 5 25',
					        store : Ext.create('Ext.data.Store', {
					        	fields:['value','text'],
					        	data : [
					        		{value:'R', text:'<t:message code="system.label.common.downEnterKeyRight" default="오른쪽"/>'},
					        		{value:'D', text:'<t:message code="system.label.common.downEnterKeyDown" default="아래쪽"/>'}
					        	]
					        }),
					        value:parent.UserInfo.appOption.downEnterKey ? parent.UserInfo.appOption.downEnterKey : 'R',
					        listeners: {
					        	change: function( combo, newValue, oldValue, eOpts )  {
					        		UserInfo.appOption.downEnterKey = newValue;
										saveUI({'DOWN_ENTER_KEY':newValue});
					        	}
					        }
					}]
				}

			]}
	}
	/*,{
		text : '<t:message code="system.label.common.languagesetup" default="언어 설정"/>',
		menu: {
			plain: true,
			items: [

			<c:forEach var="lang" items="${langs}" varStatus="status">
				{text:'<t:message code="language.${lang}"/>', handler: function(){uniChangeLang('${lang}');}}
				<c:if test="${!status.last}">,</c:if>

			</c:forEach>

				{text:'한국어', handler: function(){uniChangeLang('ko');}},
				{text:'Chinese(中文)', handler: function(){uniChangeLang('zh');}},
				{text:'English', handler: function(){uniChangeLang('en');}},
				{text:'Japaness', handler: function(){uniChangeLang('ja');}}
			]}
	}
	<c:if test="${contexts.size() gt 1}">
	,{
		text : '<t:message code="system.label.common.databasesetup" default="데이터베이스 설정"/>',
		menu: {
			plain: true,
			items: [
			<c:set var="currentContext"><%=request.getContextPath()%></c:set>
			<c:forEach var="c" items="${contexts}" varStatus="status">
				{text:'${c.name}', handler: function(){uniChangeContext('${c.path}');}}
				<c:if test="${!status.last}">
				,
				</c:if>
			</c:forEach>
			]}
	}
	</c:if>*/
	,{
		itemId: 'openPassword',
        text: '<t:message code="system.label.base.pwchange" default="비밀번호변경"/>',
        handler: function()  {
        		openChangePassword("false");
        }
    }
	/*,{
		text : 'DeltaMES 정보',
		handler : function(widget, event) {

			var param = {};
			tlabMenuService.getSystemInfo(param, function(provider, response) {
				if(Ext.isEmpty(aboutWin)) {
					aboutWin = Ext.create('Ext.window.Window', {
					    title: 'DeltaMES 정보',
					    width: 400,
					    layout: 'fit',
					    items: [
					    	Unilite.createForm('',{
							    layout : {type : 'uniTable', columns : 1},
							    disabled:false,
							    buttonAlign :'center',
							    fbar: [
								        {  xtype: 'button', text: '닫기' ,
								        	handler:function()	{
								        		aboutWin.hide();
								        	}
								        }
									   ],
								defaults: {
							        width: 350
							    },
							    items: [
								    {	xtype: 'container',
									    cls: 'uni-doc-header',
									    layout: {
									        type: 'hbox',
									        align: 'stretch'
									    },
									    defaults: {
							                padding: 10,
							                style: {'vertical-align': 'middle'}
							            },
							            width: 375,
							            height: 44,
									    items: [{
									    	xtype:'uniImg',
							                src:CPATH+'/resources/css/theme_01/logo.png',
							                width: 178,
							                height: 24
							            }]
								    },
							    	{ fieldLabel: '시스템 ID', 		value: response.result.SystemId,	readOnly: true},
									{ xtype: 'textareafield', 	fieldLabel: '라이센스 키', 		value: response.result.LicenseKey,	readOnly: true },
									{ xtype: 'displayfield', 	fieldLabel: '라이센스 버전', 		value: response.result.LicenseVersion 	},
									{ xtype: 'displayfield', 	fieldLabel: '시스템 버전', 		value: response.result.SystemVersion 	}
								]
							})
					    ]
					}).show();
				}else{
					aboutWin.show();
				}
			});
		}
	}*/];
var chgCompCode = [{
	xtype:'container',
	layout:'vbox',
	items:[{
        xtype: 'component',
        margin :'5 5 5 0',
        html: '▣&nbsp;&nbsp;<t:message code="system.label.common.companychange" default="법인변경"/>'
	},{
    	xtype:'uniCombobox',
    	hideLabel:true,
    	name:'CH_COMP_CODE',
        store:Ext.create('Ext.data.Store',{
        	storeId: 'compList',
        	fields:[{name:'value', type:'string'},{name:'text', type:'string'},{name:'search', type:'string'}],
        	data:[]
        }),
        listeners: {
        	change: function( field, newValue, oldValue )  {
        		uniChangeCompCode(newValue);
        	}
        }
    }]
}]
/*
{
	text:'<t:message code="system.label.common.companychange" default="법인변경"/>',
	menu:[{
		xtype:'container',
		items:[{
        	xtype:'uniCombobox',
        	hideLabel:true,
        	name:'CH_COMP_CODE',
	        store:Ext.create('Ext.data.Store',{
	        	storeId: 'compList',
	        	fields:[{name:'value', type:'string'},{name:'text', type:'string'},{name:'search', type:'string'}],
	        	data:[]
	        }),
	        listeners: {
	        	change: function( field, newValue, oldValue )  {
	        		uniChangeCompCode(newValue);
	        	}
	        }
	    }]
	}]
}
*/



function uniChangeContext(url) {
	window.open(url,'_blank');
}

function uniChangeLang(lang) {
	console.log("new lang : ", lang);
	if(confirm('<t:message code="system.message.common.main002" default="언어 변경을 선택 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. 계속 진행하시겠습니까?"/>')) {
		document.location = CPATH+"${mainUrl }?TlabSiteLanguage="+lang;
	}
}

function uniChangeContext(contextPath) {
	console.log("new contextPath : ", contextPath);
	if(confirm('<t:message code="system.message.common.main003" default="데이터베이스 변경을 선택 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. 계속 진행하시겠습니까?"/>')) {
		document.location = contextPath+"/${mainUrl }";
	}
}

function uniChangeCompCode(compCode) {
	console.log("new compCode : ", compCode);
	if(confirm('<t:message code="system.message.common.main004" default="법인을 변경 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. 계속 진행하시겠습니까?"/>')) {
		document.location = CPATH+"/login/changeComp.do?CH_COMP_CODE="+compCode;
	}
}

function uniSaveGridState() {
	var oWin = getCurTabWin();
	if(oWin != null && typeof oWin !== 'undefined') {
		oWin.UniAppManager.saveGridState();
	}
}

function uniRestoreStete() {
	var oWin = getCurTabWin();
	if(oWin != null && typeof oWin !== 'undefined') {
		oWin.UniAppManager.resetGridState();
	}
}

function getCurTabWin() {
	var tabPanel = Ext.getCmp('contentTabPanel');
	var tab =  tabPanel.getActiveTab( );
	var oWin = null;
	if(tab != null && typeof tab.getWin !== 'undefined') {
		oWin = tab.getWin();
	}
	return oWin
}

Ext.define("Unilite.com.view.UniHeaderConfig", {
	extend : "Unilite.com.view.UniTransparentContainer",
	alias : "widget.uniHeaderConfig",
    html: '<img src="'+CPATH+'/resources/css/theme_01/setting.png" title="<t:message code="system.label.common.settings" default="Settings"/>" />',
	//contentEl : "config-content",

	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";
		this.menu = Ext.create("Ext.menu.Menu", {
					plain : true,
					renderTo : Ext.getBody(),// Ext.getCmp('icon-config'),
					items : configMenus,
					listeners: {
						mouseleave: function( menu, e, eOpts ) {
							menu.hide();
						}
					}
				});

		this.callParent()
	},
	listeners : {
		afterrender : function(b) {
			if (this.menu) {
				b.el.addListener("click", function(d, a) {
							this.menu.showBy(this.el);
							//this.menu.showBy(this.el, "bl", [0, 0]);
						}, this)
			}
		}
	}
});

Ext.define("Unilite.com.view.UniCompCodeConfig", {
	extend : "Unilite.com.view.UniTransparentContainer",
	alias : "widget.uniCompCodeConfig",
    html: '<img src="'+CPATH+'/resources/css/icons/chCompIcon.png" title="<t:message code="system.label.common.companychange" default="법인변경"/>" />',
	//contentEl : "config-content",

	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";

		this.menu = Ext.create("Ext.menu.Menu", {
					plain : true,
					renderTo : Ext.getBody(),// Ext.getCmp('icon-config'),
					items : chgCompCode
//					listeners: {
//						mouseleave: function( menu, e, eOpts ) {
//							menu.hide();
//						}
//					}
				});


		this.callParent()
	},
	listeners : {
		afterrender : function(b) {
			if (this.menu) {
				b.el.addListener("click", function(d, a) {
							this.menu.showBy(this.el);
							//this.menu.showBy(this.el, "bl", [0, 0]);
						}, this)
			}
		}
	}
});

Ext.override(Ext.view.BoundList, {
	createPagingToolbar: function() {
        return Ext.widget('pagingtoolbar', {
            id: this.id + '-paging-toolbar',
            pageSize: this.pageSize,
            store: this.dataSource,
            border: false,
            ownerCt: this,
            beforePageText: '',
            ownerLayout: this.getComponentLayout()
        });
    }
});
Ext.define("Docs.view.search.Container", {
	extend: "Ext.container.Container",
	alias: "widget.searchcontainer",
	initComponent: function() {
    	var searchStore  = Ext.create('Ext.data.Store',{
            fields: [
	            {name:'PGM_NAME', type:'string'},
	            {name: 'url', type:'string'},
	            {name: 'authoUser', type:'string'}
            ],
            storeId: 'SearchMenuStore',
            autoLoad: false,
            pageSize: 15,
            proxy: {
                type: 'direct',
                api: {
                    read : 'mainMenuService.searchMenu'
                },
	            reader: {
	                type: 'json',
			<c:choose>
	        	<c:when test="${ext_version == '4.2.2'}">
	        		root: 'records'	//4.2.2
	        	</c:when>
	        	<c:otherwise>
	        		rootProperty: 'records'	//5.1.0
	        	</c:otherwise>
	        </c:choose>
	            }
            }
        });
		this.cls = "search";
		this.items = [{
	        xtype: "combobox",
        	<c:if test="${ext_version == '4.2.2'}">
        		plugins: ['uniClearbutton'],	//4.2.2. 5.x은 clear trigger 가 plugin 이 아님.제거.
        	</c:if>
	        store: searchStore,
	        queryMode: 'remote',
	        pageSize: true, // This just causes a paging toolbar to show
	        //emptyText: "Search",
	        displayField: 'PGM_NAME',
	        minChars: 2,
	        //forceSelection: true,
	        queryParam: 'searchStr',
	        hideTrigger: true,
	        //enableKeyEvents: true,
	        selectOnFocus: false,
	        width: 180,
	        border: 0,
	        padding: '0 0 0 0',
	        margin: '0 0 0 0',
//	        triggers: {				//5.0 clear trigger
//				clear: {
//					type: 'clear',
//					hideWhenMouseOut: true,
//					hideWhenEmpty: true
//				}
//			},
	        listeners: {
	            select: function( combo, records, eOpts ) {
	                if(records && records.length > 0 ) {
	                  console.log('select : ', records[0].data);
	                  /*if(Ext.isArray(records))	{
	                  	openTab(records[0], records[0].get('url')) ;
	                  }else {
	                  	openTab(records, records.get('url'),{'authoUser':(records.get("authoUser")=="null" ? '':records.get("authoUser"))}) ;
	                  }*/
	                }
	            },
	            beforeselect:function( combo, record, index, eOpts )	{
	            	if(record) {
	            		openTab(record, record.get('url'),{'authoUser':(record.get("authoUser")=="null" ? '':record.get("authoUser"))}) ;
	            	}
	            }
	            // Firefox Korean 처리 필요
	            ,beforequery: function( queryPlan, eOpts )	{
	            	//queryPlan.query = Ext.Object.toQueryString({"searchStr":queryPlan.query});
	            }
	        }
		}];

		this.callParent()
	}
});

/**
  * 비밀번호 변경 팝업
  * @sIsAutoPopup  자동팝업 열림 여부(비밀번호 변경기간) , default는 "true"
*/
	function openChangePassword(sIsAutoPopup) {
		if(Ext.isEmpty(sIsAutoPopup))	{
			sIsAutoPopup = "true";
		}
		var fn = function() {
		//20210427 수정: 내/외부 사용자 구분하기 위해 추가
			if("${loginVO.refItem}" == 'E') {
				var oWin = Ext.create('Unilite.app.popup.changePassword2', {
					width	: 800,
					height	: sIsAutoPopup == "true" ? 600 : 530,
					title	: '<t:message code="system.label.common.pwchange" default="비밀번호 변경"/>',
					extParam : {
						'isAutoPopup' : sIsAutoPopup
					}
				});
			} else {
				var oWin = Ext.create('Unilite.app.popup.changePassword', {
					width	: 800,
					height	: sIsAutoPopup == "true" ? 600 : 530,
					title	: '<t:message code="system.label.common.pwchange" default="비밀번호 변경"/>',
					extParam : {
						'isAutoPopup' : sIsAutoPopup
					}
				});
			}
			oWin.fnInitBinding();
			oWin.center();
			// animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
			oWin.show();
			//팝업에서 팝업 띄울 경우, 뒤에 나오는 팝업이 위로 나오게 하기 위해서...
			//그런데 팝업에서 윈도우 띄우면 윈도우가 뒤로 숨는 경우 발생 -> 주석처리
			oWin.setAlwaysOnTop(true);
		}
		//20210427 수정: 내/외부 사용자 구분하기 위해 추가
		if("${loginVO.refItem}" == 'E') {
			Unilite.require('Unilite.app.popup.changePassword2', fn, null,	true );
		} else {
			Unilite.require('Unilite.app.popup.changePassword', fn, null,	true );
		}
//		Ext.require(me.app, fn);
	}
	var pwChgDay = "${loginVO.pwChgDay}";
	if(pwChgDay && parseInt(pwChgDay)<= 0 ) {
		openChangePassword("true");
	}


var alertWin;
function openAlert()	{
		 var fn = function() {
            alertWin = Ext.create('Unilite.app.popup.showAlertMsgPopup', {
                        width: 800,
                        height: 600,
                        title:'<t:message code="system.label.common.alertMessage" default="알림메세지"/>'
            });

            alertWin.fnInitBinding();
            alertWin.center();
            // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
            alertWin.show();
            //팝업에서 팝업 띄울 경우, 뒤에 나오는 팝업이 위로 나오게 하기 위해서...
            //그런데 팝업에서 윈도우 띄우면 윈도우가 뒤로 숨는 경우 발생 -> 주석처리
            alertWin.setAlwaysOnTop(true);
		 }
         Unilite.require('Unilite.app.popup.showAlertMsgPopup', fn, null,	true );
         if(alertWin){
		    alertWin.fnInitBinding();
		    alertWin.center();
		    // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
		    alertWin.show();
		    //팝업에서 팝업 띄울 경우, 뒤에 나오는 팝업이 위로 나오게 하기 위해서...
		    //그런데 팝업에서 윈도우 띄우면 윈도우가 뒤로 숨는 경우 발생 -> 주석처리
		    alertWin.setAlwaysOnTop(true);
         }
}

function getAlertCount()	{
	var store = Ext.StoreManager.lookup("mainBadgeStore");
    store.load();
}
//function show

(function (global) {

	if(typeof (global) === "undefined")
	{
		throw new Error("window is undefined");
	}

    var _hash = "!";
    var noBackPlease = function () {
        global.location.href += "#";

		// making sure we have the fruit available for juice....
		// 50 milliseconds for just once do not cost much (^__^)
        global.setTimeout(function () {
            global.location.href += "!";
        }, 50);
    };

	// Earlier we had setInerval here....
    global.onhashchange = function () {
        if (global.location.hash !== _hash) {
            global.location.hash = _hash;
        }
    };

    global.onload = function () {

		noBackPlease();

		// disables backspace on page except on input fields and textarea..
		document.body.onkeydown = function (e) {


            var elm = e.target.nodeName.toLowerCase();
            if (e.which === 8 && (elm !== 'input' && elm  !== 'textarea')) {
                e.preventDefault();
                e.stopPropagation();
                return
            }
            // stopping event bubbling up the DOM tree..
            if(!onKeydownHandlerOverrides(e))	{
            	return false;
            } else {
            	e.stopPropagation();
            }
        };

    };

    function onKeydownHandlerOverrides(event) {

	    switch (event.keyCode) {
	         case 121 : // 'F10'
	         	var tabPanel = Ext.getCmp('contentTabPanel');
				var activeTab = tabPanel.getActiveTab();
				var tab = activeTab.tab;
	            if(Ext.isIE)	{
	            	event.returnValue = false;
	            	event.keyCode = 0;
	            	if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
	                if(tabPanel) {
						if(tab && tab.closable) {
							var canClose = activeTab.onClose(activeTab);
							if(canClose)  {
								tabPanel.remove(activeTab);
							}
						}
					}
	                return false;
	        	} else {
	        		if (event.preventDefault)
	                {
	                    event.preventDefault();
	                    event.stopPropagation();
	                }
					if(tabPanel) {
						if(tab && tab.closable) {
							var canClose = activeTab.onClose(activeTab);
							if(canClose)  {
								tabPanel.remove(activeTab);
							}
						}
					}
				}
	            break;
	          default:
	          	return true;
	        	break;
	    }
	}
})(window);