/**************************************************
 * Common variable
 **************************************************/
var docFormEditPanelWidth = 660;
var docFormControlPanelWidth = 650;

/**************************************************
 * combo store
 **************************************************/
Ext.define('nbox.approval.form.categoryIDStore', {
  extend: 'Ext.data.Store',
  fields: ["CODE", 'NAME'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NA02'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	 

Ext.define('nbox.approval.form.storeYearStore', {
  extend: 'Ext.data.Store',
  fields: ["CODE", 'NAME'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NA01'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	 

Ext.define('nbox.approval.form.docuTypeStore', {
  extend: 'Ext.data.Store',
  fields: ["CODE", 'NAME'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NA03'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	 	

Ext.define('nbox.approval.form.orgTypeStore', {
  extend: 'Ext.data.Store',
  fields: ["CODE", 'NAME'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NX01'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

Ext.define('nbox.approval.form.secureGradeStore', {
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

Ext.define('nbox.approval.form.cabinetMenuStore', {
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
Ext.define('nbox.approval.form.detailEditModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'FormID'}, 
    	{name: 'CategoryID'},
    	{name: 'Subject'},
    	{name: 'Contents'},
    	{name: 'StoreYear'}, 
    	{name: 'DocuType'}, 
    	{name: 'CabinetID'},
    	{name: 'SecureGrade'},
    	{name: 'OrgType'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.approval.form.detailEditStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.approval.form.detailEditModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxDocFormService.select'
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
Ext.define('nbox.approval.form.singlePanel', {
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
		
		var nboxFormCategoryIDStore = Ext.create('nbox.approval.form.categoryIDStore',{
			id:'nboxFormCategoryIDStore'
		});
		
		var nboxFormStoreYearStore = Ext.create('nbox.approval.form.storeYearStore', {
			id:'nboxFormStoreYearStore'
		});
		
		var nboxFormDocuTypeStore = Ext.create('nbox.approval.form.docuTypeStore', {
			id:'nboxFormDocuTypeStore'
		});
		
		var nboxFormOrgTypeStore = Ext.create('nbox.approval.form.orgTypeStore', {
			id:'nboxFormOrgTypeStore'
		});
		
		var nboxFormSecureGradeStore = Ext.create('nbox.approval.form.secureGradeStore', {
			id:'nboxFormSecureGradeStore'
		});
		
		var nboxFormCabinetMenuStore = Ext.create('nbox.approval.form.cabinetMenuStore', {
			id:'nboxFormCabinetMenuStore'
		}); 
		
		var panel1 = Ext.create('Ext.panel.Panel', { 
        	layout: {
				type: 'table',
				columns: 2,
				tdAttrs:{
					style: {
					 'padding': '3px 3px 0px 3px'
				   	}
				}
			},
			border: false,
			defaultType: 'textfield',
			items: [
				{ 
					name: 'Subject',
					fieldLabel: '양식제목',
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					width: docFormControlPanelWidth,
					allowBlank:false,
					colspan: 2
				},
				{ 
					xtype: 'combo', 
					name:'CategoryID',
					fieldLabel: '양식구분', 
					store: nboxFormCategoryIDStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'StoreYear',
					fieldLabel: '보존기한', 
					store: nboxFormStoreYearStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'DocuType',
					fieldLabel: '공용구분', 
					store: nboxFormDocuTypeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'OrgType',
					fieldLabel: '조직구분', 
					store: nboxFormOrgTypeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'SecureGrade',
					fieldLabel: '공개/비공개', 
					store: nboxFormSecureGradeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'CabinetID',
					fieldLabel: '문서함', 
					store: nboxFormCabinetMenuStore, 
					displayField:'pgmName', 
					valueField: 'pgmID', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				} 
				
			]
        });
		
		me.items = [panel1];
		me.callParent(); 
	}
	
});

Ext.define('nbox.approval.form.contentPanel', {
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'fit'
	},
	
	flex: 1,
	
	style: {
		'margin': '5px 5px 5px 5px'
   	},
	
   	border: false,
   	
	initComponent: function () {
		var me = this;
		/*
		var contentsEditor = Ext.create('Ext.form.HtmlEditor', {
			id: 'Contents',
			name: 'Contents'
		});
		*/
		var docFormEditContentsHtmlEditor =  Ext.create('nbox.ckeditor.ckeditor', {
	        fieldLabel: '', 
	        name:'nboxCkeditor',
	        
	        CKConfig: { 
	            /* Enter your CKEditor config paramaters here or define a custom CKEditor config file. */
	            customConfig : 'config.js',
    	        qtRows: 20, // Count of rows
    	        qtColumns: 20, // Count of columns
    	        qtBorder: '1', // Border of inserted table
    	        qtWidth: '600px', // Width of inserted table
    	        qtStyle: { 'border-collapse' : 'collapse' },
    	        qtCellPadding: '3px', // Cell padding table
    	        qtCellSpacing: '0' // Cell spacing table
	        }
	    });  
		me.items = [docFormEditContentsHtmlEditor];
		me.callParent();
	},
	queryData: function(){

	},
	clearData: function(){
		var me = this;
		
		//me.removeAll();
	},
	loadPanel: function(){
    	var me = this;
    	var docFormEditContentsHtmlEditor = me.items.items[0];
    	var nboxFormDetailEditPanel = Ext.getCmp('nboxFormDetailEditPanel');
    	var nboxFormDetailEditStore = null
    	
    	if (docFormEditContentsHtmlEditor.name == "nboxCkeditor" )
    	{
	    	if (nboxFormDetailEditPanel)
	   		{
	    		nboxFormDetailEditStore = nboxFormDetailEditPanel.getStore();
	   		}
	    	
	    	if (nboxFormDetailEditStore)
			{
	    		if (nboxFormDetailEditStore.getCount() > 0)
				{
	    			if (docFormEditContentsHtmlEditor)
					{
	    				if (docFormEditContentsHtmlEditor.InstanceReadyFlag)
	    					docFormEditContentsHtmlEditor.setValue(nboxFormDetailEditStore.getAt(0).get('Contents'));
                        else
                        	docFormEditContentsHtmlEditor.tempData = nboxFormDetailEditStore.getAt(0).get('Contents');
	    				
					}
				}
			}
    	}
	}
});    

//Detail Edit Panel
Ext.define('nbox.approval.form.detailEditPanel', {
	extend: 'Ext.form.Panel',
	config: {
		store: null,
		regItems: {}
    },
    layout: {
    	type: 'vbox',
		align: 'stretch'
    },
	
	border: false,
    flex: 1,
    
	api: { submit: 'nboxDocFormService.save' },
	
	initComponent: function () {
		var me = this;
		
		var nboxFormSinglePanel = Ext.create('nbox.approval.form.singlePanel',{
			id:'nboxFormSinglePanel'
		});
		var nboxFormContentPanel = Ext.create('nbox.approval.form.contentPanel', {
			id:'nboxFormContentPanel'
		});
				
		me.items = [nboxFormSinglePanel, nboxFormContentPanel];
		me.callParent();
	},
    queryData: function(){
    	var me = this;
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var formID = nboxBaseApp.getFormID();
		
		me.clearData();

		store.proxy.setExtraParam('FormID', formID);
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
    },
    saveData: function(){
    	var me = this;
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    		
    	var formID = nboxBaseApp.getFormID();
		var isNew = ( formID == "" || formID == null);
		var actionType = NBOX_C_UPDATE;
		
		if(isNew)
			actionType = NBOX_C_CREATE;	
		
		var contents = Ext.getCmp('nboxFormContentPanel').items.items[0];
		var param = {
				'ActionType': actionType
			  , 'FormID': formID
			  , 'Contents' : contents.getValue()};
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	UniAppManager.updateStatus('저장되었습니다.');
                	
                	if(actionType == NBOX_C_CREATE)
                		nboxBaseApp.setFormID(action.result.FormID);
                	
                	nboxBaseApp.setActionType(NBOX_C_UPDATE);
                	nboxBaseApp.formShow();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
    },
    deleteData: function(){
    	var me = this;
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	
    	var formID = nboxBaseApp.getFormID();
    	var actionType = NBOX_C_DELETE;
		var param = {'ActionType' : actionType, 'FormID': formID };
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   me.clearData();
			}
		});
    },
    clearData: function(){
    	var me = this;
    	me.clearPanel(); 
    },
	loadData: function(){
    	var me = this;
    	var nboxFormContentPanel = Ext.getCmp('nboxFormContentPanel');
    	var store = me.getStore();
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
			
	    	if (nboxFormContentPanel)
	    	{
	    		nboxFormContentPanel.loadPanel();
	    	}
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getStore();
    	
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


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	