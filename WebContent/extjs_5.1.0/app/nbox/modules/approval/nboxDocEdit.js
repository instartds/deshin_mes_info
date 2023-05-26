/**************************************************
 * Common variable
 **************************************************/
var docEditPanelWidth = 660;
var docControlPanelWidth = 650;

/**************************************************
 * combo store
 **************************************************/
/* 보안등급 */
Ext.define('nbox.secureGradeStore', {
	extend: 'Ext.data.Store',
	fields: ["CODE", 'NAME'],
	
	autoLoad: true,
	proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NA04'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
	}
});

/* 회사문서함*/
Ext.define('nbox.cabinetMenuStore', {
	extend: 'Ext.data.Store',
	fields: ["pgmID", 'pgmName'],
	
	autoLoad: true,
	proxy: {
		type: 'direct',
    	api: { read: 'nboxDocCommonService.selectCabinetItem' },
	    reader: {
	        type: 'json',
	        root: 'records'
    	}
	}
});

	
/**************************************************
 * Model
 **************************************************/
//Detail Edit
Ext.define('nbox.docEditModel', {
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
    	{name: 'DoubleLineFirstFlag'},
    	{name: 'SecureGrade'},
    	{name: 'CabinetID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docEditStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditModel',
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


/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docEditExpandCollapseImg', {
	extend: 'Ext.Img',
	config: {
		regItems: {}
	},
	id: 'nboxDocEditExpandCollapseImg',
	title: 'Expand/Collapse',
	src: NBOX_IMAGE_PATH + 'btn_open.gif',
	
	width: 23,
	height: 23,
	
	style: {
		'padding': '5 0 0 5',
	   	'cursor': 'pointer',
	   	'margin': '0px 88px 0px 0px'
	},
	listeners: {
		el: {
			click: function() {
				var img = Ext.getCmp('nboxDocEditExpandCollapseImg');
				var panel = img.getRegItems()['ParentContainer'].getRegItems()['DocEditExpandCollapsePanel'];
				
				if (this.dom.src.indexOf("btn_open") >= 0){
					img.setSrc(NBOX_IMAGE_PATH + 'btn_close.gif');
					panel.show();
				} else {
					img.setSrc(NBOX_IMAGE_PATH + 'btn_open.gif');
					panel.hide();
	           	}
			}
		}
	}
});

Ext.define('nbox.docEditExpandCollapsePanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'vbox'
	},
	
	border: false,
	hidden: true,
	
	initComponent: function () {
		var me = this;

		var secureGradeStore = Ext.create('nbox.secureGradeStore', {});
		var cabinetMenuStore = Ext.create('nbox.cabinetMenuStore', {});
		
		var docEditTempPanel1 = Ext.create('Ext.panel.Panel', { 
        	layout: {
				type: 'table' ,
				columns: 2,
				tdAttrs:{
					style: {
					 	'padding': '5px 0px 0px 0px'
				   	}
				} 
			},
			
			border: false,
			defaultType: 'textfield',
			items: [
				{ 
					xtype: 'combo', 
					id: 'DocEditSecureGrade',
					name:'SecureGrade',
					fieldLabel: '보안등급', 
					store: secureGradeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					width: 325
				}, 
				{ 
					xtype: 'combo', 
					id: 'DocEditCabinetID',
					name:'CabinetID',
					fieldLabel: '문서함', 
					store: cabinetMenuStore, 
					displayField:'pgmName', 
					valueField: 'pgmID', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					width: 325
				}
			]
        });		
		
		var docEditRcvUserPanel = Ext.create('nbox.docEditRcvUserPanel', {});
		var docEditRefUserPanel = Ext.create('nbox.docEditRefUserPanel', {});
		var docEditBasisPanel = Ext.create('nbox.docEditBasisPanel', {});
		
		me.getRegItems()['DocEditRcvUserPanel'] = docEditRcvUserPanel;
		docEditRcvUserPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditRefUserPanel'] = docEditRefUserPanel;
		docEditRefUserPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditBasisPanel'] = docEditBasisPanel;
		docEditBasisPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [docEditTempPanel1, docEditRcvUserPanel, docEditRefUserPanel, docEditBasisPanel] ;
		me.callParent();
	},
	queryData: function(){
		var me = this;

		var docEditRcvUserPanel = me.getRegItems()['DocEditRcvUserPanel'];
		var docEditRefUserPanel = me.getRegItems()['DocEditRefUserPanel'];
		var docEditBasisPanel = me.getRegItems()['DocEditBasisPanel'];
		
		docEditRcvUserPanel.queryData();
		docEditRefUserPanel.queryData();
		docEditBasisPanel.queryData();
	},
	clearData: function(){
		var me = this;

		var docEditRcvUserPanel = me.getRegItems()['DocEditRcvUserPanel'];
		var docEditRefUserPanel = me.getRegItems()['DocEditRefUserPanel'];
		var docEditBasisPanel = me.getRegItems()['DocEditBasisPanel'];
		
		docEditRcvUserPanel.clearData();
		docEditRefUserPanel.clearData();
		docEditBasisPanel.clearData();
	}
});

