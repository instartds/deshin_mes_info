var cm;
if (!cm) {
	cm = {};
}


//=======================================================================
// String extend 
//=======================================================================

/**
*  remove trail space: " abcde "  -> "abcde"  
*  str.trim();
*/
String.prototype.trim = function(){
  return this.replace(/(^\s*)|(\s*$)/g, "");
};

/**
* remove all space in a String.  " ab c de "  -> "abcde" 
*  : str.trimAll();
*/
String.prototype.trimAll = function(){
  return this.replace(/\s*/g, "");
};


/**
 * UTF-8 String Byte Length
 */
cm.lengthB = function(str) {
    if (str == null || str.length == 0) {
        return 0;
    }
    var size = 0;

    for ( var i = 0; i < str.length; i++) {
        size += cm.utfCharByteSize(str.charAt(i));

    }
    return size;
};
/**
 * UTF-8 Character byte Length
 * http://en.wikipedia.org/wiki/Utf-8
 */
cm.utfCharByteSize = function(ch) {
    if (ch == null || ch.length == 0) {
        return 0;
      }

      var charCode = ch.charCodeAt(0);

      if (charCode <= 0x00007F) {
        return 1;
      } else if (charCode <= 0x0007FF) {
        return 2;
      } else if (charCode <= 0x00FFFF) {
        return 2; //return 3;
      } else {
         return 2; //return 4;
      }
};




/**
 * text area 에 문자 입력시 byte 계산
 * @param  : obj    - byte 계산할 textarea name
             limit  - 제한할 byte
 * @return : byte
 */

cm.byteLimit = function (obj, limit, dispObjId) {
        var ls_str     = obj.value;      // 이벤트가 일어난 컨트롤의 value 값
        var li_str_len = ls_str.length;  // 전체길이

        // 변수초기화
        var li_max      = limit;        // 제한할 글자수 크기
        var li_byte     = 0;            // 한글일경우는 2 그밗에는 1을 더함
        var li_len      = 0;            // substring하기 위해서 사용
        var ls_one_char = "";           // 한글자씩 검사한다
        var ls_str2     = "";           // 글자수를 초과하면 제한할수 글자전까지만 보여준다.


        for(i=0; i< li_str_len; i++)
        {
            //gls.util.getByteLength();
          li_byte +=cm.utfCharByteSize(ls_str.charAt(i));

           // 전체 크기가 li_max를 넘지않으면
           if(li_byte <= li_max)
           {
              li_len = i + 1;
           }
         }

        // 전체길이를 초과하면
        if(li_byte > li_max)
        {
           alert("if length over " +li_max+ " byte then overed chars will be removed.");
           ls_str2 = ls_str.substr(0, li_len);
           obj.value=ls_str2;

           li_byte = cm.lengthB(ls_str2);
         }
        if(dispObjId) {
            $("#"+dispObjId).html(" <strong>"+li_byte+"</strong> / "+li_max+"Byte (Korea "+(li_max/2)+"char/ English "+li_max+"char)");
        }

};

//=======================================================================
//팝업 함수 영역
//=======================================================================

cm.focusWin= function(oWin) {
      if (oWin == null) {
            alert(COMMON_MESSAGE['popup.fail'][lang]);//"팝업이 차단되어 있습니다. \n원할한 사이트이용을 위해 팝업을 허용해 주시기 바랍니다.");
      }
      if (oWin.opener == null) {
        oWin.opener = window;
      }
      oWin.focus();
};
/**
 * 함수설명 : 모달창 팝업
 * 예제     : showModal(url, sParam,sWithd, sHeight);
* @ parameter :
 */
cm.openModalC = function(sUrl, sParam, sWithd, sHeight, sFeatures) {
    var returnVal = new Array();

    var xPos = (screen.availWidth - sWithd) / 2;
    var yPos = (screen.availHeight - sHeight ) / 2 ;

    if(sFeatures == null || sFeatures == "") {
        sFeatures ="help:0;scroll:0;status:0;";
    }
    var features = ";dialogTop="+yPos + "px" +
            ";dialogLeft="+xPos +"px" +
            ";dialogWidth="+sWithd +"px" +
            ";dialogHeight="+sHeight+"px" ;

    returnVal = window.showModalDialog(sUrl, sParam,
            sFeatures+features);

    return returnVal;
};


