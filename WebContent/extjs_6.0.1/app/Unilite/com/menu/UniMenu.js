//@charset UTF-8
/**
 * 
 */
 Ext.define('Ext.override.menu.Menu', {
    override: 'Ext.menu.Menu',
    preventClick: function(e) {
        if (!this.getItemFromEvent(e) || !this.getItemFromEvent(e).href) {
            e.preventDefault();
        }
    }
 });
 
 Ext.define('Unilite.com.menu.UniMenu', {
	extend : 'Ext.menu.Menu',
	alias : 'widget.uniMenu',
	grid : null,
	style: {
            overflow: 'visible'     // For the Combo popup
    }
});
