//@charset UTF-8

/*****************************************************
 * 
 * 
 */
Ext.define('Unilite.com.form.field.UniMonthFieldForRange', {
    extend: 'Unilite.com.form.field.UniMonthField',
    alias: 'widget.uniMonthfieldForRange',    
	vtype: 'uniDateRange',
	uniChanged : false,

	initComponent: function () {
	 	this.callParent();
	},
	/**
	 * @private
	 * @return {}
	 */
	_getPicker : function () {
		return this.uniPicker;
	},
	setValue: function(value) {
		var me = this;
		var picker = me._getPicker();
		me.callParent(arguments);
        var nv = this.getValue();
		if(picker && Ext.isDate(nv)) {
//        if(picker ) {
			picker.setValue(me.getValue());			
		}
		var fieldcontainer = me.up('fieldcontainer');
		if(fieldcontainer){
			fieldcontainer.setDD(me);
		}
        return me;
	},
	/**
     * Replaces any existing disabled dates with new values and refreshes the Date picker.
     * @param {String[]} disabledDates An array of date strings (see the {@link #disabledDates} config for details on
     * supported values) used to disable a pattern of dates.
     */
    setDisabledDates : function(dd){
        var me = this,
            picker = me._getPicker();

        me.disabledDates = dd;
        me.initDisabledDays();
        if (picker) {
            picker.setDisabledDates(me.disabledDatesRE);
        }
    },
    /**
     * Replaces any existing disabled days (by index, 0-6) with new values and refreshes the Date picker.
     * @param {Number[]} disabledDays An array of disabled day indexes. See the {@link #disabledDays} config for details on
     * supported values.
     */
    setDisabledDays : function(dd){
        var picker =me._getPicker();

        this.disabledDays = dd;
        if (picker) {
            picker.setDisabledDays(dd);
        }
    },    
    /**
     * Replaces any existing {@link #minValue} with the new value and refreshes the Date picker.
     * @param {Date} value The minimum date that can be selected
     */
    setMinValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            minValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.minValue = minValue;
        if (picker) {
            picker.minText = Ext.String.format(me.minText, me.formatDate(me.minValue));
            //picker.setMinDate(minValue);
            picker.minDate = minValue;
        }
    },

    /**
     * Replaces any existing {@link #maxValue} with the new value and refreshes the Date picker.
     * @param {Date} value The maximum date that can be selected
     */
    setMaxValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            maxValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.maxValue = maxValue;
        if (picker) {
            picker.maxText = Ext.String.format(me.maxText, me.formatDate(me.maxValue));
            //picker.setMaxDate(maxValue);
            picker.maxDate = maxValue;     
        }
    }
}); 