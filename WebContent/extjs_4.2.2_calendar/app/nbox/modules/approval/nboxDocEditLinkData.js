/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 650;

/**************************************************
 * combo Code
 **************************************************/
Ext.define('nbox.docEditLinkCombo', {
	extend: 'Ext.data.Store',
	fields: ["CODE", 'NAME'],
	autoLoad: false,
	proxy: {
        type: 'direct',
        extraParams: {MAIN_CODE: 'NL04'},
        api: { read: 'nboxLinkCommonService.selectLinkComboList' },
        reader: {
            type: 'json',
            root: 'records'
        }
	}
});	
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docEditLinkDataModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'CompanyID'},
    	{name: 'FormID'},
    	{name: 'DataID'},
    	{name: 'DataCode'},
    	{name: 'DataName'},
    	{name: 'DataType'},
    	{name: 'InputType'},
    	{name: 'ReferenceCode'},
    	{name: 'ControlWidth'},
    	{name: 'NullFlag'},
    	{name: 'FixFlag'},
    	{name: 'OneLineFlag'},
    	{name: 'DefaultValue'},
    	{name: 'SortSeq'},
    	{name: 'DataValue'},
    	{name: 'DataValueName'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docEditLinkDataStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditLinkDataModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxLinkDataCodeByApprovalService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});

/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docEditLinkDataPanel', {
	extend: 'Ext.panel.Panel',
	
	config: {
		regItems: {}
    },
	
	layout: {
		type: 'table',
		columns: 2,
		tdAttrs:{
			style: {
				'padding': '5px 0px 0px 0px'
		   	}
		}
	},
	border: false,
	defaultType: 'textfield',
	
	queryData: function(formID){
		var me = this;
		
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var store = me.getRegItems()['Store'];
		
		
		
		me.clearData();
		
		store.proxy.setExtraParam('FormID', formID);
		store.proxy.setExtraParam('DocumentID', documentID);
		store.load({callback: function(records, operation, success) {
			if (success){
					me.loadPanel(records);
				}
			}
		});
	},
	clearData: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		
		me.clearPanel();
		
		store.removeAll();
	},
	loadPanel: function(records){
		var me = this;
		var workCodeComboStore;
		var holidayCodeComboStore;
		
		Ext.each(records, function(record) {
			switch(record.data.DataType){
				case 'A0004':
					var comboStore = Ext.create('nbox.docEditLinkCombo', {});
					
					comboStore.proxy.setExtraParam('SUB_CODE', record.data.ReferenceCode);
					comboStore.load();
					
					switch(record.data.ReferenceCode){
						case 'A0001' :
							workCodeComboStore = comboStore;	
							break;
						case 'A0002' :
							holidayCodeComboStore = comboStore;
						default:
							break;
					}
					
				default:
					break;
			}
		}); 
		
	
		Ext.each(records, function(record) {
			switch(record.data.DataType){
				case 'A0001': // text
					var field = Ext.create('Ext.form.field.Text',{
						id: record.data.DataID,
						name: record.data.DataID,
						fieldLabel: record.data.DataName,
						
						labelAlign : 'right',
						labelClsExtra: (record.data.NullFlag ? 'field_label' : 'required_field_label'),
						allowBlank: (record.data.NullFlag ? true : false), 	
						
						width: (record.data.OneLineFlag ? docControlPanelWidth : record.data.ControlWidth),
						colspan: (record.data.OneLineFlag ? 2 : 1 ),
						
						disabled: (record.data.FixFlag ? true : false),
						
						value: (record.data.DataValueName == null || record.data.DataValueName == '' ? record.data.DefaultValue : record.data.DataValueName)
					});
				
					break;
				case 'A0002': // date
					var field = Ext.create('Ext.form.field.Date',{
						id: record.data.DataID,
						name: record.data.DataID,
						fieldLabel: record.data.DataName,
						format: 'Y-m-d', 
						
						labelAlign : 'right',
						labelClsExtra: (record.data.NullFlag ? 'field_label' : 'required_field_label'),
						allowBlank: (record.data.NullFlag ? true : false),
						
						width: (record.data.OneLineFlag ? docControlPanelWidth : record.data.ControlWidth),
						colspan: (record.data.OneLineFlag ? 2 : 1 ),
						
						disabled: (record.data.FixFlag ? true : false) ,
						
						value: (record.data.DataValueName == null || record.data.DataValueName == '' ? new Date() : new Date(record.data.DataValueName))
					});
				
					break;
				case 'A0003': // time
					var field = Ext.create('Ext.form.field.Time',{
						id: record.data.DataID,
						name: record.data.DataID,
						fieldLabel: record.data.DataName,
						format: 'H:i',
						increment: 30,
						
						labelAlign : 'right',
						labelClsExtra: (record.data.NullFlag ? 'field_label' : 'required_field_label'),
						allowBlank: (record.data.NullFlag ? true : false),
						
						width: (record.data.OneLineFlag ? docControlPanelWidth : record.data.ControlWidth),
						colspan: (record.data.OneLineFlag ? 2 : 1 ),
						
						disabled: (record.data.FixFlag ? true : false),
						
						value: (record.data.DataValueName == null || record.data.DataValueName == '' ? new Date() : new Date(record.data.DataValueName)) 
					});
				
					break;
					
				case 'A0004': // combo
					var field = Ext.create('Ext.form.field.ComboBox',{
						id: record.data.DataID,
						name: record.data.DataID,
						fieldLabel: record.data.DataName,
						
						labelAlign : 'right',
						labelClsExtra: (record.data.NullFlag ? 'field_label' : 'required_field_label'),
						allowBlank: (record.data.NullFlag ? true : false),
						
						store: (record.data.ReferenceCode=='A0001'? workCodeComboStore: (record.data.ReferenceCode=='A0002'? holidayCodeComboStore: null)),
						valueField: 'CODE',
					  	displayField: 'NAME',
						
						width: (record.data.OneLineFlag ? docControlPanelWidth : record.data.ControlWidth),
						colspan: (record.data.OneLineFlag ? 2 : 1 ),
						
						disabled: (record.data.FixFlag ? true : false),
						
						value: (record.data.DataValueName == null || record.data.DataValueName == '' ? record.data.DefaultValue : record.data.DataValue)
					});
					
					break;
				default:
					break;
			}
			
			me.insert(field);
    	});	
	},
	clearPanel: function(){
		var me = this;
		
		me.removeAll();
	}
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	