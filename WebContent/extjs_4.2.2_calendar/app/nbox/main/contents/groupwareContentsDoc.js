/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsDocModel', {
    extend: 'Ext.data.Model',
    fields: [
    	 {name: 'DocumentID'} 
    	,{name: 'Subject'}
    	,{name: 'DraftUserID'}
    	,{name: 'DraftUserName'}
    	,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
		,{name: 'contentID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsDocAStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA003',MENUTYPE: 'D0001'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocBStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA007',MENUTYPE: 'D0002'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocCStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA006',MENUTYPE: 'D0003'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocDStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA002',MENUTYPE: 'D0004'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});


var groupwareContentsDocAStore = Ext.create('nbox.main.groupwareContentsDocAStore', {});
var groupwareContentsDocBStore = Ext.create('nbox.main.groupwareContentsDocBStore', {});
var groupwareContentsDocCStore = Ext.create('nbox.main.groupwareContentsDocCStore', {});
var groupwareContentsDocDStore = Ext.create('nbox.main.groupwareContentsDocDStore', {});
/**************************************************
 * Define
 **************************************************/
/* DOCD GRID */
Ext.define('nbox.main.groupwareContentsDocDGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocDStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value, metadata) {
	        		var documentId = metadata.record.data.DocumentID;
	        		
	            	if (value.substring(0,1) == '0') 
                        value = '<b>' + value.substring(1) + '</b>';
                    else
                    	value = value.substring(1) ;
	            	
	            	return "<a onclick='return openDetailWinDocD(\"" + documentId + "\")'>" + value + "</a>"
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];
		
		var contextMenuByUserName = Ext.create('nbox.contextMenuByUserName', {});
		
		me.getRegItems()['ContextMenuByUserName'] = contextMenuByUserName;
		contextMenuByUserName.getRegItems()['ParentContainer'] = me;		
		
		me.callParent(); 
	},
	listeners : {
		render: function(grid, eOpts){
			docDGrid = grid;
		},
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin(NBOX_C_READ, record.data.DocumentID);
        	}
        },
        cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
        	if(cellIndex == 1){
        		var me = this;
        		
        		contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
        		
        		contextMenuByUserName.getRegItems()['UserID'] = record.data.DraftUserID;
        		contextMenuByUserName.showAt(e.getXY());
	        	e.preventDefault();	
        	}
        }
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.changeTitle();
   				}
   			}
		});
	},
	selectPrevious: function(keepExisting, suppressEvent) {
		//alert('준비중입니다.');
    },
    selectNext: function(keepExisting, suppressEvent) {
    	//alert('준비중입니다.');
    },
	changeTitle: function(){
    	var me = this;
    	var stroe = me.getStore();
    	
    	var panel = me.getRegItems()['ParentContainer'];
    	var cnt = stroe.getCount();
    	
    	panel.setTitle('기안(' + String(cnt) + ')');
    },
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openDocDetailWin(me, actionType, documentID, '', 'XA002');
    }	
});

/* DOCA GRID */
Ext.define('nbox.main.groupwareContentsDocAGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocAStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value, metadata) {
	        		var documentId = metadata.record.data.DocumentID;
	        		
	            	if (value.substring(0,1) == '0') 
                        value = '<b>' + value.substring(1) + '</b>';
                    else
                    	value = value.substring(1) ;
	            	
	            	return "<a onclick='return openDetailWinDocA(\"" + documentId + "\")'>" + value + "</a>"
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];		
		
		var contextMenuByUserName = Ext.create('nbox.contextMenuByUserName', {});
		
		me.getRegItems()['ContextMenuByUserName'] = contextMenuByUserName;
		contextMenuByUserName.getRegItems()['ParentContainer'] = me
		
		me.callParent(); 
	},
	listeners : {
		render: function(grid, eOpts){
			docAGrid = grid;
		},
    	itemdblclick: function(grid, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin(NBOX_C_READ, record.data.DocumentID);
        	}
        },
        cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
        	if(cellIndex == 1){
        		var me = this;
        		
        		contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
        		
        		contextMenuByUserName.getRegItems()['UserID'] = record.data.DraftUserID;
        		contextMenuByUserName.showAt(e.getXY());
	        	e.preventDefault();	
        	}
        }
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.changeTitle();
   				}
   			}
		});
	},
	selectPrevious: function(keepExisting, suppressEvent) {
		//alert('준비중입니다.');
    },
    selectNext: function(keepExisting, suppressEvent) {
    	//alert('준비중입니다.');
    },
	changeTitle: function(){
    	var me = this;
    	var stroe = me.getStore();
    	
    	var panel = me.getRegItems()['ParentContainer'];
    	var cnt = stroe.getCount();
    	
    	panel.setTitle('미결(' + String(cnt) + ')');
    },
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openDocDetailWin(me, actionType, documentID, '', 'XA003');
    }	
});

