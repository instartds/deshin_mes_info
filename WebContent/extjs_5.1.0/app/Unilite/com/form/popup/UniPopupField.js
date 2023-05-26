//@charset UTF-8
/**
 * 
 * event  onSelected : function( type(VALUE|TEXT), records(선택된 레코드들))
 * 
 */
Ext.define('Unilite.com.form.popup.UniPopupField', {
    extend: 'Ext.form.FieldContainer',
    alias: 'widget.uniPopupField',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniPopupAbstract'
    },
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label',
   		'Unilite.com.form.popup.UniPopupFieldLayout'
    ],
    
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 보여줄것인지 여부
     * 
     * true : value 필드를 hidden 처리함.
     * 
     */
    showValue:true,
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 사용할지 여부
     * 
     * true : value field를 생성하지 않음.
     * 
     */
    textFieldOnly:false,
    
    padding: '0 0 0 0',
   	defaults: {
         hideLabel: true
    },
    componentLayout: 'uniPopupFieldLayout',
    layout: {
        type: 'table', columns: 2
        //,defaultMargins: { top: 0, right: 2, bottom: 0, left: 0 }
    },
    constructor : function(config){     
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        me.mixins.popupBehaviour.constructor.call(me, config);
        me.callParent(arguments);
        //addEvents 제거 - 5.0.1 deprecated
//        me.addEvents('onSelected');
        
        this.store = new Ext.create('Ext.data.Store', {
        	autoload:false,
        	fields:[
		    	me.valueFieldName, 
		    	me.textFieldName
		    ],
        	proxy:{
		    	type: 'direct',
				        api: {
				        	read: me.api //'popupService.custPopup'
				        }
				    }
		        });
    },
    setReadOnly: function(readOnly) {
    	var me = this;
    	if( me.valueField) {
        	me.valueField.setReadOnly(readOnly);
        }
        me.textField.setReadOnly(readOnly);
        Ext.each(me.extraFields,  function(field){
        	field.setReadOnly(readOnly);
        });
    },
    // private
    initComponent: function() {
        var me = this;
        me.addCls('uni-popup-fields');
        //console.log("me.textFieldName", me.textFieldName, me.allowBlank);
        
   		var f1 = me._getValueFieldConfig(!me.showValue);
   		var f2 = me._getTextFieldConfig();
   		var others = me._getExtraFieldsConfig();
   		Ext.apply(f1, {fieldCls : 'x-form-field ' + me.fieldCls});
   		Ext.apply(f2, {fieldCls : 'x-form-field ' + me.fieldCls});
   		
   		var layoutCols = me.layout.columns;
   		if(!Ext.isEmpty(others)){
   			Ext.each(others, function(field) {
   				Ext.apply(field, {fieldCls : 'x-form-field ' + me.fieldCls});
   				layoutCols ++;
   			});
   			
   			Ext.apply(me.layout, {columns: layoutCols});
   		}
   		
   		
   		if(me.verticalMode) {
	       	if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[Ext.applyIf(f1, {colspan: 2, margin: '0 5 0 0'}), f2 ];
	       		
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	} else {
       		if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[f1, f2 ];
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	}
       	
        me.callParent(arguments);
        me.initRefs();
    },
    // private
    initRefs:function() {
    	var me = this;
       	if(! me.textFieldOnly) {
        	me.valueField = me.down('#' + me.id + '-valueField');
        }
        me.textField = me.down('#' + me.id + '-textField');
        me.extraFields = me.query('textfield[id^=' + me.id + '-extraField]');
    },
    getExtraFields: function() {
    	return me.extraFields;	
    },
    
    /**]
     * 
     * @param {} popupName   string
     * @param {} changeLable bool
     */
    setPopup:function(popupName, changeLable)	{
    	var me = this;
    	var newConfig = Unilite.popup(popupName, changeLable);  
    	if(changeLable) changeLable = true;
    	if(newConfig)	{
    		me.DBvalueFieldName = newConfig.DBvalueFieldName;
			me.DBtextFieldName 	= newConfig.DBtextFieldName;
			me.api 				= newConfig.api;
			me.app 				= newConfig.app;
			me.useyn			= newConfig.useyn
			me.pageTitle		= newConfig.pageTitle;
			var proxy = me.store.getProxy();
			proxy.setConfig('api', {read: newConfig.api });
			if(changeLable) 	me.setFieldLabel(newConfig.fieldLabel);
    	} else {
    		me.DBvalueFieldName = me.config.DBvalueFieldName;
			me.DBtextFieldName 	= me.config.DBtextFieldName;
			me.api 				= me.config.api;
			me.app 				= me.config.app;
			me.useyn			= me.config.useyn
			me.pageTitle		= me.config.pageTitle;
			var proxy = me.store.getProxy();
			proxy.setConfig('api', {read: me.config.api });
			if(changeLable) 	me.setFieldLabel(me.config.fieldLabel);
    	}
    }
   
});