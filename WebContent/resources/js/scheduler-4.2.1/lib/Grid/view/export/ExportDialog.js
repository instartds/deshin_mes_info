import Popup from '../../../Core/widget/Popup.js';
import LocaleManager from '../../../Core/localization/LocaleManager.js';
import './field/ExportRowsCombo.js';
import './field/ExportOrientationCombo.js';
import './field/LocalizableCombo.js';
import { FileFormat, PaperFormat } from '../../feature/export/Utils.js';
import Checkbox from '../../../Core/widget/Checkbox.js';
import Field from '../../../Core/widget/Field.js';
import ObjectHelper from '../../../Core/helper/ObjectHelper.js';

/**
 * @module Grid/view/export/ExportDialog
 */

/**
 * Dialog window which allows to pick export options.
 *
 * ```
 * grid = new Grid({
 *     features : {
 *         pdfExport : { exportServer : '...' }
 *     }
 * });
 *
 * grid.features.pdfExport.showExportDialog();
 * ```
 *
 * @extends Core/widget/Popup
 */
export default class ExportDialog extends Popup {

    //region Config

    static get $name() {
        return 'ExportDialog';
    }

    static get type() {
        return 'exportdialog';
    }

    static get defaultConfig() {
        return {
            autoShow  : false,
            autoClose : false,
            closable  : true,
            centered  : true,

            /**
             * Grid instance to build export dialog for
             * @config {Grid.view.Grid}
             */
            client : null,

            /**
             * Set to `false` to allow using PNG + Multipage config in export dialog
             * @config {Boolean}
             */
            hidePNGMultipageOption : true,

            exporterType : 'singlepage',

            orientation : 'portrait',

            paperFormat : 'A4',

            fileFormat : 'pdf',

            alignRows : false,

            rowsRange : 'all',

            title : 'L{exportSettings}',

            defaults : {
                localeClass : this
            },

            bbar : {
                defaults : {
                    type        : 'button',
                    localeClass : this
                },
                items : {
                    exportButton : {
                        color   : 'b-green',
                        text    : 'L{ExportDialog.export}',
                        weight  : 100,
                        onClick : 'up.onExportClick'
                    },
                    cancelButton : {
                        color   : 'b-gray',
                        text    : 'L{ExportDialog.cancel}',
                        weight  : 200,
                        onClick : 'up.onCancelClick'
                    }
                }
            }
        };
    }

    //endregion

    construct(config = {}) {
        const
            me         = this,
            { client } = config;

        if (!client) {
            throw new Error('`client` config is required');
        }

        const items = me.buildDialogItems(config);

        if (config.items) {
            if (Array.isArray(config.items)) {
                config.items.push(...items);
            }
            else {
                items.forEach(item => {
                    config.items[item.ref] = item;
                    delete item.ref;
                });
            }
        }
        else {
            config.items = items;
        }

        config.width = config.width || me.L('L{width}');

        super.construct(config);

        LocaleManager.on({
            locale  : 'onLocaleChange',
            prio    : -1,
            thisObj : me
        });
    }

    get fieldProperties() {
        return [
            'exporterType',
            'orientation',
            'fileFormat',
            'paperFormat',
            'alignRows',
            'rowsRange',
            'repeatHeader'
        ];
    }

    getDefaultFieldValues(config) {
        const result = ObjectHelper.copyProperties({}, config, this.fieldProperties);

        return ObjectHelper.copyPropertiesIf(result, this.getDefaultConfiguration(), this.fieldProperties);
    }

