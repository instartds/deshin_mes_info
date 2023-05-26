//@charset UTF-8
/**
 *
 */
Ext.define('Unilite.com.grid.feature.UniGroupingSummary', {
    extend: 'Ext.grid.feature.GroupingSummary',
    alias: 'feature.uniGroupingsummary',
	
    hideGroupedHeader: false,
    groupHeaderTpl: Ext.create('Ext.XTemplate',  
    	'{columnName}: {name:this.formatName}',
    	{
	    	formatName: function(value) {
	    		if( value instanceof Date && !isNaN(value.valueOf()) ) {
	    			return UniDate.safeFormat(value);
	    		} else {
	    			return Ext.String.trim(value);
	    		}
	    	}
    	}
    )
});