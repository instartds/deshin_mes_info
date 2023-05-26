/**************************************************
 * Common variable
 **************************************************/
/*const NBOX_C_CREATE = "C";
const NBOX_C_READ = "R";
const NBOX_C_UPDATE = "U";
const NBOX_C_DELETE = "D";

const NBOX_C_COMMENT_LIMIT = 10;*/

var approvalDetailWin ;
var approvalWinWidth = 700;
var approvalWinHeight = 700;

var approvalCommentWin ;
var approvalCommentWidth = 300;
var approvalCommentHeight = 200;

var approvalFileUploadWidth = 635;
var editDetailPanelWidth = 660;
var SUBJECTWidth = 650;
var editFileUploadPanelWidth = 650;
var editFilesPanelWidth = 650; 
var htmlEditorWidth = 650;
var fileUploadWidth = 650;


/**************************************************
 * Common Code
 **************************************************/
//Combobox

/**************************************************
 * Model
 **************************************************/
//Detail View
Ext.define('nbox.approvalDetailViewModel', {
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
    	{name: 'Slogan'},
    	{name: 'DraftFlag'},
    	{name: 'CurrentStatus'},
    	{name: 'CurrentSignFlag'},
    	{name: 'NextSignFlag'},
    	{name: 'NextSignedFlag'},
    	{name: 'DoubleLineFirstFlag'}
    ]
});

//Doc Line List
Ext.define('nbox.docLineViewModel', {
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

//Doc Basis List
Ext.define('nbox.docBasisViewModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'DocumentID'},
		{name: 'Seq'},
		{name: 'RefDocumentID'},
		{name: 'RefDocumentNo'}
    ]	    
});	

//File List
Ext.define('nbox.filesModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'FID'},
    	{name: 'DocumentID'},
    	{name: 'UploadFileName'},
    	{name: 'UploadFileExtension'},
    	{name: 'UploadFileIcon'},
    	{name: 'FileSize', type: 'number'},
    	{name: 'UploadContentType'},
    	{name: 'UploadPath'},
    	{name: 'CompanyID'}
    ]	    
});	

// RCV User List
Ext.define('nbox.rcvUserViewModel', {
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

//Comment List
Ext.define('nbox.commentsModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'Seq', type: 'int'},
    	{name: 'Comment'}, 
    	{name: 'UserDeptName'}, 
    	{name: 'UserDeptPosName'},
    	{name: 'UserName'}, 
    	{name: 'MyCommentFlag'},
    	{name: 'InsertDate', type: 'date', dateFormat:'Y-m-d H:i:s'}
    ]
});