/* DOCB GRID */
Ext.define('nbox.main.groupwareContentsDocBGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocBStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value, metadata) {
	        		var documentId = metadata.record.data.DocumentID;
	        		
	            	if (value.substring(0,1) == '0') 
                        value = '<b>' + value.substring(1) + '</b>';
                    else
                    	value = value.substring(1) ;
	            	
	            	return "<a onclick='return openDetailWinDocB(\"" + documentId + "\")'>" + value + "</a>"
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];
		
		var contextMenuByUserName = Ext.create('nbox.contextMenuByUserName', {});
		
		me.getRegItems()['ContextMenuByUserName'] = contextMenuByUserName;
		contextMenuByUserName.getRegItems()['ParentContainer'] = me		
		
		me.callParent(); 
	},
	listeners : {
		render: function(grid, eOpts){
			docBGrid = grid;
		},
    	itemdblclick: function(grid, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin(NBOX_C_READ, record.data.DocumentID);
        	}
        },
        cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
        	if(cellIndex == 1){
        		var me = this;
        		
        		contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
        		
        		contextMenuByUserName.getRegItems()['UserID'] = record.data.DraftUserID;
        		contextMenuByUserName.showAt(e.getXY());
	        	e.preventDefault();	
        	}
        }        
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.changeTitle();
   				}
   			}
		});
	},
	selectPrevious: function(keepExisting, suppressEvent) {
		//alert('준비중입니다.');
    },
    selectNext: function(keepExisting, suppressEvent) {
    	//alert('준비중입니다.');
    },
	changeTitle: function(){
    	var me = this;
    	var stroe = me.getStore();
    	
    	var panel = me.getRegItems()['ParentContainer'];
    	var cnt = stroe.getCount();
    	
    	panel.setTitle('수신(' + String(cnt) + ')');
    },
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openDocDetailWin(me, actionType, documentID, '', 'XA007');
    }	
});

/* DOCC GRID */
Ext.define('nbox.main.groupwareContentsDocCGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocCStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value, metadata) {
	        		var documentId = metadata.record.data.DocumentID;
	        		
	            	if (value.substring(0,1) == '0') 
                        value = '<b>' + value.substring(1) + '</b>';
                    else
                    	value = value.substring(1) ;
	            	
	            	return "<a onclick='return openDetailWinDocC(\"" + documentId + "\")'>" + value + "</a>"
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];		
		
		var contextMenuByUserName = Ext.create('nbox.contextMenuByUserName', {});
		
		me.getRegItems()['ContextMenuByUserName'] = contextMenuByUserName;
		contextMenuByUserName.getRegItems()['ParentContainer'] = me				
		
		me.callParent(); 
	},
	listeners : {
		render: function(grid, eOpts){
			docCGrid = grid;
		},
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin(NBOX_C_READ, record.data.DocumentID);
        	}
        },
        cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
        	if(cellIndex == 1){
        		var me = this;
        		
        		contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
        		
        		contextMenuByUserName.getRegItems()['UserID'] = record.data.DraftUserID;
        		contextMenuByUserName.showAt(e.getXY());
	        	e.preventDefault();	
        	}
        }         
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.changeTitle();
   				}
   			}
		});
	},
	selectPrevious: function(keepExisting, suppressEvent) {
		//alert('준비중입니다.');
    },
    selectNext: function(keepExisting, suppressEvent) {
    	//alert('준비중입니다.');
    },
	changeTitle: function(){
    	var me = this;
    	var stroe = me.getStore();
    	
    	var panel = me.getRegItems()['ParentContainer'];
    	var cnt = stroe.getCount();
    	
    	panel.setTitle('참조(' + String(cnt) + ')');
    },
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openDocDetailWin(me, actionType, documentID, '', 'XA006');
    }
    
});

/* DRAFT PANEL */
Ext.define('nbox.main.groupwareContentsDocD', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '기안',
	
	initComponent: function () {
		var me = this;

		var groupwareContentsDocDGrid = Ext.create('nbox.main.groupwareContentsDocDGrid', {});
		
		me.getRegItems()['GroupwareContentsDocDGrid'] = groupwareContentsDocDGrid;
		groupwareContentsDocDGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsDocDGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsDocDGrid = me.getRegItems()['GroupwareContentsDocDGrid'];
		
		groupwareContentsDocDGrid.queryData();
	}
});

/* NOSIGN PANEL */
Ext.define('nbox.main.groupwareContentsDocA', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '미결',
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsDocAGrid = Ext.create('nbox.main.groupwareContentsDocAGrid', {});
		
		me.getRegItems()['GroupwareContentsDocAGrid'] = groupwareContentsDocAGrid;
		groupwareContentsDocAGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsDocAGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsDocAGrid = me.getRegItems()['GroupwareContentsDocAGrid'];
		
		groupwareContentsDocAGrid.queryData();
	}
});

/* RCV PANEL */
Ext.define('nbox.main.groupwareContentsDocB', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '수신',
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsDocBGrid = Ext.create('nbox.main.groupwareContentsDocBGrid', {});
		
		me.getRegItems()['GroupwareContentsDocBGrid'] = groupwareContentsDocBGrid;
		groupwareContentsDocBGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsDocBGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsDocBGrid = me.getRegItems()['GroupwareContentsDocBGrid'];
		
		groupwareContentsDocBGrid.queryData();
	}
});

