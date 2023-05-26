//@charset UTF-8
/**
 * 
 */
Ext.define('Unilite.com.form.field.UniFile', {
	extend: 'Ext.form.field.File',
    alias: 'widget.uniFilefield',
    buttonOnly: false,
	initComponent: function () {

	 	this.callParent();
	 	
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
	}
});