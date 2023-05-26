/**************************************************
 * Common variable
 **************************************************/
//local  variable

/**************************************************
 * Common Code
 **************************************************/

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.mailEditorModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'FROMUSER'}, 
    	{name: 'TOUSER'},
    	{name: 'CC'},
    	{name: 'BCC'},
    	{name: 'SENTTIME'},
    	{name: 'RECVTIME'},
    	{name: 'SUBJECT'},
    	{name: 'ATTACHS'},
    	{name: 'CIDS'},
    	{name: 'MESSAGEHTML'},
    	{name: 'MESSAGETEXT'}
    ]
});

Ext.define('nbox.mail.mailAddressModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'ContactID'},
    	{name: 'ContactName'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.mail.mailEditorStore', {
	extend: 'Ext.data.Store',
 	model: 'nbox.mailEditorModel',
	autoLoad: false,
	proxy: {
		type: 'direct',
	    api: { read: 'nboxMailService.getMailboxView' },
	    reader: {
	        type: 'json',
	        root: 'records'
        }
    }
});	

Ext.define('nbox.mail.mailAddressToStore', {
	extend: 'Ext.data.Store',
 	model: 'nbox.mail.mailAddressModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	}
});	

Ext.define('nbox.mail.mailAddressCcStore', {
	extend: 'Ext.data.Store',
 	model: 'nbox.mail.mailAddressModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	}
});	

Ext.define('nbox.mail.mailAddressBccStore', {
	extend: 'Ext.data.Store',
 	model: 'nbox.mail.mailAddressModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	}
});	

/**************************************************
 * To Panel
 **************************************************/
Ext.define('nbox.mailEditorTo', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'hbox'
	},
	padding: '5px 0px 0px 0px',
	border: false,
	initComponent: function () {
		var me = this;
		
		me.items = [
			{
			    xtype : 'label',
			    width: 100,
			    text: '받는사람'
			},
			{
				xtype: 'checkboxfield',
				name: 'SELFFLAG',
				boxLabel: '내게쓰기',
				width: 100,
				inputValue: '1',
				handler: function (obj, value) {
					var toUser = Ext.getCmp('nboxMailEditorTOUSER');
					var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
					var myEmail = win.getRegItems()['MYEMAIL'];
						
					if (value){
						toUser.setValue(myEmail);
					} else {
						toUser.setValue('');
					}
				}
			},
			{ 
				xtype: 'textfield',
				id: 'nboxMailEditorTOUSER',
				name: 'TOUSER',
				labelClsExtra: 'required_field_label',
				allowBlank: false,
				flex: 1
			},
			{
				xtype: 'button',
				text: '주소록',
				style: {
					'margin': '0px 5px 0px 5px'
				},
				handler: function() {
					me.getRegItems()['ParentContainer'].MailAddressButtonDown();
				}		            
	        },
			{
				xtype: 'checkboxfield',
				boxLabel: '개인별',
				name: 'PERSONALFLAG',
				width: 100,
				inputValue: '1'
			}
		];

  		me.callParent();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	if (!store) return;
    	/* if (!store) return;
    	
    	me.clearPanel(); */
    	
    	store.removeAll();
    },
	loadData: function(){
		var me = this;
    	var store = me.getRegItems()['Store'];
    	if (!store) return;
    	
    	var frm = me.getForm();
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    confirmData: function(){
    	var me = this;
    	
    	me.setAddressStore();
    },    
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
    	if (!frm) return;

		frm.reset();
    },
    getAddressStore: function(){
    	var me = this;
    	me. clearData();
    	
    	var store = me.getRegItems()['Store'];
    	var mailEditToUser = Ext.getCmp('nboxMailEditorTOUSER');
    	
    	// 좌쪽공백제거 : .replace(/^\s+/, "")    
    	// 우족공백제거 : .replace(/\s+$/, "") 
    	var toUserValue = mailEditToUser.getValue().replace(/^\s+/, "").replace(/\s+$/, "");
    	
    	var tLen = toUserValue.length;
    	if(tLen < 1) return ;
    	
    	var records=[];
    	var idx = 0;
    	
    	do {
    	    
    		idx = toUserValue.search(',');
    		if(idx == -1) idx = tLen;
    		    		
    		var record = {
    			'ContactName': 	toUserValue.substring(0,idx)
    		};
    		
    		records.push(record);
    		toUserValue = toUserValue.substring(idx+1,tLen);
    		
    	} while (idx < tLen);
    	
    	store.add(records);
    },
    setAddressStore: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var mailEditToUser = Ext.getCmp('nboxMailEditorTOUSER');
    	var toUserValue = ''; 
    	
    	Ext.each(store.data.items, function(record) {
    		toUserValue = toUserValue + ',' + record.data.ContactName;
   		}); 
    	
    	toUserValue = toUserValue.substring(1, toUserValue.length)
    	mailEditToUser.setValue(toUserValue);
    }
});

