//@charset UTF-8
/**
 * Grid 없이 단독 으로 사용 되는 폼.
 */
Ext.define('Unilite.com.form.UniDetailFormSimple', {
	extend : 'Unilite.com.form.UniDetailForm',
	alias : 'widget.uniDetailFormSimple',
	margin: '1 0 0 1',
	padding: '0 0 0 0 ',
	collapsible : false,
    trackResetOnLoad: true,
	autoScroll:true,
  	constructor: function(config) {
  		var me = this;
  		config = config || {};
	    config.trackResetOnLoad = true;
	    me.callParent([config]);
  	},
  	disabled :false
});