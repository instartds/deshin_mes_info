//@charset UTF-8
/**
 * 
 */
Ext.define('Unilite.com.form.field.UniLookupBox', {
    extend: 'Ext.form.field.ComboBox',
    requires: ['Unilite.com.view.UniBoundList'],
    alias: 'widget.uniLookupbox',
	typeAhead : true,
	hideLabel : false,
	hideTrigger : true,
	selectOnFocus: true,
	anchor : '70%',
	hideTrigger: false,

    defaultListConfig: {
    //listConfig: {
        loadingHeight: 70,
        minWidth: 70,
        maxHeight: 300,
        shadow: 'sides',
		loadingText : '조회중...',
		emptyText : '조회된 결과가 없습니다.',
		getInnerTpl : function() {
			var me = this;
			
			return '{' + me.valueField + '} : {' + me.displayField +'}';
		}
    },	
	pageSize : 10,
	minChars : 1,
	
	fieldSubTpl: [
        '<div  role="presentation"></div>',
        '<table cellspacing="0" cellpadding="0" style="width: 100%; table-layout: fixed;"><tbody><tr>',
        '<td width="100"><input type="text" name="{valueField}" class="{fieldCls} {typeCls} {editableCls}"  style="width: 100%;" readonly="true" /></td>',
        '<td><input id="{id}" type="{type}" {inputAttrTpl} class="{fieldCls} {typeCls} {editableCls}" autocomplete="off"',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="name"> name="{displayField}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '<tpl if="size"> size="{size}"</tpl>',
            '<tpl if="maxLength !== undefined"> maxlength="{maxLength}"</tpl>',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx"> tabIndex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
            '/></td>',
        '</tr></tbody></table>',
        {
            compiled: true,
            disableFormats: true
        }
    ],
    
    createPicker: function() {
        var me = this,
            picker,
            pickerCfg = Ext.apply({
                xtype: 'uniBoundlist',
                pickerField: me,
                selModel: {
                    mode: me.multiSelect ? 'SIMPLE' : 'SINGLE'
                },
                floating: true,
                hidden: true,
                store: me.store,
                displayField: me.displayField,
                valueField: me.valueField,
                focusOnToFront: false,
                pageSize: me.pageSize,
                tpl: me.tpl
            }, me.listConfig, me.defaultListConfig);

        picker = me.picker = Ext.widget(pickerCfg);
        if (me.pageSize) {
            picker.pagingToolbar.on('beforechange', me.onPageChange, me);
        }

        me.mon(picker, {
            itemclick: me.onItemClick,
            refresh: me.onListRefresh,
            scope: me
        });

        me.mon(picker.getSelectionModel(), {
            beforeselect: me.onBeforeSelect,
            beforedeselect: me.onBeforeDeselect,
            selectionchange: me.onListSelectionChange,
            scope: me
        });

        return picker;
    },    
    setHiddenValue : function(values){
    	console.log(values);
       var me = this,
            name = me.valueField, 
            i, input, valueCount ;
       var dom, childNodes, childrenCount;
            
        //if (!me.hiddenDataEl || !name) {
        //    return;
        //}
        //var cellField = form.findField('cell_phone');
        values = Ext.Array.from(values);
        //dom = me.hiddenDataEl.dom;
        //childNodes = dom.childNodes;
        //input = childNodes[0];
        valueCount = values.length;
        //childrenCount = childNodes.length;
        
        //if (!input && valueCount > 0) {
        //    me.hiddenDataEl.update(Ext.DomHelper.markup({
        //        tag: 'input', 
        //        type: 'text', 
        //        name: name
        //    }));
        //    childrenCount = 1;
        //    input = dom.firstChild;
        //}
        //while (childrenCount > valueCount) {
        //    dom.removeChild(childNodes[0]);
        //    -- childrenCount;
        //}
        //while (childrenCount < valueCount) {
        //    dom.appendChild(input.cloneNode(true));
        //    ++ childrenCount;
        //}
        for (i = 0; i < valueCount; i++) {
            childNodes[i].value = values[i];
        }
    	
    }
   
});