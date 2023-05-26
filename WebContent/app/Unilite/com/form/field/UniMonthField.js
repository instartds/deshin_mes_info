/**
 * 
 */

Ext.define('Unilite.com.form.field.UniMonthField', {
	extend: 'Ext.form.field.Date',
	alias: 'widget.uniMonthfield',
    requires: [
    	'Ext.picker.Month',
    	'Unilite.com.form.field.UniClearButton'
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
    padding: 0, margin: 0,
    labelWidth: 0,
	uniOpt: {},
	//value: Ext.util.Format.date(new Date(), this.format),
	
    initComponent: function () {
		var me = this;
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
	 		if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push('uniClearbutton');
	 	};
	 	if(Ext.isEmpty(me.value)) {
			me.setValue(Ext.util.Format.date(new Date(), me.format));
	 	}else{
	 		if(Ext.isDate(me.value)) {
	 			me.setValue(Ext.util.Format.date(me.value, me.format));
	 		}else {
	 			me.setValue(me.value);
	 		}
	 	}
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
	 	this.callParent();
	},
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        return Ext.create('Ext.picker.Month', {
            pickerField: me,
            ownerCt: me.ownerCt,
            renderTo: document.body,
            floating: true,
            hidden: true,
            focusOnShow: true,
            minDate: me.minValue,
            maxDate: me.maxValue,
            disabledDatesRE: me.disabledDatesRE,
            disabledDatesText: me.disabledDatesText,
            disabledDays: me.disabledDays,
            disabledDaysText: me.disabledDaysText,
            format: me.format,
            showToday: me.showToday,
            startDay: me.startDay,
            small: me.showToday === false,
            minText: format(me.minText, me.formatDate(me.minValue)),
            maxText: format(me.maxText, me.formatDate(me.maxValue)),
            height:170,
            listeners: { 
		        select:        { scope: me,   fn: me.onSelect      }, 
		        monthdblclick: { scope: me,   fn: me.onOKClick     },    
		        yeardblclick:  { scope: me,   fn: me.onOKClick     },
		        OkClick:       { scope: me,   fn: me.onOKClick     },    
		        CancelClick:   { scope: me,   fn: me.onCancelClick }        
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            }
        });
    },
    onSelect: function(picker, value) {
        var me = this;        	
        me.selectMonth = me._getSelectDate(value);
        me.setValue(me.selectMonth);
        me.fireEvent('select', me, me.selectMonth);
    },
    onOKClick: function(picker, value) {
        var me = this;    
	    if( me.selectMonth == null ) {
	    	me.onSelect(picker, value);
	    }
	   
        me.collapse();
    },
    onCancelClick: function() {
        var me = this;    
    	me.selectMonth = null;
        me.collapse();
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
 