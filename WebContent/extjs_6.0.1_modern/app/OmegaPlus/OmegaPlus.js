//@charset UTF-8



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

function hideAddressBar() {
  if(!window.location.hash){
      if(document.height < window.outerHeight)
      {
          document.body.style.height = (window.outerHeight + 50) + 'px';
      }
 
      setTimeout( function(){ 
        window.scrollTo(0, 1);
       }, 50 );
  }
}




/**
 * @class Unilite
 * ## 사용예 
 * 
 * 
 */


//Ext.Error.handle = function(err) {
//    if (err.someProperty == 'NotReallyAnError') {
//        // maybe log something to the application here if applicable
//        return true;
//    }
//    console.log("ERROR!ERRO!\n");
//    console.log(err);
//    // any non-true return value (including none) will cause the error to be thrown
//}


Ext.define('OmegaPlus', {
    singleton: true,
    /*requires: [
    	'Unilite.com.UniValidator'
	],*/
	/**
	 * default DB용 date format (Ymd, '20141231')
	 * @type String
	 */
    dbDateFormat: 'Ymd',
    dbMonthFormat: 'Ym',
    /**
	 * default date display format (Ymd, '2014.12.31')
	 * system설정에따라 변경됨.
	 * @type String
	 */
    dateFormat :'Y.m.d',
    monthFormat :'Y.m',
    /**
     * 
     * @type String
     */
    altFormats : 'Ymd|Y.m.d|Y/m/d|Y-m-d|Y-m-d H:i:s',
    altMonthFormats : 'Ym|Y.m|Y/m|Y-m|Ymd|Y.m.d|Y/m/d|Y-m-d',
    /**
     * null이나 empty이면 defaultValue를 돌려줌
     * @param {} obj
     * @param {} defaultValue
     * @return {}
     */
    nvl: function(obj, defaultValue) {
    	if(!Ext.isDefined(obj)) { 
    		return defaultValue;
    	}
		return Ext.isEmpty(obj) ? defaultValue : obj;
	}, // nvl
    
	
	/**
	 * 
	 * @param {Object} config
	 * @return {Unilite.com.BaseApp}
	 */
	Main: function(config) {
		return Ext.create('OmegaPlus.BaseApp',config);
	}
});

