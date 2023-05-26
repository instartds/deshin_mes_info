/**************************************************
 * Common variable
 **************************************************/
 var previewWin ;
 var previewWinWidth = 850;
 var previewWinHeight = 750;
 
 /**************************************************
 * Common Code
 **************************************************/

 /**************************************************
 * Model
 **************************************************/
//Detail View
Ext.define('nbox.previewDetailModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'DocumentNo'},
    	{name: 'FormName'}, 
    	{name: 'Subject'},
    	{name: 'Contents'},
    	{name: 'ViewContents'},
    	{name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'DraftUserName'},
    	{name: 'Slogan1'},
    	{name: 'Slogan2'},
    	{name: 'DraftFlag'},	
    	{name: 'SignFlag'},
    	{name: 'Status'},
    	{name: 'Logo'},    	
    	{name: 'Imge'},
    	{name: 'InnerApprovalFlag'},
    	{name: 'InputRcvUser'},
    	{name: 'InputRcvFlag'},
    	{name: 'InputRefUser'},
    	{name: 'InputRefFlag'},
    	{name: 'OpenFlag'}
    ]
});

//Doc Line List
Ext.define('nbox.previewDocLineModel', {
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
    ]	    
});	

//Doc Basis List
Ext.define('nbox.previewDocBasisModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'DocumentID'},
		{name: 'Seq'},
		{name: 'RefDocumentID'},
		{name: 'RefDocumentNo'}
    ]	    
});	

// RCV User List
Ext.define('nbox.previewRcvUserModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'},
    	{name: 'RcvType'},
    	{name: 'DeptType'},
    	{name: 'RcvUserID'}, 
    	{name: 'RcvUserName'}, 
    	{name: 'RcvUserDeptID'},
    	{name: 'RcvUserDeptName'},
    	{name: 'RcvUserPosName'},
    	{name: 'ReadDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'ReadChk'}
    ]
});

Ext.define('nbox.previewDivInfoModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'ZIP_CODE'},
    	{name: 'ADDR'},
    	{name: 'TELEPHON'},
    	{name: 'FAX_NUM'}, 
    	{name: 'EMAIL'}, 
    	{name: 'HTTP_ADDR'},
    	{name: 'SECUREGRADENAME'},
    	{name: 'OPENFLAGNAME'}
    ]
});


/**************************************************
 * Store
 **************************************************/	
//Detail View
Ext.define('nbox.previewDetailStore', {
    extend: 'Ext.data.Store', 
	model: 'nbox.previewDetailModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxDocListService.select'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});

