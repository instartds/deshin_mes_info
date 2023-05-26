/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Danish locale
 * By Niels Olsen
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Idag',
            defaultEventTitleText: '(Ingen titel)',
            ddCreateEventText: 'Opret begivenhed den {0}',
            ddMoveEventText: 'Flyt begivenhed til {0}',
            ddResizeEventText: 'Opdatér begivenhed til {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} flere...',
            getMoreText: function(numEvents){
                return '+{0} flere...';
            },
            detailsTitleDateFormat: 'd F'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Idag',
            dayText: 'Dag',
            weekText: 'Uge',
            monthText: 'Måned',
            jumpToText: 'Gå til:',
            goText: 'Gå',
            multiDayText: '{0} dage',
            multiWeekText: '{0} uger',
            getMultiDayText: function(numDays){
                return '{0} dage';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} uger';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Tilføj begivenhed',
            titleTextEdit: 'Ret begivenhed',
            savingMessage: 'Gemmer ændringer...',
            deletingMessage: 'Sletter begivenhed...',
            detailsLinkText: 'Ret detaljer...',
            saveButtonText: 'Gem',
            deleteButtonText: 'Slet',
            cancelButtonText: 'Annulér',
            titleLabelText: 'Titel',
            datesLabelText: 'Hvornår',
            calendarLabelText: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Begivenhed formular',
            titleTextAdd: 'Tilføj begivenhed',
            titleTextEdit: 'Ret begivenhed',
            saveButtonText: 'Gem',
            deleteButtonText: 'Slet',
            cancelButtonText: 'Annulér',
            titleLabelText: 'Title',
            datesLabelText: 'Hvornår',
            reminderLabelText: 'Påmindelse',
            notesLabelText: 'Noter',
            locationLabelText: 'Placering',
            webLinkLabelText: 'Web link',
            calendarLabelText: 'Kalender',
            repeatsLabelText: 'Gentagelser'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'til',
            allDayText: 'Hele dagen'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Kalendere'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Vis kun denne kalender'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Gentagelser',
            recurrenceText: {
                none: 'Gentages ikke',
                daily: 'Daglig',
                weekly: 'Ugentlig',
                monthly: 'Månedlig',
                yearly: 'Årlig'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Påmindelse',
            noneText: 'Ingen',
            atStartTimeText: 'Ved start tidspunkt',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minute' : 'minutter';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'time' : 'timer';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dag' : 'dage';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'uge' : 'uger';
            },
            reminderValueFormat: '{0} {1} før start' // f.eks. "2 timer før start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Ret detaljer',
            deleteText: 'Slet',
            moveToText: 'Flyt til...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'd/m'
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'd/m'
        });
    }
    
    if (exists('nbox.calendar.template.BoxLayout')) {
        Ext.apply(nbox.calendar.template.BoxLayout.prototype, {
            firstWeekDateFormat: 'D d',
            otherWeeksDateFormat: 'd',
            singleDayDateFormat: 'l d F Y',
            multiDayFirstDayFormat: 'd M Y',
            multiDayMonthStartFormat: 'd M'
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l d F Y'
        });
    }
});