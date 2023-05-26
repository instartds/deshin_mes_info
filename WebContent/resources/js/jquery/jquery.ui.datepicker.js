/* Korean initialisation for the jQuery calendar extension. */
/* Written by DaeKwon Kang (ncrash.dk@gmail.com). */
/* euc-kr 로 바꾸어 저장함 2011.1.21 by 김상준 */
jQuery(function($){
	$.datepicker.regional['ko'] = {
		closeText: '닫기',
		prevText: '이전달',
		nextText: '다음달',
		currentText: '오늘',
		monthNames: ['1월','2월','3월','4월','5월','6월',
		'7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월',
		'7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		weekHeader: 'Wk',
		dateFormat: 'yy-mm-dd', // 2100-01-23
		firstDay: 0,
		buttonText:"달력",
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: '년'};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
	
	$.datepicker.setDefaults({
		showButtonPanel: true,
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		constrainInput: true,
		showOn: "both",
		buttonImage: "/images/admin/ico_calendar.gif",
		buttonImageOnly: true
	});
});

	