Ext.define('nbox.docEditHeaderPanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'vbox'
	},
    
    border: false,
    padding: '5px 0px 0px 0px',
    
    initComponent: function () {
    	var me = this;

    	var docEditFormStore = Ext.create('nbox.docEditFormStore',{});
    	var docEditFormCombo = Ext.create('nbox.docEditFormCombo',{
			store: docEditFormStore
		});
		
		var docEditExpandCollapseImg = Ext.create('nbox.docEditExpandCollapseImg',{});
		var docEditTempPanel1 = Ext.create('Ext.panel.Panel', {
			layout: {
				type: 'hbox'
			},
			padding: '5px 0px 0px 0px',
			border: false,
			defaultType: 'textfield',
			items: [
				{ 
					name: 'Subject',
					fieldLabel: '제목',
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					width: docControlPanelWidth - 23,
					allowBlank:false
				},
				docEditExpandCollapseImg
			]
		});		
		
		var docEditExpandCollapsePanel = Ext.create('nbox.docEditExpandCollapsePanel', {});
		
		me.getRegItems()['DocEditFormCombo'] = docEditFormCombo;
		docEditFormCombo.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditExpandCollapseImg'] = docEditExpandCollapseImg;
		docEditExpandCollapseImg.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditExpandCollapsePanel'] = docEditExpandCollapsePanel;
		docEditExpandCollapsePanel.getRegItems()['ParentContainer'] = me;
				
		me.items = [docEditFormCombo, docEditTempPanel1, docEditExpandCollapsePanel];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	var docEditFormCombo = me.getRegItems()['DocEditFormCombo'];
    	var docEditExpandCollapsePanel = me.getRegItems()['DocEditExpandCollapsePanel'];
    	
    	docEditFormCombo.queryData();
    	docEditExpandCollapsePanel.queryData();
    },
    clearData: function(){
    	var me = this;
    	var docEditExpandCollapsePanel = me.getRegItems()['DocEditExpandCollapsePanel'];
    	docEditExpandCollapsePanel.clearData();
    }
});

Ext.define('nbox.docEditNorthPanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	border: false,

	initComponent: function () {
		var me = this;
		
		var docEditLinePanel = Ext.create('nbox.docEditLinePanel', {});
		var docEditHeaderPanel = Ext.create('nbox.docEditHeaderPanel', {});
		var docEditLinkDataPanel = Ext.create('nbox.docEditLinkDataPanel',{});
		var docEditContentsPanel = Ext.create('nbox.docEditContentsPanel', {});
		
		var docEditLinkDataStore = Ext.create('nbox.docEditLinkDataStore',{});
		
		me.getRegItems()['DocEditLinePanel'] = docEditLinePanel;
		docEditLinePanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditHeaderPanel'] = docEditHeaderPanel;
		docEditHeaderPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditLinkDataPanel'] = docEditLinkDataPanel;
		docEditLinkDataPanel.getRegItems()['ParentContainer'] = me;
		docEditLinkDataPanel.getRegItems()['Store'] = docEditLinkDataStore;
		
		me.getRegItems()['DocEditContentsPanel'] = docEditContentsPanel;
		docEditContentsPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [docEditLinePanel, docEditHeaderPanel, docEditLinkDataPanel, docEditContentsPanel];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var docEditLinePanel = me.getRegItems()['DocEditLinePanel'];
		var docEditHeaderPanel = me.getRegItems()['DocEditHeaderPanel'];
		//var docEditContentsPanel = me.getRegItems()['DocEditContentsPanel'];
		
		docEditLinePanel.queryData();
		docEditHeaderPanel.queryData();
		//docEditContentsPanel.queryData();
	},
	clearData: function(){
		var me = this;
		
		var docEditLinePanel = me.getRegItems()['DocEditLinePanel'];
		var docEditHeaderPanel = me.getRegItems()['DocEditHeaderPanel'];
		var docEditContentsPanel = me.getRegItems()['DocEditContentsPanel'];
		var docEditLinkDataPanel = me.getRegItems()['DocEditLinkDataPanel']; 
		
		docEditLinePanel.clearData();
		docEditHeaderPanel.clearData();
		docEditContentsPanel.clearData();
		docEditLinkDataPanel.clearData();
	}
});

