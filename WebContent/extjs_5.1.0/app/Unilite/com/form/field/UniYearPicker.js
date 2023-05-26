//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniYearPicker', {
    extend: 'Ext.view.BoundList',
    alias: 'widget.uniYearPicker',
    requires: ['Ext.data.Store', 'Ext.Date'],

   	minValue: '1980',
   	maxValue: '2020',

    /**
     * @private
     * The field in the implicitly-generated Model objects that gets displayed in the list. This is
     * an internal field name only and is not useful to change via config.
     */
    displayField: 'disp',

    componentCls: Ext.baseCSSPrefix + 'timepicker',

    /**
     * @cfg
     * @private
     */
    loadMask: false,

    initComponent: function() {
        var me = this;


        me.store = me.createStore();

        // Add our min/max range filter, but do not apply it.
        // The owning TimeField will filter it.
        me.store.addFilter(me.rangeFilter = new Ext.util.Filter({
            id: 'time-picker-filter'
        }), false);

        // Updates the range filter's filterFn according to our configured min and max
        me.updateList();

        me.callParent();
    },

    /**
     * Set the {@link #minValue} and update the list of available times. This must be a Date object (only the time
     * fields will be used); no parsing of String values will be done.
     * @param {Date} value
     */
    setMinValue: function(value) {
        this.minValue = value;
        this.updateList();
    },

    /**
     * Set the {@link #maxValue} and update the list of available times. This must be a Date object (only the time
     * fields will be used); no parsing of String values will be done.
     * @param {Date} value
     */
    setMaxValue: function(value) {
        this.maxValue = value;
        this.updateList();
    },



    /**
     * Update the list of available times in the list to be constrained within the {@link #minValue}
     * and {@link #maxValue}.
     */
    updateList: function() {
        var me = this,
            min =me.minValue ,
            max =me.maxValue ;

        me.rangeFilter.setFilterFn(function(record) {
            var date = record.get('date');
            return date >= min && date <= max;
        });
        me.store.filter();
    },

    /**
     * @private
     * Creates the internal {@link Ext.data.Store} that contains the available times. The store
     * is loaded with all possible times, and it is later filtered to hide those times outside
     * the minValue/maxValue.
     */
    createStore: function() {
        var me = this,
            years = [],
            min =  me.minValue,
            max = me.maxValue;

        while(min <= max){
            years.push({
                disp: min,
                date: min
            });
            min = min + 1;
        }
        return new Ext.data.Store({
            fields: ['disp', 'date'],
            data: years
        });
    },

    focusNode: function (rec) {
        // We don't want the view being focused when interacting with the inputEl (see Ext.form.field.ComboBox:onKeyUp)
        // so this is here to prevent focus of the boundlist view. See EXTJSIV-7319.
        return false;
    }

});
