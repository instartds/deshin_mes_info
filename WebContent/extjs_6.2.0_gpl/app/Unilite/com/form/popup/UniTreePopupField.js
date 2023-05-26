//@charset UTF-8
/**
 * 
 * event  onSelected : function( type(VALUE|TEXT), records(선택된 레코드들))
 * 
 */
Ext.define('Unilite.com.form.popup.UniTreePopupField', {
    extend: 'Ext.form.FieldContainer',
    alias: 'widget.uniTreePopupField',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniTreePopupAbstract'
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
        type: 'table', columns: 4
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
		    	me.textFieldName,
		    	me.description,		// 필드에 입력된 건 외 표시
		    	me.valuesName		// Multi 선택된 values 입력
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
        
    },
    // private
    initComponent: function() {
        var me = this;
        me.addCls('uni-popup-fields');
        //console.log("me.textFieldName", me.textFieldName, me.allowBlank);
        
   		var f1 = me._getValueFieldConfig(!me.showValue);
   		var f2 = me._getTextFieldConfig();
   		var f3 = me._getDescriptionConfig();
   		var f4 = me._getValuesConfig();

   		Ext.apply(f1, {fieldCls : 'x-form-field ' + me.fieldCls});
   		Ext.apply(f2, {fieldCls : 'x-form-field ' + me.fieldCls});
   		Ext.apply(f4, {fieldCls : 'x-form-field ' + me.fieldCls});
   		
   		if(me.verticalMode) {
	       	if(me.textFieldOnly) {
	        	me.items =[ f2, f3, f4];
	       	} else {
	       		me.items =[Ext.applyIf(f1, {colspan: 3, margin: '0 5 0 0'}), f2 , f3, f4];
	       	}
	       	
       	} else {
       		if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[f1, f2, f3, f4 ];
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
        me.values = me.down('#' + me.id + '-valuesField');
        me.description = me.down('#'+me.id+'-descriptionField');
    }
   
});