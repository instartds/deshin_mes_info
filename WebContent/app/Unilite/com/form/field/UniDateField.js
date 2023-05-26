//@charset UTF-8
 /**
  * Unilite용 DateField
  */
Ext.define('Unilite.com.form.field.UniDateField', {
    extend: 'Ext.form.field.Date',
    alias: 'widget.uniDatefield',
    format: Unilite.dateFormat,
    enforceMaxLength: true,
    maxLength: 10,
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	/**
	 * 
	 * @cfg {String} submitFormat
	 * 'Ymd',   20131231
	 */
    submitFormat : Unilite.dbDateFormat, 
    altFormats: Unilite.altFormats,
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
    /**
     * always return true : 왜? ( 2014.2.21)
     * @return {Boolean}
     */
   // validate: function() {
   // 	return true;
    //}
});  //Ext.define