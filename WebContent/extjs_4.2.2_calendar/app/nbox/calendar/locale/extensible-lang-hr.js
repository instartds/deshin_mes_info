/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Default Croatian (hr_HR) locale
 * By Grgur Grisogono
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = false;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Today',
            defaultEventTitleText: '(Bez naziva)',
            ddCreateEventText: 'Novi dogadaj za {0}',
            ddMoveEventText: 'Premjesti dogadaj za {0}',
            ddResizeEventText: 'Promijeni vrijeme dogadaja na {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} više...',
            getMoreText: function(numEvents){
                return '+{0} više...';
            },
            detailsTitleDateFormat: 'F d'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Danas',
            dayText: 'Dan',
            weekText: 'Tjedan',
            monthText: 'Mjesec',
            jumpToText: 'Pokaži datum:',
            goText: 'Pokaži',
            multiDayText: '{0} dana',
            multiWeekText: '{0} tjedana',
            getMultiDayText: function(numDays){
                return '{0} dana';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} tjedana';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 660,
            labelWidth: 60,
            titleTextAdd: 'Novi unos',
            titleTextEdit: 'Izmjeni unos',
            savingMessage: 'Spremam promjene...',
            deletingMessage: 'Brišem unos...',
            detailsLinkText: 'Izmjena detalja unosa...',
            saveButtonText: 'Spremi',
            deleteButtonText: 'Briši',
            cancelButtonText: 'Odustani',
            titleLabelText: 'Naziv',
            datesLabelText: 'Vrijeme',
            calendarLabelText: 'Kalendar'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 90,
            title: 'Obrada unosa',
            titleTextAdd: 'Novi unos',
            titleTextEdit: 'Izmjena unosa',
            saveButtonText: 'Spremi',
            deleteButtonText: 'Briši',
            cancelButtonText: 'Odustani',
            titleLabelText: 'Naziv',
            datesLabelText: 'Vrijeme',
            reminderLabelText: 'Podsjetnik',
            notesLabelText: 'Bilješke',
            locationLabelText: 'Lokacija',
            webLinkLabelText: 'Internet adresa',
            calendarLabelText: 'Kalendar',
            repeatsLabelText: 'Ponavljanje'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'do',
            allDayText: 'Cjelodnevni događaj'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Kalendar'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Kalendari'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Prikaži samo ovaj kalendar'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Ponavljanje',
            recurrenceText: {
                none: 'Ne ponavlja se',
                daily: 'Dnevno',
                weekly: 'Tjedno',
                monthly: 'Mjesečno',
                yearly: 'Godišnje'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Podsjetnik',
            noneText: 'Nema',
            atStartTimeText: 'Na početku',
            getMinutesText: function(numMinutes){
                return 'minuta';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'sat' : 'sati';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dan' : 'dana';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'tjedan' : 'tjedana';
            },
            reminderValueFormat: '{0} {1} prije početka' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd.m.Y.'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Izmjena unosa',
            deleteText: 'Briši',
            moveToText: 'Premjesti...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'd.m.'
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'd.m.'
        });
    }
    
    if (exists('nbox.calendar.template.BoxLayout')) {
        Ext.apply(nbox.calendar.template.BoxLayout.prototype, {
            firstWeekDateFormat: 'D m',
            otherWeeksDateFormat: 'm',
            singleDayDateFormat: 'l, m. F, Y',
            multiDayFirstDayFormat: 'd. M, Y',
            multiDayMonthStartFormat: 'd. M'
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l, m. F, Y'
        });
    }
});