/**************************************************
 * mail Editor Expand & Collapse Image
 **************************************************/
Ext.define('nbox.mailEditorExpandCollapseImg', {
	extend: 'Ext.Img',
	config: {
		regItems: {}
       },
	id: 'nboxMailEditorExpandCollapseImg',
	title: '숨은 참조 Expand/Collapse',
	src: NBOX_IMAGE_PATH + 'btn_s_open.gif',
       width: 12,
       height: 12,
       style: {
       	'cursor': 'pointer',
       	'margin': '0px 88px 0px 0px'
       },
       listeners: {
           el: {
               click: function() {
               	var img = Ext.getCmp('nboxMailEditorExpandCollapseImg');
               	var pimg = img.getRegItems()['ParentContainer'];
               	var ppimg = pimg.getRegItems()['ParentContainer'];
               	var mailEditorBcc = ppimg.getRegItems()['MailEditorBcc']
               	
               	if (this.dom.src.indexOf("btn_s_open") >= 0){
               		img.setSrc(NBOX_IMAGE_PATH + 'btn_s_close.gif');
               		mailEditorBcc.show();
               	} else {
                   	img.setSrc(NBOX_IMAGE_PATH + 'btn_s_open.gif');
                   	mailEditorBcc.hide();
               	}
               }
           }
       }
});

/**************************************************
 * Cc Panel
 **************************************************/
Ext.define('nbox.mailEditorCc', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'hbox'
	},
	padding: '5px 0px 0px 0px',
	border: false,
	initComponent: function () {
		var me = this;
		var mailEditorExpandCollapseImg = Ext.create('nbox.mailEditorExpandCollapseImg',{});
		
		me.getRegItems()['MailEditorExpandCollapseImg'] = mailEditorExpandCollapseImg;
		mailEditorExpandCollapseImg.getRegItems()['ParentContainer'] = me;
		
		me.items = [
			{
			    xtype: 'label',
			    width: 100,
			    text: '참조'
			},
			mailEditorExpandCollapseImg,
			{ 
				xtype: 'textfield',
				id: 'nboxMailEditorCCUSER',
				name: 'CC',
				flex: 1
			},
			{
	            xtype: 'button',
	            text : '주소록',
	            style: {
	            	'margin': '0px 0px 0px 5px'
	            },
	            handler : function() {
	            	me.getRegItems()['ParentContainer'].MailAddressButtonDown();
	            }		            
	        }
		];

  			me.callParent();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (!store) return;
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    confirmData: function(){
    	var me = this;
    	
    	me.setAddressStore();
    },
    clearPanel: function(){
    	var me = this;
    	//var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
    	if (!store) return;
    	//if (!frm) return;

		store.removeAll();
		//frm.reset();
    },
    getAddressStore: function(){
    	var me = this;
    	me. clearData();
    	
    	var store = me.getRegItems()['Store'];
    	var mailEditorCCUSER = Ext.getCmp('nboxMailEditorCCUSER');
    	
    	// 좌쪽공백제거 : .replace(/^\s+/, "")    
    	// 우족공백제거 : .replace(/\s+$/, "") 
    	var ccUserValue = mailEditorCCUSER.getValue().replace(/^\s+/, "").replace(/\s+$/, "");
    	
    	var tLen = ccUserValue.length;
    	if(tLen < 1) return ;
    	
    	var records=[];
    	var idx = 0;
    	
    	do {
    	    
    		idx = ccUserValue.search(',');
    		if(idx == -1) idx = tLen;
    		    		
    		var record = {
    			'ContactName': 	ccUserValue.substring(0,idx)
    		};
    		
    		records.push(record);
    		ccUserValue = ccUserValue.substring(idx+1,tLen);
    		
    	} while (idx < tLen);
    	
    	store.add(records);
    },
    setAddressStore: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var mailEditorCCUSER = Ext.getCmp('nboxMailEditorCCUSER');
    	var ccUserValue = ''; 
    	
    	Ext.each(store.data.items, function(record) {
    		ccUserValue = ccUserValue + ',' + record.data.ContactName;
   		}); 
    	
    	ccUserValue = ccUserValue.substring(1, ccUserValue.length)
    	mailEditorCCUSER.setValue(ccUserValue);
    }
});

