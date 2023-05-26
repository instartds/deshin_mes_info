//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniYearField', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.uniYearField',
    requires: [ 'Unilite.com.form.field.UniYearPicker', 'Ext.view.BoundListKeyNav'],

    /**
     * @cfg {String} [triggerCls='x-form-time-trigger']
     * An additional CSS class used to style the trigger button. The trigger will always get the {@link #triggerBaseCls}
     * by default and triggerCls will be **appended** if specified.
     */
    triggerCls: Ext.baseCSSPrefix + 'form-time-trigger',



    //<locale>
    /**
     * @cfg {String} minText
     * The error text to display when the entered time is before {@link #minValue}.
     */
    minText : UniUtils.getMessage('system.message.commonJS.yearfield.minnText','연도는 {0}보다 같더나 커야 합니다.'),//"The year in this field must be equal to or after {0}",
    //</locale>

    //<locale>
    /**
     * @cfg {String} maxText
     * The error text to display when the entered time is after {@link #maxValue}.
     */
    maxText : UniUtils.getMessage('system.message.commonJS.yearfield.maxText','연도는 {0}보다 같거나 작아야 합니다.'),//"The year in this field must be equal to or before {0}",
    //</locale>

    //<locale>
    /**
     * @cfg {String} invalidText
     * The error text to display when the time in the field is invalid.
     */
    invalidText : UniUtils.getMessage('system.message.commonJS.yearfield.InvalidText','{0} 는 유효한 연도가 아닙니다.'),//"{0} is not a valid year",
    //</locale>
   	minValue: '2000',
   	maxValue: '2100',
   	forceSelection : true,
	

    /**
     * @cfg {Number} pickerMaxHeight
     * The maximum height of the {@link Ext.picker.Time} dropdown.
     */
    pickerMaxHeight: 300,

    /**
     * @cfg {Boolean} selectOnTab
     * Whether the Tab key should select the currently highlighted item.
     */
    selectOnTab: true,



    
    ignoreSelection: 0,

    queryMode: 'local',

    displayField: 'disp',

    valueField: 'date',
    
	fieldStyle: "text-align:center;",
	
    initComponent: function() {
        var me = this,
            min = me.minValue,
            max = me.maxValue;
        if (min) {
            me.setMinValue(min);
        }
        if (max) {
            me.setMaxValue(max);
        }
        
        me.displayTpl = new Ext.XTemplate(
            '<tpl for=".">' +
                '{[typeof values === "string" ? values : values["' + me.displayField + '"]]}' +
                '<tpl if="xindex < xcount">' + me.delimiter + '</tpl>' +
            '</tpl>');
    	
        this.callParent();
    },

    /**
     * @private
     */
    transformOriginalValue: function(value) {
        if (Ext.isString(value)) {
            return this.rawToValue(value);
        }
        return value;
    },

    /**
     * @private
     */
    isEqual: function(v1, v2) {
        return (v1 == v2)?true:false;
    },

    /**
     * Replaces any existing {@link #minValue} with the new time and refreshes the picker's range.
     * @param {Date/String} value The minimum time that can be selected
     */
    setMinValue: function(value) {
        var me = this,
            picker = me.picker;
        me.setLimit(value, true);
        if (picker) {
            picker.setMinValue(me.minValue);
        }
    },

    /**
     * Replaces any existing {@link #maxValue} with the new time and refreshes the picker's range.
     * @param {Date/String} value The maximum time that can be selected
     */
    setMaxValue: function(value) {
        var me = this,
            picker = me.picker;
        me.setLimit(value, false);
        if (picker) {
            picker.setMaxValue(me.maxValue);
        }
    },


    setLimit: function(value, isMin) {
        var me = this,
            d, val;
        if (Ext.isString(value)) {
            d = me.parseYear(value);
        }
        if (d) {
            
            val = d;
        }
        // Invalid min/maxValue config should result in a null so that defaulting takes over
        else {
            val = null;
        }
        me[isMin ? 'minValue' : 'maxValue'] = val;
    },

    rawToValue: function(rawValue) {
    	var t = this.parseYear(rawValue) || rawValue || null;
        return t;
    },

    valueToRaw: function(value) {
        return this.parseYear(value);
    },

    /**
     * Runs all of Time's validations and returns an array of any errors. Note that this first runs Text's validations,
     * so the returned array is an amalgamation of all field errors. The additional validation checks are testing that
     * the time format is valid, that the chosen time is within the {@link #minValue} and {@link #maxValue} constraints
     * set.
     * @param {Object} [value] The value to get errors for (defaults to the current field value)
     * @return {String[]} All validation errors for this field
     */
    getErrors: function(value) {
        var me = this,
            format = Ext.String.format,
            errors = me.callParent(arguments),
            minValue = me.minValue,
            maxValue = me.maxValue,
            date;

        value = value || me.processRawValue(me.getRawValue());

        if (value === null || value.length < 1) { // if it's blank and textfield didn't flag it then it's valid
             return errors;
        }

        date = me.parseYear(value);
        if (!date) {
            errors.push(format(me.invalidText, value, "연도"));
            return errors;
        }

        if (minValue && date < minValue) {
            errors.push(format(me.minText, me.formatDate(minValue)));
        }

        if (maxValue && date > maxValue) {
            errors.push(format(me.maxText, me.formatDate(maxValue)));
        }

        return errors;
    },

    formatDate: function(value) {
        return Number(value);
    },

    /**
     * @private
     * Parses an input value into a valid Date object.
     * @param {String/Date} value
     */
    parseYear: function(value) {
       
		var val = Number(value);
        return val;
    },



    // @private
    getSubmitValue: function() {
        var me = this,
            value = me.getValue();
		var rv = value ? String(value) : null;
        return rv;
    },

    /**
     * @private
     * Creates the {@link Ext.picker.Time}
     */
    createPicker: function() {
        var me = this,
            picker;

        me.listConfig = Ext.apply({
            xtype: 'uniYearPicker',
            selModel: {
                mode: 'SINGLE'
            },
            cls: undefined,
            minValue: me.minValue,
            maxValue: me.maxValue,
            format: me.format,
            maxHeight: me.pickerMaxHeight
        }, me.listConfig);
        picker = me.callParent();
        me.bindStore(picker.store);
        return picker;
    },
    
    onItemClick: function(picker, record){
        // The selection change events won't fire when clicking on the selected element. Detect it here.
        var me = this,
            selected = picker.getSelectionModel().getSelection();

        if (selected.length > 0) {
            selected = selected[0];
            if (selected && (record.get('date')== selected.get('date'))) {
                me.collapse();
            }
        }
    },

    /**
     * @private
     * Handles a time being selected from the Time picker.
     */
    onListSelectionChange: function(list, recordArray) {
        if (recordArray.length) {
            var me = this,
                val = recordArray[0].get('date');

            if (!me.ignoreSelection) {
                me.skipSync = true;
                me.setValue(val);
                me.skipSync = false;
                me.fireEvent('select', me, val);
                me.picker.clearHighlight();
                me.collapse();
                me.inputEl.focus();
            }
        }
    },

    /**
     * @private 
     * Synchronizes the selection in the picker to match the current value
     */
    syncSelection: function() {
        var me = this,
            picker = me.picker,
            toSelect,
            selModel,
            value,
            data, d, dLen, rec;
            
        if (picker && !me.skipSync) {
            picker.clearHighlight();
            value = me.getValue();
            selModel = picker.getSelectionModel();
            // Update the selection to match
            me.ignoreSelection++;
            if (value === null) {
                selModel.deselectAll();
            } else if (Ext.isNumber(value)) {
                // find value, select it
                data = picker.store.data.items;
                dLen = data.length;

                for (d = 0; d < dLen; d++) {
                    rec = data[d];

                    if (rec.get('date') == value) {
                       toSelect = rec;
                       break;
                   }
                }

                selModel.select(toSelect);
            }
            me.ignoreSelection--;
        }
    },

    postBlur: function() {
        var me = this,
            val = me.getValue();

        me.callParent(arguments);

        // Only set the raw value if the current value is valid and is not falsy
        if (me.wasValid && val) {
            me.setRawValue(me.formatDate(val));
        }
    },

    setValue: function() {

        // Store MUST be created for parent setValue to function
        this.getPicker();

        return this.callParent(arguments);
    },

    getValue: function() {
        return this.parseYear(this.callParent(arguments));
    }
});
