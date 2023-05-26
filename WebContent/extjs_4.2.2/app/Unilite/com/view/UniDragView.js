Ext.define('UniDragView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDragView',
    
	uniDDGroup: 'dataGroup',
	dragData: {},
	
    constructor: function(config){
    	config = config || {};
        if (config.uniDDGroup) {
            this.uniDDGroup = config.uniDDGroup;
        }        
        this.callParent([config]);
    },
    
    initComponent: function() {
		this.on('render', this.onViewRender, this);        
        this.callParent(arguments);
    },
    
    onViewRender: function(view)	{    	
    	view.dragZone = Ext.create('Ext.dd.DragZone', view.getEl(), {
    		ddGroup: this.uniDDGroup,
	    	getDragData: function(e) {
		        var sourceEl = e.getTarget(view.itemSelector, 20);
		        var d;
		        if (sourceEl) {
		            d = sourceEl.cloneNode(true);
		        	d=  view.getNode(sourceEl);
		            d.id = Ext.id();
		            this.dragData = view.dragData = {
		                sourceEl: sourceEl,
		                repairXY: Ext.fly(sourceEl).getXY(),
		                ddel: d,
		                record:view.getRecord(sourceEl),
		                view: view
		            };
		            return this.dragData;
		        }
	    	}
    	})
    }
    
});   // UniDragView