/**************************************************
 * Bcc Panel
 **************************************************/
Ext.define('nbox.mailEditorBcc', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'hbox'
	},
	padding: '5px 0px 0px 0px',
	hidden: true,
	border: false,
	initComponent: function () {
		var me = this;
		
		me.items = [
			{
			    xtype: 'label',
			    width: 200,
			    text: '숨은참조'
			},
               { 
               	xtype: 'textfield',
               	id: 'nboxMailEditorBCCUSER',
				name: 'BCC',
				flex: 1
			},
			{
	            xtype: 'button',
	            text : '주소록',
	            style: {
	            	'margin': '0px 0px 0px 5px'
	            },
	            handler : function() {
	            	me.getRegItems()['ParentContainer'].MailAddressButtonDown();
	            }		            
	        }
		];

  			me.callParent();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    confirmData: function(){
    	var me = this;
    	
    	me.setAddressStore();
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (!store) return;
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	//var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
    	if (!store) return;
    	//if (!frm) return;

		store.removeAll();
		//frm.reset();
    },
    getAddressStore: function(){
    	var me = this;
    	me. clearData();
    	
    	var store = me.getRegItems()['Store'];
    	var mailEditorBCCUSER = Ext.getCmp('nboxMailEditorBCCUSER');
    	
    	// 좌쪽공백제거 : .replace(/^\s+/, "")    
    	// 우족공백제거 : .replace(/\s+$/, "") 
    	var bccUserValue = mailEditorBCCUSER.getValue().replace(/^\s+/, "").replace(/\s+$/, "");
    	
    	var tLen = bccUserValue.length;
    	if(tLen < 1) return ;
    	
    	var records=[];
    	var idx = 0;
    	
    	do {
    	    
    		idx = bccUserValue.search(',');
    		if(idx == -1) idx = tLen;
    		    		
    		var record = {
    			'ContactName': 	bccUserValue.substring(0,idx)
    		};
    		
    		records.push(record);
    		bccUserValue = bccUserValue.substring(idx+1,tLen);
    		
    	} while (idx < tLen);
    	
    	store.add(records);
    },
    setAddressStore: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var mailEditorBCCUSER = Ext.getCmp('nboxMailEditorBCCUSER');
    	var bccUserValue = ''; 
    	
    	Ext.each(store.data.items, function(record) {
    		bccUserValue = bccUserValue + ',' + record.data.ContactName;
   		}); 
    	
    	bccUserValue = bccUserValue.substring(1, bccUserValue.length)
    	mailEditorBCCUSER.setValue(bccUserValue);
    }
});

/**************************************************
 * Title Panel
 **************************************************/
Ext.define('nbox.mailEditorTitle', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'hbox'
	},
	padding: '5px 0px 0px 0px',
	border: false,
	initComponent: function () {
		var me = this;
		
		me.items = [
			{
			    xtype: 'label',
			    width: 100,
			    text: '제목'
			},
			{
				xtype: 'checkboxfield',
				name: 'IMPORTANTFLAG',
				boxLabel: '중요',
				width: 45,
				inputValue: '1'
			},
			{
				xtype:'image',
				alt: '중요',
				src: NBOX_IMAGE_PATH + 'important.gif',
				width: 7,
				height: 11,
				style: {
					'margin': '5px 48px 0px 0px'
				}
			},
			{
				xtype: 'textfield',
				name: 'SUBJECT',
				labelClsExtra: 'required_field_label',
				allowBlank: false,
				flex: 1
			}
		];

  		me.callParent();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (!store) return;
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
    	if (!store) return;
    	if (!frm) return;

		store.removeAll();
		frm.reset();
    }
});

/**************************************************
 * HTMLEditor Panel
 **************************************************/	
