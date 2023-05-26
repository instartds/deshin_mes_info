//@charset UTF-8


Ext.define('Unilite.com.tab.UniTabPanel', {
	extend: 'Ext.tab.Panel',
	padding:'1 0 0 1',
	bodyPadding: 0,
	flex : 1,
	activeTab: 0,
	tabPosition: 'top',
    initComponent: function() {
        var me = this,
            tabs = [].concat(me.items || []),
            activeTab = me.activeTab || (me.activeTab = 0),
            tabPosition = me.tabPosition;
            
         var stores = [];
         
         /**
         for(var i =0, len = tabs.length ; i < len; i ++) {
         	var item =tabs[i];
         	if(item.store) {
         		console.log("tab [" + item.id + ": store "+ item.store.id);
         		//me.mon(item.store,'update', me.onStoreUpdate, me);
         	}
         } 
         */
         me.on('beforetabchange', me.onBeforetabchange, me)
         me.callParent(arguments);
    } // initComponent
    
    , onBeforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
    	if(newCard.uniOpt) {
    		if(newCard.uniOpt.store) {
    			var option = newCard.uniOpt;
	    		var store = option.store;
	    		var naviStore = Ext.isDefined(option.naviStore) ?  option.naviStore :  store;
	    		
	    		UniAppManager.setToolbarButtons(['save'],false);
	    		if(Ext.isDefined(store.uniOpt.state.btnDelete)) {
	    			UniAppManager.setToolbarButtons(['delete'],	Unilite.nvl(store.uniOpt.state.btnDelete, false));
	    		} else {
	    			
	    			UniAppManager.setToolbarButtons(['delete'],	 false);
	    		}
	    		if(store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}
	    		if(option.useNaviBtn) {
	    			if(naviStore.count() > 0)	{
						UniAppManager.setToolbarButtons(['prev','next'],true);
					} else {
	    				UniAppManager.setToolbarButtons(['prev', 'next'],false);
					}
	    		}
    		}
    		
    	}
    }
});// define