
jQuery(function($){

	$.datepicker.setDefaults({
		showButtonPanel: true,
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		constrainInput: true,
		showOn: "both",
		dateFormat: 'yy-mm-dd', // 2100-01-23
		buttonImage: CPATH+"/resources/images/commonB/icon-calendar.png",
		buttonImageOnly: true
	});
});

	