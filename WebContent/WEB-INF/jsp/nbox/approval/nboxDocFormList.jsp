<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="${PRGID}" >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
/**************************************************
 * Require
 **************************************************/
    Ext.require([
        'Ext.ux.PreviewPlugin'/* , 
        'Ext.LoadMask'  */
    ]);
    
/**************************************************
 * Common variable
 **************************************************/
//local  variable
    var console = window.console;

/**************************************************
 * Common Code
 **************************************************/
//Combobox
/**************************************************
 * Model
 **************************************************/
//Master Grid	
    Ext.define('nbox.masterGridModel', {
        extend: 'Ext.data.Model',
        fields: [
        	{name: 'FormID'}, 
        	{name: 'CategoryName'},
        	{name: 'Subject'},
        	{name: 'StoreYear'}, 
        	{name: 'CabinetID'},
        	{name: 'SecureGrade'},
        	{name: 'OrgType'},
        	{name: 'InsertUserName'}
        ]
    });
    
/**************************************************
 * Store
 **************************************************/
//Master Grid 	
    Ext.define('nbox.masterGridStore', {
    	extend: 'Ext.data.Store', 
    	model: 'nbox.masterGridModel',
    	autoLoad: true,
    	proxy: {
               type: 'direct',
               api: { read: 'nboxDocFormService.selects' },
               reader: {
                type: 'json',
                root: 'records'
            }
    	}
    });
    	
/**************************************************
 * Include
 **************************************************/

/**************************************************
 * Define
 **************************************************/
//Master Grid
    Ext.define('nbox.masterGrid', {
    	extend:	'Ext.grid.Panel',
    	config: {
    		regItems: {}
    	},
    	flex:1,
           viewConfig:{
           loadMask:true,
           loadingText: 'loading...'
        },
        initComponent: function () {
    		var me = this;
    		
            me.columns= [
    	        {
    	            text: '양식종류',
    	            sortable: true,
    	            dataIndex: 'CategoryName',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        }, 
    	        {
    	            text: '양식제목',
    	            sortable: true,
    	            dataIndex: 'Subject',
    	            groupable: false,
    	            flex:1,
    	            renderer : function(value, metadata) {
    	            	var pgmId = 'nboxdocformwrite';
    	            	var text = '';
    	            	var formId = metadata.record.data.FormID;
    	   		        return "<a onclick=\"return openTab_a(\'" + pgmId + "\',\'" + formId + "\',\'" + text + "\',\'/nbox/nboxdocformwrite.do\');\">" + value + "</a>"
                	}
    	        }, 
    	        {	
    	            text: '보존기한',
    	            sortable: true,
    	            dataIndex: 'StoreYear',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        }, 
    	        {
    	            text: '문서함',
    	            sortable: true,
    	            dataIndex: 'CabinetID',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        },
    	        {
    	            text: '보안등급',
    	            sortable: true,
    	            dataIndex: 'SecureGrade',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        },
    	        {
    	            text: '조직구분',
    	            sortable: true,
    	            dataIndex: 'OrgType',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        },
    	        {
    	            text: '작성자',
    	            sortable: true,
    	            dataIndex: 'InsertUserName',
    	            align: 'center',
    	            groupable: false,
    	            width: 120
    	        }];
        
            var nboxMasterGridPaging = Ext.create('Ext.toolbar.Paging', {
            	id:'nboxMasterGridPaging',
           		store: me.getStore(),
    	        dock: 'bottom',
    	        displayInfo: true
           	});
    		
    		me.dockedItems= [nboxMasterGridPaging];
    		
    		me.callParent(); 
    	},
        listeners : {
        	render: function(obj, eOpts){
        		var me = obj;
        	},
           	itemdblclick: function(obj, record, item, index, e) {
           		var me = this;
           		if(record) {
               		var params = {
                            'PGM_ID'        : 'nboxdocformwrite',
                            'formID'        : record.data.FormID
                       }
               		
                    var rec1 = {data : {prgID : 'nboxdocformwrite', 'text':''}};  
                       
                    openTab(rec1, '/nbox/nboxdocformwrite.do', params);
            	}
            }
        },
        queryDetailData: function(){
            var me = this;
           	var record;
           	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
           	
           	record = me.getSelectionModel().getSelection()[0];
            if(record) {
                nboxBaseApp.setFormID(record.data.FormID);
                nboxBaseApp.setActionType(NBOX_C_READ);
            }
        },
        queryData: function(){
    	    var me = this;
            var store = me.getStore();
            
            var searchForm = Ext.getCmp('nboxSearchForm');
            
            store.proxy.setExtraParam('SEARCHTEXT', searchForm.items.get('SEARCHTEXT').getValue());
            	store.load();
        },
        selectPrevious: function(keepExisting, suppressEvent) {
           	var me = this;
    		var last;
    		var pageData;
    		var selModel = me.getSelectionModel();
    		
            last = selModel.getSelection()[0];
            if (last) {
                pageData = Ext.getCmp('nboxMasterGridPaging').getPageData();
    
                if (last.index >= pageData.fromRecord) {
                    selModel.select((last.index - pageData.fromRecord), keepExisting, suppressEvent);
                    me.queryDetailData();
                    return;
                }
    
                if (pageData.currentPage > 1) {
                    me.view.on('refresh', function(view){
                    		selModel.select((me.getStore().getCount() - 1), keepExisting, suppressEvent);
                    		me.queryDetailData();
                        },
                        me, {single: true}
                    );
                    Ext.getCmp('nboxMasterGridPaging').movePrevious();
                } else {
                    Ext.Msg.alert('확인', '첫번째 레코드 입니다.');
                }
            }
        },
        selectNext: function(keepExisting, suppressEvent) {
        	var me = this;
        	var pageData;
        	var selModel = me.getSelectionModel();
        	
               last = selModel.getSelection()[0];
           	if (last) {
               	pageData = Ext.getCmp('nboxMasterGridPaging').getPageData();
    
                if (last.index < pageData.toRecord - 1) {
                    selModel.select((last.index + 2 - pageData.fromRecord), keepExisting, suppressEvent);
                    me.queryDetailData();
                    return;
                }
    
                if (pageData.currentPage < pageData.pageCount) {
                    me.view.on('refresh', function(view){
                    		selModel.select(0, keepExisting, suppressEvent);
                            me.queryDetailData();
                        },
                        me, {single: true}
                    );
                    Ext.getCmp('nboxMasterGridPaging').moveNext();
                } else {
                	Ext.Msg.alert('확인', '마지막 레코드입니다.');
                }
            } 
        },
        openDetailWin: function(actionType, formID){
            var me = this;
        
            var params = {
                    'PGM_ID'        : 'nboxdocformwrite',
                    'formID'        : formID
               }
            
            var rec1 = {data : {prgID : 'nboxdocformwrite', 'text':''}};  
               
            openTab(rec1, '/nbox/nboxdocformwrite.do', params);
        }
    }); 
    	
