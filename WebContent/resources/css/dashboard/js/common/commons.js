if (!window.addNamespace) {
	
	window.addNamespace = function( ns ) {
		var nsParts = ns.split( "." );
		var root = window;
		for( var nIndex = 0; nIndex < nsParts.length; nIndex++ ) {
			if ( typeof( root[nsParts[nIndex]] ) == "undefined" ) root[nsParts[nIndex]] = {};
			root = root[nsParts[nIndex]];
		}
	};
}

/**
 * 날짜형 여부
 * @author 조은상
 */
String.prototype.isDate = function() {

    var date = "" + this;
    
    date = date.replace(/\/|\-/g, "");
    if (date.length != 8) return false;
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var min_year = 1900;
    
    
    // 월체크
    var m = parseInt(month, 10);
    var is = (m >= 1 && m <= 12);

    //일자 체크
    if (is) {
        m = parseInt(month, 10) - 1;
        var d = parseInt(day, 10);
        var end = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            end[1] = 29;
        }

        is = (d >= 1 && d <= end[m]);
    }

    if (is) {
        is = parseInt(year, 10) >= min_year;
    }
    
    return is;
    
};


/**
 * 문자열 길이 리턴 (한글은 3 바이트로 계산)
 * @author 조은상
 */
String.prototype.getLength = function() {
    
    var len = 0;
    for (var i=0; i<this.length; i++) {
        chrCode = this.charCodeAt(i);
        if (chrCode > 128) 
            len=len+3;
        else
            len++;
    }
    return len;
    
};


/**
 * 숫자여부
 * @author 조은상
 */
String.prototype.isNumeric = function() {

    var val = this;
    
    if (val) {
        val = val.replace(/,/g,"");
        val =  parseInt(val);
        if (val == NaN)
            return false;
        else
            return true;
    }
    else
        return false;
};


/**
 * Date 포멧처리된 문자열로 리턴
 * @param format
 * @returns {String}
 */
Date.prototype.toFormatString = function(format) {
	
	//TODO format 처리부분 필요
	
	var y = this.getFullYear().toString();
	var M = (this.getMonth()+1).toString();
	var d  = this.getDate().toString();
	var h = this.getHours().toString();
	var m = this.getMinutes().toString();
	var s = this.getSeconds().toString();
	M = (M[1]?M:"0"+M[0]);
	d = (d[1]?d:"0"+d[0]);
	h = (h[1]?h:"0"+h[0]);
	m = (m[1]?m:"0"+m[0]);
	s = (s[1]?s:"0"+s[0]);
	
	if(format == "yyyy-MM-dd") {
		return y + "-" + M + "-" + d;
	}else if(format == "yyyy.MM.dd") {
		return y + "." + M + "." + d;
	}else {
		return y + "-" + M + "-" + d + " " + h + ":" + m + ":" + s;
	}
	
	
};

/**
 * 오늘 날짜 출력
 * @returns {String}
 */
Date.prototype.getCurrentDate = function() {
    var d = new Date();
    var s =
    	String.prototype.fillZeros(d.getFullYear(), 4) + '-' +
    	String.prototype.fillZeros(d.getMonth() + 1, 2) + '-' +
    	String.prototype.fillZeros(d.getDate(), 2);
    return s;
};

Date.prototype.dateAdd = function(sDate, nDays) {
	var yy = parseInt(sDate.substr(0, 4), 10);
    var mm = parseInt(sDate.substr(5, 2), 10);
    var dd = parseInt(sDate.substr(8), 10);
 
    d = new Date(yy, mm - 1, dd + nDays);
 
    yy = d.getFullYear();
    mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;
 
    return '' + yy + '-' +  mm  + '-' + dd;
};

/**
 * 한자리수 날짜 0 append
 * @returns {String}
 */
String.prototype.fillZeros = function(n, digits) {  
    var zero = '';  
    n = n.toString();  

    if(n.length < digits) {  
        for (var i = 0; i < digits - n.length; i++){
        	zero += '0';  
        } 
    }  
    return zero + n;  
};  

