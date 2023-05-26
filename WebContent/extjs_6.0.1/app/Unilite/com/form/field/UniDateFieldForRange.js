//@charset UTF-8
/**
* Rerence : http://workblog.neteos.eu/180/javascript/extjs/extjs-datefield-select-date-range
*/

/*****************************************************
 * 
 * 
 */
Ext.define('Unilite.com.form.field.UniDateFieldForRange', {
    extend: 'Ext.form.field.Date',
    alias: 'widget.uniDatefieldForRange',
    requires: [
    	//'Unilite.com.form.field.UniClearButton'
    ],
    format: Unilite.dateFormat,
    enforceMaxLength: true,
    maxLength: 10,
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	/**
	 * 
	 * @cfg {String} submitFormat
	 * 'Ymd',   20131231
	 */
    submitFormat : Unilite.dbDateFormat, 
    altFormats: Unilite.altFormats,
	vtype: 'uniDateRange',
	showToday: false,
    labelStyle: 'text-align:center; margin-right:0',
    labelSeparator: '',
    padding: 0, margin: 0,
    labelWidth: 0,
	uniOpt: {},
	uniChanged : false,
	/**
	 * 
	 */
	initComponent: function () {
		var me = this;
		
		me.format = Unilite.dateFormat;
		me.submitFormat = Unilite.dbDateFormat;
		me.altFormats = Unilite.altFormats;
		
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
//	 		if(!Ext.isDefined(this.plugins)) {
//				this.plugins = new Array();		
//			}
//			this.plugins.push('uniClearbutton');
	 	};

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
		//	me.up('uniDateRangefield')._updateMinMax();
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
            picker.setMinDate(minValue);
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
            picker.setMaxDate(maxValue);
        }
    }
}); 