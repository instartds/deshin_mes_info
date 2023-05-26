<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	request.setAttribute("mainUrl", foren.unilite.com.constants.Unilite.getMainUrl());
%>
var currentModulePositionIsLeft = true;


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
		    screenfull.toggle();//request();
		} else {
			alert("현재 사용 하시는 브라우져는 Full Screen 모드를 자동으로 지원할수 없습니다. F11 키나 브라유젼 메뉴 상에서 전체화면 기능을 이용해 주시기 바랍니다.");
		}
	}

	function openTab(rec, url, params) {
			var tabPanel = Ext.getCmp('contentTabPanel');
			var prgID = '';
			var tabID = '';
			if (rec.raw.prgID === "undefined") {
				prgID = 'undefined';
			} else {
				prgID = rec.raw.prgID;
			}
			tabID = 'CTAB_' + prgID;
			var fullurl = CPATH + url ;
			if(typeof params !== 'undefined') {
				var i =0;
				Ext.Object.each(params, function(key, value) {
					if(i == 0) {
						fullurl = fullurl + "?";
					}
					if( i> 1) {
						fullurl = fullurl +"&";
					}
					fullurl = fullurl + key + "=" + value
					i ++;
					console.log(fullurl );
				});
			}
			if(Unilite.isMobile()) {
				window.open(fullurl,'_blank');
				return true;
			}

			var tabCheck = tabPanel.getChildByElement(tabID);
			console.log("PARAM : ", params);
			// 강제로 tab reload 하게 함.
			// 파라미터 타고온 화면이 기존에 열려 있을 경우 데이타 로드 하게 해야함

//			if(tabCheck) {
//				tabPanel.remove(tabID);
//				tabCheck = false;
//			}
			if( !tabCheck )  {
				// 기존 Tab이 없으면
				//updateTitle(rec.raw.text);
				var programTitle = '';// rec.get('text'+CUR_LANG_SUFFIX);
				if(rec.get) {
					programTitle = rec.get('text'+CUR_LANG_SUFFIX);

				}
				updateTitle(programTitle, tabID);
				tab = {
					title : programTitle, // +'('+ tabID+')',
					itemId: tabID,
					id:tabID,
	    			layout	: 'fit',
					/*	2014.09.15 uxifram 에서 uniMainContent 로 변경 ( 화면 닫기시  onClose 사용 때문에)
					xtype: 'uxiframe'
					,src  : fullurl

					,listeners: {
		                load: {
		                    fn: function () {
		                        this.up('panel').body.unmask();
		                    }
		                },
		                render: function () {
		                    this.up('panel').body.mask('Loading...');
		                }
		            }*/
	    			xtype: 'uniMainContent',       //Unilite.main.MainContentPanel
					src  : fullurl,
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
		                        alert( '대상 프로그램을 열수 없습니다. ');
		                        this.up('tabpanel').remove(this);
		                }
		                /* ,
		                beforedestroy: function ( frame, eOpts ) {
		                        console.log("beforedestroy");
		    					// return '저장되지 않은 자료가 있습니다. 저장하지 않은채로 다른 페이지로 가시겠습니까?';
		                       return true;
		                }
		                */
		            }
				}
				tabPanel.add(tab).show();
			} else {
				// 기존 Tab이 있는 경우
				var activedTab = tabPanel.setActiveTab(tabID);
				if(activedTab instanceof Ext.ux.IFrame) {
					var body = activedTab.getWin();
					if(body && body.UniAppManager && body.UniAppManager.app) {
						body.UniAppManager.app.fnInitBinding(params);
						console.log("iTab");
					}

				}
			}


		};

		function updateTitle(title) {
			var obj = Ext.getCmp('UNILITE_PG_TITLE');
			if(typeof obj !== 'undefined') {
				obj.update( title );
			}
		};

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
			updateTitle(title);

			var tabPanel = Ext.getCmp('contentTabPanel');
			if(tabPanel) {
				var activeTab = tabPanel.getActiveTab( );
				if(activeTab /* && activeTab.itemId == prgID */) {
					activeTab.tab.setText(title);
					console.log("t");
				}
			}
		}



/********************************
 *
 * @type
 */


var configMenus = [{
		text : '사용자 설정',
		iconCls : 'icon-pinfo',
		handler : function(widget, event) {
			//uniSaveGridState();
		}
	},{
		},{
		text : '언어설정',
		menu: {
			plain: true,
			items: [
				{text:'한국어', handler: function(){uniChangeLang('ko');}},
				{text:'Chinese(中文)', handler: function(){uniChangeLang('zh');}},
				{text:'English', handler: function(){uniChangeLang('en');}},
				{text:'Japaness', handler: function(){uniChangeLang('ja');}}
			]}
	}];

function uniChangeContext(url) {
	window.open(url,'_blank');
}

