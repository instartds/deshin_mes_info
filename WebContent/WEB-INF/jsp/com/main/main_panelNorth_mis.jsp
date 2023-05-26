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
                    	document.location = CPATH+"/login/logOutAll.do";
                    }
                }

             ] // items

        };