/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docDetailViewFileModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'FID'},
    	{name: 'DocumentID'},
    	{name: 'UploadFileName'},
    	{name: 'UploadFileExtension'},
    	{name: 'UploadFileIcon'},
    	{name: 'FileSize', type: 'number'},
    	{name: 'UploadContentType'},
    	{name: 'IMG_FLG'},
    	{name: 'UploadPath'},
    	{name: 'CompanyID'}
    ]	    
});	

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docDetailViewFileStore',{
	extend: 'Ext.data.Store', 
	model: 'nbox.docDetailViewFileModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocListService.selectFiles' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docDetailViewFile',{
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
						'<span style="color:#666666; font-size:12px;">첨부파일:&nbsp;&nbsp;</span>',
					'</td>',
					'<td style="border:1px;">',
						'<div class="nbox-files-div">',
					        '<tpl for=".">', 
					            '<span class="nbox-feed-sel-item">',
						            '<img src="' + NBOX_IMAGE_PATH + 'Ext/{UploadFileIcon}" style="vertical-align: middle;" width="14" height="14" />',
						            '&nbsp;<label>{UploadFileName}</label>',
						            '&nbsp;<label>&#40;{[fm.number(values.FileSize, "0,000.00")]}&nbsp;MB&#41;</label>',
					            '</span>',
					            '{[xindex === xcount ? "<span></span>" : "<span>&nbsp;&nbsp;&nbsp;</span>"]}',
					        '</tpl>',
				        '</div>',
			    	'</td>',
				'</tr>',
	       	'</table>'			
		); 
		
		me.callParent();
	},		
    listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	window.open (CPATH + '/nboxfile/docdownload/' + record.data.FID);
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
				if (success)
					me.loadPanel();
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