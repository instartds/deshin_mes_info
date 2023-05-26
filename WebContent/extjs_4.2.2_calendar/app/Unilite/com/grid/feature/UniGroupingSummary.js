//@charset UTF-8
/**
 *
 */
Ext.define('Unilite.com.grid.feature.UniGroupingSummary', {

    extend: 'Ext.grid.feature.Grouping',

    alias: 'feature.uniGroupingsummary',

    showSummaryRow: true,
    
    //hideGroupedHeader: true,
    
    vetoEvent: function(record, row, rowIndex, e){
        var result = this.callParent(arguments);
        if (result !== false) {
            if (e.getTarget(this.summaryRowSelector)) {
                result = false;
            }
        }
        return result;
    },
    // groupHeaderTpl:'{columnName}: {name}',
    groupHeaderTpl: Ext.create('Ext.XTemplate',  
    	'{columnName}: {name:this.uniFormat}',
    	{
	    	uniFormat: function(value, rows) {
	    		if( value instanceof Date && !isNaN(value.valueOf()) ) {
	    			return UniDate.safeFormat(value);
	    		} else {
	    			return Ext.String.trim(value);
	    		}
	    	}
    	}
    ),
    /**
     * @overide
     * @param {} store
     * @param {} type
     * @param {} field
     * @param {} group
     * @return {}
     */
    getSummary: function(store, type, field, group){
        var records = group.records;

        if (type) {
            if (Ext.isFunction(type)) {
                return store.getAggregate(type, null, records, [field]);
            }

            switch (type) {
                case 'count':
                    return records.length;
                case 'min':
                    return store.getMin(records, field);
                case 'max':
                    return store.getMax(records, field);
                case 'sum':
                    return store.getSum(records, field);
                case 'average':
                    return store.getAverage(records, field);
                 case 'nod':
                    return this._getNOD(records, field);
                default:
                    return '';

            }
        }
    },
    /**
     * number of distinct values 
     * @private
     * @param {} records
     * @param {} dataIndex
     * @return {}
     */
    _getNOD: function (records, dataIndex) {
    	var rv = "";
	  		var oldValue = null;
	  		for(i = 0, len = records.length; i < len; i ++) {
	  			var value = records[i].get(dataIndex) ;
	  			if(oldValue != null && value != oldValue) {
	  				rv = "";
	  				break;
	  			} else {
	  				oldValue = value;
	  				rv = value;
	  			}
	  		}
	  		return rv;
    }
});