//DoubleLine List
Ext.define('nbox.previewDoubleLineStore', {
    extend: 'Ext.data.Store', 
	model: 'nbox.previewDocLineModel',
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

//DocLine List SignType = 'A'
Ext.define('nbox.previewDocLineStore', {
    extend: 'Ext.data.Store', 
	model: 'nbox.previewDocLineModel',
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
Ext.define('nbox.previewDocBLineStore', {
    extend: 'Ext.data.Store', 
	model: 'nbox.previewDocLineModel',
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

//DocBasis List
Ext.define('nbox.previewDocBasisStore', {
    extend: 'Ext.data.Store', 
	model: 'nbox.previewDocBasisModel',
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

//REF User List
Ext.define('nbox.previewRefUsersStore', {
    extend:'Ext.data.Store', 
	model: 'nbox.previewRcvUserModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

//RCV User List
Ext.define('nbox.previewRcvUserStore', {
    extend:'Ext.data.Store', 
	model: 'nbox.previewRcvUserModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

//Div Infor
Ext.define('nbox.previewDivInfoStore', {
    extend:'Ext.data.Store', 
	model: 'nbox.previewDivInfoModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxCommonService.selectDivInfo' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

/**************************************************
 * Define
 **************************************************/
// Print Panel
Ext.define('nbox.printPanel', {
	extend: 'Ext.panel.Panel',
    config: {
    	regItems: {}
    },
    
    border: false,
    style:{
    	display: 'none'	
    },
    
    print: function(header, contents, footer) {
    	var me = this;

    	//instantiate hidden iframe
        var iFrameId = "printerFrame";
        var printFrame = Ext.DomHelper.append(
        		me.getEl().dom, 
        		{id:iFrameId, 
        		 tag: 'iframe'
        		}, true);
        
        var cw = printFrame.dom.contentWindow;
 
        // instantiate application stylesheets in the hidden iframe
        var stylesheets = "";
        var localstylesheets = "";
        for (var i = 0; i < document.styleSheets.length; i++) {
        	if(document.styleSheets[i].href)
            	stylesheets += Ext.String.format('<link rel="stylesheet" href="{0}" />', document.styleSheets[i].href);
        	else
        		localstylesheets += document.styleSheets[i].ownerNode.textContent;
        }
 
       // various style overrides
        if(localstylesheets != ""){
	       stylesheets += ''.concat(
	          "<style>", 
	            localstylesheets,
	          "</style>"
	         );	
        }
 
        // get the contents of the panel and remove hardcoded overflow properties
        var markup_header = header;
        if (markup_header){
	       	while (markup_header.indexOf('overflow: auto;') >= 0) {
	       		markup_header = markup_header.replace('overflow: auto;', '');
	       	}
        }
       	var markup_contents = contents;
       	if (markup_contents){
	       	while (markup_contents.indexOf('overflow: auto;') >= 0) {
	       		markup_contents = markup_contents.replace('overflow: auto;', '');
	       	}
       	}
       	
       	var markup_footer = footer;
       	if (markup_footer){
	       	while (markup_footer.indexOf('overflow: auto;') >= 0) {
	       		markup_footer = markup_footer.replace('overflow: auto;', '');
	       	}
       	}
       	var strStyle = ''.concat(
	       	'<style>',
       			'@media print', 
	       		'{',
	       			'html, body',
		            '{',
		                'height: 100%;',
		            '}',
			       	'#footer ',
	       	    	'{',
			       	 	'position: absolute;',
			       	 	'bottom: 0;',
			       	 '}',
	       		'}',
       			'</style>');
       	
        var defaultStr = ''.concat(
           '<html>' ,
		       '<head>{0}</head>' ,
		       '<body>',
		       		'<div>{1}</div>',
		       		'<div>{2}</div>',
		       		'<div>{3}</div>',
	           '</body>',
           '</html>') ;
 
        //var str = Ext.String.format(defaultStr,stylesheets,markup);
        var str = Ext.String.format(defaultStr,strStyle,markup_header, markup_contents,markup_footer);

        // output to the iframe
        cw.document.open();
        cw.document.write(str);
        cw.document.close(); 
        
        // remove style attrib that has hardcoded height property
        if (cw.document.getElementsByTagName('DIV').length > 0)
        	cw.document.getElementsByTagName('DIV')[0].removeAttribute('style');
 
        // print the iframe
        if(me.isIE())
        	cw.document.execCommand('Print', null, false);
        else
        	cw.print();
	  
        // destroy the iframe
        Ext.fly(iFrameId).destroy();

    },
    isIE: function(){
    	return ((navigator.appName == 'Microsoft Internet Explorer')
                || ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null)));
    }
});	

//DoubleLine List
Ext.define('nbox.previewDoubleLines',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
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
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'B');
		store.proxy.setExtraParam('SignType', 'A');
		store.proxy.setExtraParam('CPATH', CPATH);
		
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
 
//DocLine List  SignType = 'A'
Ext.define('nbox.previewDocLines',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
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
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
		store.proxy.setExtraParam('SignType', 'A');
		store.proxy.setExtraParam('CPATH', CPATH);
		
		store.load({callback: function(records, operation, success) {
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
    	
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});


//DocLine List SignType = 'B'
Ext.define('nbox.previewDocBLines',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
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
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
		store.proxy.setExtraParam('SignType', 'B');
		store.proxy.setExtraParam('CPATH', CPATH);
		
		store.load({callback: function(records, operation, success) {
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
    	
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});


// Header
Ext.define('nbox.previewHeaderView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
		'<table cellpadding="3" cellspacing="0" border="0" style="padding:10px 5px 10px 5px; width:100%;" >',
		'<tpl for=".">',
			'<tr>',
				'<td width="220">',
					'<img src="' + NBOX_IMAGE_PATH + '{Logo}" style="height:75;width:220px;" title="{FormName}"/>',
				'</td>',
				'<td align="center">',
					'<span style="font-size:30px; color:#666666; font-weight:bold;">{FormName}</span>',
				'</td>',
				'<td width="220">&nbsp;',
				'</td>',
			'</tr>',
		'</tpl>',
		'</table>'
	); 
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
	}
});

//DocBasis List
Ext.define('nbox.previewDocBasis',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" border="0" style="padding: 0px 3px 0px 3px; width:100%;" >',
				'<tr>',
					'<td align="right" width="105">',
						'<span  style="color:#666666; font-size:12px;">근거문서:&nbsp;</span>',
					'</td>',
					'<td>',
						'<tpl for=".">', 
							'<span style="color:#666666; font-size:12px;">&#91;{RefDocumentNo}&#93;</span>',
				       	'</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>',
	       	'<br/>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
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
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});

// Contents View
Ext.define('nbox.previewContentsView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	flex: 1,
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" border="0" style="padding: 3px 5px 0px 5px; width:100%;" >',
				'<tr>',
					'<td>',
						'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding: 0px 0px 0px 0px;" >',
							'<tpl for=".">',
								'<tr>',
									'<td style="padding:5px; font-size:12px">',
										'{ViewContents}',
									'</td>',
								'</tr>',						
							'</tpl>',
						'</table>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	}
});	

// Slogan View
Ext.define('nbox.previewSlogan1View',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding:5px 5px 5px 5px; width: 100%;" >',
				'<tpl for=".">',
					'<tr>',
						'<td align="center">',
							'<span style="color:#666666; font-size:12px;">{Slogan1}</span>',
						'</td>',
					'</tr>',						
				'</tpl>',
			'</table>'
		); 
		
		me.callParent();
	}
});

Ext.define('nbox.previewSlogan2View',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding:5px 5px 5px 5px; width: 100%;" >',
				'<tpl for=".">',
					'<tr>',
						'<td align="center">',
							'<span  style="color:#666666; font-size:12px;">{Slogan2}</span>',
						'</td>',
					'</tr>',						
				'</tpl>',
			'</table>'
		); 
		
		me.callParent();
	}
});

//RCV User List
Ext.define('nbox.previewRcvUserLines1',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding:3px 5px 0px 5px; width:100%;" >',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">수신&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<tpl if="xcount &gt; 1 && xindex === xcount">',
							'<span style="color:#666666; font-size:12px;">수신자&nbsp;참조</span>',
						'</tpl>',
						'<tpl if="xcount &lt;= 1">',
							'<span style="color:#666666; font-size:12px;">',
							'<tpl if="values.DeptType == \'P\'">',
								'{RcvUserName}',
							'<tpl else>',
								'{RcvUserDeptName}',
							'</tpl>',
							'</span>',
							'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
						'</tpl>',
					'</tpl>',								
					'</td>',
				'</tr>',
			'</table>'					
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'C');
		
		store.load({callback: function(records, operation, success) {
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
    	var nboxPreviewRcvUserLines2 = Ext.getCmp('nboxPreviewRcvUserLines2')
    	var store = me.getStore();
    	
    	if (nboxPreviewRcvUserLines2)
			nboxPreviewRcvUserLines2.loadData();
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});	


Ext.define('nbox.previewRcvUserLines2',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" border="0" style="padding: 5px 5px 5px 5px; width:100%;" >',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">수신자&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<span style="color:#666666; font-size:12px;">',
						'<tpl if="values.DeptType == \'P\'">',
							'{RcvUserName}',
						'<tpl else>',
							'{RcvUserDeptName}',
						'</tpl>',
						'</span>',
						'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
					'</tpl>',								
					'</td>',
				'</tr>',
			'</table>'				
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		/*
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'C');
		
		store.load({callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
		*/
		me.loadData();
	},
	clearData: function(){
		var me = this;
		
		me.clearPanel();
	},
    loadData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() <= 1)
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

Ext.define('nbox.previewSubjectView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
		'<table cellpadding="3" cellspacing="0" border="0" style="padding:0px 5px 0px 5px; width:100%;" >',
			'<tr>',
				'<td width="50">',
					'<span style="color:#666666; font-size:12px;">제목&nbsp;&nbsp;</span>',
				'</td>',
				'<td>',
				'<tpl for=".">',
					'<span style="color:#666666; font-size:12px;">{Subject}</span>',
				'</tpl>',
				'</td>',
			'</tr>',
		'</table>',
		'<table cellpadding="0" cellspacing="0" border="0" style="padding:0px 3px 0px 3px; width:100%;" >',
			'<tr style="height: 5px">',
				'<td colspan="2" style="border-top: 1px solid #A9A9A9;">',
				'</td>',
			'</tr>',
		'</table>'
	); 
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
	}
});

Ext.define('nbox.previewSealView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
		'<table cellpadding="3" cellspacing="0" border="0" style="padding:10px 5px 10px 5px; width:100%;" >',
		'<tpl for=".">',
			'<tr style="height:100px">',
				'<td align="center">',
				'<tpl if="values.FormName != \'\'">',	
					'<span style="font-size:20px; font-weight:bold; color:#666666;">{FormName}장</span>',
				'<tpl else>',
					'<span style="font-size:20px; font-weight:bold; color:#666666;">해외문화홍보원장</span>',
				'</tpl>',
				'<tpl if="values.InnerApprovalFlag == \'1\'">',
					'<span style="border: 0px;"></span>',
				'<tpl else>',
					'<span style="border: 0px; position: relative; left:-30px;">',
						'<img src="' + NBOX_IMAGE_PATH + '{Imge}" style="height:120px; width:120px; opacity:0.5;" title="{FormName}장"/>',
					'</span>',
				'</tpl>',
				'</td>',
			'</tr>',
		'</tpl>',
		'</table>'
		); 
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
	}
});

