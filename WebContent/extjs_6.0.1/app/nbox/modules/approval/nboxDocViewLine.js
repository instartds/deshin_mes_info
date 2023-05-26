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
Ext.define('nbox.docDetailViewLineModel', {
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
		{name: 'SignUserPosName'},
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
//DoubleLine List
Ext.define('nbox.docDetailViewDoubleLineStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewLineModel',
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
			records.push(r.copy());
		});
		
		me.add(records);
    }
});	


//DocLine List SignType = 'A'
Ext.define('nbox.docDetailViewLineStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewLineModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocLineService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

//DocLine List SignType = 'B'
Ext.define('nbox.docDetailViewBLineStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewLineModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocLineService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});

/**************************************************
 * Define
 **************************************************/
//DoubleLine List
/*
Ext.define('nbox.docDetailViewDoubleLine',{
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
			'<table cellpadding="3" cellspacing="0" border="0" width="100%">',
				'<tr>',
					'<td align="right">',
						'<table style="border:1px solid #C0C0C0;">',
							'<tr>',
								'<td>',
									'<div style="width:20px; height:95px; border:1px solid #C0C0C0; text-align:center; vertical-align:middle;">',
										'<span class="f9pt" style="color:#666666; font-weight:bold;"><br />관<br />리<br />부<br />서</span>',
									'</div>',
								'</td>',
			  					'<td>',
			  						'<table cellpadding="3" cellspacing="0" border="0">',
			  							'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
							  						'<div style="color:#666666; font-weight:bold;">',
										            	'<label class="f9pt">{SignUserPosName}</label>',
										            '</div>',
										            '<div style="color:#666666; font-weight:bold;">',
			            								'<label class="f9pt">&#91;{SignTypeName}&#93;</label>',
			        								'</div>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
								       	'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border-left:1px solid #C0C0C0; border-right:1px solid #C0C0C0;">',
							  						'<img src="{SignImgUrl}" style="height:30px;width:30px;" title="{SignUserPosName}\n&#91;{SignTypeName}&#93;\n{SignUserName}"/>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
								       	'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
							  						'<div style="color:#666666; ">',
							  							'<tpl if="values.SignDate != null">',
										            		'<label>{[fm.date(values.SignDate, "Y-m-d")]}</label>',
										            	'<tpl else>',
										            		'<label>&nbsp;</label>',
										            	'</tpl>',
										            '</div>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
							        '</table>',
				        		'</td>',
				        	'</tr>',
				        '</table>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'B');
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
		
		me.saveData();
		me.refresh();
		
	},
	saveData: function(){
		var me = this;
		var store = me.getStore();
		
		var nboxDocDetailViewLine = Ext.getCmp('nboxDocDetailViewLine')
		var docLineCount = nboxDocDetailViewLine.getStore().getCount();
		
		var doublelinelist = []; 
		var doublelines = store.data.items;
		Ext.each(doublelines,function(record){
			doublelinelist.push(me.JSONtoString(record.data)); 
		});
		
		if (doublelinelist.length == 0) doublelinelist = null;
		
		documentID = docDetailWin.getRegItems()['DocumentID'];
		
		var param = {
			'DocumentID': documentID,
			'Length': docLineCount + doublelinelist.length,
			'DOBULELINE[]': doublelinelist
		}
		
		nboxDocLineService.saveDoubleLine(param, 
			function(provider, response) {
				// 성공  메시지 ?
			}
		);
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
	},
	JSONtoString: function (object, columns) {
        var results = [];
        
        if(columns != null){
        	for(var colunmn in columns) {
	            var value = object[columns[colunmn]];
	            if (value)
	                results.push('\"' + columns[colunmn].toString() + '\": \"' + value + '\"');
	        }
        }
        else{
        	for(var property in object) {
	            var value = object[property];
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	        }
        }
                     
        return '{' + results.join(String.fromCharCode(11)) + '}';
    }
});	 
*/
Ext.define('nbox.docDetailViewDoubleLine',{
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
				'<table cellpadding="0" cellspacing="0" border="0" style="padding: 0px 5px 0px 5px; width:100%;">',
				'<tr>',
				'<tpl for=".">',
					'<td>',
						'<table cellpadding="3" cellspacing="0" border="0">',
							'<tr>',
								'<td>',
									'<div style="color:#666666; font-size:12px;">',
										'<label>{SignTypeName}</label>',
									'</div>',
								'</td>',
								'<td>',
									'<div style="color:#666666; font-size:12px;">',
					       			'<tpl if="values.SignDate != null">',
					       				'<label>{[fm.date(values.SignDate, "Y-m-d")]}</label>',
					       			'<tpl else>',
					       				'<label>&nbsp;</label>',
					       			'</tpl>',
					       			'</div>',
								'</td>',
							'</tr>',
							'<tr>',
								'<td>',
									'<div style="color:#666666; font-size:12px;">',
										'<label>{SignUserPosName}</label>',
									'</div>',
								'</td>',
								'<td>',
									'<div style="color:#666666; font-size:12px;">',
										'<label>{SignUserName}</label>',
									'</div>',
								'</td>',
							'</tr>',
						'</table>',
		       		'</td>',
		       	'</tpl>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxBaseApp.getDocumentID();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'B');
		store.proxy.setExtraParam('SignType', 'A');
		store.proxy.setExtraParam('CPATH', CPATH);
		
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
		
		me.clearPanel();
	},
	loadPanel: function(){
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
	},
	JSONtoString: function (object, columns) {
        var results = [];
        
        if(columns != null){
        	for(var colunmn in columns) {
	            var value = object[columns[colunmn]];
	            if (value)
	                results.push('\"' + columns[colunmn].toString() + '\": \"' + value + '\"');
	        }
        }
        else{
        	for(var property in object) {
	            var value = object[property];
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	        }
        }
                     
        return '{' + results.join(String.fromCharCode(11)) + '}';
    }
});	

//DocLine List
/*
Ext.define('nbox.docDetailViewLine',{
	
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
			'<table cellpadding="3" cellspacing="0" border="0" width="100%">',
				'<tr>',
					'<td align="center">',
						'<tpl for=".">',
							'<tpl if="xindex == \'1\'">',
								'<span style="font-size:35px; color:#666666; font-weight:bold;">{FormName}</span>',
							'</tpl>',
						'</tpl>',
					'</td>',
					'<td align="right">',
						'<table style="border:1px solid #C0C0C0;">',
							'<tr>',
								'<td>',
									'<div style="width:20px; height:95px; border:1px solid #C0C0C0; text-align:center; vertical-align:middle;">',
										'<span class="f9pt" style="color:#666666; font-weight:bold;"><br />실<br />무<br />부<br />서</span>',
									'</div>',
								'</td>',
			  					'<td>',
			  						'<table cellpadding="3" cellspacing="0" border="0">',
			  							'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
							  						'<div style="color:#666666; font-weight:bold;">',
										            	'<label class="f9pt">{SignUserPosName}</label>',
										            '</div>',
										            '<div style="color:#666666; font-weight:bold;">',
			            								'<label class="f9pt">&#91;{SignTypeName}&#93;</label>',
			        								'</div>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
								       	'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border-left:1px solid #C0C0C0; border-right:1px solid #C0C0C0;">',
							  						'<img src="{SignImgUrl}" style="height:30px;width:30px;" title="{SignUserPosName}\n&#91;{SignTypeName}&#93;\n{SignUserName}"/>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
								       	'<tr>',
											'<tpl for=".">', 
												'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
							  						'<div style="color:#666666; ">',
							  							'<tpl if="values.SignDate != null">',
										            		'<label>{[fm.date(values.SignDate, "Y-m-d")]}</label>',
										            	'<tpl else>',
										            		'<label>&nbsp;</label>',
										            	'</tpl>',
										            '</div>',
									       		'</td>',
									       	'</tpl>',
								       	'</tr>',
							        '</table>',
				        		'</td>',
				        	'</tr>',
				        '</table>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
		store.proxy.setExtraParam('CPATH', CPATH);
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
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
    loadPanel: function(){
    	
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});	
*/

Ext.define('nbox.docDetailViewLine',{
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
			'<table cellpadding="0" cellspacing="0" border="0" style="padding: 0px 5px 0px 5px; width:100%;">',
				'<tr>',
				'<tpl for=".">',
					'<td>',
						'<table cellpadding="3" cellspacing="0" border="0">',
							'<tr>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignTypeName}</label>',
									'</span>',
								'</td>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
					       			'<tpl if="values.SignDate != null">',
					       				'<label>{[fm.date(values.SignDate, "Y-m-d")]}</label>',
					       			'<tpl else>',
					       				'<label>&nbsp;</label>',
					       			'</tpl>',
					       			'</span>',
								'</td>',
							'</tr>',
							'<tr>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignUserPosName}</label>',
									'</span>',
								'</td>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignUserName}</label>',
									'</span>',
								'</td>',
							'</tr>',
						'</table>',
		       		'</td>',
		       	'</tpl>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxBaseApp.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
		store.proxy.setExtraParam('SignType', 'A');
		store.proxy.setExtraParam('CPATH', CPATH);
		
		store.load({callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
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
    loadPanel: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});

Ext.define('nbox.docDetailViewBLine',{
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
			'<table cellpadding="0" cellspacing="0" border="0" style="padding: 0px 5px 0px 5px; width:100%;">',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">',
							'<label>협조자&nbsp;</label>',
						'</span>',
					'</td>',
					'<tpl for=".">',
					'<td>',
						'<table cellpadding="3" cellspacing="0" border="0">',
							'<tr>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignTypeName}</label>',
									'</span>',
								'</td>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
					       			'<tpl if="values.SignDate != null">',
					       				'<label>{[fm.date(values.SignDate, "Y-m-d")]}</label>',
					       			'<tpl else>',
					       				'<label>&nbsp;</label>',
					       			'</tpl>',
					       			'</span>',
								'</td>',
							'</tr>',
							'<tr>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignUserPosName}</label>',
									'</span>',
								'</td>',
								'<td>',
									'<span style="color:#666666; font-size:12px;">',
										'<label>{SignUserName}</label>',
									'</span>',
								'</td>',
							'</tr>',
						'</table>',
		       		'</td>',
		       		'</tpl>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxBaseApp.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
		store.proxy.setExtraParam('SignType', 'B');
		store.proxy.setExtraParam('CPATH', CPATH);
		
		store.load({callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
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
    loadPanel: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});
/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	