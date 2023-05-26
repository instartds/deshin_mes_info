//@charset UTF-8
/**
 * 
 */
 Ext.define('Unilite.com.UniImg', {
	extend : "Ext.Img",
	alias : "widget.uniImg",
	onClick : Ext.emptyFn,
	autoRender : true,
	isButton: true,
	initComponent : function() {
		if(this.isButton) {
			this.style = "cursor: pointer;";
		}
		this.callParent()
	},
	listeners: {
        el: {
            click: function() {
                //this.onClick();
            }
        }
    }
});
