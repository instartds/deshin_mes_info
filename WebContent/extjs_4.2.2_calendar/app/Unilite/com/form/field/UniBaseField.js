//@charset UTF-8

// 자리 차지 하는 hide 기능 추가 
Ext.define('Ext.overide.form.field.Base', {
    override: 'Ext.form.field.Base',
    //selectOnFocus: true,
    initComponent : function() {
    	this.callParent(arguments);
    	
    	//focus 이동 처리
    	this.on('specialkey', function(elm, e){
    		switch( e.getKey() ) {
                case Ext.EventObject.ENTER:
                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
                		Unilite.focusPrevField(elm, false, e);
                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
                		Unilite.focusNextField(elm, false, e);
                	}
                	break;
                case Ext.EventObject.LEFT:
	            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
	            	var pos = elm.getCaretPosition(elm);
	            	if(pos < 1) {
	            		Unilite.focusPrevField(elm, false, e);
	            	}
	            	break;
	            case Ext.EventObject.RIGHT:
	            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
	            	var pos = elm.getCaretPosition(elm);
	            	var len = 0;
	            	if(Ext.isFunction(elm.getRawValue)) {
	            		len = (Ext.isEmpty(elm.getRawValue()) ? 0 : (typeof(elm.getRawValue()) === "string" ?  elm.getRawValue().length : 0));
	            	}
	            	if(pos >= len) {
	            		Unilite.focusNextField(elm, false, e);
	            	}
	            	break;	
      		}      		
    	});
    },
    getCaretPosition: function(obj) {
        var el = obj.inputEl.dom;
        if (typeof(el.selectionStart) === "number") {
            return el.selectionStart;
        } else if (document.selection && el.createTextRange){
            var range = document.selection.createRange();
            range.collapse(true);
            range.moveStart("character", -el.value.length);
            return range.text.length;
        } else {
            //throw 'getCaretPosition() not supported';
        	return 0;
        }
    },
    /**
     * 자리는 차지하되 보이지 않게.
     * el의 setDisplayed 역활이나 그려지지 않은 상황 에서도 적용됨.
     * @param {} visible
     */
    uniSetDisplayed: function(visible) {
    	var el = this.getEl();
    	
    	if( el ) { 
    		el.setDisplayed(visible);
    	} else {
    		var newStyle = (visible) ?  {display: 'inline'} :  {display: 'none'};
    		if(  this.style == undefined ) {
                this.style =  newStyle
    		} else {
            	 Ext.apply(this.style, newStyle);
            }
    	}
    }
    
});
/**
 * unilite용 form field의 기저 정의 
 */
Ext.define('Unilite.com.form.field.UniBaseField', {
	/**
     * @property {Unilite.com.form.UniAbstractForm} ownerForm
     * 
     * @readonly
     */
	ownerForm: null,
	setOwnerForm: function(form ) {
		//console.log('set');
		this.ownerForm = form;
	},
	/**
	 * 에러메시지 표시하지 않게 변경함.
	 * @overide
	 * @param {} active
	 */
	setError: function(active){
        var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, active || '');
            } else {
                //me.updateLayout();
            }
        }
    }
}); // define