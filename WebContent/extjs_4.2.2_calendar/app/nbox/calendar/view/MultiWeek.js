/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.view.MultiWeek
 * @extends nbox.calendar.view.Month
 * <p>Displays a calendar view by week, more than one week at a time. This class does not usually need to be used directly as you can
 * use a {@link nbox.calendar.CalendarPanel CalendarPanel} to manage multiple calendar views at once.</p>
 * @constructor
 * @param {Object} config The config object
 */
Ext.define('nbox.calendar.view.MultiWeek', {
    extend: 'nbox.calendar.view.Month',
    alias: 'widget.nbox.multiweekview',
    
    /**
     * @cfg {Number} weekCount
     * The number of weeks to display in the view (defaults to 2)
     */
    weekCount: 2,
    
    // inherited docs
    moveNext : function(){
        return this.moveWeeks(this.weekCount, true);
    },
    
    // inherited docs
    movePrev : function(){
        return this.moveWeeks(-this.weekCount, true);
    }
});