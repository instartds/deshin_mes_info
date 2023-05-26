//@charset UTF-8
Ext.define('Unilite.com.form.UniSearchForm', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniSearchForm',
	defaultType : 'uniTextfield',
	autoScroll:false,
	
/*	defaults : {
		listeners: {
			specialkey: function(field, e){
				// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
                // e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
//                if (e.getKey() == e.ENTER) {
//					console.log("keyDown");
//					var app = UniAppManager.getApp();
//                	app.onQueryButtonDown();
//                }
			}
		}
	},*/
    enableKeyEvents: true,
	initComponent : function(){  
    	var me  = this;
    	  	
        me.on('beforerender',this._onAfterRenderFunction , this);
    	me.callParent();
	}
});