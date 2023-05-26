/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
* Portuguese/Portugal (pt_PT) locale
* Original credits to Wemerson Januario <wemerson.januario@gmail.com> Goiânia GO, Brazil
* Update to PT by Rui Monteiro <rmonteiro@opensoft.pt> Amoreiras, Portugal
*/

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = false;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Hoje',
            defaultEventTitleText: '(Sem T&iacute;tulo)',
            ddCreateEventText: 'Criar Evento para {0}',
            ddMoveEventText: 'Mover Evento para {0}',
            ddResizeEventText: 'Alterar Evento para {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} mais...',
            getMoreText: function(numEvents){
                return '+{0} mais...';
            },
            detailsTitleDateFormat: 'F j'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Hoje',
            dayText: 'Dia',
            weekText: 'Semana',
            monthText: 'M&ecirc;s',
            jumpToText: 'Ir para:',
            goText: 'Prosseguir',
            multiDayText: '{0} Dias',
            multiWeekText: '{0} Semanas',
            getMultiDayText: function(numDays){
                return '{0} Dias';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} Semanas';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 600,
            labelWidth: 65,
            titleTextAdd: 'Adicionar Evento',
            titleTextEdit: 'Alterar Evento',
            savingMessage: 'A Guardar...',
            deletingMessage: 'A Remover Evento...',
            detailsLinkText: 'Alterar Detalhes...',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Remover',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'T&iacute;tulo',
            datesLabelText: 'Quando',
            calendarLabelText: 'Calend&aacute;rio'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Formul&aacute;rio de Evento',
            titleTextAdd: 'Adicionar Evento',
            titleTextEdit: 'Alterar Evento',
            saveButtonText: 'Guardar',
            deleteButtonText: 'Remover',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'T&iacute;tulo',
            datesLabelText: 'Quando',
            reminderLabelText: 'Lembrete',
            notesLabelText: 'Observa&ccedil;&atilde;o',
            locationLabelText: 'Local',
            webLinkLabelText: 'Site',
            calendarLabelText: 'Calend&aacute;rio',
            repeatsLabelText: 'Repeti&ccedil;oes'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'para',
            allDayText: 'Dia todo'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Calend&aacute;rio'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calend&aacute;rios'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Mostrar apenas esse Calend&aacute;rio'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Repeti&ccedil;oes',
            recurrenceText: {
                none: 'N&atilde;o repetir',
                daily: 'Diariamente',
                weekly: 'Semanalmente',
                monthly: 'Mensalmente',
                yearly: 'Anualmente'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Lembrete',
            noneText: 'Nenhum',
            atStartTimeText: 'Há hora de início',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minuto' : 'minutos';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'hora' : 'horas';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'dia' : 'dias';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'semana' : 'semanas';
            },
            reminderValueFormat: '{0} {1} antes do programado'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'j/n/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Alterar detalhes',
            deleteText: 'Remover',
            moveToText: 'Mover para...'
        });
    }
    
    if (exists('nbox.calendar.dd.DropZone')) {
        Ext.apply(nbox.calendar.dd.DropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat: 'j/n'
        });
    }
    
    if (exists('nbox.calendar.dd.DayDropZone')) {
        Ext.apply(nbox.calendar.dd.DayDropZone.prototype, {
            dateRangeFormat: '{0}-{1}',
            dateFormat : 'j/n'
        });
    }
    
    if (exists('nbox.calendar.template.BoxLayout')) {
        Ext.apply(nbox.calendar.template.BoxLayout.prototype, {
            firstWeekDateFormat: 'D j',
            otherWeeksDateFormat: 'j',
            singleDayDateFormat: 'l, j F , Y',
            multiDayFirstDayFormat: 'j M , Y',
            multiDayMonthStartFormat: 'j M'
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l, j F , Y'
        });
    }
});