//REF User List
Ext.define('nbox.previewRefUserLines1',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding: 5px 5px 5px 5px; width:100%;" >',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">참조&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<tpl if="xcount &gt; 1 && xindex === xcount">',
							'<span style="color:#666666; font-size:12px;">참조자&nbsp;참조</span>',
						'</tpl>',
						'<tpl if="xcount &lt;= 1">',
							'<span style="color:#666666; font-size:12px;">',
							'<tpl if="values.DeptType == \'P\'">',
								'{RcvUserName}',
							'<tpl else>',
								'{RcvUserDeptName}',
							'</tpl>',
							'</span>',
							'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
						'</tpl>',
					'</tpl>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'R');
		
		store.load({callback: function(records, operation, success) {
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
    	var nboxPreviewRefUserLines2 = Ext.getCmp('nboxPreviewRefUserLines2')
    	var store = me.getStore();
    	
    	if (nboxPreviewRefUserLines2)
    		nboxPreviewRefUserLines2.loadData();
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});	


Ext.define('nbox.previewRefUserLines2',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding: 5px 5px 5px 5px; width:100%;" >',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">참조자&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<span style="color:#666666; font-size:12px;">',
						'<tpl if="values.DeptType == \'P\'">',
							'{RcvUserName}',
						'<tpl else>',
							'{RcvUserDeptName}',
						'</tpl>',
						'</span>',
						'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
					'</tpl>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		/*
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'R');
		
		store.load({callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		})
		*/;
		me.loadData();
	},
	clearData: function(){
		var me = this;
		
		me.clearPanel();
	},
    loadData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() <= 1)
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


