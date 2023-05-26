/**
 * Equipment grid component
 *
 * Taken from the vanilla example
 */
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { Grid } from '@bryntum/scheduler';
import { Grid } from '@bryntum/scheduler/scheduler.umd';

export default class EquipmentGrid extends Grid {
    /**
     * Original class name getter. See Widget.$name docs for the details.
     * @return {string}
     */
    static get $name() {
        return 'EquipmentGrid';
    }

    static get defaultConfig() {
        return {
            features: {
                filterBar: true,
                cellEdit: false
            },

            rowHeight: 80,

            columns: [
                {
                    text: '',
                    field: 'name',
                    htmlEncode: false,
                    cellCls: 'b-equipment',
                    renderer: data =>
                        `<i class="${data.record.iconCls}"></i>${data.record.name}`
                }
            ]
        };
    }
}
