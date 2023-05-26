import Base from '../../Base.js';
import ObjectHelper from '../../helper/ObjectHelper.js';
// TODO: turn into plugin instead?

/**
 * @module Core/data/mixin/StoreChained
 */
const returnTrue = () => true;

/**
 * A chained Store contains a subset of records from a master store. Which records to include is determined by a
 * filtering function, {@link #config-chainedFilterFn}.
 *
 * @example
 * masterStore.makeChained(record => record.percent < 10);
 *
 * // or
 *
 * new Store({
 *   masterStore     : masterStore,
 *   chainedFilterFn : record => record.percent < 10
 * });
 *
 * @mixin
 */
export default Target => class StoreChained extends (Target || Base) {
    static get $name() {
        return 'StoreChained';
    }

    //region Config

    static get defaultConfig() {
        return {
            /**
             * Function used to filter records in the masterStore into a chained store. If not provided,
             * all records from the masterStore will be included in the chained store.
             * @config {Function}
             * @category Chained store
             */
            chainedFilterFn : null,

            /**
             * Array of fields that should trigger filtering of chained store when the fields are updated.
             * @config {String[]}
             * @category Chained store
             */
            chainedFields : null,

            /**
             * Master store that a chained store gets its records from.
             * @config {Core.data.Store}
             * @category Chained store
             */
            masterStore : null,

            /**
             * Method names calls to which should be relayed to master store.
             * @config {String[]}
             * @category Chained store
             */
            doRelayToMaster : ['add', 'remove', 'insert'],

            /**
             * Method names calls to which shouldn't be relayed to master store.
             * @config {String}
             * @category Chained store
             */
            dontRelayToMaster : [],

            /**
             * Flag showing whether to keep added/removed uncommitted records when filling the store from master.
             * @config {Boolean}
             * @category Chained store
             */
            keepUncommittedChanges : false,

            /**
             * If true, collapsed records in original tree will be excluded from the chained store.
             * @config {Boolean}
             * @category Chained store
             * @internal
             */
            excludeCollapsedRecords : true
        };
    }

    // All props should be predefined to work properly with objectified stores
    static get properties() {
        return {
            chainedStores : null
        };
    }

    //endregion

    construct(config) {
        super.construct(config);

        const
            me              = this,
            { masterStore } = me;

        if (masterStore) {
            me.methodNamesToRelay.forEach(fnName => me[fnName] = (...params) => me.relayToMaster(fnName, params));

            me.removeAll = (...params) => {
                masterStore.remove(me.getRange(), ...params);
            };

            // TODO: prevent other functions?

            masterStore.on({
                // HACK to have chained stores react early in a async events scenario (with engine). Could be turned
                // into a config, but this way one does not have to think about it
                changePreCommit : me.onMasterDataChangedPreCommit,
                change          : me.onMasterDataChanged,
                prio            : 1,
                thisObj         : me
            });

            if (!masterStore.chainedStores) {
                masterStore.chainedStores = [];
            }
            masterStore.chainedStores.push(me);

            me.fillFromMaster();
        }
    }

    //region Properties

    /**
     * Is this a chained store?
     * @property {Boolean}
     * @readonly
     * @category Store
     */
    get isChained() {
        return Boolean(this.masterStore);
    }

    set chainedFilterFn(chainedFilterFn) {
        this._chainedFilterFn = this.thisObj ? chainedFilterFn.bind(this.thisObj) : chainedFilterFn;
    }

    get chainedFilterFn() {
        return this._chainedFilterFn || returnTrue;
    }

    get methodNamesToRelay() {
        const doIsArray = Array.isArray(this.doRelayToMaster),
            dontIsArray = Array.isArray(this.dontRelayToMaster);

        return doIsArray && this.doRelayToMaster.filter(name => !dontIsArray || !this.dontRelayToMaster.includes(name)) || [];
    }

    //endregion

    //region Internal

    updateChainedStores() {
        if (this.chainedStores) {
            this.chainedStores.forEach(store => store.fillFromMaster());
        }
    }

    /**
     * Updates records available in a chained store by filtering the master store records using
     * {@link #config-chainedFilterFn}
     * @category Chained store
     */
    fillFromMaster() {
        const
            me = this,
            { masterStore, isTree } = me;

        if (!me.isChained) {
            throw new Error('fillFromMaster only allowed on chained store');
        }

        if (me.keepUncommittedChanges) {
            if (isTree) {
                throw new Error('Cannot use keepUncommittedChanges on a chained tree store');
            }
            me.data = [].concat(
                me.added.values.filter(r => !me.removed.includes(r)),
                masterStore.allRecords.filter(r => !me.removed.includes(r) && !me.added.includes(r) && me.chainedFilterFn(r))
            );
        }
        else {
            let records = masterStore.allRecords.filter(me.chainedFilterFn);

            if (isTree) {
                // All nodes will be registered
                me.idRegister = {};
                me.internalIdRegister = {};

                // *all* owned records have to join, as they would have done if they'd all gone through
                // the appendChild route for this store.
                records.forEach(r => {
                    if (r.stores.includes(me)) {
                        me.register(r);
                    }
                    else {
                        r.joinStore(me);
                    }
                });

                // We exclude collapsed records by default. It's used in Columns Store.
                // Because grid columns is a tree store when subgrid columns is just a chained store of the columns store.
                // And we don't need to include collapsed column.
                // If we need to show collapsed nodes in Combo we need to chain tree store and set `excludeCollapsedRecords` to `false`.
                if (me.excludeCollapsedRecords) {
                    const children = me.getChildren(me.rootNode);
                    records = me.doIncludeExclude(children, true);
                }
            }

            me.data = records;
        }
    }

    /**
     * Commits changes back to master.
     * - the records deleted from chained store and present in master will be deleted from master
     * - the records added to chained store and missing in master will added to master
     * Internally calls {Store#function-commit commit()}.
     * @returns {Object} Changes, see Store#changes
     * @internal
     */
    commitToMaster() {
        const
            me = this,
            master = me.masterStore;

        if (!me.isChained) {
            throw new Error('commitToMaster only allowed on chained store');
        }

        master.beginBatch();
        master.remove(me.removed.values);
        master.add(me.added.values);
        master.endBatch();

        return me.commit();
    }

    /**
     * Relays some function calls to the master store
     * @private
     */
    relayToMaster(fnName, params) {
        return this.masterStore[fnName](...params);
    }

    // HACK, when used with engine the chained store will catch events early (sync) and prevent late (async) listeners
    onMasterDataChangedPreCommit(event) {
        this.onMasterDataChanged(event);
        this.$masterEventhandled = true;
    }

    /**
     * Handles changes in master stores data. Updates the chained store accordingly
     * @private
     */
    onMasterDataChanged({ action, changes, $handled }) {
        // Handled early in engine store (above), bail out
        if (this.$masterEventhandled) {
            this.$masterEventhandled = false;
            return;
        }

        // if a field not defined in chainedFields is changed, ignore the change.
        // there is no need to refilter the store in such cases, the change will be available anyhow since data is
        // shared
        if (action !== 'update' || this.chainedFields?.some(field => field in changes)) {
            this.fillFromMaster();
        }
    }

    //endregion

    //region public API

    /**
     * Creates a chained store, a new Store instance that contains a subset of the records from current store.
     * Which records is determined by a filtering function, which is reapplied when data in the base store changes.
     *
     * If this store is a {@link Core.data.mixin.StoreTree#property-isTree tree} store, then the resulting
     * chained store will be a tree store sharing the same root node, but only child nodes which pass
     * the `chainedFilterFn` will be considered when iterating the tree through the methods such as
     * {@link Core.data.Store#function-traverse} or {@link Core.data.Store#function-forEach}.
     *
     * @param {Function} chainedFilterFn Function called for each records that determines if it should be included
     * (return true) or not (return false). Defaults to including all records (fn always returning true)
     * @param {String[]} chainedFields Array of fields that trigger filtering when they are updated
     * @param {Object} config Additional chained store configuration
     * @returns {Core.data.Store}
     * @example
     * const oldies = store.makeChained(record => record.age > 50);
     */
    makeChained(chainedFilterFn = () => true, chainedFields, config) {
        //<debug>
        // Guard against instances being passed in an attempt to clone.
        if (config && !ObjectHelper.isObject(config)) {
            throw new Error('Raw object must be passed to makeChained');
        }

        //</debug>
        return new this.constructor(Object.assign(config || {}, {
            tree        : false,
            autoTree    : false,
            masterStore : this,
            modelClass  : this.modelClass,
            chainedFilterFn,
            chainedFields
        }));
    }

    /**
     * Alias for {@link Core.data.Store#function-makeChained}
     * @param {Function} chainedFilterFn Function called for each records that determines if it should be included
     * (return true) or not (return false). Defaults to including all records (fn always returning true)
     * @param {String[]} chainedFields Array of fields that trigger filtering when they are updated
     * @param {Object} config Additional chained store configuration
     * @returns {Core.data.Store}
     */
    chain() {
        return this.makeChained(...arguments);
    }

    //endregion

    doDestroy() {
        // Destroy chained store on master store destroy
        this.chainedStores?.forEach(chainedStore => chainedStore.destroy());

        // Events superclass fires destroy event.
        super.doDestroy();
    }
};
