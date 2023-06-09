import Toolbar from './Toolbar.js';

/**
 * @module Core/widget/PagingToolbar
 */

/**
 * A special Toolbar class, which, when attached to an {@link Core.data.AjaxStore AjaxStore}, which has been configured
 * to be {@link Core.data.AjaxStore#property-isPaged paged}, controls the loading of that store to page through the data
 * set.
 *
 * ```javascript
 * new Grid({
 *      bbar : {
 *          type  : 'pagingtoolbar'
 *      }
 * });
 * ```
 *
 * Adding additional buttons or widgets to the paging toolbar can be done like so:
 *
 * ```javascript
 * bbar : {
 *       type  : 'pagingtoolbar',
 *       items : {
 *           click : { text : 'Click me' }
 *       }
 *   }
 * ```
 *
 * @extends Core/widget/Toolbar
 * @classType toolbar
 */
export default class PagingToolbar extends Toolbar {
    static get $name() {
        return 'PagingToolbar';
    }

    // Factoryable type name
    static get type() {
        return 'pagingtoolbar';
    }

    static get defaultConfig() {
        return {
            /**
             * The {@link Core.data.AjaxStore AjaxStore} that this PagingToolbar is to control.
             * @config {Core.data.AjaxStore}
             */
            store : null,

            defaults : {
                localeClass : this
            },

            items : {

                firstPageButton : {
                    onClick : 'up.onFirstPageClick',
                    icon    : 'b-icon-first'
                },
                previousPageButton : {
                    onClick : 'up.onPreviousPageClick',
                    icon    : 'b-icon-previous'
                },
                pageNumber : {
                    type                    : 'numberfield',
                    label                   : 'L{page}',
                    min                     : 1,
                    max                     : 1,
                    triggers                : null,
                    onChange                : 'up.onPageNumberChange',
                    highlightExternalChange : false
                },
                pageCount : {
                    type : 'widget',
                    cls  : 'b-pagecount b-toolbar-text'
                },
                nextPageButton : {
                    onClick : 'up.onNextPageClick',
                    icon    : 'b-icon-next'
                },
                lastPageButton : {
                    onClick : 'up.onLastPageClick',
                    icon    : 'b-icon-last'
                },
                separator : {
                    type : 'widget',
                    cls  : 'b-toolbar-separator'
                },
                reloadButton : {
                    onClick : 'up.onReloadClick',
                    icon    : 'b-icon-reload'
                },
                spacer : {
                    type : 'widget',
                    cls  : 'b-toolbar-fill'
                },
                dataSummary : {
                    type : 'widget',
                    cls  : 'b-toolbar-text'
                }
            }
        };
    }

    // Retrieve store from grid when "assigned" to it
    set parent(parent) {
        super.parent = parent;

        if (!this.store) {
            this.store = parent.store;
        }
    }

    get parent() {
        return super.parent;
    }

    set store(store) {
        const
            me       = this,
            listener = {
                beforerequest : 'onStoreBeforeRequest',
                afterrequest  : 'onStoreChange',
                change        : 'onStoreChange',
                thisObj       : me
            };

        if (me.store) {
            me.store.un(listener);
        }

        me._store = store;
        if (store) {
            store.on(listener);
            if (store.isLoading) {
                me.onStoreBeforeRequest();
            }
        }
    }

    get store() {
        return this._store;
    }

    onStoreBeforeRequest() {
        this.eachWidget(w => w.disable());
    }

    updateLocalization() {
        const
            me                                                                                    = this,
            { reloadButton, firstPageButton, previousPageButton, nextPageButton, lastPageButton } = me.widgetMap;

        firstPageButton.tooltip = me.L('L{firstPage}');
        previousPageButton.tooltip = me.L('L{prevPage}');
        nextPageButton.tooltip = me.L('L{nextPage}');
        lastPageButton.tooltip = me.L('L{lastPage}');
        reloadButton.tooltip = me.L('L{reload}');

        me.updateSummary();

        super.updateLocalization();
    }

    updateSummary() {
        const
            me                         = this,
            { pageCount, dataSummary } = me.widgetMap;

        let count, lastPage, start, end, allCount;

        count = lastPage = start = end = allCount = 0;

        if (me.store) {
            const
                { store }                 = me,
                { pageSize, currentPage } = store;

            count = store.count;
            lastPage = store.lastPage;
            allCount = store.allCount;

            start = Math.max(0, (currentPage - 1) * pageSize + 1);
            end = Math.min(allCount, start + pageSize - 1);
        }

        pageCount.html = me.L('L{pageCountTemplate}')({ lastPage });
        dataSummary.html = count ? me.L('L{summaryTemplate}')({ start, end, allCount }) : me.L('L{noRecords}');
    }

    onStoreChange() {
        const
            me                                                                                                          = this,
            { widgetMap, store }                                                                                        = me,
            { count, lastPage, currentPage }                                                                            = store,
            { pageNumber, pageCount, firstPageButton, previousPageButton, nextPageButton, lastPageButton, dataSummary } = widgetMap;

        me.eachWidget(w => w.enable());

        pageNumber.value = currentPage;
        pageNumber.max = lastPage;

        dataSummary.disabled = pageNumber.disabled = pageCount.disabled = !count;
        firstPageButton.disabled = previousPageButton.disabled = currentPage <= 1 || !count;
        nextPageButton.disabled = lastPageButton.disabled = currentPage >= lastPage || !count;

        me.updateSummary();
    }

    onPageNumberChange({ value }) {
        if (this.store.currentPage !== value) {
            this.store.loadPage(value);
        }
    }

    onFirstPageClick() {
        this.store.loadPage(1);
    }

    onPreviousPageClick() {
        this.store.previousPage();
    }

    onNextPageClick() {
        this.store.nextPage();
    }

    onLastPageClick() {
        this.store.loadPage(this.store.lastPage);
    }

    onReloadClick() {
        this.store.loadPage(this.store.currentPage);
    }
}

// Register this widget type with its Factory
PagingToolbar.initClass();