/**
 * 숫자 포멧(0,000.00) 처리된 문자열로 리턴  
 * @param digits 소수점 처리-버림처리, 0이거나 값이 없는 경우는 콜론(,)만 처리
 * @returns {String}
 */
Number.prototype.toFormatString = function(digits) {
	//if(this==0) return 0;
    
    var reg = /(^[+-]?\d+)(\d{3})/;
    var s = (this + '');
    
    if(digits) {
    	var p = Math.pow(10, digits);	// 10의 제곱 
        var n  = Math.floor(this * p) / p;	//버림 처리
    	s = n.toFixed(digits);
    	
    }
    
	while (reg.test(s)) s = s.replace(reg, '$1' + ',' + '$2');
	return s;
};

window.addNamespace("dr");
dr.gnb = function(reqUrl) {

	//현재 메뉴 알아내고 선택 처리
	var link = $("#gnb div.submenu a[href='" + reqUrl + "']");

	if(link.length > 1) {
		link = link.eq(0);
	} else if(link.length == 0) {
		//현재 없으면 '/' 이하 버리고 유사한 링크 찾기
		var reqUrl = reqUrl.substring(0, reqUrl.lastIndexOf("/"));
		link = $("#gnb div.submenu a[href^='" + reqUrl + "']");
		if(link.length > 1) link = link.eq(0);
	}

	
	if(link.length > 0) {
		var submenu = link.parent();
		if(link.parent().parent().parent().is(".depth")) {
			submenu = link.parent().parent().parent();	// 3단 메뉴가 있다면 subment parent() + parent()
		}
		submenu.addClass("on").parent().parent().parent().addClass("on");
	}
	
	
	//메뉴 액션 처리
	var selGnb = $("li.menu").index($("#gnb li.menu.on"));	//선택 메뉴
	
	$("#gnb li.menu.on div.submenu").show();
	$("#gnb li.menu")
		.mouseenter(function() {
			
			if($(this).is(".on")) return;
			$("#gnb li.menu.on").removeClass("on").find(".submenu").hide();
			$(this).addClass("on").find(".submenu").fadeIn();
			
		})
		.mouseleave(function() {
			
			if(selGnb == $("li.menu").index($(this))) return;
			
			$(this).removeClass("on").find(".submenu").fadeOut(function() {
				if($("#gnb li.menu.on").length==0) $("#gnb li.menu").eq(selGnb).addClass("on").find(".submenu").show();
			});
		});
	
	$("#gnb div.submenu li.depth")
	.mouseenter(function() {
		$(this).find("ul").show();
		
	})
	.mouseleave(function() {
		$(this).find("ul").hide();
	});
	

};



window.addNamespace("dr.common.chart");

/**
 * 차트 기본 옵션 리턴
 *
 * @param chartType 차트종류('spline')
 * @author 조은상
 */ 
dr.common.chart.getDefaultOptions = function(chartType) {
	if(!chartType) chartType = "spline";
	return  {
		chart: { type: chartType },
		tooltip: { crosshairs: true, shared: true},
		plotOptions: {
	        spline: {
		        marker: { radius: 2 }, lineWidth: 1, states: { hover: { lineWidth: 1 } }, threshold: null
	        }
		}
		
		
	};
	
};


window.addNamespace("dr.common.ui");

/**
 * 메시지 박스
 * 
 * 	dr.common.ui.alert("메시지");
 * 	dr.common.ui.alert({message:'메시지',onClose:function() { } });
 * 	dr.common.ui.alert({title:'제목',message:'메시지',onClose:function() { } });
 *
 * @param options 메시지
 * @author 조은상
 */ 
