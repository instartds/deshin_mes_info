/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * Portugues (BR) locale
 * By Wemerson Januario <wemerson.januario@gmail.com> Goiânia GO, Brazil
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = false;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 0,
            todayText: 'Hoje',
            defaultEventTitleText: '(Sem Titulo)',
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
            monthText: 'Mês',
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
            savingMessage: 'Salvando...',
            deletingMessage: 'Excluindo Evento...',
            detailsLinkText: 'Alterar Detalhes...',
            saveButtonText: 'Salvar',
            deleteButtonText: 'Excluir',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'Título',
            datesLabelText: 'Quando',
            calendarLabelText: 'Calendário'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 65,
            labelWidthRightCol: 65,
            title: 'Formulário de Evento',
            titleTextAdd: 'Adicionar Evento',
            titleTextEdit: 'Alterar Evento',
            saveButtonText: 'Salvar',
            deleteButtonText: 'Excluir',
            cancelButtonText: 'Cancelar',
            titleLabelText: 'Título',
            datesLabelText: 'Quando',
            reminderLabelText: 'Lembrete',
            notesLabelText: 'Observação',
            locationLabelText: 'Local',
            webLinkLabelText: 'Site',
            calendarLabelText: 'Calendário',
            repeatsLabelText: 'Repetiçoes'
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
            fieldLabel: 'Calendário'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Calendários'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'Mostrar apenas esse Calendário'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Repetiçoes',
            recurrenceText: {
                none: 'Não repetir',
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
            atStartTimeText: 'No horário exato',
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
                return numWeeks === 1 ? 'semana' : 'semanadas';
            },
            reminderValueFormat: '{0} {1} antes do programado' // e.g. "2 hours before start"
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
            deleteText: 'Excluir',
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
            singleDayDateFormat: 'l, F j, Y',
            multiDayFirstDayFormat: 'j M , Y',
            multiDayMonthStartFormat: 'j M'
        });
    }
    
    if (exists('nbox.calendar.template.Month')) {
        Ext.apply(nbox.calendar.template.Month.prototype, {
            dayHeaderFormat: 'D',
            dayHeaderTitleFormat: 'l, F j, Y'
        });
    }
    
    // This is an override of Ext's default dayNames. Ext uses HTML char equivalents
    // like &aacute; but in abbreviations it's wrong. E.g., Sábado is
    // abbreviated as S&a. This seems to be a bug in Ext's abbreviation logic
    // so for our purposes just include the actual chars here.
    Date.dayNames = [
       "Domingo",
       "Segunda",
       "Terça",
       "Quarta",
       "Quinta",
       "Sexta",
       "Sábado"
    ];
});