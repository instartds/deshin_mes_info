/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsNoticeModel', {
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
Ext.define('nbox.main.groupwareContentsNoticeStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsNoticeModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {PARENT_PGM_ID: '1000'},
		        api   : {
		        			read: 'groupwareContentsService.selectBoard' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsNoticeStore = Ext.create('nbox.main.groupwareContentsNoticeStore', {});

/**************************************************
 * Define
 **************************************************/

/* NOTICE GRID */
Ext.define('nbox.main.groupwareContentsNoticeGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask: false,
	
	store: groupwareContentsNoticeStore,
	
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
	            	
	            	return "<a onclick='return openDetailWinNotice(\"" + noticeId + "\", \"" + prgId +"\")'>" + value + "</a>"
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
			noticeGrid = grid;
		},
    	itemdblclick: function(gird, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.noticeid, record.data.prgID);
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
    queryDetailData: function(){
    	//alert('준비중입니다.');
    },	
    openDetailWin: function(actionType, noticeID, menuID){
    	var me = this;
    	
    	openBoardDetailWin(me, actionType, noticeID, menuID);
    }	
});


/* NOTICE PANEL */
Ext.define('nbox.main.groupwareContentsNotice', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsNotice',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '공지사항',
	
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
		
		/*var title = '공지사항';
		var type = 1;
		
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
        		'border': '1px solid #C0C0C0',
        		'background-color': '#d9e7f8'
        	},
        	listeners: {
        		render: function(container, eOpts){
        			container.el.on('click', function() {
        		    	me.queryData();
        			});
        		}
        	}
        };*/
		
		var groupwareContentsNoticeGrid = Ext.create('nbox.main.groupwareContentsNoticeGrid', {});
		
		me.getRegItems()['GroupwareContentsNoticeGrid'] = groupwareContentsNoticeGrid;
		groupwareContentsNoticeGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title, */groupwareContentsNoticeGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwareContentsNoticeGrid = me.getRegItems()['GroupwareContentsNoticeGrid'];
		
		groupwareContentsNoticeGrid.queryData();
	}

});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
function openDetailWinNotice(noticeId, prgId){
	if( typeof noticeGrid != 'undefined' )
		noticeGrid.openDetailWin(NBOX_C_READ, noticeId, prgId);
}