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
       	'<td class="x-form-item-body  " width="100%">',
       	/*'<input id="{id}" type="{type}" {inputAttrTpl}',
            ' size="1"', // allows inputs to fully respect CSS widths across all browsers
            '<tpl if="name"> name="{name}"</tpl>',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '{%if (values.maxLength !== undefined){%} maxlength="{maxLength}"{%}%}',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx"> tabIndex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
        ' class="{fieldCls} {typeCls} {editableCls} {inputCls}" autocomplete="off"/>',*/
       	'<input id="{id}" data-ref="inputEl" type="{type}" role="{role}" {inputAttrTpl}',
            ' size="1"', // allows inputs to fully respect CSS widths across all browsers
            '<tpl if="name"> name="{name}"</tpl>',
            '<tpl if="value"> value="{[Ext.util.Format.htmlEncode(values.value)]}"</tpl>',
            '<tpl if="placeholder"> placeholder="{placeholder}"</tpl>',
            '{%if (values.maxLength !== undefined){%} maxlength="{maxLength}"{%}%}',
            '<tpl if="readOnly"> readonly="readonly"</tpl>',
            '<tpl if="disabled"> disabled="disabled"</tpl>',
            '<tpl if="tabIdx != null"> tabindex="{tabIdx}"</tpl>',
            '<tpl if="fieldStyle"> style="{fieldStyle}"</tpl>',
        ' class="{fieldCls} {typeCls} {typeCls}-{ui} {editableCls} {inputCls}" autocomplete="off"/>',
        '</td>',
        '<tpl if="suffixTpl">',
        '<td nowrap class="suffixTplBg">{suffixTpl}</td>',
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
