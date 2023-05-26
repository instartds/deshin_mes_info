/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 650;

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
  			/*var formID = Ext.getCmp('FormID');
  			
  			if('${BOX}' == 'XY002')
  				formID.setValue(expenseFormID);*/
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
    	regItems: {}
    },
    
    name: 'FormID',
    fieldLabel: '문서',
	labelAlign : 'right',
	labelClsExtra: 'required_field_label',
	width: docControlPanelWidth,
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
    	var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    	
    	var record = store.findRecord('FormID', newValue);
    	if( record != null)
    	{
        	var docEditContentsHtmlEditor = win.getRegItems()['DocEditPanel'].getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditContentsPanel'].getRegItems()['DocEditContentsHtmlEditor'];
        	var docEditLinkDataPanel = win.getRegItems()['DocEditPanel'].getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinkDataPanel'];
        	var docEditSecureGrade = Ext.getCmp('DocEditSecureGrade') ;
        	var docEditCabinetID = Ext.getCmp('DocEditCabinetID') ;
        	
        	if(newValue != oldValue)
        	{
        		if(win.getRegItems()['ActionType'] == NBOX_C_CREATE){
	        		docEditContentsHtmlEditor.setValue(record.raw.Contents);
	        		docEditSecureGrade.setValue(record.raw.SecureGrade);
	        		docEditCabinetID.setValue(record.raw.CabinetID);
        		}
        		
        		docEditLinkDataPanel.queryData(newValue);
        	}
		}
    	
		/*if(win.getRegItems()['ActionType'] == NBOX_C_CREATE)
		{
	    	var record = store.findRecord('FormID', newValue);
	    	if( record != null)
	    	{
    		
	        	var docEditContentsHtmlEditor = win.getRegItems()['DocEditPanel'].getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditContentsPanel'].getRegItems()['DocEditContentsHtmlEditor'];
	        	var docEditLinkDataPanel = win.getRegItems()['DocEditPanel'].getRegItems()['DocEditNorthPanel'].getRegItems()['DocEditLinkDataPanel'];
	        	var docEditSecureGrade = Ext.getCmp('DocEditSecureGrade') ;
	        	var docEditCabinetID = Ext.getCmp('DocEditCabinetID') ;
	        	
	        	if(newValue != oldValue)
	        	{
	        		docEditContentsHtmlEditor.setValue(record.raw.Contents);
	        		docEditSecureGrade.setValue(record.raw.SecureGrade);
	        		docEditCabinetID.setValue(record.raw.CabinetID);
	        		docEditLinkDataPanel.queryData(newValue);
	        	}
    		}
    	}*/
		
		
		
    },
    queryData: function(){
    	var me = this;
    	
    	me.disabled = false;
    	var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    	if(win.getRegItems()['ActionType'] == NBOX_C_UPDATE)
    		me.disabled = true;
    }
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	