Ext.define('nbox.docEditSouthPanel',{
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	
	layout: {
		type: 'fit'
	},
	
	border: false,
	
	initComponent: function () {
		var me = this;

		var docEditFilePanel = Ext.create('nbox.docEditFilePanel', {});
		
		me.getRegItems()['DocEditFilePanel'] = docEditFilePanel;
		docEditFilePanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [docEditFilePanel];
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var docEditFilePanel = me.getRegItems()['DocEditFilePanel'];
		
		docEditFilePanel.queryData();
	},
	clearData: function(){
		var me = this;
		var docEditFilePanel = me.getRegItems()['DocEditFilePanel'];
		
		docEditFilePanel.clearData();
	}
});

// Detail Edit Panel
Ext.define('nbox.docEditPanel', {
	extend: 'Ext.form.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'anchor'
    },
    
    border: false,
    flex: 1,
    width: docEditPanelWidth,
    
	api: { submit: 'nboxDocListService.save' },
	initComponent: function () {
		var me = this;
		
		var docEditNorthPanel = Ext.create('nbox.docEditNorthPanel',{
			region:'north',
			anchor: '100% 80%'
		})
		
		var docEditSouthPanel = Ext.create('nbox.docEditSouthPanel',{
			region:'south',
			anchor: '100% 20%'
		});
		
		/*
		var editExpenseDetailPanel = Ext.create('nbox.editExpenseDetailPanel',{
			width: htmlEditorWidth,
			height: 0,
			style: {
        		'margin': '0px 5px 5px 5px'
		   	}
		}); 			
		
*/
		me.getRegItems()['DocEditNorthPanel'] = docEditNorthPanel;
		docEditNorthPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocEditSouthPanel'] = docEditSouthPanel;
		docEditSouthPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [docEditNorthPanel, docEditSouthPanel];
		
  		me.callParent();
	},
	queryData: function(){
    	var me = this;
    	var win = me.getRegItems()['ParentContainer'];
    	var docEditNorthPanel = me.getRegItems()['DocEditNorthPanel'];
    	var docEditSouthPanel = me.getRegItems()['DocEditSouthPanel'];
    	
    	me.clearData();
    	
    	switch (win.getRegItems()['ActionType']){
			case NBOX_C_CREATE:
				break;
			case NBOX_C_UPDATE:
				/*var editHeaderPanel = me.getRegItems()['EditHeaderPanel'];
				var formID = me.getRegItems()['EditHeaderPanel'].items.getAt(0);
				
				formID.disabled = true;*/
				
				var store = me.getRegItems()['Store'];
				var documentID = me.getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
				
				store.proxy.setExtraParam('DocumentID', documentID);
	   			store.load({
	       			callback: function(records, operation, success) {
	       				if (success){
	       					me.loadPanel();
	       				}
	       			}
	   			});
				break;
			default:
				break;
		}
    	
    	docEditNorthPanel.queryData();
    	docEditSouthPanel.queryData();
	},	
	newData: function(){
		var me = this;
		
		me.clearData();
	},
	saveData: function(){
		var me = this;
    	var documentID = null;

    	var win = me.getRegItems()['ParentContainer'];
    	/*var editExpenseDetailPanel = me.getRegItems()['EditExpenseDetailPanel'];
    	var expenseDetailGrid = editExpenseDetailPanel.getRegItems()['ExpenseDetailGrid'];
    	
    	var addExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getNewRecords());
    	var updExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getUpdatedRecords());
    	var delExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getRemovedRecords());*/
    	
    	if (win.getRegItems()['ActionType'] == NBOX_C_UPDATE)
    		documentID = win.getRegItems()['DocumentID'];

    	var isNew = (documentID == "" || documentID == null);
    	
    	var formCombo = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditFormCombo'] ;
    	var formID = formCombo.getValue(); 
		
    	var docEditFilePanel = me.getRegItems()['DocEditSouthPanel'].getRegItems()['DocEditFilePanel'];
		var addFiles = docEditFilePanel.getAddFiles();
		var delFiles = docEditFilePanel.getRemoveFiles();
		
		var linkdatalist = [];
		var columns = ['id','value','rawValue'];
		var docEditLinkDataPanel =  me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinkDataPanel'];
		Ext.each(docEditLinkDataPanel.items.items,function(item){
			linkdatalist.push(me.JSONtoString(item,columns));
		});
		
		if (linkdatalist.length == 0) linkdatalist = null;
		
		var docEditLineView = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinePanel'].getRegItems()['DocEditLineView'];
		var docEditExpandCollapsePanel = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditExpandCollapsePanel'];
		var docEditRcvUserView = docEditExpandCollapsePanel.getRegItems()['DocEditRcvUserPanel'].getRegItems()['DocEditRcvUserView'];
    	var docEditRefUserView = docEditExpandCollapsePanel.getRegItems()['DocEditRefUserPanel'].getRegItems()['DocEditRefUserView'];
    	var docEditBasisView   = docEditExpandCollapsePanel.getRegItems()['DocEditBasisPanel'].getRegItems()['DocEditBasisView'];
    	
		var doclinelist = []; 
		var doclines = docEditLineView.getStore().data.items;
		Ext.each(doclines,function(record){
			doclinelist.push(me.JSONtoString(record.data));
		});
		
		var rcvuserlist = []; 
		var rcvusers = docEditRcvUserView.getStore().data.items;
		Ext.each(rcvusers,function(record){
			rcvuserlist.push(me.JSONtoString(record.data));
		});
		
		var refuserlist = []; 
		var refusers = docEditRefUserView.getStore().data.items;
		Ext.each(refusers,function(record){
			refuserlist.push(me.JSONtoString(record.data));
		});
		
		var docbasilist = []; 
		var docbasis = docEditBasisView.getStore().data.items;
		Ext.each(docbasis,function(record){
			docbasilist.push(me.JSONtoString(record.data));
		});
		
		if (addFiles.length == 0) addFiles = null;
		if (delFiles.length == 0) delFiles = null;
		
		if (doclinelist.length == 0) doclinelist = null;
		if (rcvuserlist.length == 0) rcvuserlist = null;
		if (refuserlist.length == 0) refuserlist = null;
		if (docbasilist.length == 0) docbasilist = null;
		
		var param = {
			 'DocumentID': documentID, 
		     'FormID': formID, 
		     'Status': 'A', 
		     'ADDFID': addFiles,
		     'DELFID': delFiles,
		     'DOCLINES': doclinelist,
		     'RCVUSERS': rcvuserlist,
		     'REFUSERS': refuserlist,
		     'DOCBASISS': docbasilist,
		     'LINKDATA': linkdatalist,
		     'EXPENSEADD': null,
		     'EXPENSEUPD': null,
		     'EXPENSEDEL': null
		     /*'EXPENSEADD': addExpenseDetailRecord,
		     'EXPENSEUPD': updExpenseDetailRecord,
		     'EXPENSEDEL': delExpenseDetailRecord*/
		};
		
		if (me.isValid()) {
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   var win = me.getRegItems()['ParentContainer'];
                	   var docEditFilePanel = me.getRegItems()['DocEditSouthPanel'].getRegItems()['DocEditFilePanel'];
                	   
                	   if (win.getRegItems()['ActionType'] == NBOX_C_UPDATE){
                		   	docEditFilePanel.reset();
	               		  	win.getRegItems()['ActionType'] = NBOX_C_READ;
							win.formShow();
                	   }else{
                		   Ext.Msg.alert('확인', '문서가 저장되었습니다.');
	                	   me.clearData();	
                	   }
                   }
               });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }  
    },
    draftData: function(){
    	var me = this;
    	var documentID = null;

    	var win = me.getRegItems()['ParentContainer'];
    	/*var editExpenseDetailPanel = me.getRegItems()['EditExpenseDetailPanel'];
    	var expenseDetailGrid = editExpenseDetailPanel.getRegItems()['ExpenseDetailGrid'];
    	
    	var addExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getNewRecords());
    	var updExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getUpdatedRecords());
    	var delExpenseDetailRecord = me.getModeltoArray(expenseDetailGrid.getStore().getRemovedRecords());*/
    	
    	if (win.getRegItems()['ActionType'] == NBOX_C_UPDATE)
    		documentID = win.getRegItems()['DocumentID'];

    	var isNew = ( documentID == "" || documentID == null);
    	
    	var formCombo = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditFormCombo'] ;
    	var formID = formCombo.getValue(); 
		
    	var docEditFilePanel = me.getRegItems()['DocEditSouthPanel'].getRegItems()['DocEditFilePanel'];
		var addFiles = docEditFilePanel.getAddFiles();
		var delFiles = docEditFilePanel.getRemoveFiles();
		
		var linkdatalist = [];
		var columns = ['id','value','rawValue'];
		var docEditLinkDataPanel =  me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinkDataPanel'];
		Ext.each(docEditLinkDataPanel.items.items,function(item){
			linkdatalist.push(me.JSONtoString(item,columns));
		});
		
		if (linkdatalist.length == 0) linkdatalist = null;
		
		var docEditLineView = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinePanel'].getRegItems()['DocEditLineView'];
		var docEditExpandCollapsePanel = me.getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditExpandCollapsePanel'];
		var docEditRcvUserView = docEditExpandCollapsePanel.getRegItems()['DocEditRcvUserPanel'].getRegItems()['DocEditRcvUserView'];
    	var docEditRefUserView = docEditExpandCollapsePanel.getRegItems()['DocEditRefUserPanel'].getRegItems()['DocEditRefUserView'];
    	var docEditBasisView   = docEditExpandCollapsePanel.getRegItems()['DocEditBasisPanel'].getRegItems()['DocEditBasisView'];
    	
		var doclinelist = []; 
		var doclines = docEditLineView.getStore().data.items;
		Ext.each(doclines,function(record){
			doclinelist.push(me.JSONtoString(record.data));
		});
		
		var rcvuserlist = []; 
		var rcvusers = docEditRcvUserView.getStore().data.items;
		Ext.each(rcvusers,function(record){
			rcvuserlist.push(me.JSONtoString(record.data));
		});
		
		var refuserlist = []; 
		var refusers = docEditRefUserView.getStore().data.items;
		Ext.each(refusers,function(record){
			refuserlist.push(me.JSONtoString(record.data));
		});
		
		var docbasilist = []; 
		var docbasis = docEditBasisView.getStore().data.items;
		Ext.each(docbasis,function(record){
			docbasilist.push(me.JSONtoString(record.data));
		});
		
		if (addFiles.length == 0) addFiles = null;
		if (delFiles.length == 0) delFiles = null;
		
		if (doclinelist.length == 0) doclinelist = null;
		if (rcvuserlist.length == 0) rcvuserlist = null;
		if (refuserlist.length == 0) refuserlist = null;
		if (docbasilist.length == 0) docbasilist = null;
		
		var param = {
			 'DocumentID': documentID, 
		     'FormID': formID, 
		     'Status': 'B', 
		     'ADDFID': addFiles,
		     'DELFID': delFiles,
		     'DOCLINES': doclinelist,
		     'RCVUSERS': rcvuserlist,
		     'REFUSERS': refuserlist,
		     'DOCBASISS': docbasilist,
		     'LINKDATA': linkdatalist,
		     'EXPENSEADD': null,
		     'EXPENSEUPD': null,
		     'EXPENSEDEL': null
		     /*'EXPENSEADD': addExpenseDetailRecord,
		     'EXPENSEUPD': updExpenseDetailRecord,
		     'EXPENSEDEL': delExpenseDetailRecord*/
		};
		
		if (me.isValid()) {
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   var win = me.getRegItems()['ParentContainer'];
                	   var docEditFilePanel = me.getRegItems()['DocEditSouthPanel'].getRegItems()['DocEditFilePanel'];
                	   
                	   if (win.getRegItems()['ActionType'] == NBOX_C_UPDATE){
                		   	docEditFilePanel.reset();
                		   	win.close();
	               		  	/*win.getRegItems()['ActionType'] = NBOX_C_READ;
							win.formShow();*/
                	   }else{
                		   Ext.Msg.alert('확인', '문서가 상신되었습니다.');
	                	   me.clearData();	
                	   }
                   }
               });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        } 
    },
    clearData: function(){
    	var me = this;
    	
    	var store = me.getRegItems()['Store'];
    	var docEditNorthPanel = me.getRegItems()['DocEditNorthPanel'];
    	var docEditSouthPanel = me.getRegItems()['DocEditSouthPanel'];
    	
    	me.clearPanel();
    	
    	store.removeAll();
    	docEditNorthPanel.clearData();
    	docEditSouthPanel.clearData();
    },
	loadPanel: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if(frm.initialized)
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
    },
    getModeltoArray: function(model){
    	var me = this;
    	var resultArr = [];
    	
    	if (!model) return null;
    	
    	Ext.each(model, function(record){
    		resultArr.push(me.JSONtoString(record.data));
		});
    	
    	if (resultArr.length == 0) resultArr = null;
    	
    	return resultArr;
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

				if(property.toString() == 'ExpenseDate')
	            	value = value.toISOString().slice(0,10);
				
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	        }
        }
                     
        return '{' + results.join(String.fromCharCode(11)) + '}';
    }
});	

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	