Ext.define('nbox.previewFooterView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
		'<table cellpadding="0" cellspacing="0" border="0" style="padding:0px 3px 0px 3px; width:100%;" >',
			'<tr style="height: 7px">',
				'<td style="border-top: 7px solid #DCDCDC;">',
				'</td>',
			'</tr>',
		'</table>'
	); 
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
	}
});

Ext.define('nbox.previewDocIDView',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
	itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
		'<table cellpadding="3" cellspacing="0" border="0" style="padding:0px 5px 0px 5px; width:100%;" >',
			'<tr>',
				'<td width="50">',
					'<span style="color:#666666; font-size:12px;">시행&nbsp;&nbsp;</span>',
				'</td>',
				'<td>',
				'<tpl for=".">',
					'<span style="color:#666666; font-size:12px;">{DocumentNo}</span>',
				'</tpl>',
				'</td>',
				'<td width="50">',
					'<span style="color:#666666; font-size:12px;">접수&nbsp;&nbsp;</span>',
				'</td>',
				'<td>',
				'</td>',
			'</tr>',
		'</table>'
	); 
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
	}
});

Ext.define('nbox.previewDivInfo',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    /* cls: 'nbox-feed-list', */
    itemSelector: '.nbox-feed-sel-item',
    /* selectedItemCls: 'nbox-feed-seled-item',  */
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="3" cellspacing="0" border="0" style="padding: 0px 5px 0px 5px; width:100%;" >',
			'<tpl for=".">',	
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">우&nbsp;&nbsp;</span>',
					'</td>',
				
					'<td>',
						'<span style="color:#666666; font-size:12px;">{ZIP_CODE}&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
						'<span style="color:#666666; font-size:12px;">{ADDR}&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
						'<span style="color:#666666; font-size:12px;">&#47;&nbsp;{HTTP_ADDR}&nbsp;&nbsp;</span>',
					'</td>',
				'</tr>',
			'</tpl>',
			'</table>',
			'<table cellpadding="3" cellspacing="0" border="0" style="padding: 0px 5px 0px 5px; width:100%;" >',
			'<tpl for=".">',	
				'<tr>',
					'<td width="70">',
						'<span style="color:#666666; font-size:12px;">전화번호&nbsp;&nbsp;</span>',
					'</td>',
				
					'<td>',
						'<span style="color:#666666; font-size:12px;">{TELEPHON}&nbsp;&nbsp;</span>',
					'</td>',
					'<td width="70">',
						'<span style="color:#666666; font-size:12px;">팩스번호&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
						'<span style="color:#666666; font-size:12px;">{FAX_NUM}&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
						'<span style="color:#666666; font-size:12px;">&#47;&nbsp;{EMAIL}&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
						'<span style="color:#666666; font-size:12px;">&#47;&nbsp;{SECUREGRADENAME}&nbsp;&nbsp;',
					'</td>',
				'</tr>',
			'</tpl>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.load({callback: function(records, operation, success) {
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
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});	


