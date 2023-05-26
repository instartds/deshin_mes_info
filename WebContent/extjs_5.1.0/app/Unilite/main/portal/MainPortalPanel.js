// @charset UTF-8
/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
Ext.define('Unilite.main.portal.MainPortalPanel', {
    extend: 'Unilite.com.panel.portal.UniPortalPanel',
    title: 'Portal',
    itemId: 'portal',
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,

    //abstract 
    getPortalItems: function() {
    	var itemCol1 = {
	        items: [{
	            title: 'Portlet 1',
	            html: 'Portlet 1'
	        },{
	            title: 'Portlet 2',
	            html: 'Portlet 2'
	        }]
	    };
	    
	    var itemCol2 = {
	        items: [{
	            title: 'Portlet 3',
	            html: 'Portlet 3'
	        }]
	    };
	    
	    var itemCol3 = {
	        items: [{
	            title: 'Portlet 4',
	            html: 'Portlet 4'
	        }]
	    };
	    
	    return [itemCol1,
    			itemCol2,
    			itemCol3]
    },
    
    //initialize
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems()
    	});
    		    
    	this.callParent();
    }
});