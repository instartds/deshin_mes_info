/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * German (DE) locale
 * Contributors: 
 * - Tobias Uhlig, http://extthemes.com/
 * - Gunnar Beushausen
 * - Joern Heid
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Heute',
            defaultEventTitleText: '(kein titel)',
            ddCreateEventText: 'Termin erstellen f\u00FCr {0}',
            ddMoveEventText: 'Termin verschieben nach {0}',
            ddResizeEventText: 'Termin updaten nach {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} weitere...',
            getMoreText: function(numEvents){
                return '+{0} weitere...';
            },
            detailsTitleDateFormat: 'F j'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Heute',
            dayText: 'Tag',
            weekText: 'Woche',
            monthText: 'Monat',
            jumpToText: 'Springe zu:',
            goText: 'Los',
            multiDayText: '{0} Tage',
            multiWeekText: '{0} Wochen',
            getMultiDayText: function(numDays){
                return '{0} Tage';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} Wochen';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 640,
            labelWidth: 65,
            titleTextAdd: 'Termin erstellen',
            titleTextEdit: 'Termin editieren',
            savingMessage: 'Speichere Daten...',
            deletingMessage: 'L\u00F6sche Termin...',
            detailsLinkText: 'Einzelheiten bearbeiten...',
            saveButtonText: 'Speichern',
            deleteButtonText: 'L\u00F6schen',
            cancelButtonText: 'Abbrechen',
            titleLabelText: 'Titel',
            datesLabelText: 'Wann',
            calendarLabelText: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Termin Formular',
            titleTextAdd: 'Termin hinzuf\u00FCgen',
            titleTextEdit: 'Termin editieren',
            saveButtonText: 'Speichern',
            deleteButtonText: 'L\u00F6schen',
            cancelButtonText: 'Abbrechen',
            titleLabelText: 'Titel',
            datesLabelText: 'Wann',
            reminderLabelText: 'Erinnerung',
            notesLabelText: 'Notizen',
            locationLabelText: 'Ort',
            webLinkLabelText: 'Web Link',
            calendarLabelText: 'Kalender',
            repeatsLabelText: 'Wiederholungen'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'bis',
            allDayText: 'ganzer Tag'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Nur diesen Kalender anzeigen'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Wiederholungen',
            recurrenceText: {
                none: 'keine Wiederholungen',
                daily: 't\u00E4glich',
                weekly: 'w\u00F6chentlich',
                monthly: 'monatlich',
                yearly: 'j\u00E4hrlich'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Erinnerung',
            noneText: 'keine',
            atStartTimeText: 'zur Startzeit',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'Minute' : 'Minuten';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'Stunde' : 'Stunden';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'Tag' : 'Tage';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'Woche' : 'Wochen';
            },
            reminderValueFormat: '{0} {1} vor Terminbeginn' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'j.n.Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Einzelheiten bearbeiten',
            deleteText: 'L\u00F6schen',
            moveToText: 'Verschieben nach...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'j.n'
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'j.n'
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