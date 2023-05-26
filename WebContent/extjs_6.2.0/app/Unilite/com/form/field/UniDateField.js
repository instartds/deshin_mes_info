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
    	var me = this;
    	
    	me.format = Unilite.dateFormat;
		me.submitFormat = Unilite.dbDateFormat;
		me.altFormats = Unilite.altFormats;
		
    	this.callParent(arguments);
    },
    
    parseDate : function(value) {
        if(!value || Ext.isDate(value)){
            return value;
        }
        if(Ext.isString(value)) value =value.replace(/[.]/g, '');
        
        var me = this,
            val = me.safeParse(value, me.format),
            altFormats = me.altFormats,
            altFormatsArray = me.altFormatsArray,
            i = 0,
            len;

        if (!val && altFormats) {
            altFormatsArray = altFormatsArray || altFormats.split('|');
            len = altFormatsArray.length;
            for (; i < len && !val; ++i) {
                val = me.safeParse(value, altFormatsArray[i]);
            }
        }
        return val;
    }
    /**
     * always return true : 왜? ( 2014.2.21)
     * @return {Boolean}
     */
   // validate: function() {
   // 	return true;
    //}
});  //Ext.define