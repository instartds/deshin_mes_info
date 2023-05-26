//@charset UTF-8
/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.form.EventWindow
 * @extends Ext.window.Window
 * <p>A custom window containing a basic edit form used for quick editing of events.</p>
 * <p>This window also provides custom events specific to the calendar so that other calendar components can be easily
 * notified when an event has been edited via this component.</p>
 * <p>The default configs are as follows:</p><pre><code>
    // Locale configs
    titleTextAdd: 'Add Event',
    titleTextEdit: 'Edit Event',
    width: 600,
    labelWidth: 65,
    detailsLinkText: 'Edit Details...',
    savingMessage: 'Saving changes...',
    deletingMessage: 'Deleting event...',
    saveButtonText: 'Save',
    deleteButtonText: 'Delete',
    cancelButtonText: 'Cancel',
    titleLabelText: 'Title',
    datesLabelText: 'When',
    calendarLabelText: 'Calendar',
    
    // General configs
    closeAction: 'hide',
    modal: false,
    resizable: false,
    constrain: true,
    buttonAlign: 'left',
    editDetailsLinkClass: 'edit-dtl-link',
    enableEditDetails: true,
    bodyStyle: 'padding: 8px 10px 5px;',
    layout: 'fit'
</code></pre>
 * @constructor
 * @param {Object} config The config object
 */
