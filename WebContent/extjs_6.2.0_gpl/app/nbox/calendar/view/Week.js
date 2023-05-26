/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.view.Week
 * @extends nbox.calendar.view.MultiDay
 * <p>Displays a calendar view by week. This class does not usually need to be used directly as you can
 * use a {@link nbox.calendar.CalendarPanel CalendarPanel} to manage multiple calendar views at once including
 * the week view.</p>
 * @constructor
 * @param {Object} config The config object
 */
Ext.define('nbox.calendar.view.Week', {
    extend: 'nbox.calendar.view.MultiDay',
    alias: 'widget.nbox.weekview',
    
    /**
     * @cfg {Number} dayCount
     * The number of days to display in the view (defaults to 7)
     */
    dayCount: 7
});