/**
 * 함수설명 : 화면 중앙에 팝업창
 * 예제     : nmPopupCenter(url, object,windowWidth, windowHeight, windowFeatures);
* @ parameter : sTargetPath : 해당 popup창의 실제 페이지 경로
                              object          : popup창으로 넘길 object
                              windowWidth     : 창의 넓이
                              windowHeight    : 창의 높이
                              windowFeatures  : 창의 속성
 */
cm.openWinC = function (url, windowName, sParam, windowWidth, windowHeight, windowFeatures)
{
	
    try {
        if( windowFeatures == null || windowFeatures == "" ) {
            windowFeatures = "toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes,menubar=no";
        }
        //windowFeatures="";
        //alert(windowFeatures);
        
        if(navigator.appVersion.indexOf("Safari") > 0 && navigator.appVersion.indexOf("Chrome") < 0 && navigator.appVersion.indexOf("Version/5.1") > 0) {
            windowHeight = parseInt(windowHeight) - 61;
        }

        if(navigator.appVersion.indexOf("Chrome") > 0) {
            windowHeight = parseInt(windowHeight) + 58;
        }

        var xPos = (screen.availWidth  - windowWidth) / 2;
        var yPos = (screen.availHeight - windowHeight) / 2;
        var feature =  "top=" + yPos + ",left=" + xPos + ",width=" + windowWidth + ",height=" + windowHeight +  "," + windowFeatures;
        if(!windowName) {
        	//windowName = "_blank";
        	windowName = "CUPIA_POP";
        }
        var newUrl = url;
        if(sParam) {
        	newUrl = newUrl+"?"+sParam;
        }
        var oWin = window.open( newUrl , windowName, feature );
        
        //oWin.moveTo(xPos, yPos);
        this.focusWin(oWin);
        return oWin;
    } catch(errorObject) {
		alert("Opening a pop-up window was blocked. Please allow opening a pop-ups  for this site");
    }
};

/**
 * 함수설명 :  팝업창
 * 예제     : openWin(url, object,windowWidth, windowHeight, windowFeatures);
* @ parameter : sTargetPath : 해당 popup창의 실제 페이지 경로
                              object          : popup창으로 넘길 object
                              windowWidth     : 창의 넓이
                              windowHeight    : 창의 높이
                              windowFeatures  : 창의 속성
 */
cm.openWin = function (url, windowName, sParam, windowWidth, windowHeight, windowFeatures)
{
    try {
        if( windowFeatures == null || windowFeatures == "" ) {
            windowFeatures = "toolbar=no,directories=no,status=no,scrollbars=no,resize=yes,menubar=no";
        }
        if(navigator.appVersion.indexOf("Safari") > 0 && navigator.appVersion.indexOf("Chrome") < 0 && navigator.appVersion.indexOf("Version/5.1") > 0) {
            windowHeight = parseInt(windowHeight) - 61;
        }

        if(navigator.appVersion.indexOf("Chrome") > 0) {
            windowHeight = parseInt(windowHeight) + 58;
        }

        var win = window.open( url , windowName, "width=" + windowWidth + ",height=" + windowHeight + "," + windowFeatures);
        this.focusWin(win);
        return win;
    }
    catch(errorObject) {
		alert("Opening a pop-up window was blocked. Please allow opening a pop-ups  for this site");
    }
};

/**
 * Ajax Type SelectBox Drawer.
 * Exam ) ajaxSelCountryLocFacade Service & cais.cm.code.AjaxSelectBI.java*
 *    <select name="grodupCode"
 *      onchange="jsSelect('/ajaxSelCountryLocFacade.do','1', this.value, 'detailCD');" >
 *
 */
