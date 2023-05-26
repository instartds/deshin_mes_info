
var AlertsUtil = {
		save : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "성공!", 											 // Optional heading to be shown on the toast
			    icon: "success", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 3000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},

		warning : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "경고!", 											 // Optional heading to be shown on the toast
			    icon: "warning", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 3000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},
		error : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "Error!", 											 // Optional heading to be shown on the toast
			    icon: "error", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 3000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},

		info : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "정보", 											 // Optional heading to be shown on the toast
			    icon: "inf", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 3000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},
		kioskWarning_0 : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "정상!", 											 // Optional heading to be shown on the toast
			    icon: "success", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 5000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},
		kioskWarning_1 : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "경고!", 											 // Optional heading to be shown on the toast
			    icon: "warning", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 5000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		},
		kioskWarning_2 : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "불량!", 											 // Optional heading to be shown on the toast
			    icon: "error", 											 // Type of toast icon
			    showHideTransition: 'fade', 								 // fade, slide or plain
			    allowToastClose: true, 										 // Boolean value true or false
			    hideAfter: 5000, 											 // false to make it sticky or number representing the miliseconds as time after which toast needs to be hidden
			    stack: 5, 													 // false if there should be only one toast at a time or a number representing the maximum number of toasts to be shown at a time
			    position: 'top-center', 									  // bottom-left or bottom-right or bottom-center or top-left or top-right or top-center or mid-center or an object representing the left, right, top, bottom values



			    textAlign: 'left',  // Text alignment i.e. left, right or center
			    loader: true,  // Whether to show loader or not. True by default
			    loaderBg: '#9EC600',  // Background color of the toast loader
			    beforeShow: function () {}, // will be triggered before the toast is shown
			    afterShown: function () {}, // will be triggered after the toat has been shown
			    beforeHide: function () {}, // will be triggered before the toast gets hidden
			    afterHidden: function () {}  // will be triggered after the toast has been hidden
			});
		}
}


var ObjUtil = {
	/**
	 * 빈값 체크.
	 * ObjUtil.isEmpty(Object object);
	 */
	isEmpty : function(value){
		if(
			(value == "" && typeof(value) != "number") ||
			value == null 				||
			value == undefined 			||
			( value != null && typeof value == "object" && !Object.keys(value).length ) ){
			return true
		}else{
			return false
		}

	},
	isNumber : function(){
		if(event.code != "Backspace" && event.code != "Tab"
		&& event.code != "ArrowLeft" && event.code != "ArrowDown"
		&& event.code != "ArrowRight" && event.code != "ArrowUp"
		&& event.code != "Home" && event.code != "End"){
			if(event.keyCode < 48 || event.keyCode > 57){
				event.returnValue=false;
			}
		}
	}
}