    buildDialogItems(config) {
        const
            me         = this,
            {
                exporters,
                client
            }          = config,
            {
                exporterType,
                orientation,
                paperFormat,
                fileFormat,
                alignRows,
                rowsRange,
                repeatHeader
            }          = me.getDefaultFieldValues(config),
            labelWidth = me.L('L{ExportDialog.labelWidth}');

        me.columnsStore = client.columns.chain(record => record.isLeaf && record.exportable);

        function buildComboItems(obj, fn = x => x) {
            return Object.keys(obj).map(key => ({ id : key, text : fn(key) }));
        }

        return [
            {
                labelWidth,
                type         : 'combo',
                ref          : 'columnsField',
                label        : 'L{ExportDialog.columns}',
                store        : me.columnsStore,
                // Value is filled on paint
                value        : null,
                valueField   : 'id',
                displayField : 'text',
                multiSelect  : true
            },
            {
                labelWidth,
                type  : 'exportrowscombo',
                ref   : 'rowsRangeField',
                label : 'L{ExportDialog.rows}',
                value : rowsRange
            },
            {
                labelWidth,
                type                : 'localizablecombo',
                ref                 : 'exporterTypeField',
                label               : 'L{ExportDialog.exporterType}',
                editable            : false,
                value               : exporterType,
                buildLocalizedItems : () => exporters.map(exporter => ({
                    id   : exporter.type,
                    text : me.optionalL(exporter.title, this)
                })),
                onChange({ value }) {
                    this.owner.widgetMap.alignRowsField.hidden = value === 'singlepage';
                    this.owner.widgetMap.repeatHeaderField.hidden = value !== 'multipagevertical';
                }
            },
            {
                labelWidth,
                type    : 'checkbox',
                ref     : 'alignRowsField',
                label   : 'L{ExportDialog.alignRows}',
                checked : alignRows,
                hidden  : exporterType === 'singlepage'
            },
            {
                labelWidth,
                type        : 'checkbox',
                ref         : 'repeatHeaderField',
                label       : 'L{ExportDialog.repeatHeader}',
                localeClass : this,
                value       : repeatHeader,
                hidden      : exporterType !== 'multipagevertical'
            },
            {
                labelWidth,
                type        : 'combo',
                ref         : 'fileFormatField',
                label       : 'L{ExportDialog.fileFormat}',
                localeClass : this,
                editable    : false,
                value       : fileFormat,
                items       : buildComboItems(FileFormat, value => value.toUpperCase()),
                onChange({ value, oldValue }) {
                    if (me.hidePNGMultipageOption) {
                        const
                            exporterField = me.widgetMap.exporterTypeField,
                            exporter      = exporterField.store.find(r => r.id === 'singlepage');

                        if (value === FileFormat.png && exporter) {
                            this._previousDisabled = exporterField.disabled;
                            exporterField.disabled = true;

                            this._previousValue = exporterField.value;
                            exporterField.value = 'singlepage';
                        }
                        else if (oldValue === FileFormat.png && this._previousValue) {
                            exporterField.disabled = this._previousDisabled;
                            exporterField.value = this._previousValue;
                        }
                    }
                }
            },
            {
                labelWidth,
                type     : 'combo',
                ref      : 'paperFormatField',
                label    : 'L{ExportDialog.paperFormat}',
                editable : false,
                value    : paperFormat,
                items    : buildComboItems(PaperFormat)
            },
            {
                labelWidth,
                type  : 'exportorientationcombo',
                ref   : 'orientationField',
                label : 'L{ExportDialog.orientation}',
                value : orientation
            }
        ];
    }

    onShow() {
        super.onShow?.(...arguments);

        this.widgetMap.columnsField.value = this.columnsStore.query(c => !c.hidden);
    }

    onLocaleChange() {
        const
            labelWidth = this.L('L{labelWidth}');

        this.width = this.L('L{width}');

        this.eachWidget(widget => {
            if (widget instanceof Field) {
                widget.labelWidth = labelWidth;
            }
        });
    }

    onExportClick() {
        const values = this.values;

        /**
         * Fires when export button is clicked
         * @event export
         * @param {Object} values Object containing config for {@link Grid.feature.export.PdfExport#function-export export()} method
         * @group Export
         */
        this.trigger('export', { values });
    }

    onCancelClick() {
        /**
         * Fires when cancel button is clicked. Popup will hide itself.
         * @event cancel
         * @group Export
         */
        this.trigger('cancel');
        this.hide();
    }

    get values() {
        const
            fieldRe = /field/i,
            result  = {};

        this.eachWidget(widget => {
            if (fieldRe.test(widget.ref)) {
                result[widget.ref.replace(fieldRe, '')] = widget instanceof Checkbox ? widget.checked : widget.value;
            }
        });

        return result;
    }
}
