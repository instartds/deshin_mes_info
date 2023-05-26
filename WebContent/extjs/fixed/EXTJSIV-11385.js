Ext.define('Ext.override.grid.feature.GroupStore', {
    override: 'Ext.grid.feature.GroupStore',
    expandGroup: function(group) {
        var me = this,
            startIdx;
        if (typeof group === 'string') {
            group = me.groupingFeature.groupCache[group];
        }
        if (group && group.children.length && (startIdx = me.data.indexOf(group.placeholder)) !== -1) {
            group.isCollapsed = false;
            me.isExpandingOrCollapsing = 1;
            me.data.removeAt(startIdx);
            me.data.insert(startIdx, group.children);
            me.fireEvent('replace', me, startIdx, [group.placeholder], group.children);
            me.fireEvent('groupexpand', me, group);
            me.isExpandingOrCollapsing = 0;
        }
    },
    collapseGroup: function(group) {
        var me = this,
            startIdx,
            placeholder,
            len;
        if (typeof group === 'string') {
            group = me.groupingFeature.groupCache[group];
        }
        if (group && (len = group.children.length) && (startIdx = me.data.indexOf(group.children[0])) !== -1) {
            group.isCollapsed = true;
            me.isExpandingOrCollapsing = 2;
            me.data.removeRange(startIdx, len);
            me.data.insert(startIdx, placeholder = me.getGroupPlaceholder(group));
            me.fireEvent('replace', me, startIdx, group.children, [placeholder]);
            me.fireEvent('groupcollapse', me, group);
            me.isExpandingOrCollapsing = 0;
        }
    },
    indexOf: function(record) {
        if (!record.isCollapsedPlaceholder) {
            return this.data.indexOf(record);
        }
        return -1;
    }
});
Ext.define('Ext.override.grid.feature.Grouping', {
    override: 'Ext.grid.feature.Grouping',
    indexOf: function(record) {
        return this.dataSource.indexOf(record);
    },
    setupRowData: function(record, idx, rowValues) {
        var me = this,
            recordIndex = rowValues.recordIndex,
            data = me.refreshData,
            groupInfo = me.groupInfo,
            header = data.header,
            groupField = data.groupField,
            store = me.view.store,
            dataSource = me.view.dataSource,
            grouper, groupName, prev, next;
        rowValues.isCollapsedGroup = false;
        rowValues.summaryRecord = null;
        if (data.doGrouping) {
            grouper = me.view.store.groupers.first();
            if (record.children) {
                groupName = grouper.getGroupString(record.children[0]);
                rowValues.isFirstRow = rowValues.isLastRow = true;
                rowValues.itemClasses.push(me.hdCollapsedCls);
                rowValues.isCollapsedGroup = rowValues.needsWrap = true;
                rowValues.groupInfo = groupInfo;
                groupInfo.groupField = groupField;
                groupInfo.name = groupName;
                groupInfo.groupValue = record.children[0].get(groupField);
                groupInfo.columnName = header ? header.text : groupField;
                rowValues.collapsibleCls = me.collapsible ? me.collapsibleCls : me.hdNotCollapsibleCls;
                rowValues.groupId = me.createGroupId(groupName);
                groupInfo.rows = groupInfo.children = record.children;
                if (me.showSummaryRow) {
                    rowValues.summaryRecord = data.summaryData[groupName];
                }
                return;
            }
            groupName = grouper.getGroupString(record);
            if (record.group) {
                rowValues.isFirstRow = record === record.group.children[0];
                rowValues.isLastRow = record === record.group.children[record.group.children.length - 1];
            } else {
                rowValues.isFirstRow = recordIndex === 0;
                if (!rowValues.isFirstRow) {
                    prev = store.getAt(recordIndex - 1);
                    if (prev) {
                        rowValues.isFirstRow = !prev.isEqual(grouper.getGroupString(prev), groupName);
                    }
                }
                rowValues.isLastRow = recordIndex == (store.buffered ? store.getTotalCount() : store.getCount()) - 1;
                if (!rowValues.isLastRow) {
                    next = store.getAt(recordIndex + 1);
                    if (next) {
                        rowValues.isLastRow = !next.isEqual(grouper.getGroupString(next), groupName);
                    }
                }
            }
            if (rowValues.isFirstRow) {
                groupInfo.groupField = groupField;
                groupInfo.name = groupName;
                groupInfo.groupValue = record.get(groupField);
                groupInfo.columnName = header ? header.text : groupField;
                rowValues.collapsibleCls = me.collapsible ? me.collapsibleCls : me.hdNotCollapsibleCls;
                rowValues.groupId = me.createGroupId(groupName);
                if (!me.isExpanded(groupName)) {
                    rowValues.itemClasses.push(me.hdCollapsedCls);
                    rowValues.isCollapsedGroup = true;
                }
                if (dataSource.buffered) {
                    groupInfo.rows = groupInfo.children = [];
                } else {
                    groupInfo.rows = groupInfo.children = me.getRecordGroup(record).children;
                }
                rowValues.groupInfo = groupInfo;
            }
            if (rowValues.isLastRow) {
                if (me.showSummaryRow) {
                    rowValues.summaryRecord = data.summaryData[groupName];
                }
            }
            rowValues.needsWrap = (rowValues.isFirstRow || rowValues.summaryRecord);
        }
    }
});
Ext.define('Ext.grid.plugin.BufferedRenderer', {
    override: 'Ext.override.grid.plugin.BufferedRenderer',
    scrollTo: function(recordIdx, doSelect, callback, scope) {
        var me = this,
            view = me.view,
            viewDom = view.el.dom,
            store = me.store,
            total = store.buffered ? store.getTotalCount() : store.getCount(),
            startIdx, endIdx,
            targetRec,
            targetRow,
            tableTop,
            groupingFeature,
            group,
            record;
        if ((groupingFeature = view.dataSource.groupingFeature) && (groupingFeature.collapsible !== false)) {
            recordIdx = Math.min(Math.max(recordIdx, 0), view.store.getCount() - 1);
            record = view.store.getAt(recordIdx);
            group = groupingFeature.getGroup(record);
            if (group.isCollapsed) {
                groupingFeature.expand(group.name);
                total = store.buffered ? store.getTotalCount() : store.getCount();
            }
            recordIdx = groupingFeature.indexOf(record);
        } else {
            recordIdx = Math.min(Math.max(recordIdx, 0), total - 1);
        }
        startIdx = Math.max(Math.min(recordIdx - ((me.leadingBufferZone + me.trailingBufferZone) / 2), total - me.viewSize + 1), 0);
        tableTop = startIdx * me.rowHeight;
        endIdx = Math.min(startIdx + me.viewSize - 1, total - 1);
        store.getRange(startIdx, endIdx, {
            callback: function(range, start, end) {
                me.renderRange(start, end, true);
                targetRec = store.data.getRange(recordIdx, recordIdx)[0];
                targetRow = view.getNode(targetRec, false);
                view.body.dom.style.top = tableTop + 'px';
                me.position = me.scrollTop = viewDom.scrollTop = tableTop = Math.min(Math.max(0, tableTop - view.body.getOffsetsTo(targetRow)[1]), viewDom.scrollHeight - viewDom.clientHeight);
                if (Ext.isIE) {
                    viewDom.scrollTop = tableTop;
                }
                if (doSelect) {
                    view.selModel.select(targetRec);
                }
                if (callback) {
                    callback.call(scope || me, recordIdx, targetRec);
                }
            }
        });
    },
    onRangeFetched: function(range, start, end, fromLockingPartner) {
        var me = this,
            view = me.view,
            oldStart,
            rows = view.all,
            removeCount,
            increment = 0,
            calculatedTop = start * me.rowHeight,
            top,
            lockingPartner = me.lockingPartner,
            newRows,
            topAdditionSize,
            i;
        if (view.isDestroyed) {
            return;
        }
        if (!range) {
            range = me.store.getRange(start, end);
            if (!range) {
                return;
            }
        }
        if (start < rows.startIndex && end > rows.endIndex) {
            topAdditionSize = rows.startIndex - start;
            rows.clear(true);
            newRows = Ext.Array.slice(view.doAdd(range, start), 0, topAdditionSize);
            for (i = 0; i < newRows.length; i++) {
                increment -= newRows[i].offsetHeight;
            }
            me.setBodyTop(me.bodyTop + increment);
            return;
        }
        if (start > rows.endIndex || end < rows.startIndex) {
            rows.clear(true);
            top = calculatedTop;
        }
        if (!rows.getCount()) {
            view.doAdd(range, start);
        } else if (end > rows.endIndex) {
            removeCount = Math.max(start - rows.startIndex, 0);
            if (me.variableRowHeight) {
                increment = rows.item(rows.startIndex + removeCount, true).offsetTop;
            }
            rows.scroll(Ext.Array.slice(range, rows.endIndex + 1 - start), 1, removeCount, start, end);
            if (me.variableRowHeight) {
                top = me.bodyTop + increment;
            } else {
                top = calculatedTop;
            }
        } else {
            removeCount = Math.max(rows.endIndex - end, 0);
            oldStart = rows.startIndex;
            rows.scroll(Ext.Array.slice(range, 0, rows.startIndex - start), -1, removeCount, start, end);
            if (me.variableRowHeight) {
                top = me.bodyTop - rows.item(oldStart, true).offsetTop;
            } else {
                top = calculatedTop;
            }
        }
        me.position = me.scrollTop;
        if (view.positionBody) {
            me.setBodyTop(top, calculatedTop);
        }
        if (lockingPartner && !lockingPartner.disabled && !fromLockingPartner) {
            lockingPartner.onRangeFetched(range, start, end, true);
            if (lockingPartner.scrollTop !== me.scrollTop) {
                lockingPartner.view.el.dom.scrollTop = me.scrollTop;
            }
        }
    }
});
Ext.define('Ext.grid.plugin.BufferedRendererTableView', {
    override: 'Ext.override.grid.plugin.BufferedRendererTableView',
    onReplace: function(store, startIndex, oldRecords, newRecords) {
        var me = this,
            bufferedRenderer = me.bufferedRenderer,
            viewSize = bufferedRenderer && bufferedRenderer.viewSize,
            overflow,
            overlap,
            rows = me.all,
            endIndex;
        endIndex = startIndex + oldRecords.length - 1;
        if (me.rendered && bufferedRenderer) {
            if (endIndex < rows.startIndex || startIndex > rows.endIndex) {
                bufferedRenderer.stretchView(me, bufferedRenderer.getScrollHeight());
                return;
            }
            if (startIndex <= rows.startIndex && endIndex >= rows.endIndex) {
                me.refreshView();
            } else if (startIndex < rows.startIndex) {
                overlap = startIndex + newRecords.length - rows.startIndex;
                if (overlap > 0) {
                    me.callParent([store, rows.startIndex, Ext.Array.slice(oldRecords, oldRecords.length - overlap), Ext.Array.slice(newRecords, newRecords.length - overlap)]);
                } else {
                    rows.removeRange(rows.startIndex, startIndex + oldRecords.length - 1, true);
                    startIndex = Math.max(rows.startIndex, 0);
                    endIndex = Math.min(startIndex + viewSize, store.getCount()) - 1;
                    bufferedRenderer.onRangeFetched(null, startIndex, endIndex, true);
                }
            } else {
                overflow = startIndex + newRecords.length - 1 - rows.endIndex;
                if (overflow > 0) {
                    rows.removeRange(startIndex, null, true);
                    endIndex = Math.max(newRecords.length - overflow, rows.startIndex + viewSize);
                    me.doAdd(Ext.Array.slice(newRecords, 0, endIndex), startIndex);
                } else {
                    endIndex = Math.min(rows.endIndex, store.getCount() - 1);
                    rows.removeRange(startIndex, null, true);
                    startIndex = Math.max(endIndex - viewSize + 1, 0);
                    bufferedRenderer.onRangeFetched(null, startIndex, endIndex, true);
                }
            }
            bufferedRenderer.stretchView(me, bufferedRenderer.getScrollHeight());
        } else {
            me.callParent(arguments);
        }
    },
    onAdd: function(store, records, index) {
        var me = this,
            bufferedRenderer = me.bufferedRenderer,
            viewSize = bufferedRenderer && bufferedRenderer.viewSize,
            storeSize = store.getCount(),
            rows = me.all,
            startIndex,
            endIndex;
        if (me.rendered && bufferedRenderer) {
            if ((rows.getCount() + records.length) > viewSize) {
                if (index < rows.startIndex + viewSize && (index + records.length) > rows.startIndex) {
                    startIndex = Math.max(bufferedRenderer.getFirstVisibleRowIndex() - bufferedRenderer.trailingBufferZone, 0);
                    endIndex = Math.min(startIndex + bufferedRenderer.viewSize, storeSize) - 1;
                    rows.removeRange(index, null, true);
                    bufferedRenderer.onRangeFetched(null, startIndex, endIndex, true);
                    bufferedRenderer.stretchView(me, bufferedRenderer.getScrollHeight());
                }
            } else if (rows.getCount() + records.length < viewSize) {
                rows.clear(true);
                startIndex = Math.max(0, storeSize - viewSize);
                me.doAdd(store.getRange(startIndex, Math.min(startIndex + bufferedRenderer.viewSize, storeSize) - 1), 0);
            } else {
                me.callParent([store, records, index]);
            }
            bufferedRenderer.stretchView(me, bufferedRenderer.getScrollHeight());
        } else {
            me.callParent([store, records, index]);
        }
    },
    onRemove: function(store, records, indices) {
        var me = this,
            bufferedRenderer = me.bufferedRenderer,
            storeSize, rows, startIndex;
        me.callParent([store, records, indices]);
        if (me.rendered && bufferedRenderer) {
            storeSize = me.dataSource.getCount();
            rows = me.all;
            if (storeSize > rows.getCount()) {
                startIndex = rows.startIndex;
                bufferedRenderer.onRangeFetched(null, startIndex, Math.min(startIndex + bufferedRenderer.viewSize, storeSize) - 1, true);
            } else {
                bufferedRenderer.stretchView(me, bufferedRenderer.getScrollHeight());
            }
        }
    }
});
Ext.define('Ext.override.view.NodeCache', {
    override: 'Ext.view.NodeCache',
    removeRange: function(start, end, removeDom) {
        var me = this,
            elements = me.elements,
            el,
            i, removeCount, fromPos;
        if (end == null) {
            end = me.endIndex + 1;
        } else {
            end = Math.min(me.endIndex + 1, end + 1);
        }
        if (start == null) {
            start = me.startIndex;
        }
        removeCount = end - start;
        for (i = start, fromPos = end; i <= me.endIndex; i++, fromPos++) {
            if (removeDom && i < end) {
                Ext.removeNode(elements[i]);
            }
            if (fromPos <= me.endIndex) {
                el = elements[i] = elements[fromPos];
                el.setAttribute('data-recordIndex', i);
            } else {
                delete elements[i];
            }
        }
        me.count -= removeCount;
        me.endIndex -= removeCount;
    }
});
Ext.define('Ext.override.view.Table', {
    override: 'Ext.view.Table',
    indexInStore: function(node) {
        return this.dataSource.indexOf(this.getRecord(node));
    },
    onUpdate: function(store, record, operation, changedFieldNames) {
        var me = this,
            rowTpl = me.rowTpl,
            oldRow, oldRowDom, oldDataRow,
            newRowDom,
            newAttrs, attLen, attName, attrIndex,
            overItemCls, beforeOverItemCls,
            focusedItemCls, beforeFocusedItemCls,
            selectedItemCls, beforeSelectedItemCls,
            columns;
        if (me.viewReady) {
            oldRowDom = me.getNodeByRecord(record, false);
            if (oldRowDom) {
                overItemCls = me.overItemCls;
                beforeOverItemCls = me.beforeOverItemCls;
                focusedItemCls = me.focusedItemCls;
                beforeFocusedItemCls = me.beforeFocusedItemCls;
                selectedItemCls = me.selectedItemCls;
                beforeSelectedItemCls = me.beforeSelectedItemCls;
                oldRow = Ext.fly(oldRowDom, '_internal');
                newRowDom = me.createRowElement(record, me.indexInStore(record));
                if (oldRow.hasCls(overItemCls)) {
                    Ext.fly(newRowDom).addCls(overItemCls);
                }
                if (oldRow.hasCls(beforeOverItemCls)) {
                    Ext.fly(newRowDom).addCls(beforeOverItemCls);
                }
                if (oldRow.hasCls(focusedItemCls)) {
                    Ext.fly(newRowDom).addCls(focusedItemCls);
                }
                if (oldRow.hasCls(beforeFocusedItemCls)) {
                    Ext.fly(newRowDom).addCls(beforeFocusedItemCls);
                }
                if (oldRow.hasCls(selectedItemCls)) {
                    Ext.fly(newRowDom).addCls(selectedItemCls);
                }
                if (oldRow.hasCls(beforeSelectedItemCls)) {
                    Ext.fly(newRowDom).addCls(beforeSelectedItemCls);
                }
                columns = me.ownerCt.getVisibleColumnManager().getColumns();
                if (Ext.isIE9m && oldRowDom.mergeAttributes) {
                    oldRowDom.mergeAttributes(newRowDom, true);
                } else {
                    newAttrs = newRowDom.attributes;
                    attLen = newAttrs.length;
                    for (attrIndex = 0; attrIndex < attLen; attrIndex++) {
                        attName = newAttrs[attrIndex].name;
                        if (attName !== 'id') {
                            oldRowDom.setAttribute(attName, newAttrs[attrIndex].value);
                        }
                    }
                }
                if (columns.length && (oldDataRow = me.getNode(oldRowDom, true))) {
                    me.updateColumns(record, oldDataRow, me.getNode(newRowDom, true), columns, changedFieldNames);
                }
                while (rowTpl) {
                    if (rowTpl.syncContent) {
                        if (rowTpl.syncContent(oldRowDom, newRowDom) === false) {
                            break;
                        }
                    }
                    rowTpl = rowTpl.nextTpl;
                }
                me.fireEvent('itemupdate', record, me.store.indexOf(record), oldRowDom);
                me.refreshSize();
            }
        }
    },
    onReplace: function(store, startIndex, oldRecords, newRecords) {
        var me = this,
            selModel = me.selModel,
            nextIndex, isNextRowSelected, isNextRowFocused;
        me.callParent(arguments);
        me.doStripeRows(startIndex);
        if (me.rendered && selModel.isRowModel && !newRecords[0].isCollapsedPlaceholder) {
            nextIndex = startIndex + newRecords.length;
            isNextRowSelected = selModel.isRowSelected(nextIndex);
            isNextRowFocused = me.indexOf(selModel.lastFocused) === (nextIndex);
            if (isNextRowSelected || isNextRowFocused) {
                me.onRowDeselect(startIndex);
            }
            if (isNextRowSelected) {
                me.onRowSelect(nextIndex);
            }
            if (selModel.isRowSelected(startIndex)) {
                me.onRowSelect(startIndex);
            }
        }
        me.selModel.onLastFocusChanged(null, me.selModel.lastFocused, true);
    },
});
Ext.define('Ext.override.view.AbstractView', {
    override: 'Ext.view.AbstractView',
    onReplace: function(store, startIndex, oldRecords, newRecords) {
        var me = this,
            endIndex,
            rows = me.all,
            nodes,
            i, j;
        if (me.rendered) {
            nodes = me.bufferRender(newRecords, startIndex, true);
            rows.item(startIndex).insertSibling(nodes, 'before', true);
            rows.insert(startIndex, nodes);
            startIndex += newRecords.length;
            endIndex = startIndex + oldRecords.length - 1;
            rows.removeRange(startIndex, endIndex, true);
            if (me.refreshSelmodelOnRefresh !== false) {
                me.selModel.refresh();
            }
            me.updateIndexes(startIndex);
            me.refreshSize();
            if (me.hasListeners.itemremove) {
                for (i = oldRecords.length, j = endIndex; i >= 0; --i, --j) {
                    me.fireEvent('itemremove', oldRecords[i], j);
                }
            }
            if (me.hasListeners.itemadd) {
                me.fireEvent('itemadd', newRecords, startIndex, nodes);
            }
        }
    },
    doAdd: function(records, index) {
        var me = this,
            nodes = me.bufferRender(records, index, true),
            all = me.all,
            count = all.getCount(),
            firstRowIndex = all.startIndex || 0,
            lastRowIndex = all.endIndex || count - 1,
            i, l, nodeContainer, fragment;
        if (count === 0 || index > lastRowIndex) {
            nodeContainer = this.getNodeContainer();
            fragment = document.createDocumentFragment();

            for (i = 0, l = nodes.length; i < l; i++) {
                fragment.appendChild(nodes[i]);
            }
            nodeContainer.appendChild(fragment);
        } else if (index <= firstRowIndex) {
            all.item(all.startIndex).insertSibling(nodes, 'before', true);
        } else {
            all.item(index).insertSibling(nodes, 'before', true);
        }
        all.insert(index, nodes);
        return nodes;
    },
    onRemove: function(ds, records, indices) {
        var me = this,
            fireItemRemove = me.hasListeners.itemremove,
            i,
            record,
            index;
        if (me.all.getCount()) {
            if (me.dataSource.getCount() === 0) {
                if (fireItemRemove) {
                    for (i = indices.length - 1; i >= 0; --i) {
                        me.fireEvent('itemremove', records[i], indices[i]);
                    }
                }
                me.refresh();
            } else {
                for (i = indices.length - 1; i >= 0; --i) {
                    record = records[i];
                    index = indices[i];
                    if (me.all.item(index)) {
                        me.doRemove(record, index);
                        if (fireItemRemove) {
                            me.fireEvent('itemremove', record, index);
                        }
                    }
                }
                me.updateIndexes(indices[0]);
            }
            this.refreshSize();
        }
    },
    refreshNode: function(index) {
        this.onUpdate(this.dataSource, this.store.getAt(index));
    },
    getStoreListeners: function() {
        var me = this;
        return {
            idchanged: me.onIdChanged,
            refresh: me.onDataRefresh,
            replace: me.onReplace,
            add: me.onAdd,
            bulkremove: me.onRemove,
            update: me.onUpdate,
            clear: me.refresh
        };
    }
});