function uniChangeLang(lang) {
	console.log("new lang : ", lang);
	if(confirm("언어 변경을 선택 하셨습니다. 현재 열려있는 화면의 저장되지 않은 모든 정보가 버려집니다. \n계속 진행하시겠습니까?")) {
		document.location = CPATH+"${mainUrl }?TlabSiteLanguage="+lang;
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
	var tabPanel = Ext.getCmp('panelContent');
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
	contentEl : "config-content",

	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";
		this.menu = Ext.create("Ext.menu.Menu", {
					plain : true,
					renderTo : Ext.getBody(),// Ext.getCmp('icon-config'),
					items : configMenus
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

/************************************************
 * Search box Shecha DOC에서
 *
 * @type
 */
Docs = {"data": {
		"signatures":[
			{"tagname":"abstract","short":"ABS","long":"abstract"},
			{"tagname":"chainable","short":"&gt;","long":"chainable"},
			{"tagname":"deprecated","short":"DEP","long":"deprecated"},
			{"tooltip":"New since Ext JS 4.2.1","tagname":"new","short":"&#9733;","long":"&#9733;"},
			{"tagname":"preventable","short":"PREV","long":"preventable"},
			{"tagname":"private","short":"PRI","long":"private"},
			{"tagname":"protected","short":"PRO","long":"protected"},
			{"tagname":"readonly","short":"R O","long":"readonly"},
			{"tagname":"removed","short":"REM","long":"removed"},
			{"tagname":"required","short":"REQ","long":"required"},
			{"tagname":"static","short":"STA","long":"static"},
			{"tagname":"template","short":"TMP","long":"template"}
		]
		,"search": [
			{"meta":{},"icon":"icon-class","sort":1,"url":"#!/api/Ext.data.amf.Packet","name":"Packet","fullName":"Ext.data.amf.Packet"},
			{"meta":{},"icon":"icon-class","sort":1,"url":"#!/api/Ext.data.amf.Packet","name":"Packet","fullName":"Ext.data.amf.Packet"}
		]
	} //data
};

Ext.define("Docs.view.Signature", {
  singleton: true,
  render: function(f, d) {
    d = d || "short";
    var e = Ext.Array.map(Docs.data.signatures, function(a) {
      return f[a.tagname] ? '<span class="' + a.tagname + '">' + (a[d]) + "</span>" : ""
    }).join(" ");
    return '<span class="signature">' + e + "</span>"
  }
});

Ext.define("Docs.view.search.Dropdown", {
  extend: "Ext.view.View",
  alias: "widget.searchdropdown",
  requires: ["Docs.view.Signature"],
  floating: true,
  autoShow: false,
  autoRender: true,
  toFrontOnShow: true,
  focusOnToFront: false,
  store: "Search",
  id: "search-dropdown",
  overItemCls: "x-view-over",
  trackOver: true,
  itemSelector: "div.item",
  singleSelect: true,
  pageStart: 0,
  pageSize: 10,
  initComponent: function() {
    this.addEvents("changePage", "footerClick");
    this.tpl = new Ext.XTemplate('<tpl for=".">', '<div class="item">', '<div class="icon {icon}"></div>', '<div class="meta">{[this.getMetaTags(values.meta)]}</div>', '<div class="title {[this.getCls(values.meta)]}">{name}</div>', '<div class="class">{fullName}</div>', "</div>", "</tpl>", '<div class="footer">', '<tpl if="this.getTotal()">', '<a href="#" class="prev">&lt;</a>', '<span class="total">{[this.getStart()+1]}-{[this.getEnd()]} of {[this.getTotal()]}</span>', '<a href="#" class="next">&gt;</a>', "<tpl else>", '<span class="total">Nothing found</span>', "</tpl>", "</div>", {
      getCls: function(b) {
        return b["private"] ? "private" : (b.removed ? "removed" : "")
      },
      getMetaTags: function(b) {
        return Docs.view.Signature.render(b)
      },
      getTotal: Ext.bind(this.getTotal, this),
      getStart: Ext.bind(this.getStart, this),
      getEnd: Ext.bind(this.getEnd, this)
    });
    this.on("afterrender", function() {
      this.el.addListener("click", function() {
        this.fireEvent("changePage", this, -1)
      }, this, {
        preventDefault: true,
        delegate: ".prev"
      });
      this.el.addListener("click", function() {
        this.fireEvent("changePage", this, +1)
      }, this, {
        preventDefault: true,
        delegate: ".next"
      });
      this.el.addListener("click", function() {
        this.fireEvent("footerClick", this)
      }, this, {
        delegate: ".footer"
      })
    }, this);
    this.callParent(arguments)
  },
  setTotal: function(b) {
    this.total = b
  },
  getTotal: function() {
    return this.total
  },
  setStart: function(b) {
    this.pageStart = b
  },
  getStart: function(b) {
    return this.pageStart
  },
  getEnd: function(c) {
    var d = this.pageStart + this.pageSize;
    return d > this.total ? this.total : d
  }
});

Ext.define("Docs.view.search.Container", {
  extend: "Ext.container.Container",
  alias: "widget.searchcontainer",
  requires: "Docs.view.search.Dropdown",
  initComponent: function() {
    if (Docs.data.search.length) {
      this.cls = "search";
      this.items = [{
        xtype: "triggerfield",
        triggerCls: "reset",
        emptyText: "Search",
        width: 170,
        id: "search-field",
        enableKeyEvents: true,
        hideTrigger: true,
        onTriggerClick: function() {
          this.reset();
          this.focus();
          this.setHideTrigger(true);
          Ext.getCmp("search-dropdown").hide()
        }
      }, {
        xtype: "searchdropdown"
      }]
    }
    this.callParent()
  }
});