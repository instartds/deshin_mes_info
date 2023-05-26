/**************************************************
 * Common variable
 **************************************************/


/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docEditFormStore', {
	extend: 'Ext.data.Store',
	
	fields: ["FormID", 'FormName'],
	
  	autoLoad: true,
  	proxy: {
        type: 'direct',
        extraParams: {BOX: 'XY001'},
        api: { read: 'nboxDocCommonService.selectDocFormItem' },
        reader: {
            type: 'json',
            root: 'records'
        }
  	},
  	listeners: {
  		load: function(store, records, successful, eOpts){

  		}
  	}
});	


/**************************************************
 * Define
 **************************************************/
//Form Combo Box
Ext.define('nbox.docEditFormCombo',{
	extend: 'Ext.form.ComboBox',
	config: {
		store: null,
    	regItems: {}
    },
  
    name: 'FormID',
    fieldLabel: '문서',
	labelAlign : 'right',
	labelClsExtra: 'required_field_label',
	width: 650,
	allowBlank:false,
    forceSelection: true,
    editable : false,
    displayField: 'FormName',
	valueField: 'FormID',
    listeners: {
        change: function (combo, newValue, oldValue) {
        	combo.changeForm(newValue,oldValue);
        },
        scope: this
    },
    changeForm: function(newValue, oldValue) {
    	var me = this;

    	var store = me.getStore();
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	var actionType = nboxBaseApp.getActionType();
    	var record = store.findRecord('FormID', newValue);
    	
    	if( record != null)
    	{
        	var docEditContentsHtmlEditor = Ext.getCmp('nboxDocEditContentsPanel').items.items[0];
        	var nboxDocEditLinkDataPanel = Ext.getCmp('nboxDocEditLinkDataPanel');
        	var nboxDocEditLinkDataPanel = Ext.getCmp('nboxDocEditLinkDataPanel');
        	var docEditSecureGrade = Ext.getCmp('DocEditSecureGrade');
        	var docEditCabinetID = Ext.getCmp('DocEditCabinetID');
        		
    		if(newValue != oldValue && actionType == NBOX_C_CREATE){

    			if (docEditContentsHtmlEditor.InstanceReadyFlag)
    				docEditContentsHtmlEditor.setValue(record.data.Contents);
            	//else
            		//docEditContentsHtmlEditor.tempData = record.data.Contents;
    			
        		docEditSecureGrade.setValue(record.data.SecureGrade);
        		docEditCabinetID.setValue(record.data.CabinetID.toLowerCase());
    		}
    		
    		if (nboxDocEditLinkDataPanel)
    			nboxDocEditLinkDataPanel.queryData(newValue);
		}
    },
    queryData: function(){
    	var me = this;
    	
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	me.disabled = false;
    	
    	if(nboxBaseApp.getActionType() == NBOX_C_UPDATE)
    		me.disabled = true;

    },
    clearData: function(){
    	var me = this;
    	
    }
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	