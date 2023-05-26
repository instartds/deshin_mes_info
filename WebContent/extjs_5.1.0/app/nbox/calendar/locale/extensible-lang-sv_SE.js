/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Swedish locale
 * By Mats Bryntse, http://ext-scheduler.com
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Idag',
            defaultEventTitleText: '(Ingen titel)',
            ddCreateEventText: 'Skapa ny aktivitet den {0}',
            ddMoveEventText: 'Flytta aktivitet till {0}',
            ddResizeEventText: 'Uppdatera aktivitet till {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} ytterligare...',
            getMoreText: function(numEvents){
                return '+{0} ytterligare...';
            },
            detailsTitleDateFormat: 'd F'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Idag',
            dayText: 'Dag',
            weekText: 'Vecka',
            monthText: 'Månad',
            jumpToText: 'Gå till:',
            goText: 'Gå',
            multiDayText: '{0} dagar',
            multiWeekText: '{0} veckor',
            getMultiDayText: function(numDays){
                return '{0} dagar';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} veckor';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Lägg till aktivitet',
            titleTextEdit: 'Ändra aktivitet',
            savingMessage: 'Sparar ändringar...',
            deletingMessage: 'Tar bort aktivitet...',
            detailsLinkText: 'Ändra detaljer...',
            saveButtonText: 'Spara',
            deleteButtonText: 'Ta bort',
            cancelButtonText: 'Avbryt',
            titleLabelText: 'Titel',
            datesLabelText: 'När',
            calendarLabelText: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 75,
            title: 'aktivitetformulär',
            titleTextAdd: 'Lägg till aktivitet',
            titleTextEdit: 'Ändra aktivitet',
            saveButtonText: 'Spara',
            deleteButtonText: 'Ta bort',
            cancelButtonText: 'Avbryt',
            titleLabelText: 'Titel',
            datesLabelText: 'När',
            reminderLabelText: 'Påminnelse',
            notesLabelText: 'Anteckningar',
            locationLabelText: 'Placering',
            webLinkLabelText: 'Webblänk',
            calendarLabelText: 'Kalender',
            repeatsLabelText: 'Upprepa'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'till',
            allDayText: 'Hela dagen'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Kalender'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Kalendrar'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Visa endat denna kalender'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Upprepa',
            recurrenceText: {
                none: 'Aldrig',
                daily: 'Daglig',
                weekly: 'Vecklig',
                monthly: 'Månatlig',
                yearly: 'Årlig'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Påminnelse',
            noneText: 'Ingen',
            atStartTimeText: 'Vid start',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minut' : 'minuter';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'timme' : 'timmar';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dag' : 'daggar';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'veka' : 'veckor';
            },
            reminderValueFormat: '{0} {1} före start' // f.eks. "2 timmar före start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Ändra detaljer',
            deleteText: 'Ta bort',
            moveToText: 'Flytta till...'
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