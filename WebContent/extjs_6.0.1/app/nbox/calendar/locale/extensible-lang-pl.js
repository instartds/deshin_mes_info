/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Polish locale
 * By ma_gro
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Dzisiaj',
            defaultEventTitleText: '(Brak tytułu)',
            ddCreateEventText: 'Utwórz wydarzenie dla {0}',
            ddMoveEventText: 'Przenieś wydarzenie do {0}',
            ddResizeEventText: 'Aktualizuj wydarzenie do {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} więcej...',
            getMoreText: function(numEvents){
                return '+{0} więcej...';
            },
            detailsTitleDateFormat: 'F j'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Dzisiaj',
            dayText: 'Dzień',
            weekText: 'Tydzień',
            monthText: 'Miesiąc',
            jumpToText: 'Przejdź do:',
            goText: 'Przejdź',
            multiDayText: '{0} Dni',
            multiWeekText: '{0} Tygodnie',
            getMultiDayText: function(numDays){
                return '{0} Dni';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} Tygodnie';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Tworzenie wydarzenia',
            titleTextEdit: 'Edycja wydarzenia',
            savingMessage: 'Zapisywanie zmian...',
            deletingMessage: 'Usuwanie wydarzenia...',
            detailsLinkText: 'Edycja szczegółów...',
            saveButtonText: 'Zapisz',
            deleteButtonText: 'Usuń',
            cancelButtonText: 'Anuluj',
            titleLabelText: 'Tytuł',
            datesLabelText: 'Kiedy',
            calendarLabelText: 'Kalendarz'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Formularz wydarzenia',
            titleTextAdd: 'Tworzenie wydarzenia',
            titleTextEdit: 'Edycja wydarzenia',
            saveButtonText: 'Zapisz',
            deleteButtonText: 'Usuń',
            cancelButtonText: 'Anuluj',
            titleLabelText: 'Tytuł',
            datesLabelText: 'Kiedy',
            reminderLabelText: 'Przypomnij',
            notesLabelText: 'Notatki',
            locationLabelText: 'Lokalizacja',
            webLinkLabelText: 'Adres web',
            calendarLabelText: 'Kalendarz',
            repeatsLabelText: 'Powtarzaj'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'do',
            allDayText: 'Cały dzień'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Kalendarz'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Kalendarze'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Wyświetlaj tylko ten kalendarz'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Powtarzaj',
            recurrenceText: {
                none: 'Nie powtarzaj',
                daily: 'Codziennie',
                weekly: 'Cotygodniowo',
                monthly: 'Raz na miesiąc',
                yearly: 'Raz na rok'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Reminder',
            noneText: 'Brak',
            atStartTimeText: 'W momencie startu',
            getMinutesText: function(numMinutes){
                return 'minut';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'godzina' : 'godziny';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dzień' : 'dni';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'tydzień' : 'tygodni';
            },
            reminderValueFormat: '{0} {1} przed startem' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'n/j/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Edycja szczegółów',
            deleteText: 'Usuń',
            moveToText: 'Przenieś do...'
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