/* REF PANEL */
Ext.define('nbox.main.groupwareContentsDocC', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '참조',
	
	/*tools:[{
	    type:'refresh',
	    tooltip: 'Refresh form Data',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],	*/	
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsDocCGrid = Ext.create('nbox.main.groupwareContentsDocCGrid', {});
		
		me.getRegItems()['GroupwareContentsDocCGrid'] = groupwareContentsDocCGrid;
		groupwareContentsDocCGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsDocCGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsDocCGrid = me.getRegItems()['GroupwareContentsDocCGrid'];
		
		groupwareContentsDocCGrid.queryData();
	}
});

/* DOC TAB PANEL */
Ext.define('nbox.main.groupwareContentsDocTab', {
	extend: 'Ext.tab.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	/*tools:[{
	    type:'refresh',
	    tooltip: 'Refresh form Data',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],*/		
	
	tabPosition : 'bottom',
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsDocD = Ext.create('nbox.main.groupwareContentsDocD', {});
		var groupwareContentsDocA = Ext.create('nbox.main.groupwareContentsDocA', {});
		var groupwareContentsDocB = Ext.create('nbox.main.groupwareContentsDocB', {});
		var groupwareContentsDocC = Ext.create('nbox.main.groupwareContentsDocC', {});
		
		me.getRegItems()['GroupwareContentsDocD'] = groupwareContentsDocD;
		groupwareContentsDocD.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDocA'] = groupwareContentsDocA;
		groupwareContentsDocA.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDocB'] = groupwareContentsDocB;
		groupwareContentsDocB.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDocC'] = groupwareContentsDocC;
		groupwareContentsDocC.getRegItems()['ParentContainer'] = me;
	
		me.items = [groupwareContentsDocD,groupwareContentsDocA,groupwareContentsDocB,groupwareContentsDocC];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsDocD = me.getRegItems()['GroupwareContentsDocD'];
		var groupwareContentsDocA = me.getRegItems()['GroupwareContentsDocA'];
		var groupwareContentsDocB = me.getRegItems()['GroupwareContentsDocB'];
		var groupwareContentsDocC = me.getRegItems()['GroupwareContentsDocC'];
		
		groupwareContentsDocD.queryData();
		groupwareContentsDocA.queryData();
		groupwareContentsDocB.queryData();
		groupwareContentsDocC.queryData();	
	}
});

/* DOC PANEL */
Ext.define('nbox.main.groupwareContentsDoc', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsDoc',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '2 0 0 0',
	
	layout:{
		type: 'vbox',
		align: 'stretch'
	},
	
	title: '전자결재',
	
	tools:[{
	    type:'refresh',
	    tooltip: '새로고침',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],	
	
	initComponent: function () {
		var me = this;
		
		/*var title = '전자결재';
		var type = 3;
		
		var html = '';
		html += '<table style="background-color:#d9e7f8;" width="100%">'
		html += '	<tr>';
		html += '		<td width="90%">';
		html += '			<label>' + title + '</label>';
		html += '		</td>';
		html += '		<td width="10%" align="right">';
		html += '			<img src = "' + CPATH + '/resources/images/nbox/main/refresh16a.png" width=15 height=15" onClick="panelRefresh('+ type +')" style="cursor: pointer;" />';
		html += '		</td>'			
		html += '	</tr>';
		html += '</table>';
		
		var title = {
            xtype: 'container',
            cls: 'nbox-contentTitle',
            html: html,
            padding: '0 0 0 0',
            height: 25,
            region:'north',
            style: {
        		'border-bottom': '1px solid #C0C0C0'
        	},
        	listeners: {
        		render: function(container, eOpts){
        			container.el.on('click', function() {
        		    	me.queryData();
        			});
        		}
        	}
        };*/
		
		var groupwareContentsDocTab = Ext.create('nbox.main.groupwareContentsDocTab', {
			flex: 1
		});
		
		me.getRegItems()['GroupwareContentsDocTab'] = groupwareContentsDocTab;
		groupwareContentsDocTab.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title,*/ groupwareContentsDocTab];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsDocTab = me.getRegItems()['GroupwareContentsDocTab'];
		
		groupwareContentsDocTab.queryData();
	}
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
function openDetailWinDocA(documentId){
	if( typeof docAGrid != 'undefined' )
		docAGrid.openDetailWin(NBOX_C_READ, documentId, null);
}

function openDetailWinDocB(documentId){
	if( typeof docBGrid != 'undefined' )
		docBGrid.openDetailWin(NBOX_C_READ, documentId, null);
}

function openDetailWinDocB(documentId){
	if( typeof docCGrid != 'undefined' )
		docCGrid.openDetailWin(NBOX_C_READ, documentId, null);
}

function openDetailWinDocD(documentId){
	if( typeof docDGrid != 'undefined' )
		docDGrid.openDetailWin(NBOX_C_READ, documentId, null);
}