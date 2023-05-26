<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs/ext-all-dev.js");
	
    request.setAttribute("css_url", "/extjs/resources/ext-theme-classic-omega/ext-overrides.css"); // 4.2.2    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Portal Layout Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/portal.css" />' />
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>

    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setPath('Unilite', CPATH +'/app/Unilite');
    </script>
    
    <script type="text/javascript">
        Ext.require([
            'Ext.layout.container.*',
            'Ext.resizer.Splitter',
            'Ext.fx.target.Element',
            'Ext.fx.target.Component',
            'Ext.window.Window',
            'Unilite.com.panel.portal.UniPortlet',
            'Unilite.com.panel.portal.UniPortalColumn',
            'Unilite.com.panel.portal.UniPortalPanel',
            'Unilite.com.panel.portal.UniPortlet'
        ]);

        Ext.onReady(function(){
        	
        	/*Ext.define('Unilite.com.panel.portal.Portal', {
			    extend: 'Ext.container.Viewport',
        		//extend: 'Ext.container.Container',
			    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
				//renderTo: Ext.getBody(),
			    id: 'app-portal-viewport',
	            layout: {
	                type: 'border',
	                padding: '0 5 5 5' // pad the layout from the window edges
	            },
	            items: [{
	                id: 'app-header',
	                xtype: 'box',
	                region: 'north',
	                height: 40,
	                html: 'Ext Portal'
	            },{
	                xtype: 'container',
	                region: 'center',
	                layout: 'border',
	                items: [{
	                    id: 'app-portal',
	                    xtype: 'uniPortalpanel',
	                    region: 'center',
	                    items: [{
	                        id: 'col-1',
	                        items: [{
	                            id: 'portlet-1',
	                            title: 'Grid Portlet',
	                            html: 'Portlet 1'
	                        },{
	                            id: 'portlet-2',
	                            title: 'Portlet 2',
	                            html: 'Portlet 2'
	                        }]
	                    },{
	                        id: 'col-2',
	                        items: [{
	                            id: 'portlet-3',
	                            title: 'Portlet 3',
	                            html: 'Portlet 3'
	                        }]
	                    },{
	                        id: 'col-3',
	                        items: [{
	                            id: 'portlet-4',
	                            title: 'Stock Portlet',
	                            html: 'Portlet 4'
	                        }]
	                    }]
	                }]
	            }],
			    initComponent: function(){			       
//			        Ext.apply(this, {			            
//			        });
			        this.callParent(arguments);
			    }
			});*/
			
        	var MainPortal =  {
			    xtype: 'container',
                //region: 'center',
                layout: 'border',
                items: [{
                    id: 'app-portal',
                    //xtype: 'uniPortalpanel',
                    xtype: 'panel',
                    region: 'center',
                    items: [{
                        id: 'col-1',
                        items: [{
                            id: 'portlet-1',
                            title: 'Grid Portlet',
                            html: 'Portlet 1'
                        },{
                            id: 'portlet-2',
                            title: 'Portlet 2',
                            html: 'Portlet 2'
                        }]
                    },{
                        id: 'col-2',
                        items: [{
                            id: 'portlet-3',
                            title: 'Portlet 3',
                            html: 'Portlet 3'
                        }]
                    },{
                        id: 'col-3',
                        items: [{
                            id: 'portlet-4',
                            title: 'Stock Portlet',
                            html: 'Portlet 4'
                        }]
                    }]
                }]
			};
			
			var MainPortal = {
                    id: 'app-portal',
                    xtype: 'uniPortalpanel',
                    items: [{
                        id: 'col-1',
                        items: [{
                            id: 'portlet-1',
                            title: 'Grid Portlet',
                            html: 'Portlet 1'
                        },{
                            id: 'portlet-2',
                            title: 'Portlet 2',
                            html: 'Portlet 2'
                        }]
                    },{
                        id: 'col-2',
                        items: [{
                            id: 'portlet-3',
                            title: 'Portlet 3',
                            html: 'Portlet 3'
                        }]
                    },{
                        id: 'col-3',
                        items: [{
                            id: 'portlet-4',
                            title: 'Stock Portlet',
                            html: 'Portlet 4'
                        }]
                    }]
                }
			
			var portalCfg = {
				renderTo : Ext.getBody(),
				layout: {
	                type: 'border',
	                padding: '0 5 5 5' // pad the layout from the window edges
	            },
				items : [{
					region: 'north',
	                id: 'app-header',
	                xtype: 'box',	                
	                height: 40,
	                html: 'Ext Portal'
	            },
	            {
	            	region: 'center',
	            	type: 'panel',
	            	title: 'mainPortal',
	            	items: [MainPortal]
	            }
	            
	            ]	
			};
			Ext.create('Ext.Viewport', portalCfg);
			/*
            Ext.create('',
            	{
				    xtype: 'Ext.container.Viewport',
				   
				//    layout: {
				//        type: 'vbox',
				//        align: 'stretch'
				//    },
				    layout: {
				        type: 'border',
				        padding: '0 5 5 5' // pad the layout from the window edges
				    },
				    renderTo: Ext.getBody(),
				    items: [{
				     	xtype: 'uniPortalpanel',
				     	region: 'center',
				     	title: 'Portal',
				        items: [{
				        	xtype: 'panel',
				        	title: 'Portlet 1',
				        	html: 'this is Portlet 1'
				        },{
				        	xtype: 'panel',
				        	title: 'Portlet 2',
				        	html: 'this is Portlet 2'
				        },{
				        	xtype: 'panel',
				        	title: 'Portlet 3',
				        	html: 'this is Portlet 3'
				        },{
				        	xtype: 'panel',
				        	title: 'Portlet 4',
				        	html: 'this is Portlet 4'
				        }]
				    }]
				}
			);*/
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
    <span id="app-msg" style="display:none;"></span>
</body>
</html>
