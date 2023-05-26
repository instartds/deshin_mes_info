Ext.define('DnDView', {
    extend : 'Ext.view.View',
    requires : ['Ext.ux.DataView.Draggable' ],
    mixins: {
        draggable: 'Ext.ux.DataView.Draggable'
    },
    ddGroup: 'someGroup',
    constructor: function(config){
    	config = config || {};
        if (config.ddGroup) {
            this.ddGroup = config.ddGroup;
        }
        this.callParent([config]);
    },
    initComponent: function() {
		console.log('ddGroup:', this.ddGroup);
    	this.mixins.draggable.init(this, {
            ddConfig: {
                ddGroup: this.ddGroup
            },
            ghostConfig: {
            	id:this.id
            }
        });
        
        this.callParent(arguments);
    },
    emptyText: 'No images to display',    
    overItemCls: 'presentaion-item-over',
    selectedItemCls: 'presentaion-item-selected',
    getCurrentIndex: function() {
    	var idx = 0;
    	var curRec = this.getSelectionModel().getSelection()[0];
    	if(curRec) {
    		idx = this.store.indexOf(curRec);
    	}
    	return idx;
    }
});   // DnDView