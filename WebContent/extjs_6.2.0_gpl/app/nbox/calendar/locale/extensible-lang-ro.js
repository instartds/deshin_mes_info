/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
﻿/*
 * Romanian (Romania) locale
 * By Laurentiu Macovei, DotNetWise, http://www.dotnetwise.com
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = false;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Astăzi',
            defaultEventTitleText: '(Fără titlu)',
            ddCreateEventText: 'Creează eveniment pentru {0}',
            ddMoveEventText: 'Muta eveniment în {0}',
            ddResizeEventText: 'Actualizează eveniment în {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+ încă {0}...',
            getMoreText: function(numEvents){
                return '+ încă {0}...';
            },
            detailsTitleDateFormat: 'F j'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Astăzi',
            dayText: 'Zi',
            weekText: 'Săptămână',
            monthText: 'Lună',
            jumpToText: 'Sari la:',
            goText: 'Vezi',
            multiDayText: '{0} Zile',
            multiWeekText: '{0} Săptămâni',
            getMultiDayText: function(numDays){
                return '{0} Zile';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} Săptămâni';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Adaugă Eveniment',
            titleTextEdit: 'Editează Eveniment',
            savingMessage: 'Salvez schimbările...',
            deletingMessage: 'Șterge eveninment...',
            detailsLinkText: 'Editează Detaliile...',
            saveButtonText: 'Salvează',
            deleteButtonText: 'Șterge',
            cancelButtonText: 'Renunță',
            titleLabelText: 'Titlu',
            datesLabelText: 'Când',
            calendarLabelText: 'Calendar'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 80,
            title: 'Formular Eveniment',
            titleTextAdd: 'Adaugă Eveniment',
            titleTextEdit: 'Editayă Eveniment',
            saveButtonText: 'Salvează',
            deleteButtonText: 'Șterge',
            cancelButtonText: 'Renunță',
            titleLabelText: 'Titlu',
            datesLabelText: 'Când',
            reminderLabelText: 'Anunță-mă',
            notesLabelText: 'Note',
            locationLabelText: 'Locația',
            webLinkLabelText: 'Adresă web',
            calendarLabelText: 'Calendar',
            repeatsLabelText: 'Se repetă'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'la',
            allDayText: 'Toată ziua'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Calendar'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calendare'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Afișează doar acest calendar'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Se repetă',
            recurrenceText: {
                none: 'Nu se repetă',
                daily: 'Zilnic',
                weekly: 'Săptpmânal',
                monthly: 'Lunar',
                yearly: 'Anual'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Anunță-mă',
            noneText: 'Niciodată',
            atStartTimeText: 'La începutul evenimentului',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minut' : 'minute';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'ora' : 'ore';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'zi' : 'zile';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'săptămână' : 'săptămâni';
            },
            reminderValueFormat: '{0} {1} înainte de început' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Editează Detalii',
            deleteText: 'Șterge',
            moveToText: 'Mută în...'
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