/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/*
 * French (France) locale
 * Contributors: devil1591, Alain Deseine, Yannick Torres
 */

Ext.onReady(function() {
    var exists = Ext.Function.bind(Ext.ClassManager.get, Ext.ClassManager);
    
    Extensible.Date.use24HourTime = true;
    
    if (exists('nbox.calendar.view.AbstractCalendar')) {
        Ext.apply(nbox.calendar.view.AbstractCalendar.prototype, {
            startDay: 1,
            todayText: 'Aujourd\'hui',
            defaultEventTitleText: '(Pas de titre)',
            ddCreateEventText: 'Créer évènement le {0}',
            ddMoveEventText: 'Déplacer évènement le {0}',
            ddResizeEventText: 'Mettre à jour l\'événement au {0}'
        });
    }
    
    if (exists('nbox.calendar.view.Month')) {
        Ext.apply(nbox.calendar.view.Month.prototype, {
            moreText: '+{0} autres ...',
            getMoreText: function(numEvents){
                return numEvents > 1 ? '+{0} autres ...' : '+{0} autre ...';
            },
            detailsTitleDateFormat: 'd F'
        });
    }
    
    if (exists('nbox.calendar.CalendarPanel')) {
        Ext.apply(nbox.calendar.CalendarPanel.prototype, {
            todayText: 'Aujourd\'hui',
            dayText: 'Jour',
            weekText: 'Semaine',
            monthText: 'Mois',
            jumpToText: 'Aller au :',
            goText: 'Ok',
            multiDayText: '{0} jours',
            multiWeekText: '{0} semaines',
            getMultiDayText: function(numDays){
                return '{0} jours';
            },
            getMultiWeekText: function(numWeeks){
                return '{0} semaines';
            }
        });
    }
    
    if (exists('nbox.calendar.form.EventWindow')) {
        Ext.apply(nbox.calendar.form.EventWindow.prototype, {
            width: 650,
            labelWidth: 65,
            titleTextAdd: 'Ajouter évènement',
            titleTextEdit: 'Editer évènement',
            savingMessage: 'Sauvegarde des changements...',
            deletingMessage: 'Suppression de l\'évènement...',
            detailsLinkText: 'Détail de l\'événement...',
            saveButtonText: 'Enregistrer',
            deleteButtonText: 'Supprimer',
            cancelButtonText: 'Annuler',
            titleLabelText: 'Titre',
            datesLabelText: 'Quand',
            calendarLabelText: 'Agenda'
        });
    }
    
    if (exists('nbox.calendar.form.EventDetails')) {
        Ext.apply(nbox.calendar.form.EventDetails.prototype, {
            labelWidth: 55,
            labelWidthRightCol: 80,
            title: 'Formulaire évènement',
            titleTextAdd: 'Ajouter évènement',
            titleTextEdit: 'Editer évènement',
            saveButtonText: 'Enregistrer',
            deleteButtonText: 'Supprimer',
            cancelButtonText: 'Annuler',
            titleLabelText: 'Titre',
            datesLabelText: 'Quand',
            reminderLabelText: 'Rappel',
            notesLabelText: 'Notes',
            locationLabelText: 'Lieu',
            webLinkLabelText: 'Lien internet',
            calendarLabelText: 'Agenda',
            repeatsLabelText: 'Répéter'
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            toText: 'au',
            allDayText: 'Toute la journée'
        });
    }
    
    if (exists('nbox.calendar.form.field.CalendarCombo')) {
        Ext.apply(nbox.calendar.form.field.CalendarCombo.prototype, {
            fieldLabel: 'Agenda'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListPanel')) {
        Ext.apply(nbox.calendar.gadget.CalendarListPanel.prototype, {
            title: 'Agendas'
        });
    }
    
    if (exists('nbox.calendar.gadget.CalendarListMenu')) {
        Ext.apply(nbox.calendar.gadget.CalendarListMenu.prototype, {
            displayOnlyThisCalendarText: 'N\'afficher que cet agenda'
        });
    }
    
    if (exists('nbox.form.recurrence.Combo')) {
        Ext.apply(nbox.form.recurrence.Combo.prototype, {
            fieldLabel: 'Réccurence',
            recurrenceText: {
                none: 'Ne pas répéter',
                daily: 'Quotidien',
                weekly: 'Hebdomadaire',
                monthly: 'Mensuel',
                yearly: 'Annuel'
            }
        });
    }
    
    if (exists('nbox.calendar.form.field.ReminderCombo')) {
        Ext.apply(nbox.calendar.form.field.ReminderCombo.prototype, {
            fieldLabel: 'Rappel',
            noneText: 'Aucun',
            atStartTimeText: 'au début',
            getMinutesText: function(numMinutes){
                return numMinutes === 1 ? 'minute' : 'minutes';
            },
            getHoursText: function(numHours){
                return numHours === 1 ? 'heure' : 'heures';
            },
            getDaysText: function(numDays){
                return numDays === 1 ? 'jour' : 'jours';
            },
            getWeeksText: function(numWeeks){
                return numWeeks === 1 ? 'semaine' : 'semaines';
            },
            reminderValueFormat: '{0} {1} avant le début' // e.g. "2 hours before start"
        });
    }
    
    if (exists('nbox.form.field.DateRange')) {
        Ext.apply(nbox.form.field.DateRange.prototype, {
            dateFormat: 'd/m/Y'
        });
    }
    
    if (exists('nbox.calendar.menu.Event')) {
        Ext.apply(nbox.calendar.menu.Event.prototype, {
            editDetailsText: 'Éditer les détails',
            deleteText: 'Effacer',
            moveToText: 'Déplacer au...'
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