//Rcv Read Check
Ext.define('nbox.rcvReadCheckModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'RcvUserName'}, 
    	{name: 'RcvUserPosName'},
    	{name: 'ReadDate'},
    	{name: 'RcvUserDeptID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
//Detail View
Ext.define('nbox.approvalDetailStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.approvalDetailViewModel',
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
Ext.define('nbox.doubleLineViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docLineViewModel',
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

//DocLine List
Ext.define('nbox.docLineViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docLineViewModel',
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

//File List
Ext.define('nbox.filesStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.filesModel',
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

//RCV User List
Ext.define('nbox.rcvUserViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.rcvUserViewModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
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

//REF User List
Ext.define('nbox.refUserViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.rcvUserViewModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
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

//Comment List
Ext.define('nbox.commentsStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.commentsModel',
	autoLoad: false,
	pageSize: NBOX_C_COMMENT_LIMIT,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxDocCommentService.selects' ,
        	destroy: 'nboxDocCommentService.delete' 
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
  	initPage: function(currentPage, pageSize) {
        var me = this;

        me.currentPage = currentPage;
        me.pageSize = pageSize;
    }
});	 

//Comment
Ext.define('nbox.commentStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.commentsModel',
	config: {
		parentContainer: null
	},
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxDocCommentService.select'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});

//Rcv Read Check 
Ext.define('nbox.rcvReadCheckStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.rcvReadCheckModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxDocRcvUserService.selectReadCheck'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
  	initPage: function(currentPage, pageSize) {
        var me = this;

        me.currentPage = currentPage;
        me.pageSize = pageSize;
    }
});	

var approvalDetailStore = Ext.create('nbox.approvalDetailStore',{});
var doubleLineViewStore = Ext.create('nbox.doubleLineViewStore',{});
var docLineViewStore = Ext.create('nbox.docLineViewStore',{});
var docBasisViewStore = Ext.create('nbox.docBasisViewStore',{});
var filesStore = Ext.create('nbox.filesStore',{});
var rcvUserViewStore = Ext.create('nbox.rcvUserViewStore',{});
var refUserViewStore = Ext.create('nbox.refUserViewStore',{});
var commentsStore = Ext.create('nbox.commentsStore',{});
var commentStore = Ext.create('nbox.commentStore',{});
		
/**************************************************
 * Define
 **************************************************/
//DoubleLine List
Ext.define('nbox.doubleLines',{
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
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		
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
		
		var viewDocLine = me.getRegItems()['ParentContainer'].getRegItems()['ViewDocLineView'];
		var docLineCount = viewDocLine.getStore().getCount();
		
		var doublelinelist = []; 
		var doublelines = store.data.items;
		Ext.each(doublelines,function(record){
			doublelinelist.push(me.JSONtoString(record.data)); 
		});
		
		if (doublelinelist.length == 0) doublelinelist = null;
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		
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

//DocLine List
Ext.define('nbox.docLines',{
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
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('LineType', 'A');
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

//DocBasis List
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
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
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

//File List
Ext.define('nbox.files',{
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
						'<label width="100%" class="f9pt">첨부파일:&nbsp;</label>',
					'</td>',
					'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
						'<div class="nbox-files-div">',
					        '<tpl for=".">', 
					            '<span class="nbox-feed-sel-item">',
					            	'<img src="' + CPATH + '/resources/images/nbox/Ext/{UploadFileIcon}" style="vertical-align: middle;" width="14" height="14" />',
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
		var documentID;
		
		me.clearData();
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
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
    	else
    		me.show();
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});

// Rcv Read Check
Ext.define('nbox.rcvReadCheckGrid', {
	extend:	'Ext.grid.Panel',
	
	config:{
		regItems: {}
	},
	
	border: true,
    
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            text: '이름',
	            dataIndex: 'RcvUserName',
	            align: 'center',
	            width: 100
	        }, 
	        {
	            text: '직위',
	            dataIndex: 'RcvUserPosName',
	            align: 'center',
	            width: 100
	        }, 
	        {	
	            text: '확인일자',
	            dataIndex: 'ReadDate',
	            align: 'center',
	            flex: 1
	        }];
    
        var gridPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: 5,
	        displayInfo: true
    	});
		
		me.getRegItems()['GridPaging'] = gridPaging;
		me.dockedItems= [gridPaging];
		
		me.callParent(); 
    }
});	

//RCV User List
Ext.define('nbox.rcvUserLines',{
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
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="border-collapse:collapse; border:1px solid #C0C0C0;">',
				'<tr>',
					'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
						'<span class="f9pt" style="font-weight:bold; color:#666666;">수신</span>',
					'</td>',
					'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
						'<tpl for=".">',
							'<div id="MAINCONTENTS-RCVUSER-{RcvUserDeptID}" style="float:left; border:1px solid #C0C0C0; width:150px; height:60px; margin-top:5px; margin-left:5px;margin-right:5px; margin-bottom:5px; padding-left:15px; text-align:left;">',
								'<span class="f9pt">{RcvUserDeptName}</span>',
								'<br />',
								'<span class="f9pt">{RcvUserName}</span>',
								'<br />',
								'<tpl if="values.ReadChk != \'0\'">',
									'<span class="f9pt">{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}</span>',
								'<tpl else>',
									'<span class="f9pt">&#91;미열람&#93;</span>',
								'</tpl>',
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
		var documentID;
		
		me.clearData();
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'C');
		
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
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() == 0)
    		me.hide(); 
    	else{
    		me.show();
    		
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var rcvReadCheckStroe = Ext.create('nbox.rcvReadCheckStore',{});
            		
            		rcvReadCheckStroe.proxy.setExtraParam('DocumentID', record.data.DocumentID);
            		rcvReadCheckStroe.proxy.setExtraParam('RcvType', record.data.RcvType);
            		rcvReadCheckStroe.proxy.setExtraParam('DeptType', record.data.DeptType);
            		rcvReadCheckStroe.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
            		rcvReadCheckStroe.initPage(1, 5);
            		rcvReadCheckStroe.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var rcvReadCheckGrid = Ext.create('nbox.rcvReadCheckGrid',{
	               	        			store: rcvReadCheckStroe
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'MAINCONTENTS-RCVUSER-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[rcvReadCheckGrid]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});	

//REF User List
Ext.define('nbox.refUserLines',{
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
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="border-collapse:collapse; border:1px solid #C0C0C0;">',
				'<tr>',
					'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
						'<span class="f9pt" style="font-weight:bold; color:#666666;">참조</span>',
					'</td>',
					'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
						'<tpl for=".">',
							'<div id="MAINCONTENTS-REFUSER-{RcvUserDeptID}" style="float:left; border:1px solid #C0C0C0; width:150px; height:60px; margin-top:5px; margin-left:5px;margin-right:5px; margin-bottom:5px; padding-left:15px; text-align:left;">',
								'<span class="f9pt">{RcvUserDeptName}</span>',
								'<br />',
								'<span class="f9pt">{RcvUserName}</span>',
								'<br />',
								'<tpl if="values.ReadChk != \'0\'">',
									'<span class="f9pt">{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}</span>',
								'<tpl else>',
									'<span class="f9pt">&#91;미열람&#93;</span>',
								'</tpl>',
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
		var documentID;
		
		me.clearData();
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'R');
		
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
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() == 0)
    		me.hide(); 
    	else{
    		me.show();
    		
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var rcvReadCheckStroe = Ext.create('nbox.rcvReadCheckStore',{});
            		
            		rcvReadCheckStroe.proxy.setExtraParam('DocumentID', record.data.DocumentID);
            		rcvReadCheckStroe.proxy.setExtraParam('RcvType', record.data.RcvType);
            		rcvReadCheckStroe.proxy.setExtraParam('DeptType', record.data.DeptType);
            		rcvReadCheckStroe.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
            		rcvReadCheckStroe.initPage(1, 5);
            		rcvReadCheckStroe.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var rcvReadCheckGrid = Ext.create('nbox.rcvReadCheckGrid',{
	               	        			store: rcvReadCheckStroe
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'MAINCONTENTS-REFUSER-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[rcvReadCheckGrid]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	}
});		

//Comment Grid
Ext.define('nbox.commentGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	padding: '3px 3px 0px 3px',
	hideHeaders: true,
	border: false,
    initComponent: function () {
    	var me = this;
    	
    	var commentTpl = new Ext.XTemplate(
			'<div style="padding: 3px 3px 0px, 3px">',
		        '<tpl for=".">', 
		            '<div>',
			            '<span class="nbox-feed-sel-item"><label>{UserName}</label>&nbsp;</span>',
			            '<span><label>{UserDeptPosName}</label>&nbsp;</span>',
			            '<span><label>{[fm.date(values.InsertDate, "Y-m-d H:i:s")]}</label>&nbsp;</span>',
		            '</div>',
		        	'<div style="padding: 0px 0px 0px, 10px">',
		        		'<span><label>{Comment}</label></span>',
		        	'</div>',
		        '</tpl>',
	        '</div>'
		);
		
    	var commentTplColumns = Ext.create('Ext.grid.column.Template', {
    		tpl: commentTpl,
        	flex: 1
    	});
    	
    	var commentActionColumns = Ext.create('Ext.grid.column.Action', {
    		width: 50,
			items: [
				{
					icon: CPATH + '/resources/images/nbox/edit.gif' ,
					tooltip: '수정',
					width: 25,
					handler:function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						if (record.data.MyCommentFlag == 'Y'){
							var documentID = record.data.DocumentID;
							var seq = record.data.Seq;
							me.openCommentWin(NBOX_C_UPDATE, documentID, seq);
						}
					}
				},
				{
					icon: CPATH + '/resources/images/nbox/delete.png' ,
					tooltip: '삭제',
					width: 25,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						if (record.data.MyCommentFlag == 'Y'){
							Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
						    function(btn) {
						        if (btn === 'yes') {
						        	me.deleteData(rowIndex);
						            return true;
						        } else {
						            return false;
						        }
							});
						};
					}
				}
			]
    	});
    	
    	var commentPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: NBOX_C_COMMENT_LIMIT,
	        displayInfo: true
    	});
    	
    	me.getRegItems()['CommentPaging'] = commentPaging;
	    me.columns = [commentTplColumns, commentActionColumns];
        me.dockedItems = [commentPaging];
        
       	me.callParent();
    },
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var documentID;
		
		me.clearData();
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.initPage(1, NBOX_C_COMMENT_LIMIT);
			store.load({callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
			});
	},
	deleteData: function(rowIndex){
		var me = this;
		var last;
		var store = me.getStore();
		var record = store.getAt(rowIndex);
		var selModel = me.getSelectionModel();
		
		last = selModel.getSelection()[0];

		store.remove(record);
		store.sync({success: function(batch, options){
			me.selectPrevious(last.index, false, false);
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
		var commentPaging = me.getRegItems()['CommentPaging'];
		
		if (commentPaging != null) {
			if (store.totalCount > 0){
  				if (!commentPaging.isVisible()){
  					commentPaging.show();
  				}
			} else {
				if (commentPaging.isVisible()){
					commentPaging.hide();
				}
			}
    	}
    },
	clearPanel: function(){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
	},
    selectPrevious: function(lastIndex, keepExisting, suppressEvent) {
		var me = this;
		var pageData;
		var selModel = me.getSelectionModel();
		
		if (lastIndex) {
            pageData = me.getRegItems()['CommentPaging'].getPageData();

            if (lastIndex >= pageData.fromRecord) {
                selModel.select((lastIndex - pageData.fromRecord), keepExisting, suppressEvent);
                return;
            }

            if (pageData.currentPage > 1) {
                me.view.on('refresh', function(view){
                		if (me.getStore().getCount() > 0){
                			selModel.select((me.getStore().getCount() - 1), keepExisting, suppressEvent);
                		}
                    },
                    me, {single: true}
                );
                me.getRegItems()['CommentPaging'].movePrevious();
            }
		} else {
			selModel.getStore().reload({callback: function(records, operation, success) {
   					if (success){
   						me.loadData();
   					}
   				}
				});
		}
    },
	openCommentWin: function(actionType, documentID, seq){
		var me = this;
		
		openApprovalCommentWin(me, actionType, documentID, seq);
	}
});

//Detail View 
Ext.define('nbox.approvalDetailView',    {
    extend: 'Ext.form.Panel',
    config: {
    	regItems: {}
    },
    layout: { 
    	type:'anchor'
    },
    padding: '5px 5px 0px 5px',
    flex: 1,
    border: false,
    autoScroll: true,
    defaultType: 'displayfield',
    api: { 
    	submit: 'nboxDocListService.exec' 
	},

    initComponent: function () {
    	var me = this;
    	
    	var viewDoubleLineView = Ext.create('nbox.doubleLines', {
    		store: doubleLineViewStore
    	});
    	
    	var viewDocLineView = Ext.create('nbox.docLines', {
    		store: docLineViewStore
    	});
    	
    	var viewHeaderPanel = Ext.create('Ext.form.Panel', {
    		layout: 'vbox',
			style: {
				'padding': '3px 3px 3px 3px'					
			},
			border:false,
			defaultType: 'displayfield',
			items: [
			    {
			    	xtype: 'form',
			    	layout: 'hbox',
					style: {
						'padding': '3px 3px 3px 3px'					
					},
					border:false,
					defaultType: 'displayfield',
					items: [
						{ 
							fieldLabel: '문서번호',
							labelClsExtra: 'nbox_view_field_label',
							name: 'DocumentNo',
							flex: 1,
							fieldStyle: 'color: #666666;'
			        	},
			        	{ 
			        		fieldLabel: '상신일',
			        		labelClsExtra: 'nbox_view_field_label',
							name: 'DraftDate', 
							renderer: Ext.util.Format.dateRenderer('Y-m-d'),
							width: '200px',
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
			]});
    	
    	var viewDocBasisView = Ext.create('nbox.docBasis', {
    		store: docBasisViewStore
    	}); 
    	
    	var viewFilesView = Ext.create('nbox.files', {
    		store: filesStore
    	});
    	
    	var viewContentsPanel = Ext.create('Ext.form.Panel', {
    		layout: 'fit',
    		style: {
    			'border-top': '1px solid #C0C0C0',
    			'border-bottom': '1px solid #C0C0C0',
    			'padding': '10px 3px 10px 3px'					
			},
    		border: false,
    		defaultType: 'displayfield',
    		items: [ {
        			name: 'ViewContents',
        			fieldStyle: 'padding: 0px 10px 0px 3px;'
    			},
    			{
    				xtype: 'component',
    				html: '&nbsp;',
    				style: {
    					'width': '100%',
    					'height': '1px',
    					'border-bottom': '1px solid #C0C0C0'
    				}
    			}]
    	});
    	
    	var viewSlogan = Ext.create('Ext.form.Panel', {
    		layout: 'fit',
    		style: {
				'padding': '3px 3px 3px 3px'	
    		},
    		border: false,
    		defaultType: 'displayfield',
    		items: [ 
        		{ 
					name: 'Slogan',
					flex: 1,
					fieldStyle: 'text-align: center; color: #666666; padding: 3px 3px 0px 3px;'
	        	}]
    	});
    	
    	var viewRcvUserView = Ext.create('nbox.rcvUserLines',{
    		store: rcvUserViewStore
    	});
    	
    	var viewRefUserView = Ext.create('nbox.refUserLines',{
    		store: refUserViewStore
    	})
    	
    	var viewCommentGrid = Ext.create('nbox.commentGrid', {
    		store: commentsStore
    	}); 	
    	
    	me.getRegItems()['ViewDoubleLineView'] = viewDoubleLineView;
    	viewDoubleLineView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewDocLineView'] = viewDocLineView;
    	viewDocLineView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewDocBasisView'] = viewDocBasisView;
    	viewDocBasisView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewFilesView'] = viewFilesView;
    	viewFilesView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewRcvUserView'] = viewRcvUserView;
    	viewRcvUserView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewRefUserView'] = viewRefUserView;
    	viewRefUserView.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ViewCommentGrid'] = viewCommentGrid;
    	viewCommentGrid.getRegItems()['ParentContainer'] = me;
    	
		me.items = [ viewDoubleLineView,
		             viewDocLineView,
		             viewHeaderPanel, 
		             viewDocBasisView,
		             viewFilesView, 
		             viewContentsPanel , 
		             viewSlogan, 
		             viewRcvUserView,
		             viewRefUserView,
		             viewCommentGrid];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	
    	var viewDoubleLineView = me.getRegItems()['ViewDoubleLineView'];
    	var viewDocLineView = me.getRegItems()['ViewDocLineView'];
    	var viewDocBasisView = me.getRegItems()['ViewDocBasisView'];
    	var viewFilesView = me.getRegItems()['ViewFilesView'];
    	var viewRcvUserView = me.getRegItems()['ViewRcvUserView'];
    	var viewRcfUserView = me.getRegItems()['ViewRefUserView'];
    	var viewCommentGrid = me.getRegItems()['ViewCommentGrid']; 
		var store = me.getRegItems()['StoreData'];
		var documentID;
		
		me.clearData();
		
		documentID = approvalDetailWin.getRegItems()['DocumentID'];
		box = approvalDetailWin.getRegItems()['Box'];
			
		store.proxy.setExtraParam('BOX', box);
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
		viewFilesView.queryData();
		viewRcvUserView.queryData();
		viewRcfUserView.queryData();
		viewCommentGrid.queryData();
    },
	deleteData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var param = {'ActionType': NBOX_C_DELETE, 'DocumentID': documentID};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	draftData: function(){
		var me = this;
		var viewDocLineView = me.getRegItems()['ViewDocLineView']; 
		var docLineStore = viewDocLineView.getStore();
		
		if( docLineStore.getCount() > 1 ){
			
			var documentID = approvalDetailWin.getRegItems()['DocumentID'];
    		var execType = 'DRAFT';
    		
			var param = {
				'ActionType': NBOX_C_UPDATE, 
				'DocumentID': documentID, 
				'ExecType': execType
			};
			
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   approvalDetailWin.close();
				}
			});
		}else
			Ext.Msg.alert('확인', '선택된 결재선이 존재하지 않습니다.');
		
	},
	draftcancelData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var execType = 'DRAFTCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	confirmData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var execType = 'CONFIRM';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	confirmcancelData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var execType = 'CONFIRMCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	returnData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var execType = 'RETURN';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	returncancelData: function(){
		var me = this;
		var documentID = approvalDetailWin.getRegItems()['DocumentID'];
		var execType = 'RETURNCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   approvalDetailWin.close();
			}
		});
	},
	doublelineData: function(){
		var me = this;
		
		var viewDoubleLineView = me.getRegItems()['ViewDoubleLineView'];
   		var viewRcvUserView = me.getRegItems()['ViewRcvUserView'];
   		var viewRefUserView = me.getRegItems()['ViewRefUserView'];
   			
   		openDocLinePopupWin(0,'B',viewDoubleLineView,viewRcvUserView,viewRefUserView);
	},
	clearData: function(){
    	var me = this;
    	
    	var viewDoubleLineView = me.getRegItems()['ViewDoubleLineView'];
    	var viewDocLineView = me.getRegItems()['ViewDocLineView'];
    	var viewDocBasisView = me.getRegItems()['ViewDocBasisView'];
    	var viewFilesView = me.getRegItems()['ViewFilesView'];
    	var viewRcvUserView = me.getRegItems()['ViewRcvUserView'];
    	var viewRefUserView = me.getRegItems()['ViewRefUserView'];
    	var viewCommentGrid = me.getRegItems()['ViewCommentGrid'];
    	
    	me.clearPanel();
    	
    	viewDoubleLineView.clearData();
    	viewDocLineView.clearData();
    	viewDocBasisView.clearData();
    	viewFilesView.clearData();
    	viewRcvUserView.clearData();
    	viewRefUserView.clearData();
    	viewCommentGrid.clearData();
    },
    loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['StoreData'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			var detailToolbar = approvalDetailWin.getRegItems()['DetailToolbar'];
			var box = approvalDetailWin.getRegItems()['Box'];
			
			switch (box){
				case 'XA002': //기안문서
					
					if(record.data.NextSignedFlag == 'Y' )
						detailToolbar.setToolBars(['draftcancel'], false);
				
					break;
					
				case 'XA003': //미결문서
				
					if( record.data.DoubleLineFirstFlag == 'Y' )
						detailToolbar.setToolBars(['doubleline'], true);
				
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'Y' )
						detailToolbar.setToolBars(['draftcancel'], false);
					
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'N' )
						detailToolbar.setToolBars(['draftcancel'], true);
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								detailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
					
					break;
				case 'XA004': //기결문서
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								detailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
				
					if ( record.data.DraftFlag == 'N' && record.data.NextSignFlag == 'Y') {
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
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
    	var store = me.getRegItems()['StoreData'];
		
    	store.removeAll();
		frm.reset();
    },
    openCommentWin: function(actionType, documentID, seq){
    	var me = this;
    	var viewCommentGrid = me.getRegItems()['ViewCommentGrid'];
    	
    	viewCommentGrid.openCommentWin(actionType, documentID, seq);
    },
    openPreviewWin: function(documentID){
    	var me = this;
    	openPreviewWin(documentID);
    }
});

//Comment Edit
Ext.define('nbox.approvalCommentEdit',  {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
	},
	layout: 'fit',
	padding: '5px 5px 0px 5px',
	api: { submit: 'nboxDocCommentService.save' },
	items: [
		{ xtype: 'textareafield',
		  name: 'Comment',
		  autoScroll: true,
		  allowBlank: false 
        }
	],
	queryData: function(){
		var me = this;
		var store = me.getRegItems()['StoreData'];
		var documentID = approvalCommentWin.getRegItems()['DocumentID'];
		var seq = approvalCommentWin.getRegItems()['Seq'];
		
		me.clearData();
		
		switch (approvalCommentWin.getRegItems()['ActionType']){
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    		break;
	    		
    		case NBOX_C_UPDATE:
				store.proxy.setExtraParam('DocumentID', documentID);
				store.proxy.setExtraParam('Seq', seq);
        		
       			store.load({
	       			callback: function(records, operation, success) {
	       				if (success){
	       					me.loadData();
	       				}
	       			}
       			});
	    		break;
	    	
			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
    },
	saveData: function(){
		var me = this;
    	var documentID = approvalCommentWin.getRegItems()['DocumentID'];
    	var seq = approvalCommentWin.getRegItems()['Seq'];
		var param = {'DocumentID': documentID, 'Seq': seq};
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	approvalCommentWin.close();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
	},
    clearData: function(){
		var me = this;
		
    	me.clearPanel();
    },
	loadData: function(){
		var me = this;
    	var store = me.getRegItems()['StoreData'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
	},
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['StoreData'];
    	
		store.removeAll();
		frm.reset();
    },
	validationCheck: function(){
    	var me = this;
    	
    	var fields = me.getForm().getFields();
    	var result = '';
    	
    	var itemCnt = fields.getCount();
    	for(var idx=0; idx<itemCnt; idx++){
    		if(!fields.items[idx].isValid()){
    			result += fields.items[idx].getFieldLabel() + ',';
    		}
    	}
    	
    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
    }
});

//Detail toolbar
Ext.define('nbox.approvalDetailToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	config: {
		regItems: {}
	},
	
	initComponent: function () {
    	var me = this;
    	
    	var btnEdit = {
			xtype: 'button',
			text: '수정',
			tooltip : '수정',
			itemId : 'edit',
			handler: function() { 
				me.getRegItems()['ParentContainer'].EditButtonDown();
			}
        };
        
        var btnSave = {
			xtype: 'button',
			text: '저장',
			tooltip : '저장',
			itemId : 'save',
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnDraft = {
			xtype: 'button',
			text: '상신',
			tooltip : '상신',
			itemId : 'draft',
			handler: function() {
				me.getRegItems()['ParentContainer'].DraftButtonDown();		
			}
        };
        
        var btnDraftCancel = {
			xtype: 'button',
			text: '상신취소',
			tooltip : '상신취소',
			itemId : 'draftcancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].DraftCancelButtonDown();		
			}
        };
        
        var btnConfirm = {
			xtype: 'button',
			text: '결재승인',
			tooltip : '결재승인',
			itemId : 'confirm',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmButtonDown();		
			}
        };
	        
        var btnConfirmCancel = {
			xtype: 'button',
			text: '승인취소',
			tooltip : '승인취소',
			itemId : 'confirmcancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmCancelButtonDown();		
			}
        };
        
        var btnReturn = {
			xtype: 'button',
			text: '반려',
			tooltip : '반려',
			itemId : 'return',
			handler: function() {
				me.getRegItems()['ParentContainer'].ReturnButtonDown();		
			}
        };
	        
        var btnReturnCancel = {
			xtype: 'button',
			text: '반려취소',
			tooltip : '반려취소',
			itemId : 'returncancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].ReturnCancelButtonDown();		
			}
        };
        
        var btnDelete = {
			xtype: 'button',
			text: '삭제',
			tooltip : '삭제',
			itemId : 'delete',
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();					
			}
        };	       
        
        var btnCancel = {
			xtype: 'button',
			text: '취소',
			tooltip : '취소',
			itemId : 'cancel',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();
			}
        };
        
        var btnPreview = {
			xtype: 'button',
			text: '미리보기',
			tooltip : '미리보기',
			itemId : 'preview',
			handler: function() { 
				me.getRegItems()['ParentContainer'].PreviewButtonDown();
			}
        };	 
        
        var btnComment = {
			xtype: 'button',
			text: '댓글',
			tooltip : '댓글쓰기',
			itemId : 'comment',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CommentButtonDown();
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
    	
    	var btnDoubleLine = {
			xtype: 'button',
			text: '이중결재선',
			tooltip : '이중결재선',
			itemId : 'doubleline',
			handler: function() { 
				me.getRegItems()['ParentContainer'].DoubleLineButtonDown();
			}				
        };
        
        /*var btnPrev = {
			xtype: 'button',
			text: '이전',
			tooltip : '이전페이지',
			itemId : 'prev',
			handler: function() {
				me.getRegItems()['ParentContainer'].PrevButtonDown();
			}
        };
        
        var btnNext = {
			xtype: 'button',
			text: '다음',
			tooltip : '다음페이지',
			itemId : 'next',
			handler: function() { 
				me.getRegItems()['ParentContainer'].NextButtonDown();
			}
        };	*/        
    	
		me.items = [btnEdit, btnSave, btnDelete, btnCancel, btnPreview, btnComment, btnClose, '-', btnDoubleLine, '->', btnDraft, btnDraftCancel, btnConfirm, btnConfirmCancel, btnReturn, btnReturnCancel/*, '-', btnPrev, btnNext*/];
		
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

//comment toolbar
Ext.define('nbox.approvalCommentToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	config: {
		regItems: {}
	},
	
	initComponent: function () {
    	var me = this;
    	
        var btnSave = {
			xtype: 'button',
			text: '저장',
			tooltip : '저장',
			itemId : 'save',
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnCancel = {
			xtype: 'button',
			text: '취소',
			tooltip : '취소',
			itemId : 'cancel',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();					
			}
        };
        	    	
		me.items = [btnSave, btnCancel];
		
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

//Detail Window
Ext.define('nbox.approvalDetailWindow',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: approvalWinWidth,
    height: approvalWinHeight,
    maximizable: true,
    /* maximized: true, */
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    
    
    initComponent: function () {
    	var me = this;
		
    	var detailToolbar = Ext.create('nbox.approvalDetailToolbar', {});
    	var detailView = Ext.create('nbox.approvalDetailView', {});
		/*var popDetailEdit = Ext.create('nbox.detailEdit', {});*/
		
    	detailToolbar.getRegItems()['ParentContainer'] = me;
		me.getRegItems()['DetailToolbar'] = detailToolbar;
		
		detailView.getRegItems()['ParentContainer'] = me;
		detailView.getRegItems()['StoreData'] = approvalDetailStore;
		me.getRegItems()['DetailView'] = detailView;
		
		/*popDetailEdit.getRegItems()['ParentContainer'] = me;
		popDetailEdit.getRegItems()['StoreData'] = approvalDetailStore;
		popDetailEdit.getRegItems()['ActionType'] = NBOX_C_UPDATE;
    	me.getRegItems()['EditForm'] = popDetailEdit; */
    	
		me.dockedItems = [detailToolbar];
		me.items = [detailView /*, popDetailEdit*/ ];
		
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> approvalDetailWin');
    		obj.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> approvalDetailWin')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		var masterGrid = me.getRegItems()['MasterGrid'];
    		
    		console.log(me.id + ' beforeclose -> approvalDetailWin')
    		masterGrid.queryData();
    		approvalDetailWin = null;
    	},
    },
    EditButtonDown: function() {
		var me = this;
		
		me.editData();
    },
    SaveButtonDown: function(){
    	var me = this;
    	
    	me.saveData();
    },
    DraftButtonDown: function(){
    	var me = this;
    	
    	me.draftData();
    },
    DraftCancelButtonDown: function(){
    	var me = this;
    	
    	me.draftcancelData();
    },
    ConfirmButtonDown: function(){
    	var me = this;
    	
    	me.confirmData();
    },
    ConfirmCancelButtonDown: function(){
    	var me = this;
    	
    	me.confirmcancelData();
    },
    ReturnButtonDown: function(){
    	var me = this;
    	
    	me.returnData();
    },
    ReturnCancelButtonDown: function(){
    	var me = this;
    	
    	me.returncancelData();
    },
    DoubleLineButtonDown: function(){
    	var me = this;
    	
    	me.doublelineData();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
	    function(btn) {
	        if (btn === 'yes') {
	        	me.deleteData();
	            return true;
	        } else {
	            return false;
	        }
		});
    },
    CancelButtonDown: function(){
    	var me = this;
    	
		me.cancelData();
    },
    PreviewButtonDown: function(){
    	var me = this;
    	
    	me.previewData();
    },
    CommentButtonDown: function(){
    	var me = this;
    	
    	me.commentData();
    },
    CloseButtonDown: function(){
    	var me = this;
		
	    me.closeData();
	},
	PrevButtonDown: function(){
		var me = this;
		
		me.prevData();
	},
	NextButtonDown: function(){
		var me = this;
		
		me.nextData();
	},
	editData: function(){
		var me = this;
		
		me.getRegItems()['ActionType'] = NBOX_C_UPDATE;
		me.formShow();
	},
	saveData: function(){
		var me = this;
    	var editForm = me.getRegItems()['EditForm'];
    	
    	editForm.saveData();
	},
	draftData: function(){
		var me = this;
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_READ:
				var currentForm = me.getRegItems()['DetailView'];
				break;
			case NBOX_C_CREATE:
			case NBOX_C_UPDATE:
				var currentForm = me.getRegItems()['EditForm'];
				break
		}
		currentForm.draftData();
	},
	draftcancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.draftcancelData();
	},
	confirmData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.confirmData();
	},
	confirmcancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.confirmcancelData();
	},
	returnData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.returnData();
	},
	returncancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.returncancelData();
	},
	doublelineData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.doublelineData();
	},
	deleteData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.deleteData();
    },
    cancelData: function(){
    	var me = this;

    	switch(me.getRegItems()['ActionType'])
    	{
    		case NBOX_C_UPDATE:
    			me.getRegItems()['ActionType'] = NBOX_C_READ;
			break;
	    	
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    	case NBOX_C_DELETE:
				break;
			
    		default:
    			break;
    	}

		me.formShow();
    },
    previewData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	var documentID = approvalDetailWin.getRegItems()['DocumentID'];
    	
    	detailView.openPreviewWin(documentID);
    },
    commentData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	var documentID = approvalDetailWin.getRegItems()['DocumentID'];
    	
    	detailView.openCommentWin(NBOX_C_CREATE, documentID, null);
    },
    closeData: function(){
    	var me = this;
    	me.close();
    },
    prevData: function(){
    	var me = this;
		var masterGrid = me.getRegItems()['MasterGrid'];
		
		masterGrid.selectPrevious(false, false);
    },
    nextData: function(){
    	var me = this;
		var masterGrid = me.getRegItems()['MasterGrid'];
		
		masterGrid.selectNext(false, false);
    },
    queryData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	
    	detailView.queryData();
    },
    formShow: function(){
		var me = this;
		var detailToolbar = me.getRegItems()['DetailToolbar'];
		var detailView = me.getRegItems()['DetailView'];
		/*var editForm = me.getRegItems()['EditForm'];*/
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_READ:
				switch(me.getRegItems()['Box']){
	    			case 'XA001': //임시문서
	    				detailToolbar.setToolBars(['edit','draft','delete', 'preview', 'close'/*, 'prev', 'next'*/], true);
	    				detailToolbar.setToolBars(['draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'comment'], false);
		    			break;
	    			case 'XA002': //기안문서
	    				detailToolbar.setToolBars(['draftcancel', 'close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'comment', 'save', 'cancel'], false);
		    			break;
	    			case 'XA003': case 'XA004': case 'XA011':  //미결문서,기결문서
	    				detailToolbar.setToolBars(['comment','close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
		    			break;
	    			case 'XA005':  case 'XA006': case 'XA007':	case 'XA008': case 'XA009': case 'XA010': //예결문서, 참조, 수신, 발신, 회사결재문서함, 개인결재문서함
	    				detailToolbar.setToolBars(['comment', 'close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
		    			break;
		    		default:
		    			break;
	    		}    				
				
				detailToolbar.setToolBars(['save', 'cancel', 'doubleline'], false);
				detailView.clearData();
				detailView.show();
				/*editForm.hide();*/
				
				detailView.queryData();
				break;
				
			case NBOX_C_UPDATE:
				detailToolbar.setToolBars(['save', 'draft', 'cancel', 'close'], true);
				detailToolbar.setToolBars(['edit', 'draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'preview', 'comment'/*, 'prev', 'next'*/], false);
				
				/*editForm.clearData();*/
				
				detailView.hide();
				/*editForm.show();*/
				
				/*editForm.queryData();*/
				break;

			case NBOX_C_DELETE:
				detailView.hide();
				/*editForm.hide();*/
				break;
				
			default:
				detailView.clearData();
			
				detailView.show();
				/*editForm.hide();*/
				break;
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

//Comment Window
Ext.define('nbox.approvalCommentWindow',{
	extend: 'Ext.window.Window',
	config: {
		regItems: {}    	
	},
	layout: {
        type: 'fit'
    },
	title: '댓글',
	x:20,
    y:20,
    width: commentWidth,
    height: commentHeight,
    modal: true,
    resizable: false,
    closable: false,
    initComponent: function () {
		var me = this;
       
        var commentToolbar = Ext.create('nbox.approvalCommentToolbar', {});
		var commentEditForm = Ext.create('nbox.approvalCommentEdit',{});
        
		me.getRegItems()['CommentToolbar'] = commentToolbar;
		commentToolbar.getRegItems()['ParentContainer'] = me;
		me.getRegItems()['CommentEditForm'] = commentEditForm;
		commentEditForm.getRegItems()['ParentContainer'] = me;
		commentEditForm.getRegItems()['StoreData'] = commentStore;
		
		me.dockedItems = [commentToolbar];
		me.items = [commentEditForm];
		
		me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> approvalCommentWindow');
    		me.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> approvalCommentWindow')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		var commentGrid = me.getRegItems()['CommentGrid'];
    		
    		console.log(me.id + ' beforeclose -> approvalCommentWindow')
    		commentGrid.queryData();
    		approvalCommentWin = null;
    	}
    },
    SaveButtonDown: function(){
		var me = this;
		
    	me.saveData();	
    },
    CancelButtonDown: function(){
		var me = this;
		
	    me.closeData();
    },
    saveData: function(){
		var me = this;
    	var commentEditForm = me.getRegItems()['CommentEditForm'];
    	commentEditForm.saveData();	
    },
    closeData: function(){
		var me = this;
	    me.close();
    },
    formShow: function(){
		var me = this;
		var commentEditForm = me.getRegItems()['CommentEditForm'];
		
		commentEditForm.clearData();
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
	    		break;
	    		
			case NBOX_C_READ:
				break;
				
			case NBOX_C_UPDATE:
				commentEditForm.queryData();
				break;

			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
	}
});
/**************************************************
 * Create
 **************************************************/



/**************************************************
 * User Define Function
 **************************************************/
//Detail Window Open
function openApprovalDetailWin(obj, box, actionType, documentID) {
	// approvalDetailWin
	if(!approvalDetailWin){
		approvalDetailWin = Ext.create('nbox.approvalDetailWindow', { 
		}); 
	} 
	
	approvalDetailWin.getRegItems()['MasterGrid'] = obj;
	approvalDetailWin.getRegItems()['Box'] = box;
	approvalDetailWin.getRegItems()['DocumentID'] = documentID;
	approvalDetailWin.getRegItems()['ActionType'] = actionType;
	
	approvalDetailWin.show();
}	

//Comment Window Open
function openApprovalCommentWin(obj, actionType, documentID, seq){
	
	if(!approvalCommentWin){
		approvalCommentWin = Ext.create('nbox.approvalCommentWindow', {
		}); 
	}
	
	approvalCommentWin.getRegItems()['CommentGrid'] = obj;
	approvalCommentWin.getRegItems()['DocumentID'] = documentID;
	approvalCommentWin.getRegItems()['Seq'] = seq;
	approvalCommentWin.getRegItems()['ActionType'] = actionType;
		
	approvalCommentWin.show();
}
