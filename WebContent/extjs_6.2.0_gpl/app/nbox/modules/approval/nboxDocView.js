/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
//Detail View
Ext.define('nbox.docDetailViewModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'CompanyID'},
    	{name: 'DraftUserID'}, 
    	{name: 'DraftUserName'},
    	{name: 'DraftDeptName'},
    	{name: 'DraftUserPos'},
    	{name: 'Subject'},
    	{name: 'Contents'},
    	{name: 'ViewContents'},
    	{name: 'DocumentNo'},
    	{name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'MultiType'},
    	{name: 'Status'},
    	{name: 'FormID'},
    	{name: 'FormName'},
    	{name: 'Slogan1'},
    	{name: 'Slogan2'},
    	{name: 'DraftFlag'},
    	{name: 'CurrentStatus'},
    	{name: 'CurrentSignFlag'},
    	{name: 'NextSignFlag'},
    	{name: 'NextSignedFlag'},
    	{name: 'DoubleLineFirstFlag'},
    	{name: 'SecureGrade'},
    	{name: 'CabinetID'},
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

Ext.define('nbox.docDetailViewDivInfoModel', {
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
Ext.define('nbox.docDetailViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewModel',
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
    },
    isteners: {
        load: function(store, records, success, operation) {
//        	var InputRcvUser = null;
//        	var InputRcvUserList = null;
//        	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
//        	var comboStore = nboxDocInputRcvCombo.getStore();
//        	
//        	if (records.length > 0){
//        		InputRcvUser = record.get('InputRcvUser');
//        		if (InputRcvUser){
//        			InputRcvUserList = InputRcvUser.split(';')
//       			if (InputRcvUserList.length > 0){
//        				for (var idx in InputRcvUserList) {
//        					comboStore.insert(0,[{'CODE':InputRcvUserList[idx]}]);
//        				}
//        				comboStore.commitChanges();        				
//        			}
//        				
//        		}
//        	}
        }
    }
});

//Div Infor
Ext.define('nbox.docDetailViewDivInfoStore', {
    extend:'Ext.data.Store', 
	model: 'nbox.docDetailViewDivInfoModel',
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
Ext.define('nbox.docDetailViewHeader',{
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
			'<tpl if="values.Logo != \'\'">',
				'<td width="220">',
					'<img src="' + NBOX_IMAGE_PATH + '{Logo}" style="height:75px;width:220px;" title="{FormName}"/>',
			'<tpl else>',
				'<td>',
					'&nbsp;',
			'</tpl>',
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

// Detail View Header
/*
Ext.define('nbox.docDetailViewHeader', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'vbox'
    },

    border:false,
	
	defaultType: 'displayfield',
	
	items: 
	[ 
	    { 
			fieldLabel: '문서ID',
			labelClsExtra: 'nbox_view_field_label',
			name: 'DocumentID',
			fieldStyle: 'color: #666666;'
    	},
	    {
	    	xtype: 'panel',
	    	
	    	layout: {
	    		type: 'hbox',
	    		align: 'stretch'
	    	},

	    	style: {
	    		'padding': '3px 0px 3px 0px'					
	    	},
	    	
			border:false,
			defaultType: 'displayfield',
			items: [
				{ 
					fieldLabel: '문서번호',
					labelClsExtra: 'nbox_view_field_label',
					name: 'DocumentNo',
					width: 500,
					fieldStyle: 'color: #666666;'
	        	},
	        	{ 
	        		fieldLabel: '상신일',
	        		labelClsExtra: 'nbox_view_field_label',
					name: 'DraftDate', 
					renderer: Ext.util.Format.dateRenderer('Y-m-d'),
					fieldStyle: 'color: #666666;'
				}
			]
	    }, 
	    { 
			fieldLabel: '기안',
			labelClsExtra: 'nbox_view_field_label',
			name: 'DraftUserName',
			fieldStyle: 'color: #666666;'
    	},
    	{ 
			fieldLabel: '제목',
			labelClsExtra: 'nbox_view_field_label',
			name: 'Subject',
			fieldStyle: 'color: #666666;'
    	}
	]
});
*/

// Detail View Contents
Ext.define('nbox.docDetailViewContents', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
	
	layout: 'fit',
	
	border: false,
	
	style: {
		'padding': '10px 10px 10px 10px'
	},
	
	defaultType: 'displayfield',
	
	items: [ 
	    {
			name: 'ViewContents',
			fieldStyle: 'padding: 10px 10px 10px 10px;'
		}
	]
});


// Detail View Slogan
Ext.define('nbox.docDetailViewSlogan1', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
	
	layout: 'fit',
	
	border: false,
	
	style: {
		'padding': '3px 3px 3px 3px'	
	},
	
	defaultType: 'displayfield',

	items: [ 
		{ 
			name: 'Slogan1',
			flex: 1,
			fieldStyle: 'text-align: center; color: #666666; padding: 3px 3px 0px 3px;'
    	}]
});

Ext.define('nbox.docDetailViewSlogan2', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
	
	layout: 'fit',
	
	border: false,
	
	style: {
		'padding': '3px 3px 3px 3px'	
	},
	
	defaultType: 'displayfield',

	items: [ 
		{ 
			name: 'Slogan2',
			flex: 1,
			fieldStyle: 'text-align: center; color: #666666; padding: 3px 3px 0px 3px;'
    	}]
});

Ext.define('nbox.docDetailViewSubject',{
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

Ext.define('nbox.docDetailViewSeal',{
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
					'<tpl if="values.Imge != \'\' && values.Status == \'C\'">',
						'<span style="border: 0px; position: relative; left:-30px;">',
							'<img src="' + NBOX_IMAGE_PATH + '{Imge}" style="height:120px; width:120px; opacity:0.5;" title="{FormName}장"/>',
						'</span>',
					'<tpl else>',
						'&nbsp;',
					'</tpl>',
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

Ext.define('nbox.docDetailViewFooter',{
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

Ext.define('nbox.docDetailViewID',{
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

Ext.define('nbox.docDetailViewDivInfo',{
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
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = nboxBaseApp.getDocumentID();
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

// Detail View 
Ext.define('nbox.docDetailView',    {
    extend: 'Ext.form.Panel',
    config: {
    	store: null,
    	regItems: {}
    },
    
    layout: {
    	type: 'anchor'
    },
    
    bodyStyle: {
		'padding': '20px 20px 20px 20px'
	},
	
    border: false,
    flex: 1,
    
    autoScroll: true,
    
    api: { 
    	submit: 'nboxDocListService.exec' 
	},

    initComponent: function () {
    	var me = this;
    	
    	var docStore = me.getStore();
    	
    	var nboxDocDetailViewLineStore = Ext.create('nbox.docDetailViewLineStore', {
    		id: 'nboxDocDetailViewLineStore'
    	});
    	
    	var nboxDocDetailViewBLineStore = Ext.create('nbox.docDetailViewBLineStore', {
    		id: 'nboxDocDetailViewBLineStore'
    	});
    	
    	var nboxDocDetailViewDoubleLineStore = Ext.create('nbox.docDetailViewDoubleLineStore',{
    		id: 'nboxDocDetailViewDoubleLineStore'
    	});

    	var nboxDocDetailViewBasisStore = Ext.create('nbox.docDetailViewBasisStore',{
    		id: 'nboxDocDetailViewBasisStore'
    	});

    	var nboxDocDetailViewFileStore = Ext.create('nbox.docDetailViewFileStore', {
    		id: 'nboxDocDetailViewFileStore'
    	});

    	var nboxDocDetailViewRcvUserStore = Ext.create('nbox.docDetailViewRcvUserStore', {
    		id: 'nboxDocDetailViewRcvUserStore'
    	});
    	
    	var nboxDocDetailViewRefUserStore = Ext.create('nbox.docDetailViewRefUserStore',{
    		id: 'nboxDocDetailViewRefUserStore'
    	});
    	
    	var nboxDocDetailViewCommentStore = Ext.create('nbox.docDetailViewCommentStore', {
    		id: 'nboxDocDetailViewCommentStore'
    	});
    	
    	var nboxDocDetailViewDivInfoStore = Ext.create('nbox.docDetailViewDivInfoStore', {
    		id: 'nboxDocDetailViewDivInfoStore'
    	});
    	
    	
    	var nboxDocDetailViewSlogan1 = Ext.create('nbox.docDetailViewSlogan1',{
    		id: 'nboxDocDetailViewSlogan1',
    		store: docStore
    	});
    	
    	var nboxDocDetailViewHeader = Ext.create('nbox.docDetailViewHeader', {
    		id:'nboxDocDetailViewHeader',
    		store: docStore
    	});
    	
    	var nboxDocDetailViewRcvUser1 = Ext.create('nbox.docDetailViewRcvUser1',{
    		id: 'nboxDocDetailViewRcvUser1',
    		store: nboxDocDetailViewRcvUserStore
    	});
    	
    	var nboxDocDetailViewRefUser1 = Ext.create('nbox.docDetailViewRefUser1',{
    		id: 'nboxDocDetailViewRefUser1',
    		store: nboxDocDetailViewRefUserStore,
    		hidden : true
    	});
    	
    	var nboxDocDetailViewSubject = Ext.create('nbox.docDetailViewSubject',{
    		id:'nboxDocDetailViewSubject',
    		store: docStore
    	});
    	
    	var nboxDocDetailViewBasis = Ext.create('nbox.docDetailViewBasis',{
    		id: 'nboxDocDetailViewBasis',
    		store: nboxDocDetailViewBasisStore
    	});
    	
    	var nboxDocDetailViewFile = Ext.create('nbox.docDetailViewFile',{
    		id: 'nboxDocDetailViewFile',
    		store: nboxDocDetailViewFileStore
    	});
    	
    	var nboxDocDetailViewContents = Ext.create('nbox.docDetailViewContents',{
    		id: 'nboxDocDetailViewContents'
    	});
    	
    	
    	var nboxDocDetailViewSeal = Ext.create('nbox.docDetailViewSeal',{
        	id: 'nboxDocDetailViewSeal',
        	store: docStore
        });
    	
    	var nboxDocDetailViewRcvUser2 = Ext.create('nbox.docDetailViewRcvUser2',{
    		id: 'nboxDocDetailViewRcvUser2',
    		store: nboxDocDetailViewRcvUserStore
    	});
    	
    	var nboxDocDetailViewRefUser2 = Ext.create('nbox.docDetailViewRefUser2',{
    		id: 'nboxDocDetailViewRefUser2',
    		store: nboxDocDetailViewRefUserStore,
    		hidden : true
    	});
    	
    	var nboxDocDetailViewFooter = Ext.create('nbox.docDetailViewFooter',{
        	id: 'nboxDocDetailViewFooter'
        });
    	    	    	
    	var nboxDocDetailViewLine = Ext.create('nbox.docDetailViewLine',{
    		id:'nboxDocDetailViewLine',
    		store: nboxDocDetailViewLineStore
    	});
    	
    	var nboxDocDetailViewBLine = Ext.create('nbox.docDetailViewBLine',{
    		id:'nboxDocDetailViewBLine',
    		store: nboxDocDetailViewBLineStore
    	});
    	
    	var nboxDocDetailViewDoubleLine = Ext.create('nbox.docDetailViewDoubleLine',{
    		id: 'nboxDocDetailViewDoubleLine',
    		store: nboxDocDetailViewDoubleLineStore,
    		hidden : true
    	});
    	
    	var nboxDocDetailViewID = Ext.create('nbox.docDetailViewID',{
    		id:'nboxDocDetailViewID',
    		store: docStore
    	});
    	
    	var nboxDocDetailViewDivInfo = Ext.create('nbox.docDetailViewDivInfo',{
    		id:'nboxDocDetailViewDivInfo',
    		store: nboxDocDetailViewDivInfoStore
    	});
    	    	
    	var nboxDocDetailViewComment = Ext.create('nbox.docDetailViewComment',{
    		id: 'nboxDocDetailViewComment',
    		store: nboxDocDetailViewCommentStore
    	});
    	
    	var nboxDocDetailViewFileImgs = Ext.create('nbox.docDetailViewFileImgs',{
    		id: 'nboxDocDetailViewFileImgs',
    		store: nboxDocDetailViewFileStore
    	});
    	
    	var nboxDocDetailViewSlogan2 = Ext.create('nbox.docDetailViewSlogan2',{
    		id: 'nboxDocDetailViewSlogan2'
    	});
    	
		me.items = [
		    nboxDocDetailViewSlogan1,
		    nboxDocDetailViewHeader,
		    nboxDocDetailViewRcvUser1,
		    nboxDocDetailViewRefUser1,
		    nboxDocDetailViewSubject,
		    nboxDocDetailViewBasis,
		    nboxDocDetailViewFile,
            nboxDocDetailViewContents,
            nboxDocDetailViewSeal,
            nboxDocDetailViewRcvUser2,
            nboxDocDetailViewRefUser2,
            nboxDocDetailViewFooter,
            nboxDocDetailViewLine,
            nboxDocDetailViewBLine,
            nboxDocDetailViewDoubleLine,
            nboxDocDetailViewID,
            nboxDocDetailViewDivInfo,
            nboxDocDetailViewSlogan2,
            nboxDocDetailViewComment,
            nboxDocDetailViewFileImgs
		];
    	
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	
    	var nboxDocDetailViewBasis 		= Ext.getCmp('nboxDocDetailViewBasis');
    	var nboxDocDetailViewFile 		= Ext.getCmp('nboxDocDetailViewFile');
    	var nboxDocDetailViewRcvUser1 	= Ext.getCmp('nboxDocDetailViewRcvUser1');
    	var nboxDocDetailViewRcvUser2 	= Ext.getCmp('nboxDocDetailViewRcvUser2');
    	var nboxDocDetailViewRefUser1 	= Ext.getCmp('nboxDocDetailViewRefUser1');
    	var nboxDocDetailViewRefUser2 	= Ext.getCmp('nboxDocDetailViewRefUser2');
    	var nboxDocDetailViewSubject 	= Ext.getCmp('nboxDocDetailViewSubject');
    	var nboxDocDetailViewLine 		= Ext.getCmp('nboxDocDetailViewLine');
    	var nboxDocDetailViewBLine 		= Ext.getCmp('nboxDocDetailViewBLine');
    	var nboxDocDetailViewDoubleLine = Ext.getCmp('nboxDocDetailViewDoubleLine');
    	var nboxDocDetailViewDivInfo 	= Ext.getCmp('nboxDocDetailViewDivInfo');    	
    	var nboxDocDetailViewComment 	= Ext.getCmp('nboxDocDetailViewComment');
    	var nboxDocDetailViewFileImgs 	= Ext.getCmp('nboxDocDetailViewFileImgs');

		me.clearData();

		var store 		= me.getStore();
		var documentID 	= nboxBaseApp.getDocumentID();
		var box 		= nboxBaseApp.getDocBox();
		var gradeLevel	= nboxBaseApp.getGradeLevel();
		
		store.proxy.setExtraParam('BOX', box);
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   					if (records[0].data.InputRcvFlag == "1" || records[0].data.InnerApprovalFlag == "1"){
   						var storeRcv = nboxDocDetailViewRcvUser1.getStore();
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
   						if (nboxDocDetailViewRcvUser1)
   							nboxDocDetailViewRcvUser1.queryData();   						
   					}
   					
   					if (nboxDocDetailViewRcvUser2)
						nboxDocDetailViewRcvUser2.queryData();
   					
   					if (records[0].data.InputRefFlag == "1"){
   						var storeRef = nboxDocDetailViewRefUser1.getStore();
   						var tempData = records[0].data.InputRcvUser;
      					 
						if (tempData && tempData.length){
							tempArray = tempData.split(';');
							
							if (tempArray.length){
		   						var newRecordRef = {
					  				DocumentID: records[0].data.DocumentID,
					  				RcvType: 'R',
					  				DeptType: 'P',
					  				RcvUserID: '',
					  				RcvUserName: records[0].data.InputRefUser,
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
   					else{
   						if (nboxDocDetailViewRefUser1)
   							nboxDocDetailViewRefUser1.queryData();
   					}
   					
   					if (nboxDocDetailViewRefUser2)
						nboxDocDetailViewRefUser2.queryData();
   					
   					
   					if (records[0].data.Status == 'R' && records[0].data.DraftUserID == UserInfo.userID && box == "XA002"){
   						var nboxDocDetailToolbar = Ext.getCmp('nboxDocDetailToolbar')
   						
   						nboxDocDetailToolbar.setToolBars(['delete'], true);
   					}
   					
   					if (records[0].data.Status == 'C' && gradeLevel == "G1"  && box == "XA009"){
   						var nboxDocDetailToolbar = Ext.getCmp('nboxDocDetailToolbar')
   						
   						nboxDocDetailToolbar.setToolBars(['confirmcancel'], true);
   					}
   				}
   			}
		});
		

		if (nboxDocDetailViewBasis)
			nboxDocDetailViewBasis.queryData();
		if (nboxDocDetailViewFile)
			nboxDocDetailViewFile.queryData();
		if (nboxDocDetailViewSubject)
			nboxDocDetailViewSubject.queryData();
		if (nboxDocDetailViewLine)
			nboxDocDetailViewLine.queryData();
		if (nboxDocDetailViewBLine)
			nboxDocDetailViewBLine.queryData();
		if (nboxDocDetailViewDoubleLine)
			nboxDocDetailViewDoubleLine.queryData();
		if (nboxDocDetailViewDivInfo)
			nboxDocDetailViewDivInfo.queryData();
		nboxDocDetailViewComment.queryData();
		nboxDocDetailViewFileImgs.queryData();
    },
	deleteData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		var param = {'ActionType': NBOX_C_DELETE, 'DocumentID': documentID};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   nboxBaseApp.closeData();
			}
		});
	},
	draftData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		
		var nboxDocDetailViewLine = Ext.getCmp('nboxDocDetailViewLine');
		var nboxDocDetailViewBLine = Ext.getCmp('nboxDocDetailViewBLine');
		var nboxDocDetailViewLineStore = nboxDocDetailViewLine.getStore();
		var nboxDocDetailViewBLineStore = nboxDocDetailViewBLine.getStore();
		
		if( nboxDocDetailViewLineStore.getCount() + nboxDocDetailViewBLineStore.getCount() > 1 ){
			
			var documentID = nboxBaseApp.getDocumentID();
    		var execType = 'DRAFT';
    		
			var param = {
				'ActionType': NBOX_C_UPDATE, 
				'DocumentID': documentID, 
				'ExecType': execType
			};
			
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   nboxBaseApp.closeData();
				}
			});
		}else
			Ext.Msg.alert('확인', '선택된 결재선이 존재하지 않습니다.');
		
	},
	draftcancelData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		var execType = 'DRAFTCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   Ext.MessageBox.show({
              		    title: '확인',
              		    msg: '상신취소 되었습니다.',
              		    icon: Ext.MessageBox.INFO,
              		    buttons: Ext.MessageBox.OK, 
              		    closable: false,
              		    fn: function(btn) {nboxBaseApp.closeData()}
              		});
               }
		});
	},
	confirmData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		var execType = 'CONFIRM';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   Ext.MessageBox.show({
           		    title: '확인',
           		    msg: '결재승인 되었습니다.',
           		    icon: Ext.MessageBox.INFO,
           		    buttons: Ext.MessageBox.OK, 
           		    closable: false,
           		    fn: function(btn) {nboxBaseApp.closeData()}
           		});
			}
		});
	},
	confirmcancelData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		var execType = 'CONFIRMCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   Ext.MessageBox.show({
            		    title: '확인',
            		    msg: '승인취소 되었습니다.',
            		    icon: Ext.MessageBox.INFO,
            		    buttons: Ext.MessageBox.OK, 
            		    closable: false,
            		    fn: function(btn) {nboxBaseApp.closeData()}
            		});
               }
		});
	},
	returnData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		var execType = 'RETURN';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   Ext.MessageBox.show({
             		    title: '확인',
             		    msg: '반려 되었습니다.',
             		    icon: Ext.MessageBox.INFO,
             		    buttons: Ext.MessageBox.OK, 
             		    closable: false,
             		    fn: function(btn) {nboxBaseApp.closeData()}
             		});
               }
		});
	},
	returncancelData: function(){
		var me = this;
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		var execType = 'RETURNCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	  Ext.MessageBox.show({
            		    title: '확인',
            		    msg: '반려취소 되었습니다.',
            		    icon: Ext.MessageBox.INFO,
            		    buttons: Ext.MessageBox.OK, 
            		    closable: false,
            		    fn: function(btn) {nboxBaseApp.closeData()}
            	  });
               }
		});
	},
	doublelineData: function(){
		var me = this;
		
		var nboxDocDetailViewLine 		= Ext.getCmp('nboxDocDetailViewLine');
		var nboxDocDetailViewBLine 		= Ext.getCmp('nboxDocDetailViewBLine');
		var nboxDocDetailViewRcvUser1 	= Ext.getCmp('nboxDocDetailViewRcvUser1');
    	var nboxDocDetailViewRefUser 	= Ext.getCmp('nboxDocDetailViewRefUser');
   			
   		openDocLinePopupWin(1, 'B', nboxDocDetailViewLine, nboxDocDetailViewRcvUser1, nboxDocDetailViewRefUser);
	},
	clearData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	
    	var nboxDocDetailViewBasis 		= Ext.getCmp('nboxDocDetailViewBasis');
    	var nboxDocDetailViewFile 		= Ext.getCmp('nboxDocDetailViewFile');
    	var nboxDocDetailViewRcvUser1 	= Ext.getCmp('nboxDocDetailViewRcvUser1');
    	var nboxDocDetailViewRcvUser2 	= Ext.getCmp('nboxDocDetailViewRcvUser2');
    	var nboxDocDetailViewRefUser1 	= Ext.getCmp('nboxDocDetailViewRefUser1');
    	var nboxDocDetailViewRefUser2 	= Ext.getCmp('nboxDocDetailViewRefUser2');
    	var nboxDocDetailViewLine 		= Ext.getCmp('nboxDocDetailViewLine');
    	var nboxDocDetailViewBLine 		= Ext.getCmp('nboxDocDetailViewBLine');
    	var nboxDocDetailViewDoubleLine = Ext.getCmp('nboxDocDetailViewDoubleLine');
    	var nboxDocDetailViewDivInfo 	= Ext.getCmp('nboxDocDetailViewDivInfo');    
    	var nboxDocDetailViewComment 	= Ext.getCmp('nboxDocDetailViewComment');
    	var nboxDocDetailViewFileImgs 	= Ext.getCmp('nboxDocDetailViewFileImgs');
    	
    	me.clearPanel();
    	
    	store.removeAll();
    	
    	if (nboxDocDetailViewBasis)
    		nboxDocDetailViewBasis.clearData();
    	if (nboxDocDetailViewFile)
    		nboxDocDetailViewFile.clearData();
    	if (nboxDocDetailViewRcvUser1)
    		nboxDocDetailViewRcvUser1.clearData();
    	if (nboxDocDetailViewRcvUser2)
    		nboxDocDetailViewRcvUser2.clearData();
    	if (nboxDocDetailViewRefUser1)
    		nboxDocDetailViewRefUser1.clearData();
    	if (nboxDocDetailViewRefUser2)
    		nboxDocDetailViewRefUser2.clearData();
    	if (nboxDocDetailViewLine)
    		nboxDocDetailViewLine.clearData();
    	if (nboxDocDetailViewBLine)
    		nboxDocDetailViewBLine.clearData();
    	if (nboxDocDetailViewDoubleLine)
    		nboxDocDetailViewDoubleLine.clearData();
    	if (nboxDocDetailViewDivInfo)
    		nboxDocDetailViewDivInfo.clearData();
    	nboxDocDetailViewComment.clearData();
    	nboxDocDetailViewFileImgs.clearData();
    },
    loadPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	var frm = me.getForm();
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			var nboxDocDetailToolbar = Ext.getCmp('nboxDocDetailToolbar')
			
			switch (nboxBaseApp.getDocBox()){
				case 'XA002': //기안문서
					
					if(record.data.NextSignedFlag == 'Y' )
						nboxDocDetailToolbar.setToolBars(['draftcancel'], false);
				
					break;
					
				case 'XA003': //미결문서
				
					if( record.data.DoubleLineFirstFlag == 'Y' )
						nboxDocDetailToolbar.setToolBars(['doubleline'], true);
				
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'Y' )
						nboxDocDetailToolbar.setToolBars(['draftcancel'], false);
					
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'N' )
						nboxDocDetailToolbar.setToolBars(['draftcancel'], true);
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								nboxDocDetailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								nboxDocDetailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								nboxDocDetailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
					
					break;
				case 'XA004': //기결문서
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								nboxDocDetailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								nboxDocDetailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								nboxDocDetailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
				
					if ( record.data.DraftFlag == 'N' && record.data.NextSignFlag == 'Y') {
						switch(record.data.CurrentStatus){
							case 'C':
								nboxDocDetailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								nboxDocDetailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								break;
						}
					}
				
					break;
				default:
					break;
			};
			
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
		frm.reset();
    },
    openCommentWin: function(actionType, documentID, seq){
    	var me = this;
    	
    	var nboxDocDetailViewComment = Ext.getCmp('nboxDocDetailViewComment');
    	nboxDocDetailViewComment.openCommentWin(actionType, documentID, seq);
    },
    openPreviewWin: function(documentID){
    	var me = this;
    	openDocPreviewWin(documentID);
    }
});	


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	