/**
 * Layout
 */
var layout;

$(document).ready(function(){
	if ($.blockUI) {
		$.blockUI.defaults = {
			// message displayed when blocking (use null for no message) 
		    message:  '<div id="spinnerElement"><span>process request...</span></div>', 
		 
		    // styles for the message when blocking; if you wish to disable 
		    // these and use an external stylesheet then do this in your code: 
		    // $.blockUI.defaults.css = {}; 
		    css: { 
		        padding:        0, 
		        margin:         0, 
		        top:            '50%', 
		        left:           '50%', 
		        textAlign:      'center', 
		        color:          '#000', 
		        border:         '1px solid #eee', 
		        backgroundColor:'#eee',
		        cursor:         'cursor' 
		    }, 
		 
		    // styles for the overlay 
		    overlayCSS:  { 
		        backgroundColor: '#fff', 
		        opacity:         0.2,
		        cursor:         'cursor'
		    }, 
		 
		    // styles applied when using $.growlUI 
		    growlCSS: { 
		        width:    '350px', 
		        top:      '10px', 
		        left:     '', 
		        right:    '10px', 
		        border:   'none', 
		        padding:  '5px', 
		        opacity:   0.6, 
		        cursor:    null, 
		        color:    '#fff', 
		        backgroundColor: '#000', 
		        '-webkit-border-radius': '10px', 
		        '-moz-border-radius':    '10px' 
		    }, 
		     
		    // IE issues: 'about:blank' fails on HTTPS and javascript:false is s-l-o-w 
		    // (hat tip to Jorge H. N. de Vasconcelos) 
		    iframeSrc: /^https/i.test(window.location.href || '') ? 'javascript:false' : 'about:blank', 
		 
		    // force usage of iframe in non-IE browsers (handy for blocking applets) 
		    forceIframe: false, 
		 
		    // z-index for the blocking overlay 
		    baseZ: 1000, 
		 
		    // set these to true to have the message automatically centered 
		    centerX: true, // <-- only effects element blocking (page block controlled via css above) 
		    centerY: true, 
		 
		    // allow body element to be stetched in ie6; this makes blocking look better 
		    // on "short" pages.  disable if you wish to prevent changes to the body height 
		    allowBodyStretch: true, 
		 
		    // enable if you want key and mouse events to be disabled for content that is blocked 
		    bindEvents: true, 
		 
		    // be default blockUI will supress tab navigation from leaving blocking content 
		    // (if bindEvents is true) 
		    constrainTabKey: true, 
		 
		    // fadeIn time in millis; set to 0 to disable fadeIn on block 
		    fadeIn:  100, 
		 
		    // fadeOut time in millis; set to 0 to disable fadeOut on unblock 
		    fadeOut:  300, 
		 
		    // time in millis to wait before auto-unblocking; set to 0 to disable auto-unblock 
		    timeout: 0, 
		 
		    // disable if you don't want to show the overlay 
		    showOverlay: true, 
		 
		    // if true, focus will be placed in the first available input field when 
		    // page blocking 
		    focusInput: true, 
		 
		    // suppresses the use of overlay styles on FF/Linux (due to performance issues with opacity) 
		    applyPlatformOpacityRules: true, 
		 
		    // callback method invoked when unblocking has completed; the callback is 
		    // passed the element that has been unblocked (which is the window object for page 
		    // blocks) and the options that were passed to the unblock call: 
		    //     onUnblock(element, options) 
		    onUnblock: null, 
		 
		    // don't ask; if you really must know: http://groups.google.com/group/jquery-en/browse_thread/thread/36640a8730503595/2f6a79a77a78e493#2f6a79a77a78e493 
		    quirksmodeOffsetHack: 4 
		};
	}
	
	if($('#body').get(0)) {
		layout = $('#body').layout(layoutSettings);
	}
});

var layoutSettings = {
		
	defaults: {
		size: 'auto',
		spacing_open: 5
	},
	
	north: {
		togglerLength_open: 0,
		resizable: false
	},
	
	south: {
		togglerLength_open: 0,
		resizable: false,
		size: 25
	},
	
	west: {
		spacing_closed: 21,
		togglerLength_open: 45,
		togglerLength_closed: 20,
		togglerAlign_closed: 'top',
		minSize: 150,
		maxSize: 300,
		size: 220,
		resizable: false
	},
	
	east: {
		spacing_closed: 21,
		togglerLength_open: 35,
		togglerLength_closed: 20,
		togglerAlign_closed: 'top',
		minSize: 21,
		maxSize: 100,
		size: 60,
		resizable: false
	},
	
	center: {}
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

/**
 * Accordion
 */
var accordion = {
	setAccordion: function(selector, options) {
		this.options = {
			autoHeight: false,
			collapsible: true,
			navigation: true
		};
		
		$.extend(true, this.options, options || {});
		
		$(selector).accordion(this.options);
	}
};

/**
	Tabs
*/
var tabs = {
	setTabs: function(selector, options) {
		this.options = {
			autoHeight: false,
			collapsible: false,
			navigation: true
		};
		
		$.extend(true, this.options, options || {});
		
		$(selector).tabs(this.options);
	}	
};


$().ready(function(){
	 
		$.datepicker.setDefaults({
			showButtonPanel: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			changeMonth: true,
			changeYear: true,
			constrainInput: true,
			showOn: "both",
			defaultDate: "+0d",
			dateFormat: 'dd/mm/yy', // 2100-01-23
			buttonImage: CPATH+"/css/co/work/calendar.png",
			buttonImageOnly: true
		});
		//$( ".datepicker" ).datepicker();
});