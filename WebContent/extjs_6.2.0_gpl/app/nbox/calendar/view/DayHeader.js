/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.view.DayHeader
 * @extends nbox.calendar.view.Month
 * <p>This is the header area container within the day and week views where all-day events are displayed.
 * Normally you should not need to use this class directly -- instead you should use {@link nbox.calendar.view.Day DayView}
 * which aggregates this class and the {@link nbox.calendar.view.DayBody DayBodyView} into the single unified view
 * presented by {@link nbox.calendar.CalendarPanel CalendarPanel}.</p>
 * @constructor
 * @param {Object} config The config object
 */
Ext.define('nbox.calendar.view.DayHeader', {
    extend: 'nbox.calendar.view.Month',
    alias: 'widget.nbox.dayheaderview',
    
    requires: [
        'nbox.calendar.template.DayHeader'
    ],
    
    // private configs
    weekCount: 1,
    dayCount: 1,
    allDayOnly: true,
    monitorResize: false,
    isHeaderView: true,
    
    // The event is declared in MonthView but we're just overriding the docs:
    /**
     * @event dayclick
     * Fires after the user clicks within the view container and not on an event element. This is a cancelable event, so 
     * returning false from a handler will cancel the click without displaying the event editor view. This could be useful 
     * for validating that a user can only create events on certain days.
     * @param {nbox.calendar.view.DayHeader} this
     * @param {Date} dt The date/time that was clicked on
     * @param {Boolean} allday True if the day clicked on represents an all-day box, else false. Clicks within the 
     * DayHeaderView always return true for this param.
     * @param {Ext.Element} el The Element that was clicked on
     */
    
    // private
    afterRender : function(){
        if(!this.tpl){
            this.tpl = Ext.create('nbox.calendar.template.DayHeader', {
                id: this.id,
                showTodayText: this.showTodayText,
                todayText: this.todayText,
                showTime: this.showTime
            });
        }
        this.tpl.compile();
        this.addCls('ext-cal-day-header');
        
        this.callParent(arguments);
    },
    
    // private
    forceSize: Ext.emptyFn,
    
    // private
    refresh : function(reloadData){
        //nbox.log('refresh (DayHeaderView)');
        this.callParent(arguments);
        this.recalcHeaderBox();
    },
    
    // private
    recalcHeaderBox : function(){
        var tbl = this.el.down('.ext-cal-evt-tbl'),
            h = tbl.getHeight();
        
        this.el.setHeight(h+7);
        
        // These should be auto-height, but since that does not work reliably
        // across browser / doc type, we have to size them manually
        this.el.down('.ext-cal-hd-ad-inner').setHeight(h+5);
        this.el.down('.ext-cal-bg-tbl').setHeight(h+5);
    },
    
    // private
    moveNext : function(){
        return this.moveDays(this.dayCount);
    },

    // private
    movePrev : function(){
        return this.moveDays(-this.dayCount);
    },
    
    // private
    onClick : function(e, t){
        if(el = e.getTarget('td', 3)){
            if(el.id && el.id.indexOf(this.dayElIdDelimiter) > -1){
                var parts = el.id.split(this.dayElIdDelimiter),
                    dt = parts[parts.length-1];
                    
                this.onDayClick(Ext.Date.parseDate(dt, 'Ymd'), true, Ext.get(this.getDayId(dt, true)));
                return;
            }
        }
        this.callParent(arguments);
    }
});