/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Spanish/Spain locale
 * By Alberto López Doñaque, <lopezdonaque@gmail.com>
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Hoy',
            defaultEventTitleText: '(Sin título)',
            ddCreateEventText: 'Crear evento desde {0}',
            ddMoveEventText: 'Mover evento a {0}',
            ddResizeEventText: 'Actualizar evento a {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} m&aacute;s...',
            getMoreText: function(numEvents){
                return '+{0} m&aacute;s...';
            },
            detailsTitleDateFormat: 'j \\de F'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Hoy',
            dayText: 'Día',
            weekText: 'Semana',
            monthText: 'Mes',
            jumpToText: 'Ir a:',
            goText: 'Ir',
            multiDayText: '{0} días',
            multiWeekText: '{0} semanas',
            getMultiDayText: function(numDays){
                return '{0} días';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} semanas';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'A&ntilde;adir evento',
            titleTextEdit: 'Editar evento',
            savingMessage: 'Guardando cambios...',
            deletingMessage: 'Borrando evento...',
            detailsLinkText: 'Editar detalles...',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Borrar',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'Título',
            datesLabelText: 'Cuando',
            calendarLabelText: 'Calendario'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 75,
            labelWidthRightCol: 75,
            title: 'Formulario de evento',
            titleTextAdd: 'A&ntilde;adir evento',
            titleTextEdit: 'Editar evento',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Borrar',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'Título',
            datesLabelText: 'Cuando',
            reminderLabelText: 'Recordatorio',
            notesLabelText: 'Notas',
            locationLabelText: 'Localizaci&oacute;n',
            webLinkLabelText: 'Enlace Web',
            calendarLabelText: 'Calendario',
            repeatsLabelText: 'Repetir'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'a',
            allDayText: 'Todo el día'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Calendario'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calendarios'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Mostrar solo este calendario'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Repeats',
            recurrenceText: {
                none: 'No repetir',
                daily: 'Diario',
                weekly: 'Semanal',
                monthly: 'Mensual',
                yearly: 'Anual'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Recordatorio',
            noneText: 'Ninguno',
            atStartTimeText: 'Al inicio',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minuto' : 'minutos';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'hora' : 'horas';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'día' : 'días';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'semana' : 'semanas';
            },
            reminderValueFormat: '{0} {1} antes de empezar' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Editar detalles',
            deleteText: 'Borrar',
            moveToText: 'Mover a...'
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