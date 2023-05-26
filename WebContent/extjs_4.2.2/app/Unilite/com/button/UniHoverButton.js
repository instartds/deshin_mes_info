//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.button.UniHoverButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.uniHoverButton',
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        var btnConfig = {};
        if (Ext.isDefined(this.menu)) {            
            btnConfig = {
                listeners: {
					mouseover: function (b) {
                            b.maybeShowMenu();
                    }
                } // listeners
            }
        }
 
        // apply config
        Ext.apply(this, Ext.apply(this.initialConfig, btnConfig));
        
        me.callParent(arguments);
    }
});