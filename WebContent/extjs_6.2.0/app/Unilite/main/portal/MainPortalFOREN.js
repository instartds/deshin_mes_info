/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 * 연세대 신촌 캠퍼스
 */
Ext.define('Unilite.main.portal.MainPortalFOREN', {
	extend: 'Unilite.com.panel.portal.UniPortalPanel',
	title: 'Portal',
    itemId: 'portal',
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,
    // implement getPortalItems of base class
    getPortalItems: function() {
    	
    	Unilite.defineModel('portalConsultingModel', {
    	    fields: [ 
    	    	{name: 'PROJECT_NAME'		, text:'프로젝트'	, type: 'string'}, 
    	    	{name: 'CLIENT_NAME'		, text:'고객사'		, type: 'string'},
    		    {name: 'STATUS'				, text:'상태'},
    	    	{name: 'PROJECT_DATE_FR'	, text:'시작일'		, type: 'string'},
    	    	{name: 'PROJECT_DATE_TO'	, text:'종료일'		, type: 'string'},
    	    	{name: 'PROJECT_MANAGER'	, text:'PM'			, type: 'string'},
    	    	{name: 'NOTICE_YN'			, text:'게시여부'	, type: 'string'},
    			{name: 'NOTICE_SEQ'			, text:'게시순서'	, type: 'int'}
    		]
    	});
    	function dateConvert(value)	{
    		return UniDate.extSafeParse(value,'Y.m.d');
    	}
    	Unilite.defineModel('portalDeptTaskModel', {
    	    fields: [ 
    	    	{name: 'TASK_NAME'		, text:'업무명'	, type: 'string'}, 
    	    	{name: 'TASK_DETAIL'	, text:'업무내용'	, type: 'string'},
    		    {name: 'STATUS'			, text:'상태'},
    	    	{name: 'TASK_DATE_FR'	, text:'시작일'	, type: 'uniDate'},
    	    	{name: 'TASK_DATE_TO'	, text:'종료일'	, type: 'uniDate'},
    	    	{name: 'TASK_MANAGER'	, text:'담당'	, type: 'string'},
    	    	{name: 'NOTICE_YN'		, text:'게시여부'	, type: 'string'},
    			{name: 'NOTICE_SEQ'		, text:'게시순서'	, type: 'int'}
    		]
    	});
    	//컨설팅팀
        var store1 = new Ext.data.Store({
        	storeId: 'a',
      		model:'portalConsultingModel',
      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalFORENService.selectCounsulting'                	
                }
            },
    		loadStoreRecords: function()	{
				this.load();
    		}
    	});
    	//IT서비스팀
        var store2 = new Ext.data.Store({
      		model:'portalDeptTaskModel',
      		storeId: 'b',
//      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalFORENService.selectItService'                	
                }
            },
            loadStoreRecords: function()	{
            	this.load();
    		}
    	});
    	//개발팀
        var store3 = new Ext.data.Store({
      		model:'portalDeptTaskModel',
      		storeId: 'c',
      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalFORENService.selectDevelopment'                	
                }
            },
            loadStoreRecords: function()	{
    			this.load();
    		}
    	});
    	//연구소
        var store4 = new Ext.data.Store({
      		model:'portalDeptTaskModel',
      		storeId: 'c',
      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'mainPortalFORENService.selectLab'                	
                }
            },
            loadStoreRecords: function()	{
    			this.load();
    		}
    	});
        
    	var grid2 = Unilite.createGrid('portalForenGrid2', {
            //height: 300,
    		region:'center',
    		layout:'fit',
		           		splitterResize:false,
		           		split:false,
    		flex:1,
            uniOpt: {
        		useGroupSummary: false,
        		useLiveSearch: false,
    			useContextMenu: false,
    			useMultipleSorting: false,
    			useRowNumberer: false,
    			expandLastColumn: false,
    			userToolbar:false,
        		filter: {
    				useFilter: false,
    				autoCreate: false
    			}
            },
        	store: store2,
            columns: [
            	{dataIndex: 'TASK_NAME'			, width: 120},
    		    {dataIndex: 'TASK_DETAIL'		, flex:1},
    		    {dataIndex: 'STATUS'			, width: 80},
    		    {dataIndex: 'TASK_DATE_FR'		, width: 80},
            	{dataIndex: 'TASK_DATE_FR'		, width: 80},
            	{dataIndex: 'TASK_DATE_TO'		, width: 80},
            	{dataIndex: 'TASK_MANAGER'		, width: 80}]
        });

       var grid3 = Unilite.createGrid('portalForenGrid3', {
            height: 320,
    		flex:1,
            uniOpt: {
        		useGroupSummary: false,
        		useLiveSearch: false,
    			useContextMenu: false,
    			useMultipleSorting: false,
    			useRowNumberer: false,
    			expandLastColumn: false,
    			userToolbar:false,
        		filter: {
    				useFilter: false,
    				autoCreate: false
    			}
            },
        	store: store3,
            columns: [
            	{dataIndex: 'TASK_NAME'			, width: 120},
    		    {dataIndex: 'TASK_DETAIL'		, flex:1},
    		    {dataIndex: 'STATUS'			, width: 80},
            	{dataIndex: 'TASK_DATE_FR'		, width: 80},
            	{dataIndex: 'TASK_DATE_TO'		, width: 80},
            	{dataIndex: 'TASK_MANAGER'		, width: 80}]
        });
        
        var grid4 = Unilite.createGrid('portalForenGrid4', {
            height: 320,
    		flex:1,
            uniOpt: {
        		useGroupSummary: false,
        		useLiveSearch: false,
    			useContextMenu: false,
    			useMultipleSorting: false,
    			useRowNumberer: false,
    			expandLastColumn: false,
    			userToolbar:false,
        		filter: {
    				useFilter: false,
    				autoCreate: false
    			}
            },
        	store: store4,
            columns: [
            	{dataIndex: 'TASK_NAME'			, width: 120},
    		    {dataIndex: 'TASK_DETAIL'		, flex:1},
    		    {dataIndex: 'STATUS'			, width: 80},
            	{dataIndex: 'TASK_DATE_FR'		, width: 80},
            	{dataIndex: 'TASK_DATE_TO'		, width: 80},
            	{dataIndex: 'TASK_MANAGER'		, width: 80}]
        });
        var view1 = Ext.create('Ext.view.View', {
		tpl: [
			'<tpl for=".">' ,
			'<div class="consulting-portlet" id={NOTICE_SEQ} style="float:left;margin:2px;">' ,
			'<table cellpadding="5" cellspacing="0" border="0" width="250"  align="center" style="border:1px solid #cccccc;">' ,
			'<tr>' ,
			'	<td colspan="2" style="background:#dfe8f6 ;text-align:center;fontweight:bold;">{PROJECT_NAME}</td>',
			'</tr>',
			'<tr>',
			'	<td width="90"  style="text-align:right; !important">고객사 : </td>' ,
			'	<td style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc !important">{CLIENT_NAME}</td>',
			'</tr>' ,
			'<tr>',
			'	<td width="90"  style="text-align:right; !important">프로젝트기간 : </td>' ,
			'	<td style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc !important">{PROJECT_DATE_FR} ~ {PROJECT_DATE_TO}</td>',
			'</tr>' ,
			'<tr>',
			'	<td width="90"  style="text-align:right; !important">PM : </td>' ,
			'	<td style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc !important">{PROJECT_MANAGER}</td>',
			'</tr>' ,
			'<tr>',
			'	<td width="90"  style="text-align:right; !important">상태 : </td>' ,
			'	<td style="border-top: 0px solid #cccccc;border-left: 0px solid #cccccc !important">{STATUS}</td>',
			'</tr>' ,
			'</table>',
			'</div>',
			'</tpl>'
		],
		height:320,
		border:true,
		autoScroll:true,
		trackOver: true,
		itemSelector: 'div.consulting-portlet',
		selectedItemCls : 'consulting-portlet',
		overItemCls:'consulting-portlet',
        store: store1,
        margin:'1 1 1 1'
	
	});
        
    	var itemCol1 = {
    			defaults:{
    				padding: '0 0 0 0'
            	},
	        items: [{
	            title: '컨설팅팀',
	            layout: 'fit',
	            itemId:'portlet1',
	            flex:0.5,
		        closable:false,
		        collapsible:false,
		        tools:[
		        	{
		        		type: 'refresh',
				        callback: function() {
				            store1.loadStoreRecords();
				    	}
		        	}
		        ],
	            items: [view1]
	        },{
		           title: '개발팀',
		           layout: 'fit',
		           itemId:'portlet2',
		           flex:0.5,
		           closable:false,
		        	collapsible:false,
			       tools:[
			        	{
			        		type: 'refresh',
					        callback: function() {
				            	store3.loadStoreRecords();
					    	}
			        	}
			        ],
		           items: [grid3]
		        }]
	    };
	    
	    var itemCol2 = {
	    		defaults:{
	    			padding: '0 0 0 0'
            	},
	        items: [{
		           title: 'IT 서비스팀',
		           flex:0.5,
		           itemId:'portlet3',
		           closable:false,
		        	collapsible:false,
		        	
			        tools:[
			        	{
			        		type: 'refresh',
					        callback: function() {
					            store2.loadStoreRecords();
					    	}
			        	}
			        ],
		           items: [{
		           		xtyp:'panel',
		           		layout:'border',
		           		height:321,
		           		border:0,
		           		items:[
		           			{
				           		xtype:'panel',
				           		region:'north',
				           		height:22,
				           		style:{
				           			'text-align':'right'
				           		},
				           		border:0,
				           		margin:'2 4 2 1',
				           		splitterResize:false,
				           		split:false,
				           		items:[
						           	{
						           		xtype:'button',
						           		text:'서버현황',
						           		width:'100',
						           		handler:function()	{
											var detailWin = Ext.create('Ext.window.Window', {
								                title: '서버현황',
								                width: 1050,				                
								                height: 500,
												scrollable:true,
								                items: [{ 
								                	xtype: 'image', 
								                	src:CPATH+'/fileman/view/idc1', 
								                	align:'center',	 
								                	overflow:'auto'
								                },{ 
								                	xtype: 'image', 
								                	src:CPATH+'/fileman/view/idc2', 
								                	align:'center',	 
								                	overflow:'auto'
								                }]
											});
											detailWin.show();
						           		}
						           	}
						        ]
				           }
				           	,grid2
		           		
		           		]
		           	
		           }]
		        },{
		           title: '연구소',
		           layout: 'fit',
		           flex:0.5,
		           itemId:'portlet4',
		           closable:false,
		        	collapsible:false,
			        tools:[
			        	{
			        		type: 'refresh',
					        callback: function() {
					           store4.loadStoreRecords();
					    	}
			        	}
			        ],
		           items: [grid4]
		        }]
	    };
	    
	    return [itemCol1,
    			itemCol2]
    },
    
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems()
    		,listeners:{
    			'show':function(portalPanel, eOpts)	{
	    			
    			}
    		}
    	});
    		    
    	this.callParent();
    }
 
});