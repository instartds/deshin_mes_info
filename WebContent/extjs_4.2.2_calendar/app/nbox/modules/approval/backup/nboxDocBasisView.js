
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
	Ext.define('nbox.docBasisViewModel', {
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
	Ext.define('nbox.docBasisViewStore', {
		extend: 'Ext.data.Store', 
		model: 'nbox.docBasisViewModel',
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
	Ext.define('nbox.docBasis',{
		extend: 'Ext.view.View',
		config: {
			regItems: {}
		},
		loadMask:false,
	    cls: 'nbox-feed-list',
        itemSelector: '.nbox-feed-sel-item',
	    selectedItemCls: 'nbox-feed-seled-item', 
	    width: '100%',
		initComponent: function () {
			var me = this;
			
			me.tpl = new Ext.XTemplate(
				'<table cellpadding="0" cellspacing="0" width="100%" border="0" >',
					'<tr>',
						'<td align="right" style="color:#666666; font-weight:bold;" width="105">',
							'<label width="100%" class="f9pt">근거문서:&nbsp;</label>',
						'</td>',
						'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
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
            	openPreviewWin(record.data.RefDocumentID);
        	}
        },
        queryData: function(){
    		var me = this;
    		var store = me.getStore();
    		var documentID;
			
    		me.clearData();
    		
    		documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
    		store.proxy.setExtraParam('DocumentID', documentID);
    		
   			store.load({
   				callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	clearData: function(){
    		var me = this;
    		
    		me.clearPanel();
    	},
        loadData: function(){
        	var me = this;
        	var store = me.getStore();
        	
        	if (store.getCount() == 0)
        		me.hide(); 
        	else
        		me.show();
        },
        clearPanel: function(){
    		var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    	}
	});	 	
	
    /**************************************************
	 * User Define Function
	 **************************************************/
