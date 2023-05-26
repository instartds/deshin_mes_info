//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.window.UniDetailWindow', {
    extend: 'Unilite.com.window.UniBaseWindowApp',
    alias: 'widget.uniDetailWindow',
    header: {
        titlePosition: 2,
        titleAlign: 'left'
    },
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        
        me.callParent(arguments);
    }
});