//Detail View 
Ext.define('nbox.previewDetailView',    {
    extend: 'Ext.panel.Panel',
    
    config: {
    	store: null,
    	regItems: {}
    },
    /* layout: { 
    	type:'vbox',
    	align: 'stretch' 
    }, */
    /* padding: '5px 5px 0px 5px',
    flex: 1, */
    border: false,
    autoScroll: true,

    initComponent: function () {
    	var me = this;
    	
    	var nboxPreviewDetailStore = me.getStore();

    	//var nboxPreviewDocBasisStore = Ext.create('nbox.previewDocBasisStore', {
    		//id: 'nboxPreviewDocBasisStore'
    	//});

    	var nboxPreviewRcvUserStore = Ext.create('nbox.previewRcvUserStore', {
    		id: 'nboxPreviewRcvUserStore'
    	});
    	
    	var nboxPreviewRefUsersStore = Ext.create('nbox.previewRefUsersStore', {
    		id: 'nboxPreviewRefUsersStore'
    	});
    	
    	var nboxPreviewDocLineStore = Ext.create('nbox.previewDocLineStore', {
    		id: 'nboxPreviewDocLineStore'
    	});
    	
    	var nboxPreviewDocBLineStore = Ext.create('nbox.previewDocBLineStore', {
    		id: 'nboxPreviewDocBLineStore'
    	});

    	var nboxPreviewDoubleLineStore = Ext.create('nbox.previewDoubleLineStore', {
    		id: 'nboxPreviewDoubleLineStore'
    	});
    	
    	var nboxPreviewDivInfoStore = Ext.create('nbox.previewDivInfoStore', {
    		id: 'nboxPreviewDivInfoStore'
    	});

    	var nboxPreviewSlogan1View = Ext.create('nbox.previewSlogan1View',{
			id:'nboxPreviewSlogan1View',
    		store: nboxPreviewDetailStore
    	});
    	
    	var nboxPreviewHeaderView = Ext.create('nbox.previewHeaderView',{
    		id:'nboxPreviewHeaderView',
    		store: nboxPreviewDetailStore
    	});
    	
    	var nboxPreviewRcvUserLines1 = Ext.create('nbox.previewRcvUserLines1',{
			id:'nboxPreviewRcvUserLines1',
    		store: nboxPreviewRcvUserStore
    	});
    	
    	var nboxPreviewRefUserLines1 = Ext.create('nbox.previewRefUserLines1',{
    		id:'nboxPreviewRefUserLines1',
    		store: nboxPreviewRefUsersStore,
    		hidden : true
    	})
    	
    	var nboxPreviewSubjectView = Ext.create('nbox.previewSubjectView',{
    		id:'nboxPreviewSubjectView',
    		store: nboxPreviewDetailStore
    	});
    	    	
    	//var nboxPreviewDocBasis = Ext.create('nbox.previewDocBasis', {
    		//id:'nboxPreviewDocBasis',
    		//store: nboxPreviewDocBasisStore
    	//}); 
    	
		var nboxPreviewContentsView = Ext.create('nbox.previewContentsView',{
			id:'nboxPreviewContentsView',
    		store: nboxPreviewDetailStore
    	});
		
		var nboxPreviewRcvUserLines2 = Ext.create('nbox.previewRcvUserLines2',{
			id:'nboxPreviewRcvUserLines2',
    		store: nboxPreviewRcvUserStore
    	});
		
    	var nboxPreviewRefUserLines2 = Ext.create('nbox.previewRefUserLines2',{
    		id:'nboxPreviewRefUserLines2',
    		store: nboxPreviewRefUsersStore,
    		hidden : true
    	})
    	
    	var nboxPreviewSealView = Ext.create('nbox.previewSealView',{
    		id:'nboxPreviewSealView',
        	store: nboxPreviewDetailStore
    	})
    	
    	var nboxPreviewFooterView = Ext.create('nbox.previewFooterView',{
    		id:'nboxPreviewFooterView'
    	})

    	
    	var nboxPreviewDocLines = Ext.create('nbox.previewDocLines', {
    		id: 'nboxPreviewDocLines',
    		store: nboxPreviewDocLineStore
    	});
    	
    	var nboxPreviewDocBLines = Ext.create('nbox.previewDocBLines', {
    		id: 'nboxPreviewDocBLines',
    		store: nboxPreviewDocBLineStore
    	});
    	
    	var nboxPreviewDoubleLines = Ext.create('nbox.previewDoubleLines', {
    		id: 'nboxPreviewDoubleLines',
    		store: nboxPreviewDoubleLineStore,
    		hidden : true
    	});
    	
    	var nboxPreviewDocIDView = Ext.create('nbox.previewDocIDView',{
    		id:'nboxPreviewDocIDView',
    		store: nboxPreviewDetailStore
    	});
    	
    	var nboxPreviewDivInfo = Ext.create('nbox.previewDivInfo',{
    		id:'nboxPreviewDivInfo',
    		store: nboxPreviewDivInfoStore
    	});
    	
    	var nboxPreviewSlogan2View = Ext.create('nbox.previewSlogan2View',{
			id:'nboxPreviewSlogan2View',
    		store: nboxPreviewDetailStore
    	});
    	
    	var nboxPrintPanel = Ext.create('nbox.printPanel', {
    		id:'nboxPrintPanel',
    		border: false
    	}); 

    	
    	var nboxPreviewHeaderPanel = Ext.create('Ext.panel.Panel', {
    		id: 'nboxPreviewHeaderPanel',
    		border: false,
    		items: [nboxPreviewSlogan1View,
    		        nboxPreviewHeaderView,
    		        nboxPreviewRcvUserLines1,
    		        nboxPreviewRefUserLines1,
    		        nboxPreviewSubjectView
    		        //nboxPreviewDocBasis
    		        ]
    	});
    	
    	
    	var nboxBodyPanel = Ext.create('Ext.panel.Panel', {
    		id: 'nboxBodyPanel',
    		border: false,
    		items: [nboxPreviewContentsView]
    	});
    	
    	var nboxFooterPanel = Ext.create('Ext.panel.Panel', {
    		id: 'nboxFooterPanel',
    		border: false,
    		items: [nboxPreviewSealView,
		            nboxPreviewRcvUserLines2,
		            nboxPreviewRefUserLines2,
		            nboxPreviewFooterView,
		            nboxPreviewDocLines,
		            nboxPreviewDocBLines,
		            nboxPreviewDoubleLines,
		            nboxPreviewDocIDView,
		            nboxPreviewDivInfo,
		            nboxPreviewSlogan2View]
    	});

    	
		me.items = [nboxPreviewHeaderPanel,
		            nboxBodyPanel,
		            nboxFooterPanel,		             
		            nboxPrintPanel];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	
    	var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
    	var nboxPreviewDoubleLines = Ext.getCmp('nboxPreviewDoubleLines');
    	//var nboxPreviewDocBasis = Ext.getCmp('nboxPreviewDocBasis');
    	var nboxPreviewRcvUserLines1 = Ext.getCmp('nboxPreviewRcvUserLines1');
    	var nboxPreviewRcvUserLines2 = Ext.getCmp('nboxPreviewRcvUserLines2');
    	var nboxPreviewRefUserLines1 = Ext.getCmp('nboxPreviewRefUserLines1');
    	var nboxPreviewRefUserLines2 = Ext.getCmp('nboxPreviewRefUserLines2');
    	var nboxPreviewDocLines = Ext.getCmp('nboxPreviewDocLines');
    	var nboxPreviewDocBLines = Ext.getCmp('nboxPreviewDocBLines');
    	var nboxPreviewDivInfo = Ext.getCmp('nboxPreviewDivInfo');
    	
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxPreviewDetailWindow.getDocumentID();
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   					
   					if (records[0].data.InputRcvFlag == "1" || records[0].data.InnerApprovalFlag == "1"){
   						var storeRcv = nboxPreviewRcvUserLines1.getStore();
   						var tempData = records[0].data.InputRcvUser;
      					 
						if (tempData && tempData.length){
							tempArray = tempData.split(';');
							
							if (tempArray.length){
								for(var indx in tempArray) {
			   						var newRecordRcv = {
						  				DocumentID: records[0].data.DocumentID,
						  				RcvType: 'C',
						  				DeptType: 'P',
						  				RcvUserID: '',
						  				RcvUserName: tempArray[indx],
						  				RcvUserDeptID: '',
						  				RcvUserDeptName: '' ,
						  				RcvUserPosName: '',
						  				ReadDate: null,
						  				ReadChk: '-1'
			   					        }; 
			   							
			   						storeRcv.add(newRecordRcv);
								}
							}
						}
   					}
   					else{
   						if (nboxPreviewRcvUserLines1)
   							nboxPreviewRcvUserLines1.queryData();   						
   					}
   					
   					if (nboxPreviewRcvUserLines2)
   						nboxPreviewRcvUserLines2.queryData();
   					
   					if (records[0].data.InputRefFlag == "1"){
   						var storeRef = nboxPreviewRefUserLines1.getStore();
   						var tempData = records[0].data.InputRcvUser;
     					 
						if (tempData && tempData.length){
							tempArray = tempData.split(';');
							
							if (tempArray.length){
								for(var indx in tempArray) {
			   						var newRecordRef = {
						  				DocumentID: records[0].data.DocumentID,
						  				RcvType: 'R',
						  				DeptType: 'P',
						  				RcvUserID: '',
						  				RcvUserName: tempArray[indx],
						  				RcvUserDeptID: '',
						  				RcvUserDeptName: '' ,
						  				RcvUserPosName: '',
						  				ReadDate: null,
						  				ReadChk: '-1'
			   					    }; 
			   							
			   				  		storeRef.add(newRecordRef);
								}
							}
						}
   					}
   					else{
   						if (nboxPreviewRefUserLines1)
   							nboxPreviewRefUserLines1.queryData();
   					}
   					
   					if (nboxPreviewRefUserLines2)
   						nboxPreviewRefUserLines2.queryData();
   				}
   			}
		});
		
		if (nboxPreviewDoubleLines)
			nboxPreviewDoubleLines.queryData();
		//if (nboxPreviewDocBasis)
			//nboxPreviewDocBasis.queryData();
		if(nboxPreviewDocLines)
			nboxPreviewDocLines.queryData();
		if(nboxPreviewDocBLines)
			nboxPreviewDocBLines.queryData();
		if(nboxPreviewDivInfo)
			nboxPreviewDivInfo.queryData();
		
    },
	printAllData: function(){
		var me = this;
		var nboxPrintPanel = Ext.getCmp('nboxPrintPanel');
		var header = "";
		var contents = "";
		var footer = "";
		
		
		header = header + Ext.get('nboxPreviewSlogan1View').dom.innerHTML;
		header = header + Ext.get('nboxPreviewHeaderView').dom.innerHTML;
		header = header + Ext.get('nboxPreviewRcvUserLines1').dom.innerHTML;
		header = header + Ext.get('nboxPreviewRefUserLines1').dom.innerHTML;
		header = header + Ext.get('nboxPreviewSubjectView').dom.innerHTML;
	
		contents = contents + Ext.get('nboxPreviewContentsView').dom.innerHTML;
		
		footer = footer + Ext.get('nboxPreviewSealView').dom.innerHTML;
		if (Ext.getCmp('nboxPreviewRcvUserLines2').isVisible())
			footer = footer + Ext.get('nboxPreviewRcvUserLines2').dom.innerHTML;
		if (Ext.getCmp('nboxPreviewRefUserLines2').isVisible())
			footer = footer + Ext.get('nboxPreviewRefUserLines2').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewFooterView').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewDocLines').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewDocBLines').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewDoubleLines').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewDocIDView').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewDivInfo').dom.innerHTML;
		footer = footer + Ext.get('nboxPreviewSlogan2View').dom.innerHTML;
		
		//footer =  Ext.get('nboxFooterPanel').dom.innerHTML;

		nboxPrintPanel.print(header, contents, footer); 
	},
	
	printData: function(){
		var me = this;
		var header = "";
		var contents = "";
		var footer = "";
		var nboxPrintPanel = Ext.getCmp('nboxPrintPanel');
		var contentsView = Ext.getCmp('nboxPreviewContentsView');

		contents = contents + Ext.get('nboxPreviewContentsView').dom.innerHTML;
		
		if (contents != "")
			nboxPrintPanel.print(header, contents, footer); 
	},
	clearData: function(){
    	var me = this;
    	
    	//var nboxPreviewDocBasis = Ext.getCmp('nboxPreviewDocBasis');
    	var nboxPreviewRcvUserLines1 = Ext.getCmp('nboxPreviewRcvUserLines1');
    	var nboxPreviewRcvUserLines2 = Ext.getCmp('nboxPreviewRcvUserLines2');
    	var nboxPreviewRefUserLines1 = Ext.getCmp('nboxPreviewRefUserLines1');
    	var nboxPreviewRefUserLines2 = Ext.getCmp('nboxPreviewRefUserLines2');
    	var nboxPreviewDocLines = Ext.getCmp('nboxPreviewDocLines');
    	var nboxPreviewDocBLines = Ext.getCmp('nboxPreviewDocBLines');
    	var nboxPreviewDoubleLines = Ext.getCmp('nboxPreviewDoubleLines');
    	var nboxPreviewDivInfo = Ext.getCmp('nboxPreviewDivInfo');
    	
    	me.clearPanel();
    	
    	//if (nboxPreviewDocBasis)
    		//nboxPreviewDocBasis.clearData();
    	if (nboxPreviewRcvUserLines1)
    		nboxPreviewRcvUserLines1.clearData();
    	if (nboxPreviewRcvUserLines2)
    		nboxPreviewRcvUserLines2.clearData();
    	if (nboxPreviewRefUserLines1)
    		nboxPreviewRefUserLines1.clearData();
    	if (nboxPreviewRefUserLines2)
    		nboxPreviewRefUserLines2.clearData();
    	if (nboxPreviewDocLines)
    		nboxPreviewDocLines.clearData();
    	if (nboxPreviewDocBLines)
    		nboxPreviewDocBLines.clearData();
    	if (nboxPreviewDoubleLines)
    		nboxPreviewDoubleLines.clearData();
    	if (nboxPreviewDivInfo)
    		nboxPreviewDivInfo.clearData();
    },
    loadData: function(){
    	var me = this;

    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getStore();
		
    	if (store)
    		store.removeAll();
    }
});	

