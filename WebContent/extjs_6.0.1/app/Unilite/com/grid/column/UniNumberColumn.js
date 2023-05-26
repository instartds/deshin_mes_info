//@charset UTF-8
/**
 *  Grid용 number column
 * 
 */
Ext.define('Unilite.com.grid.column.UniNnumberColumn', {
    extend: 'Ext.grid.column.Number',
    alias: ['widget.uniNnumberColumn'],
    requires: ['Ext.util.Format'],

    /**
     * @cfg {String} format
     * A formatting string as used by {@link Ext.util.Format#number} to format a numeric value for this Column.
     */
    format : '0,000',
	
    defaultRenderer: function(value){
        return Ext.util.Format.number(value, this.format);
    },
    summaryRenderer: function(value, summaryData, dataIndex) {
        return Ext.util.Format.number(value, this.format);
    }
});