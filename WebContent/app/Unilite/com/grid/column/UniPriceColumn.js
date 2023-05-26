//@charset UTF-8
/**
 *  Grid용 Price column
 * 
 */
Ext.define('Unilite.com.grid.column.UniPriceColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniPriceColumn'],
    requires: ['Ext.util.Format'],

    /**
     * @cfg {String} format
     * A formatting string as used by {@link Ext.util.Format#number} to format a numeric value for this Column.
     */
    format : '0,000',


    defaultRenderer: function(value){
        return Ext.util.Format.number(value, this.format);
    }
});