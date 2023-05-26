/**
 * @class Ext.ux.DataTip
 * @extends Ext.ToolTip.
 * This plugin implements automatic tooltip generation for an arbitrary number of child nodes *within* a Component.
 *
 * This plugin is applied to a high level Component, which contains repeating elements, and depending on the host Component type,
 * it automatically selects a {@link Ext.ToolTip#delegate delegate} so that it appears when the mouse enters a sub-element.
 *
 * When applied to a GridPanel, this ToolTip appears when over a row, and the Record's data is applied
 * using this object's {@link #tpl} template.
 *
 * When applied to a DataView, this ToolTip appears when over a view node, and the Record's data is applied
 * using this object's {@link #tpl} template.
 *
 * When applied to a TreePanel, this ToolTip appears when over a tree node, and the Node's {@link Ext.data.Model} record data is applied
 * using this object's {@link #tpl} template.
 *
 * When applied to a FormPanel, this ToolTip appears when over a Field, and the Field's `tooltip` property is used is applied
 * using this object's {@link #tpl} template, or if it is a string, used as HTML content. If there is no `tooltip` property,
 * the field itself is used as the template's data object.
 *
 * If more complex logic is needed to determine content, then the {@link #beforeshow} event may be used.
 * This class also publishes a **`beforeshowtip`** event through its host Component. The *host Component* fires the
 * **`beforeshowtip`** event.
 */
Ext.define('Ext.ux.DataTip', function(DataTip) {

//  Target the body (if the host is a Panel), or, if there is no body, the main Element.
    function onHostRender() {
        var e = this.isXType('panel') ? this.body : this.el;
        if (this.dataTip.renderToTarget) {
            this.dataTip.render(e);
        }
        this.dataTip.setTarget(e);
    }

    function updateTip(tip, data) {
        if (tip.rendered) {
            if (tip.host.fireEvent('beforeshowtip', tip.eventHost, tip, data) === false) {
                return false;
            }
            tip.update(data);
        } else {
            if (Ext.isString(data)) {
                tip.html = data;
            } else {
                tip.data = data;
            }
        }
    }

    function beforeViewTipShow(tip) {
        var rec = this.view.getRecord(tip.triggerElement),
            data;

        if (rec) {
            data = tip.initialConfig.data ? Ext.apply(tip.initialConfig.data, rec.data) : rec.data;
            return updateTip(tip, data);
        } else {
            return false;
        }
    }

    function beforeFormTipShow(tip) {
        var field = Ext.getCmp(tip.triggerElement.id);
        if (field && (field.tooltip || tip.tpl)) {
            return updateTip(tip, field.tooltip || field);
        } else {
            return false;
        }
    }

    return {
        extend: 'Ext.tip.ToolTip',

        mixins: {
            plugin: 'Ext.AbstractPlugin'
        },

        alias: 'plugin.datatip',

        lockableScope: 'both',

        constructor: function(config) {
            var me = this;
            me.callParent([config]);
            me.mixins.plugin.constructor.call(me, config);
        },

        init: function(host) {
            var me = this;

            me.mixins.plugin.init.call(me, host);
            host.dataTip = me;
            me.host = host;

            if (host.isXType('tablepanel')) {
                me.view = host.getView();
                if (host.ownerLockable) {
                    me.host = host.ownerLockable;
                }
                me.delegate = me.delegate || me.view.getDataRowSelector();
                me.on('beforeshow', beforeViewTipShow);
            } else if (host.isXType('dataview')) {
                me.view = me.host;
                me.delegate = me.delegate || host.itemSelector;
                me.on('beforeshow', beforeViewTipShow);
            } else if (host.isXType('form')) {
                me.delegate = '.' + Ext.form.Labelable.prototype.formItemCls;
                me.on('beforeshow', beforeFormTipShow);
            } else if (host.isXType('combobox')) {
                me.view = host.getPicker();
                me.delegate = me.delegate || me.view.getItemSelector();
                me.on('beforeshow', beforeViewTipShow);
            }
            if (host.rendered) {
                onHostRender.call(host);
            } else {
                host.onRender = Ext.Function.createSequence(host.onRender, onHostRender);
            }
        }
    };
});/**
 * Base class from Ext.ux.TabReorderer.
 */
Ext.define('Ext.ux.BoxReorderer', {
    mixins: {
        observable: 'Ext.util.Observable'
    },

    /**
     * @cfg {String} itemSelector
     * A {@link Ext.DomQuery DomQuery} selector which identifies the encapsulating elements of child
     * Components which participate in reordering.
     */
    itemSelector: '.x-box-item',

    /**
     * @cfg {Mixed} animate
     * If truthy, child reordering is animated so that moved boxes slide smoothly into position.
     * If this option is numeric, it is used as the animation duration in milliseconds.
     */
    animate: 100,

    constructor: function() {
        this.addEvents(
            /**
             * @event StartDrag
             * Fires when dragging of a child Component begins.
             * @param {Ext.ux.BoxReorderer} this
             * @param {Ext.container.Container} container The owning Container
             * @param {Ext.Component} dragCmp The Component being dragged
             * @param {Number} idx The start index of the Component being dragged.
             */
             'StartDrag',
            /**
             * @event Drag
             * Fires during dragging of a child Component.
             * @param {Ext.ux.BoxReorderer} this
             * @param {Ext.container.Container} container The owning Container
             * @param {Ext.Component} dragCmp The Component being dragged
             * @param {Number} startIdx The index position from which the Component was initially dragged.
             * @param {Number} idx The current closest index to which the Component would drop.
             */
             'Drag',
            /**
             * @event ChangeIndex
             * Fires when dragging of a child Component causes its drop index to change.
             * @param {Ext.ux.BoxReorderer} this
             * @param {Ext.container.Container} container The owning Container
             * @param {Ext.Component} dragCmp The Component being dragged
             * @param {Number} startIdx The index position from which the Component was initially dragged.
             * @param {Number} idx The current closest index to which the Component would drop.
             */
             'ChangeIndex',
            /**
             * @event Drop
             * Fires when a child Component is dropped at a new index position.
             * @param {Ext.ux.BoxReorderer} this
             * @param {Ext.container.Container} container The owning Container
             * @param {Ext.Component} dragCmp The Component being dropped
             * @param {Number} startIdx The index position from which the Component was initially dragged.
             * @param {Number} idx The index at which the Component is being dropped.
             */
             'Drop'
        );
        this.mixins.observable.constructor.apply(this, arguments);
    },

    init: function(container) {
        var me = this;
 
        me.container = container;
 
        // Set our animatePolicy to animate the start position (ie x for HBox, y for VBox)
        me.animatePolicy = {};
        me.animatePolicy[container.getLayout().names.x] = true;
        
        

        // Initialize the DD on first layout, when the innerCt has been created.
        me.container.on({
            scope: me,
            boxready: me.afterFirstLayout,
            beforedestroy: me.onContainerDestroy
        });
    },

    /**
     * @private Clear up on Container destroy
     */
    onContainerDestroy: function() {
        var dd = this.dd;
        if (dd) {
            dd.unreg();
            this.dd = null;
        }
    },

    afterFirstLayout: function() {
        var me = this,
            layout = me.container.getLayout(),
            names = layout.names,
            dd;
            
        // Create a DD instance. Poke the handlers in.
        // TODO: Ext5's DD classes should apply config to themselves.
        // TODO: Ext5's DD classes should not use init internally because it collides with use as a plugin
        // TODO: Ext5's DD classes should be Observable.
        // TODO: When all the above are trus, this plugin should extend the DD class.
        dd = me.dd = Ext.create('Ext.dd.DD', layout.innerCt, me.container.id + '-reorderer');
        Ext.apply(dd, {
            animate: me.animate,
            reorderer: me,
            container: me.container,
            getDragCmp: this.getDragCmp,
            clickValidator: Ext.Function.createInterceptor(dd.clickValidator, me.clickValidator, me, false),
            onMouseDown: me.onMouseDown,
            startDrag: me.startDrag,
            onDrag: me.onDrag,
            endDrag: me.endDrag,
            getNewIndex: me.getNewIndex,
            doSwap: me.doSwap,
            findReorderable: me.findReorderable
        });

        // Decide which dimension we are measuring, and which measurement metric defines
        // the *start* of the box depending upon orientation.
        dd.dim = names.width;
        dd.startAttr = names.beforeX;
        dd.endAttr = names.afterX;
    },

    getDragCmp: function(e) {
        return this.container.getChildByElement(e.getTarget(this.itemSelector, 10));
    },

    // check if the clicked component is reorderable
    clickValidator: function(e) {
        var cmp = this.getDragCmp(e);

        // If cmp is null, this expression MUST be coerced to boolean so that createInterceptor is able to test it against false
        return !!(cmp && cmp.reorderable !== false);
    },

    onMouseDown: function(e) {
        var me = this,
            container = me.container,
            containerBox,
            cmpEl,
            cmpBox;

        // Ascertain which child Component is being mousedowned
        me.dragCmp = me.getDragCmp(e);
        if (me.dragCmp) {
            cmpEl = me.dragCmp.getEl();
            me.startIndex = me.curIndex = container.items.indexOf(me.dragCmp);

            // Start position of dragged Component
            cmpBox = cmpEl.getBox();

            // Last tracked start position
            me.lastPos = cmpBox[this.startAttr];

            // Calculate constraints depending upon orientation
            // Calculate offset from mouse to dragEl position
            containerBox = container.el.getBox();
            if (me.dim === 'width') {
                me.minX = containerBox.left;
                me.maxX = containerBox.right - cmpBox.width;
                me.minY = me.maxY = cmpBox.top;
                me.deltaX = e.getPageX() - cmpBox.left;
            } else {
                me.minY = containerBox.top;
                me.maxY = containerBox.bottom - cmpBox.height;
                me.minX = me.maxX = cmpBox.left;
                me.deltaY = e.getPageY() - cmpBox.top;
            }
            me.constrainY = me.constrainX = true;
        }
    },

    startDrag: function() {
        var me = this,
            dragCmp = me.dragCmp;
            
        if (dragCmp) {
            // For the entire duration of dragging the *Element*, defeat any positioning and animation of the dragged *Component*
            dragCmp.setPosition = Ext.emptyFn;
            dragCmp.animate = false;

            // Animate the BoxLayout just for the duration of the drag operation.
            if (me.animate) {
                me.container.getLayout().animatePolicy = me.reorderer.animatePolicy;
            }
            // We drag the Component element
            me.dragElId = dragCmp.getEl().id;
            me.reorderer.fireEvent('StartDrag', me, me.container, dragCmp, me.curIndex);
            // Suspend events, and set the disabled flag so that the mousedown and mouseup events
            // that are going to take place do not cause any other UI interaction.
            dragCmp.suspendEvents();
            dragCmp.disabled = true;
            dragCmp.el.setStyle('zIndex', 100);
        } else {
            me.dragElId = null;
        }
    },

    /**
     * @private
     * Find next or previous reorderable component index.
     * @param {Number} newIndex The initial drop index.
     * @return {Number} The index of the reorderable component.
     */
    findReorderable: function(newIndex) {
        var me = this,
            items = me.container.items,
            newItem;

        if (items.getAt(newIndex).reorderable === false) {
            newItem = items.getAt(newIndex);
            if (newIndex > me.startIndex) {
                 while(newItem && newItem.reorderable === false) {
                    newIndex++;
                    newItem = items.getAt(newIndex);
                }
            } else {
                while(newItem && newItem.reorderable === false) {
                    newIndex--;
                    newItem = items.getAt(newIndex);
                }
            }
        }

        newIndex = Math.min(Math.max(newIndex, 0), items.getCount() - 1);

        if (items.getAt(newIndex).reorderable === false) {
            return -1;
        }
        return newIndex;
    },

    /**
     * @private
     * Swap 2 components.
     * @param {Number} newIndex The initial drop index.
     */
    doSwap: function(newIndex) {
        var me = this,
            items = me.container.items,
            container = me.container,
            wasRoot = me.container._isLayoutRoot,
            orig, dest, tmpIndex, temp;

        newIndex = me.findReorderable(newIndex);

        if (newIndex === -1) {
            return;
        }

        me.reorderer.fireEvent('ChangeIndex', me, container, me.dragCmp, me.startIndex, newIndex);
        orig = items.getAt(me.curIndex);
        dest = items.getAt(newIndex);
        items.remove(orig);
        tmpIndex = Math.min(Math.max(newIndex, 0), items.getCount() - 1);
        items.insert(tmpIndex, orig);
        items.remove(dest);
        items.insert(me.curIndex, dest);

        // Make the Box Container the topmost layout participant during the layout.
        container._isLayoutRoot = true;
        container.updateLayout();
        container._isLayoutRoot = wasRoot;
        me.curIndex = newIndex;
    },

    onDrag: function(e) {
        var me = this,
            newIndex;

        newIndex = me.getNewIndex(e.getPoint());
        if ((newIndex !== undefined)) {
            me.reorderer.fireEvent('Drag', me, me.container, me.dragCmp, me.startIndex, me.curIndex);
            me.doSwap(newIndex);
        }

    },

    endDrag: function(e) {
        if (e) {
            e.stopEvent();
        }
        var me = this,
            layout = me.container.getLayout(),
            temp;

        if (me.dragCmp) {
            delete me.dragElId;

            // Reinstate the Component's positioning method after mouseup, and allow the layout system to animate it.
            delete me.dragCmp.setPosition;
            me.dragCmp.animate = true;
            
            // Ensure the lastBox is correct for the animation system to restore to when it creates the "from" animation frame
            me.dragCmp.lastBox[layout.names.x] = me.dragCmp.getPosition(true)[layout.names.widthIndex];

            // Make the Box Container the topmost layout participant during the layout.
            me.container._isLayoutRoot = true;
            me.container.updateLayout();
            me.container._isLayoutRoot = undefined;
            
            // Attempt to hook into the afteranimate event of the drag Component to call the cleanup
            temp = Ext.fx.Manager.getFxQueue(me.dragCmp.el.id)[0];
            if (temp) {
                temp.on({
                    afteranimate: me.reorderer.afterBoxReflow,
                    scope: me
                });
            } 
            // If not animated, clean up after the mouseup has happened so that we don't click the thing being dragged
            else {
                Ext.Function.defer(me.reorderer.afterBoxReflow, 1, me);
            }

            if (me.animate) {
                delete layout.animatePolicy;
            }
            me.reorderer.fireEvent('drop', me, me.container, me.dragCmp, me.startIndex, me.curIndex);
        }
    },

    /**
     * @private
     * Called after the boxes have been reflowed after the drop.
     * Re-enabled the dragged Component.
     */
    afterBoxReflow: function() {
        var me = this;
        me.dragCmp.el.setStyle('zIndex', '');
        me.dragCmp.disabled = false;
        me.dragCmp.resumeEvents();
    },

    /**
     * @private
     * Calculate drop index based upon the dragEl's position.
     */
    getNewIndex: function(pointerPos) {
        var me = this,
            dragEl = me.getDragEl(),
            dragBox = Ext.fly(dragEl).getBox(),
            targetEl,
            targetBox,
            targetMidpoint,
            i = 0,
            it = me.container.items.items,
            ln = it.length,
            lastPos = me.lastPos;

        me.lastPos = dragBox[me.startAttr];

        for (; i < ln; i++) {
            targetEl = it[i].getEl();

            // Only look for a drop point if this found item is an item according to our selector
            if (targetEl.is(me.reorderer.itemSelector)) {
                targetBox = targetEl.getBox();
                targetMidpoint = targetBox[me.startAttr] + (targetBox[me.dim] >> 1);
                if (i < me.curIndex) {
                    if ((dragBox[me.startAttr] < lastPos) && (dragBox[me.startAttr] < (targetMidpoint - 5))) {
                        return i;
                    }
                } else if (i > me.curIndex) {
                    if ((dragBox[me.startAttr] > lastPos) && (dragBox[me.endAttr] > (targetMidpoint + 5))) {
                        return i;
                    }
                }
            }
        }
    }
});
/**
 * Plugin which allows items to be dropped onto a toolbar and be turned into new Toolbar items.
 * To use the plugin, you just need to provide a createItem implementation that takes the drop
 * data as an argument and returns an object that can be placed onto the toolbar. Example:
 * <pre>
 * Ext.create('Ext.ux.ToolbarDroppable', {
 *   createItem: function(data) {
 *     return Ext.create('Ext.Button', {text: data.text});
 *   }
 * });
 * </pre>
 * The afterLayout function can also be overridden, and is called after a new item has been
 * created and inserted into the Toolbar. Use this for any logic that needs to be run after
 * the item has been created.
 */
 Ext.define('Ext.ux.ToolbarDroppable', {

    /**
     * Creates new ToolbarDroppable.
     * @param {Object} config Config options.
     */
    constructor: function(config) {
      Ext.apply(this, config);
    },

    /**
     * Initializes the plugin and saves a reference to the toolbar
     * @param {Ext.toolbar.Toolbar} toolbar The toolbar instance
     */
    init: function(toolbar) {
      /**
       * @property toolbar
       * @type Ext.toolbar.Toolbar
       * The toolbar instance that this plugin is tied to
       */
      this.toolbar = toolbar;

      this.toolbar.on({
          scope : this,
          render: this.createDropTarget
      });
    },

    /**
     * Creates a drop target on the toolbar
     */
    createDropTarget: function() {
        /**
         * @property dropTarget
         * @type Ext.dd.DropTarget
         * The drop target attached to the toolbar instance
         */
        this.dropTarget = Ext.create('Ext.dd.DropTarget', this.toolbar.getEl(), {
            notifyOver: Ext.Function.bind(this.notifyOver, this),
            notifyDrop: Ext.Function.bind(this.notifyDrop, this)
        });
    },

    /**
     * Adds the given DD Group to the drop target
     * @param {String} ddGroup The DD Group
     */
    addDDGroup: function(ddGroup) {
        this.dropTarget.addToGroup(ddGroup);
    },

    /**
     * Calculates the location on the toolbar to create the new sorter button based on the XY of the
     * drag event
     * @param {Ext.EventObject} e The event object
     * @return {Number} The index at which to insert the new button
     */    
    calculateEntryIndex: function(e) {
        var entryIndex = 0,
            toolbar = this.toolbar,
            items = toolbar.items.items,
            count = items.length,
            xHover = e.getXY()[0],
            index = 0,
            el, xTotal, width, midpoint;
 
        for (; index < count; index++) {
            el = items[index].getEl();
            xTotal = el.getXY()[0];
            width = el.getWidth();
            midpoint = xTotal + width / 2;
 
            if (xHover < midpoint) {
                entryIndex = index; 
                break;
            } else {
                entryIndex = index + 1;
            }
       }
       return entryIndex;
    },

    /**
     * Returns true if the drop is allowed on the drop target. This function can be overridden
     * and defaults to simply return true
     * @param {Object} data Arbitrary data from the drag source
     * @return {Boolean} True if the drop is allowed
     */
    canDrop: function(data) {
        return true;
    },

    /**
     * Custom notifyOver method which will be used in the plugin's internal DropTarget
     * @return {String} The CSS class to add
     */
    notifyOver: function(dragSource, event, data) {
        return this.canDrop.apply(this, arguments) ? this.dropTarget.dropAllowed : this.dropTarget.dropNotAllowed;
    },

    /**
     * Called when the drop has been made. Creates the new toolbar item, places it at the correct location
     * and calls the afterLayout callback.
     */
    notifyDrop: function(dragSource, event, data) {
        var canAdd = this.canDrop(dragSource, event, data),
            tbar   = this.toolbar;

        if (canAdd) {
            var entryIndex = this.calculateEntryIndex(event);

            tbar.insert(entryIndex, this.createItem(data));
            tbar.doLayout();

            this.afterLayout();
        }

        return canAdd;
    },

    /**
     * Creates the new toolbar item based on drop data. This method must be implemented by the plugin instance
     * @param {Object} data Arbitrary data from the drop
     * @return {Mixed} An item that can be added to a toolbar
     */
    createItem: function(data) {
        //<debug>
        Ext.Error.raise("The createItem method must be implemented in the ToolbarDroppable plugin");
        //</debug>
    },

    /**
     * Called after a new button has been created and added to the toolbar. Add any required cleanup logic here
     */
    afterLayout: Ext.emptyFn
});
/*
 * GNU General Public License Usage
 * This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 *
 * http://www.gnu.org/licenses/lgpl.html
 *
 * @description: This class provide aditional format to numbers by extending Ext.form.field.Number
 *
 * @author: Greivin Britton
 * @email: brittongr@gmail.com
 * @version: 2 compatible with ExtJS 4
 */
Ext.define('Ext.ux.form.NumericField', 
{
    extend: 'Ext.form.field.Number',//Extending the NumberField
    alias: 'widget.numericfield',//Defining the xtype,
    currencySymbol: null,
    useThousandSeparator: true,
    thousandSeparator: ',',
    alwaysDisplayDecimals: false,
    fieldStyle: 'text-align: right;',
	initComponent: function(){
        if (this.useThousandSeparator && this.decimalSeparator == ',' && this.thousandSeparator == ',') 
            this.thousandSeparator = '.';
        else 
            if (this.allowDecimals && this.thousandSeparator == '.' && this.decimalSeparator == '.') 
                this.decimalSeparator = ',';
        
        this.callParent(arguments);
    },
    setValue: function(value){
        Ext.ux.form.NumericField.superclass.setValue.call(this, value != null ? value.toString().replace('.', this.decimalSeparator) : value);
        
        this.setRawValue(this.getFormattedValue(this.getValue()));
    },
    getFormattedValue: function(value){
        if (Ext.isEmpty(value) || !this.hasFormat()) 
            return value;
        else 
        {
            var neg = null;
            
            value = (neg = value < 0) ? value * -1 : value;
            value = this.allowDecimals && this.alwaysDisplayDecimals ? value.toFixed(this.decimalPrecision) : value;
            
            if (this.useThousandSeparator) 
            {
                if (this.useThousandSeparator && Ext.isEmpty(this.thousandSeparator)) 
                    throw ('NumberFormatException: invalid thousandSeparator, property must has a valid character.');
                
                if (this.thousandSeparator == this.decimalSeparator) 
                    throw ('NumberFormatException: invalid thousandSeparator, thousand separator must be different from decimalSeparator.');
                
                value = value.toString();
                
                var ps = value.split('.');
                ps[1] = ps[1] ? ps[1] : null;
                
                var whole = ps[0];
                
                var r = /(\d+)(\d{3})/;
                
                var ts = this.thousandSeparator;
                
                while (r.test(whole)) 
                    whole = whole.replace(r, '$1' + ts + '$2');
                
                value = whole + (ps[1] ? this.decimalSeparator + ps[1] : '');
            }
            
            return Ext.String.format('{0}{1}{2}', (neg ? '-' : ''), (Ext.isEmpty(this.currencySymbol) ? '' : this.currencySymbol + ' '), value);
        }
    },
    /**
     * overrides parseValue to remove the format applied by this class
     */
    parseValue: function(value){
        //Replace the currency symbol and thousand separator
        return Ext.ux.form.NumericField.superclass.parseValue.call(this, this.removeFormat(value));
    },
    /**
     * Remove only the format added by this class to let the superclass validate with it's rules.
     * @param {Object} value
     */
    removeFormat: function(value){
        if (Ext.isEmpty(value) || !this.hasFormat()) 
            return value;
        else 
        {
            value = value.toString().replace(this.currencySymbol + ' ', '');
            
            value = this.useThousandSeparator ? value.replace(new RegExp('[' + this.thousandSeparator + ']', 'g'), '') : value;
            
            return value;
        }
    },
    /**
     * Remove the format before validating the the value.
     * @param {Number} value
     */
    getErrors: function(value){
        return Ext.ux.form.NumericField.superclass.getErrors.call(this, this.removeFormat(value));
    },
    hasFormat: function(){
        return this.decimalSeparator != '.' || (this.useThousandSeparator == true && this.getRawValue() != null) || !Ext.isEmpty(this.currencySymbol) || this.alwaysDisplayDecimals;
    },
    /**
     * Display the numeric value with the fixed decimal precision and without the format using the setRawValue, don't need to do a setValue because we don't want a double
     * formatting and process of the value because beforeBlur perform a getRawValue and then a setValue.
     */
    onFocus: function(){
        this.setRawValue(this.removeFormat(this.getRawValue()));
        
        this.callParent(arguments);
    }
});
/**
* Allows GroupTab to render a table structure.
*/
Ext.define('Ext.ux.GroupTabRenderer', {
    alias: 'plugin.grouptabrenderer',
    extend: 'Ext.AbstractPlugin',

    tableTpl: new Ext.XTemplate(
        '<div id="{view.id}-body" class="' + Ext.baseCSSPrefix + '{view.id}-table ' + Ext.baseCSSPrefix + 'grid-table-resizer" style="{tableStyle}">',
            '{%',
                'values.view.renderRows(values.rows, values.viewStartIndex, out);',
            '%}',
        '</div>',
        {
            priority: 5
        }
    ),

    rowTpl: new Ext.XTemplate(
        '{%',
            'Ext.Array.remove(values.itemClasses, "', Ext.baseCSSPrefix + 'grid-row");',
            'var dataRowCls = values.recordIndex === -1 ? "" : " ' + Ext.baseCSSPrefix + 'grid-data-row";',
        '%}',
        '<div {[values.rowId ? ("id=\\"" + values.rowId + "\\"") : ""]} ',
            'data-boundView="{view.id}" ',
            'data-recordId="{record.internalId}" ',
            'data-recordIndex="{recordIndex}" ',
            'class="' + Ext.baseCSSPrefix + 'grouptab-row {[values.itemClasses.join(" ")]} {[values.rowClasses.join(" ")]}{[dataRowCls]}" ',
            '{rowAttr:attributes}>',
            '<tpl for="columns">' +
                '{%',
                    'parent.view.renderCell(values, parent.record, parent.recordIndex, parent.rowIndex, xindex - 1, out, parent)',
                 '%}',
            '</tpl>',
        '</div>',
        {
            priority: 5
        }
    ),

    cellTpl: new Ext.XTemplate(
        '{%values.tdCls = values.tdCls.replace(" ' + Ext.baseCSSPrefix + 'grid-cell "," ");%}',
        '<div class="' + Ext.baseCSSPrefix + 'grouptab-cell {tdCls}" {tdAttr}>',
            '<div {unselectableAttr} class="' + Ext.baseCSSPrefix + 'grid-cell-inner" style="text-align: {align}; {style};">{value}</div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-top-left"></div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-bottom-left"></div>',
        '</div>',
        {
            priority: 5
        }
    ),

    selectors: {
        // Outer table
        bodySelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // Element which contains rows
        nodeContainerSelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // row
        itemSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-row',

        // row which contains cells as opposed to wrapping rows
        dataRowSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-row',

        // cell
        cellSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-cell', 

        getCellSelector: function(header) {
            return header ? header.getCellSelector() : this.cellSelector; 
        }

    },

    init: function(grid) {
        var view = grid.getView(), 
            me = this;
        view.addTableTpl(me.tableTpl);
        view.addRowTpl(me.rowTpl);
        view.addCellTpl(me.cellTpl);
        Ext.apply(view, me.selectors);
    }
});



/**
 * @author Nicolas Ferrero
 * A TabPanel with grouping support.
 */
Ext.define('Ext.ux.GroupTabPanel', {
    extend: 'Ext.Container',

    alias: 'widget.grouptabpanel',

    requires:[
        'Ext.tree.Panel',
        'Ext.ux.GroupTabRenderer'
    ],

    baseCls : Ext.baseCSSPrefix + 'grouptabpanel',

    initComponent: function(config) {
        var me = this;

        Ext.apply(me, config);

        // Processes items to create the TreeStore and also set up
        // "this.cards" containing the actual card items.
        me.store = me.createTreeStore();

        me.layout = {
            type: 'hbox',
            align: 'stretch'
        };
        me.defaults = {
            border: false
        };

        me.items = [{
            xtype: 'treepanel',
            cls: 'x-tree-panel x-grouptabbar',
            width: 150,
            rootVisible: false,
            store: me.store,
            hideHeaders: true,
            animate: false,
            processEvent: Ext.emptyFn,
            border: false,
            plugins: [{
                ptype: 'grouptabrenderer'
            }],
            viewConfig: {
                overItemCls: '',
                getRowClass: me.getRowClass
            },
            columns: [{
                xtype: 'treecolumn',
                sortable: false,
                dataIndex: 'text',
                flex: 1,
                renderer: function (value, cell, node, idx1, idx2, store, tree) {
                    var cls = '';

                    if (node.parentNode && node.parentNode.parentNode === null) {
                        cls += ' x-grouptab-first';
                        if (node.previousSibling) {
                            cls += ' x-grouptab-prev';
                        }
                        if (!node.get('expanded') || node.firstChild == null) {
                            cls += ' x-grouptab-last';
                        }
                    } else if (node.nextSibling === null) {
                        cls += ' x-grouptab-last';
                    } else {
                        cls += ' x-grouptab-center';
                    }
                    if (node.data.activeTab) {
                        cls += ' x-active-tab';
                    }
                    cell.tdCls= 'x-grouptab'+ cls;

                    return value;
                }
             }]
        }, {
            xtype: 'container',
            flex: 1,
            layout: 'card',
            activeItem: me.mainItem,
            baseCls: Ext.baseCSSPrefix + 'grouptabcontainer',
            items: me.cards
        }];

        me.addEvents(
            /**
             * @event beforetabchange
             * Fires before a tab change (activated by {@link #setActiveTab}). Return false in any listener to cancel
             * the tabchange
             * @param {Ext.ux.GroupTabPanel} grouptabPanel The GroupTabPanel
             * @param {Ext.Component} newCard The card that is about to be activated
             * @param {Ext.Component} oldCard The card that is currently active
             */
            'beforetabchange',

            /**
             * @event tabchange
             * Fires when a new tab has been activated (activated by {@link #setActiveTab}).
             * @param {Ext.ux.GroupTabPanel} grouptabPanel The GroupTabPanel
             * @param {Ext.Component} newCard The newly activated item
             * @param {Ext.Component} oldCard The previously active item
             */
            'tabchange',

            /**
             * @event beforegroupchange
             * Fires before a group change (activated by {@link #setActiveGroup}). Return false in any listener to cancel
             * the groupchange
             * @param {Ext.ux.GroupTabPanel} grouptabPanel The GroupTabPanel
             * @param {Ext.Component} newGroup The root group card that is about to be activated
             * @param {Ext.Component} oldGroup The root group card that is currently active
             */
            'beforegroupchange',

            /**
             * @event groupchange
             * Fires when a new group has been activated (activated by {@link #setActiveGroup}).
             * @param {Ext.ux.GroupTabPanel} grouptabPanel The GroupTabPanel
             * @param {Ext.Component} newGroup The newly activated root group item
             * @param {Ext.Component} oldGroup The previously active root group item
             */
            'groupchange'
        );

        me.callParent(arguments);
        me.setActiveTab(me.activeTab);
        me.setActiveGroup(me.activeGroup);
        me.mon(me.down('treepanel').getSelectionModel(), 'select', me.onNodeSelect, me);
    },

    getRowClass: function(node, rowIndex, rowParams, store) {
        var cls = '';
        if (node.data.activeGroup) {
           cls += ' x-active-group';
        }
        return cls;
    },

    /**
     * @private
     * Node selection listener.
     */
    onNodeSelect: function (selModel, node) {
        var me = this,
            currentNode = me.store.getRootNode(),
            parent;

        if (node.parentNode && node.parentNode.parentNode === null) {
            parent = node;
        } else {
            parent = node.parentNode;
        }

        if (me.setActiveGroup(parent.get('id')) === false || me.setActiveTab(node.get('id')) === false) {
            return false;
        }

        while (currentNode) {
            currentNode.set('activeTab', false);
            currentNode.set('activeGroup', false);
            currentNode = currentNode.firstChild || currentNode.nextSibling || currentNode.parentNode.nextSibling;
        }

        parent.set('activeGroup', true);
        parent.eachChild(function(child) {
            child.set('activeGroup', true);
        });
        node.set('activeTab', true);
        selModel.view.refresh();
    },

    /**
     * Makes the given component active (makes it the visible card in the GroupTabPanel's CardLayout)
     * @param {Ext.Component} cmp The component to make active
     */
    setActiveTab: function(cmp) {
        var me = this,
            newTab = cmp,
            oldTab;

        if(Ext.isString(cmp)) {
            newTab = Ext.getCmp(newTab);
        }

        if (newTab === me.activeTab) {
            return false;
        }

        oldTab = me.activeTab;
        if (me.fireEvent('beforetabchange', me, newTab, oldTab) !== false) {
             me.activeTab = newTab;
             if (me.rendered) {
                 me.down('container[baseCls=' + Ext.baseCSSPrefix + 'grouptabcontainer' + ']').getLayout().setActiveItem(newTab);
             }
             me.fireEvent('tabchange', me, newTab, oldTab);
         }
         return true;
    },

    /**
     * Makes the given group active
     * @param {Ext.Component} cmp The root component to make active.
     */
    setActiveGroup: function(cmp) {
        var me = this,
            newGroup = cmp,
            oldGroup;

        if(Ext.isString(cmp)) {
            newGroup = Ext.getCmp(newGroup);
        }

        if (newGroup === me.activeGroup) {
            return true;
        }

        oldGroup = me.activeGroup;
        if (me.fireEvent('beforegroupchange', me, newGroup, oldGroup) !== false) {
             me.activeGroup = newGroup;
             me.fireEvent('groupchange', me, newGroup, oldGroup);
         } else {
             return false;
         }
         return true;
    },

    /**
     * @private
     * Creates the TreeStore used by the GroupTabBar.
     */
    createTreeStore: function() {
        var me = this,
            groups = me.prepareItems(me.items),
            data = {
                text: '.',
                children: []
            },
            cards = me.cards = [];
        me.activeGroup = me.activeGroup || 0;
        
        Ext.each(groups, function(groupItem, idx) {
            var leafItems = groupItem.items.items,
                rootItem = (leafItems[groupItem.mainItem] || leafItems[0]),
                groupRoot = {
                    children: []
                };

            // Create the root node of the group
            groupRoot.id = rootItem.id;
            groupRoot.text = rootItem.title;
            groupRoot.iconCls = rootItem.iconCls;

            groupRoot.expanded = true;
            groupRoot.activeGroup = (me.activeGroup === idx);
            groupRoot.activeTab = groupRoot.activeGroup ? true : false;
            if (groupRoot.activeTab) {
                me.activeTab = groupRoot.id;
            }

            if (groupRoot.activeGroup) {
                me.mainItem = groupItem.mainItem || 0;
                me.activeGroup = groupRoot.id;
            }

            Ext.each(leafItems, function(leafItem) {
                // First node has been done
                if (leafItem.id !== groupRoot.id) {
                    var child = {
                        id: leafItem.id,
                        leaf: true,
                        text: leafItem.title,
                        iconCls: leafItem.iconCls,
                        activeGroup: groupRoot.activeGroup,
                        activeTab: false
                    };
                    groupRoot.children.push(child);
                }

                // Ensure the items do not get headers
                delete leafItem.title;
                delete leafItem.iconCls;
                cards.push(leafItem);
            });

            data.children.push(groupRoot);
      });

       return Ext.create('Ext.data.TreeStore', {
            fields: ['id', 'text', 'activeGroup', 'activeTab'],
            root: {
                expanded: true
            },
            proxy: {
                type: 'memory',
                data: data
            }
        });
    },

    /**
     * Returns the item that is currently active inside this GroupTabPanel.
     * @return {Ext.Component/Number} The currently active item
     */
    getActiveTab: function() {
        return this.activeTab;
    },

    /**
     * Returns the root group item that is currently active inside this GroupTabPanel.
     * @return {Ext.Component/Number} The currently active root group item
     */
    getActiveGroup: function() {
        return this.activeGroup;
    }
});
/**
 * FiltersFeature is a grid {@link Ext.grid.feature.Feature feature} that allows for a slightly more
 * robust representation of filtering than what is provided by the default store.
 *
 * Filtering is adjusted by the user using the grid's column header menu (this menu can be
 * disabled through configuration). Through this menu users can configure, enable, and
 * disable filters for each column.
 *
 * #Features#
 *
 * ##Filtering implementations:##
 *
 * Default filtering for Strings, Numeric Ranges, Date Ranges, Lists (which can be backed by a
 * {@link Ext.data.Store}), and Boolean. Additional custom filter types and menus are easily
 * created by extending {@link Ext.ux.grid.filter.Filter}.
 *
 * ##Graphical Indicators:##
 *
 * Columns that are filtered have {@link #filterCls a configurable css class} applied to the column headers.
 *
 * ##Automatic Reconfiguration:##
 *
 * Filters automatically reconfigure when the grid 'reconfigure' event fires.
 *
 * ##Stateful:##
 *
 * Filter information will be persisted across page loads by specifying a `stateId`
 * in the Grid configuration.
 *
 * The filter collection binds to the {@link Ext.grid.Panel#beforestaterestore beforestaterestore}
 * and {@link Ext.grid.Panel#beforestatesave beforestatesave} events in order to be stateful.
 *
 * ##GridPanel Changes:##
 *
 * - A `filters` property is added to the GridPanel using this feature.
 * - A `filterupdate` event is added to the GridPanel and is fired upon onStateChange completion.
 *
 * ##Server side code examples:##
 *
 * - [PHP](http://www.vinylfox.com/extjs/grid-filter-php-backend-code.php) - (Thanks VinylFox)
 * - [Ruby on Rails](http://extjs.com/forum/showthread.php?p=77326#post77326) - (Thanks Zyclops)
 * - [Ruby on Rails](http://extjs.com/forum/showthread.php?p=176596#post176596) - (Thanks Rotomaul)
 *
 * #Example usage:#
 *
 *     var store = Ext.create('Ext.data.Store', {
 *         pageSize: 15
 *         ...
 *     });
 *
 *     var filtersCfg = {
 *         ftype: 'filters',
 *         autoReload: false, //don't reload automatically
 *         local: true, //only filter locally
 *         // filters may be configured through the plugin,
 *         // or in the column definition within the headers configuration
 *         filters: [{
 *             type: 'numeric',
 *             dataIndex: 'id'
 *         }, {
 *             type: 'string',
 *             dataIndex: 'name'
 *         }, {
 *             type: 'numeric',
 *             dataIndex: 'price'
 *         }, {
 *             type: 'date',
 *             dataIndex: 'dateAdded'
 *         }, {
 *             type: 'list',
 *             dataIndex: 'size',
 *             options: ['extra small', 'small', 'medium', 'large', 'extra large'],
 *             phpMode: true
 *         }, {
 *             type: 'boolean',
 *             dataIndex: 'visible'
 *         }]
 *     };
 *
 *     var grid = Ext.create('Ext.grid.Panel', {
 *          store: store,
 *          columns: ...,
 *          features: [filtersCfg],
 *          height: 400,
 *          width: 700,
 *          bbar: Ext.create('Ext.PagingToolbar', {
 *              store: store
 *          })
 *     });
 *
 *     // a filters property is added to the GridPanel
 *     grid.filters
 */
Ext.define('Ext.ux.grid.FiltersFeature', {
    extend: 'Ext.grid.feature.Feature',
    alias: 'feature.filters',
    uses: [
        'Ext.ux.grid.menu.ListMenu',
        'Ext.ux.grid.menu.RangeMenu',
        'Ext.ux.grid.filter.BooleanFilter',
        'Ext.ux.grid.filter.DateFilter',
        'Ext.ux.grid.filter.DateTimeFilter',
        //'Ext.ux.grid.filter.ListFilter',
        'Unilite.com.grid.filter.UniListFilter',
        'Ext.ux.grid.filter.NumericFilter',
        'Ext.ux.grid.filter.StringFilter'
    ],

    /**
     * @cfg {Boolean} autoReload
     * Defaults to true, reloading the datasource when a filter change happens.
     * Set this to false to prevent the datastore from being reloaded if there
     * are changes to the filters.  See <code>{@link #updateBuffer}</code>.
     */
    autoReload : true,
    /**
     * @cfg {Boolean} encode
     * Specify true for {@link #buildQuery} to use Ext.util.JSON.encode to
     * encode the filter query parameter sent with a remote request.
     * Defaults to false.
     */
    /**
     * @cfg {Array} filters
     * An Array of filters config objects. Refer to each filter type class for
     * configuration details specific to each filter type. Filters for Strings,
     * Numeric Ranges, Date Ranges, Lists, and Boolean are the standard filters
     * available.
     */
    /**
     * @cfg {String} filterCls
     * The css class to be applied to column headers with active filters.
     * Defaults to <tt>'ux-filterd-column'</tt>.
     */
    filterCls : 'ux-filtered-column',
    /**
     * @cfg {Boolean} local
     * <tt>true</tt> to use Ext.data.Store filter functions (local filtering)
     * instead of the default (<tt>false</tt>) server side filtering.
     */
    local : false,
    /**
     * @cfg {String} menuFilterText
     * defaults to <tt>'Filters'</tt>.
     */
    menuFilterText : 'Filters',
    /**
     * @cfg {String} paramPrefix
     * The url parameter prefix for the filters.
     * Defaults to <tt>'filter'</tt>.
     */
    paramPrefix : 'filter',
    /**
     * @cfg {Boolean} showMenu
     * Defaults to true, including a filter submenu in the default header menu.
     */
    showMenu : true,
    /**
     * @cfg {String} stateId
     * Name of the value to be used to store state information.
     */
    stateId : undefined,
    /**
     * @cfg {Number} updateBuffer
     * Number of milliseconds to defer store updates since the last filter change.
     */
    updateBuffer : 500,

    // doesn't handle grid body events
    hasFeatureEvent: false,


    /** @private */
    constructor : function (config) {
        var me = this;

        me.callParent(arguments);

        me.deferredUpdate = Ext.create('Ext.util.DelayedTask', me.reload, me);

        // Init filters
        me.filters = me.createFiltersCollection();
        me.filterConfigs = config.filters;
    },

    init: function(grid) {
        var me = this,
            view = me.view,
            headerCt = view.headerCt;

        me.bindStore(view.getStore(), true);

        // Listen for header menu being created
        headerCt.on('menucreate', me.onMenuCreate, me);

        view.on('refresh', me.onRefresh, me);
        grid.on({
            scope: me,
            beforestaterestore: me.applyState,
            beforestatesave: me.saveState,
            beforedestroy: me.destroy
        });

        // Add event and filters shortcut on grid panel
        grid.filters = me;
        grid.addEvents('filterupdate');
    },

    createFiltersCollection: function () {
        return Ext.create('Ext.util.MixedCollection', false, function (o) {
            return o ? o.dataIndex : null;
        });
    },

    /**
     * @private Create the Filter objects for the current configuration, destroying any existing ones first.
     */
    createFilters: function() {
        var me = this,
            hadFilters = me.filters.getCount(),
            grid = me.getGridPanel(),
            filters = me.createFiltersCollection(),
            model = grid.store.model,
            fields = model.prototype.fields,
            field,
            filter,
            state;

        if (hadFilters) {
            state = {};
            me.saveState(null, state);
        }

        function add (dataIndex, config, filterable) {
            if (dataIndex && (filterable || config)) {
                field = fields.get(dataIndex);
                filter = {
                    dataIndex: dataIndex,
                    type: (field && field.type && field.type.type) || 'auto'
                };

                if (Ext.isObject(config)) {
                    Ext.apply(filter, config);
                }

                filters.replace(filter);
            }
        }

        // We start with filters from our config
        Ext.Array.each(me.filterConfigs, function (filterConfig) {
            add(filterConfig.dataIndex, filterConfig);
        });

        // Then we merge on filters from the columns in the grid. The columns' filters take precedence.
        Ext.Array.each(grid.columnManager.getColumns(), function (column) {
            if (column.filterable === false) {
                filters.removeAtKey(column.dataIndex);
            } else {
                add(column.dataIndex, column.filter, column.filterable);
            }
        });
        

        me.removeAll();
        if (filters.items) {
            me.initializeFilters(filters.items);
        }

        if (hadFilters) {
            me.applyState(null, state);
        }
    },

    /**
     * @private
     */
    initializeFilters: function(filters) {
        var me = this,
            filtersLength = filters.length,
            i, filter, FilterClass;

        for (i = 0; i < filtersLength; i++) {
            filter = filters[i];
            if (filter) {
                FilterClass = me.getFilterClass(filter.type);
                filter = filter.menu ? filter : new FilterClass(Ext.apply({
                    grid: me.grid
                }, filter));
                me.filters.add(filter);
                Ext.util.Observable.capture(filter, this.onStateChange, this);
            }
        }
    },

    /**
     * @private Handle creation of the grid's header menu. Initializes the filters and listens
     * for the menu being shown.
     */
    onMenuCreate: function(headerCt, menu) {
        var me = this;
        me.createFilters();
        menu.on('beforeshow', me.onMenuBeforeShow, me);
    },

    /**
     * @private Handle showing of the grid's header menu. Sets up the filter item and menu
     * appropriate for the target column.
     */
    onMenuBeforeShow: function(menu) {
        var me = this,
            menuItem, filter;

        if (me.showMenu) {
            menuItem = me.menuItem;
            if (!menuItem || menuItem.isDestroyed) {
                me.createMenuItem(menu);
                menuItem = me.menuItem;
            }

            filter = me.getMenuFilter();

            if (filter) {
                menuItem.setMenu(filter.menu, false);
                menuItem.setChecked(filter.active);
                // disable the menu if filter.disabled explicitly set to true
                menuItem.setDisabled(filter.disabled === true);
            }
            menuItem.setVisible(!!filter);
            this.sep.setVisible(!!filter);
        }
    },


    createMenuItem: function(menu) {
        var me = this;
        me.sep  = menu.add('-');
        me.menuItem = menu.add({
            checked: false,
            itemId: 'filters',
            text: me.menuFilterText,
            listeners: {
                scope: me,
                checkchange: me.onCheckChange,
                beforecheckchange: me.onBeforeCheck
            }
        });
    },

    getGridPanel: function() {
        return this.view.up('gridpanel');
    },

    /**
     * @private
     * Handler for the grid's beforestaterestore event (fires before the state of the
     * grid is restored).
     * @param {Object} grid The grid object
     * @param {Object} state The hash of state values returned from the StateProvider.
     */
    applyState : function (grid, state) {
        var me = this,
            key, filter;
        me.applyingState = true;
        me.clearFilters();
        if (state.filters) {
            for (key in state.filters) {
                if (state.filters.hasOwnProperty(key)) {
                    filter = me.filters.get(key);
                    if (filter) {
                        filter.setValue(state.filters[key]);
                        filter.setActive(true);
                    }
                }
            }
        }
        me.deferredUpdate.cancel();
        if (me.local) {
            me.reload();
        }
        delete me.applyingState;
        delete state.filters;
    },

    /**
     * Saves the state of all active filters
     * @param {Object} grid
     * @param {Object} state
     * @return {Boolean}
     */
    saveState : function (grid, state) {
        var filters = {};
        this.filters.each(function (filter) {
            if (filter.active) {
                filters[filter.dataIndex] = filter.getValue();
            }
        });
        return (state.filters = filters);
    },

    /**
     * @private
     * Handler called by the grid 'beforedestroy' event
     */
    destroy : function () {
        var me = this;
        Ext.destroyMembers(me, 'menuItem', 'sep');
        me.removeAll();
        me.clearListeners();
    },

    /**
     * Remove all filters, permanently destroying them.
     */
    removeAll : function () {
        if(this.filters){
            Ext.destroy.apply(Ext, this.filters.items);
            // remove all items from the collection
            this.filters.clear();
        }
    },


    /**
     * Changes the data store bound to this view and refreshes it.
     * @param {Ext.data.Store} store The store to bind to this view
     */
    bindStore : function(store) {
        var me = this;

        // Unbind from the old Store
        if (me.store && me.storeListeners) {
            me.store.un(me.storeListeners);
        }

        // Set up correct listeners
        if (store) {
            me.storeListeners = {
                scope: me
            };
            if (me.local) {
                me.storeListeners.load = me.onLoad;
            } else {
                me.storeListeners['before' + (store.buffered ? 'prefetch' : 'load')] = me.onBeforeLoad;
            }
            store.on(me.storeListeners);
        } else {
            delete me.storeListeners;
        }
        me.store = store;
    },

    /**
     * @private
     * Get the filter menu from the filters MixedCollection based on the clicked header
     */
    getMenuFilter : function () {
        var header = this.view.headerCt.getMenu().activeHeader;
        return header ? this.filters.get(header.dataIndex) : null;
    },

    /** @private */
    onCheckChange : function (item, value) {
        this.getMenuFilter().setActive(value);
    },

    /** @private */
    onBeforeCheck : function (check, value) {
        return !value || this.getMenuFilter().isActivatable();
    },

    /**
     * @private
     * Handler for all events on filters.
     * @param {String} event Event name
     * @param {Object} filter Standard signature of the event before the event is fired
     */
    onStateChange : function (event, filter) {
        if (event !== 'serialize') {
            var me = this,
                grid = me.getGridPanel();

            if (filter == me.getMenuFilter()) {
                me.menuItem.setChecked(filter.active, false);
            }

            if ((me.autoReload || me.local) && !me.applyingState) {
                me.deferredUpdate.delay(me.updateBuffer);
            }
            me.updateColumnHeadings();

            if (!me.applyingState) {
                grid.saveState();
            }
            grid.fireEvent('filterupdate', me, filter);
        }
    },

    /**
     * @private
     * Handler for store's beforeload event when configured for remote filtering
     * @param {Object} store
     * @param {Object} options
     */
    onBeforeLoad : function (store, options) {
        options.params = options.params || {};
        this.cleanParams(options.params);
        var params = this.buildQuery(this.getFilterData());
        Ext.apply(options.params, params);
    },

    /**
     * @private
     * Handler for store's load event when configured for local filtering
     * @param {Object} store
     */
    onLoad : function (store) {
        store.filterBy(this.getRecordFilter());
    },

    /**
     * @private
     * Handler called when the grid's view is refreshed
     */
    onRefresh : function () {
        this.updateColumnHeadings();
    },

    /**
     * Update the styles for the header row based on the active filters
     */
    updateColumnHeadings : function () {
        var me = this,
            headerCt = me.view.headerCt;
        if (headerCt) {
            headerCt.items.each(function(header) {
                var filter = me.getFilter(header.dataIndex);
                header[filter && filter.active ? 'addCls' : 'removeCls'](me.filterCls);
            });
        }
    },

    /** @private */
    reload : function () {
        var me = this,
            store = me.view.getStore();

        if (me.local) {
            store.clearFilter(true);
            store.filterBy(me.getRecordFilter());
            store.sort();
        } else {
            me.deferredUpdate.cancel();
            if (store.buffered) {
                store.data.clear();
            }
            store.loadPage(1);
        }
    },

    /**
     * Method factory that generates a record validator for the filters active at the time
     * of invokation.
     * @private
     */
    getRecordFilter : function () {
        var f = [], len, i,
            lockingPartner = this.lockingPartner;

        this.filters.each(function (filter) {
            if (filter.active) {
                f.push(filter);
            }
        });

        // Be sure to check the active filters on a locking partner as well.
        if (lockingPartner) {
            lockingPartner.filters.each(function (filter) {
                if (filter.active) {
                    f.push(filter);
                }
            });
        }

        len = f.length;
        return function (record) {
            for (i = 0; i < len; i++) {
                if (!f[i].validateRecord(record)) {
                    return false;
                }
            }
            return true;
        };
    },

    /**
     * Adds a filter to the collection and observes it for state change.
     * @param {Object/Ext.ux.grid.filter.Filter} config A filter configuration or a filter object.
     * @return {Ext.ux.grid.filter.Filter} The existing or newly created filter object.
     */
    addFilter : function (config) {
        var me = this,
            columns = me.getGridPanel().columnManager.getColumns(),
            i, columnsLength, column, filtersLength, filter;

        
        for (i = 0, columnsLength = columns.length; i < columnsLength; i++) {
            column = columns[i];
            if (column.dataIndex === config.dataIndex) {
                column.filter = config;
            }
        }
        
        if (me.view.headerCt.menu) {
            me.createFilters();
        } else {
            // Call getMenu() to ensure the menu is created, and so, also are the filters. We cannot call
            // createFilters() withouth having a menu because it will cause in a recursion to applyState()
            // that ends up to clear all the filter values. This is likely to happen when we reorder a column
            // and then add a new filter before the menu is recreated.
            me.view.headerCt.getMenu();
        }
        
        for (i = 0, filtersLength = me.filters.items.length; i < filtersLength; i++) {
            filter = me.filters.items[i];
            if (filter.dataIndex === config.dataIndex) {
                return filter;
            }
        }
    },

    /**
     * Adds filters to the collection.
     * @param {Array} filters An Array of filter configuration objects.
     */
    addFilters : function (filters) {
        if (filters) {
            var me = this,
                i, filtersLength;
            for (i = 0, filtersLength = filters.length; i < filtersLength; i++) {
                me.addFilter(filters[i]);
            }
        }
    },

    /**
     * Returns a filter for the given dataIndex, if one exists.
     * @param {String} dataIndex The dataIndex of the desired filter object.
     * @return {Ext.ux.grid.filter.Filter}
     */
    getFilter : function (dataIndex) {
        return this.filters.get(dataIndex);
    },

    /**
     * Turns all filters off. This does not clear the configuration information
     * (see {@link #removeAll}).
     */
    clearFilters : function () {
        this.filters.each(function (filter) {
            filter.setActive(false);
        });
    },

    getFilterItems: function () {
        var me = this;

        // If there's a locked grid then we must get the filter items for each grid.
        if (me.lockingPartner) {
            return me.filters.items.concat(me.lockingPartner.filters.items);
        }

        return me.filters.items;
    },

    /**
     * Returns an Array of the currently active filters.
     * @return {Array} filters Array of the currently active filters.
     */
    getFilterData : function () {
        var items = this.getFilterItems(),
            filters = [],
            n, nlen, item, d, i, len;

        for (n = 0, nlen = items.length; n < nlen; n++) {
            item = items[n];
            if (item.active) {
                d = [].concat(item.serialize());
                for (i = 0, len = d.length; i < len; i++) {
                    filters.push({
                        field: item.dataIndex,
                        data: d[i]
                    });
                }
            }
        }
        return filters;
    },

    /**
     * Function to take the active filters data and build it into a query.
     * The format of the query depends on the {@link #encode} configuration:
     *
     *   - `false` (Default) :
     *     Flatten into query string of the form (assuming <code>{@link #paramPrefix}='filters'</code>:
     *
     *         filters[0][field]="someDataIndex"&
     *         filters[0][data][comparison]="someValue1"&
     *         filters[0][data][type]="someValue2"&
     *         filters[0][data][value]="someValue3"&
     *
     *
     *   - `true` :
     *     JSON encode the filter data
     *
     *         {filters:[{"field":"someDataIndex","comparison":"someValue1","type":"someValue2","value":"someValue3"}]}
     *
     * Override this method to customize the format of the filter query for remote requests.
     *
     * @param {Array} filters A collection of objects representing active filters and their configuration.
     * Each element will take the form of {field: dataIndex, data: filterConf}. dataIndex is not assured
     * to be unique as any one filter may be a composite of more basic filters for the same dataIndex.
     *
     * @return {Object} Query keys and values
     */
    buildQuery : function (filters) {
        var p = {}, i, f, root, dataPrefix, key, tmp,
            len = filters.length;

        if (!this.encode){
            for (i = 0; i < len; i++) {
                f = filters[i];
                root = [this.paramPrefix, '[', i, ']'].join('');
                p[root + '[field]'] = f.field;

                dataPrefix = root + '[data]';
                for (key in f.data) {
                    p[[dataPrefix, '[', key, ']'].join('')] = f.data[key];
                }
            }
        } else {
            tmp = [];
            for (i = 0; i < len; i++) {
                f = filters[i];
                tmp.push(Ext.apply(
                    {},
                    {field: f.field},
                    f.data
                ));
            }
            // only build if there is active filter
            if (tmp.length > 0){
                p[this.paramPrefix] = Ext.JSON.encode(tmp);
            }
        }
        return p;
    },

    /**
     * Removes filter related query parameters from the provided object.
     * @param {Object} p Query parameters that may contain filter related fields.
     */
    cleanParams : function (p) {
        // if encoding just delete the property
        if (this.encode) {
            delete p[this.paramPrefix];
        // otherwise scrub the object of filter data
        } else {
            var regex, key;
            regex = new RegExp('^' + this.paramPrefix + '\[[0-9]+\]');
            for (key in p) {
                if (regex.test(key)) {
                    delete p[key];
                }
            }
        }
    },

    /**
     * Function for locating filter classes, overwrite this with your favorite
     * loader to provide dynamic filter loading.
     * @param {String} type The type of filter to load ('Filter' is automatically
     * appended to the passed type; eg, 'string' becomes 'StringFilter').
     * @return {Function} The Ext.ux.grid.filter.Class
     */
    getFilterClass : function (type) {
        // map the supported Ext.data.Field type values into a supported filter
        switch(type) {
            case 'auto':
              type = 'string';
              break;
            case 'int':
            case 'float':
              type = 'numeric';
              break;
            case 'bool':
              type = 'boolean';
              break;
        }
        return Ext.ClassManager.getByAlias('gridfilter.' + type);
    }
});
/**
 * This is a supporting class for {@link Ext.ux.grid.filter.ListFilter}.
 * Although not listed as configuration options for this class, this class
 * also accepts all configuration options from {@link Ext.ux.grid.filter.ListFilter}.
 */
Ext.define('Ext.ux.grid.menu.ListMenu', {
    extend: 'Ext.menu.Menu',
    
    /**
     * @cfg {String} idField
     * Defaults to 'id'.
     */
    idField :  'id',

    /**
     * @cfg {String} labelField
     * Defaults to 'text'.
     */
    labelField :  'text',
    /**
     * @cfg {String} paramPrefix
     * Defaults to 'Loading...'.
     */
    loadingText : 'Loading...',
    /**
     * @cfg {Boolean} loadOnShow
     * Defaults to true.
     */
    loadOnShow : true,
    /**
     * @cfg {Boolean} single
     * Specify true to group all items in this list into a single-select
     * radio button group. Defaults to false.
     */
    single : false,

    plain: true,

    constructor : function (cfg) {
        var me = this,
            options,
            i,
            len,
            value;
            
        me.selected = [];
        me.addEvents(
            /**
             * @event checkchange
             * Fires when there is a change in checked items from this list
             * @param {Object} item Ext.menu.CheckItem
             * @param {Object} checked The checked value that was set
             */
            'checkchange'
        );

        me.callParent(arguments);

        // A ListMenu which is completely unconfigured acquires its store from the unique values of its field in the store
        if (!me.store && !me.options) {
            me.options = me.grid.store.collect(me.dataIndex, false, true);
        }

        if (!me.store && me.options) {
            options = [];
            for(i = 0, len = me.options.length; i < len; i++) {
                value = me.options[i];
                switch (Ext.type(value)) {
                    case 'array': 
                        options.push(value);
                        break;
                    case 'object':
                        options.push([value[me.idField], value[me.labelField]]);
                        break;
                    default:
                        if (value != null) {
                            options.push([value, value]);
                        }
                }
            }

            me.store = Ext.create('Ext.data.ArrayStore', {
                fields: [me.idField, me.labelField],
                data:   options,
                listeners: {
                    load: me.onLoad,
                    scope:  me
                }
            });
            me.loaded = true;
            me.autoStore = true;
        } else {
            me.add({
                text: me.loadingText,
                iconCls: 'loading-indicator'
            });
            me.store.on('load', me.onLoad, me);
        }
    },

    destroy : function () {
        var me = this,
            store = me.store;
            
        if (store) {
            if (me.autoStore) {
                store.destroyStore();
            } else {
                store.un('unload', me.onLoad, me);
            }
        }
        me.callParent();
    },

    /**
     * Lists will initially show a 'loading' item while the data is retrieved from the store.
     * In some cases the loaded data will result in a list that goes off the screen to the
     * right (as placement calculations were done with the loading item). This adapter will
     * allow show to be called with no arguments to show with the previous arguments and
     * thus recalculate the width and potentially hang the menu from the left.
     */
    show : function () {
        var me = this;
        if (me.loadOnShow && !me.loaded && !me.store.loading) {
            me.store.load();
        }
        me.callParent();
    },

    /** @private */
    onLoad : function (store, records) {
        var me = this,
            gid, itemValue, i, len,
            listeners = {
                checkchange: me.checkChange,
                scope: me
            };

        Ext.suspendLayouts();
        me.removeAll(true);
        gid = me.single ? Ext.id() : null;
        for (i = 0, len = records.length; i < len; i++) {
            itemValue = records[i].get(me.idField);
            me.add(Ext.create('Ext.menu.CheckItem', {
                text: records[i].get(me.labelField),
                group: gid,
                checked: Ext.Array.contains(me.selected, itemValue),
                hideOnClick: false,
                value: itemValue,
                listeners: listeners
            }));
        }

        me.loaded = true;
        Ext.resumeLayouts(true);
        me.fireEvent('load', me, records);
    },

    /**
     * Get the selected items.
     * @return {Array} selected
     */
    getSelected : function () {
        return this.selected;
    },

    /** @private */
    setSelected : function (value) {
        value = this.selected = [].concat(value);

        if (this.loaded) {
            this.items.each(function(item){
                item.setChecked(false, true);
                for (var i = 0, len = value.length; i < len; i++) {
                    if (item.value == value[i]) {
                        item.setChecked(true, true);
                    }
                }
            });
        }
    },

    /**
     * Handler for the 'checkchange' event from an check item in this menu
     * @param {Object} item Ext.menu.CheckItem
     * @param {Object} checked The checked value that was set
     */
    checkChange : function (item, checked) {
        var value = [];
        this.items.each(function(item){
            if (item.checked) {
                value.push(item.value);
            }
        });
        this.selected = value;

        this.fireEvent('checkchange', item, checked);
    }
});
/**
 * Custom implementation of {@link Ext.menu.Menu} that has preconfigured items for entering numeric
 * range comparison values: less-than, greater-than, and equal-to. This is used internally
 * by {@link Ext.ux.grid.filter.NumericFilter} to create its menu.
 */
Ext.define('Ext.ux.grid.menu.RangeMenu', {
    extend: 'Ext.menu.Menu',

    /**
     * @cfg {String} fieldCls
     * The Class to use to construct each field item within this menu
     * Defaults to:<pre>
     * fieldCls : Ext.form.field.Number
     * </pre>
     */
    fieldCls : 'Ext.form.field.Number',

    /**
     * @cfg {Object} fieldCfg
     * The default configuration options for any field item unless superseded
     * by the <code>{@link #fields}</code> configuration.
     * Defaults to:<pre>
     * fieldCfg : {}
     * </pre>
     * Example usage:
     * <pre><code>
fieldCfg : {
    width: 150,
},
     * </code></pre>
     */

    /**
     * @cfg {Object} fields
     * The field items may be configured individually
     * Defaults to <tt>undefined</tt>.
     * Example usage:
     * <pre><code>
fields : {
    gt: { // override fieldCfg options
        width: 200,
        fieldCls: Ext.ux.form.CustomNumberField // to override default {@link #fieldCls}
    }
},
     * </code></pre>
     */

    /**
     * @cfg {Object} itemIconCls
     * The itemIconCls to be applied to each comparator field item.
     * Defaults to:<pre>
itemIconCls : {
    gt : 'ux-rangemenu-gt',
    lt : 'ux-rangemenu-lt',
    eq : 'ux-rangemenu-eq'
}
     * </pre>
     */
    itemIconCls : {
        gt : 'ux-rangemenu-gt',
        lt : 'ux-rangemenu-lt',
        eq : 'ux-rangemenu-eq'
    },

    /**
     * @cfg {Object} fieldLabels
     * Accessible label text for each comparator field item. Can be overridden by localization
     * files. Defaults to:<pre>
fieldLabels : {
     gt: 'Greater Than',
     lt: 'Less Than',
     eq: 'Equal To'
}</pre>
     */
    fieldLabels: {
        gt: 'Greater Than',
        lt: 'Less Than',
        eq: 'Equal To'
    },

    /**
     * @cfg {Object} menuItemCfgs
     * Default configuration options for each menu item
     * Defaults to:<pre>
menuItemCfgs : {
    emptyText: 'Enter Filter Text...',
    selectOnFocus: true,
    width: 125
}
     * </pre>
     */
    menuItemCfgs : {
        emptyText: 'Enter Number...',
        selectOnFocus: false,
        width: 155
    },

    /**
     * @cfg {Array} menuItems
     * The items to be shown in this menu.  Items are added to the menu
     * according to their position within this array. Defaults to:<pre>
     * menuItems : ['lt','gt','-','eq']
     * </pre>
     */
    menuItems : ['lt', 'gt', '-', 'eq'],

    plain: true,

    constructor : function (config) {
        var me = this,
            fields, fieldCfg, i, len, item, cfg, Cls;

        me.callParent(arguments);

        fields = me.fields = me.fields || {};
        fieldCfg = me.fieldCfg = me.fieldCfg || {};
        
        me.addEvents(
            /**
             * @event update
             * Fires when a filter configuration has changed
             * @param {Ext.ux.grid.filter.Filter} this The filter object.
             */
            'update'
        );
      
        me.updateTask = Ext.create('Ext.util.DelayedTask', me.fireUpdate, me);
    
        for (i = 0, len = me.menuItems.length; i < len; i++) {
            item = me.menuItems[i];
            if (item !== '-') {
                // defaults
                cfg = {
                    itemId: 'range-' + item,
                    enableKeyEvents: true,
                    hideEmptyLabel: false,
                    labelCls: 'ux-rangemenu-icon ' + me.itemIconCls[item],
                    labelSeparator: '',
                    labelWidth: 29,
                    listeners: {
                        scope: me,
                        change: me.onInputChange,
                        keyup: me.onInputKeyUp,
                        el: {
                            click: this.stopFn
                        }
                    },
                    activate: Ext.emptyFn,
                    deactivate: Ext.emptyFn
                };
                Ext.apply(
                    cfg,
                    // custom configs
                    Ext.applyIf(fields[item] || {}, fieldCfg[item]),
                    // configurable defaults
                    me.menuItemCfgs
                );
                Cls = cfg.fieldCls || me.fieldCls;
                item = fields[item] = Ext.create(Cls, cfg);
            }
            me.add(item);
        }
    },
    
    stopFn: function(e) {
        e.stopPropagation();
    },

    /**
     * @private
     * called by this.updateTask
     */
    fireUpdate : function () {
        this.fireEvent('update', this);
    },
    
    /**
     * Get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
        var result = {},
            fields = this.fields, 
            key, field;
            
        for (key in fields) {
            if (fields.hasOwnProperty(key)) {
                field = fields[key];
                if (field.isValid() && field.getValue() !== null) {
                    result[key] = field.getValue();
                }
            }
        }
        return result;
    },
  
    /**
     * Set the value of this menu and fires the 'update' event.
     * @param {Object} data The data to assign to this menu
     */	
    setValue : function (data) {
        var me = this,
            fields = me.fields,
            key,
            field;

        for (key in fields) {
            if (fields.hasOwnProperty(key)) {
                // Prevent field's change event from tiggering a Store filter. The final upate event will do that
                field =fields[key];
                field.suspendEvents();
                field.setValue(key in data ? data[key] : '');
                field.resumeEvents();
            }
        }

        // Trigger the filering of the Store
        me.fireEvent('update', me);
    },

    /**  
     * @private
     * Handler method called when there is a keyup event on an input
     * item of this menu.
     */
    onInputKeyUp: function(field, e) {
        if (e.getKey() === e.RETURN && field.isValid()) {
            e.stopEvent();
            this.hide();
        }
    },

    /**
     * @private
     * Handler method called when the user changes the value of one of the input
     * items in this menu.
     */
    onInputChange: function(field) {
        var me = this,
            fields = me.fields,
            eq = fields.eq,
            gt = fields.gt,
            lt = fields.lt;

        if (field == eq) {
            if (gt) {
                gt.setValue(null);
            }
            if (lt) {
                lt.setValue(null);
            }
        }
        else {
            eq.setValue(null);
        }

        // restart the timer
        this.updateTask.delay(this.updateBuffer);
    }
});
/**
 * Abstract base class for filter implementations.
 */
Ext.define('Ext.ux.grid.filter.Filter', {
    extend: 'Ext.util.Observable',

    /**
     * @cfg {Boolean} active
     * Indicates the initial status of the filter (defaults to false).
     */
    active : false,
    /**
     * True if this filter is active.  Use setActive() to alter after configuration.
     * @type Boolean
     * @property active
     */
    /**
     * @cfg {String} dataIndex
     * The {@link Ext.data.Store} dataIndex of the field this filter represents.
     * The dataIndex does not actually have to exist in the store.
     */
    dataIndex : null,
    /**
     * The filter configuration menu that will be installed into the filter submenu of a column menu.
     * @type Ext.menu.Menu
     * @property
     */
    menu : null,
    /**
     * @cfg {Number} updateBuffer
     * Number of milliseconds to wait after user interaction to fire an update. Only supported
     * by filters: 'list', 'numeric', and 'string'. Defaults to 500.
     */
    updateBuffer : 500,

    constructor : function (config) {
        Ext.apply(this, config);

        this.addEvents(
            /**
             * @event activate
             * Fires when an inactive filter becomes active
             * @param {Ext.ux.grid.filter.Filter} this
             */
            'activate',
            /**
             * @event deactivate
             * Fires when an active filter becomes inactive
             * @param {Ext.ux.grid.filter.Filter} this
             */
            'deactivate',
            /**
             * @event serialize
             * Fires after the serialization process. Use this to attach additional parameters to serialization
             * data before it is encoded and sent to the server.
             * @param {Array/Object} data A map or collection of maps representing the current filter configuration.
             * @param {Ext.ux.grid.filter.Filter} filter The filter being serialized.
             */
            'serialize',
            /**
             * @event update
             * Fires when a filter configuration has changed
             * @param {Ext.ux.grid.filter.Filter} this The filter object.
             */
            'update'
        );
        Ext.ux.grid.filter.Filter.superclass.constructor.call(this);

        this.menu = this.createMenu(config);
        this.init(config);
        if(config && config.value){
            this.setValue(config.value);
            this.setActive(config.active !== false, true);
            delete config.value;
        }
    },

    /**
     * Destroys this filter by purging any event listeners, and removing any menus.
     */
    destroy : function(){
        if (this.menu){
            this.menu.destroy();
        }
        this.clearListeners();
    },

    /**
     * Template method to be implemented by all subclasses that is to
     * initialize the filter and install required menu items.
     * Defaults to Ext.emptyFn.
     */
    init : Ext.emptyFn,

    /**
     * @private @override
     * Creates the Menu for this filter.
     * @param {Object} config Filter configuration
     * @return {Ext.menu.Menu}
     */
    createMenu: function(config) {
        config.plain = true;
        return Ext.create('Ext.menu.Menu', config);
    },

    /**
     * Template method to be implemented by all subclasses that is to
     * get and return the value of the filter.
     * Defaults to Ext.emptyFn.
     * @return {Object} The 'serialized' form of this filter
     * @template
     */
    getValue : Ext.emptyFn,

    /**
     * Template method to be implemented by all subclasses that is to
     * set the value of the filter and fire the 'update' event.
     * Defaults to Ext.emptyFn.
     * @param {Object} data The value to set the filter
     * @template
     */
    setValue : Ext.emptyFn,

    /**
     * Template method to be implemented by all subclasses that is to
     * return <tt>true</tt> if the filter has enough configuration information to be activated.
     * Defaults to <tt>return true</tt>.
     * @return {Boolean}
     */
    isActivatable : function(){
        return true;
    },

    /**
     * Template method to be implemented by all subclasses that is to
     * get and return serialized filter data for transmission to the server.
     * Defaults to Ext.emptyFn.
     */
    getSerialArgs : Ext.emptyFn,

    /**
     * Template method to be implemented by all subclasses that is to
     * validates the provided Ext.data.Record against the filters configuration.
     * Defaults to <tt>return true</tt>.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function(){
        return true;
    },

    /**
     * Returns the serialized filter data for transmission to the server
     * and fires the 'serialize' event.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    serialize : function(){
        var args = this.getSerialArgs();
        this.fireEvent('serialize', args, this);
        return args;
    },

    /** @private */
    fireUpdate : function(){
        if (this.active) {
            this.fireEvent('update', this);
        }
        this.setActive(this.isActivatable());
    },

    /**
     * Sets the status of the filter and fires the appropriate events.
     * @param {Boolean} active        The new filter state.
     * @param {Boolean} suppressEvent True to prevent events from being fired.
     */
    setActive : function(active, suppressEvent){
        if(this.active != active){
            this.active = active;
            if (suppressEvent !== true) {
                this.fireEvent(active ? 'activate' : 'deactivate', this);
            }
        }
    }
});
/**
 * Boolean filters use unique radio group IDs (so you can have more than one!)
 * <p><b><u>Example Usage:</u></b></p>
 * <pre><code>
var filters = Ext.create('Ext.ux.grid.GridFilters', {
    ...
    filters: [{
        // required configs
        type: 'boolean',
        dataIndex: 'visible'

        // optional configs
        defaultValue: null, // leave unselected (false selected by default)
        yesText: 'Yes',     // default
        noText: 'No'        // default
    }]
});
 * </code></pre>
 */
Ext.define('Ext.ux.grid.filter.BooleanFilter', {
    extend: 'Ext.ux.grid.filter.Filter',
    alias: 'gridfilter.boolean',

	/**
	 * @cfg {Boolean} defaultValue
	 * Set this to null if you do not want either option to be checked by default. Defaults to false.
	 */
	defaultValue : false,
	/**
	 * @cfg {String} yesText
	 * Defaults to 'Yes'.
	 */
	yesText : 'Yes',
	/**
	 * @cfg {String} noText
	 * Defaults to 'No'.
	 */
	noText : 'No',

    /**
     * @private
     * Template method that is to initialize the filter and install required menu items.
     */
    init : function (config) {
        var gId = Ext.id();
		this.options = [
			Ext.create('Ext.menu.CheckItem', {text: this.yesText, group: gId, checked: this.defaultValue === true}),
			Ext.create('Ext.menu.CheckItem', {text: this.noText, group: gId, checked: this.defaultValue === false})];

		this.menu.add(this.options[0], this.options[1]);

		for(var i=0; i<this.options.length; i++){
			this.options[i].on('click', this.fireUpdate, this);
			this.options[i].on('checkchange', this.fireUpdate, this);
		}
	},

    /**
     * @private
     * Template method that is to get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
		return this.options[0].checked;
	},

    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     */
	setValue : function (value) {
		this.options[value ? 0 : 1].setChecked(true);
	},

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs : function () {
		var args = {type: 'boolean', value: this.getValue()};
		return args;
	},

    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function (record) {
		return record.get(this.dataIndex) == this.getValue();
	}
});
/**
 * Filter by a configurable Ext.picker.DatePicker menu
 *
 * Example Usage:
 *
 *     var filters = Ext.create('Ext.ux.grid.GridFilters', {
 *         ...
 *         filters: [{
 *             // required configs
 *             type: 'date',
 *             dataIndex: 'dateAdded',
 *      
 *             // optional configs
 *             dateFormat: 'm/d/Y',  // default
 *             beforeText: 'Before', // default
 *             afterText: 'After',   // default
 *             onText: 'On',         // default
 *             pickerOpts: {
 *                 // any DatePicker configs
 *             },
 *      
 *             active: true // default is false
 *         }]
 *     });
 */
Ext.define('Ext.ux.grid.filter.DateFilter', {
    extend: 'Ext.ux.grid.filter.Filter',
    alias: 'gridfilter.date',
    uses: ['Ext.picker.Date', 'Ext.menu.Menu'],

    /**
     * @cfg {String} afterText
     * Defaults to 'After'.
     */
    afterText : 'After',
    /**
     * @cfg {String} beforeText
     * Defaults to 'Before'.
     */
    beforeText : 'Before',
    /**
     * @cfg {Object} compareMap
     * Map for assigning the comparison values used in serialization.
     */
    compareMap : {
        before: 'lt',
        after:  'gt',
        on:     'eq'
    },
    /**
     * @cfg {String} dateFormat
     * The date format to return when using getValue.
     * Defaults to 'm/d/Y'.
     */
    dateFormat : 'm/d/Y',

    /**
     * @cfg {Date} maxDate
     * Allowable date as passed to the Ext.DatePicker
     * Defaults to undefined.
     */
    /**
     * @cfg {Date} minDate
     * Allowable date as passed to the Ext.DatePicker
     * Defaults to undefined.
     */
    /**
     * @cfg {Array} menuItems
     * The items to be shown in this menu
     * Defaults to:<pre>
     * menuItems : ['before', 'after', '-', 'on'],
     * </pre>
     */
    menuItems : ['before', 'after', '-', 'on'],

    /**
     * @cfg {Object} menuItemCfgs
     * Default configuration options for each menu item
     */
    menuItemCfgs : {
        selectOnFocus: true,
        width: 125
    },

    /**
     * @cfg {String} onText
     * Defaults to 'On'.
     */
    onText : 'On',

    /**
     * @cfg {Object} pickerOpts
     * Configuration options for the date picker associated with each field.
     */
    pickerOpts : {},

    /**
     * @private
     * Template method that is to initialize the filter and install required menu items.
     */
    init : function (config) {
        var me = this,
            pickerCfg, i, len, item, cfg;

        pickerCfg = Ext.apply(me.pickerOpts, {
            xtype: 'datepicker',
            minDate: me.minDate,
            maxDate: me.maxDate,
            format:  me.dateFormat,
            listeners: {
                scope: me,
                select: me.onMenuSelect
            }
        });

        me.fields = {};
        for (i = 0, len = me.menuItems.length; i < len; i++) {
            item = me.menuItems[i];
            if (item !== '-') {
                cfg = {
                    itemId: 'range-' + item,
                    text: me[item + 'Text'],
                    menu: Ext.create('Ext.menu.Menu', {
                        plain: true,
                        items: [
                            Ext.apply(pickerCfg, {
                                itemId: item,
                                listeners: {
                                    select: me.onPickerSelect,
                                    scope: me
                                }
                            })
                        ]
                    }),
                    listeners: {
                        scope: me,
                        checkchange: me.onCheckChange
                    }
                };
                item = me.fields[item] = Ext.create('Ext.menu.CheckItem', cfg);
            }
            //me.add(item);
            me.menu.add(item);
        }
        me.values = {};
    },

    onCheckChange : function (item, checked) {
        var me = this,
            picker = item.menu.items.first(),
            itemId = picker.itemId,
            values = me.values;

        if (checked) {
            values[itemId] = picker.getValue();
        } else {
            delete values[itemId]
        }
        me.setActive(me.isActivatable());
        me.fireEvent('update', me);
    },

    /**
     * @private
     * Handler method called when there is a keyup event on an input
     * item of this menu.
     */
    onInputKeyUp : function (field, e) {
        var k = e.getKey();
        if (k == e.RETURN && field.isValid()) {
            e.stopEvent();
            this.menu.hide();
        }
    },

    /**
     * Handler for when the DatePicker for a field fires the 'select' event
     * @param {Ext.picker.Date} picker
     * @param {Object} date
     */
    onMenuSelect : function (picker, date) {
        var fields = this.fields,
            field = this.fields[picker.itemId];

        field.setChecked(true);

        if (field == fields.on) {
            fields.before.setChecked(false, true);
            fields.after.setChecked(false, true);
        } else {
            fields.on.setChecked(false, true);
            if (field == fields.after && this.getFieldValue('before') < date) {
                fields.before.setChecked(false, true);
            } else if (field == fields.before && this.getFieldValue('after') > date) {
                fields.after.setChecked(false, true);
            }
        }
        this.fireEvent('update', this);

        picker.up('menu').hide();
    },

    /**
     * @private
     * Template method that is to get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
        var key, result = {};
        for (key in this.fields) {
            if (this.fields[key].checked) {
                result[key] = this.getFieldValue(key);
            }
        }
        return result;
    },

    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     * @param {Boolean} preserve true to preserve the checked status
     * of the other fields.  Defaults to false, unchecking the
     * other fields
     */
    setValue : function (value, preserve) {
        var key;
        for (key in this.fields) {
            if(value[key]){
                this.getPicker(key).setValue(value[key]);
                this.fields[key].setChecked(true);
            } else if (!preserve) {
                this.fields[key].setChecked(false);
            }
        }
        this.fireEvent('update', this);
    },

    /**
     * Template method that is to return <tt>true</tt> if the filter
     * has enough configuration information to be activated.
     * @return {Boolean}
     */
    isActivatable : function () {
        var key;
        for (key in this.fields) {
            if (this.fields[key].checked) {
                return true;
            }
        }
        return false;
    },

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs : function () {
        var args = [];
        for (var key in this.fields) {
            if(this.fields[key].checked){
                args.push({
                    type: 'date',
                    comparison: this.compareMap[key],
                    value: Ext.Date.format(this.getFieldValue(key), this.dateFormat)
                });
            }
        }
        return args;
    },

    /**
     * Get and return the date menu picker value
     * @param {String} item The field identifier ('before', 'after', 'on')
     * @return {Date} Gets the current selected value of the date field
     */
    getFieldValue : function(item){
        return this.values[item];
    },

    /**
     * Gets the menu picker associated with the passed field
     * @param {String} item The field identifier ('before', 'after', 'on')
     * @return {Object} The menu picker
     */
    getPicker : function(item){
        return this.fields[item].menu.items.first();
    },

    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function (record) {
        var key,
            pickerValue,
            val = record.get(this.dataIndex),
            clearTime = Ext.Date.clearTime;

        if(!Ext.isDate(val)){
            return false;
        }
        val = clearTime(val, true).getTime();

        for (key in this.fields) {
            if (this.fields[key].checked) {
                pickerValue = clearTime(this.getFieldValue(key), true).getTime();
                if (key == 'before' && pickerValue <= val) {
                    return false;
                }
                if (key == 'after' && pickerValue >= val) {
                    return false;
                }
                if (key == 'on' && pickerValue != val) {
                    return false;
                }
            }
        }
        return true;
    },

    onPickerSelect: function(picker, date) {
        // keep track of the picker value separately because the menu gets destroyed
        // when columns order changes.  We return this value from getValue() instead
        // of picker.getValue()
        this.values[picker.itemId] = date;
        this.fireEvent('update', this);
    }
});
/**
 * Filter by a configurable Ext.picker.DatePicker menu
 *
 * This filter allows for the following configurations:
 *
 * - Any of the normal configs will be passed through to either component.
 * - There can be a docked config.
 * - The timepicker can be on the right or left (datepicker, too, of course).
 * - Choose which component will initiate the filtering, i.e., the event can be
 *   configured to be bound to either the datepicker or the timepicker, or if
 *   there is a docked config it be automatically have the handler bound to it.
 *
 * Although not shown here, this class accepts all configuration options
 * for {@link Ext.picker.Date} and {@link Ext.picker.Time}.
 *
 * In the case that a custom dockedItems config is passed in, the
 * class will handle binding the default listener to it so the
 * developer need not worry about having to do it.
 *
 * The default dockedItems position and the toolbar's
 * button text can be passed a config for convenience, i.e.,:
 *
 *     dock: {
 *        buttonText: 'Click to Filter',
 *        dock: 'left'
 *     }
 *
 * Or, pass in a full dockedItems config:
 *
 *     dock: {
 *        dockedItems: {
 *            xtype: 'toolbar',
 *            dock: 'bottom',
 *            ...
 *        }
 *     }
 *
 * Or, give a value of `true` to accept dock defaults:
 *
 *     dock: true
 *
 * But, it must be one or the other.
 *
 * Example Usage:
 *
 *     var filters = Ext.create('Ext.ux.grid.GridFilters', {
 *         ...
 *         filters: [{
 *             // required configs
 *             type: 'datetime',
 *             dataIndex: 'date',
 *
 *             // optional configs
 *             positionDatepickerFirst: false,
 *             //selectDateToFilter: false, // this is overridden b/c of the presence of the dock cfg object
 *
 *             date: {
 *                 format: 'm/d/Y',
 *             },
 *
 *             time: {
 *                 format: 'H:i:s A',
 *                 increment: 1
 *             },
 *
 *             dock: {
 *                 buttonText: 'Click to Filter',
 *                 dock: 'left'
 *
 *                 // allows for custom dockedItems cfg
 *                 //dockedItems: {}
 *             }
 *         }]
 *     });
 *
 * In the above example, note that the filter is being passed a {@link #date} config object,
 * a {@link #time} config object and a {@link #dock} config. These are all optional.
 *
 * As for positioning, the datepicker will be on the right, the timepicker on the left
 * and the docked items will be docked on the left. In addition, since there's a {@link #dock}
 * config, clicking the button in the dock will trigger the filtering.
 */
Ext.define('Ext.ux.grid.filter.DateTimeFilter', {
    extend: 'Ext.ux.grid.filter.DateFilter',
    alias: 'gridfilter.datetime',

    /**
     * @private
     */
    dateDefaults: {
        xtype: 'datepicker',
        format: 'm/d/Y'
    },

    /**
     * @private
     */
    timeDefaults: {
        xtype: 'timepicker',
        width: 100,
        height: 200,
        format: 'g:i A'
    },

    /**
     * @private
     */
    dockDefaults: {
        dock: 'top',
        buttonText: 'Filter'
    },

    /**
     * @cfg {Object} date
     * A {@link Ext.picker.Date} can be configured here.
     * Uses {@link #dateDefaults} by default.
     */

    /**
     * @cfg {Object} time
     * A {@link Ext.picker.Time} can be configured here.
     * Uses {@link #timeDefaults} by default.
     */

    /**
     * @cfg {Boolean/Object} dock
     * A {@link Ext.panel.AbstractPanel#cfg-dockedItems} can be configured here.
     * A `true` value will use the {@link #dockDefaults} default configuration.
     * If present, the button in the docked items will initiate the filtering.
     */

    /**
     * @cfg {Boolean} [selectDateToFilter=true]
     * By default, the datepicker has the default event listener bound to it.
     * Setting to `false` will bind it to the timepicker.
     *
     * The config will be ignored if there is a `dock` config.
     */
    selectDateToFilter: true,

    /**
     * @cfg {Boolean} [positionDatepickerFirst=true]
     * Positions the datepicker within its container.
     * A `true` value will place it on the left in the container.
     * Set to `false` if the timepicker should be placed on the left.
     * Defaults to `true`.
     */
    positionDatepickerFirst: true,

    reTime: /\s(am|pm)/i,
    reItemId: /\w*-(\w*)$/,

    /**
     * Replaces the selected value of the timepicker with the default 00:00:00.
     * @private
     * @param {Object} date
     * @param {Ext.picker.Time} timepicker
     * @return Date object
     */
    addTimeSelection: function (date, timepicker) {
        var me = this,
            selection = timepicker.getSelectionModel().getSelection(),
            time, len, fn, val,
            i = 0,
            arr = [],
            timeFns = ['setHours', 'setMinutes', 'setSeconds', 'setMilliseconds'];


        if (selection.length) {
            time = selection[0].get('disp');

            // Loop through all of the splits and add the time values.
            arr = time.replace(me.reTime, '').split(':');

            for (len = arr.length; i < len; i++) {
                fn = timeFns[i];
                val = arr[i];

                if (val) {
                    date[fn](parseInt(val, 10));
                }
            }
        }

        return date;
    },

    /**
     * @private
     * Template method that is to initialize the filter and install required menu items.
     */
    init: function (config) {
        var me = this,
            dateCfg = Ext.applyIf(me.date || {}, me.dateDefaults),
            timeCfg = Ext.applyIf(me.time || {}, me.timeDefaults),
            dockCfg = me.dock, // should not default to empty object
            defaultListeners = {
                click: {
                    scope: me,
                    click: me.onMenuSelect
                },
                select: {
                    scope: me,
                    select: me.onMenuSelect
                }
            },
            pickerCtnCfg, i, len, item, cfg,
            items = [dateCfg, timeCfg],

            // we need to know the datepicker's position in the items array
            // for when the itemId name is bound to it before adding to the menu
            datepickerPosition = 0;

        if (!me.positionDatepickerFirst) {
            items = items.reverse();
            datepickerPosition = 1;
        }

        pickerCtnCfg = Ext.apply(me.pickerOpts, {
            xtype: !dockCfg ? 'container' : 'panel',
            layout: 'hbox',
            items: items
        });

        // If there's no dock config then bind the default listener to the desired picker.
        if (!dockCfg) {
            if (me.selectDateToFilter) {
                dateCfg.listeners = defaultListeners.select;
            } else {
                timeCfg.listeners = defaultListeners.select;
            }
        } else if (dockCfg) {
            me.selectDateToFilter = null;

            if (dockCfg.dockedItems) {
                pickerCtnCfg.dockedItems = dockCfg.dockedItems;
                // TODO: allow config that will tell which item to bind the listener to
                // right now, it's using the first item
                pickerCtnCfg.dockedItems.items[dockCfg.bindToItem || 0].listeners = defaultListeners.click;
            } else {
                // dockCfg can be `true` if button text and dock position defaults are wanted
                if (Ext.isBoolean(dockCfg)) {
                    dockCfg = {};
                }
                dockCfg = Ext.applyIf(dockCfg, me.dockDefaults);
                pickerCtnCfg.dockedItems = {
                    xtype: 'toolbar',
                    dock: dockCfg.dock,
                    items: [
                        {
                            xtype: 'button',
                            text: dockCfg.buttonText,
                            flex: 1,
                            listeners: defaultListeners.click
                        }
                    ]   
                };
            }
        }

        me.fields = {};
        for (i = 0, len = me.menuItems.length; i < len; i++) {
            item = me.menuItems[i];
            if (item !== '-') {
                pickerCtnCfg.items[datepickerPosition].itemId = item;

                cfg = {
                    itemId: 'range-' + item,
                    text: me[item + 'Text'],
                    menu: Ext.create('Ext.menu.Menu', {
                        items: pickerCtnCfg
                    }),
                    listeners: {
                        scope: me,
                        checkchange: me.onCheckChange
                    }
                };
                item = me.fields[item] = Ext.create('Ext.menu.CheckItem', cfg);
            }
            me.menu.add(item);
        }
        me.values = {};
    },

    /**
     * @private
     */
    onCheckChange: function (item, checked) {
        var me = this,
            menu = item.menu,
            timepicker = menu.down('timepicker'),
            datepicker = menu.down('datepicker'),
            itemId = datepicker.itemId,
            values = me.values;

        if (checked) {
            values[itemId] = me.addTimeSelection(datepicker.value, timepicker);
        } else {
            delete values[itemId];
        }
        me.setActive(me.isActivatable());
        me.fireEvent('update', me);
    },

    /** 
     * Handler for when the DatePicker for a field fires the 'select' event
     * @param {Ext.picker.Date} picker
     * @param {Object} date
     */
    onMenuSelect: function (picker, date) {
        // NOTE: we need to redefine the picker.
        var me = this,
            menu = me.menu,
            checkItemId = menu.getFocusEl().itemId.replace(me.reItemId, '$1'),
            fields = me.fields,
            field;

        picker = menu.queryById(checkItemId);
        field = me.fields[picker.itemId];
        field.setChecked(true);

        if (field == fields.on) {
            fields.before.setChecked(false, true);
            fields.after.setChecked(false, true);
        } else {
            fields.on.setChecked(false, true);
            if (field == fields.after && me.getFieldValue('before') < date) {
                fields.before.setChecked(false, true);
            } else if (field == fields.before && me.getFieldValue('after') > date) {
                fields.after.setChecked(false, true);
            }   
        }   
        me.fireEvent('update', me);

        // The timepicker's getBubbleTarget() returns the boundlist's implementation,
        // so it doesn't look up ownerCt chain (it looks up this.pickerField).
        // This is a problem :)
        // This can be fixed by just walking up the ownerCt chain
        // (same thing, but confusing without comment).
        picker.ownerCt.ownerCt.hide();
    },

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs: function () {
        var me = this,
            key,
            fields = me.fields,
            args = [];

        for (key in fields) {
            if (fields[key].checked) {
                args.push({
                    type: 'datetime',
                    comparison: me.compareMap[key],
                    value: Ext.Date.format(me.getFieldValue(key), (me.date.format || me.dateDefaults.format) + ' ' + (me.time.format || me.timeDefaults.format))
                });
            }
        }
        return args;
    },

    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     * @param {Boolean} preserve true to preserve the checked status
     * of the other fields.  Defaults to false, unchecking the
     * other fields
     */
    setValue: function (value, preserve) {
        var me = this,
            fields = me.fields,
            key,
            val,
            datepicker;

        for (key in fields) {
            val = value[key];
            if (val) {
                datepicker = me.menu.down('datepicker[itemId="' + key + '"]');
                // Note that calling the Ext.picker.Date:setValue() calls Ext.Date.clearTime(),
                // which we don't want, so just call update() instead and set the value on the component.
                datepicker.update(val);
                datepicker.value = val;

                fields[key].setChecked(true);
            } else if (!preserve) {
                fields[key].setChecked(false);
            }
        }
        me.fireEvent('update', me);
    },

    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord: function (record) {
        // remove calls to Ext.Date.clearTime
        var me = this,
            key,
            pickerValue,
            val = record.get(me.dataIndex);

        if(!Ext.isDate(val)){
            return false;
        }

        val = val.getTime();

        for (key in me.fields) {
            if (me.fields[key].checked) {
                pickerValue = me.getFieldValue(key).getTime();
                if (key == 'before' && pickerValue <= val) {
                    return false;
                }
                if (key == 'after' && pickerValue >= val) {
                    return false;
                }
                if (key == 'on' && pickerValue != val) {
                    return false;
                }
            }
        }
        return true;
    }
});
/**
 * Filters using an Ext.ux.grid.menu.RangeMenu.
 * <p><b><u>Example Usage:</u></b></p>
 * <pre><code>
var filters = Ext.create('Ext.ux.grid.GridFilters', {
    ...
    filters: [{
        type: 'numeric',
        dataIndex: 'price'
    }]
});
 * </code></pre>
 * <p>Any of the configuration options for {@link Ext.ux.grid.menu.RangeMenu} can also be specified as
 * configurations to NumericFilter, and will be copied over to the internal menu instance automatically.</p>
 */
Ext.define('Ext.ux.grid.filter.NumericFilter', {
    extend: 'Ext.ux.grid.filter.Filter',
    alias: 'gridfilter.numeric',
    uses: ['Ext.form.field.Number'],

    /**
     * @private @override
     * Creates the Menu for this filter.
     * @param {Object} config Filter configuration
     * @return {Ext.menu.Menu}
     */
    createMenu: function(config) {
        var me = this,
            menu;
        menu = Ext.create('Ext.ux.grid.menu.RangeMenu', config);
        menu.on('update', me.fireUpdate, me);
        return menu;
    },

    /**
     * @private
     * Template method that is to get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
        return this.menu.getValue();
    },

    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     */
    setValue : function (value) {
        this.menu.setValue(value);
    },

    /**
     * Template method that is to return <tt>true</tt> if the filter
     * has enough configuration information to be activated.
     * @return {Boolean}
     */
    isActivatable : function () {
        var values = this.getValue(),
            key;
        for (key in values) {
            if (values[key] !== undefined) {
                return true;
            }
        }
        return false;
    },

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs : function () {
        var key,
            args = [],
            values = this.menu.getValue();
        for (key in values) {
            args.push({
                type: 'numeric',
                comparison: key,
                value: values[key]
            });
        }
        return args;
    },

    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function (record) {
        var val = record.get(this.dataIndex),
            values = this.getValue(),
            isNumber = Ext.isNumber;
        if (isNumber(values.eq) && val != values.eq) {
            return false;
        }
        if (isNumber(values.lt) && val >= values.lt) {
            return false;
        }
        if (isNumber(values.gt) && val <= values.gt) {
            return false;
        }
        return true;
    }
});
/**
 * Filter by a configurable Ext.form.field.Text
 * <p><b><u>Example Usage:</u></b></p>
 * <pre><code>
var filters = Ext.create('Ext.ux.grid.GridFilters', {
    ...
    filters: [{
        // required configs
        type: 'string',
        dataIndex: 'name',

        // optional configs
        value: 'foo',
        active: true, // default is false
        iconCls: 'ux-gridfilter-text-icon' // default
        // any Ext.form.field.Text configs accepted
    }]
});
 * </code></pre>
 */
Ext.define('Ext.ux.grid.filter.StringFilter', {
    extend: 'Ext.ux.grid.filter.Filter',
    alias: 'gridfilter.string',

    /**
     * @cfg {String} iconCls
     * The iconCls to be applied to the menu item.
     * Defaults to <tt>'ux-gridfilter-text-icon'</tt>.
     */
    iconCls : 'ux-gridfilter-text-icon',

    emptyText: 'Enter Filter Text...',
    selectOnFocus: true,
    width: 125,

    /**
     * @private
     * Template method that is to initialize the filter and install required menu items.
     */
    init : function (config) {
        Ext.applyIf(config, {
            enableKeyEvents: true,
            labelCls: 'ux-rangemenu-icon ' + this.iconCls,
            hideEmptyLabel: false,
            labelSeparator: '',
            labelWidth: 29,
            listeners: {
                scope: this,
                keyup: this.onInputKeyUp,
                el: {
                    click: function(e) {
                        e.stopPropagation();
                    }
                }
            }
        });

        this.inputItem = Ext.create('Ext.form.field.Text', config);
        this.menu.add(this.inputItem);
        this.menu.showSeparator = false;
        this.updateTask = Ext.create('Ext.util.DelayedTask', this.fireUpdate, this);
    },

    /**
     * @private
     * Template method that is to get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
        return this.inputItem.getValue();
    },

    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     */
    setValue : function (value) {
        this.inputItem.setValue(value);
        this.fireEvent('update', this);
    },

    /**
     * Template method that is to return <tt>true</tt> if the filter
     * has enough configuration information to be activated.
     * @return {Boolean}
     */
    isActivatable : function () {
        return this.inputItem.getValue().length > 0;
    },

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs : function () {
        return {type: 'string', value: this.getValue()};
    },

    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function (record) {
        var val = record.get(this.dataIndex);

        if(typeof val != 'string') {
            return (this.getValue().length === 0);
        }

        return val.toLowerCase().indexOf(this.getValue().toLowerCase()) > -1;
    },

    /**
     * @private
     * Handler method called when there is a keyup event on this.inputItem
     */
    onInputKeyUp : function (field, e) {
        var k = e.getKey();
        if (k == e.RETURN && field.isValid()) {
            e.stopEvent();
            this.menu.hide();
            return;
        }
        // restart the timer
        this.updateTask.delay(this.updateBuffer);
    }
});
/*!
 * Ext JS Library 4.0
 * Copyright(c) 2006-2011 Sencha Inc.
 * licensing@sencha.com
 * http://www.sencha.com/license
 */

/**
 * Barebones iframe implementation. For serious iframe work, see the
 * ManagedIFrame extension
 * (http://www.sencha.com/forum/showthread.php?71961).
 */
Ext.define('Ext.ux.IFrame', {
    extend: 'Ext.Component',

    alias: 'widget.uxiframe',

    loadMask: 'Loading...',

    src: 'about:blank',

    renderTpl: [
        '<iframe src="{src}" name="{frameName}" width="100%" height="100%" frameborder="0"></iframe>'
    ],

    initComponent: function () {
        this.callParent();

        this.frameName = this.frameName || this.id + '-frame';

        this.addEvents(
            'beforeload',
            'load'
        );

        Ext.apply(this.renderSelectors, {
            iframeEl: 'iframe'
        });
    },

    initEvents : function() {
        var me = this;
        me.callParent();
        me.iframeEl.on('load', me.onLoad, me);
        me.iframeEl.on('error', me.onError, me);
    },

    initRenderData: function() {
        return Ext.apply(this.callParent(), {
            src: this.src,
            frameName: this.frameName
        });
    },

    getBody: function() {
        var doc = this.getDoc();
        return doc.body || doc.documentElement;
    },

    getDoc: function() {
        try {
            return this.getWin().document;
        } catch (ex) {
            return null;
        }
    },

    getWin: function() {
        var me = this,
            name = me.frameName,
            win = Ext.isIE
                ? me.iframeEl.dom.contentWindow
                : window.frames[name];
        return win;
    },

    getFrame: function() {
        var me = this;
        return me.iframeEl.dom;
    },

    beforeDestroy: function () {
    	
        this.cleanupListeners(true);
        this.callParent();
    },
    
    cleanupListeners: function(destroying){
        var doc, prop;

        if (this.rendered) {
            try {
                doc = this.getDoc();
                if (doc) {
                    Ext.EventManager.removeAll(doc);
                    if (destroying) {
                        for (prop in doc) {
                            if (doc.hasOwnProperty && doc.hasOwnProperty(prop)) {
                                delete doc[prop];
                            }
                        }
                    }
                }
            } catch(e) { }
        }
    },

    onLoad: function() {
        console.log("IFRAME onOload");
        var me = this,
            doc = me.getDoc(),
            fn = me.onRelayedEvent;

        if (doc) {
            try {
                Ext.EventManager.removeAll(doc);

                // These events need to be relayed from the inner document (where they stop
                // bubbling) up to the outer document. This has to be done at the DOM level so
                // the event reaches listeners on elements like the document body. The effected
                // mechanisms that depend on this bubbling behavior are listed to the right
                // of the event.
//                Ext.EventManager.on(doc, {
//                    mousedown: fn, // menu dismisal (MenuManager) and Window onMouseDown (toFront)
//                    mousemove: fn, // window resize drag detection
//                    mouseup: fn,   // window resize termination
//                    click: fn,     // not sure, but just to be safe
//                    dblclick: fn,  // not sure again
//                    scope: me
//                });
            } catch(e) {
                // cannot do this xss
            }

            var win = this.getWin();
            // We need to be sure we remove all our events from the iframe on unload or we're going to LEAK!
            Ext.EventManager.on(win, 'beforeunload', function(eOpts, doc) {
            	me.cleanupListeners();
            }, me);
            

            this.el.unmask();
            if(win && win.isErrorPage) {
            	this.fireEvent('error', this);
	        } else {
	            this.fireEvent('load', this) ;
	        }

        } else if(me.src && me.src != '') {

            this.el.unmask();
            this.fireEvent('error', this);
        }

		// VISIBILITY: 1, DISPLAY: 2, OFFSETS: 3, ASCLASS: 4
        if(this.el) {
			this.el.setVisibilityMode(3);//Element.OFFSETS );
        }
    },
    onError: function() {
            this.el.unmask();
            this.fireEvent('error', this);
    	
    },

    onRelayedEvent: function (event) {
        // relay event from the iframe's document to the document that owns the iframe...

        console.log("onRelayedEvent ");
        var iframeEl = this.iframeEl,

            // Get the left-based iframe position
            iframeXY = Ext.Element.getTrueXY(iframeEl),
            originalEventXY = event.getXY(),

            // Get the left-based XY position.
            // This is because the consumer of the injected event (Ext.EventManager) will
            // perform its own RTL normalization.
            eventXY = Ext.EventManager.getPageXY(event.browserEvent);

        // the event from the inner document has XY relative to that document's origin,
        // so adjust it to use the origin of the iframe in the outer document:
        event.xy = [iframeXY[0] + eventXY[0], iframeXY[1] + eventXY[1]];

        event.injectEvent(iframeEl); // blame the iframe for the event...

        event.xy = originalEventXY; // restore the original XY (just for safety)
    },

    load: function (src) {
        var me = this,
            text = me.loadMask,
            frame = me.getFrame();

        if (me.fireEvent('beforeload', me, src) !== false) {
            if (text && me.el) {
                me.el.mask(text);
            }

            frame.src = me.src = (src || me.src);
        }
    }
});
/**
 * Basic status bar component that can be used as the bottom toolbar of any {@link Ext.Panel}.  In addition to
 * supporting the standard {@link Ext.toolbar.Toolbar} interface for adding buttons, menus and other items, the StatusBar
 * provides a greedy status element that can be aligned to either side and has convenient methods for setting the
 * status text and icon.  You can also indicate that something is processing using the {@link #showBusy} method.
 *
 *     Ext.create('Ext.Panel', {
 *         title: 'StatusBar',
 *         // etc.
 *         bbar: Ext.create('Ext.ux.StatusBar', {
 *             id: 'my-status',
 *      
 *             // defaults to use when the status is cleared:
 *             defaultText: 'Default status text',
 *             defaultIconCls: 'default-icon',
 *      
 *             // values to set initially:
 *             text: 'Ready',
 *             iconCls: 'ready-icon',
 *      
 *             // any standard Toolbar items:
 *             items: [{
 *                 text: 'A Button'
 *             }, '-', 'Plain Text']
 *         })
 *     });
 *
 *     // Update the status bar later in code:
 *     var sb = Ext.getCmp('my-status');
 *     sb.setStatus({
 *         text: 'OK',
 *         iconCls: 'ok-icon',
 *         clear: true // auto-clear after a set interval
 *     });
 *
 *     // Set the status bar to show that something is processing:
 *     sb.showBusy();
 *
 *     // processing....
 *
 *     sb.clearStatus(); // once completeed
 *
 */
Ext.define('Ext.ux.statusbar.StatusBar', {
    extend: 'Ext.toolbar.Toolbar',
    alternateClassName: 'Ext.ux.StatusBar',
    alias: 'widget.statusbar',
    requires: ['Ext.toolbar.TextItem'],
    /**
     * @cfg {String} statusAlign
     * The alignment of the status element within the overall StatusBar layout.  When the StatusBar is rendered,
     * it creates an internal div containing the status text and icon.  Any additional Toolbar items added in the
     * StatusBar's {@link #cfg-items} config, or added via {@link #method-add} or any of the supported add* methods, will be
     * rendered, in added order, to the opposite side.  The status element is greedy, so it will automatically
     * expand to take up all sapce left over by any other items.  Example usage:
     *
     *     // Create a left-aligned status bar containing a button,
     *     // separator and text item that will be right-aligned (default):
     *     Ext.create('Ext.Panel', {
     *         title: 'StatusBar',
     *         // etc.
     *         bbar: Ext.create('Ext.ux.statusbar.StatusBar', {
     *             defaultText: 'Default status text',
     *             id: 'status-id',
     *             items: [{
     *                 text: 'A Button'
     *             }, '-', 'Plain Text']
     *         })
     *     });
     *
     *     // By adding the statusAlign config, this will create the
     *     // exact same toolbar, except the status and toolbar item
     *     // layout will be reversed from the previous example:
     *     Ext.create('Ext.Panel', {
     *         title: 'StatusBar',
     *         // etc.
     *         bbar: Ext.create('Ext.ux.statusbar.StatusBar', {
     *             defaultText: 'Default status text',
     *             id: 'status-id',
     *             statusAlign: 'right',
     *             items: [{
     *                 text: 'A Button'
     *             }, '-', 'Plain Text']
     *         })
     *     });
     */
    /**
     * @cfg {String} [defaultText='']
     * The default {@link #text} value.  This will be used anytime the status bar is cleared with the
     * `useDefaults:true` option.
     */
    /**
     * @cfg {String} [defaultIconCls='']
     * The default {@link #iconCls} value (see the iconCls docs for additional details about customizing the icon).
     * This will be used anytime the status bar is cleared with the `useDefaults:true` option.
     */
    /**
     * @cfg {String} text
     * A string that will be <b>initially</b> set as the status message.  This string
     * will be set as innerHTML (html tags are accepted) for the toolbar item.
     * If not specified, the value set for {@link #defaultText} will be used.
     */
    /**
     * @cfg {String} [iconCls='']
     * A CSS class that will be **initially** set as the status bar icon and is
     * expected to provide a background image.
     *
     * Example usage:
     *
     *     // Example CSS rule:
     *     .x-statusbar .x-status-custom {
     *         padding-left: 25px;
     *         background: transparent url(images/custom-icon.gif) no-repeat 3px 2px;
     *     }
     *
     *     // Setting a default icon:
     *     var sb = Ext.create('Ext.ux.statusbar.StatusBar', {
     *         defaultIconCls: 'x-status-custom'
     *     });
     *
     *     // Changing the icon:
     *     sb.setStatus({
     *         text: 'New status',
     *         iconCls: 'x-status-custom'
     *     });
     */

    /**
     * @cfg {String} cls
     * The base class applied to the containing element for this component on render.
     */
    cls : 'x-statusbar',
    /**
     * @cfg {String} busyIconCls
     * The default {@link #iconCls} applied when calling {@link #showBusy}.
     * It can be overridden at any time by passing the `iconCls` argument into {@link #showBusy}.
     */
    busyIconCls : 'x-status-busy',
    /**
     * @cfg {String} busyText
     * The default {@link #text} applied when calling {@link #showBusy}.
     * It can be overridden at any time by passing the `text` argument into {@link #showBusy}.
     */
    busyText : 'Loading...',
    /**
     * @cfg {Number} autoClear
     * The number of milliseconds to wait after setting the status via
     * {@link #setStatus} before automatically clearing the status text and icon.
     * Note that this only applies when passing the `clear` argument to {@link #setStatus}
     * since that is the only way to defer clearing the status.  This can
     * be overridden by specifying a different `wait` value in {@link #setStatus}.
     * Calls to {@link #clearStatus} always clear the status bar immediately and ignore this value.
     */
    autoClear : 5000,

    /**
     * @cfg {String} emptyText
     * The text string to use if no text has been set. If there are no other items in
     * the toolbar using an empty string (`''`) for this value would end up in the toolbar
     * height collapsing since the empty string will not maintain the toolbar height.
     * Use `''` if the toolbar should collapse in height vertically when no text is
     * specified and there are no other items in the toolbar.
     */
    emptyText : '&#160;',

    // private
    activeThreadId : 0,

    // private
    initComponent : function(){
        var right = this.statusAlign === 'right';

        this.callParent(arguments);
        this.currIconCls = this.iconCls || this.defaultIconCls;
        this.statusEl = Ext.create('Ext.toolbar.TextItem', {
            cls: 'x-status-text ' + (this.currIconCls || ''),
            text: this.text || this.defaultText || ''
        });

        if (right) {
            this.cls += ' x-status-right';
            this.add('->');
            this.add(this.statusEl);
        } else {
            this.insert(0, this.statusEl);
            this.insert(1, '->');
        }
    },

    /**
     * Sets the status {@link #text} and/or {@link #iconCls}. Also supports automatically clearing the
     * status that was set after a specified interval.
     *
     * Example usage:
     *
     *     // Simple call to update the text
     *     statusBar.setStatus('New status');
     *
     *     // Set the status and icon, auto-clearing with default options:
     *     statusBar.setStatus({
     *         text: 'New status',
     *         iconCls: 'x-status-custom',
     *         clear: true
     *     });
     *
     *     // Auto-clear with custom options:
     *     statusBar.setStatus({
     *         text: 'New status',
     *         iconCls: 'x-status-custom',
     *         clear: {
     *             wait: 8000,
     *             anim: false,
     *             useDefaults: false
     *         }
     *     });
     *
     * @param {Object/String} config A config object specifying what status to set, or a string assumed
     * to be the status text (and all other options are defaulted as explained below). A config
     * object containing any or all of the following properties can be passed:
     *
     * @param {String} config.text The status text to display.  If not specified, any current
     * status text will remain unchanged.
     *
     * @param {String} config.iconCls The CSS class used to customize the status icon (see
     * {@link #iconCls} for details). If not specified, any current iconCls will remain unchanged.
     *
     * @param {Boolean/Number/Object} config.clear Allows you to set an internal callback that will
     * automatically clear the status text and iconCls after a specified amount of time has passed. If clear is not
     * specified, the new status will not be auto-cleared and will stay until updated again or cleared using
     * {@link #clearStatus}. If `true` is passed, the status will be cleared using {@link #autoClear},
     * {@link #defaultText} and {@link #defaultIconCls} via a fade out animation. If a numeric value is passed,
     * it will be used as the callback interval (in milliseconds), overriding the {@link #autoClear} value.
     * All other options will be defaulted as with the boolean option.  To customize any other options,
     * you can pass an object in the format:
     * 
     * @param {Number} config.clear.wait The number of milliseconds to wait before clearing
     * (defaults to {@link #autoClear}).
     * @param {Boolean} config.clear.anim False to clear the status immediately once the callback
     * executes (defaults to true which fades the status out).
     * @param {Boolean} config.clear.useDefaults False to completely clear the status text and iconCls
     * (defaults to true which uses {@link #defaultText} and {@link #defaultIconCls}).
     *
     * @return {Ext.ux.statusbar.StatusBar} this
     */
    setStatus : function(o) {
        var me = this;

        o = o || {};
        Ext.suspendLayouts();
        if (Ext.isString(o)) {
            o = {text:o};
        }
        if (o.text !== undefined) {
            me.setText(o.text);
        }
        if (o.iconCls !== undefined) {
            me.setIcon(o.iconCls);
        }

        if (o.clear) {
            var c = o.clear,
                wait = me.autoClear,
                defaults = {useDefaults: true, anim: true};

            if (Ext.isObject(c)) {
                c = Ext.applyIf(c, defaults);
                if (c.wait) {
                    wait = c.wait;
                }
            } else if (Ext.isNumber(c)) {
                wait = c;
                c = defaults;
            } else if (Ext.isBoolean(c)) {
                c = defaults;
            }

            c.threadId = this.activeThreadId;
            Ext.defer(me.clearStatus, wait, me, [c]);
        }
        Ext.resumeLayouts(true);
        return me;
    },

    /**
     * Clears the status {@link #text} and {@link #iconCls}. Also supports clearing via an optional fade out animation.
     *
     * @param {Object} [config] A config object containing any or all of the following properties.  If this
     * object is not specified the status will be cleared using the defaults below:
     * @param {Boolean} config.anim True to clear the status by fading out the status element (defaults
     * to false which clears immediately).
     * @param {Boolean} config.useDefaults True to reset the text and icon using {@link #defaultText} and
     * {@link #defaultIconCls} (defaults to false which sets the text to '' and removes any existing icon class).
     *
     * @return {Ext.ux.statusbar.StatusBar} this
     */
    clearStatus : function(o) {
        o = o || {};

        var me = this,
            statusEl = me.statusEl;

        if (o.threadId && o.threadId !== me.activeThreadId) {
            // this means the current call was made internally, but a newer
            // thread has set a message since this call was deferred.  Since
            // we don't want to overwrite a newer message just ignore.
            return me;
        }

        var text = o.useDefaults ? me.defaultText : me.emptyText,
            iconCls = o.useDefaults ? (me.defaultIconCls ? me.defaultIconCls : '') : '';

        if (o.anim) {
            // animate the statusEl Ext.Element
            statusEl.el.puff({
                remove: false,
                useDisplay: true,
                callback: function() {
                    statusEl.el.show();
                    me.setStatus({
                        text: text,
                        iconCls: iconCls
                    });
                }
            });
        } else {
             me.setStatus({
                 text: text,
                 iconCls: iconCls
             });
        }
        return me;
    },

    /**
     * Convenience method for setting the status text directly.  For more flexible options see {@link #setStatus}.
     * @param {String} text (optional) The text to set (defaults to '')
     * @return {Ext.ux.statusbar.StatusBar} this
     */
    setText : function(text) {
        var me = this;
        me.activeThreadId++;
        me.text = text || '';
        if (me.rendered) {
            me.statusEl.setText(me.text);
        }
        return me;
    },

    /**
     * Returns the current status text.
     * @return {String} The status text
     */
    getText : function(){
        return this.text;
    },

    /**
     * Convenience method for setting the status icon directly.  For more flexible options see {@link #setStatus}.
     * See {@link #iconCls} for complete details about customizing the icon.
     * @param {String} iconCls (optional) The icon class to set (defaults to '', and any current icon class is removed)
     * @return {Ext.ux.statusbar.StatusBar} this
     */
    setIcon : function(cls) {
        var me = this;

        me.activeThreadId++;
        cls = cls || '';

        if (me.rendered) {
            if (me.currIconCls) {
                me.statusEl.removeCls(me.currIconCls);
                me.currIconCls = null;
            }
            if (cls.length > 0) {
                me.statusEl.addCls(cls);
                me.currIconCls = cls;
            }
        } else {
            me.currIconCls = cls;
        }
        return me;
    },

    /**
     * Convenience method for setting the status text and icon to special values that are pre-configured to indicate
     * a "busy" state, usually for loading or processing activities.
     *
     * @param {Object/String} config (optional) A config object in the same format supported by {@link #setStatus}, or a
     * string to use as the status text (in which case all other options for setStatus will be defaulted).  Use the
     * `text` and/or `iconCls` properties on the config to override the default {@link #busyText}
     * and {@link #busyIconCls} settings. If the config argument is not specified, {@link #busyText} and
     * {@link #busyIconCls} will be used in conjunction with all of the default options for {@link #setStatus}.
     * @return {Ext.ux.statusbar.StatusBar} this
     */
    showBusy : function(o){
        if (Ext.isString(o)) {
            o = { text: o };
        }
        o = Ext.applyIf(o || {}, {
            text: this.busyText,
            iconCls: this.busyIconCls
        });
        return this.setStatus(o);
    }
});
/**
 * A {@link Ext.ux.statusbar.StatusBar} plugin that provides automatic error
 * notification when the associated form contains validation errors.
 */
Ext.define('Ext.ux.statusbar.ValidationStatus', {
    extend: 'Ext.Component', 
    requires: ['Ext.util.MixedCollection'],
    /**
     * @cfg {String} errorIconCls
     * The {@link Ext.ux.statusbar.StatusBar#iconCls iconCls} value to be applied
     * to the status message when there is a validation error.
     */
    errorIconCls : 'x-status-error',
    /**
     * @cfg {String} errorListCls
     * The css class to be used for the error list when there are validation errors.
     */
    errorListCls : 'x-status-error-list',
    /**
     * @cfg {String} validIconCls
     * The {@link Ext.ux.statusbar.StatusBar#iconCls iconCls} value to be applied
     * to the status message when the form validates.
     */
    validIconCls : 'x-status-valid',
    
    /**
     * @cfg {String} showText
     * The {@link Ext.ux.statusbar.StatusBar#text text} value to be applied when
     * there is a form validation error.
     */
    showText : 'The form has errors (click for details...)',
    /**
     * @cfg {String} hideText
     * The {@link Ext.ux.statusbar.StatusBar#text text} value to display when
     * the error list is displayed.
     */
    hideText : 'Click again to hide the error list',
    /**
     * @cfg {String} submitText
     * The {@link Ext.ux.statusbar.StatusBar#text text} value to be applied when
     * the form is being submitted.
     */
    submitText : 'Saving...',
    
    // private
    init : function(sb) {
        var me = this;

        me.statusBar = sb;
        sb.on({
            single: true,
            scope: me,
            render: me.onStatusbarRender,
            beforedestroy: me.destroy
        });
        sb.on({
            click: {
                element: 'el',
                fn: me.onStatusClick,
                scope: me,
                buffer: 200
            }
        });
    },

    onStatusbarRender: function(sb) {
        var me = this,
            startMonitor = function() {
                me.monitor = true;
            };

        me.monitor = true;
        me.errors = Ext.create('Ext.util.MixedCollection');
        me.listAlign = (sb.statusAlign === 'right' ? 'br-tr?' : 'bl-tl?');

        if (me.form) {
            me.formPanel = Ext.getCmp(me.form);
            me.basicForm = me.formPanel.getForm();
            me.startMonitoring();
            me.basicForm.on('beforeaction', function(f, action) {
                if (action.type === 'submit') {
                    // Ignore monitoring while submitting otherwise the field validation
                    // events cause the status message to reset too early
                    me.monitor = false;
                }
            });
            me.basicForm.on('actioncomplete', startMonitor);
            me.basicForm.on('actionfailed', startMonitor);
        }
   },
    
    // private
    startMonitoring : function() {
        this.basicForm.getFields().each(function(f) {
            f.on('validitychange', this.onFieldValidation, this);
        }, this);
    },
    
    // private
    stopMonitoring : function() {
        this.basicForm.getFields().each(function(f) {
            f.un('validitychange', this.onFieldValidation, this);
        }, this);
    },
    
    // private
    onDestroy : function() {
        this.stopMonitoring();
        this.statusBar.statusEl.un('click', this.onStatusClick, this);
        this.callParent(arguments);
    },
    
    // private
    onFieldValidation : function(f, isValid) {
        var me = this,
            msg;

        if (!me.monitor) {
            return false;
        }
        msg = f.getErrors()[0];
        if (msg) {
            me.errors.add(f.id, {field:f, msg:msg});
        } else {
            me.errors.removeAtKey(f.id);
        }
        this.updateErrorList();
        if (me.errors.getCount() > 0) {
            if (me.statusBar.getText() !== me.showText) {
                me.statusBar.setStatus({
                    text: me.showText,
                    iconCls: me.errorIconCls
                });
            }
        } else {
            me.statusBar.clearStatus().setIcon(me.validIconCls);
        }
    },

    // private
    updateErrorList : function() {
        var me = this,
            msg,
            msgEl = me.getMsgEl();

        if (me.errors.getCount() > 0) {
            msg = ['<ul>'];
            this.errors.each(function(err) {
                msg.push('<li id="x-err-', err.field.id, '"><a href="#">', err.msg, '</a></li>');
            });
            msg.push('</ul>');
            msgEl.update(msg.join(''));
        } else {
            msgEl.update('');
        }
        // reset msgEl size
        msgEl.setSize('auto', 'auto');
    },
    
    // private
    getMsgEl : function() {
        var me = this,
            msgEl = me.msgEl,
            t;

        if (!msgEl) {
            msgEl = me.msgEl = Ext.DomHelper.append(Ext.getBody(), {
                cls: me.errorListCls
            }, true);
            msgEl.hide();
            msgEl.on('click', function(e) {
                t = e.getTarget('li', 10, true);
                if (t) {
                    Ext.getCmp(t.id.split('x-err-')[1]).focus();
                    me.hideErrors();
                }
            }, null, {stopEvent: true}); // prevent anchor click navigation
        }
        return msgEl;
    },
    
    // private
    showErrors : function() {
        var me = this;

        me.updateErrorList();
        me.getMsgEl().alignTo(me.statusBar.getEl(), me.listAlign).slideIn('b', {duration: 300, easing: 'easeOut'});
        me.statusBar.setText(me.hideText);
        me.formPanel.body.on('click', me.hideErrors, me, {single:true}); // hide if the user clicks directly into the form
    },

    // private
    hideErrors : function() {
        var el = this.getMsgEl();
        if (el.isVisible()) {
            el.slideOut('b', {duration: 300, easing: 'easeIn'});
            this.statusBar.setText(this.showText);
        }
        this.formPanel.body.un('click', this.hideErrors, this);
    },
    
    // private
    onStatusClick : function() {
        if (this.getMsgEl().isVisible()) {
            this.hideErrors();
        } else if (this.errors.getCount() > 0) {
            this.showErrors();
        }
    }
});/**
 * @author Ed Spencer
 *
<pre><code>
Ext.create('Ext.view.View', {
    mixins: {
        draggable: 'Ext.ux.DataView.Draggable'
    },

    initComponent: function() {
        this.mixins.draggable.init(this, {
            ddConfig: {
                ddGroup: 'someGroup'
            }
        });

        this.callParent(arguments);
    }
});
</code></pre>
 *
 */
Ext.define('Ext.ux.DataView.Draggable', {
    requires: 'Ext.dd.DragZone',

    /**
     * @cfg {String} ghostCls The CSS class added to the outermost element of the created ghost proxy
     * (defaults to 'x-dataview-draggable-ghost')
     */
    ghostCls: 'x-dataview-draggable-ghost',

    /**
     * @cfg {Ext.XTemplate/Array} ghostTpl The template used in the ghost DataView
     */
    ghostTpl: [
        '<tpl for=".">',
            '{title}',
        '</tpl>'
    ],

    /**
     * @cfg {Object} ddConfig Config object that is applied to the internally created DragZone
     */

    /**
     * @cfg {String} ghostConfig Config object that is used to configure the internally created DataView
     */

    init: function(dataview, config) {
        /**
         * @property dataview
         * @type Ext.view.View
         * The Ext.view.View instance that this DragZone is attached to
         */
        this.dataview = dataview;

        dataview.on('render', this.onRender, this);

        Ext.apply(this, {
            itemSelector: dataview.itemSelector,
            ghostConfig : {}
        }, config || {});

        Ext.applyIf(this.ghostConfig, {
            itemSelector: 'img',
            cls: this.ghostCls,
            tpl: this.ghostTpl
        });
    },

    /**
     * @private
     * Called when the attached DataView is rendered. Sets up the internal DragZone
     */
    onRender: function() {
        var config = Ext.apply({}, this.ddConfig || {}, {
            dvDraggable: this,
            dataview   : this.dataview,
            getDragData: this.getDragData,
            getTreeNode: this.getTreeNode,
            afterRepair: this.afterRepair,
            getRepairXY: this.getRepairXY
        });

        /**
         * @property dragZone
         * @type Ext.dd.DragZone
         * The attached DragZone instane
         */
        this.dragZone = Ext.create('Ext.dd.DragZone', this.dataview.getEl(), config);
    },

    getDragData: function(e) {
        var draggable = this.dvDraggable,
            dataview  = this.dataview,
            selModel  = dataview.getSelectionModel(),
            target    = e.getTarget(draggable.itemSelector),
            selected, dragData;

        if (target) {
            if (!dataview.isSelected(target)) {
                selModel.select(dataview.getRecord(target));
            }

            selected = dataview.getSelectedNodes();
            dragData = {
                copy: true,
                nodes: selected,
                records: selModel.getSelection(),
                item: true
            };

            if (selected.length == 1) {
                dragData.single = true;
                dragData.ddel = target;
            } else {
                dragData.multi = true;
                dragData.ddel = draggable.prepareGhost(selModel.getSelection()).dom;
            }

            return dragData;
        }

        return false;
    },

    getTreeNode: function() {
        // console.log('test');
    },

    afterRepair: function() {
        this.dragging = false;

        var nodes  = this.dragData.nodes,
            length = nodes.length,
            i;

        //FIXME: Ext.fly does not work here for some reason, only frames the last node
        for (i = 0; i < length; i++) {
            Ext.get(nodes[i]).frame('#8db2e3', 1);
        }
    },

    /**
     * @private
     * Returns the x and y co-ordinates that the dragged item should be animated back to if it was dropped on an
     * invalid drop target. If we're dragging more than one item we don't animate back and just allow afterRepair
     * to frame each dropped item.
     */
    getRepairXY: function(e) {
        if (this.dragData.multi) {
            return false;
        } else {
            var repairEl = Ext.get(this.dragData.ddel),
                repairXY = repairEl.getXY();

            //take the item's margins and padding into account to make the repair animation line up perfectly
            repairXY[0] += repairEl.getPadding('t') + repairEl.getMargin('t');
            repairXY[1] += repairEl.getPadding('l') + repairEl.getMargin('l');

            return repairXY;
        }
    },

    /**
     * Updates the internal ghost DataView by ensuring it is rendered and contains the correct records
     * @param {Array} records The set of records that is currently selected in the parent DataView
     * @return {Ext.view.View} The Ghost DataView
     */
    prepareGhost: function(records) {
        var ghost = this.createGhost(records),
            store = ghost.store;

        store.removeAll();
        store.add(records);

        return ghost.getEl();
    },

    /**
     * @private
     * Creates the 'ghost' DataView that follows the mouse cursor during the drag operation. This div is usually a
     * lighter-weight representation of just the nodes that are selected in the parent DataView.
     */
    createGhost: function(records) {
        if (!this.ghost) {
            var ghostConfig = Ext.apply({}, this.ghostConfig, {
                store: Ext.create('Ext.data.Store', {
                    model: records[0].modelName
                })
            });

            this.ghost = Ext.create('Ext.view.View', ghostConfig);

            this.ghost.render(document.createElement('div'));
        }

        return this.ghost;
    }
});
/**
 * This plugin can enable a cell to cell drag and drop operation within the same grid view.
 *
 * Note that the plugin must be added to the grid view, not to the grid panel. For example, using {@link Ext.panel.Table viewConfig}:
 *
 *      viewConfig: {
 *          plugins: {
 *              ptype: 'celldragdrop',
 *
 *              // Remove text from source cell and replace with value of emptyText.
 *              applyEmptyText: true,
 *
 *              //emptyText: Ext.String.htmlEncode('<<foo>>'),
 *
 *              // Will only allow drops of the same type.
 *              enforceType: true
 *          }
 *      }
 */
Ext.define('Ext.ux.CellDragDrop', {
    extend: 'Ext.AbstractPlugin',
    alias: 'plugin.celldragdrop',

    uses: ['Ext.view.DragZone'],

    /**
     * @cfg {Boolean} enforceType
     * Set to `true` to only allow drops of the same type.
     *
     * Defaults to `false`.
     */
    enforceType: false,

    /**
     * @cfg {Boolean} applyEmptyText
     * If `true`, then use the value of {@link #emptyText} to replace the drag record's value after a node drop.
     * Note that, if dropped on a cell of a different type, it will convert the default text according to its own conversion rules.
     *
     * Defaults to `false`.
     */
    applyEmptyText: false,

    /**
     * @cfg {Boolean} emptyText
     * If {@link #applyEmptyText} is `true`, then this value as the drag record's value after a node drop.
     *
     * Defaults to an empty string.
     */
    emptyText: '',

    /**
     * @cfg {Boolean} dropBackgroundColor
     * The default background color for when a drop is allowed.
     *
     * Defaults to green.
     */
    dropBackgroundColor: 'green',

    /**
     * @cfg {Boolean} noDropBackgroundColor
     * The default background color for when a drop is not allowed.
     *
     * Defaults to red.
     */
    noDropBackgroundColor: 'red',

    //<locale>
    /**
     * @cfg {String} dragText
     * The text to show while dragging.
     *
     * Two placeholders can be used in the text:
     *
     * - `{0}` The number of selected items.
     * - `{1}` 's' when more than 1 items (only useful for English).
     */
    dragText: '{0} selected row{1}',
    //</locale>

    /**
     * @cfg {String} ddGroup
     * A named drag drop group to which this object belongs. If a group is specified, then both the DragZones and
     * DropZone used by this plugin will only interact with other drag drop objects in the same group.
     */
    ddGroup: "GridDD",

    /**
     * @cfg {Boolean} enableDrop
     * Set to `false` to disallow the View from accepting drop gestures.
     */
    enableDrop: true,

    /**
     * @cfg {Boolean} enableDrag
     * Set to `false` to disallow dragging items from the View.
     */
    enableDrag: true,

    /**
     * @cfg {Object/Boolean} containerScroll
     * True to register this container with the Scrollmanager for auto scrolling during drag operations.
     * A {@link Ext.dd.ScrollManager} configuration may also be passed.
     */
    containerScroll: false,

    init: function (view) {
        var me = this;

        view.on('render', me.onViewRender, me, {
            single: true
        });
    },

    destroy: function () {
        var me = this;

        Ext.destroy(me.dragZone, me.dropZone);
    },

    enable: function () {
        var me = this;

        if (me.dragZone) {
            me.dragZone.unlock();
        }
        if (me.dropZone) {
            me.dropZone.unlock();
        }
        me.callParent();
    },

    disable: function () {
        var me = this;

        if (me.dragZone) {
            me.dragZone.lock();
        }
        if (me.dropZone) {
            me.dropZone.lock();
        }
        me.callParent();
    },

    onViewRender: function (view) {
        var me = this,
            scrollEl;

        if (me.enableDrag) {
            if (me.containerScroll) {
                scrollEl = view.getEl();
            }

            me.dragZone = new Ext.view.DragZone({
                view: view,
                ddGroup: me.dragGroup || me.ddGroup,
                dragText: me.dragText,
                containerScroll: me.containerScroll,
                scrollEl: scrollEl,
                getDragData: function (e) {
                    var view = this.view,
                        item = e.getTarget(view.getItemSelector()),
                        record = view.getRecord(item),
                        clickedEl = e.getTarget(view.getCellSelector()),
                        dragEl;

                    if (item) {
                        dragEl = document.createElement('div');
                        dragEl.className = 'x-form-text';
                        dragEl.appendChild(document.createTextNode(clickedEl.textContent || clickedEl.innerText));

                        return {
                            event: new Ext.EventObjectImpl(e),
                            ddel: dragEl,
                            item: e.target,
                            columnName: view.getGridColumns()[clickedEl.cellIndex].dataIndex,
                            record: record
                        };
                    }
                },

                onInitDrag: function (x, y) {
                    var self = this,
                        data = self.dragData,
                        view = self.view,
                        selectionModel = view.getSelectionModel(),
                        record = data.record,
                        el = data.ddel;

                    // Update the selection to match what would have been selected if the user had
                    // done a full click on the target node rather than starting a drag from it.
                    if (!selectionModel.isSelected(record)) {
                        selectionModel.select(record, true);
                    }

                    self.ddel.update(el.textContent || el.innerText);
                    self.proxy.update(self.ddel.dom);
                    self.onStartDrag(x, y);
                    return true;
                }
            });
        }

        if (me.enableDrop) {
            me.dropZone = new Ext.dd.DropZone(view.el, {
                view: view,
                ddGroup: me.dropGroup || me.ddGroup,
                containerScroll: true,

                getTargetFromEvent: function (e) {
                    var self = this,
                        v = self.view,
                        cell = e.getTarget(v.cellSelector),
                        row, columnIndex;

                    // Ascertain whether the mousemove is within a grid cell.
                    if (cell) {
                        row = v.findItemByChild(cell);
                        columnIndex = cell.cellIndex;

                        if (row && Ext.isDefined(columnIndex)) {
                            return {
                                node: cell,
                                record: v.getRecord(row),
                                columnName: self.view.up('grid').columns[columnIndex].dataIndex
                            };
                        }
                    }
                },

                // On Node enter, see if it is valid for us to drop the field on that type of column.
                onNodeEnter: function (target, dd, e, dragData) {
                    var self = this,
                        destType = target.record.fields.get(target.columnName).type.type.toUpperCase(),
                        sourceType = dragData.record.fields.get(dragData.columnName).type.type.toUpperCase();

                    delete self.dropOK;

                    // Return if no target node or if over the same cell as the source of the drag.
                    if (!target || target.node === dragData.item.parentNode) {
                        return;
                    }

                    // Check whether the data type of the column being dropped on accepts the
                    // dragged field type. If so, set dropOK flag, and highlight the target node.
                    if (me.enforceType && destType !== sourceType) {

                        self.dropOK = false;

                        if (me.noDropCls) {
                            Ext.fly(target.node).addCls(me.noDropCls);
                        } else {
                            Ext.fly(target.node).applyStyles({
                                backgroundColor: me.noDropBackgroundColor
                            });
                        }

                        return;
                    }

                    self.dropOK = true;

                    if (me.dropCls) {
                        Ext.fly(target.node).addCls(me.dropCls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: me.dropBackgroundColor
                        });
                    }
                },

                // Return the class name to add to the drag proxy. This provides a visual indication
                // of drop allowed or not allowed.
                onNodeOver: function (target, dd, e, dragData) {
                    return this.dropOK ? this.dropAllowed : this.dropNotAllowed;
                },

                // Highlight the target node.
                onNodeOut: function (target, dd, e, dragData) {
                    var cls = this.dropOK ? me.dropCls : me.noDropCls;

                    if (cls) {
                        Ext.fly(target.node).removeCls(cls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: ''
                        });
                    }
                },

                // Process the drop event if we have previously ascertained that a drop is OK.
                onNodeDrop: function (target, dd, e, dragData) {
                    if (this.dropOK) {
                        target.record.set(target.columnName, dragData.record.get(dragData.columnName));
                        if (me.applyEmptyText) {
                            dragData.record.set(dragData.columnName, me.emptyText);
                        }
                        return true;
                    }
                },

                onCellDrop: Ext.emptyFn
            });
        }
    }
});
//@charset UTF-8
/**
 * Unilite 용 Util 모음 
 */
 
Ext.define('Unilite.com.UniUtils', {
    alternateClassName: ['UniUtils'],
	singleton: true,
	/**
	 * jQuery의 param함수를 구현함. 
	 * @param {} obj
	 * @return {}
	 */
	param: function(obj) {
		var s = [],r20 = /%20/g,
			add = function( key, value ) {
				s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
			};
		for ( var prefix in obj ) {	
         	add(prefix, obj[prefix]);  
		}

	    return s.join( "&" ).replace( r20, "+" );
	} ,
	stringifyJson: function(obj) {
	    return encodeURIComponent(JSON.stringify(obj))
	},
	msg : function(title, format){
			createBox = function(t, s) {
				return '<div class="msg"><h3>' + t + '</h3><p>' + s + '</p></div>';
			}
            if(!this.msgCt){
                this.msgCt = Ext.core.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
            }
            var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
            var m = Ext.core.DomHelper.append(this.msgCt, createBox(title, s), true);
            m.hide();
            m.slideIn('t').ghost("t", { delay: 1000, remove: true});
    },
	indexOf: function(v, values) {
		if(Array.isArray(values)) {
			if(values.indexOf(v) > -1) return true;
		}else{
			if(v == values) return true;
		}
		return false;
	}
});
/**
 * formfield label helper
 */
/*
 Ext.Function.createInterceptor(Ext.form.Field.prototype.initComponent, function() {
	console.log('intercept');
  var fl = this.fieldLabel, h = this.helpText;
  if (h && h !== '' && fl) {
   
});
*///@charset UTF-8
/**
 *  form 과 grid를 같은 함수(get, set)로 처리하기 위한 객체
 */
Ext.define('Unilite.com.ValidateService.ExtRec',{
	type : null,
	obj: null,
	constructor: function(config) {
		Ext.apply(this, config);
	},
	/**
	 * 
	 * @param {} fieldName
	 * @return {}
	 */
	get:function(fieldName) {
		if(this.type =='grid') {
			return this.obj.get(fieldName);
		} else if ( this.type == 'form' ) {
			return this.obj.getValue(fieldName);
		}
	},
	/**
	 * 
	 * @param {} fieldName
	 * @param {} value
	 * @return {}
	 */
	set:function(fieldName, value) {
		if(this.type =='grid') {
			return this.obj.set(fieldName, value);
		} else if( this.type == 'form' ) {
			return this.obj.setValue(fieldName, value);
		}
	}
});//ExtRec

/**
 * @class Unilite.com.ValidateService
 * 
 */
Ext.define('Unilite.com.ValidateService',{
	/**
	 * 
	 * @cfg {Unilite.com.data.UniStore} 
	 */
	store : null,
	/**
	 * 
	 * @cfg {Unilite.com.grid.UniGridPanel} 
	 */
	grid: null,
	/**
	 * 
	 * @cfg {Unilite.com.form.UniDetailForm} 
	 */
	forms:null, 
	
	constructor: function(config) {
		Ext.apply(this, config);
		var me = this;
		console.log("uniValidator");
		if(me.grid) {
			console.log('grid added');
			me.grid.on('validateedit',function(editor, e)  {
				/**
				 * editor : Ext.grid.plugin.CellEditing
				 * e : Object
				 *   An edit event with the following properties:
				 *   	grid - The grid
				 *   	record - The record being edited	
				 *   		//  e.record.data[e.field] = e.value;
				 *   	field - The field name being edited
				 *   	value - The value being set
				 *   	originalValue - The original value for the field, before the edit.
				 *   	row - The grid table row
				 *   	column - The grid Column defining the column that is being edited.
				 *   	rowIdx - The row index that is being edited
				 *   	colIdx - The column index that is being edited
				 *   	cancel - Set this to true to cancel the edit or return false from your handler.
				 */
				var eRec = Ext.create('Unilite.com.ValidateService.ExtRec', {type:'grid', obj:e.record});
				
				var rv = me.validate('grid', e.field, e.value, e.originalValue, eRec,  me.grid, editor, e);
				if(rv != true) { 
					e.cancel = true;
					if(rv != false) {
						me.alert(rv, e.column.text); // 오류 메시지						
					}
					
				} else {
					// 정상일 경우 
				}
			}); // validateedit 
		} // me.grid
        
		if(me.forms && Ext.isObject(me.forms)) {   // typeof obj !== 'object'
			//var keys = Unilite.getKeys(me.forms); // Object.keys(obj) IE 9부터 지원
			
			for(var key in me.forms) {
				var form = me.forms[key]; 
				if(form instanceof Ext.form.Panel ) {
					console.log('Validator Service for form : ' , form.id);
					var fields = form.getForm().getFields( );
					for(i = 0, len = fields.length; i < len; i ++) {
						var field = fields.getAt(i);
						// 사실 getFields에서는 form 필드만 가져옴 					
						if(field.isFormField) {
							// validator - text/number
							
							// 각 필드에 담담 폼
							Ext.apply(field, {uniOpt: {ownForm:form}});
							
							// 각 필드에 validator 함수 정의 ( 메모리 효율성을 위해 외부 함수사용) 
							// radiogroup과 checkboxgroup는 validator를 사용 하지 않음 
							// 그래서 uniRadioGroup과 uniCheckBox그룹만지원함..!!!
							
							Ext.apply(field, {'validator': function() {
										var field = this;
										//console.log()
										return me._fieldBeforeFn(field, me);
									} // function
							});
						}
						
					}
				} 
			} // for forms
		}// me.forms
	}, 

	setUseConfirmMsg: function ( b )	{
		this._useConfirmMsg = b;
	},
	// form 항목의 validator 호출 /호출 처리 사전 사후 처리 
	_fieldBeforeFn:function(field, service ) {
		var rv = true,  form=field.uniOpt.ownForm, lastValidValue = field.uniOpt.lastValidValue;
		var newValue = field.value;
		
		console.log('Validator check : ' , form.id,'-',field.name, field.uniChanged );		
		if(field.uniChanged) {
			if(form.uniOpt.inLoading) {
				var uniOpt = field.uniOpt || {};
				Ext.apply(uniOpt, {'lastValidValue': newValue});
				field.uniOpt = uniOpt;
			}
			
			//if(!form.uniOpt.inLoading && field.isDirty()) {
			if(!form.uniOpt.inLoading) {
				//console.log('Validator dirty : ' , form.id);;
				// form 과 grid를 같은 함수로 처리하기 위한 객체
				var eRec = Ext.create('Unilite.com.ValidateService.ExtRec', {type:'form', obj:form});
				//form.activeRecord
				var rv = service.validate('field', field.name, newValue, lastValidValue, eRec, form, field, null);
				if(rv != true ) {
					service.resetToLastValue(field );
					service.alert(rv, field.fieldLabel); // 오류 메시지
				}else {
					var uniOpt = field.uniOpt || {};
					Ext.apply(uniOpt, {'lastValidValue': newValue});
					field.uniOpt = uniOpt;
				}
			}
		}
		return rv;
	},
	
	resetToLastValue : function(field){
        var me = field, uniOpt = field.uniOpt || {};

        me.beforeReset();
        me.setValue(uniOpt.lastValidValue || me.originalValue);
        me.clearInvalid();
        // delete here so we reset back to the original state
        delete me.wasValid;
    },
	/**
	 * 
	 * @param {} type		[grid | form]
	 * @param {} fieldName	수정이 발생된 column name
	 * @param {} newValue	신규값
	 * @param {} oldValue
	 * @param {} record
	 * @param {} eopt
	 * @return {Boolean|string}		
	 */
	validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		return true;
	}, 
	alert: function(message, tit) {
		if(!(message == false || message == true || message == undefined))	{
			Ext.MessageBox.show({
	                        title: tit || 'Alert',
	                        msg: message,
	                        icon: Ext.MessageBox.ERROR,
	                        buttons: Ext.Msg.OK
	                    });
		}
	}
});  // ValidateService//@charset UTF-8
/**
 * 
 */
Ext.define('Unilite.com.UniValidator',{
    alternateClassName: ['UniValidator'],
    singleton: true
    
    // 주민등록번호
    ,residentno : function(value) {
	    var pattern = /^(\d{6})-?(\d{5}(\d{1})\d{1})$/;
	    var num = value;
	    var errorMsg = "residentno";
	    if (!pattern.test(num)) return errorMsg;
	    num = RegExp.$1 + RegExp.$2;
	    if (RegExp.$3 == 7 || RegExp.$3 == 8 || RegExp.$4 == 9)
	        if ((num[7]*10 + num[8]) %2) return errorMsg;
	
	    var sum = 0;
	    var last = num.charCodeAt(12) - 0x30;
	    var bases = "234567892345";
	    for (var i=0; i<12; i++) {
	        if (isNaN(num.substring(i,i+1))) return errorMsg;
	        sum += (num.charCodeAt(i) - 0x30) * (bases.charCodeAt(i) - 0x30);
	    };
	    var mod = sum % 11;
	    if(RegExp.$3 == 7 || RegExp.$3 == 8 || RegExp.$4 == 9)
	        return (11 - mod + 2) % 10 == last ? true : errorMsg;
	    else
	        return (11 - mod) % 10 == last ? true : errorMsg;
	}
	,bizno : function(value) {
	    var pattern = /([0-9]{3})-?([0-9]{2})-?([0-9]{5})/;
	    var num = value;
	    var errorMsg = "bizno";
	    if (!pattern.test(num)) return errorMsg;
	    num = RegExp.$1 + RegExp.$2 + RegExp.$3;
	    var cVal = 0;
	    for (var i=0; i<8; i++) {
	        var cKeyNum = parseInt(((_tmp = i % 3) == 0) ? 1 : ( _tmp  == 1 ) ? 3 : 7);
	        cVal += (parseFloat(num.substring(i,i+1)) * cKeyNum) % 10;
	    };
	    var li_temp = parseFloat(num.substring(i,i+1)) * 5 + "0";
	    cVal += parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2));
	    return parseInt(num.substring(9,10)) == 10-(cVal % 10)%10 ? true : errorMsg;
	}
	,phone : function(value) {	
	    var errorMsg = "phone";
	    var pattern = /^(0[2-8][0-5]?|01[01346-9])-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var pattern15xx = /^(1544|1566|1577|1588|1644|1688)-?([0-9]{4})$/;
	    var num = value ;
	    return pattern.test(num) || pattern15xx.test(num) ? true : errorMsg;
		/*
	    var pattern = /^([0-9]+)([0-9|-]*)([0-9]+)$/;
	    var num = value ;
	    return pattern.test(num) ? true : false;
	    */
	}
	// 집전화 
	,homephone : function(value) {
	    var errorMsg = "homephone";
	    var pattern = /^(0[2-8][0-5]?)-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var pattern15xx = /^(1544|1566|1577|1588|1644|1688)-?([0-9]{4})$/;
	    var num = value;
	    return pattern.test(num) || pattern15xx.test(num) ? true : errorMsg;
	}
	// 휴대폰
	,handphone : function(value) {
	    var errorMsg = "handphone";
	    var pattern = /^(01[01346-9])-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var num = value;
	    return pattern.test(num) ? true : errorMsg;
	}
	,isDate : function(value) {
	    var errorMsg = "isDate";
	    var value = value;
	    var t = value.replace(/-/g, "");
	    var chk = this._validateDate(t)
	    return (chk) ? true :  errorMsg;
	}
	/*************************
	 * 
	 * @param {} parsedDate
	 * @return {Boolean}
	 */
	,_validateDate :function(parsedDate) {
		var day, month, year;
		if (parsedDate.length != 8) {
			return false;
		}
		try {
			year = parsedDate.substr(0, 4);
			month = parsedDate.substr(4, 2);
			day = parsedDate.substr(6, 2);
			
			var dt = new Date( month + "/" + day + "/" + year );
			
			if (month != dt.getMonth()+1)
				return false;
			if (day != dt.getDate())
				return false;
			if (year != dt.getFullYear())
				return false;
			return true;
		} catch (e) {
			return false;
		}
	}
});

//@charset UTF-8
/**
 * @class Ext.data.Types
 * 
 * Unilite용 확장 Types
 * 타입 첫글짜는 무조건 대문자로 !!!
 * @type 
 */
var st = Ext.data.SortTypes;
Ext.apply(Ext.data.Types, {
	/**
	 * 
	 * @type 
	 */
	UNIDATE : {
		    convert: function(v) {
                if (!v) {
                    return null;
                }
                // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
                if (v instanceof Date) {
                    return v;
                }
                return UniDate.extParseDate(v);
                //console.log(v, rv);
                //return rv;
	        },
	        sortType: Ext.data.SortTypes.asDate,
	        type: 'uniDate'
	},
	UNIMONTH : {
		    convert: function(v) {
                if (!v) {
                    return null;
                }
                // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
                if (v instanceof Date) {
                    return v;
                }
                return v;
                //console.log(v, rv);
                //return rv;
	        },
	        sortType: Ext.data.SortTypes.asDate,
	        type: 'uniMonth'
	},
	/**
	 * 
	 * @type 
	 */
	UNITIME : {
	    convert: function(v) {
	    	if (!v) {
                    return null;
            }
			if (typeof v == 'number') {
                return parseInt(v);
            }
    		
            // instanceof check ~10 times faster than Ext.isDate. Values here will not be cross-document objects
            if (v instanceof Date) {
                return v;
            }
            return UniDate.extParseDate(v);
//                return v !== undefined && v !== null && v !== '' ?
//                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	     },
	        
        sortType: Ext.data.SortTypes.none,
        type: 'uniTime'
	},
	UNIYEAR : {
	    convert: function(v) {
			if (typeof v == 'number') {
                    return parseInt(v);
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	        },
        sortType: Ext.data.SortTypes.none,
        type: 'uniYear'
	},
	UNIQTY : {
	    convert: function(v) {
			if (typeof v == 'number') {
                    return parseInt(v);
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseInt(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
	        },
        sortType: Ext.data.SortTypes.none,
        type: 'uniQty'
	},
	UNIPRICE : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniPrice'
	},
	UNIUNITPRICE : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniUnitPrice'
	},
	UNIPERCENT : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniPercent'
	},
	UNIFC : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniFC'
	},
	UNIER : {
            convert: function(v) {
                if (typeof v === 'number') {
                    return v;
                }
                return v !== undefined && v !== null && v !== '' ?
                    parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
            },
	        sortType: Ext.data.SortTypes.none,
	        type: 'uniER'
	},
	UNIPASSWORD : {
             convert: function(v) {
                var defaultValue = this.useNull ? null : '';
                return (v === undefined || v === null) ? defaultValue : String(v);
            },
            sortType: st.asUCString,
	        type: 'uniPassword'
	}
});//@charset UTF-8

window.onerror = function(msg, url, line, col, error) {
   // Note that col & error are new to the HTML 5 spec and may not be 
   // supported in every browser.  It worked for me in Chrome.
   var extra = !col ? '' : '\ncolumn: ' + col;
   extra += !error ? '' : '\nerror: ' + error;

   // You can view the information in an alert to see things working like this:
   var errorMsg = "Error: " + msg + "\nurl: " + url + "\nline: " + line + extra;
   console.log(errorMsg);
   alert(errorMsg);

   // TODO: Report this error via ajax so you can keep track
   //       of what pages have JS issues

   var suppressErrorAlert = false; // true
   // If you return true, then error alerts (like in older versions of 
   // Internet Explorer) will be suppressed.
   return suppressErrorAlert;
};
/*
 * Debuger가 설치 안된 브라우져(일부 IE)에서 console 오류 발생 방지
 */
var alertFallback = false;

if (typeof console === "undefined" || typeof console.log === "undefined") {
	// https://developer.mozilla.org/en-US/docs/Web/API/console
	console = {
		/**
	    * @private
	    */
		_out: function(msg) {
			if (alertFallback) {
					alert(msg);
			}
		},
		log: function(msg) {
			this._out(msg);
		},
		info: function(msg) {
			this._out(msg);
		},
		warn: function(msg) {
			this._out(msg);
		},
		error: function(msg) {
			this._out(msg);
		}
	};
}

function hideAddressBar() {
  if(!window.location.hash){
      if(document.height < window.outerHeight)
      {
          document.body.style.height = (window.outerHeight + 50) + 'px';
      }
 
      setTimeout( function(){ 
        window.scrollTo(0, 1);
       }, 50 );
  }
}




/**
 * @class Unilite
 * ## 사용예 
 * 
 * 
 */


//Ext.Error.handle = function(err) {
//    if (err.someProperty == 'NotReallyAnError') {
//        // maybe log something to the application here if applicable
//        return true;
//    }
//    console.log("ERROR!ERRO!\n");
//    console.log(err);
//    // any non-true return value (including none) will cause the error to be thrown
//}


Ext.define('Unilite', {
    singleton: true,
    requires: [
    	'Unilite.com.UniValidator'
	],
	/**
	 * default DB용 date format (Ymd, '20141231')
	 * @type String
	 */
    dbDateFormat: 'Ymd',
    dbMonthFormat: 'Ym',
    /**
	 * default date display format (Ymd, '2014.12.31')
	 * system설정에따라 변경됨.
	 * @type String
	 */
    dateFormat :'Y.m.d',
    monthFormat :'Y.m',
    /**
     * 
     * @type String
     */
    altFormats : 'Ymd|Y.m.d|Y/m/d|Y-m-d|Y-m-d H:i:s',
    altMonthFormats : 'Ym|Y.m|Y/m|Y-m|Ymd|Y.m.d|Y/m/d|Y-m-d',
    /**
     * null이나 empty이면 defaultValue를 돌려줌
     * @param {} obj
     * @param {} defaultValue
     * @return {}
     */
    nvl: function(obj, defaultValue) {
    	if(!Ext.isDefined(obj)) { 
    		return defaultValue;
    	}
		return Ext.isEmpty(obj) ? defaultValue : obj;
	}, // nvl
    /**
     * 확장자 "do"인 js 프로그램 Load 함수.
     * @param {} className
     * @param {} onLoad
     * @param {Object} scope
     * @param {Boolean} forceReload
     */
	require: function(className, onLoad, scope, forceReload) {
        var Loader = Ext.Loader,
            Manager = Ext.ClassManager,
            pass = Ext.Function.pass;
            
        scope = scope || Ext.global;
        if(!Ext.isDefined(forceReload)) {
            forceReload = false;
        }
        
        var isCreated = false;
        // 한번 로딩 했으면 다시 읽지 않게 처리
        if(forceReload) {
            isCreated = false;
            var objArray=Ext.ComponentQuery.query(className);
            if(objArray) {
                for (var i=0; i<objArray.length; i++) {
				    objArray[i].destroy();
				}
            }
        } else {
            isCreated = Manager.isCreated(className); 
        }
        if(!isCreated) {
	        var filePath = Loader.getPath(className);
//	        if(!Ext.isEmpty(EXT_ROOT))
//	        	filePath = filePath.replace(EXT_ROOT+"/", "")
	        filePath = filePath.substring(0, filePath.length-3) + '.do';
	        if(!onLoad) {
	             onLoad = function() { console.log(className + " loaded.");};
	        }
	        //Ext.Loader.loadScriptFile(newPath,onLoad,function() {},Ext.Loader,false);
	        Loader.loadScriptFile(
	                        filePath,
	                        onLoad, //pass(Loader.onFileLoaded, [className, filePath], Loader),
	                        pass(Loader.onFileLoadError, [className, filePath], Loader),
	                        Loader,
	                        false
	        );        
	        console.log("Dynamic javascript load. Path = " + filePath);
        } else {
            onLoad.call(scope);
        }
    },
	grid: {
		comboRenderer : function(combo){
		    return function(value){
		    	//multiSelect 일 때 grid에서 combo 선택하면 blank 로 보여되는 오류로 인해 변경
//		        var record = combo.findRecord(combo.valueField, value);
//		        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
		    	
		    	var valueNotFoundText = combo.valueNotFoundText,
		            i, len, record,
		            dataObj,
		            displayTplData = [];
						
		        if(combo.multiSelect && typeof value === 'string' && value.indexOf(combo.delimiter.trim()) > -1 ) {
		        	value = value.split(combo.delimiter.trim());
		        }else{
		        	value = Ext.Array.from(value);
		        }
		        for (i = 0, len = value.length; i < len; i++) {
		            record = value[i];
		            if (!record || !record.isModel) {
		                record = combo.findRecordByValue(record);
		            }
		 
		            if (record) {
		                displayTplData.push(record.data);
		            }
		            else {
		                if (!combo.forceSelection) {
		                    dataObj = {};
		                    dataObj[combo.displayField] = value[i];
		                    displayTplData.push(dataObj);
		                }
		                else if (Ext.isDefined(valueNotFoundText)) {
		                    displayTplData.push(valueNotFoundText);
		                }
		            }
		        }
				        
		        combo.displayTplData = displayTplData;
		        combo.setRawValue(combo.getDisplayValue());
		        
		    	return combo.getRawValue();
		    }
		}
	}, // grid,
	form: {
		createCombobox : function(field) {
			var lComboType = field.comboType, 
				lComboCode=field.comboCode;
			var lAllowBlank = Unilite.nvl(field['allowBlank'],true);
			var comboConfig ={ 
							comboType: field.comboType,
							comboCode: field.comboCode,
							allowBlank: field.allowBlank,
							store:field.store
						};
			// 다단계 콤보 처리 
			if(field.child) {
				Ext.apply(comboConfig, {'child': field.child})
			}
			if(field.parentFieldName) {
				Ext.apply(comboConfig, {'parentFieldName': field.parentFieldName})
			}			
			if(field.name) {
				Ext.apply(comboConfig, {'name': field.name})
			}
			if(field.displayField) {
				Ext.apply(comboConfig, {'displayField': field.displayField})
			}
			if(field.valueField) {
				Ext.apply(comboConfig, {'valueField': field.valueField})
			}
			if(Ext.isDefined(field.multiSelect)) {
				Ext.apply(comboConfig, {'multiSelect': field.multiSelect})
			}
			if(Ext.isDefined(field.typeAhead)) {
				Ext.apply(comboConfig, {'typeAhead': field.typeAhead})
			}
			var combo = Ext.create('Unilite.com.form.field.UniComboBox', comboConfig);	
			return combo;
		} 
	},// form
	
	/**
	 * 모델을 정의 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.data.Model}
	 */
	defineModel : function (id, config) {
		config = this._fieldConfigure(config);
		Ext.apply(config, {extend:'Unilite.com.data.UniModel'});
		Ext.define(id, config);
	},
		/**
	 * Tree 모델을 정의 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.data.Model}
	 */
	defineTreeModel : function (id, config) {
		config = this._fieldConfigure(config);
		Ext.apply(config, {extend:'Unilite.com.data.UniTreeModel'});
		Ext.define(id, config);
	},
    /**
     * @private
     * @param {} config
     * @return {}
     */
	_fieldConfigure:function(config) {
		var types = Ext.data.Types;
		if(config.fields) {
			for(i =0, len = config.fields.length; i< len; i ++ ) {
				var field = config.fields[i];
				if(field.type) {
					if(field.type == 'uniDate') {
						field.type = types.UNIDATE;
						Ext.apply(field, {dateWriteFormat : Unilite.dbDateFormat});
					} else if (field.type == 'uniMonth') {
						field.type = types.UNIMONTH;
						Ext.apply(field, {dateWriteFormat : Unilite.dbMonthFormat});
					} else if (field.type == 'uniQty') {
						field.type = types.UNIQTY;
					} else if (field.type == 'uniUnitPrice') {
						field.type = types.UNIUNITPRICE;
					} else if (field.type == 'uniPrice') {
						field.type = types.UNIPRICE;
					} else if (field.type == 'uniPercent') {
						field.type = types.UNIPERCENT;
					} else if (field.type == 'uniFC') {
						field.type = types.UNIFC;
					} else if (field.type == 'uniER') {
						field.type = types.UNIER;
					} else if (field.type == 'uniTime') {
						field.type = types.UNITIME;
					} else if (field.type == 'uniYear') {
						field.type = types.UNIYEAR;
					} else if (field.type == 'uniPassword') {
						field.type = types.UNIPASSWORD;
					}
				}
				if(Ext.isDefined( field.allowBlank) ) {
					if( field.allowBlank  == false ) {
						config.validations = config.validations || [];
						config.validations.push({'type': 'presence', 'field': field.name});
					}
					
				}
				// child field 처리 
				if(field.child) {
					for(var j = 0; j < len; j++) {
						if(config.fields[j].name == field.child) {
							config.fields[j].parentFieldName = field.name;
							console.log(field.name + '\'s child is ' + field.child +'. '+ config.fields[j].name + ' parent is ' + field.name);
							//Ext.apply
							break;
						}
					}
				}
			}
		}
		return config;
	}, 
	/**
	 * UniStore 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.data.UniStore}
	 */
	createStore: function(id, config) {
		// Ext.apply(config, {'id':id, storeId: id});
        Ext.apply(config, {storeId: id});
		return  Ext.create('Unilite.com.data.UniStore', config);
	}, 
    /**
     * UniStore 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.data.UniStore}
     */
    createStoreSimple: function(id, config) {
        // Ext.apply(config, {'id':id, storeId: id});
        Ext.apply(config, {storeId: id});
        return  Ext.create('Unilite.com.data.UniStoreSimple', config);
    },     
	/**
	 * UniGridPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.grid.UniGridPanel}
	 */
	createGrid : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.grid.UniGridPanel', config);
	},
	/**
	 * UniTreeStore 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.data.UniTreeStore}
	 */
	createTreeStore: function(id, config) {
		//Ext.apply(config, {'id':id});
        Ext.apply(config, {storeId: id});
		return  Ext.create('Unilite.com.data.UniTreeStore', config);
	},	
	/**
	 * UniTreeGridPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.grid.UniGridPanel}
	 */
	createTreeGrid : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.grid.UniTreeGridPanel', config);
	},	
	/**
	 * uniSearchForm 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniSearchForm}
	 */
	createSearchForm : function(id, config) {
		Ext.apply(config, {'xtype':'uniSearchForm'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniSearchForm', config);
	},
    /**
     * uniSearchForm 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.form.UniSearchForm}
     */
    createSearchPanel : function(id, config) {
    	Ext.apply(config, {'xtype':'uniSearchPanel'});
    	if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
        //return  config;
        return Ext.create('Unilite.com.form.UniSearchPanel', config);
    },    
	/**
	 * uniDetailForm 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniDetailForm}
	 */
	createForm : function(id, config) {
		//popup 창 폼의 경우  id 룰 부여하면 중복날 수 있음.->popup의 ext.component 개체들은 id를 할당하지 않는다.
		//id를 할당하지 않으면 자동할당 됨.
		//Ext.apply(config, {'xtype':'uniDetailForm', 'id': id});
		Ext.apply(config, {'xtype':'uniDetailForm'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniDetailForm', config);
	},
	/**
	 * uniDetailFormSimple 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniDetailFormSimple}
	 */
	createSimpleForm : function(id, config) {
		Ext.apply(config, {'xtype':'uniDetailFormSimple'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniDetailFormSimple', config);
	},
	 /**
     * uniOperatePanel 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.form.UniSearchForm}
     */
    createOperatePanel : function(id, config) {
        Ext.apply(config, {'xtype':'uniOperatePanel'});
        if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
        //return  config;
        return Ext.create('Unilite.com.form.UniOperatePanel', config);
    },  
	/**
	 * UniTabPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.tab.UniTabPanel}
	 */
	createTabPanel : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.tab.UniTabPanel', config);
	},	
	/**
	 * ValidateService 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.ValidateService}
	 */
	createValidator : function(id, config) {
		Ext.apply(config, {'id':id});
		return  Ext.create('Unilite.com.ValidateService', config);
	},
	/**
	 * 
	 * @param {Object} config
	 * @return {Unilite.com.BaseApp}
	 */
	Main: function(config) {
		return Ext.create('Unilite.com.BaseApp',config);
	},
	
	/**
	 * 
	 * @param {Object} config
	 * @return {Unilite.com.BasePopupApp}
	 */
	PopupMain: function(config) {
		return Ext.create('Unilite.com.BasePopupApp',config);
	},
	/**
	 * Client가 Mobile인지 확인
	 * @return {boolean}
	 */
	isMobile: function() {
		if( this._isMobile === undefined) {
			var a = navigator.userAgent;
			// http://detectmobilebrowsers.com/
			//if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4)))  {
			if (/(ipad).+mobile|(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) )  {
				this._isMobile = true;
			} else {
				this._isMobile = false;
			}
		}
		return this._isMobile;
	},
    getViewportSize: function() {
        var viewportwidth;
	    var viewportheight;
	    // The more standards compliant browsers (mozilla/netscape/opera/chrome/IE7)
	    // use window.innerWidth and window.innerHeight
	    if (typeof window.innerWidth != 'undefined') {
	        viewportwidth = window.innerWidth;
	        viewportheight = window.innerHeight;
	    }
	    // IE6 in standards compliant mode (i.e. with a valid doctype as the first
	    // line in the document)
	    else if (typeof document.documentElement != 'undefined'
	            && typeof document.documentElement.clientWidth != 'undefined'
	            && document.documentElement.clientWidth != 0) {
	        viewportwidth = document.documentElement.clientWidth;
	        viewportheight = document.documentElement.clientHeight;
	    }
	    // older versions of IE
	    else {
	        viewportwidth = document.getElementsByTagName('body')[0].clientWidth;
	        viewportheight = document.getElementsByTagName('body')[0].clientHeight;
	    }
	    return {width:viewportwidth, height: viewportheight};
	},
    getOrientation: function() {
	    var orientation = window.orientation;
	    var rv = '';
	
	    if (orientation === 0 || orientation === 180)
	        rv = 'portrait';
	    else if (orientation === 90 || orientation === -90)
	        rv = 'landscape';
	    else {
	        // JavaScript orientation not supported. Work it out.
	        if (document.documentElement.clientWidth > document.documentElement.clientHeight)
	            rv = 'landscape';
	        else
	            rv = 'portrait';
	
	    }
	    return rv;
	},
	getScale: function() {
	    return document.body.clientWidth / window.innerWidth;
	},
	/**
	 * 검증 함수 모음.
	 * @param {String} type
	 * residentno | bizno | phone | isDate
	 * @param {String} value
	 * @return {Boolean}
	 */
	validate: function (type, value) {
		var rv;
		switch(type) 	{
			case 'residentno':
				rv = UniValidator.residentno(value);
				break;
			case 'bizno':
				rv = UniValidator.bizno(value);
				break;
			case 'phone':
				rv =  UniValidator.phone(value);
				break;
			case 'homephone':
				rv =  UniValidator.homephone(value);
				break;
			case 'handphone':
				rv =  UniValidator.handphone(value);
				break;
			case 'isDate':
				rv =  UniValidator.isDate(value);
				break;
			
			default:
				rv = false;
		}
		return rv;
	}
	,isGrandSummaryRow:function (summaryData, metaData) {
		if(Ext.String.endsWith(summaryData.record.id,'grand-summary-record')) {
			return true;
		} else {
			return false;
		}
		
	}
	,renderSummaryRow: function (summaryData, metaData, sumLabel, gsumLabel) {
		var rv = '<div align="center"></div>';
                  	
      	if(this.isGrandSummaryRow(summaryData, metaData)) {
			rv =  '<div align="center">'+gsumLabel+'</div>';
    	}  else {
			rv = '<div align="center">'+sumLabel+'</div>';
    	}
		return rv;
	}
	/**
	 * Object.keys(object) 가 IE 9 부터 지원 되어 별도로 구현 함.
	 * @param {} object
	 * @return {Array}
	 */
	,getKeys : function(object) {
		if (Type(object) !== OBJECT_TYPE) { throw new TypeError(); }
	    var results = [];
	    for (var property in object) {
	      if (object.hasOwnProperty(property)) {
	        results.push(property);
	      }
	    }
	    return results;
	}
	,getParams: function() {
		var getParams = document.URL.split("?");
		return Ext.urlDecode(getParams[getParams.length - 1]);
	},
	/**
	 * form에서 다음 폼필드로 포커스 이동
	 * @param {} field	현재 focus를 가지고 있는 폼 필드
	 * @param {} selectText	텍스트 선택 상태 활성화 여부 (optional)
	 */
	focusNextField: function(field, selectText, e) {
		var form = field.up('form');
		var focusable, targetField;		

		if(form && field.isFormField) { //form 내 필드인 경우
			if(Ext.isDefined(field.triggerBlur))
				field.triggerBlur();
			else
				field.blur();
			
			focusable = field.nextNode('field:focusable');
			if(focusable && focusable.el) {
				targetField = focusable.el.down('.x-form-field');
				if(targetField) {
					targetField.focus(10);					
					if(selectText) 
						targetField.dom.select();
				}
			}else{
				focusable = form.down('field:focusable')	// 마지막 form field 인 경우 폼의 처음에서 검색				
				if(focusable && focusable.el) {
					targetField = focusable.el.down('.x-form-field');
					if(targetField) {
						targetField.focus(10);						
						if(selectText) 
							targetField.dom.select();
					}else{
						field.focus();
					}
				}
			}
		}else {	// //grid 내 필드인 경우
			var grid = field.up('grid');
			if(grid) {
				if (e.getKey() === Ext.EventObject.RIGHT || e.getKey() === Ext.EventObject.LEFT) {
					
					e.keyCode = Ext.EventObject.TAB;
					e.shiftKey = false;
					//e.target = field.el;
					//grid.getSelectionModel().getCurrentPosition().view.editingPlugin.fireEvent('specialkey', null, field, e);
					grid.editing.fireEvent('specialkey', null, field, e);
					e.stopEvent();
				}
				
			}
		}
	},
	/**
	 * form에서 이전 폼필드로 포커스 이동
	 * @param {} field	현재 focus를 가지고 있는 폼 필드
	 * @param {} selectText	텍스트 선택 상태 활성화 여부 (optional)
	 */
	focusPrevField: function(field, selectText, e) {
		var form = field.up('form');
		var focusable, targetField; 
		
		if(form && field.isFormField) { //form 내 필드인 경우
			if(Ext.isDefined(field.triggerBlur))
				field.triggerBlur();
			else
				field.blur();
			
			focusable = field.previousNode('field:focusable');
			if(focusable && focusable.el) {
				targetField = focusable.el.down('.x-form-field');
				if(targetField) {
					targetField.focus(10);					
					if(selectText) 
						targetField.dom.select();
				}
			}else{
				focusable = form.query('field:focusable')	// 맨처음 form field 인 경우 폼의 마지막 필드 검색
				focusable = focusable[focusable.length - 1];
				if(focusable && focusable.el) {
					targetField = focusable.el.down('.x-form-field');
					if(targetField) {
						targetField.focus(10);						
						if(selectText) 
							targetField.dom.select();
					}else{
						field.focus();
					}
				}
			}
		}else {	// //grid 내 필드인 경우
			var grid = field.up('grid');
			if(grid) {
				if (e.getKey() === Ext.EventObject.RIGHT || Ext.EventObject.LEFT) {
					e.keyCode = Ext.EventObject.TAB;
					e.shiftKey = true;
					//e.target = field.el;
					//field.fireEvent('specialkey', field, e);
					//grid.getSelectionModel().getCurrentPosition().view.editingPlugin.fireEvent('specialkey', null, field, e);
					grid.editing.fireEvent('specialkey', null, field, e);
					e.stopEvent();
				}
				
			}
		}
	}

});// define(UniLite)


function uniDirectExceptionProcessor(event) {
	console.log("uniDirectExceptionProcessor / Ext.direct.Exception:", event );
	var vMessage = event.message + "<br/> - " + event.where
	if( event.type == "exception" ) {
		if (event.message == "InvalidSessionException") {
	 		Ext.MessageBox.show({
                title: 'Warning',
                msg: event.where,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK,
                fn: function(btn, text) {
                	document.location.href	= CPATH ;
                }
            });			
		} else {
	 		Ext.MessageBox.show({
                title: 'REMOTE EXCEPTION',
                msg: vMessage,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK
            });
		}
	
	} else {
			Ext.MessageBox.show({
                title:  event.type,
                msg: vMessage,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK
            });
	}
    Ext.getBody().unmask();
};


//Ext.apply(Ext.data.Types, {
//	UniPrice : {
//		convert: function(v) {
//	            if (typeof v === 'number') {
//	                return v;
//	            }
//	            return v !== undefined && v !== null && v !== '' ?
//	                parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
//	        },
//	    sortType: Ext.data.SortTypes.none,
//	    type: 'uniPrice'
//	}
//});

Ext.apply(Ext.form.VTypes, {
	/**
	 * 연도 입력시 연도 비교용 
	 * @param {} val
	 * @param {} field
	 * @return {Boolean}
	 */
    yearRange : function(val, field) {
        // startYear, endYear
        if (field.startYearField && (!this.maxValue || (val != this.maxValue))) {
            var start = Ext.getCmp(field.startYearField);
            start.setMaxValue(val);
            //start.validate();
            this.maxValue = val;
        } else if (field.endYearField && (!this.minValue || (val != this.minValue))) {
            var end = Ext.getCmp(field.endYearField);
            end.setMinValue(val);
            //end.validate();
            this.minValue = val;
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    },
    uniDateRange : function(val, field) {
    	if(! field.isInit ) {
    		field.isInit = true;
    		if(!val) {
    			return;
    		}
	        var date = field.parseDate(val);
	 
	        if(!date){
	            return;
	        }
	        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
	            //var start = Ext.getCmp(field.startDateField);
	            var start = field.startDateField;
	            start.setMaxValue(date);
	            start.validate();
	            this.dateRangeMax = date;
	        }
	        else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
	            //var end = Ext.getCmp(field.endDateField);
	            var end = field.endDateField;
	            end.setMinValue(date);
	            end.validate();
	            this.dateRangeMin = date;
	        }
	    	delete field.isInit; 
    	}
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

Ext.apply('Ext.form.field.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.grid.PropertyColumnModel', {dateFormat:Unilite.dateFormat});
Ext.apply('Ext.picker.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.util.Format', {dateFormat:Unilite.dateFormat});

	
// Advance File-Size
Ext.util.Format.fileSize = function(value) {
	if (value > 1) {
		var s = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(value) / Math.log(1024));
		if (e > 0) {
			return (value / Math.pow(1024, Math.floor(e))).toFixed(2) + " " + s[e];
		} else {
			return value + " " + s[e];
		}
	} else if (value == 1) {
		return "1 Byte";
	}
	return '-';
}

String.format = function() {
	var s = arguments[0];
	for (var i = 0; i < arguments.length - 1; i++) {
		var reg = new RegExp("\\{" + i + "\\}", "gm");
		s = s.replace(reg, arguments[i + 1]);
	}
	return s;
}
//@charset UTF-8

/*
 * Format      Description                                                               Example returned values
------      -----------------------------------------------------------------------   -----------------------
  d         Day of the month, 2 digits with leading zeros                             01 to 31
  D         A short textual representation of the day of the week                     Mon to Sun
  j         Day of the month without leading zeros                                    1 to 31
  l         A full textual representation of the day of the week                      Sunday to Saturday
  N         ISO-8601 numeric representation of the day of the week                    1 (for Monday) through 7 (for Sunday)
  S         English ordinal suffix for the day of the month, 2 characters             st, nd, rd or th. Works well with j
  w         Numeric representation of the day of the week                             0 (for Sunday) to 6 (for Saturday)
  z         The day of the year (starting from 0)                                     0 to 364 (365 in leap years)
  W         ISO-8601 week number of year, weeks starting on Monday                    01 to 53
  F         A full textual representation of a month, such as January or March        January to December
  m         Numeric representation of a month, with leading zeros                     01 to 12
  M         A short textual representation of a month                                 Jan to Dec
  n         Numeric representation of a month, without leading zeros                  1 to 12
  t         Number of days in the given month                                         28 to 31
  L         Whether it's a leap year                                                  1 if it is a leap year, 0 otherwise.
  o         ISO-8601 year number (identical to (Y), but if the ISO week number (W)    Examples: 1998 or 2004
            belongs to the previous or next year, that year is used instead)
  Y         A full numeric representation of a year, 4 digits                         Examples: 1999 or 2003
  y         A two digit representation of a year                                      Examples: 99 or 03
  a         Lowercase Ante meridiem and Post meridiem                                 am or pm
  A         Uppercase Ante meridiem and Post meridiem                                 AM or PM
  g         12-hour format of an hour without leading zeros                           1 to 12
  G         24-hour format of an hour without leading zeros                           0 to 23
  h         12-hour format of an hour with leading zeros                              01 to 12
  H         24-hour format of an hour with leading zeros                              00 to 23
  i         Minutes, with leading zeros                                               00 to 59
  s         Seconds, with leading zeros                                               00 to 59
  u         Decimal fraction of a second                                              Examples:
            (minimum 1 digit, arbitrary number of digits allowed)                     001 (i.e. 0.001s) or
                                                                                      100 (i.e. 0.100s) or
                                                                                      999 (i.e. 0.999s) or
                                                                                      999876543210 (i.e. 0.999876543210s)
  O         Difference to Greenwich time (GMT) in hours and minutes                   Example: +1030
  P         Difference to Greenwich time (GMT) with colon between hours and minutes   Example: -08:00
  T         Timezone abbreviation of the machine running the code                     Examples: EST, MDT, PDT ...
  Z         Timezone offset in seconds (negative if west of UTC, positive if east)    -43200 to 50400
  c         ISO 8601 date
            Notes:                                                                    Examples:
            1) If unspecified, the month / day defaults to the current month / day,   1991 or
               the time defaults to midnight, while the timezone defaults to the      1992-10 or
               browser's timezone. If a time is specified, it must include both hours 1993-09-20 or
               and minutes. The "T" delimiter, seconds, milliseconds and timezone     1994-08-19T16:20+01:00 or
               are optional.                                                          1995-07-18T17:21:28-02:00 or
            2) The decimal fraction of a second, if specified, must contain at        1996-06-17T18:22:29.98765+03:00 or
               least 1 digit (there is no limit to the maximum number                 1997-05-16T19:23:30,12345-0400 or
               of digits allowed), and may be delimited by either a '.' or a ','      1998-04-15T20:24:31.2468Z or
            Refer to the examples on the right for the various levels of              1999-03-14T20:24:32Z or
            date-time granularity which are supported, or see                         2000-02-13T21:25:33
            http://www.w3.org/TR/NOTE-datetime for more info.                         2001-01-12 22:26:34
  U         Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)                1193432466 or -2138434463
  MS        Microsoft AJAX serialized dates                                           \/Date(1238606590509)\/ (i.e. UTC milliseconds since epoch) or
                                                                                      \/Date(1238606590509+0800)\/
  time      A javascript millisecond timestamp                                        1350024476440
  timestamp A UNIX timestamp (same as U)                                              1350024866     
 * 
 */
/**
 * Some function from Extensible class
 */


Ext.define('Unilite.UniDate', {
    alternateClassName: 'UniDate',
    requires: [
    	'Unilite',
    	'Ext.Date'
	],
    
    singleton: true,
    dbDateFormat : Unilite.dbDateFormat,
    altFormats : Unilite.altFormats,
    mommentDBformat : "YYYYMMDD",    
    format : Unilite.dateFormat,
    /**
     * 
     * @param {} dt
     * @return {}
     */
	getDateStr: function (dt) {
		return Ext.Date.format(dt, 'Ymd');
	},
	getHHMI: function (dt) {
		return Ext.Date.format(dt, 'Hi');
	},
	getDbDateStr: function (dt) {
        return Ext.isDate(dt) ? Ext.Date.format(dt, Unilite.dbDateFormat) : dt;
	},
    safeFormat : function(value) {
    	var me = this;
    	/*
    	if(!me.altFormatsArray) {
    		me.altFormatsArray =  me.altFormats.split('|');
    	}
    	if(value) {
    		return moment(value, me.altFormatsArray ).format(me.dateFormat);
    	} else {
    		return value;
    	}*/
    	
    	return me.extFormatDate(me.extParseDate(value));  //  formatDate
    },
    extParseDate : function(value) {
        if(!value || Ext.isDate(value)){
            return value;
        }

        var me = this,
            val = me.extSafeParse(value, Unilite.dateFormat),
            altFormats = Unilite.altFormats,
            altFormatsArray = me.altFormatsArray,
            i = 0,
            len;

        if (!val && altFormats) {
            altFormatsArray = altFormatsArray || altFormats.split('|');
            len = altFormatsArray.length;
            for (; i < len && !val; ++i) {
                val = me.extSafeParse(value, altFormatsArray[i]);
            }
        }
        return val;
    },
    extSafeParse : function(value, format) {
        var me = this,
            utilDate = Ext.Date,
            result = null,
            strict = undefined,
            parsedDate;

        if (utilDate.formatContainsHourInfo(format)) {
            // if parse format contains hour information, no DST adjustment is necessary
            result = utilDate.parse(value, format, strict);
        } else {
            // set time to 12 noon, then clear the time
            parsedDate = utilDate.parse(value + ' ' + '12', format + ' ' + 'H', strict);
            if (parsedDate) {
                result = utilDate.clearTime(parsedDate);
            }
        }
        return result;
    },   
    // private
    extFormatDate : function(date){
        return Ext.isDate(date) ? Ext.Date.format(date, Unilite.dateFormat) : date;
    },
    extFormatMonth : function(date){
        return Ext.isDate(date) ? Ext.Date.format(date, Unilite.monthFormat) : date;
    },
    /**
     * 
     * @param {} type
     * @param {} basisDate (날자 문자열 또는 Date, moment)
     * @return {}
     */
	get:function(type, basisDate) {
		var rv = "";
		var dt = null;
		if(basisDate) {
			if(moment.isMoment(basisDate)) {
				dt = basisDate;
			} else {
			 	dt =moment(this.extParseDate(basisDate));
			}
		} else {
			dt = moment();
		}
		var format = this.mommentDBformat;
		 if(type == 'today'){
		 	rv = dt.format(format);
		 }else if(type == 'yesterday'){
		 	rv = dt.add('day',-1).format(format);
		 }else if(type == 'tomorrow'){
		 	rv = dt.add('day',1).format(format);
		 }else if(type == 'nextWeek'){
		 	rv = dt.add('day',7).format(format);
		 }else if(type == 'todayOfLastWeek'){
		 	rv = dt.add('week',-1).format(format);
		 }else if(type == 'mondayOfWeek'){
		 	rv = dt.startOf("week").add('day',1).format(format);
		 }else if(type == 'startOfWeek'){
		 	rv = dt.startOf("week").format(format);
		 }else if(type == 'endOfWeek'){
		 	rv = dt.endOf("week").format(format);
		 }else if(type == 'startOfNextWeek'){
		 	rv = dt.add('week',1).startOf("week").format(format);
		 }else if(type == 'startOfMonth'){
		 	rv = dt.startOf("month").format(format);
		 }else if(type == 'endOfMonth'){
		 	rv = dt.endOf("month").format(format);
		 }else if(type == 'startOfLastMonth'){
		 	rv = dt.add('month',-1).startOf("month").format(format);
		 }else if(type == 'endOfLastMonth'){
		 	rv = dt.add('month',-1).endOf("month").format(format);
		 }else if(type == 'startOfYear'){
		 	//rv = Ext.Date.format(new Date(), 'Y') + "0101";
		 	rv = dt.startOf("year").format(format);
		 }else if(type == 'endOfMonth'){
		 	rv = dtendOf('month').format(format);
		 }else if(type == 'endOfYear'){
		 	rv = dt.endOf('year').format(format);
		 }
		 console.log(type + ":" + rv + "," + Unilite.dbDateFormat);
		 return rv;
	},
	getC: function(m) {
		var format = this.mommentDBformat;
		return m.format(format);
	},
	/**
     * Returns the time duration between two dates in the specified units. For finding the number of
     * calendar days (ignoring time) between two dates use {@link Extensible.Date.diffDays diffDays} instead.
     * @param {Date} start The start date
     * @param {Date} end The end date
     * @param {String} unit (optional) The time unit to return. Valid values are 'ms' (milliseconds,
     * the default), 's' (seconds), 'm' (minutes) or 'h' (hours).
     * @return {Number} The time difference between the dates in the units specified by the unit param
     */
    diff : function(start, end, unit){
        var denom = 1,
            diff = end.getTime() - start.getTime();
        
        if(unit == 's'){ 
            denom = 1000;
        }
        else if(unit == 'm'){
            denom = 1000*60;
        }
        else if(unit == 'h'){
            denom = 1000*60*60;
        }
        return Math.round(diff/denom);
    },
    
    /**
     * Calculates the number of calendar days between two dates, ignoring time values. 
     * A time span that starts at 11pm (23:00) on Monday and ends at 1am (01:00) on Wednesday is 
     * only 26 total hours, but it spans 3 calendar days, so this function would return 3. For the
     * exact time difference, use {@link Extensible.Date.diff diff} instead.
     * @param {Date} start The start date
     * @param {Date} end The end date
     * @return {Number} The number of calendar days difference between the dates
     */
    diffDays : function(start, end){
        var day = 1000*60*60*24,
            clear = Ext.Date.clearTime,
            diff = clear(end, true).getTime() - clear(start, true).getTime();
        
        return Math.ceil(diff/day);
    },
    
    /**
     * Copies the time value from one date object into another without altering the target's 
     * date value. This function returns a new Date instance without modifying either original value.
     * @param {Date} fromDt The original date from which to copy the time
     * @param {Date} toDt The target date to copy the time to
     * @return {Date} The new date/time value
     */
    copyTime : function(fromDt, toDt){
        var dt = Ext.Date.clone(toDt);
        dt.setHours(
            fromDt.getHours(),
            fromDt.getMinutes(),
            fromDt.getSeconds(),
            fromDt.getMilliseconds());
        
        return dt;
    },
    
    /**
     * Compares two dates and returns a value indicating how they relate to each other.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Boolean} precise (optional) If true, the milliseconds component is included in the comparison,
     * else it is ignored (the default).
     * @return {Number} The number of milliseconds difference between the two dates. If the dates are equal
     * this will be 0.  If the first date is earlier the return value will be positive, and if the second date
     * is earlier the value will be negative.
     */
    compare : function(dt1, dt2, precise){
        var d1 = dt1, d2 = dt2;
        if(precise !== true){
            d1 = Ext.Date.clone(dt1);
            d1.setMilliseconds(0);
            d2 = Ext.Date.clone(dt2);
            d2.setMilliseconds(0);
        }
        return d2.getTime() - d1.getTime();
    },

    // private helper fn
    maxOrMin : function(max){
        var dt = (max ? 0 : Number.MAX_VALUE), i = 0, args = arguments[1], ln = args.length;
        for(; i < ln; i++){
            dt = Math[max ? 'max' : 'min'](dt, args[i].getTime());
        }
        return new Date(dt);
    },
    
    /**
     * Returns the maximum date value passed into the function. Any number of date 
     * objects can be passed as separate params.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Date} dtN (optional) The Nth date, etc.
     * @return {Date} A new date instance with the latest date value that was passed to the function
     */
	max : function(){
        return this.maxOrMin.apply(this, [true, arguments]);
    },
    
    /**
     * Returns the minimum date value passed into the function. Any number of date 
     * objects can be passed as separate params.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Date} dtN (optional) The Nth date, etc.
     * @return {Date} A new date instance with the earliest date value that was passed to the function
     */
	min : function(){
        return this.maxOrMin.apply(this, [false, arguments]);
    },
    
    isInRange : function(dt, rangeStart, rangeEnd) {
        return  (dt >= rangeStart && dt <= rangeEnd);
    },
    
    /**
     * Returns true if two date ranges overlap (either one starts or ends within the other, or one completely
     * overlaps the start and end of the other), else false if they do not.
     * @param {Date} start1 The start date of range 1
     * @param {Date} end1   The end date of range 1
     * @param {Date} start2 The start date of range 2
     * @param {Date} end2   The end date of range 2
     * @return {boolean} True if the ranges overlap, else false
     */
    rangesOverlap : function(start1, end1, start2, end2){
        var startsInRange = (start1 >= start2 && start1 <= end2),
            endsInRange = (end1 >= start2 && end1 <= end2),
            spansRange = (start1 <= start2 && end1 >= end2);
        
        return (startsInRange || endsInRange || spansRange);
    },
    
    /**
     * Returns true if the specified date is a Saturday or Sunday, else false.
     * @param {Date} dt The date to test
     * @return {Boolean} True if the date is a weekend day, else false 
     */
    isWeekend : function(dt){
        return dt.getDay() % 6 === 0;
    },
    
    /**
     * Returns true if the specified date falls on a Monday through Friday, else false.
     * @param {Date} dt The date to test
     * @return {Boolean} True if the date is a week day, else false 
     */
    isWeekday : function(dt){
        return dt.getDay() % 6 !== 0;
    },
    
    /**
     * Returns true if the specified date's time component equals 00:00, ignoring
     * seconds and milliseconds.
     * @param {Object} dt The date to test
     * @return {Boolean} True if the time is midnight, else false
     */
    isMidnight : function(dt) {
        return dt.getHours() === 0 && dt.getMinutes() === 0;
    },
    
    /**
     * Returns true if the specified date is the current browser-local date, else false.
     * @param {Object} dt The date to test
     * @return {Boolean} True if the date is today, else false
     */
    isToday : function(dt) {
        return this.diffDays(dt, this.today()) === 0;
    },
    
    /**
     * Convenience method to get the current browser-local date with no time value.
     * @return {Date} The current date, with time 00:00
     */
    today : function() {
        return Ext.Date.clearTime(new Date());
    },
    
    /**
     * Add time to the specified date and returns a new Date instance as the result (does not
     * alter the original date object). Time can be specified in any combination of milliseconds
     * to years, and the function automatically takes leap years and daylight savings into account.
     * Some syntax examples:<code><pre>
		var now = new Date();
		
		// Add 24 hours to the current date/time:
		var tomorrow = Extensible.Date.add(now, { days: 1 });
		
		// More complex, returning a date only with no time value:
		var futureDate = Extensible.Date.add(now, {
		    weeks: 1,
		    days: 5,
		    minutes: 30,
		    clearTime: true
		});
		</pre></code>
     * @param {Date} dt The starting date to which to add time
     * @param {Object} o A config object that can contain one or more of the following
     * properties, each with an integer value: <ul>
     * <li>millis</li>
     * <li>seconds</li>
     * <li>minutes</li>
     * <li>hours</li>
     * <li>days</li>
     * <li>weeks</li>
     * <li>months</li>
     * <li>years</li></ul>
     * You can also optionally include the property "clearTime: true" which will perform all of the
     * date addition first, then clear the time value of the final date before returning it.
     * @return {Date} A new date instance containing the resulting date/time value
     */
    add : function(dt, o) {
        if (!o) {
            return dt;
        }
        var ExtDate = Ext.Date,
            dateAdd = ExtDate.add,
            newDt = ExtDate.clone(dt);
        
        if (o.years) {
            newDt = dateAdd(newDt, ExtDate.YEAR, o.years);
        }
        if (o.months) {
            newDt = dateAdd(newDt, ExtDate.MONTH, o.months);
        }
        if (o.weeks) {
            o.days = (o.days || 0) + (o.weeks * 7);
        }
        if (o.days) {
            newDt = dateAdd(newDt, ExtDate.DAY, o.days);
        }
        if (o.hours) {
            newDt = dateAdd(newDt, ExtDate.HOUR, o.hours);
        }
        if (o.minutes) {
            newDt = dateAdd(newDt, ExtDate.MINUTE, o.minutes);
        }
        if (o.seconds) {
            newDt = dateAdd(newDt, ExtDate.SECOND, o.seconds);
        }
        if (o.millis) {
            newDt = dateAdd(newDt, ExtDate.MILLI, o.millis);
        }
         
        return o.clearTime ? ExtDate.clearTime(newDt) : newDt;
    }
});//@charset UTF-8
/**
 * @singleton
 * 
 * 한 App에서 쓰이는 Grid / Store 를 통합 관리
 * 
 */
 Ext.define('Unilite.com.UniAppManager', {
    extend: 'Ext.util.MixedCollection',
    alternateClassName: ['UniAppManager','UniApp'],
    mixins: {
        observable: 'Ext.util.Observable'
    },
    requires: [    	
    	'Ext.util.MixedCollection'
    	//, 'Unilite.com.data.UniStore'
    	//, 'Unilite.com.state.UniStorageProvider'
	],
    
    singleton: true,
    app: null,
    appParams: null,
    id:'',

    constructor : function(){    
        var me = this;
        me.callParent(arguments);
        //me.addEvents('datachanged');
        
	    me.grids= new Ext.util.MixedCollection();
	    me.stores= Array();
	    me.stateInfo = {};
	    
		window.onbeforeunload = function(e) {
			var app = this.UniAppManager.getApp();
			if(app && app.isDirty()) {
		    	return '저장되지 않은 자료가 있습니다. 저장하지 않은채로 다른 페이지로 가시겠습니까?';
			}
		}
		
    	me.updateStatus("Page Loaded", true)
        console.log('UniAppManager constructor.');
    },
    /**
     * uniStore, uniGrid
     * 
     * @static
     */
    register : function() {
    	var me = this;
	    for (var i = 0, s; (s = arguments[i]); i++) {
	        if (s instanceof Unilite.com.data.UniStore) {
	        	//console.log('Register Store:', s.storeId, s);
	        	// Data load나 Sync 후
	        	//s.on('datachanged', this._dataChangedFun, this);
	        	//하나의 데이타가 수정이 일어 났을때
	        	//s.on('update', this._dataUpdatedFun, this);
	        	this.stores.push(s);
	        } else if(s instanceof Ext.grid.Panel) {
	        	console.log("Register Grid:", s.id);

	        	this.grids.add(s.id, s);
	        }
	    }
	},
	/**
	 * Main화면에 메시지를 전송 한다.
	 * 
	 * @param {} message
     * @static
	 */
	updateStatus: function(message, statusOnly) {
		if(parent && parent.updateStatus ) {
			parent.updateStatus(message);
		}
		var lStatusOnly = false ;
		if(statusOnly) {
			lStatusOnly = statusOnly;
		}
		if(!statusOnly) {
        	UniUtils.msg('확인', message);
		}
	},
	
	/**
	 * 
	 * @param {} newApp
	 */
	setApp: function(newApp) {
		this.app = newApp;
		
		console.log("app registered. id = ", this.id);
	},
	/**
	 * 
	 * @return {}
	 */
	getApp: function() {
		return this.app;
	},
	/**
	 * 다른 app 에게 전달할 params 저장
	 * @param {} params
	 */
	setAppParams: function(params) {
		this.appParams = params;
	},
	getAppParams: function() {
		return this.appParams;
	},
	/**
	 * 그리드 설정 값을 DB에 저장한다.
     * @static
	 */  
	saveGridState: function() {
		var me = this;
		var provider = Ext.state.Manager.getProvider();
		var state = new Array();
		for(i=0,len = me.grids.length; i < len; i++ ) {
			var grid = me.grids.get(i);			
			if(grid instanceof Ext.grid.Panel) {
				var gid = me.id + grid.getId();	// not using
				var shtInfo = provider.get(grid.getId());
				state.push({"type":"grid", "id": grid.getId(), "shtInfo" :  shtInfo} ) ;
				console.log("SAVE Grid STATE : id",grid.getId(), "shtInfo : " , shtInfo  ) ;
			}
		}
		if(Ext.isDefined(extJsStateProviderService.updateState)) {
	    	var params = {PGM_ID:this.id, type:'SAVE', SHT_INFO:provider.encodeValue(state)};
	    	extJsStateProviderService.updateState(params);
		}
		
		//참고: AppConfigTag 에 의해 매 화면마다 자바스크립트로 db의 상태정보(shtInfo) 값이 전달된다.
		//    상태 정보를 불러들이는 곳은 layout_extjs.js 의 provider.setStore(...) 에서 UniStorageProvider 의 _buildState 이다.
	},
	/**
	 * 그리드 설정 값을 DB로 부터 읽어 온다.
     * @static
	 */ 
	loadGridState:function() {
		var provider = Ext.state.Manager.getProvider();
		if(Ext.isDefined(extJsStateProviderService.getState)) {
	    	var params = {PGM_ID:this.id};
	    	extJsStateProviderService.getState(params, function(response, e) {  
    		if(Ext.isDefined(response)) {
	    		var shtInfo = provider.decodeValue(response.VALUE);
	    		provider.setStore( Ext.create('Ext.data.Store', {
						storeId: "STATE_STORE",
					 	fields: ["id","shtInfo"],
					 	idProperty : 'id',
					 	data: shtInfo
				}));
				/* reconfig후 grid 화면 reset됨 !!!
		    		if(Ext.isDefined(shtInfo)) {
		    			for(i =0, len = shtInfo.length; i < len; i++ ) {
		    				var info = shtInfo[i];
		    				console.log(i, info);
		    				var grid = Ext.getCmp(info.id);
		    				grid.view.refresh();
		    				//grid.reconfigure(grid.store,  info.shtInfo);
		    				//provider.set(info.id,info.shtInfo);
		    				grid.reconfigure(undefined,  info.shtInfo);
		    				console.log("reconfigure grid-", info.id, info.shtInfo);
		    				
		    			}		    			
		    		}	
		    		*/  		
	    		}
	    	});   
	    }
	},
	/**
	 * DB에 저장된 그리드의 설정값을 초기화 한다. 
	 * 단, 화면을 refresh 해야 적용됨 
     * @static
	 */
	resetGridState: function() {
		
		var provider = Ext.state.Manager.getProvider();
		console.log('grid 환경 기본값 설정');
		for(i=0,len<this.grids.length; i < len; i++ ) {
			var grid = this.grids.get(i);		
			if(grid instanceof Ext.grid.Panel) {
				console.log(this.id + "-Grid " + i + ": ",grid	);
				Ext.state.Manager.clear(grid.getItemId());
			}
		}
		if(Ext.isDefined(extJsStateProviderService.resetState)) {
			var params = {PGM_ID:this.id};
			extJsStateProviderService.resetState(params, function(response, e) {  
		    		if(Ext.isDefined(response)) {
			    		var obj = provider.decodeValue(response.SHT_INFO);
			    		console.log("OBJ:", obj);
			    		alert("화면을 닫았다 다시 열면 sheet 기본 설정이 적용 됩니다.");
		    		}
		    	}); 
		};

	},
	/**
	 * grid 상태정보를 불러와서 grid 에 적용한다.
	 * @param {} stateInfo	db에 저장되어 있는 설정 정보 (encoded)
	 */
	applyGridState: function(stateInfo) {		
		var provider = Ext.state.Manager.getProvider();
		var state = provider.decodeValue(stateInfo.SHT_INFO);	//db의 STH_INFO 값
		console.log('grid 환경 설정 적용');
		provider.setStore( Ext.create('Ext.data.Store', {
				storeId: "STATE_STORE",
			 	fields: ["id","shtInfo"],
			 	idProperty : 'id',
			 	data: state
		}));
		
		if(Ext.isDefined(state)) {
			var obj = Ext.getCmp(state.id);
			if(obj && obj instanceof Unilite.UniGridPanel) {
				//grid.getView().refresh();
				//grid.reconfigure(grid.store,  info.shtInfo);
				//provider.set(info.id,info.shtInfo);
				//grid.reconfigure(undefined,  state.shtInfo);
				//grid.reconfigure(grid.getStore(), state.shtInfo.columns);

				//그리드에 적용
				obj.setLoading(true);
				var cnt = obj.getStore().count();
				if(cnt > 0)
					obj.getStore().removeAll();	//data 가 있는 경우 속도에 문제가 생김.
				
				obj.applyState(state.shtInfo);
				
				if(cnt > 0)
					obj.getStore().reload();
					
				obj.setLoading(false);
				
				if(stateInfo.DEFAULT_YN == 'Y') {	//기본설정이 변경 적용되는 경우
					this.setStateInfo(stateInfo);
				}
				
				console.log("applyState grid-", state.id, state.shtInfo);	
			}
		}	
	},
	/**
	 * @private
	 * @param {} store
	 * @return {Boolean}
	 */
	_hasDirty:function(store) {
		var toCreate = store.getNewRecords(),
            toUpdate = store.getUpdatedRecords(),
            toDestroy = store.getRemovedRecords();
            /*
            console.log("STORE:", store.storeId, 
            		"toCreate:"+ toCreate.length,            		
            		"toUpdate:"+ toUpdate.length,
            		"toDestroy:"+ toDestroy.length
            	);
            	*/
        if(toCreate.length + toUpdate.length + toDestroy.length > 0) {
        	return true;
        } else {
        	return false;
        }
	},
	// ptivate
	/*
	_dataChangedFun: function(store, eOpts) {
		var me = this, hasDirty = false;
		
		for(i = 0, len = this.stores.length; i < len; i ++) {
			var lStore = this.stores[i];
			var l = me._hasDirty(lStore);
			if(l) {
				hasDirty = true;
				break;
			}
		}
		
		this.hasDirty = hasDirty;	
        me.fireEvent('datachanged',  me.app);	
	},
	*/
	// ptivate
	/*
	_dataUpdatedFun: function(store, record, operation, modifiedFieldNames, eOpts) {
		console.log("_dataUpdatedFun");
		var me = this;
		this.hasDirty = true;
        me.fireEvent('datachanged',  me.app);
	},
	*/
	
	/**
	 * 툴바 버튼 제어 
	 * 
	 *     UniApp.setToolbarButtons(['delete'], false);
	 *     UniApp.setToolbarButtons(['prev','next'], true);
	 *     
	 * @param {Array} btnNames
	 * @param {Boolean} state
     * @static
	 */
	setToolbarButtons:function(btnNames, state) {
		if(this.app) {
			this.app.setToolbarButtons(btnNames, state);
		}
	},
	setPageTitle: function(title) {
		if(parent && parent.updateProgramTitle ) {
			parent.updateProgramTitle(title);
		}
//        var tit = Ext.getCmp('UNILITE_PG_TITLE');
//        console.log('tit:', tit);
	},
	addButton: function( button ) {
		if(this.app) {
			this.app.addButton(button);
		}
	},
	saveState: function(id, state) {
		var provider = Ext.state.Manager.getProvider();
	}, 
	getState: function(id) {
		
		var provider = Ext.state.Manager.getProvider();
		var state = provider.get(id);
		return state
	},
	getDbShtInfo: function(id) {		
		var provider = Ext.state.Manager.getProvider();
		var StateInfo = {"type":"grid", "id": id, "shtInfo" :  provider.get(id)} 
		
		return provider.encodeValue(StateInfo);
	},
	setStateInfo: function(stateInfo) {
		this.stateInfo[stateInfo.SHT_ID] = stateInfo;	
	},
	getStateInfo: function(id) {
		return this.stateInfo[id];	
	}
	
});//@charset UTF-8
/**
 * 
 */
 Ext.define('Unilite.com.UniAbstractApp', {
	extend: 'Ext.Viewport',
    //defaults: {padding: '5 5 5 5'},
    //defaults: {padding: 0},  // 검색조건에 padding값 0 되는 현상 제거 목표 2014.07.09
    layout : {	type: 'vbox', pack: 'start', align: 'stretch' },
	params:{},
	items: [],
	buttons:{},
    requires: [
	    'Ext.ux.DataTip',
	    'Unilite.com.UniAppManager'
	],
    // abstract
	beforeClose:Ext.emptyFn,
	toolBar : {},    
    comPanelToolbar : {
			xtype : 'panel',
			//id : 'comPanelToolbar',
			flex : 0,
			border : 0,
			margin : '0 0 0 0 ',
			dockedItems : [ ]
	},
	
	onQueryButtonDown: Ext.emptyFn


}); // define//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.button.UniHoverButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.uniHoverButton',
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        var btnConfig = {};
        if (Ext.isDefined(this.menu)) {            
            btnConfig = {
                listeners: {
					mouseover: function (b) {
                            b.maybeShowMenu();
                    }
                } // listeners
            }
        }
 
        // apply config
        Ext.apply(this, Ext.apply(this.initialConfig, btnConfig));
        
        me.callParent(arguments);
    }
});//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.button.BaseButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.uniBaseButton',
    scale: 'medium',
    constructor: function(config) {
        var me = this;
        config = config || {};
        config.text = '';
        config.trackResetOnLoad = true;
        me.callParent([config]);
    }
    
});//@charset UTF-8
/**
 * This is a supporting class for {@link Ext.ux.grid.filter.ListFilter}.
 * Although not listed as configuration options for this class, this class
 * also accepts all configuration options from {@link Ext.ux.grid.filter.ListFilter}.
 */
Ext.define('Unilite.com.grid.filter.UniListMenu', {
    extend: 'Ext.menu.Menu',
    
    /**
     * @cfg {String} idField
     * Defaults to 'id'.
     */
    idField :  'id',

    /**
     * @cfg {String} labelField
     * Defaults to 'text'.
     */
    labelField :  'text',
    /**
     * @cfg {String} paramPrefix
     * Defaults to 'Loading...'.
     */
    loadingText : 'Loading...',
    /**
     * @cfg {Boolean} loadOnShow
     * Defaults to true.
     */
    loadOnShow : true,
    /**
     * @cfg {Boolean} single
     * Specify true to group all items in this list into a single-select
     * radio button group. Defaults to false.
     */
    single : false,

    plain: true,

    constructor: function (cfg) {
        var me = this,
            gridStore;
            
        me.selected = [];
        me.addEvents(
            /**
             * @event checkchange
             * Fires when there is a change in checked items from this list
             * @param {Object} item Ext.menu.CheckItem
             * @param {Object} checked The checked value that was set
             */
            'checkchange'
        );

        me.callParent(arguments);

        gridStore = me.grid.store;

        if (me.store) {
            me.add({
                text: me.loadingText,
                iconCls: 'loading-indicator'
            });
            me.store.on('load', me.onLoad, me);

        // A ListMenu which is completely unconfigured acquires its store from the unique values of its field in the store.
        // If there are no records in the grid store, then we know it's async and we need to listen for its 'load' event.
        } else if (gridStore.data.length) {
            me.createMenuStore();
        } else {
            gridStore.on('load', me.createMenuStore, me, {single: true});
        }
    },

    destroy : function () {
        var me = this,
            store = me.store;
            
        if (store) {
            if (me.autoStore) {
                store.destroyStore();
            } else {
                store.un('unload', me.onLoad, me);
            }
        }
        me.callParent();
    },

    /**
     * Lists will initially show a 'loading' item while the data is retrieved from the store.
     * In some cases the loaded data will result in a list that goes off the screen to the
     * right (as placement calculations were done with the loading item). This adapter will
     * allow show to be called with no arguments to show with the previous arguments and
     * thus recalculate the width and potentially hang the menu from the left.
     */
    show : function () {
        var me = this;
        if (me.loadOnShow && !me.loaded && !me.store.loading) {
            me.store.load();
        }
        me.callParent();
    },

    /** @private */
    onLoad: function (store, records) {
        var me = this,
            gid, itemValue, i, len,
            listeners = {
                checkchange: me.checkChange,
                scope: me
            };

        Ext.suspendLayouts();
        me.removeAll(true);
        gid = me.single ? Ext.id() : null;
        for (i = 0, len = records.length; i < len; i++) {
            itemValue = records[i].get(me.idField);
            me.add(Ext.create('Ext.menu.CheckItem', {
                text: records[i].get(me.labelField),
                group: gid,
                checked: Ext.Array.contains(me.selected, itemValue),
                hideOnClick: false,
                value: itemValue,
                listeners: listeners
            }));
        }

        me.loaded = true;
        Ext.resumeLayouts(true);
        me.fireEvent('load', me, records);
    },

    createMenuStore: function () {
        var me = this,
            options = [],
            i, len, value;
            
       if( me.store) {
			me.store.destroyStore();
        	me.removeAll(true);
        }
            
        me.options = me.grid.store.collect(me.dataIndex, false, true);

        for (i = 0, len = me.options.length; i < len; i++) {
            value = me.options[i];
            switch (Ext.type(value)) {
                case 'array': 
                    options.push(value);
                    break;
                case 'object':
                    options.push([value[me.idField], value[me.labelField]]);
                    break;
                default:
                    if (value != null) {
                        options.push([value, value]);
                    }
            }
        }

        me.store = Ext.create('Ext.data.ArrayStore', {
            fields: [me.idField, me.labelField],
            data:   options,
            listeners: {
                load: me.onLoad,
                scope:  me
            }
        });

        me.loaded = true;
       me.autoStore = true;
        me.grid.store.on('load', me.createMenuStore, me, {single: true});
    },

    /**
     * Get the selected items.
     * @return {Array} selected
     */
    getSelected : function () {
        return this.selected;
    },

    /** @private */
    setSelected : function (value) {
        value = this.selected = [].concat(value);

        if (this.loaded) {
            this.items.each(function(item){
                item.setChecked(false, true);
                for (var i = 0, len = value.length; i < len; i++) {
                    if (item.value == value[i]) {
                        item.setChecked(true, true);
                    }
                }
            });
        }
    },

    /**
     * Handler for the 'checkchange' event from an check item in this menu
     * @param {Object} item Ext.menu.CheckItem
     * @param {Object} checked The checked value that was set
     */
    checkChange : function (item, checked) {
        var value = [];
        this.items.each(function(item){
            if (item.checked) {
                value.push(item.value);
            }
        });
        this.selected = value;

        this.fireEvent('checkchange', item, checked);
    }
});//@charset UTF-8
/**
 * Ext.ux.grid.filter.ListFilter의 경우 데이타가 refresh되어도 filter 목록이 갱신되지 않음.
 * 
 * 해당 기능을 추가함.
 * ## 사용예
 * 		@example
 * 			{ dataIndex: 'CUSTOM_NAME',width: 120, filter: {type: 'uniList'} }
 *
 */
Ext.define('Unilite.com.grid.filter.UniListFilter', {
    extend: 'Ext.ux.grid.filter.Filter',
    alias: ['gridfilter.uniList', 'gridfilter.list'],

    /**
     * @cfg {Array} [options]
     * `data` to be used to implicitly create a data store
     * to back this list when the data source is **local**. If the
     * data for the list is remote, use the {@link #store}
     * config instead.
     *
     * If neither store nor {@link #options} is specified, then the choices list is automatically
     * populated from all unique values of the specified {@link #dataIndex} field in the store at first
     * time of filter invocation.
     *
     * Each item within the provided array may be in one of the
     * following formats:
     *
     *   - **Array** :
     *
     *         options: [
     *             [11, 'extra small'],
     *             [18, 'small'],
     *             [22, 'medium'],
     *             [35, 'large'],
     *             [44, 'extra large']
     *         ]
     *
     *   - **Object** :
     *
     *         labelField: 'name', // override default of 'text'
     *         options: [
     *             {id: 11, name:'extra small'},
     *             {id: 18, name:'small'},
     *             {id: 22, name:'medium'},
     *             {id: 35, name:'large'},
     *             {id: 44, name:'extra large'}
     *         ]
     * 
     *   - **String** :
     *
     *         options: ['extra small', 'small', 'medium', 'large', 'extra large']
     *
     */
    
    phpMode : false,
    /**
     * @cfg {Ext.data.Store} [store]
     * The {@link Ext.data.Store} this list should use as its data source
     * when the data source is **remote**. If the data for the list
     * is local, use the {@link #options} config instead.
     *
     * If neither store nor {@link #options} is specified, then the choices list is automatically
     * populated from all unique values of the specified {@link #dataIndex} field in the store at first
     * time of filter invocation.
     */

    /**
     * @private
     * Template method that is to initialize the filter.
     * @param {Object} config
     */
    init : function (config) {
        this.dt = Ext.create('Ext.util.DelayedTask', this.fireUpdate, this);
    },

    /**
     * @private @override
     * Creates the Menu for this filter.
     * @param {Object} config Filter configuration
     * @return {Ext.menu.Menu}
     */
    createMenu: function(config) {
        var menu = Ext.create('Unilite.com.grid.filter.UniListMenu', config);
        menu.on('checkchange', this.onCheckChange, this);
        return menu;
    },

    /**
     * @private
     * Template method that is to get and return the value of the filter.
     * @return {String} The value of this filter
     */
    getValue : function () {
        return this.menu.getSelected();
    },
    /**
     * @private
     * Template method that is to set the value of the filter.
     * @param {Object} value The value to set the filter
     */
    setValue : function (value) {
        this.menu.setSelected(value);
        this.fireEvent('update', this);
    },

    /**
     * Template method that is to return true if the filter
     * has enough configuration information to be activated.
     * @return {Boolean}
     */
    isActivatable : function () {
        return this.getValue().length > 0;
    },

    /**
     * @private
     * Template method that is to get and return serialized filter data for
     * transmission to the server.
     * @return {Object/Array} An object or collection of objects containing
     * key value pairs representing the current configuration of the filter.
     */
    getSerialArgs : function () {
        return {type: 'list', value: this.phpMode ? this.getValue().join(',') : this.getValue()};
    },

    /** @private */
    onCheckChange : function(){
        this.dt.delay(this.updateBuffer);
    },


    /**
     * Template method that is to validate the provided Ext.data.Record
     * against the filters configuration.
     * @param {Ext.data.Record} record The record to validate
     * @return {Boolean} true if the record is valid within the bounds
     * of the filter, false otherwise.
     */
    validateRecord : function (record) {
        var valuesArray = this.getValue();
        return Ext.Array.indexOf(valuesArray, record.get(this.dataIndex)) > -1;
    }
});
//@charset UTF-8
/**
 *
 */
Ext.define('Unilite.com.grid.feature.UniGroupingSummary', {

    extend: 'Ext.grid.feature.Grouping',

    alias: 'feature.uniGroupingsummary',

    showSummaryRow: true,
    
    //hideGroupedHeader: true,
    
    vetoEvent: function(record, row, rowIndex, e){
        var result = this.callParent(arguments);
        if (result !== false) {
            if (e.getTarget(this.summaryRowSelector)) {
                result = false;
            }
        }
        return result;
    },
    // groupHeaderTpl:'{columnName}: {name}',
    groupHeaderTpl: Ext.create('Ext.XTemplate',  
    	'{columnName}: {name:this.uniFormat}',
    	{
	    	uniFormat: function(value, rows) {
	    		if( value instanceof Date && !isNaN(value.valueOf()) ) {
	    			return UniDate.safeFormat(value);
	    		} else {
	    			return Ext.String.trim(value);
	    		}
	    	}
    	}
    ),
    /**
     * @overide
     * @param {} store
     * @param {} type
     * @param {} field
     * @param {} group
     * @return {}
     */
    getSummary: function(store, type, field, group){
        var records = group.records;

        if (type) {
            if (Ext.isFunction(type)) {
                return store.getAggregate(type, null, records, [field]);
            }

            switch (type) {
                case 'count':
                    return records.length;
                case 'min':
                    return store.getMin(records, field);
                case 'max':
                    return store.getMax(records, field);
                case 'sum':
                    return store.getSum(records, field);
                case 'average':
                    return store.getAverage(records, field);
                 case 'nod':
                    return this._getNOD(records, field);
                default:
                    return '';

            }
        }
    },
    /**
     * number of distinct values 
     * @private
     * @param {} records
     * @param {} dataIndex
     * @return {}
     */
    _getNOD: function (records, dataIndex) {
    	var rv = "";
	  		var oldValue = null;
	  		for(i = 0, len = records.length; i < len; i ++) {
	  			var value = records[i].get(dataIndex) ;
	  			if(oldValue != null && value != oldValue) {
	  				rv = "";
	  				break;
	  			} else {
	  				oldValue = value;
	  				rv = value;
	  			}
	  		}
	  		return rv;
    }
});//@charset UTF-8

/**
 *
 */
Ext.define('Unilite.com.grid.feature.UniSummary', {

    /* Begin Definitions */

    extend: 'Ext.grid.feature.AbstractSummary',
	suffix : '-grand-summary-record',
    alias: 'feature.uniSummary',
    summaryRowCls: Ext.baseCSSPrefix + 'grid-grand-row-summary',

    /**
     * @cfg {String} dock
     * Configure `'top'` or `'bottom'` top create a fixed summary row either above or below the scrollable table.
     *
     */
    dock: undefined,
	//dock: 'top', // 설정 후 합계표시 토글 시키면 row 가 사라짐
	
    dockedSummaryCls: Ext.baseCSSPrefix + 'docked-summary',

    panelBodyCls: Ext.baseCSSPrefix + 'summary-',

    init: function(grid) {
        var me = this,
            view = me.view;

        me.callParent(arguments);

        if (me.dock) {
            grid.headerCt.on({
                afterlayout: me.onStoreUpdate,
                scope: me
            });
            grid.on({
                beforerender: function() {
                    var tableCls = [me.summaryTableCls];
                    if (view.columnLines) {
                        tableCls[tableCls.length] = view.ownerCt.colLinesCls;
                    }
                    me.summaryBar = grid.addDocked({
                        childEls: ['innerCt'],
                        renderTpl: [
                            '<div id="{id}-innerCt">',
                                '<table cellPadding="0" cellSpacing="0" class="' + tableCls.join(' ') + '">',
                                    '<tr class="' + me.summaryRowCls + '"></tr>',
                                '</table>',
                            '</div>'
                        ],
                        style: 'overflow:hidden',
                        itemId: 'summaryBar',
                        cls: [ me.dockedSummaryCls, me.dockedSummaryCls + '-' + me.dock ],
                        xtype: 'component',
                        dock: me.dock,
                        weight: 10000000
                    })[0];
                },
                afterrender: function() {
                    grid.body.addCls(me.panelBodyCls + me.dock);
                    view.mon(view.el, {
                        scroll: me.onViewScroll,
                        scope: me
                    });
                    me.onStoreUpdate();
                },
                single: true
            });
// Dock 의 colum line 맞추기 위해 변경
//            // Stretch the innerCt of the summary bar upon headerCt layout
//            grid.headerCt.afterComponentLayout = Ext.Function.createSequence(grid.headerCt.afterComponentLayout, function() {
//                me.summaryBar.innerCt.setWidth(this.getFullWidth() + Ext.getScrollbarSize().width);
//            });
            grid.headerCt.afterComponentLayout = Ext.Function.createSequence(grid.headerCt.afterComponentLayout, function() {
                var width = this.getFullWidth(),
                    innerCt = me.summaryBar.innerCt,
                    scrollWidth;
                    
                if (view.hasVerticalScroll()) {
                    scrollWidth = Ext.getScrollbarSize().width;
                    width -= scrollWidth;
                    innerCt.down('table').setStyle(me.scrollPadProperty, scrollWidth + 'px');
                }
                innerCt.setWidth(width);
            });
        } else {
            me.view.addFooterFn(me.renderTFoot);
        }

        grid.on({
            columnmove: me.onStoreUpdate,
            scope: me
        });

        // On change of data, we have to update the docked summary.
        view.mon(view.store, {
            update: me.onStoreUpdate,
            datachanged: me.onStoreUpdate,
            scope: me
        });
    },

    renderTFoot: function(values, out) {
        var view = values.view,
            me = view.findFeature('uniSummary');

        if (me.showSummaryRow) {
            out.push('<tfoot>');
            me.outputSummaryRecord(me.createSummaryRecord(view), values, out);
            out.push('</tfoot>');
        }
    },
    
    vetoEvent: function(record, row, rowIndex, e) {
        return !e.getTarget(this.summaryRowSelector);
    },

    onViewScroll: function() {
        this.summaryBar.el.dom.scrollLeft = this.view.el.dom.scrollLeft;
    },

    createSummaryRecord: function(view) {
        var columns = view.headerCt.getVisibleGridColumns(),
            info = {
                records: view.store.getRange()
            },
            colCount = columns.length, i, column,
            summaryRecord = this.summaryRecord || (this.summaryRecord = new view.store.model(null, view.id + this.suffix));

        // Set the summary field values
        summaryRecord.beginEdit();
      //  var fields = summaryRecord.fields.getRange();
      //  fields.push(new Ext.data.Field({name: 'S_SUMMAR_TYPE', type: 'string', dataIndex:'S_SUMMAR_TYPE'}));
      // 	summaryRecord.set('S_SUMMAR_TYPE', 'GRAND');
       	//summaryRecord.setFields(fields,'1','1');
        
        for (i = 0; i < colCount; i++) {
            column = columns[i];

            // In summary records, if there's no dataIndex, then the value in regular rows must come from a renderer.
            // We set the data value in using the column ID.
            if (!column.dataIndex) {
                column.dataIndex = column.id;
            }

            summaryRecord.set(column.dataIndex, this.getSummary(view.store, column.summaryType, column.dataIndex, info));
        }
       // console.log("summaryRecord", summaryRecord);
        summaryRecord.endEdit(true);
        // It's not dirty
        summaryRecord.commit(true);
        summaryRecord.isSummary = true;

        return summaryRecord;
    },

    onStoreUpdate: function() {
        var me = this,
            view = me.view,
            record = me.createSummaryRecord(view),
            newRowDom = view.createRowElement(record, -1),
            oldRowDom, partner,
            p;

        if (!view.rendered) {
            return;
        }
        
        // Summary row is inside the docked summaryBar Component
        if (me.dock) {
            oldRowDom = me.summaryBar.el.down('.' + me.summaryRowCls, true);
        }
        // Summary row is a regular row in a THEAD inside the View.
        // Downlinked through the summary record's ID'
        else {
            oldRowDom = me.view.getNode(record);
        }
        
        if (oldRowDom) {
            p = oldRowDom.parentNode;
            p.insertBefore(newRowDom, oldRowDom);
            p.removeChild(oldRowDom);

            partner = me.lockingPartner;
            // For locking grids...
            // Update summary on other side (unless we have been called from the other side)
            if (partner && partner.grid.rendered && !me.calledFromLockingPartner) {
                partner.calledFromLockingPartner = true;
                partner.onStoreUpdate();
                partner.calledFromLockingPartner = false;
            }
        }
        // If docked, the updated row will need sizing because it's outside the View
        if (me.dock) {
            me.onColumnHeaderLayout();
        }
    },

    // Synchronize column widths in the docked summary Component
    onColumnHeaderLayout: function() {
        var view = this.view,
            columns = view.headerCt.getVisibleGridColumns(),
            column,
            len = columns.length, i,
            summaryEl = this.summaryBar.el,
            el;

        for (i = 0; i < len; i++) {
            column = columns[i];
            el = summaryEl.down(view.getCellSelector(column));
            if (el) {
                if (column.hidden) {
                    el.setDisplayed(false);
                } else {
                    el.setDisplayed(true);
                    el.setWidth(column.width || (column.lastBox ? column.lastBox.width : 100));
                }
            }
        }
    },
    // overide
    getSummary: function(store, type, field, group){
        var records = group.records;

        if (type) {
            if (Ext.isFunction(type)) {
                return store.getAggregate(type, null, records, [field]);
            }

            switch (type) {
                case 'count':
                    return records.length;
                case 'min':
                    return store.getMin(records, field);
                case 'max':
                    return store.getMax(records, field);
                case 'sum':
                    return store.getSum(records, field);
                case 'average':
                    return store.getAverage(records, field);
                 case 'nod':
                    return this._getNOD(records, field);
                default:
                    return '';

            }
        }
    },
    // _private  //  number of distinct values 
    _getNOD: function (records, dataIndex) {
    	var rv = "";
	  		var oldValue = null;
	  		for(i = 0, len = records.length; i < len; i ++) {
	  			var value = records[i].get(dataIndex) ;
	  			if(oldValue != null && value != oldValue) {
	  				rv = "";
	  				break;
	  			} else {
	  				oldValue = value;
	  				rv = value;
	  			}
	  		}
	  		return rv;
    }
});//@charset UTF-8
/**
 *  Grid용 month column
 * 
 */
Ext.define('Unilite.com.grid.column.UniMonthColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniMonthColumn'],
    requires: ['Ext.Date', 'Unilite','Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.MonthColumn',
	fieldStyle: 'text-align:center;ime-mode:disabled;',

    initComponent: function(){
        if (!this.format) {
            this.format = Unilite.monthFormat;
        }
        
        this.callParent(arguments);
    },
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	return  UniDate.extFormatMonth(value);
    }
});//@charset UTF-8
/**
 *  Grid용 date column
 * 
 */
Ext.define('Unilite.com.grid.column.UniDateColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniDateColumn'],
    requires: ['Ext.Date', 'Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.DateColumn',
	fieldStyle: 'text-align:center;ime-mode:disabled;',

    initComponent: function(){
        if (!this.format) {
            this.format = Ext.Date.defaultFormat;
        }
        
        this.callParent(arguments);
    },
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	return  UniDate.safeFormat(value);
    	//console.log(value, rv);
    	//return rv;
        //return Ext.util.Format.date(value, this.format);
    }
});//@charset UTF-8
/**
 *  Grid용 date column
 * 
 */
Ext.define('Unilite.com.grid.column.UniTimeColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniTimeColumn'],
    requires: ['Ext.Date', 'Unilite.UniDate'],
    //alternateClassName: 'Ext.grid.TimeColumn',
    
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	format: 'H:i',
	constructor: function(config){    
        var me = this;
        
       	if (config) {
            Ext.apply(me, config);
        };	
        
        this.callParent([config]);
	},
    
    /**
     * 날자 표시 함수 
     * @param {} value
     * @return {}
     */
    defaultRenderer: function(value){
    	
    	return  Ext.Date.format(value, this.format);
    	//console.log(value, rv);
    	//return rv;
        //return Ext.util.Format.date(value, this.format);
    }
});//@charset UTF-8
/**
 *  Grid용 Price column
 * 
 */
Ext.define('Unilite.com.grid.column.UniPriceColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniPriceColumn'],
    requires: ['Ext.util.Format'],

    /**
     * @cfg {String} format
     * A formatting string as used by {@link Ext.util.Format#number} to format a numeric value for this Column.
     */
    format : '0,000',


    defaultRenderer: function(value){
        return Ext.util.Format.number(value, this.format);
    }
});//@charset UTF-8
/**
 *  Grid용 number column
 * 
 */
Ext.define('Unilite.com.grid.column.UniNnumberColumn', {
    extend: 'Ext.grid.column.Column',
    alias: ['widget.uniNnumberColumn'],
    requires: ['Ext.util.Format'],

    /**
     * @cfg {String} format
     * A formatting string as used by {@link Ext.util.Format#number} to format a numeric value for this Column.
     */
    format : '0,000',


    defaultRenderer: function(value){
        return Ext.util.Format.number(value, this.format);
    }
});Ext.define('Unilite.com.grid.CellDragDrop', {
    extend: 'Ext.ux.CellDragDrop',
    alias: 'plugin.unicelldragdrop',

    /**
     * @cfg {Boolean} applyEmptyText
     * If `record`, then copy to drop record from drag record if 'cell' copy cell to drop cell from drag cell.
     *
     * Defaults to `record`.
     */
    copyType:'record', 
    
	constructor: function(config){
    	config = config || {};
        
        this.callParent([config]);
    },
    init: function (view) {
        var me = this;

        view.on('render', me.onViewRender, me, {
            single: true
        });
    },
	
    onViewRender: function (view) {
        var me = this,
            scrollEl;

        if (me.enableDrag) {
            if (me.containerScroll) {
                scrollEl = view.getEl();
            }

            me.dragZone = new Ext.view.DragZone({
                view: view,
                ddGroup: me.dragGroup || me.ddGroup,
                dragText: me.dragText,
                containerScroll: me.containerScroll,
                scrollEl: scrollEl,
                getDragData: function (e) {
                    var view = this.view,
                        item = e.getTarget(view.getItemSelector()),
                        record = view.getRecord(item),
                        clickedEl = e.getTarget(view.getCellSelector()),
                        dragEl;

                    if (item) {
                        dragEl = document.createElement('div');
                        dragEl.className = 'x-form-text';
                        dragEl.appendChild(document.createTextNode(clickedEl.textContent || clickedEl.innerText));

                        return {
                            event: new Ext.EventObjectImpl(e),
                            ddel: dragEl,
                            item: e.target,
                            columnName: view.getGridColumns()[clickedEl.cellIndex].dataIndex,
                            record: record,
                            view: view,
                            records : [record]
                        };
                    }
                },

                onInitDrag: function (x, y) {
                    var self = this,
                        data = self.dragData,
                        view = self.view,
                        selectionModel = view.getSelectionModel(),
                        record = data.record,
                        el = data.ddel;

                    // Update the selection to match what would have been selected if the user had
                    // done a full click on the target node rather than starting a drag from it.
                    if (!selectionModel.isSelected(record)) {
                        selectionModel.select(record, true);
                    }

                    self.ddel.update(el.textContent || el.innerText);
                    self.proxy.update(self.ddel.dom);
                    self.onStartDrag(x, y);
                    return true;
                }
            });
        }

        if (me.enableDrop) {
            me.dropZone = new Ext.dd.DropZone(view.el, {
                view: view,
                ddGroup: me.dropGroup || me.ddGroup,
                containerScroll: true,

                getTargetFromEvent: function (e) {
                    var self = this,
                        v = self.view,
                        cell = e.getTarget(v.cellSelector),
                        row, columnIndex;

                    // Ascertain whether the mousemove is within a grid cell.
                    if (cell) {
                        row = v.findItemByChild(cell);
                        columnIndex = cell.cellIndex;
                        
						var columns = self.view.getGridColumns();
						
                        if (row && Ext.isDefined(columnIndex)) {
                            return {
                                node: cell,
                                record: v.getRecord(row),
                                columnName: columns[columnIndex].dataIndex //self.view.up('grid').columns[columnIndex].dataIndex
                            };
                        }
                    }
                },

                // On Node enter, see if it is valid for us to drop the field on that type of column.
                onNodeEnter: function (target, dd, e, dragData) {
                    var self = this;
                        
                    //delete self.dropOK;

                    // Return if no target node or if over the same cell as the source of the drag.
                    if (!target ) {
                     	if (dragData.view.getXType() == 'gridview' && target.node === dragData.item.parentNode)  {
                        	return;
                     	}
                    }
					
                    if (me.enforceType && destType !== sourceType) {

                        self.dropOK = false;

                        if (me.noDropCls) {
                            Ext.fly(target.node).addCls(me.noDropCls);
                        } else {
                            Ext.fly(target.node).applyStyles({
                                backgroundColor: me.noDropBackgroundColor
                            });
                        }

                        return;
                    }
                    
                    if(!me.onDropEnter(target, dragData))	{
                    	self.dropOK = false;
                    	return;
                    }
                    
                    self.dropOK = true;

                    if (me.dropCls) {
                        Ext.fly(target.node).addCls(me.dropCls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: me.dropBackgroundColor
                        });
                    }
                    
                },

                // Return the class name to add to the drag proxy. This provides a visual indication
                // of drop allowed or not allowed.
                onNodeOver: function (target, dd, e, dragData) {
                    return this.dropOK ? this.dropAllowed : this.dropNotAllowed;
                },

                // Highlight the target node.
                onNodeOut: function (target, dd, e, dragData) {
                    var cls = this.dropOK ? me.dropCls : me.noDropCls;

                    if (cls) {
                        Ext.fly(target.node).removeCls(cls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: ''
                        });
                    }
                },

                // Process the drop event if we have previously ascertained that a drop is OK.
                onNodeDrop: function (target, dd, e, dragData) {
                    if (this.dropOK) {
                    	if(me.copyType == "record")	{
                    		/*var store = me.getCmp().getStore();
                    		if(store)	{
	                    		var tFields = store.getAt(store.indexOf(target.record)).getFields();
	                    		Ext.each(tFields, function(field, index)	{
	                    			if( !Ext.isEmpty(dragData.record.get(field.getName())) )	{
	                    				target.record.set(field.getName(), dragData.record.get(field.getName()) );
	                    			}
	                    		});
                    		}*/
                    		me.onRecordDrop(target, dragData);
                    		//target.record.set('name', dragData.record.name);
                    	}else {
                    		
	                        target.record.set(target.columnName, dragData.record.get(dragData.columnName));
	                        if (me.applyEmptyText) {
	                            dragData.record.set(dragData.columnName, me.emptyText);
	                        }
                    	}
                        return true;
                    }
                },

                onCellDrop: Ext.emptyFn
            });
        }
    },
    
    onRecordDrop: Ext.emptyFn,
    onDropEnter: function(target, dragData)	{
    	return true;
    }
});
//@charset UTF-8
// http://pastebin.com/aReGA9Vi
// JavaScript keycode : http://unixpapa.com/js/key.html 
// http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

var UNI_GRID_NEW_VAL="";

/*****************************************
 *  Ext.Editor Overide
 *  키입력으로 Editor 모드 들어 가게
 *  Deprecated - 2014.09.16 field.selectText() 에 오류가 있어 override 취소. 현재 UniBaseFields 에서 selectOnFocus: true 사용하고 있음.
 */
/*
Ext.override(Ext.Editor, {
     startEdit : function(el, value) {
        var me = this,
            field = me.field;

        me.completeEdit();
        me.boundEl = Ext.get(el);
        value = Ext.isDefined(value) ? value : Ext.String.trim(me.boundEl.dom.innerText || me.boundEl.dom.innerHTML);

        if (!me.rendered) {
            // Render to the ownerCt's element
            // Being floating, we do not need to use the actual layout's target.
            // Indeed, it's better if we do not so that we do not interfere with layout's child management,
            // especially with CellEditors in the element of a TablePanel.
            if (me.ownerCt) {
                me.parentEl = me.ownerCt.el;
                me.parentEl.position();
            }
            me.render(me.parentEl || document.body);
        }

        if (me.fireEvent('beforestartedit', me, me.boundEl, value) !== false) {
            me.startValue = value;
            me.show();
            // temporarily suspend events on field to prevent the "change" event from firing when reset() and setValue() are called
            field.suspendEvents();
            field.reset();
            field.setValue(value);
            //field.setValue((UNI_GRID_NEW_VAL != '' ? UNI_GRID_NEW_VAL : value));
            field.resumeEvents();
            me.realign(true);
            
            if(field.getRawValue().length > 0)
            	//field.selectText();	//2014.09.16 셀 클릭시 텍스트가 있는 경우에 에디터 박스가 안나타나는 현상 발생. field.focus() 로 변경
            	field.focus([field.getRawValue().length]);
            else
            	field.focus([field.getRawValue().length]);
            
            if (field.autoSize) {
                field.autoSize();
            }
            me.editing = true;
        }
    }

});
*/
/****************************
 * Ext.grid.plugin.CellEditing
 * 아무키나 가지고 Edit 모드 들어 가게
 * 
 */
Ext.define('Ext.overide.grid.plugin.CellEditing', {
    override: 'Ext.grid.plugin.CellEditing',	
    onSpecialKey: function(ed, field, e) {
        var sm;
 		// Enter키를 Tab과 같이 사용
        if (e.getKey() === e.TAB || e.getKey() === e.ENTER) {
            e.stopEvent();

            if (ed) {
                // Allow the field to act on tabs before onEditorTab, which ends
                // up calling completeEdit. This is useful for picker type fields.
                ed.onEditorTab(e);
            }

            sm = ed.up('tablepanel').getSelectionModel();
            if (sm.onEditorTab) {
                return sm.onEditorTab(ed.editingPlugin, e);
            }
        }
    }
});


/****************************
 * Ext.grid.plugin.CellEditing
 * 아무키나 가지고 Edit 모드 들어 가게
 * - click으로 edit 모드 들어갈때 현제 선택 되었을때만 가능 하게
 * 
 */
Ext.define('Ext.overide.grid.plugin.Editing', {
    override: 'Ext.grid.plugin.Editing',
    // @private
//    initEditTriggers: function() {
//        var me = this,
//            view = me.view;
//
//        // Listen for the edit trigger event.
//        if (me.triggerEvent == 'cellfocus') {
//            me.mon(view, 'cellfocus', me.onCellFocus, me);
//        } else if (me.triggerEvent == 'rowfocus') {
//            me.mon(view, 'rowfocus', me.onRowFocus, me);
//        } else {
//
//            // Prevent the View from processing when the SelectionModel focuses.
//            // This is because the SelectionModel processes the mousedown event, and
//            // focusing causes a scroll which means that the subsequent mouseup might
//            // take place at a different document XY position, and will therefore
//            // not trigger a click.
//            // This Editor must call the View's focusCell method directly when we recieve a request to edit
//            if (view.getSelectionModel().isCellModel) {
//                view.onCellFocus = Ext.Function.bind(me.beforeViewCellFocus, me);
//            }
//
//            // Listen for whichever click event we are configured to use
//            me.mon(view, me.triggerEvent || ('cell' + (me.clicksToEdit === 1 ? 'click' : 'dblclick')), me.onCellClick, me);
//        }
//
//        // add/remove header event listeners need to be added immediately because
//        // columns can be added/removed before render
//        me.initAddRemoveHeaderEvents();
//        // wait until render to initialize keynav events since they are attached to an element
//        view.on('render', me.initKeyNavHeaderEvents, me, {single: true});
//    },
    
    /**
     * 선택되었을때만 Edit 모드 들어 가게 수정 
     * @param {} view
     * @param {} cell
     * @param {} colIdx
     * @param {} record
     * @param {} row
     * @param {} rowIdx
     * @param {} e
     */
//    onCellClick: function(view, cell, colIdx, record, row, rowIdx, e) {
//        // Make sure that the column has an editor.  In the case of CheckboxModel,
//        // calling startEdit doesn't make sense when the checkbox is clicked.
//        // Also, cancel editing if the element that was clicked was a tree expander.
//        var expanderSelector = view.expanderSelector,
//            // Use getColumnManager() in this context because colIdx includes hidden columns.
//            columnHeader = view.ownerCt.getColumnManager().getHeaderAtIndex(colIdx),
//            editor = columnHeader.getEditor(record);
//		//console.log('cellClick');
//		var editable = true;
//		if (view.getSelectionModel().isCellModel) {
//			var selModel = view.selModel;
//			var selection = selModel.selection;
//			if( selection &&  selection.column == colIdx &&  selection.row == rowIdx) {
//				editable = true;
//			} else {
//				editable = false;
//			}
//		}
//		//console.log('editable : ' , editable);
//        if (editor && editable && !expanderSelector || !e.getTarget(expanderSelector)) {
//           this.startEdit(record, columnHeader);
//        }
//    },
    
    initKeyNavHeaderEvents: function() {
        var me = this;
	/*
        me.keyNav = Ext.create('Ext.util.KeyNav', me.view.el, {
            enter: me.onEnterKey,
            esc: me.onEscKey,
            scope: me
        });
        */
        me.keyNav = new Ext.util.KeyMap({
        	target: me.view.el, 
        	processEvent:function(event, el) {
        		if(event.getKey ) {
        			// 입력 가능한 값이면 
        			if( me.isValuableEvenv( event) ) {
        				me.onValueKey(event);
        				event = {};
        			} else {
        				UNI_GRID_NEW_VAL = "";
        			}
        			
        		}
        		return event;
        	},
        	binding: [
	        	{	
	        		//key: [Ext.EventObject.ENTER, Ext.EventObject.SPACE, Ext.EventObject.F2],
	        		key: Ext.EventObject.ENTER,
	        		fn: me.onEnterKey,	//startEdit
	        		scope: me
	        	}, {
	        		key: Ext.EventObject.ESC, 
	        		fn: me.onEscKey,	//cancelEdit
	        		scope: me
	        	}/*, {
	                key: [48, 49, 50, 51, 52, 53, 54, 55, 56, 57],  // 0123456789
	                fn: me.onValueKey,
	                scope: me
	            }*/
	        ]
        });
    },
    isValuableEvenv: function(event) {
    	var chk = false;
		var key = event.getKey();
		if( key >= 48 && key < 93) {	// number, alphabet
			chk = true;
		} else if ( key >=96 && key <= 111) {	// numpad 
			chk = true;
		} else if ( key >=186 && key <= 192 || key >=219 && key <=222) {	// numpad 
			chk = true;
		}
		//console.log("Key : " + key +" : charCode = " + event.getCharCode() + "   is " + chk);
    	return chk
    },
 	onValueKey: function(e) {
            var me = this,
                grid = me.grid,
                selModel = grid.getSelectionModel(),
                record,
                columnHeader = grid.headerCt.getHeaderAtIndex(0);
 
            // Calculate editing start position from SelectionModel
            // CellSelectionModel
            if (selModel.isCellModel) {
                pos = selModel.getCurrentPosition();
                if(grid.store.getAt) {
                	record = grid.store.getAt(pos.row);
                }else{
                	record = selModel.getLastSelected();
                }
                columnHeader = grid.headerCt.getHeaderAtIndex(pos.column);
            }
            // RowSelectionModel
            else {
                record = selModel.getLastSelected();
            }
 
            ed = me.getEditor(record, columnHeader);
            if (ed) {
               UNI_GRID_NEW_VAL = String.fromCharCode(e);
            }
 
            // start cell edit mode
            //me.startEdit(record, columnHeader, null, true);
            me.startEdit(record, columnHeader);
        }
});


/*******************************************
 * UniAbstractGridPanel 
 */
Ext.define('Unilite.com.grid.UniAbstractGridPanel', {
	getEditor: function(me) {
		var editiong = Ext.create('Ext.grid.plugin.CellEditing', {
						//clicksToMoveEditor: 1,
						clicksToEdit: 2, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						autoCancel : false,
						listeners: {
							beforeedit: function(editor, e, eOpts) {	
								me.uniOpt.currentRecord = e.record;
								if( (e.column.uniOPT && e.column.uniOPT.isPk ) || (e.column.isLink) ) {
									if( e.record.phantom) {
										return true;
									} else {
										//UniApp.updateStatus( '추가건만 수정이 가능합니다.');
										return false;
									}
								}
								
							}
						}
			});
		return editiong;
	}, // getEditor
	// private
	setColumnInfo: function( me, col, fields) {
		if(! Ext.isDefined(col)) {
			console.error( "column is undefined !!! - ",col);
			return false;
		}

		// 기본 속성 등록
		Ext.applyIf(col, me.columnDefaults);
		
		if( col.isLink == true ) {
			Ext.applyIf(col, {'tdCls': 'GRID_COL_HREF'});
		}
		// 모델을 참조
		if(col.dataIndex) {
			var field = this._getField(fields, col.dataIndex);
			if (Ext.isDefined(field)) {
				var isFieldEditable = Unilite.nvl(field['editable'], true);
				//var colEditable  = Unilite.nvl(col,editable, true);
				var columnEditable = false;
				var lAllowBlank = Unilite.nvl(field['allowBlank'],true);
				//console.log(field['text'], editable, lAllowBlank);
				// 1.헤더명칭 등록(Model참조)
				var text = field['text'];
				if (!text) {
					text = col.dataIndex;
				}
				if( field.isPk) {
					Ext.applyIf(col, {uniOPT:{} });
					Ext.applyIf(col.uniOPT, {	'isPk' : field.isPk	});
				}
				//Ext.applyIf(col, {	'text' : text	});
				// mouse cursor 설정 
				var storeEditable = this._getStoreEditable(me);
				if(storeEditable && isFieldEditable && Unilite.nvl(col.editable, true)) {
//	노란색 제거 2014.4.8 
//					if(lAllowBlank == false) {
//						Ext.applyIf(col, {'tdCls': 'GRID_COL_EDITABLE GRID_COL_MANDATORY'});
//					} else {
//						Ext.applyIf(col, {'tdCls': 'GRID_COL_EDITABLE'});
//					}
					//if(lAllowBlank == false) {
					//	Ext.applyIf(col, {'style': {'background':  '#FCFCB6'}  });
					//}
					if(lAllowBlank == false) {
						text = "<span style='color:#f00 !important;font-weight:bold'>*</span>" + text;
					}
					columnEditable = true;
					Ext.applyIf(col, {'tdCls': 'GRID_COL_EDITABLE'});
				}
				Ext.applyIf(col, {	'text' : text	});
				if(  Ext.isDefined(col.editor)) {
					columnEditable = false;
				}
				// 타입 설정
				var fieldType = field['type'];
				var fieldFormat = field['format'];
				
				if(fieldType ) {
					var t = fieldType.type;
					var editListeners = {};
					var editorConfing = {
						'allowBlank' : lAllowBlank
					};
					if(field.minLength) {
						Ext.applyIf(editorConfing, {'minLength': field.minLength });
					}
					if(field.maxLength) {
						Ext.applyIf(editorConfing, {'maxLength': field.maxLength });
					}
					if(field.minValue) {
						Ext.applyIf(editorConfing, {'minValue': field.minValue });
					}
					if(field.maxValue) {
						Ext.applyIf(editorConfing, {'maxValue': field.maxValue });
					}
					
					
					//minLength / MaxLength
					//console.log(col.dataIndex, "TYPE", t, "-",fieldType, fieldFormat, lAllowBlank)
					if( t ==  'string') {
						Ext.applyIf(col, {align: 'left' });
						Ext.applyIf(editorConfing, {xtype : 'textfield' });
					} else if( t ==  'number') {
						Ext.applyIf(col, {align: 'right' , xtype:'numbercolumn' });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else  if( t ==  'int' || t ==  'integer') {
						Ext.applyIf(col, {align: 'right', xtype:'numbercolumn' , format:'0,000'});
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if( t ==  'float') {
						Ext.applyIf(col, {align: 'right', xtype:'numbercolumn'  });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });						
					} else if( t ==  'bool' || t == 'boolean') {
						Ext.applyIf(col, {
									xtype: 'booleancolumn',
									trueText: 'Yes',
    								falseText: 'No'});
						Ext.applyIf(col, {align: 'center' });
						Ext.applyIf(editorConfing, {xtype : 'booleanfield' });
						
					} else if( t ==  'date' || t ==  'uniDate') {
						Ext.applyIf(col, {align: 'center', xtype: 'uniDateColumn' });
						//Ext.applyIf(col, {format: Unilite.dateFormat });
						
						// 날자 Editor 설정 
						Ext.applyIf(editorConfing, {
							xtype : 'uniDatefield',
						    format: Unilite.dateFormat 
						 });
					} else if( t ==  'uniMonth') {
						Ext.applyIf(col, {align: 'center', xtype: 'uniMonthColumn' });
						//Ext.applyIf(col, {format: Unilite.monthFormat });
						
						// 날자 Editor 설정 
						Ext.applyIf(editorConfing, {
							xtype : 'uniMonthfield',
							format: Unilite.monthFormat
						 });
					} else if(t ==  'uniQty') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Qty });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });						
					} else if(t ==  'uniPrice') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });						
					} else if(t ==  'uniUnitPrice') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.UnitPrice });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if(t ==  'uniPercent') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Percent });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if(t ==  'uniFC') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.FC });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if(t ==  'uniER') {
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.ER });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if(t ==  'uniTime') {
						if(field.format) {
							if(field.format == 'His') {
								Ext.applyIf(col, {align: 'center' , 
									xtype:'uniTimeColumn', 
									format:'H:i:s' });
								Ext.applyIf(editorConfing, {
									xtype : 'uniTimefield',
									hideTrigger: true,
									autoSelect: false,
									increment: 1,
									format : "H:i:s",
									altFormats :'H|H:i|Hi|H:i:s|His',	
	    							submitFormat:'His'
	    							
								});
							}
						} else {
							Ext.applyIf(col, {align: 'center' , xtype:'uniTimeColumn' });
							Ext.applyIf(editorConfing, {xtype : 'uniTimefield'});
						}
					} else if(t ==  'uniYear') {
						Ext.applyIf(col, {align: 'right' , xtype:'string' });
						Ext.applyIf(editorConfing, {xtype : 'textfield' });
					} else if(t ==  'uniPassword') {
						Ext.applyIf(col, {'renderer' : function(val) { 
							if(Ext.isEmpty(val)) {
								return '';
							}else{
								return '********';
							}
						}});
						Ext.applyIf(editorConfing, {inputType :'password' });
					}
					if(columnEditable){
						Ext.applyIf(col, {'editor' : editorConfing});
					}
				} // type && editor(AUTO)
				
				/*
				if(fieldFormat )  {
					if(fieldFormat == 'price') {
						Ext.apply(col, {align: 'right' , xtype:'uniPriceColumn' });
					}
				}
				*/
				// 콤보 설정(code) comboType:'AU', comboCode:'CB23' 
				var isCombo = false;
				if(field.comboType) {	
					var combo = Unilite.form.createCombobox(field); // Unilite.js
					Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo) });
					if(columnEditable) {
						Ext.apply(col, {editor:  combo });
					}
					isCombo = true;
				} else if(field.store) {
					var combo = Unilite.form.createCombobox(field);
					Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo) });
					if(columnEditable) {
						Ext.apply(col, {editor:  combo });
					}
					isCombo = true;
				}
				
				if(isCombo) {
					Ext.apply(col, {doSort:  function(state) {
							console.log("do custom Sort for combobox");
							var ds = this.up('grid').getStore();
			                var field = this.getSortParam();
			                var colx = col; //col.renderer;
			                ds.sort({
			                    property: field,
			                    direction: state,
			                    transform: function(val) {
			                    	var t = colx.renderer(val);
			                    	if (t == undefined ) {
			                    		t = "";
			                    	}
			                    	//console.log( "transfer : " + val + " => " + t);
			                    	return t
			                    }

			                });
						}						
					}); //Ext.apply					
				} // if
			}
		} // col.dateindex
		
		
		if(col.tooltip) {
			Ext.applyIf(col, {renderer :function(value, metadata,record) { metadata.tdAttr = 'data-qtip="' + value + '"'; return value; } });
		}
		// column merge 처리용
		if(Ext.isArray(col.columns)) {
			//console.log(col.columns);
			for (var i = 0, len = col.columns.length; i < len; i++) {
				this.setColumnInfo(me, col.columns[i], fields );
			}
		}
		
	},
	    // grid의 store가 수정 가능한지 확인 
	_getStoreEditable : function(grid) {
		var storeEditable = false;
		if(grid.store.uniOpt) {
			if( grid.store.uniOpt.editable ) {
				storeEditable = true;
			}
		}
		return storeEditable;
	},
		// private
	_getField : function(fields, id) {
		var srchField;
		if (fields) {

			for (var i = 0, len = fields.length; i < len; i++) {
				var field = fields[i];
				if (field['name'] == id) {
					srchField = field;
					break;
				}
			}
		}
		return srchField;
	},
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function(grid, values, startEditColumnName, rowIndex, newRecord) {

		//현재행 다음줄 부터
		if(!rowIndex)  {
			rowIndex = grid.getSelectedRowIndex();
		}else if(rowIndex >= grid.getStore().getCount())  {
			rowIndex = grid.getSelectedRowIndex();
		}		
		rowIndex = (rowIndex < 0)? 0 : rowIndex +1;
		console.log("rowIndex = " ,rowIndex );
		
		if(!newRecord) {
			newRecord =  Ext.create (grid.store.model, values);
		}
		console.log("newRowIndex 1= " ,rowIndex );
		//newRecord = grid.store.insert(rowIndex, newRecord);
		grid.store.insert(rowIndex, newRecord);
		//console.log("newRowIndex 2= " ,rowIndex );
		if(grid.getSelectionModel().isCellModel) {
		}else{
			grid.getSelectionModel().select(rowIndex);
		}
		//grid.startEdit(startEditColumnName);
		//console.log("newRowIndex 3= " ,rowIndex );
		return newRecord;
	},
	/*
	onCellKeyDownFun : function (grid, viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts) {
		switch( e.getKey() ) {
			//case Ext.EventObject.ENTER:  // 기본으로 처리
			case Ext.EventObject.SPACE:
  			case Ext.EventObject.F2:
  			 	//console.log('start edit');
  			 	this.startEdit(grid, cellIndex);
    			break;
    		default:
    			var key = e.getKey();
    			console.log("Kye:", key);
    		
	    } // switch
	    
	},
	*/

	/**
	 * 현재 선택된 행에서 수정모드로 진입.
	 * @param {} columnName
	 */
	startEdit: function(grid, columnName, val) {
		var me = grid, column = 0, edit;
		if( typeof columnName == "String") {
			column = me.getColumn(columnName);
		} else if ( typeof columnName == "number") {
			column = columnName;
		}
		if(this._getStoreEditable(me)) {
			var edit = this.getEditing(grid);
			var vrow = this.getSelectedRecord(grid);
			edit.startEditByPosition({
	            row: vrow,
	            column: column
	        });
		}
		
	},
	/**
	 * 
	 * @return {}
	 */
	getEditing:function(grid) {
		return grid.editing;
	},
	
	getSelectedRecords: function(grid) {
		return grid.getSelectionModel().getSelection();
	},
	getSelectedRecord:function(grid) {
		var selectedRecords = this.getSelectedRecords(grid);
		if(selectedRecords && selectedRecords.length > 0 ) {
			return selectedRecords[0];
		}		
	},
	getColumnFilterType: function(t) {
		var filterType = '';
		if( t ==  'string') {
			filterType = 'string';
		} else if( t ==  'number') {
			filterType = 'numeric';
		} else  if( t ==  'int' || t ==  'integer') {
			filterType = 'numeric';
		} else if( t ==  'float') {
			filterType = 'numeric';	
		} else if( t ==  'bool' || t == 'boolean') {
			filterType = 'uniList';
			
		} else if( t ==  'date' || t ==  'uniDate' || t ==  'uniMonth') {
			filterType = 'date';
		} else if(t ==  'uniQty') {
			filterType = 'numeric';					
		} else if(t ==  'uniPrice') {
			filterType = 'numeric';					
		} else if(t ==  'uniUnitPrice') {
			filterType = 'numeric';
		} else if(t ==  'uniPercent') {
			filterType = 'numeric';
		} else if(t ==  'uniFC') {
			filterType = 'numeric';
		} else if(t ==  'uniER') {
			filterType = 'numeric';
		} else if(t ==  'uniTime') {
			filterType = 'string';
		} else if(t ==  'uniYear') {
			filterType = 'string';
		} else {
			filterType = 'string';
		}
		
		return filterType;
	}
});  // UniAbstractGridPanel
//@charset UTF-8
/**
 * 
 * Unilit용 표준 TreeGrid 셋업.
 * 
 * Grid 기본설정
 * - 설정상태 저장 기능(id 값이 필수로 지정 되어야 함 !) : 
 *   . 2013017 : cookie에 저장
 * - tooltip 지원
 * - model과 연동 
 *   
 * column 속성 확장
 * - tooltip : true : tooltip 보이게 
 */
 
 

Ext.define('Unilite.com.grid.UniTreeGridPanel', {
	extend: 'Ext.tree.Panel',
	alias: 'widget.uniTreeGridPanel',
	require:[
		'Ext.grid.plugin.CellEditing',
		'Unilite.com.grid.column.UniPriceColumn',
		'Unilite.com.grid.column.UniDateColumn',
    	'Unilite.com.UniAppManager',
    	'Unilite.UniDate'
	],
	 mixins: {
	 	gutil: 'Unilite.com.grid.UniAbstractGridPanel'
	 },
		
    xtype: 'tree-grid',
    rootVisible: false,
	/**
	 * 
	 * @property {Object} uniOpt
     * @readonly 
     * 
     * Unilite용 확장 속성을 저장하는 객체
     * 
     *     - currentRecord : grid에서 현재 수정중인 record (popup등에서 사용)
     *     - childForms : 현재 grid에 딸린 form
	 */
	uniOpt:{},
	/**
	 * 생성 가능한 최대 깊이
	 * @cfg(Number) maxDepth
	 */
	maxDepth : 4,
	
	/**
	 * grid 설정 상태 저장을 위한 설정
	 * 
	 * @cfg Boolean
	 */
	stateful: true,
	stateEvents: ['columnresize', 'columnmove', 'show', 'hide'],
	// 화면 layout 에서 grid부분을 자동으로 꽉 채우게
	flex:1,
	// column에 대한 기본값 속성 설정 
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center'
		//,menuDisabled:true
		,margin :'0 0 0 0'
		,sortable:true
	},
	//selType: 'rowmodel', // row 단위로 선택 됨. 단 lockmode 에서 수정시 오류 발생 함.
	selType: 'cellmodel',  // cell 단위로 선택됨 
	
	// check 박스를 통해 row를 select 할 경우 
	//selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
	selModel: {
            pruneRemoved: false // store에서 buffer 사용시 false로 해야 함.
    },
	viewConfig : {
		loadMask: true,
		trackOver: true,		// 
		stripeRows: true		//
//		selectedItemCls : 'GRID_ROW_SELECTED',			// checkbox랑 충돌 at 2014.2.27
//		focusedItemCls : 'GRID_ROW_FOCUSED'
	},
	sortableColumns : true,
	columnLines : true,
	
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
        
        if(!Ext.isDefined(config.plugins)) {
			config.plugins = new Array();		
		}
		if(!Ext.isDefined(config.features)) {
			config.features = new Array();		
		}
		
	
		
		var uniOpt = config.uniOpt || {};
		Ext.apply(uniOpt, {'childForms': new Array()}); 
		config.uniOpt = uniOpt;
		
		if (config) {
            Ext.apply(me, config);
        }
        
        this.callParent([config]);
	}, 
	
	/**
	 * 
	 */
	initComponent : function() {
		UniAppManager.register(this);
		var me = this;

		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		
		if (this.mixins.gutil._getStoreEditable(me)) {
			this.editing  = this.mixins.gutil.getEditor(me);
			if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push(this.editing);
			this.enableLocking = false;
		} else {
			
		}
		
		var model = mStore.model;
		var fields;
		if (model) {
			fields = model.getFields();
		}
		if(Ext.isArray(me.columns)) {
			for (var i = 0, len = me.columns.length; i < len; i++) {
				this.mixins.gutil.setColumnInfo(me, me.columns[i], fields );
			}
		} else {
			console.error("ERROR !!! please define columns");
		}
		this.callParent(arguments);
		
		
		// keyDown on Cell
		/*
        this.on('cellkeydown', function(viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts) {
        	me.mixins.gutil.onCellKeyDownFun(me, viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts);
        })
        */

	},
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.(Tree용으로 새로 개발 필요 !!)
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function( values, startEditColumnName, rowIndex) {
		var selModel = this.getSelectionModel();
		// Could also use:
        // var node = selModel.getSelection()[0];
        var node = selModel.getLastSelected();

        if (!node) {
            return;
        }
		if(node.getDepth() > this.maxDepth) {
			var msg = "단계초과 최대 깊이 = " + this.maxDepth;
			console.log(msg);
			UniAppManager.updateStatus(msg, true);			
			node = node.parentNode;
			//return;
		}
        // Feels like this should happen automatically
        node.set('leaf', false);

		var newRecord =  Ext.create (this.store.model, values);
		//newRecord.set('TREE_NAME', "new")
        newRecord.set('leaf', true);
        node.appendChild(newRecord);

        // The tree lines won't join up without a refresh
       // tree.getView().refresh();

        // Not strictly required but...
        node.expand();
        return newRecord;
                
	},
	
	/**
	 * 그리드 데이타 초기화 (Store 포함)
	 */
	reset:function() {
		//this.store.loadRecords({}, {addRecords: false});
		this.store.load(); 
		this.view.refresh();
	},
	/**
	 * 선택된 row들을 삭제 한다.
	 */
	deleteSelectedRow:function() {
		var sm = this.getSelectionModel();
		var store = this.getStore();
		var selected = sm.getSelection();
		//selected[0].remove();
		
		this.deleteNode(selected);
	}
	,deleteNode: function (nodes) {
		var me = this;
		/*  for loop안에서 요소를 삭제하면 이가 빠지면서 삭제됨 
		 * Ext.each(nodes, function(node, index) {
			console.log(nodes.length + " / " + index + ". " + node);
			if(node) {
				if(node.hasChildNodes()) {
					me.deleteNode(node.childNodes);
				};
				node.remove();
			} 
		});
		*/
		var check = true;
		do{
		  var node = nodes[0];
		  if(node) {
				if(node.hasChildNodes()) {
					me.deleteNode(node.childNodes);
				};
				console.log(nodes.length + " / " +  node.get('TREE_NAME'));
				if(node.parentNode == null) {
					check = false;
				}
				node.remove();
			}
		}while (nodes.length > 0 && check);
	},
	uniSelectInvalidColumnAndAlert:function(invalidRecords) {
		var invalidRec = Ext.isArray(invalidRecords) ? invalidRecords[0] : invalidRecords;
		
		var me = this;
		var fields = me.getStore().model.getFields();

		var errors = invalidRec.validate();
		var column ;
		if(errors.items) {
			column = errors.items[0].field;
		} else {
			console.log('찾아갈 오류내용(column) 없음');
		}
		
		var msg = '';
		errors.items.forEach(function(entry) {
			var field = me._getField(fields, entry.field);
			msg = msg + field.text + ': ' + entry.message + '\n';
		});		
		//alert(msg + Msg.sMB083);
		msg = '입력행의 입력값을 확인해 주세요.\n' + msg ;
		//UniAppManager.updateStatus(msg);
		alert(msg);
	}
});//  UniTreeGridPanel  //@charset UTF-8
  
  Ext.define('Unilite.com.grid.UniGridMultiSorter', {
    alternateClassName: ['UniGridMultiSorter'],
    singleton: true,
	createSorterButtonConfig: function ( grid, config ) {
	        config = config || {};
	        Ext.applyIf(config, {
	            listeners: {
	                click: function(button, e) {
	                    UniGridMultiSorter.changeSortDirection(grid, button, true);
	                }
	            },
	            iconCls: 'sort-' + config.sortData.direction.toLowerCase(),
	            reorderable: true,
	            xtype: 'button'
	        });
	        return config;
	},
    doSort: function (grid) {
    	grid.suspendEvents();
        var sorter = this.getSorters(grid);
        //console.log("doSort S", sorter, new Date().getTime());
        grid.store.sort(sorter);
        //console.log("doSort F", new Date().getTime());
        grid.resumeEvents();
	},
    changeSortDirection: function (grid, button, changeDirection) {
	        var sortData = button.sortData,
	            iconCls  = button.iconCls;
	        
	        if (sortData) {
	            if (changeDirection !== false) {
	                button.sortData.direction = Ext.String.toggle(button.sortData.direction, "ASC", "DESC");
	                button.setIconCls(Ext.String.toggle(iconCls, "sort-asc", "sort-desc"));
	            }
	            grid.store.clearFilter();
	            this.doSort(grid);
	        }
	    },
	 getSorters: function (grid) {
	        var sorters = [];
	 		if(grid.uniSortingToolbar ) {
		        Ext.each(grid.uniSortingToolbar.query('button'), function(button) {
		            sorters.push(button.sortData);
		        }, this);
	 		}
	        return sorters;
	 },
	 // Grid header에서 Sorting시 SortingToolBar내용 제거 후 전달된 column을 다시 생성함.
	 clearSortingToolbar: function(grid, column, pDirection) {
	        var sortBtns = [];
	 		if(grid.uniSortingToolbar ) {
	 			 Ext.each(grid.uniSortingToolbar.query('button'), function(button) {
		            sortBtns.push(button);
		        }, this);
	 			//for (var i = 0; i < sortBtns.length; ++i) {
	 			//	grid.uniSortingToolbar.remove(sortBtns[i], true);
	 			//	console.log('remove');
				//}
				grid.uniSortingToolbar.removeAll();
	 		}
	 		if(column) {
	 			
				var btnText = column.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
	 			var newButton = this.createSorterButtonConfig( grid, {
		                text: btnText,
		                sortData: {
		                    property: column.dataIndex,
		                    direction: pDirection
		                }
		            });
		            grid.uniSortingToolbar.insert(0,newButton);
	 		}
	 		
	 	
	 }
    	
});  //@charset UTF-8
  
  Ext.define('Unilite.com.grid.UniGridGrouper', {
    alternateClassName: ['UniGridGrouper'],
    singleton: true,
	createGroupButtonConfig: function ( grid, config ) {
			grid.uniGroupingToolbar.removeAll();
			
	        config = config || {};
	        Ext.applyIf(config, {
	            listeners: {
	                click: function(button, e) {

	                }
	            },
	            //iconCls: 'sort-' + config.sortData.direction.toLowerCase(),
	            reorderable: true,
	            xtype: 'button'
	        });
	        return config;
	},
    doGroupSummary: function (grid) {
    	
    	grid.suspendEvents();
        
        var store = grid.getStore();
        var drops = this.getDrops(grid);
        
        if( (store.getCount() > 0) && !Ext.isEmpty(drops) ) {
			
        	//group
	        store.clearGrouping();
		    store.group(drops[0].dataIndex, 'ASC');
	
		    //summary
		    var view;
		    if(grid.lockedGrid) {
			    view = grid.lockedGrid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
				
				view = grid.normalGrid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
		    } else {
		    	view = grid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
		    }
		    
        };

        grid.resumeEvents();
	},
	 getDrops: function (grid) {
	        var drops = [];
	 		if(grid.uniGroupingToolbar ) {
		        Ext.each(grid.uniGroupingToolbar.query('button'), function(button) {
		            drops.push(button.groupData);
		        }, this);
	 		}
	        return drops;
	 },
	 // Grid header에서 Grouping시 GroupingToolBar내용 제거 후 전달된 column을 다시 생성함.
	 clearGroupingToolbar: function(grid, column, pDirection) {
	        var sortBtns = [];
	 		if(grid.uniGroupingToolbar ) {
	 			 Ext.each(grid.uniGroupingToolbar.query('button'), function(button) {
		            sortBtns.push(button);
		        }, this);
	 			//for (var i = 0; i < sortBtns.length; ++i) {
	 			//	grid.uniGroupingToolbar.remove(sortBtns[i], true);
	 			//	console.log('remove');
				//}
				grid.uniGroupingToolbar.removeAll();
	 		}
	 		if(column) {
	 			
				var btnText = column.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
	 			var newButton = this.createGroupButtonConfig( grid, {
		                text: btnText,
		                groupData: {
		                    dataIndex: column.dataIndex,
		                    direction: pDirection
		                }
		            });
		            grid.uniGroupingToolbar.insert(0,newButton);
	 		}
	 		
	 	
	 }
    	
});//@charset UTF-8



Ext.define('Unilite.com.grid.UniSimpleGridPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.uniSimpleGridPanel',
	margin: '1 1 1 1',
	split:{size: 1},
	mixins: {
		 	gutil: 'Unilite.com.grid.UniAbstractGridPanel'
	},
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center',
		//,menuDisabled:true
		margin :'0 0 0 0',
		sortable: true
	},
	viewConfig : {
		shrinkWrap: 1, //3, //default:2
		enableTextSelection: true, 	// default : false
		loadMask: true,
		trackOver: true,		// 
		stripeRows: true		// 겹줄표시
	},
	sortableColumns : false,
	columnLines : true,
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
       		
        if (config) {
            Ext.apply(me, config);
        }
        

        this.callParent([config]);
	}, // constructor
	/**
	 * 
	 */
	initComponent : function() {
		UniAppManager.register(this);
		var me = this;
		
		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		var model = mStore.model;
		var fields;
		if (model) {
			fields = model.getFields();
		}
		
		if(Ext.isArray(me.columns)) {
			
			for (var i = 0, len = me.columns.length; i < len; i++) {
				this.mixins.gutil.setColumnInfo(me, me.columns[i], fields );
			}
		} else {
			console.error("ERROR !!! please define columns");
		}
		//me.columns.push();
		
		this.callParent(arguments);
	}  // initComponent
});//@charset UTF-8
/**
 * 
 * Unilit용 표준 Grid 셋업.
 * 
 * Grid 기본설정
 * - 설정상태 저장 기능(id 값이 필수로 지정 되어야 함 !) : 
 *   . 2013017 : cookie에 저장
 * - tooltip 지원
 * - model과 연동 
 *   
 * column 속성 확장
 * - tooltip : true : tooltip 보이게 
 */


Ext.define('Unilite.com.grid.UniGridPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.uniGridPanel',
	alternateClassName: 'Unilite.UniGridPanel',
	margin: '1 1 1 1',
	split:{size: 1},
	requires: [
		'Ext.grid.plugin.CellEditing',
		'Ext.ux.BoxReorderer',
		'Ext.ux.ToolbarDroppable',
		'Ext.toolbar.TextItem',
        'Ext.form.field.Checkbox',
        'Ext.ux.statusbar.StatusBar'	,
        //'Unilite.com.form.field.UniTextField',
		'Unilite.com.grid.column.UniPriceColumn',
		'Unilite.com.grid.column.UniDateColumn',
		'Unilite.com.grid.column.UniTimeColumn',
    	'Unilite.com.UniAppManager',
    	'Unilite.UniDate',
    	'Unilite.com.grid.UniGridMultiSorter'
	],
	 mixins: {
	 	gutil: 'Unilite.com.grid.UniAbstractGridPanel',
	 	search: 'Unilite.com.grid.UniGridLiveSearch'
	 },
	//formBind: true,		// true로 form 안에 grid가 disabled되는 경우 발생 
	
	/**
	 * 
	 * @property {Object} uniOpt
     * @readonly 
     * 
     * Unilite용 확장 속성을 저장하는 객체
     * 
     *     - currentRecord : grid에서 현재 수정중인 record (popup등에서 사용)
     *     - childForms : 현재 grid에 딸린 form
     *     - expandLastColumn :
     *     - useRowNumberer : 좌측에 row number 자동 부여 및 lock
     *     - useMultipleSorting : 
	 */
	uniOpt:{
		//column option--------------------------------------------------
		expandLastColumn: true,
		useRowNumberer: true,		//번호 컬럼 사용 여부		
		filter: {
			useFilter: false,		//컬럼 filter 사용 여부
			autoCreate: true		//컬럼 필터 자동 생성 여부
		},
		//toolbar option--------------------------------------------------
		useGroupSummary: false,		//그룹핑 버튼 사용 여부
		useMultipleSorting: false,	//정렬 버튼 사용 여부
		useLiveSearch: false,		//내용검색 버튼 사용 여부		
		state: {
			useState: true,			//그리드 설정 버튼 사용 여부
			useStateList: true		//그리드 설정 목록 사용 여부
		},
		excel: {
			useExcel: true,			//엑셀 다운로드 사용 여부
			exportGroup : false		//group 상태로 export 여부
		},
		//grid row&cell option--------------------------------------------
		useContextMenu: false,		//Context 메뉴 자동 생성 여부 
		copiedRow: null	,
		onLoadSelectFirst: true,
		
		_selectionRecord: {			//selectionChangeRecord event에서 사용됨
			oldRecordId:'',
			newRecordId:''
		}
	},
	uniText: {
		sortingBar: {
			btnSort: '정렬',
			sortingOrder: '정렬순서',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		groupingBar: {
			btnGroup: '그룹핑',
			groupColumn: '그룹항목',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		searchBar: {
			btnFind: '내용검색',
			searchColumn: '내용검색',
			emptyText: '검색어를 입력하세요.',
			btnPrev: '이전 찾기',
			btnNext: '다음 찾기'
		},
		btnSummary: '합계표시',
		btnExcel: '엑셀 다운로드',
		columns: {
			etc: '*'
		},
		contextMenu: {
			rowCopy: '행 복사',
			rowPaste: '복사한 행 삽입'
		}
	},
	/**
	 * grid 설정 상태 저장을 위한 설정
	 * 
	 * @cfg Boolean
	 */
	stateful: true,
	stateEvents: ['columnresize', 'columnmove', 'show', 'hide'],
	// 화면 layout 에서 grid부분을 자동으로 꽉 채우게
	flex: 1,
	// column에 대한 기본값 속성 설정 
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center',
		//,menuDisabled:true
		margin :'0 0 0 0',
		sortable: true
	},
//	plugins: {'bufferedrenderer'},
	plugins: [
		{	 
        	ptype: 'bufferedrenderer',
        	pluginId: 'bufferedrenderer',
        	trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
			leadingBufferZone: 50
		}
	],
	selType: 'rowmodel', // row 단위로 선택 됨. 단 lockmode 에서 수정시 오류 발생 함.
	//selType: 'cellmodel',  // cell 단위로 선택됨, 단 조회용의 경우(store가 editable false의경우) rowmodel
	
	// check 박스를 통해 row를 select 할 경우 
	//selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
	selModel: {
            pruneRemoved: false // store에서 buffer 사용시 false로 해야 함.
    },
    viewConfig : {
		shrinkWrap: 1 //3, 				//default: 2
		,enableTextSelection: true 		//default: false
		,loadMask: true					//default: true
		//trackOver: true,				//default: false 
		//stripeRows: true				//default: true 겹줄표시		
		//,selectedItemCls : 'GRID_ROW_SELECTED'			// checkbox랑 충돌 at 2014.2.27
		//focusedItemCls : 'GRID_ROW_FOCUSED'
	},
	sortableColumns : true,
	columnLines : true,
	
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
       	
        //config: create 시에 설정한 config
        
//        if (config) {
//            Ext.apply(me, config);
//        }
        var uniOpt = me.uniOpt;
        if(config) {
        	Ext.apply(uniOpt, {'childForms': new Array()}); 
        	// if recursive merging and cloning is need, use Ext.Object.merge instead.
        	// Ext.apply 는 merge 하지 않고 overwrite 함.        	     
        	if(config.uniOpt) {        		
        		uniOpt = config.uniOpt = Ext.Object.merge(uniOpt, config.uniOpt);
        	}
			
			if(uniOpt.expandLastColumn) {
				var bigoConfig = {text: this.uniText.columns.etc,	flex: 1, minWidth:120, 
										resizable: false, hideable:false, sortable:false, lockable:false,
										menuDisabled: true, draggable: false
				};
				//config.columns.push(bigoConfig);
				config.columns = Ext.Array.push(config.columns, bigoConfig);
			}
        	
        	Ext.apply(me, config);
        }
        
//        if(!Ext.isDefined(config.plugins)) {
//			config.plugins = new Array();		
//		}
		if(!Ext.isDefined(config.features)) {
			config.features = new Array();		
		}
		
        // bufferedrenderer plugin config
//        var bufferedPlugin = {	 
//        	ptype: 'bufferedrenderer',
//        	pluginId: 'bufferedrenderer',
//			trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
//			leadingBufferZone: 20
//		}; 
//		config.plugins.push(bufferedPlugin);
		
		// filter
		if(Ext.isDefined(me.uniOpt.filter) && me.uniOpt.filter.useFilter) {

			var filtersCfg = 
			{
				id : 'masterGridFilters',
				ftype : 'filters',
			    local: 'true',
			    encode: false
			};

			if(this.uniOpt.filter.autoCreate) {
				var fieldName, filter, filterType;
				
				filtersCfg.filters = [];
				for (var column in config.columns) {
				    fieldName = config.columns[column].dataIndex;
				    filter = config.columns[column].filter;
				    if (fieldName) 
				    {
				    	if(filter) {
				    		filterType= filter.type;	
				    	} else {
					    	filterType = this.getColumnFilterType( this.getModelField(fieldName).type.type );
				    	}
	
				        filtersCfg.filters.push(
				        {
				            dataIndex: fieldName,
				            type: filterType
				        });
				    }
				}
			}

			config.features.push(filtersCfg);
		}
		
		// 편집모드의 경우
		if(config.store && config.store.uniOpt && config.store.uniOpt.editable) {
			config.selType= 'rowmodel';
			Ext.apply(config, {selType: 'rowmodel'} );
			
			Ext.apply(me.viewConfig, {enableTextSelection: false} ); //(true로 하면 Chrome 에서 에디팅모드 시 셀에 잔상이 보여지다 사라지는 문제가 있음.)
		}
		
		/*var uniOpt = this.uniOpt || {};
		Ext.apply(uniOpt, config.uniOpt );
		Ext.apply(uniOpt, {'childForms': new Array()}); 
		config.uniOpt = uniOpt;
		
		if(uniOpt.expandLastColumn) {
			var bigoConfig = {text: this.uniText.columns.etc,	flex: 1, minWidth:120, 
									resizable: false, hideable:false, sortable:false, lockable:false,
									menuDisabled: true, draggable: false
			};
			//config.columns.push(bigoConfig);
			config.columns = Ext.Array.push(config.columns, bigoConfig);
		}
		if (config) {
            Ext.apply(me, config);
        }*/
        
		me.addEvents(
			/**
			 * Unilite용 추가 Event
			 * @event onGridDblClick
			 * @param grid
			 * @param record
			 * @param cellIndex
			 * @param colName
			 */
			'onGridDblClick',
			'onGridKeyDown',
			'statelistchange',
			'statelistselect',
			'beforePasteRecord',
			'afterPasteRecord',
			'selectionchangerecord'
		);
        this.callParent([config]);
	}, 
	
	/**
	 * 
	 */
	initComponent : function() {
		var me = this;
		
		UniAppManager.register(this);

		//edit grid 인 경우 
		if (this.mixins.gutil._getStoreEditable(me)) {
			this.editing  = this.mixins.gutil.getEditor(me);
			if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push(this.editing);
			
			this.enableLocking = false;			
			this.uniOpt.state.useState = false;
			this.uniOpt.state.useStateList = false;
			
		} else {
			//console.log("Grid readonly");
			//this.selType =  'rowmodel';
		}
		
		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		var model = mStore.model;
		var fields;
		if (model) {
			fields = model.getFields();
		}
		if(Ext.isArray(me.columns)) {
			if(this.uniOpt.useRowNumberer) {
				if(this.selModel && Ext.getClassName(this.selModel) !=	"Ext.selection.CheckboxModel") {
					var rNum = {
						xtype: 'rownumberer', 
						sortable:false, 
						locked: true, 
						width: 35,
						align:'center  !important',
						resizable: true
					};
					me.columns = Ext.Array.insert(me.columns,0, [rNum]);
				}
			}
			for (var i = 0, len = me.columns.length; i < len; i++) {
				this.mixins.gutil.setColumnInfo(me, me.columns[i], fields );
			}
		} else {
			console.error("ERROR !!! please define columns");
		}
		//me.columns.push();
		
		this.callParent(arguments);
		
 		me.on('statelistchange', me._onStateListChange);
		me.on('statelistselect', me._onStateListSelect);
		
        // grid가 그려진후 
        this.on('render', this._onRenderFun);
        

        
        // keyDown on Cell
        /*
        this.on('cellkeydown', function(viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts) {
        	me.mixins.gutil.onCellKeyDownFun(me, viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts);
        }),
		*/
        // 더블클릭 on Cell
        this.on('celldblclick', this._onCellDblClickFun);
        
		// 행이동시 
        this.on('selectionchange', this._onSelectionchange);
		/*
		 * // 마우스 우측 click 이벤트에 context 메뉴 등록
		 me.contextMenu = new Unilite.com.menu.UniMenu({
				grid: me,
			    items: [
				    Ext.create('Ext.Action', {
				        iconCls   : 'icon-sheetSaveState',
				        text: '삭제',
				        disabled: false,
				        handler: function(widget, event) {
				        	
				          
				        }
				    })		    
			    ]   
			});
			
		
		this.on('itemcontextmenu',function(view, rec, node, index, e) {
            e.stopEvent();
            this.contextMenu.showAt(e.getXY());
            return false;
        });
        */
        // column resize 후 
        //this.on('columnresize',this._onColumnResizeFun);
        
        this.contextMenu = Ext.create('Ext.menu.Menu', {});
        
        var tbar = this._getToolBar();
        
    	if(Ext.isEmpty(tbar)) {
    		if(this.uniOpt.useGroupSummary || this.uniOpt.useLiveSearch || 
    			this.uniOpt.state.useState || this.uniOpt.state.useStateList || 
    			this.uniOpt.excel.useExcel || me.getStore().isGrouped()) {
	    		var bar = Ext.create('Ext.toolbar.Toolbar', {
			    	dock: 'top',
			        items : ['->']
		    	});
		    	this.addDocked(bar);
		    	tbar = this._getToolBar();
    		}
    	} else {
    		
    		tbar[0].insert(0, '->');
    	}
    	
    	this._createContextMenu(tbar[0]);
        
    	if(!Ext.isEmpty(tbar) && this.uniOpt.excel.useExcel) {

        	var excelBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-excel',
        		width: 26, height: 26,
        		tooltip: this.uniText.btnExcel,
        		handler: function() {
        			me.downloadExcelXml();
        		}
        	}
        	tbar[0].insert(0, excelBtn);
        }
    	
    	/************************************
         * for Toggle Summary
         */
    	if(!Ext.isEmpty(tbar)) {
	    	var toggleSummaryBtn = Ext.create('Unilite.com.button.BaseButton', {
	    		//xtype: 'uniBaseButton',
	    		iconCls: 'icon-grid-sum',
        		width: 26, height: 26,
        		tooltip: this.uniText.btnSummary,
	    		itemId: 'toggleSummaryBtn',
	    		enableToggle: true,
			    pressed:  false,
			    hidden: me.getStore().isGrouped() ? false:true,
	    		handler: function() {
	    			if(me.getStore().isGrouped()) {
	    				if(me.lockedGrid) {
						    view = me.lockedGrid.getView();
						    view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );																
							view.refresh();
							
							view = me.normalGrid.getView();
							view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
							view.refresh();
					    } else {
					    	view = me.getView();
					    	view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
							view.refresh();
					    }
	    			}
	    		}
	    	});
//	    	if(me.getStore().isGrouped()) {
//	    		toggleSummaryBtn.show();
//	    	}
	    	tbar[0].insert(0, toggleSummaryBtn);
    	}
    	//그풉핑 변경 시 이벤트
    	// - '합계표시' 버튼 보이기 제어
    	me.getStore().on({
    		groupchange: {
    			//scope : me,
    			fn: function(store, groupers, eOpts){
    				var tbar = me._getToolBar();
    				if(!Ext.isEmpty(tbar)) {
						var toggleSummaryBtn = tbar[0].down("#toggleSummaryBtn");
						if(toggleSummaryBtn) {
							if(store.isGrouped()) {
					    		toggleSummaryBtn.show();
					    	}else{
					    		toggleSummaryBtn.hide();
					    	}
						}
    				}
    			}
    		}
    	});
    	
    	
    	/************************************
         * for Toggle Filters
         */
    	/*var toggleFilterBtn = {
    		text: '필터사용',
    		enableToggle: true,
		    pressed: this.uniOpt.useFilter,
    		handler: function() {
    			if(me.getStore().isGrouped()) {
    				if(me.lockedGrid) {
					    view = me.lockedGrid.getView();
					    if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.lockedFilters)
								filterFeature.filters = me.lockedFilters;
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());

					    } else {
					    	me.lockedFilters = view.getFeature('masterGridFilters').filters;
					    	view.getFeature('masterGridFilters').removeAll();	
							Ext.Array.remove(view.features, view.getFeature('masterGridFilters'));				

					    }
						view.refresh();
						
						view = me.normalGrid.getView();
						if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.normalFilters)
								filterFeature.filters = me.normalFilters;
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());
					    } else {
					    	me.normalFilterFs = view.getFeature('masterGridFilters').filters;
							view.getFeature('masterGridFilters').removeAll();				
					    	Ext.Array.remove(view.features, view.getFeature('masterGridFilters'));

					    }
					    view.refresh();
					    me.doLayout();
					    
						
					    
				    } else {
				    	view = me.getView();
				    	if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.normalFilters || me.lockedFilters)
								filterFeature.filters = me.normalFilters || me.lockedFilters || {};
					
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());
					    } else {
					    	me.normalfilters = view.getFeature('masterGridFilters').filters;
							view.getFeature('masterGridFilters').removeAll();							
							Ext.Array.remove(view.features, view.getFeature('masterGridFilters')); 
					    }

						view.refresh();
					    me.doLayout();
				    }
    			}
    		}
    	}
    	tbar[0].insert(0, toggleFilterBtn);*/
    	
        /************************************
         * for LiveSearch
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.useLiveSearch) {

        	var liveSearchBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-grid-find',
        		width: 26, height: 26,
        		tooltip: this.uniText.searchBar.btnFind,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniSearchToolbar) {
        				var wrapper = me.uniSearchToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
        	tbar[0].insert(0, liveSearchBtn);
        	
		    me.uniSearchToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'textfield',
			            name: 'searchField',
			            listeners: {
		                    change: {
		                         fn: me.mixins.search.onTextFieldChange,
		                         scope: this,
		                         buffer: 500
		                    },
		                    specialkey: function(field, e, eOpts){
				            	if(e.getKey() == e.ENTER){
        							field.fireEvent('change', field.getValue(), '', eOpts);
				            	}
				         	}
		                 },
		                 emptyText: this.uniText.searchBar.emptyText
		        	}, {
		                xtype: 'button',
		                text: '&lt;',
		                tooltip: this.uniText.searchBar.btnPrev,
		                handler: me.mixins.search.onPreviousClick,
		                scope: me
		            },{
		                xtype: 'button',
		                text: '&gt;',
		                tooltip: this.uniText.searchBar.btnNext,
		                handler: me.mixins.search.onNextClick,
		                scope: me
		            }, '-', {
		                xtype: 'checkbox',
		                hideLabel: true,
		                margin: '0 0 0 4px',
		                handler: me.mixins.search.regExpToggle,
		                scope: me                
		            }/*, '정규식', {
		                xtype: 'checkbox',
		                hideLabel: true,
		                margin: '0 0 0 4px',
		                handler: me.mixins.search.caseSensitiveToggle,
		                scope: me
		            }*/, '대소문자',		            
		            '->',{
		            	xtype: 'tbtext',
		            	itemId: 'searchStatus',
			            text: me.mixins.search.defaultStatusText
		            }
		        ]
		    });
		    
		    var searchBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.searchBar.searchColumn,
			            reorderable: false
			        },		        	
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniSearchToolbar
		    	]		    	
		    });

		    this.addDocked(searchBarWrap);
	    
        } // useLiveSearch

        
        /************************************
         * for MultiSOrting
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.useMultipleSorting) {
        	var multiSortingBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-grid-sort',
        		width: 26, height: 26,        		
        		tooltip: this.uniText.sortingBar.btnSort,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniSortingToolbar) {
        				var wrapper = me.uniSortingToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
            
//        	var chkBtnLocation=true;
//        	Ext.each(tbar[0].items.items, function(item, index) {
//        		console.log("chkBtnLocation",item);
//        		if(item.getXType() == 'tbfill')	chkBtnLocation = false;
//        	});
//        	
//        	if(chkBtnLocation)	{
//        		tbar[0].add('->');
//        	}
        	tbar[0].insert(0, multiSortingBtn);
        	console.log("tbar[0]", tbar[0]);
        	
        	var reorderer = Ext.create('Ext.ux.BoxReorderer', {
		        listeners: {
		            scope: this,
		            Drop: function(r, c, button) { //update sort direction when button is dropped
		                UniGridMultiSorter.changeSortDirection(me, button, false);
		            }
		        }
		    });

		    var droppable = Ext.create('Ext.ux.ToolbarDroppable', {
		        /**
		         * Creates the new toolbar item from the drop event
		         */
		        createItem: function(data) {
		            var header = data.header,
		                headerCt = header.ownerCt,
		                reorderer = headerCt.reorderer;
		            
		            if (reorderer) {
		                reorderer.dropZone.invalidateDrop();
		            }
					var btnText = header.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
		            return UniGridMultiSorter.createSorterButtonConfig( me, {
		                text: btnText,
		                sortData: {
		                    property: header.dataIndex,
		                    direction: "ASC"
		                }
		            });
		        },
		
		        canDrop: function(dragSource, event, data) {
		            var sorters = UniGridMultiSorter.getSorters(me),
		                header  = data.header,
		                length = sorters.length,
		                entryIndex = this.calculateEntryIndex(event),
		                targetItem = this.toolbar.getComponent(entryIndex),
		                i;
		            if (!header.dataIndex || (targetItem && targetItem.reorderable === false)) {
		                return false;
		            }
		
		            for (i = 0; i < length; i++) {
		                if (sorters[i].property == header.dataIndex) {
		                    return false;
		                }
		            }
		            return true;
		        },
				//afterLayout: doSort
		       	afterLayout: function() {
		       		UniGridMultiSorter.doSort(me);
		       	} 
		    }); //droppable
	
		    //create the toolbar with the 2 plugins
		    me.uniSortingToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'tbtext',
			            text: this.uniText.sortingBar.dragAndDropHelp,
			            flex:1
		        	}
		        ],
		        hasHelp: true,
		        plugins: [reorderer, droppable],
		        listeners: {
		        	add: function ( tbar, component, index, eOpts ) {
		        		if(tbar.hasHelp && component.xtype != 'tbtext' ) {		        			
			        		var text = tbar.down('tbtext');
			        		if(text) {
			        			tbar.remove(text);
			        			tbar.hasHelp = false;
			        		}
		        		}
		        	}
		        }
		    });
		    
		    var sortBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.sortingBar.sortingOrder,
			            reorderable: false
			        },
		        	/*{
			            xtype: 'button',
			            text: 'Clear',
			            handler: function() {
							me.uniSortingToolbar.removeAll();
			            }
			        } ,*/
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniSortingToolbar
		    	]		    	
		    });
//		    tbar.push(sortingToolbar);
		    this.addDocked(sortBarWrap);//me.uniSortingToolbar);
	    
		    me.on('afterlayout', function(grid) {
                var lockedHeaderCt = grid.down("#lockedHeaderCt");
                var normalHeaderCt = grid.down("#normalHeaderCt");
                var needSort = false;
                if(lockedHeaderCt || lockedHeaderCt ) {
	                if(lockedHeaderCt) {
			                droppable.addDDGroup(lockedHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;
		            }  
		            if (normalHeaderCt) {
			                droppable.addDDGroup(normalHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;

                         // 기존 toolbar도 dropzone으로 변경
			            /*    
                        var tbar = me._getToolBar()[0];
                        tbar.dropTarget = Ext.create('Ext.dd.DropTarget', tbar.getEl(), {
                            notifyOver: function() {
						         var wrapper = me.uniSortingToolbar.up('toolbar');
                                 wrapper.show();
                                 return false;
                            }
                        });
                        tbar.canDrop= function() { return true;};
                        tbar.dropTarget.addToGroup(normalHeaderCt.reorderer.dragZone.ddGroup);*/
		            }
                } else {
	                var headerCt = grid.child("headercontainer");
	                if(headerCt) {
		                droppable.addDDGroup(headerCt.reorderer.dragZone.ddGroup);
			            needSort = true;
                        

	                }
                }
                if(needSort) {
	                UniGridMultiSorter.doSort(grid);
                }
               
            }, this, {single:true});
            
            me.on('sortchange', function(ct, column, direction, eOpts) {
            	console.log('sortchange:', eOpts);
            	UniGridMultiSorter.clearSortingToolbar(me, column, direction);
            });// sortchange
            
        	console.log("MultipleSorting enabled");
        }; // useMultipleSorting
        
        
        /************************************
         * for GroupSummary
         */
        //if(this.uniOpt.useGroupSummary && !this.uniOpt.useMultipleSorting) {
        if(!Ext.isEmpty(tbar) && this.uniOpt.useGroupSummary) {

        	var groupSummaryBtn = {
        		text: me.uniText.groupingBar.closed,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniGroupingToolbar) {
        				var wrapper = me.uniGroupingToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
        	tbar[0].insert(0, groupSummaryBtn);
        	
        	/*
        	var reorderer = Ext.create('Ext.ux.BoxReorderer', {
		        listeners: {
		            scope: this,
		            Drop: function(r, c, button) { //update sort direction when button is dropped
		                UniGridMultiSorter.changeSortDirection(me, button, false);
		            }
		        }
		    });*/

		    var droppable = Ext.create('Ext.ux.ToolbarDroppable', {
		        /**
		         * Creates the new toolbar item from the drop event
		         */
		        createItem: function(data) {
		            var header = data.header,
		                headerCt = header.ownerCt,
		                reorderer = headerCt.reorderer;
		            
		            if (reorderer) {
		                reorderer.dropZone.invalidateDrop();
		            }
					var btnText = header.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
		            return UniGridGrouper.createGroupButtonConfig( me, {
		                text: btnText,
		                groupData: {
		                    dataIndex: header.dataIndex
		                }
		            });
		        },
		
		        canDrop: function(dragSource, event, data) {
		            var drops = UniGridGrouper.getDrops(me),
		                header  = data.header,
		                length = drops.length,
		                entryIndex = this.calculateEntryIndex(event),
		                targetItem = this.toolbar.getComponent(entryIndex),
		                i;
		
		            if (!header.dataIndex || (targetItem && targetItem.reorderable === false)) {
		                return false;
		            }
		
		            for (i = 0; i < length; i++) {
		                if (drops[i].dataIndex == header.dataIndex) {
		                    return false;
		                }
		            }
		            return true;
		        },
				//Add any required cleanup logic here
		       	afterLayout: function() {
		       		
		       		UniGridGrouper.doGroupSummary(me);
		       		
		       	} 
		    }); //droppable
	
		    //create the toolbar with the 2 plugins
		    me.uniGroupingToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'tbtext',
			            text: this.uniText.groupingBar.dragAndDropHelp,
			            flex:1
		        	}
		        ],
		        hasHelp: true,
		        plugins: [droppable],
		        listeners: {
		        	add: function ( tbar, component, index, eOpts ) {
		        		if(tbar.hasHelp && component.xtype != 'tbtext' ) {		        			
			        		var text = tbar.down('tbtext');
			        		if(text) {
			        			tbar.remove(text);
			        			tbar.hasHelp = false;
			        		}
		        		}
		        	}
		        }
		    });
		    
		    var groupBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.groupingBar.groupColumn,
			            reorderable: false
			        },
		        	/*{
			            xtype: 'button',
			            text: 'Clear',
			            handler: function() {
							me.uniSortingToolbar.removeAll();
			            }
			        } ,*/
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniGroupingToolbar
		    	]		    	
		    });

		    this.addDocked(groupBarWrap);//me.uniSortingToolbar);
	    
		    me.on('afterlayout', function(grid) {
                var lockedHeaderCt = grid.down("#lockedHeaderCt");
                var normalHeaderCt = grid.down("#normalHeaderCt");
                var needGroup = false;
                if(lockedHeaderCt || normalHeaderCt ) {
	                if(lockedHeaderCt) {
			                droppable.addDDGroup(lockedHeaderCt.reorderer.dragZone.ddGroup);
			                needGroup = true;
		            }  
		            if (normalHeaderCt) {
			                droppable.addDDGroup(normalHeaderCt.reorderer.dragZone.ddGroup);
			                needGroup = true;
		            }
                } else {
	                var headerCt = grid.child("headercontainer");
	                if(headerCt) {
		                droppable.addDDGroup(headerCt.reorderer.dragZone.ddGroup);
			            needGroup = true;
	                }
                }
                if(needGroup) {
	                UniGridGrouper.doGroupSummary(grid);
                }
            }, this, {single:true});
            
            /*me.on('sortchange', function(ct, column, direction, eOpts) {
            	console.log('sortchange:', eOpts);
            	UniGridMultiSorter.clearSortingToolbar(me, column, direction);
            });// sortchange
*/            
        	console.log("useGroupSummary ");        	
        }; // useGroupSummary
        
        
        /************************************
         * for Grid Stateful 
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useState) {
        	var configBtn = {	
				text: 'Grid',
				iconCls: 'menu-menuShow',
				menu: {xtype: 'menu',
						items:[{
	                            text: 'Grid 설정 추가', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
	                            	// 작업중!!!
	                            	var param = {
	                            		PGM_ID: 	UniAppManager.id,
	                            		SHT_ID: 	me.id,
	                            		SHT_INFO: 	UniAppManager.getDbShtInfo(me.id),
	                            		SHT_SEQ:	0,
	                            		MODE:		'save'
	                            	};
	                            	var callback = Ext.emptyFn;
	                            	Unilite.popupGridConfig(param, callback, me);				          
						        }
	                        },{
	                            text: 'Grid 설정 수정', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
	                            	// 작업중!!!
	                            	var param = {
	                            		PGM_ID: 	UniAppManager.id,
	                            		SHT_ID: 	me.id,
	                            		SHT_INFO: 	'',
	                            		SHT_SEQ:	0,
	                            		MODE:		'config'
	                            	};
	                            	var callback = me.applyGridState;
	                            	Unilite.popupGridConfig(param, callback, me);					          
						        }
	                        }
	                  ]}
			};
			tbar[0].add(configBtn);
        }
        
        //그리드 설정 빠른 목록 
        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useStateList) {
        	this.stateList = Ext.create('Unilite.com.form.field.UniComboBox', {
        		comboType: 'BSA421',
        		comboCode: UniAppManager.id + "__" + me.id,
        		tpl : Ext.create('Ext.XTemplate',
			        '<tpl for=".">',
			            '<div class="x-boundlist-item"><div class="uni_combo_text">{text}</div></div>',	
			        '</tpl>'
			    ),			    
			    listeners: {
			    	'change': function(cb, newValue, oldValue, eOpts) {
			    			if(!Ext.isEmpty(newValue)) {
					    		var param = {
		                    		PGM_ID: 	UniAppManager.id,
		                    		SHT_ID: 	me.id,
		                    		SHT_SEQ:	newValue
		                    	};
		                    	me.setLoading(true);
					    		extJsStateProviderService.selectStateInfo(param, 
					    			function(provider, response) {					    				
					    				UniAppManager.applyGridState(response.result);
					    				me.setLoading(false);
					    			}
					    		);
				    		}
			    	}
			    },
			    onStoreLoad: function(combo, store, records, successful, eOpts) {
			    	//초기 기본설정값 불러와서 설정
			    	var stateInfo = UniAppManager.getStateInfo(me.id);
		        	if(Ext.isDefined(stateInfo)) {
		        		if(!Ext.isEmpty(stateInfo)) {
		        			me.fireEvent('statelistselect', me, stateInfo);	
		        		}
		        	}			    	
			    }
        	});	
        	tbar[0].add(this.stateList);
        }
        

        me.on('afterrender', me._onAfterRender);

		me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
		//me.on('itemcontextmenu', function( grid, record, item, index, event, eOpts ) {			
			
			
			if(!Ext.isEmpty(me.contextMenu.child())) {
				if(me.copiedRow != null ) {
					var tMenu = me.contextMenu.down('#pasteRecord');
					tMenu.enable();
				}
				me.clickedRecord = record;
				me.clickedRowIndex = rowIndex;
				//var position = view.getPositionByEvent(event);
				me.select(rowIndex);
			
				event.stopEvent();
				me.contextMenu.showAt(event.getXY());
			}
		});
		
		me.on('beforeselect', function(model, record, index, eOpts ) {
			if(!Ext.isEmpty(me.uniOpt._selectionRecord.newRecordId))	{
				me.uniOpt._selectionRecord.oldRecordId = me.uniOpt._selectionRecord.newRecordId;
			}
			if(!Ext.isEmpty(record.id))	{
          		me.uniOpt._selectionRecord.newRecordId = record.id;
			}
		});
		
	},	// initComponent
	
	_onAfterRender: function(grid) {
		var me = grid;
		var view = me.getView();
		var map = new Ext.KeyMap(view.getEl(), [
		{
			key: Ext.EventObject.ENTER,
			fn: function(keyCode, e){ 
				var selModel;
				if(me._getStoreEditable()) {
					selModel = me.getSelectionModel();			
					var pos = selModel.getCurrentPosition(),
				            editingPlugin;
		            if (pos) {		            			            	
				        if (selModel.isCellModel) {
				        	editingPlugin = pos.view.editingPlugin;				            
				            if (editingPlugin && editingPlugin.editing) {
				                e.stopEvent();	//editing cell 이면 event stop (Ext.overide.grid.plugin.CellEditing 에서 처리)
				            } else {
				                selModel.move(e.shiftKey ? 'left' : 'right', e);
				            }
				            
				            //마지막 row의 last column 인 경우 새로운 행 추가
				            var isLastColumn;
				            if(me.lockedGrid) {
				            	isLastColumn = (pos.column === me.normalGrid.headerCt.getGridColumns().length-1);			            
				            }else {
				            	isLastColumn = (pos.column === me.getColumns().length-1);
				            }
				           	if(pos.row === me.getStore().getCount()-1 && isLastColumn) {
				           		UniAppManager.app.onNewDataButtonDown();
				           	}
				        } else {
				        	if(pos.row === me.getStore().getCount()-1) {
				           		UniAppManager.app.onNewDataButtonDown();
				           	}
				        }
		            }
				}else{
					me.fireEvent('onGridKeyDown', me, keyCode, e);	//팝업 그리드용 (각 onGridKeyDown 에서 기능 정의)
				}
			}
		}/*,{
		   	key: "c",
		   	ctrl:true,
		   	fn: function(keyCode, e) {		
		    	var recs = view.getSelectionModel().getSelection();
		
		      	if (recs && recs.length != 0) {		
		        	var clipText = me.getCsvDataFromRecs(recs);		
		           	var ta = document.createElement('textarea');
		
		           	ta.id = 'cliparea';
		           	ta.style.position = 'absolute';
		           	ta.style.left = '-1000px';
		           	ta.style.top = '-1000px';
		           	ta.value = clipText;
		           	document.body.appendChild(ta);
		           	document.designMode = 'off';
		
		           	ta.focus();
		           	ta.select();
		
		           	setTimeout(function(){		
		            	document.body.removeChild(ta);		
		           	}, 100);
		     	}
		 	}
		},{
			key: "v",
			ctrl:true,
			fn: function() {			
			    var ta = document.createElement('textarea');
			    ta.id = 'cliparea';
			
			    ta.style.position = 'absolute';
			    ta.style.left = '-1000px';
			    ta.style.top = '-1000px';
			    ta.value = '';
			
			    document.body.appendChild(ta);
			    document.designMode = 'off';
			
			    setTimeout(function(){			
			    	//Ext.getCmp('grid-pnl').getRecsFromCsv(grid, ta);
			     	me.getRecsFromCsv(view, ta);			
			     }, 100);
			
			    ta.focus();
			    ta.select();
			}
		}*/		 
		]);		
	},

	//State 목록을 갱신한다.
	_onStateListChange: function(grid, selectedValue) {
		var me = this;
    	
    	if(Ext.isDefined(me.stateList)) {
    		var combo = me.stateList;
    		var store = combo.getStore();
    		
    		if(Ext.isEmpty(selectedValue)) {
    			store.reload()
    		}else{
    			store.load({
				    scope: combo,
				    callback: function(records, operation, success) {				       
						combo.setValueOnly(selectedValue);
				    }    		
	    		});
    		}
    	}
	},	
	//State 목록의 선택값을 변경한다. (목록의 onchange 등 이벤트 발동 없이)
	_onStateListSelect: function(grid, stateInfo) {
		var me = this;
		if(me.stateList && stateInfo) {
			var combo = me.stateList;
			combo.setValueOnly(stateInfo.SHT_SEQ.toString());
		}
	},
	//db의 State 를 적용하고 State 목록의 선택값을 변경한다.
	applyGridState: function(stateInfo) {
    	
    	UniAppManager.applyGridState(stateInfo); 
    	
    	this.fireEvent('statelistselect', this, stateInfo);
    },
    
	// 행이동시 
	_onSelectionchange:function( grid, selected, eOpts ) {
        if(this.store.uniOpt) {
	        
	        if(this.store.uniOpt.isMaster) {
                var btnState = this.store.uniOpt.state || {};
				if(selected.length > 0 && this._getStoreDeletable()) {
			    	UniAppManager.setToolbarButtons('delete', true);
			    	Ext.apply(btnState, {btnDelete: true});
				} else {
					
			    	UniAppManager.setToolbarButtons('delete', false);
			    	Ext.apply(btnState,{btnDelete:false});
				}
			    this.store.uniOpt.state = btnState;
            }
        }
        if(selected.length > 0)	{
        	//console.log("oldRecordId:", this.uniOpt._selectionRecord.oldRecordId, ", newRecordId:", this.uniOpt._selectionRecord.newRecordId)
	        if(this.uniOpt._selectionRecord.oldRecordId != this.uniOpt._selectionRecord.newRecordId)	{
	        	this.fireEvent('selectionchangerecord',selected[0]);
	        }
        }
	},
	
	/**
	 * 선택된 row들을 삭제 한다.
	 */
	deleteSelectedRow:function() {
		var sm = this.getSelectionModel();
		var store = this.getStore();
		var selected = sm.getSelection();
		//var idx = selected[0].index;
		var idx  = this.getSelectedRowIndex();
		store.remove(sm.getSelection());
		if (idx > 0) {
			sm.select(idx-1);
		} else if(store.getCount() > 0) {
			sm.select(idx);
		}else {
			
			sm.deselectAll();
		}
		if(this.uniOpt.childForms) {
			for(var i =0, len = this.uniOpt.childForms.length ; i < len; i ++) {
				this.uniOpt.childForms[i].reset();
			}
		}
	},
	/**
	 * 커서를 이전row로 
	 */
	selectPriorRow:function() {
//		var selModel = this.getSelectionModel();
		//var selected = selModel.getSelection()[0];
		var rowIndex = this.getSelectedRowIndex();
		rowIndex = (rowIndex < 0) ? 0 : rowIndex;
		if(rowIndex > 0)	{
            this.select(rowIndex-1);
            return true;
//			this.getSelectionModel().select(rowIndex-1);
//            selModel.selectByPosition({row:currentPosition.row-1, column:currentPosition.column});
		}else {
			//alert(this.uniText.commons.isFirst);
			alert(Msg.sMB114);			
            return false;
		}
	},
	/**
	 * 커서를 다음row로 
	 */
	selectNextRow:function() {
//		var selModel = this.getSelectionModel();
		//var selected = selModel.getSelection()[0];
		var rowIndex = this.getSelectedRowIndex();
		rowIndex = (rowIndex < 0) ? 0 : rowIndex;
		var totalCount = this.getStore().getTotalCount()
       
		if(rowIndex < (totalCount-1))	{
            this.select(rowIndex+1);
            return true;
			//this.getSelectionModel().select(rowIndex+1);
            //selModel.selectByPosition({row:currentPosition.row+1, column:currentPosition.column});
            //this.moveTo(rowIndex+1,1);
		}else {
			//alert(this.uniText.commons.isLast);
			alert(Msg.sMB115);
            return false;
		}
	},
	
	selectFirstRow:function() {
		this.select(0);
	},
	/**
	 * 해당 row 선택 
	 * @param {} rowIndex
	 */
	select: function(rowIndex) {
		var selModel = this.getSelectionModel();
       
        
        if(selModel.isCellModel) {
            var currentPosition = selModel.getCurrentPosition();
            var newColumn = 0; 
            var newRow = 0;
            if(currentPosition) {
                newColumn = currentPosition.column;
            }
            // rownumberer가 있으면 보이지 않음
            var rownumberer = this.down('rownumberer');
            if(rownumberer && newColumn === 0 ) {
                newColumn = this._getFirstVisibleColumnIndex();
            }
            selModel.deselect(); 
            selModel.selectByPosition({row: rowIndex, column:newColumn});
        } else {
            selModel.deselectAll(); 
		    selModel.select(rowIndex);
        }
	},
    
    /**
     * 그리드에 보이는 첫번째 Column 가져오기
     * @return {}
     */
    _getFirstVisibleColumnIndex: function() {
        var cm = this.getView().getGridColumns();
        var columIndex = 0;
        var colCount = cm.length;
        for (var i = 0; i < colCount; i++) {
            if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != '') && (!cm[i].hidden)) {
                columIndex = i+1;
                break;
            }
        }
        return columIndex;
    },
	
	/**
	 * 선택된 record들을 돌려 준다.
	 * @return {}
	 */
	getSelectedRecords: function() {
		return this.getSelectionModel().getSelection();
	},
	/**
	 * 선택된 row중에서 첫번째 레코드를 돌려준다.
	 * @return {}
	 */
	getSelectedRecord:function() {
		var selectedRecords = this.getSelectedRecords();
		if(selectedRecords && selectedRecords.length > 0 ) {
			return selectedRecords[0];
		}		
	}, 
		
	/**
	 * 선택된 records중에 첫번째 record의  row index 값을 돌려 준다. 
	 * ( 기존 selected.index 를 대체함 !!!, 추가된 record는 index값이 없다)
	 * @param {} def
	 * @return {}
	 */
	getSelectedRowIndex: function(def) {
		
		var selModel = this.getSelectionModel();
		var selectedRecord = selModel.getSelection()[0];
		if(selectedRecord) {
			return this.store.indexOf(selectedRecord);
		} else {
			console.log("def:", def);
			if(Ext.isDefined(def)) {
				return def;
			} else { 
				return -1;
			}
		}
	},


	/**
	 * 그리드 데이타 초기화 (Store 포함)
	 */
	reset:function() {
//		this.store.loadRecords({}, {addRecords: false});
//		this.store.clearData(); 
		this.getStore().removeAll();
		this.view.refresh();
	},
	
	/**
	 * 현재 선택된 행에서 수정모드로 진입.
	 * @param {} columnName
	 */
	startEdit: function(columnName, val) {
		var me = this;
		this.mixins.gutil.startEdit(me, columnName, val);		
	},	
	
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function( values, startEditColumnName, rowIndex) {
		return this.mixins.gutil.createRow(this, values, startEditColumnName, rowIndex);
/*		var me = this;
		//현재행 다음줄 부터
		var rowIndex = me.getSelectedRowIndex();
		console.log("rowIndex = " ,rowIndex );
		rowIndex = (rowIndex < 0)? 0 : rowIndex +1;
		var newRecord =  Ext.create (me.store.model, values);
		console.log("newRowIndex 1= " ,rowIndex );
		newRecord = me.store.insert(rowIndex, newRecord);	
		console.log("newRowIndex 2= " ,rowIndex );
		me.select(rowIndex);
		//me.startEdit(startEditColumnName);
		console.log("newRowIndex 3= " ,rowIndex );
		return newRecord; */
	},
	/**
	 * 
	 * @param {} form
	 */
	addChildForm:function(form) {
		this.uniOpt.childForms.push(form)
	}, 
	// private
	_onRenderFun: function(grid) {
		if(grid.uniOpt.onLoadSelectFirst) {
			grid.store.on('load', function(store, records, options) {
				if(store.count() > 0 ) {
		         	grid.getSelectionModel().select(0);
				}
		     });
		}
	},	
	// private
	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
        	var colName = ct.dataIndex;
        	//console.log('grid cell double click, record index : ',  record,"////", record.getId() + "=" + cellIndex + "/" + colName + "/" + record.get(colName) );
// function 에서 event로 처리 
        	//        	if(Ext.isDefined( this.onGridDblClick )) {
//        		this.onGridDblClick(grid, record, cellIndex, colName);
//        	}
        	this.fireEvent('onGridDblClick',grid, record, cellIndex, colName);
    },
	// private
	//_onColumnResizeFun:function(container, column, width, eOpts ) {
    //	console.log("Column : " , column.dataIndex ,  " resize to ", width);
	//},
    
	_getStoreDeletable : function() {
		var storeDeletable = false;
		if(this.store.uniOpt) {
			if( this.store.uniOpt.deletable ) {
				storeDeletable = true;
			}
		}
		return storeDeletable;
	},
	_getStoreEditable : function() {
		var storeEditable= false;
		if(this.store.uniOpt) {
			if( this.store.uniOpt.editable ) {
				storeEditable = true;
			}
		}
		return storeEditable;
	},
	/**
	 * 오류가 있는(invalid) 레코드의 첫번째 레코드의 첫번째 오류 Column으로 이동 및 선택 
	 * @param {} invalidRecords
	 */
	uniSelectInvalidColumnAndAlert:function(invalidRecords) {
		var invalidRec = Ext.isArray(invalidRecords) ? invalidRecords[0] : invalidRecords;
		
		var me = this;
		var rowIndex = me.store.indexOf(invalidRec);
		var fields = me.store.model.getFields();
		var columnIndex =  -1;
		var errors = invalidRec.validate();
		var column ;
		if(errors.items) {
			column = errors.items[0].field;
		} else {
			console.log('찾아갈 오류내용(column) 없음');
		}
		columnIndex =  me.getColumnIndex(column)-1;
		//me.moveTo(rowIndex, columnIndex);

		
		var msg = '';
		errors.items.forEach(function(entry) {
			var field = me._getField(fields, entry.field);
			msg = msg + field.text + ': ' + entry.message + '\n';
		});		
		//alert(msg + Msg.sMB083);
		msg = (rowIndex+1) + '행의 입력값을 확인해 주세요.\n' + msg ;
		//UniAppManager.updateStatus(msg);
		alert(msg);
	},
	/**
	 * grid에서 header에 정의된 모든 컬럼 정보
	 * @return {}
	 */
	getColumns: function() {
		return this.headerCt.getGridColumns();
	},
	/**
	 * grid에서 header에 정의된 visible 컬럼 정보
	 * @return {}
	 */
	getViewColumns: function() {
		return this.getView().getGridColumns();
	},
	/**
	 * grid에서 columnName(indexName)에 해당 하는 column을 돌려 줌.
	 * @param {} columnName
	 * @return {}
	 */
	getColumn: function(columnName) {
		var me = this, column  = null;
		var columns  = this.getColumns();
		/*for(var i = 0, len =  me.columns.length; i < len; i ++) {
			if ( me.columns[i].dataIndex == columnName ) {
				column = me.columns[i];
				break;
			}
		}
		*/
		for(var i = 0, len =  columns.length; i < len; i ++) {
			if ( columns[i].dataIndex == columnName ) {
				column = columns[i];
				break;
			}
		}
		return column;
	},	
	/**
	 * 
	 * @param {} dataIndex
	 * @return {}
	 * @private
	 */
	getColumnIndex: function(dataIndex) {
		var gridColumns = this.getColumns();
		for (var i = 0; i < gridColumns.length; i++) {
			if (gridColumns[i].dataIndex == dataIndex) {
				return i;
			}
		}
	},
	/**
	 * setCurrentPosition의 경우 bufferredremderer 사용시 오류가 있음
	 * 해당문제 해결한 이동 기능 .
	 * @param {} nRow
	 * @param {} nCol
	 */
	/*moveTo: function(nRow, nCol) {
		var view = this.view;
		var bufferedrenderer = undefined;
		if(view.locked) {
			bufferedrenderer = view.lockedView.bufferedRenderer;
		} else {
			 bufferedrenderer = this.findPlugin('bufferedrenderer');
		}
		
		if(bufferedrenderer) {
			bufferedrenderer.scrollTo(nRow);
		} else {
			var selModel = this.getSelectionModel();
			selModel.setCurrentPosition( {row: nRow, column: nCol} );
        }

	},*/
	getModelField: function(fieldName) {
 
        var fields = this.store.model.getFields();
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].name === fieldName) {
                return fields[i];
            }
        }
    },
    getCsvDataFromRecs: function(records) {
    	var me = this,
			store = me.getStore(),
			clipText = '';
		
	   	//var currRow = store.find('id',records[0].data.id);
		var currRow = records[0].position.row;
	  	for (var i=0; i<records.length; i++) {
	
	    	//var index = store.find('id',records[i].data.id);
			var rowIndex = records[i].position.row;	
	     	var r = rowIndex;
	
	     	var record = records[i].position.record;
	     	//var cv = me.initialConfig.columns;
	     	var cv = me.columns;
	
	     	//for(var j=0; j < cv.length;j++) {
	
	        	//var val = rec.data[cv[j].dataIndex];
	     		var val = record.data[records[i].position.dataIndex];
	
	        	if (r === currRow) {
	
	             	clipText = clipText.concat(val,"\t");
	
	        	} else {
	
	             	currRow = r;
	
	            	clipText = clipText.concat("\n", val, "\t");
	
	        	}
	    	
	  	}
	
		return clipText;
	},
	getRecsFromCsv: function(view, ta) {

	  	document.body.removeChild(ta);
	  	var del = '';
	  	var store = view.getStore();
	
	  	if (ta.value.indexOf("\r\n")) {	
	      	del = "\r\n";
	  	} else if (ta.value.indexOf("\n")) {	
	      	del = "\n"
	  	}
	  	var rows = ta.value.split("\n");
	
	  	for (var i=0; i<rows.length; i++) {
	
	     	var cols = rows[i].split("\t");	
	     	var columns = view.initialConfig.columns;
	
	        if (cols.length > columns.length)	
	         	cols = cols.slice(0, columns.length-1)
	
	        if (gRow === -1 ) {	
	        	Ext.Msg.alert('Select a cell before pasting and try again!');	
	           	return;	
	        }
	
	        var cfg = {};
	
	        var tmpRec = store.getAt(gRow);
	
	        var existing = false;
	
	        if ( tmpRec ) {
	
	        	cfg = tmpRec.data;
	
	            existing = true;
	
	        }
	
	        var l = cols.length;
	
	        if ( cols.length > columns.length )	
	              l = columns.length;
	
	        for (var j=0; j<l; j++) {
	        	if (cols[j] === "") {	
	            	return;	
	           }
	
	        	cfg[columns[j].dataIndex] = cols[j];
	        }
	
	      	me.storeInitialCount++;
	
	      	cfg['id'] = me.storeInitialCount;
	
	      	var tmpRow = gRow;
	
	      	view.getSelectionModel().clearSelections(true);
	
	      	var tmpRec = Ext.create('Country',cfg);
	
	      	if (existing)	
	         	store.removeAt(tmpRow);
	
	      	store.insert(tmpRow, tmpRec);
	
	      	gRow = ++tmpRow;
	
	 	}
	   	if (gRow === store.getCount()) {
	
	    	var RowRec = Ext.create('Country',{});
	    	store.add(RowRec);
	   	}
	   	gRow = 0;
	},
    // 상단 toolbar를 돌려준다.
    _getToolBar: function() {
        var me = this;
        return me.getDockedItems('toolbar[dock="top"]');
    },
    // contextmenu를 생성한다.
    _createContextMenu: function(tbar) {
    	var me = this;

    	if(me._getStoreEditable()) {
			
			 	me.contextMenu.add(  
					    Ext.create('Ext.menu.Item', {
					    	itemId: 'copyRecord',
					        text: this.uniText.contextMenu.rowCopy,
					        disabled: false,
					        handler: function(widget, event) {
					          	if( me.clickedRecord != null ) {
					          		me.copiedRow = me.clickedRecord;
					          	}
					        }
					    })	
				);
				
				me.contextMenu.add(  
					    Ext.create('Ext.menu.Item', {
					        text: this.uniText.contextMenu.rowPaste,
					    	itemId: 'pasteRecord',
					        disabled: true,
					        handler: function(widget, event) {
					          	if(me.clickedRowIndex != null) {
					          		var record = me.copiedRow.copy().data;
						          	if(!me.hasListeners.beforepasterecord || me.fireEvent('beforePasteRecord',  me.clickedRowIndex, record) !== false) {
						        		me.createRow(record, 0, me.clickedRowIndex);
						        		me.fireEvent('afterPasteRecord',  me.clickedRowIndex, record)
					          		}
					          	}
					        }
					    })	
				);
		}
    	
		// 업무버튼을 contextmenu 로 변환하여 생성한다.
		if(me.uniOpt.useContextMenu) {			
//			if(!Ext.isEmpty(me.contextMenu.child())) {
//				me.contextMenu.add(Ext.create('Ext.menu.Separator', {}));
//			}
	    	tbar.items.items.forEach(function(btn){
	    		var menuItem = null;
	    		if(btn.getXType()=='tbfill' || btn.getXType()=='tbseparator' || btn.getXType()=='tbspacer') {
	    			menuItem = Ext.create('Ext.menu.Separator', {});
	    		}else{
	    			if(btn instanceof Ext.button.Button) {
		    			menuItem = Ext.create('Ext.menu.Item', {
		    			
		    			});
		    			menuItem.setText(btn.getText());
		    			menuItem.setIconCls(btn.iconCls);
		    			if(btn.menu){
		    				menuItem.setMenu(btn.menu.cloneConfig());
		    			}
	    			}
	    		}
	    		if(!Ext.isEmpty(menuItem))
	    			me.contextMenu.add(menuItem);    		
			});
		}
    }
    	
});
 //@charset UTF-8 
//    http://druckit.wordpress.com/2013/10/26/generate-an-excel-file-from-an-ext-js-4-grid/
// https://fiddle.sencha.com/#fiddle/17j

/*
 
    Excel.js - convert an Ext 4 grid into an Excel spreadsheet using nothing but
    javascript and good intentions.
 
    By: Steve Drucker
    October 26, 2013
    Original Ext 3 Implementation by: Nige "Animal" White?
    
    Updated: March 19, 2014 to support grouped grids/stores
    Updated: April 3, 2014 to support Internet Explorer
     
    Contact Info:
 
    e. sdrucker@figleaf.com
    blog: druckit.wordpress.com
    linkedin: www.linkedin.com/in/uberfig
    git: http://github.com/sdruckerfig
    company: Fig Leaf Software (http://www.figleaf.com / http://training.figleaf.com)
 
    Invocation:  grid.downloadExcelXml(includeHiddenColumns,title)
 
*/
 
 
var Base64 = (function() {
    // Private property
    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
 
    // Private method for UTF-8 encoding
 
    function utf8Encode(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;
    }
 
    // Public method for encoding
    return {
        encode: (typeof btoa == 'function') ? function(input) {
            return btoa(utf8Encode(input));
        } : function(input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;
            input = utf8Encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }
                output = output +
                    keyStr.charAt(enc1) + keyStr.charAt(enc2) +
                    keyStr.charAt(enc3) + keyStr.charAt(enc4);
            }
            return output;
        }
    };
})();
 
Ext.define('MyApp.view.override.Grid', {
    override: 'Ext.grid.GridPanel',
 
 
    /*
        Kick off process
    */
    downloadExcelXml: function(includeHidden, title) {
  		if(this.getStore().getCount() < 1 ) return;
    	
        if (!title) title = this.title;
 
        if (Ext.isEmpty(title)) {
        	title = this.id ? this.id : 'Export';
        }
        var vExportContent = this.getExcelXml(includeHidden, title);
 
        var location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
 
        /* 
          dynamically create and anchor tag to force download with suggested filename 
          note: download attribute is Google Chrome specific
        */
 
        var fileName = title + "-" + Ext.Date.format(new Date(), 'Y-m-d Hi') + '.xls';
        
        if (true && (Ext.isChrome || Ext.isGecko || Ext.isSafari)) { // local download
            var gridEl = this.getEl();
 
            var el = Ext.DomHelper.append(gridEl, {
                tag: "a",
                download: fileName,
                href: location
            });
 
            el.click();
 
            Ext.fly(el).destroy();
 
        } else { // remote download
 
            var form = this.down('form#uploadForm');
            if (form) {
                form.destroy();
            }
            form = this.add({
                xtype: 'form',
                itemId: 'uploadForm',
                hidden: true,
                standardSubmit: true,
                url: CPATH+'/download/echoExcel.do',
                items: [{
                    xtype: 'hiddenfield',
                    name: 'data',
                    value: vExportContent
                },{
                    xtype: 'hiddenfield',
                    name: 'fileName',
                    value: fileName
                }]
            });
 
            form.getForm().submit();
        }
    },
 
 
    /*
     
        Welcome to XML Hell
        See: http://msdn.microsoft.com/en-us/library/office/aa140066(v=office.10).aspx
        for more details
 
    */
    getExcelXml: function(includeHidden, title) {

        var theTitle = title || this.title;
        
        var worksheet = this.createWorksheet(includeHidden, theTitle);        
        var totalWidth = this.columns.length;
		//<?xml version="1.0" encoding="utf-8" ?>
        return ''.concat(
            '<?xml version="1.0" encoding="utf-8"?>',
            //'<?mso-application progid="Excel.Sheet"?>',
            '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">',
            '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Title>' + theTitle + '</Title></DocumentProperties>',
            '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office"><AllowPNG/></OfficeDocumentSettings>',
            '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">',
            '<WindowHeight>' + worksheet.height + '</WindowHeight>',
            '<WindowWidth>' + worksheet.width + '</WindowWidth>',
            '<ProtectStructure>False</ProtectStructure>',
            '<ProtectWindows>False</ProtectWindows>',
            '</ExcelWorkbook>',

            '<Styles>',

            '<Style ss:ID="Default" ss:Name="Normal">',
            '<Alignment ss:Vertical="Bottom"/>',
            '<Borders/>',
            '<Font ss:FontName="맑은 고딕" x:Family="Modern" ss:Size="11" ss:Color="#000000"/>',
            '<Interior/>',
            '<NumberFormat/>',
            '<Protection/>',
            '</Style>',
            
			  '<Style ss:ID="uniPercent" ss:Name="백분율">',
			  '<NumberFormat ss:Format="0%"/>',
			  '</Style>',
              
			  '<Style ss:ID="s17" ss:Name="쉼표 [0]">',
			  '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;_-;_-@_-"/>',
			  '</Style>',
              
            '<Style ss:ID="title">',
            '<Borders />',
            '<Font ss:Bold="1" ss:Size="18" />',
            '<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1" />',
            '<NumberFormat ss:Format="@" />',
            '</Style>',

            '<Style ss:ID="headercell">',
            '<Font ss:Bold="1" ss:Size="11" />',
            '<Alignment ss:Horizontal="Center" ss:WrapText="1" />',
            '<Interior ss:Color="#A3C9F1" ss:Pattern="Solid" />',
            '</Style>',


            '<Style ss:ID="even">',
            '<Interior/>',
            '</Style>',


            '<Style ss:ID="uniDate" ss:Parent="even">',
            '<NumberFormat ss:Format="yyyy-mm-dd" />',
            '</Style>',


            '<Style ss:ID="uniInt" ss:Parent="s17">',
            '<Numberformat ss:Format="0" />',
            '</Style>',

            '<Style ss:ID="uniFloat" ss:Parent="s17">',
            '<Numberformat ss:Format="0.00" />',
            '</Style>',

            '<Style ss:ID="groupSeparator">',
            '<Interior ss:Color="#D3D3D3" ss:Pattern="Solid" />',
            '</Style>',

            '</Styles>',
            worksheet.xml,
            '</Workbook>'
        );
    },
 
    /*
     
        Support function to return field info from store based on fieldname
     
    */
 
    getModelField: function(fieldName) {
 
        var fields = this.store.model.getFields();
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].name === fieldName) {
                return fields[i];
            }
        }
    },
 
    /*
         
        Convert store into Excel Worksheet
 
    */

     generateEmptyGroupRow: function(dataIndex, value, cellTypes, includeHidden) {

        
        //var cm =  this.getView().getGridColumns();
     	var cm =  this.getColumns();
        var colCount = this.columns.length;
        var rowTpl = '<Row ss:AutoFitHeight="0"><Cell ss:StyleID="groupSeparator" ss:MergeAcross="{0}"><Data ss:Type="String"><html:b>{1}</html:b></Data></Cell></Row>';
        var visibleCols = 0;
        
        // rowXml += '<Cell ss:StyleID="groupSeparator">'
        
        for (var j = 0; j < colCount; j++) {
            if (cm[j].xtype != 'actioncolumn' && (cm[j].dataIndex != '') && (includeHidden || !cm[j].hidden)) {
                // rowXml += '<Cell ss:StyleID="groupSeparator"/>';
                visibleCols++;
            }
        }
        
        // rowXml += "</Row>";
        
        return Ext.String.format(rowTpl,visibleCols - 1,value);
    }, 
    
    createWorksheet: function(includeHidden, theTitle) {
        // Calculate cell data types and extra class names which affect formatting
        var cellType = [];
        var cellTypeClass = [];
//        var cm = this.columns;
        var cm = this.getView().getGridColumns();
        
        var totalWidthInPixels = 0;
        var colXml = '';
        var headerXml = '';
        var visibleColumnCountReduction = 0;
        var colCount = cm.length;
        for (var i = 0; i < colCount; i++) {
            if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != '') && (includeHidden || !cm[i].hidden)) {
                var w = cm[i].getEl().getWidth();
                totalWidthInPixels += w;

                if (cm[i].text === "") {
                    cellType.push("None");
                    cellTypeClass.push("");
                    ++visibleColumnCountReduction;
                } else {
                    colXml += '<Column ss:AutoFitWidth="1" ss:Width="' + w + '" />';
                    headerXml += '<Cell ss:StyleID="headercell">' +
                        '<Data ss:Type="String">' + cm[i].text + '</Data>' +
                        '<NamedCell ss:Name="Print_Titles"></NamedCell></Cell>';


                    var fld = this.getModelField(cm[i].dataIndex);
                    if(fld) {
	                    switch (fld.type.type) {
	                        case "int":
	                            cellType.push("Number");
	                            cellTypeClass.push("uniInt");
	                            break;
                            case "uniPrice":
	                        case "float":
	                            cellType.push("Number");
	                            cellTypeClass.push("uniFloat");
	                            break;
                            case "uniPercent":
                                cellType.push("Number");
                                cellTypeClass.push("uniPercent");
                                break;
                            case "float":
                                cellType.push("Number");
                                cellTypeClass.push("uniFloat");
                                break;
	
	                        case "bool":
	
	                        case "boolean":
	                            cellType.push("String");
	                            cellTypeClass.push("");
	                            break;
                            case "uniDate":
	                        case "date":
	                            cellType.push("DateTime");
	                            cellTypeClass.push("uniDate");
	                            break;
	                        default:
	                            cellType.push("String");
	                            cellTypeClass.push("");
	                            break;
	                    }
                    } else {
                    	cellType.push("String");
                        cellTypeClass.push("");
                    }
                }
            }
        }
        var visibleColumnCount = cellType.length - visibleColumnCountReduction;

        var result = {
            height: 9000,
            width: Math.floor(totalWidthInPixels * 30) + 50
        };

        // Generate worksheet header details.

        // determine number of rows
        var numGridRows = this.store.getCount() + 2;
        if (!Ext.isEmpty(this.store.groupField)) {
            numGridRows = numGridRows + this.store.getGroups().length;
        }

        // create header for worksheet
        var t = ''.concat(
            '<Worksheet ss:Name="' + theTitle + '">',

            '<Names>',
            '<NamedRange ss:Name="Print_Titles" ss:RefersTo="=\'' + theTitle + '\'!R1:R2">',
            '</NamedRange></Names>',

            '<Table ss:ExpandedColumnCount="' + (visibleColumnCount + 2),
            '" ss:ExpandedRowCount="' + numGridRows + '" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">',
            colXml,
            '<Row ss:Height="38">',
            '<Cell ss:MergeAcross="' + (visibleColumnCount - 1) + '" ss:StyleID="title">',
            '<Data ss:Type="String" xmlns:html="http://www.w3.org/TR/REC-html40">',
            '<html:b>' + theTitle + '</html:b></Data><NamedCell ss:Name="Print_Titles">',
            '</NamedCell></Cell>',
            '</Row>',
            '<Row ss:AutoFitHeight="1">',
            headerXml +
            '</Row>'
        );

        // Generate the data rows from the data in the Store
        var groupVal = "";
        for (var i = 0, it = this.store.data.items, l = it.length; i < l; i++) {

            if (this.uniOpt.excel.exportGroup && !Ext.isEmpty(this.store.groupField)) {
                if (groupVal != this.store.getAt(i).get(this.store.groupField)) {
                    groupVal = this.store.getAt(i).get(this.store.groupField);
                    t += this.generateEmptyGroupRow(this.store.groupField, groupVal, cellType, includeHidden);
                }
            }
            t += '<Row>';
            //var cellClass = (i & 1) ? 'odd' : 'even';
            r = it[i].data;
            var k = 0;
            for (var j = 0; j < colCount; j++) {
                if (cm[j].xtype != 'actioncolumn' && cm[j].xtype != 'rownumberer' &&  (cm[j].dataIndex != '') && (includeHidden || !cm[j].hidden)) {
                    var v = cm[j].dataIndex ? r[cm[j].dataIndex] : '';
                    if (cellType[k] !== "None") {
                        
                        if(Ext.isEmpty(cellTypeClass[k]) ) {
                            t += '<Cell ><Data ss:Type="' + cellType[k] + '">';
                        } else {
                            t += '<Cell ss:StyleID="' + cellTypeClass[k] + '"><Data ss:Type="' + cellType[k] + '">';
                        }
                        
                        //t += '<Cell ss:StyleID="' + cellClass + cellTypeClass[k] + '"><Data ss:Type="' + cellType[k] + '">';
                        if (cellType[k] == 'DateTime') {
                            t += Ext.Date.format(v, 'Y-m-d');
                        } else if (cellType[k] == 'Number' && cellTypeClass[k] == 'uniPercent') {
                                t += (v / 100);
                           
                        }  else {
                            t += v;
                        }
                        t += '</Data></Cell>';
                    }
                    k++;
                }
            }
            t += '</Row>';
        }

        result.xml = t.concat(
            '</Table>',
            '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">',
            '<PageLayoutZoom>0</PageLayoutZoom>',
            '<Selected/>',
            '<Panes>',
            '<Pane>',
            '<Number>3</Number>',
            '<ActiveRow>2</ActiveRow>',
            '</Pane>',
            '</Panes>',
            '<ProtectObjects>False</ProtectObjects>',
            '<ProtectScenarios>False</ProtectScenarios>',
            '</WorksheetOptions>',
            '</Worksheet>'
        );
        return result;
    }
});//@charset UTF-8
/**
 * 
 */
 Ext.define('Unilite.com.UniImg', {
	extend : "Ext.Img",
	alias : "widget.uniImg",
	onClick : Ext.emptyFn,
	autoRender : true,
	isButton: true,
	initComponent : function() {
		if(this.isButton) {
			this.style = "cursor: pointer;";
		}
		this.callParent()
	},
	listeners: {
        el: {
            click: function() {
                //this.onClick();
            }
        }
    }
});
//@charset UTF-8
/**
 * 
 */
 Ext.define('Unilite.com.menu.UniMenu', {
	extend : 'Ext.menu.Menu',
	alias : 'widget.uniMenu',
	grid : null,
	style: {
            overflow: 'visible'     // For the Combo popup
    }
});
//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */

Ext.define('Unilite.com.BaseApp', {
	extend: 'Unilite.com.UniAbstractApp',
    alias: 'widget.BaseApp',    
	name: 'BaseApp',

	requires: [
		'Ext.Msg',
		'Ext.button.Button',
		'Ext.toolbar.Toolbar',
    	'Unilite.com.UniAppManager'
	],
    text: {
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrint: '인쇄',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnClose: '닫기'
    },
    uniOpt: {
    	showToolbar: true
    },
    layout: 'border' ,    
    listeners: {
    	afterrender: function(viewport, eOpts) {
    		var me = viewport;
    		/** IE10,11 에서 preventDefault 가 제대로 동작하지 않고 있음.
    		 * preventDefault 	: Prevents the browsers default handling of the event
    		 * stopPropagation 	: Cancels bubbling of the event.
    		 * stopEvent	 	: Stop the event (preventDefault and stopPropagation)
    		 */
            me.keyNav = new Ext.util.KeyMap({
                target: me.el,
                binding: [
                {
                    key: Ext.EventObject.F2,
                    fn: function(keyCode, e){
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F2 (조회)
	                        me._clickToolBarButton('query');
	                        e.stopEvent();
                    	}else if(e.shiftKey && !e.ctrlKey && !e.altKey) {	// Shift + F2 (초기화)
                    		me._clickToolBarButton('reset');
                        	e.stopEvent();
                    	}
                    }
                },{
                    key: Ext.EventObject.F9,
                    fn: function(keyCode, e){            
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F9 (저장)
	                        me._clickToolBarButton('save');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.BACKSPACE,
                    fn: function(keyCode, e){                       
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + Backspace (삭제)
	                        me._clickToolBarButton('delete');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.F8,
                    fn: function(keyCode, e){                 
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + F8 (추가)
                    		me._clickToolBarButton('newData');
                    		e.stopEvent();
                    	}
                   	}
                }/*,{
                    key: Ext.EventObject.LEFT,
                    fn: function(keyCode, e){
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + <-
	                        me._clickToolBarButton('prev');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.RIGHT,
                    fn: function(keyCode, e){
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + ->
	                        me._clickToolBarButton('next');
	                        e.stopEvent();
                    	}
                   	}
                }*/],
                scope: this
            }); 
            
            this.focus();
        }				
	},
    constructor : function (config) {
        var me = this;
		
		Ext.apply(this, config || {});
		
        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
    },
    initComponent: function(){    
    	var me  = this;
    	UniAppManager.setApp( me );
    	
    	this._setToolBar();
		this.comPanelToolbar = {
            dockedItems : [this.toolbar], 
            padding:0, 
            border:0,
            region:'north'
        };
		
		var newItems = [];
        var pgmTitle = '';
        if(typeof PGM_TITLE !== 'undefined') {
            pgmTitle = PGM_TITLE + (UserInfo.appOption.showPgmId ? " (" +PGM_ID +")" : "");
        }
        
        var title = {
            xtype: 'container',
            cls: 'uni-pageTitle',
            id: 'UNILITE_PG_TITLE',
            html: pgmTitle,
            padding: '0 0 5px 0',
            height: 32,
            region:'north'
        };
        newItems.push(title);
        if(this.uniOpt.showToolbar) {
    		newItems.push(this.comPanelToolbar);  
        }

        // Border를 쓸결우
        if(me.borderItems) {
            for(i = 0, len = me.borderItems.length; i < len; i ++ ) {
				 var item = me.borderItems[i];
				 newItems.push(item);
			}
            console.log('border items');
        }
        
        // 기존 방식의 경우
        if(me.items && me.items.length > 0) {
	        newItems.push({
	            xtype: 'panel',
	            region: 'center',
	            border: false,
	            padding: '1 1 1 1',
	            layout: { type: 'vbox', pack: 'start', align: 'stretch' },
	            items: me.items
	        });
            console.log('normal items');
        }
    	this.items = newItems;
    	
    	this.callParent();

    	this.fnInitButton();
    	
		//var params = Unilite.getParams();
    	var params;
    	if(parent) {
    		params = parent.UniAppManager.getAppParams();	//openTab 시에 저장된 appParams
    	}else{
    		params = Unilite.getParams();	//url 파싱이라서 object 를 넘기지 못함.
    	}
    	this.fnInitBinding(Ext.isEmpty(params) ? {} : params);
    	
    	if(Ext.isDefined(me.focusField)) {    		
    		me.focusField.focus();
    	}else{
    		var form = me.down('form');
    		if(form) {
    			//form.child(':focusable').focus();
    			var fd = form.down('field:not(hiddenfield)');
    			if(fd)
    				fd.focus();
    		}
    	}
    	    	
		console.log("BaseApp initialized.");
    },
    
    /**
     * 
     *  @abstract
     */
    fnReceiveParam:  Ext.emptyFn,

    /**
     * 
     * @abstract
     */
    fnInitBinding:  Ext.emptyFn,
    
    /**
     * 
     */
    fnInitButton:function(){
    	var me = this;
    	for(i = 0, len = this.buttons.length; i < len; i ++ ) {
    		var element = this.buttons[i];
    		if(element.name != 'query') {
				me._setToolbarButton(element.name, false);
			}
    	}

	},
	/**
	 * [조회] 버튼 처리 함수
	 * 각 화면에서 overide 해야 함.
	 * @abstract
	 */
    onQueryButtonDown: function() {
    	return true;
    }, 
    /**
	 * [저장] 버튼 처리 함수
	 * 각 화면에서 overide 해야 함.
	 * @abstract
	 */
	onSaveAndQueryButtonDown: function() {
		// 저장 후 조회 ( 저장 완료 체크 필요 )
		this.onSaveDataButtonDown(); 
		this.onQueryButtonDown();
	}, 
	/**
	 * 저장 후 조회 ( 저장 완료 체크 필요 )
	 * @abstract
	 */
	onSaveAndResetButtonDown: function() {
		// 저장 후 조회 ( 저장 완료 체크 필요 )
		this.onSaveDataButtonDown(true); 
		this.onResetButtonDown();
	},
    /**
     * 
     * @abstract
     */	
	onResetButtonDown:function() {this.fnInitBinding();},
    /**
     * 데이타 추가
     * @abstract
     */	
	onNewDataButtonDown: Ext.emptyFn,  
    /**
     * 데이타 삭제
     * @abstract
     */	
	onDeleteDataButtonDown: Ext.emptyFn, 
    /**
     * 전체 삭제 
     * @abstract
     */	
	onDeleteAllButtonDown: Ext.emptyFn, 
    /**
     * 저장	
     * @abstract
     */	
	onSaveDataButtonDown: Ext.emptyFn,	/**
     * 저장   
     * @abstract
     */ 
    onSaveDataButtonDown: Ext.emptyFn,  
    /**
     * 엑셀 저장	
     * @abstract
     */	
	onSaveAsExcelButtonDown: Ext.emptyFn,
    /**
     * 인쇄
     * @abstract
     */		
	onPrintButtonDown: Ext.emptyFn, 
    /**
     * 
     * @abstract
     */	
	onPrevDataButtonDown: Ext.emptyFn,
    /**
     * 
     * @abstract
     */	
	onNextDataButtonDown: Ext.emptyFn,
    /**
     * 상세검색
     * @abstract
     */	
	onDetailButtonDown: Ext.emptyFn,	
    /**
     * 인쇄
     * @abstract
     */	
	onPrintButtonDown: Ext.emptyFn,	
    /**
     * 닫기
     * @abstract
     */	
	onCloseButtonDown: function() {
		self.close();
		alert('작업중');
	},
	
	/**
	 * 버튼 상태 변경 
	 * btnNames : 버튼명 또는 버튼명 배열
	 * 
	 * state : true / false
	 *       @example
	 *       예제) 
	 * 	        this.setToolbarButtons('newData',true);
	 *          this.setToolbarButtons(['prev','next'],true);
	 */
	setToolbarButtons: function(btnNames, state) {
		var me = this;
		if(Ext.isArray(btnNames) ) {
			for(i =0, len = btnNames.length; i < len; i ++) {
				var element = btnNames[i];
				me._setToolbarButton(element, state);
			}
		} else {
			me._setToolbarButton(btnNames, state);
		}
	},	
    
	_setToolbarButton : function(btnName, state) {
		//var obj = this.buttons[btnName];
		//console.log("_setToolbarButton ", btnName, state);
			
		var obj =  this.getTopToolbar().getComponent(btnName);
		if(obj) {
			(state) ? obj.enable():obj.disable();
		}
	},
	addButton: function( button ) {
		var toolbar =  this.getTopToolbar();
		if(toolbar) {
			var index = toolbar.items.findIndex('itemId','detail');
			toolbar.insert(index+2, button);
			console.log("t");
		}
	},
	/**
	 * 조회 버튼 클릭시 저장 여부 확인 이 필요 한지 확인
	 * save 버튼이 enable되어 있으면 true
	 * 여러 탭이 있는 경우도 있음.
	 */ 	
	_needSave: function() {
		//var button = this.buttons['save'];
		//return ! button.isDisabled( );
		return ! this.getTopToolbar().getComponent('save').isDisabled( );
	},
	getTopToolbar: function() {
		return this.toolbar;
	},
	// private
	_setToolBar : function() {
		var me = this;
		var btnWidth = 26;
		var btnHeight = 26;	
		
		var btnQuery =  {
                xtype: 'uniBaseButton',
		 		text : me.text.btnQuery,
		 		tooltip : '조회' + ' [F2]',
		 		iconCls : 'icon-query', 
		 		width: btnWidth, height: btnHeight,
		 		itemId : 'query',
				handler: function() { 
					//if(this.autoButtonControl && UniAppManager.hasDirty) {
					if( me._needSave() ) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		me.onSaveAndQueryButtonDown();
						     	} else if(res === 'no') {
						     		me.onQueryButtonDown();
						     	}
						     }
						});
					} else {
						me.onQueryButtonDown();
					}
				}
			};
		var btnReset = {
                xtype: 'uniBaseButton',
				text : me.text.btnReset, 
				tooltip : '초기화' + ' [Shift+F2]',
				iconCls: 'icon-reset',
				width: btnWidth, height: btnHeight,
		 		itemId : 'reset',
				handler : function() { 
					if( me._needSave() ) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		me.onSaveAndResetButtonDown();
						     	} else if(res === 'no') {
						     		me.onResetButtonDown();
						     	}
						     }
						});
					} else {
						me.onResetButtonDown() ;
					}
					
				}
			};
		
		var btnNewData = {
                xtype: 'uniBaseButton',
				text : me.text.btnNewData,
				tooltip : '추가' + ' [Shift+F8]',
				iconCls: 'icon-new',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'newData',
				handler : function() { me.onNewDataButtonDown() }
			};
		var btnDelete = {
                xtype: 'uniBaseButton',
				text : me.text.btnDelete,
				tooltip : '삭제' + ' [Shift+Baskspace]',
				iconCls: 'icon-delete',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'delete',
				handler : function() { me.onDeleteDataButtonDown() }
			};
		var btnSave = {
                xtype: 'uniBaseButton',
				text : me.text.btnSave, 
				tooltip : '저장' + ' [F9]', 
				iconCls: 'icon-save',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'save',
				handler : function() { 
                    //Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
			};
		var btnDeleteAll = {
                xtype: 'uniBaseButton',
				text : me.text.btnDeleteAll, tooltip : '전체삭제', iconCls: 'icon-deleteAll',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'deleteAll',
				handler : function() { me.onDeleteAllButtonDown() }
			};			
		var btnExcel = Ext.create('Unilite.com.button.BaseButton', {
				text : me.text.btnExcel, tooltip : '엑셀 다운로드', iconCls: 'icon-excel',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'excel',
				//handler : function() { me.onSaveAsDataButtonDown() }
				handler : function() { me.onSaveAsExcelButtonDown() }
			});			
		var btnPrev = {
                xtype: 'uniBaseButton',
				text : me.text.btnPrev, 
				tooltip : '이전 레코드', 
				iconCls: 'icon-movePrev',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'prev',
				handler : function() { me.onPrevDataButtonDown() }
			};
		var btnNext = {
                xtype: 'uniBaseButton',
				text : me.text.btnNext, 
				tooltip : '다음 레코드', 
				iconCls: 'icon-moveNext', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'next',
				handler : function() { me.onNextDataButtonDown() }
			};
		var btnDetail = {
                xtype: 'uniBaseButton',
				text : me.text.btnDetail, tooltip : '추가검색', iconCls: 'icon-detail', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'detail',
				handler : function() { me.onDetailButtonDown() }
			};	
		var btnPrint = {
                xtype: 'uniBaseButton',
				text : me.text.btnDetail, tooltip : '인쇄', iconCls: 'icon-print', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'print',
				handler : function() { me.onPrintButtonDown() }
			};				
			
			
		var btnClose = {
                xtype: 'uniBaseButton',
				text : me.text.btnClose, tooltip : '닫기', iconCls: 'icon-close', disabled: false,
				width: btnWidth, height: btnHeight,
		 		itemId : 'close',
				handler : function() {
					
					var tabPanel = parent.Ext.getCmp('contentTabPanel');
					if(tabPanel) {
						var activeTab = tabPanel.getActiveTab();
	//					tabPanel.remove(activeTab);
						var canClose = activeTab.onClose(activeTab);
						if(canClose)  {
							tabPanel.remove(activeTab);
						}
					} else {
						self.close();
					}
				}
			};			
		/*
		this.buttons = {"query":btnQuery,
						"reset":btnReset,
						"newData":btnNewData,
						"delete":btnDelete,
						"save":btnSave,
						"excel":btnExcel,
						"prev":btnPrev,
						"next":btnNext,
						"detail":btnDetail};
		*/
//		var toolbarItems = [ btnQuery,'-', btnReset, 
//						btnNewData, btnDelete,
//						btnSave, btnDeleteAll, btnExcel,
//				// space
//				' ','-',' ',btnPrev, btnNext ,' ','-',' ', btnDetail, '-',
//				btnClose
//				];
        var toolbarItems = [ btnQuery, btnReset, 
                btnNewData, btnDelete,
                btnSave, btnDeleteAll, //btnExcel,
                btnPrint,
                // space
                btnPrev, btnNext , 
                btnClose
                ];
                
		var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER  ;
		if( chk01 ) {
			toolbarItems.push( // space
				'->',				
				{xtype : 'button',
					text : '',
					tooltip : '현재탭 Reload(Cache 사용 안함!)', 
					iconCls: 'icon-reload',
					handler : function() {
						// param : 
						//			false - Default. Reloads the current page from the cache.
						//			true - The current page must be reloaded from the server
						location.reload(true );
					}
				},
				{xtype : 'button',
					text : '',
					tooltip : '현재 Tab을 새창으로 띄우기', 
					iconCls: 'icon-newWindow',
					handler : function() {
						window.open(window.location.href, '_blank');
					}
				}
			);
		} // IS_DEVELOPE_SERVER
			
    	this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
				dock : 'top',
				height: 30, 
				padding: '0 0 0 5',
				items : toolbarItems
		});
	},
	_clickToolBarButton: function(buttonId) {
		var me = this;
		var btn = me.getTopToolbar().getComponent(buttonId);
        if(btn.isVisible() && !btn.isDisabled()) {
        	if(btn.el.dom.click)
        		btn.el.dom.click();
        }
	},
	isDirty: function() {
		var obj =  this.getTopToolbar().getComponent('save');
		var rv = false;
		if(obj) {
			rv =  ! obj.disabled;
		}
		return rv;
	}
	
});


//@charset UTF-8
/**
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */

Ext.define('Unilite.com.BasePopupApp', {
	extend: 'Unilite.com.UniAbstractApp',
    alias: 'widget.BasePopupApp',
    name:'BasePopupApp',
    requires: [
    	'Unilite.com.UniAppManager'
	],
    
    defaults: {padding:'0 0 5 0'},
    initComponent : function(){    
    	var me  = this;
    	UniAppManager.setApp( me );
    	//UniAppManager.on("datachanged", me._datachangedFun);
    	
    	var param = window.dialogArguments;
    	if(Ext.isDefined(param)) {
    		document.title =param['pageTitle'];
    	}
    	
    	this._setToolBar();
		this.comPanelToolbar.dockedItems = [this.toolbar];
		console.log("BaseApp init.");
    	var newItems = [];
    	newItems.push(this.comPanelToolbar);  
 	
    	for(i = 0, len = this.items.length; i < len; i ++ ) {
    		var element = this.items[i];
    		newItems.push(element);
    	}
    	this.items = newItems;    	
    	this.callParent();		
    	var params = Unilite.getParams();
    	this.fnInitBinding(params);
    	this.fnInitBinding();
    },
    // abstract
	beforeClose:Ext.emptyFn,
    // abstract
    fnReceiveParam:  Ext.emptyFn,
    // abstract
    fnInitBinding:  Ext.emptyFn,

    toolBar : {},    
    comPanelToolbar : {
			xtype : 'panel',
			//id : 'comPanelToolbar',
			flex : 0,
			border : 0,
			margin : '0 0 0 0 ',
			dockedItems : [ ]
	},
	
	onQueryButtonDown: Ext.emptyFn,
	onSubmitButtonDown: function()	{
		window.close();
	},

	
	// private
	_setToolBar : function() {
		var me = this;
		var btnQuery = Ext.create('Ext.button.Button', {
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
				handler: function() { 
					if(UniAppManager.hasDirty) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		me.onSaveAndQueryButtonDown();
						     	} else if(res === 'no') {
						     		me.onQueryButtonDown();
						     	}
						     }
						});
					} else {
						me.onQueryButtonDown();
					}
				}
			});
			
		var btnSubmit = Ext.create('Ext.button.Button', {
		 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onSubmitButtonDown();
				}
			});
    	this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
				dock : 'top',
				items : [ '->', btnQuery,
				// space
				' ','-',' ',
				btnSubmit,
				/*{text : '확인',tooltip : '확인',iconCls : 'icon-query',
					handler: function() { 
						window.close();
					}
				},*/
				{text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
					handler: function() { 
						window.close();
					}
				},
				' '
			]
		});
	
	},
	setToolbarButtons: function(btnNames, state) {
		var me = this;
		if(Ext.isArray(btnNames) ) {
			for(i =0, len = btnNames.length; i < len; i ++) {
				var element = btnNames[i];
				me._setToolbarButton(element, state);
			}
		} else {
			me._setToolbarButton(btnNames, state);
		}
	},
	_setToolbarButton : function(btnName, state) {
		var obj = this.buttons[btnName];
		//console.log("_setToolbarButton ", btnName, state);
			
		if(obj) {
			(state) ? obj.enable():obj.disable();
		}
	},
	isDirty: function() {
		var obj =  this.getTopToolbar().getComponent('save');
		var rv = false;
		if(obj) {
			rv =  ! obj.disabled;
		}
		return rv;
	},
    getTopToolbar: function() {
        return this.toolbar;
    }
});


//@charset UTF-8
/**
 * 미정
 */
Ext.define('Unilite.com.data.UniWriter', {
	extend: 'Ext.data.writer.Json',
    alias: 'writer.uniWriter',

    write: function(request) {
        var operation = request.operation,
            records   = operation.records || [],
            len       = records.length,
            i         = 0,
            data      = [];

        for (; i < len; i++) {
        	if(operation.action == 'syncAll') {
        		data.push(records[i]);
        	}else{
            	data.push(this.getRecordData(records[i], operation));
        	}
        }
        return this.writeRecords(request, data);
    },
    
    writeValue: function(data, field, record){
        var name = field[this.nameProperty],
            dateFormat = this.dateFormat || field.dateWriteFormat || field.dateFormat,
            value = record.get(field.name);

        // Allow the nameProperty to yield a numeric value which may be zero.
        // For example, using a field's numeric mapping to write an array for output.
        if (name == null) {
            name = field.name;
        }

        if (field.serialize) {
            data[name] = field.serialize(value, record);
        } else if (field.type === Ext.data.Types.DATE && dateFormat && Ext.isDate(value)) {
            data[name] = Ext.Date.format(value, dateFormat);
        } else if (field.type === Ext.data.Types.UNIDATE && dateFormat && Ext.isDate(value)) {	//UniDate 추가
            data[name] = Ext.Date.format(value, dateFormat);
        } else if (field.type === Ext.data.Types.UNIMONTH && dateFormat && Ext.isDate(value)) {	//UniMonth 추가
            data[name] = Ext.Date.format(value, dateFormat);
        } else {
            data[name] = value;
        }
    }
});
//@charset UTF-8


Ext.override(Ext.data.proxy.Server, {
    // Should this be documented as protected method?
    processResponse: function(success, operation, request, response, callback, scope) {
        var me = this,
            reader,
            result;

        if (success === true) {
            reader = me.getReader();

            // Apply defaults to incoming data only for read operations.
            // For create and update, there will already be a client-side record
            // to match with which will contain any defaulted in values.
            reader.applyDefaults = operation.action === 'read';
            
            // modified by lhj 2014.06.24 -------------------------------------
            //result = reader.read(me.extractResponseData(response));
            var isSyncAll = false
            if(operation.action && operation.action == 'syncAll')   {
                result = me.extractResponseData(response);
                isSyncAll = true;
            } else {
                result = reader.read(me.extractResponseData(response));
            }
            //----------------------------------------------------------------------
            
            if (result.success !== false) {
                //see comment in buildRequest for why we include the response object here
                Ext.apply(operation, {
                    response: response,
                    resultSet: result
                });
                
                if(!isSyncAll) {
                    operation.commitRecords(result.records);
                }
                operation.setCompleted();
                operation.setSuccessful();
            } else {
                operation.setException(result.message);
                me.fireEvent('exception', this, response, operation);
            }
        } else {
            me.setException(operation, response);
            me.fireEvent('exception', this, response, operation);
        }

        //this callback is the one that was passed to the 'read' or 'write' function above
        if (typeof callback == 'function') {
            
            if(!isSyncAll) {
                callback.call(scope || me, operation);
            }
        }

        me.afterRequest(request, success);
    }    
    
});

/**
 * unilite용 proxy class
 */
Ext.define('Unilite.com.data.proxy.UniDirectProxy', {
	extend: 'Ext.data.proxy.Direct',
    alias: 'proxy.uniDirect',
    batchActions:true,
	writer:'uniWriter',

    requires: ['Ext.direct.Manager'],
     //batchOrder: 'syncAll,create,update,destroy',
    batchOrder: 'destroy,create,update',
     
     /**

      * 추가/수정/삭제된 데이타를 server와 동기화 한다.
      * @return {}
      */
     /*
    syncAll: function() {
    	console.log("Proxy syncAll");
        return this.doRequest.apply(this, arguments);
    },*/
	
     /**
      * 하나의 Trancsaction 내에서 실행할 server 메소드들의 정보를 보낸다.
      * @return {}
      */
    doRequestSyncAll: function(batch, scope) {
    	var me = this,
    		operations = batch.operations,
            writer = me.getWriter(),
            request,
            operation,
            onProxyReturn,
            params,            
            args,
            fn, method;
        
        for(var index=0; index< operations.length; index++) {
        	args = [];
        	operation = operations[index];
        	
        	operation.setStarted();
        	
        	request = me.buildRequest(operation);
        	
        	if (!me.methodsResolved) {
	            me.resolveMethods();
	        }
	
	        fn = me.api[request.action] || me.directFn;
	        
	        //<debug>
	        if (!fn) {
	            Ext.Error.raise('No direct function specified for this proxy');
	        }
	        //</debug>
	
	        if (operation.allowWrite()) {	        	
	            request = writer.write(request);	        	
	        }
	
	        if (operation.action == 'read') {
	            // We need to pass params
	            method = fn.directCfg.method;
	            params = request.params
	            args = method.getArgs(params, me.paramOrder, me.paramsAsHash);
	        } else {
	            args.push(request.jsonData);
	        }
	
	        Ext.apply(request, {
	            args: args,
	            directFn: fn
	        });
	        
	        
	        
        	if(index == operations.length -1) {	//last operation	        		
        		
        		onProxyReturn = function(operation) {		        	
		                var hasException = operation.hasException();
		
		                if (hasException) {	                    
		                	batch.hasException = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (hasException && batch.pauseOnException) {
		                    batch.pause();
		                } else {
		                    operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }
			        	
		                batch.fireEvent('complete', batch, operation);	//strore refresh 및 콜백처리
		            };
        	} else {	//per operation 
        		onProxyReturn = function(operation) {		        	
		                var hasException = operation.hasException();
		
		                if (hasException) {	                    
		                	batch.hasException = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (hasException && batch.pauseOnException) {
		                    batch.pause();
		                } else {
		                    operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }		                
		                
//		                if(operation.action == 'syncAll') {
//		                	batch.fireEvent('complete', batch, operation);
//		                }
		         };
        	}
		    			
	        args.push(me.createRequestCallback(request, operation, onProxyReturn, scope), me);
	        
	        fn.apply(window, args);	       
        }
    },
    
     /**
      * 추가/수정/삭제된 데이타를 server와 동기화 한다.
      * @return {}
      */
    syncAll: function(options) {
    	console.log("Proxy syncAll(options)");

    	var me = this,
            callback,
            operations = [],
            records,
            batch,
            actions, aLen;
       
        //options.params = options.params || [];     //Master params info
        
        options.batch = {
            proxy: me,
            listeners: options.listeners || {}
        };    
        batch = new Ext.data.Batch(options.batch);
        batch.on('complete', Ext.bind(me.onBatchComplete, me, [options], 0));	//store의 refresh 및 callback 이 처리됨
        
    	actions = me.batchOrder.split(',');
        aLen    = actions.length;
		
        if(aLen > 0) {
        	 batch.add(new Ext.data.Operation({
                action  : 'syncAll',
                records : (options.params ? options.params : [{}])
                //records : []
            }));
        }
        
        for (a = 0; a < aLen; a++) {
            action  = actions[a];
            records = options.operations[action];

            if (records) {            	
            	batch.add(new Ext.data.Operation({
                    action  : action,
                    records : records
                }));
            }
        }
                 
        //if(options.callback)
        //	callback = options.callbak;
        
        me.doRequestSyncAll(batch, me);

    },
    
    /**
     * @overide
     * 
     * @param {} options
     * @param {} listeners
     * @return {}
     */
    batch: function(options, /* deprecated */listeners) {
    	console.log("new batch :" , options);
        var me = this,
            useBatch = me.batchActions,
            batch,
            records,
            actions, aLen, action, a, r, rLen, record;

        if (options.operations === undefined) {
            // the old-style (operations, listeners) signature was called
            // so convert to the single options argument syntax
            options = {
                operations: options,
                listeners: listeners
            };
        }

        if (options.batch) {
            if (Ext.isDefined(options.batch.runOperation)) {
                batch = Ext.applyIf(options.batch, {
                    proxy: me,
                    listeners: {}
                });
            }
        } else {
            options.batch = {
                proxy: me,
                listeners: options.listeners || {}
            };
        }

        if (!batch) {
            batch = new Ext.data.Batch(options.batch);
        }

        batch.on('complete', Ext.bind(me.onBatchComplete, me, [options], 0));

        actions = me.batchOrder.split(',');
        aLen    = actions.length;

        for (a = 0; a < aLen; a++) {
            action  = actions[a];
            records = options.operations[action];

            if (records) {
                if (useBatch) {
                    batch.add(new Ext.data.Operation({
                        action  : action,
                        records : records
                    }));
                } else {
                    rLen = records.length;

                    for (r = 0; r < rLen; r++) {
                        record = records[r];

                        batch.add(new Ext.data.Operation({
                            action  : action,
                            records : [record]
                        }));
                    }
                }
            }
        }

        batch.start();
        return batch;
    }

}); // Ext.define//@charset UTF-8
/**
 * Unilite용 Direct Store / 데이타 수정이 필요한 곳에만 사용 !
 *  * Sync시 (create, update, delete가 하나의 sync 함수로 통합함)
 */
Ext.define('Unilite.com.data.UniTreeStore', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.uniTreeStore',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.data.UniWriter',
    	'Unilite.com.UniAppManager'
    ],
    // Unilite용으로 확장된 옵션 사항.
    uniOpt : {
    	isMaster:	true, 		// 버튼과 상태 바에 메시지 전송 여부 
    	editable:	false,		// 수정 가능 여부
    	deletable:	false,		// 삭제 가능 여부 
    	useNaviBtn:	false,		// prev/next 버튼 사용 여부
    	state: {'btnDelete':false}				// 상태-tab이동시 사용 
    },
	
	
    constructor : function(config){
    	var me = this;
        config = Ext.apply({}, config);
       
        //Ext.apply(config.proxy, config, 'paramOrder,paramsAsHash,directFn,api,simpleSortMode');
		//Ext.apply(config.proxy.reader, config, 'totalProperty,root,idProperty');
		Ext.apply(config.proxy, {
				writer:'uniWriter',
				batchActions: true,
				batchOrder : 'destroy,create,update',
				listeners: {
                	exception : {
                		fn: function(proxy, response, operation, eOpts) {
                			// 서버 오류발생시 (validation 오류 포함)
                			me._onExceltion(proxy, response, operation, eOpts);
                		},
                		scope:this
                	}
                	
                }
		});
        me.callParent([config]);
        UniAppManager.register(this);   
		Ext.applyIf(this.uniOpt, {state:{btn:{}}});  
    	
        //
   		me.on('update', me._onStoreUpdate, me);
 		me.on('load', me._onStoreLoad, me);
 		me.on('datachanged', me._onStoreDataChanged, me);
   		me.on('remove', me._onChildRemove, me);

    } // initComponent
    ,count:function() {
    	var obj = this.tree.flatten();
    	return 1;
    }
    ,_onChildRemove: function(node, deletedNode, isMove, eOpts ) {
    	if(!node.hasChildNodes( )) {
    		node.set('leaf', true);
    	}
    	// 삭제후 store에 변경 notice (강제로 save 버튼 활성화)
    	this._onStoreDataChanged(this,eOpts, true);
    }
	, onStoreActionEnable : function(eOpts)	{
		var tmpIsMaster = this.uniOpt.isMaster;
		this.uniOpt.isMaster = true;
		this._onStoreDataChanged(this,eOpts);
		this.uniOpt.isMaster = tmpIsMaster;
	}
	// 주의 !!! 
    //,_onStoreUpdate:function (store, eOpt) {
    ,_onStoreUpdate:function (store, record, operation, modifiedFieldNames, eOpts) {
    	if(modifiedFieldNames != 'modifiedFieldNames' && this.uniOpt.isMaster) {
	    	//console.log("Store data updated save btn enabled !"+ this.isLoading( ) );
	    	UniAppManager.setToolbarButtons('save', true);
    	}
    } // onStoreUpdate
    ,_onStoreLoad:function ( store, records, successful, eOpts ) {
    	if(this.uniOpt.isMaster) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = '조회되었습니다.';
		    	//console.log(msg, st);
		    	UniAppManager.updateStatus(msg, true);	    	
	    	}
    	}
    } //onStoreLoad
   
    ,_onStoreDataChanged : function( store, eOpts , lForce)	{
    	if(this.uniOpt.isMaster) {
       		var rootNode = store.getRootNode();
       		console.log(" store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty() || lForce)	{
       			UniApp.setToolbarButtons(['save'], true);
       		}else {
       			UniApp.setToolbarButtons(['save'], false);
       		}
    	}
    } // onStoreDatachanged
    ,_onExceltion:function(proxy, response, operation, eOpts) {
    	 Ext.MessageBox.show({
		                    title: 'REMOTE EXCEPTION',
		                    msg: operation.getError(),
		                    icon: Ext.MessageBox.ERROR,
		                    buttons: Ext.Msg.OK
		                });
    },

    
     
    /**
     * 저장할 것이 있는지 확인
     * extjs의 isDirty와 의미가 조금 다름.
     * @return {}
     */
    isDirty:function() {
    	var me = this, needsSync = false;
        var toCreate = Ext.Array.filter(this.tree.flatten(), this.filterNew);
        var toUpdate = Ext.Array.filter(this.tree.flatten(), this.filterUpdated);
        var toDestroy = me.getRemovedRecords();
            

        if (toCreate.length > 0 || toUpdate.length > 0 || toDestroy.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },
    // Ext.data.AbstractStore
    // filterNew : item.phantom === true && item.isValid();
    // filterUpdated : item.dirty === true && item.phantom !== true && item.isValid();
    // 
    filterInvalidUpdatedRecords:function (item) {
    	return item.dirty === true && item.phantom !== true && !item.isValid();
    },
    filterInvalidNewRecords:function (item) {
    	// dirty는 저장안된것 !!!(추가건에 수정이 없으면 dirty에 안걸림)
    	return item.phantom === true && !item.isValid();
    },
    getInvalidRecords: function() {
    	//return this.data.filterBy(this.filterInvalid).items;
    	//return [].concat(this.data.filterBy(this.filterInvalidNewRecords).items, this.data.filterBy(this.filterInvalidUpdatedRecords).items);
    	var a1 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidNewRecords);
    	var a2 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidUpdatedRecords);
    	return [].concat( a1, a2 );
    },
    /**
     * 
     * @param {} options
     * @return {}
     */
    syncAll: function(options) {
    	
    	// 유효한 레코드 들만 가져옮
        var me = this,
            operations = {syncAll:{}},
            toCreate = me.getNewRecords(),
            toUpdate = me.getUpdatedRecords(),
            toDestroy = me.getRemovedRecords(),
            needsSync = false;

        if (toCreate.length > 0) {
            operations.create = toCreate;
            operations.syncAll.create = toCreate;
            needsSync = true;
        }

        if (toUpdate.length > 0) {
            operations.update = toUpdate;
            operations.syncAll.update = toUpdate;
            needsSync = true;
        }

        if (toDestroy.length > 0) {
            operations.destroy = toDestroy;
            operations.syncAll.destroy = toDestroy;
            needsSync = true;
        }

        if (needsSync && me.fireEvent('beforesync', operations) !== false) {
            options = options || {};
			options=Ext.apply(options, {
                operations: operations,
                listeners: me.getBatchListeners()
            });
            options=Ext.apply(options, {
            	callback: function(batch, option) {
            		//UniAppManager.updateStatus("저장되었습니다.");
            		console.log()
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.batch(options);
        }
        
        return me;
    }
    
}); // Ext.define//@charset UTF-8
/**
 * Unilite용 Direct Abstract Store 
 */
Ext.define('Unilite.com.data.UniAbstractStore', {
    extend: 'Ext.data.Store',
    
    // statefulFilters: true,	// store 필터 상태 정보 저장 시 필요함.
    
    // Unilite용으로 확장된 옵션 사항.
    uniOpt: {
        isMaster:   true,       // 버튼과 상태 바에 메시지 전송 여부 
        editable:   false,      // 수정 가능 여부
        deletable:  false,      // 삭제 가능 여부 
        useNaviBtn: false,      // prev/next 버튼 사용 여부
        state: {'btnDelete': false}             // 상태-tab이동시 사용 
    },
    // Ext.data.AbstractStore
    // filterNew : item.phantom === true && item.isValid();
    // filterUpdated : item.dirty === true && item.phantom !== true && item.isValid();
    // 
    filterInvalidUpdatedRecords: function (item) {
        return item.dirty === true && item.phantom !== true && !item.isValid();
    },
    filterInvalidNewRecords: function (item) {
        // dirty는 저장안된것 !!!(추가건에 수정이 없으면 dirty에 안걸림)
        return item.phantom === true && !item.isValid();
    },
    getInvalidRecords: function() {
        //return this.data.filterBy(this.filterInvalid).items;
        return [].concat(this.data.filterBy(this.filterInvalidNewRecords).items, this.data.filterBy(this.filterInvalidUpdatedRecords).items);
    },
    /**
     * filter에서 inValid record 포함하기 위해 override함
     * @return {}
     */
    getRejectRecords: function() {
        // Return phantom records + updated records
        return Ext.Array.push(this.data.filterBy(this.filterNewOnly).items, this.getUpdatedRecordsForReject());
    },
    getUpdatedRecordsForReject: function() {
        return (this.snapshot || this.data).filterBy(this.filterUpdatedForReject).items;
    },
    filterUpdatedForReject: function(item) {
        // only want dirty records, not phantoms that are valid
        return item.dirty === true && item.phantom !== true ;
    },
       /**
     * 
     * @param {} options
     * @return {}
     */
    syncAll: function(options) {
    	
    	// 유효한 레코드 들만 가져옮
        var me = this,
            operations = {syncAll:{}},
            toCreate = me.getNewRecords(),
            toUpdate = me.getUpdatedRecords(),
            toDestroy = me.getRemovedRecords(),
            needsSync = false;

        if (toCreate.length > 0) {
            operations.create = toCreate;
            operations.syncAll.create = toCreate;
            needsSync = true;
        }

        if (toUpdate.length > 0) {
            operations.update = toUpdate;
            operations.syncAll.update = toUpdate;
            needsSync = true;
        }

        if (toDestroy.length > 0) {
            operations.destroy = toDestroy;
            operations.syncAll.destroy = toDestroy;
            needsSync = true;
        }

        if (needsSync && me.fireEvent('beforesync', operations) !== false) {
            options = options || {};
			options=Ext.apply(options, {
                operations: operations,
                listeners: me.getBatchListeners()
            });
            options=Ext.apply(options, {
            	callback: function(batch, option) {
            		console.log("callback exceptions :", batch.exceptions);
            		if(batch.exceptions && batch.exceptions.length < 1) {
            			UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
            		}
            		Ext.getBody().unmask();
            	},
            	failure: function (optional){
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.batch(options);
        }
        
        return me;
    },
    
    /**
     * 
     * @param {} options
     * @return {}
     */
    syncAllDirect: function(options) {
    	
    	// 유효한 레코드 들만 가져옮
        var me = this,
            operations = {syncAll:{}},
            toCreate = me.getNewRecords(),
            toUpdate = me.getUpdatedRecords(),
            toDestroy = me.getRemovedRecords(),
            needsSync = false;

        if (toCreate.length > 0) {
            operations.create = toCreate;
            operations.syncAll.create = toCreate;
            needsSync = true;
        }

        if (toUpdate.length > 0) {
            operations.update = toUpdate;
            operations.syncAll.update = toUpdate;
            needsSync = true;
        }

        if (toDestroy.length > 0) {
            operations.destroy = toDestroy;
            operations.syncAll.destroy = toDestroy;
            needsSync = true;
        }

        if (needsSync && me.fireEvent('beforesync', operations) !== false) {
            options = options || {};
			options=Ext.apply(options, {
                operations: operations,
                listeners: me.getBatchListeners()
            });
            options=Ext.apply(options, {
            	callback: function(batch, option) {
            		console.log("callback exceptions :", batch.exceptions);
            		if(batch.exceptions && batch.exceptions.length < 1) {
            			UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
            		}
            		Ext.getBody().unmask();
            	},
            	failure: function (optional){
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.syncAll(options);
        }
        
        return me;
    }
});//@charset UTF-8
/**
 * Unilite용 Direct Store / 데이타 수정이 필요한 곳에만 사용 !
 *  * Sync시 (create, update, delete가 하나의 sync 함수로 통합함)
 */
Ext.define('Unilite.com.data.UniStore', {
    extend: 'Unilite.com.data.UniAbstractStore',
    alias: 'store.uniStore',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.data.UniWriter',
    	'Unilite.com.UniAppManager'
    ],
	
	
    constructor: function(config){
    	var me = this;
        config = Ext.apply({}, config);
        
		Ext.apply(config.proxy, {
				writer:'uniWriter',
				batchActions: true,
				batchOrder : 'destroy,create,update'
		});
		me.callParent(arguments);
        UniAppManager.register(this);   
		Ext.applyIf(this.uniOpt, {state:{btn:{}}});  
    	
        //
   		me.on('update', me._onStoreUpdate, me);
 		me.on('load', me._onStoreLoad, me);
 		me.on('datachanged', me._onStoreDataChanged, me);
        

    } // initComponent
	, onStoreActionEnable: function(eOpts)	{
		var tmpIsMaster = this.uniOpt.isMaster;
		this.uniOpt.isMaster = true;
		this._onStoreDataChanged(this,eOpts);
		this.uniOpt.isMaster = tmpIsMaster;
	}
    ,_onStoreUpdate: function (store, eOpt) {
    	if(this.uniOpt.isMaster) {
	    	console.log("Store data updated save btn enabled !");
	    	UniAppManager.setToolbarButtons('save', true);
    	}
    } // onStoreUpdate
    ,_onStoreLoad: function ( store, records, successful, eOpts ) {
    	if(this.uniOpt.isMaster) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
		    	UniAppManager.updateStatus(msg, true);	
	    	}
    	}
    } //onStoreLoad
   
    ,_onStoreDataChanged: function( store, eOpts )	{
    	if(this.uniOpt.isMaster) {
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty())	{
       			UniApp.setToolbarButtons(['save'], true);
       		}else {
       			UniApp.setToolbarButtons(['save'], false);
       		}
    	}
    }, // onStoreDatachanged
//    _onException:function(proxy, response, operation, eOpts) {
//    	var vMsg = operation.getError() ;
//    	if(response) {
//    		vMsg = vMsg + "<br/>" + response.where
//    	}
//    	
//    	 Ext.MessageBox.show({
//		                    title: 'REMOTE EXCEPTION',
//		                    msg: vMsg,
//		                    icon: Ext.MessageBox.ERROR,
//		                    buttons: Ext.Msg.OK
//		                });
//    },

    
     
    /**
     * 저장할 것이 있는지 확인
     * extjs의 isDirty와 의미가 조금 다름.
     * @return {}
     */
    isDirty: function() {
    	var me = this, needsSync = false;
        var toCreate = me.data.filterBy(function(item) {return item.phantom === true;});
        var toUpdate = me.data.filterBy(function(item) {return item.dirty === true && item.phantom !== true });
        var toDestroy = me.getRemovedRecords();
            

        if (toCreate.length > 0 || toUpdate.length > 0 || toDestroy.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },
    isUpdateDirty: function() {
    	var me = this, needsSync = false;
        var toUpdate = me.data.filterBy(function(item) {return item.dirty === true && item.phantom !== true });            

        if (toUpdate.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },
    /**
     * UniAbstract store로 이동
     * @param {} options
     * @return {}
     */
    syncAllX: function(options) {
    	
    	// 유효한 레코드 들만 가져옮
        var me = this,
            operations = {syncAll:{}},
            toCreate = me.getNewRecords(),
            toUpdate = me.getUpdatedRecords(),
            toDestroy = me.getRemovedRecords(),
            needsSync = false;

        if (toCreate.length > 0) {
            operations.create = toCreate;
            operations.syncAll.create = toCreate;
            needsSync = true;
        }

        if (toUpdate.length > 0) {
            operations.update = toUpdate;
            operations.syncAll.update = toUpdate;
            needsSync = true;
        }

        if (toDestroy.length > 0) {
            operations.destroy = toDestroy;
            operations.syncAll.destroy = toDestroy;
            needsSync = true;
        }

        if (needsSync && me.fireEvent('beforesync', operations) !== false) {
            options = options || {};
			options=Ext.apply(options, {
                operations: operations,
                listeners: me.getBatchListeners()
            });
            options=Ext.apply(options, {
            	callback: function(batch, option) {
            		console.log("callback exceptions :", batch.exceptions);
            		if(batch.exceptions && batch.exceptions.length < 1) {
            			UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
            		}
            		Ext.getBody().unmask();
            	},
            	failure: function (optional){
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.batch(options);
        }
        
        return me;
    },
    
    /**
     * 조건식에 의해 컬럼의 합계를 가져온다.
     * @param {} queryFn	query 할 function
     * @param {} sumCols	집계할 컬럼명 배열 객체
     * @return {}	sum된 값을  sumCols의 각 이름으로 리턴
     */
    sumBy: function(queryFn, sumCols) {
    	var records = this.queryBy(queryFn);
		var results = new Array();
		Ext.each(sumCols, function(colName) {
			results[colName] = 0;
			Ext.each(records.items, function(record){
				results[colName] += Ext.isNumeric(record.get(colName)) ? record.get(colName):0;
			});
		});
		return results;
    },
    
    countBy: function(queryFn) {
    	var records = this.queryBy(queryFn);
    	return records.getCount();
    }
    
}); // Ext.define
//@charset UTF-8
/**
 * Unilite용 Simple Store (JSpopup용)
 * 
 */
Ext.define('Unilite.com.data.UniStoreSimple', {
    extend: 'Unilite.com.data.UniAbstractStore',
    alias: 'store.uniStoreSimple',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.data.UniWriter',
    	'Unilite.com.UniAppManager'
    ],
 
    uniOpt: {
        isMaster:   false,       // 버튼과 상태 바에 메시지 전송 여부 
        editable:   false,      // 수정 가능 여부
        deletable:  false,      // 삭제 가능 여부 
        useNaviBtn: false,      // prev/next 버튼 사용 여부
        state: {'btnDelete': false}             // 상태-tab이동시 사용 
    },	
    constructor: function(config){
        var me = this;
        config = Ext.apply({}, config);
        me.callParent(arguments);

    } // constructor
    
}); // Ext.define//@charset UTF-8
/**
 * unilite용 확장된 모델 class
 */
Ext.define('Unilite.com.data.UniModel', {
	extend: 'Ext.data.Model',
    alternateClassName: 'Unilite.data.Model',
    
    
    
    /**
     *  @cfg {} pks Primary Keys 들을 정의 
     */
    pks : [],
    
    /**
     * 새로운 레코드인지 판단 true : 신규 레코드 (DB에서 가져온 것이 아님 !)
     * @return {}
     */
    isNew : function() {
    	var me = this;
    	return me.phantom;
    }
}); // Ext.define//@charset UTF-8
/**
 * unilite용 확장된 모델 class
 */
Ext.define('Unilite.com.data.UniTreeModel', {
	extend: 'Ext.data.Model',
    alternateClassName: 'Unilite.data.TreeModel',
    
    
    
    /**
     *  @cfg {} pks Primary Keys 들을 정의 
     */
    pks : [],
    
    /**
     * 새로운 레코드인지 판단 true : 신규 레코드 (DB에서 가져온 것이 아님 !)
     * @return {}
     */
    isNew : function() {
    	var me = this;
    	return me.phantom;
    }/*,
    idgen: {
         type: 'sequential',
         seed: 1000,
         prefix: 'ID_'
     }*/
}); // Ext.define//@charset UTF-8
/**
 * 
 */


Ext.define('Unilite.com.state.UniStorageProvider', {

    extend: 'Ext.state.Provider',
    alias: 'state.uniStorage',
    
    
    /**
     * The internal store.
     */
    store: null,



    constructor: function (config) {
        config = config || {};
        var me = this;
        Ext.apply(me, config);

        //if (!me.store) {
        //    me.store = me.buildStore();
        //}
        me.addEvents("statechange");
        me.state = {};
        me.isFirst = true;
        me.mixins.observable.constructor.call(me);
    },

    // Statefull.saveState() 에서 grid의 getState()를 통해 columns 와 storeState(단, grouper, sorter, filter 등이 있을 경우만) 상태값을 가져와서  set 한다.
    // Ext.state.Manager.set(..) 하면 provider 로 set 하게 되어 있음.
    set: function (name, value) {
 		var me = this;
        me.state[name] = value;
        me.fireEvent("statechange", me, name, value);
    },

    
    get: function (name, defaultValue) {
    	var me = this;
    	var rv = typeof me.state[name] == "undefined" ?
            defaultValue : me.state[name];
            console.log("GET : ", name, rv);
        return rv;
    },

    _buildState: function() {

    	var me = this;
    	var row, shtInfo;
    	if( Ext.isDefined(me.store)) {
    	 	me.store.data.each(function(item, index, totalItems ) {
    	 		
    	 		// provider 의 state 에 grid의 id를 키값으로 db에 저장되어 있는 상태정보값을 불러들인다.
    	 		me.state[item.get("id")] = item.get("shtInfo");
    	 		
        		me.fireEvent("statechange", me, item.get("id"), null);
    	 		
    	 		console.log("State rebuild:", me.state.length, item.get("id"), item.get("shtInfo") );
    	 	})
    	 	
    	 	/*
    	 	row = me.store.getById(name);
    	 	if(Ext.isDefined(row)) {
	    	 	shtInfo = row.get('shtInfo');
	    	 	if(Ext.isDefined(shtInfo)) {
		    	 	me.state[name] = shtInfo.shtInfo;
	    	 	}
    	 	}
    	 	*/
    	 }
    },
    clear: function (name) {
        var me = this;
        delete me.state[name];
        me.fireEvent("statechange", me, name, null);
    },
	setStore:function(store) {
		this.store = store;
		this._buildState();
	}
	/*

    buildStore: function () {
        return  Ext.data.StoreManager.lookup('STATE_STORE');
    }
    */
    
});
//@charset UTF-8


Ext.define('Unilite.com.tab.UniTabPanel', {
	extend: 'Ext.tab.Panel',
	padding:'1 0 0 1',
	bodyPadding: 0,
	flex : 1,
	activeTab: 0,
	tabPosition: 'top',
    initComponent: function() {
        var me = this,
            tabs = [].concat(me.items || []),
            activeTab = me.activeTab || (me.activeTab = 0),
            tabPosition = me.tabPosition;
            
         var stores = [];
         
         /**
         for(var i =0, len = tabs.length ; i < len; i ++) {
         	var item =tabs[i];
         	if(item.store) {
         		console.log("tab [" + item.id + ": store "+ item.store.id);
         		//me.mon(item.store,'update', me.onStoreUpdate, me);
         	}
         } 
         */
         me.on('beforetabchange', me.onBeforetabchange, me)
         me.callParent(arguments);
    } // initComponent
    
    , onBeforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
    	if(newCard.uniOpt) {
    		if(newCard.uniOpt.store) {
    			var option = newCard.uniOpt;
	    		var store = option.store;
	    		var naviStore = Ext.isDefined(option.naviStore) ?  option.naviStore :  store;
	    		
	    		UniAppManager.setToolbarButtons(['save'],false);
	    		if(Ext.isDefined(store.uniOpt.state.btnDelete)) {
	    			UniAppManager.setToolbarButtons(['delete'],	Unilite.nvl(store.uniOpt.state.btnDelete, false));
	    		} else {
	    			
	    			UniAppManager.setToolbarButtons(['delete'],	 false);
	    		}
	    		if(store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}
	    		if(option.useNaviBtn) {
	    			if(naviStore.count() > 0)	{
						UniAppManager.setToolbarButtons(['prev','next'],true);
					} else {
	    				UniAppManager.setToolbarButtons(['prev', 'next'],false);
					}
	    		}
    		}
    		
    	}
    }
});// defineExt.ns('Ext.ux');
/**
 * Plugin for adding a tab menu to a TabBar is the Tabs overflow.
 * 
 * based on Ext.ux.TabScrollerMenu 
 *  add funcrions of Ext.ux.TabCloseMenu
 */
Ext.define('Unilite.com.tab.UniTabScrollerMenu', {
    alias: 'plugin.uniTabscrollermenu',

    requires: ['Ext.menu.Menu'],

    /**
     * @cfg {Number} pageSize How many items to allow per submenu.
     */
    pageSize: 10,
    /**
     * @cfg {Number} maxText How long should the title of each {@link Ext.menu.Item} be.
     */
    maxText: 15,
    /**
     * @cfg {String} menuPrefixText Text to prefix the submenus.
     */
    menuPrefixText: 'Items',

    /**
     * @cfg {Boolean} showCloseAll
     * Indicates whether to show the 'Close All' option.
     */
    showCloseAll: true,
    /**
     * @cfg {Boolean} showCloseOthers
     * Indicates whether to show the 'Close Others' option.
     */
    showCloseOthers: true,    
    /**
     * Creates new TabScrollerMenu.
     * @param {Object} config Configuration options
     */
    constructor: function(config) {
        Ext.apply(this, config);
    },
    text: {
    	closeAllTabs: 'Close All Tabs',
    	closeOthersTabs: 'Close Other Tabs'
    },
    
    //private
    init: function(tabPanel) {
        var me = this;

        me.tabPanel = tabPanel;

        tabPanel.on({
            render: function() {
                me.tabBar = tabPanel.tabBar;
                me.layout = me.tabBar.layout;
                me.layout.overflowHandler.handleOverflow = Ext.Function.bind(me.showButton, me);
                me.layout.overflowHandler.clearOverflow = Ext.Function.createSequence(me.layout.overflowHandler.clearOverflow, me.hideButton, me);
            },
            destroy: me.destroy,
            scope: me,
            single: true
        });
    },

    showButton: function() {
        var me = this,
            result = Ext.getClass(me.layout.overflowHandler).prototype.handleOverflow.apply(me.layout.overflowHandler, arguments),
            button = me.menuButton;

        if (me.tabPanel.items.getCount() > 1) {
            if (!button) {
                button = me.menuButton = me.tabBar.body.createChild({
                    cls: Ext.baseCSSPrefix + 'tab-tabmenu-right'
                }, me.tabBar.body.child('.' + Ext.baseCSSPrefix + 'box-scroller-right'));
                button.addClsOnOver(Ext.baseCSSPrefix + 'tab-tabmenu-over');
                button.on('click', me.showTabsMenu, me);
            }
            button.setVisibilityMode(Ext.dom.Element.DISPLAY);
            button.show();
            result.reservedSpace += button.getWidth();
        } else {
            me.hideButton();
        }
        return result;
    },

    hideButton: function() {
        var me = this;
        if (me.menuButton) {
            me.menuButton.hide();
        }
    },

    /**
     * Returns an the current page size (this.pageSize);
     * @return {Number} this.pageSize The current page size.
     */
    getPageSize: function() {
        return this.pageSize;
    },
    /**
     * Sets the number of menu items per submenu "page size".
     * @param {Number} pageSize The page size
     */
    setPageSize: function(pageSize) {
        this.pageSize = pageSize;
    },
    /**
     * Returns the current maxText length;
     * @return {Number} this.maxText The current max text length.
     */
    getMaxText: function() {
        return this.maxText;
    },
    /**
     * Sets the maximum text size for each menu item.
     * @param {Number} t The max text per each menu item.
     */
    setMaxText: function(t) {
        this.maxText = t;
    },
    /**
     * Returns the current menu prefix text String.;
     * @return {String} this.menuPrefixText The current menu prefix text.
     */
    getMenuPrefixText: function() {
        return this.menuPrefixText;
    },
    /**
     * Sets the menu prefix text String.
     * @param {String} t The menu prefix text.
     */
    setMenuPrefixText: function(t) {
        this.menuPrefixText = t;
    },

    showTabsMenu: function(e) {
        var me = this;

        if (me.tabsMenu) {
            me.tabsMenu.removeAll();
        } else {
            me.tabsMenu = new Ext.menu.Menu();
        }

        me.generateTabMenuItems();

        var target = Ext.get(e.getTarget()),
            xy = target.getXY();

        //Y param + 24 pixels
        xy[1] += 24;

        me.tabsMenu.showAt(xy);
    },

    // private
    generateTabMenuItems: function() {
        var me = this,
            tabPanel = me.tabPanel,
            curActive = tabPanel.getActiveTab(),
            allItems = tabPanel.items.getRange(),
            pageSize = me.getPageSize(),
            tabsMenu = me.tabsMenu,
            totalItems, numSubMenus, remainder,
            i, curPage, menuItems, x, item, start, index;
            
        tabsMenu.suspendLayouts();
        allItems = Ext.Array.filter(allItems, function(item){
            if (item.id == curActive.id) {
                return false;
            }
            return item.hidden ? !!item.hiddenByLayout : true;
        });
        totalItems = allItems.length;
        numSubMenus = Math.floor(totalItems / pageSize);
        remainder = totalItems % pageSize;

       	if(this.showCloseAll) {
	        tabsMenu.add({
	                    text: this.text.closeAllTabs,
	                    handler: this.onCloseAll,
	                    scope: me
	                });
	    }
	    if(this.showCloseOthers) {
	        tabsMenu.add({
	                    text: this.text.closeOthersTabs,
	                    handler: this.onCloseOthers,
	                    scope: me
	                });
	    }
	    if(this.showCloseAll || this.showCloseOthers) {
	        tabsMenu.add('-');
	    }
        if (totalItems > pageSize) {

            // Loop through all of the items and create submenus in chunks of 10
            for (i = 0; i < numSubMenus; i++) {
                curPage = (i + 1) * pageSize;
                menuItems = [];

                for (x = 0; x < pageSize; x++) {
                    index = x + curPage - pageSize;
                    item = allItems[index];
                    menuItems.push(me.autoGenMenuItem(item));
                }

                tabsMenu.add({
                    text: me.getMenuPrefixText() + ' ' + (curPage - pageSize + 1) + ' - ' + curPage,
                    menu: menuItems
                });
            }
            // remaining items
            if (remainder > 0) {
                start = numSubMenus * pageSize;
                menuItems = [];
                for (i = start; i < totalItems; i++) {
                    item = allItems[i];
                    menuItems.push(me.autoGenMenuItem(item));
                }

                me.tabsMenu.add({
                    text: me.menuPrefixText + ' ' + (start + 1) + ' - ' + (start + menuItems.length),
                    menu: menuItems
                });

            }
        } else {
            for (i = 0; i < totalItems; ++i) {
                tabsMenu.add(me.autoGenMenuItem(allItems[i]));
            }
        }
        tabsMenu.resumeLayouts(true);
    },
    onCloseAll : function(){
        this.doClose(false);
    },
    onCloseOthers : function(){
        this.doClose(true);
    },
    doClose : function(excludeActive){
        var items = [];

        this.tabPanel.items.each(function(item){
            if(item.closable){
                //if(!excludeActive || item != this.item){
                if(!excludeActive || !item.tab.active){
                    items.push(item);
                }
            }
        }, this);

        Ext.each(items, function(item){
            this.tabPanel.remove(item);
        }, this);
    },
    
    // private
    autoGenMenuItem: function(item) {
        var maxText = this.getMaxText(),
            text = Ext.util.Format.ellipsis(item.title, maxText);

        return {
            text: text,
            handler: this.showTabFromMenu,
            scope: this,
            disabled: item.disabled,
            tabToShow: item,
            iconCls: item.iconCls
        };
    },

    // private
    showTabFromMenu: function(menuItem) {
        this.tabPanel.setActiveTab(menuItem.tabToShow);
    },
    
    destroy: function(){
        Ext.destroy(this.tabsMenu, this.menuButton);       
    }
});//@charset UTF-8
/**
 *  Table layout 보정용 
 * 
 */
 
 Ext.define("Unilite.com.layout.UniTable", {
    extend: 'Ext.layout.container.Container',
	alias: ['layout.uniTable'],



    // private
    monitorResize:false,

    type: 'table',
    
    createsInnerCt: true,

    targetCls: Ext.baseCSSPrefix + 'table-layout-ct',
    tableCls: Ext.baseCSSPrefix + 'table-layout',
    cellCls: Ext.baseCSSPrefix + 'table-layout-cell',

    /**
     * @cfg {Object} tableAttrs
     * An object containing properties which are added to the {@link Ext.DomHelper DomHelper} specification used to
     * create the layout's `<table>` element. Example:
     *
     *     {
     *         xtype: 'panel',
     *         layout: {
     *             type: 'table',
     *             columns: 3,
     *             tableAttrs: {
     *                 style: {
     *                     width: '100%'
     *                 }
     *             }
     *         }
     *     }
     */
    tableAttrs: null,

    /**
     * @cfg {Object} trAttrs
     * An object containing properties which are added to the {@link Ext.DomHelper DomHelper} specification used to
     * create the layout's `<tr>` elements.
     */

    /**
     * @cfg {Object} tdAttrs
     * An object containing properties which are added to the {@link Ext.DomHelper DomHelper} specification used to
     * create the layout's `<td>` elements.
     */

    getItemSizePolicy: function (item) {
        return this.autoSizePolicy;
    },
    
    initHierarchyState: function (hierarchyStateInner) {    
        hierarchyStateInner.inShrinkWrapTable  = true;
    },

    getLayoutItems: function() {
        var me = this,
            result = [],
            items = me.callParent(),
            item,
            len = items.length, i;

        for (i = 0; i < len; i++) {
            item = items[i];
            if (!item.hidden) {
                result.push(item);
            }
        }
        return result;
    },
    
    getHiddenItems: function(){
        var result = [],
            items = this.owner.items.items,
            len = items.length,
            i = 0, item;
            
        for (; i < len; ++i) {
            item = items[i];
            if (item.rendered && item.hidden) {
                result.push(item);
            }
        }    
        return result;
    },

    /**
     * @private
     * Iterates over all passed items, ensuring they are rendered in a cell in the proper
     * location in the table structure.
     */
    renderChildren: function() {
        var me = this,
            items = me.getLayoutItems(),
            tbody = me.owner.getTargetEl().child('table', true).tBodies[0],
            rows = tbody.rows,
            i = 0,
            len = items.length,
            hiddenItems = me.getHiddenItems(),
            cells, curCell, rowIdx, cellIdx, item, trEl, tdEl, itemCt, el;

        // Calculate the correct cell structure for the current items
        cells = me.calculateCells(items);

        // Loop over each cell and compare to the current cells in the table, inserting/
        // removing/moving cells as needed, and making sure each item is rendered into
        // the correct cell.
        for (; i < len; i++) {
            curCell = cells[i];
            rowIdx = curCell.rowIdx;
            cellIdx = curCell.cellIdx;
            item = items[i];

            // If no row present, create and insert one
            trEl = rows[rowIdx];
            if (!trEl) {
                trEl = tbody.insertRow(rowIdx);
                if (me.trAttrs) {
                    trEl.set(me.trAttrs);
                }
            }

            // If no cell present, create and insert one
            itemCt = tdEl = Ext.get(trEl.cells[cellIdx] || trEl.insertCell(cellIdx));
            if (me.needsDivWrap()) { //create wrapper div if needed - see docs below
            	var child = {tag: 'div', cls:'uni-table_td_div'};
                itemCt = tdEl.first() || tdEl.createChild(child);
                itemCt.setWidth(null);
                itemCt.addCls('uni-table_td_div');
            }

            // Render or move the component into the cell
            if (!item.rendered) {
                me.renderItem(item, itemCt, 0);
            } else if (!me.isValidParent(item, itemCt, rowIdx, cellIdx, tbody)) {
                me.moveItem(item, itemCt, 0);
            }

            // Set the cell properties
            if (me.tdAttrs) {
                tdEl.set(me.tdAttrs);
            }
            if (item.tdAttrs) {
                tdEl.set(item.tdAttrs);
            }
            tdEl.set({
                colSpan: item.colspan || 1,
                rowSpan: item.rowspan || 1,
                id: item.cellId || '',
                cls: me.cellCls + ' ' + (item.cellCls || '')
            });

            // If at the end of a row, remove any extra cells
            if (!cells[i + 1] || cells[i + 1].rowIdx !== rowIdx) {
                cellIdx++;
                while (trEl.cells[cellIdx]) {
                    trEl.deleteCell(cellIdx);
                }
            }
        }

        // Delete any extra rows
        rowIdx++;
        while (tbody.rows[rowIdx]) {
            tbody.deleteRow(rowIdx);
        }
        
        // Check if we've removed any cells that contain a component, we need to move
        // them so they don't get cleaned up by the gc
        for (i = 0, len = hiddenItems.length; i < len; ++i) {
            me.ensureInDocument(hiddenItems[i].getEl());
        }
    },
    
    ensureInDocument: function(el){
        var dom = el.dom.parentNode;
        while (dom) {
            if (dom.tagName.toUpperCase() == 'BODY') {
                return;
            }
            dom = dom.parentNode;
        } 
        
        Ext.getDetachedBody().appendChild(el);
    },

    calculate: function (ownerContext) {
        if (!ownerContext.hasDomProp('containerChildrenSizeDone')) {
            this.done = false;
        } else {
            var targetContext = ownerContext.targetContext,
                widthShrinkWrap = ownerContext.widthModel.shrinkWrap,
                heightShrinkWrap = ownerContext.heightModel.shrinkWrap,
                shrinkWrap = heightShrinkWrap || widthShrinkWrap,
                table = shrinkWrap && targetContext.el.child('table', true),
                targetPadding = shrinkWrap && targetContext.getPaddingInfo();

            if (widthShrinkWrap) {
                ownerContext.setContentWidth(table.offsetWidth + targetPadding.width, true);
            }

            if (heightShrinkWrap) {
                ownerContext.setContentHeight(table.offsetHeight + targetPadding.height, true);
            }
        }
    },

    finalizeLayout: function() {
        if (this.needsDivWrap()) {
            // set wrapper div width to match layed out item - see docs below
            var items = this.getLayoutItems(),
                i,
                iLen  = items.length,
                item;

            for (i = 0; i < iLen; i++) {
                item = items[i];

                Ext.fly(item.el.dom.parentNode).setWidth(item.getWidth());
            }
        }
        if (Ext.isIE6 || Ext.isIEQuirks) {
            // Fixes an issue where the table won't paint
            this.owner.getTargetEl().child('table').repaint();
        }
    },

    /**
     * @private
     * Determine the row and cell indexes for each component, taking into consideration
     * the number of columns and each item's configured colspan/rowspan values.
     * @param {Array} items The layout components
     * @return {Object[]} List of row and cell indexes for each of the components
     */
    calculateCells: function(items) {
        var cells = [],
            rowIdx = 0,
            colIdx = 0,
            cellIdx = 0,
            totalCols = this.columns || Infinity,
            rowspans = [], //rolling list of active rowspans for each column
            i = 0, j,
            len = items.length,
            item;

        for (; i < len; i++) {
            item = items[i];

            // Find the first available row/col slot not taken up by a spanning cell
            while (colIdx >= totalCols || rowspans[colIdx] > 0) {
                if (colIdx >= totalCols) {
                    // move down to next row
                    colIdx = 0;
                    cellIdx = 0;
                    rowIdx++;

                    // decrement all rowspans
                    for (j = 0; j < totalCols; j++) {
                        if (rowspans[j] > 0) {
                            rowspans[j]--;
                        }
                    }
                } else {
                    colIdx++;
                }
            }

            // Add the cell info to the list
            cells.push({
                rowIdx: rowIdx,
                cellIdx: cellIdx
            });

            // Increment
            for (j = item.colspan || 1; j; --j) {
                rowspans[colIdx] = item.rowspan || 1;
                ++colIdx;
            }
            ++cellIdx;
        }

        return cells;
    },

    getRenderTree: function() {
        var me = this,
            items = me.getLayoutItems(),
            cells,
            rows = [],
            result = Ext.apply({
                tag: 'table',
                role: 'presentation',
                cls: me.tableCls,
                cellspacing: 0,
                cellpadding: 0,
                cn: {
                    tag: 'tbody',
                    cn: rows
                }
            }, me.tableAttrs),
            tdAttrs = me.tdAttrs,
            needsDivWrap = me.needsDivWrap(),
            i, len = items.length, item, curCell, tr, rowIdx, cellIdx, cell;

        // Calculate the correct cell structure for the current items
        cells = me.calculateCells(items);

        for (i = 0; i < len; i++) {
            item = items[i];
            
            curCell = cells[i];
            rowIdx = curCell.rowIdx;
            cellIdx = curCell.cellIdx;

            // If no row present, create and insert one
            tr = rows[rowIdx];
            if (!tr) {
                tr = rows[rowIdx] = {
                    tag: 'tr',
                    cn: []
                };
                if (me.trAttrs) {
                    Ext.apply(tr, me.trAttrs);
                }
            }

            // If no cell present, create and insert one
            cell = tr.cn[cellIdx] = {
                tag: 'td'
            };
            if (tdAttrs) {
                Ext.apply(cell, tdAttrs);
            }
            Ext.apply(cell, {
                colSpan: item.colspan || 1,
                rowSpan: item.rowspan || 1,
                id: item.cellId || '',
                cls: me.cellCls + ' ' + (item.cellCls || '')
            });

            if (needsDivWrap) { //create wrapper div if needed - see docs below
                cell = cell.cn = {
                    tag: 'div'
                };
            }

            me.configureItem(item);
            // The DomHelper config of the item is the cell's sole child
            cell.cn = item.getRenderTree();
        }
        return result;
    },

    isValidParent: function(item, target, rowIdx, cellIdx) {
        var tbody,
            correctCell,
            table;

        // If we were called with the 3 arg signature just check that the parent table of the item is within the render target
        if (arguments.length === 3) {
            table = item.el.up('table');
            return table && table.dom.parentNode === target.dom;
        }
        tbody = this.owner.getTargetEl().child('table', true).tBodies[0];
        correctCell = tbody.rows[rowIdx].cells[cellIdx];
        return item.el.dom.parentNode === correctCell;
    },

    /**
     * @private
     * Opera 10.5 has a bug where if a table cell's child has box-sizing:border-box and padding, it
     * will include that padding in the size of the cell, making it always larger than the
     * shrink-wrapped size of its contents. To get around this we have to wrap the contents in a div
     * and then set that div's width to match the item rendered within it afterLayout. This method
     * determines whether we need the wrapper div; it currently does a straight UA sniff as this bug
     * seems isolated to just Opera 10.5, but feature detection could be added here if needed.
     */
    needsDivWrap: function() {
        return true;//Ext.isOpera10_5;
    }
});//@charset UTF-8
/**
 * Unilite용 Abstract Form
 */
 Ext.define('Unilite.com.form.UniAbstractForm', {
	extend : 'Ext.form.Panel',
	requires: [
		'Ext.ux.DataTip'
	],
	deferredRender : true,
	border : false,
	padding : '5 5 0 5',
	width : '100%',
	defaultType : 'uniTextfield',
	autoScroll:true,
	paramsAsHash: true, //
	activeRecord: null,
	fieldDefaults : {
		msgTarget : 'qtip',
		labelAlign : 'right',
		blankText : '값을 입력해 주세요!',
		labelWidth : 90,
		//width:250,
		labelSeparator : "",
	    validateOnChange: false,
        autoFitErrors: true   //false  //화면 깨짐 
	},
	uniOpt: {
		inLoading : false
	},
	plugins: {
        ptype: 'datatip'
    },
	initComponent: function(){
		
		this.addEvents('uniOnChange');
        this.callParent();
	},
	/**
	 * 폼의 모든 항목을 
	 * readOnly 
	 *   : true -> 읽기 전용으로
	 *   : false ->  원상복원
	 * @param {} readOnly
	 */
	setReadOnly: function(readOnly) {
		var frm = me.getForm();
		var fields = frm.getFields( );
		for(var i = 0, len = fields.length; i < len; i ++) {
			var field = fields.getAt(i);
			if(readOnly) {
				field.rawReadOnly2 = field.readOnly;
				field.setReadOnly(readOnly);
			} else {
				if(Ext.isDefined(field.rawReadOnly2)) {
					field.setReadOnly(field.rawReadOnly2);
				} else {
					field.setReadOnly(readOnly);
				}
			}
		}
	},
	/**
	 * 폼값 reset
	 */
	reset: function() {
		this.uniOpt.inLoading = true;
		var frm = this.getForm().reset(true);
		this.uniOpt.inLoading = false;
	},
 	/**
 	 * 편집 record를 지정 
 	 * 내부적으로 loadrecord를 호출 함.
 	 * @param {} record
 	 */
	setActiveRecord: function(record) {
		var me = this;
		me.uniOpt.inLoading = true;
		//Ext.suspendLayouts();
		//console.log("setActiveRecord0 : " , record);
		me.activeRecord = record;
		if (record) {
		 	var frm = me.getForm();
		 	frm.clearInvalid( );
			var fields = frm.getFields( );
			for(var i = 0, len = fields.length; i < len; i ++) {
				var field = fields.getAt(i);
				field.uniChanged = false;
			}
			for(var i = 0, len = record.fields.length; i < len; i ++) {
				var column = record.fields.getAt(i);
				var field = me.getField(column.name);
				if(field) {
					if(column.isPk ) {
						if(!Ext.isDefined(field.rawReadOnly)) {
							field.rawReadOnly = field.readOnly;
						}
						var lReadonly = true;
						// 신규 건이고 kgen 
						if( record.phantom && column.pkGen && column.pkGen == 'user' ) {
							lReadonly = false;
						}
						field.setReadOnly(lReadonly);
					}
					//console.log(column.name + '  readonly= ' + field.readOnly + ', rawReadOnly= ' + field.rawReadOnly, record.get(column.name) );
					//me.setValue(column.name, record.get(column.name), true)
				}
			}
			//console.log(me.id+">setActiveRecord: is dirty =",frm.isDirty( ) , record.getData());
		 	
            frm.loadRecord(record);
			frm._record = record;
            

			
		 	me.setDisabled( false );
         } else {
         	me.setDisabled( true );
         }
         
		 //Ext.resumeLayouts(true);
		me.uniOpt.inLoading = false;
  		
	},
	/**
	 * values{object} 는 JSON object이며
	 * onChange 이벤트 발생 시킴
	 */
	setValues:function(values) {
		return this.getForm().setValues(values);
	},
	// onChange 발생 안시킴.
	setValue:function(name, value, silent) {
		var mSilent = Ext.isDefined(silent) ? silent : true;
		var valueObj = {};
		valueObj[name] = value;
		var rv = null;
		
		var field = this.getField(name);
		if(!field) {
			var fields = this.getForm().getFields();
			
			console.log("Field [" + name + "] not found!", fields);
			return null;
		}
		if(mSilent ) {
			field.suspendEvents(false);
		}
		if(field.xtype == 'uniRadiogroup') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(valueObj);
			//rv= field.setRawValue(valueObj);// date타입으로 값이 저장 되어 화면에 포맷을 따르지 않게됨 2013/12/11
		} else if(field.xtype == 'uniCombobox') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(value);
			//rv= field.select(value);
			//rv= field.setRawValue(valueObj);
		} else if(field.xtype == 'uniDatefield') {
			rv= field.setValue(value);
		} else if(field.xtype == 'uniTimefield') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(UniDate.extSafeParse(field.initDate + ' ' + value,field.initDateFormat + ' Hi'));
			//rv= field.setRawValue(valueObj);	 
		} else if(field.xtype == 'uniCheckboxgroup') {
			console.log('xtype:', field.xtype,'>', valueObj);
			var valueObjA = {};
			if(Ext.isArray(value)) {
				
				valueObjA[name+'[]'] = value;
			} else {
				var t= new Array();
				t.push(value);
				valueObjA[name+'[]'] = t;
			}
			
			console.log("uniCheckboxgroup:", valueObjA)
			rv= field.setValue(valueObjA);
			//rv= field.setRawValue(valueObjA);
		} else {
			//console.log('xtype:', field.xtype,'>', valueObj);
			// rv= this.getForm().setValues(valueObj);
			//rv= field.setRawValue(value);
			rv= field.setValue(value);
		}
		if (this.trackResetOnLoad) {
			//2014.11.11 modified
			//setValue 에서는 orignalValue 를 reset 안함. (isDirty() 체크 클 위해)
			//loadRecord, setValues 에서는 extjs가 trackResetOnLoad 가 true 인 경우 각 필드의 resetOriginalValue()를 수행함.
            
			//field.resetOriginalValue();
         }
		if(mSilent ) {
			field.resumeEvents();
		}
		return rv;
	},
	getValue: function(name) {
		var field = this.getField(name);
		
		if(field) {
			return field.getValue();
		} else {
			return null;
		}
	},
	// id나 name으로 조회 
	getField: function(name) {
		/*
		var fields = this.getForm().getFields();
		fields.each(function(f) {
			if(field instanceof Ext.form.field.Field ) {
					console.log(f);
			}
		})
		*/
		return this.getForm().findField(name);//
	},
	/**
	 * 값이 변경 되었는지 확인
	 * 
	 * @return {boolean}
	 * true : load후 변경됨
	 * false : load후 변경된 내용 없음.
	 */
	isDirty: function() {
		return this.getForm().isDirty();
	},
	/**
	 * 주어진 필드값들 중 빈 값이 있는지 확인
	 * fieldNames = array()
	 * @param {} fieldNames
	 * 
	 * @return {boolean}
	 */
	checkManadatory: function(fieldNames) {
		var rv = true,   frm = this.getForm();
		
		for(var i = 0, len=fieldNames.length; i < len; i ++) {
			var field = frm.findField(fieldNames[i]); 
			var value = field.getSubmitValue()
			if(Ext.isEmpty(value)) {
				return field;
			}
		}
		return rv;
	},
	_onAfterRenderFunction: function(form, rOpts) {
		var me = form;
		var fields = me.getForm().getFields( );
		if(me.masterGrid) {
			me.masterGrid.addChildForm(me);
		}
		for(var i = 0, len=fields.length; i < len; i ++) {
			me._onFieldAddFunction(form, fields.getAt(i), i);
		}
		// console.log('detail form is rendering. ' + fields.length + ' items');
	} ,
	// 필드가 추가 될때 unilite를 위한 추가 기능을 등록 한다.
	_onFieldAddFunction : function(form, field, index ){		
			// console.log(form.id +"-" + index + " field added : " , field);
			if( field.isFormField ) {
				if(Ext.isFunction(field.setOwnerForm)) {
					field.setOwnerForm( form );
				}
	      		
	      		/**
	             * @event uniOnChange
	             * // VB의 onChange와 같이 onBLur시 변경된 값이 있을 경우 발생
	             * @param field 
	             * @param newValue
	             * @param oldValue
	             */
				field.addEvents('uniOnChange');
	        	field.on('change', form._onFieldChangedFunction, this);
	        	
	        	// radio, checkbox등은 focus를 가지지 않음 !!
        		//field.on('focus',function( field, The, eOpts ) {console.log("gotFocus : ", field); } , this);
	        	
	        	if ('radiogroup' == field.ariaRole || 'group' == field.ariaRole )  {
					// radiogroup / change( this, newValue, oldValue, eOpts )13
					// checkboxgroup // change( this, newValue, oldValue, eOpts )13
					field.on('change', function(field, newValue, oldValue, eOpts) {
							console.log('radiogroup change');
							form._onFieldBlurFunction('change',field, newValue);
					}, this );
				}else if ('radio' == field.ariaRole || 'checkbox' == field.ariaRole)  {
					
				} else {
					// blur( this, The, eOpts )
					field.on('blur', function(field, The, eOpts) {
							form._onFieldBlurFunction('blur',field);
						}, this );
				}
                if(Ext.isDefined(field.allowBlank) && ! field.allowBlank ) {
                    if(field.isPopupField) {
                        if(field.popupField) {
                            field.popupField.labelClsExtra = 'required_field_label';
                        }
                    } else {
                        field.labelClsExtra = 'required_field_label';
                    }
                }
				if(field.readOnly) {
					field.tabIndex = -1;
				}
				var opt = field.uniOpt || {};
				field.uniOpt = opt;
	        	
	      }
	      return true;
	},
	
	// 수정 되었는지 표시 
	_onFieldChangedFunction:function(field, newValue, oldValue, eOpts) {
		var me = this;
		//console.log ( field.fieldLabel,"(",field.name, ")",'_onFieldChangedFunc (oldValue => newValue)', oldValue, "=>" , newValue);
		if(!me.uniOpt.inLoading) {
			field.uniChanged = true;
			field.uniOpt.oldValue = oldValue;
		}
	},
		/**
	 * Clear all field's value 
	 * % The reset() method just resets the form back to the last record loaded.
	 */
	clearForm:function(){
	     Ext.each(this.getForm().getFields().items, function(field){
	            field.setValue('');
	     });
	 },
	
	_onFieldBlurFunction:function(type, field, newValue) {
		var me = this;
		// change event가 모든 상황에서 발생하는것이 아니라 uniChange가 제대로 반영 되지 않음.
		// 그래서 isDirty로 변경함. 2013/12/19
		//if(! me.uniOpt.inLoading && (field.uniChanged == true || type == 'change')) {
		
		//2014.11.11 modified. - isDirty 체크를 위해 위의 setValue() 함수내에서 orignalValue를 reset 하지 않도록 수정.
		if(! me.uniOpt.inLoading && (field.uniChanged || field.isDirty() || type == 'change')) {
			var rec = this.activeRecord; //this.getRecord();
			var form = this.getForm();
			
			if(rec) {
				console.log ( "update record.field value change detected on ", field.name);
				form.updateRecord(rec);	//form의 내용을 rec에 write 함.
			}
			var mNewVal = null;
			if(Ext.isDefined(newValue)) {
				mNewVal = newValue;
			} else {
				if('radiogroup' == field.ariaRole ) {
					mNewVal = {};
					mNewVal[field.name] =  field.getValue();
				} else if( 'radio' == field.ariaRole ) {
					mNewVal = {};
					mNewVal[field.name] =  field.getValue();
				} else {
					mNewVal = field.getValue();
				}
			}
			
			field.fireEvent( 'uniOnChange',  field, mNewVal, field.uniOpt.oldValue  ) ;
			// me = Form
			me.fireEvent( 'uniOnChange',  me, field, mNewVal, field.uniOpt.oldValue  ) ;
			field.uniChanged = false;
		};
	},
	
	/**
	 * Save 나 reset후 form의 상태를 초기상태로 변경함 
	 * - trackResetOnLoad:true 로 했을 경우 저장후 상태가 reset 안되는 현상이 있어 이를 호출 해야함.
	 */
	resetDirtyStatus: function() {
		var me = this;
		//var form = this.getForm();
		var items = me.getForm().getFields().items,
		    i = 0,
		    len = items.length;
		for(; i < len; i++) {
		    var c = items[i];
		    //c.value = '';
		    if(c.mixins && c.mixins.field && typeof c.mixins.field['initValue'] == 'function'){
		        c.mixins.field.initValue.apply(c);
		        c.wasDirty = false;
		    }
		}
		me.getForm().wasDirty = false;	
	}
});//@charset UTF-8
Ext.define('Unilite.com.form.UniSearchForm', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniSearchForm',
	defaultType : 'uniTextfield',
	autoScroll:false,
	
	defaults : {
		listeners: {
			specialkey: function(field, e){
				// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
                // e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
//                if (e.getKey() == e.ENTER) {
//					console.log("keyDown");
//					var app = UniAppManager.getApp();
//                	app.onQueryButtonDown();
//                }
			}
		}
	},
    enableKeyEvents: true,
	initComponent : function(){  
    	var me  = this;
    	  	
        me.on('beforerender',this._onAfterRenderFunction , this);
    	me.callParent();
	}
});// @charset UTF-8
Ext.define('Unilite.com.form.UniSearchSubPanel', {
			extend : 'Ext.panel.Panel',
			alias : 'widget.uniSearchSubPanel',
			defaultType : 'uniTextfield',
			collapsible : true,
			titleCollapse : true,
			hideCollapseTool : true,
            cls: 'uniSearchSubPanel',
			bodyStyle : {
				'border-width' : '0px',
				'spacing-bottom' : '3px'
			},
			header : {
				xtype : 'header',
				style : {
					'background-color' : '#D9E7F8',
					'background-image' : 'none',
					'color' : '#333333',
					'font-weight' : 'normal',
					'border-width' : '0px',
					'spacing' : '5px'
				}
			}
		});

Ext.define('Unilite.human.ImageListPanel', {
	extend : 'Ext.view.View',
	alias : 'widget.humImageListPanel',
    tpl: [
            '<tpl for=".">',
                '<div class="thumb-wrap">',
                    '<div class="thumb"><img src="'+CPATH+'/uploads/employeePhoto/{PERSON_NUMB}?_dc={dc}" title="{NAME:htmlEncode}" width="100"></div>',
                    '<span class="x-editable">{NAME:htmlEncode}</span>',
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
        ],        
//        this.down('#EmpImg').getEl().dom.src=CPATH+'/human/viewPhoto.do?personNumb='+data['PERSON_NUMB'];
        trackOver: true,
        frame:true,
        overItemCls: 'x-item-over',
        itemSelector: 'div.thumb-wrap',
        emptyText: 'No images to display'
});
//@charset UTF-8
Ext.define('Unilite.com.form.UniSearchPanel', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniSearchPanel',
	defaultType : 'uniTextfield',
	autoScroll:false,
    region:'west', 
    padding: '1 1 1 1',
    split:{size: 0.5},
    width:350,
    border: true,
    collapsible: false, 
    autoScroll:true,
    collapseDirection: 'left',
    layout: {type: 'vbox', align:'stretch'},
    
	constructor: function(config) {
        var me = this;
        config = config || {};
        //config.trackResetOnLoad = true;
        
        var clapseTool= {
	        region:'west',
	        type: 'left',   
	        itemId:'left',
	        tooltip: 'Hide',
	        handler: function(event, toolEl, panelHeader) {
	                    me.collapse(); 
	                }
	        };
	    config.tools=[clapseTool];
        me.callParent([config]);
    },
	defaults : {
		listeners: {
			specialkey: function(field, e){
				// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
                // e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
//                if (e.getKey() == e.ENTER) {
//					console.log("keyDown");
//					var app = UniAppManager.getApp();
//                	app.onQueryButtonDown();
//                }
			}
		}
	},
    enableKeyEvents: true,
	initComponent : function(){  
    	var me  = this;
    	  	
        me.on('beforerender',this._onAfterRenderFunction , this);
                
        if(UserInfo && UserInfo.appOption) {	//설정 메뉴->검색창 접기 설정값 적용
    		Ext.apply(me, {
	        	collapsed: UserInfo.appOption.collapseLeftSearch
	        })
    	}
    	
    	me.callParent();
	},
	
	setAllFieldsReadOnly: function(flag) {
		var r= true
		if(flag) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}

			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			} else {
				//this.mask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;							
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})
			}
  		} else {
			//this.unmask();
  			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(false); 
					}
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;	
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
		}
		return r;
  	},
  	
  	saveForm: function()	{
  		var me = this;
		var paramMaster = me.getValues();
		me.getForm().submit({
		    
		    success:function()	{
	    		me.getForm().wasDirty = false;
				me.resetDirtyStatus();
				console.log("set was dirty to false");
				UniAppManager.setToolbarButtons('save', false);		
		    }
		})
	}
});

//@charset UTF-8
Ext.define('Unilite.com.form.UniOperatePanel', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniOperatePanel',
	defaultType : 'uniTextfield',
	autoScroll:false,
    region:'east', 
    padding: '1 1 1 1',
    split:{size: 0.5},
    width:350,
    border: true,
    collapsible: false, 
    autoScroll:true,
    collapseDirection: 'right',
    layout: {type: 'vbox', align:'stretch'},
    
	constructor: function(config) {
        var me = this;
        config = config || {};
        //config.trackResetOnLoad = true;
        
        var clapseTool= {
	        region:'west',
	        type: 'right',   
	        itemId:'left',
	        tooltip: 'Hide',
	        handler: function(event, toolEl, panelHeader) {
	                    me.collapse(); 
	                }
	        };
	    config.tools=[clapseTool];
        me.callParent([config]);
    },
	defaults : {
		listeners: {
			specialkey: function(field, e){
				// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
                // e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
//                if (e.getKey() == e.ENTER) {
//					console.log("keyDown");
//					var app = UniAppManager.getApp();
//                	app.onQueryButtonDown();
//                }
			}
		}
	},
    enableKeyEvents: true,
	initComponent : function(){  
    	var me  = this;
    	  	
        me.on('beforerender',this._onAfterRenderFunction , this);
    	me.callParent();
	},
	
	setAllFieldsReadOnly: function(flag) {
		var r= true
		if(flag) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}

			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			} else {
				//this.mask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;							
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})
			}
  		} else {
			//this.unmask();
  			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(false); 
					}
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;	
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
		}
		return r;
  	},
  	
  	saveForm: function()	{
  		var me = this;
		var paramMaster = me.getValues();
		me.getForm().submit({
		    
		    success:function()	{
	    		me.getForm().wasDirty = false;
				me.resetDirtyStatus();
				console.log("set was dirty to false");
				UniAppManager.setToolbarButtons('save', false);		
		    }
		})
	}
});

Ext.define('Unilite.com.form.UniFieldSet', {
    extend: 'Ext.form.FieldSet',
    alias: 'widget.uniFieldset',
    fieldDefaults : {
		msgTarget : 'side',
		labelAlign : 'right',
		labelWidth : 80,
		labelSeparator : ""
	},
	defaultType : 'uniTextfield'
});// define//@charset UTF-8
/**
 * 기본 상세 폼
 * 
 * Unilite.createForm을 통해 생성 함{@link Unilite#createForm}
 * 
 */
Ext.define('Unilite.com.form.UniDetailForm', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniDetailForm',

	collapsible : false,
	//formBind: true,		// true로 form 안에 grid가 disabled되는 경우 발생 
    trackResetOnLoad: true,
	autoScroll:true,
	disabled :true,
  	constructor: function(config) {
  		var me = this;
  		config = config || {};
	    config.trackResetOnLoad = true;
	    me.callParent([config]);
  	},  	
  	initComponent: function(){
  		
  		var me = this;
  		
  		console.log("uniDetailForm " + this.id + " init.");
       // this.on('afterrender',this._onAfterRenderFunction , this);
  		// form을 그리기 전에 fields 기본값 처리 
        this.on('beforerender',this._onAfterRenderFunction , this);
        //this.on('add',this._onFieldAddFunction , this); // 손자 이하의 field의 추가에 대해 반응 하지 않음.
  		console.log("uniDetailForm : " + this.id + " init End.");
        this.callParent();
	},

	beforeRender : function() {
		/*
		if (!this.allowBlank) {
			this.labelStyle = 'color:#FF0000';
		}

		if (this.readOnly) {
			this.fieldCls = 'readOnlyClass';
		}
		*/
		this.callParent();
	}
	
});//@charset UTF-8
/**
 * Grid 없이 단독 으로 사용 되는 폼.
 */
Ext.define('Unilite.com.form.UniDetailFormSimple', {
	extend : 'Unilite.com.form.UniDetailForm',
	alias : 'widget.uniDetailFormSimple',
	margin: '1 0 0 1',
	padding: '0 0 0 0 ',
	collapsible : false,
    trackResetOnLoad: true,
	autoScroll:true,
  	constructor: function(config) {
  		var me = this;
  		config = config || {};
	    config.trackResetOnLoad = true;
	    me.callParent([config]);
  	},
  	disabled :false
});//@charset UTF-8
/**
 * 초기값 설정 방법 : 
 * 1. 각 값으로 설정
 *   value : ['A1','B1']
 * 2. 모두 checked로 시작  
 *   initAllTrue : true
 * 
 */
Ext.define('Unilite.com.form.UniCheckboxgroup', {
    extend: 'Ext.form.CheckboxGroup',
    alias: 'widget.uniCheckboxgroup',
    comboType: '',
    comboCode: '',
    values:[],
    initAllTrue: false,
	initComponent: function () {		
		var me = this;
		this.callParent();
		if(!Ext.isEmpty(me.comboType) && !Ext.isEmpty(me.comboCode)) {
			if (typeof me.store === "undefined") {
				var mstore = me._getStore();
		 		Ext.apply(this, {
		            store: mstore
		        });
		        mstore.on('load', me.handler_StoreLoad, this);
		        me.handler_StoreLoad(me.store);
		 	} else {
		 		me.handler_StoreLoad(me.store);
		 	}
		}
	},
	 setReadOnly: function(readOnly) {
        var boxes = this.getBoxes(),
            b,
            bLen  = boxes.length;

        for (b = 0; b < bLen; b++) {
        	boxes[b].readOnlyCls = 'uniCheckBoxReadonly';
            boxes[b].setReadOnly(readOnly);
        }

        this.readOnly = readOnly;
    },
	handler_StoreLoad: function (store, mRecords, successful, options) {
		var records = store.data.items;
		if(records) {
			var items = [];
			for( var i=0, j=records.length; i<j; i++ ){		
				var item ;
		 		if (this.initAllTrue || Ext.Array.contains(this.values,records[i].get('value') )) {
		 			item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: this.name+'[]',
		            		checked : true
	            		};
            	} else {
            		item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: this.name+'[]'
	            		};
            	}
            	
            	//console.log(item);
		 		items.push(item);
			}
			this.add( items);
		}
	} ,
    // private
    _getStore:function() {
    	var storeId = "CBS_"+this.comboType+"_"+this.comboCode;
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	console.log('_getStore : ', storeId, mStore);
    	if ( ! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		mStore= Ext.create('Ext.data.Store', { 
		        autoLoad: true, 
		        fields: ['value', 'text'],
		        sorters: [{
			        property: 'value',
			        direction: 'ASC' // or 'ASC'
			    }],
		        proxy: { 
		            type: 'ajax', 
		            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode
		        } 
		    } );
    	}
	 	return mStore;
    }
     
});
//@charset UTF-8
/**
 * 초기값 설정 방법
 * value: 'value'
 */
Ext.define('Unilite.com.form.UniRadiogroup', {
    extend: 'Ext.form.RadioGroup',
    alias: 'widget.uniRadiogroup',
    name:'',
    comboType: '',
    comboCode: '',
    curValue: '',
    validateOnChange:true,
	initComponent: function () {		
		var me = this;
		this.callParent();
		if(!Ext.isEmpty(me.comboType) && !Ext.isEmpty(me.comboCode)) {
			if (typeof me.store === "undefined") {
				var mstore = me._getStore();
		 		Ext.apply(this, {
		            store: mstore
		        });
		        mstore.on('load', me.handler_StoreLoad, this);
		        me.handler_StoreLoad(me.store);
		 	} else {
		 		me.handler_StoreLoad(me.store);
		 	}
		}
	},
	 setReadOnly: function(readOnly) {
        var boxes = this.getBoxes(),
            b,
            bLen  = boxes.length;

        for (b = 0; b < bLen; b++) {
        	boxes[b].readOnlyCls = 'uniRadioReadonly';
            boxes[b].setReadOnly(readOnly);
        }

        this.readOnly = readOnly;
    },
	/**
	 * http://www.sencha.com/forum/showthread.php?187185-Set-a-int-value-on-a-radiogroup-fails&p=986333#post986333
	 * to solve loadRecord
	 * @param {} value
	 */
	setValue: function (value) {
	    if (!Ext.isObject(value)) {
	        var obj = new Object();
	        obj[this.name] = value;
	        value = obj;
	    }
	    Ext.form.RadioGroup.prototype.setValue.call(this, value);
	} ,
	// validate 함수를 타기 위해 변경 (Ext.form.CheckboxGroup)
	getErrors: function() {
		var me = this;
        var errors = [];
        var validator = me.validator;
        if (Ext.isFunction(validator)) {
            msg = validator.call(me, me.value);
            if (msg !== true) {
                errors.push(msg);
            }
        }
        if (!this.allowBlank && Ext.isEmpty(this.getChecked())) {
            errors.push(this.blankText);
        }
        return errors;
    },
	handler_StoreLoad: function (store, mRecords, successful, options) {
		var records = store.data.items, fieldName = this.name;
		//console.log("fieldName:", fieldName, "records:", records);
		//this.removeAll();
		if(store.count() > 0 ) {
			var items = [];		
			if(this.allowBlank) {
				items.push({ boxLabel: '전체' , inputValue: '' , name: fieldName, checked : true});
		 	};	
			for( var i=0, j=records.length; i<j; i++ ){			 		
		 		var item ;
		 		if (this.value == records[i].get('value') ) {
		 			var t = (this.allowBlank) ? false:true;
		 			item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: fieldName,
		            		checked : t
	            		};
            	} else {
            		item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: fieldName
	            		};
            	}
            	
            	//console.log(item);
		 		items.push(item);
			}
			//console.log("done");
			this.add( items);
		 	
		}
	} ,
    // private
    _getStore:function() {
    	var storeId = "CBS_"+this.comboType+"_"+this.comboCode;
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	console.log('_getStore : ', storeId, mStore);
    	if ( ! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		mStore= Ext.create('Ext.data.Store', { 
		        autoLoad: true, 
		        fields: ['value', 'text'],
		        sorters: [{
			        property: 'value',
			        direction: 'ASC' // or 'ASC'
			    }],
		        proxy: { 
		            type: 'ajax', 
		            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode
		        } 
		    } );
    	}
	 	return mStore;
    }
});
//@charset UTF-8

// 자리 차지 하는 hide 기능 추가 
Ext.define('Ext.overide.form.field.Base', {
    override: 'Ext.form.field.Base',
    //selectOnFocus: true,
    initComponent : function() {
    	this.callParent(arguments);
    	
    	//focus 이동 처리
    	this.on('specialkey', function(elm, e){
    		switch( e.getKey() ) {
                case Ext.EventObject.ENTER:
                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
                		Unilite.focusPrevField(elm, false, e);
                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
                		Unilite.focusNextField(elm, false, e);
                	}
                	break;
                case Ext.EventObject.LEFT:
	            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
	            	var pos = elm.getCaretPosition(elm);
	            	if(pos < 1) {
	            		Unilite.focusPrevField(elm, false, e);
	            	}
	            	break;
	            case Ext.EventObject.RIGHT:
	            	//console.log('getCaretPosition()->' + elm.getCaretPosition(elm));
	            	var pos = elm.getCaretPosition(elm);
	            	var len = 0;
	            	if(Ext.isFunction(elm.getRawValue)) {
	            		len = (Ext.isEmpty(elm.getRawValue()) ? 0 : (typeof(elm.getRawValue()) === "string" ?  elm.getRawValue().length : 0));
	            	}
	            	if(pos >= len) {
	            		Unilite.focusNextField(elm, false, e);
	            	}
	            	break;	
      		}      		
    	});
    },
    getCaretPosition: function(obj) {
        var el = obj.inputEl.dom;
        if (typeof(el.selectionStart) === "number") {
            return el.selectionStart;
        } else if (document.selection && el.createTextRange){
            var range = document.selection.createRange();
            range.collapse(true);
            range.moveStart("character", -el.value.length);
            return range.text.length;
        } else {
            //throw 'getCaretPosition() not supported';
        	return 0;
        }
    },
    /**
     * 자리는 차지하되 보이지 않게.
     * el의 setDisplayed 역활이나 그려지지 않은 상황 에서도 적용됨.
     * @param {} visible
     */
    uniSetDisplayed: function(visible) {
    	var el = this.getEl();
    	
    	if( el ) { 
    		el.setDisplayed(visible);
    	} else {
    		var newStyle = (visible) ?  {display: 'inline'} :  {display: 'none'};
    		if(  this.style == undefined ) {
                this.style =  newStyle
    		} else {
            	 Ext.apply(this.style, newStyle);
            }
    	}
    }
    
});
/**
 * unilite용 form field의 기저 정의 
 */
Ext.define('Unilite.com.form.field.UniBaseField', {
	/**
     * @property {Unilite.com.form.UniAbstractForm} ownerForm
     * 
     * @readonly
     */
	ownerForm: null,
	setOwnerForm: function(form ) {
		//console.log('set');
		this.ownerForm = form;
	},
	/**
	 * 에러메시지 표시하지 않게 변경함.
	 * @overide
	 * @param {} active
	 */
	setError: function(active){
        var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, active || '');
            } else {
                //me.updateLayout();
            }
        }
    }
}); // define//@charset UTF-8
/*
 * @class Ext.ux.form.field.ClearButton
 *
 * Plugin for text components that shows a "clear" button over the text field.
 * When the button is clicked the text field is set empty.
 * Icon image and positioning can be controlled using CSS.
 * Works with Ext.form.field.Text, Ext.form.field.TextArea, Ext.form.field.ComboBox and Ext.form.field.Date.
 *
 * Plugin alias is 'clearbutton' (use "plugins: 'clearbutton'" in GridPanel config).
 *
 * @author <a href="mailto:stephen.friedrich@fortis-it.de">Stephen Friedrich</a>
 * @author <a href="mailto:fabian.urban@fortis-it.de">Fabian Urban</a>
 *
 * @ copyright (c) 2011 Fortis IT Services GmbH
 * @ license Ext.ux.form.field.ClearButton is released under the
 * <a target="_blank" href="http://www.apache.org/licenses/LICENSE-2.0">Apache License, Version 2.0</a>.
 *
 */
 /**
  * Ext.ux.form.field.ClearButton 을 가져와 확장 
  * 배경 없는 버튼
  */
Ext.define('Unilite.com.form.field.UniClearButton', {
    alias: 'plugin.uniClearbutton',

    /**
     * @cfg {Boolean} hideClearButtonWhenEmpty
     * Hide the clear button when the field is empty (default: true).
     */
    hideClearButtonWhenEmpty: true, // true

    /**
     * @cfg {Boolean} hideClearButtonWhenMouseOut
     * Hide the clear button until the mouse is over the field (default: true).
     */
    hideClearButtonWhenMouseOut: true,

    /**
     * @cfg {Boolean} When the clear buttons is hidden/shown, this will animate the button to its new state (using opacity) (default: true).
     */
    animateClearButton: true,

    /**
     * @cfg {Boolean} Empty the text field when ESC is pressed while the text field is focused.
     */
    clearOnEscape: false,

    /**
     * @cfg {String} CSS class used for the button div.
     * Also used as a prefix for other classes (suffixes: '-mouse-over-input', '-mouse-over-button', '-mouse-down', '-on', '-off')
     */
    clearButtonCls: 'ext-ux-clearbutton',

    /**
     * The text field (or text area, combo box, date field) that we are attached to
     */
    textField: null,

    /**
     * Will be set to true if animateClearButton is true and the browser supports CSS 3 transitions
     * @private
     */
    animateWithCss3: false,

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Set up and tear down
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    constructor: function(cfg) {
        Ext.apply(this, cfg);

        this.callParent(arguments);
    },

    /**
     * Called by plug-in system to initialize the plugin for a specific text field (or text area, combo box, date field).
     * Most all the setup is delayed until the component is rendered.
     */
    init: function(textField) {
        this.textField = textField;
        if (!textField.rendered) {
            textField.on('afterrender', this.handleAfterRender, this);
        }
        else {
            // probably an existing input element transformed to extjs field
            this.handleAfterRender();
        }
    },

    /**
     * After the field has been rendered sets up the plugin (create the Element for the clear button, attach listeners).
     * @private
     */
    handleAfterRender: function(textField) {
        this.isTextArea = (this.textField.inputEl.dom.type.toLowerCase() == 'textarea');

        this.createClearButtonEl();
        this.addListeners();

        this.repositionClearButton();
        this.updateClearButtonVisibility();

        this.addEscListener();
    },

    /**
     * Creates the Element and DOM for the clear button
     */
    createClearButtonEl: function() {
        var animateWithClass = this.animateClearButton && this.animateWithCss3;
        /*
          
         this.clearButtonEl = this.textField.bodyEl.createChild({
            tag: 'div',
            cls: this.clearButtonCls
        });
        */
        this.clearButtonEl = this.textField.bodyEl.createChild({
            tag: 'div',
            cls: this.clearButtonCls
        });
        if(this.animateClearButton) {
            this.animateWithCss3 = this.supportsCssTransition(this.clearButtonEl);
        }
        if(this.animateWithCss3) {
            this.clearButtonEl.addCls(this.clearButtonCls + '-off');
        }
        else {
            this.clearButtonEl.setStyle('visibility', 'hidden');
        }
    },

    /**
     * Returns true iff the browser supports CSS 3 transitions
     * @param el an element that is checked for support of the "transition" CSS property (considering any
     *           vendor prefixes)
     */
    supportsCssTransition: function(el) {
        var styles = ['transitionProperty', 'WebkitTransitionProperty', 'MozTransitionProperty',
                      'OTransitionProperty', 'msTransitionProperty', 'KhtmlTransitionProperty'];

        var style = el.dom.style;
        for(var i = 0, length = styles.length; i < length; ++i) {
            if(style[styles[i]] !== 'undefined') {
                // Supported property will result in empty string
                return true;
            }
        }
        return false;
    },

    /**
     * If config option "clearOnEscape" is true, then add a key listener that will clear this field
     */
    addEscListener: function() {
        if (!this.clearOnEscape) {
            return;
        }

        // Using a KeyMap did not work: ESC is swallowed by combo box and date field before it reaches our own KeyMap
        this.textField.inputEl.on('keydown',
            function(e) {
                if (e.getKey() == Ext.EventObject.ESC) {
                    if (this.textField.isExpanded) {
                        // Let combo box or date field first remove the popup
                        return;
                    }
                    // No idea why the defer is necessary, but otherwise the call to setValue('') is ignored
                    Ext.Function.defer(this.textField.setValue, 1, this.textField, ['']);
                    e.stopEvent();
                }
            },
            this);
    },

    /**
     * Adds listeners to the field, its input element and the clear button to handle resizing, mouse over/out events, click events etc.
     */
    addListeners: function() {
        // listeners on input element (DOM/El level)
        var textField = this.textField;
        var bodyEl = textField.bodyEl;
        bodyEl.on('mouseover', this.handleMouseOverInputField, this);
        bodyEl.on('mouseout', this.handleMouseOutOfInputField, this);

        // listeners on text field (component level)
        textField.on('destroy', this.handleDestroy, this);
        textField.on('resize', this.repositionClearButton, this);
        textField.on('change', function() {
            this.repositionClearButton();
            this.updateClearButtonVisibility();
        }, this);

        // listeners on clear button (DOM/El level)
        var clearButtonEl = this.clearButtonEl;
        clearButtonEl.on('mouseover', this.handleMouseOverClearButton, this);
        clearButtonEl.on('mouseout', this.handleMouseOutOfClearButton, this);
        clearButtonEl.on('mousedown', this.handleMouseDownOnClearButton, this);
        clearButtonEl.on('mouseup', this.handleMouseUpOnClearButton, this);
        clearButtonEl.on('click', this.handleMouseClickOnClearButton, this);
    },

    /**
     * When the field is destroyed, we also need to destroy the clear button Element to prevent memory leaks.
     */
    handleDestroy: function() {
        this.clearButtonEl.destroy();
    },

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Mouse event handlers
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Tada - the real action: If user left clicked on the clear button, then empty the field
     */
    handleMouseClickOnClearButton: function(event, htmlElement, object) {
        if (!this.isLeftButton(event)) {
            return;
        }
        this.textField.setValue('');
        this.textField.focus();
    },

    handleMouseOverInputField: function(event, htmlElement, object) {
        this.clearButtonEl.addCls(this.clearButtonCls + '-mouse-over-input');
        if (event.getRelatedTarget() == this.clearButtonEl.dom) {
            // Moused moved to clear button and will generate another mouse event there.
            // Handle it here to avoid duplicate updates (else animation will break)
            this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-over-button');
            this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-down');
        }
        this.updateClearButtonVisibility();
    },

    handleMouseOutOfInputField: function(event, htmlElement, object) {
        this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-over-input');
        if (event.getRelatedTarget() == this.clearButtonEl.dom) {
            // Moused moved from clear button and will generate another mouse event there.
            // Handle it here to avoid duplicate updates (else animation will break)
            this.clearButtonEl.addCls(this.clearButtonCls + '-mouse-over-button');
        }
        this.updateClearButtonVisibility();
    },

    handleMouseOverClearButton: function(event, htmlElement, object) {
        event.stopEvent();
        if (this.textField.bodyEl.contains(event.getRelatedTarget())) {
            // has been handled in handleMouseOutOfInputField() to prevent double update
            return;
        }
        this.clearButtonEl.addCls(this.clearButtonCls + '-mouse-over-button');
        this.updateClearButtonVisibility();
    },

    handleMouseOutOfClearButton: function(event, htmlElement, object) {
        event.stopEvent();
        if (this.textField.bodyEl.contains(event.getRelatedTarget())) {
            // will be handled in handleMouseOverInputField() to prevent double update
            return;
        }
        this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-over-button');
        this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-down');
        this.updateClearButtonVisibility();
    },

    handleMouseDownOnClearButton: function(event, htmlElement, object) {
        if (!this.isLeftButton(event)) {
            return;
        }
        this.clearButtonEl.addCls(this.clearButtonCls + '-mouse-down');
    },

    handleMouseUpOnClearButton: function(event, htmlElement, object) {
        if (!this.isLeftButton(event)) {
            return;
        }
        this.clearButtonEl.removeCls(this.clearButtonCls + '-mouse-down');
    },

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Utility methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Repositions the clear button element based on the textfield.inputEl element
     * @private
     */
    repositionClearButton: function() {
        var clearButtonEl = this.clearButtonEl;
        if (!clearButtonEl) {
            return;
        }
        var clearButtonPosition = this.calculateClearButtonPosition(this.textField);
        // console.log("clearButtonPosition:", clearButtonPosition)
        clearButtonEl.dom.style.right = clearButtonPosition.right + 'px';
        clearButtonEl.dom.style.top = clearButtonPosition.top + 'px';
    },

    /**
     * Calculates the position of the clear button based on the textfield.inputEl element
     * @private
     */
    calculateClearButtonPosition: function(textField) {
        var positions = textField.inputEl.getBox(true, true);
        var top = positions.y;
        var right = positions.x;
        var t1 = "";
        if (this.fieldHasScrollBar()) {
            right += Ext.getScrollBarWidth();
            t1 += ":hasScroll";
        }
        if (this.textField.triggerWrap) {
            right += this.textField.getTriggerWidth();
            t1 += ":triggerWrap";
        }
        //console.log("positions:", positions, t1, top +","+right);
        return {
            right: right,
            top: top
        };
    },

    /**
     * Checks if the field we are attached to currently has a scrollbar
     */
    fieldHasScrollBar: function() {
        if (!this.isTextArea) {
            return false;
        }

        var inputEl = this.textField.inputEl;
        var overflowY = inputEl.getStyle('overflow-y');
        if (overflowY == 'hidden' || overflowY == 'visible') {
            return false;
        }
        if (overflowY == 'scroll') {
            return true;
        }
        //noinspection RedundantIfStatementJS
        if (inputEl.dom.scrollHeight <= inputEl.dom.clientHeight) {
            return false;
        }
        return true;
    },


    /**
     * Small wrapper around clearButtonEl.isVisible() to handle setVisible animation that may still be in progress.
     */
    isButtonCurrentlyVisible: function() {
        if (this.animateClearButton && this.animateWithCss3) {
            return this.clearButtonEl.hasCls(this.clearButtonCls + '-on');
        }

        // This should not be necessary (see Element.setVisible/isVisible), but else there is confusion about visibility
        // when moving the mouse out and _quickly_ over then input again.
        var cachedVisible = Ext.core.Element.data(this.clearButtonEl.dom, 'isVisible');
        if (typeof(cachedVisible) == 'boolean') {
            return cachedVisible;
        }
        return this.clearButtonEl.isVisible();
    },

    /**
     * Checks config options and current mouse status to determine if the clear button should be visible.
     */
    shouldButtonBeVisible: function() {
        if (this.hideClearButtonWhenEmpty && Ext.isEmpty(this.textField.getValue())) {
            return false;
        }

        var clearButtonEl = this.clearButtonEl;
        //noinspection RedundantIfStatementJS
        if (this.hideClearButtonWhenMouseOut
            && !clearButtonEl.hasCls(this.clearButtonCls + '-mouse-over-button')
            && !clearButtonEl.hasCls(this.clearButtonCls + '-mouse-over-input')) {
            return false;
        }

        return true;
    },

    /**
     * Called after any event that may influence the clear button visibility.
     */
    updateClearButtonVisibility: function() {
        var oldVisible = this.isButtonCurrentlyVisible();
        var newVisible = this.shouldButtonBeVisible();

        var clearButtonEl = this.clearButtonEl;
        if (oldVisible != newVisible) {
            if(this.animateClearButton && this.animateWithCss3) {
                this.clearButtonEl.removeCls(this.clearButtonCls + (oldVisible ? '-on' : '-off'));
                clearButtonEl.addCls(this.clearButtonCls + (newVisible ? '-on' : '-off'));
            }
            else {
                clearButtonEl.stopAnimation();
                clearButtonEl.setVisible(newVisible, this.animateClearButton);
            }

            // Set background-color of clearButton to same as field's background-color (for those browsers/cases
            // where the padding-right (see below) does not work)
            clearButtonEl.setStyle('background-color', this.textField.inputEl.getStyle('background-color'));

            // Adjust padding-right of the input tag to make room for the button
            // IE (up to v9) just ignores this and Gecko handles padding incorrectly with  textarea scrollbars
            if (!(this.isTextArea && Ext.isGecko) && !Ext.isIE) {
                // See https://bugzilla.mozilla.org/show_bug.cgi?id=157846
                var deltaPaddingRight = clearButtonEl.getWidth() - this.clearButtonEl.getMargin('l');
                var currentPaddingRight = this.textField.inputEl.getPadding('r');
                var factor = (newVisible ? +1 : -1);
                this.textField.inputEl.dom.style.paddingRight = (currentPaddingRight + factor * deltaPaddingRight) + 'px';
            }
        }
    },

    isLeftButton: function(event) {
        return event.button === 0;
    }

});

//@charset UTF-8
// http://stackoverflow.com/questions/18390041/extjs-combobox-dynamic-json-updates

Ext.override(Ext.form.field.ComboBox, {
	/**
	 * displayField 와 valueField 에서 모두 검색되어지도록 함.
	 * @param {} queryPlan
	 */
	doLocalQuery: function(queryPlan) {
        var me = this,
            queryString = queryPlan.query;

        // Create our filter when first needed
        if (!me.queryFilter) {
            // Create the filter that we will use during typing to filter the Store
            me.queryFilter = new Ext.util.Filter({
                id: me.id + '-query-filter',
                anyMatch: me.anyMatch,
                caseSensitive: me.caseSensitive,
                root: 'data',
                //property: me.displayField
                property: me.searchField	// combo에 정의한 searchField 에서 검색되어지도록 한다.
            });
            me.store.addFilter(me.queryFilter, false);
        }

        // Querying by a string...
        if (queryString || !queryPlan.forceAll) {
            me.queryFilter.disabled = false;
            me.queryFilter.setValue(me.enableRegEx ? new RegExp(queryString) : queryString);
        }

        // If forceAll being used, or no query string, disable the filter
        else {
            me.queryFilter.disabled = true;
        }

        // Filter the Store according to the updated filter
        me.store.filter();

        // Expand after adjusting the filter unless there are no matches
        if (me.store.getCount()) {
            me.expand();
        } else {
            me.collapse();
        }

        me.afterQuery(queryPlan);
    },
	/**
	 * space 키로 선택값 입력
     * @private
     * Enables the key nav for the BoundList when it is expanded.
     */
    onExpand: function() {
        var me = this,
            keyNav = me.listKeyNav,
            selectOnTab = me.selectOnTab,
            picker = me.getPicker();

        // Handle BoundList navigation from the input field. Insert a tab listener specially to enable selectOnTab.
        if (keyNav) {
            keyNav.enable();
        } else {
            keyNav = me.listKeyNav = new Ext.view.BoundListKeyNav(me.inputEl, {
                boundList: picker,
                forceKeyDown: true,
                tab: function(e) {
                    if (selectOnTab) {
                        this.selectHighlighted(e);
                        me.triggerBlur();
                    }
                    // Tab key event is allowed to propagate to field
                    return true;
                },
                enter: function(e){
                    var selModel = picker.getSelectionModel(),
                        count = selModel.getCount();
                        
                    this.selectHighlighted(e);
                    
                    // Handle the case where the highlighted item is already selected
                    // In this case, the change event won't fire, so just collapse
                    if (!me.multiSelect && count === selModel.getCount()) {
                        me.collapse();
                    }
                },
                space: function(e){	//2014.09.04 space 키로 선택값 입력된 후 포커스 이동하도록 수정
                    var selModel = picker.getSelectionModel(),
                        count = selModel.getCount();
                        
                    this.selectHighlighted(e);
                    
                    // Handle the case where the highlighted item is already selected
                    // In this case, the change event won't fire, so just collapse
                    if (!me.multiSelect && count === selModel.getCount()) {
                        me.collapse();
                    }
                    
                    Unilite.focusNextField(me, false, e);
                }
            });
        }

        // While list is expanded, stop tab monitoring from Ext.form.field.Trigger so it doesn't short-circuit selectOnTab
        if (selectOnTab) {
            me.ignoreMonitorTab = true;
        }

        Ext.defer(keyNav.enable, 1, keyNav); //wait a bit so it doesn't react to the down arrow opening the picker
        //me.inputEl.focus();
        
    }
});

 /**
  * Unilite용 Combobox
  */
Ext.define('Unilite.com.form.field.UniComboBox', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.uniCombobox',
    requires: [ 
    			'Ext.data.Store',
    			'Unilite.com.form.field.UniClearButton'
    ],
    mixins: {
        uniBaseField: 'Unilite.com.form.field.UniBaseField'  ,
        bindable: 'Ext.util.Bindable'      
    },
    //editable: false,
    /**
     * @cfg {boolean} typeAhead
     */
	typeAhead: true ,	
    queryMode: 'local', 
    /**
     * @cfg {Boolean} forceSelection
     */
    forceSelection: true,   
    /**
     * 
     * @cfg {Boolean} anyMatch
     * 
     * true:검색시 중간에 포함 되어도 검색 되게 함
     * false : 첫문자 부터 검색
     */
    anyMatch:true,
    /**
     * 
     * @cfg {String} displayField
     */
	displayField: 'text',
	/**
     * 
     * @cfg {String} valueField
     */
    valueField: 'value',
    
    searchField: 'search',
    
    store: undefined,
    withOptionValue: false,
    selectOnTab: true,        
    
//    tpl : Ext.create('Ext.XTemplate',
//        '<tpl for=".">',
//            //'<div class="x-boundlist-item">{value} | {text}</div>',
//            '<div class="x-boundlist-item"><div class="uni_combo_text">{text}</div> <div class="uni_combo_value">{value}</div> </div>',	
//        '</tpl>'
//    ),	
    
    //user config
    comboType: '',
    comboCode: '',
    childCombo: null,
    
    //abstract function
    onAfterRender	: Ext.emptyFn,
	onStoreLoad		: Ext.emptyFn,
	onBeforeChange	: Ext.emptyFn,
	onChangeDivCode	: Ext.emptyFn,
    
    constructor : function(config){    
        var me = this;

        var displayField 	= config.displayField || this.displayField;
        var valueField 		= config.valueField || this.valueField;
        Ext.apply(me, {tpl: Ext.create('Ext.XTemplate',
	        '<tpl for=".">',
	            '<div class="x-boundlist-item"><div class="uni_combo_text">{'+displayField+'}</div> <div class="uni_combo_value">{'+valueField+'}</div> </div>',	
	        '</tpl>'
	    )});
        
        if (config) {
            Ext.apply(me, config);
        }
        
 
        this.callParent([config]);
	}, // constructor
	initComponent: function () {
		var me = this;
		if (this.fieldLabel) {
			//this.emptyText = this.fieldLabel + '을(를) 선택하세요' 
		};
		var store;
	 	if (typeof this.store === "undefined") { // 공통코드 Store
	 		store = this._getStore();
	 		Ext.apply(this, {
	            store: store
	        });
	        //console.log("combo init: _getStore ", store);
	 	} else { 								// Controller 에서 정의된 Store clone 
	 		// 하나의 화면에 여러 combo가 하나의 store를 사용할떄 filter문제가 발생하므로 Store를 복제 하여 사용 
	 		store = this._storeClone(this.store)
	 		Ext.apply(this, {
	            store: store
	        });
	        console.log("combo init: store clone ", me.name, store);
	 	}
	 	
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
    		//this.trigger2Cls = 'x-form-clear-trigger';
	 		if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push('uniClearbutton');
	 	};
	 	


//	 	var combineFilter = new Ext.util.Filter({
//	        filterFn : function(record) {
//	        	var t = new String(record.get(me.displayField));
//    			var v = new String(record.get(me.valueField));
//    			var searchValue = me.getValue();
//    			if(searchValue != null) {
//    				searchValue = searchValue.toLowerCase();
//    			} else {
//    				searchValue = null;
//    			}
//	        	return t.toLowerCase().indexOf(searchValue) == 0 ||
//        				v.toLowerCase().indexOf(searchValue) == 0;			       
//	        } // filterFn
//        });
        
         //beforechange 추가
        me.addEvents("beforechange");
        me.addEvents("changedivcode");
        
        me.on("beforechange", 	me.onBeforeChange, me);
        me.on("changedivcode", 	me.onChangeDivCode, me);
        
        // child combo 처리
        me.on('afterrender', function(combo, eOpts) { me._onAfterRender(combo);});        

        // 다단계 Combo 처리를 change에서 child를 바꾸는 방식에서 query날리기전 filtering 하는 방식으로 변경
        // form, grid 모두 적용 가능 / 2014.08.13 ksj
        me.on("beforequery", me.onBeforequery, me);
        
        me.on('expand', me._onExpand, me);
        
//        this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});

        /*
		me.on('beforequeryX',function(queryPlan) {
				console.log("queryPlan", queryPlan);
				var me = this;
				var searchValue = me.getValue();
				//me.store.clearFilter();  // combo child와 문제 발생 2014.02.13 / beforequery를 수행 하는 이유는? 
				if(!queryPlan.forceAll && searchValue != null && searchValue.length > 0 ) {
					//searchValue = searchValue.toLowerCase();
					me.store.filter(combineFilter);
					
			        //me.store.filterBy(function(record) {
			        //	var t = new String(record.get(me.displayField));
            		//	var v = new String(record.get(me.valueField));
            		//	
			        //	return t.toLowerCase().indexOf(searchValue) == 0 ||
                	//			v.toLowerCase().indexOf(searchValue) == 0;
			        //});
			        
			    } else {
		        	return true;
		        }
		    }
		);
		*/
	 	this.callParent();
	},	

	// private
	_storeClone: function(source) {
	    var target = Ext.create ('Ext.data.Store', {
	        model: source.model
	    });
	
	    Ext.each (source.getRange (), function (record) {
	        var newRecordData = Ext.clone (record.copy().data);
	        var model = new source.model (newRecordData, newRecordData.id);
	
	        target.add (model);
	    });
	
	    return target;
    },    
    _getStore:function(forceRemote) {
    	var me = this;
    	var storeId = "CBS_"+this.comboType+"_"+Unilite.nvl(this.comboCode,'');
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	
    	if (! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		console.log('_getStore from remote ', storeId, mStore);
    		mStore= Ext.create('Ext.data.Store', { 
		        autoLoad: true, 
		        fields: ['value', 'text', 'option', 'search'],
		        sorters: [{
			        property: 'value',
			        direction: 'ASC' // or 'ASC'
			    }],
		        proxy: { 
		            type: 'ajax', 
		            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode
		        },
		        listeners: {
		        	load: function(store, records, successful, eOpts) {
		        		me.onStoreLoad(me, store, records, successful, eOpts);
		        	}
		        }
		    } );
    	}else{
    		mStore = me._storeClone(mStore);
    		mStore.on({
    			//load: me.onStoreLoad
    			load: function(store, records, successful, eOpts) {
	        		me.onStoreLoad(me, store, records, successful, eOpts);
	        	}
    		});		
    	}
	 	return mStore;
    },       
	
	_onAfterRender:function(combo) {
		var me = this;
		
		if(this.child) {
			this.childCombo = combo.ownerCt.getComponent(this.child);
			// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
			if(! this.childCombo &&  combo.ownerForm ) {
				this.childCombo = combo.ownerForm.getField(this.child);
			}
			//console.log("haschild:" + this.child + " : ", this.childCombo);
			if(me.childCombo) {
				me.childCombo.parentFieldName = me.name;
				// 값이 바뀌면 child 값을 reset !
				me.on('change', function(combo, newValue, oldValue, eOpts) {	
					if(combo.childCombo) {
						combo.childCombo.clearValue();
					}
				}, this);
			}
		}
		this.onAfterRender(combo);
	},	
//	onAfterRenderX:function(combo) {
//		var me = this;
//		if(this.child) {
//			//var childObj = Ext.getCmp(this.child);
//			//var childObj = combo.ownerCt.getComponent(this.child);
//			// 1. itemId로 조회
//			this.childCombo = combo.ownerCt.getComponent(this.child);
//			// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
//			if(! this.childCombo &&  combo.ownerForm ) {
//				this.childCombo = combo.ownerForm.getField(this.child);
//			}
//			console.log("haschild:" + this.child + " : ", this.childCombo);
//			if(me.childCombo) {
//				me.childCombo.parentFieldName = me.name;
//				//this.childCombo.store.filter("X","Y"); // 좀더 세련된 방법으로 ㅠㅠ
//		 		me.on('change', function(combo, newValue, oldValue, eOpts) {		 					
//							//var childObj = Ext.getCmp(this.child); //- itemId 사용 권장 
//							//var childObj = combo.ownerForm.getField(this.child);
//		 					console.log("afterRendender onChange. oldValue:" + oldValue + ", newValue:" + newValue);
//							if(combo.childCombo) {
//								combo.childCombo.store.clearFilter(true);
//								combo.childCombo.store.filter('option', newValue);
//								combo.childCombo.clearValue();
//								
////								combo.childCombo.store.clearFilter(true);
////								var filterValue = "";
////								if(combo.parentOptionValue) {
////						      		//filterValue = combo.parentOptionValue+'|'+combo.getValue();
////						      		filterValue = combo.parentOptionValue+'|'+newValue;
////								} else {
////									filterValue =  newValue;
////								}
////								
////								combo.childCombo.store.filter('option', filterValue);
////						      	combo.childCombo.parentOptionValue = newValue;
////						      	combo.childCombo.clearValue();
//							}
//					    },
//					this
//				); // me.on 
//			}
//	 	};
//	},
	getGrowWidth: function () {
        var me = this,
            value = me.inputEl.dom.value,
            field, store, dataLn, currentLongestLength,
            i, item, itemLn;

        if (me.growToLongestValue) {
            field = me.displayField;
            store = me.store;
            dataLn = store.data.length;
            currentLongestLength = 0;

            for (i = 0; i < dataLn; i++) {
                item = store.getAt(i).data[field];
                itemLn = item.length;

                // Compare the current item's length with the current longest length and store the value.
                if (itemLn > currentLongestLength) {
                    currentLongestLength = itemLn;
                    value = item;
                }
            }
        }

        return value;
    },
	_onExpand: function(combo) {
		var picker = combo.getPicker();
		var growLen = combo.getGrowWidth().length - 10;
		if(growLen > 0) { 
			picker.setWidth(combo.bodyEl.getWidth() + (growLen*15));
		}else{
			picker.setWidth(combo.bodyEl.getWidth());
		}
	},
	onBeforequery : function(queryPlan, eOpts) { 
    	var combo = queryPlan.combo
    	// Parent 필드가 있을 경우
    	if ( combo.parentFieldName ) {
    		var parentField=null;
    		var pValue=null;
    		if(combo.ownerForm) {	// form일경우
    			parentField = combo.ownerForm.getField(combo.parentFieldName);
    			
    			if(parentField) {
    				 pValue=parentField.getValue();
    			}
    		}  else {
    			var grid = combo.up('grid');
    			pValue = grid.uniOpt.currentRecord.get(combo.parentFieldName);
    		}
    		if(!Ext.isEmpty(pValue)) {
				combo.store.clearFilter(true);
				combo.queryFilter = null;				//key 입력 필터를 클리어한다. (doLocalQuery에서 queryFilter 를 재생성하도록)
				combo.store.filter('option', pValue);	//Parent 필드값으로 필터를 설정
    		} else {
//        			this.childCombo.store.filter("X","Y");
    			UniUtils.msg('확인','상위 분류값을 먼저 선택해 주세요.');
    			return false;
    		}
        }        	
    },			
	/*
	onTrigger2Click: function (args) {
		console.log("clear");
		this.setValue("");
	},
	*/
	/*
	getSubTplMarkup : function(values) {
        var me = this,
            field = me.callParent(arguments);

        return '<div style="position: relative">H:' + field+'</div>';
    },
    */
	/*
	handler_StoreLoad: function (store, records, successful, option) { 
		if(this.allowBlank) {
			this.store.add({value:'',text:''});
	 	};	 			
	},
	*/
        
    //override
    setValue: function(value, doSelect) {
        var me = this,
            valueNotFoundText = me.valueNotFoundText,
            inputEl = me.inputEl,
            oldValue = me.getValue(),
            i, len, record,
            dataObj,
            matchedRecords = [],
            displayTplData = [],
            processedValue = [];
		
        if (me.store.loading) {         
            me.value = value;
            me.setHiddenValue(me.value);
            return me;
        }

        if(this.multiSelect && typeof value === 'string' && value.indexOf(this.delimiter.trim()) > -1 ) {
        	value = value.split(this.delimiter.trim());
        }else{
        	value = Ext.Array.from(value);
        }
        for (i = 0, len = value.length; i < len; i++) {
            record = value[i];
            if (!record || !record.isModel) {
                record = me.findRecordByValue(record);
            }
 
            if (record) {
                matchedRecords.push(record);
                displayTplData.push(record.data);
                processedValue.push(record.get(me.valueField));
            }
            else {
                if (!me.forceSelection) {
                    processedValue.push(value[i]);
                    dataObj = {};
                    dataObj[me.displayField] = value[i];
                    displayTplData.push(dataObj);
                }
                else if (Ext.isDefined(valueNotFoundText)) {
                    displayTplData.push(valueNotFoundText);
                }
            }
        }

        me.setHiddenValue(processedValue);
        me.value = me.multiSelect ? processedValue : processedValue[0];
        if (!Ext.isDefined(me.value)) {
            me.value = null;
        }
        
         //beforechange 추가
        if(me.fireEvent('beforechange', me, me.value, oldValue) == false) {
        	return me;	
        }
        
        me.displayTplData = displayTplData;
        me.lastSelection = me.valueModels = matchedRecords;

        if (inputEl && me.emptyText && !Ext.isEmpty(value)) {
            inputEl.removeCls(me.emptyCls);
        }

        me.setRawValue(me.getDisplayValue());
        me.checkChange();

        if (doSelect !== false) {
            me.syncSelection();
        }
        me.applyEmptyText();

        return me;
    },
    //override
    beforeBlur: function(){	//값을 직접 지웠을 때 clear 될 수 있도록  (forceSelection: true 설정과 상관없이 동작하도록)
        var value = this.getRawValue();
        if(value == ''){
            this.lastSelection = [];
        }
        this.doQueryTask.cancel();
        this.assertValue();
    },
    //override
	setError: function(error){
		var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, error || '');
            } else {
                //me.updateLayout();
            }
        }
	},
	
	//관련 이벤트 발동 업이 값만 설정
    setValueOnly: function(value, doSelect) {
    	this.suspendEvents(false);
		this.setValue(value, doSelect);
		this.resumeEvents();
    },    
	changeDivCode: function(combo, newValue, oldValue, eOpts) {
		var me = combo;		
		var form = me.ownerForm;
		if(form) {
			var fields = form.getForm().getFields();
			console.log("changeDivCode called by %s of form", me.getName());
			
			for(i = 0, len = fields.length; i < len; i ++) {
				var field = fields.getAt(i);		
				if(field instanceof Ext.form.field.ComboBox) {
					eOpts = eOpts || {};
					eOpts.parent 	= combo;
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}			
			}
		}/*else{
			var grid = me.up('grid');
			for(i = 0, len = grid.columns.length; i < len; i ++) {
				var column = grid.columns[i];
				if(column.editor && column.editor instanceof Ext.form.field.ComboBox) {
					eOpts = eOpts || {};
					eOpts.parent 	= combo;
					//eOpts.context	= grid.getSelectionModel().getCurrentPosition().view.editingPlugin.context;
					column.editor.fireEvent('unidivchange', column.editor, newValue, oldValue, eOpts);
				}
			};
		}*/
	},
	filterByRefCode: function(refCodeName, filterValue, parentField) {
		var me = this;		
		//var pValue = null;
		//var parentField = eOpts.parent;		
		
		
		if(!Ext.isEmpty(filterValue)) {
			if(me.up('form')) {	// form일경우 (filter 중복 가능)	
				var filterId = parentField.name;
				
				me.store.removeFilter(filterId);
				me.queryFilter = null;
				//new 로 생성할 경우 root 설정 필수!!
				var filter = new Ext.util.Filter({id: filterId, property: refCodeName, value: filterValue, root: 'data'});
				//var filter2 = new Ext.util.Filter({id: 'unideptchange', property: 'refCode2', value: '101000', root: 'data'});
				me.store.addFilter([filter]);
				
				me.clearValue();			
			} else {	//grid
				//ToDo : 현재는 clear 하지만 필요하면 중복 필터 처리..
				me.store.clearFilter();
				me.store.filter(refCodeName, filterValue);
			}
		}
		
	}
});
//@charset UTF-8
 /**
  * Unilite용 TextField
  */
Ext.define('Unilite.com.form.field.UniTextField', {
	extend: 'Ext.form.field.Text',
    alias: 'widget.uniTextfield',
    mixins: {
        uniBaseField: 'Unilite.com.form.field.UniBaseField'
    },
    suffixTpl: '',
	initComponent: function () {
		if (this.fieldLabel && this.tooltip) {
			//this.emptyText = this.fieldLabel + '을(를) 입력하세요' 
			//Ext.applyIf(this.emptyText, this.fieldLabel + '을(를) 입력하세요' );
			 //this.fieldLabel =  this.fieldLabel+'<span style="color:green;" ext:qtip="'+this.tooltip+'"> ? </span> ';
		};
	 	this.callParent();
	 	
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
    	this.on('change', function(elm, newValue, oldValue, eOpts){
    		
    	});
	},
	clearInvalid:function() {
		//console.log('clearInvalid');
		        // Clear the message and fire the 'valid' event
        var me = this,
            hadError = me.hasActiveError();
            
        delete me.needsValidateOnEnable;
        me.unsetActiveError();
        if (hadError) {
           me.setError('');
        }
	},
	setError: function(active){
		var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, active || '');
            } else {
                 me.updateLayout();  // 에러 ! 안보이게. ( qtip 사용으로 필요 없음.)
            }
        }
	},
	fieldSubTpl: [ // note: {id} here is really {inputId}, but {cmpId} is available
       	'<table width="100%" cellpadding="0" cellspacing="0"><tr>',
       	'<td class="x-form-item-body  " width="100%"><input id="{id}" type="{type}" {inputAttrTpl}',
            ' size="1"', // allows inputs to fully respect CSS widths across all browsers
            '<tpl if="name"> name="{name}"</tpl>',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '{%if (values.maxLength !== undefined){%} maxlength="{maxLength}"{%}%}',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx"> tabIndex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
        ' class="{fieldCls} {typeCls} {editableCls} {inputCls}" autocomplete="off"/></td>',
        '<tpl if="suffixTpl">',
        '<td nowrap>{suffixTpl}</td>',
        '</tpl>',
        '</tr></table>',
        {
            disableFormats: true
        }
    ],
    /**
     * @override subTplInsertions
     * 
     */
    subTplInsertions: [
        /**
         * 
         * @cfg {String/Array/Ext.XTemplate} inputAttrTpl
         * An optional string or `XTemplate` configuration to insert in the field markup
         * inside the input element (as attributes). If an `XTemplate` is used, the component's
         * {@link #getSubTplData subTpl data} serves as the context.
         */
        'inputAttrTpl', 'suffixTpl'
    ]
    
});
//@charset UTF-8
/**
 * 
 */
Ext.define('Unilite.com.form.field.UniFile', {
	extend: 'Ext.form.field.File',
    alias: 'widget.uniFilefield',
    buttonOnly: false,
	initComponent: function () {

	 	this.callParent();
	 	
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
	}
});//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniYearPicker', {
    extend: 'Ext.view.BoundList',
    alias: 'widget.uniYearPicker',
    requires: ['Ext.data.Store', 'Ext.Date'],

   	minValue: '1980',
   	maxValue: '2020',

    /**
     * @private
     * The field in the implicitly-generated Model objects that gets displayed in the list. This is
     * an internal field name only and is not useful to change via config.
     */
    displayField: 'disp',

    componentCls: Ext.baseCSSPrefix + 'timepicker',

    /**
     * @cfg
     * @private
     */
    loadMask: false,

    initComponent: function() {
        var me = this;


        me.store = me.createStore();

        // Add our min/max range filter, but do not apply it.
        // The owning TimeField will filter it.
        me.store.addFilter(me.rangeFilter = new Ext.util.Filter({
            id: 'time-picker-filter'
        }), false);

        // Updates the range filter's filterFn according to our configured min and max
        me.updateList();

        me.callParent();
    },

    /**
     * Set the {@link #minValue} and update the list of available times. This must be a Date object (only the time
     * fields will be used); no parsing of String values will be done.
     * @param {Date} value
     */
    setMinValue: function(value) {
        this.minValue = value;
        this.updateList();
    },

    /**
     * Set the {@link #maxValue} and update the list of available times. This must be a Date object (only the time
     * fields will be used); no parsing of String values will be done.
     * @param {Date} value
     */
    setMaxValue: function(value) {
        this.maxValue = value;
        this.updateList();
    },



    /**
     * Update the list of available times in the list to be constrained within the {@link #minValue}
     * and {@link #maxValue}.
     */
    updateList: function() {
        var me = this,
            min =me.minValue ,
            max =me.maxValue ;

        me.rangeFilter.setFilterFn(function(record) {
            var date = record.get('date');
            return date >= min && date <= max;
        });
        me.store.filter();
    },

    /**
     * @private
     * Creates the internal {@link Ext.data.Store} that contains the available times. The store
     * is loaded with all possible times, and it is later filtered to hide those times outside
     * the minValue/maxValue.
     */
    createStore: function() {
        var me = this,
            years = [],
            min =  me.minValue,
            max = me.maxValue;

        while(min <= max){
            years.push({
                disp: min,
                date: min
            });
            min = min + 1;
        }
        return new Ext.data.Store({
            fields: ['disp', 'date'],
            data: years
        });
    },

    focusNode: function (rec) {
        // We don't want the view being focused when interacting with the inputEl (see Ext.form.field.ComboBox:onKeyUp)
        // so this is here to prevent focus of the boundlist view. See EXTJSIV-7319.
        return false;
    }

});
//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniYearField', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.uniYearField',
    requires: [ 'Unilite.com.form.field.UniYearPicker', 'Ext.view.BoundListKeyNav'],

    /**
     * @cfg {String} [triggerCls='x-form-time-trigger']
     * An additional CSS class used to style the trigger button. The trigger will always get the {@link #triggerBaseCls}
     * by default and triggerCls will be **appended** if specified.
     */
    triggerCls: Ext.baseCSSPrefix + 'form-time-trigger',



    //<locale>
    /**
     * @cfg {String} minText
     * The error text to display when the entered time is before {@link #minValue}.
     */
    minText : "The year in this field must be equal to or after {0}",
    //</locale>

    //<locale>
    /**
     * @cfg {String} maxText
     * The error text to display when the entered time is after {@link #maxValue}.
     */
    maxText : "The year in this field must be equal to or before {0}",
    //</locale>

    //<locale>
    /**
     * @cfg {String} invalidText
     * The error text to display when the time in the field is invalid.
     */
    invalidText : "{0} is not a valid year",
    //</locale>
   	minValue: '1980',
   	maxValue: '2020',
   	forceSelection : true,


    /**
     * @cfg {Number} pickerMaxHeight
     * The maximum height of the {@link Ext.picker.Time} dropdown.
     */
    pickerMaxHeight: 300,

    /**
     * @cfg {Boolean} selectOnTab
     * Whether the Tab key should select the currently highlighted item.
     */
    selectOnTab: true,



    
    ignoreSelection: 0,

    queryMode: 'local',

    displayField: 'disp',

    valueField: 'date',

    initComponent: function() {
        var me = this,
            min = me.minValue,
            max = me.maxValue;
        if (min) {
            me.setMinValue(min);
        }
        if (max) {
            me.setMaxValue(max);
        }
        
        me.displayTpl = new Ext.XTemplate(
            '<tpl for=".">' +
                '{[typeof values === "string" ? values : values["' + me.displayField + '"]]}' +
                '<tpl if="xindex < xcount">' + me.delimiter + '</tpl>' +
            '</tpl>');
            
//        this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
        this.callParent();
    },

    /**
     * @private
     */
    transformOriginalValue: function(value) {
        if (Ext.isString(value)) {
            return this.rawToValue(value);
        }
        return value;
    },

    /**
     * @private
     */
    isEqual: function(v1, v2) {
        return (v1 == v2)?true:false;
    },

    /**
     * Replaces any existing {@link #minValue} with the new time and refreshes the picker's range.
     * @param {Date/String} value The minimum time that can be selected
     */
    setMinValue: function(value) {
        var me = this,
            picker = me.picker;
        me.setLimit(value, true);
        if (picker) {
            picker.setMinValue(me.minValue);
        }
    },

    /**
     * Replaces any existing {@link #maxValue} with the new time and refreshes the picker's range.
     * @param {Date/String} value The maximum time that can be selected
     */
    setMaxValue: function(value) {
        var me = this,
            picker = me.picker;
        me.setLimit(value, false);
        if (picker) {
            picker.setMaxValue(me.maxValue);
        }
    },


    setLimit: function(value, isMin) {
        var me = this,
            d, val;
        if (Ext.isString(value)) {
            d = me.parseYear(value);
        }
        if (d) {
            
            val = d;
        }
        // Invalid min/maxValue config should result in a null so that defaulting takes over
        else {
            val = null;
        }
        me[isMin ? 'minValue' : 'maxValue'] = val;
    },

    rawToValue: function(rawValue) {
    	var t = this.parseYear(rawValue) || rawValue || null;
        return t;
    },

    valueToRaw: function(value) {
        return this.parseYear(value);
    },

    /**
     * Runs all of Time's validations and returns an array of any errors. Note that this first runs Text's validations,
     * so the returned array is an amalgamation of all field errors. The additional validation checks are testing that
     * the time format is valid, that the chosen time is within the {@link #minValue} and {@link #maxValue} constraints
     * set.
     * @param {Object} [value] The value to get errors for (defaults to the current field value)
     * @return {String[]} All validation errors for this field
     */
    getErrors: function(value) {
        var me = this,
            format = Ext.String.format,
            errors = me.callParent(arguments),
            minValue = me.minValue,
            maxValue = me.maxValue,
            date;

        value = value || me.processRawValue(me.getRawValue());

        if (value === null || value.length < 1) { // if it's blank and textfield didn't flag it then it's valid
             return errors;
        }

        date = me.parseYear(value);
        if (!date) {
            errors.push(format(me.invalidText, value, "연도"));
            return errors;
        }

        if (minValue && date < minValue) {
            errors.push(format(me.minText, me.formatDate(minValue)));
        }

        if (maxValue && date > maxValue) {
            errors.push(format(me.maxText, me.formatDate(maxValue)));
        }

        return errors;
    },

    formatDate: function(value) {
        return Number(value);
    },

    /**
     * @private
     * Parses an input value into a valid Date object.
     * @param {String/Date} value
     */
    parseYear: function(value) {
       
		var val = Number(value);
        return val;
    },



    // @private
    getSubmitValue: function() {
        var me = this,
            value = me.getValue();
		var rv = value ? String(value) : null;
        return rv;
    },

    /**
     * @private
     * Creates the {@link Ext.picker.Time}
     */
    createPicker: function() {
        var me = this,
            picker;

        me.listConfig = Ext.apply({
            xtype: 'uniYearPicker',
            selModel: {
                mode: 'SINGLE'
            },
            cls: undefined,
            minValue: me.minValue,
            maxValue: me.maxValue,
            format: me.format,
            maxHeight: me.pickerMaxHeight
        }, me.listConfig);
        picker = me.callParent();
        me.bindStore(picker.store);
        return picker;
    },
    
    onItemClick: function(picker, record){
        // The selection change events won't fire when clicking on the selected element. Detect it here.
        var me = this,
            selected = picker.getSelectionModel().getSelection();

        if (selected.length > 0) {
            selected = selected[0];
            if (selected && (record.get('date')== selected.get('date'))) {
                me.collapse();
            }
        }
    },

    /**
     * @private
     * Handles a time being selected from the Time picker.
     */
    onListSelectionChange: function(list, recordArray) {
        if (recordArray.length) {
            var me = this,
                val = recordArray[0].get('date');

            if (!me.ignoreSelection) {
                me.skipSync = true;
                me.setValue(val);
                me.skipSync = false;
                me.fireEvent('select', me, val);
                me.picker.clearHighlight();
                me.collapse();
                me.inputEl.focus();
            }
        }
    },

    /**
     * @private 
     * Synchronizes the selection in the picker to match the current value
     */
    syncSelection: function() {
        var me = this,
            picker = me.picker,
            toSelect,
            selModel,
            value,
            data, d, dLen, rec;
            
        if (picker && !me.skipSync) {
            picker.clearHighlight();
            value = me.getValue();
            selModel = picker.getSelectionModel();
            // Update the selection to match
            me.ignoreSelection++;
            if (value === null) {
                selModel.deselectAll();
            } else if (Ext.isNumber(value)) {
                // find value, select it
                data = picker.store.data.items;
                dLen = data.length;

                for (d = 0; d < dLen; d++) {
                    rec = data[d];

                    if (rec.get('date') == value) {
                       toSelect = rec;
                       break;
                   }
                }

                selModel.select(toSelect);
            }
            me.ignoreSelection--;
        }
    },

    postBlur: function() {
        var me = this,
            val = me.getValue();

        me.callParent(arguments);

        // Only set the raw value if the current value is valid and is not falsy
        if (me.wasValid && val) {
            me.setRawValue(me.formatDate(val));
        }
    },

    setValue: function() {

        // Store MUST be created for parent setValue to function
        this.getPicker();

        return this.callParent(arguments);
    },

    getValue: function() {
        return this.parseYear(this.callParent(arguments));
    }
});
/**
 * 
 */

Ext.define('Unilite.com.form.field.UniMonthField', {
	extend: 'Ext.form.field.Date',
	alias: 'widget.uniMonthfield',
    requires: [
    	'Ext.picker.Month',
    	'Unilite.com.form.field.UniClearButton'
    ],
    selectMonth: null,
    format: Unilite.monthFormat,
    enforceMaxLength: true,
    maxLength: 7,
    fieldStyle: 'text-align:center;ime-mode:disabled;',
    submitFormat : Unilite.dbMonthFormat,
    altFormats: Unilite.altMonthFormats,
    showToday: false,
    labelStyle: 'text-align:right; margin-right:0',
    labelSeparator: '',
    padding: 0, margin: 0,
    labelWidth: 0,
	uniOpt: {},
	//value: Ext.util.Format.date(new Date(), this.format),
	
    initComponent: function () {
		var me = this;
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
	 		if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push('uniClearbutton');
	 	};
	 	if(Ext.isEmpty(me.value)) {
			me.setValue(Ext.util.Format.date(new Date(), me.format));
	 	}else{
	 		if(Ext.isDate(me.value)) {
	 			me.setValue(Ext.util.Format.date(me.value, me.format));
	 		}else {
	 			me.setValue(me.value);
	 		}
	 	}
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
	 	this.callParent();
	},
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        return Ext.create('Ext.picker.Month', {
            pickerField: me,
            ownerCt: me.ownerCt,
            renderTo: document.body,
            floating: true,
            hidden: true,
            focusOnShow: true,
            minDate: me.minValue,
            maxDate: me.maxValue,
            disabledDatesRE: me.disabledDatesRE,
            disabledDatesText: me.disabledDatesText,
            disabledDays: me.disabledDays,
            disabledDaysText: me.disabledDaysText,
            format: me.format,
            showToday: me.showToday,
            startDay: me.startDay,
            small: me.showToday === false,
            minText: format(me.minText, me.formatDate(me.minValue)),
            maxText: format(me.maxText, me.formatDate(me.maxValue)),
            height:170,
            listeners: { 
		        select:        { scope: me,   fn: me.onSelect      }, 
		        monthdblclick: { scope: me,   fn: me.onOKClick     },    
		        yeardblclick:  { scope: me,   fn: me.onOKClick     },
		        OkClick:       { scope: me,   fn: me.onOKClick     },    
		        CancelClick:   { scope: me,   fn: me.onCancelClick }        
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            }
        });
    },
    onSelect: function(picker, value) {
        var me = this;        	
        me.selectMonth = me._getSelectDate(value);
        me.setValue(me.selectMonth);
        me.fireEvent('select', me, me.selectMonth);
    },
    onOKClick: function(picker, value) {
        var me = this;    
	    if( me.selectMonth == null ) {
	    	me.onSelect(picker, value);
	    }
	   
        me.collapse();
    },
    onCancelClick: function() {
        var me = this;    
    	me.selectMonth = null;
        me.collapse();
    },
    _getSelectDate: function(d) {
    	var me = this,
            month	= d[0],
            year 	= d[1],
            date 	= new Date(year, month, 1);

        if(date.getMonth() !== month){
            date = Ext.Date.getLastDateOfMonth(new Date(year, month, 1));
        }
       
        return Ext.util.Format.date(date, me.format);
    }
});  
 //@charset UTF-8

/*****************************************************
 * 
 * 
 */
Ext.define('Unilite.com.form.field.UniMonthFieldForRange', {
    extend: 'Unilite.com.form.field.UniMonthField',
    alias: 'widget.uniMonthfieldForRange',    
	vtype: 'uniDateRange',
	uniChanged : false,

	initComponent: function () {
	 	this.callParent();
	},
	/**
	 * @private
	 * @return {}
	 */
	_getPicker : function () {
		return this.uniPicker;
	},
	setValue: function(value) {
		var me = this;
		var picker = me._getPicker();
		me.callParent(arguments);
        var nv = this.getValue();
		if(picker && Ext.isDate(nv)) {
//        if(picker ) {
			picker.setValue(me.getValue());			
		}
        return me;
	},
	/**
     * Replaces any existing disabled dates with new values and refreshes the Date picker.
     * @param {String[]} disabledDates An array of date strings (see the {@link #disabledDates} config for details on
     * supported values) used to disable a pattern of dates.
     */
    setDisabledDates : function(dd){
        var me = this,
            picker = me._getPicker();

        me.disabledDates = dd;
        me.initDisabledDays();
        if (picker) {
            picker.setDisabledDates(me.disabledDatesRE);
        }
    },
    /**
     * Replaces any existing disabled days (by index, 0-6) with new values and refreshes the Date picker.
     * @param {Number[]} disabledDays An array of disabled day indexes. See the {@link #disabledDays} config for details on
     * supported values.
     */
    setDisabledDays : function(dd){
        var picker =me._getPicker();

        this.disabledDays = dd;
        if (picker) {
            picker.setDisabledDays(dd);
        }
    },    
    /**
     * Replaces any existing {@link #minValue} with the new value and refreshes the Date picker.
     * @param {Date} value The minimum date that can be selected
     */
    setMinValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            minValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.minValue = minValue;
        if (picker) {
            picker.minText = Ext.String.format(me.minText, me.formatDate(me.minValue));
            //picker.setMinDate(minValue);
            picker.minDate = minValue;
        }
    },

    /**
     * Replaces any existing {@link #maxValue} with the new value and refreshes the Date picker.
     * @param {Date} value The maximum date that can be selected
     */
    setMaxValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            maxValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.maxValue = maxValue;
        if (picker) {
            picker.maxText = Ext.String.format(me.maxText, me.formatDate(me.maxValue));
            //picker.setMaxDate(maxValue);
            picker.maxDate = maxValue;     
        }
    }
}); //@charset UTF-8
/**
 * UniMonthRangefield용 layout Class
 */
Ext.define('Unilite.com.form.field.UniMonthRangeFieldLayout', {

    /* Begin Definitions */

    extend: 'Ext.layout.component.field.FieldContainer',
	
    //extend: 'Ext.layout.component.Auto',

    alias: 'layout.uniMonthRangefieldLayout',

    /* End Definitions */
    
    type: 'uniMonthRangefield',


    waitForOuterHeightInDom: true,
    waitForOuterWidthInDom: true,

    beginLayout: function(ownerContext) {
        var owner = this.owner;
        this.callParent(arguments);

        // Tell Component.measureAutoDimensions to measure the DOM when containerChildrenSizeDone is true
        ownerContext.hasRawContent = true;
        owner.bodyEl.setStyle('height', '');
        owner.containerEl.setStyle('height', '');
        ownerContext.containerElContext = ownerContext.getEl('containerEl');
    },

    measureContentHeight: function (ownerContext) {
        // since we are measuring the outer el, we have to wait for whatever is in our
        // container to be flushed to the DOM... especially for things like box layouts
        // that size the innerCt since that is all that will contribute to our size!
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    measureContentWidth: function (ownerContext) {
        // see measureContentHeight
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    publishInnerWidth: function (ownerContext, width) {
        var bodyContext = ownerContext.bodyCellContext,
            innerWidth = bodyContext.el.getWidth();

        bodyContext.setWidth(innerWidth, false);
        ownerContext.containerElContext.setWidth(innerWidth, false);
    },
    
    publishInnerHeight: function (ownerContext, height) {
        var bodyContext = ownerContext.bodyCellContext,
            containerElContext = ownerContext.containerElContext;
            
        height -= this.measureLabelErrorHeight(ownerContext);
        bodyContext.setHeight(height);
        containerElContext.setHeight(height);
    }
});//@charset UTF-8


/**
 * 
 */
Ext.define('Unilite.com.form.field.UniMonthRangeField', {
  	extend: 'Ext.form.FieldContainer',
	alias: 'widget.uniMonthRangefield',
    componentLayout: 'uniMonthRangefieldLayout',
	mixins: {
        //observable: 'Ext.util.Observable'
		field: 'Ext.form.field.Field',
        label: 'Ext.form.Labelable'
    },
    requires: [
        'Ext.form.field.Date',
        'Ext.form.Label',
        'Unilite.com.form.field.UniMonthFieldForRange',
    	'Unilite.com.form.field.UniClearButton',
        'Unilite.com.form.field.UniMonthRangeFieldLayout'
    ],
    layout: {
        type: 'hbox',
        align: 'stretch'
    },
    
    /**
     * 
     * @cfg{Object} startDate 
     */
    startDate: null,
    /**
     * 
     * @cfg{Object} endDate 
     */
    endDate:null,
    /**
     * 
     * @cfg{Object} fromFieldName 
     */
    startFieldName:'MONTH_FR',
    /**
     * 
     * @cfg{Object} endFieldName 
     */
    endFieldName:'MONTH_TO',
    
    onStartDateChange: Ext.emptyFn,
    onEndDateChange: Ext.emptyFn,
    
    constructor : function(config){     
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        
        var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
        me.startDateField =  Ext.create('Unilite.com.form.field.UniMonthFieldForRange',{
        	hideTrigger:true,
            hideLabel: true,
            width: 100,
            name: me.startFieldName,
            allowBlank: lAllowBlank,
            listeners: {
            	change: function( field, newValue, oldValue, eOpts ){
            		me.onStartDateChange(field, newValue, oldValue, eOpts);
            	}
            }	    
        });
        me.endDateField = Ext.create('Unilite.com.form.field.UniMonthFieldForRange',{
            hideLabel: true,
            //labelWidth:5,
            width:110,
            //fieldLabel:'~',
            name: me.endFieldName,
            allowBlank: lAllowBlank,
            onTriggerClick: function() {
		        me.onTriggerClick();
		    },
            listeners: {
            	change: function( field, newValue, oldValue, eOpts ){
            		me.onEndDateChange(field, newValue, oldValue, eOpts);
            	}
            }
    	});
        
        me.items =[me.startDateField, {xtype:'label', text:'~', width: '5', style: 'margin-top: 3px!important;'}, me.endDateField ];
        me.callParent(arguments);
    },  // constructor
    
    initComponent: function() {
        var me = this;
        me.callParent(arguments);
        
        
       	me.startDateField.setValue(me.startDate);
        me.endDateField.setValue(me.endDate);
        
        // vtype 설정용 (min/MAX 자동 설정)
        me.endDateField.startDateField = me.startDateField; //.getId();
        me.startDateField.endDateField = me.endDateField;//.getId();
        
    },  // initComponent
    
	/**
	 * 
	 * @cfg {Object[]}   presetPastDates
	 * 주의 !!! month 는 0이 1월임
	 * Example:
     *
     *     presetPastDates: [
     *		{text:'어제',   startDate: moment().add('day',-1),                     endDate: moment().add('day',-1)},
     *		{text:'지난주', startDate: moment().add('week',-1).startOf('week'),    endDate: moment().add('week',-1).endOf('week')},
     *		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
     *		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
     *		{text:'전년도', startDate: moment().add('year',-1).startOf('year'),    endDate: moment().add('year',-1).endOf('year')}
     *	],
     *
	 */
	presetPastDates: [
		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년도', 
								startDate: moment().add('year',-1).startOf('year'),    
								endDate: moment().add('year',-1).endOf('year')},
		{text:moment().add('year',-1).get('year')+'년 상반기', 	
								startDate: moment().add('year',-1).startOf('year'),    	
								endDate:   moment().add('year',-1).set('month',5).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 하반기', 
								startDate: moment().add('year',-1).set('month',6).startOf('month'),    
								endDate: moment().add('year',-1).endOf('year')},
								
		{text:moment().add('year',-1).get('year')+'년 1사분기', 	
								startDate: moment().add('year',-1).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',-1).set('month',2).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 2사분기', 
								startDate: moment().add('year',-1).set('month',3).startOf('month'),    
								endDate:   moment().add('year',-1).set('month',5).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 3사분기', 	
								startDate: moment().add('year',-1).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',-1).set('month',7).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 4사분기', 
								startDate: moment().add('year',-1).set('month',8).startOf('month'),    
								endDate:   moment().add('year',-1).set('month',11).endOf('month')},
								
		{text:moment().add('year',-2).get('year')+'년도', 
								startDate: moment().add('year',-2).startOf('year'),    
								endDate: moment().add('year',-2).endOf('year')},								
		{text:moment().add('year',-2).get('year')+'년 상반기', 	
								startDate: moment().add('year',-2).startOf('year'),    	
								endDate: moment().add('year',-2).set('month',5).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 하반기', 		
								startDate: moment().add('year',-2).set('month',6).startOf('month'),    
								endDate: moment().add('year',-2).endOf('year')},
		{text:moment().add('year',-2).get('year')+'년 1사분기', 	
								startDate: moment().add('year',-2).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',-2).set('month',2).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 2사분기', 
								startDate: moment().add('year',-2).set('month',3).startOf('month'),    
								endDate:   moment().add('year',-2).set('month',5).endOf('month')},								
		{text:moment().add('year',-2).get('year')+'년 3사분기', 	
								startDate: moment().add('year',-2).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',-2).set('month',7).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 4사분기', 
								startDate: moment().add('year',-2).set('month',8).startOf('month'),    
								endDate:   moment().add('year',-2).set('month',11).endOf('month')}								
	],
	/**
	 * 
	 * @cfg {Object[]}   presetDates
	 * Example:
     *
     *     presetDates: [
     *		{text:'어제',   startDate: moment().add('day',-1),                     endDate: moment().add('day',-1)},
     *		{text:'지난주', startDate: moment().add('week',-1).startOf('week'),    endDate: moment().add('week',-1).endOf('week')},
     *		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
     *		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
     *		{text:'전년도', startDate: moment().add('year',-1).startOf('year'),    endDate: moment().add('year',-1).endOf('year')}
     *	   ],
     *
	 */
    presetDates: [
        {text:'이번달', startDate: moment().startOf('month'),                      	endDate: moment().endOf('month')},
        {text:'최근6개월', startDate: moment().add('month',-6).startOf('month'),    endDate: moment()},
        {text:'금년도', startDate: moment().startOf('year'),    					endDate: moment().endOf('year')},
		{text:'상반기', startDate: moment().startOf('year'),    endDate: moment().set('month',5).endOf('month')},
		{text:'하반기', startDate: moment().set('month',6).startOf('month'),    endDate: moment().endOf('year')},
		{text:'1사분기', 	
						startDate: moment().set('month',0).startOf('month'),    	
						endDate:   moment().set('month',2).endOf('month')},
		{text:' 2사분기', 
						startDate: moment().set('month',3).startOf('month'),    
						endDate:   moment().set('month',5).endOf('month')},								
		{text:'3사분기', 	
						startDate: moment().set('month',6).startOf('month'),    	
						endDate:   moment().set('month',7).endOf('month')},
		{text:'4사분기', 
						startDate: moment().set('month',8).startOf('month'),    
						endDate:   moment().set('month',11).endOf('month')}	
    ],
	/**
	 * 
	 * @cfg {Object[]}   presetFutureDates
	 * Example:
     *
     *     presetDates: [
     *		{text:'내일',   startDate: moment().add('day',1),                     endDate: moment().add('day',1)},
     *		{text:'다음주', startDate: moment().add('week',1).startOf('week'),    endDate: moment().add('week',1).endOf('week')},
     *		{text:'한달후', startDate: moment().add('month',1).startOf('month'),    endDate: moment().add('month',1).endOf('month')},
     *		{text:'두달후', startDate: moment().add('month',2).startOf('month'),    endDate: moment().add('month',2).endOf('month')},
     *		{text:'내년도', startDate: moment().add('year',1).startOf('year'),    endDate: moment().add('year',1).endOf('year')}
     *	   ],
     *
	 */    
    presetFutureDates: [
		{text:'한달후', startDate: moment().add('month',1).startOf('month'),    endDate: moment().add('month',1).endOf('month')},
		{text:'두달후', startDate: moment().add('month',2).startOf('month'),    endDate: moment().add('month',2).endOf('month')},
		{text:moment().add('year',1).get('year')+'년도', startDate: moment().add('year',1).startOf('year'),    endDate: moment().add('year',1).endOf('year')},
		{text:moment().add('year',1).get('year')+'년 상반기', 	
								startDate: moment().add('year',1).startOf('year'),    	
								endDate:   moment().add('year',1).set('month',5).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 하반기', 
								startDate: moment().add('year',1).set('month',6).startOf('month'),    
								endDate: moment().add('year',1).endOf('year')},
								
		{text:moment().add('year',1).get('year')+'년 1사분기', 	
								startDate: moment().add('year',1).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',1).set('month',2).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 2사분기', 
								startDate: moment().add('year',1).set('month',3).startOf('month'),    
								endDate:   moment().add('year',1).set('month',5).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 3사분기', 	
								startDate: moment().add('year',1).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',1).set('month',7).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 4사분기', 
								startDate: moment().add('year',1).set('month',8).startOf('month'),    
								endDate:   moment().add('year',1).set('month',11).endOf('month')}		
		
    ],

    
    makeMenu: function(mtext, presets) {
    	var me = this;
        var menu = Ext.create('Ext.menu.Menu', {
    		plain: true,
            text:mtext
        });
        Ext.each(presets,function(p,i){
        	var dispFormat ='YYYY.MM';
            var startDT, endDT;
            var memuText = p.text;
            
            if(typeof p.startDate === 'object' ) {
                startDT = p.startDate.format(UniDate.mommentDBformat);
                endDT = p.endDate.format(UniDate.mommentDBformat);
                memuText = memuText + ' : '+p.startDate.format(dispFormat) + " ~ "+p.endDate.format(dispFormat);
            }
            menu.add({
                text: memuText,
                handler:function() {
                    me.setValuesAndGo(startDT, endDT);
                }
            });
        }); // forEach
        return menu;
    },
	_makePanel: function() {
		//this.menu = Ext.create('Ext.panel.Panel', {
		var me = this, p1, p2;
		
		var menuPast = this.makeMenu('과거', this.presetPastDates);
        var menuDates = this.makeMenu('현재',this.presetDates);
        var menuFuture = this.makeMenu('미래',this.presetFutureDates);
        
    	var toolBar = {
    		xtype:'toolbar',
    		dock: 'top',
    		autoShow:true, 
    		defaults: { // defaults are applied to items, not the container
    			autoScroll: true,
    			autoShow: true
			},   
			defaultType:'button',
    		items: [    
    			{xtype:'button', text: '과거',iconCls: 'menu-menuShow',menu: menuPast},
    			{xtype:'button', text: '현재',iconCls: 'menu-menuShow',menu: menuDates},
    			{xtype:'button', text: '미래',iconCls: 'menu-menuShow',menu: menuFuture},
	    	 	{xtype:'button', text:'이번달', colspan:2,  handler:function(){me.setValuesAndGo(UniDate.get("today"), UniDate.get("today"));}},
	    	 	'->',
	    	 	{xtype:'button', text:'확인', handler:function(){me._close();}}
	    	 ]};
		
		var createPicker = function(field, config){
			var monthPicker =  Ext.create('Ext.picker.Month', Ext.apply({
		    		format: Unilite.monthFormat,
		    		altFormats: Unilite.altFormats,
		    		minDate: field.minValue,
		            maxDate: field.maxValue,
		            disabledDatesRE: field.disabledDatesRE,
		            disabledDatesText: field.disabledDatesText,
		            disabledDays: field.disabledDays,
		            disabledDaysText: field.disabledDaysText,
		            showToday: field.showToday,
		            startDay: field.startDay,
		            minText: Ext.String.format(field.minText, field.formatDate(field.minValue)),
		            maxText: Ext.String.format(field.maxText, field.formatDate(field.maxValue)),
		            showButtons: false,
		            listeners: {
		                scope: field,
		                select: field.onSelect
		            }
	    		}, config) )
	    		
	    		field.uniPicker = monthPicker;
	    		return monthPicker;
		};
		
		p1 = createPicker(me.startDateField);
		p2 = createPicker(me.endDateField);
		
		p1.addListener('select',function(p,d){
			//p2.setMinDate(d);
			p2.minDate = d;
		});
		p2.addListener('select',function(p,d){
			//p1.setMaxDate(d);
			p1.maxDate = d;
		});
		me.startMonthPicker  = p1;
		me.endMonthPicker  = p2;
						
		
		this.picPanel = Ext.create('Ext.window.Window', {	
			dockedItems: toolBar,
			title:me.fieldLabel,
			hidden:true,
			modal:true,
			closable:false,
		    defaults: {padding:5},
		    layout : {	type: 'hbox'},
		    listeners : {
		    	scope : this,
		    	show: function(obj, eOpts) {
		    		var st  = me.startDateField.getValue() ;
		    		var ed  = me.endDateField.getValue() ;
		    		
		    		me.startMonthPicker.setValue(Ext.isDate(st) ? st : new Date());
		    		me.endMonthPicker.setValue(Ext.isDate(ed) ? ed : new Date());
		    	}
		    },
		    items: [
		    	me.startMonthPicker, me.endMonthPicker
		    ] // items
		});		
		//console.log('Made Menu');
	},
	setValuesAndGo:function(startDdate, endDate) {
		this.setValues(startDdate, endDate);
		this._close();
	},
	setValues:function(startDdate, endDate) {
		this.startDateField.setValue(startDdate);
		this.endDateField.setValue(endDate);
		
		this.startMonthPicker.setValue(Ext.isDate(startDdate) ? startDdate : new Date());
		this.endMonthPicker.setValue(Ext.isDate(endDate) ? endDate : new Date());
		
		this._updateMinMax();
	},
	_updateMinMax: function() {
		this.startDateField.setMaxValue(this.endDateField.getValue());
		this.endDateField.setMinValue(this.startDateField.getValue());
	},
	_close: function(el) {
		this.picPanel.hide();
		this.endDateField.focus();
	}, 
	/**
	 * 창띄우기
	 * @param {} el
	 */
    onTriggerClick: function() {
    	var me = this;
    	if (me.disabled || me.readOnly) {
			return;
		}
		
		if (me.picPanel === undefined) {
			me._makePanel();
		} // if menu
		
		if(me.picPanel) {
			var targetEl = me.startDateField;
			me.picPanel.showBy(targetEl, "tl-bl?");
			me.picPanel.getEl().on('keydown', function(e, elm){
				switch( e.getKey() ) {
	    			case Ext.EventObject.ESC:
	    				me._close();
	    		}
			});
			me.picPanel.getDockedItems('toolbar[dock="top"]')[0].items.items[0].focus();
		}
		//pnl.showBy(el, "tl-bl?");
    }
    
});

//@charset UTF-8
/**
* Rerence : http://workblog.neteos.eu/180/javascript/extjs/extjs-datefield-select-date-range
*/

/*****************************************************
 * 
 * 
 */
Ext.define('Unilite.com.form.field.UniDateFieldForRange', {
    extend: 'Ext.form.field.Date',
    alias: 'widget.uniDatefieldForRange',
    requires: [
    	'Unilite.com.form.field.UniClearButton'
    ],
    format: Unilite.dateFormat,
    enforceMaxLength: true,
    maxLength: 10,
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	/**
	 * 
	 * @cfg {String} submitFormat
	 * 'Ymd',   20131231
	 */
    submitFormat : Unilite.dbDateFormat, 
    altFormats: Unilite.altFormats,
	vtype: 'uniDateRange',
	showToday: false,
    labelStyle: 'text-align:center; margin-right:0',
    labelSeparator: '',
    padding: 0, margin: 0,
    labelWidth: 0,
	uniOpt: {},
	uniChanged : false,
	/**
	 * 
	 */
	initComponent: function () {
		var me = this;
		
		
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
    		//this.trigger2Cls = 'x-form-clear-trigger';
	 		if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push('uniClearbutton');
	 	};
		
//	 	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});    	    	
    	
	 	this.callParent();
	},
	/**
	 * @private
	 * @return {}
	 */
	_getPicker : function () {
		return this.uniPicker;
	},
	setValue: function(value) {
		var me = this;
		var picker = me._getPicker();
		me.callParent(arguments);
        var nv = this.getValue();
		if(picker && Ext.isDate(nv)) {
//        if(picker ) {
			picker.setValue(me.getValue());			
		}
        return me;
	},
	/**
     * Replaces any existing disabled dates with new values and refreshes the Date picker.
     * @param {String[]} disabledDates An array of date strings (see the {@link #disabledDates} config for details on
     * supported values) used to disable a pattern of dates.
     */
    setDisabledDates : function(dd){
        var me = this,
            picker = me._getPicker();

        me.disabledDates = dd;
        me.initDisabledDays();
        if (picker) {
            picker.setDisabledDates(me.disabledDatesRE);
        }
    },
    /**
     * Replaces any existing disabled days (by index, 0-6) with new values and refreshes the Date picker.
     * @param {Number[]} disabledDays An array of disabled day indexes. See the {@link #disabledDays} config for details on
     * supported values.
     */
    setDisabledDays : function(dd){
        var picker =me._getPicker();

        this.disabledDays = dd;
        if (picker) {
            picker.setDisabledDays(dd);
        }
    },    
    /**
     * Replaces any existing {@link #minValue} with the new value and refreshes the Date picker.
     * @param {Date} value The minimum date that can be selected
     */
    setMinValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            minValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.minValue = minValue;
        if (picker) {
            picker.minText = Ext.String.format(me.minText, me.formatDate(me.minValue));
            picker.setMinDate(minValue);
        }
    },

    /**
     * Replaces any existing {@link #maxValue} with the new value and refreshes the Date picker.
     * @param {Date} value The maximum date that can be selected
     */
    setMaxValue : function(dt){
        var me = this,
            picker = me._getPicker(),
            maxValue = (Ext.isString(dt) ? me.parseDate(dt) : dt);

        me.maxValue = maxValue;
        if (picker) {
            picker.maxText = Ext.String.format(me.maxText, me.formatDate(me.maxValue));
            picker.setMaxDate(maxValue);
        }
    }
}); //@charset UTF-8
/**
 * UniPopupField용 layout Class
 */
Ext.define('Unilite.com.form.field.UniDateRangeFieldLayout', {

    /* Begin Definitions */

    extend: 'Ext.layout.component.field.FieldContainer',
	
    //extend: 'Ext.layout.component.Auto',

    alias: 'layout.uniDateRangefieldLayout',

    /* End Definitions */
    
    type: 'uniDateRangefield',


    waitForOuterHeightInDom: true,
    waitForOuterWidthInDom: true,

    beginLayout: function(ownerContext) {
        var owner = this.owner;
        this.callParent(arguments);

        // Tell Component.measureAutoDimensions to measure the DOM when containerChildrenSizeDone is true
        ownerContext.hasRawContent = true;
        owner.bodyEl.setStyle('height', '');
        owner.containerEl.setStyle('height', '');
        ownerContext.containerElContext = ownerContext.getEl('containerEl');
    },

    measureContentHeight: function (ownerContext) {
        // since we are measuring the outer el, we have to wait for whatever is in our
        // container to be flushed to the DOM... especially for things like box layouts
        // that size the innerCt since that is all that will contribute to our size!
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    measureContentWidth: function (ownerContext) {
        // see measureContentHeight
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    publishInnerWidth: function (ownerContext, width) {
        var bodyContext = ownerContext.bodyCellContext,
            innerWidth = bodyContext.el.getWidth();

        bodyContext.setWidth(innerWidth, false);
        ownerContext.containerElContext.setWidth(innerWidth, false);
    },
    
    publishInnerHeight: function (ownerContext, height) {
        var bodyContext = ownerContext.bodyCellContext,
            containerElContext = ownerContext.containerElContext;
            
        height -= this.measureLabelErrorHeight(ownerContext);
        bodyContext.setHeight(height);
        containerElContext.setHeight(height);
    }
});//@charset UTF-8


/**
 * 
 */
Ext.define('Unilite.com.form.field.UniDateRangeField', {
  	extend: 'Ext.form.FieldContainer',
	alias: 'widget.uniDateRangefield',
    componentLayout: 'uniDateRangefieldLayout',
	mixins: {
        //observable: 'Ext.util.Observable',
        field: 'Ext.form.field.Field',
        label: 'Ext.form.Labelable'
    },
    requires: [
        'Ext.form.field.Date',
        'Ext.form.Label',
        'Unilite.com.form.field.UniDateFieldForRange',
    	'Unilite.com.form.field.UniClearButton',
        'Unilite.com.form.field.UniDateRangeFieldLayout'
    ],
    layout: {
        type: 'hbox',
        align: 'stretch'
    },
    
    /**
     * 
     * @cfg{Object} startDate 
     */
    startDate: null,
    /**
     * 
     * @cfg{Object} endDate 
     */
    endDate:null,
    /**
     * 
     * @cfg{Object} fromFieldName 
     */
    startFieldName:'DATE_FR',
    /**
     * 
     * @cfg{Object} endFieldName 
     */
    endFieldName:'DATE_TO',
    
    onStartDateChange: Ext.emptyFn,
    onEndDateChange: Ext.emptyFn,
    
    constructor : function(config){     
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        
        var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
        me.startDateField =  Ext.create('Unilite.com.form.field.UniDateFieldForRange',{
        	hideTrigger:true,
            hideLabel: true,
            width: 100,
            name: me.startFieldName,
            allowBlank: lAllowBlank,
            listeners: {
            	change: function( field, newValue, oldValue, eOpts ){
            		me.onStartDateChange(field, newValue, oldValue, eOpts);
            	}
            }
        });
        me.endDateField = Ext.create('Unilite.com.form.field.UniDateFieldForRange',{
            hideLabel: true,
            //labelWidth:5,
            width:110,
            //fieldLabel:'~',
            name: me.endFieldName,
            allowBlank: lAllowBlank,
            onTriggerClick: function() {
		        me.onTriggerClick();
		    },
            listeners: {
            	change: function( field, newValue, oldValue, eOpts ){
            		me.onEndDateChange(field, newValue, oldValue, eOpts);
            	}
            }
    	});
        
        me.items =[me.startDateField, {xtype:'label', text:'~', width: '5', style: 'margin-top: 3px!important;'}, me.endDateField ];
        me.callParent(arguments);
    },  // constructor
    
    initComponent: function() {
        var me = this;
        me.callParent(arguments);
        
        
       	me.startDateField.setValue(me.startDate);
        me.endDateField.setValue(me.endDate);
        
        // vtype 설정용 (min/MAX 자동 설정)
        me.endDateField.startDateField = me.startDateField; //.getId();
        me.startDateField.endDateField = me.endDateField;//.getId();
        
    },  // initComponent
    
	/**
	 * 
	 * @cfg {Object[]}   presetPastDates
	 * 주의 !!! month 는 0이 1월임
	 * Example:
     *
     *     presetPastDates: [
     *		{text:'어제',   startDate: moment().add('day',-1),                     endDate: moment().add('day',-1)},
     *		{text:'지난주', startDate: moment().add('week',-1).startOf('week'),    endDate: moment().add('week',-1).endOf('week')},
     *		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
     *		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
     *		{text:'전년도', startDate: moment().add('year',-1).startOf('year'),    endDate: moment().add('year',-1).endOf('year')}
     *	],
     *
	 */
	presetPastDates: [
		{text:'어제',   startDate: moment().add('day',-1),                     endDate: moment().add('day',-1)},
		{text:'지난주', startDate: moment().add('week',-1).startOf('week'),    endDate: moment().add('week',-1).endOf('week')},
		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년도', 
								startDate: moment().add('year',-1).startOf('year'),    
								endDate: moment().add('year',-1).endOf('year')},
		{text:moment().add('year',-1).get('year')+'년 상반기', 	
								startDate: moment().add('year',-1).startOf('year'),    	
								endDate:   moment().add('year',-1).set('month',5).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 하반기', 
								startDate: moment().add('year',-1).set('month',6).startOf('month'),    
								endDate: moment().add('year',-1).endOf('year')},
								
		{text:moment().add('year',-1).get('year')+'년 1사분기', 	
								startDate: moment().add('year',-1).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',-1).set('month',2).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 2사분기', 
								startDate: moment().add('year',-1).set('month',3).startOf('month'),    
								endDate:   moment().add('year',-1).set('month',5).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 3사분기', 	
								startDate: moment().add('year',-1).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',-1).set('month',7).endOf('month')},
		{text:moment().add('year',-1).get('year')+'년 4사분기', 
								startDate: moment().add('year',-1).set('month',8).startOf('month'),    
								endDate:   moment().add('year',-1).set('month',11).endOf('month')},
								
		{text:moment().add('year',-2).get('year')+'년도', 
								startDate: moment().add('year',-2).startOf('year'),    
								endDate: moment().add('year',-2).endOf('year')},								
		{text:moment().add('year',-2).get('year')+'년 상반기', 	
								startDate: moment().add('year',-2).startOf('year'),    	
								endDate: moment().add('year',-2).set('month',5).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 하반기', 		
								startDate: moment().add('year',-2).set('month',6).startOf('month'),    
								endDate: moment().add('year',-2).endOf('year')},
		{text:moment().add('year',-2).get('year')+'년 1사분기', 	
								startDate: moment().add('year',-2).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',-2).set('month',2).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 2사분기', 
								startDate: moment().add('year',-2).set('month',3).startOf('month'),    
								endDate:   moment().add('year',-2).set('month',5).endOf('month')},								
		{text:moment().add('year',-2).get('year')+'년 3사분기', 	
								startDate: moment().add('year',-2).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',-2).set('month',7).endOf('month')},
		{text:moment().add('year',-2).get('year')+'년 4사분기', 
								startDate: moment().add('year',-2).set('month',8).startOf('month'),    
								endDate:   moment().add('year',-2).set('month',11).endOf('month')}								
	],
	/**
	 * 
	 * @cfg {Object[]}   presetDates
	 * Example:
     *
     *     presetDates: [
     *		{text:'어제',   startDate: moment().add('day',-1),                     endDate: moment().add('day',-1)},
     *		{text:'지난주', startDate: moment().add('week',-1).startOf('week'),    endDate: moment().add('week',-1).endOf('week')},
     *		{text:'한달전', startDate: moment().add('month',-1).startOf('month'),    endDate: moment().add('month',-1).endOf('month')},
     *		{text:'두달전', startDate: moment().add('month',-2).startOf('month'),    endDate: moment().add('month',-2).endOf('month')},
     *		{text:'전년도', startDate: moment().add('year',-1).startOf('year'),    endDate: moment().add('year',-1).endOf('year')}
     *	   ],
     *
	 */
    presetDates: [
        {text:'오늘',   startDate: moment(),										endDate: moment()},
        {text:'이번주', startDate: moment().startOf('week'),                       	endDate: moment().endOf('week')},
        {text:'이번달', startDate: moment().startOf('month'),                      	endDate: moment().endOf('month')},
        {text:'최근6개월', startDate: moment().add('month',-6).startOf('month'),    endDate: moment()},
        {text:'금년도', startDate: moment().startOf('year'),    					endDate: moment().endOf('year')},
		{text:'상반기', startDate: moment().startOf('year'),    endDate: moment().set('month',5).endOf('month')},
		{text:'하반기', startDate: moment().set('month',6).startOf('month'),    endDate: moment().endOf('year')},
		{text:'1사분기', 	
						startDate: moment().set('month',0).startOf('month'),    	
						endDate:   moment().set('month',2).endOf('month')},
		{text:' 2사분기', 
						startDate: moment().set('month',3).startOf('month'),    
						endDate:   moment().set('month',5).endOf('month')},								
		{text:'3사분기', 	
						startDate: moment().set('month',6).startOf('month'),    	
						endDate:   moment().set('month',7).endOf('month')},
		{text:'4사분기', 
						startDate: moment().set('month',8).startOf('month'),    
						endDate:   moment().set('month',11).endOf('month')}	
    ],
	/**
	 * 
	 * @cfg {Object[]}   presetFutureDates
	 * Example:
     *
     *     presetDates: [
     *		{text:'내일',   startDate: moment().add('day',1),                     endDate: moment().add('day',1)},
     *		{text:'다음주', startDate: moment().add('week',1).startOf('week'),    endDate: moment().add('week',1).endOf('week')},
     *		{text:'한달후', startDate: moment().add('month',1).startOf('month'),    endDate: moment().add('month',1).endOf('month')},
     *		{text:'두달후', startDate: moment().add('month',2).startOf('month'),    endDate: moment().add('month',2).endOf('month')},
     *		{text:'내년도', startDate: moment().add('year',1).startOf('year'),    endDate: moment().add('year',1).endOf('year')}
     *	   ],
     *
	 */    
    presetFutureDates: [
		{text:'내일',   startDate: moment().add('day',1),                     endDate: moment().add('day',1)},
		{text:'다음주', startDate: moment().add('week',1).startOf('week'),    endDate: moment().add('week',1).endOf('week')},
		{text:'한달후', startDate: moment().add('month',1).startOf('month'),    endDate: moment().add('month',1).endOf('month')},
		{text:'두달후', startDate: moment().add('month',2).startOf('month'),    endDate: moment().add('month',2).endOf('month')},
		{text:moment().add('year',1).get('year')+'년도', startDate: moment().add('year',1).startOf('year'),    endDate: moment().add('year',1).endOf('year')},
		{text:moment().add('year',1).get('year')+'년 상반기', 	
								startDate: moment().add('year',1).startOf('year'),    	
								endDate:   moment().add('year',1).set('month',5).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 하반기', 
								startDate: moment().add('year',1).set('month',6).startOf('month'),    
								endDate: moment().add('year',1).endOf('year')},
								
		{text:moment().add('year',1).get('year')+'년 1사분기', 	
								startDate: moment().add('year',1).set('month',0).startOf('month'),    	
								endDate:   moment().add('year',1).set('month',2).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 2사분기', 
								startDate: moment().add('year',1).set('month',3).startOf('month'),    
								endDate:   moment().add('year',1).set('month',5).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 3사분기', 	
								startDate: moment().add('year',1).set('month',6).startOf('month'),    	
								endDate:   moment().add('year',1).set('month',7).endOf('month')},
		{text:moment().add('year',1).get('year')+'년 4사분기', 
								startDate: moment().add('year',1).set('month',8).startOf('month'),    
								endDate:   moment().add('year',1).set('month',11).endOf('month')}		
		
    ],

    
    makeMenu: function(mtext, presets) {
    	var me = this;
        var menu = Ext.create('Ext.menu.Menu', {
    		plain: true,
            text:mtext
        });
        Ext.each(presets,function(p,i){
        	var dispFormat ='YYYY.MM.DD';
            var startDT, endDT;
            var memuText = p.text;
            
            if(typeof p.startDate === 'object' ) {
                startDT = p.startDate.format(UniDate.mommentDBformat);
                endDT = p.endDate.format(UniDate.mommentDBformat);
                memuText = memuText + ' : '+p.startDate.format(dispFormat) + " ~ "+p.endDate.format(dispFormat);
            }
            menu.add({
                text: memuText ,
                handler:function() {
                    me.setValuesAndGo(startDT, endDT);
                }
            });
        }); // forEach
        return menu;
    },
	_makePanel: function() {
		//this.menu = Ext.create('Ext.panel.Panel', {
		var me = this, p1, p2;
		
		var menuPast = this.makeMenu('과거', this.presetPastDates);
        var menuDates = this.makeMenu('현재',this.presetDates);
        var menuFuture = this.makeMenu('미래',this.presetFutureDates);
        
    	var toolBar = {
    		xtype:'toolbar',
    		dock: 'top',
    		autoShow:true, 
    		defaults: { // defaults are applied to items, not the container
    			autoScroll: true,
    			autoShow: true
			},   
			defaultType:'button',
    		items: [    
    			{xtype:'button', text: '과거',iconCls: 'menu-menuShow',menu: menuPast},
    			{xtype:'button', text: '현재',iconCls: 'menu-menuShow',menu: menuDates},
    			{xtype:'button', text: '미래',iconCls: 'menu-menuShow',menu: menuFuture},
	    	 	{xtype:'button', text:'오늘', colspan:2,  handler:function(){me.setValuesAndGo(UniDate.get("today"), UniDate.get("today"));}},
	    	 	'->',
	    	 	{xtype:'button', text:'확인', handler:function(){me._close();}}
	    	 ]};
		
		var createPicker = function(field, config){
			var datePicker =  Ext.create('Ext.picker.Date', Ext.apply({
		    		format: Unilite.dateFormat,
		    		altFormats: Unilite.altFormats,
		    		minDate: field.minValue,
		            maxDate: field.maxValue,
		            disabledDatesRE: field.disabledDatesRE,
		            disabledDatesText: field.disabledDatesText,
		            disabledDays: field.disabledDays,
		            disabledDaysText: field.disabledDaysText,
		            showToday: field.showToday,
		            startDay: field.startDay,
		            minText: Ext.String.format(field.minText, field.formatDate(field.minValue)),
		            maxText: Ext.String.format(field.maxText, field.formatDate(field.maxValue)),
		            listeners: {
		                scope: field,
		                select: field.onSelect
		            }/*,
		            keyNavConfig: {
		                esc: function() {
		                    me._close();
		                }
		            }*/
	    		}, config) )
	    		
	    		field.uniPicker = datePicker;
	    		return datePicker;
		};
		
		p1 = createPicker(me.startDateField);
		p2 = createPicker(me.endDateField);
		
		p1.addListener('select',function(p,d){
			p2.setMinDate(d);
		});
		p2.addListener('select',function(p,d){
			p1.setMaxDate(d);
		});
		me.startDatePicker  = p1;
		me.endDatePicker  = p2;
						
		
		this.picPanel = Ext.create('Ext.window.Window', {	
			dockedItems: toolBar,
			title:me.fieldLabel,
			hidden:true,
			modal:true,closable:false,
		    defaults: {padding:5},
		    layout : {	type: 'hbox'},
		    listeners : {
		    	scope : this,
		    	show: function(obj, eOpts) {
		    		var st  = me.startDateField.getValue() ;
		    		var ed  = me.endDateField.getValue() ;
		    		
		    		me.startDatePicker.setValue(Ext.isDate(st) ? st : new Date());
		    		me.endDatePicker.setValue(Ext.isDate(ed) ? ed : new Date());		    		
		    	}
		    },
		    items: [
		    	me.startDatePicker,me.endDatePicker
		    ] // items
		});
		//console.log('Made Menu');
	},
	setValuesAndGo:function(startDdate, endDate) {
		this.setValues(startDdate, endDate);
		this._close();
	},
	setValues:function(startDdate, endDate) {
		this.startDateField.setValue(startDdate);
		this.endDateField.setValue(endDate);
		this._updateMinMax();
	},
	_updateMinMax: function() {
		this.startDateField.setMaxValue(this.endDateField.getValue());
		this.endDateField.setMinValue(this.startDateField.getValue());
	},
	_close: function(el) {
		this.picPanel.hide();
		this.endDateField.focus()
	}, 
	/**
	 * 창띄우기
	 * @param {} el
	 */
    onTriggerClick: function() {
    	var me = this;
    	if (me.disabled || me.readOnly) {
			return;
		}
		
		if (me.picPanel === undefined) {
			me._makePanel();
		} // if menu
		
		if(me.picPanel) {
			var targetEl = me.startDateField;
			me.picPanel.showBy(targetEl, "tl-bl?");
			me.picPanel.getEl().on('keydown', function(e, elm){
				switch( e.getKey() ) {
	    			case Ext.EventObject.ESC:
	    				me._close();
	    		}
			});
			//me.picPanel.getDockedItems('toolbar[dock="top"]')[0].items.items[0].getEl().focus();
		}
		//pnl.showBy(el, "tl-bl?");
    }
    
});

//@charset UTF-8
 /**
  * Unilite용 DateField
  */
Ext.define('Unilite.com.form.field.UniDateField', {
    extend: 'Ext.form.field.Date',
    alias: 'widget.uniDatefield',
    format: Unilite.dateFormat,
    enforceMaxLength: true,
    maxLength: 10,
	fieldStyle: 'text-align:center;ime-mode:disabled;',
	/**
	 * 
	 * @cfg {String} submitFormat
	 * 'Ymd',   20131231
	 */
    submitFormat : Unilite.dbDateFormat, 
    altFormats: Unilite.altFormats,
    initComponent: function() {
        	
//    	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
    	this.callParent(arguments);
    }
    /**
     * always return true : 왜? ( 2014.2.21)
     * @return {Boolean}
     */
   // validate: function() {
   // 	return true;
    //}
});  //Ext.define//@charset UTF-8

/**
 * 
 */
Ext.define('Unilite.com.form.field.UniTimeField', {
    extend: 'Ext.form.field.Time',
    alias: 'widget.uniTimefield',
     autoSelect: true,
    format : "h:i A",	// 12H format with leading zero
    altFormats :'H:i|Hi',	// 24H
    submitFormat:'Hi',
    //minValue: '08:00 AM',
    increment: 30,
    initComponent: function() {
        	
//    	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
    	this.callParent(arguments);
    }
});  //Ext.define//@charset UTF-8
Ext.util.Format.thousandSeparator = ',';
/**
 * Unilite용으로 확장된 UniNumber Field
 * 
 *   - 접미사 기능 추가: {@link #suffixTpl}
 *   
 *   - 천단위 구분기호 기능 추가. 
 *     (https://github.com/omids20m/Ext.override.ThousandSeparatorNumberField)
 *     
 */
Ext.define('Unilite.com.form.field.UniNumberField', {
	alias: 'widget.uniNumberfield',
	extend: 'Ext.form.field.Number',
	//extend: 'Ext.ux.form.NumericField',
	hideTrigger: true,
	keyNavEnabled: false,
    mouseWheelEnabled: false,
	forcePrecision: false,
	//fieldStyle: 'text-align:right;',
	fieldStyle: 'ime-mode:disabled;',
	fieldCls: 'x-form-num-field x-form-field',
	
	/**
    * @cfg {Boolean} useThousandSeparator
    */
    useThousandSeparator: true,
    /**
     * @cfg {Integer} decimalPrecision 
     * 소수점 자리수
     * 
     */
    decimalPrecision:0,
    
    uniType: null,
    
	/**
	 *  
	 * @cfg {String} suffixTpl
	 * 접미사
	 * 
	 *     {	fieldLabel: '자녀',  
	 *          name: 'CHILD_CNT'	,
	 *          xtype:'uniNumberfield',	
	 *          suffixTpl:'&nbsp;명'
	 *     }
	 * 
	 */
    suffixTpl: '',

	initComponent: function() {
        	
//    	this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});
    	
    	this.callParent(arguments);
    },
	
	setError: function(active){
		var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, active || '');
            } else {
                //me.updateLayout();
            }
        }
	},
	/**
	 * 접미사 추가를 위해 변경 됨.
	 * @type 
	 */
	fieldSubTpl: [ // note: {id} here is really {inputId}, but {cmpId} is available
       	'<table width="100%" cellpadding="0" cellspacing="0"><tr>',
       	'<td class="x-form-item-body  " width="100%"><input id="{id}" type="{type}" {inputAttrTpl}',
            ' size="1"', // allows inputs to fully respect CSS widths across all browsers
            '<tpl if="name"> name="{name}"</tpl>',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '{%if (values.maxLength !== undefined){%} maxlength="{maxLength}"{%}%}',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx"> tabIndex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
        ' class="{fieldCls} {typeCls} {editableCls} {inputCls}" autocomplete="off"/></td>',
        '<tpl if="suffixTpl">',
        '<td nowrap>{suffixTpl}</td>',
        '</tpl>',
        '</tr></table>',
        {
            disableFormats: true
        }
    ],
    subTplInsertions: [
        /**
         * @cfg {String/Array/Ext.XTemplate} inputAttrTpl
         * An optional string or `XTemplate` configuration to insert in the field markup
         * inside the input element (as attributes). If an `XTemplate` is used, the component's
         * {@link #getSubTplData subTpl data} serves as the context.
         */
        'inputAttrTpl', 'suffixTpl'
    ],
    
     /**
     * @inheritdoc
     */
    toRawNumber: function (value) {
        return String(value).replace(this.decimalSeparator, '.').replace(new RegExp(Ext.util.Format.thousandSeparator, "g"), '');
    },
    /**
     * @inheritdoc
     */
    getErrors: function (value) {
        if (!this.useThousandSeparator)
            return this.callParent(arguments);
        var me = this,
            errors = Ext.form.field.Text.prototype.getErrors.apply(me, arguments),
            format = Ext.String.format,
            num;

        value = Ext.isDefined(value) ? value : this.processRawValue(this.getRawValue());

        if (value.length < 1) { // if it's blank and textfield didn't flag it then it's valid
            return errors;
        }

        value = me.toRawNumber(value);

        if (isNaN(value.replace(Ext.util.Format.thousandSeparator, ''))) {
            errors.push(format(me.nanText, value));
        }

        num = me.parseValue(value);

        if (me.minValue === 0 && num < 0) {
            errors.push(this.negativeText);
        }
        else if (num < me.minValue) {
            errors.push(format(me.minText, me.minValue));
        }

        if (num > me.maxValue) {
            errors.push(format(me.maxText, me.maxValue));
        }

        return errors;
    },
    ///////////////////////
    /**
     * @inheritdoc
     */
     valueToRaw: function (value) {
        if (!this.useThousandSeparator)
            return this.callParent(arguments);
        var me = this;

        var format = "000,000";
        for (var i = 0; i < me.decimalPrecision; i++) {
            if (i == 0)
                format += ".";
            format += "0";
        }
        value = me.parseValue(Ext.util.Format.number(value, format));
        value = me.fixPrecision(value);
        value = Ext.isNumber(value) ? value : parseFloat(me.toRawNumber(value));
        value = isNaN(value) ? '' : String(Ext.util.Format.number(value, format)).replace('.', me.decimalSeparator);
        return value;
    },
    
    /*
	 * 숫자타입으로 강제 규정하기위해 overide 함.
	 * @param {} value
	 * @return {}
	 
    valueToRaw: function(value) {
        var me = this,
            decimalSeparator = me.decimalSeparator;
        value = me.parseValue(value);
        value = me.fixPrecision(value);
        value = Ext.isNumber(value) ? value : parseFloat(String(value).replace(decimalSeparator, '.'));
        if (isNaN(value))
        {
          value = '';
        } else {
          value = me.forcePrecision ? value.toFixed(me.decimalPrecision) : parseFloat(value);
          value = String(value).replace(".", decimalSeparator);
        }
        return value;
    },
    */
    /**
     * @inheritdoc
     */
    getSubmitValue: function () {
        if (!this.useThousandSeparator)
            return this.callParent(arguments);
        var me = this,
            value = me.callParent();

        //if (!me.submitLocaleSeparator) {
            value = me.toRawNumber(value);
       // }
        return value;
    },
    
    /**
     * @inheritdoc
     */
    setMinValue: function (value) {
        if (!this.useThousandSeparator)
            return this.callParent(arguments);
        var me = this,
            allowed;

        me.minValue = Ext.Number.from(value, Number.NEGATIVE_INFINITY);
        me.toggleSpinners();

        // Build regexes for masking and stripping based on the configured options
        if (me.disableKeyFilter !== true) {
            allowed = me.baseChars + '';

            if (me.allowExponential) {
                allowed += me.decimalSeparator + 'e+-';
            }
            else {
                allowed += Ext.util.Format.thousandSeparator;
                if (me.allowDecimals) {
                    allowed += me.decimalSeparator;
                }
                if (me.minValue < 0) {
                    allowed += '-';
                }
            }

            allowed = Ext.String.escapeRegex(allowed);
            me.maskRe = new RegExp('[' + allowed + ']');
            if (me.autoStripChars) {
                me.stripCharsRe = new RegExp('[^' + allowed + ']', 'gi');
            }
        }
    },
    
    /**
     * @private
     */
    parseValue: function (value) {
        if (!this.useThousandSeparator)
            return this.callParent(arguments);
        value = parseFloat(this.toRawNumber(value));
        return isNaN(value) ? null : value;
    }
});//@charset UTF-8
/**
 * UniPopupField용 layout Class
 */
Ext.define('Unilite.com.form.popup.UniPopupFieldLayout', {

    /* Begin Definitions */

   	//extend: 'Ext.layout.component.field.Field',
	extend: 'Ext.layout.component.field.FieldContainer',
	
    //extend: 'Ext.layout.component.Auto',

    alias: 'layout.uniPopupFieldLayout',

    /* End Definitions */
    
    type: 'uniPopupFieldLayout',

    waitForOuterHeightInDom: true,
    waitForOuterWidthInDom: true,

    beginLayout: function(ownerContext) {
        var owner = this.owner;
        this.callParent(arguments);

        // Tell Component.measureAutoDimensions to measure the DOM when containerChildrenSizeDone is true
        ownerContext.hasRawContent = true;
        owner.bodyEl.setStyle('height', '');
        owner.containerEl.setStyle('height', '');
        ownerContext.containerElContext = ownerContext.getEl('containerEl');
    },

    measureContentHeight: function (ownerContext) {
        // since we are measuring the outer el, we have to wait for whatever is in our
        // container to be flushed to the DOM... especially for things like box layouts
        // that size the innerCt since that is all that will contribute to our size!
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    measureContentWidth: function (ownerContext) {
        // see measureContentHeight
        return ownerContext.hasDomProp('containerLayoutDone') ? this.callParent(arguments) : NaN;
    },

    publishInnerWidth: function (ownerContext, width) {
        var bodyContext = ownerContext.bodyCellContext,
            innerWidth = bodyContext.el.getWidth();

        bodyContext.setWidth(innerWidth, false);
        ownerContext.containerElContext.setWidth(innerWidth, false);
    },
    
    publishInnerHeight: function (ownerContext, height) {
        var bodyContext = ownerContext.bodyCellContext,
            containerElContext = ownerContext.containerElContext;
            
        height -= this.measureLabelErrorHeight(ownerContext);
        bodyContext.setHeight(height);
        containerElContext.setHeight(height);
    }
});//@charset UTF-8
/**
 * 
 * Popup
 * 
 * ## Example usage:
 *  
 *    @example
 *    listeners: {
 *			'onSelected':  function(records, type  ){
 *				//var grdRecord = masterGrid.getSelectedRecord();
 *				var grdRecord = masterGrid.uniOpt.currentRecord;
 *				grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
 *			},
 *			'onClear':  function( type  ){
 *				// onClear는 커서가 떠난후 발생하므로 getSlected 사용 안함.
 *				//var grdRecord = masterGrid.getSelectedRecord(); 
 *				var grdRecord = masterGrid.uniOpt.currentRecord;
 *				grdRecord.set('MCUSTOM_NAME','');
 *				grdRecord.set('MANAGE_CUSTOM','');
 *			}
 *		}         
 */
Ext.define('Unilite.com.form.popup.UniPopupAbstract', {
	
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label'
    ],

    /**
     * 
     * @cfg {Boolean} 
     * 잘못된 값을 그냥 둘것인지?
     * 
     * true : 잘못된 값은 clear함 
     * 
     */
    validateBlank : true,	
        /**
     * 
     * @cfg {Boolean} 
     * 
     * default value is false
     * true : 팝업띄우지 않고 검색란에서 검색시 조회 결과가 2건 이상 조회시 onClear를 실행하지 않음 
     */
    allowMulti : false,
    store:'',
    api : '',
    pageTitle:'',
    readOnly: false,
	popupPage : '/com/popup/CustPopup.do',
	popupWidth:700,
	popupHeight:550,
	valueFieldWidth:60,
	textFieldWidth:90,
	extraFieldWidth:90,
	defaults: {
         hideLabel: true
    },
	
	//layout: 'uniPopupFieldLayout',   
    
    /**
     * 
     * @cfg {String}
     */
    valueFieldName: 'VALUE_FIELD',
    /**
     * 
     * @cfg {String}
     */
    textFieldName: 'TEXT_FIELD',
    /**
     * DB의 Value field name 
     * @cfg {String}
     */
    DBvalueFieldName : undefined,
    /**
     * DB의 Text field name 
     * @cfg {String}
     */
    DBtextFieldName : undefined,
    
    textFieldConfig: {},
    /**
     * DB검색시 Like를 사용 할것인지?
     * @cfg {String} useLike
     */
    useLike : false,
    
    //width:320,typeof value !== 'undefined'
    /**
     * api 호출시 추가되는 parameters
     * @type  {Object}
     */
	extParam: {},
    
	//valueField, textField 외 부가필드
	extraFields: [],
	extraFieldsConfig: [],
	
	getDBvalueFieldName:function() {
		return (typeof this.DBvalueFieldName === 'undefined') ? this.valueFieldName : this.DBvalueFieldName;
	},
    getDBtextFieldName:function() {
		return (typeof this.DBtextFieldName === 'undefined') ? this.textFieldName : this.DBtextFieldName;
    	
    },
    /**
     * uniPopup 생성
     * 
     * @param {} config
     */
    constructor : function(config){    
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        me.addEvents(
        	/**
             * @event onSelected
             * 하나의 record가 선택되었을때 발생
             * @param {Array} records
             * @param {String} type
             * [ TEXT | VALUE ] 
             */
        	'onSelected',
        	
        	/**
             * @event onClear
             * 데이타가 지워졌을때 발생 
             * 주의! grid에서 onClear사용시 현재 record 가져올때는 아래 방법 사용 
             *        
			 * @param {String} type
             * [ TEXT | VALUE ]
             */
        	'onClear',
        	'applyextparam'
        );
        //Ext.applyIf(me,{DBvalueFieldName:config.valueFieldName});
        //Ext.applyIf(me,{DBtextFieldName:config.textFieldName});
        
    },  // constructor
   	_supendEvents : function(supend) {
   		var me = this;
   		if(supend) {
       		if(me.valueField) {
   				me.valueField.suspendEvents(false);
       		}
   			me.textField.suspendEvents(false);
   			Ext.each(me.extraFields, function(field){
	        	field.suspendEvents(false);
	        });
   		} else {
   			if(me.valueField) {
   				me.valueField.resumeEvents();
       		}
   			me.textField.resumeEvents();
   			Ext.each(me.extraFields, function(field){
	        	field.resumeEvents();
	        });
   		}
   	},
   	
    _onDataLoad : function( records,   type) {
    	var me = this;
    	if(records.length == 1 || ( me.allowMulti && records.length > 1)) {
    		var rec = records[0];
    		console.log('popup(select) ' + type + ' : select 1 : ' + rec.get(me.getDBtextFieldName()));
    		me._supendEvents(true);
    		if(type == 'TEXT') {
       			if(me.valueField) {
       				//var v= rec.get(me.getDBvalueFieldName());
       				var v = rec.raw[me.getDBvalueFieldName()];
    				me.valueField.setRawValue(v);
       			}
       			//var v= rec.get(me.getDBtextFieldName());
       			var v = rec.raw[me.getDBtextFieldName()];
    			me.textField.setRawValue(v);
    			
    			Ext.each(me.extraFields, function(field){
		        	field.setRawValue(rec.raw[field.name]);
		        	field.uniChanged = false;
		        	field.clearInvalid();
		        });
    		} else {
       			if(me.valueField) {
       				//var v= rec.get(me.getDBvalueFieldName());
       				var v = rec.raw[me.getDBvalueFieldName()];
    				me.valueField.setRawValue(v);
       			}
       			//var v= rec.get(me.getDBtextFieldName());
       			var v = rec.raw[me.getDBtextFieldName()];
    			me.textField.setRawValue(v);
    			
    			Ext.each(me.extraFields, function(field){
		        	field.setRawValue(rec.raw[field.name]);
		        	field.uniChanged = false;
		        	field.clearInvalid();
		        });
    		}
    		me.textField.uniChanged = false;
    		me.textField.clearInvalid();
    		if(me.valueField) {
    			me.valueField.uniChanged = false;
    			me.valueField.clearInvalid();
    		}
    		me._supendEvents(false);
    		
    		// data에는 fields에 정의된 값만 있음 !!!
    		me.fireEvent('onSelected',  [rec.raw], type);	
    		//this._fireBlurEvent(null);
    	} else if (records.length > 1) {
    		console.log('DATA Loaded:', type, records.length);
    		if(me.validateBlank ) {
    			console.log('onClear on records:' + records.length);
    			me._clearValue(me,type);
    		}else{
    			me.openPopup(type);
    		}
    	} else {
    		if(me.validateBlank) {
    			console.log('onClear on records:' + records.length);
    			me._clearValue(me,type);
    		}else{
    			me.openPopup(type);
    		}
    	}
    }
    ,_clearValue : function (me, type) {
    	if(type == 'TEXT') {
   			if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
   			}
			me.textField.setValue('');
			me.textField.validate();
		} else {
   			if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
   			}
			me.textField.setValue('');
			me.textField.validate();
		}
		Ext.each(me.extraFields, function(field){
	    	field.setValue('');
			field.validate();
	    });
    	me.fireEvent('onClear',  type);	
    },
    _checkReadOnly: function() {
    	var rv = false;
    	var me = this;
    	if(me.valueField ) {
    		if(me.valueField.readOnly) return true;
    	}
    	if(me.textField.readOnly) {
    		return true;
    	} else {
    		return false;
    	}
    	
    },
    openPopup: function(type) {
        var me = this;
        if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
        
	        var param = me.extParam;
	        //param['page'] = 'CustPopup';
	        
	        if(!me.textField.readOnly)	{
		        if(me.valueField ) {
		            param[me.getDBvalueFieldName()] = me.valueField.getValue().trim()   ;
		        }
		        //param[me.getDBtextFieldName()] = me.textField.getValue();   
		        
		        if(me.textField instanceof Ext.form.field.Date) {
	       			param[me.getDBtextFieldName()]  = me.textField.getSubmitValue();
	       		}else{
					param[me.getDBtextFieldName()]  = me.textField.getValue();
	       		}
		        param['TYPE'] = type;   
		        param['pageTitle'] = me.pageTitle;
		        
		        if(me.app) {
		            var fn = function() {
		                var oWin =  Ext.WindowMgr.get(me.app);
		                if(!oWin) {
		                    oWin = Ext.create( me.app, {
		                            id: me.app, 
		                            callBackFn: me.processResult, 
		                            callBackScope: me, 
		                            popupType: type,
		                            width: me.popupWidth,
		                            height: me.popupHeight,
		                            title:me.pageTitle,
		                            param: param
		                     });
		                }
		                oWin.fnInitBinding(param);
		                oWin.center();
		                // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
		                oWin.show();
		            };
		            Unilite.require(me.app, fn, this, true);
		//            Ext.require(me.app, fn);            
		        } else {
		            me.openPopupModalDialog(param,type)
		        }
	        }
        }
    },
    processResult: function(result, type) {
        var me = this, rv;
        console.log("Result: ", result);
        if(Ext.isEmpty(result)) {
        	if(type == 'VALUE') {
        		if( Ext.isDefined(me.valueField) ) {
        			me.valueField.focus();
        		}
        	}else{
        		me.textField.focus();
        	}
        }else{
	        if(Ext.isDefined(result) && result.status == 'OK') {
//	            if( Ext.isDefined(me.valueField) ) {
//	                me.valueField.suspendEvents(false);
//	            }
//	            me.textField.suspendEvents(false);
	        	me._supendEvents(true);
	            
	            var rec = result.data[0];
	            //console.log("RV:", me.DBtextFieldName, rec[me.DBtextFieldName], rec);
	            
	            if( Ext.isDefined(me.valueField) ) {
	                me.valueField.setValue(rec[me.DBvalueFieldName]);
	                me.valueField.clearInvalid();
	            }
	            me.textField.setValue(rec[me.getDBtextFieldName()]);
	            me.textField.clearInvalid();	            
	            //console.log("value : ", me.DBvalueFieldName," text : ",me.getDBtextFieldName())
	            Ext.each(me.extraFields, function(field){
		        	field.setValue(rec[field.name]);
		        	field.clearInvalid();
		        });
	            
	            //me.textField.focus();
	            me._focusNext(me.textField);	//2014.09.03 값 입력 후 다음 필드 포커스 이동 구현.
	            
//	            if( Ext.isDefined(me.valueField) ) {
//	                me.valueField.resumeEvents();
//	            }
//	            me.textField.resumeEvents();
	            me._supendEvents(false);
	            
	            me.fireEvent('onSelected',  result.data, type); 
	            this._fireBlurEvent(null);
	        }
        }
    },
    
    openPopupModalDialog: function(param, type) {
    	var me = this;
    	var width = me.popupWidth, height = me.popupHeight;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
	
		
	
		// readonly면 popup 불가.
		if(me._checkReadOnly()) return false;
		
	    var sParam = UniUtils.param(param);
	    console.log("Parameters : ", param, sParam);
	    var features = "help:0;scroll:0;status:0;center:yes;" +
	           // "dialogTop="+yPos + "px;dialogLeft="+xPos +"px;" +
	            ";dialogWidth="+width +"px;dialogHeight="+height+"px" ;
	
	    var rv = window.showModalDialog(CPATH+me.popupPage+'?'+sParam, param, features);
	    me.processResult(rv, type);

	    
    },
   
   
    // private
    getLayoutItems: function() {
    	var me = this;
        return  me.items.items;
    }
    /**
     * 
     * @param {} v
     */
    ,setValue:function(v) {
    	this.textField.setValue(v);
    }
    /**
     * 
     */
    ,getValue: function() {
    	this.textField.getValue();
    }
    /**
     * 
     */
    ,reset:function() {
    	this.textField.reset();
    	
       	if(this.valueField) {
    		this.valueField.reset();
       	}
       	Ext.each(this.extraFields, function(field){
        	field.reset();
        });
    },
    isValid: function() { return true; },
    
    /**
     * 강제로 값을 조회하게 함.
     * @param {} type
     */
    lookup:function(type) {
    	var me = this;
    	var elm = "";
    	if( type == 'TEXT') {
    		elm = me.textField;
    	} else {
    		elm = me.valueField;
    	}
    	console.log("lookup",elm, type) ;
    	this._onFieldBlur(elm, type, true) ;
    },
    /*
    onFieldBlur: function( field, e ){ 
    	var items = this.field.items.items;
            
        for( var index = 0; index < items.length; index++ )
        {
            if (items[ index ].hasFocus) {
                return;
            }
        }
        
        this.onFieldBlur( field, e );
    },
    */
    defaultRenderer: function(value){
    	
    	return this.textField.getValue();
    },
    // value : {key: value, key2: value2}
    setExtParam : function(param)	{
    	var me = this;
    	Ext.Object.merge(me.extParam, param);
    	//me.extParam = param; 
    },
    // private  valuefield ( Code 값 저장 )
    _getValueFieldConfig:function(isHidden) {
    	var me = this, lHidden = isHidden || false;;
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	 return {
            xtype: 'textfield',
            id: this.id + '-valueField',
            //triggerCls :'x-form-search-trigger',
            labelWidth: 0,
            padding:0, margin:0,
            hideLabel: true,
            width: me.valueFieldWidth,
            label:'Code',
            name: this.valueFieldName,
            allowBlank : lAllowBlank,
            enableKeyEvents: true,
		    uniChanged : false,
		    uniPopupChanged : false,
		    uniOpt:this.uniOpt,
		    hidden: lHidden,
		    readOnly:me.readOnly,
            isPopupField: true,
            popupField: me,
		    
            /*
            onTriggerClick: function() {
		        me.openPopup( 'VALUE');
		    },
		    */
            listeners: {
            	'render' : function(c) {
            		 c.getEl().on('dblclick', function(){
					    	me.openPopup( 'VALUE');
					  });
            	},
                'blur': {
                    fn: function(elm){
                        this._onFieldBlur(elm, 'VALUE');
                    },
                    scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                        this._onFieldChange(elm, 'VALUE', newValue, oldValue);
                    }
                    ,scope: this
					,delay:1
                },
                'keydown': {
                  	fn: function(elm, e){
                  		switch( e.getKey() ) {
                  			case Ext.EventObject.F8:
                  				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
                  					me.openPopup( 'TEXT');
                  					e.stopEvent();
                  				}
                    			break;
//                            case Ext.EventObject.ENTER:
//                            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//			                		Unilite.focusPrevField(elm);
//			                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//			                		Unilite.focusNextField(elm);
//			                	}
//			                	break;
//			                case Ext.EventObject.LEFT:
//				            	var pos = elm.getCaretPosition(elm);
//				            	if(pos < 1) {
//				            		Unilite.focusPrevField(elm, false, e);
//				            	}
//				            	break;
//				            case Ext.EventObject.RIGHT:
//				            	var pos = elm.getCaretPosition(elm);
//				            	var len = (Ext.isEmpty(elm.getRawValue()) ? 0 : elm.getRawValue().length);
//				            	if(pos >= len) {
//				            		Unilite.focusNextField(elm, false, e);
//				            	}
//				            	break;	
                  		}
                  	} // fn
                    ,scope: this
                }  
            }
        };
    },
    // private
    _getTextFieldConfig: function() {
    	var me = this;
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	return Ext.apply({
            xtype: 'triggerfield',
            //flex:1,
            id: this.id + '-textField',
            triggerCls :'x-form-search-trigger',
            labelWidth: 0,
            padding:0, margin:0,
            hideLabel: true,
            name:this.textFieldName,
            enableKeyEvents: true,
            allowBlank : lAllowBlank,
            fieldStyle: me.textFieldStyle,
            width:me.textFieldWidth,
            onTriggerClick: function() {
		        me.openPopup( 'TEXT');
		    },
		    uniOpt:this.uniOpt,
		    uniChanged : false,
		    uniPopupChanged : false,
		    readOnly:me.readOnly,
            isPopupField: true,
            popupField: me,
            listeners: {
            	'render' : function(c) {
            		 c.getEl().on('dblclick', function(){
					    	me.openPopup( 'TEXT');
					  });
            	},
                'blur': {
                    fn: function(elm){
                        this._onFieldBlur(elm, 'TEXT');
                    }
                    ,scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                        this._onFieldChange(elm, 'TEXT', newValue, oldValue);
                    }
                    ,scope: this
					,delay:1
                },
                'keydown': {
                  	fn: function(elm, e){
                  		switch( e.getKey() ) {
                  			case Ext.EventObject.F8:
                  				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
                  					me.openPopup( 'TEXT');
                  					e.stopEvent();
                  				}
                    			break;
//                            case Ext.EventObject.ENTER:
//                            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//			                		Unilite.focusPrevField(elm);
//			                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//			                		Unilite.focusNextField(elm);
//			                	}
//			                	break;
//			                case Ext.EventObject.LEFT:
//				            	var pos = elm.getCaretPosition(elm);
//				            	if(pos < 1) {
//				            		Unilite.focusPrevField(elm, false, e);
//				            	}
//				            	break;
//				            case Ext.EventObject.RIGHT:
//				            	var pos = elm.getCaretPosition(elm);
//				            	var len = (Ext.isEmpty(elm.getRawValue()) ? 0 : (typeof elm.getRawValue() == 'string' ?  elm.getRawValue().length : 0));
//				            	if(pos >= len) {
//				            		Unilite.focusNextField(elm, false, e);
//				            	}
//				            	break;	
                  		}
                  	} // fn
                  	,scope: this
                }                  
            }
    	}, me.textFieldConfig);
    },
    
    _getExtraFieldsConfig: function() {
    	var me = this;
    	var fields = [];
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	
    	if(!Ext.isEmpty(me.extraFieldsConfig)) {
    		Ext.each(me.extraFieldsConfig, function(config){
    			fields.push(
    				{
			            xtype: 'textfield',
			            id: me.id + '-extraField'+ '-' + config.extraFieldName,
			            labelWidth: 0,
			            padding:0, margin:0,
			            hideLabel: true,
			            width: Ext.isDefined(config.extraFieldWidth) ? config.extraFieldWidth: me.extraFieldWidth,
			            name: config.extraFieldName,
			            allowBlank : lAllowBlank,
			            enableKeyEvents: true,
					    uniChanged : false,
					    uniPopupChanged : false,
					    uniOpt:me.uniOpt,
					    readOnly: Ext.isDefined(config.readOnly) ? config.readOnly: true,
			            isPopupField: true,
			            popupField: me,
			            listeners: {
			            	'blur': {
			                    fn: function(elm){
			                        me._onFieldBlur(elm, 'TEXT');
			                    }
			                    ,scope: me
								,delay:1
			                },
			                'change': {
			                    fn: function(elm, newValue, oldValue, eOpts){
			                        me._onFieldChange(elm, 'EXTRA', newValue, oldValue);
			                    }
			                    ,scope: me
								,delay:1
			                }	                
			            }
			    	}
    			)    			
    		});
    	}
    	
    	return fields;
    },
    _onFieldChange : function (elm, type, newValue, oldValue) {
    	elm.uniChanged = true;
    	elm.uniPopupChanged = true;
    },
    _onFieldBlur : function(elm, type, force) {
	    var me = this;
	    if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
			if( Ext.isEmpty(elm.getValue() ) && !me.validateBlank ) {
	    		if(type == 'VALUE') {
	    			if(me.textField){
	    				me.textField.setValue();
	    			}
	    		} else if(type == 'TEXT'){
	    			if(me.valueField) {
	    				me.valueField.setValue();
	    			}
	    		}
	    		Ext.each(me.extraFields, function(field){
		        	field.setValue();
		        });
	    		
	    	} else {
	    		
	    		// isDirty() ? uniChanged (onChange 기반이라 DEL이나 일부 이벤트 처리 안됨)
		    	if(( elm.uniPopupChanged  ) || force) {
		    		
			    	/*if(type == 'TEXT' && me.valueField) {
			    		if(!Ext.isEmpty(me.valueField.getValue().trim())) {
			    			return;
			    		}
			    	}*/
		    	
		    		elm.resetOriginalValue();
		    		elm.uniChanged = false;
		    		//elm.uniOpt.oldValue=elm.uniOpt.lastValidValue;	//2014.09.02 영업기회진행종합->영업기회세부정보에서 null 참조 오류
		    		if(!Ext.isEmpty(elm.uniOpt) && !Ext.isEmpty(elm.uniOpt.lastValidValue)){
		    			elm.uniOpt.oldValue=elm.uniOpt.lastValidValue;
		    		}
		    		console.log(type + "_onValueFieldChange:",elm.getValue(), elm);
		    		elm.setValue(elm.value);
		    		
		    		var  param = me.extParam;
		    		
			       	if(me.valueField && type == 'VALUE') {
			    		param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
			    		param[me.getDBtextFieldName()] = '';
			       	}
			       	if( type == 'TEXT') {
			       		if(me.textField instanceof Ext.form.field.Date) {
			       			param[me.getDBtextFieldName()]  = me.textField.getSubmitValue().trim();
			       		}else{
		    				param[me.getDBtextFieldName()]  = me.textField.getValue().trim();
			       		}
		    			if(me.valueField) {
		    				//param[me.getDBvalueFieldName()] = '';
		    				param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
		    			}
			       	}
		    		param['TYPE'] = type;
		    		param['USELIKE'] = me.useLike;
                    Ext.getBody().mask();
                    //console.log('mask');
		    		me.store.load({
						params: param,
						limit: 2,
						scope: this,
						callback: function(records, operation, success) {
                            console.log('unmask');
                            Ext.getBody().unmask(); 
							if(success) {
								me._onDataLoad(records,  type);
							}
						}
					});    	
		    	}
		    }
    	elm.uniPopupChanged = false;
	    }
    },
    _fireBlurEvent:function(obj) {
    	var me = this;
    	//	this.textField.fireEvent('blur', this.textField);
    	
    	if( Ext.isDefined(me.valueField) ) {
			me.valueField.uniPopupChanged = false;
    	}
		me.textField.uniPopupChanged = false;
		Ext.each(me.extraFields, function(field){
        	field.uniPopupChanged = false;
        });
    },
    
    //값 입력 후 form 상에서 다음 form field에 포커스 이동
    _focusNext: function(field) {
    	
    	var me = this;
    	
    	var nextEl = null;
    	var fieldCell = me.el.up('.x-table-layout-cell');
    	
    	if(fieldCell && fieldCell.parent()) {
    		//nextEl = fieldCell.parent().next().down('.x-form-field');
    		var obj = fieldCell.parent().next();
    		if(obj) {
    			//nextEl = obj.query(':focusable')[0];
    			nextEl = obj.query('input:first-child')[0];
    		}
    	}
    	if(nextEl) {
    		nextEl.focus();
    		nextEl.select();
    	}else{
    		field.focus();
    	}
    	
    }
   
});//@charset UTF-8
/**
 * 
 * event  onSelected : function( type(VALUE|TEXT), records(선택된 레코드들))
 * 
 */
Ext.define('Unilite.com.form.popup.UniPopupField', {
    extend: 'Ext.form.FieldContainer',
    alias: 'widget.uniPopupField',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniPopupAbstract'
    },
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label',
   		'Unilite.com.form.popup.UniPopupFieldLayout'
    ],
    
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 보여줄것인지 여부
     * 
     * true : value 필드를 hidden 처리함.
     * 
     */
    showValue:true,
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 사용할지 여부
     * 
     * true : value field를 생성하지 않음.
     * 
     */
    textFieldOnly:false,
    
    padding: '0 0 0 0',
   	defaults: {
         hideLabel: true
    },
    componentLayout: 'uniPopupFieldLayout',
    layout: {
        type: 'table', columns: 2
        //,defaultMargins: { top: 0, right: 2, bottom: 0, left: 0 }
    },
    constructor : function(config){     
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        me.mixins.popupBehaviour.constructor.call(me, config);
        me.callParent(arguments);
        me.addEvents('onSelected');
        
        this.store = new Ext.create('Ext.data.Store', {
        	autoload:false,
        	fields:[
		    	me.valueFieldName, 
		    	me.textFieldName
		    ],
        	proxy:{
		    	type: 'direct',
				        api: {
				        	read: me.api //'popupService.custPopup'
				        }
				    }
		        });
    },
    setReadOnly: function(readOnly) {
    	var me = this;
    	if( me.valueField) {
        	me.valueField.setReadOnly(readOnly);
        }
        me.textField.setReadOnly(readOnly);
        Ext.each(me.extraFields,  function(field){
        	field.setReadOnly(readOnly);
        });
    },
    // private
    initComponent: function() {
        var me = this;
        me.addCls('uni-popup-fields');
        //console.log("me.textFieldName", me.textFieldName, me.allowBlank);
        
   		var f1 = me._getValueFieldConfig(!me.showValue);
   		var f2 = me._getTextFieldConfig();
   		var others = me._getExtraFieldsConfig();
   		Ext.apply(f1, {fieldCls : 'x-form-field ' + me.fieldCls});
   		Ext.apply(f2, {fieldCls : 'x-form-field ' + me.fieldCls});
   		
   		var layoutCols = me.layout.columns;
   		if(!Ext.isEmpty(others)){
   			Ext.each(others, function(field) {
   				Ext.apply(field, {fieldCls : 'x-form-field ' + me.fieldCls});
   				layoutCols ++;
   			});
   			
   			Ext.apply(me.layout, {columns: layoutCols});
   		}
   		
   		
   		if(me.verticalMode) {
	       	if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[Ext.applyIf(f1, {colspan: 2, margin: '0 5 0 0'}), f2 ];
	       		
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	} else {
       		if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[f1, f2 ];
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	}
       	
        me.callParent(arguments);
        me.initRefs();
    },
    // private
    initRefs:function() {
    	var me = this;
       	if(! me.textFieldOnly) {
        	me.valueField = me.down('#' + me.id + '-valueField');
        }
        me.textField = me.down('#' + me.id + '-textField');
        me.extraFields = me.query('textfield[id^=' + me.id + '-extraField]');
    },
    getExtraFields: function() {
    	return me.extraFields;	
    }
});//@charset UTF-8
/**
 * 
 * Grid 용 popup
 * 
 * ## Example usage:
 *  
 *		@example
 *
 * 		{ 	dataIndex:'MCUSTOM_NAME',	
 *			'editor' : Unilite.popup('CUST_G',{						            
 *					textFieldName:'MCUSTOM_NAME',
 *				    listeners: {
 *						'onSelected':  function(records, type  ){
 *						 	//var grdRecord = masterGrid.getSelectedRecord();
 *						 	var grdRecord = masterGrid.uniOpt.currentRecord;
 *						 	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
 *						 }
 *						 ,'onClear':  function( type  ){
 *						 	//var grdRecord = masterGrid.getSelectedRecord();
 *						 	var grdRecord = masterGrid.uniOpt.currentRecord;
 *						 	grdRecord.set('MCUSTOM_NAME','');
 *						 	grdRecord.set('MANAGE_CUSTOM','');
 *						 }
 *					} // listeners
 *				}) // Unilite.popup
 *		}
 */
Ext.define('Unilite.com.form.popup.UniPopupColumn', {
    extend: 'Ext.form.field.Trigger',
    alias: 'widget.uniPopupColumn',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniPopupAbstract'
    },
    store:'',
    triggerCls :'x-form-search-trigger',
	enableKeyEvents: true,
	validateBlank : true,	// 잘못된 값을 그냥 둘것인지? true = 잘못된 값은 clear함 
	onTriggerClick: function() {
	    this.openPopup( 'TEXT');
	},
    textFieldName: 'CUSTOM_NAME',
	//popupPage : '/com/popup/CustPopup.do',
	popupWidth:700,
	popupHeight:500,
	//width:150,
	validateOnChange:false,
	uniPopupChanged : false,
	uniOpt:{},
	validator: function() {
		console.log('validator -> _onFieldBlur');
		var rv = this._onFieldBlur(this.textField, 'TEXT', false);
		return true;
	}, 
    constructor : function(config){    
        var me = this;
        config.trackResetOnLoad = true;
        me.callParent(arguments);
        me.addEvents('onSelected');
        me.mixins.observable.constructor.call(me, config);
        me.mixins.popupBehaviour.constructor.call(me, config);
        me.textField = this;
        
        me.store = new Ext.create('Ext.data.Store', {
        	autoload:false,
        	fields:[ me.valueFieldName,  me.textFieldName ],
        	proxy:{
		    	type: 'direct',
				api: {
                    read: me.api //'popupService.custPopup'
				}
			},
            listeners: {
            }
		});
    },
    _clearValue : function (me, type) {
    	me.setValue('');
    	me.fireEvent('onClear',  type);	
    },
    // private
    initComponent: function() {
        var me = this;
    	
    	me.on('render',function(c) {        		
    		 c.getEl().on('dblclick', function(){			    	
			    	me.openPopup( 'TEXT');
			  });
        }); // render
        /*
         * me.on('blur', function(elm, e, eOpts ) {
        	//console.log('blur');
        	elm._onFieldBlur(me.textField, 'TEXT', false);
        } ); // blur
        */
        me.on('change', function(elm, newValue, oldValue, eOpts ) {
        	//console.log('change');
        	me._onFieldChange(me.textField, 'TEXT', newValue, oldValue);
        	//elm._onFieldBlur(me.textField, 'TEXT', false);
        } ); // blur
        
        // special key down
        me.on('keydown', function(elm, e){
	      		//console.log("KEYS:", evt.getKey());
	      		switch( e.getKey() ) {
	      			case Ext.EventObject.F8:
	      				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
	      			 		elm.openPopup( 'TEXT');
	      			 		e.stopEvent();
	      				}
	        			break;
	      		}
        } ); // keydown
        
        me.callParent(arguments);
    }
   
});////@charset UTF-8
/**
 * @class Unilite
 * Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.apply(Unilite,{
	/**
	 * ## popup 설정 생성 함수. 
	 * 
	 * Grid 용 : {@link Unilite.com.form.popup.UniPopupColumn}.
	 * Form용 :  {@link Unilite.com.form.popup.UniPopupField}.
	 * 
	 * @param {} sPopItem
	 * 'CUST' :	거래처
	 * 'CUST_G' : 거래처 그리드용
	 * 
	 * @param {} config
	 * @return {PopupConfig}
	 */
	popup: function(sPopItem, config ) {
		var rv={} ;

		if (sPopItem == 'CUST' ) { 		// 거래처 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
			    app: 'Unilite.app.popup.CustPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
			    app: 'Unilite.app.popup.CustPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST' ) { 		// 거래처 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
                app: 'Unilite.app.popup.AgentCustPopup',
                //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    popupWidth: 800,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
			    app: 'Unilite.app.popup.AgentCustPopup',
			    //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    popupWidth:800,
			    pageTitle: '거래처정보'
			};
		}else if (sPopItem == 'CUSTOMER' ) { 	// 고객정보 ( CLIENT_ID, CLIENT_NAME)
		
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '고객',
			    valueFieldName:'CLIENT_ID',
			    textFieldName:'CLIENT_NAME',
			    DBvalueFieldName: 'CLIENT_ID',
			    DBtextFieldName: 'CLIENT_NAME',
			    api: 'cmPopupService.clientPopup',
			    app: 'Unilite.app.popup.ClientPopup',			    
			    //popupPage: '/crm/ClientPopup.do',
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CUSTOMER_G' ) {  // 고객 그리드용
		
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'CLIENT_NAME',
			    DBtextFieldName: 'CLIENT_NAME',
			    //api: 'cmPopupService.clientPopup',
			    app: 'Unilite.app.popup.ClientPopup',
			    popupPage: '/crm/ClientPopup.do',
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT' ) {	// 고객정보 ( CUSTOMER_ID, CUSTOMER_NAME)	
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '영업기회',
			    valueFieldName:'PROJECT_NO',
			    textFieldName:'PROJECT_NAME',
			    DBvalueFieldName: 'PROJECT_NO',
			    DBtextFieldName: 'PROJECT_NAME',
                api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT2' ) {	// 고객정보 ( CUSTOMER_ID, CUSTOMER_NAME)
			
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '영업기회',
			    textFieldName:'CLIENT_NM', 
			    valueFieldName : 'CLIENT',
			    DBtextFieldName:'CLIENT_NAME', 
			    DBvalueFieldName : 'CLIENT_ID',
                api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT_G' ) {	// 고객 그리드용
	 
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PROJECT_NAME',
			    DBtextFieldName: 'PROJECT_NAME',
			    api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'BANK' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '금융기관',
			    valueFieldName:'BANK_CODE',
			    textFieldName:'BANK_NAME',
			    DBvalueFieldName: 'BANK_CODE',
			    DBtextFieldName: 'BANK_NAME',
			    api: 'popupService.bankPopup',
			    app: 'Unilite.app.popup.BankPopup',
			    //popupPage: '/com/popup/bk/BankPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '은행'
			};
		} else if (sPopItem == 'BANK_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'BANK_NAME',
			    DBtextFieldName: 'BANK_NAME',
			    api: 'popupService.bankPopup',
			    app: 'Unilite.app.popup.BankPopup',
			    //popupPage: '/com/popup/bk/BankPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '은행'
			};
		} else if (sPopItem == 'ZIP' ) {	
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '우편번호',
			    valueFieldName:'ZIP',
			    textFieldName:'ZIP_CODE',
			    DBvalueFieldName: 'ZIP_CODE',
			    DBtextFieldName: 'ZIP_NAME',
			    api: 'popupService.zipPopup', 
			    app: 'Unilite.app.popup.ZipPopup',
			    //popupPage: '/com/popup/bk/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
				textFieldStyle: 'text-align:center;',
			    pageTitle: '우편번호'
			};
		} else if (sPopItem == 'ZIP_G' ) {	
		 
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'ZIP_CODE',
			    DBtextFieldName: 'ZIP_CODE',
			    api: 'popupService.zipPopup',
			    app: 'Unilite.app.popup.ZipPopup',
			    //popupPage: '/com/popup/bk/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
			    pageTitle: '우편번호'
			};
		} else if (sPopItem == 'USER' ) {				
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사용자',
			    valueFieldName:'USER_ID',
			    textFieldName:'USER_NAME',
			    DBvalueFieldName: 'USER_ID',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/bk/UserPopup.do',                
			    popupWidth:650,
			    popupHeight:400,
			    pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'USER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'USER_ID',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/bk/UserPopup.do',
			    popupWidth:500,
			    popupHeight:300,
			    pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'Employee' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
			    DBvalueFieldName: 'PERSON_NUMB',
			    DBtextFieldName: 'NAME',
			    api: 'popupService.employeePopup',
			    app: 'Unilite.app.popup.EmployeePopup',
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'Employee_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'NAME',
			    DBtextFieldName: 'NAME',
			    api: 'popupService.employeePopup',
			    app: 'Unilite.app.popup.EmployeePopup',
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'DEPT' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서',
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:350,
			    popupHeight:400,
			    pageTitle: '부서코드'
			};
		} else if (sPopItem == 'DEPT_G' ) {
		
			rv = {
				xtype: 'uniPopupColumn',
			    textFieldName:'DEPT_NAME',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:350,
			    popupHeight:400,
			    pageTitle: '부서코드'
			};
		} else if (sPopItem == 'ITEM' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup',
			    app: 'Unilite.app.popup.ItemPopup',
			    //popupPage: '/com/popup/bk/ItemPopup.do',
			    pageTitle: '품목정보'
			};
		} else if (sPopItem == 'ITEM_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup',
			    app: 'Unilite.app.popup.ItemPopup',
			    //popupPage: '/com/popup/bk/ItemPopup.do',
			    pageTitle: '품목정보'
			};
		} else if (sPopItem == 'ITEM2' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE2',
			    textFieldName:'ITEM_NAME2',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup2',
			    //app: 'Unilite.app.popup.ItemPopup2',
			    popupPage: '/com/popup/bk/ItemPopup2.do',
			    pageTitle: '사용자별 품목정보'
			    
			};
		} else if (sPopItem == 'ITEM2_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME2',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup2',
			    //app: 'Unilite.app.popup.ItemPopup2',
			    popupPage: '/com/popup/bk/ItemPopup2.do',
			    pageTitle: '사용자별 품목정보'
			};	
		}else if (sPopItem == 'DIV_PUMOK' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK2' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumok2Popup',
                app: 'Unilite.app.popup.DivPumok2Popup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보2'
			};
		} else if (sPopItem == 'DIV_PUMOK2_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumok2Popup',
                app: 'Unilite.app.popup.DivPumok2Popup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보2'
			};
		} else if (sPopItem == 'ITEM_GROUP' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드(대표모델)',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemGroupPopup',
			    app: 'Unilite.app.popup.ItemGroupPopup',
			    //popupPage: '/com/popup/bk/ItemGroupPopup.do',
			    pageTitle: '대표모델정보'
			};
		} else if (sPopItem == 'ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemGroupPopup',
			    app: 'Unilite.app.popup.ItemGroupPopup',
			    //popupPage: '/com/popup/bk/ItemGroupPopup.do',
			    pageTitle: '대표모델정보'
			};
		} else if (sPopItem == 'DIV_ITEM_GROUP' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '사업장별 품목코드(대표모델)',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divItemGroupPopup',
			    app: 'Unilite.app.popup.DivItemGroupPopup',
			    //popupPage: '/com/popup/bk/DivItemGroupPopup.do',
			    pageTitle: '사업장별 대표모델정보'
			};
		} else if (sPopItem == 'DIV_ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divItemGroupPopup',
			    app: 'Unilite.app.popup.DivItemGroupPopup',
			    //popupPage: '/com/popup/bk/DivItemGroupPopupPopup.do',
			    pageTitle: '사업장별 대표모델정보'
			};
		}else if (sPopItem == 'SAFFER_TAX' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '세무서코드',
			    valueFieldName:'SUB_CODE',
			    textFieldName:'CODE_NAME',
			    DBvalueFieldName: 'SUB_CODE',
			    DBtextFieldName: 'CODE_NAME',
			    api: 'popupService.safferTaxPopup',			    
			    app: 'Unilite.app.popup.SafferTaxPopup',
			    //popupPage: '/com/popup/bk/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '세무서코드'
			};
		} else if (sPopItem == 'SAFFER_TAX_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'SUB_CODE',
			    DBtextFieldName: 'CODE_NAME',
			    api: 'popupService.safferTaxPopup',
			    app: 'Unilite.app.popup.SafferTaxPopup',
			    //popupPage: '/com/popup/bk/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '세무서코드'
			};
		} else if (sPopItem == 'DRIVER' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '기사',
			    valueFieldName:'DRIVER_CODE',
			    textFieldName:'DRIVER_NAME',
			    DBvalueFieldName: 'DRIVER_CODE',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',			    
			    app: 'Unilite.app.popup.DriverPopup',
			    popupWidth:400,
			    popupHeight:300,
			    pageTitle: '기사'
			};
		} else if (sPopItem == 'DRIVER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'DRIVER_NAME',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',
			    app: 'Unilite.app.popup.DriverPopup',
			    popupWidth:400,
			    popupHeight:300,
			    pageTitle: '기사'
			};
		} else if (sPopItem == 'COUNT_DATE' ) {
			rv = {
				xtype:'uniPopupField',
				textFieldName:'COUNT_DATE',
			    DBtextFieldName: 'COUNT_DATE',
			    textFieldOnly: true,
			    textFieldConfig: {
			    	xtype: 'uniDatefield'
			    },
			    api: 'popupService.countdatePopup',
			    app: 'Unilite.app.popup.CountDatePopup',
			    popupWidth:480,
			    popupHeight:300,
			    pageTitle: '실사일'
			};
		} else if (sPopItem == 'SHOP' ) { 		// 매장 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '매장',
			    valueFieldName:'SHOP_CODE',
			    textFieldName:'SHOP_NAME',
			    DBvalueFieldName: 'SHOP_CODE',
			    DBtextFieldName: 'SHOP_NAME',
			    api: 'popupService.shopPopup',
			    app: 'Unilite.app.popup.ShopPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    popupWidth:650,
			    popupHeight:400,
			    pageTitle: '매장정보'
			};
		} else if (sPopItem == 'SHOP_G' ) {    // 매장 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'SHOP_NAME',
			    DBtextFieldName: 'SHOP_NAME',
			    api: 'popupService.shopPopup',
			    app: 'Unilite.app.popup.ShopPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    popupWidth:650,
			    popupHeight:400,
			    pageTitle: '매장정보'
			};
		} else if (sPopItem == 'VEHICLE' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '차량',
			    valueFieldName:'VEHICLE_CODE',
			    textFieldName:'VEHICLE_NAME',
			    DBvalueFieldName: 'VEHICLE_CODE',
			    DBtextFieldName: 'VEHICLE_NAME',
			    api: 'popupService.vehiclePopup',			    
			    app: 'Unilite.app.popup.VehiclePopup',
			    popupWidth:400,
			    popupHeight:300,
			    pageTitle: '차량'
			};
		} else if (sPopItem == 'VEHICLE_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'VEHICLE_NAME',
			    DBtextFieldName: 'VEHICLE_NAME',
			    api: 'popupService.vehiclePopup',
			    app: 'Unilite.app.popup.VehiclePopup',
			    popupWidth:400,
			    popupHeight:300,
			    pageTitle: '차량'
			};
		} else if (sPopItem == 'CUST_BILL_PRSN' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '담당자', 
			    valueFieldName:'SEQ',
			    textFieldName:'PRSN_NAME',
			    DBvalueFieldName: 'SEQ',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.custBillPrsnPopup',			    
			    app: 'Unilite.app.popup.CustBillPrsnPopupWin',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '전자세금계산서 담당자'
			};
		} else if (sPopItem == 'CUST_BILL_PRSN_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PRSN_NAME',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.custBillPrsnPopup',
			    app: 'Unilite.app.popup.CustBillPrsnPopupWin',
			    popupWidth:600,
			    popupHeight:400,
			    pageTitle: '전자세금계산서 담당자'
			};
		}else if (sPopItem == 'PROJECT' ) {	//관리번호 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    textFieldOnly: true,
			    api: 'popupService.projectPopup',			    	
			    app: 'Unilite.app.popup.ProjectPopup',
			    popupWidth:600,
			    popupHeight:450,
			    pageTitle: '관리번호'
			};
		}else if (sPopItem == 'PROJECT_G' ) {	//관리번호 팝업
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    api: 'popupService.projectPopup',			    	
			    app: 'Unilite.app.popup.ProjectPopup',
			    popupWidth:600,
			    popupHeight:450,
			    pageTitle: '관리번호'
			};
		}else if (sPopItem == 'INOUT_NUM' ) {	//수불번호 팝업
			rv = {
				//xtype:'uniPopupColumn',//uniPopupField 로 해야 masterForm, pnelResult 연동됨
				xtype:'uniPopupField',
				textFieldName:'INOUT_NUM',
			    DBtextFieldName: 'INOUT_NUM',
			    textFieldOnly: true,
			    api: 'popupService.inoutNumPopup',
			    app: 'Unilite.app.popup.InoutNumPopup',
			    popupWidth:480,
			    popupHeight:450,
			    pageTitle: '수불번호'
			};
		}else if (sPopItem == 'ORDER_NUM' ) {	//수주번호 팝업
			rv = {
				//xtype:'uniPopupColumn',//uniPopupField 로 해야 masterForm, pnelResult 연동됨
				xtype:'uniPopupField',
				textFieldName:'ORDER_NUM',
			    DBtextFieldName: 'ORDER_NUM',
			    textFieldOnly: true,
			    api: 'popupService.orderNumPopup',
			    app: 'Unilite.app.popup.OrderNumPopup',
			    popupWidth:480,
			    popupHeight:450,
			    pageTitle: '수주번호'
			};
		}   
			
		
       // console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
            rv = Ext.apply(rv, config);
            console.log('uniPopup Config : ', config);
            console.log('uniPopup rv : ', rv);
        }
        //console.log("AFTER", rv.allowBlank, config)
		return rv;
				
	},
	
	popupGridConfig: function(param, callback, scope) {
		var app = "Unilite.app.popup.GridConfigPopup";
    	var fn = function() {	                            		
            var oWin =  Ext.WindowMgr.get(app);
            if(!oWin) {
                oWin = Ext.create( app, {
                        //id: 'GridConfigPopup', 
                        callBackFn: callback, 
                        callBackScope: scope, 
                        width: 800,
                        height: 550,
                        title: 'Grid 설정',
                        param: param
                 });
            }
            oWin.fnInitBinding(param);
            oWin.center();
            oWin.show();
        };
        Unilite.require(app, fn, this, true);
	}
}) 	// @charset UTF-8

/**
 * 
 * Ext.ux.panel.UploadPanel for ExtJs 4 + plupload
 * Source: http://www.thomatechnik.de/webmaster-tools/extjs-plupload/
 * 
 * Based on:
 * http://www.sencha.com/forum/showthread.php?98033-Ext.ux.Plupload-Panel-Button-%28file-uploader%29
 * 
 * Please link to this page if you find this extension usefull
 * Version 0.2
 * 
 * @authors:
 * - mhd sulhan (ms@kilabit.org)
 * 
 * 
 * PLUPLOAD Model
 *      @example
 *       file : {
 *       	id,
 *       	fid,
 *       	loaded,
 *       	name,	// 파일명
 *       	percent,
 *       	size,
 *       	status : [1:'Queued', 2:'Uploading', 3:'Unknown', 4:'Failed', 5:'Done', 6:'기존파일'] // 6은 unilite에서 확장됨
 *      }
 * 
 */
Ext.define('Unilite.com.panel.UploadPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.xuploadpanel',
	
	requires: ['Ext.ProgressBar'],
	flex:1,
	/**
	 * 
	 * @cfg {String} title
	 */
	title : '',
	
	/**
	 * 
	 * @cfg {String} url
	 * 
	 * URL to your server-side upload-script
	 */
	url : CPATH+'/fileman/upload.do',
	/**
	 * 
	 * @cfg {String} downloadUrl
	 * 
	 * URL to your server-side download-script
	 */
	downloadUrl : CPATH+'/fileman/download/',//CPATH+'/fileman/download.do',
	
	/**
	 * 
	 * @cfg {String} chunk_size
	 * 
	 * The chunk-size
	 */
	//chunk_size : '512kb', 
	chunk_size : '0',
	
	/**
	 * 
	 * @cfg {String} max_file_size
	 * 
	 * The max. allowed file-size
	 */
	max_file_size : '200mb',
	
	/**
	 * 
	 * @cfg {String} unique_names
	 * 
	 * Make sure to use only unique-names
	 */
	unique_names : false, 
	
	/**
	 * 
	 * @cfg {Boolean} multipart
	 * 
	 * Use multipart-uploads
	 */
	multipart : true,  
	
	/**
	 * 
	 * @cfg {String} pluploadPath
	 * 
	 * Path to plupload
	 */
	pluploadPath : CPATH + '/resources/plupload', 
	
	/**
	 * 
	 * @cfg {String} pluploadRuntimes
	 * 
	 * All the runtimes you want to use. first available runtime will be used
	 * pluploadRuntimes : 'html5,gears,browserplus,silverlight,flash,html4',
	 */
	pluploadRuntimes : 'html5,flash,html4',
	 
	/**
	 * 
	 * @cfg {boolean} readOnly
	 * 
	 * default : false 
	 * controllerd by setReadOnly
	 */
	readOnly : false, // 
	/**
	 * 
	 * @cfg {Object}
	 * Texts (language-dependent)
	 * 
	 *      @example
	 *      texts : {
	 *       status : ['Queued', 'Uploading', 'Unknown', 'Failed', 'Done'],
	 *       DragDropAvailable : 'Drag & drop files here',
	 *       noDragDropAvailable : 'This Browser doesn\'t support drag&drop.',
	 *       emptyTextTpl : '<div style="color:#808080; margin:0 auto; text-align:center; top:48%; position:relative;">{0}</div>',
	 *       cols : ["File", "Size", "State", "Message"],
	 *       addButtonText : 'Add file',
	 *       uploadButtonText : 'Upload',
	 *       cancelButtonText : 'Cancel',
	 *       deleteButtonText : 'Delete',
	 *       deleteUploadedText : 'Delete finished',
	 *       deleteAllText : 'Delete all',
	 *       deleteSelectedText : 'Delete selected',
	 *       progressCurrentFile : 'Current file:',
	 *       progressTotal : 'Total:',
	 *       statusInvalidSizeText : 'File size is to big',
	 *       statusInvalidExtensionText : 'Invalid file-type'
	 *      }
	 */
	texts : {
		status : ['ready', 'uploading', 'Unknown', 'fail', 'uploaded','uploaded'],
		DragDropAvailable : 'Drag & drop files here',
		noDragDropAvailable : '이 브라우져는 드래그엔 드롭을 지원하지 않습니다.',
		emptyTextTpl : '<div style="color:#808080; margin:0 auto; text-align:center; top:48%; position:relative;">{0}</div>',
		cols : ["File name", "Size", "Status", "Message"],
		addButtonText : 'Add files',
		uploadButtonText : 'Upload',
		cancelButtonText : 'Cancel',
		deleteButtonText : 'Delete',
		deleteUploadedText : 'Deleted',
		deleteAllText : 'Delete all',
		deleteSelectedText : 'Deleted Selected',
		progressCurrentFile : 'Uploading:',
		progressTotal : 'All:',
		statusInvalidSizeText : 'File size is to big',
		statusInvalidExtensionText : 'Invalid file-type'
	},

	/**
	 * 
	 * @cfg {String} addButtonCls
	 * The CSS class for add button
	 */
	addButtonCls : 'pluploadAddCls',
	
	/**
	 * 
	 * @cfg {String} uploadButtonCls
	 * The CSS class for upload button
	 */
	uploadButtonCls : 'pluploadUploadCls',
	
	/**
	 * 
	 * @cfg {String} cancelButtonCls
	 * The CSS class for cancel button
	 */
	cancelButtonCls : 'pluploadCancelCls',
	
	/**
	 * 
	 * @cfg {String} deleteButtonCls
	 * The CSS class for delete button
	 */
	deleteButtonCls : 'pluploadDeleteCls',
	
	/**
	 * 
	 * @cfg {Array} filters
	 * 
	 *     @Example :
	 *       filters: [
	 *         {title : "Image files", extensions : "jpg,JPG,gif,GIF,png,PNG"},
     *         {title : "Zip files", 	extensions : "zip,ZIP"},
     *         {title : "Text files", 	extensions : "txt,TXT"}
	 *     ]
	 */
	filters: [],
	
	/**
	 * 
	 * @cfg {} multipart_params
	 *  works as baseParams for store.  multipart must be true
	 *  
	 *      @example
	 *      Example: 
	 *       multipart_params: { param1: 1, param2: 2 }
	 */
	multipart_params : null,
	
	// Internal (do not change)
	// Grid-View
	
	/**
	 * 
	 * @cfg {Boolean} multiSelect
	 */
	multiSelect : true,
	
	/**
	 * 
	 * @cfg  {Object} viewConfig
	 */
	viewConfig : {
		deferEmptyText : false
		// For showing emptyText
	},

	// Hack: loaded of the actual file (plupload is sometimes a step ahead)
	loadedFile : 0,
	
	/**
	 * 
	 * @cfg {Boolean} 
	 */
	showProgressBBar : false,
	
	uniOpt: {
		isDirty : false,
		isLoading: false,
		autoStart: true
		
	},
	
	constructor : function(config) {
		var me = this;
		// List of files
		this.success = [];
		this.failed = [];

		// Column-Headers
		config.columns = [{
					header : 'id',
					width:150,
					dataIndex : 'id',
					hidden: true
				},{
					header : 'FID',
					width:150,
					dataIndex : 'fid',
					hidden: true
				},{
					header : me.texts.cols[0],
					flex : 1,
					dataIndex : 'name',
					'tdCls': 'GRID_COL_HREF',
					style : 'text-align:center'
				}, /*{
					header : 'Read',
					xtype: 'actioncolumn',
                    width: 70,
                    align: 'center',
					renderer: function (value, metadata, record) {
                        if (record.get('fid')) {
                            metadata.tdCls = 'pluploadDownloadActionCls'
                        }
                    },
                    me : this,
                    handler: this._download
				},*/
				{
					header : me.texts.cols[1],
					width:100,
					align : 'right',
					dataIndex : 'size',
					renderer : Ext.util.Format.fileSize,
					style : 'text-align:center'
				}, {
					header : me.texts.cols[2],
					width:120,
					dataIndex : 'status',
					renderer : me.renderStatus,
					style : 'text-align:center'
				}, {
					header : me.texts.cols[3],
					dataIndex : 'msg',
					hidden:true
				},
		        {
		        	header: 'Task',
		            xtype:'actioncolumn',
		            
					align : 'center',
					width: 80,
					style : 'text-align:center',
		            items: [{
		                icon: CPATH+'/resources/css/icons/upload_delete.png',
		                tooltip: '삭제',
		                handler: function(grid, rowIndex, colIndex) {
		                	var id = grid.store.getAt(rowIndex).get('id');
		                    me.remove_file(id);
		                },
		                isDisabled: function(view, rowIndex, colIndex, item, record) {
		                	return me.readOnly;//up('grid').readOnly;
		                }
		            }]
		        }];

		// Model and Store
		if (!Ext.ModelManager.getModel('PluploadModel')) {
			Ext.define('PluploadModel', {
						extend : 'Ext.data.Model',
						fields : [
							'id', 
							'loaded', 
							'name', 
							'size', 
							'percent', 
							{name:'status', type: 'int'}, 
							'msg',
							'fid'
						]
					});
		};

		config.store = {
			type : 'json',
			model : 'PluploadModel',
			listeners : {
				add: this.onStoreUpdate,
				load: this.onStoreLoad,
				remove: this.onStoreRemove,
				update: this.onStoreUpdate,
				datachanged: this.onStoreChanged,
				scope : this
			},
			proxy : 'memory'
		};

		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: [
		        new Ext.Button({
								text : this.texts.addButtonText,
								itemId : 'addButton',
								iconCls : this.addButtonCls,
								disabled : true
								
					}) /* , new Ext.Button({
						text : this.texts.uploadButtonText,
						handler : this.onStart,
						scope : this,
						disabled : true,
						itemId : 'upload',
						iconCls : this.uploadButtonCls 
					}), new Ext.Button({
						text : this.texts.cancelButtonText,
						handler : this.onCancel,
						scope : this,
						disabled : true,
						itemId : 'cancel',
						iconCls : this.cancelButtonCls
					}) */
    ]
		}];
		
		// Top-Bar
		/*
		this.tbar = {
			enableOverflow : true,
			items : [new Ext.Button({
								text : this.texts.addButtonText,
								itemId : 'addButton',
								iconCls : this.addButtonCls,
								disabled : true
							}), new Ext.Button({
								text : this.texts.uploadButtonText,
								handler : this.onStart,
								scope : this,
								disabled : true,
								itemId : 'upload',
								iconCls : this.uploadButtonCls 
							}), new Ext.Button({
								text : this.texts.cancelButtonText,
								handler : this.onCancel,
								scope : this,
								disabled : true,
								itemId : 'cancel',
								iconCls : this.cancelButtonCls
							})
							// 전체 삭제 오류가 있음.
							
							//, new Ext.Button({
							//	text : this.texts.deleteAllText,
							//	handler : this.onDeleteAll,
							//	scope : this,
							//	disabled : true,
							//	itemId : 'delete',
							//	iconCls : this.deleteButtonCls
							//})
							
							// , 
							//new Ext.SplitButton({
							//text : this.texts.deleteButtonText,
							//handler : this.onDeleteSelected,
							//menu : new Ext.menu.Menu({
							//			items : [{
							//						text : this.texts.deleteUploadedText,
							//						handler : this.onDeleteUploaded,
							//						scope : this
							//					}, '-', {
							//						text : this.texts.deleteAllText,
							//						handler : this.onDeleteAll,
							//						scope : this
							//					}, '-', {
							//						text : this.texts.deleteSelectedText,
							//						handler : this.onDeleteSelected,
							//						scope : this
							//					}]
							//		}), //Ext.menu.Menu
							//scope : this,
							//disabled : true,
							//itemId : 'delete',
							iconCls : this.deleteButtonCls 
						//}) //Ext.SplitButton
						
					]
		};
		*/
		// Progress-Bar (bottom)
		if(this.showProgressBBar) {
			this.progressBarSingle = new Ext.ProgressBar({
						//flex : 1,
						width:150,
						animate : true
					});
			this.progressBarAll = new Ext.ProgressBar({
						//flex : 2,
						width:150,
						animate : true
					});
	
			this.bbar = {
				layout : {type : 'table', columns: 5 },
				style : {
					paddingLeft : '5px'
				},
				items : [
						{	xtype : 'tbtext',
							text : this.texts.progressCurrentFile, 
							style : 'text-align:right',
							width : 80
						},
						this.progressBarSingle, 
						{
							xtype : 'tbtext',
							itemId : 'single',
							style : 'text-align:right',
							text : '',
							width : 150
						}, 
						{	xtype : 'tbtext',
							text:"속도",
							style : 'text-align:right',
							width : 100
						},
						{
							xtype : 'tbtext',
							itemId : 'speed',
							style : 'text-align:right',
							text : '',
							width : 100
						},
						{	xtype : 'tbtext',
							text : this.texts.progressTotal, 
							style : 'text-align:right'
						},
						this.progressBarAll, 
						{
							xtype : 'tbtext',
							itemId : 'all',
							style : 'text-align:right',
							text : '-',
							width : 150
						}, 
						{	xtype : 'tbtext',
							text:"남은시간",
							style : 'text-align:right',
							width : 100
						},
						{
							xtype : 'tbtext',
							itemId : 'remaining',
							style : 'text-align:right',
							text : '-',
							width : 100
						}]
			};
		}; // if (showProgressBBar)

		me.addEvents(
			/**
			 * @event uploadstarted
			 * @param uploader
			 */
			'uploadstarted',
			
			/**
			 * @event uploadcomplete
			 * @param uploader
			 * @param success
			 * @param failed
			 */
			'uploadcomplete',
			
			/**
			 * @event beforestart
			 * @param uploader
			 */
			'beforestart',
			
			/**
			 * @event change
			 * @param uploader
			 */
			'change'
		); //  me.addEvents
		me.callParent(arguments);// 더블클릭 on Cell
        this.on('celldblclick', this._onCellDblClickFun);
	},
	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			var me = this;
        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
        	var colName = ct.dataIndex;
        	if(colName == 'name') {
        		var status = record.get('status');
        		if( status  >= 5) {
	        		var fid = record.get('fid');
	        		var url = me.downloadUrl; // +"?inline=N&fid=" +  fid;
					me.onDownload(url, fid);
        		} else {
        			alert('전송 되지 않은 파일입니다.')
        		}
        	}
    },
	_download: function(view ,rowIndex , colIndex, item ,e,record,row ) {

		var me = this;
		var fid = record.get('fid')
		var body = Ext.getBody();
		var url = me.downloadUrl; // +"?inline=N&fid=" +  fid;
		me.onDownload(url, fid);
		
	},
	/**
	 * 
	 * @return {Boolean} True : 수정된 자료 있음, False : 수정 된 자료 없음.
	 */
	isDirty: function() {
		return this.uniOpt.isDirty;
	},
	onDownload : function(url, fid) {
        Ext.log("onDownload : ", url+fid);
        window.open (url+fid);
        // 폼 없이 다운 로드 하도록 수정(2014.07.31)
//        var frame, form, hidden, params;
// 
// 
//        form = Ext.fly('exportform').dom;
//        
//        form.action = url;
//        hidden = document.getElementById('fid');
//        params = {fid: fid};
//        hidden.value = fid;
// 
//        form.submit();
    },
	/**
	 * 파일 업로드 시작 
	 */
	uploadFiles : function() {
		this.uniOpt.isDirty=false;
		this.onStart();
	},
	/**
	 * Upload 추가된 파일 목록을 돌려 준다.
	 * 
	 */
	getAddFiles: function() {
		var me = this, store = this.store;
		var all = store.data.filterBy(function(item) {return item.data.status != 6;}).items;
        var rv= me._convertRecToArray(all);
        Ext.log("getAddFiles: ", rv );
        return rv;
	},
	/** 
	 * @private
	 */
	_convertRecToArray: function(data) {
		var allArray = [];
        Ext.each(data, function(rec) {
        	console.log("id:", rec.get('id'),  "status:", rec.get('status'));
        	if(rec.get('status') != 6 ) {
        		allArray.push(rec.get('fid'));
        	}
        	
        });
        return allArray;
	},	
	/**
	 * Upload 파일 목록을 돌려 준다.
	 * 
	 *  - 삭제 표시된 파일
	 *  
	 *  - upload된 파일 
	 */
	getRemoveFiles: function() {
		var me = this, store = this.store;
        var toDestroy = store.getRemovedRecords();
        var rv= me._convertRecToArrayForRemove(toDestroy);
        
        Ext.log("getRemoveFiles : ", rv);
        return rv;
	},	
	/** 
	 * @private
	 */
	_convertRecToArrayForRemove: function(data) {
		var allArray = [];
        Ext.each(data, function(rec) {
        	console.log("id:", rec.get('id'),  "status:", rec.get('status'));
        	if(rec.get('status') == 6 ) {
        		allArray.push(rec.get('fid'));
        	}
        	
        });
        return allArray;
	},
	/**
	 * Store 데이타 변경(store.loadData).
	 * @param data {Ext.data.Model[]/Object[]}
	 * @param {Boolean} [append=false]
	 */
	loadData : function(data, append) {
		
		var me = this, store = this.store;
		me.uniOpt.isLoading=true;
		me.reset();
		store.loadData(data, append);
		me.uniOpt.isLoading = false;
	},
	/** 
	 * 데이타 reeset
	 */
	reset : function() {
		var me = this;
		me.uniOpt.isDirty =false;
		
		if(me.uploader) {
			me.uploader.splice();
		};
		
		me.store.loadRecords({}, {addRecords: false});
		me.store.clearData(); 
		me.view.refresh();
		
	},
	/**
	 * @private
	 */
	afterRender : function() {
		this.callParent(arguments);
		this.initPlUpload();
	},
	/**
	 * @param {} value
	 * @param {} meta
	 * @param {} record
	 * @param {} rowIndex
	 * @param {} colIndex
	 * @param {} store
	 * @param {} view
	 * @return {}
	 * 
	 * @private
	 */
	renderStatus : function(value, meta, record, rowIndex, colIndex, store,
			view) {
		var s = this.texts.status[value - 1];
		if (value == 2) {
			s += " " + record.get("percent") + " %";
		}
		return s;
	},
	/** 
	 * @private
	 */
	getTopToolbar : function() {
		var bars = this.getDockedItems('toolbar[dock="top"]');
		return bars[0];
	},
	/** 
	 * @private
	 */
	getBottomToolbar : function() {
		var bars = this.getDockedItems('toolbar[dock="bottom"]');
		return bars[0];
	},
	/** 
	 * @private
	 */
	initPlUpload : function() {
		this.uploader = new plupload.Uploader({
					file_data_name : 'file',
					url : this.url,
					runtimes : this.pluploadRuntimes,
					browse_button : this.getTopToolbar().getComponent('addButton').getEl().dom.id,
					container : this.getEl().dom.id,
					max_file_size : this.max_file_size || '',
					resize : this.resize || '',
					flash_swf_url : this.pluploadPath + '/plupload.flash.swf',
					silverlight_xap_url : this.pluploadPath + 'plupload.silverlight.xap',
					filters : this.filters || [],
					chunk_size : this.chunk_size,
					unique_names : this.unique_names,
					multipart : this.multipart,
					multipart_params : this.multipart_params || null,
					drop_element : this.getEl().dom.id,
					required_features : this.required_features || null
				});

	

		// Events of plupload
		var events = [
				'Init', 
				'ChunkUploaded', 
				'FilesRemoved',
				'FileUploaded', 
				'PostInit', 
				'QueueChanged',
				'Refresh', 
				'StateChanged', 
				'UploadFile',
				'UploadProgress', 
				'Error'
			]; // events
		Ext.each(events, function(v) {
							this.uploader.bind(v, eval("this.Plupload" + v), this);
						}, this);
		// Init Plupload
		this.uploader.init(); 
		// 	plupload 자체 이벤트 먼저 처리하게 init 순서를 이벤트 정의부문과 바꿈.
		// Events of plupload
		var events = [
				'FilesAdded'
			]; // events
		Ext.each(events, function(v) {
							this.uploader.bind(v, eval("this.Plupload" + v), this);
						}, this);
	},
	/** 
	 * @private
	 */
	onDeleteSelected : function() {
		Ext.each(this.getView().getSelectionModel().getSelection(), function(
						record) {
					this.remove_file(record.get('id'));
				}, this);
	},
	/** 
	 * @private
	 */
	onDeleteAll : function() {
		this.store.each(function(record) {
					this.remove_file(record.get('id'));
				}, this);
	},
	/** 
	 * @private
	 */
	onDeleteUploaded : function() {
		this.store.each(function(record) {
					if (record.get('status') == 5) {
						this.remove_file(record.get('id'));
					}
				}, this);
	},
	/** 
	 * @private
	 */
	onCancel : function() {
		this.uploader.stop();
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	onStart : function() {
		this.fireEvent('beforestart', this);

		if (this.multipart_params) {
			this.uploader.settings.multipart_params = this.multipart_params;
			this.uploader.settings.multipart_params.id = Earsip.berkas.tree.id;
		}
		this.uploader.start();
	},
	/** 
	 * @private
	 */
	remove_file : function(id) {
		var fileObj = this.uploader.getFile(id);
		if (fileObj) {
			console.log(" delete fileObj", fileObj);
			this.uploader.removeFile(fileObj);
		} else {
			console.log(" delete row ", id);
			this.store.remove(this.store.getById(id));
		}
	},
	/** 
	 * @private
	 */
	updateStore : function(files) {
		Ext.each(files, function(data) {
					this.updateStoreFile(data);
				}, this);
	},
	/** 
	 * @private
	 */
	updateStoreFile : function(data) {
		data.msg = data.msg || '';
		var record = this.store.getById(data.id);
		if (record) {
			record.set(data);
			record.commit();
		} else {
			this.store.add(data);
		}
	},
	
	onStoreLoad : function(store, record, operation) {
	},
	onStoreRemove : function(store, record, operation) {
		if (!store.data.length) {
			if(this.useDeleteMenu) {
				this.getTopToolbar().getComponent('delete').setDisabled(true);
			}
			this.uploader.total.reset();
		}
		var id = record.get('id');

		Ext.each(this.success, function(v) {
					if (v && v.id == id) {
						Ext.Array.remove(this.success, v);
					}
				}, this);

		Ext.each(this.failed, function(v) {
					if (v && v.id == id) {
						Ext.Array.remove(this.failed, v);
					}
				}, this);
		this._setDirty();
	},
	
	// store's datachanged event
	onStoreChanged : function ( store, eOpts) {
		if(!this.uniOpt.isLoading && this.uniOpt.isDirty ) {
			//this.uniOpt.isDirty = true;
			this.fireEvent('change', this);
		}
		
	},
	onStoreUpdate : function(store, record, operation) {
		var canUpload = false;
		if (this.uploader.state != 2) {
			this.store.each(function(record) {
						if (record.get("status") == 1) {
							canUpload = true;
							return false;
						}
					}, this);
		}
		if(!this.uniOpt.autoStart) {
			this.getTopToolbar().getComponent('upload').setDisabled(!canUpload);
		}
		this._setDirty();
	},
	_setDirty: function() {
		this.uniOpt.isDirty=true;
		
	},
	updateProgress : function(file) {
		if(this.showProgressBBar) {
			var queueProgress = this.uploader.total;
			// All
			var total = queueProgress.size;
			var uploaded = queueProgress.loaded ;
			console.log(queueProgress, queueProgress.percent, "uploaded",uploaded,"total",total)
			this.getBottomToolbar().getComponent('all').setText(Ext.util.Format
					.fileSize(uploaded)
					+ "/" + Ext.util.Format.fileSize(total));
	
			if (total > 0) {
				this.progressBarAll.updateProgress(queueProgress.percent / 100,
						queueProgress.percent + " %");
			} else {
				this.progressBarAll.updateProgress(0, ' ');
			}
	
			// Speed+Remaining
			var speed = queueProgress.bytesPerSec;
			if (speed > 0) {
				var totalSec = parseInt((total - uploaded) / speed);
				var hours = parseInt(totalSec / 3600) % 24;
				var minutes = parseInt(totalSec / 60) % 60;
				var seconds = totalSec % 60;
				var timeRemaining = result = (hours < 10 ? "0" + hours : hours)
						+ ":" + (minutes < 10 ? "0" + minutes : minutes) + ":"
						+ (seconds < 10 ? "0" + seconds : seconds);
				this.getBottomToolbar().getComponent('speed').setText(Ext.util.Format.fileSize(speed) + '/s');
				this.getBottomToolbar().getComponent('remaining').setText(timeRemaining);
			} else {
				this.getBottomToolbar().getComponent('speed').setText('');
				this.getBottomToolbar().getComponent('remaining').setText('');
			}
	
			// Single
			if (!file) {
				this.getBottomToolbar().getComponent('single').setText('');
				this.progressBarSingle.updateProgress(0, ' ');
			} else {
				total = file.size;
				// uploaded = file.loaded; // file.loaded sometimes is 1 step ahead,
				// so we can not use it.
				// uploaded = 0; if (file.percent > 0) uploaded = file.size *
				// file.percent / 100.0; // But this solution is imprecise as well
				// since percent is only a hint
				uploaded = this.loadedFile; // So we use this Hack to store the
				// value which is one step back
				this.getBottomToolbar().getComponent('single')
						.setText(Ext.util.Format.fileSize(uploaded) + "/"
								+ Ext.util.Format.fileSize(total));
				this.progressBarSingle.updateProgress(file.percent / 100,
						(file.percent).toFixed(0) + " %");
			}
		}; // if(showProgressBBar)
	},
	/** 
	 * @private
	 */
	PluploadInit : function(uploader, data) {
		this.getTopToolbar().getComponent('addButton').setDisabled(false);
		console.log("Runtime: ", data.runtime);
		if (data.runtime == "flash" || data.runtime == "silverlight"
				|| data.runtime == "html4") {
			this.view.emptyText = this.texts.noDragDropAvailable;
		} else {
			this.view.emptyText = this.texts.DragDropAvailable
		}
		this.view.emptyText = String.format(this.texts.emptyTextTpl,
				this.view.emptyText);
		this.view.refresh();
		
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadChunkUploaded : function() {
	},
	/** 
	 * @private
	 */
	PluploadFilesAdded : function(uploader, files) {
		if(this.useDeleteMenu) {
			this.getTopToolbar().getComponent('delete').setDisabled(false);
		}
		this.updateStore(files);
		if(this.showProgressBBar) {
			this.updateProgress();
		};
		console.log("upload added");
		if(this.uniOpt.autoStart) {
			this.onStart();
		}
	},
	/** 
	 * @private
	 */
	PluploadFilesRemoved : function(uploader, files) {
		Ext.each(files, function(file) {
					this.store.remove(this.store.getById(file.id));
				}, this);

		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadFileUploaded : function(uploader, file, status) {
		var response = Ext.JSON.decode(status.response);
		if (response.success == true) {
			file.server_error = 0;
			// fid update
			file.fid = response.fid;
			this.success.push(file);
		} else {
			if (response.message) {
				file.msg = '<span style="color: red">' + response.message
						+ '</span>';
			}
			file.server_error = 1;
			this.failed.push(file);
		}
		this.updateStoreFile(file);
		if(this.showProgressBBar) {
			this.updateProgress(file);
		};
	},
	/** 
	 * @private
	 */
	PluploadPostInit : function() {
	},
	/** 
	 * @private
	 */
	PluploadQueueChanged : function(uploader) {
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadRefresh : function(uploader) {
		this.updateStore(uploader.files);
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadStateChanged : function(uploader) {
		if (uploader.state == 2) {
			this.fireEvent('uploadstarted', this);
			if(this.getTopToolbar().getComponent('cancel')) {
				this.getTopToolbar().getComponent('cancel').setDisabled(false);
			}
		} else {
			this.fireEvent('uploadcomplete', this, this.success, this.failed);
			
			if(this.getTopToolbar().getComponent('cancel')) {
				this.getTopToolbar().getComponent('cancel').setDisabled(true);
			}
		}
	},
	/** 
	 * @private
	 */
	PluploadUploadFile : function() {
		this.loadedFile = 0;
	},
	/** 
	 * @private
	 */
	PluploadUploadProgress : function(uploader, file) {
		// No chance to stop here - we get no response-text from the server. So
		// just continue if something fails here. Will be fixed in next update,
		// says plupload.
		if (file.server_error) {
			file.status = 4;
		}
		this.updateStoreFile(file);
		if(this.showProgressBBar) {
			this.updateProgress(file);
		};
		this.loadedFile = file.loaded;
	},
	/** 
	 * @private
	 */
	PluploadError : function(uploader, data) {
		data.file.status = 4;
		if (data.code == -600) {
			data.file.msg = String.format(
					'<span style="color: red">{0}</span>',
					this.texts.statusInvalidSizeText);
		} else if (data.code == -700) {
			data.file.msg = String.format(
					'<span style="color: red">{0}</span>',
					this.texts.statusInvalidExtensionText);
		} else {
			data.file.msg = String.format(
					'<span style="color: red">{2} ({0}: {1})</span>',
					data.code, data.details, data.message);
		}
		this.updateStoreFile(data.file);
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	}
	, clear : function()	{
		var me = this;
		me.uniOpt.isDirty =false;
		
		me.store.clearData(); 
		me.view.refresh();
		
	}
	, setReadOnly : function(readOnly)	{
		this.readOnly = readOnly;
		
		var btn = this.down('#addButton');
		if(btn) {
			btn.setDisabled(readOnly);
		}
	}
});


Ext.define('PluploadModel', {
						extend : 'Ext.data.Model',
						fields : ['id', 'loaded', 'name', 'size', 'percent', 'status', 'msg','fid']
					});
// @charset UTF-8
Ext.define("Unilite.main.MainContentPanel", {
	extend : 'Ext.ux.IFrame',
    alias: 'widget.uniMainContent',
    text: {
    	closeWinMsgTitle: "확인",
	    closeWinMsgMessage : "저장되지 않은 자료가 있습니다. 현재 페이지를 닫으시겠습니까?"    	
    },
	initComponent : function() {
		var me = this;
		this.callParent();

		this.addListener({
					 beforeclose:{
					//beforedestroy : {
						fn: this.onClose,
						scope: this
					}
				});
	},
	onClose : function(p) {
		var win = this.getWin();
		var isDirty = false;
		if(win) {
			try {
				isDirty = this.getWin().UniAppManager.getApp().isDirty();
			}catch(err) {
			}
		}
		if(isDirty) {
			Ext.MessageBox.show({
					title : this.text.closeWinMsgTitle,
					msg : this.text.closeWinMsgMessage,
					icon: Ext.Msg.WARNING,
					buttons : Ext.MessageBox.OKCANCEL,
					fn : function(buttonId) {
						switch (buttonId) {
	
							case 'ok' :
								//this.saveToFile();
								this.ownerCt.remove(p);
								break;
							case 'cancel' :
								// leave blank if no action required on
								// cancel
								break;
						}
					},
					scope : this
				}); // MessageBox
			return false; // returning false to beforeclose cancels the
						  // close event
		} else {
			return true;
		}
	} // onClose

}); // MainContentPanel
//@charset UTF-8

Ext.define("Unilite.main.MainTree", {
  extend: "Ext.tree.Panel",
  alias: "widget.doctree",
  cls: "doc-tree iScroll",
  useArrows: false,
  animCollapse: true,
  animate: true,
  rootVisible: false,
  border: true,
  bodyBorder: false,
  
  margins: '0 0 0 0',
  rowLines: false, lines: false,
  scroll: 'vertical',
			
  initComponent: function() {
    this.addEvents("urlclick");
    //this.root.expanded = true;
    this.on("itemclick", this.onItemClick, this);
    this.on("beforeitemcollapse", this.handleBeforeExpandCollapse, this);
    this.on("beforeitemexpand", this.handleBeforeExpandCollapse, this);
    this.callParent();
    this.nodeTpl = new Ext.XTemplate('<a href="{url}" rel="{url}">{text}</a>');
   /// this.initNodeLinks()
  },
  /*
  initNodeLinks: function() {
    this.getRootNode().cascadeBy(this.applyNodeTpl, this)
  },
  applyNodeTpl: function(b) {
    if (b.get("leaf")) {
      b.set("text", this.nodeTpl.apply({
        text: b.get("text"),
        url: b.raw.url
      }));
      b.commit()
    }
  },
  */
  onItemClick: function(h, rec, k, l, i) {
    var url = rec.raw ? rec.raw.url : rec.data.url;
    if (url) {
      this.fireEvent("urlclick", rec, url, i)
    } else {
      if (!rec.isLeaf()) {
        if (rec.isExpanded()) {
          rec.collapse(false)
        } else {
          rec.expand(false)
        }
      }
    }
  },
  /*
  selectUrl: function(d) {
    var c = this.findNodeByUrl(d);
    if (c) {
      c.bubble(function(a) {
        a.expand()
      });
      this.getSelectionModel().select(c)
    } else {
      this.getSelectionModel().deselectAll()
    }
  },
  */
  findNodeByUrl: function(b) {
    return this.getRootNode().findChildBy(function(a) {
      return b === a.raw.url
    }, this, true)
  },
  findRecordByUrl: function(d) {
    var c = this.findNodeByUrl(d);
    return c ? c.raw : undefined
  },
  handleBeforeExpandCollapse: function(b) {
    if (this.getView().isAnimating(b)) {
      return false
    }
  }
});

// @charset UTF-8
Ext.define("Unilite.main.MainTreeForSystemMenu", {
			extend : "Unilite.main.MainTree",

			initComponent : function() {
				/* Navigation 메뉴 헤더에 툴바 구현으로 삭제
				Ext.apply(this, {
							tbar : ['->',
                                    {
										//text : 'Expand All',
                                        iconCls : 'icon-expandAll',
										scope : this, 
										handler : this.onExpandAllClick
									}, {
										//text : 'Collapse All',
                                        iconCls : 'icon-collapsedAll',
										scope : this,
										handler : this.onCollapseAllClick
									}]
						});// apply
				*/		
				this.callParent();
			},

			onExpandAllClick : function() {
				var me = this, toolbar = me.down('toolbar');

				me.getEl().mask('Expanding tree...');
				toolbar.disable();

				this.expandAll(function() {
							me.getEl().unmask();
							toolbar.enable();
						});
			},

			onCollapseAllClick : function() {
				var toolbar = this.down('toolbar');

				toolbar.disable();
				this.collapseAll(function() {
							toolbar.enable();
						});
			}
});
        
        Ext.define("Unilite.com.view.UniTransparentContainer", {
	extend : "Ext.container.Container",
	alias : "widget.uniTransparentContainer",
	border: 0,
	overlay : true,
	style : {
        'opacity': 1,
        'vertical-align': 'middle'
    }
});// define
Ext.define("Unilite.com.view.UniActionContainer", {
	extend : "Ext.Component",
	alias : "widget.uniActionContainer",
	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";
		this.callParent()
	},
	onClick:Ext.emptyFn,
	listeners : {
		afterrender : function(b) {
				b.el.addListener("click", function(d, a) {
							this.onClick(this.el);
						}, this)
		}
	}
}); // Ext.define
Ext.define('UniDragView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDragView',
    
	uniDDGroup: 'dataGroup',
	dragData: {},
	
    constructor: function(config){
    	config = config || {};
        if (config.uniDDGroup) {
            this.uniDDGroup = config.uniDDGroup;
        }        
        this.callParent([config]);
    },
    
    initComponent: function() {
		this.on('render', this.onViewRender, this);        
        this.callParent(arguments);
    },
    
    onViewRender: function(view)	{    	
    	view.dragZone = Ext.create('Ext.dd.DragZone', view.getEl(), {
    		ddGroup: this.uniDDGroup,
	    	getDragData: function(e) {
		        var sourceEl = e.getTarget(view.itemSelector, 20);
		        var d;
		        if (sourceEl) {
		            d = sourceEl.cloneNode(true);
		        	d=  view.getNode(sourceEl);
		            d.id = Ext.id();
		            this.dragData = view.dragData = {
		                sourceEl: sourceEl,
		                repairXY: Ext.fly(sourceEl).getXY(),
		                ddel: d,
		                record:view.getRecord(sourceEl),
		                view: view
		            };
		            return this.dragData;
		        }
	    	}
    	})
    }
    
});   // UniDragView

Ext.define('UniDropView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDropView',
    
    itemSelector: 'div.data-source',
    overItemCls: 'data-source',//'data-over',
    selectedItemClass: 'data-selected',
    singleSelect: true,
    
    
    dragRecord: null,
    dropRecord: null,
    dragRecords: null,
	
    uniDDGroup: 'dataGroup',
	uniBaseCls: 'data',
	allowDrop: true,
	
    constructor: function(config){
    	config = config || {};
        if (config.uniDDGroup) {
            this.uniDDGroup = config.uniDDGroup;
        }
        if (config.uniBaseCls) {
            this.uniBaseCls = config.uniBaseCls;
        }
        if (config.itemSelector) {
            this.itemSelector = config.itemSelector;
        }else {
        	this.itemSelector = 'div.'+this.uniBaseCls+'-source';
        }
        if (config.overItemCls) {
            this.overItemCls = config.overItemCls;
        }else {
        	this.overItemCls = this.uniBaseCls+'-over';
        }
        if (config.selectedItemClass) {
            this.selectedItemClass = config.selectedItemClass;
        }else {
        	this.selectedItemClass = this.uniBaseCls+'-selected';
        }
        this.callParent([config]);
    },
    
    initComponent: function() {
		this.on('render', this.onViewRender, this, {single: this.singleSelect});        
        this.callParent(arguments);
    },
    
    onViewRender: function(view)	{
    	
    	view.dropZone = Ext.create('Ext.dd.DropZone', view.getEl(), {
		ddGroup: this.uniDDGroup,

        getTargetFromEvent: function(e) {
            return e.getTarget('.'+view.uniBaseCls+'-source');
        },

        onNodeEnter : function(target, dd, e, data){
            //Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	view._setDragnDropRecords(target);
        	if(view.onDropEnter(target, dd, e, data))	{
            	Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	}
        },


        onNodeOut : function(target, dd, e, data){
            Ext.fly(target).removeCls(view.uniBaseCls+'-source-hover');
        },


        onNodeOver : function(target, dd, e, data){
           return view.allowDrop ? Ext.dd.DropZone.prototype.dropAllowed : Ext.dd.DropZone.prototype.dropNotAllowed;
        },

        onNodeDrop : function(target, dd, e, drag){         	 	
        		view.targetEl = target;
        		view.dropRecord = view.getRecord(target);
        		if(view.allowDrop)	{
	        		if("uniDragView" == drag.view.getXType())	{
	        			view.dragRecord = drag.record;
		        	} else if("gridview" == drag.view.getXType()) {
		        		view.dragRecord = drag.records[0];
	        			view.dragRecords = drag.records;
		        	}
	        		
		        	return view.onDrop(target, dd, e, drag);	
        		}
	        }     
    	});
    },
    onDrop: Ext.emptyFn,
    onDropEnter : Ext.emptyFn, 
    
    getDragRecord: function() {
    	return this.dragRecord;
    },
    getDragRecords: function() {
    	return this.dragRecords;
    },
    getDropRecord: function() {
    	return this.dropRecord;
    },
    isFromGridView: function(view)	{
    	if("gridview" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    isFromDataView: function(view)	{
    	if("uniDragView" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    setAllowDrop: function (b)	{
    	this.allowDrop = b;
    },
     _setDragnDropRecords: function(target)	{
    	this.dropRecord = this.getRecord(target); 	
    }
    
});   // UniDropView
Ext.define('UniDragandDropView', {
    extend : 'Ext.view.View',
    alias: 'widget.uniDragandDropView',
    
    itemSelector: 'div.data-source',
    overItemCls: 'data-source',//'data-over',
    selectedItemClass: 'data-selected',
    singleSelect: true,
    
    dragRecord: null,
    dropRecord: null,
    dragRecords: null,
	
    uniDDGroup: 'dataGroup',
	uniBaseCls: 'data',
	allowDrop: true,
	dragData: {},
	
	
    constructor: function(config){
    	config = config || {};
        if (config.uniDDGroup) {
            this.uniDDGroup = config.uniDDGroup;
        }
        if (config.uniBaseCls) {
            this.uniBaseCls = config.uniBaseCls;
        }
        if (config.itemSelector) {
            this.itemSelector = config.itemSelector;
        }else {
        	this.itemSelector = 'div.'+this.uniBaseCls+'-source';
        }
        if (config.overItemCls) {
            this.overItemCls = config.overItemCls;
        }else {
        	this.overItemCls = this.uniBaseCls+'-over';
        }
        if (config.selectedItemClass) {
            this.selectedItemClass = config.selectedItemClass;
        }else {
        	this.selectedItemClass = this.uniBaseCls+'-selected';
        }
        this.callParent([config]);
    },
    
    initComponent: function() {
		this.on('render', this.onViewRender, this, {single: this.singleSelect});        
        this.callParent(arguments);
    },
    
    onViewRender: function(view)	{
		view.dragZone = Ext.create('Ext.dd.DragZone', view.getEl(), {
		ddGroup: this.uniDDGroup,
		containerScroll: true,
		    	getDragData: function(e) {
			        var sourceEl = e.getTarget(view.itemSelector, 20), d;
			        if (sourceEl) {
			            d = sourceEl.cloneNode(true);
			        	d=  view.getNode(sourceEl);
			            d.id = Ext.id();
			            this.dragData = view.dragData = {
			                sourceEl: sourceEl,
			                repairXY: Ext.fly(sourceEl).getXY(),
			                ddel: d,
			                record:view.getRecord(sourceEl),
			                view: view
			            };
			            return this.dragData;
			        }
		    }
	    });
    	
    	view.dropZone = Ext.create('Ext.dd.DropZone', view.getEl(), {
		ddGroup: this.uniDDGroup,
		containerScroll: true,
        getTargetFromEvent: function(e) {
            return e.getTarget('.'+view.uniBaseCls+'-source');
        },

        onNodeEnter : function(target, dd, e, data){
        	view._setDragnDropRecords(target, data);
        	if(view.onDropEnter(target, dd, e, data))	{
            	Ext.fly(target).addCls(view.uniBaseCls+'-source-hover');
        	}
        },


        onNodeOut : function(target, dd, e, data){
            Ext.fly(target).removeCls(view.uniBaseCls+'-source-hover');
        },


        onNodeOver : function(target, dd, e, data){
            return view.allowDrop ? Ext.dd.DropZone.prototype.dropAllowed : Ext.dd.DropZone.prototype.dropNotAllowed;
            //return Ext.dd.DropZone.prototype.dropAllowed;
        },

        onNodeDrop : function(target, dd, e, drag){         	 	
        		view.targetEl = target;
        		view._setDragnDropRecords(target, drag);
	        	return view.allowDrop ? view.onDrop(target, dd, e, drag) : false;	        	
	        }     
    	});
    	
    	
    },
    
    onDrop: Ext.emptyFn,
    
    onDropEnter : Ext.emptyFn, 
    
    getDragRecord: function() {
    	return this.dragRecord;
    },
    getDragRecords: function() {
    	return this.dragRecords;
    },
    getDropRecord: function() {
    	return this.dropRecord;
    },
    isFromGridView: function(view)	{
    	if("gridview" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    isFromDataView: function(view)	{
    	if("uniDragView" == view.getXType()) {
    		return true;
    	}
    	return false;
    },
    setAllowDrop: function (b)	{
    	this.allowDrop = b;
    },
    
    _setDragnDropRecords: function(target, drag)	{
    	this.dropRecord = this.getRecord(target);
    	this.dragRecord = drag.record;    	
    }
    
});   // UniDragandDropView//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniWindow', {
    extend: 'Ext.window.Window',
    header: {
        titlePosition: 0,
        titleAlign: 'left'
    },
        
    closable: false,
    closeAction: 'hide',
    /**
     * 최초 오픈시 창의 크기 및 위치
     * 
     * lt: leftTop ( default )
     * rt: rightTop
     * center : 화면 중앙
     * maxmized: 꽉찬 윈도우
     * 
     * @type String
     */
    basePosition:'lt',	
    modal: true,
    resizable: true,
    layout: {
        type: 'fit'
    },
    dockedItems: [],
    
    text: {
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnPrint: '인쇄',
        btnClose: '닫기'
    },
    
    /**
     * extend init props
     */
   initComponent: function () {
        var me = this;
        this.on('move', me._checkPosition);
        me.callParent(arguments);
    },
    /**
     * @private
     * @param {} btnName
     * @param {} state
     */
    _setToolbarButton: function(btnName, state) {
        var obj =  this.getTopToolbar();
        if(obj) {
	        var btn = obj.getComponent(btnName);
	        if(btn) {
	            (state) ? btn.enable():btn.disable();
	        }
        }
    },
    getTopToolbar : function() {
        return this.toolbar;
    },
    _checkPosition: function( win, x, y, eOpts ) {
        if(x < 0 ) {
            win.setX(0);
        }
        if(y < 0 ) {
            win.setY(0);
        }
    },
    onShow: function() {
        var me = this;
        var mySize = me.getSize();
        var pSize = Ext.getBody().getSize();
        
        if(mySize.height > pSize.height) {
            me.setSize({
                    width: mySize.width,
                    height : pSize.height
            });   
        }
        var posX = pSize.width - mySize.width;
        me.x = 0;//(posX < 0) ? 0 : posX;
        me.y = 0;
        //me.setXY(me.);
        
    	// basePosition, lt,lr,center,maximized
        switch( this.basePosition ) {
        	case 'lt':
	        	 me.x = 0;
	        	 me.y = 0;
        		break;
    		case 'maximized' :
    			 me.x = 0;
	        	 me.y = 0;
	        	 me.setSize({
                    width: pSize.width,
                    height : pSize.height
            	}); 
//            	me.maximize();
        }
        
        me.callParent(arguments);
    },
    _doPositioning: function() {
    	// basePosition
    },
    /**
     * @private
     * @param {} btnName
     * @param {} state
     */
    _setToolbarButton: function(btnName, state) {
        var obj =  this.getTopToolbar();
        if(obj) {
	        var btn = obj.getComponent(btnName);
	        if(btn) {
	            (state) ? btn.enable():btn.disable();
	        }
        }
    },
    setToolbarButtons: function(btnNames, state) {
            var me = this;
            if(Ext.isArray(btnNames) ) {
                for(i =0, len = btnNames.length; i < len; i ++) {
                    var element = btnNames[i];
                    me._setToolbarButton(element, state);
                }
            } else {
                me._setToolbarButton(btnNames, state);
            }
    }
});

//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniBaseWindowApp', {
    extend: 'Unilite.com.window.UniWindow',
    header: {
        titlePosition: 0,
        titleAlign: 'left'
    },
        
    closable: false,
    closeAction: 'hide',
    modal: true,
    resizable: true,
    layout: {
        type: 'fit'
    },
    dockedItems: [],
    
    onSaveDataButtonDown:  Ext.emptyFn,
    onSaveAndCloseButtonDown:  Ext.emptyFn,
    onDeleteDataButtonDown:  Ext.emptyFn,
    onCloseButtonDown:  Ext.emptyFn, 
    onPrevDataButtonDown: Ext.emptyFn,
    onNextDataButtonDown: Ext.emptyFn,
    
    /**
     * extend init props
     */
   initComponent: function () {
        var me = this;
        me.callParent(arguments);
    }
//UniBaseWindowApp
});

//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */
Ext.define('Unilite.com.window.UniDetailWindow', {
    extend: 'Unilite.com.window.UniBaseWindowApp',
    alias: 'widget.uniDetailWindow',
    header: {
        titlePosition: 2,
        titleAlign: 'left'
    },
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        
        me.callParent(arguments);
    }
});//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniDetailFormWindow', {
    extend: 'Unilite.com.window.UniBaseWindowApp',
    alias: 'widget.uniDetailFormWindow',

    maximizable: true,
    buttonAlign: 'right',
    constructor : function (config) {
        var me = this;

        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
        me.delayedSaveAndCloseButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveAndCloseButtonDown, me);
    },
	/**
	 * extend init props
	 */
   initComponent: function () {
 		var me = this;
        
        var toolbarItems =  ['->',
	                {   
	                    itemId : 'saveBtn',
	                    text: me.text.btnSave,
	                    handler: function() {
                            me.delayedSaveDataButtonDown.delay(500);
	                        //me.onSaveDataButtonDown();
	                    },
	                    disabled: true
	                }, '-',{                    
	                    itemId : 'saveCloseBtn',
	                    text: '저장 후 닫기',
	                    handler: function() {                               
	                        me.delayedSaveAndCloseButtonDown.delay(500);                
                            //me.onSaveAndCloseButtonDown();
	                    },
	                    disabled: true
	                }, '-',' ',{                    
	                    itemId : 'deleteCloseBtn',
	                    text: me.text.btnDelete,
	                    handler: function() {
	                            me.onDeleteDataButtonDown();                        
	                    },
	                    disabled: false
	                }, '-',' ',{                    
                        itemId : 'prev',
                        text: '이전',
                        handler: function() {
//                            var frm = me.down('form');
//                            if(frm && !frm.isDirty())    {
                                me.onPrevDataButtonDown();   
//                            }
                        },
                        disabled: false
                    },{                    
                        itemId : 'next',
                        text: '다음',
                        handler: function() {
//                            var frm = me.down('form');
//                            if(frm && !frm.isDirty())  {
                                me.onNextDataButtonDown();   
//                            }
                        },
                        disabled: false
                    },'-',' ',{
	                    itemId : 'closeBtn',
	                    text: '닫기',
	                    handler: function() {
	                        me.onCloseButtonDown()
	                    },
	                    disabled: false
	                }
	            ];
        

        me.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
                dock : 'top',
                items : toolbarItems
        });
        me.dockedItems = me.toolbar;
        
        this.on('beforehide', me._beforeHide);
        this.on('beforeclose', me._beforeClose);
        me.callParent(arguments);
    },
    getForm: function(){
        var me = this;
        return me.down('form');
    },
    /**
     * 화면이 close 하기전에 저장 여부 확인
     * @param {} me
     * @param {} eOpt
     */
    _beforeHide: function(me, eOpt) {
        UniAppManager.app.confirmSaveData();
    },
    /**
     * @private 
     */
    _beforeClose: function() {
        UniAppManager.app.confirmSaveData();
    },
    onCloseButtonDown: function() {
        this.hide();
    }
});//@charset UTF-8
Ext.define('Unilite.com.window.PDFPrintWindow', {
	extend: 'Unilite.com.window.UniWindow',
	requires: [
		'Ext.ux.IFrame', 
		'Unilite.com.UniUtils',
		'Unilite.com.form.UniSearchPanel',
		'Unilite.com.form.UniSearchSubPanel',
		'Unilite.com.layout.UniTable',
		'Unilite.com.form.field.UniTextField',
		'Unilite.com.form.field.UniDateField'
	],
	alias: 'widget.PDFPrintWindow',
	width: 600,
	basePosition:'maximized',
	height: 700,
	title: '인쇄',
    closable: true,
    disabled: true,
	constructor: function(config){    
        var me = this;
       	if (config) {
            Ext.apply(me, config);
        };	
        
        
		
		
	    var itemStyle ={'margin-left':'0px','margin-bottom':'10px'};
        var configForm = {
        	xtype: 'uniSearchForm',
        	itemId: 'configForm',
        	width: 200,
        	region: 'west',
        	padding: 0,
		    splitterResize: false,
//		    split: true,
		    collapsible: true,
		    collapseMode: 'header', //header, mini
		    baseParams: {
		    	'PGM_ID': me.prgID
		    },
		    layout:  {
		    	type: 'vbox',
		        align: 'stretch',
		        padding: '10'
		    },
		    title: '출력옵션',
		    fieldDefaults : {
				msgTarget : 'qtip',
				labelAlign : 'left',
				labelWidth : 90,
				labelSeparator : "",
				boxLabelAlign: 'after'
			},
        	defaultType: 'checkbox',
        	api: {
			    load: commonReportService.loadPdfWinUserConfig,
			    submit: commonReportService.savePdfWinUserConfig
			},
			items: [
				{fieldLabel: '제목', 	xtype:'textfield', name: 'PT_TITLENAME', labelAlign:'top', disabled: true, allowBlank: false},
				{boxLabel: '회사명',name: 'PT_COMPANY_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true},
				{boxLabel: '결재란',name: 'PT_SANCTION_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true},
				{boxLabel: '페이지',name: 'PT_PAGENUM_YN',inputValue: 'Y', uncheckedValue:'N', disabled: true},
				{	xtype:'fieldcontainer',
					layout:{
				    	type: 'hbox',
				        align: 'stretch'
				    },
					items: [
						{xtype:'checkbox', boxLabel: '출력일',name: 'PT_OUTPUTDATE_YN', inputValue:'Y', uncheckedValue:'N', disabled: true},
						{xtype:'uniDatefield', name: 'PT_OUTPUTDATE', labelPad: 0, flex:1,style: {'margin-left': '0px'} , disabled: true, value: new Date()}
					]
				},
				{
					xtype: 'container',
					layout: {
						type:'hbox',								
    					align:'stretch'
					},
					items : [{   
								xtype:'button',
				                text: '설정저장',
								style: itemStyle,
								flex:1,
								margin: '0 5 5 0',
								formBind: true,
				                handler: function() {
					                if(me.validForm()) {
					                	me.onSaveConfig(me);
					                }
				                }
				        	},
				        	{   
								xtype:'button',
				                text: '기본값적용',
								style: itemStyle,
								flex:1,
								margin: '0 0 5 5',
				                handler: function() {me.onResetConfig(me);}
				        	}	
				        	]
				},
				{	xtype:'button',
	                text: '설정값 적용 미리보기',
					style: itemStyle,
					formBind: true,
	                handler: function() {me.updatePreview();}
	        	},
				{  
					xtype:'button', disabled: true,
					itemId: 'saveAsXLS',
					style: itemStyle,
					formBind: true,
	                text: '엑셀파일로 저장(xlsx)',
	                disabled: true,
	                handler: function() {me.onSaveAs(me,'xlsx');}
	        	},{   
					xtype:'button', disabled: true,
					itemId: 'saveAsDOC',
					style: itemStyle,
					formBind: true,
	                disabled: true,
	                text: '워드파일로 저장(docx)',
	                handler: function() {me.onSaveAs(me,'docx');}
	        	},{   
					xtype:'button', disabled: true,
					itemId: 'saveAsPDF',
					style: itemStyle,
					formBind: true,
	                disabled: true,
	                text: 'PDF파일로 저장(pdf)',
	                handler: function() {me.onSaveAs(me,'pdfd');}
	        	}
	        ]
        }
	      
        var iframe = { 
	         xtype: 'uxiframe',
        	 region: 'center',
        	 itemId: 'previewWin',
	         flex: 1,
	         //src: fullUrl//fullUrl
	         src: 'about:blank'//fullUrl
	    }
        this.items= [configForm, iframe];
	    this.layout={
			type: 'border',
			align:'stretch'
		}
        this.callParent([config]);
	},
	validForm: function(form) {
		if(form == null) { 
			form = this.getForm();
		}
		if( form.isValid() ) {
			return true;
		} else {
			alert('오류사항을 확인해 주세요');
			return false;
		}
	},
	updatePreview: function() {
		var me = this;
		var fullUrl = ""; //me.getFullUrl();
		var viewer= CPATH+"/resources/pdfJS/web/viewer.jsp";
		if (! Ext.isIE8m ) {
			fullUrl= viewer+"?file="+me.getFullUrl(true);
		} else {
			fullUrl= me.getFullUrl();
		}
		console.log("full url:", fullUrl);
		var previewWin = me.down('#previewWin');
		previewWin.load( fullUrl);
	},
	getForm: function() {
		return this.down("#configForm");
	},
	initComponent: function () {
        var me = this;
        me.callParent(arguments);
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.getPdfWinConfig( nParam, this.onReceiveConfig, this	);
	    me.loadUserConfigInfo();  
    },
    loadUserConfigInfo: function() {
		var me = this;
    	me.getForm().load({success:function() {me.updatePreview();}}); 
    },
	onReceiveConfig: function(result, response, success) {
		var me = this;
		var form = me.getForm();
		if(success && result) {
			if(result.PT_SAVEASXLS_USE == 'Y') me.down("#saveAsXLS").enable();
			if(result.PT_SAVEASPDF_USE == 'Y') me.down("#saveAsPDF").enable();
			if(result.PT_SAVEASDOC_USE == 'Y') me.down("#saveAsDOC").enable();
			
			
			if(result.PT_COMPANY_USE == 'Y') form.getField("PT_COMPANY_YN").enable();
			if(result.PT_SANCTION_USE == 'Y') form.getField("PT_SANCTION_YN").enable();
			if(result.PT_PAGENUM_USE == 'Y') form.getField("PT_PAGENUM_YN").enable();
			if(result.PT_TITLENAME_USE == 'Y') form.getField("PT_TITLENAME").enable();
			
			if(result.PT_OUTPUTDATE_USE == 'Y') {
				form.getField("PT_OUTPUTDATE_YN").enable();
				form.getField("PT_OUTPUTDATE").enable();
				form.getField("PT_OUTPUTDATE").enable();
				
				form.setValue("PT_TITLENAME", result.PT_TITLENAME);
			}
		}
		me.enable();
	},
	enableCmp: function (name) {
		var me = this;
		
		var cmp = me.down(name);
		if(cmp) {
			cmd.enable();
		}
	},
	getFullUrl: function(forViewer) {
		var me = this;
		var form = me.getForm();
		var params = Ext.apply(me.extParam, form.getValues());
		if(forViewer) {
        	var fullUrl = me.url +'&params=' + UniUtils.stringifyJson(params);
		} else {
        	var fullUrl = me.url + '?'+UniUtils.param(params);
		}
        return fullUrl;
	},
	onPrint: function(me) {
		console.log('onPrint');
	},
	onSaveAs: function(me, reportType) {
		window.open(this.getFullUrl()+"&reportType="+reportType,'_blank');
		console.log('onSaveExcel');
	},
	onSaveConfig: function(me) {
		var form = me.getForm();
		//button이 formBind되어 있으므로 별도의 validation 필요 없음.
		form.submit({success : function() {UniAppManager.updateStatus(Msg.sMB011);}});
		
	},
	onResetConfig: function(me) {
		var nParam={
			'PGM_ID': me.prgID
		};
		commonReportService.resetPdfWinUserConfig( nParam, this.afterResetConfig, this	);
	},
     
	afterResetConfig: function(result, response, success) {
		if(result) {
			this.loadUserConfigInfo();
			UniAppManager.updateStatus('기본값이 적용 되었습니다.');
		}
	},
     onShow: function() {
        var me = this;
     	//console.log('onShow');
     	
        me.callParent(arguments);
     }
});//@charset UTF-8

Ext.define('Unilite.Excel', {
    singleton: true,
    defineModel: function (id, config) {
		var baseFields = [
	        {name: '_EXCEL_ROWNUM',  text:'행' , type: 'int'},
	        {name: '_EXCEL_ERROR_MSG', text:'오류' , type:'string'},
	        {name: '_EXCEL_HAS_ERROR', text:'오류여부' , type:'string', hidden: true}
        ];
		config.fields = baseFields.concat(config.fields);
		
		Ext.apply(config, {
			extend: 'Ext.data.Model',
			idProperty: '_EXCEL_ROWNUM'
		});
		
		Ext.define(id, config);
    }
});

Ext.define('Unilite.com.excel.ExcelUploadWin', { 
    extend: 'Unilite.com.window.UniWindow',
    layout: {type:'vbox', align:'stretch'},

	requires: ['Unilite.com.grid.UniSimpleGridPanel'],
	
    border: 0,
    closable: false,
    width: 600,
    height: 520,
    extParam: {},
    title: '엑셀 업로드',
    // excelConfigName: 'sof100',
    tbar: null,
    jobID:null,
    
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
        	fileUpload: true,
        	itemId: 'uploadForm',
        	url: CPATH+'/excel/upload.do',
        	layout:{type:'hbox', align:'stretch'},
	    	fileUpload: true,
        	items : [ 
     				
                     { 
     	                xtype: 'filefield',
     	                buttonOnly: false,
     	                fieldLabel: '엑셀파일',
     	                flex: 1,
     	                margin:5,
     	                name: 'excelFile',
     	                buttonText: '파일선택',
     	                listeners: {
     	                    change: function( filefield, value, eOpts )    {
     	                            var fileExtention = value.substring(value.lastIndexOf("."));
     	                            console.log("new file's extension is ",fileExtention);
     	                            
     	                     } // change
     	                } // listeners
                   } // filefield
     			]
		};
		
		
		var sampleDownloadUrl = CPATH + "/excel/samples/"+me.excelConfigName;
		var tabpanel = {
			xtype: 'tabpanel',
			flex:1,
			
			items: [
		        {
		        	title: 'Help',
		        	margin:5,
		        	html: ' Sample #1(Excel 2003 format) : <a href="'+sampleDownloadUrl+'?type=xls"> [다운로드]</a>'+'<br/>'
		        		+' Sample #2(Excel 2007 format) : <a href="'+sampleDownloadUrl+'?type=xlsx">[다운로드]</a>'
		        }
			]
		};
		
		if(this.excelConfigName) {
			for(i in this.grids) {
				var cfg = this.grids[i];
				var tColumns = [];
				var tStore = new Ext.data.DirectStore( {
					model: cfg.model,
					autoLoad: false,	
					sorters: [
					          {property: '_EXCEL_ERROR_MSG', direction : 'DESC'}, 
					          {property: '_EXCEL_ROWNUM'}
					          ],
					proxy: {
						type: 'direct',
						api: {
							read: cfg.readApi
						}
					}
				});
				var newColumns =  [
	                	{ dataIndex:'_EXCEL_ROWNUM', width: 50},
	                	{ dataIndex:'_EXCEL_ERROR_MSG', flex:1, minWidth: 100}
	            ];
				newColumns = newColumns.concat(cfg.columns);
				var gridConfig = {
						xtype: 'uniSimpleGridPanel',
						store: tStore,
			            flex: 1,
			            itemId: cfg.itemId,
			            title: cfg.title,
			            columns: newColumns,
						selType: 'rowmodel', 
			            viewConfig: {
			                emptyText: '엑셀 파일을 Upload해주세요.',
			                deferEmptyText: false,
			                getRowClass: function(record) { 
			                    if ( !Ext.isEmpty(record.get('_EXCEL_ERROR_MSG')) ) {
			                    	return 'x-grid-excel-hasError';
			                    
			                    }
			                } 
			            },
			            listeners:{
							/*beforeselect: function ( gridPanel, record, index, eOpts ) {
							    if (record.get('_EXCEL_HAS_ERROR') == 'Y') {
							    	return false;
							    }
							}*/
			            }
			            
					};
				if(cfg.useCheckbox) {

					var sm = Ext.create('Ext.selection.CheckboxModel');
					Ext.apply(gridConfig, {selModel: sm});
				}
				
				if(cfg.listeners) {
					Ext.apply(gridConfig.listeners, cfg.listeners);
				}
				
				tabpanel.items.push(gridConfig);
			}	
			frm.baseParams = {
					excelConfigName: this.excelConfigName
			};
			this.items = [
	              frm,
	              tabpanel
			];
			
			this._setToolBar();
		} else {
			this.items = [{
			    	flex: 1,
					html: '엑셀설정 정보를 확인해 주세요.'
			}]
		}

		me.callParent(arguments);
	}, // constructor
	initComponent: function(){ 
		this.callParent();
	},  // initComponent
	getTabPanel: function() {
		
	},
	uploadFile: function() {
		var me = this,
		frm = me.down('#uploadForm');
		frm.submit({
			params: me.extParam,
			success: function(form, action) {
				me.jobID = action.result.jobID;
				me.readGridData(me.jobID);
				me.down('tabpanel').setActiveTab(1);
				Ext.Msg.alert('Success', 'Upload 되었습니다.');
			},
            failure: function(form, action) {
                Ext.Msg.alert('Failed', action.result.msg);
            }
			
		});
	},
	readGridData: function( jobId ) {
		var me = this;
		var param = {
			_EXCEL_JOBID: jobId
		}
		if (me.extParam) {
			param = Ext.apply(param, me.extParam);
        }
		
		for(i in this.grids) {
			var cfg = this.grids[i];
			var grid = me.down('#'+cfg.itemId);
			grid.getStore().load({
				params : param
			});
		}
		
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : '업로드',
				tooltip : '업로드', 
				handler: function() { 
					me.jobID = null;
					me.uploadFile();
				}
			},
			{
				xtype: 'button',
				text : 'Read Data',
				tooltip : 'Read Data', 
				hidden: true,
				handler: function() { 
					if(me.jobID != null)	{
						me.readGridData(me.jobID);
						me.down('tabpanel').setActiveTab(1);
					} else {
						alert('Upload된 파일이 없습니다.')
					}
				}
			},
			{
				xtype: 'button',
				text : '적용',
				tooltip : '적용', 
				handler: function() { 
					var grids = me.down('grid');
					var isError = false;
					Ext.each(grids, function(grid,i){	
			        	var records = grid.getSelectionModel().getSelection();
			        	return Ext.each(records, function(record,i){	
				        	if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
				        		isError = true;		
				        		return false;
				        	}
					    });
				    }); 
				    if(!isError) {
						me.onApply();
				    }
				}
			},
			'->',
			{
				xtype: 'button',
				text : '닫기',
				tooltip : '닫기', 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});/**
 * 
 */
 
Ext.define('Unilite.com.openapi.UniNaverSearch', {
	//extend : "Ext.Component",
	singleton: true,
	alternateClassName: ['UniNaverSearch'],
	//popupWidth:700,
	//popupHeight:550,
	//onSuccess 	: Ext.emptyFn,
	onFailure 	: function(response) {		
					Ext.Msg.show({
					     title:'Failure ',
					     msg: response.responseText,
					     buttons: Ext.Msg.OKCANCEL,
					     icon: Ext.Msg.ERROR
					});
	},
	onError 	: function(result) {		
					Ext.Msg.show({
					     title:'Error '+result.error_code,
					     msg: result.message,
					     buttons: Ext.Msg.OKCANCEL,
					     icon: Ext.Msg.ERROR
					});
	},
	
//	initComponent : function() {		
//		this.callParent()
//	},
	/**
	 *  책 기본 검색
	 *  요청 파라미터 정보
	    key string (필수)  이용 등록을 통해 받은 key 스트링을 입력합니다. 
		target string (필수) : book  서비스를 위해서는 무조건 지정해야 합니다. 
		query string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다 
	 * @param {} params
	 */
	searchBook: function(params) {
		var me = this;
		
		Ext.Ajax.request({
		    url: CPATH+'/openapi/naver/book/search.do',
		    params: params,
		    success: function(response, options){
		        var result = Ext.JSON.decode(response.responseText);
				
		        if(me.isSuccess(result)) {
		        	//me.onSuccess(result);
		        	if(callback && Ext.isFunction(callback)) {
		        		callback.call(this, me, result.channel.item, result);
		        	}
		        }else{
		        	me.onError(result);
		        }
		    },
		    failure: function(response, options) {
		    	me.onFailure(response);
		    }
		});
	},
	
	/**
	 *  책 상세 검색
	 *  요청 파라미터 정보
	    target  string (필수) : book_adv  상세검색을 위해서는 무조건 지정해야 합니다. 
		query  string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		d_titl  string  책 제목에서의 검색을 의미합니다. 
		d_auth  string  저자명에서의 검색을 의미합니다. 
		d_cont  string  목차에서의 검색을 의미합니다. 
		d_isbn  string  isbn에서의 검색을 의미합니다. 
		d_publ  string  출판사에서의 검색을 의미합니다. 
		d_dafr  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (시작일) 
		d_dato  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (종료일) 
		d_catg  integer  검색을 원하는 카테고리를 지정합니다.  
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다.
	 * @param {} params
	 * @param {} callback
	 */
	searchBookAdv: function(params, callback) {
		var me = this;
		
		Ext.Ajax.request({
		    url: CPATH+'/openapi/naver/book/searchAdv.do',
		    params: params,
		    success: function(response, options){
		        var result = Ext.JSON.decode(response.responseText);
				
		        if(me.isSuccess(result)) {
		        	//me.onSuccess(result);
		        	if(callback && Ext.isFunction(callback)) {
		        		callback.call(this, me, result.channel.item, result);
		        	}
		        }else{
		        	me.onError(result);
		        }
		    },
		    failure: function(response, options) {
		    	me.onFailure(response);
		    }
		});
	},
	
	isSuccess: function(result) {
		return Ext.isEmpty(result.error_code);
	},
	
	openLink: function(url) {
		var me = this;
		
		var width = (screen.availWidth) / 2, height = (screen.availHeight) / 2;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
		
	    var features = "titlebar=0,location=0,menubar=0,toolbar=0,scrollbars=1,status=0," +
	            "width="+width +",height="+height ;

	    window.open(url, '_blank', features);

	},
	getLinkScript: function(url) {
		var me = this;
		
		var width = (screen.availWidth) / 2, height = (screen.availHeight) / 2;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
		
	    var features = "titlebar=0,location=0,menubar=0,toolbar=0,scrollbars=1,status=0," +
	            "width="+width +",height="+height ;

	    return "window.open('"+url+"', '_blank', '"+features+"')";
	}	
});//@charset UTF-8
/**
 * 영업 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
Ext.define('Unilite.module.UniSales', {
    alternateClassName: 'UniSales',
    singleton: true,
    
    /**
     * Excel round / roundup / rounddown 함수 
     * roundup 과 rounddown은 ceil과 floor와 약간 다름 
     * roundup : 0 에서 먼 수
     * rounddown : 0 에서 가까운 수
     * 음수 round의 경우 abs 기준 round 사용 !!! 즉 -3.5 는 -4 임.
     * @param {number} dAmount
     * @param {String} sUnderCalBase 1: roundup, 2:rounddown, 기타 : round
     * @param {Integer} numDigit
     */
    fnAmtWonCalc: function(dAmount, sUnderCalBase, numDigit)	{
			var absAmt = 0, wasMinus = false;
			var numDigit = (numDigit == undefined) ? 0 : numDigit ;
			
			if( dAmount >= 0 ) {
				absAmt = dAmount;
			} else {
				absAmt = Math.abs(dAmount);
				wasMinus = true;
			}
			
			var mn = Math.pow(10,numDigit);
			switch (sUnderCalBase) {
				case  "1" :	//up : 0에서 멀어짐.
					absAmt = Math.ceil(absAmt * mn) / mn;
					break;
				case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
					absAmt = Math.floor(absAmt * mn) / mn;
					break;
				default:						//round
					absAmt = Math.round(absAmt * mn) / mn;
			}
			// 음수 였다면 -1을 곱하여 복원.
			return (wasMinus) ? absAmt * (-1) : absAmt;

    },
    fnGetPriceInfo2: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,  
                            currency, orderUnit, stockUnit, transRate, baseDate,
                            qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType, bOpt)	{
    	if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'CUSTOM_CODE':customCode
        				, 'AGENT_TYPE':agentType
        				, 'ITEM_CODE':itemCode
        				, 'MONEY_UNIT':currency
        				, 'ORDER_UNIT':orderUnit
        				, 'STOCK_UNIT':stockUnit
        				, 'TRANS_RATE':transRate
        				, 'BASIS_DATE':baseDate	      
        				, 'WGT_UNIT':sWgtUnit
        				, 'VOL_UNIT':sWgtUnit
        				};
        	Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo2(param, function(provider, response)	{
						Ext.getBody().unmask();
						if(!Ext.isEmpty(provider))	{
							var cbParam = {
								'sType':sType,								
								'qty':qty,								
								'unitWgt':unitWgt,
								'unitVol':unitVol,
								'priceType':priceType,
								'rtnRecord':rtnRecord,
								'bOpt':bOpt
							}
							fnCallback.call(this, provider, cbParam);
							/*
							var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
							
							
							var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
							var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)
							
							if(sType=='I')	{
								
								//단가구분별 판매단가 계산
								if(priceType == 'A')	{							//단가구분(판매단위)
									dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
									dVolPrice  = (unitVol==0) ? 0 : dSalePrice / unitVol
								}else if(priceType == 'B')	{						//단가구분(중량단위)
									dSalePrice = dWgtPrice  * unitWgt
									dVolPrice  = (unitVol==0) ? 0 : dSalePrice / unitVol
								}else if(priceType == 'C')	{						//단가구분(부피단위)
									dSalePrice = dVolPrice  * unitVol;
									dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
								}else {
									dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
									dVolPrice = (unitVol==0) ? 0 : dSalePrice / unitVol
								}
								

								//판매단가 적용
								rtnRecord.set('ORDER_P',dSalePrice);
								rtnRecord.set('ORDER_WGT_P',dWgtPrice);
								rtnRecord.set('ORDER_VOL_P',dVolPrice);
								
								rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
								rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);
							}
							if(orderQ > 0)	UniAppManager.app.fnOrderAmtCal(rtnRecord, "P", dSalePrice);
							*/
						}													
				});
    	}
    },
    fnGetPriceInfo: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,  
                            currency, orderUnit, stockUnit, transRate, baseDate, bOpt)	{
    	if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'CUSTOM_CODE':customCode
        				, 'AGENT_TYPE':agentType
        				, 'ITEM_CODE':itemCode
        				, 'MONEY_UNIT':currency
        				, 'ORDER_UNIT':orderUnit
        				, 'STOCK_UNIT':stockUnit
        				, 'TRANS_RATE':transRate
        				, 'BASIS_DATE':baseDate
        				};
        	Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo(param, function(provider, response)	{
						Ext.getBody().unmask();
						if(!Ext.isEmpty(provider))	{
							var cbParam = {
								'sType':sType,							
//								'unitWgt':unitWgt,
//								'unitVol':unitVol,
//								'priceType':priceType,
								'rtnRecord':rtnRecord
//								'bOpt':bOpt
							}
							fnCallback.call(this, provider, cbParam);
						}													
				});
    	}
    },
    fnGetDivPriceInfo2: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,  
                            currency, orderUnit, stockUnit, transRate, baseDate,
                            qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType, bOpt)	{
    	if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'CUSTOM_CODE':customCode
        				, 'AGENT_TYPE':agentType
        				, 'ITEM_CODE':itemCode
        				, 'MONEY_UNIT':currency
        				, 'ORDER_UNIT':orderUnit
        				, 'STOCK_UNIT':stockUnit
        				, 'TRANS_RATE':transRate
        				, 'BASIS_DATE':baseDate	      
        				, 'WGT_UNIT':sWgtUnit
        				, 'VOL_UNIT':sWgtUnit
        				};
        	Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo2(param, function(provider, response)	{
						Ext.getBody().unmask();
						if(!Ext.isEmpty(provider))	{
							var cbParam = {
								'sType':sType,								
								'qty':qty,								
								'unitWgt':unitWgt,
								'unitVol':unitVol,
								'priceType':priceType,
								'rtnRecord':rtnRecord,
								'bOpt':bOpt
							}
							fnCallback.call(this, provider, cbParam);
						}													
				});
    	}
    },
    fnGetItemInfo: function(rtnRecord, fnCallbak, sType,compCode, customCode, agentType, itemCode,  
                            currency, orderUnit, stockUnit, transRate, baseDate,
                            qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType,  divCode, bParam3,  whCode)	{
    	var param = {'COMP_CODE':compCode
        				, 'CUSTOM_CODE':customCode
        				, 'AGENT_TYPE':agentType
        				, 'ITEM_CODE':itemCode
        				, 'MONEY_UNIT':currency
        				, 'ORDER_UNIT':orderUnit
        				, 'STOCK_UNIT':stockUnit
        				, 'TRANS_RATE':transRate
        				, 'BASIS_DATE':baseDate	      
        				, 'WGT_UNIT':sWgtUnit
        				, 'VOL_UNIT':sWgtUnit
        				, 'DIV_CODE':divCode
        				, 'bParam3':bParam3
        				, 'WH_CODE':whCode
        				};
        				
    	salesCommonService.getItemInfo(param, function(provider, response)	{
				Ext.getBody().unmask();
				if(!Ext.isEmpty(provider))	{
					var cbParams = {
						'sType':sType,								
						'qty':qty,								
						'unitWgt':unitWgt,
						'unitVol':unitVol,
						'priceType':priceType,
						'rtnRecord':rtnRecord							
					}
					fnCallbak.call(this, provider, cbParams);	
				}
		});
    	
    },
    fnStockQ: function(rtnRecord, fnCallbak, compCode, divCode, bParam3, itemCode,  whCode)	{
    	if(!Ext.isEmpty(compCode) && !Ext.isEmpty(divCode) && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'DIV_CODE':divCode
        				, 'bParam3':bParam3
        				, 'ITEM_CODE':itemCode
        				, 'WH_CODE':whCode		};
        	Ext.getBody().mask();
        	//salesCommonServiceImpl
			salesCommonService.fnStockQ(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log(provider);
					if(!Ext.isEmpty(provider))	{
						var cbParams = {																					
						//	'orderQ':orderQ,		
							'rtnRecord':rtnRecord							
						}
						fnCallbak.call(this, provider, cbParams);
					}
			});
    	}
    },
    fnGetCustCredit: function (compCode, divCode, customCode, sDate, currency, rObj, rName,  rType, rValue)	{
    	var param = {'COMP_CODE':compCode
    				, 'DIV_CODE':divCode
    				, 'CUSTOM_CODE':customCode
    				, 'S_DATE':sDate
    				, 'CURRENCY':currency
    				};
    	Ext.getBody().mask();
		salesCommonService.fnGetCRedit(param, function(provider, response)	{
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider))	{
				alert(Msg.sMB009);
			}else {
				this.setReturnValue(rObj, rName,  rType, provider['CREDIT']);
			}
		})
		//return r;
    },
    /**
     * 환율구하기
     * @param {} compCode
     * @param {} moneyUnit
     * @param {} sData
     * @param {} rObj
     * @param {} rName
     * @param {} rType
     * @param {} rValue
     */
	fnExchangeRate: function(compCode, moneyUnit, sData, rObj, rName,  rType, rValue){

    	var param = {'COMP_CODE':compCode
    				, 'DIV_CODE':divCode
    				, 'S_DATE':sDate
    				};
    	Ext.getBody().mask();
		salesCommonService.fnExchangeRate(param, function(provider, response)	{
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider))	{
				this.setReturnValue(rObj, rName,  rType, 1);
			}else {
				this.setReturnValue(rObj, rName,  rType, provider['BASE_EXCHG']);
			}
		})

	},
    /**
     *  작업장에 대한 제조처 반환 
     */
    fnOrgCd: function(compCode, orgCdType, wkShopcd, rObj, rName,  rType, rValue) {
        var param = {'COMP_CODE':compCode
                    , 'TYPE':orgCdType
                    , 'TREE_CODE':wkShopcd
                    };
        Ext.getBody().mask();
        salesCommonService.fnOrgCd(param, function(provider, response)  {
            Ext.getBody().unmask();
            if(!Ext.isEmpty(provider))  {
                alert(Msg.sMB009);
            }else {
                this.setReturnValue(rObj, rName,  rType, provider['TYPE_LEVEL']);
            }
        })
     },
     
     /**
     *  사업장정보 조회 
     */
    fnGetOrgInfo: function(compCode, divCode, callbackFuntionName)  {
        var param = {'COMP_CODE':compCode
                    , 'DIV_CODE':divCode
                    };
        Ext.getBody().mask();
        salesCommonService.fnGetOrgInfo(param, function(provider, response) {
            Ext.getBody().unmask();
            if(!Ext.isEmpty(provider))  {
                alert(Msg.sMB009);
            }else {
                eval(callbackFuntionName+"("+provider+")");
            }
        })
    },
    
    /**
     *  마감정보 
     */
    fnCloseCheck: function(compCode, divCode, whCd , sDate) {
        var param = {'COMP_CODE':compCode
                    , 'DIV_CODE':divCode
                    , 'WH_CODE' :whCd
        };
        Ext.getBody().mask();
        salesCommonService.fnGetOrgInfo(param, function(provider, response) {
            Ext.getBody().unmask();
        })
    },

    setReturnValue:function(rObj, rName,  rType, rValue)    {
        if("RECORD" == rType)       {
            rObj.set(rName, rValue)
        }else if("FORM")    {
            rObj.setValue(rName, rValue)
        } else if("ARRAY"==rType)   {
            rObj[rName] = rValue;
        }
    },
    fnGetClosingInfo: function(fnCallbak, divCode, sJobType, sDate){
    	var monClosing = "";
    	var dayClosing = "";
    	var param = { 'DIV_CODE':divCode
    				, 'S_JOB_TYPE':sJobType
    				, 'SALE_DATE':sDate };    				
		salesCommonService.getMonClosing(param, function(provider1, response)	{		
			if(!Ext.isEmpty(provider1))	{
				if(provider1['AR_CLOSING'] >= sDate){
					monClosing = "Y";
				}else{
					monClosing = "N";
				}
			}
			salesCommonService.getDayClosing(param, function(provider2, response)	{
				if(!Ext.isEmpty(provider2))  {
					var dayClosing = provider2['JOB_CLOSING'];
					var cbParams = {
						'gsMonClosing':	monClosing,
						'gsDayClosing': dayClosing
					}					
					fnCallbak.call(this,cbParams);
				}else{
					salesCommonService.getDayClosing2(param, function(provider3, response)	{
						if(!Ext.isEmpty(provider3))	{
							if(provider3['JOB_CLOSING'] >= sDate){
								dayClosing = "Y";
							}else{
								dayClosing = "N";
							}
							var cbParams = {
								'gsMonClosing':	monClosing,
								'gsDayClosing': dayClosing
							}
							fnCallbak.call(this,cbParams);
						}
					});
				}								
			});
			
		});
    	
    },
    /**
     *  미수잔액, 선수금잔액 구하기 
     */   
    fnGetRemainder: function(fnCallback, iFlag, divCode, customCode, moneyUnit, collDate)	{
    	
    	var param = { 'I_FLAG': iFlag
    				, 'DIV_CODE': divCode
    				, 'CUSTOM_CODE': customCode    				
    				, 'MONEY_UNIT': moneyUnit
    				, 'COLL_DATE': collDate
    				};
//    	Ext.getBody().mask();
    	var result1 = 0;	//미수잔액
    	var result2 = 0;	//선수금잔액
		salesCommonService.getRemainderInfo1(param, function(provider1, response)	{	//미수금잔액 조회
			if(!Ext.isEmpty(provider1.UN_COLL_AMT)){
				result1 = provider1.UN_COLL_AMT;
			}
			salesCommonService.getRemainderInfo2(param, function(provider2, response)	{	//선수금액 조회
				if(!Ext.isEmpty(provider2.UN_COLL_AMT)){
					result2 = provider2.UN_PRE_COLL_AMT;
				}
				fnCallback.call(this, result1, result2);
			});												
		});    	
    }
}); 



//@charset UTF-8
/**
 * 회계 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
Ext.define('Unilite.module.UniAccnt', {
    alternateClassName: 'UniAccnt',
    singleton: true,
	makeItem: function( acCode,  acName,  fName, fDataName, acType, acPopup, acLen, acCtl, acFormat)	{
		var field = {};
		// acType
		if(acPopup == 'Y')	{  
			if(acCode.substring(0,1) != "Z")	{
    			switch(acCode)	{
	    			case 'A2': Ext.apply(field, Unilite.popup('DEPT',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//부서
	    				break;
	    			case 'A3': Ext.apply(field, Unilite.popup('BANK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//은행
	    				break;
	    			case 'A4': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));		//거래처
	    				break;
	    			case 'A6': Ext.apply(field, Unilite.popup('Employee',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));	//사번
	    				break;
	    			case 'A7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//예산코드
	    				break;
	    			case 'A9': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//Cost Pool
	    				break;
	    			case 'B1': Ext.apply(field, Unilite.popup('DIV_PUMOK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//사업장별 품목팝업
	    				break;
	    			case 'C2': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//어음번호
	    				break;
	    			case 'C7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//수표번호
	    				break;
	    			case 'D5': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//L/C번호(수출)
	    				break;
	    			case 'D6': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//L/C번호(수입)
	    				break;
	    			case 'D7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//B/L번호(수출)
	    				break;
	    			case 'D8': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//B/L번호(수입)
	    				break;
	    			case 'E1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//프로젝트
	    				break;
	    			case 'G5': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//증빙유형
	    				break;
	    			case 'M1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//자산코드
	    				break;
	    			case 'O1': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//Deposit
	    				break;
	    			case 'P2': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, textFieldWidth:150}));			//차입금번호
	    				break;
	    			case 'B5': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'B013'});
	    				break;
	    			case 'C0': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A058'});
	    				break;
	    			case 'D2': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'B004'});
	    				break;
	    			case 'I4': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A003'});
	    				break;
	    			case 'I5': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A022'});
	    				break;
	    			case 'I7': Ext.apply(field, {fieldLabel:acName, xtype:'uniCombobox', name:fName, comboType:'AU', comboCode: 'A149'});
	    				break;    				
	    			default:
	    				break;
	    		}
			}else {
				//  Z로 시작하는 관리항목은 사용자 정의 항목임
				Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen});
			}
		}else {
    		switch(acType)	{
    			case 'A': Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen});
    				break;
    			case 'N': Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen });
    				break;
    			case 'D': Ext.apply(field, {fieldLabel:acName, xtype:'uniDatefield', name:fName});
    				break;
    			default:
    				break;
    		}
		}
		
		if(acType=='N')	{
			switch(acFormat)	{
    			case 'Q': Ext.apply(field, {uniType:'uniQty'});	
    				break;
    			case 'P': Ext.apply(field, {uniType:'uniUnitPrice'}); 
    				break;
    			case 'I': Ext.apply(field, {uniType:'uniPrice'});
    				break;
    			case 'O': Ext.apply(field, {uniType:'uniFC'});
    				break;
    			case 'R': Ext.apply(field, {uniType:'uniER'});
    				break;
    			default:
    				break;
    		}
		}
		
		if(acCtl == 'Y')	{
			Ext.apply(field, {allowBlank: false});
		}
		return field;
	},
	makeBlankField: function()	{
		var field={xtype:'component', html:'&nbsp;'};
		return field;
	},	
	
	addMadeFields : function( form, dataMap )	{
    	var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
		console.log('dataMap: ',dataMap)
		form.removeAll();
    	/*form.remove('AC_CODE1');
    	form.remove('AC_DATA_NAME1');
    	form.remove('AC_DATA1');
    	form.remove('AC_CODE2');
    	form.remove('AC_DATA_NAME2');
    	form.remove('AC_DATA2');
    	form.remove('AC_CODE3');
    	form.remove('AC_DATA_NAME3');
    	form.remove('AC_DATA3');*/
    	
		acCode= dataMap['AC_CODE1'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA1';
			fDataName = 'AC_DATA_NAME1';
			acName = dataMap['AC_NAME1'];
			acType = dataMap['AC_TYPE1'];
			acPopup = dataMap['AC_POPUP1'];
			acLen = dataMap['AC_LEN1'];
			acCtl = dataMap['AC_CTL1'];
			acFormat = dataMap['AC_FORMAT1'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName,	acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE4'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA4' 
			fDataName = 'AC_DATA_NAME4';
			acName = dataMap['AC_NAME4'];
			acType = dataMap['AC_TYPE4'];
			acPopup = dataMap['AC_POPUP4'];
			acLen = dataMap['AC_LEN4'];
			acCtl = dataMap['AC_CTL4'];
			acFormat = dataMap['AC_FORMAT4'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE2'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA2' 
			fDataName = 'AC_DATA_NAME2';
			acName = dataMap['AC_NAME2'];
			acType = dataMap['AC_TYPE2'];
			acPopup = dataMap['AC_POPUP2'];
			acLen = dataMap['AC_LEN2'];
			acCtl = dataMap['AC_CTL2'];
			acFormat = dataMap['AC_FORMAT2'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE5'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA5' 
			fDataName = 'AC_DATA_NAME5';
			acName = dataMap['AC_NAME5'];
			acType = dataMap['AC_TYPE5'];
			acPopup = dataMap['AC_POPUP5'];
			acLen = dataMap['AC_LEN5'];
			acCtl = dataMap['AC_CTL5'];
			acFormat = dataMap['AC_FORMAT5'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
			
		acCode= dataMap['AC_CODE3'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA3' 
			fDataName = 'AC_DATA_NAME3';
			acName = dataMap['AC_NAME3'];
			acType = dataMap['AC_TYPE3'];
			acPopup = dataMap['AC_POPUP3'];
			acLen = dataMap['AC_LEN3'];
			acCtl = dataMap['AC_CTL3'];
			acFormat = dataMap['AC_FORMAT3'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		acCode= dataMap['AC_CODE6'];
		if(!Ext.isEmpty(acCode))	{
			fName = 'AC_DATA6' 
			fDataName = 'AC_DATA_NAME6';
			acName = dataMap['AC_NAME6'];
			acType = dataMap['AC_TYPE6'];
			acPopup = dataMap['AC_POPUP6'];
			acLen = dataMap['AC_LEN6'];
			acCtl = dataMap['AC_CTL6'];
			acFormat = dataMap['AC_FORMAT6'];
			form.add(UniAccnt.makeItem(acCode,  acName,	fName,	fDataName, acType, acPopup, acLen, acCtl, acFormat));
		}else {
			form.add(UniAccnt.makeBlankField());	
		}
		
		//form.masterGrid.addChildForm(form);
		form._onAfterRenderFunction(form);
		 
		console.log('form:', form);
	}			
    			
	
}); 



//@charset UTF-8
/**
 * 구매 모듈용 공통 함수 모음
 * @class Unilite.module.UniMatrl
 * @singleton
 */
Ext.define('Unilite.module.UniMatrl', {
    alternateClassName: 'UniMatrl',
    singleton: true,
    
    /**
     * Excel round / roundup / rounddown 함수 
     * roundup 과 rounddown은 ceil과 floor와 약간 다름 
     * roundup : 0 에서 먼 수
     * rounddown : 0 에서 가까운 수
     * 음수 round의 경우 abs 기준 round 사용 !!! 즉 -3.5 는 -4 임.
     * @param {number} dAmount
     * @param {String} sUnderCalBase 1: roundup, 2:rounddown, 기타 : round
     * @param {Integer} numDigit
     */
    fnAmtWonCalc: function(dAmount, sUnderCalBase, numDigit)	{
			var absAmt = 0, wasMinus = false;
			var numDigit = (numDigit == undefined) ? 0 : numDigit ;
			
			if( dAmount >= 0 ) {
				absAmt = dAmount;
			} else {
				absAmt = Math.abs(dAmount);
				wasMinus = true;
			}
			
			var mn = Math.pow(10,numDigit);
			switch (sUnderCalBase) {
				case  "1" :	//up : 0에서 멀어짐.
					absAmt = Math.ceil(absAmt * mn) / mn;
					break;
				case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
					absAmt = Math.floor(absAmt * mn) / mn;
					break;
				default:						//round
					absAmt = Math.round(absAmt * mn) / mn;
			}
			// 음수 였다면 -1을 곱하여 복원.
			return (wasMinus) ? absAmt * (-1) : absAmt;

    },
    
    fnStockQ: function(rtnRecord, fnCallbak, compCode, divCode, bParam3, itemCode,  whCode)	{
    	if(!Ext.isEmpty(compCode) && !Ext.isEmpty(divCode) && !Ext.isEmpty(itemCode))	{
        	var param = {'COMP_CODE':compCode
        				, 'DIV_CODE':divCode
        				, 'bParam3':bParam3
        				, 'ITEM_CODE':itemCode
        				, 'WH_CODE':whCode		};
        	Ext.getBody().mask();
			matrlCommonService.fnStockQ(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log(provider);
					if(!Ext.isEmpty(provider))	{
						var cbParams = {																					
						//	'orderQ':orderQ,		
							'rtnRecord':rtnRecord							
						}
						fnCallbak.call(this, provider, cbParams);
					}
			});
    	}
    }
    
    
    
    
    
}); 



//@charset UTF-8
/**
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */

Ext.define('Unilite.com.BaseJSPopupApp', {
	extend: 'Ext.window.Window',
    requires: [
    	'Unilite.com.UniAppManager'
	],
    
    text: {
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnClose: '닫기'
    },
    closable: false,
    closeAction: 'destroy',         // 한화면에 같은 팝업을 여러군데 쓸수 있으므로 윈도는 close로 닫고 destory 시킨다.
    modal: true,
    resizable: true,
    layout:{type:'vbox', align:'stretch'},
    width: 500,
    height: 400,
    //defaults: {padding:'0 0 5 0'},
    callBackFn: Ext.emptyFn,
    
    constructor : function (config) {
        var me = this;

        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
    },
    initComponent : function(){    
    	var me  = this;
        
    	this.setToolBar();
//		this.comPanelToolbar.dockedItems = [this.toolbar];
//		console.log("BaseJSPopupApp init.");
//    	var newItems = [];
//    	newItems.push(this.comPanelToolbar);  
// 	
//    	for(i = 0, len = this.items.length; i < len; i ++ ) {
//    		var element = this.items[i];
//    		newItems.push(element);
//    	}
    	//this.items = newItems;   
        this.tbar= this.toolbar;
    	this.callParent();		
    	//var params = Unilite.getParams();
    	//this.fnInitBinding(params);
    	
    },
    // abstract
	beforeClose:Ext.emptyFn,
    // abstract
    fnReceiveParam:  Ext.emptyFn,
    // abstract
    fnInitBinding:  Ext.emptyFn,

    toolBar: {},    
    comPanelToolbar: {
			xtype : 'panel',
			//id : 'comPanelToolbar',
			flex : 0,
			border : 0,
			margin : '0 0 0 0 ',
			dockedItems : [ ]
	},
	
	onQueryButtonDown: Ext.emptyFn,
	onSubmitButtonDown: function()	{
		this.close();
	},

    returnData: function(data) {
        this.callBackFn.call(this.callBackScope, data, this.popupType);
        this.close();
    },
	
	// private
	setToolBar : function() {
		var me = this;
		var btnQuery = Ext.create('Ext.button.Button', {
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onQueryButtonDown();
				}
			});
			
		var btnSubmit = Ext.create('Ext.button.Button', {
		 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onSubmitButtonDown();
				}
			});
	
    	this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
				dock : 'top',
				items : [ '->', btnQuery,
				// space
				' ','-',' ',
				btnSubmit,
				/*{text : '확인',tooltip : '확인',iconCls : 'icon-query',
					handler: function() { 
						window.close();
					}
				},*/
				{text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
					handler: function() { 
						//me.close();
						me._onCloseBtnDown();
					}
				}
				,' '
				//,'-',' ', me._getSheetButtons()
				
			]
		});
	
	},
    
    _onCloseBtnDown: function() {
    	this.callBackFn.call(this.callBackScope, null, this.popupType);
        this.close();
    },
	setToolbarButtons: function(btnNames, state) {
		var me = this;
		if(Ext.isArray(btnNames) ) {
			for(i =0, len = btnNames.length; i < len; i ++) {
				var element = btnNames[i];
				me._setToolbarButton(element, state);
			}
		} else {
			me._setToolbarButton(btnNames, state);
		}
	},
	_setToolbarButton : function(btnName, state) {
		var obj =  this.getTopToolbar().getComponent(btnName);
        if(obj) {
            (state) ? obj.enable():obj.disable();
        }
	},
	isDirty: function() {
		var obj =  this.getTopToolbar().getComponent('save');
		var rv = false;
		if(obj) {
			rv =  ! obj.disabled;
		}
		return rv;
	},
	onShow: function() {
        var me = this;
        var mySize = me.getSize();
        var pSize = Ext.getBody().getSize();
        
        if(mySize.height > pSize.height) {
            me.setSize({
                    width: mySize.width,
                    height : pSize.height
            });   
        }
        var posX = pSize.width - mySize .width;
        me.x = 0;(posX < 0) ? 0 : posX;
        me.y = 0;
        //me.setXY(me.);
        
        
        me.callParent(arguments);
    },
    getTopToolbar: function() {
        return this.toolbar;
    }
});

/**
 * 카렌다용 
 */
Ext.define('Unilite.com.BaseJSPopupCalApp', {
    extend: 'Unilite.com.BaseJSPopupApp',
    // private
    setToolBar : function() {
        var me = this;
        
		var btnSave = {
                xtype: 'button',
                text : me.text.btnSave, tooltip : '저장', disabled: true,
                itemId : 'save',
                handler : function() { 
                    Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
            };
            
        var btnDelete = {
                xtype: 'button',
                text : me.text.btnDelete,tooltip : '삭제', disabled: true,
                itemId : 'delete',
                handler : function() { me.onDeleteDataButtonDown() }
            };

        this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
            dock : 'top',
            items : [ '->', 
	            btnSave,btnDelete,
	            // space
	            ' ','-',' ',
	            
	            {text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
	                handler: function() { 
	                     me.close();
	                }
	            }
            ]
        });
    
    }
});

/**
 * 그리드 설정용 
 */
Ext.define('Unilite.com.BaseJSPopupGridApp', {
    extend: 'Unilite.com.BaseJSPopupApp',
    // private
    setToolBar : function() {
        var me = this;
        
        var btnQuery =  {
                xtype: 'button',
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onQueryButtonDown();
				}
			};
		var btnReset =  {
                xtype: 'button',
		 		text : '초기화',tooltip : '초기화', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onResetButtonDown();
				}
			};	
		
		var btnSave = {
                xtype: 'button',
                text : me.text.btnSave, tooltip : '저장', disabled: true,
                itemId : 'save',
                handler : function() { 
                    Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
            };
            
        var btnDelete = {
                xtype: 'button',
                text : me.text.btnDelete,tooltip : '삭제', disabled: true,
                itemId : 'delete',
                handler : function() { me.onDeleteDataButtonDown() }
            };

        var btnSubmit = Ext.create('Ext.button.Button', {
	 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
			handler: function() { 
				me.onSubmitButtonDown();
			}
		});
		
        this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
            dock : 'top',
            items : [ '->', 
	            btnQuery,	
	            btnReset,
	            ' ','-',' ',	            
	            btnSave,btnDelete,
	            // space
	            ' ','-',' ',
	            btnSubmit,
	            {text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
	                handler: function() { 
	                     me.close();
	                }
	            }
            ]
        });
    
    }
});
//@charset UTF-8
Ext.define('Unilite.com.config.CodeGrid', {
	extend: 'Ext.container.Container',
	
	alias: 'widget.ConfigCodeGrid',
	codeName: '',
	subCode: '',
	constructor: function(config){    
        var me = this;
        
        var grid = me.sysCodeGridConfig( config.codeName, config.subCode )	;
		//Ext.apply(config, mConfig);
		
       	if (config) {
            Ext.apply(me, config);
        };	
        

		this.items=[grid];
		
        this.callParent([config]);
	},
    initComponent: function() {
        var me = this;
        
        
        me.callParent(arguments);
     },
   
     

     sysCodeGridConfig:function(codeName, subCode )	{
     	
 		Unilite.defineModel('systemCodeModel', {
		    fields : [ 	  
		    	  {name : 'MAIN_CODE',		text : '종합코드'	, allowBlank : false, readOnly:true}
				, {name : 'SUB_CODE',		text : '상세코드'	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
				, {name : 'CODE_NAME',		text : '상세코드명'	, allowBlank : false}
				, {name : 'SYSTEM_CODE_YN',	text : '시스템',	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
				, {name : 'SORT_SEQ',		text: '정렬순서',	type : 'int',			defaultValue:1	, allowBlank : false}
				, {name : 'REF_CODE1',		text: '관련1',		type : 'string'	}
				, {name : 'REF_CODE2',		text: '관련2',		type : 'string'	}
				, {name : 'REF_CODE3',		text: '관련3',		type : 'string'	}
				, {name : 'REF_CODE4',		text: '관련4',		type : 'string'	}
				, {name : 'REF_CODE5',		text: '관련5',		type : 'string'	}
				, {name : 'REF_CODE6',		text: '관련6',		type : 'string'	}
				, {name : 'REF_CODE7',		text: '관련7',		type : 'string'	}
				, {name : 'REF_CODE8',		text: '관련8',		type : 'string'	}
				, {name : 'REF_CODE9',		text: '관련9',		type : 'string'	}
				, {name : 'REF_CODE10',		text: '관련10',		type : 'string'	} 
				, {name : 'USE_YN',			text: '사용여부',	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
				, {name : 'S_COMP_CODE',	text: '관련10',		type : 'string', 	defaultValue: UserInfo.compCode	} 
			]
		});
		var grid;
     	var inStore = Ext.create('Unilite.com.data.UniStore', {
			model: 'systemCodeModel',
	        autoLoad: false,
	        uniOpt : {
	        	isMaster: true,			// 상위 버튼 연결 
	        	editable: true,			// 수정 모드 사용 
	        	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
	        },
	        
	        proxy: {
	            type: 'direct',
	            api: {
	            	   read :  bsa100ukrvService.selectDetailCodeList,
	            	   update: bsa100ukrvService.updateCodes,
					   create: bsa100ukrvService.insertCodes,
					   destroy:bsa100ukrvService.deleteCodes,
					   syncAll:bsa100ukrvService.syncAll
	            }
	        },
	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
//			load: function() {
//				// {params:{'MAIN_CODE':mainCode}}
//				console.log('load');
//			}
		});
		
		grid= Unilite.createGrid('', {
			title:codeName,
			subCode: subCode,
			autoScroll:true,
			flex:1,
			dockedItems: [{
		        xtype: 'toolbar',
		        dock: 'top',
		        padding:'0px',
		        border:0
		    }],
			bodyCls: 'human-panel-form-background',
	        padding: '0 0 0 0',
		    store : inStore,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{	dataIndex : 'MAIN_CODE',		width : 100, 	hidden : true}
					, {	dataIndex : 'SUB_CODE',			width : 100	}
					, {	dataIndex : 'CODE_NAME',		flex: 1	}
					, {	dataIndex : 'SYSTEM_CODE_YN',	width : 100	}
					, {	dataIndex : 'SORT_SEQ',			width : 100,		hidden : true	}
					, {	dataIndex : 'REF_CODE1',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE2',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE3',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE4',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE5',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE6',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE7',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE8',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE9',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE10',		width : 110,	hidden : true	}  
					, {	dataIndex : 'USE_YN',			width : 100	}  
			]
			 ,getSubCode: function()	{
				return this.subCode;
			}
		});
	return grid;
	
 	}
});
/**************************************************
 * Common variable
 **************************************************/
var winWidth = 400;
var winHeight = 400;

var propertyWin = null;
var menuUserWin = null;

var NBOX_C_NEWMENU_TITLE = '새 메뉴';
var NBOX_C_MENU_NEW = 'NEW';
var NBOX_C_MENU_UPDATE = 'UPDATE';
var NBOX_C_MENU_RENAME = 'RENAME';
var NBOX_C_MENU_DELETE = 'DELETE';


/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareMenuPanelModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'PGM_ID'}, 
    	{name: 'PGM_NAME'}
    ]
});

Ext.define('nbox.main.groupwareMenuModel', {
	extend:'Ext.data.Model',
    fields: [ 	{name: 'id'}
    			,{name: 'compcode'}
             	,{name: 'prgID'}
    			,{name: 'text'}
    			,{name: 'text_en'}
    			,{name: 'text_cn'}
    			,{name: 'text_jp'}
    			,{name: 'url'}
    			,{name: 'viewYN'}
    			,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
    			,{name: 'index'}
    			,{name: 'box'}
    			,{name: 'pgm_div'}
    			,{name: 'type'}
    			,{name: 'moduleid'}
    			,{name: 'cmenuflag'}
    			,{name: 'tablegubun'}
		]
});

Ext.define('nbox.main.groupwareMenuPropertyModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'COMP_CODE'}, 
    	{name: 'PGM_SEQ'}, 
    	{name: 'PGM_ID'}, 
    	{name: 'PGM_TYPE'}, 
    	{name: 'PGM_LEVEL'}, 
    	{name: 'UP_PGM_DIV'}, 
    	{name: 'PGM_ARNG_SEQ'}, 
    	{name: 'PGM_NAME'}, 
    	{name: 'LOCATION'}, 
    	{name: 'TYPE'},
    	{name: 'USE_YN'},
    	{name: 'AUTHO_TYPE'},
    	{name: 'AUTHO_PGM'},
    	{name: 'REMARK'},
    	{name: 'URL_DISPLAY'},
    	{name: 'URL'},
    	{name: 'NBOX_URL'},
    	{name: 'NBOX_BOX'},
    	{name: 'PERSONALFLAG'},
    	{name: 'INSERT_DB_USER'},
    	{name: 'INSERT_DB_TIME'},
    	{name: 'UPDATE_DB_USER'},
    	{name: 'UPDATE_DB_TIME'}
    ]
});		


Ext.define('nbox.main.groupwareMenuUserModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ID'},
    	{name: 'COMP_CODE'},
    	{name: 'USER_ID'},
    	{name: 'USER_NAME'},
    	{name: 'DEPT_CODE'},
    	{name: 'DEPT_NAME'},
    	{name: 'POST_CODE'},
    	{name: 'POST_NAME'},
    	{name: 'ABIL_CODE'},
    	{name: 'ABIL_NAME'},
    	{name: 'PGM_ID'},
    	{name: 'PGM_LEVEL'},
    	{name: 'UPDATE_MAN'},
    	{name: 'UPDATE_DATE'},
    	{name: 'PGM_LEVEL2'},
    	{name: 'AUTHO_USER'}
    ]
});		


/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareMenuPanelStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareMenuPanelModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareMenuService.selectGroupMenu' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareMenuAllTreeStore',{
	extend  : 'Ext.data.TreeStore',
	model   : 'nbox.main.groupwareMenuModel',
    autoLoad: true,
    proxy   : {
    			type: 'direct',
    			api : {
    					read : 'groupwareMenuService.selectMenuAll'
    				  }
    }
});

Ext.define('nbox.main.groupwareMenuTreeStore',{
	extend  : 'Ext.data.TreeStore',
	model   : 'nbox.main.groupwareMenuModel',
    autoLoad: true,
    proxy   : {
    			type : 'direct',
    			api  : {
    						read   : 'groupwareMenuService.selectMenu',
    						update : 'groupwareMenuService.saveMenu',
    						destroy: 'groupwareMenuService.deleteMenu'
    				   }
    }
});

Ext.define('nbox.main.groupwareMenuPropertyStore', {
	extend  : 'Ext.data.Store',
	model   : 'nbox.main.groupwareMenuPropertyModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
          	   	api   : {
          	   				read: 'groupwareMenuService.selectMenuProperty' 
          	   			},
          	   	reader: {
          	   				type: 'json',
          	   				root: 'records'
          	   			}
          	   }
});

Ext.define('nbox.main.groupwareMenuUserStore', {
	extend  : 'Ext.data.Store',
	model   : 'nbox.main.groupwareMenuUserModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
          	   	api   : {
          	   				read: 'groupwareMenuService.selectMenuUser' 
          	   			},
          	   	reader: {
          	   				type: 'json',
          	   				root: 'records'
          	   			}
          	   }
});

//Combobox
Ext.define('nbox.main.groupwareMenuTypeStore', {
  extend  : 'Ext.data.Store', 
  fields  : ["CODE", 'NAME'],
  autoLoad: true,
  proxy   : {
	  			type       : 'direct',
	  			extraParams: {
	  							'MAIN_CODE' : 'B009', 
	  							'SUB_CODE[]': ['2','9']
	  						 },
            	api        : {
            					read: 'groupwareMenuService.selectCommonCode' 
            				 },
            	reader     : {
            					type: 'json',
            					root: 'records'
            				 }
             }
});	


/**************************************************
 * Define
 **************************************************/
//Groupware ContextMenu
Ext.define('nbox.main.groupwareMenuContextMenu', {
	extend: 'Ext.menu.Menu',
	config: {
		regItems: {}
	},
	initComponent: function () {
    	var me = this;
		
    	me.items = [
    	    {
    	    	text   : '새로만들기',
    	    	itemId : 'newMenu',
    	    	handler: function(){
			    	me.getRegItems()['OpenContainer'].AddNewButtonDown();
			 	}
			},
		    {
				text   : '속성',
				itemId : 'propertyMenu',
				handler: function(){
			    	me.getRegItems()['OpenContainer'].PropertiesButtonDown();
			    }
			},
		    {
				text   : '이름바꾸기',
			    itemId : 'renameMenu',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].ReNameButtonDown();
			    }
			},
			{
			    text   : '삭제',
			    itemId : 'deleteMenu',
			    handler: function(){
			    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
				    function(btn) {
				        if (btn === 'yes') {
				        	me.getRegItems()['OpenContainer'].DeleteButtonDown();
				            return true;
				        } else {
				            return false;
				        }
			    	});
			    }
			}
		];
    	
        me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
				var element = btnItemIDs[i];
				me.setToolBar(element, flag);
			}
		} else {
			me.setToolBar(btnItemIDs, flag);
		}
    },
    setToolBar: function(btnItemID, flag){
    	var me = this;
    	
    	var obj =  me.getComponent(btnItemID);
		if(obj) {
			(flag) ? obj.enable(): obj.disable();
		}
    }
});


//Groupware ContextMenu
Ext.define('nbox.main.groupwareMenuMailContextMenu', {
	extend: 'Ext.menu.Menu',
	config: {
		regItems: {}
	},
	initComponent: function () {
    	var me = this;
		
    	me.items = [
    	    /*{
    	    	text   : '상세검색',
    	    	itemId : 'detailSearch',
    	    	handler: function(){
			    	me.getRegItems()['OpenContainer'].DetailSearchButtonDown();
			 	}
			},*/
		    /*{
				text   : '외부 POP3 가져오기',
				itemId : 'outsdiePop3',
				handler: function(){
			    	me.getRegItems()['OpenContainer'].OutsidePop3ButtonDown();
			    }
			},*/
    	    /*{
    	    	xtype: 'menuseparator'
			},*/
		    {
				text   : '새로만들기',
			    itemId : 'newMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].NewMailboxButtonDown();
			    }
			},
			{
			    text   : '새로고침',
			    itemId : 'refreshMailbox',
			    handler: function(){
			    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
				    function(btn) {
				        if (btn === 'yes') {
				        	me.getRegItems()['OpenContainer'].RefreshMailboxButtonDown();
				            return true;
				        } else {
				            return false;
				        }
			    	});
			    }
			}
		];
    	
        me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
				var element = btnItemIDs[i];
				me.setToolBar(element, flag);
			}
		} else {
			me.setToolBar(btnItemIDs, flag);
		}
    },
    setToolBar: function(btnItemID, flag){
    	var me = this;
    	
    	var obj =  me.getComponent(btnItemID);
		if(obj) {
			(flag) ? obj.enable(): obj.disable();
		}
    }
});

//Groupware Menu Property Popup Window General Tab
Ext.define('nbox.main.groupwareMenuGeneralPanel',  {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
	},
	border: false,
	padding: 5,
	api: { 
    	submit: 'groupwareMenuService.save' 
	},
    initComponent: function () {
    	var me = this;
    	
    	var groupwareMenuTypeStore = Ext.create('nbox.main.groupwareMenuTypeStore', {});
    	
		me.items = [
			{ 
				xtype        : 'textfield',
				name         : 'PGM_NAME',
				fieldLabel   : '메뉴명',
				anchor       : '100%',
				padding      : 5,
				labelAlign   : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank   : false
			},
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype        : 'combo', 
				name         : 'TYPE',
				fieldLabel   : '메뉴형식', 
				store        : groupwareMenuTypeStore, 
				displayField : 'NAME', 
				valueField   : 'CODE', 
				padding      : 1,
				labelAlign   : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank   : false
			}, 
			{
    	    	xtype     : 'textareafield',
		        name      : 'REMARK',
		        fieldLabel: '설명',
		        padding   : 1,
				labelAlign: 'right',
				rows      : 3,
				anchor: '100%'
    	    },
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'URL_DISPLAY',
				fieldLabel: 'URL',
				padding   : 1,
				labelAlign: 'right'
			},
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'INSERT_DB_TIME',
				fieldLabel: '만든날짜',
				padding   : 1,
				labelAlign: 'right'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'UPDATE_DB_TIME',
				fieldLabel: '수정한날짜',
				padding   : 1,
				labelAlign: 'right'
			},
			{
		        xtype: 'hiddenfield',
		        name: 'COMP_CODE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_SEQ'
		    },
		    {
		        xtype: 'hiddenfield',
		        name: 'PGM_ID'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_TYPE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_LEVEL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'UP_PGM_DIV'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_ARNG_SEQ'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_EN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_CN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_JP'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'LOCATION'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'USE_YN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'AUTHO_TYPE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'AUTHO_PGM'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'NBOX_URL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'URL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'NBOX_BOX'
		    }
		];
    	
		me.callParent(); 
    },
    queryData: function(){
    	var me = this;
		var store = me.getRegItems()['DataStore'];
		var targetReocrd = propertyWin.getRegItems()['TargetReocrd'];
		
		me.clearData();
		
		store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		store.proxy.setExtraParam('PGM_ID', targetReocrd.data.prgID);
		store.proxy.setExtraParam('ACTIONTYPE', propertyWin.getRegItems()['ActionType']);
		
		store.load({callback: function(record, options, success){
			if (success){
				switch(propertyWin.getRegItems()['ActionType']){
					case NBOX_C_MENU_NEW:
						record[0].set('PGM_NAME', NBOX_C_NEWMENU_TITLE);
						break;
					default:
						break;
				}
				me.loadData();
			}
		}});
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['DataStore'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    	
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuPermissionPanel = menuTabPanel.getRegItems()['MenuPermissionPanel'];
    	menuPermissionPanel.queryData();
    },
    saveData: function(){
    	
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['DataStore'];
    	
		//store.removeAll();
		frm.reset();
    }
});

//Groupware Menu Property Popup  Permission Tab Grid
Ext.define('nbox.main.groupwareMenuGrid01', {
	extend:	'Ext.grid.Panel',
	config:{
		regItems: {}
	},
    viewConfig:{
       loadMask:false
    },
    hideHeaders: true,
    sortableColumns: false, 
    multiSelect: true,
    padding: 5,
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            dataIndex: 'COMP_CODE',
	            width: 50,
	            hidden: true            
	        }, 
	        {
	            dataIndex: 'USER_ID',
	            width: 80
	        }, 
	        {
	            dataIndex: 'USER_NAME',
	            flex:1
	        }, 
	        {	
	            dataIndex: 'DEPT_CODE',
	            width: 50,
	            hidden: true  
	        }, 
	        {	
	            dataIndex: 'DEPT_NAME',
	            width: 100
	        },
	        {	
	            dataIndex: 'POST_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'POST_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'ABIL_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'ABIL_NAME',
	            width: 80,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_ID',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'PGM_LEVEL',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'UPDATE_MAN',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'UPDATE_DATE',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_LEVEL2',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'AUTHO_USER',
	            width: 50,
	            hidden: true
	        }	        
		];
    	
		me.callParent(); 
    },
    queryData: function(){
    	var me = this;
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'] 
    	var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
    	var menuPropertyReocrd = menuPropertyStore.getAt(0);
    	var store = me.getStore();
    	
    	me.clearData();
    	
    	if (menuPropertyReocrd){
	    	store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
	    	store.proxy.setExtraParam('PGM_ID', menuPropertyReocrd.data.PGM_ID);
	    	store.proxy.setExtraParam('PGM_LEVEL', menuPropertyReocrd.data.PGM_LEVEL);
	    	store.proxy.setExtraParam('UP_PGM_DIV', menuPropertyReocrd.data.UP_PGM_DIV);
	    	store.proxy.setExtraParam('ACTIONTYPE', propertyWin.getRegItems()['ActionType']);
	    	
	    	store.load({callback: function(record, options, success){
				if (success){
					me.loadData();
				}
			}});
    	}
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
		store.removeAll();
    }
});

//Groupware Menu Property Popup  Permission Tab User Add, Delete Button 
Ext.define('nbox.main.groupwareMenuButtonPanel', {
	extend:	'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	border: false,
	layout : {
	    type : 'hbox',
	    pack : 'end'
	},
	padding: 5,
    /* api: { submit: 'nboxBoardService.saveComment' }, */
    initComponent: function () {
    	var me = this;
    	
    	var addButton = Ext.create('Ext.button.Button', {
    		text: '추가',
			tooltip : '추가',
			id: 'nboxPAddButton',
			/*itemId : 'add',*/
			width:70,
			style: {
	            margin: '0px 5px 0px 0px'
	        },
			handler: function() {
				me.getRegItems()['ParentContainer'].AddButtonDown();		
			}
    	});
    	
    	var deleteButton = Ext.create('Ext.button.Button', {
    		text: '삭제',
			tooltip : '삭제',
			id: 'nboxPDeleteButton',
			/*itemId : 'delete',*/
			width:70,
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();		
			}
    	});
    	
    	me.items = [
    	            {
    	            	xtype: 'checkboxfield',
    	            	id: 'nboxInheritToChild',
    	            	boxLabel: '하위 메뉴에 상속',
    	            	flex: 1
    	            },    	            
    	            addButton, 
    	            deleteButton
    	           ];
    	
    	me.callParent(); 
    }
});

//Permission Panel
Ext.define('nbox.main.groupwareMenuPermissionPanel', {
	extend:	'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	border: false,
	padding: 5,
    initComponent: function () {
    	var me = this;
    	var menuGrid01 = Ext.create('nbox.main.groupwareMenuGrid01', {
    		store: groupwareGrid01Store,
    		height: 255
    	});
    	var menuButtonPanel = Ext.create('nbox.main.groupwareMenuButtonPanel', {
    		id: 'nboxMenuButtonPanel'
    	});
    	
    	me.getRegItems()['MenuGrid01'] = menuGrid01;
    	me.getRegItems()['MenuButtonPanel'] = menuButtonPanel;
    	menuGrid01.getRegItems()['ParentContainer'] = me;
    	menuButtonPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items = [
            {
            	xtype: 'label',
                text: '사용자 :'
            },
            menuGrid01,
            menuButtonPanel
    	];
    	
    	me.callParent(); 
    },
    listeners: {
    	render: function( obj, eOpts ){
    		var me = this;
    		var nboxPAddButton = me.getComponent('nboxMenuButtonPanel').getComponent('nboxPAddButton');
    		var nboxPDeleteButton = me.getComponent('nboxMenuButtonPanel').getComponent('nboxPDeleteButton');
    		var nboxInheritToChild = me.getComponent('nboxMenuButtonPanel').getComponent('nboxInheritToChild');
    		var menuTabPanel = me.getRegItems()['ParentContainer'];
    		var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'];
    		var store = menuGeneralPanel.getRegItems()['DataStore'];
    		var personalFlag = store.getAt(0).get("PERSONALFLAG");
   		
    		if (personalFlag == 'Y'){
	    		nboxPAddButton.setDisabled(true);
	    		nboxPDeleteButton.setDisabled(true);
	    		nboxInheritToChild.setDisabled(true);
    		}
    	}
	},
	queryData: function(){
    	var me = this;
    	var menuGrid01 = me.getRegItems()['MenuGrid01'];
		
    	menuGrid01.queryData();
		
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	
    },
    AddButtonDown: function(){
    	var me = this;
    	openMenuUserWin(me, propertyWin.getRegItems()['TargetReocrd'], propertyWin.getRegItems()['ActionType']);
    },
    DeleteButtonDown: function(){
    	var me = this;
    	var menuGrid01 = me.getRegItems()['MenuGrid01'];
    	var store = menuGrid01.getStore();
		var selection = menuGrid01.getView().getSelectionModel().getSelection();
		if (selection) {
			store.remove(selection);
		}
    }
});

//Tab Panel
Ext.define('nbox.main.groupwareMenuTabPanel', {
	extend:'Ext.tab.Panel',
	config: {
		regItems: {}
	},
    padding: 5,
	initComponent: function () {
    	var me = this;
    	var menuGeneralPanel = Ext.create('nbox.main.groupwareMenuGeneralPanel', {});
    	var menuPermissionPanel = Ext.create('nbox.main.groupwareMenuPermissionPanel', {});
    	
    	me.getRegItems()['MenuGeneralPanel'] = menuGeneralPanel;
    	menuGeneralPanel.getRegItems()['ParentContainer'] = me;
    	menuGeneralPanel.getRegItems()['DataStore'] = groupwareMenuPropertyStore;
    	
    	me.getRegItems()['MenuPermissionPanel'] = menuPermissionPanel;
    	menuPermissionPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items = [{
            title: '일반',
            items: menuGeneralPanel
        }, {
            title: '보안',
            items: menuPermissionPanel
        }];
    	
        me.callParent(); 
    },
    queryData: function(){
    	var me = this;
    	var menuGeneralPanel = me.getRegItems()['MenuGeneralPanel']
    	
    	menuGeneralPanel.queryData();
    }
});

//Groupware Menu Property Popup 
Ext.define('nbox.main.groupwareMenuPropertyToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	config: {
		regItems: {}
	},
	dock : 'bottom',
	flex: 1,
	padding: 3,
	initComponent: function () {
    	var me = this;
    	
        var btnSave = {
			xtype: 'button',
			text: '확인',
			tooltip : '확인',
			itemId : 'saveProperty',
			width: 70,
			style: {
	            margin: '0px 5px 0px 0px'
	        },
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnCancel = {
			xtype: 'button',
			text: '취소',
			tooltip : '취소',
			itemId : 'cancelProperty',
			width: 70,
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();					
			}
        };
        	    	
		me.items = [ '->',btnSave, btnCancel];
		
    	me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
				var element = btnItemIDs[i];
				me.setToolBar(element, flag);
			}
		} else {
			me.setToolBar(btnItemIDs, flag);
		}
    },
    setToolBar: function(btnItemID, flag){
    	var me = this;
    	
    	var obj =  me.getComponent(btnItemID);
		if(obj) {
			(flag) ? obj.enable(): obj.disable();
		}
    }
});

Ext.define('nbox.main.groupwareMenuPropertyWindow',{
	extend: 'Ext.window.Window',
    width: winWidth,
    height: winHeight,
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    layout: {
        type: 'fit'
    },
    config: {
    	regItems: {}   	
    },
    initComponent: function () {
    	var me = this;
    	var menuPropertyToolbar = Ext.create('nbox.main.groupwareMenuPropertyToolbar', {});
    	var menuTabPanel = Ext.create('nbox.main.groupwareMenuTabPanel', {});
    	
    	me.getRegItems()['MenuPropertyToolbar'] = menuPropertyToolbar;
    	menuPropertyToolbar.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MenuTabPanel'] = menuTabPanel;
    	menuTabPanel.getRegItems()['ParentContainer'] = me;
    	
		me.items = [menuTabPanel];
    	me.dockedItems = [menuPropertyToolbar];
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> PropertyWindow');
			var menuTabPanel = me.getRegItems()['MenuTabPanel'];
			menuTabPanel.queryData();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> PropertyWindow');
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> PropertyWindow');
    		propertyWin = null;
    	},
    },
    SaveButtonDown: function(){
		var me = this;
		var menuTabPanel = me.getRegItems()['MenuTabPanel'];
		var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel']
		var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
		var menuPermissionPanel = menuTabPanel.getRegItems()['MenuPermissionPanel'];
		var menuGrid01 = menuPermissionPanel.getRegItems()['MenuGrid01'];
		var menuGrid01Store = menuGrid01.getStore();
		var param = me.getStoretoCUDJSON(menuGrid01Store);
		var menuTreePanel = me.getRegItems()['OpenContainer'];
		
		menuGeneralPanel.submit({
			params : {"DELETE": param.DELETE, "CREATE": param.CREATE, "UPDATE": param.UPDATE,
				'ACTIONTYPE': me.getRegItems()['ActionType'],
				'INHERITTOCHILD':menuPermissionPanel.getComponent('nboxMenuButtonPanel').getComponent('nboxInheritToChild').getValue()},
			success: function(obj, action) {
				switch (propertyWin.getRegItems()['ActionType']){
		    		case NBOX_C_MENU_NEW:
		    			var newNode = {id: null
	           				, prgID: action.result.PGM_ID
	           				, text: action.result.PGM_NAME
	           				, text_en: null
	           				, text_cn: null
	           				, text_jp: null
	           				, url: menuPropertyStore.getAt(0).get("URL")
	           				, viewYN: menuPropertyStore.getAt(0).get("USE_YN")
	           				, qtip: null
	           				, index: null
	           				, box: menuPropertyStore.getAt(0).get("NBOX_BOX")
	           				, pgm_div: menuPropertyStore.getAt(0).get("UP_PGM_DIV")
	           				, type: action.result.TYPE
	           				, cmenuflag: 'Y'
	           				, tablegubun: 'TBMENU'
	           				, leaf: (action.result.TYPE == 9 ? false : true)
	           				, expanded: true}
						
						menuTreePanel.appendChildNode(newNode);
						break;
		    		
		    		case NBOX_C_MENU_UPDATE:
		    			var selModel = menuTreePanel.getSelectionModel();
		    	        var selectedNode = selModel.getLastSelected();
		    	        selectedNode.set("text", action.result.PGM_NAME);
		    	        selectedNode.set("type", action.result.TYPE);
		    	        selectedNode.set("leaf", action.result.TYPE == 9 ? false : true);
		    	        selectedNode.commit();
		    			break
		    			
		    		default:
		    			break;
				}
				
				me.closeData();
			}
		});	
    },
    CancelButtonDown: function(){
		var me = this;
	    me.closeData();
    },
    saveData: function(){
		var me = this;
    },
    closeData: function(){
		var me = this;
	    me.close();
    },
    JSONtoString: function (object) {
        var results = [];
        
        for (var property in object) {
            var value = object[property];
            if (value)
                results.push("\"" + property.toString() + "\": \"" + value + "\"");
            }
                     
        return "{" + results.join(String.fromCharCode(11)) + "}";
    },
    getStoretoCUDJSON: function(store){
    	var me = this;
    	var resultJSON = {};
    	
    	if (!store) return null;
    	switch (propertyWin.getRegItems()['ActionType']){
    		case NBOX_C_MENU_NEW:
    			resultJSON["CREATE"] = me.getModeltoArray(store.data.items);
    			break;
    			
    		default:
    			resultJSON["CREATE"] = me.getModeltoArray(store.getNewRecords());
    			break
    	}
    	
    	resultJSON["UPDATE"] = me.getModeltoArray(store.getUpdatedRecords());
    	resultJSON["DELETE"] = me.getModeltoArray(store.getRemovedRecords());
    	
    	return resultJSON;
    },
    getModeltoArray: function(model){
    	var me = this;
    	var resultArr = [];
    	
    	if (!model) return null;
    	
    	Ext.each(model, function(record){
    		resultArr.push(me.JSONtoString(record.data));
		});
    	
    	if (resultArr.length == 0) resultArr = null;
    	
    	return resultArr;
    }
});

//Groupware Menu User Permissions Popup
Ext.define('nbox.main.groupwareMenuUserToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	config: {
		regItems: {}
	},
	dock : 'top',
	height: 30, 
	padding: '0 0 0 5px',
	
	initComponent: function () {
    	var me = this;
    	var btnWidth = 26;
    	var btnHeight = 26;
    	
    	var btnQuery = {
				xtype: 'button',
				text: '조회',
				tooltip : '조회',
				itemId : 'query',
				handler: function() { 
					me.getRegItems()['ParentContainer'].QueryButtonDown();
				}
	        };
	        
        var btnConfirm = {
			xtype: 'button',
			text: '확인',
			tooltip : '확인',
			itemId : 'confirm',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmButtonDown();		
			}
        };
	
        var btnClose = {
				xtype: 'button',
				text: '닫기',
				tooltip : '닫기',
				itemId : 'close',
				handler: function() {
					me.getRegItems()['ParentContainer'].CloseButtonDown();		
				}
	        };
        
	    var toolbarItems = [ btnQuery, btnConfirm, btnClose ];    
	        
        /*var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
		if( chk01 ) {
			toolbarItems.push( // space
				'->',
				{	
					//xtype: 'menu',
					text: 'Grid',
					iconCls: 'menu-menuShow',
					menu: {
						xtype: 'menu',
						items:[
							{
	                            text: 'Sheet 환경 저장', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
						        	UniAppManager.saveGridState();							          
						        }
					        },
	                        {
	                        	text: 'Sheet 환경 기본값 설정', 
	                        	iconCls: 'icon-sheetResetState',
	                            handler: function(widget, event) {
						        	UniAppManager.resetGridState();
						          
						        }
							}
						]
					}
				}
			);
		}*/
        	    	
		me.items = toolbarItems;
		
    	me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
				var element = btnItemIDs[i];
				me.setToolBar(element, flag);
			}
		} else {
			me.setToolBar(btnItemIDs, flag);
		}
    },
    setToolBar: function(btnItemID, flag){
    	var me = this;
    	
    	var obj =  me.getComponent(btnItemID);
		if(obj) {
			(flag) ? obj.enable(): obj.disable();
		}
    }
});

Ext.define('nbox.main.groupwareMenuGrid02', {
	extend:	'Ext.grid.Panel',
	config:{
		regItems: {}
	},
    viewConfig:{
       loadMask:false
    },
    hideHeaders: true,
    sortableColumns: false, 
    multiSelect: true,
    padding: 5,
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            dataIndex: 'COMP_CODE',
	            width: 50,
	            hidden: true            
	        }, 
	        {
	            dataIndex: 'USER_ID',
	            width: 80
	        }, 
	        {
	            dataIndex: 'USER_NAME',
	            flex:1
	        }, 
	        {	
	            dataIndex: 'DEPT_CODE',
	            width: 50,
	            hidden: true  
	        }, 
	        {	
	            dataIndex: 'DEPT_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'POST_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'POST_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'ABIL_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'ABIL_NAME',
	            width: 80,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_ID',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'PGM_LEVEL',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'UPDATE_MAN',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'UPDATE_DATE',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_LEVEL2',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'AUTHO_USER',
	            width: 50,
	            hidden: true
	        }	
		];
    	
		me.callParent(); 
    },
    listeners: {
    	itemdblclick: function( obj, record, item, index, e, eOpts ){
    		var me = this;
    		console.log(me.id + ' itemdblclick -> MenuGrid02');
			var menuUserWindow = me.getRegItems()['ParentContainer'];
			menuUserWindow.ConfirmButtonDown();
    	}
    },
    queryData: function(){
    	var me = this;
    	var store = me.getStore();
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'] 
    	var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
    	var targetReocrd = menuUserWin.getRegItems()['TargetReocrd'];
    	var menuPropertyReocrd = menuPropertyStore.getAt(0);
    	
    	if (menuPropertyReocrd){
    		store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
    		store.proxy.setExtraParam('PGM_ID', menuPropertyReocrd.data.PGM_ID);
    		store.proxy.setExtraParam('UP_PGM_DIV', menuPropertyReocrd.data.UP_PGM_DIV);
	    	store.proxy.setExtraParam('PGM_LEVEL', menuPropertyReocrd.data.PGM_LEVEL);
	    	store.proxy.setExtraParam('ACTIONTYPE', null);
	    	
	    	store.load({callback: function(record, options, success){
				if (success){
					me.loadData();
				}
			}});
    	}
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
		store.removeAll();
    }
});

Ext.define('nbox.main.groupwareMenuUserWindow',{
	extend: 'Ext.window.Window',
    width: winWidth,
    height: winHeight,
    /* maximizable: true, */
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    layout: {
        type: 'fit'
    },
    config: {
    	regItems: {}   	
    },
    initComponent: function () {
    	var me = this;
    	var menuUserToolbar = Ext.create('nbox.main.groupwareMenuUserToolbar', {});
    	var menuGrid02 = Ext.create('nbox.main.groupwareMenuGrid02', {
    		store: groupwareGrid02Store,
    		height: 250
    	});
    	
    	me.getRegItems()['MenuGrid02'] = menuGrid02;
    	me.getRegItems()['MenuUserToolbar'] = menuUserToolbar;
    	menuGrid02.getRegItems()['ParentContainer'] = me;
    	menuUserToolbar.getRegItems()['ParentContainer'] = me;
    	
		me.items = [menuGrid02];
    	me.dockedItems = [menuUserToolbar];
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> MenuUserWindow');
			var menuGrid02 = me.getRegItems()['MenuGrid02'];
			menuGrid02.queryData();			
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> MenuUserWindow');
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> MenuUserWindow');
    		menuUserWin = null;
    	},
    },
    QueryButtonDown: function(){
    	var me = this;
    	var menuGrid02 = me.getRegItems()['MenuGrid02'];
		menuGrid02.queryData();	
    },
    ConfirmButtonDown: function(){
    	var me = this;
    	var openContainer = me.getRegItems()['OpenContainer'];
    	var menuGrid01 = openContainer.getRegItems()['MenuGrid01'];
    	var menuGrid02 = me.getRegItems()['MenuGrid02'];
    	var selections = menuGrid02.getSelectionModel().getSelection();
    	
    	if (selections.length > 0){
	    	for(var i = selections.length; i > 0; i --){
	    		if (menuGrid01.getStore().findRecord('USER_ID', selections[i - 1].get('USER_ID')) == null){
	    			/*menuGrid01.getStore().add(selections[i - 1]);*/
	    			menuGrid01.getStore().insert(menuGrid01.getStore().getCount(),  selections[i - 1].data);
	    		}
	    	}
	    }
    	
    	me.closeData();
    },
    CloseButtonDown: function(){
    	var me = this;
	    me.closeData();
    },
    closeData: function(){
		var me = this;
	    me.close();
    }
});

//Groupware Menu Panel & Sub Tree Panel
Ext.define("nbox.main.groupwareMenuTreePanel",{
	extend: 'Ext.tree.Panel',
	config: {
		regItems: {}
	}, 
	cls: "doc-tree iScroll",
	animCollapse: true,
	animate: true,
	rootVisible: false,
	border: false,
	bodyBorder: false,

	margins: '0 0 0 0',
	rowLines: false, lines: false,
	scroll: 'vertical',
	hideHeaders: true,
   
	initComponent: function () {
    	var me = this;
    	var menuContextMenu = Ext.create('nbox.main.groupwareMenuContextMenu', {});
    	var menuMailContextMenu = Ext.create('nbox.main.groupwareMenuMailContextMenu', {});
    	
    	var editor = Ext.create('Ext.Editor', {
    		hideEl: false,
    	    field: {
    	        xtype: 'textfield',
    	        flex: 1
    	    }
    	});
    	
    	me.plugins = [
    	           Ext.create('Ext.grid.plugin.CellEditing', {
    	           	clicksToEdit: 2,
    	           	listeners: {
    	           		beforeedit: function( editor, e, eOpts ){
    	           			if (e.record.get('cmenuflag') != 'Y' || e.record.get('tablegubun') != 'TBMENU')
    	           				return false;
    	           		},
    	           		edit: function( editor, e, eOpts ){
    	           			e.grid.store.sync();
    	           		}
    	           	}
    	           })
    	       ];
    	me.columns= [{
    	            xtype: 'treecolumn',
    	            dataIndex: 'text',
    	            flex: 1,
    	            editor: {
    	                xtype: 'textfield',
    	                allowBlank: false,
    	                allowOnlyWhitespace: false
    	            }
    	        }];
    	
    	me.getRegItems()['MenuContextMenu'] = menuContextMenu;
    	me.getRegItems()['MenuMailContextMenu'] = menuMailContextMenu;
    	/*menuContextMenu.getRegItems()['ParentContainer'] = me;*/
    	me.getRegItems()['Editor'] = editor;
    	
    	me.callParent(); 
    },
	listeners: {
	  	itemclick: function(t, record, item, index, e, eOpts ) {
	  		
	  		if ( record.data.url !== "" &&  record.data.type != '9')  {
	  			var url = record.data.url ; 
		  		var params = {
		  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
				};
		  		
		  		if (typeof url !== "undefined" )
			  		openTab(record, url, params);
		  		
	  	    } else {
	  	      if (!record.isLeaf()) {
	  	        if (record.isExpanded()) {
	  	        	record.collapse(false)
	  	        } else {
	  	        	record.expand(false)
	  	        }
	  	      }
	  	    }
		},
		itemcontextmenu: function( obj, record, item, index, e, eOpts ){
			var me = this;
			var menuContextMenu = me.getRegItems()['MenuContextMenu'];
			
			if (record.data.cmenuflag == 'Y'){
				me.setToolBars(record.data.type, record.data.tablegubun);
				
				menuContextMenu.getRegItems()['OpenContainer'] = me;
				menuContextMenu.getRegItems()['TargetItem'] = item;
				menuContextMenu.getRegItems()['TargetRecord'] = record;
				menuContextMenu.showAt(e.getXY());
		        /*e.stopEvent();*/
				e.preventDefault();
			}
		},
    	beforeitemappend: function( obj, node, eOpts ){
    		if (node.get("type") == "9" && node.isLeaf()) node.set("leaf", false);
    	}
	},
	AddNewButtonDown: function(){
    	var me = this;
    	var menuContextMenu = me.getRegItems()['MenuContextMenu'];
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();

        if (!selectedNode) return;
        
        openPropertyWin(me, menuContextMenu.getRegItems()['TargetRecord'], NBOX_C_MENU_NEW);
    },
    PropertiesButtonDown: function(){
    	var me = this;
    	var menuContextMenu = me.getRegItems()['MenuContextMenu'];
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();

        if (!selectedNode) return;
        
        openPropertyWin(me, menuContextMenu.getRegItems()['TargetRecord'], NBOX_C_MENU_UPDATE);
    },
    ReNameButtonDown: function(){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        
        if (!selectedNode) return;
        me.plugins[0].startEdit(me.getSelectionModel().getLastSelected(), 0)
    },
    DeleteButtonDown: function(){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        var store = me.getStore();

        if(!selectedNode) return;

        if (selectedNode.hasChildNodes()){
        	for(var indx = selectedNode.childNodes.length -1; indx >= 0; indx --){
        		me.getView().getRecord(selectedNode.childNodes[indx]).remove();
        	}
        }
        me.getView().getRecord(selectedNode).remove(); 
        store.sync();
        me.getView().refresh();
    },
    appendChildNode: function(model){
    	var me = this;
    	var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        
        selectedNode.appendChild(model);
        me.getView().refresh();
        selectedNode.expand();
    },
    setToolBars: function(menuType, menuTablegubun){
    	var me = this;
    	var menuContextMenu = me.getRegItems()['MenuContextMenu'];
    	var enableMenu = [];
    	var disableMenu = [];
    	var menuToolbar = {'newMenu': true, 'propertyMenu': true, 'renameMenu': true, 'deleteMenu': true};
    	
    	switch(menuTablegubun){
	    	case 'TBMENU':
	    		break;
	    	
	    	case 'BSA400T':
	    		menuToolbar['propertyMenu'] = false;
	    		menuToolbar['renameMenu'] = false;
	    		menuToolbar['deleteMenu'] = false;
	    		break;
	    		
	    	default:
	    		break;
    	}
    	
    	switch(menuType){
    		case '9':
    			break;
    			
    		default:
    			menuToolbar['newMenu'] = false;
				break;
    	}
    	
    	for(var key in menuToolbar){
    		if (menuToolbar[key] == true){
    			enableMenu.push(key);
    		} else {
    			disableMenu.push(key)
    		}
    	}
    		
    	if (enableMenu.length > 0) menuContextMenu.setToolBars(enableMenu, true);
    	if (disableMenu.length > 0) menuContextMenu.setToolBars(disableMenu, false);
    }
});

Ext.define('nbox.main.groupwareMenuPanel', {
	extend: 'Ext.panel.Panel', 
	itemId: 'leftGroupWareMenu',
	hidden: true,
	layout: {
        type: 'accordion',
        titleCollapse: true,
        animate: false
    },
    initComponent: function () {
		var me = this;
		
		groupwareMenuPanelStore.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		groupwareMenuPanelStore.load({callback: function(record, options, success){
			if (success){
		    	var rec = record;
		    	groupwareMenuPanelStore.each(function(rec){
		    		var groupwareMenuTreeStore = null;
		    		
					groupwareMenuTreeStore = Ext.create('nbox.main.groupwareMenuTreeStore',{
						storeId: 'nboxStore' + rec.get('PGM_ID')
					});
		    		
		    		groupwareMenuTreeStore.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		    		groupwareMenuTreeStore.proxy.setExtraParam('GROUPID', rec.get('PGM_ID'));
		    		groupwareMenuTreeStore.proxy.setExtraParam('PGM_ID', rec.get('PGM_ID'));
		    		
		    		groupwareMenuTreeStore.load({callback: function(record, options, success){
		    			if (success){
		    				/*me.setLeafByMenuType(record);*/
		    			}
		    		}});
		    		
		    		var groupwareMenuTreePanel = Ext.create("nbox.main.groupwareMenuTreePanel",{
		    			id: 'nboxTree' + rec.get('PGM_ID'),
			        	store: groupwareMenuTreeStore  	
			        });
		    		
		    		me.add({
	                    title: rec.get('PGM_NAME'),
	                    id: rec.get('PGM_ID'),
	                    layout:'fit',
	                    border: false,
	                    items: [groupwareMenuTreePanel]
	                });
				});
			}
	    }});
		
		me.callParent();
	},
	setLeafByMenuType: function(record){
		var me = this;
		
		for(var indx = 0; indx < record.length; indx++){
			if (record[indx].childNodes.length > 0)
				me.setLeafByMenuType(record[indx].childNodes);
			
			if (record[indx].get('type') == '9')
				record[indx].set('leaf', false);
		}
	}
});

/**************************************************
 * Create
 **************************************************/
var groupwareMenuPanelStore = Ext.create('nbox.main.groupwareMenuPanelStore', {});
var groupwareMenuPropertyStore = Ext.create('nbox.main.groupwareMenuPropertyStore', {});
var groupwareGrid01Store = Ext.create('nbox.main.groupwareMenuUserStore', {});
var groupwareGrid02Store = Ext.create('nbox.main.groupwareMenuUserStore', {});


/**************************************************
 * User Define Function
 **************************************************/
function openPropertyWin(obj, record, actionType){
	var winTitle = '';
	
	switch (actionType)
	{
		case NBOX_C_MENU_NEW:
			winTitle = NBOX_C_NEWMENU_TITLE;
			break;
		
		default:
			winTitle = record.data.text;
			break;
	}
	
	if(!propertyWin){
		propertyWin = Ext.create('nbox.main.groupwareMenuPropertyWindow', {
			title: winTitle + ' 속성'
		}); 
	}
	
	propertyWin.getRegItems()['OpenContainer'] = obj;
	propertyWin.getRegItems()['TargetReocrd'] = record;
	propertyWin.getRegItems()['ActionType'] = actionType;
	propertyWin.show();
}

function openMenuUserWin(obj, record, actionType){
	
	if(!menuUserWin){
		menuUserWin = Ext.create('nbox.main.groupwareMenuUserWindow', {
			title: '사용자' + ' - 속성',
			x: propertyWin.getX() + 30, 
			y: propertyWin.getY() - 30 
		}); 
	}
	
	menuUserWin.getRegItems()['OpenContainer'] = obj;
	menuUserWin.getRegItems()['TargetReocrd'] = record;
	menuUserWin.getRegItems()['ActionType'] = actionType;
 	/*propertyWin.getRegItems()['SEQ'] = SEQ;*/		
 	menuUserWin.show();
}
