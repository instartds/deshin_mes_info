//@charset UTF-8
/**
 *  Grid용 date column
 * 
 */
Ext.define('Unilite.com.grid.column.UniDateColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniDateColumn'],
    requires: ['Ext.Date', 'Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.DateColumn',
	fieldStyle: 'text-align:center;ime-mode:disabled;',

    initComponent: function(){
        if (!this.format) {
            this.format = Ext.Date.defaultFormat;
        }
        
        this.callParent(arguments);
    },
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	return  UniDate.safeFormat(value);
    	//console.log(value, rv);
    	//return rv;
        //return Ext.util.Format.date(value, this.format);
    }
});