/* eslint-disable no-unused-vars,no-undef */
import '../_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';

const scheduler = new Scheduler({
    appendTo          : 'container',
    rowHeight         : 50,
    barMargin         : 5,
    eventColor        : 'cyan',
    resourceImagePath : '../_shared/images/users/',

    startDate  : new Date(2020, 7, 26, 6),
    endDate    : new Date(2020, 7, 26, 20),
    viewPreset : 'hourAndDay',

    columns : [
        { type : 'resourceInfo', text : 'Name', field : 'name', width : 130 }
    ],

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    listeners : {
        // Listener called before the built in event menu is shown
        eventMenuBeforeShow({ eventRecord, resourceRecord, event }) {

            // Hide all visible context menus
            $('.dropdown-menu:visible').hide();

            // Set data, set position, and show custom event menu
            $('#customEventMenu').data({
                eventId    : eventRecord.id,
                resourceId : resourceRecord.id
            }).css({
                top  : event.y,
                left : event.x
            }).show();

            // Prevent built in event menu
            return false;
        }
    }
});

// Hide all visible context menus by global click
$(document).on('click', () => {
    $('.dropdown-menu:visible').hide();
});

// Event menu handlers
$('#customEventMenu button').on('click', function() {
    const
        menuEl     = $(this).parent(),
        eventId    = menuEl.data('eventId'),
        resourceId = menuEl.data('resourceId'),
        ref        = $(this).data('ref');

    switch (ref) {
        // "Edit" menu item implementation
        case 'edit':
            scheduler.editEvent(scheduler.eventStore.getById(eventId), scheduler.resourceStore.getById(resourceId));
            break;

        // "Remove" menu item implementation
        case 'remove':
            scheduler.eventStore.remove(eventId);
            break;
    }
});
