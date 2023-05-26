//@charset UTF-8
/**
 * Unilite용 확장 field
 */


Ext.define('Unilite.com.data.UniDate', {
	extend: 'Ext.data.field.Date',
	alias: 'data.field.uniDate',
	dateWriteFormat: Unilite.dbDateFormat,
	convert: function(v) {
        if (!v) {
            return null;
        }
        // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
        if (v instanceof Date) {
            return v;
        }
        return UniDate.extParseDate(v);
        //console.log(v, rv);
        //return rv;
	},
	sortType: Ext.data.SortTypes.asDate
});

Ext.define('Unilite.com.data.UniMonth', {
	extend: 'Ext.data.field.Date',
	alias: 'data.field.uniMonth',
	dateWriteFormat: Unilite.dbMonthFormat,
	convert: function(v) {
        if (!v) {
            return null;
        }
        // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
        if (v instanceof Date) {
            return v;
        }
        return v;
        //console.log(v, rv);
        //return rv;
	},
	sortType: Ext.data.SortTypes.asDate
});

Ext.define('Unilite.com.data.UniTime', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniTime',
	convert: function(v) {
    	if (!v) {
                return null;
        }
		if (typeof v == 'number') {
            return parseInt(v);
        }
		
        // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
        if (v instanceof Date) {
            return v;
        }
        return UniDate.extParseDate(v);
//                return v !== undefined && v !== null && v !== '' ?
//                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },        
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniYear', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniYear',
	convert: function(v) {
		if (typeof v == 'number') {
                return parseInt(v);
            }
            return v !== undefined && v !== null && v !== '' ?
                parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
        },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniQty', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniQty',
	convert: function(v) {
		if (typeof v == 'number') {
                return parseInt(v);
            }
            return v !== undefined && v !== null && v !== '' ?
                parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
        },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniPrice', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniPrice',
	convert: function(v) {
        if (typeof v === 'number') {
            return v;
        }
        return v !== undefined && v !== null && v !== '' ?
            parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniUnitPrice', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniUnitPrice',
	convert: function(v) {
        if (typeof v === 'number') {
            return v;
        }
        return v !== undefined && v !== null && v !== '' ?
            parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniPercent', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniPercent',
	convert: function(v) {
        if (typeof v === 'number') {
            return v;
        }
        return v !== undefined && v !== null && v !== '' ?
            parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniFC', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniFC',
	convert: function(v) {
        if (typeof v === 'number') {
            return v;
        }
        return v !== undefined && v !== null && v !== '' ?
            parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniER', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniER',
	convert: function(v) {
        if (typeof v === 'number') {
            return v;
        }
        return v !== undefined && v !== null && v !== '' ?
            parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.allowNull ? null : 0);
    },
    sortType: Ext.data.SortTypes.none
});

Ext.define('Unilite.com.data.UniPassword', {
	extend: 'Ext.data.field.Field',
	alias: 'data.field.uniPassword',
	convert: function(v) {
        var defaultValue = this.allowNull ? null : '';
        return (v === undefined || v === null) ? defaultValue : String(v);
    },
    sortType: Ext.data.SortTypes.asUCString
});