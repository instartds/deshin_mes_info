//@charset UTF-8

// 자리 차지 하는 hide 기능 추가 
Ext.define('Ext.overide.form.field.Base', {
    override: 'Ext.form.field.Base',
    //selectOnFocus: true,
    initComponent : function() {
    	this.callParent(arguments);
    	
    	//focus 이동 처리
    	if(!this.hasListener('specialkey'))	{
	    	this.on('specialkey', function(elm, e){
	    		
	    		switch( e.getKey() ) {
	                case Ext.EventObjectImpl.ENTER:
	                	if(elm && elm.getXType() == 'uniCombobox')	{
	                		if(elm.isExpanded)	{
	                			e.stopEvent();
	                			var picker = elm.getPicker();
	                			if(picker)	{
	                				var view = picker.selectionModel.view;
	                				if(view && view.highlightItem)	{
	                					picker.select(view.highlightItem);
	                				}
	                			}
	        
	                		} else {
			                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
			                		Unilite.focusPrevField(elm, true, e);
			                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
			                		Unilite.focusNextField(elm, true, e);
			                	}
		                	}
	                	}else {
		                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
		                		Unilite.focusPrevField(elm, true, e);
		                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
		                		Unilite.focusNextField(elm, true, e);
		                	}
	                	}
	                	break;
	                 case Ext.EventObjectImpl.TAB:
	                 	if(e.currentTarget && e.currentTarget.parentElement && e.currentTarget.parentElement.id)	{
	                 		if(e.currentTarget.parentElement.id.toLowerCase().indexOf("popupcolumn") > -1)	{
	                 			if(elm && elm.ownerCt && elm.ownerCt.editingPlugin)	{
	                 				e.stopEvent();
	                 				this.fireEvent("blur");
	                 				elm.ownerCt.editingPlugin.completeEdit();
	                 				break;
	                 			}
	                 			
	                 		}
	                 	}/*
	                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(elm, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		Unilite.focusNextField(elm, true, e);
	                	}*/
	                	break;
	                default : break;
	                /*case Ext.EventObjectImpl.LEFT:
		            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
		            	var pos = elm.getCaretPosition(elm);
		            	if(pos < 1) {
		            		Unilite.focusPrevField(elm, false, e);
		            	}
		            	break;
		            case Ext.EventObjectImpl.RIGHT:
		            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
		            	var pos = elm.getCaretPosition(elm);
		            	var len = 0;
		            	if(Ext.isFunction(elm.getRawValue)) {
		            		len = (Ext.isEmpty(elm.getRawValue()) ? 0 : (typeof(elm.getRawValue()) === "string" ?  elm.getRawValue().length : 0));
		            	}
		            	if(pos >= len) {
		            		Unilite.focusNextField(elm, false, e);
		            	}
		            	break;	*/
	      		}      		
	    	});
    	}
    },
    getCaretPosition: function(obj) {
    	
    	var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
		
		if(!isFirefox && !Ext.isSafari && !Ext.isChrome)	{
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
		}else {
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