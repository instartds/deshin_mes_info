//@charset UTF-8


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

