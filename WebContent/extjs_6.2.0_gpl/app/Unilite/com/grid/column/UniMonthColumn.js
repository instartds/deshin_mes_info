//@charset UTF-8
/**
 *  Grid용 month column
 * 
 */
Ext.define('Unilite.com.grid.column.UniMonthColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniMonthColumn'],
    requires: ['Ext.Date', 'Unilite','Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.MonthColumn',
	fieldStyle: 'text-align:center;ime-mode:disabled;',

    initComponent: function(){
        if (!this.format) {
            this.format = Unilite.monthFormat;
        }
        
        this.callParent(arguments);
    },
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	return  UniDate.extFormatMonth(value);
    }
});