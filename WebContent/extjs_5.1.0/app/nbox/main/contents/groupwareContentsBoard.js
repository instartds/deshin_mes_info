/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsBoardModel', {
    extend: 'Ext.data.Model',
    fields: [
    	 {name: 'title'} 
    	,{name: 'subject'}
    	,{name: 'loaddate', type: 'date', dateFormat:'Y-m-d'}
    	,{name: 'noticeid'}
    	,{name: 'userid'}
    	,{name: 'username'}
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
Ext.define('nbox.main.groupwareContentsBoardStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsBoardModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {PARENT_PGM_ID: '2000'},
		        api   : {
		        			read: 'groupwareContentsService.selectBoard' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsBoardStore = Ext.create('nbox.main.groupwareContentsBoardStore', {});
/**************************************************
 * Define
 **************************************************/
/* BOARD GRID */
Ext.define('nbox.main.groupwareContentsBoardGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsBoardStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{ text: 'title',  dataIndex: 'title'},
	        { 
	        	text: 'subject', 
	        	dataIndex: 'subject', 
	        	flex: 1,
	        	renderer : function(value, metadata) {
	        		var noticeId = metadata.record.data.noticeid;
	        		var prgId = metadata.record.data.prgID;
	            	
	            	if (value.substring(0,1) == '0') 
                        value = '<b>' + value.substring(1) + '</b>';
                    else
                    	value = value.substring(1) ;
	            	
	            	return "<a onclick='return openDetailWinBoard(\"" + noticeId + "\", \"" + prgId +"\")'>" + value + "</a>"
            	}
	        },
	        { text: 'username',  dataIndex: 'username', width: 100},
	        { xtype: 'datecolumn', text: 'loaddate', dataIndex: 'loaddate', format: 'Y-m-d'}
		];		
		
		var contextMenuByUserName = Ext.create('nbox.contextMenuByUserName', {});
		
		me.getRegItems()['ContextMenuByUserName'] = contextMenuByUserName;
		contextMenuByUserName.getRegItems()['ParentContainer'] = me;
		
		me.callParent(); 
	},
	listeners : {
		render: function(grid, eOpts){
			boardGrid = grid;
		},
    	itemdblclick: function(grid, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin(NBOX_C_READ, record.data.noticeid, record.data.prgID);
        	}
        },
        cellcontextmenu: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
        	if(cellIndex == 2){
        		var me = this;
        		
        		contextMenuByUserName = me.getRegItems()['ContextMenuByUserName'];
        		
        		contextMenuByUserName.getRegItems()['UserID'] = record.data.userid;
        		contextMenuByUserName.showAt(e.getXY());
	        	e.preventDefault();	
        	}
        }
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
	selectPrevious: function(keepExisting, suppressEvent) {
		//alert('준비중입니다.');
    },
    selectNext: function(keepExisting, suppressEvent) {
    	//alert('준비중입니다.');
    },
	openDetailWin: function(actionType, noticeID, menuID){
    	var me = this;
    	
    	openBoardDetailWin(me, actionType, noticeID, menuID);
    }	
});


/* BOARD PANEL */
Ext.define('nbox.main.groupwareContentsBoard', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsBoard',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '2 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '게시판',
	
	tools:[{
	    type:'refresh',
	    tooltip: 'Refresh form Data',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],	
	
	initComponent: function () {
		var me = this;
		
		/*var title = '게시판';
		var type = 2;
		
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
            height: 20,
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
		
		var groupwareContentsBoardGrid = Ext.create('nbox.main.groupwareContentsBoardGrid', {});
		
		me.getRegItems()['GroupwareContentsBoardGrid'] = groupwareContentsBoardGrid;
		groupwareContentsBoardGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title, */groupwareContentsBoardGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsBoardGrid = me.getRegItems()['GroupwareContentsBoardGrid'];
		
		groupwareContentsBoardGrid.queryData();
	}
});


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
function openDetailWinBoard(noticeId, prgId){
	if( typeof boardGrid != 'undefined' )
		boardGrid.openDetailWin(NBOX_C_READ, noticeId, prgId);
}