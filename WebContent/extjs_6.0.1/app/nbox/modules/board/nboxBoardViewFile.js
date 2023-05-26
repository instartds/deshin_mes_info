/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	

/**************************************************
 * Model
 **************************************************/
//File List
Ext.define('nbox.boardViewFileModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'FID'},
    	{name: 'NOTICEID'},
    	{name: 'UPLOADFILENAME'},
    	{name: 'UPLOADFILEEXTENSION'},
    	{name: 'UPLOADFILEICON'},
    	{name: 'FILESIZE', type: 'number'},
    	{name: 'UPLOADCONTENTTYPE'},
    	{name: 'UPLOADPATH'},
    	{name: 'COMPANYID'}
    ]	    
});	

/**************************************************
 * Store
 **************************************************/
//Files Store
Ext.define('nbox.boardViewFilesStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardViewFileModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxBoardService.selectFiles' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

/**************************************************
 * Define
 **************************************************/
//File List
Ext.define('nbox.boardViewFiles',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	style: {
		'padding': '5px 5px 5px 5px'					
	},
	
	loadMask:false,
    
	cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
	initComponent: function () {
		var me = this;
		me.tpl = new Ext.XTemplate(
	  		'<div style="border: 1px solid #C0C0C0; padding: 5px 5px 5px 5px;">',
		        '<tpl for=".">', 
		            '<span class="nbox-feed-sel-item">',
			            '<img src="' + NBOX_IMAGE_PATH + 'Ext/{UPLOADFILEICON}" style="vertical-align: middle;" width="14" height="14" />',
			            '&nbsp;<label>{UPLOADFILENAME}</label>',
			            '&nbsp;<label>&#40;{[fm.number(values.FILESIZE, "0,000.00")]}&nbsp;MB&#41;</label>',
		            '</span>',
		            '{[xindex === xcount ? "<span></span>" : "<span>&nbsp;&nbsp;&nbsp;</span>"]}',
		        '</tpl>',
	        '</div>'
		); 
		
		me.callParent();
	},		
    listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	 window.open (CPATH + '/nboxfile/boarddownload/' + record.data.FID);
    	}
    },
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var noticeID = win.getRegItems()['NoticeID'];
		
		me.clearData();
		
		store.proxy.setExtraParam('NOTICEID', noticeID);
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
		var store = me.getStore();
		
		me.clearPanel();
		
		store.removeAll();
	},
    loadPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if( store.getCount() > 0 )
    		me.show();
    	else
    		me.hide();
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