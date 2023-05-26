/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Model
 **************************************************/

/**************************************************
 * Store
 **************************************************/

/**************************************************
 * Define
 **************************************************/
/*
 Ext.define('nbox.ckeditor.ckeditor', {
	extend: 'Ext.form.field.TextArea',
	 
    alias: 'widget.ckeditor',
 
    onRender : function(ct, position){
        if(!this.el){
            this.defaultAutoCreate = {
                tag: "textarea",
                autocomplete: "off"
            };
        }
        this.callParent(arguments);
        this.editor = CKEDITOR.replace(this.inputEl.id, this.CKConfig);
    },
 
    setValue: function(value) {
        this.callParent(arguments);
        if(this.editor){
            this.editor.setData(value);
        }
        //var inputId = this.getInputId();
        //if(CKEDITOR.instances[inputId]){
            //CKEDITOR.instances[inputId].setData(value);
        //}
    },
 
    getValue: function() {
        if (this.editor) {
            this.editor.updateElement();
            return this.editor.getData()
        } else {
            return ''
        }
    },
 
    getRawValue: function() {
        if (this.editor) {
            this.editor.updateElement();
            return this.editor.getData()
        } else {
            return ''
        }
    }
     
});
*/
Ext.define('nbox.ckeditor.ckeditor', {
    extend: 'Ext.form.field.TextArea',
    alias: 'widget.ckeditor',
    
    defaultListenerScope: true,
    
    listeners: {
        instanceReady: 'instanceReady',
        resize: 'resize',
        boxready : 'onBoxReady'
      },
    
    editorId: null,
    editor:null,
    tempData:null,
    CKConfig: {},
    InstanceReadyFlag: false,
    
    constructor: function () {
        this.callParent(arguments);
    },

    initComponent: function () {
        this.callParent(arguments);
        this.on("afterrender", function () {
        
            Ext.apply(this.CKConfig, {
            	
            });
        
            this.editor = CKEDITOR.replace(this.inputEl.id, this.CKConfig);
            this.editorId = this.inputEl.id;
            this.editor.name = this.name;

            this.editor.on("instanceReady", function (ev) {
        
                this.fireEvent(
                    "instanceReady",
                    this,
                    this.editor
                );
            }, this);
         
        }, this);
    },
    
    instanceReady : function (ev) {
    	var me = this;
        // Set read only to false to avoid issue when created into or as a child of a disabled component.
    	me.InstanceReadyFlag = true;
    	ev.editor.setReadOnly(false);

    	var eid = me.editorId,
    	 	editor = CKEDITOR.instances[me.editorId];     

    	if (!Ext.isEmpty(CKEDITOR.instances[me.editorId])){
    		 CKEDITOR.instances[me.editorId].resize(me.getWidth() - 3, me.getHeight() - 3);
    		 
    		 if (!Ext.isEmpty(me.tempData)){
    			 me.setValue(me.tempData);
    			 me.tempData = null;
    		 }
    	}
    },
    
    onRender: function (ct, position) {
        if (!this.el) {
            this.defaultAutoCreate = {
                tag: 'textarea',
                autocomplete: 'off'
            };
        }
        this.callParent(arguments)
    },
    
    setValue: function (value) {
    	var me = this;

        if (me.editor) {
        	me.editor.setData(value);
        }
    },

    getValue: function () {
        if (this.editor) {
            return this.editor.getData();
        }
        else {
            return ''
        }
    },
    insertHtml : function(html){
    	var me = this;

    	if (me.editor) {
    		me.editor.insertHtml(html);
    	}
    },
    destroy: function(){
    	var me = this;
        // delete instance
        if(!Ext.isEmpty(CKEDITOR.instances[me.editorId])){
            delete CKEDITOR.instances[me.editorId];
        }

    },

    resize: function(win, width, height, opt) {
        var eid = this.editorId,
            editor = CKEDITOR.instances[this.editorId];

        if (this.InstanceReadyFlag){

	        if (!Ext.isEmpty(CKEDITOR.instances[this.editorId])){
	            CKEDITOR.instances[this.editorId].resize(width - 3, height - 3);
	        }       
        }
    },
    
    onBoxReady : function(win, width, height, eOpts){
        // used to hook into the resize method
    }
});