cm.jsSelect = function ( url, jsonParams, targetObj, title, def) {
    //var targetObj = $(targetElm);
    var URL = CPATH + url;

    var def = def;
    var title=title;
    $.ajax({
        url: URL,
        type: 'POST',
        async: false,
        data:jsonParams,
        dataType:'json',
        error: function(returnData, textStatus){
            //alert('Error loading JSON document: '+textStatus);
        },
        success: function(returnData){
             try{
                 targetObj[0].options.length = 0;
                 if(title ) {
                     targetObj.get(0).options[0] = new Option( title, "" );
                 }
                 for(var i=0; i < returnData.length; i++){
                     var opt = new Option( returnData[i].text, returnData[i].value );
                     if(def == returnData[i].value ) {
                         opt.selected = true;
                     }
                     targetObj.get(0).options[targetObj[0].options.length] = opt;
                 }

             } catch (e) {
                console.log("ajax Exception : ", e);
             }
        }
    });
};


/**
 * 
 */
cm.jsValue = function (componentName, beanName, jObj, targetElm) {
	var obj = targetElm;

	var URL = CPATH + '/ajValue.do';
	var params = {'componentName':componentName, 
				  'beanName':beanName};
	
	var keys = Object.keys(jObj);
	for( var i=0; i < keys.length; i++ ) {
		params[keys[i]] = jObj[keys[i] ];
		
	}

    var rqst = new Ajax.Request(URL, 
    		{
		    	method: 'post', 
		        parameters: params,
    			onSuccess: function (xmlHttp) {
    				var serverData = xmlHttp.responseText;
    			    var evalData = serverData.evalJSON();	    
    			    eval(obj +"("+serverData+")");
    			},
                onFailure: function (xmlHttp) {
                    alert('jsValue Ajax fail!!!');
                }
    		}
    	);
};
/**
 * POST 방식으로 전송하는 팝업창
 * url        : 팝업창 경로
 * data       : jason data
 * popName    : 팝업창 이름 
 * popWidth   : 팝업창 가로 길이 (생략하면 화면 넓이에 맞춰진다.)
 * popHeight  : 팝업창 세로 길이 (생략하면 화면 높에에 맞춰진다.)
 * popOptions : 팝업창 옵션 (생략하면 기본으로 scrollbars=yes 이다.)
 * 
 * comment :
 *     데이터를 json 형식으로 넘겨도 된다.
 *     예) gls.openPostPopup({
 *             url     : 경로
 *            ,data    : json data
 *            ,target  : 이름
 *            ,width   : 넓이
 *            ,height  : 높이
 *            ,options : 옵션
 *         });
 *     데이터가 필요없는 부분은 json property로 넣지 않아도 된다.    
 */
cm.openPostPopup = function(obj, data, popName, popWidth, popHeight, popOptions) {
	var myPop = null;
	try {
		var param = null;		
		// json object이라면
		if ( obj && typeof obj == 'object' ) {
			param = {
				 'url'     : obj.url                 || ''
				,'data'    : obj.data                || {}
				,'target'  : obj.target              || ''
				,'width'   : obj.width               || screen.availWith
				,'height'  : obj.height              || screen.availHeight
				,'options' : obj.options             || 'scrollbars=yes'
			};
		}
		else {
			param = {
				 'url'     : obj                     || ''
				,'data'    : data                    || {}
				,'target'  : popName                 || ''
				,'width'   : popWidth                || screen.availWith
				,'height'  : popHeight               || screen.availHeight
				,'options' : popOptions              || 'scrollbars=yes'
			}; 
		}
		
		//랜덤한 수를 출력
		var curDate   = new Date();
		var ranNumber = Math.floor(Math.random() * 10000) + 1;
		var strId = "";
		    strId += param.target;
		    strId += "_";		    
		    strId += curDate.getFullYear();
		    strId += curDate.getMonth();
		    strId += curDate.getDay();
		    strId += curDate.getHours();
		    strId += curDate.getMinutes();
		    strId += curDate.getSeconds();
		    strId += "_" + ranNumber;
		    
		var $popForm = jQuery("<form></form>")
						.attr("name"  , strId)
						.attr("id"    , strId)
						.attr("method", "POST");
		if ( $popForm ) {
			jQuery.each(param.data, function(key, val) { 
		        jQuery("<input type='hidden'/>")
			        .attr("name" , key)
			        .attr("id"   , key)
			        .attr("value", val)
			        .appendTo($popForm);
			});
			$popForm.appendTo(document.body);

		    myPop = cm.openWin("", param.target, null, param.width, param.height, param.options);
		    var myForm = $popForm[0];
		    myForm.action = param.url;
		    myForm.method = "POST";
		    myForm.target = param.target;
		    
		    myForm.submit();
		    $popForm.remove();
		}//if ( $popForm ) {
	}
	catch (e) {alert(e.message);}
	finally   {}

	return myPop;
};

