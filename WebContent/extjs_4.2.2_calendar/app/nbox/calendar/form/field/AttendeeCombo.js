/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */

/*
 * Not currently in use, may or may not be implemented...
 */
nbox.calendar.form.field.AttendeeCombo = Ext.extend(Ext.ux.form.SuperBoxSelect, {
    fieldLabel: 'Attendees',
    name: 'attendees',
    anchor:'100%',
    mode: 'local',
    displayField: 'Name',
    valueField: 'AttendeeId',
    classField: 'cls',
    styleField: 'style',
    extraItemStyle: 'border-width:2px'
});

Ext.reg('nbox.attendeecombo', nbox.calendar.form.field.AttendeeCombo);