Ext.define('nbox.calendar.form.EventWindow', {
    extend: 'Ext.window.Window',
    alias: 'widget.nbox.eventeditwindow',
    
    requires: [
        'Ext.form.Panel',
        'nbox.calendar.data.EventModel',
        'nbox.calendar.data.EventMappings'
    ],
    animCollapse:false,
    
    // Locale configs
    titleTextAdd: '일정등록',
    titleTextEdit: '일정수정',
    width: 650,
    labelWidth: 65,
    detailsLinkText: '',
    savingMessage: 'Saving changes...',
    deletingMessage: 'Deleting event...',
    saveButtonText: 'Save',
    deleteButtonText: 'Delete',
    cancelButtonText: 'Cancel',
    titleLabelText: 'Title',
    datesLabelText: '기간',
    calendarLabelText: '일정구분',
    
    // General configs
    closeAction: 'hide',
    modal: false,
    resizable: false,
    constrain: true,
    buttonAlign: 'left',
    editDetailsLinkClass: 'edit-dtl-link',
    enableEditDetails: true,
    layout: 'fit',
    
    formPanelConfig: {
        border: false
    },
    
    // private
    initComponent: function(){
        this.addEvents({
            /**
             * @event eventadd
             * Fires after a new event is added
             * @param {nbox.calendar.form.EventWindow} this
             * @param {nbox.calendar.data.EventModel} rec The new {@link nbox.calendar.data.EventModel record} that was added
             * @param {Ext.Element} el The target element
             */
            eventadd: true,
            /**
             * @event eventupdate
             * Fires after an existing event is updated
             * @param {nbox.calendar.form.EventWindow} this
             * @param {nbox.calendar.data.EventModel} rec The new {@link nbox.calendar.data.EventModel record} that was updated
             * @param {Ext.Element} el The target element
             */
            eventupdate: true,
            /**
             * @event eventdelete
             * Fires after an event is deleted
             * @param {nbox.calendar.form.EventWindow} this
             * @param {nbox.calendar.data.EventModel} rec The new {@link nbox.calendar.data.EventModel record} that was deleted
             * @param {Ext.Element} el The target element
             */
            eventdelete: true,
            /**
             * @event eventcancel
             * Fires after an event add/edit operation is canceled by the user and no store update took place
             * @param {nbox.calendar.form.EventWindow} this
             * @param {nbox.calendar.data.EventModel} rec The new {@link nbox.calendar.data.EventModel record} that was canceled
             * @param {Ext.Element} el The target element
             */
            eventcancel: true,
            /**
             * @event editdetails
             * Fires when the user selects the option in this window to continue editing in the detailed edit form
             * (by default, an instance of {@link nbox.calendar.form.EventDetails}. Handling code should hide this window
             * and transfer the current event record to the appropriate instance of the detailed form by showing it
             * and calling {@link nbox.calendar.form.EventDetails#loadRecord loadRecord}.
             * @param {nbox.calendar.form.EventWindow} this
             * @param {nbox.calendar.data.EventModel} rec The {@link nbox.calendar.data.EventModel record} that is currently being edited
             * @param {Ext.Element} el The target element
             */
            editdetails: false
        });
        
        this.fbar = this.getFooterBarConfig();
        
        this.callParent(arguments);
    },
    
    getFooterBarConfig: function() {
        var cfg = ['->', {
                text: this.saveButtonText,
                itemId: this.id + '-save-btn',
                disabled: false,
                handler: this.onSave, 
                scope: this
            },{
                text: this.deleteButtonText, 
                itemId: this.id + '-delete-btn',
                disabled: false,
                handler: this.onDelete,
                scope: this,
                hideMode: 'offsets' // IE requires this
            },{
                text: this.cancelButtonText,
                itemId: this.id + '-cancel-btn',
                disabled: false,
                handler: this.onCancel,
                scope: this
            }];
        
        if(this.enableEditDetails !== false){
            cfg.unshift({
                xtype: 'tbtext',
                itemId: this.id + '-details-btn',
                text: '<a href="#" class="' + this.editDetailsLinkClass + '">' + this.detailsLinkText + '</a>'
            });
        }
        return cfg;
    },
    
    // private
    onRender : function(ct, position){        
        this.formPanel = Ext.create('Ext.form.Panel', Ext.applyIf({
            fieldDefaults: {
                labelWidth: this.labelWidth,
	            msgTarget: 'under',
	            labelAlign: 'right',
	            labelSeparator : "",
	            labelWidth : 80,
	            anchor    : '100%'
            },
	    	defaultType: 'textfield',
            items: this.getFormItemConfigs(),
            layout: {
	            type: 'vbox'
	        }
            
        }, this.formPanelConfig));
        
        this.add(this.formPanel);
        
        this.callParent(arguments);
    },
    
    getFormItemConfigs: function() {
    	var me = this;
    	var items = [] ;
    	
    	var recurtypeStore = Ext.create('Ext.data.Store', {
		  fields: ["CODE", 'NAME'],
		  autoLoad: true,
		  proxy: {
		        type: 'direct',
		        extraParams: {MASTERID: 'NS03'},
		        api: { read: 'nboxCommonService.selectCommonCode' },
		        reader: {
		            type: 'json',
		            root: 'records'
		        }
		  	}
		});
    	
    	var monthPositionStore = Ext.create('Ext.data.Store', {
		  fields: ["CODE", 'NAME'],
		  autoLoad: true,
		  proxy: {
		        type: 'direct',
		        extraParams: {MASTERID: 'NS07'},
		        api: { read: 'nboxCommonService.selectCommonCode' },
		        reader: {
		            type: 'json',
		            root: 'records'
		        }
		  	}
		});	
      	
    	
    	var weekPositionStore = Ext.create('Ext.data.Store', {
  		  fields: ["CODE", 'NAME'],
  		  autoLoad: true,
  		  proxy: {
  		        type: 'direct',
  		        extraParams: {MASTERID: 'NS05'},
  		        api: { read: 'nboxCommonService.selectCommonCode' },
  		        reader: {
  		            type: 'json',
  		            root: 'records'
  		        }
  		  	}
  		});	
    	
    	var dayPositionStore = Ext.create('Ext.data.Store', {
		  fields: ["CODE", 'NAME'],
		  autoLoad: true,
		  proxy: {
		        type: 'direct',
		        extraParams: {MASTERID: 'NS06'},
		        api: { read: 'nboxCommonService.selectCommonCode' },
		        reader: {
		            type: 'json',
		            root: 'records'
		        }
		  	}
		});	
    	
    	var endingTypeStore = Ext.create('Ext.data.Store', {
  		  fields: ["CODE", 'NAME'],
  		  autoLoad: true,
  		  proxy: {
  		        type: 'direct',
  		        extraParams: {MASTERID: 'NS08'},
  		        api: { read: 'nboxCommonService.selectCommonCode' },
  		        reader: {
  		            type: 'json',
  		            root: 'records'
  		        }
  		  	}
  		});	    
    	
    	var saveTypeStore = Ext.create('Ext.data.Store', {
		  fields: ["CODE", 'NAME'],
		  autoLoad: true,
		  proxy: {
		        type: 'direct',
		        extraParams: {MASTERID: 'NS09'},
		        api: { read: 'nboxCommonService.selectCommonCode' },
		        reader: {
		            type: 'json',
		            root: 'records'
		        }
		  	}
		});	    
    	
    	
    	if(this.calendarStore){
            items = [{
                xtype: 'nbox.calendarcombo',
                itemId: this.id + '-calendar',
                name: 'CalendarId',
                /*anchor: '100%',*/
                fieldLabel: this.calendarLabelText,
                store: this.calendarStore,
                padding: '7 0 0 0'
            }];
        }
    	
        items.push(
        	{
	            itemId: this.id + '-title',
	            name: nbox.calendar.data.EventMappings.Title.name,
	            fieldLabel: '일정명',
	            width : 600
	        },
	        {
	            xtype: 'nbox.daterangefield',
	            itemId: this.id + '-dates',
	            name: 'dates',
	            anchor: '95%',
	            singleLine: true,
	            fieldLabel: this.datesLabelText
	        },
			{	xtype: 'textareafield',
			    itemId: this.id + '-Notes',
			    name: nbox.calendar.data.EventMappings.Notes.name,
			    fieldLabel: '상세내용',  grow : true, width : 600, height : 80,
			    padding: '5 0 0 0'
			    
			},
			{
				itemId: this.id + '-infoPanel',
				xtype: 'panel',
				border: false,
				layout: {
					type: 'hbox'
				},
				items:[
					{ 
						itemId: this.id + '-openFlag',
						xtype: 'checkbox',
						labelWidth : 70,
						fieldLabel: '공개여부',
					    name : nbox.calendar.data.EventMappings.OpenFlag.name,
					},
					{ 
						itemId: this.id + '-eventInformation',
						xtype: 'displayfield',
					    name : nbox.calendar.data.EventMappings.EventInformation.name,
					    width: 500,
					    padding: '0 0 0 0',
					    style: {
					    	'text-align': 'right'
					    }
					}
				]
			},
			{
				itemId: this.id + '-recurFlagPanel',
				xtype: 'panel',
				border: false,
				layout: {
					type: 'hbox',
					align: 'strech'
				},
				items:[
					{ 
			        	itemId: this.id + '-recurFlag',
			        	xtype: 'checkbox',
			        	labelWidth : 70,
			        	fieldLabel: '반복설정',
					    name      : nbox.calendar.data.EventMappings.RecurFlag.name,
					    padding: '0 0 0 0'	,
					    listeners: {
					    	change: function( obj, newValue, oldValue, eOpts ){
					    		var recurPanel = obj.up('panel').up('panel').items.get(me.id + '-recurPanel');
					    		var recurSaveType = obj.up('panel').items.get(me.id + '-recurSaveType');
					    		
					    		if(recurPanel)
					    			recurPanel.setVisible(newValue);
					    		
					    		if(recurSaveType)
					    			recurSaveType.setVisible(newValue);
					    	}
					    }
					},
					
					{
						id: this.id + '-recurSaveType',
						xtype: 'combo',
						displayField: 'NAME',
					    valueField: 'CODE',
					    store: saveTypeStore,
					    name : nbox.calendar.data.EventMappings.RecurSaveType.name,
					    padding: '0 0 0 368',
					    width: 150,
					    value: '3',
					    hidden: true
					    
					}
				]
			},
			{
				itemId: this.id + '-recurPanel',
				xtype: 'panel',
				padding: '0 0 5 0',
				border: true,
				layout: {
		            type: 'vbox'
		        },
		        hidden: true,
		        width: 617,
				items: [
				    {
				    	xtype: 'panel',
				    	layout: {
				    		type: 'hbox'
				    	},
				    	border: false,
				    	items: [
							{
								id: this.id + '-recurCount',
								xtype: 'numberfield',
								width: 110,
								fieldLabel: '반복간격',
								labelWidth: 60,
								value: 1,
								name : nbox.calendar.data.EventMappings.RecurCount.name,
							},
							{
								id: this.id + '-recurType',
								xtype: 'combo',
								displayField: 'NAME',
							    valueField: 'CODE',
							    store: recurtypeStore,
							    padding: '0 0 0 5',
							    width: 100,
							    value: '1',
							    name : nbox.calendar.data.EventMappings.RecurType.name,
							    listeners: {
							    	select: function(obj, records, eOpts ){
							    		me.setRecurItems();
							    	}
							    }
							},
							{
								id: this.id + '-fixType',
								xtype: 'checkbox',
								boxLabel: '고정',
								padding: '0 0 0 5',
								checked: false,
								name : nbox.calendar.data.EventMappings.FixType.name,
								listeners: {
									change: function( obj, newValue, oldValue, eOpts ){
										me.setRecurItems();
									}
								}
							},
							{
								id: this.id + '-monthPosition',
								xtype: 'combo',
								displayField: 'NAME',
							    valueField: 'CODE',
							    store: monthPositionStore,
							    name : nbox.calendar.data.EventMappings.MonthPosition.name,
							    /*hidden: true,*/
							    padding: '0 0 0 5',
							    width: 60,
							    disabled: true
							},
							{
								id: this.id + '-weekPosition',
								xtype: 'combo',
								displayField: 'NAME',
							    valueField: 'CODE',
							    store: weekPositionStore,
							    name : nbox.calendar.data.EventMappings.WeekPosition.name,
							    /*hidden: true,*/
							    padding: '0 0 0 5',
							    width: 80,
							    disabled: true
							},
							{
								id: this.id + '-dayPosition',
								xtype: 'combo',
								displayField: 'NAME',
							    valueField: 'CODE',
							    store: dayPositionStore,
							    name : nbox.calendar.data.EventMappings.DayPosition.name,
							    /*hidden: true,*/
							    padding: '0 0 0 5',
							    width: 70,
							    disabled: true
							}
				    	]
				    },
			    	{
				    	xtype: 'panel',
				    	layout: {
				    		type: 'hbox'
				    	},
				    	border: false,
				    	items:[
							{
								id: this.id + '-endingType',
								xtype: 'combo',
								displayField: 'NAME',
							    valueField: 'CODE',
							    store: endingTypeStore,
							    fieldLabel: '반복 끝',
							    labelWidth: 60,
							    width: 150,
							    value: '1',
							    name : nbox.calendar.data.EventMappings.EndingType.name,
							    listeners: {
							    	select: function(obj, records, eOpts ){
							    		me.setRecurEndingItems();
							    	}
							    }
							},
							{
								id: this.id + '-endingCount',
								xtype: 'numberfield',
								width: 70,
								padding: '0 0 0 5',
								value: 1,
								name : nbox.calendar.data.EventMappings.EndingCount.name
							},
							{
								id: this.id + '-endingDate',
								xtype: 'datefield',
								width: 100,
								padding: '0 0 0 5',
								format: 'Y-m-d',
								value: new Date(),
								name : nbox.calendar.data.EventMappings.EndingDate.name
							}
							
				    	]
			    	}
				]
			}
	        );
        
        
        return items;
    },
    // Recurrence Items Setting 
    setRecurItems: function(){
    	var me = this;
    	
    	var recurType = Ext.getCmp(me.id + '-recurType');
    	var fixType = Ext.getCmp(me.id + '-fixType');
    	
    	var monthPosition = Ext.getCmp(me.id + '-monthPosition');
		var weekPosition =Ext.getCmp(me.id + '-weekPosition');
		var dayPosition = Ext.getCmp(me.id + '-dayPosition');
		
		monthPosition.setVisible(false);   
		weekPosition.setVisible(false);
		dayPosition.setVisible(false);
		
		if(!fixType.checked){
			switch(recurType.getValue()){
				/* 매일 */
		    	case '1':
		    		break;
		    	/* 매주 */
		    	case '2':
		    		dayPosition.setVisible(true);
		    		break;
		    	/* 매월 */
		    	case '3':
		    		weekPosition.setVisible(true);
		    		dayPosition.setVisible(true);
		    		break;
		    	/* 매년 */	
		    	case '4':
		    		monthPosition.setVisible(true); 
		    		weekPosition.setVisible(true);
		    		dayPosition.setVisible(true);
		    		break;
		    	default:
		    		break;
	    	}	
		}
    	
    },
    setRecurEndingItems: function(){
    	var me = this;
    	
    	var endingType = Ext.getCmp(me.id + '-endingType');
    	var endingCount = Ext.getCmp(me.id + '-endingCount');
    	var endingDate = Ext.getCmp(me.id + '-endingDate');
    	
    	endingCount.setVisible(false);
    	endingDate.setVisible(false);
    	
    	switch(endingType.getValue()){
	    	case '1':
	    		break;
	    	case '2':
	    		endingCount.setVisible(true);
	    		break;
	    	case '3':
	    		endingDate.setVisible(true);
	    		break;
	    	default:
	    		break;
    	}
    },
    // private
    afterRender: function(){
        this.callParent(arguments);
		
		this.el.addCls('ext-cal-event-win');
        
        this.initRefs();
        
        // This junk spacer item gets added to the fbar by Ext (fixed in 4.0.2)
        var junkSpacer = this.getDockedItems('toolbar')[0].items.items[0];
        if (junkSpacer.el.hasCls('x-component-default')) {
            Ext.destroy(junkSpacer);
        }
    },
    
    initRefs: function() {
        // toolbar button refs
        this.saveButton = this.down('#' + this.id + '-save-btn');
        this.deleteButton = this.down('#' + this.id + '-delete-btn');
        this.cancelButton = this.down('#' + this.id + '-cancel-btn');
        this.detailsButton = this.down('#' + this.id + '-details-btn');
        
        if (this.detailsButton) {
            this.detailsButton.getEl().on('click', this.onEditDetailsClick, this);
        }
        
        // form item refs
        this.titleField = this.down('#' + this.id + '-title');
        this.dateRangeField = this.down('#' + this.id + '-dates');
        this.calendarField = this.down('#' + this.id + '-calendar');
        this.recurField = this.down('#' + this.id + '-recurFlag');
    },
    
    // private
    onEditDetailsClick: function(e){
        e.stopEvent();
        this.updateRecord(this.activeRecord, true);
        this.fireEvent('editdetails', this, this.activeRecord, this.animateTarget);
    },
	
	/**
     * Shows the window, rendering it first if necessary, or activates it and brings it to front if hidden.
	 * @param {Ext.data.Record/Object} o Either a {@link Ext.data.Record} if showing the form
	 * for an existing event in edit mode, or a plain object containing a StartDate property (and 
	 * optionally an EndDate property) for showing the form in add mode. 
     * @param {String/Element} animateTarget (optional) The target element or id from which the window should
     * animate while opening (defaults to null with no animation)
     * @return {Ext.Window} this
     */
    show: function(o, animateTarget){
		// Work around the CSS day cell height hack needed for initial render in IE8/strict:
		this.animateTarget = (Ext.isIE8 && Ext.isStrict) ? null : animateTarget,
            M = nbox.calendar.data.EventMappings;

        this.callParent([this.animateTarget, function(){
            this.titleField.focus(false, 100);
        }, this]);
        
        //this.deleteButton[o.data && o.data[M.EventId.name] ? 'show' : 'hide']();
        this.deleteButton[o.data ? 'show' : 'hide']();
        
        var rec, f = this.formPanel.form;
        
        if(o.data){
            rec = o;
			this.isAdd = false;//!!rec.data[nbox.calendar.data.EventMappings.IsNew.name];
			if(rec.phantom){
				// Enable adding the default record that was passed in
				// if it's new even if the user makes no changes 
				rec.markDirty();
				this.setTitle(this.titleTextAdd);
			}
			else{
				this.setTitle(this.titleTextEdit);
			}
            
            f.loadRecord(rec);
        }
        else{
			this.isAdd = true;
            this.setTitle(this.titleTextAdd);

            var start = o[M.StartDate.name],
                end = o[M.EndDate.name] || Extensible.Date.add(start, {hours: 1});
                
            rec = Ext.create('nbox.calendar.data.EventModel');
            rec.data[M.EventId.name] = this.newId++;
            rec.data[M.StartDate.name] = start;
            rec.data[M.EndDate.name] = end;
            rec.data[M.IsAllDay.name] = !!o[M.IsAllDay.name] || start.getDate() != Extensible.Date.add(end, {millis: 1}).getDate();
            
            /* 초기값 Setting */
            rec.data[M.RecurCount.name] = 1;
            rec.data[M.RecurType.name] = '1';
            rec.data[M.FixType.name] = true;
            
            rec.data[M.EndingType.name] = '1';
            rec.data[M.MonthPosition.name] = (start.getMonth() + 1).toString();
            rec.data[M.WeekPosition.name] = this.getHowWeek(start).toString();
            rec.data[M.DayPosition.name] = (start.getDay() + 1).toString();
            
            rec.data[M.EndingCount.name] = 1;
            rec.data[M.EndingDate.name] = end;
            
            rec.data[M.RecurSaveType.name] = '3';
            
            f.reset();
            f.loadRecord(rec);
        }
        
        this.setRecurItems();
        this.setRecurEndingItems();
        
        if(this.calendarStore){
            this.calendarField.setValue(rec.data[M.CalendarId.name]);
        }
        this.dateRangeField.setValue(rec.data);
        this.activeRecord = rec;
        //this.el.setStyle('z-index', 12000);
        
        this.saveButton.setDisabled(false);
    	this.deleteButton.setDisabled(false);
    	
    	/* 본인이 작성한 글만 수정 가능 */
    	if(rec.data.userId != ''){
    		if( rec.data.userId != UserInfo.userID){
	    		this.saveButton.setDisabled(true);
	        	this.deleteButton.setDisabled(true);
	    	}
    	}
    	
    	switch(rec.data.calendarId){
    		case 'B': case 'H': case 'W':
    			this.calendarField.setDisabled(true);
    			this.recurField.setDisabled(true);
    			
    			break;
    		default:
    			this.calendarField.setDisabled(false);
				this.recurField.setDisabled(false);
				
    			break;
    	}
        
		return this;
    },
    
    getHowWeek: function(date){
    	
    	var day = new Date(date.getFullYear(), date.getMonth(), 1);
    	var week = 0;
    	
    	for (var i=0; i<41; i++) {
    		
    		day = new Date(day.getFullYear(), day.getMonth(), (1 + i));
    		
    		if(date.getDay() == day.getDay())
    			week ++;
    		
    		if(day.getDate() == date.getDate())
    			break;
    		
		}
    	
    	return week;
    },
    
    // private
    roundTime: function(dt, incr){
        incr = incr || 15;
        var m = parseInt(dt.getMinutes());
        return dt.add('mi', incr - (m % incr));
    },
    
    // private
    onCancel: function(){
    	this.cleanup(true);
		this.fireEvent('eventcancel', this, this.activeRecord, this.animateTarget);
    },

    // private
    cleanup: function(hide){
        if (this.activeRecord) {
            this.activeRecord.reject();
        }
        delete this.activeRecord;
		
        if (hide===true) {
			// Work around the CSS day cell height hack needed for initial render in IE8/strict:
			//var anim = afterDelete || (Ext.isIE8 && Ext.isStrict) ? null : this.animateTarget;
            this.hide();
        }
    },
    
    // private
    updateRecord: function(keepEditing){
        var dates = this.dateRangeField.getValue(),
            M = nbox.calendar.data.EventMappings,
            rec = this.activeRecord,
            form = this.formPanel.form,
            fs = rec.fields,
            dirty = false;
            
        rec.beginEdit();

        //TODO: This block is copied directly from BasicForm.updateRecord.
        // Unfortunately since that method internally calls begin/endEdit all
        // updates happen and the record dirty status is reset internally to
        // that call. We need the dirty status, plus currently the DateRangeField
        // does not map directly to the record values, so for now we'll duplicate
        // the setter logic here (we need to be able to pick up any custom-added 
        // fields generically). Need to revisit this later and come up with a better solution.
        fs.each(function(f){
            var field = form.findField(f.name);
            if(field){
                var value = field.getValue();
                if(value){
	                if (value.getGroupValue) {
	                    value = value.getGroupValue();
	                } 
	                else if (field.eachItem) {
	                    value = [];
	                    field.eachItem(function(item){
	                        value.push(item.getValue());
	                    });
	                }
	                rec.set(f.name, value);
                }
            }
        }, this);
        
        rec.set(M.StartDate.name, dates[0]);
        rec.set(M.EndDate.name, dates[1]);
        rec.set(M.IsAllDay.name, dates[2]);
        
        rec.set(M.CalendarId.name, this.calendarField.getValue());
        
        dirty = rec.dirty;
        
        if(!keepEditing){
            rec.endEdit();
        }
        
        return dirty;
    },
    
    // private
    onSave: function(){
        if(!this.formPanel.form.isValid()){
            return;
        }
		if(!this.updateRecord(this.activeRecord)){
			this.onCancel();
			return;
		}
		this.fireEvent(this.activeRecord.phantom ? 'eventadd' : 'eventupdate', this, this.activeRecord, this.animateTarget);
    },
    
    // private
    onDelete: function(){
    	this.updateRecord(this.activeRecord);
		this.fireEvent('eventdelete', this, this.activeRecord, this.animateTarget);
    }
});