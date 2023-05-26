//@charset UTF-8
/**
 *  Grid용 date column
 * 
 */
Ext.define('Unilite.com.grid.column.UniTimeColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniTimeColumn'],
    requires: ['Ext.Date', 'Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.TimeColumn',
    
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	format: 'H:i',
	constructor: function(config){    
        var me = this;
        
       	if (config) {
            Ext.apply(me, config);
        };	
        
        this.callParent([config]);
	},
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	
    	return  Ext.Date.format(value, this.format);
    	//console.log(value, rv);
    	//return rv;
        //return Ext.util.Format.date(value, this.format);
    }
});