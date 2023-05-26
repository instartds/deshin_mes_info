//@charset UTF-8
/**
 * @class Ext.data.Types
 * 
 * Unilite용 확장 Types
 * 타입 첫글자는 무조건 대문자로 !!!
 * @type 
 */
var st = Ext.data.SortTypes;
Ext.apply(Ext.data.Types, {
	/**
	 * 
	 * @type 
	 */
	//UniDate : {
	UNIDATE : {
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
		sortType: Ext.data.SortTypes.asDate,
		type: 'uniDate'
	},
	UNIMONTH : {
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
	        sortType: Ext.data.SortTypes.asDate,
	        type: 'uniMonth'
	},
	/**
	 * 
	 * @type 
	 */
	UNITIME : {
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
//                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	     },
	        
        sortType: Ext.data.SortTypes.none,
        type: 'uniTime'
	},
	UNIYEAR : {
	    convert: function(v) {
			if (typeof v == 'number') {
                    return parseInt(v);
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	        },
        sortType: Ext.data.SortTypes.none,
        type: 'uniYear'
	},
	UNIQTY : {
	    convert: function(v) {
			if (typeof v == 'number') {
                    return parseInt(v);
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	        },
        sortType: Ext.data.SortTypes.none,
        type: 'uniQty'
	},
	UNIPRICE : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniPrice'
	},
	UNIUNITPRICE : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniUnitPrice'
	},
	UNIPERCENT : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniPercent'
	},
	UNIFC : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniFC'
	},
	UNIER : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniER'
	},
	UNIPASSWORD : {
             convert: function(v) {
                var defaultValue = this.useNull ? null : '';
                return (v === undefined || v === null) ? defaultValue : String(v);
            },
            sortType: st.asUCString,
	        type: 'uniPassword'
	}
});