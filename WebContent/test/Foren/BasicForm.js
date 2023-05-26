Ext.define('Foren.BasicForm', {
	extend: 'Ext.form.Panel',
    alias: 'widget.forenBaseForm',   
    
	padding: '5 5 0 5',
	fieldDefaults: {
		msgTarget: 'qtip',
		labelAlign: 'right',
		blankText: '값을 입력해 주세요!',
		labelWidth: 90,
		//width:250,
		labelSeparator: "",
	    validateOnChange: false,
        autoFitErrors: true   //false  //화면 깨짐 
	},
	layout: { type: 'vbox' , alignstrech: true},
	requires: [
		'Ext.Msg'
	],
	
	constructor: function(config) {
  		var me = this;
  		config = config || {};
	    config.trackResetOnLoad = true;
	    me.callParent([config]);
  	},
  	
	initComponent: function(){
		
		//this.addEvents('uniOnChange');
        this.callParent();
	}
}); // define
 
