/**
 * Layout
 */

var layoutSettings = {

	defaults : {
		size : 'auto',
		spacing_open : 5
	},

	north : {
		togglerLength_open : 0,
		resizable : false
	},

	south : {
		togglerLength_open : 0,
		resizable : false,
		size : 25
	},

	west : {
		spacing_closed : 21,
		togglerLength_open : 45,
		togglerLength_closed : 20,
		togglerAlign_closed : 'top',
		minSize : 150,
		maxSize : 300,
		size : 220,
		resizable : false
	},

	east : {
		spacing_closed : 21,
		togglerLength_open : 35,
		togglerLength_closed : 20,
		togglerAlign_closed : 'top',
		minSize : 21,
		maxSize : 100,
		size : 60,
		resizable : false
	},

	center : {}
};

$(document).ready(function() {
		$('body').layout(layoutSettings);
//		$('body').layout({ applyDemoStyles: true });

});

/**
 * Accordion
 */
var accordion = {
	setAccordion : function(selector, options) {
		this.options = {
			autoHeight : false,
			collapsible : true,
			navigation : true
		};

		$.extend(true, this.options, options || {});

		$(selector).accordion(this.options);
	}
};

/**
 * Tabs
 */
var tabs = {
	setTabs : function(selector, options) {
		this.options = {
			autoHeight : false,
			collapsible : false,
			navigation : true
		};

		$.extend(true, this.options, options || {});

		$(selector).tabs(this.options);
	}
};



/**
 * DatePicker
 */
var datepicker = {
//	id : '',
//	defaultFromPeroid : '-7d',
//	lastDay: '31/12/2099',
//	firstDay: '01/01/1900',

//	setDefaultSetting : function(id) {
//		$.datepicker.setDefaults( {
//			showOn : 'both',
//			buttonImage : CPATH+ '/js/co/work/calendar.png',
//			buttonImageOnly : true,
//			buttonText : 'Calendar',
//			autoSize : true,
//			changeMonth : true,
//			changeYear : true,
//			showMonthAfterYear : true,
//			minDate : null,
//			maxDate : null,
//			constrainInput: true,
//			showOn: 'button',
//			yearRange: '1900:2099'
//		});
//		
//		this.id = id;
//	},

//	setEvents : function() {
//		$(this.id + ' .datepicker').datepicker( {
//			onSelect : function(dateText) {
//				datepicker.setDateRange(this, dateText);
//			},
//
//			onClose : function(dateText) {
//				datepicker.setDateRange(this, dateText);
//			}
//		});
//	},
//
	setDateRange : function(object, dateText) {
		var instance = $(object).data('datepicker');
		var date = $.datepicker.parseDate(instance.settings.dateFormat ||
				   $.datepicker._defaults.dateFormat, dateText,	instance.settings);

		if ($(object).attr('fromto') == 'from') {
			$(object).nextAll('input').datepicker('option', 'minDate', date);
		} else if ($(object).attr('fromto') == 'to') {
			$(object).prevAll('input').datepicker('option', 'maxDate', date);
		}
	},
//
//	setDateText : function() {
//		$.each($(this.id + ' .datepicker'), function(index, value) {
//
//			var val = $(this).val();
//			if (val) {
//				attr = val;
//			} else {
//				var attr = '+0d';
//				var fromtoAttr = $(this).attr('fromto');
//				var period = $(this).attr('period');
//
//				if (fromtoAttr == 'from') {
//					if (period) {
//						attr = period;
//					} else {
//						attr = datepicker.defaultFromPeroid;
//					}
//				} else if (fromtoAttr == 'to') {
//					if (period) {
//						attr = period;
//					}
//				}
//			}
//
//			if ($(this).attr('displaytext') == 'true' || !$(this).attr('displaytext')) {
//				$(this).datepicker('setDate', attr);
//			}
//
//			datepicker.setDateRange(this, $(this).val());
//		});
//	},

//	setDatePicker : function(id) {
//		$('#' + id + ' .datepicker').mask('99/99/9999');
//		
//		$('#' + id + ' .datepicker').each(function(index, element){
//			$(element).blur(function(){
//				if(!datepicker.validateDateFormat($(this).val())) {
//					$(this).val('');
//				}
//			});
//		});
//		
//		this.setDefaultSetting('#' + id);
//		this.setEvents();
//		this.setDateText();
//	},
	controlDateDef : function(fromId, toId, value) {
		if($('#' + fromId).val() == ''  ) {
			datepicker.controlDate(fromId, toId, value);
		}
	},
	controlDate : function(fromId, toId, value) {
		if(value == 'today'){
			if(fromId){
				$('#' + fromId).datepicker('setDate', new Date());
			}
			$('#' + toId).datepicker('setDate', new Date());
			
		} else if(value == 'unlimited') {
			if(fromId){
				$('#' + fromId).datepicker('setDate', this.firstDay);
			}
			$('#' + toId).datepicker('setDate', this.lastDay);
		} else if(value == 'thisterm') {
			if(fromId){
				$('#' + fromId).datepicker('setDate', '-7d');
			}
			$('#' + toId).datepicker('setDate', '+7d');			
		} else {
			if(!value.indexOf('-')){
				if(fromId){
					$('#' + fromId).datepicker('setDate', value);
				}
				$('#' + toId).datepicker('setDate', new Date());
			}else {
				if(fromId){
					$('#' + fromId).datepicker('setDate', new Date());
				}
				$('#' + toId).datepicker('setDate', value);
			}
		}
		
//		if(fromId){
//			datepicker.setDateRange($('#' + fromId), $('#' + fromId).val());
//		}
//		
//		datepicker.setDateRange($('#' + toId), $('#' + toId).val());
	},

//	disableDatePicker : function(id) {
//		$('#' + id).attr('disabled', 'disabled');
//		$('#' + id).next().attr('disabled', 'disabled');
//		$('#' + id).next().css('cursor', 'default');
//	},
//
//	enableDatePicker : function(id) {
//		$('#' + id).removeAttr('disabled');
//		$('#' + id).next().removeAttr('disabled');
//		$('#' + id).next().css('cursor', 'pointer');
//		$('#' + id).focus();
//	},
//	
//	validateDateFormat: function(dateString) {
//		var dateStr = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2}|\d{4})$/;
//
//		var matchArray = dateStr.exec(dateString); // is the format ok?
//		if (matchArray == null) {
//			return false;
//		}
//
//		var day = matchArray[1]; // parse date into variables
//		var month = matchArray[3];
//		var year = matchArray[4];
//		
//		if (day < 1 || day > 31) {
//			return false;
//		}
//		if (month < 1 || month > 12) { // check month range
//			return false;
//		}
//		if ((month == 4 || month == 6 || month == 9 || month == 11)
//				&& day == 31) {
//			return false;
//		}
//		
//		if (month == 2) { // check for february 29th
//			var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
//
//			if (day > 29 || (day == 29 && !isleap)) {
//				return false;
//			}
//		}
//		return true;
//	}
	sample:function() {
		
	}
};