dr.common.ui.alert = function(options) {
	
	
	var dialog = $("#c_dialog");
	
	if(typeof(options)=="string") {
		dialog.find("h2").html("알림");
		dialog.find(".txt").html(options);
	} else {
		dialog.find("h2").html(options.title?options.title:"알림");
		dialog.find(".txt").html(options.message);
	}
	
	dialog.find(".btn_red").unbind("click").click(function() {
		$.unblockUI();
		if(options.onClose) options.onClose();
	});
	dialog.find(".btn_gray").hide();
	
	$.blockUI({ 
		message: dialog,
		css : { width : 500, height : 200 },
	});
	
};
/**
 * 메시지 박스
 *
 * @param opts.title 타이틀
 * @param opts.message 메시지
 * @param opts.onSelected 선택 callback
 * @author 조은상
 */ 
dr.common.ui.confirm = function(opts) {
	
	var dialog = $("#c_dialog");
	
	if(typeof(opts)=="string") {
		dialog.find("h2").html("확인");
		dialog.find(".txt").html(opts);
	} else {
		dialog.find("h2").html(opts.title?opts.title:"확인");
		dialog.find(".txt").html(opts.message);
	}

	dialog.find(".btn_red").show().unbind("click").click(function() {
		
		$.unblockUI({
			onUnblock: function() {
				if(opts.onSelected) opts.onSelected(true);
			} 
		});
		
	});
	dialog.find(".btn_gray").show().unbind("click").click(function() {
		$.unblockUI({
			onUnblock: function() {
				if(opts.onSelected) opts.onSelected(false);//취소
			} 
		});
		
	});
	
	$.blockUI({ 
		message: dialog,
		css : { width : 500, height : 200 }
	});	

	
	
};
/**
 * confirm Queue
 * 
 * @param opts.condition : confirm 창 오픈 조건 (0:skip, 1:open, -1:전체 stop)
 * @param opts.message : 메시지
 * @param opts.onYes : 사용자 확인선택 callback
 * @param callback : 완료 callback
 * @author 조은상
 */
dr.common.ui.confirmQ = function(opts, callback, index) {
	
	if(!opts) callback(false, -1);
	if(!index) index = 0;
	
	var val = opts[index];
	if(val.condition) {
		var c = val.condition();
		if(c == 1) {
			
			dr.common.ui.confirm({
				message: val.message, 
				onSelected: function(sel) {
					if(sel) {
						if(val.onYes) {
							val.onYes();
						}
						index++;
						if(index < opts.length) {
							return dr.common.ui.confirmQ(opts, callback, index);
						} else {
							if(callback) callback(true, index-1);
							return false;
						}
					} else {
						if(callback) callback(false, index);
						return false;
					}
				}
			});
			
		} else if(c == 0) {
			
			index++;
			if(index < opts.length) {
				return dr.common.ui.confirmQ(opts, callback, index);
			} else {
				if(callback) callback(true, index-1);
				return false;
			}
			
		} else {
			
			if(callback) callback(false, index);
		}
		
	}
	
};
/**
 * prompt
 *
 * @param opts.title 타이틀
 * @param opts.ok 확인 버튼 문구
 * @param opts.cancel 취소 버튼 문구
 * @param opts.maxlength 텍스트박스 최대문자길이
 * @param opts.onSelected 선택 callback
 * @author 조은상
 */ 
dr.common.ui.prompt = function(opts) {
	
	var dialog = $("#c_dialog");
	var inputBox = $('<input>').attr({'type':'text','class':'type-text'}).css('width','80%');
	var orgBtnTxtArr = {
			ok: dialog.find(".btn_red").text(),
			cancel: dialog.find(".btn_gray").text()
		};
	
	if(typeof(opts)=="string") {
		dialog.find("h2").html(opts);
		dialog.find(".btn_red").html("확인");
		dialog.find(".btn_gray").html("취소");
		dialog.find(".txt").html(inputBox);
	} else {
		dialog.find("h2").html(opts.title?opts.title:"입력");
		dialog.find(".btn_red").html(opts.ok?opts.ok:"확인");
		dialog.find(".btn_gray").html(opts.cancel?opts.cancel:"취소");
		dialog.find(".txt").html(opts.msg? opts.msg : $(inputBox).attr('maxlength', opts.maxlength?opts.maxlength:''));
	}

	dialog.find(".btn_red").show().unbind("click").click(function() {
		$.unblockUI({
			onUnblock: function() {
				resetBtnText();
				if(opts.onSelected) opts.onSelected(true, $.trim(dialog.find('input').val()));
			} 
		});
		
	});
	dialog.find(".btn_gray").show().unbind("click").click(function() {
		$.unblockUI({
			onUnblock: function() {
				resetBtnText();
				if(opts.onSelected) opts.onSelected(false);//취소
			} 
		});
		
	});
	
	$.blockUI({ 
		message: dialog,
		css : { width : 500, height : 200 }
	});
	
	function resetBtnText(){
		dialog.find(".btn_red").html(orgBtnTxtArr.ok);
		dialog.find(".btn_gray").html(orgBtnTxtArr.cancel);
	}
};

