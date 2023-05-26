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

var cm = {
	/**
	 * UTF-8 String Byte Length
	 */
	lengthB: function(str) {
	    if (str == null || str.length == 0) {
	        return 0;
	    }
	    var size = 0;
	
	    for ( var i = 0; i < str.length; i++) {
	        size += cm.utfCharByteSize(str.charAt(i));
	
	    }
	    return size;
	}
	/**
	 * UTF-8 Character byte Length
	 * http://en.wikipedia.org/wiki/Utf-8
	 */
	,utfCharByteSize: function(ch) {
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
	}
	
	/**
	 * text area 에 문자 입력시 byte 계산
	 * @param  : obj    - byte 계산할 textarea name
	             limit  - 제한할 byte
	 * @return : byte
	 */
	
	,byteLimit: function (obj, limit, dispObjId) {
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
	
	}
	
	//=======================================================================
	//팝업 함수 영역
	//=======================================================================
	
	,focusWin:function(oWin) {
	      if (oWin == null) {
	            alert(COMMON_MESSAGE['popup.fail'][lang]);//"팝업이 차단되어 있습니다. \n원할한 사이트이용을 위해 팝업을 허용해 주시기 바랍니다.");
	      }
	      if (oWin.opener == null) {
	        oWin.opener = window;
	      }
	      oWin.focus();
	}
	/**
	 * 함수설명 : 모달창 팝업
	 * 예제     : showModal(url, sParam,sWithd, sHeight);
	* @ parameter :
	 */
	,openModalC: function(sUrl, sParam, sWithd, sHeight, sFeatures) {
	    var returnVal = new Array();
	
	    var xPos = (screen.availWidth - sWithd) / 2;
	    var yPos = (screen.availHeight - sHeight ) / 2 ;
	
	    if(sFeatures == null || sFeatures == "") {
	        sFeatures ="help:0;scroll:0;status:0;";
	    }
	    console.log(sFeatures)
	    var features = ";dialogTop="+yPos + "px" +
	            ";dialogLeft="+xPos +"px" +
	            ";dialogWidth="+sWithd +"px" +
	            ";dialogHeight="+sHeight+"px" ;
	
	    returnVal = window.showModalDialog(sUrl, sParam,
	            sFeatures+features);
	
	    return returnVal;
	}
	
	/**
	 * 함수설명 : 화면 중앙에 팝업창
	 * 예제     : nmPopupCenter(url, object,windowWidth, windowHeight, windowFeatures);
	* @ parameter : sTargetPath : 해당 popup창의 실제 페이지 경로
	                              object          : popup창으로 넘길 object
	                              windowWidth     : 창의 넓이
	                              windowHeight    : 창의 높이
	                              windowFeatures  : 창의 속성
	 */
	,openWinC: function (url, windowName, sParam, windowWidth, windowHeight, windowFeatures) {
		
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
	        	windowName = "POP";
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
	}
	
	/**
	 * 함수설명 :  팝업창
	 * 예제     : openWin(url, object,windowWidth, windowHeight, windowFeatures);
	* @ parameter : sTargetPath : 해당 popup창의 실제 페이지 경로
	                              object          : popup창으로 넘길 object
	                              windowWidth     : 창의 넓이
	                              windowHeight    : 창의 높이
	                              windowFeatures  : 창의 속성
	 */
	,openWin: function (url, windowName, sParam, windowWidth, windowHeight, windowFeatures) {
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
	},
	toggleFullscreen: function() {
		if (screenfull.enabled) {
		    screenfull.toggle();//request();
		} else {
			alert("현재 사용 하시는 브라우져는 Full Screen 모드를 자동으로 지원할수 없습니다. F11 키나 브라우져 메뉴 상에서 전체화면 기능을 이용해 주시기 바랍니다.");
		}
	}
	, nvlToStr: function(originStr) {
	    var rtn = "";
	    if(originStr != null) {
	        rtn = originStr;
	    }
	    return rtn;
	}
	/**
	 * Add Comma
	 */
	, addCommas: function(input){
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
		}
}; // cm


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


function makeClipper( objectId ) {
	var client = new ZeroClipboard(document.getElementById(objectId));
	client.on( 'ready', function(event) {
		console.log( 'ZeroClipboard movie is loaded.' );
		client.on( 'copy', function(event) {
			console.log( 'copied' );
          	event.clipboardData.setData('text/plain',"lkasjdlasjdlkjsd");
        } );
	});// clipper.on
	
	client.on( 'error', function(event) {
        console.log( 'ZeroClipboard error of type "' + event.name + '": ' + event.message );
        ZeroClipboard.destroy();
     } );
     return  client;
}

