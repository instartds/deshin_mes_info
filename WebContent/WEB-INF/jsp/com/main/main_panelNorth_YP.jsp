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
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logo_YP.png" />',
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
                    padding: "13 10 0 0",
                    width: 28,
                    onClick:function() {
                        var tabPanel = Ext.getCmp('contentTabPanel');
                        tabPanel.setActiveTab('home');
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/groupware.png" title="Home" />',
                    padding: "13 10 0 0",
                    width: 28,
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
                    width: 28,
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
                    width: 28,
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
                    width: 28,
                },
                {
					xtype: "uniCompCodeConfig",
					padding: "13 10 0 0",
                    width: 28,
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/fullscreen.png" title="Maximize" />',
                    padding: "13 10 0 0",
                    width: 28,
                    onClick:function() {
                        windowMaximize();
                    }
                },
                { 
                    xtype:"uniActionContainer",
                    html: '<img src="' + CPATH + '/resources/css/theme_01/logout.png" title="LogOut" />',
                    padding: "13 10 0 0",
                    width: 28,
                    onClick:function() {
                    	document.location = CPATH+"/login/actionLogout.do";
                    }
                }
                
             ] // items

        };