//Detail toolbar
Ext.define('nbox.previewDetailToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	config: {
		regItems: {}
	},
	
	initComponent: function () {
    	var me = this;
    	
    	var btnPrintAll = {
			xtype: 'button',
			text: '인쇄',
			tooltip : '인쇄',
			itemId : 'printAll',
			style: { margin: '0px 0px 0px 3px' },
			handler: function() { 
				var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
				
				if (nboxPreviewDetailWindow)
					nboxPreviewDetailWindow.PrintAllButtonDown();
			}
        };
    	
    	var btnPrint = {
			xtype: 'button',
			text: '내용인쇄',
			tooltip : '내용인쇄',
			itemId : 'print',
			style: { margin: '0px 0px 0px 3px' },
			handler: function() { 
				var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
				
				if (nboxPreviewDetailWindow)
					nboxPreviewDetailWindow.PrintButtonDown();
			}
        };
        
    	var btnClose = {
			xtype: 'button',
			text: '닫기',
			tooltip : '닫기',
			itemId : 'close',
			style: { margin: '0px 0px 0px 3px' },
			handler: function() { 
				var nboxPreviewDetailWindow = Ext.getCmp('nboxPreviewDetailWindow');
				
				if (nboxPreviewDetailWindow)
					nboxPreviewDetailWindow.CloseButtonDown();
			}				
        };
    	
		me.items = [btnPrintAll,btnClose];
		
    	me.callParent(); 
    },
	
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(i = 0; i < btnItemIDs.length; i ++) {
				var element = btnItemIDs[i];
				me.setToolBar(element, flag);
			}
		} else {
			me.setToolBar(btnItemIDs, flag);
		}
    },
    setToolBar: function(btnItemID, flag){
    	var me = this;
    	
    	var obj =  me.getComponent(btnItemID);
		if(obj) {
			(flag) ? obj.enable(): obj.disable();
		}
    }
});	

