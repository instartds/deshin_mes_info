Ext.define('UniDragandDropView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDragandDropView',
    
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
	dragData: {},
	
	
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
		view.dragZone = Ext.create('Ext.dd.DragZone', view.getEl(), {
		ddGroup: this.uniDDGroup,
		containerScroll: true,
		    	getDragData: function(e) {
			        var sourceEl = e.getTarget(view.itemSelector, 20), d;
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
	    });
    	
    	view.dropZone = Ext.create('Ext.dd.DropZone', view.getEl(), {
		ddGroup: this.uniDDGroup,
		containerScroll: true,
        getTargetFromEvent: function(e) {
            return e.getTarget('.'+view.uniBaseCls+'-source');
        },

        onNodeEnter : function(target, dd, e, data){
        	view._setDragnDropRecords(target, data);
        	if(view.onDropEnter(target, dd, e, data))	{
            	Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	}
        },


        onNodeOut : function(target, dd, e, data){
            Ext.fly(target).removeCls(view.uniBaseCls+'-source-hover');
        },


        onNodeOver : function(target, dd, e, data){
            return view.allowDrop ? Ext.dd.DropZone.prototype.dropAllowed : Ext.dd.DropZone.prototype.dropNotAllowed;
            //return Ext.dd.DropZone.prototype.dropAllowed;
        },

        onNodeDrop : function(target, dd, e, drag){         	 	
        		view.targetEl = target;
        		view._setDragnDropRecords(target, drag);
	        	return view.allowDrop ? view.onDrop(target, dd, e, drag) : false;	        	
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
    
    _setDragnDropRecords: function(target, drag)	{
    	this.dropRecord = this.getRecord(target);
    	this.dragRecord = drag.record;    	
    }
    
});   // UniDragandDropView