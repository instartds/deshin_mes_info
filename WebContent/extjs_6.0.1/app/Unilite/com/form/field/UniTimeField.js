//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniTimeField', {
    extend: 'Ext.form.field.Time',
    alias: 'widget.uniTimefield',
     autoSelect: true,
    format : "h:i A",	// 12H format with leading zero
    altFormats :'H:i|Hi',	// 24H
    submitFormat:'Hi',
    //minValue: '08:00 AM',
    increment: 30,
    initComponent: function() {
    	this.callParent(arguments);
    }
});  //Ext.define