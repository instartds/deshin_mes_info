/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.data.CalendarModel
 * @extends Ext.data.Record
 * <p>This is the {@link Ext.data.Record Record} specification for calendar items used by the
 * {@link nbox.calendar.CalendarPanel CalendarPanel}'s calendar store. If your model fields 
 * are named differently you should update the <b>mapping</b> configs accordingly.</p>
 * <p>The only required fields when creating a new calendar record instance are CalendarId and
 * Title.  All other fields are either optional or will be defaulted if blank.</p>
 * <p>Here is a basic example for how to create a new record of this type:<pre><code>
rec = new nbox.calendar.data.CalendarModel({
    CalendarId: 5,
    Title: 'My Holidays',
    Description: 'My personal holiday schedule',
    ColorId: 3
});
</code></pre>
 * If you have overridden any of the record's data mappings via the {@link nbox.calendar.data.CalendarMappings CalendarMappings} object
 * you may need to set the values using this alternate syntax to ensure that the fields match up correctly:<pre><code>
var M = nbox.calendar.data.CalendarMappings;

rec = new nbox.calendar.data.CalendarModel();
rec.data[M.CalendarId.name] = 5;
rec.data[M.Title.name] = 'My Holidays';
rec.data[M.Description.name] = 'My personal holiday schedule';
rec.data[M.ColorId.name] = 3;
</code></pre>
 * @constructor
 * @param {Object} data (Optional) An object, the properties of which provide values for the new Record's
 * fields. If not specified the {@link Ext.data.Field#defaultValue defaultValue}
 * for each field will be assigned.
 * @param {Object} id (Optional) The id of the Record. The id is used by the
 * {@link Ext.data.Store} object which owns the Record to index its collection
 * of Records (therefore this id should be unique within each store). If an
 * id is not specified a {@link #phantom}
 * Record will be created with an {@link #Record.id automatically generated id}.
 */
Ext.define('nbox.calendar.data.CalendarModel', {
    extend: 'Ext.data.Model',
    
    requires: [
        'Ext.util.MixedCollection',
        'nbox.calendar.data.CalendarMappings'
    ],
    
    statics: {
        /**
         * Reconfigures the default record definition based on the current {@link nbox.calendar.data.CalendarMappings CalendarMappings}
         * object. See the header documentation for {@link nbox.calendar.data.CalendarMappings} for complete details and 
         * examples of reconfiguring a CalendarRecord.
         * @method create
         * @static
         * @return {Function} The updated CalendarRecord constructor function
         */
        reconfigure: function(){
            var Data = nbox.calendar.data,
                Mappings = Data.CalendarMappings,
                proto = Data.CalendarModel.prototype,
                fields = [];
            
            // It is critical that the id property mapping is updated in case it changed, since it
            // is used elsewhere in the data package to match records on CRUD actions:
            proto.idProperty = Mappings.CalendarId.name || 'id';
            
            for(prop in Mappings){
                if(Mappings.hasOwnProperty(prop)){
                    fields.push(Mappings[prop]);
                }
            }
            proto.fields.clear();
            for(var i = 0, len = fields.length; i < len; i++){
                proto.fields.add(Ext.create('Ext.data.Field', fields[i]));
            }
            return Data.CalendarModel;
        }
    }
},
function() {
    nbox.calendar.data.CalendarModel.reconfigure();
});