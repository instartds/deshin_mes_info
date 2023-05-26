import NumberColumn from './NumberColumn.js';
import ColumnStore from '../data/ColumnStore.js';
import ArrayHelper from '../../Core/helper/ArrayHelper.js';

/**
 * @module Grid/column/RatingColumn
 */

/**
 * A column that displays a star rating. Click a start to set a value, shift+click to unset a single start from the end.
 * Clicking the first and only star toggles it.
 *
 * This column uses a custom widget as its editor, and it is not intended to be changed.
 *
 * @extends Grid/column/NumberColumn
 *
 * @example
 * new Grid({
 *     appendTo : document.body,
 *
 *     columns : [
 *         { type: 'rating', max : 10, field: 'rating' }
 *     ]
 * });
 *
 * @classType percent
 * @inlineexample Grid/column/RatingColumn.js
 */
export default class RatingColumn extends NumberColumn {
    static get type() {
        return 'rating';
    }

    // Type to use when auto adding field
    static get fieldType() {
        return 'number';
    }

    static get fields() {
        return ['emptyIcon', 'filledIcon', 'editable'];
    }

    static get defaults() {
        return {
            min : 0,
            max : 5,

            /**
             * The empty rating icon to show
             * @config {String}
             * @category Rendering
             */
            emptyIcon : 'b-icon b-icon-star',

            /**
             * The filled rating icon to show
             * @config {String}
             * @category Rendering
             */
            filledIcon : 'b-icon b-icon-star',

            /**
             * Allow user to click an icon to change the value
             * @config {Boolean}
             * @category Interaction
             */
            editable : true,

            filterType : 'number',
            searchable : false,
            width      : '11.2em',
            htmlEncode : false,
            minWidth   : '11.2em',
            editor     : false,
            fitMode    : 'value'
        };
    }

    constructor(config, store) {
        super(...arguments);

        this.internalCellCls = 'b-rating-cell';
    }

    /**
     * Renderer that displays a number of stars in the cell. Also adds CSS class 'b-rating-cell' to the cell.
     * @private
     */
    renderer({ value }) {
        return {
            className : {
                'b-rating-cell-inner' : 1,
                'b-not-editable'      : !this.editable
            },
            children : ArrayHelper.populate(this.max, i => {
                const filled = i < value;
                return {
                    tag       : 'i',
                    className : {
                        'b-rating-icon'                             : true,
                        'b-filled'                                  : filled,
                        'b-empty'                                   : !filled,
                        [filled ? this.filledIcon : this.emptyIcon] : true
                    }
                };
            })
        };
    }

    onCellClick({ grid, column, record, target, event }) {
        if (target.classList.contains('b-rating-icon') && !grid.readOnly && column.editable) {
            let starIndex = [].indexOf.call(target.parentNode.childNodes, target);

            if (target.classList.contains('b-filled') && (event.metaKey || event.shiftKey)) {
                starIndex = starIndex - 1;
            }

            // Clicking first star when it is only one removes it
            if (record.get(column.field) === 1 && starIndex === 0) {
                starIndex = -1;
            }

            record.set(column.field, starIndex + 1);
        }
    }
}

ColumnStore.registerColumnType(RatingColumn, true);
RatingColumn.exposeProperties();
