/**
 * Custom drag class
 *
 * Taken from the vanilla example
 */
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { DragHelper, WidgetHelper } from '@bryntum/scheduler';
import { DragHelper, WidgetHelper } from '@bryntum/scheduler/scheduler.umd';

export default class Drag extends DragHelper {
    static get defaultConfig() {
        return {
            // Don't drag the actual cell element, clone it
            cloneTarget        : true,
            mode               : 'translateXY',
            // Only allow drops on scheduled tasks
            dropTargetSelector : '.b-sch-event',

            // Only allow dragging cell elements inside on the equipment grid
            targetSelector : '.b-grid-cell'
        };
    }

    construct(config) {
        const me = this;

        super.construct(config);

        me.on({
            dragstart : me.onEquipmentDragStart,
            drop      : me.onEquipmentDrop,
            thisObj   : me
        });
    }

    onEquipmentDragStart({ event, context }) {
        // save a reference to the equipment so we can access it later
        context.equipment = this.grid.getRecordFromElement(context.grabbed);

        // Prevent tooltips from showing while dragging
        this.schedule.element.classList.add('b-dragging-event');
    }

    onEquipmentDrop({ context, event }) {
        const me = this;

        if (context.valid) {
            const
                equipment = context.equipment,
                eventRecord = me.schedule.resolveEventRecord(context.target);

            eventRecord.equipment = eventRecord.equipment.concat(equipment);

            me.context.finalize();

            // Dropped on a scheduled event, display toast
            WidgetHelper.toast(`Added ${equipment.name} to ${eventRecord.name}`);
        }

        me.schedule.element.classList.remove('b-dragging-event');
    }
};
