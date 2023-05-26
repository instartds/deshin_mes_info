/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Default English (US) locale
 * By nbox, LLC
 */
/*
 * A general note regarding pluralization... Some locales require conditional logic
 * to properly pluralize certain terms. When this might be required there is an additional
 * "get*" method in addition to the standard config. By default these simply return the
 * same value as the corresponding config, but if your locale requires such logic simply
 * implement the appropriate method bodies. The configs in these cases are still listed for
 * backwards compatibility, but they are deprecated and will be removed in a future release.
 * The Czech locale (nbox-lang-cs.js) is an example that uses these method overrides.
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = false;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Today',
            defaultEventTitleText: '(No title)',
            ddCreateEventText: 'Create event for {0}',
            ddMoveEventText: 'Move event to {0}',
            ddResizeEventText: 'Update event to {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} more...', // deprecated
            getMoreText: function(numEvents){
                return '+{0} more...';
            },
            detailsTitleDateFormat: 'F j'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Today',
            dayText: 'Day',
            weekText: 'Week',
            monthText: 'Month',
            jumpToText: 'Jump to:',
            goText: 'Go',
            multiDayText: '{0} Days', // deprecated
            multiWeekText: '{0} Weeks', // deprecated
            getMultiDayText: function(numDays){
                return '{0} Days';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} Weeks';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Add Event',
            titleTextEdit: 'Edit Event',
            savingMessage: 'Saving changes...',
            deletingMessage: 'Deleting event...',
            detailsLinkText: 'Edit Details...',
            saveButtonText: 'Save',
            deleteButtonText: 'Delete',
            cancelButtonText: 'Cancel',
            titleLabelText: 'Title',
            datesLabelText: 'When',
            calendarLabelText: 'Calendar'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Event Form',
            titleTextAdd: 'Add Event',
            titleTextEdit: 'Edit Event',
            saveButtonText: 'Save',
            deleteButtonText: 'Delete',
            cancelButtonText: 'Cancel',
            titleLabelText: 'Title',
            datesLabelText: 'When',
            reminderLabelText: 'Reminder',
            notesLabelText: 'Notes',
            locationLabelText: 'Location',
            webLinkLabelText: 'Web Link',
            calendarLabelText: 'Calendar',
            repeatsLabelText: 'Repeats'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'to',
            allDayText: 'All day'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Calendar'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calendars'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Display only this calendar'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Repeats',
            recurrenceText: {
                none: 'Does not repeat',
                daily: 'Daily',
                weekly: 'Weekly',
                monthly: 'Monthly',
                yearly: 'Yearly'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Reminder',
            noneText: 'None',
            atStartTimeText: 'At start time',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minute' : 'minutes';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'hour' : 'hours';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'day' : 'days';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'week' : 'weeks';
            },
            reminderValueFormat: '{0} {1} before start' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'n/j/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Edit Details',
            deleteText: 'Delete',
            moveToText: 'Move to...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'n/j'
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'n/j'
        });
    }
    
    if (exists('nbox.calendar.template.BoxLayout')) {
        Ext.apply(nbox.calendar.template.BoxLayout.prototype, {
            firstWeekDateFormat: 'D j',
            otherWeeksDateFormat: 'j',
            singleDayDateFormat: 'l, F j, Y',
            multiDayFirstDayFormat: 'M j, Y',
            multiDayMonthStartFormat: 'M j'
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l, F j, Y'
        });
    }
});