cm.nvlToStr = function(originStr) {
    var rtn = "";
    if(originStr != null) {
        rtn = originStr;
    }
    return rtn;
};


function layer_open(el) {
    //$('.layer').addClass('open');
    $('.layer').fadeIn();
    var temp = $('#' + el);
    if(temp.outerHeight() < $(document).height())
        temp.css('margin-top', '-' + temp.outerHeight() / 2 + 'px');
    else
        temp.css('top', '0px');
    if(temp.outerWidth() < $(document).width())
        temp.css('margin-left', '-' + temp.outerWidth() / 2 + 'px');
    else
        temp.css('left', '0px');
}

jQuery(function($) {
    $('#layer_close').click(function(){
        $('.layer').fadeOut();
        return false;
    });
});

cm.getGUID = function() {
    var ret = "";

    $.ajax({
        url : CPATH + "/common/getGuid.do",
        type : 'POST',
        async: false,
        data : {},
        dataType : 'json',
        error: function(returnData, textStatus) {
            ret = "";
        },
        success: function(returnData) {
            ret = returnData.grp_id;
        }
    });

    return ret;
};

/**
 * Checkbox 전체선택/해제
 */
cm.toggleCheckboxAll = function(obj, checkboxName, targetSelector) {
    var checked = $(obj).attr('checked');
   // alert(checked);
    $('input[name="' + checkboxName + '"]').each(function(index, element){
        if(checked) {
            $(element).attr('checked', true);
        }else {
            $(element).attr('checked', false);
        }

        if(targetSelector){
            util.appendCheckValue(element, targetSelector);
        }
    });
};



/**
 * 행 색 반영
 * @param selector
 * @returns
 */
cm.alternateRowColors = function(selector, isCriterionItem) {
    if(isCriterionItem) {
        $(selector).find('tbody:visible:odd').children().addClass('odd_row');
        $(selector).find('tbody:visible:even').children().removeClass('odd_row');
    }else {
        $(selector).find('tbody').each(function(index, element){
            $(this).children(':visible:odd').addClass('odd_row');
            $(this).children(':visible:even').removeClass('odd_row');
        });
    };
};

cm.autoComplete= function(url, selector, arg0, arg1, targetID, cuoCd) {
	if(arg1 == null) arg1 = "";
	
	$('#'+selector).autocomplete({
		 minLength: 2
	   , delay : 0	   
	   , source: function(request, response) {
			 $.ajax({
				 	  url      : CPATH+url
				 	, datatype : "json"
				    , data     : {
				    	  term:  request.term
				    	, arg0: arg0
				    	, arg1: arg1
				    	, cuoCd:cuoCd
				    	, maxRows: 12
				 	  }
			 	    , success: function(data) {
			 	    	$('#'+targetID).val("");
				 		
				 		if(data.totalCount < 1) {
				 			$('#'+selector).val("");
				 		}
				 		
						response($.map(data.rows, function(item) {
								var cuoStr = "";     
								if(cuoCd != null && cuoCd == "*") {
									cuoStr = ","+item.cuoCd;
							    }
							    	
							    return {
							      label: item.dspId + "," + item.label + cuoStr,
							      value:  item.dspId + ","  + item.label,
							      id : item.value
							   };
						}));
					  }
			 });
		  }
	    , select : function( event, ui ) {
			if(ui.item) {
				$('#'+targetID).val(ui.item.id);
			} 
		  }
	}).blur(function() {
		if($("#"+targetID).val() == "") { $("#"+selector).val(""); }
	}).keyup(function() {
		if($("#"+selector).val() == "") { $("#"+targetID).val(""); }
	});
};

