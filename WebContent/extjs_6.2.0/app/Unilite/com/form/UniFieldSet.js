Ext.define('Unilite.com.form.UniFieldSet', {
    extend: 'Ext.form.FieldSet',
    alias: 'widget.uniFieldset',
    fieldDefaults : {
		msgTarget : 'side',
		labelAlign : 'right',
		labelWidth : 80,
		labelSeparator : ""
	},
	defaultType : 'uniTextfield'
});// define