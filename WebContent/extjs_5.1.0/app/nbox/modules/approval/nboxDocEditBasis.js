/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 650;

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docEditBasisModel', {
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
Ext.define('nbox.docEditBasisStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditBasisModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocBasisService.selectByDoc' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    copyData: function(store){
    	var me = this;
    	var records = [];
    	
    	store.each(function(r){
			records.push(r.copy());
		});
		
		me.add(records);
    }
});	

/**************************************************
 * Define
 **************************************************/
//DocBasis List
Ext.define('nbox.docEditBasisView',{
	extend: 'Ext.view.View',
	id: 'docEditBasisView',
	config: {
		regItems: {}
	},
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: docControlPanelWidth - 27,
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
				'<tr>',
					'<td style="border:0px; padding:3px; width:95px; text-align:right">',
						'<label>근거문서:</label>',
					'</td>',
					'<td style="border:0px; width:4px; text-align:right">',
					'</td>',	
					'<td class="nboxDocEditBasisTd"">',
						'<span class="f9pt">&nbsp;</span>',
						'<tpl for=".">',
							'<span class="f9pt">',
								'<div class="nboxDocEditBasisDiv" onclick="deleteDocEditBasis({[xindex]})">',
									'&#91;{RefDocumentNo}&#93;',
									'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
								'</div>',
							'</span>',
			            '</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
    	var me = this;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
   		var documentID = win.getRegItems()['DocumentID'];
		
   		store.proxy.setExtraParam('DocumentID', documentID);
		store.load();    	
   	},
   	deleteData: function(rowIndex){
   		var me = this;
   		var store = me.getStore();
   		
   		var record = store.getAt(rowIndex);
		store.remove(record);
   		
   		me.refresh();
   	}, 
   	clearData: function(){
   		var me = this;
   		var store = me.getStore();
   		
   		store.removeAll();
   	}
});	

//RefUser Panel
Ext.define('nbox.docEditBasisPanel', { 
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},
	padding: '0px 0px 3px 3px',

	border: false,
	
	initComponent: function () {
		var me = this;
		
		var docEditBasisStore = Ext.create('nbox.docEditBasisStore', {});
		
		var docEditBasisView = Ext.create('nbox.docEditBasisView',{
			store: docEditBasisStore
		});
		
		var btn =  {	
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popup.png" width=13 height=13/>',
		    itemId: 'btnrcvuser',
		    style: 'width:26px; height:23px; margin-top:3px; margin-right:3px; padding-left:0px;',
		    handler: function() {
		    	me.buttonDown();
		    }
		};			
		
		me.items = [ docEditBasisView, btn ] ;
		
		me.getRegItems()['DocEditBasisView'] = docEditBasisView;
		docEditBasisView.getRegItems()['ParentContainer'] = me;
		            
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		var docEditBasisView = me.getRegItems()['DocEditBasisView']
   			
   		openDocBasisPopupWin(docEditBasisView);
	},
	queryData: function(){
		var me = this;
		var docEditBasisView = me.getRegItems()['DocEditBasisView'];
		
		docEditBasisView.queryData();
	},
	clearData: function(){
		var me = this;
		var docEditBasisView = me.getRegItems()['DocEditBasisView'];
    	
    	docEditBasisView.clearData();
    }
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
function deleteDocEditBasis(rowIndex){
	var docEditBasisView = Ext.getCmp('docEditBasisView');
	docEditBasisView.deleteData(rowIndex-1);
}