/**
 * autoComplete for  B/L Forwarder -soojin
 * */

cm.autoCompleteFrwrdr= function(url, selector, arg0, arg1, targetID1, targetID2, cuoCd) {
	if(arg1 == null) arg1 = "";
	
	$('#'+selector).autocomplete({
		 minLength: 2
	   , delay : 0	   
	   , source: function(request, response) {
			 $.ajax({
				 	  url      : CPATH+url
				 	, datatype : "json"
				    , data     : {
				    	  term:  request.term
				    	, arg0: arg0
				    	, arg1: arg1
				    	, maxRows: 12
				 	  }
			 	    , success: function(data) {
			 	    	$('#'+targetID1).val("");
				 		
				 		if(data.totalCount < 1) {
				 			$('#'+selector).val("");
				 		}
				 		
						response($.map(data.rows, function(item) {
								var cuoStr = "";     
								if(cuoCd != null && cuoCd == "*") {
									cuoStr = ","+item.cuoCd;
							    }
							    	
							    return {
							      label: item.dspId + "," + item.label + cuoStr,
							      value:  item.dspId + ","  + item.label,
							      id : item.value,
							      tel : item.tel
							   };
						}));
					  }
			 });
		  }
	    , select : function( event, ui ) {
			if(ui.item) {
				$('#'+targetID1).val(ui.item.id);
				$('#'+targetID2).val(ui.item.tel);
			} 
		  }
	}).blur(function() {
		if($("#"+targetID1).val() == "") { $("#"+selector).val(""); }
	}).keyup(function() {
		if($("#"+selector).val() == "") { $("#"+targetID1).val(""); }
	});
};

cm.autoCompleteConsignee= function(url, selector, targetID1, targetID2, targetID3) {
	
	$('#'+selector).autocomplete({
		 minLength: 2
	   , delay : 0	   
	   , source: function(request, response) {
			 $.ajax({
				 	  url      : CPATH+url
				 	, datatype : "json"
				    , data     : {
				    	  term:  request.term
				    	, maxRows: 12
				 	  }
			 	    , success: function(data) {
			 	    	//$('#'+targetID1).val("");
				 		
				 		//if(data.totalCount < 1) {
				 		//	$('#'+selector).val("");
				 		//}
				 		
						response($.map(data.rows, function(item) {
							    return {
							    	label: item.nm,
							      nm: item.nm,
							      tin: item.tin,
							      addr : item.addr,
							      tel : item.tel
							   };
						}));
					  }
			 });
		  }
	    , select : function( event, ui ) {
			if(ui.item) {
				$('#'+targetID1).val(ui.item.tin);
				$('#'+selector).val(ui.item.nm);
				$('#'+targetID2).val(ui.item.tel);
				$('#'+targetID3).val(ui.item.addr);
			} 
		  }
	}).blur(function() {
		//if($("#"+targetID1).val() == "") { $("#"+selector).val(""); }
	}).keyup(function() {
		//if($("#"+selector).val() == "") { $("#"+targetID1).val(""); }
	});
};

/**
 * Code Auto Complete
 */
cm.autoCompleteCode = function(selector, codeGroup, targetID ) {
	cm.autoComplete("/ajax/autoCompleteCode.do", selector, codeGroup, null, targetID, null );
};
cm.autoCompleteCode = function(selector, codeGroup, targetID, codeOption ) {
	cm.autoComplete("/ajax/autoCompleteCode.do", selector, codeGroup, codeOption, targetID, null );
};

/**
 * Forwarder Auto Complete
 */
cm.autoCompleteComp = function(selector, companyType, codeOption, targetID, cuoCd) {
		cm.autoComplete("/ajax/autoCompleteComp.do", selector, companyType, codeOption, targetID, cuoCd);
};

/**
 * Forwarder Auto Complete for B/L Forwarder -- soojin 
 */
cm.autoCompleteCompFrwrdr = function(selector, companyType, codeOption, targetID1, targetID2, cuoCd) {
		cm.autoCompleteFrwrdr("/ajax/autoCompleteComp.do", selector, companyType, codeOption, targetID1,targetID2, cuoCd);
};


