//@charset UTF-8
/**
 * Unilite 용 Util 모음 
 */
 
Ext.define('Unilite.com.UniUtils', {
    alternateClassName: ['UniUtils'],
	singleton: true,
	/**
	 * jQuery의 param함수를 구현함. 
	 * @param {} obj
	 * @return {}
	 */
	param: function(obj) {
		var s = [],r20 = /%20/g,
			add = function( key, value ) {
				s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
			};
		for ( var prefix in obj ) {	
         	add(prefix, obj[prefix]);  
		}

	    return s.join( "&" ).replace( r20, "+" );
	} ,
	stringifyJson: function(obj) {
	    return encodeURIComponent(JSON.stringify(obj))
	},
	msg : function(title, format){
			createBox = function(t, s) {
				return '<div class="msg"><h3>' + t + '</h3><p>' + s + '</p></div>';
			}
            if(!this.msgCt){
                this.msgCt = Ext.core.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
            }
            var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
            var m = Ext.core.DomHelper.append(this.msgCt, createBox(title, s), true);
            m.hide();
            m.slideIn('t').ghost("t", { delay: 1000, remove: true});
    },
	indexOf: function(v, values) {
		if(Array.isArray(values)) {
			if(values.indexOf(v) > -1) return true;
		}else{
			if(v == values) return true;
		}
		return false;
	}
});
/**
 * formfield label helper
 */
/*
 Ext.Function.createInterceptor(Ext.form.Field.prototype.initComponent, function() {
	console.log('intercept');
  var fl = this.fieldLabel, h = this.helpText;
  if (h && h !== '' && fl) {
   
});
*/