/**
 * waitbar 열기
 *
 * @param message 메시지
 * @author 조은상
 */ 
dr.common.ui.waitbar = function(message) {
	if(!message) message = "처리 중입니다. 잠시만 기다리세요.";
	$.blockUI({
	    message: "<div class=\"waitbar\"><img src=\"" + CONTEXT_ROOT + "resources/img/loading.gif\"><p>" + message + "</p></div>"
	});
	
};

/**
 * waitbar 닫기
 *
 * @author 조은상
 */ 
dr.common.ui.unWaitbar = function() {
	$.unblockUI();
};

/**
 * 팝업
 *
 * @param opts 메시지 or 옵션
 * @author 조은상
 */ 
dr.common.ui.popup = function(opts) {
	
	if(!opts.type) opts.type = "iframe";
	$.fancybox.open(opts);
	
};

/**
 * pager 초기화
 *
 * @param pager  pager jquery 객체
 * @param callback  callback 함수
 * @author 조은상
 */
dr.common.ui.pager = function($pager, callback) {
	
	var pager = new Pager($pager);
	
	$.pager.invoke(pager,pager.buttons.pages.eq(0).text("1"), callback);
	
};

window.addNamespace("dr.common.ui.combo");
/**
 * 콤보 ajax 처리
 *
 * @param opts.selector : 콤보 selector
 * @param opts.isAll : 전체 추가 여부 (선택값 : *)
 * @param opts.url : json 요청 URL
 * @param opts.handle : 행(option 태그) 처리 handler
 * 
 *  사용예
 * 	dr.common.ui.combo.ajax({
 * 		selector : "#cboCode",
 * 		isAll : true,
 * 		url : "<c:url value="/samples/list/"/>" + $(obj).val() + "/json",
 * 		handle: function(row) {
 * 			return { code: row.comm_sub_cd, name: row.comm_nm };
 * 		}
 * 	});
 */
dr.common.ui.combo.ajax = function(opts) {
	
	var $combo = $(opts.selector).wait();
	if(!opts.isAll) opts.isAll = false;
	
	opts.success = function(resp) {
		
		$combo.unWait();
		if(resp.code == 0) {
			$combo.html("").prev().find("strong").text("");
			if(opts.isAll) $("<option>").attr("value","*").html("전체").appendTo($combo);
			
			resp.data[0].forEach(function(row, i) {
				if(opts.handle) {
					var c = opts.handle(row);
					$("<option>").attr("value",c.code).html(c.name).appendTo($combo);
					
				}
			});
			
			$combo.prev().find("strong").text($combo.find("option:selected").text());
		} else {
			dr.common.ui.alert(resp.message);
		}
	};
	
	$.ajax(opts);
	
};


/**
 * 콤보 추가
 * 
 * 	dr.common.ui.combo.set({
 * 		selector : "#cboCode",
 * 		data : [{code:"*", name: "지역"},{code:"1", name: "서울"},{code:"2", name: "부산"} ]
 * 	});
 */
dr.common.ui.combo.set = function(opts) {

	var $combo = $(opts.selector);
	$combo.html("").prev().find("strong").text("");
	
	opts.data.forEach(function(row, i) {
		
		$("<option>").attr("value",row.code).html(row.name).appendTo($combo);
	});
	
	$combo.prev().find("strong").text( $combo.find("option:selected").text());
};

