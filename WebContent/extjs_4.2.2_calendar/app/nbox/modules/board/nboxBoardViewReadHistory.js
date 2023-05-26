/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.boardViewReadHisModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'UserName'}, 
    	{name: 'ReadCount', type: 'int'},
    	{name: 'LastReadDate'}
    ]
});	

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.boardViewReadHisStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardViewReadHisModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxBoardService.selectReadHis'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
  	initPage: function(currentPage, pageSize) {
        var me = this;

        me.currentPage = currentPage;
        me.pageSize = pageSize;
    }
});	

/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.boardViewReadHisGrid', {
	extend:	'Ext.grid.Panel',
	
	config:{
		regItems: {}
	},
	
	border: true,
    
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            text: '열람자',
	            dataIndex: 'UserName',
	            align: 'center',
	            width: 100
	        }, 
	        {
	            text: '열람횟수',
	            dataIndex: 'ReadCount',
	            align: 'center',
	            width: 70
	        }, 
	        {	
	            text: '최종열람일',
	            dataIndex: 'LastReadDate',
	            align: 'center',
	            flex: 1
	        }];
    
        var gridPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: 5,
	        displayInfo: true
    	});
		
		me.getRegItems()['GridPaging'] = gridPaging;
		me.dockedItems= [gridPaging];
		
		me.callParent(); 
    }
});	

//Read Count ToolTip 
Ext.define('nbox.boardViewReadHisToolTip',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
	loadMask:false,
	initComponent: function () {
		var me = this;
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer']; 
		var noticeID = win.getRegItems()['NoticeID'];
		
		me.clearData();
		
		store.proxy.setExtraParam('NOTICEID', noticeID);
		store.initPage(1, 5);
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
	},
	clearData: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		
		me.clearPanel();
		
		store.removeAll(); 
	},
	loadPanel: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		
		var boardViewReadHisGrid = Ext.create('nbox.boardViewReadHisGrid',{
			store: store
		});
		
		var targetControl = Ext.getCmp('boardViewReadCount');
		
		Ext.create('Ext.tip.ToolTip', {
     		target: targetControl.getId(),
     		width: 400, height:185,
     	    hideDelay: 1000000,
			layout: { 
				type:'fit'
			},
     	    items:[boardViewReadHisGrid]
     	});	
		
	},
	clearPanel: function(){
		
	}
}); 


/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	