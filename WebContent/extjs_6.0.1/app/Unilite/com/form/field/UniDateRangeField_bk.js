//@charset UTF-8
/**
 * Copyright (c) 2009, Hans Doller
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 *   * Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *     
 *   * Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *     
 *   * The names of its contributors may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Ext.ux.form.DateRange Class
 * 
 * @author Hans Doller
 * @version DateRange.js 2010-02-10 v0.2
 * 
 * @class Ext.ux.form.DateRange
 * @extends Ext.form.TriggerField
 */


Ext.define('Unilite.com.form.field.UniDateRangeField', {
  	extend: 'Ext.form.TriggerField',
	alias: 'widget.uniDateRangefield',
	format : "Y-m-d",
	delimiter: ' to ',
	altFormats : "m/d/Y|n/j/Y|n/j/y|m/j/y|n/d/y|m/j/Y|n/d/Y|m-d-y|m-d-Y|m/d|m-d|md|mdy|mdY|d|Y-m-d",
	invalidText : "{0} is not a valid date - it must be in the format {1}",
    triggerClass : 'x-form-date-trigger',
	showToday : true,
	handler: function(s,e){},
	value: 'today',
	keywords: {
		today: function(){
			var d = new Date();
				d = d.format( this.format );
			return d;
		}
	},
	presetDates: [
		{ text: 'Today', dateStart: 'today' },
		{ text: 'Last 7 days',
			dateStart: 'today-7days',
			dateEnd: 'today' },
		{ text: 'Month to date',
			//dateStart: function(){ return Date.parse('today').moveToFirstDayOfMonth(); },
			dateStart: function(){ return UniDate.get('startOfMonth'); },
			dateEnd: 'today' },
		{ text: 'Year to date',
			//dateStart: function(){ var x= Date.parse('today'); x.setMonth(0); x.setDate(1); return x; },
			dateStart: function(){  return UniDate.get('startOfYear'); },
			dateEnd: 'today' }
			/*,
		{ text: 'The previous month',
			//dateStart: function(){ return Date.parse('1 month ago').moveToFirstDayOfMonth(); },
			//dateEnd: function(){ return Date.parse('1 month ago').moveToLastDayOfMonth(); } }
			dateStart: function(){ return Date.parse('1 month ago').moveToFirstDayOfMonth(); },
			dateEnd: function(){ return Date.parse('1 month ago').moveToLastDayOfMonth(); } } 
			*/
	],
	presets: {
		specificDate: 'Specific Date',
		allDatesBefore: 'All Dates Before',
		allDatesAfter: 'All Dates After',
		dateRange: 'Custom Date Range'
	},
	defaultAutoCreate : {
		tag : "input",
		type : "text",
		size : "30",
		autocomplete : "off"
	},
    initEvents : function(){
		Unilite.com.form.field.UniDateRangeField.superclass.initEvents.call(this);

		this.mon(this.el, 'keypress', function(e,f){
			if(e.getKey() == Ext.EventObject.ENTER) { // catch Return.
				var ds = this.getDates();
				if(this.isDateRange()) { this.handler(ds[0],ds[1]); }
				else { this.handler(ds,false); }
			}
		}, this, {preventDefault:false});
	},
	setValue : function(date) {
		
		var value = '';
		
		if(date == '') {
			return false;
		}
		
		this.value = date;
		
		if( Ext.isDate(date) ) {
			// is a single date
			value = this.formatDate(date);
		}
		else if( Ext.isArray(date) && !Ext.isObject(date) ) {
			// multiple dates ([0] start, [1], end)
			if(date.length == 1) {
				value = this.formatDate(date[0]);
			}
			else if(date.length > 1) {
				value = this.formatDate(date[0]) + this.delimiter + this.formatDate(date[1]);
			}
		}
		else if( this.isDateRange(date) ) {
			value = date; // pass thru
		}
		else {
			value = this.formatDate(Date.parse(date)); // try a parse (last shot)
		}
		
		return Ext.form.DateField.superclass.setValue.call(this, value );
	},
	formatDate : function(date) {
        return Ext.isDate(date) ? date.dateFormat(this.format) : date;
	},
	getDates : function() {
		var val = this.getValue()+'';
		
		if( this.isDateRange(val) ) {
			var dates = val.split(this.delimiter);
			var ndates = [];
			Ext.each(dates,function(v){
				var dp = Date.parse(v);
				if(dp) { ndates.push(dp); }
			});
			return ndates;
		}
		else {
			return [ Date.parse(val) ];
		}
	},
	isDateRange: function(v){
		if(v === undefined) { v = this.getValue(); }
		return (v.indexOf(this.delimiter) !== -1);
	},
	onDestroy : function() {
		Ext.destroy(this.menu);
		Ext.form.DateField.superclass.onDestroy.call(this);
	},
	onTriggerClick : function() {
		if (this.disabled) {
			return;
		}
		var $this = this;
		
		var 
		dateToday = Date.parse('today'),
		dateBasePast = Date.parse('today-10years');

		var cdates = $this.getDates(),
			cdateS = (cdates.length > 0)?cdates[0]:dateToday,
			cdateE = (cdates.length > 1)?cdates[1]:cdateS;
			
		if (this.menu === undefined) {
			this.menu = new Ext.menu.Menu( {
				hideOnClick : false,
				focusOnSelect : false
			});

			var obj, singleDate=true, checked, menu = this.menu;
			Ext.each(this.presetDates,function(preset,i){
				if(Ext.isEmpty(preset.dateStart)) {
					return false;
				}
				var importPresetDate = function(date) {
					var result = false;
					if( Ext.isDate(date) ) { result = date; }
					else if( Ext.isString(date) ) { result = Date.parse(date); }
					else if( Ext.isFunction(date) ) { result = date(); }
					return result;
				};
				var startDate = importPresetDate(preset.dateStart);
				var endDate = importPresetDate(preset.dateEnd);
				
				menu.add({
					text: preset.text,
					group:'presetDates',
					checked: checked,
					handler: function(){
						if(!endDate) {
							$this.setValue(startDate);
						}
						else {
							$this.setValue([startDate,endDate]);
						}
						$this.handler(startDate,endDate);
					}
				});
			});
			if(false === Ext.isEmpty(this.presetDates) && false === Ext.isEmpty(this.presets)) {
				menu.add('-');
			}
			Ext.iterate(this.presets,function(key,value){
				checked = false;
				var width, dateMenu;
				switch(key) {
					case 'specificDate':
					case 'allDatesBefore':
					case 'allDatesAfter':
						dateMenu = new Ext.menu.DatePicker({
							maxDate: dateToday,
			                focusOnSelect: false,
							handler: function(p,d){
								var date = d;
								if(key == 'allDatesBefore') { date = [dateBasePast,d]; }
								if(key == 'allDatesAfter') { date = [d,dateToday]; }
								$this.setValue(date);
								
								if(Ext.isArray(date)) {
									$this.handler(date[0],date[1]);
								}
								else {
									$this.handler(date,false);
								}
							}
						});
						switch(key) {
							case 'specificDate': dateMenu.picker.setValue(cdateE); break;
							case 'allDatesBefore': dateMenu.picker.setValue(cdateS); break;
							case 'allDatesAfter': dateMenu.picker.setValue(cdateE); break;
						}
					break;
					case 'dateRange':
						var instanciateDatePickerPanel = function(config,pickerCfg){
							var $this = this;
							this.picker = new Ext.DatePicker(Ext.applyIf({
								internalRender: this.strict || !Ext.isIE,
								ctCls: 'x-daterange-item',
								showToday: false
							},pickerCfg));
							return new Ext.Panel(Ext.applyIf({
								picker: this.picker,
								cls: 'x-daterange-picker-panel',
								width:175,
								items:[ this.picker ]
							},config));
						};

						var p1, p2;
						
						p1 = instanciateDatePickerPanel({ role:'start', title:'From Date' },{maxDate: dateToday});
						p2 = instanciateDatePickerPanel({ role:'end', title:'To Date' },{maxDate: dateToday});

						p1.picker.setMaxDate(cdateE);
						p1.picker.setValue(cdateS);
						p2.picker.setMinDate(cdateS);
						p2.picker.setValue(cdateE);
						
						p1.picker.addListener('select',function(p,d){
							p2.picker.setMinDate(d);
						});
						p2.picker.addListener('select',function(p,d){
							p1.picker.setMaxDate(d);
						});
						
						var dateControls = new Ext.Container({
							cls: 'x-daterange',
							layout: 'column',
							defaults: { style: { margin:0, padding:0 } },
							items: [p1,p2]
						});

						var dateForm = new Ext.form.FormPanel({
							width: 350,
							border: false,
							cls: 'x-daterange-form',
							items:[dateControls],
							buttons: [
								{text:'Cancel',handler:function(){ menu.hide(true); }},
								{text:'Done',handler:function(){
									$this.setValue([p1.picker.getValue(),p2.picker.getValue()]);
									
									menu.hide(true);

									$this.handler(p1.picker.getValue(),p2.picker.getValue());
								}}
							]
						});

						dateMenu = new Ext.menu.Menu({
							plain: true,
							items: [ dateForm ]
						});

					break;
					default:
					break;
				}
				menu.add({ text: value, menu: dateMenu });
			});
		}
		this.onFocus();
		this.menu.show(this.el, "tl-bl?");
	}
});