/**
 * PDF 다운로드
 * 
 */
dr.common.ui.pdf = function(opts) {
	
	var iframe = $(opts.selector + " iframe");
	
	var reqUrl = CONTEXT_ROOT + "platform/pdf?uri=" + opts.uri;
	if(opts.fileName) reqUrl += "&name=" + opts.fileName;
	
	if(iframe.length == 0) {
		iframe = $("<iframe>").appendTo($(opts.selector).html("")).css("width","100%").css("height","800px");
	}
	$(opts.selector).wait();
	
	iframe.attr("src",reqUrl).unbind("load").load(function() {
		$(opts.selector).unWait();
	});
	
};



window.addNamespace("dr.common.func");
/**
 * null 조정
 *
 * @param v 값
 * @author 조은상
 */ 
dr.common.func.fixNull = function(v) {
	if(v) return v;
	else return "";
};

/**
 * null check
 * @param obj
 * @returns {Boolean}
 */
dr.common.isNull = function(obj) {
	if(obj == null || obj == "undefined"  || obj == "" ) {
		return true;
	}
	else {
		return false;
	}
};


/**
 * ie8 에서 forEach 사용가능하게 처리.
 * @param 
 * @returns
 */
if (!Array.prototype.forEach) {
	Array.prototype.forEach = function (fn, scope) {  
		for (var i = 0, len = this.length; i < len; ++i) {  
			fn.call(scope || this, this[i], i, this);  
		}  
	}  
}  


