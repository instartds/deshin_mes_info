
/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
 
/**
 * @class nbox.calendar.data.EventMappings
 * @extends Object
 * <p>A simple object that provides the field definitions for 
 * {@link nbox.calendar.EventRecord EventRecord}s so that they can be easily overridden.</p>
 * 
 * <p>There are several ways of overriding the default Event record mappings to customize how 
 * Ext records are mapped to your back-end data model. If you only need to change a handful 
 * of field properties you can directly modify the EventMappings object as needed and then 
 * reconfigure it. The simplest approach is to only override specific field attributes:</p>
 * <pre><code>
var M = nbox.calendar.data.EventMappings;
M.Title.mapping = 'evt_title';
M.Title.name = 'EventTitle';
nbox.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p>You can alternately override an entire field definition using object-literal syntax, or 
 * provide your own custom field definitions (as in the following example). Note that if you do 
 * this, you <b>MUST</b> include a complete field definition, including the <tt>type</tt> attribute
 * if the field is not the default type of <tt>string</tt>.</p>
 * <pre><code>
// Add a new field that does not exist in the default EventMappings:
nbox.calendar.data.EventMappings.Timestamp = {
    name: 'Timestamp',
    mapping: 'timestamp',
    type: 'date'
};
nbox.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p>If you are overriding a significant number of field definitions it may be more convenient 
 * to simply redefine the entire EventMappings object from scratch. The following example
 * redefines the same fields that exist in the standard EventRecord object but the names and 
 * mappings have all been customized. Note that the name of each field definition object 
 * (e.g., 'EventId') should <b>NOT</b> be changed for the default EventMappings fields as it 
 * is the key used to access the field data programmatically.</p>
 * <pre><code>
nbox.calendar.data.EventMappings = {
    EventId:     {name: 'ID', mapping:'evt_id', type:'int'},
    CalendarId:  {name: 'CalID', mapping: 'cal_id', type: 'int'},
    Title:       {name: 'EvtTitle', mapping: 'evt_title'},
    StartDate:   {name: 'StartDt', mapping: 'start_dt', type: 'date', dateFormat: 'c'},
    EndDate:     {name: 'EndDt', mapping: 'end_dt', type: 'date', dateFormat: 'c'},
    RRule:       {name: 'RecurRule', mapping: 'recur_rule'},
    Location:    {name: 'Location', mapping: 'location'},
    Notes:       {name: 'Desc', mapping: 'full_desc'},
    Url:         {name: 'LinkUrl', mapping: 'link_url'},
    IsAllDay:    {name: 'AllDay', mapping: 'all_day', type: 'boolean'},
    Reminder:    {name: 'Reminder', mapping: 'reminder'},
    
    // We can also add some new fields that do not exist in the standard EventRecord:
    CreatedBy:   {name: 'CreatedBy', mapping: 'created_by'},
    IsPrivate:   {name: 'Private', mapping:'private', type:'boolean'}
};
// Don't forget to reconfigure!
nbox.calendar.EventRecord.reconfigure();
</code></pre>
 * 
 * <p><b>NOTE:</b> Any record reconfiguration you want to perform must be done <b>PRIOR to</b> 
 * initializing your data store, otherwise the changes will not be reflected in the store's records.</p>
 * 
 * <p>Another important note is that if you alter the default mapping for <tt>EventId</tt>, make sure to add
 * that mapping as the <tt>idProperty</tt> of your data reader, otherwise it won't recognize how to
 * access the data correctly and will treat existing records as phantoms. Here's an easy way to make sure
 * your mapping is always valid:</p>
 * <pre><code>
var reader = new Ext.data.JsonReader({
    totalProperty: 'total',
    successProperty: 'success',
    root: 'data',
    messageProperty: 'message',
    
    // read the id property generically, regardless of the mapping:
    idProperty: nbox.calendar.data.EventMappings.EventId.mapping  || 'id',
    
    // this is also a handy way to configure your reader's fields generically:
    fields: nbox.calendar.EventRecord.prototype.fields.getRange()
});
</code></pre>
 */
Ext.ns('nbox.calendar.data');
// @define nbox.calendar.data.EventMappings
nbox.calendar.data.EventMappings = {	
    EventId: {
        name:    'id',
        mapping: 'id',
        type:    'String'
    },
    CalendarId: {
        name:    'calendarId',
        mapping: 'calendarId',
        type:    'String'
    },
    Title: {
        name:    'title',
        mapping: 'title',
        type:    'string'
    },
    StartDate: {
        name:       'startDate',
        mapping:    'startDate',
        type:       'date',
        dateFormat: 'Y-m-d H:i:s' // c
    },
    EndDate: {
        name:       'endDate',
        mapping:    'endDate',
        type:       'date',
        dateFormat: 'Y-m-d H:i:s' // c'c'
    },
    RRule: { // not currently used
        name:    'recurRule', 
        mapping: 'recurRule', 
        type:    'string' 
    },
    Location: { // not currently used
        name:    'location',
        mapping: 'location',
        type:    'string'
    },
    Notes: {
        name:    'notes',
        mapping: 'notes',
        type:    'string'
    },
    Url: { // not currently used
        name:    'url',
        mapping: 'url',
        type:    'string'
    },
    IsAllDay: {
        name:    'allDay',
        mapping: 'allDay',
        type:    'boolean'
    },
    Reminder: { // not currently used
        name:    'reminder',
        mapping: 'reminder',
        type:    'string'
    },
    OpenFlag: {
        name:    'openFlag',
        mapping: 'openFlag',
        type:    'boolean'
    },
    RecurFlag: {
        name:    'recurFlag',
        mapping: 'recurFlag',
        type:    'boolean'
    },
    RecurType: {
        name:    'recurType',
        mapping: 'recurType',
        type:    'string'
    },
    RecurCount: {
        name:    'recurCount',
        mapping: 'recurCount',
        type:    'int'
    },
    FixType: {
        name:    'fixType',
        mapping: 'fixType',
        type:    'boolean'
    },
    MonthPosition: {
        name:    'monthPosition',
        mapping: 'monthPosition',
        type:    'string'
    },
    WeekPosition: {
        name:    'weekPosition',
        mapping: 'weekPosition',
        type:    'string'
    },
    DayPosition: {
        name:    'dayPosition',
        mapping: 'dayPosition',
        type:    'string'
    },
    EndingType: {
        name:    'endingType',
        mapping: 'endingType',
        type:    'string'
    },
    EndingCount: {
        name:    'endingCount',
        mapping: 'endingCount',
        type:    'int'
    },
    EndingDate: {
        name:    'endingDate',
        mapping: 'endingDate',
        type:       'date',
        dateFormat: 'Y-m-d' // c'c'
    },
    ScheduleID: {
        name:    'scheduleId',
        mapping: 'scheduleId',
        type:    'string'
    },
    UserID: {
        name:    'userId',
        mapping: 'userId',
        type:    'string'
    },
    RecurSaveType: {
        name:    'recurSaveType',
        mapping: 'recurSaveType',
        type:    'string'
    },
    EventInformation: {
        name:    'eventInformation',
        mapping: 'eventInformation',
        type:    'string'
    }
};