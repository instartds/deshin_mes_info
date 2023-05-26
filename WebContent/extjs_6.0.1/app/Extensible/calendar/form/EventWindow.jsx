//@charset UTF-8
/*!
 * Extensible 1.5.2
 * Copyright(c) 2010-2013 Extensible, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class Extensible.calendar.form.EventWindow
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
Ext.define('Extensible.calendar.form.EventWindow', {
    extend: 'Ext.window.Window',
    alias: 'widget.extensible.eventeditwindow',
    
    requires: [
        'Ext.form.Panel',
        'Extensible.calendar.data.EventModel',
        'Extensible.calendar.data.EventMappings'
    ],
    animCollapse:false,
    
    // Locale configs
    titleTextAdd: 'Add Event',
    titleTextEdit: '일일 영업활동',
    width: 850,
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
             * @param {Extensible.calendar.form.EventWindow} this
             * @param {Extensible.calendar.data.EventModel} rec The new {@link Extensible.calendar.data.EventModel record} that was added
             * @param {Ext.Element} el The target element
             */
            eventadd: true,
            /**
             * @event eventupdate
             * Fires after an existing event is updated
             * @param {Extensible.calendar.form.EventWindow} this
             * @param {Extensible.calendar.data.EventModel} rec The new {@link Extensible.calendar.data.EventModel record} that was updated
             * @param {Ext.Element} el The target element
             */
            eventupdate: true,
            /**
             * @event eventdelete
             * Fires after an event is deleted
             * @param {Extensible.calendar.form.EventWindow} this
             * @param {Extensible.calendar.data.EventModel} rec The new {@link Extensible.calendar.data.EventModel record} that was deleted
             * @param {Ext.Element} el The target element
             */
            eventdelete: true,
            /**
             * @event eventcancel
             * Fires after an event add/edit operation is canceled by the user and no store update took place
             * @param {Extensible.calendar.form.EventWindow} this
             * @param {Extensible.calendar.data.EventModel} rec The new {@link Extensible.calendar.data.EventModel record} that was canceled
             * @param {Ext.Element} el The target element
             */
            eventcancel: true,
            /**
             * @event editdetails
             * Fires when the user selects the option in this window to continue editing in the detailed edit form
             * (by default, an instance of {@link Extensible.calendar.form.EventDetails}. Handling code should hide this window
             * and transfer the current event record to the appropriate instance of the detailed form by showing it
             * and calling {@link Extensible.calendar.form.EventDetails#loadRecord loadRecord}.
             * @param {Extensible.calendar.form.EventWindow} this
             * @param {Extensible.calendar.data.EventModel} rec The {@link Extensible.calendar.data.EventModel record} that is currently being edited
             * @param {Ext.Element} el The target element
             */
            editdetails: true
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
	            type: 'table',
	            columns: 3
	        }
            
        }, this.formPanelConfig));
        
        this.add(this.formPanel);
        
        this.callParent(arguments);
    },
    
    getFormItemConfigs: function() {
        var items = [
        	{
	            itemId: this.id + '-eventId',
	            name: 'id',
	            fieldLabel: '문서번호',
	            anchor: '100%',
	            readOnly : true,
	            colspan:3
	        },
	        {
	            itemId: this.id + '-PlanCustomCode',
	            name: 'PLAN_CUSTOM_CODE',
	            fieldLabel: '거래처코드',
	            anchor: '100%',
	            readOnly : true,
	            hidden : true
	        },
	        {
	            itemId: this.id + '-PlanCustomName',
	            name: 'PLAN_CUSTOM_NAME',
	            fieldLabel: '거래처',
	            anchor: '100%',
	            readOnly : true
	        },
	        {
	            itemId: this.id + '-PlanDvryCustNm',
	            name: 'PLAN_DVRY_CUST_NM',
	            fieldLabel: '배송처',
	            anchor: '100%',
	            readOnly : true
	        },
	        {
	            itemId: this.id + '-PlanDvryCustSeq',
	            name: 'PLAN_DVRY_CUST_SEQ',
	            fieldLabel: '배송처코드',
	            anchor: '100%',
	            readOnly : true,
	            hidden : true 
	        },
	        {
	            itemId: this.id + '-PlanClientId',
	            name: 'PLAN_CLIENT_ID',
	            fieldLabel: '고객ID',
	            anchor: '100%',
	            readOnly : true,
	            colspan:2
	        },
	        {
	            itemId: this.id + '-PlanClientNm',
	            name: 'PLAN_CLIENT_NAME',
	            fieldLabel: '고객명',
	            anchor: '100%',
	            readOnly : true,
	            colspan:2
	        },
	        {
	            itemId: this.id + '-PlanDate',
	            name: 'PLAN_DATE',
	            fieldLabel: '계획일자',
	            anchor: '100%',
	            readOnly : true,
	            xtype: 'datefield',format: Unilite.dateFormat ,altFormats: Unilite.altFormats, value : new Date()
	        },
	        {
	            itemId: this.id + '-PlanTarget',
	            name: 'PLAN_TARGET',
	            fieldLabel: '계획',
	            anchor: '100%',
	            readOnly : true,
	            colspan:3
	        },
	        
	        
	        {
			    itemId: this.id + '-ResultClientCd',
			    name: 'RESULT_CLIENT',
			    fieldLabel: '고객ID' }, 
			{
			    itemId: this.id + '-ResultClientNm',
			    name: 'RESULT_CLIENT_NAME',
			    fieldLabel: '고객명',     hidden: true}, 
			{
			    itemId: this.id + '-EtcClientNm',
			    name: 'ETC_CLIENT',
			    fieldLabel: '고객etc',   hidden: true},
			{
				  itemId: this.id + '-ResultDate',
			    name: 'RESULT_DATE',
			    fieldLabel: '실행일자', format: Unilite.dateFormat ,altFormats: Unilite.altFormats,value : new Date()},
			{
				  itemId: this.id + '-ResultTime',
			    name: 'RESULT_TIME',
			    fieldLabel: '실행시간', hidden: true },
			
			{
			    itemId: this.id + '-SaleType',
			    name: 'SALE_TYPE',
			    fieldLabel: '영업유형',   allowBlank : false},		 //btnSaleType
				
			{
				itemId: this.id + '-CustomCode',
			    name: 'CUSTOM_CODE',
			    fieldLabel: '거래처코드', hidden : true},
			{
				itemId: this.id + '-CustomNm',
			    name: 'CUSTOM_NAME',
			    fieldLabel: '거래처'},
			{
				itemId: this.id + '-DvryCustSeq',
			    name: 'DVRY_CUST_SEQ',
			    fieldLabel: '배송처코드', hidden : true},
			{
				  itemId: this.id + '-DvryCustNm',
			    name: 'DVRY_CUST_NM',
			    fieldLabel: '배송처', colspan : 2},
				{
					itemId: this.id + '-ProcessTypeNm',
			    name: 'PROCESS_TYPE_NM',
			    fieldLabel: '상태'  , allowBlank : false},
				{
					itemId: this.id + '-ProcessTypeCd',
			    name: 'PROCESS_TYPE',
			    fieldLabel: '상태'  , hidden : true},
				{
			    itemId: this.id + '-ProjectNo',
			    name: 'PROJECT_NO',
			    fieldLabel: '영업기회번호' }, 
			    {
			    itemId: this.id + '-ProjectNoNm',
			    name: 'PROJECT_NO_NM',
			    fieldLabel: '영업기회' }, 
				{
			    itemId: this.id + '-CurrentItemNm',
			    name: 'ITEM_NAME',
			    fieldLabel: '현사용제품',   colspan : 2},
				{
			    itemId: this.id + '-IMPORTANCE_STATUS',
			    name: 'IMPORTANCE_STATUS',
			    fieldLabel: '중요도' },				//btnImportanceStatus
				
				
				{
			    itemId: this.id + '-SaleEmp',
			    name: 'SALE_EMP',
			    fieldLabel: '영업담당자',  allowBlank: false},	//btnSaleEmp
				{
			    itemId: this.id + '-SaleAttend',
			    name: 'SALE_ATTEND',
			    fieldLabel: '영업참석자', colspan : 3, width : 360} ,
				
				{
			    itemId: this.id + '-SummaryStr',
			    name: 'SUMMARY_STR',
			    fieldLabel: '현황요약',  colspan : 4, width : 807} ,
				
				{xtype: 'textareafield',
			    itemId: this.id + '-Content',
			    name: 'CONTENT_STR',
			    fieldLabel: '내용',  grow : true, colspan : 4, width : 807, height : 150} ,
				
				{
			    itemId: this.id + '-ReqStr',
			    name: 'REQ_STR',
			    fieldLabel: '요청사항', colspan : 4, width : 807} ,
				
				{
			    itemId: this.id + '-OptionStr',
			    name: 'OPINION_STR',
			    fieldLabel: '소견/작성자', colspan : 4, width : 807} ,
				
				{
			    itemId: this.id + '-REMARK',
			    name: 'REMARK',
			    fieldLabel: '비고',  colspan : 4, width : 807} ,
				
				{
			    itemId: this.id + '-KeyWord',
			    name: 'KEYWORD',
			    fieldLabel: 'Keyword', colspan : 4, width : 807} 
    
    
	        ];
        
        if(this.calendarStore){
            items.push({
                xtype: 'extensible.calendarcombo',
                itemId: this.id + '-calendar',
                name: 'CalendarId',
                anchor: '100%',
                fieldLabel: this.calendarLabelText,
                store: this.calendarStore
            });
        }
        
        return items;
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
        //this.titleField = this.down('#' + this.id + '-title');
        //this.dateRangeField = this.down('#' + this.id + '-dates');
        //this.calendarField = this.down('#' + this.id + '-calendar');
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
            M = Extensible.calendar.data.EventMappings;
        // Animation 제거 by Kim
        this.animateTarget = null;
        this.callParent([this.animateTarget, function(){
           // this.id.focus(false, 10);
        }, this]);
        
        
        this.deleteButton[o.data && o.data[M.EventId.name] ? 'show' : 'hide']();
        
        var rec, f = this.formPanel.form;

        if(o.data){
            rec = o;
			//this.isAdd = !!rec.data[Extensible.calendar.data.EventMappings.IsNew.name];
			if(rec.phantom){
				// Enable adding the default record that was passed in
				// if it's new even if the user makes no changes 
				//rec.markDirty();
				//this.setTitle(this.titleTextAdd);
			}
			else{
				//this.setTitle(this.titleTextEdit);
			}
            
            f.loadRecord(rec);
        }
        else{
			//this.isAdd = true;
            this.setTitle(this.titleTextAdd);

            var start = o[M.StartDate.name],
                end = o[M.EndDate.name] || Extensible.Date.add(start, {hours: 1});
                
            rec = Ext.create('Extensible.calendar.data.EventModel');
            //rec.data[M.EventId.name] = this.newId++;
            rec.data[M.StartDate.name] = start;
            rec.data[M.EndDate.name] = end;
            rec.data[M.IsAllDay.name] = !!o[M.IsAllDay.name] || start.getDate() != Extensible.Date.add(end, {millis: 1}).getDate();
            
            f.reset();
            f.loadRecord(rec);
        }
        
        if(this.calendarStore){
            //this.calendarField.setValue(rec.data[M.CalendarId.name]);
        }
        //this.dateRangeField.setValue(rec.data);
        this.activeRecord = rec;
        //this.el.setStyle('z-index', 12000);
        
		return this;
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
//    updateRecord: function(keepEditing){
//        var dates = this.dateRangeField.getValue(),
//            M = Extensible.calendar.data.EventMappings,
//            rec = this.activeRecord,
//            form = this.formPanel.form,
//            fs = rec.fields,
//            dirty = false;
//            
//        rec.beginEdit();
//
//        //TODO: This block is copied directly from BasicForm.updateRecord.
//        // Unfortunately since that method internally calls begin/endEdit all
//        // updates happen and the record dirty status is reset internally to
//        // that call. We need the dirty status, plus currently the DateRangeField
//        // does not map directly to the record values, so for now we'll duplicate
//        // the setter logic here (we need to be able to pick up any custom-added 
//        // fields generically). Need to revisit this later and come up with a better solution.
//        fs.each(function(f){
//            var field = form.findField(f.name);
//            if(field){
//                var value = field.getValue();
//                if (value.getGroupValue) {
//                    value = value.getGroupValue();
//                } 
//                else if (field.eachItem) {
//                    value = [];
//                    field.eachItem(function(item){
//                        value.push(item.getValue());
//                    });
//                }
//                rec.set(f.name, value);
//            }
//        }, this);
//        
//        rec.set(M.StartDate.name, dates[0]);
//        rec.set(M.EndDate.name, dates[1]);
//        rec.set(M.IsAllDay.name, dates[2]);
//        
//        dirty = rec.dirty;
//        
//        if(!keepEditing){
//            rec.endEdit();
//        }
//        
//        return dirty;
//    },
    
    updateRecord: function(record, keepEditing) {
        var fields = record.fields,
            values = this.formPanel.getForm().getValues(),
            name,
            M = Extensible.calendar.data.EventMappings,
            obj = {};

        fields.each(function(f) {
            name = f.name;
            if (name in values) {
                obj[name] = values[name];
            }
        });
        
        var dates = this.dateRangeField.getValue();
        obj[M.StartDate.name] = dates[0];
        obj[M.EndDate.name] = dates[1];
        obj[M.IsAllDay.name] = dates[2];

        record.beginEdit();
        record.set(obj);
        
        if (!keepEditing) {
            record.endEdit();
        }

        return this;
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
		this.fireEvent('eventdelete', this, this.activeRecord, this.animateTarget);
    }
});