Ext.define('nbox.mailEditorHtmlEditor', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'fit'
	},
	padding: '5px 0px 0px 0px',
	border: false,
	initComponent: function () {
		var me = this;
		
		me.items = [
			{
				xtype: 'htmleditor',
				name: 'MESSAGEHTML',
	        	flex: 1
	        }
		];

  			me.callParent();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (!store) return;
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
    	if (!store) return;
    	if (!frm) return;

		store.removeAll();
		frm.reset();
    }
});

/**************************************************
 * FileUpload Panel
 **************************************************/
Ext.define('nbox.mailEditorFilePanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
       },
       layout: {
		type: 'hbox'
	},
	padding: '5px 0px 0px 0px',
	border: false,
	initComponent: function () {
		var me = this;
		
    	var mailEditorUploadPanel = Ext.create('Unilite.com.panel.UploadPanel', {
    		id: 'nboxMailEditorUploadPanel',
		   	itemId: 'mailEditorUploadPanel',
		   	url: CPATH + '/nboxfile/mailupload.do',
		   	downloadUrl: CPATH + '/nbox/maildownload.do',
	    	flex: 1, 
	    	height: 200,
	    	listeners: {
	    		change: function(obj) {
	    			obj.store.sync();
	    		}
	    	},
	    	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
	    		var me = this;
	        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
	        	var colName = ct.dataIndex;
	        	if(colName == 'name') {
	        		var status = record.get('status');
	        		if( status  >= 5) {
		        		var fid = record.get('fid');
		        		var name = record.get('name');
		        		var contenttype = record.raw.contenttype;
		        		var mailattachid = record.raw.mailattachid;
		        		var url = me.downloadUrl; // +"?inline=N&fid=" +  fid;
						me.onDownload(url, fid, name, contenttype, mailattachid);
	        		} else {
	        			alert('전송 되지 않은 파일입니다.')
	        		}
	        	}
	    	},
	    	onDownload : function(url, fid, name, contenttype, mailattachid) {
	    		var mailboxIdx = null;
	    		var mailID = null;	    		
	    		 
	    		if (mailEditorWin){
		    		mailboxIdx = mailEditorWin.getRegItems()['MailboxIdx'];
		    		mailID = mailEditorWin.getRegItems()['MailID'];
	    		}
	    		
	    		var reUrl = url + '?fid=' + fid
	    		 	+ '&name=' + name
	    			+ '&contenttype=' + contenttype
	    			+ "&mailattachid=" + mailattachid
	    			+ "&MailboxIdx=" + mailboxIdx
	    			+ "&MailID=" + mailID;
	    			
		        window.open (reUrl);
			},
			PluploadFileUploaded : function(uploader, file, status) {
				var response = Ext.JSON.decode(status.response);
				if (response.success == true) {
					file.server_error = 0;
					// fid update
					file.fid = response.fid;
					file.contenttype = response.contenttype;
					file.mailattachid = response.mailattachid;
					this.success.push(file);
				} else {
					if (response.message) {
						file.msg = '<span style="color: red">' + response.message
								+ '</span>';
					}
					file.server_error = 1;
					this.failed.push(file);
				}
				this.updateStoreFile(file);
				if(this.showProgressBBar) {
					this.updateProgress(file);
				};
			},
			getFiles: function() {
				var me = this, store = this.store;
		        var rv= me._convertRecToArrayForFiles(store.data.items);//return fid array
		        return rv;
			},
			getFilesName: function() {
				var me = this, store = this.store;
		        var rv= me._convertRecToArrayForFilesName(store.data.items);
		        return rv;
			},
			getAddFilesName: function() {
				var me = this, store = this.store;
				var all = store.data.filterBy(function(item) {return item.data.status != 6;}).items;
		        var rv= me._convertRecToArrayForAddFilesName(all);
		        return rv;
			},
			getMailAttachids: function() {
				var me = this, store = this.store;
		        var rv= me._convertRecToArrayForMailAttachid(store.data.items);
		        return rv;
			},
			_convertRecToArrayForFiles: function(data) {
				var allArray = [];
		        Ext.each(data, function(rec) {
		        	if(rec.get('status') == 6 || rec.get('status') == 5) {
		        		allArray.push(rec.get('fid'));
		        	}
		        	
		        });
		        return allArray;
			},
			_convertRecToArrayForFilesName: function(data) {
				var allArray = [];
		        Ext.each(data, function(rec) {
		        	if(rec.get('status') == 6 || rec.get('status') == 5) {
		        		allArray.push(rec.get('name'));
		        	}
		        	
		        });
		        return allArray;
			},
			_convertRecToArrayForAddFilesName: function(data) {
				var allArray = [];
		        Ext.each(data, function(rec) {
		        	if(rec.get('status') != 6) {
		        		allArray.push(rec.get('name'));
		        	}
		        	
		        });
		        return allArray;
			},
			_convertRecToArrayForMailAttachid: function(data) {
				var allArray = [];
		        Ext.each(data, function(rec) {
		        	if(rec.raw.status == 6 || rec.raw.status == 5) {
		        		allArray.push(rec.raw.mailattachid);
		        	}
		        	
		        });
		        return allArray;
			}
		});
		
    	me.getRegItems()['MailEditorUploadPanel'] = mailEditorUploadPanel;
		
    	me.items = [mailEditorUploadPanel];

  		me.callParent();
	},
	getFiles: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getFiles();
	},
	getFilesName: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getFilesName();
	},
	getAddFiles: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getAddFiles();
	},
	getAddFilesName: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getAddFilesName();
	},
	getMailAttachids: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getMailAttachids();
	},
	getRemoveFiles: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getRemoveFiles();
	},
	getRemoveFiles: function(){
		var me = this;
		var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
		
		return mailFileUpload.getRemoveFiles();
	},
    queryData: function(){
    	var me = this;
		
		me.clearData();
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (!store) return;
    	if (!frm) return;
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
    	if (!store) return;
    	if (!frm) return;

		store.removeAll();
		frm.reset();
    }
});

