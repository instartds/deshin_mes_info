//@charset UTF-8
/**
 * 
 */
Ext.define('Unilite.com.UniValidator',{
    alternateClassName: ['UniValidator'],
    singleton: true
    
    // 주민등록번호
    ,residentno : function(value) {
	    var pattern = /^(\d{6})-?(\d{5}(\d{1})\d{1})$/;
	    var num = value;
	    var errorMsg = "residentno";
	    if (!pattern.test(num)) return errorMsg;
	    num = RegExp.$1 + RegExp.$2;
	    if (RegExp.$3 == 7 || RegExp.$3 == 8 || RegExp.$4 == 9)
	        if ((num[7]*10 + num[8]) %2) return errorMsg;
	
	    var sum = 0;
	    var last = num.charCodeAt(12) - 0x30;
	    var bases = "234567892345";
	    for (var i=0; i<12; i++) {
	        if (isNaN(num.substring(i,i+1))) return errorMsg;
	        sum += (num.charCodeAt(i) - 0x30) * (bases.charCodeAt(i) - 0x30);
	    };
	    var mod = sum % 11;
	    if(RegExp.$3 == 7 || RegExp.$3 == 8 || RegExp.$4 == 9)
	        return (11 - mod + 2) % 10 == last ? true : errorMsg;
	    else
	        return (11 - mod) % 10 == last ? true : errorMsg;
	}
	,bizno : function(value) {
	    var pattern = /([0-9]{3})-?([0-9]{2})-?([0-9]{5})/;
	    var num = value;
	    var errorMsg = "bizno";
	    if (!pattern.test(num)) return errorMsg;
	    num = RegExp.$1 + RegExp.$2 + RegExp.$3;
	    var cVal = 0;
	    for (var i=0; i<8; i++) {
	        var cKeyNum = parseInt(((_tmp = i % 3) == 0) ? 1 : ( _tmp  == 1 ) ? 3 : 7);
	        cVal += (parseFloat(num.substring(i,i+1)) * cKeyNum) % 10;
	    };
	    var li_temp = parseFloat(num.substring(i,i+1)) * 5 + "0";
	    cVal += parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2));
	    return parseInt(num.substring(9,10)) == (10-(cVal % 10))%10 ? true : errorMsg;
	}
	,phone : function(value) {	
	    var errorMsg = "phone";
	    var pattern = /^(0[2-8][0-5]?|01[01346-9])-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var pattern15xx = /^(1544|1566|1577|1588|1644|1688)-?([0-9]{4})$/;
	    var num = value ;
	    return pattern.test(num) || pattern15xx.test(num) ? true : errorMsg;
		/*
	    var pattern = /^([0-9]+)([0-9|-]*)([0-9]+)$/;
	    var num = value ;
	    return pattern.test(num) ? true : false;
	    */
	}
	// 집전화 
	,homephone : function(value) {
	    var errorMsg = "homephone";
	    var pattern = /^(0[2-8][0-5]?)-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var pattern15xx = /^(1544|1566|1577|1588|1644|1688)-?([0-9]{4})$/;
	    var num = value;
	    return pattern.test(num) || pattern15xx.test(num) ? true : errorMsg;
	}
	// 휴대폰
	,handphone : function(value) {
	    var errorMsg = "handphone";
	    var pattern = /^(01[01346-9])-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
	    var num = value;
	    return pattern.test(num) ? true : errorMsg;
	}
	,isDate : function(value) {
	    var errorMsg = "isDate";
	    var value = value;
	    var t = value.replace(/-/g, "");
	    var chk = this._validateDate(t)
	    return (chk) ? true :  errorMsg;
	}
	/*************************
	 * 
	 * @param {} parsedDate
	 * @return {Boolean}
	 */
	,_validateDate :function(parsedDate) {
		var day, month, year;
		if (parsedDate.length != 8) {
			return false;
		}
		try {
			year = parsedDate.substr(0, 4);
			month = parsedDate.substr(4, 2);
			day = parsedDate.substr(6, 2);
			
			var dt = new Date( month + "/" + day + "/" + year );
			
			if (month != dt.getMonth()+1)
				return false;
			if (day != dt.getDate())
				return false;
			if (year != dt.getFullYear())
				return false;
			return true;
		} catch (e) {
			return false;
		}
	}
});

