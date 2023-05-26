/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
//Doc Basis Model
Ext.define('nbox.docDetailViewBasisModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'DocumentID'},
		{name: 'Seq'},
		{name: 'RefDocumentID'},
		{name: 'RefDocumentNo'}
    ]	    
});	

/**************************************************
 * Store
 **************************************************/
// Doc Basis Store
Ext.define('nbox.docDetailViewBasisStore', {
	extend: 'Ext.data.Store', 
	model: 'nbox.docDetailViewBasisModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocBasisService.selectByDoc' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

/**************************************************
 * Define
 **************************************************/
// Doc Basis
Ext.define('nbox.docDetailViewBasis',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	loadMask:false,
    
	cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item',
    
    padding: '0 0 5 0',
    
    width: '100%',
    
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" border="0" style="padding:3px 5px 0px 5px; width:100%;">',
				'<tr>',
					'<td align="right" width="105">',
						'<span style="color:#666666; font-size:12px;">근거문서:&nbsp;&nbsp;</span>',
					'</td>',
					'<td style="padding:5px; border:1px;">',
						'<tpl for=".">', 
							'<span class="nbox-feed-sel-item">',
								'&#91;{RefDocumentNo}&#93;',
				            '</span>',
				       	'</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>'
		); 
		
		me.callParent();
	},		
    listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	openDocPreviewWin(record.data.RefDocumentID);
    	}
    },
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		
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
		
		store.removeAll();
	},
    loadPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() == 0)
    		me.hide(); 
    	else
    		me.show();
    }
});	 

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/