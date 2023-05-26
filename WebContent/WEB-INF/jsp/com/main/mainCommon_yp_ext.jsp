<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.unilite.com.constants.*" %>
<%@ page import="foren.framework.utils.*" %>
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
		if(activeTab /* && activeTab.itemId == prgID */) {
			//Ext.getCmp('panelNorth').down('uniHeaderConfig').menu.down('#showTitleWithPgmID').checked
			activeTab.fireEvent('changeheadertitle', UserInfo.appOption.showPgmId);
			activeTab.tab.setText(title);
		}
	}
}

function iniOpenTab(fullurl) {
        var tabPanel = Ext.getCmp('contentTabPanel');
        var programTitle = 'WEB-MAIN';// rec.get('text'+CUR_LANG_SUFFIX);
        var tab = {
            xtype: 'uniMainContent',       //Unilite.main.MainContentPanel
            src  : fullurl,

            title : programTitle, // +'('+ tabID+')',
            id: 'CTAB_w_bsa000skrv_yp',
            itemId: 'CTAB_w_bsa000skrv_yp',
            layout  : 'fit',
            buttons: Ext.MessageBox.YESNOCANCEL,
            uniOpt: {
                'prgID': 'w_bsa000skrv_yp',
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
                    Unilite.messageBox( '대상 프로그램을 열수 없습니다. ');
                    this.up('tabpanel').remove(this);
                }/*,
                changeheadertitle: function(checked) {
                    var me = this;
                    var oExt = me.getWin().Ext;
                    if(oExt)    {
                        var tltleObj = oExt.getCmp('UNILITE_PG_TITLE');
                        if(tltleObj) {
                            var title = me.uniOpt.title + (checked ? " ("+me.uniOpt.prgID+")" : "");
                            tltleObj.update(title);
                        }
                    }
                }*/
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

    if(UserInfo.appOption.collapseMenuOnOpen) {
//      Ext.getCmp('panelNavigation').collapse();
    }else{
        Ext.getCmp('panelNavigation').expand();
    }

};

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
                	Unilite.messageBox( '대상 프로그램을 열수 없습니다. ');
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
//		Ext.getCmp('panelNavigation').collapse();
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
		text : '사용자 설정',
		//iconCls : 'icon-pinfo',
		menu: {
			plain: true,
			items: [
				{
					itemId: 'collapseMenuOnOpen',
			        xtype: 'menucheckitem',
			        text: '좌측 메뉴 접기',
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
			        text: '좌측 검색창 접기',
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
			        text: '프로그램 ID 보이기',
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
			    }

			]}
	},{
		text : '언어설정',
		menu: {
			plain: true,
			items: [

			<c:forEach var="lang" items="${langs}" varStatus="status">
				{text:'<t:message code="language.${lang}"/>', handler: function(){uniChangeLang('${lang}');}}
				<c:if test="${!status.last}">,</c:if>

			</c:forEach>
			/*
				{text:'한국어', handler: function(){uniChangeLang('ko');}},
				{text:'Chinese(中文)', handler: function(){uniChangeLang('zh');}},
				{text:'English', handler: function(){uniChangeLang('en');}},
				{text:'Japaness', handler: function(){uniChangeLang('ja');}}*/
			]}
	}
	<c:if test="${contexts.size() gt 1}">
	,{
		text : '데이타베이스 설정',
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
	</c:if>
	,{
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
	}];
var chgCompCode = [{
	text:'법인변경',
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
}]
function uniChangeContext(url) {
	window.open(url,'_blank');
}

function uniChangeLang(lang) {
	console.log("new lang : ", lang);
	if(confirm("언어 변경을 선택 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. \n계속 진행하시겠습니까?")) {
		document.location = CPATH+"/${mainUrl }?TlabSiteLanguage="+lang;
	}
}

function uniChangeContext(contextPath) {
	console.log("new contextPath : ", contextPath);
	if(confirm("데이터베이스 변경을 선택 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. \n계속 진행하시겠습니까?")) {
		document.location = contextPath+"/${mainUrl }";
	}
}

function uniChangeCompCode(compCode) {
	console.log("new compCode : ", compCode);
	if(confirm("법인을 변경 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. \n계속 진행하시겠습니까?")) {
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
    html: '<img src="'+CPATH+'/resources/css/theme_01/setting.png" title="Setting" />',
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
    html: '<img src="'+CPATH+'/resources/css/icons/chCompIcon.png" title="Company" />',
	//contentEl : "config-content",

	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";
		this.menu = Ext.create("Ext.menu.Menu", {
					plain : true,
					renderTo : Ext.getBody(),// Ext.getCmp('icon-config'),
					items : chgCompCode,
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
	        }
		}];

		this.callParent()
	}
});
function openChangePassword()	{
		 var fn = function() {
            var oWin = Ext.create('Unilite.app.popup.changePassword', {
                        width: 800,
                        height: 665,
                        title:'비밀번호 변경'
            });

            oWin.fnInitBinding();
            oWin.center();
            // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
            oWin.show();
            //팝업에서 팝업 띄울 경우, 뒤에 나오는 팝업이 위로 나오게 하기 위해서...
            //그런데 팝업에서 윈도우 띄우면 윈도우가 뒤로 숨는 경우 발생 -> 주석처리
            oWin.setAlwaysOnTop(true);
		 }
         Unilite.require('Unilite.app.popup.changePassword', fn, null,	true );
//            Ext.require(me.app, fn);

}
var pwChgDay = "${loginVO.pwChgDay}";
if(pwChgDay && parseInt(pwChgDay)<= 0 ) {
	openChangePassword();
}