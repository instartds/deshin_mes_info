//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.button.BaseButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.uniBaseButton',
    scale: 'medium',
    constructor: function(config) {
        var me = this;
        config = config || {};
        config.text = '';
        config.trackResetOnLoad = true;
        me.callParent([config]);
    }
    
});