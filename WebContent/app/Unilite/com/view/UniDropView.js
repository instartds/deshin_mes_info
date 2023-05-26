Ext.define('UniDropView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDropView',
    
    itemSelector: 'div.data-source',
    overItemCls: 'data-source',//'data-over',
    selectedItemClass: 'data-selected',
    singleSelect: true,
    
    
    dragRecord: null,
    dropRecord: null,
    dragRecords: null,
	
    uniDDGroup: 'dataGroup',
	uniBaseCls: 'data',
	allowDrop: true,
	
    constructor: function(config){
    	config = config || {};
        if (config.uniDDGroup) {
            this.uniDDGroup = config.uniDDGroup;
        }
        if (config.uniBaseCls) {
            this.uniBaseCls = config.uniBaseCls;
        }
        if (config.itemSelector) {
            this.itemSelector = config.itemSelector;
        }else {
        	this.itemSelector = 'div.'+this.uniBaseCls+'-source';
        }
        if (config.overItemCls) {
            this.overItemCls = config.overItemCls;
        }else {
        	this.overItemCls = this.uniBaseCls+'-over';
        }
        if (config.selectedItemClass) {
            this.selectedItemClass = config.selectedItemClass;
        }else {
        	this.selectedItemClass = this.uniBaseCls+'-selected';
        }
        this.callParent([config]);
    },
    
    initComponent: function() {
		this.on('render', this.onViewRender, this, {single: this.singleSelect});        
        this.callParent(arguments);
    },
    
    onViewRender: function(view)	{
    	
    	view.dropZone = Ext.create('Ext.dd.DropZone', view.getEl(), {
		ddGroup: this.uniDDGroup,

        getTargetFromEvent: function(e) {
            return e.getTarget('.'+view.uniBaseCls+'-source');
        },

        onNodeEnter : function(target, dd, e, data){
            //Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	view._setDragnDropRecords(target);
        	if(view.onDropEnter(target, dd, e, data))	{
            	Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	}
        },


        onNodeOut : function(target, dd, e, data){
            Ext.fly(target).removeCls(view.uniBaseCls+'-source-hover');
        },


        onNodeOver : function(target, dd, e, data){
           return view.allowDrop ? Ext.dd.DropZone.prototype.dropAllowed : Ext.dd.DropZone.prototype.dropNotAllowed;
        },

        onNodeDrop : function(target, dd, e, drag){         	 	
        		view.targetEl = target;
        		view.dropRecord = view.getRecord(target);
        		if(view.allowDrop)	{
	        		if("uniDragView" == drag.view.getXType())	{
	        			view.dragRecord = drag.record;
		        	} else if("gridview" == drag.view.getXType()) {
		        		view.dragRecord = drag.records[0];
	        			view.dragRecords = drag.records;
		        	}
	        		
		        	return view.onDrop(target, dd, e, drag);	
        		}
	        }     
    	});
    },
    onDrop: Ext.emptyFn,
    onDropEnter : Ext.emptyFn, 
    
    getDragRecord: function() {
    	return this.dragRecord;
    },
    getDragRecords: function() {
    	return this.dragRecords;
    },
    getDropRecord: function() {
    	return this.dropRecord;
    },
    isFromGridView: function(view)	{
    	if("gridview" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    isFromDataView: function(view)	{
    	if("uniDragView" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    setAllowDrop: function (b)	{
    	this.allowDrop = b;
    },
     _setDragnDropRecords: function(target)	{
    	this.dropRecord = this.getRecord(target); 	
    }
    
});   // UniDropView
