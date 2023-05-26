//@charset UTF-8
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
});