/**
 * Consignee Auto Complete
 */
cm.autoCompleteCons = function(selector,  targetID1, targetID2, targetID3) {
		cm.autoCompleteConsignee("/ajax/autoCompleteCons.do", selector,  targetID1, targetID2, targetID3);
};


/**
 * Ajax Get Code Info 
 */
cm.ajaxGetCodeInfo = function(codeGroup, value) {
	var rtnStr = "";
	jQuery.ajax({
        type    : "POST",
        url     : CPATH+"/ajax/ajaxGetCodeInfo.do",
        data    : { codeGroup:codeGroup, value:value},
        dataType: 'json',
        async   : false,
        success : function(data) {
        	rtnStr = data.codeName;
        }
    });  
	
	return rtnStr;
};

/**
 *	SELECT ROW CSS 
 */
cm.selectRowCss = function(hDiv, selClass, i) {
 	var old = $("#"+hDiv).val();
    $("."+selClass+old).attr( 'style', '' );
    $("."+selClass+old+" a").attr( 'style', '' );
	
    $("#"+hDiv).val(i);
    $("."+selClass+i).css({"color":"#e17009"});
	$("."+selClass+i+" a").css({"color":"#e17009"});
}; 


/**
 *	SUBMIT UPPERCASE 
 */
cm.textUpperCase = function(){
	$('input[type=text].uppercase').map(function() {
	    $("input[name="+this.name+"]").val($("input[name="+this.name+"]").val().toUpperCase()); 
	});
};

/**
 * Add Comma
 */
cm.addCommas = function(input){
	  // If the regex doesn't match, `replace` returns the string unmodified
	  return (input.toString()).replace(
	    // Each parentheses group (or 'capture') in this regex becomes an argument 
	    // to the function; in this case, every argument after 'match'
	    /^([-+]?)(0?)(\d+)(.?)(\d+)$/g, function(match, sign, zeros, before, decimal, after) {

	      // If a digit has 3 digits after it, replace it with itself plus a comma
	      var insertCommas = function(string) { return string.replace(/(\d)(?=(\d{3})+$)/g, "$1,"); };

	      // If there was no decimal, the last capture grabs the final digit, so
	      // we have to put it back together with the 'before' substring
	      return sign + (decimal ? insertCommas(before) + decimal + after : insertCommas(before + after));
	    }
	  );
	};

/**
 *  SELECT AUDIT RESULT DIALOG
 */
