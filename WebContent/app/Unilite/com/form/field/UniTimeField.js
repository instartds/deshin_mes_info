//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniTimeField', {
    extend: 'Ext.form.field.Time',
    alias: 'widget.uniTimefield',
     autoSelect: true,
    format : "h:i A",	// 12H format with leading zero
    altFormats :'H:i|Hi',	// 24H
    submitFormat:'Hi',
    //minValue: '08:00 AM',
    increment: 30,
    initComponent: function() {
        	
//    	this.on('specialkey', function(elm, e){
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
    	
    	this.callParent(arguments);
    }
});  //Ext.define