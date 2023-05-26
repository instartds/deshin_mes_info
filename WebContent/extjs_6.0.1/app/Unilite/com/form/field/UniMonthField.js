/**
 * 
 */

Ext.define('Unilite.com.form.field.UniMonthField', {
	extend: 'Ext.form.field.Date',
	alias: 'widget.uniMonthfield',
    requires: [
    	'Ext.picker.Month'/*,
    	'Unilite.com.form.field.UniClearButton'*/
    ],
    selectMonth: null,
    format: Unilite.monthFormat,
    enforceMaxLength: true,
    maxLength: 7,
    fieldStyle: 'text-align:center;ime-mode:disabled;',
    submitFormat : Unilite.dbMonthFormat,
    altFormats: Unilite.altMonthFormats,
    showToday: false,
    labelStyle: 'text-align:right; margin-right:0',
    labelSeparator: '',
    padding: 0, 
    //margin: 0,
    labelWidth: 0,
	uniOpt: {},
	
    initComponent: function () {
		var me = this;
    	
	 	this.callParent();
	},
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        return Ext.create('Ext.picker.Month', {
            ownerCt: me.ownerCt,
            renderTo: document.body,
            ownerCmp: me,
            // OVERRIDE
            focusable: me.focusable,
            floating: true,
            focusable: false, // Key events are listened from the input field which is never blurred
			uniHide:false,
            //height:170,
            listeners: { 
            	/*
		        select:        { scope: me,   fn: me.onSelect      }, 
		        monthdblclick: { scope: me,   fn: me.onOKClick     },
		        yeardblclick:  { scope: me,   fn: me.onOKClick     },
		        //monthclick: { scope: me,   fn: me.onOKClick     },
		        //yearclick:  { scope: me,   fn: me.onOKClick     },
		        OkClick:       { scope: me,   fn: me.onOKClick     },    
		        CancelClick:   { scope: me,   fn: me.onCancelClick }
		        */
            	scope: me,
            	select:         me.onSelect      , 
		        monthdblclick:  me.onOKClick     ,
		        yeardblclick:  	me.onOKClick     ,
		        monthclick: 	me.onSelect     ,
		        yearclick:  	me.onSelect     ,
		        OkClick:       	me.onOKClick     ,    
		        CancelClick:   	me.onCancelClick ,
		        beforehide:function(cmp)	{
	        		if((Ext.isChrome || Ext.isSafari) && !cmp.uniHide)	{
	        			return false;
	        		}else if((Ext.isChrome || Ext.isSafari) && cmp.uniHide)	{
	        			cmp.setHide(false);
	        		}
		        	
		        }
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            },
		    setHide:function(hide)	{
		    	var me = this;
		    	if(Ext.isChrome || Ext.isSafari){
		    		me.uniHide = hide;
		    	}
		    }
        });
    },
    onSelect: function(picker, value) {
        var me = this;        	
        me.selectMonth = me._getSelectDate(value);
        me.setValue(me.selectMonth);
        if(Ext.isFunction(picker.setHide)) picker.setHide(false);
        me.fireEvent('select', me, me.selectMonth);
       
    },
    onOKClick: function(picker, value) {
        var me = this;    
	    if( me.selectMonth == null ) {
	    	me.onSelect(picker, value);
	    }
	    if(Ext.isFunction(picker.setHide)) picker.setHide(true);
		if(Ext.isChrome || Ext.isSafari){
	    	picker.hide();
		}else {
			me.collapse();
		}
        //
    },
    onCancelClick: function(picker, value) {
        var me = this;    
    	me.selectMonth = null;
        if(Ext.isFunction(picker.setHide))  picker.setHide(true);
        if(Ext.isChrome || Ext.isSafari){
	    	picker.hide();
		}else {
			me.collapse();
		}
		
    },
    _getSelectDate: function(d) {
    	var me = this,
            month	= d[0],
            year 	= d[1],
            date 	= new Date(year, month, 1);

        if(date.getMonth() !== month){
            date = Ext.Date.getLastDateOfMonth(new Date(year, month, 1));
        }
       
        return Ext.util.Format.date(date, me.format);
    }
});  
 