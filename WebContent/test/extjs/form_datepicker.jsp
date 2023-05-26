<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" src='<c:url value="/app/Extensible/Extensible.js" />' ></script>
<script type="text/javascript">
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
            	"Ext.ux": '${CPATH }/app/Ext/ux',
            	"Unilite": '${CPATH }/app/Unilite',
            	"Extensible": '${CPATH }/app/Extensible'
        }
	});
	
Ext.require([
    '*',
    'Ext.ux.grid.FiltersFeature',
    'Ext.ux.DataTip',
    'Extensible.form.field.DateRange',
    'Extensible.Date'
]);

	
Ext.onReady(function() {
	/**
	* Rerence : http://workblog.neteos.eu/180/javascript/extjs/extjs-datefield-select-date-range
	* 
	* 초기값이 있으면 무한 루프를 돌수 있다.! ( isInit 값으로 무한 루프 제거 )
	*/
	
	Ext.apply(Ext.form.VTypes, {
	    daterangeX : function(val, field) {
	    	if(! field.isInit ) {
	    		field.isInit = true;
		        var date = field.parseDate(val);
		 
		        if(!date){
		            return;
		        }
		        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
		            //var start = Ext.getCmp(field.startDateField);
		             var start = field.up('form').down('#' + field.startDateField);
		            start.setMaxValue(date);
		            start.validate();
		            this.dateRangeMax = date;
		        }
		        else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
		           // var end = Ext.getCmp(field.endDateField);
		            var end = field.up('form').down('#' + field.endDateField);
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
	
	
	var dateStart =  new Unilite.com.form.field.UniDateField({
	    allowBlank: false,
	    name: 'dataStart',
	    itemId:'dataStart',
	    fieldLabel: "Date Start",
	    hideLabel: false,
	    value:'2014.02.10',
	    vtype: 'daterangeX',//type here
	    endDateField: 'dateEnd'//and end date field
	});
	 
	var dateEnd =  new Unilite.com.form.field.UniDateField({
	    allowBlank: false,
	    name: 'dateEnd',
	    itemId:'dateEnd',
	    fieldLabel: "Date End",
	    hideLabel: false,
	    value:'2014.02.12',
	    vtype: 'daterangeX',//add type
	    startDateField: 'dataStart'//start date field
	});
	
	
	Ext.create('Ext.form.Panel', {
	    renderTo: Ext.getBody(),
	    layout: {
	    	xtype: 'vbox'
	    },
	    width: 800,
	    bodyPadding: 10,
	    title: 'Dates',
	    items: [
	            dateStart, dateEnd,
	            {
	            xtype: 'extensible.daterangefield',
	            itemId: this.id + '-dates',
	            name: 'dates',
	            anchor: '95%',
	            singleLine: true,
	            fieldLabel: this.datesLabelText
	        }
	    ]
	});
});


</script>
