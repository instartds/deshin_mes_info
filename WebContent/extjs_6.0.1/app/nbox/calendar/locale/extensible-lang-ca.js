/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Catalan/Spain locale
 * By Alberto López Doñaque, <lopezdonaque@gmail.com>
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Avui',
            defaultEventTitleText: '(Sense t&iacute;tol)',
            ddCreateEventText: 'Crear event desde {0}',
            ddMoveEventText: 'Moure event a {0}',
            ddResizeEventText: 'Actualitzar event a {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} m&eacute;s...',
            getMoreText: function(numEvents){
                return '+{0} m&eacute;s...';
            },
            detailsTitleDateFormat: 'j \\de F'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Avui',
            dayText: 'Dia',
            weekText: 'Setmana',
            monthText: 'Mes',
            jumpToText: 'Anar a:',
            goText: 'Anar',
            multiDayText: '{0} dies',
            multiWeekText: '{0} setmanes',
            getMultiDayText: function(numDays){
                return '{0} dies';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} setmanes';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Afegir event',
            titleTextEdit: 'Editar event',
            savingMessage: 'Guardant canvis...',
            deletingMessage: 'Borrant event...',
            detailsLinkText: 'Editar detalls...',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Borrar',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'T&iacute;tol',
            datesLabelText: 'Quan',
            calendarLabelText: 'Calendari'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Formulari de vent',
            titleTextAdd: 'Afegir event',
            titleTextEdit: 'Editar event',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Borrar',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'T&iacute;tol',
            datesLabelText: 'Quan',
            reminderLabelText: 'Recordatori',
            notesLabelText: 'Notes',
            locationLabelText: 'Localitzaci&oacute;',
            webLinkLabelText: 'Enlla&ccedil; Web',
            calendarLabelText: 'Calendari',
            repeatsLabelText: 'Repetir'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'a',
            allDayText: 'Tot el dia'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Calendari'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calendaris'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Mostrar nom&eacute;s aquest calendari'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Repeats',
            recurrenceText: {
                none: 'No repetir',
                daily: 'Diari',
                weekly: 'Setmanal',
                monthly: 'Mensual',
                yearly: 'Anual'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Recordatori',
            noneText: 'Cap',
            atStartTimeText: 'Al començament',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minut' : 'minuts';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'hora' : 'hores';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dia' : 'dies';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'setmana' : 'setmanes';
            },
            reminderValueFormat: '{0} {1} abans de començar' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Editar detalls',
            deleteText: 'Borrar',
            moveToText: 'Moure a...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'd/m' // e.g. "25/12"
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'd/m' // e.g. "25/12"
        });
    }
    
    if (exists('nbox.calendar.template.BoxLayout')) {
        Ext.apply(nbox.calendar.template.BoxLayout.prototype, {
            firstWeekDateFormat: 'D d', // e.g. "Lun 01"
            otherWeeksDateFormat: 'd',
            singleDayDateFormat: 'l, d \\de F \\de Y', // e.g. "Lunes, 12 de Enero de 2011"
            multiDayFirstDayFormat: 'd M, Y', // e.g. "09 Ene, 2011"
            multiDayMonthStartFormat: 'd M' // e.g. "01 Ene"
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l, d \\de F \\de Y' // e.g. "Lunes, 12 de Enero de 2011"
        });
    }
});