/**************************************************
 * Detail Edit Panel
 **************************************************/
Ext.define('nbox.mailEditorPanel', {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
       },
	layout: {
		type: 'vbox', 
   		pack: 'start', 
   		align: 'stretch' 
	},
	padding: '5px 5px 0px 5px',
	border: false,
	api: { submit: 'nboxMailService.sendMail' },
	defaultType: 'textfield',
	initComponent: function () {
		var me = this;
		
		var mailEditorTo = Ext.create('nbox.mailEditorTo', {});
		var mailAddressToStore = Ext.create('nbox.mail.mailAddressToStore');
		me.getRegItems()['MailEditorTo'] = mailEditorTo;
		mailEditorTo.getRegItems()['ParentContainer'] = me;
		mailEditorTo.getRegItems()['Store'] = mailAddressToStore;
		
		var mailEditorCc = Ext.create('nbox.mailEditorCc', {});
		var mailAddressCcStore = Ext.create('nbox.mail.mailAddressCcStore');
		me.getRegItems()['MailEditorCc'] = mailEditorCc;
		mailEditorCc.getRegItems()['ParentContainer'] = me;
		mailEditorCc.getRegItems()['Store'] = mailAddressCcStore;
		
		var mailEditorBcc = Ext.create('nbox.mailEditorBcc', {});
		var mailAddressBccStore = Ext.create('nbox.mail.mailAddressBccStore');
		me.getRegItems()['MailEditorBcc'] = mailEditorBcc;
		mailEditorBcc.getRegItems()['ParentContainer'] = me;
		mailEditorBcc.getRegItems()['Store'] = mailAddressBccStore;
		
		var mailEditorTitle = Ext.create('nbox.mailEditorTitle', {});
		me.getRegItems()['MailEditorTitle'] = mailEditorTitle;
		mailEditorTitle.getRegItems()['ParentContainer'] = me;
		
		var mailEditorHtmlEditor = Ext.create('nbox.mailEditorHtmlEditor', {flex: 1});
		me.getRegItems()['MailEditorHtmlEditor'] = mailEditorHtmlEditor;
		mailEditorHtmlEditor.getRegItems()['ParentContainer'] = me;
		
		var mailEditorFilePanel = Ext.create('nbox.mailEditorFilePanel', {height: 150});
		me.getRegItems()['MailEditorFilePanel'] = mailEditorFilePanel;
		mailEditorFilePanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [mailEditorTo, mailEditorCc, mailEditorBcc, mailEditorTitle, mailEditorHtmlEditor, mailEditorFilePanel];

  		me.callParent();
	},
	MailAddressButtonDown: function(){
		var me = this;
		
		me.openMailAddress();
	},
    queryData: function(){
    	var me = this;
		var store = me.getRegItems()['Store'];
			
   		me.clearData();
   		
		store.proxy.setExtraParam('Type', me.getRegItems()['Type']);
   		store.proxy.setExtraParam('MailboxIdx', me.getRegItems()['MailboxIdx']);
   		store.proxy.setExtraParam('MailID', me.getRegItems()['MailID']);
		
		store.load({
			callback: function(records, operation, success) {
				if (success){
					me.loadData();
				}
			}
		});
    },
    sendMailData: function(){
    	var me = this;
		var mailEditorFilePanel = me.getRegItems()['MailEditorFilePanel'];
		
		var files = mailEditorFilePanel.getFiles();
		var filesName = mailEditorFilePanel.getFilesName();
		var mailAttchids = mailEditorFilePanel.getMailAttachids();
		var delFiles = mailEditorFilePanel.getRemoveFiles();
		if (files.length == 0) files = null;
		if (filesName.length == 0) filesName = null;
		if (mailAttchids.length == 0) mailAttchids = null;
		if (delFiles.length == 0) delFiles = null;
		
		var param = {'FID': files, 'FNM':filesName, 'MATID':mailAttchids, 'DELFID': delFiles
			, 'MailboxIdx': me.getRegItems()['MailboxIdx'], 'MailID': me.getRegItems()['MailID']};
		
		if (me.isValid()) {
		me.submit({
           params: param,
               success: function(obj, action) {
               	Ext.Msg.alert('확인','메일을 발송했습니다.');
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
      	var store = me.getRegItems()['Store'];
      	var frm = me.getForm();
      	
      	if (store.getCount() > 0)
      	{
			var record = store.getAt(0);
			frm.loadRecord(record);
			
			switch(me.getRegItems()['Type']){
				case 'VIEW':
					break;
					
				case 'REPLY':
					var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
					mailFileUpload.clear();
					break;
					
				case 'FORWARD':
					me.getFileListFromMail();
					break;
					
				default:
					
					break;
			}
				
      	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['Store'];
    	
		store.removeAll();
		frm.reset();
    },
    validationCheck: function(){
    	var me = this;
    	
    	var fields = me.getForm().getFields();
    	var result = '';
    	
    	var itemCnt = fields.getCount();
    	for(var idx = 0; idx < itemCnt; idx++){
    		if(!fields.items[idx].isValid()){
    			result += fields.items[idx].getFieldLabel() + ',';
    		}
    	}
    	
    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
    },
    getFileListFromMail: function(){
    	var me = this;
    	
    	nboxMailService.getFileListFromMail({'MailboxIdx' :  me.getRegItems()['MailboxIdx'], 'MailID' : me.getRegItems()['MailID']},
			function(provider, response) {
				var mailFileUpload = Ext.getCmp('nboxMailEditorUploadPanel');
				if (response.result.length > 0){
					mailFileUpload.setVisible(true);
					mailFileUpload.loadData(response.result);
				}
				else{
					mailFileUpload.clear();
				}
			}
		);
    },
    setUserEmail: function(){
    	var me = this;
    	
    	var toUser = Ext.getCmp('nboxMailEditorTOUSER');
		var useremail = me.getRegItems()['USEREMAIL']  ;
		
		toUser.setValue(useremail);
    },
    openMailAddress: function(){
    	var me = this;
    	
    	var mailEditorTo = me.getRegItems()['MailEditorTo'];
		var mailEditorCc = me.getRegItems()['MailEditorCc'];
		var mailEditorBcc = me.getRegItems()['MailEditorBcc'];
		
		mailEditorTo.getAddressStore();
		openMailAddressPopupWin(mailEditorTo,mailEditorCc,mailEditorBcc);
    }
});
	
/**************************************************
 * Editor toolbar
 **************************************************/
Ext.define('nbox.mailEditorToolbar',    {
	extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	config: {
		regItems: {}
	},		
	initComponent: function () {
    	var me = this;
    	
    	var btnSendMail = {
			xtype: 'button',
			text: '보내기',
			tooltip : '보내기',
			itemId : 'send',
               
			handler: function() { 
				me.getRegItems()['ParentContainer'].SendMailButtonDown();
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
    		    	
		me.items = [btnSendMail, btnClose]; 
			
    	me.callParent(); 
    },
	
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
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

/**************************************************
 * Editor Window
 **************************************************/
Ext.define('nbox.mailEditorWindow',{
	extend: 'Ext.window.Window',
	width: 700,
	height: 700,
	maximizable: true,
	buttonAlign: 'right',
	modal: true,
	resizable: true,
	closable: false,
	layout: {
	    type: 'fit'
	},
	config: {
		regItems: {}   	
	},
	
	initComponent: function () {
		var me = this;
			
		var mailEditorToolbar = Ext.create('nbox.mailEditorToolbar', {});
		var mailEditorPanel = Ext.create('nbox.mailEditorPanel', {});
			
		mailEditorToolbar.getRegItems()['ParentContainer'] = me;
		me.getRegItems()['MailEditorToolbar'] = mailEditorToolbar;
		
		var mailEditorStore = Ext.create('nbox.mail.mailEditorStore', {});
		mailEditorPanel.getRegItems()['ParentContainer'] = me;
		mailEditorPanel.getRegItems()['Store'] = mailEditorStore;
		me.getRegItems()['MailEditorPanel'] = mailEditorPanel;
       	
		me.dockedItems = [mailEditorToolbar];
		me.items = [mailEditorPanel];
		
		me.callParent(); 
	},
	listeners: {
		beforeshow: function(obj, eOpts){
			var me = this;
			var mailEditorPanel = me.getRegItems()['MailEditorPanel'];
			
			console.log(me.id + ' beforeshow -> detailWindow');
			
			if(me.getRegItems()['USEREMAIL']){
				mailEditorPanel.getRegItems()['USEREMAIL'] = me.getRegItems()['USEREMAIL'];
				mailEditorPanel.setUserEmail();
			}
			
			if (me.getRegItems()['Type'] && me.getRegItems()['MailboxIdx'] && me.getRegItems()['MailID']){
				mailEditorPanel.getRegItems()['Type'] = me.getRegItems()['Type']; 
				mailEditorPanel.getRegItems()['MailboxIdx'] = me.getRegItems()['MailboxIdx'];
				mailEditorPanel.getRegItems()['MailID'] = me.getRegItems()['MailID'];
				mailEditorPanel.queryData();
			}
		},
		beforehide: function(obj, eOpts){
			var me = this;
			
			console.log(me.id + ' beforehide -> detailWindow')
		},
		beforeclose: function(obj, eOpts){
			var me = this;
		
			console.log(me.id + ' beforeclose -> detailWindow')
			mailEditorWin = null;
		},
	},
	SendMailButtonDown: function(){
		var me = this;
	    	
	    me.sendMailData();
	},
	EditButtonDown: function() {
		var me = this;
		
		me.editData();
	},
	SaveButtonDown: function(){
		var me = this;
		
		me.saveData();
	},
	TrashButtonDown: function(){
		var me = this;
		
		Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
			function(btn) {
				if (btn === 'yes') {
					me.trashData();
					return true;
				} else {
					return false;
			}
		});
	},
	SpamButtonDown: function(){
		var me = this;
		
		Ext.Msg.confirm('확인', '스팸처리 하시겠습니까?', 
			function(btn) {
				if (btn === 'yes') {
					me.spamData();
					return true;
				} else {
					return false;
			}
		});
	},
	DeleteButtonDown: function(){
		var me = this;
		
		Ext.Msg.confirm('확인', '완전 삭제 하시겠습니까?', 
			function(btn) {
				if (btn === 'yes') {
					me.deleteData();
					return true;
				} else {
					return false;
			}
		});
	},
	CancelButtonDown: function(actionType){
		var me = this;
		  	
		me.cancelData();
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
	
	sendMailData: function(){
    	var me = this;
    	var mailEditorPanel = me.getRegItems()['MailEditorPanel'];
    	
    	mailEditorPanel.sendMailData();
    },
	editData: function(){
		var me = this;
	
	},
	saveData: function(){
		var me = this;
	
	},
	trashData: function(){
		var me = this;
	
	},
	spamData: function(){
		var me = this;
	
	},
	deleteData: function(){
		var me = this;
	
	},
	cancelData: function(){
		var me = this;
	
	},
	commentData: function(){
		var me = this;
		
	},
	closeData: function(){
		var me = this;
			
		me.close();
	},
	prevData: function(){
		var me = this;
	
	},
	nextData: function(){
		var me = this;
	
	},
	queryData: function(){
		var me = this;
	
	},
	
	formShow: function(){
		var me = this;
		
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