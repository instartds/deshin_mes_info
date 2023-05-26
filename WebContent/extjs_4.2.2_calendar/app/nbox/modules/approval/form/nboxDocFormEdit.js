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
		type: 'fit'
	},
	
	border: false,
	
	initComponent: function () {
		var me = this;
		
		var categoryIDStore = Ext.create('nbox.approval.form.categoryIDStore',{});
		var storeYearStore = Ext.create('nbox.approval.form.storeYearStore', {});
		var docuTypeStore = Ext.create('nbox.approval.form.docuTypeStore', {});
		var orgTypeStore = Ext.create('nbox.approval.form.orgTypeStore', {});
		var secureGradeStore = Ext.create('nbox.approval.form.secureGradeStore', {});
		var cabinetMenuStore = Ext.create('nbox.approval.form.cabinetMenuStore', {}); 
		
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
					store: categoryIDStore, 
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
					store: storeYearStore, 
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
					store: docuTypeStore, 
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
					store: orgTypeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false
				}, 
				{ 
					xtype: 'combo', 
					name:'SecureGrade',
					fieldLabel: '보안등급', 
					store: secureGradeStore, 
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
					store: cabinetMenuStore, 
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
	padding: '5 5 5 5',
	
	flex: 1,	
	
	border: false,
	
	initComponent: function () {
		var me = this;
		
		var contentsEditor = Ext.create('Ext.form.HtmlEditor', {
			id: 'Contents',
			name: 'Contents'
		});
		
		me.items = [contentsEditor];
		me.callParent();
	}
});    

//Detail Edit Panel
Ext.define('nbox.approval.form.detailEditPanel', {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
    },
    layout: {
    	type: 'vbox',
		align: 'stretch' 
    },
	
	border: false,
	api: { submit: 'nboxDocFormService.save' },
	
	initComponent: function () {
		var me = this;
		var singlePanel = Ext.create('nbox.approval.form.singlePanel',{});
		var contentPanel = Ext.create('nbox.approval.form.contentPanel', {});
				
		singlePanel.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['SinglePanel'] = singlePanel;
    	
    	contentPanel.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['ContentPanel'] = contentPanel;
		
		me.items = [singlePanel, contentPanel];
		me.callParent();
	},
    queryData: function(){
    	var me = this;
		var store = me.getRegItems()['Store'];
		var win = me.getRegItems()['ParentContainer'];
		var formID = win.getRegItems()['FormID'];
		
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
    	var win = me.getRegItems()['ParentContainer']; 
    		
    	var formID = win.getRegItems()['FormID'];
		var isNew = ( formID == "" || formID == null);
		var actionType = NBOX_C_UPDATE;
		
		if(isNew)
			actionType = NBOX_C_CREATE;	
		
		var contents = me.getRegItems()['ContentPanel'].items.get('Contents');
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
                		win.getRegItems()['FormID'] = action.result.FormID;
                	
                	win.getRegItems()['ActionType'] = NBOX_C_UPDATE;
                	win.formShow();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
    },
    deleteData: function(){
    	var me = this;
    	var win = me.getRegItems()['ParentContainer']; 
    	
    	var formID = win.getRegItems()['FormID'];
    	var actionType = NBOX_C_DELETE;
		var param = {'ActionType' : actionType, 'FormID': formID };
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   win.close();
			}
		});
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