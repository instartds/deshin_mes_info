//@charset UTF-8


Ext.define('Unilite.com.tab.UniGroupTabPanel', {
	extend: 'Ext.ux.GroupTabPanel',
	alias: 'widget.uniGroupTabPanel',
	autoScroll: false,
	scrollable: false,
	columnWidth:200,
	treeColumnConfig:{},
	treePanel:{ scrollable:false},
	constructor : function(config){    
        var me = this;
		if(config)	{
			if(config.treeColumnConfig)	{
				Ext.Object.merge(me.treeColumnConfig, config.treeColumnConfig)
			}
			if(config.treePanel)	{
				Ext.Object.merge(me.treePanel, config.treePanel)
			}
			Ext.each(config.items, function(group, idx){
				Ext.each(group.items, function(item, idx){
					if(idx == 0)	{
						item.iconCls ='blank-icon';
					}
				})
			})
		}
        this.callParent([config]);
	}, 
	
    initComponent: function() {
    	var me = this;
        me.callParent(arguments);
    	
    	
    	var treePanel = me.down('treepanel');
    	if(treePanel) {
    		treePanel.setConfig(me.treePanel);
    	}
    	if(treePanel.columns) {
    		treePanel.columns[0].setConfig(me.treeColumnConfig)
    	}

    	me.on('beforegroupchange', me._onTabChange );
    	
    	
    },
    
    _onTabChange: function( grouptabPanel, newCard, oldCard, eOpts )	{    	
    	if(!newCard.items || newCard.items.length == 0)	{
    		var initConfig = grouptabPanel.getInitialConfig();
    		Ext.each(initConfig.items, function(group, idx)	{
    			var groupItems =  group.items;
    			if(groupItems && groupItems.length >1)	{
	    			if(newCard.getItemId() == groupItems[0].itemId){
	    				var treePanel = grouptabPanel.down('treepanel');
	    				var store = treePanel.getStore();
	    				var node = store.findNode('id', newCard.id);
	    				var secondCard = grouptabPanel.down('#'+groupItems[1].itemId).id
        				node.expand();
        				var secondNode =  store.findNode('id', secondCard);
        				
        				setTimeout(function() {  treePanel.getSelectionModel().select(secondNode);secondNode.data.activeTab = true}, 100);
        				return false;
	    			}
    			}
    		})
    		
    	}
    	return true;
    }
});// define