var StringUtil = {
	padLeft : function(obj, padChar, len) {
		obj = obj.toString();

		var l = obj.length;

		while(l < len) {
			obj = padChar + obj;
			l = obj.length;
		}

		return obj.substring(0, len);
	},
	formatNumber : function(val) {
		return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	},
	formatNumber2 : function(val, point, char) {
		if (typeof point == 'undefined') point = 0;
		if (typeof char == 'undefined') char = ',';
		return $(val).number(true, point, char);
	},
	convertSpcialChar : function(obj) {
		return obj.replace(/\\n/g, "\\n")
		        .replace(/\\'/g, "\\'")
		        .replace(/\\"/g, '\\"')
		        .replace(/\\&/g, "\\&")
		        .replace(/\\r/g, "\\r")
		        .replace(/\\t/g, "\\t")
		        .replace(/\\b/g, "\\b")
		        .replace(/\\f/g, "\\f")
		        .replace(/%/g, "");
	},
	customFormat : function(sType, sVal, sExtra) {
		let sRetVal = "";
		switch(sType)
		{
			case "RESIDENT REGISTRATION NUMBER":
			case "SOCIAL SECURITY NUMBER":
			case "ID CARD NUMBER":
			case "RRN":
			case "SSN":
			case "ICN":
				sRetVal = sVal.replace(/^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/, '$1-$2');
			break;

			case "REG_NUM":
				if(!ObjUtil.isEmpty(sExtra)){
					if(sExtra.length == 1){
						sRetVal = sVal.replace(/(\d{2})(\d{3})(\d{5})/, '$1' + sExtra + '$2' + sExtra + '$3');
					}
				}
				else
					sRetVal = sVal.replace(/(\d{2})(\d{3})(\d{5})/, '$1-$2-$3');
				break;

			case "TIME":
				if(!ObjUtil.isEmpty(sExtra)){
					if(sExtra.length == 1){
						sRetVal = sVal.replace(/(\d{2})(\d{2})(\d{2})/, '$1' + sExtra + '$2' + sExtra + '$3');
					}
				}
				else
					sRetVal = sVal.replace(/(\d{2})(\d{2})(\d{2})/, '$1:$2:$3');
				break;

			case "CARD":
				sRetVal = sVal;
				if(!ObjUtil.isEmpty(sExtra)){
					let arrExtra = sExtra.split("");
					let arrVal = sVal.split("");
					let sNewVal = "";
					for(var i=0; i<arrExtra.length; i++){
						if(arrExtra[i] == 0)
							sNewVal += arrVal[i];
						else
							sNewVal += arrExtra[i];
					}
					sRetVal = sNewVal.substring(0, 4) + "-" + sNewVal.substring(4, 8) + "-" + sNewVal.substring(8, 12) + "-" + sNewVal.substring(12, 16);
				}
				else
					sRetVal = sNewVal.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '$1-$2-$3-$4');
				break;

			case "NUM":
			case "NUMBER":
				//sRetVal = sVal.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				let sep = (typeof sExtra == "undefined") ? "," : sExtra;
				let regx = new RegExp(/(-?\d+)(\d{3})/);
				let bExists = (typeof sVal == "string") ? sVal.indexOf(".", 0) : sVal.toString().indexOf(".", 0);//0번째부터 .을 찾는다.
				let strArr = (typeof sVal == "string") ? sVal.split('.') : sVal.toString().split('.');
				if (bExists > -1) {
					if (strArr[1] == 0)
						sRetVal = strArr[0];
					else
						sRetVal = strArr[0] + "." + strArr[1];
				} else { //정수만 있을경우 //소수점 문자열 존재하면 양수 반환
					sRetVal = strArr[0];
				}
				while (regx.test(sRetVal)) {//문자열에 정규식 특수문자가 포함되어 있는지 체크
					//정수 부분에만 콤마 달기
					sRetVal = sRetVal.replace(regx, "$1" + sep + "$2");//콤마추가하기
				}
				break;

			case "TEL":
			case "PHONE":
				if(sVal.length==11){
					if(!ObjUtil.isEmpty(sExtra)){
						sRetVal = sVal.replace(/(\d{3})(\d{4})(\d{4})/, '$1-' + sExtra + sExtra + sExtra + sExtra + '-$3');
					}else{
						sRetVal = sVal.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
					}
				}else if(sVal.length==8){
					sRetVal = sVal.replace(/(\d{4})(\d{4})/, '$1-$2');
				}else{
					if(sVal.indexOf('02')==0){
						if(!ObjUtil.isEmpty(sExtra)){
							sRetVal = sVal.replace(/(\d{2})(\d{4})(\d{4})/, '$1-' + sExtra + sExtra + sExtra + sExtra + '-$3');
						}else{
							sRetVal = sVal.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
						}
					}else{
						if(!ObjUtil.isEmpty(sExtra)){
							sRetVal = sVal.replace(/(\d{3})(\d{3})(\d{4})/, '$1-' + sExtra + sExtra + sExtra + '-$3');
						}else{
							sRetVal = sVal.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
						}
					}
				}
				break;
			default : break;
		}

		return sRetVal;
	}
}

var DateUtil = {
	/**
	 * 날짜 변환 함수
	 * DateUtil.toString(dt, "yyyy.MM.dd")
	 */
	toString : function(dt, format) {
		var rv;
		var d;
		var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일", "월", "화", "수", "목", "금", "토"];

		if(format == null || typeof format == "undefined") {
			format = "yyyy.MM.dd";
		}

		if(typeof dt == "string") {
			dt = dt.replace(/(-|\.|\/)/gi, "");
			dt = dt.substring(0, 4) + "-" + dt.substring(4, 6) + "-" + dt.substring(6, 8);

			d = new Date(dt);
		}
		else {
			d = new Date(dt);
		}

		rv = format.replace(/(yyyy|yy|MM|M|dd|d|DD|D|HH|hh|mm|ss|T|t)/gi, function($1) {
			switch ($1) {
				case "yyyy" : return String(d.getFullYear());
				case "yy"	: return String(d.getFullYear()).substring(2, 4);
				case "MM"	: return StringUtil.padLeft((d.getMonth() + 1), "0", 2);
				case "M"	: return String(d.getMonth() + 1);
				case "dd"	: return StringUtil.padLeft(d.getDate(), "0", 2);
				case "d"	: return String(d.getDate());
				case "DD"	: return weekName[d.getDay()];
				case "D"	: return weekName[d.getDay() + 7];
				case "HH"	: return StringUtil.padLeft(d.getHours(), "0", 2);
				case "hh"	: return StringUtil.padLeft(d.getHours() % 12, "0", 2);
				case "mm"	: return StringUtil.padLeft(d.getMinutes(), "0", 2);
				case "ss"	: return StringUtil.padLeft(d.getSeconds(), "0", 2);
				case "T"	: return (d.getHours() < 12 ? "오전" : "오후");
				case "t"	: return (d.getHours() < 12 ? "AM" : "PM");
				default		: return $1;
			}
		});

		return rv;
	},


	/**
	 * 날짜 변환 함수 : 리턴 타입은 기본 "yyyyMMdd"
	 * DateUtil.toString(dt)
	 */
	toFormattedString : function(dt, delimiter) {
		var rv;

		if(delimiter == null || typeof delimiter == "undefined") {
			delimiter = "";
		}

		if(typeof dt == "string") {
			rv = dt.replace(/-/gi, "");
		}
		else {
			var newDt = new Date(dt);
			var yy = String(newDt.getFullYear());
			var mm = String(newDt.getMonth() + 1);
			var dd = String(newDt.getDay());

			rv = yy + (mm.length == 1 ? "0" + mm : mm) + (dd.length == 1 ? "0" + dd : dd);
		}

		rv = rv.substring(0, 4) + delimiter + rv.substring(4, 6) + delimiter + rv.substring(6, 8);

		return rv;
	},

	/**
	 * 날짜 반환 함수 : 오늘
	 * DateUtil.today()
	 */
	today : function(format) {
		var dt = new Date();

		if(format == null || typeof format == "undefined") {
			return dt;
		}
		else {
			dt = this.toString(dt, format);
		}

		return dt;
	},

	/**
	 * 날짜 반환 함수 : 차이(일)
	 * DateUtil.today()
	 */
	getDaysBetween : function(frDate, toDate) {
		if(toDate == null || typeof toDate == "undefined") {
			toDate = this.today();
		}

		frDate = new Date(this.toString(frDate, "yyyy-MM-dd"));
		toDate = new Date(this.toString(toDate, "yyyy-MM-dd"));

		var diff = (toDate - frDate) / 24 / 60 / 60 / 1000;

		return diff;
	},

	/**
	 * String to Date
	 * DateUtil.getDate("yyyyMMdd")
	 */
	getDate : function(sDate) {
		return new Date(sDate.substr(0,4), sDate.substr(4,2) -1, sDate.substr(6,2));
	}
}

// 공통화과정에서 다른 js파일내용과 충돌로 인한 명칭 변경
//var DB = {
var DataUtil = {
	getCommonCodeList : function(compCode,mainCode){
		var me = this;

		//var ajaxUrl 	= "/cms/common/getCode.do";
		var ajaxUrl 	= CPATH+"/api/pda/common/getCommonCodeList";
		var ajaxData 	= {'compCode':compCode ,'mainCode' : mainCode};
		var ajaxloding	= false;
		var returnCode;
		var ajaxCallback= function (data) {
			returnCode = data;
		}
		var type = 'GET';

		me.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);

		return returnCode;
	},
	
	
	ajax : function(url, param, boolLoadingVar, fnCallBack, callBackData,type){

	    $.ajax({
	      url     		: url,
	      type    		: type,
	      data    		: param,
	      async     	: false,
	      loadingVar  	: boolLoadingVar,
	      callBack  	: fnCallBack,
	      beforeSend  	: function(){
	        if (boolLoadingVar){

	        	UI.loadingVar.show();
	        }
	      },
	      complete  : function(){
	        if (boolLoadingVar)
	          UI.loadingVar.hide();
	      },
	      success   : function(data){
	      if(typeof(fnCallBack) == "function")
	    	  	fnCallBack(data);
	      },
	      error   : function(jqXHR, textStatus, errorThrown){
	        console.error(jqXHR, textStatus, errorThrown);
	      }
	    });
	},
	
	
	
		/**
		 * 공통코드 조회
		 * DB.getCode("A01");
		 */
	getCode : function(code){
		var me = this;

		//var ajaxUrl 	= "/cms/common/getCode.do";
		var ajaxUrl 	= "./getCode.do";
		var ajaxData 	= {'CODE' : code};
		var ajaxloding	= false;
		var returnCode;
		var ajaxCallback= function (data) {
			returnCode = data;
		}

		me.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode);

		return returnCode;
	},

	getCompanyCode : function(companyNo,code){
		var me = this;

		//var ajaxUrl 	= "/cms/common/getCompanyCode.do";
		var ajaxUrl 	= "./getCompanyCode.do";
		var ajaxData 	= {'COMPANY_NO' : companyNo, 'CODE' : code};
		var ajaxloding	= false;
		var returnCode;
		var ajaxCallback= function (data) {
			returnCode = data;
		}

		me.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode);

		return returnCode;
	},
	getCustomCode : function(strCode, strName, strTable, arrCond){

		let arrData = [];
		arrData.push["CODE"] = strCode;
		arrData.push["NAME"] = strName;
		arrData.push["TABLE"] = strTable;
		arrData.push["COND"] = arrCond;

		var ajaxUrl 	= "/cms/common/getCustomCode.do";
		var ajaxData 	= arrData;
		var ajaxloding	= false;
		var returnCode;
		var ajaxCallback= function (data) {
			returnCode = data;
		}

		this.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode);

		return returnCode;
	}
	
}

var UI = {
	append 	: function(loc, shtml){
		$(loc).append(shtml);
	},

	loadingVar : {
		set : function(){
			var maskHeight = $(document).height();
			var maskWidth = window.document.body.clientWidth;
			var mask = "<div id='mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
			var loadingImg = '';
			loadingImg += "<div id='loadingImg' style='position:absolute; left:50%; top:40%; display:none; z-index:10000;'>";
			loadingImg += " <img width='150px;' height='150px;' src='/cms/resources/images/cms/ajax-loader.gif'/>";


			loadingImg += "</div>";

			$('body').append(mask).append(loadingImg);
			$('#mask').css({
				'width' : maskWidth
				,'height': maskHeight
				,'opacity' : '0.3'
				});

			//
		},
		show : function(){
			$('#mask').show();
			$('#loadingImg').show();
		},
		hide : function(){
			$('#mask, #loadingImg').hide();
		}


	}
}
