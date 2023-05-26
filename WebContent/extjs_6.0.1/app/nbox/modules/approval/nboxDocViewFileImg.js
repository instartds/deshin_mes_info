/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	

/**************************************************
 * Model
 **************************************************/

/**************************************************
 * Store
 **************************************************/

/**************************************************
 * Define
 **************************************************/
//File List
Ext.define('nbox.docDetailViewFileImgs',{
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
	  		'<div style="border: 0px solid #C0C0C0; padding: 5px 5px 5px 5px;">',
		        '<tpl for=".">', 
		            '<span class="nbox-feed-sel-item">',
	            		'<tpl if="IMG_FLG == 1">',
	            			'&nbsp;<label>{UPLOADFILENAME}</label></br>',
		            		'<img src="/nboxfile/docdownload/{FID}" />',
		    		    '</tpl>',
		            '</span>',
		        '</tpl>',
	        '</div>'
		); 
		
		me.callParent();
	},
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
	/*	
		store.proxy.setExtraParam('DocumentID', documentID);
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
		*/
		me.loadPanel();
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