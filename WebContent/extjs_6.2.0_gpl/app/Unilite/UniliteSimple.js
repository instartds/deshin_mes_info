//@charset UTF-8

Ext.ns('Unilite');


/*
 * Debuger가 설치 안된 브라우져(일부 IE)에서 console 오류 발생 방지
 */
var alertFallback = false;

if (typeof console === "undefined" || typeof console.log === "undefined") {
	// https://developer.mozilla.org/en-US/docs/Web/API/console
	console = {
		/**
	    * @private
	    */
		_out: function(msg) {
			if (alertFallback) {
					alert(msg);
			}
		},
		log: function(msg) {
			this._out(msg);
		},
		info: function(msg) {
			this._out(msg);
		},
		warn: function(msg) {
			this._out(msg);
		},
		error: function(msg) {
			this._out(msg);
		}
	};
}


Ext.define('Unilite', {
    singleton: true,
    
    dbDateFormat: 'Ymd',
    dateFormat :'Y.m.d',
    altFormats : 'Ymd|Y.m.d|Y/m/d|Y-m-d|Y-m-d H:i:s'
    
});// define(UniLite)


//Ext.apply(Ext.data.Types, {
//	UniPrice : {
//		convert: function(v) {
//	            if (typeof v === 'number') {
//	                return v;
//	            }
//	            return v !== undefined && v !== null && v !== '' ?
//	                parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
//	        },
//	    sortType: Ext.data.SortTypes.none,
//	    type: 'uniPrice'
//	}
//});

Ext.apply(Ext.form.VTypes, {
	/**
	 * 연도 입력시 연도 비교용 
	 * @param {} val
	 * @param {} field
	 * @return {Boolean}
	 */
    yearRange : function(val, field) {
        // startYear, endYear
        if (field.startYearField && (!this.maxValue || (val != this.maxValue))) {
            var start = Ext.getCmp(field.startYearField);
            start.setMaxValue(val);
            //start.validate();
            this.maxValue = val;
        } else if (field.endYearField && (!this.minValue || (val != this.minValue))) {
            var end = Ext.getCmp(field.endYearField);
            end.setMinValue(val);
            //end.validate();
            this.minValue = val;
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

Ext.apply('Ext.form.field.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.grid.PropertyColumnModel', {dateFormat:Unilite.dateFormat});
Ext.apply('Ext.picker.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.util.Format', {dateFormat:Unilite.dateFormat});