(function($) {

	if($.datepicker) {
		$.datepicker._defaults.buttonImage = CONTEXT_ROOT + 'resources/img/ico_calendar.png';
		$.datepicker._defaults.showOn = "both";
		$.datepicker._defaults.buttonText = "날짜선택";
		$.datepicker._defaults.showButtonPanel = true;
	}
	
	if($.blockUI) {
		$.blockUI.defaults.css.border = "";
		$.blockUI.defaults.css.backgroundColor = "transparent";
	}
	
	if($.fancybox) {
		$.fancybox.defaults.padding = 0;
		$.fancybox.defaults.autoSize = false;
		$.fancybox.defaults.closeBtn = false;
		$.fancybox.defaults.autoHeight = false;
		$.fancybox.defaults.iframe.scrolling = "no";
		$.fancybox.defaults.padding = 0;
		$.fancybox.defaults.scrolling = "no";
	}

	
	$.date = {
			
		format : function() {
			
    		var ar = this.value.replace(/-/gi, "");
    		ar = ar.replace(/-/gi, "");
    		if(ar) {
        		var d = "";
        		for(var i=0;i<ar.length;i++) {
        			if(i==4 || i==6) d+="-";
        			d += ar[i];
        		}
        		
        		try {
        			$.datepicker.parseDate( $.datepicker._defaults.dateFormat, d);
        			this.value = d;
        		} catch(e) {
        			this.value = "";
        		}
    		}
			
		}
			
	};
		
    $.fn.date = function() {
	    	
    	$(this).datepicker().attr("maxlength", "10");
    	
    	
        return this.each(function() {
        	
        	var allow = [8,9,13,37,38,39,40,46,189];
        	
        	$(this)
        		.css("text-align", "center")
        		.css("ime-mode", "disabled")
       			.keydown(function(event) {
       				if(event.which >= 48 && event.which <= 57 && !isNaN(event.target.value)) {}
       				else if(event.which >= 96 && event.which <= 105 && !isNaN(event.target.value)) {}
       				else {
       					var pass = false;
       					for(var i=0;i<allow.length;i++ ) {
       						pass = (allow[i] == event.which);
       						if(pass) break;
       					}
       					if(!pass) {
           					event.preventDefault();
           					return false;
       					}
       					
       				}
       			})
       			.focus(function() {
       				if(this.value) {
           				this.value = this.value.replace(/-/gi, "");
           				this.select();
       				}
       			})
       			.blur($.date.format)
       			.change($.date.format);
        	
        	
        });
    	
    };
	    
    $.number = {
    	digits : 0,
    	format : function() {
    		
				var v = this.value.replace(/,/gi, "");
				if(v) {
					var n;
					if(v.isNumeric()) {
						n = Number(parseFloat(v));
					}
					this.value = n.toFormatString($.number.digits);
				}
    		
    	}
    	
    };
	
    $.fn.number = function(degits) {
    	
    	if(degits) $.number.digits = degits;
    	
        return this.each(function() {
        	
        	var allow = [8,9,13,37,38,39,40,46,190];
        	
        	$(this)
        		.css("text-align", "right")
        		.css("ime-mode", "disabled")
       			.keydown(function(event) {
       				if(event.which >= 48 && event.which <= 57 && !isNaN(event.target.value)) {}
       				else if(event.which >= 96 && event.which <= 105 && !isNaN(event.target.value)) {}
       				else {
       					var pass = false;
       					for(var i=0;i<allow.length;i++ ) {
       						pass = (allow[i] == event.which);
       						if(pass) break;
       					}
       					if(!pass) {
       						event.preventDefault();
       						return false;
       					}
       				}
       			})
       			.focus(function() {
       				this.value = this.value.replace(/,/gi, "");
       				this.select();
       				this.focus();
       			})
       			.blur($.number.format)
       			.change($.number.format);
       			
       	});
	};    
    

	
	$.wait = {
		blockTags : ["DIV","TABLE"],
		isBlockUI : function($this) {
			
			var tagName = $this.prop("tagName");
			blockUI = false;

			this.blockTags.forEach(function(tag) {
    			if(tag == tagName) {
    				blockUI = true;
    				return;
    			};
				
			});
    		
    		return blockUI;
    		
		}
		
	
	};
    $.fn.unWait = function() {

    	return this.each(function() {
        	
        	var obj = $(this);
        	
        	if($.wait.isBlockUI(obj)) {
        		
        		obj.unblock();
        		
        	} else {
        		
        		if(obj.prop("tagName") == "SELECT") obj = $(this).prev();
        		
        		obj.removeClass("loading");
        		obj.removeClass("small");
        	}
        	
        });
        
    };
	
    $.fn.wait = function() {
    	
    	
        return this.each(function() {
        	
			var obj = $(this);
        	var blockUI = $.wait.isBlockUI(obj);
        	
    		if(blockUI) {
    			obj.block({
    			    message: "<img src=\"" + CONTEXT_ROOT + ((obj.height() < 30) ? "resources/img/loading_s.gif": "resources/img/loading.gif") + "\">",
    			    overlayCSS: {backgroundColor: "#000", opacity: 0.1}
    			});
    			
    		} else {
    			
    			if(obj.prop("tagName") == "SELECT") obj = obj.prev();

    			obj.addClass("loading");
    			if(obj.height() < 30) obj.addClass("small");
    			
    		};
        	
        	
        });
    	
    };
	
		
	$(function() {
		
		//$.i18n.properties( {name:'messages', path: CONTEXT_ROOT + 'resources/i18n/', mode:'both'} );	//다국어

	});
		
		
})(jQuery);