function cmeAdtResult(targetDiv, dclrtnRefNo, title) {
	
	var param = { dclrtnRefNo:dclrtnRefNo 
			    , isModal : "Y"
	};

	var url   = CPATH + "/cme/common/selectAdtResultList.do?" + $.param(param);
	var name  = targetDiv + "Frame"; 

	var wWidth  = $(window).width();
    var dWidth  = wWidth * 0.7;
    
    if(dWidth > 650)  dWidth  = 650;
    
	$("#"+targetDiv).dialog({
		title    : title,
		modal    : true,
		resizable: true,
		width    : dWidth,
		height   : 400
	});
	
	$("#"+targetDiv).html('<iframe id="'+name+'" name="'+name+'" src="'+url+'" style="width:100%; height:100%;" frameborder="0" scrolling="auto" />');
}
function cmeAdtResultType(targetDiv, dclrtnRefNo, title, docType) {
	
	var param = { dclrtnRefNo:dclrtnRefNo 
			    , isModal : "Y"
			    , docType : docType
	};

	var url   = CPATH + "/cme/common/selectAdtResultType.do?" + $.param(param);
	var name  = targetDiv + "Frame"; 

	var wWidth  = $(window).width();
    var dWidth  = wWidth * 0.7;
    
    if(dWidth > 650)  dWidth  = 650;
    
	$("#"+targetDiv).dialog({
		title    : title,
		resizable: true,
		modal    : true,
		width    : dWidth,
		height   : 400
	});
	
	$("#"+targetDiv).html('<iframe id="'+name+'" name="'+name+'" src="'+url+'" style="width:100%; height:100%;" frameborder="0" scrolling="auto" />');
}
function cmiAdtResult(targetDiv, dclrtnRefNo, title) {
	
	var param = { dclrtnRefNo:dclrtnRefNo
			    , isModal : "Y"
	};
	
	var url   = CPATH + "/cmi/common/selectAdtResultList.do?" + $.param(param);
	var name  = targetDiv + "Frame"; 
	
	var wWidth  = $(window).width();
	var dWidth  = wWidth * 0.7;
	
	if(dWidth > 650)  dWidth  = 650;
	
	$("#"+targetDiv).dialog({
		title    : title,
		resizable: false,
		modal    : true,
		resizable:false,
		width    : dWidth,
		height   : 400
	});
	
	$("#"+targetDiv).html('<iframe id="'+name+'" name="'+name+'" src="'+url+'" style="width:100%; height:100%;" frameborder="0" scrolling="no" />');
}
function cmiAdtResultType(targetDiv, dclrtnRefNo, title, docType) {
	
	var param = { dclrtnRefNo:dclrtnRefNo
			    , isModal : "Y"
			    ,docType : docType
	};
	
	var url   = CPATH + "/cmi/common/selectAdtResultListType.do?" + $.param(param);
	var name  = targetDiv + "Frame"; 
	
	var wWidth  = $(window).width();
	var dWidth  = wWidth * 0.7;
	
	if(dWidth > 650)  dWidth  = 650;
	
	$("#"+targetDiv).dialog({
		title    : title,
		resizable: false,
		modal    : true,
		resizable:false,
		width    : dWidth,
		height   : 400
	});
	
	$("#"+targetDiv).html('<iframe id="'+name+'" name="'+name+'" src="'+url+'" style="width:100%; height:100%;" frameborder="0" scrolling="no" />');
}


// 날짜를 비교한다. sDate1이 sDate2 보다 크면 false를 반환한다.
// 날짜를 보내는 형식은 yyyy.mm.dd(.이 sDeli)이다.
// 함수 호출 예 jsDateCompare('2011.01.01', '2011.01.02', '.')
function jsDateCompare(sDate1, sDate2, sDeli) {
    var arrDate1 = sDate1.split(sDeli);
    var arrDate2 = sDate2.split(sDeli);

    useDate1 = new Date(arrDate1[0], arrDate1[1] -1, arrDate1[2]);
    useDate2 = new Date(arrDate2[0], arrDate2[1] -1, arrDate2[2]);

    if (useDate1 > useDate2) {
        return false;
    } else {
        return true;
    }
}


function resizeiframe(iframeID)
{
  var iframeWin = window.frames[iframeID];
  var iframeEl = window.document.getElementById? window.document.getElementById(iframeID): document.all? document.all[iframeID]: null;
  if ( iframeEl && iframeWin )
  {
    var docHt = getDocHeight(iframeWin.document);
    if (docHt != iframeEl.style.height) iframeEl.style.height = docHt + 'px';
  }
  else
  { // firefox
    var docHt = window.document.getElementById(iframeID).contentWindow.document.body.scrollHeight;
    window.document.getElementById(iframeID).style.height = docHt + 'px';
  }
}

function getDocHeight(doc)
{
  var docHt = 0, sh, oh;
  if (doc.height) {
    docHt = doc.height;
  } else if (doc.body) {
    if (doc.body.scrollHeight) {
    	docHt = sh = doc.body.scrollHeight;
    }
    if (doc.body.offsetHeight) {
    	docHt = oh = doc.body.offsetHeight;
    }
    if (sh && oh) {
    	docHt = Math.max(sh, oh);
    }
  }
  //alert("height: " + (docHt+10));
  return docHt+10;
}


$().ready(function(){
 $.ajaxSetup({
  error:function(xhr,e){
   if(xhr.status === 0){
	   alert('You are offline!!\n Please Check Your Network.');
   }else if(xhr.status==404){
	   alert('Requested URL not found. [404]');
   }else if(xhr.status==500){
	   alert('Internel Server Error. [500]');
   }else if(e === 'parsererror'){
	   alert('Error.\nParsing JSON Request failed.');
   }else if(e === 'timeout'){
	   alert('Request Time out.');
   }else {
	   alert('Unknow Error.\n'+xhr.responseText);
   }
  }
 });
});