//Viewport toolbar
    Ext.define('nbox.viewportToolbar',    {
           extend:'Ext.toolbar.Toolbar',
           config: {
    		regItems: {}
    	},
    	dock : 'top',
    	height: 30, 
    	padding: '0 0 0 5px',
    	
    	initComponent: function () {
        	var me = this;
        	var btnWidth = 60;
        	var btnHeight = 26;
        	
        	var formSearch = { 
            	xtype: 'form',
    		  	border: false,
    		  	layout: 'fit',
    		  	id:'nboxSearchForm',
    		  	items: [
    		  	{ 
    			  	xtype: 'textfield',
    			  	id: 'SEARCHTEXT',
    			  	name: 'SEARCHTEXT'
    		  	}]	
            };
        	
        	var btnQuery =  {	
    			xtype: 'button', 
    			//scale: 'medium',
    			tooltip: '검색',
    			//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/search16a.png" width=15 height=15/>&nbsp;<label>검색</label>', 
    			text: '<label>검색</label>',
    		    itemId: 'query',
    		    width: btnWidth,
    		    height: btnHeight,
    		            
    		    handler: function() {
    		    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    		    	
    		    	if (nboxBaseApp)
    		    		nboxBaseApp.QueryButtonDown();
    		    }
    		};
    			
    		var btnNew = {
    		 	xtype: 'button', 
    		 	//scale: 'medium',
    		 	tooltip : '새양식',
    		 	//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/new16a.png" width=15 height=15/>&nbsp;<label>새양식</label>', 
    		 	text: '<label>새양식</label>',
                itemId : 'new',
                width: btnWidth,
                height: btnHeight,
                   
                handler: function() { 
                    var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.NewButtonDown();
                }
    		};
    		
    		var btnClose = {
    			xtype: 'button', 
    			//scale: 'medium',
    		 	tooltip : '닫기',
    		 	//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/close16a.png" width=15 height=15/>&nbsp;<label>닫기</label>', 
    		 	text: '<label>닫기</label>',
                itemId : 'close',
                width: btnWidth,
                height: btnHeight,
                
                handler: function() { 
                    var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.CloseButtonDown();
                }
    		};
    		
    	    var toolbarItems = [ formSearch, btnQuery, btnNew, btnClose ];    
    	        
            //var chk01 = false; 
            var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
    		if( chk01 ) {
    			toolbarItems.push( // space
    				'->',
    				{	
    					//xtype: 'menu',
    					text: 'Grid',
    					iconCls: 'menu-menuShow',
    					menu: {
    						xtype: 'menu',
    						items:[
    							{
    	                            text: 'Sheet 환경 저장', 
    	                            iconCls: 'icon-sheetSaveState',
    	                            handler: function(widget, event) {
    						        	UniAppManager.saveGridState();							          
    						        }
    					        },
    	                        {
    	                        	text: 'Sheet 환경 기본값 설정', 
    	                        	iconCls: 'icon-sheetResetState',
    	                            handler: function(widget, event) {
    						        	UniAppManager.resetGridState();
    						          
    						        }
    							}
    						]
    					}
    				},
    				{
    					xtype : 'button',
    					text : '',
    					tooltip : '현재탭 Reload(Cache 사용 안함!)', 
    					iconCls: 'icon-reload',
    					handler : function() {
    						location.reload(true );
    					}
    				},
    				{
    					xtype : 'button',
    					text : '',
    					tooltip : '현재 Tab을 새창으로 띄우기', 
    					iconCls: 'icon-newWindow',
    					handler : function() {
    						window.open(window.location.href, '_blank');
    					}
    				}
    			);
    		}
            	    	
    		me.items = toolbarItems;
        	me.callParent(); 
        },
        setToolBars: function(btnItemIDs, flag){
        	var me = this;
        	
    		if(Ext.isArray(btnItemIDs) ) {
    			for(i = 0; i < btnItemIDs.length; i ++) {
    				var element = btnItemIDs[i];
    				me.setToolBar(element, flag);
    			}
    		} else {
    			me.setToolBar(btnItemIDs, flag);
    		}
        },
        setToolBar: function(btnItemID, flag){
        	var me = this;
        	
        	var obj =  me.getComponent(btnItemID);
    		if(obj) {
    			(flag) ? obj.enable(): obj.disable();
    		}
        }
    });
    	
