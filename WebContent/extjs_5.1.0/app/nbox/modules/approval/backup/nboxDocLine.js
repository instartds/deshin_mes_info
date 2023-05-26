
	/**************************************************
	 * Common variable
	 **************************************************/

	
	/**************************************************
	 * Common Code
	 **************************************************/
		
	
	/**************************************************
	 * Model
	 **************************************************/
	//Doc Line List
	Ext.define('nbox.docLineEditModel', {
	    extend: 'Ext.data.Model',
	    fields: [
 			{name: 'DocumentID'},
			{name: 'LineType'},
			{name: 'Seq'},
			{name: 'SignType'},
			{name: 'SignTypeName'},
			{name: 'SignUserID'},
			{name: 'SignUserName'},
			{name: 'SignUserDeptName'},
			{name: 'SignUserPosName'} ,
			{name: 'SignDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
			{name: 'SignImgUrl'},
			{name: 'SignFlag'},
			{name: 'LastFlag'},
			{name: 'FormName'},
	    	{name: 'DoubleLineFirstFlag'}
	    ]	    
	});	

	/**************************************************
	 * Store
	 **************************************************/
	//DocLine List
	Ext.define('nbox.docLineStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.docLineEditModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: { read: 'nboxDocLineService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        },
        copyData: function(store){
        	var me = this;
        	var records = [];
        	
        	store.each(function(r){
        		r = me.exceptionData(r);
    			records.push(r.copy());
    		});
    		
    		me.add(records);
        },
        exceptionData: function(record){
        	var me = this;
        	
        	if(record.data.LineType == 'B'){
        		record.data.SignTypeName = '이중결재';
        	}
        	
        	if(record.data.SignType == 1){
        		record.data.SignTypeName = '합의';
        	}
        	
        	return record;
        } 
	});		
	 
		
	/**************************************************
	 * Define
	 **************************************************/
	//DocLine List
	Ext.define('nbox.editDocLineView',{
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
						'<td style="padding:0px; border-right-width:1px;border-bottom-width:1px;">',
							'<tpl for=".">',	
								'<div style="float:left; border:1px solid #C0C0C0; width:85px; height:45px; margin-top:5px; margin-left:0px;margin-right:5px; margin-bottom:5px; padding-left:0px; text-align:center;">',
									'<span class="f9pt">{SignUserPosName}</span>',
									'<br />',
									'<span class="f9pt">{SignUserName}</span>',
									'<br />',
									'<span class="f9pt">&#91;{SignTypeName}&#93;</span>',
								'</div>',
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
	   		
	   		var documentID = null;
	   		var actionType = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ActionType'];
			switch (actionType){
				case NBOX_C_CREATE:
					break;
				case NBOX_C_UPDATE:
					documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
					break;
				default:
					break;
			}
	   		
	   		store.proxy.setExtraParam('DocumentID', documentID);
	   		store.proxy.setExtraParam('CPATH', CPATH);
	   		
			store.load({
				callback: function(records, operation, success) {
	   				if (success){
	   					me.loadData();
	   				}
	   			}
			});
	   	},
	   	confirmData: function(tempStore){
    		var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    		store.copyData(tempStore);
    		
    		me.refresh();
    	}, 
	   	clearData: function(){
	   		var me = this;
	   		
	   		me.clearPanel();
	   	},
	    loadData: function(){
	    	
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
