$.extend($.inputmask.defaults.definitions, {
    'f': {
        "validator": "[0-9\(\)\.\+/ ]",
        "cardinality": 1,
        'prevalidator': null
    }
});
$(document).ready(function() {
	// 숫자만 10자리
	$(".mask_int").inputmask({ "mask": "9", "repeat": 9, "greedy": false });
	// 숫자+'.' 10자리
	$(".mask_float").inputmask({ "mask": "F", "repeat": 9, "greedy": false });
	$(".mask_time").inputmask({ "mask": "h:s", "greedy": true });
	
	// 숫자+'.' 5자리
	$(".mask_point").inputmask({ "mask": "f", "repeat": 5, "greedy": false });
	// 전화번호 3자리
	$(".mask_phone3").inputmask({ "mask": "9", "repeat": 3, "greedy": false });
	// 전화번호 4자리
	$(".mask_phone4").inputmask({ "mask": "9", "repeat": 4, "greedy": false });
	// 숫자만 6자리, 주민번호 앞자리 
	$(".mask_number6").inputmask({ "mask": "9", "repeat": 6, "greedy": false });
	// 숫자만 7자리, 주민번호 뒷자리
	$(".mask_number7").inputmask({ "mask": "9", "repeat": 7, "greedy": false });
	// 계좌번호 
	$(".mask_account").inputmask({ "mask": "9", "repeat": 15, "greedy": false });
	// 날자
	$(".mask_date").inputmask({ "mask": "d/m/y", 'autounmask' : false, "greedy": true });	
	// 돈
	$(".mask_money").maskMoney({precision:0,allowZero:true});
	// 숫자만 5자리 
	$(".mask_number5").inputmask({ "mask": "9", "repeat": 5, "greedy": false });
	// 숫자만 4자리 
	$(".mask_number4").inputmask({ "mask": "9", "repeat": 4, "greedy": false });
	// 숫자만 3자리 
	$(".mask_number3").inputmask({ "mask": "9", "repeat": 3, "greedy": false });
//	alert("inputmask");
});