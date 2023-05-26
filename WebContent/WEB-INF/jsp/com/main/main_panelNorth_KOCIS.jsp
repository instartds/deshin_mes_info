<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	
	request.setAttribute("isDevelopServer", isDevelopServer);
%>

{
            region: 'north',
            id: 'panelNorth',
            xtype: "container",
            layout: {
		        type: 'hbox',
		        align: 'stretch'
		    },
            defaults: {
                xtype: "uniTransparentContainer",
                padding: "0",
                style: {'vertical-align': 'middle'}
            },      
            cls: 'uni-doc-header',   
            height: 44,
            items: [
                { 
                    xtype:"uniActionContainer",
                    style:{
                    	'background-image':'url('+CPATH + '/resources/css/theme_01/logo_'+UserInfo.compCode+'.png)',
                    	'background-repeat': 'no-repeat'
                    },
                    html:'<div style="line-height:29px;width:211px;">&nbsp</div>',
                    //html: '<img src="' + CPATH + '/resources/css/theme_01/logo.png" />',
                    margin: "8 0 0 35",
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('home');
                    }
                },  
                <c:if test="${isDevelopServer }">
                {
                	xtype:'component',
                    width: 80,
                	html:'<div style="  height: 32px !important;line-height: 44px !important; vertical-align: middle; color: #fefefe;font-weight: bold;font-size: 18px ;padding-left:20px;">(개발)</div>'
               
                },
                </c:if>
                {
                  flex: .8,
                  },
//              프로그램 검색
                { 
                    xtype: "searchcontainer", 
                    width: 230, 
                    margin: "10 0 0 0" 
                },
                { 
                    xtype:'dataview',
                    //html:'<img src="' + CPATH + '/resources/css/theme_01/badge.png" title="<t:message code="system.label.common.home" default="Home"/>" />',
                    //renderTpl: Ext.create('Ext.XTemplate','<span  style="<tpl if=\'!badgeText || badgeText == "0" \'>display: none;{style}</tpl>" data-qtip="{toolTip}">{badgeText}</span>'),
                    tpl: Ext.create('Ext.XTemplate',['<div class="badgeItem"><img src="' + CPATH + '/resources/css/theme_01/badge.png" title="<t:message code="system.label.common.badge" default="Badge"/>" />',
                    '<tpl for="."><span badge="{CNT}"  data-qtip="{CNT}개의 알림이 있습니다."/></tpl></div>']),
                    padding: "13 10 0 0",
                    width: 30,
                    loadMask:false,
                    //renderData :{cnt:9},
                    store: Ext.create('Ext.data.Store',{
						storeId: 'mainBadgeStore',
						proxy:{
							type:'direct',
							api: { read:'badgeService.selectMyCount'}
							
						},
				        fields:[
				        	'cnt',
				        	'text'
				        ]/*,
				        data:[
				        	{'cnt':0 , text:'개의 알림이 있습니다.'}
				        ]*/
					}),
                    itemSelector:'div.badgeItem',
                    selectedItemCls :'badgeItem-x-item-selected',
                    listeners:{
                    	render:function(cmp)	{
                    		
                    		var store = Ext.StoreManager.lookup("mainBadgeStore");
                    		store.load();
                    		setInterval(function(){ 
	                    			try {
	                    				store.load();
	                    			} catch(e){
	                    				console.log(e)
	                    			}
                    			},30000);
                    	}
                    	,
                    	select:function(view, record)	{
                    		openAlert();
                    	}
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/home.png" title="Home" />',
                    width: 30,
                    padding: "13 10 0 0",
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('home');
                    }
                },
                
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/process.png" title="' + '<t:message code="main.menuTab.process" />' + '" />',
                    width: 30,
                    padding: "13 10 0 0",
                    onClick:function() {
                        var tabPanel = Ext.getCmp('panelNavigation');
                        tabPanel.setActiveTab('leftProcMenu');
                        if(tabPanel.getCollapsed( )) {
                            tabPanel.expand();
                        }
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/bookmark.png" title="' + '<t:message code="main.menuTab.mymenu" />' + '" />',
                    width: 30,
                    padding: "13 10 0 0",
                    onClick:function() {
                        var tabPanel = Ext.getCmp('panelNavigation');
                        tabPanel.setActiveTab('leftMyMenu');
                        if(tabPanel.getCollapsed( )) {
                            tabPanel.expand();
                        }
                    }
                },
                {
					xtype: "uniHeaderConfig",
                    width: 30,
					padding: "13 10 0 0"
                },
                {
					xtype: "uniCompCodeConfig",
                    width: 30,
					padding: "13 10 0 0"
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/fullscreen.png" title="Maximize" />',
                    width: 30,
                    padding: "13 10 0 0",
                    onClick:function() {
                        windowMaximize();
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logout.png" title="LogOut" />',
                    width: 30,
                    padding: "13 10 0 0",
                    onClick:function() {
                    	document.location = CPATH+"/login/logOutKocis.do";
                    }
                }
                
             ] // items

        };