function crgCommonCodeLookup(selector, codeGroup,targetCode, targetName, codeOption) {
	if(codeOption == undefined || codeOption == null) {
		codeOption = "";
	}
	var jsonParams = { "arg0":codeGroup, "arg1":codeOption, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName };
	cm.openWinC(CPATH+"/cm/popupCode.do", "CUPIA_POP", $.param(jsonParams), 480,460);
}
function crgCommonCompLookup(selector, compType,targetCode, targetName, codeOption, cuoCd, targetTel) {
	//alert("t");
	var jsonParams = {};
	if(cuoCd) {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName , "codeOption":codeOption, "cuoCd" : cuoCd};
	} else if (codeOption) {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName , "codeOption":codeOption};
	} else if (targetTel){
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName , "codeOption":codeOption, "targetTel":targetTel};
	} else {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName};
	}
	cm.openWinC(CPATH+"/cm/popupComp.do", "CUPIA_POP", $.param(jsonParams), 480,460);
}

/***/
function crgCommonCompLookupFrwrdr(selector, compType,targetCode, targetName, targetTel, codeOption, cuoCd) {
	//alert("t");
	var jsonParams = {};
	if(cuoCd) {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName , "codeOption":codeOption, "cuoCd" : cuoCd};
	} else if (codeOption) {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName , "codeOption":codeOption};
	} else if (targetTel){
		
	}else {
		jsonParams = { "compType":compType, "term":$(selector).val(),"targetCode":targetCode, "targetName":targetName};
	}
	
	cm.openWinC(CPATH+"/cm/popupComp.do", "CUPIA_POP", $.param(jsonParams), 480,460);
}

function crgMRNLookUp( targetName, callID) {
	var jsonParams = {};
	if(callID) {
		var jsonParams = { "targetName":targetName , "callID":callID};
	} else {
		jsonParams = { "targetName":targetName};
	}
	cm.openWinC(CPATH+"/cm/popupCmeMrnList.do", "CUPIA_POP", $.param(jsonParams), 800,400);
}

function crgCommonConsLookup(selector, targetTin, targetNm, targetTel, targetAddr, srchType) {
	var jsonParams = {"term":$(selector).val(), "targetTin":targetTin, "targetNm":targetNm, "targetTel":targetTel, "targetAddr":targetAddr, "srchType":srchType};
	cm.openWinC(CPATH+"/cm/popupCons.do", "CUPIA_POP", $.param(jsonParams), 480,460);
}

function cmiCrgTracking(mhType,crnVal){
    var param = "";
    param = {mhType:mhType,crnVal:crnVal, isModal : "Y"};
	cm.openWinC(CPATH+"/cmi/tracking/selectCargoTracking.do", "CUPIA_POP", $.param(param), 1000,500);
}
function goImportMfBlLookUp(mhType,crgRefNo){
	var url = "";
	var param = "";
    param = {crgRefNo:crgRefNo, isAudit : "N", isModal : "Y"};

    if(mhType == 'M') {
    	url = "selectAuditedMblDetail.do";
    }else if(mhType == 'H') {
    	url = "selectAuditedHblDetail.do";
    }
	cm.openWinC(CPATH+"/cmi/manifest/Import/Manifest/"+url, "CUPIA_BL_POP", $.param(param), 1000,500);

}

function goExportMfBlLookUp(mhType,crgRefNo){
	var url = "";
	var param = "";
    param = {crgRefNo:crgRefNo, isAudit : "N", isModal : "Y"};

    if(mhType == 'M') {
    	url = "selectAuditedMblDetail.do";
    }else if(mhType == 'H') {
    	url = "selectAuditedHblDetail.do";
    }
	cm.openWinC(CPATH+"/cmi/manifest/Export/Manifest/"+url, "CUPIA_BL_POP", $.param(param), 1000,500);

}