//Viewport
    Ext.define('nbox.baseApp', {
    	extend: 'Ext.Viewport',
    	config: {
    		formID: null,
    		actionType: null,
    		regItems: {}
    	},
        defaults: { padding: 0 },
       	layout : {	
       		type: 'vbox', 
       		pack: 'start', 
       		align: 'stretch' 
       	},
        initComponent: function () {
        	var me = this;
        	
        	var title = {
                xtype: 'container',
                cls: 'uni-pageTitle',
                id: 'UNILITE_PG_TITLE',
                html: "${PGM_TITLE}",
                padding: '0 0 5px 0',
                height: 32,
                region:'north'
            };

    		var nboxViewportToolbar = Ext.create('nbox.viewportToolbar',{
    			id:'nboxViewportToolbar'
    		});
    		
            var nboxMasterGridStore = Ext.create('nbox.masterGridStore', {
                id: 'nboxMasterGridStore'
            });
            
    		var nboxMasterGrid = Ext.create('nbox.masterGrid',{
    			id: 'nboxMasterGrid',
    			store: nboxMasterGridStore
    		});
    		
        	me.items = [title, nboxViewportToolbar, nboxMasterGrid];
        	
            me.callParent(); 
        },
        QueryButtonDown: function(){
        	var me = this;
        	me.queryData();
        },
        NewButtonDown: function(){
        	var me = this;
        	me.newData();
        },
        CloseButtonDown: function(){
            var me = this;
            me.closeWindow();
        },    
       	queryData: function(){
       		var me = this;
       		var nboxMasterGrid = Ext.getCmp('nboxMasterGrid');
       		
       		if (nboxMasterGrid)
       			nboxMasterGrid.queryData();
       	},	    
        newData: function(){
        	var me = this;
            var nboxMasterGrid = Ext.getCmp('nboxMasterGrid');
            
            if (nboxMasterGrid)
            	nboxMasterGrid.openDetailWin(NBOX_C_CREATE, null);
        },
        closeWindow: function(){
        	var tabPanel = parent.Ext.getCmp('contentTabPanel');
    		if(tabPanel) {
    			var activeTab = tabPanel.getActiveTab();
    			var canClose = activeTab.onClose(activeTab);
    			if(canClose)  {
    				tabPanel.remove(activeTab);
    			}
    		} else {
    			me.hide();
    		}
        }
    });
    	
/**************************************************
 * Create
 **************************************************/
//Load Mask
//var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
    
//Viewport Create
    Ext.create('nbox.baseApp',  {
    	id: 'nboxBaseApp'
    });
    
}; // appMain

/**************************************************
 * User Define Function
 **************************************************/
function openTab_a(pgmId, formID, text, doPath){
    var params = {
         'PGM_ID'        : pgmId,
         'formID'        : formID
    }
    var rec1 = {data : {prgID : pgmId, 'text':text}};  
    
    openTab(rec1, doPath, params);
};

function openTab(rec1, doPath, params){
    parent.openTab(rec1, doPath, params);
};
</script>	
