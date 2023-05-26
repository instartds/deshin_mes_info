/**
 * 
 */

Ext.define('Unilite.com.form.field.UniMonthField', {
	extend: 'Ext.form.field.Date',
	alias: 'widget.uniMonthfield',
    requires: [
    	'Ext.picker.Month'/*,
    	'Unilite.com.form.field.UniClearButton'*/
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
	//value: new Date(), //기본값 설정
	/*triggers: {

		picker: {
			handler: 'onTriggerClick', scope: 'this'
		}
	},
	onTriggerClick: function() {
		var me = this,
		 bodyEl, picker, doc, collapseIf;
		
		if(!me.picker) {
			me.picker = new Ext.picker.Month({
				renderTo: document.body,
				ownerCt: me.ownerCt,
				floating: true,
				padding: me.padding,
				shadow: false,
				small: me.showToday === false,
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
		}
		picker = me.picker;

		if (me.rendered && !me.isExpanded && !me.isDestroyed) {
            bodyEl = me.bodyEl;
            //picker = me.getPicker();
            doc = Ext.getDoc();
            collapseIf = me.collapseIf;
            picker.setMaxHeight(picker.initialConfig.maxHeight);
            
            if (me.matchFieldWidth) {
                picker.width = me.bodyEl.getWidth();
            }

            // Show the picker and set isExpanded flag. alignPicker only works if isExpanded.
            picker.show();
            me.isExpanded = true;
            me.alignPicker();
            bodyEl.addCls(me.openCls);

            // monitor touch and mousewheel
            me.hideListeners = doc.on({
                mousewheel: me.collapseIf,
                touchstart: me.collapseIf,
                scope: me,
                delegated: false,
                destroyable: true
            });	
            
            Ext.on('resize', me.alignPicker, me);
            me.fireEvent('expand', me);
            me.onExpand();
        }
	},*/
    initComponent: function () {
		var me = this;
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
//	 		if(!Ext.isDefined(this.plugins)) {
//				this.plugins = new Array();		
//			}
//			this.plugins.push('uniClearbutton');
	 	};
    	
	 	this.callParent();
	},
//	createPicker : function()
//    {
//        var me = this,
//            picker = me.monthPicker;
//
//        if (!picker) {
//            me.monthPicker = picker = new Ext.picker.Month({
//                renderTo: document.body,
//                ownerCt: me.ownerCt,
//                // We need to set the ownerCmp so that owns() can correctly
//                // match up the component hierarchy so that focus does not leave
//                // an owning picker field if/when this gets focus.
//                ownerCmp: me,
//                floating: true,
//
//                // OVERRIDE
//                focusable: true,
//                
//                padding: me.padding,
//                shadow: false,
//                small: me.showToday === false,
//	            listeners: { 
//			        select:        { scope: me,   fn: me.onSelect      }, 
//			        monthdblclick: { scope: me,   fn: me.onOKClick     },
//			        yeardblclick:  { scope: me,   fn: me.onOKClick     },
//			        OkClick:       { scope: me,   fn: me.onOKClick     },    
//			        CancelClick:   { scope: me,   fn: me.onCancelClick }        
//	            }
//            });
//            if (!me.disableAnim) {
//                // hide the element if we're animating to prevent an initial flicker
//                picker.el.setStyle('display', 'none');
//            }
//            picker.hide();
//            //me.on('beforehide', me.doHideMonthPicker, me);
//        }
//        return picker;
//    },
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        return Ext.create('Ext.picker.Month', {
            ownerCt: me.ownerCt,
            renderTo: document.body,
            ownerCmp: me,
            // OVERRIDE
            focusable: me.focusable,
            floating: true,
            focusable: false, // Key events are listened from the input field which is never blurred

            //height:170,
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
 