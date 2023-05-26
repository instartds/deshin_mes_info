<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logo_ysu.png" />',
                    margin: "8 0 0 35",
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('home');
                    }
                },  
                {
                  flex: 1
                },
//              프로그램 검색
                { 
                    xtype: "searchcontainer", 
                    width: 230, 
                    margin: "10 0 0 0" ,
                    listeners: {        	
			            select: function( combo, record, eOpts ) {
			                if(records && records.length > 0 ) {
			                  console.log('select : ', records[0].data);     
			                  openTab(records, records.get('url')+"?authoUser="+(rec.get("authoUser")=="null" ? '':rec.get("authoUser"))) ;
			                }
			            }
			        }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/home.png" title="Home" />',
                    padding: "13 10 0 0",
                    width:30,
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('home');
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/groupware.png" title="Home" />',
                    padding: "13 10 0 0",
                    width:30,
                    hidden: !MODULE_GROUPWARE.ENABLE,
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('groupware');
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/process.png" title="' + '<t:message code="main.menuTab.process" />' + '" />',
                    padding: "13 10 0 0",
                    width:30,
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
                    padding: "13 10 0 0",
                    width:30,
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
					padding: "13 10 0 0",
					width:30
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/fullscreen.png" title="Maximize" />',
                    padding: "13 10 0 0",
                    width:30,
                    onClick:function() {
                        windowMaximize();
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logout.png" title="LogOut" />',
                    padding: "13 10 0 0",
                    width:30,
                    onClick:function() {
                    	document.location = CPATH+"/login/logout.do";
                    }
                }
                
             ] // items

        };