//Preview Detail Window
Ext.define('nbox.previewDetailWindow',{
	extend: 'Ext.window.Window',
	config: {
		documentID: null,
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: previewWinWidth,
    height: previewWinHeight,
    
   	modal: true,
   	maximizable: true,
   	resizable: true,
    closable: true,
    
    buttonAlign: 'right',

    initComponent: function () {
    	var me = this;
		
    	var nboxPreviewDetailToolbar = Ext.create('nbox.previewDetailToolbar', {
    		id:'nboxPreviewDetailToolbar'
    	});
    	
    	var nboxPreviewDetailStore = Ext.create('nbox.previewDetailStore', {
    		id:'nboxPreviewDetailStore'
    	});
    	
    	var nboxPreviewDetailView = Ext.create('nbox.previewDetailView', {
    		id:'nboxPreviewDetailView',
    		store: nboxPreviewDetailStore
    	});
		
		me.dockedItems = [nboxPreviewDetailToolbar];
		me.items = [nboxPreviewDetailView];
		
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> detailWindow');
    		obj.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> detailWindow')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		
    		console.log(me.id + ' beforeclose -> detailWindow')
    	},
    },
    PrintAllButtonDown: function(){
    	var me = this;
    	
    	me.printAllData();
    },
    PrintButtonDown: function(){
    	var me = this;
    	
    	me.printData();
    },
    CloseButtonDown: function(){
    	var me = this;
		
	    me.closeData();
	},
	printAllData: function(){
    	/*
    	var me = this;
    	var nboxPreviewDetailView = Ext.getCmp('nboxPreviewDetailView');
    	
    	if (nboxPreviewDetailView)
    		nboxPreviewDetailView.printAllData();
    	*/
    },
    printData: function(){
    	var me = this;
    	var nboxPreviewDetailView = Ext.getCmp('nboxPreviewDetailView');
    	
    	if (nboxPreviewDetailView)    	
    		nboxPreviewDetailView.printData();
    },
    closeData: function(){
    	var me = this;
    	me.close();
    },
    queryData: function(){
    	var me = this;
    	var nboxPreviewDetailView = Ext.getCmp('nboxPreviewDetailView');
    	
    	if (nboxPreviewDetailView)
    		nboxPreviewDetailView.queryData();
    },
    formShow: function(){
		var me = this;
		var nboxPreviewDetailView = Ext.getCmp('nboxPreviewDetailView');
    	
    	if (nboxPreviewDetailView){
    		//nboxPreviewDetailView.clearData();
    		nboxPreviewDetailView.queryData();
    		//nboxPreviewDetailView.show();
    	}
	},        
	onShow: function() {
        var me = this;
        var mySize = me.getSize();
        var pSize = Ext.getBody().getSize();
        
        if(mySize.height > pSize.height) {
            me.setSize({
                    width: mySize.width,
                    height : pSize.height
            });   
        }
        var posX = pSize.width - mySize .width;
        me.x = 0;(posX < 0) ? 0 : posX;
        me.y = 0;
        
        me.callParent(arguments);
    }
});	


/**************************************************
 * User Define Function
 **************************************************/    
//Preview Window Open
function openDocPreviewWin(documentID){
	
	var nboxPreviewDetailWindow = Ext.create('nbox.previewDetailWindow', {
		id:'nboxPreviewDetailWindow'
	});
		
	nboxPreviewDetailWindow.setDocumentID(documentID);
	nboxPreviewDetailWindow.show();
} 
