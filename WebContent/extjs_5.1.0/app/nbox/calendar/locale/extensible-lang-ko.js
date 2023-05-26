//@charset utf-8
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
            todayText: '오늘',
            defaultEventTitleText: '(No title)',
            ddCreateEventText: '계획 생성 {0}',
            ddMoveEventText: '계획 이동  {0}',
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
            todayText: '오늘',
            dayText: '일',
            weekText: '주',
            monthText: '월',
            jumpToText: '이동:',
            goText: 'Go',
            multiDayText: '{0} 일', // deprecated
            multiWeekText: '{0} 주', // deprecated
            getMultiDayText: function(numDays){
                return '{0} 일';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} 주';
            }
        });
        console.log("apply")
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: '영업활동 등록',
            titleTextEdit: '영업활동 수정',
            savingMessage: '저장중...',
            deletingMessage: '삭제중...',
            detailsLinkText: 'Edit Details...',
            saveButtonText: '저장',
            deleteButtonText: '삭제',
            cancelButtonText: '취소',
            titleLabelText: '제목',
            datesLabelText: '일자',
            calendarLabelText: '구분'
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
            titleLabelText: '제목',
            datesLabelText: '일자',
            reminderLabelText: 'Reminder',
            notesLabelText: 'Notes',
            locationLabelText: 'Location',
            webLinkLabelText: 'Web Link',
            calendarLabelText: '구분',
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
            deleteText: '삭제',
            moveToText: '이동...'
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
            dayHeaderTitleFormat: 'Y F j일 (l)'
        });
    }
});