(function($) {
	
	Pager = function($pager) {
		
		this.pager = $pager;
		this.max = parseInt($pager.attr("max"));		//max page no
		this.group = parseInt($pager.attr("group"));	//group size
		this.handler = eval($pager.attr("handler")),
		this.length = parseInt($pager.attr("length"));	//rec count
		this.buttons = {
			prev : $pager.find(">div.prev"),
			next : $pager.find(">div.next"),
			first : $pager.find(">div.first"),
			last : $pager.find(">div.last"),
			pages : $pager.find(">div:not(:empty)")
		};
		this.setMax = function(n) {
			this.max = n;
			this.pager.attr("max",this.max);
		};
		this.setLength = function(n) {
			this.length = n;
			this.pager.attr("length",this.length);
		};
	};
	
    $.pager = {
    	
    	invoke : function (pager, $button, callback) {
    			
    		
			if($button.text()) {
				
				var pageNo = parseInt($button.text());
		    	var param =  pager.handler.getParam(pageNo);
		    	var handler = pager.handler;
		    	var selector = handler.selector;
	    		$(selector).wait();
		    	

		    	$.ajax(param).success(function(resp) {
		    		
		    		try {
		    			
			    		if(resp.code ==0) {
			    			
			    			$(selector).find("tbody tr").remove();
			    			var body = $(selector).find("tbody");
			    			
			    			$.each(resp.data[0], function(i, row) {
			    				
			    				var r = handler.handle(row);
			    				
			    				var el = body.append("<tr></tr>").find("tr:last");
			    				
			    				r.forEach(function(entry) {
			    					if ( typeof(entry) == "object" ) {
			    						el.append("<td " + entry.tdstyle + ">" + entry.data + "</td>");
			    					}else{
			    						el.append("<td>" + entry + "</td>");
			    					}
			    				});
			    				
			    				
			    			});
			    			
			    			if(resp.data.length>1) {
			    				pager.setMax(resp.data[1].max);
			    				pager.setLength(resp.data[1].length);
			    				$.pager.initButtons(pager, 1);
			    			}
			    			
			    			pager.buttons.pages.filter(".on").removeClass("on");
			    			$button.addClass("on");
			    			$(selector).unWait();
			    			if(handler.onComplete) handler.onComplete($(selector), pager.length);

			    		} else {
			    			$(selector).unWait();
			    			dr.common.ui.alert(data.message);
			    		}
						if(callback) callback();

		    		} catch(ex) {
		    			$(selector).unWait();
		    			dr.common.ui.alert("잠시후 다시 시도하세요");
		    		}
		    	});
				
			}
			
		},
		
		jump : function() {
			
			var n = parseInt($(this).attr("position"));
			if(n==0) return;
			
			var pager = new Pager($(this).parent());
			
			var r = (n-1)%pager.group;
			if(r > 0) n = n - r;
			
			$.pager.initButtons(pager, n);
			$.pager.invoke(pager, pager.buttons.pages.eq(0));
			
		},
		
		initButtons : function(pager, n) {

			var gr = Math.ceil(n/pager.group);			//group no
			var mgr = Math.ceil(pager.max/pager.group);	//max group no


			pager.buttons.first.attr("position",(gr>1? 1:0));
			pager.buttons.prev.attr("position",(gr>1? (gr-1) * pager.group - (pager.group-1): 0));
			pager.buttons.next.attr("position",(gr<mgr? n + pager.group: 0));
			pager.buttons.last.attr("position",(gr<mgr? pager.max: 0));

			
			pager.buttons.pages.each(function(index) {

				
				$(this).text(index+n);
				
				if( pager.max >= index+n ) {
					
					$(this).show().unbind("click").click(function() {

						$.pager.invoke(new Pager($(this).parent()), $(this));
						
					});
					
				} else {
					$(this).hide();
				}
				
			});
			
			pager.buttons.prev.unbind("click").click($.pager.jump);
			pager.buttons.next.unbind("click").click($.pager.jump);
			pager.buttons.first.unbind("click").click($.pager.jump);
			pager.buttons.last.unbind("click").click($.pager.jump);
			
		}
		
    	
    };


	/**
	 * 페이징 처리 플러그인
	 * 
	 * @author 조은상
	 */
    $.fn.pager = function() {
    	
    	$.pager.initButtons(new Pager($(this)), 1);
    	
        return $(this);
    	
    };
    
		
		
})(jQuery);


function chkPwd(str){
	
	var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
	
	if(!reg_pwd.test(str)){
		dr.common.ui.alert("비밀번호는 영문,숫자를 혼합하여<br/> 10자리 ~ 20자리 이내로 입력해주세요.");
		return false;
	}
	return true;
}

