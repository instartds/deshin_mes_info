	/**************************************************
	 * Common variable
	 **************************************************/
	 var previewWin ;
	 var previewWinWidth = 800;
	 var previewWinHeight = 700;
	 
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
	    	{name: 'Slogan'},
	    	{name: 'DraftFlag'},	
	    	{name: 'SignFlag'},
	    	{name: 'Status'}
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
	
	
	/**************************************************
	 * Store
	 **************************************************/	
	//Detail View
	var previewDetailStore = Ext.create('Ext.data.Store', {
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
	var previewDoubleLineStore = Ext.create('Ext.data.Store', {
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
	
	//DocLine List
	var previewDocLineStore = Ext.create('Ext.data.Store', {
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
	var previewDocBasisStore = Ext.create('Ext.data.Store', {
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
	var previewRefUsersStore = Ext.create('Ext.data.Store', {
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
	var previewRcvUsersStore = Ext.create('Ext.data.Store', {
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
        
	    print: function(pnl) {
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
	       stylesheets += ''.concat(
	          "<style>", 
	            localstylesheets,
	          "</style>"
	         );	
	 
	        // get the contents of the panel and remove hardcoded overflow properties
	        var markup = pnl.getEl().dom.innerHTML;
	       	while (markup.indexOf('overflow: auto;') >= 0) {
	            markup = markup.replace('overflow: auto;', '');
	       	} 
	        
	        var defaultStr = ''.concat(
	           '<html>' ,
			       '<head>{0}</head>' ,
			       '<body>',
				       '<table cellpadding="0" cellspacing="0" border="0" style="width:100%">',
					       '<tr>',
					       '<td align="center">',
						       '<div>{1}</div>' + 
						   '</td>',
					       '</tr>',
				       '</table>',
		           '</body>',
	           '</html>') ;
	 
	        //var str = Ext.String.format(defaultStr,stylesheets,markup);
	        var str = Ext.String.format(defaultStr,'',markup);

	        // output to the iframe
	        cw.document.open();
	        cw.document.write(str);
	        cw.document.close(); 
	        
	        // remove style attrib that has hardcoded height property
	        //cw.document.getElementsByTagName('DIV')[0].removeAttribute('style');
	 
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
				'<table cellpadding="3" cellspacing="0" border="0" width="100%">',
					'<tr>',
						'<td align="right">',
							'<table style="border:1px solid #C0C0C0;">',
								'<tr>',
									'<td>',
										'<div style="width:20px; height:95px; border:1px solid #C0C0C0; text-align:center; vertical-align:middle;">',
											'<span style="color:#666666; font-weight:bold; font-size: 9pt;"><br />관<br />리<br />부<br />서</span>',
										'</div>',
									'</td>',
				  					'<td>',
				  						'<table cellpadding="3" cellspacing="0" border="0">',
				  							'<tr>',
												'<tpl for=".">', 
													'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
								  						'<div style="color:#666666; font-weight:bold;">',
											            	'<label style="font-size: 9pt;">{SignUserPosName}</label>',
											            '</div>',
											            '<div style="color:#666666; font-weight:bold;">',
				            								'<label style="font-size: 9pt;">&#91;{SignTypeName}&#93;</label>',
				        								'</div>',
										       		'</td>',
										       	'</tpl>',
									       	'</tr>',
									       	'<tr>',
												'<tpl for=".">', 
													'<td align="center" style="width:85px; border-left:1px solid #C0C0C0; border-right:1px solid #C0C0C0;">',
								  						'<img src="{SignImgUrl}" style="height:30px;width:30px;"/>',
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = previewWin.getRegItems()['DocumentID'];
    		
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
	 
	//DocLine List
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
				'<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">',
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
										'<div style="width:20px; height:94px; border:1px solid #C0C0C0; text-align:center; vertical-align:middle;">',
											'<span style="color:#666666; font-weight:bold; font-size:9pt;"><br />실<br />무<br />부<br />서</span>',
										'</div>',
									'</td>',
				  					'<td>',
				  						'<table cellpadding="3" cellspacing="0" border="0">',
				  							'<tr>',
												'<tpl for=".">', 
													'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
								  						'<div style="color:#666666; font-weight:bold; font-size:9pt;">',
											            	'<label>{SignUserPosName}</label>',
											            '</div>',
											            '<div style="color:#666666; font-weight:bold; font-size:9pt;">',
				            								'<label>&#91;{SignTypeName}&#93;</label>',
				        								'</div>',
										       		'</td>',
										       	'</tpl>',
									       	'</tr>',
									       	'<tr>',
												'<tpl for=".">', 
													'<td align="center" style="width:85px; border-left:1px solid #C0C0C0; border-right:1px solid #C0C0C0;">',
								  						'<img src="{SignImgUrl}" style="height:30px;width:30px;"/>',
										       		'</td>',
										       	'</tpl>',
									       	'</tr>',
									       	'<tr>',
												'<tpl for=".">', 
													'<td align="center" style="width:85px; border:1px solid #C0C0C0;">',
								  						'<div style="color:#666666; font-size:9pt;">',
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = previewWin.getRegItems()['DocumentID'];
    		store.proxy.setExtraParam('DocumentID', documentID);
    		store.proxy.setExtraParam('LineType', 'A');
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
				'<table cellpadding="0" cellspacing="0" border="0" style="padding: 10px 3px 0px 3px; width:100%;" >',
					'<tpl for=".">',
						'<tr>',
							'<td align="right" style="color:#666666; font-weight:bold; font-size:9pt;" width="105">',
								'<label width="100%">문서번호:&nbsp;</label>',
							'</td>',
							'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
								'<label>{DocumentNo}</label>',
							'</td>',
							'<td align="right" style="color:#666666; font-weight:bold; font-size:9pt;" width="105">',
								'<label width="100%">상신일:&nbsp;</label>',
							'</td>',
							'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
								'<label>{[fm.date(values.DraftDate, "Y-m-d")]}</label>',
							'</td>',
						'</tr>',
						'<tr>',
							'<td align="right" style="color:#666666; font-weight:bold; font-size:9pt;" width="105">',
								'<label width="100%">기안:&nbsp;</label>',
							'</td>',
							'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
								'<label>{DraftUserName}</label>',
							'</td>',
						'</tr>',
						'<tr>',
						'<td align="right" style="color:#666666; font-weight:bold; font-size:9pt;" width="105">',
							'<label width="100%">제목:&nbsp;</label>',
						'</td>',
						'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
							'<label>{Subject}</label>',
						'</td>',
					'</tr>',						
					'</tpl>',
				'</table>'
			); 
			
			me.callParent();
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
						'<td align="right" style="color:#666666; font-weight:bold; font-size:9pt;" width="105">',
							'<label width="100%">근거문서:&nbsp;</label>',
						'</td>',
						'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
							'<tpl for=".">', 
								'<span>&#91;{RefDocumentNo}&#93;</span>',
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
    		var store = me.getStore();
    		var documentID;
			
    		me.clearData();
    		
    		documentID = previewWin.getRegItems()['DocumentID'];
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
				'<table cellpadding="0" cellspacing="0" border="0" style="padding: 0px 0px 0px 0px; width:100%;" >',
					'<tr>',
						'<td>',
							'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding: 0px 0px 0px 0px;" >',
								'<tpl for=".">',
									'<tr>',
										'<td style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
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
	Ext.define('nbox.previewSloganView',{
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
				'<table cellpadding="0" cellspacing="0" border="0" style="border-top: 1px solid #C0C0C0; padding: 10px 3px 0px 3px; width: 100%;" >',
					'<tpl for=".">',
						'<tr>',
							'<td align="center" style="padding:5px;border-right-width:1px;border-bottom-width:1px;font-size:9pt">',
								'<label style="color: #666666;">{Slogan}</label>',
							'</td>',
						'</tr>',						
					'</tpl>',
				'</table>'
			); 
			
			me.callParent();
		}
	});	
	
	//RCV User List
	Ext.define('nbox.previewRcvUserLines',{
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
				'<table cellpadding="0" cellspacing="0" border="0" style="padding: 5px 0px 0px 0px; width:100%;" >',
					'<tr>',
						'<td>',
							'<table cellpadding="0" cellspacing="0" style="border:1px solid #C0C0C0; width:100%;">',
								'<tr>',
									'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
										'<span style="font-weight:bold; color:#666666; font-size:9pt;">수신</span>',
									'</td>',
									'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px; font-size:9pt;">',
										'<tpl for=".">',
											'<tpl if="values.DeptType == \'P\'">',
												'<span>{RcvUserName}</span>',
											'<tpl else>',
												'<span>&#91;{RcvUserDeptName}&#93;</span>',
											'</tpl>',
											'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
										'</tpl>',
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = previewWin.getRegItems()['DocumentID'];
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
	
	//REF User List
	Ext.define('nbox.previewRefUserLines',{
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
				'<table cellpadding="0" cellspacing="0" border="0" style="padding: 5px 0px 0px 0px; width:100%;" >',
					'<tr>',
						'<td>',
							'<table cellpadding="0" cellspacing="0" style="border:1px solid #C0C0C0; width:100%;">',
								'<tr>',
									'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
										'<span style="font-weight:bold; color:#666666; font-size:9pt">참조</span>',
									'</td>',
									'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px; font-size:9pt">',
										'<tpl for=".">',
											'<tpl if="values.DeptType == \'P\'">',
												'<span>{RcvUserName}</span>',
											'<tpl else>',
												'<span>&#91;{RcvUserDeptName}&#93;</span>',
											'</tpl>',
											'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
										'</tpl>',
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = previewWin.getRegItems()['DocumentID'];
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
        	
        	var viewDoubleLine = Ext.create('nbox.previewDoubleLines', {
        		store: previewDoubleLineStore
        	});
        	
        	var viewDocLine = Ext.create('nbox.previewDocLines', {
        		store: previewDocLineStore
        	});
        	
        	var viewHeader = Ext.create('nbox.previewHeaderView',{
        		store: previewDetailStore
        	});
        	
        	var viewDocBasis = Ext.create('nbox.previewDocBasis', {
        		store: previewDocBasisStore
        	}); 
        	
			var viewContents = Ext.create('nbox.previewContentsView',{
        		store: previewDetailStore
        	});
			
			var viewSlogan = Ext.create('nbox.previewSloganView',{
        		store: previewDetailStore
        	});
        	
			var viewRcvUser = Ext.create('nbox.previewRcvUserLines',{
        		store: previewRcvUsersStore
        	});
        	
        	var viewRefUser = Ext.create('nbox.previewRefUserLines',{
        		store: previewRefUsersStore
        	})
        	
        	var printPanel = Ext.create('nbox.printPanel', {}); 
        	
        	var boxPanel = Ext.create('Ext.panel.Panel', {
        		style: {
        			'border': '1px solid #C0C0C0'
				},
        		border: false,
        		items: [viewDoubleLine,
        		        viewDocLine,
        		        viewHeader,
        		        viewDocBasis,
        		        viewContents,
        		        viewSlogan]
        	});
        	
        	me.getRegItems()['ViewDoubleLineView'] = viewDoubleLine;
        	viewDoubleLine.getRegItems()['ParentContainer'] = me;
        	me.getRegItems()['ViewDocLineView'] = viewDocLine;
        	viewDocLine.getRegItems()['ParentContainer'] = me;
        	me.getRegItems()['ViewDocBasisView'] = viewDocBasis;
        	viewDocBasis.getRegItems()['ParentContainer'] = me;
        	me.getRegItems()['ViewContents'] = viewContents;
        	viewContents.getRegItems()['ParentContainer'] = me;
        	me.getRegItems()['ViewRcvUserView'] = viewRcvUser;
        	viewRcvUser.getRegItems()['ParentContainer'] = me;
        	me.getRegItems()['ViewRefUserView'] = viewRefUser;
        	viewRefUser.getRegItems()['ParentContainer'] = me;
        	
        	me.getRegItems()['PrintPanel'] = printPanel;
        	printPanel.getRegItems()['ParentContainer'] = me;
        	
			me.items = [ boxPanel,
			             viewRcvUser,
			             viewRefUser,
			             printPanel];
			
			me.callParent();
        },
        queryData: function(){
        	var me = this;
        	
        	var viewDoubleLineView = me.getRegItems()['ViewDoubleLineView'];
        	var viewDocLineView = me.getRegItems()['ViewDocLineView'];
        	var viewDocBasisView = me.getRegItems()['ViewDocBasisView'];
        	var viewRcvUserView = me.getRegItems()['ViewRcvUserView'];
        	var viewRcfUserView = me.getRegItems()['ViewRefUserView']; 
    		var store = me.getRegItems()['StoreData'];
    		var documentID;
    		
    		me.clearData();
    		
			documentID = previewWin.getRegItems()['DocumentID'];
			store.proxy.setExtraParam('DocumentID', documentID);
    		
   			store.load({
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
   			
   			viewDoubleLineView.queryData();
   			viewDocLineView.queryData();
   			viewDocBasisView.queryData();
   			viewRcvUserView.queryData();
   			viewRcfUserView.queryData(); 
        },
    	printAllData: function(){
    		var me = this;
    		var printPanel = me.getRegItems()['PrintPanel'];

    		printPanel.print(me); 
    	},
    	
    	printData: function(){
    		var me = this;
    		var printPanel = me.getRegItems()['PrintPanel'];
    		var contentsView = me.getRegItems()['ViewContents'];

    		printPanel.print(contentsView); 
    	},
    	clearData: function(){
        	var me = this;
        	var viewDocLineView = me.getRegItems()['ViewDocLineView'];
        	var viewDocBasisView = me.getRegItems()['ViewDocBasisView'];
        	var viewRcvUserView = me.getRegItems()['ViewRcvUserView'];
        	var viewRefUserView = me.getRegItems()['ViewRefUserView']; 
	    	
        	me.clearPanel();
        	
        	viewDocLineView.clearData();
        	viewDocBasisView.clearData();
        	viewRcvUserView.clearData();
        	viewRefUserView.clearData();
        },
        loadData: function(){
        	
        },
        clearPanel: function(){
        	var me = this;
        	var store = me.getRegItems()['StoreData'];
    		
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
				text: '전체인쇄',
				tooltip : '전체인쇄',
				itemId : 'printAll',
				handler: function() { 
					me.getRegItems()['ParentContainer'].PrintAllButtonDown();
				}
	        };
	    	
	    	var btnPrint = {
				xtype: 'button',
				text: '내용인쇄',
				tooltip : '내용인쇄',
				itemId : 'print',
				handler: function() { 
					me.getRegItems()['ParentContainer'].PrintButtonDown();
				}
	        };
	        
	    	var btnClose = {
				xtype: 'button',
				text: '닫기',
				tooltip : '닫기',
				itemId : 'close',
				handler: function() { 
					me.getRegItems()['ParentContainer'].CloseButtonDown();
				}				
	        };
	    	
			me.items = [btnPrintAll,btnPrint,btnClose];
			
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
			
	    	var previewDetailToolbar = Ext.create('nbox.previewDetailToolbar', {});
	    	var previewDetailView = Ext.create('nbox.previewDetailView', {});
			
	    	previewDetailToolbar.getRegItems()['ParentContainer'] = me;
			me.getRegItems()['PreviewDetailToolbar'] = previewDetailToolbar;
			
			previewDetailView.getRegItems()['ParentContainer'] = me;
			previewDetailView.getRegItems()['StoreData'] = previewDetailStore;
			me.getRegItems()['ViewForm'] = previewDetailView;
			
			me.dockedItems = [previewDetailToolbar];
			me.items = [previewDetailView];
			
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
	    		previewWin = null;
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
	    	var me = this;
	    	var viewForm = me.getRegItems()['ViewForm'];
	    	
	    	viewForm.printAllData();
	    },
	    printData: function(){
	    	var me = this;
	    	var viewForm = me.getRegItems()['ViewForm'];
	    	
	    	viewForm.printData();
	    },
	    closeData: function(){
	    	var me = this;
	    	me.close();
	    },
        queryData: function(){
        	var me = this;
        	var viewForm = me.getRegItems()['ViewForm'];
        	
        	viewForm.queryData();
        },
        formShow: function(){
    		var me = this;
    		var viewForm = me.getRegItems()['ViewForm'];

			viewForm.clearData();
			viewForm.queryData();
			viewForm.show();
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
    	
    	if(!previewWin){
    		previewWin = Ext.create('nbox.previewDetailWindow', {
			}); 
    	}
    	
    	previewWin.getRegItems()['DocumentID'] = documentID;
    	previewWin.show();
    } 
