//@charset UTF-8
/**
 * 
 * Grid 용 popup
 * 
 * ## Example usage:
 *  
 *		@example
 *
 * 		{ 	dataIndex:'MCUSTOM_NAME',	
 *			'editor' : Unilite.popup('CUST_G',{						            
 *					textFieldName:'MCUSTOM_NAME',
 *				    listeners: {
 *						'onSelected':  function(records, type  ){
 *						 	//var grdRecord = masterGrid.getSelectedRecord();
 *						 	var grdRecord = masterGrid.uniOpt.currentRecord;
 *						 	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
 *						 }
 *						 ,'onClear':  function( type  ){
 *						 	//var grdRecord = masterGrid.getSelectedRecord();
 *						 	var grdRecord = masterGrid.uniOpt.currentRecord;
 *						 	grdRecord.set('MCUSTOM_NAME','');
 *						 	grdRecord.set('MANAGE_CUSTOM','');
 *						 }
 *					} // listeners
 *				}) // Unilite.popup
 *		}
 */
Ext.define('Unilite.com.form.popup.UniPopupColumn', {
    extend: 'Ext.form.field.Trigger',
    alias: 'widget.uniPopupColumn',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniPopupAbstract'
    },
    store:'',
    triggerCls :'x-form-search-trigger',
	enableKeyEvents: true,
	validateBlank : true,	// 잘못된 값을 그냥 둘것인지? true = 잘못된 값은 clear함 
	onTriggerClick: function() {
	    this.openPopup( 'TEXT');
	},
    textFieldName: 'CUSTOM_NAME',
	//popupPage : '/com/popup/CustPopup.do',
	popupWidth:700,
	popupHeight:500,
	//width:150,
	validateOnChange:false,
	uniPopupChanged : false,
	uniOpt:{},
	validator: function() {
		console.log('validator -> _onFieldBlur');
		if(this.useBarcodeScanner)	{
			this._onFieldBlur(this.textField, 'TEXT', true);
		} else {
			this._onFieldBlur(this.textField, 'TEXT', false);
		}
		return true;
		return true;
	}, 
    constructor : function(config){    
        var me = this;
        config.trackResetOnLoad = true;
        me.callParent(arguments);
        me.addEvents('onSelected');
        me.mixins.observable.constructor.call(me, config);
        me.mixins.popupBehaviour.constructor.call(me, config);
        me.textField = this;
        
        me.store = new Ext.create('Ext.data.Store', {
        	autoload:false,
        	fields:[ me.valueFieldName,  me.textFieldName ],
        	proxy:{
		    	type: 'direct',
				api: {
                    read: me.api //'popupService.custPopup'
				}
			},
            listeners: {
            }
		});
    },
    _clearValue : function (me, type) {
    	me.setValue('');
    	me.fireEvent('onClear',  type);	
    },
    // private
    initComponent: function() {
        var me = this;
    	
    	me.on('render',function(c) {        		
    		 c.getEl().on('dblclick', function(){			    	
			    	me.openPopup( 'TEXT');
			  });
        }); // render
        /*
         * me.on('blur', function(elm, e, eOpts ) {
        	//console.log('blur');
        	elm._onFieldBlur(me.textField, 'TEXT', false);
        } ); // blur
        */
        me.on('change', function(elm, newValue, oldValue, eOpts ) {
        	//console.log('change');
        	me._onFieldChange(me.textField, 'TEXT', newValue, oldValue);
        	//elm._onFieldBlur(me.textField, 'TEXT', false);
        } ); // blur
        
        // special key down
        me.on('keydown', function(elm, e){
	      		//console.log("KEYS:", evt.getKey());
	      		switch( e.getKey() ) {
	      			case Ext.EventObject.F8:
	      				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
	      			 		elm.openPopup( 'TEXT');
	      			 		e.stopEvent();
	      				}
	        			break;
	      		}
        } ); // keydown
        
        me.callParent(arguments);
    }
    ,
    _setRecordExtParam:function()	{
    	var me = this;	
 		if(me.uniOpt != null && Ext.isDefined(me.uniOpt.recordFields)) {
 			var grid = Ext.getCmp(me.uniOpt.grid);
 			Ext.each(me.uniOpt.recordFields, function(field, idx)	{
 				me.extParam[field] = grid.uniOpt.currentRecord.get(field);
 			})
 		}
    }
});