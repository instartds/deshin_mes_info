<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html lang="ko">

<head>
	<meta charset="utf-8" />
	<title>제조이력 관리</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description" />
	<meta content="Coderthemes" name="author" />
	
	<!-- App favicon -->
	<link rel="shortcut icon" href="<c:url value='/resources/z_rmgmt/assets/images/favicon.ico' />">

	<!-- third party css -->
	<link href="<c:url value='/resources/z_rmgmt/assets/css/vendor/jquery-jvectormap-1.2.2.css' />" rel="stylesheet" type="text/css" />
	<!-- third party css end -->

	<!-- App css -->
	<link href="<c:url value='/resources/z_rmgmt/assets/css/icons.min.css '/>" rel="stylesheet" type="text/css" />
	<link href="<c:url value='/resources/z_rmgmt/assets/css/app-dark.min.css '/>" rel="stylesheet" type="text/css" id="light-style" />
	
	<link href="<c:url value='/resources/z_rmgmt/assets/css/dataTables/dataTables.bootstrap4.min.css '/>" type="text/css" rel="stylesheet" />
	<link href="<c:url value='/resources/z_rmgmt/assets/css/dataTables/buttons.bootstrap4.min.css '/>" type="text/css" rel="stylesheet" />


	<!-- bundle -->
	<script src="<c:url value='/resources/z_rmgmt/assets/js/vendor.min.js' />"></script>
	<script src="<c:url value='/resources/z_rmgmt/assets/js/app.min.js' />"></script>

	<!-- third party js ends -->
	<script src="<c:url value='/resources/z_rmgmt/assets/js/datatables/datatables.min.js' />"></script>
	<script src="<c:url value='/resources/z_rmgmt/assets/js/datatables/dataTables.bootstrap4.min.js' />"></script>
	<script src="//cdn.rawgit.com/ashl1/datatables-rowsgroup/v1.0.0/dataTables.rowsGroup.js"></script>
	<style>
		th.dt-head-right {
			text-align: right
		}
		
		th.dt-head-center {
			text-align: center
		}
		
		td.dt-body-right {
			text-align: right
		}
		
		td.dt-body-center {
			text-align: center
		}
		.btn-group button{
			width:90px;
			height:60px;
			font-size:25px;
		}
		.tot-line-font {
			font-size: 15px;
		}
		.tot-line-icon {
			font-size: 13px;
		}
		.tot-line-contents {
			font-size: 23px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		.tot-line-contents.tot-line-prdctn-nm {
			display: block;
			white-space: normal;
			font-size: 20px;
		}
		.tot-line-contents.tot-line-etc {
			line-height: 65px;
		}
		
		table#tbRmgHist td {
			height: 40px;
    		white-space: normal;
			font-size: 20px;
			
			vertical-align: middle;
			display: table-cell;
		}
		table#tbRmgHist td.td-lot-no{
			 
			 word-break:keep-all;
			 white-space:pre-line;
		} 
		.tab-hist {
			font-size: 24px;
			width:80px;
		}
		.tab-plus {
			font-size: 24px;
		}
		
		.tab-minus {
			font-size: 24px;
		}

		select {
			vertical-align : middle;
			text-align-last : center;
			 
		}

		#divBodyTopArea .form-changed {
			background: linear-gradient(to top, #0ba360 0%, #3cba92 100%);
		}
    </style>

</head>

<body>
<script type="text/javascript" chartset="utf-8">
$.fn.serializeObject = function() {
	"use strict"
  	var result = {}
  	var extend = function(i, element) {
    var node = result[element.name]
    
    if ("undefined" !== typeof node && node !== null) {
     	if ($.isArray(node)) {
        	node.push(element.value)
      	}else{
        	result[element.name] = [node, element.value]
      	}
    }else{
      	result[element.name] = element.value
    }
  }

  $.each(this.serializeArray(), extend)
  return result
}

var AlertsUtil = {
		/** 
		 * 날짜 변환 함수
		 * DateUtil.toString(dt, "yyyy.MM.dd")
		 */
		save : function(pText){
			$.toast({
			    text: pText, // Text that is to be shown in the toast
			    heading: "Success", 											 // Optional heading to be shown on the toast
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
			    heading: "Warning", 											 // Optional heading to be shown on the toast
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
			    heading: "Error", 											 // Optional heading to be shown on the toast
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
			    heading: "Information", 											 // Optional heading to be shown on the toast
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
	blank : function(value){ 
		if(
			(value == "" && typeof(value) != "number") || 
			value == null 				|| 
			value == undefined 			|| 
			( value != null && typeof value == "object" && !Object.keys(value).length ) ){
			return "" 
		}else{ 
			return value 
		} 
	}
}

var StringUtil = {
		padLeft : function(obj, padChar, len) {
			if(ObjUtil.isEmpty(obj)){
				obj = "";
			}
			
			obj = obj.toString();
			
			var l = obj.length;
			
			while(l < len) {
				obj = padChar + obj;
				l = obj.length;
			}
			
			return obj.substring(0, len);
		},
		formatNumber : function(val) { 
			val = NumberUtil.nullEqualsZero(val);
			return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		},
		/*
		 * checkBytes --> byte 체크 max값보다 클경우 true 
		 *  StringUtil.checkBytes(obj, maxByte);
		 */
		checkBytes : function(obj, maxByte){
			if(ObjUtil.isEmpty(obj)){
				obj = "";
			}
			obj = obj.toString();
			
			var stringByteLength = 0;
			var bool = false;
			
			stringByteLength = obj.replace(/[\u0000-\u007f]|([\u0080-\u07ff]|(.))/g, "$&$1$2").length;
			
			if(maxByte < stringByteLength) {
				bool = true;
			}
			
			return bool;
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
	 * DateUtil.getDaysBetween(frDate, toDate)
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
	 * 날짜 반환 함수 : 차이(일)
	 * DateUtil.getDaysBetween(frDate, toDate)
	 */
	addDays : function(dt, addDay){
		var rt = new Date(dt);
		rt.setDate(rt.getDate() + addDay);
		return rt;
	}
}

var NumberUtil = {
		/*
		 * 빈값일 때 0으로 치환. 
		 *  NumberUtil.nullEqualsZero(Object object);
		 */
		nullEqualsZero : function(value){
			
			if(ObjUtil.isEmpty(value) || 
			  isNaN(value)		
			){
				return 0;
			}else{
				return Number(value);
			}	
		},
		/*
		 * FormatString --> 숫자로 변경. 
		 *  NumberUtil.nullEqualsZero(Object object);
		 */
		toNumber : function(value){
			var val = value.replace(",","");
			return Number(val);
		},
		/*
		 * 숫자 앞에 원하는 길이 만큼 0을 채워넣어 줌
		 * ex) 3 --> 003
		 */
		numberPad : function numberPad(value, width){
			value = value + '';
			return value.length >= width ? value : new Array(width - value.length + 1).join('0') + value;
		}
	}

</script>


<form id="frm_m">
	<input type="hidden" name="DIV_CODE" id="DIV_CODE" value="" />
	<input type="hidden" name="WKORD_NUM" id="WKORD_NUM" value="" />
	<input type="hidden" name="LOAD_WKORD_NUM" id="LOAD_WKORD_NUM" value="" />
	<input type="hidden" name="DATA_EXIST_YN" id="DATA_EXIST_YN" value="" />
	<input type="hidden" name="MAX_INSERT_DB_TIME" id="MAX_INSERT_DB_TIME" value="" />
	<input type="hidden" name="USE_WKORD_Q_YN" id="USE_WKORD_Q_YN" value="" />
	<input type="hidden" name="PROG_WORK_CODE" id="PROG_WORK_CODE" value="" />
	<input type="hidden" name="LOAD_PROG_WORK_CODE" id="LOAD_PROG_WORK_CODE" value="" />
	<input type="hidden" name="ITEM_CODE" id="ITEM_CODE" value="" />
	<input type="hidden" name="EQU_CODE" id="EQU_CODE" value="" />
	<input type="hidden" name="LOT_NO" id="LOT_NO" value="" />
	<input type="hidden" name="PRODT_DATE" id="PRODT_DATE" value="" />
	<input type="hidden" name="WKORD_Q" id="WKORD_Q" value="" />
	<input type="hidden" name="PRODT_PRSN" id="PRODT_PRSN" value="" />
</form>
    <div class="container-fluid">
        <main>
            <div class="main-tot-aggr">
                
                <!-- 
                <div class="card m-2">
                    <div class='card-body row p-0'>
                        
                        <div class="col-12 text-right ">
                            <div class="btn-group">
                                <button class="btn btn-rounded btn-outline-info">&lt;&lt; </button>
                                <button class="btn btn-rounded btn-outline-primary">&lt; </button>
                                <button class="btn btn-rounded btn-outline-primary"> &gt;</button>
                                <button class="btn btn-rounded btn-outline-info"> &gt;&gt;</button>    
                            </div>
                        </div>
                    </div>
                </div>
                 -->
                <div class="card widget-inline mb-2">
                    <div class='card-body row p-0'>        
                        <div class="col-xl-2 col-md-8">
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <a href="javascript:openPopHist();">
                                    <i class='mdi mdi-hammer tot-line-icon'></i>
                                    <span class='tot-line-font tot-line-prodt-nm'>&nbsp제품명</span>
                                    <div>
                                        <span class='tot-line-contents text-success tot-line-prdctn-nm' data-code='' id='h_item' name='h_item'>
                                            
                                        </span>
                                    </div>    
                                </a>
                            </div>
                        </div>
                        <div class='col-xl-2 col-md-4'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-hammer tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조기기</span>
                                <div class='text-center'>
                                    <div class="row">
                                        <div class="col-12 pt-1">
                                            <select id="selEqu" class="form-control text-center" style="height:45px;font-size:25px;text-align:center;">
												<c:forEach items="${EQU }" var="ls" varStatus="i">
													<option value="${ls.EQU_CODE }">${ls.EQU_NAME }</option>
												</c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class='col-xl-2 col-md-2'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-pencil-box tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp작업지시번호</span>
                                <div class='text-center'>
                                    <div class="row">
                                    	<div class="col-12 pt-1">
                                    		<input id="h_wkord_num" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" type="text" style="height:45px;font-size:25px">
                                    	</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class='col-xl-1 col-md-2'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-pencil-box tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조번호</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents tot-line-etc text-success' id='h_lot_no' name='h_lot_no'>
                                        
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-xl-1 col-md-2'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-pencil-box-outline tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조일</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents tot-line-etc text-success' id='h_prodt_date' name='h_prodt_date'>
                                        
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-xl-1 col-md-2'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp이론량</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents tot-line-etc text-success' id='h_wkord_q' name='h_wkord_q'>
                                        
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-xl-1 col-md-2'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp실제조량</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents tot-line-etc text-success' id='h_work_q' name='h_work_q'>
                                        
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-xl-2 col-md-4'>
                            <div class='card-body pt-2 pl-2 pr-2 pb-0'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조자</span>
                                <div class='text-center'>
                                    <div class="row">
                                        <div class="col-12 pt-1">
                                            <select id="selPrsn" class="form-control text-center" style="height:45px;font-size:25px;text-align: center;">
												<option value=""></option>
												<c:forEach items="${P505 }" var="ls" varStatus="i">
													<option value="${ls.CODE_CD }">${ls.CODE_NM }</option>
												</c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row pr-2 pl-2">
                
                <div class="col-xl-9 p-0 pr-xl-2">
                   <div class="row pr-4">
                      <div class="col-10 pr-0">
                           <ul id="ulSeqArea" class="nav nav-tabs mb-0">
                                <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="false" class="nav-link active" data-code="00">
                                        <i class="mdi mdi-home-variant d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_0">전체</span>
                                    </a>
                                </li>
                                <!-- 
                                <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="true" class="nav-link">
                                        <i class="mdi mdi-account-circle d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_1">&nbsp;1공정&nbsp;</span>
                                    </a>
                                </li> -->
                               <!--  <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="false" class="nav-link">
                                        <i class="mdi mdi-settings-outline d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_2">&nbsp;2공정&nbsp;</span>
                                        
                                    </a>
                                </li> -->
                                 <!-- 
                                 <li class="nav-item">
                                    <div data-toggle="tab" aria-expanded="false" class="">
                                        <button class="btn btn-sucess">
                                        <span class="text-warning d-none d-md-block tab-hist" >&nbsp; + &nbsp;</span>
                                        </button>
                                    </div>
                                </li>
                                 -->
                            </ul>   
                      </div>
                       <div class="col-2 pl-0 pr-0 text-right" id="divPlusArea" style="border-bottom: 1px solid #4d5764;">
                              
                      </div>
                   </div>
                    <div class="row">
                        <div id="divBodyTopArea" class="col-12">
                            <div class="row pr-2 pl-2" id="pbl-2">
                            	<div class="col-4">
                            		<div class="row">
                            			<div class="col-4 pl-0 pr-0">
			                                <div class="card mb-2">
			                                	<a id="aBodyTopPowder" onclick="javascript:openPopCalulator('Powder');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">파우더</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopPowder" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
			                                </div>
			                            </div>
			                            <div class="col-4 pr-0">
			                                <div class="card mb-2">
			                                	<a id="aBodyTopColoring" onclick="javascript:openPopCalulator('Coloring');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">색소</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopColoring" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
			                                </div>
			                            </div>
			                            <div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopBinder" onclick="javascript:openPopCalulator('Binder');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">바인더</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopBinder" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
		                                    </div>
		                                </div>
			                            
                            		</div>
                            	</div>
                            	<div class="col-4">
                            		<div class="row">
                            			<div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopPearl" onclick="javascript:openPopCalulator('Pearl');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">펄</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopPearl" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
		                                    </div>
		                                </div>
                            			<div class="col-4 pr-0">
			                                <div class="card mb-2">
			                                	<a id="aBodyTopSharp7" onclick="javascript:openPopCalulator('Sharp7');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">#7</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopSharp7" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="number" style="height:50px;font-size:35px">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
			                                </div>
			                            </div>
                            			<div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopRpm" onclick="javascript:openPopCalulator('Rpm');">
			                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
			                                            <h4 class="text-center text-dark">RPM</h4>
			                                            <hr class="mt-1 mb-1" />
			                                            <div class="row">
			                                                <div class="col-12 pt-1">
			                                                    <input id="bodyTopRpm" data-value="" data-ref1=""  class="pr-0 pl-0 form-control text-center" readonly type="number" style="height:50px;font-size:35px">
			                                                </div>
			                                            </div>
			                                        </div>
												</a>
		                                    </div>
		                                </div>
		                                
		                                
                            		</div>
                            	</div>
                                
                            	<div class="col-4">
                            		<div class="row">
	                            		
		                                <div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopTime" onclick="javascript:openPopCalulator('Time');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">시간</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopTime" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="number" style="height:50px;font-size:35px">		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
		                                    </div>
		                                </div>
		                                <div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopHgi" onclick="javascript:openPopCalulator('Hgi');">
			                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
			                                            <h4 class="text-center text-dark">분쇄도</h4>
			                                            <hr class="mt-1 mb-1" />
			                                            <div class="row">
			                                                <div class="col-12 pt-1">
			                                                    <input id="bodyTopHgi" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px" value="">
			                                                </div>
			                                            </div>
			                                        </div>
		                                        </a>
		                                    </div>
		                                </div>
		                                <div class="col-4 pr-0">
		                                    <div class="card mb-2">
		                                    	<a id="aBodyTopGroup" onclick="javascript:openPopCalulator('Group');">
		                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
		                                            <h4 class="text-center text-dark">공정그룹</h4>
		                                            <hr class="mt-1 mb-1" />
		                                            <div class="row">
		                                                <div class="col-12 pt-1">
		                                                    <input id="bodyTopGroup" data-value="" data-ref1="" class="pr-0 pl-0 form-control text-center" readonly type="text" style="height:50px;font-size:35px" value="">
		                                                </div>
		                                            </div>
		                                        </div>
		                                        </a>
		                                    </div>
		                                </div>
                            		</div>
                            	</div>
                            	
                                
                                
                            </div>
                        </div>
                        
                        <div class="col-12 pr-2">
                            <div class="card mb-2" style="height: 565px;">
                                <div class="card-body pt-1 pb-1 pl-2 pr-2">
                                
                                    <div style="display: inline-block">
                                        <h4>제조지시 및 공정기록</h4>
                                    </div>
                                    <hr class="mt-1 mb-1" />
                                    <table id="tbRmgHist" class="table table-stripedtable-sm nowrap" style="width:100%">
									</table>
									
									<div class="row text-center">
                                        <div class="col-12 pt-2">
                                            <button id="btnCtrlTbHistPlus" data-tab="" class="btn btn-block btn-primary" style="font-size: 26px;">
                                                <span style="font-size: 33px;">+</span>
                                                	더 보 기 &nbsp;
                                            </button>
                                            <button id="btnCtrlTbHistMinus" data-tab="" class="btn btn-block btn-primary mt-0" style="font-size: 26px;display: none;">
                                                <span style="font-size: 33px;">-</span>
                                                	접 기 &nbsp;
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-9 pl-2">
                            <div class="card mb-1">
                                <div class="card-body pt-2 pb-2">
                                    <div class="row">
                                        <input id="bodyFooterUserProc" type="text" class="form-control" style="font-size:20px;height:65px;line-height:65px;" value="">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 pr-2 pl-xl-0">
                            <div class="card mb-1">
                                <div class="card-body p-2">
                                    <button id="btnSaveRmgmt" class="btn btn-block btn-primary" style="height:65px;font-size:35px">이 력 등 록</button>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="col-xl-3 pr-0 pl-0">
                    <div class="card mb-1">
                        <div class="card-body pt-1 pb-2">
                            <h4>제조 표준 공정</h4>
                            <hr class="mt-1 mb-2" />
                            <div class="row">
                                <textarea class="form-control" name="engineeringDisign" id="engineeringDisign" cols="100" rows="10" readonly style="font-size:17px"></textarea>
                            </div> <!-- end row-->
                            <div class="row text-center">
                                <div class="col-12 pt-2 pl-0 pr-0">
                                    <button id="btnCtrlAsidePlus" data-tab="" class="btn btn-block btn-primary" style="font-size: 26px;">
                                        <span style="font-size: 33px;">+</span>
                                        	더 보 기 &nbsp;
                                    </button>
                                    <button id="btnCtrlAsideMinus" data-tab="" class="btn btn-block btn-primary mt-0" style="font-size: 26px;display: none;">
                                        <span style="font-size: 33px;">-</span>
                                        	접 기 &nbsp;
                                    </button>
                                </div>
                            </div>
                        </div> <!-- end card-body -->
                    </div> <!-- end card-->
                    <div class="card mb-1">
                        <div class="card-body pt-2 pb-2">
                            <div class="row">
                            	<textarea class="form-control" name="bodyFooterProc" id="bodyFooterProc" cols="100" rows="14" readonly style="font-size:19px"></textarea>
                            </div>
                        </div>
                    </div>
                </div> <!-- end col -->
            </div>

        </main>
        <!-- end page title -->
    </div>

    
    
<!-- pop 추가 area -->
<jsp:include page="./pop/rmgmt-pop-hist.jsp" flush="false"/>
<jsp:include page="./pop/rmgmt-pop-hist-detail.jsp" flush="false"/>
<jsp:include page="./pop/rmgmt-pop-calculator.jsp" flush="false"/>
<!-- pop 추가 area End-->

    <script type="text/javascript" chartset="utf-8">

	
    /********** 전역 
    **************************************************/
 	var _glbBodyTop = {}; //공정별 차수 데이터
 	var _glbBodyTb 	= {}; //공정 기초 데이터
 	
 	var _glbSeq 		= ${Z014J};
 	var _glbCommRpm 	= ${Z011J};
 	var _glbCommTime 	= ${Z012J};
 	var _glbCommHgi 	= ${Z013J};
 	var _glbCommGroup 	= ${B140J};
 	
 	const queryString = JSON.parse('${param2}');


	function fnParamRead() {
		if(ObjUtil.isEmpty(queryString.wkordNum)) return false;
		if(ObjUtil.isEmpty(queryString.equCode)) return false;
		if(ObjUtil.isEmpty(queryString.prodtPrsn)) return false;
		
		return true;
	}
	
	
	/********** 파라미터가 넘어왔을때 실행될 함수들
	**************************************************/
	function fnCheckRead() {
		if(fnParamRead()) {
			$('#frm_m [name="EQU_CODE"]').val(queryString.equCode);
			fnBarcodeScan('02', queryString.wkordNum);
		}
	}
	
	function fnCheckParam() {
		if(fnParamRead()) {
			$('#selPrsn').val(queryString.prodtPrsn);
			
			$('#frm_m [name="PRODT_PRSN"]').val(queryString.prodtPrsn);
			
			$('#h_wkord_num').attr('readonly', true);
			$('#selEqu').attr('disabled', true);
			$('#selPrsn').attr('disabled', true);
		}
	}

	fnCheckRead();

		
	$(document).ready(function () {
		/********** 이벤트 함수 정의.
		**************************************************/
		$("#h_wkord_num").keyup(function(e){
			if(e.keyCode != 13) return;
			if(fnParamRead()) return;
			
			var wkordNum = $(this).val();
			
			if(ObjUtil.isEmpty(wkordNum)) return;
			
			fnBarcodeScan('02', wkordNum);
			
		});

		/***** 이력등록
		*************************/
		$("#btnSaveRmgmt").click(function(e){
			
			if(!confirm("제조이력을 저장하시겠습니까?")) return;
			if(!fnValidate()) return;
			
			var rmgWkordNumList = new Array();
			var arrTopKeys 	= Object.keys(_glbBodyTop).sort();
			var rmgWkordNumDetailList = new Array();
			
			$.each(arrTopKeys, function(index, key){
				$.each(_glbBodyTop[key], function(subIndex, item){
					rmgWkordNumList.push(item);
					
					var rmgDetailList =  $("#tbRmgHist").DataTable().rows().data().filter(function(item){
						if(item.WKORD_NUM_SEQ == key && item.PRODT_Q_G  != "0"){
							return true;
						};
					}).toArray();
					
					rmgWkordNumDetailList = rmgWkordNumDetailList.concat(rmgDetailList);
				});
			});


			/***** 저장
			*************************/
			$.ajax({      
				url     : "${pageContext.request.contextPath}/z_rmgmt/saveRmgmt.do",
				type    : "POST",
				
				data	: {
					RMG 		: JSON.stringify($("#frm_m").serializeObject()),
					RMG_DETAIL 	: JSON.stringify(rmgWkordNumDetailList),
					RMG_SEQ		: JSON.stringify(rmgWkordNumList)
				},
				success : function(data){
					if(data.status){
						AlertsUtil.save(data.msg);
					}else{
						AlertsUtil.error(data.msg);
					}
					
				}
			});
			
			
		});
		// 제조기기 변경 시
		$("#selEqu").change(function(e){
			var thisVal = $(this).val();
			$("#EQU_CODE").val(thisVal);
		});
	
		// 제조자 변경 시
		$("#selPrsn").change(function(e){
			var thisVal = $(this).val();
			$("#PRODT_PRSN").val(thisVal);
		});
		
		// 유저 비고 등록시
		$("#bodyFooterUserProc").keyup(function(e){
			var me = this;
			var activeSeq = $("#ulSeqArea").find("a.active").attr("data-code");
			var arrTopKeys = Object.keys(_glbBodyTop).sort();
			
			$.each(_glbBodyTop[activeSeq], function(index, item){
					item.USER_PROD_PROC 	= $(me).val();
				})
				
				var prodProc = "";
			var userProdProc = "";
			$.each(arrTopKeys, function(index, key){
				
				$.each(_glbBodyTop[key], function(subIndex, item){
					
					if(key == "00") return true;
					
					var bodyTabName = fnFindSeqName(key);
					//prodProc 		+= (item.PROD_PROC == "") 		? "" : (prodProc 		== "" ? "" : "/") + item.PROD_PROC;
					//userProdProc	+= (item.USER_PROD_PROC == "") 	? "" : (userProdProc 	== "" ? "" : "/") + item.USER_PROD_PROC;
					prodProc 		+= (key == "01" ? bodyTabName + ": " : "\n" + bodyTabName + ": ") + item.PROD_PROC;
					prodProc		+= (item.USER_PROD_PROC.replace(" ","") == "") ? "" : "\n(" + item.USER_PROD_PROC + ")";
					userProdProc	+= (key == "01" ? "" : "/") + item.USER_PROD_PROC;
				})
			});
			
			if(userProdProc.replaceAll(" ", "").replaceAll("/", "") == ""){
				userProdProc = "";
			}
			
			// "00" 공정차수에 데이터 put
			$.each(_glbBodyTop["00"], function(subIndex, item){

				item.PROD_PROC		= prodProc;
				item.USER_PROD_PROC	= userProdProc;
				
				});

			if(activeSeq == "00"){
				$("#bodyFooterProc").val(prodProc);
				$("#bodyFooterUserProc").val(userProdProc);
			}
    		/* var userProdProc = "";
    		$.each(arrTopKeys, function(index, key){
    			$.each(_glbBodyTop[key], function(subIndex, item){
    				if(key == "00") return true;
    				
    				//userProdProc	+= (item.USER_PROD_PROC == "") 	? "" : (userProdProc 	== "" ? "" : "/") + item.USER_PROD_PROC;
    				userProdProc	+= (key == "01" ? "" : "/") + item.USER_PROD_PROC;
        		})
    		});
    		
    		if(userProdProc.replaceAll(" ", "").replaceAll("/", "") == ""){
    			userProdProc = "";
    		}
    		// "00" 공정차수에 데이터 put
			$.each(_glbBodyTop["00"], function(subIndex, item){
				item.USER_PROD_PROC	= userProdProc;
       		});
    		
			if(activeSeq == "00"){
				$("#bodyFooterUserProc").val(userProdProc);
			} */

		})
		
		/***** 분쇄도 변경 시
		*************************/
		/* $("#bodyTopHgi").change(function(e){
            
    		var thisVal = $(this).val();
            
    		var seq = $("#ulSeqArea").find("a.active").attr("data-code");
			var arrTopKeys = Object.keys(_glbBodyTop).sort();
    		
        	$.each(_glbBodyTop[seq], function(index, item){
       			item.HGI_Q_CD 	= thisVal;
       		})
        		
       		// "00" : 전체 공정차수에 최대값으로 변경
       		var hgiQ	= "00";
       		$.each(arrTopKeys, function(index, key){
       			
       			if(key == "00") return true;
       			
       			$.each(_glbBodyTop[key], function(subIndex, item){
           			
       				hgiQ = (parseFloat(hgiQ) > parseFloat(item.HGI_Q_CD)) ? hgiQ : item.HGI_Q_CD;
           		})
       		});
       		
       		// "00" 공정차수에 데이터 put
			$.each(_glbBodyTop["00"], function(subIndex, item){
           		item.HGI_Q_CD  	= hgiQ;
			});
       		
			fnDrawFooterProc(seq);
        }); */
    
		/***** 탭 추가
		*************************/
		$(document).on("click", "#btnAddTabSeq", function(e){
			fnDrawNewSeq();
		})
		
		$(document).on("click", "#btnDeleteTab", function(e){
			
			var DelTabSeqCode = $("#btnDeleteTab").val();
			var DelTabSeqName = fnFindSeqName(DelTabSeqCode);
			
			if(confirm(DelTabSeqName + " 삭제하시겠습니까?")){
				fnDeleteLastTabSeq();
			}
		})
		
		
		/***** 테이블 더보기 클릭 시
		*************************/
		$(document).on("click", "#btnCtrlTbHistPlus", function(e){
			var seq = $(this).attr("data-tab");
			
			fnFilterTbHist(seq, "N");
			
			$(this).hide();
			$("#btnCtrlTbHistMinus").show();
		});
		/***** 테이블 접기 클릭 시
		*************************/
		$(document).on("click", "#btnCtrlTbHistMinus", function(e){
			var seq = $(this).attr("data-tab");
			
			fnFilterTbHist(seq, "Y");
			
			$(this).hide();
			$("#btnCtrlTbHistPlus").show();
		});
		
		/***** Aside 더보기 클릭 시
		*************************/
		$(document).on("click", "#btnCtrlAsidePlus", function(e){
			
			$("#engineeringDisign").attr("rows", 21);
			$("#bodyFooterProc").attr("rows", 4);
			
			$(this).hide();
			$("#btnCtrlAsideMinus").show();
		});
		/***** 테이블 접기 클릭 시
		*************************/
		$(document).on("click", "#btnCtrlAsideMinus", function(e){
			$("#engineeringDisign").attr("rows", 10);
			$("#bodyFooterProc").attr("rows", 14);
			
			$(this).hide();
			$("#btnCtrlAsidePlus").show();
		});
		
		/***** 제조이력 상세 버튼 클릭시
		*************************/
		$(document).on("click", "[name=btn_pop_rmgmt_hist_detail]", function(e){
			
			openPopHistDetail(this);
			
		});
		
		$(document).on("click", "[name=tb_input_prodt_q_g]", function(e){
			
			openPopCalulatorGrid("G", $(this));
		});
		
		$(document).on("click", "[name=tb_input_prodt_q_p]", function(e){
			
			openPopCalulatorGrid("P", $(this));
		});
		
		
		fnInit();

 		//fnBarcodeScan('02', '02P20210415108', 'H120', 'M2305');
 		//fnBarcodeScan('02', '02P20210217001', 'H120', 'M2305');
 		//fnBarcodeScan('02', '02P20210216097', 'H120', 'M2307');
 		
 		
 		//fnBarcodeScan('02', '02P20190605001', 'H120', 'M2305');
 		//fnBarcodeScan('02', '02P20190605002', 'H120', 'M2305');
 		//fnBarcodeScan('02', '02P20190612003', 'H120', 'M2305');
 		//fnBarcodeScan('02', '02P20190612039', 'H120', 'M2305');
 		
 		
	})
	
	/********** 초기화.
    **************************************************/
	function fnInit() {
		
		// 제조이력 hist 테이블 생성
		$("#tbRmgHist").DataTable({
	        /*객체 순서.*/
	        /*l - length changing input control
	        f - filtering input
	        t - The table!
	        i - Table information summary
	        p - pagination control
	        r - processing display element*/
	        /*dom: "Blfrtip",*/
	        /*"dom": '<"top"iflp<"clear">>rt<"bottom"iflp<"clear">>',*/
	        dom : "" 
					/* + "<'hr'>" + "<'row'<'col-6'l><'col-6'f>>" */
					+ "<'row'<'col-12'tr>>" //col-12
					+ "<'row'<'col-sm-6'i><'col-sm-6'p>>",
	        autoWidth 	: true,
	        select      : false,
	        paging      : false,
	        ordering    : true,
	        info        : false,
	        filter      : true,
	        lenghChange : true,
	        lengthChange: true,
	        order       : [],
	        stateSave   : false,
	        pagingType  : "full_numbers",
	        pageLength  : 9,
	        lengthMenu  : [5, 10, 25, 50, 100],
	        processing  : false,
	        serverside  : false,
	        scrollX		: true,
	        scrollY		: "350px",
	        scrollCollapse	: true,
	        buttons     : [{
	            extend      : "excel",
	            text        : "엑셀",
	            footer      : true,
	            className   : "exportBtnExcel"
	        },{
	            extend      : "pdf",
	            text        : "PDF",
	            footer      : true,
	            className   : "exportBtnPdf"
	        }],
	        
	        language  : {
	            "emptyTable": "데이터가 존재하지 않습니다.",
	            "lengthMenu": "페이지당 _MENU_ 개씩 보기",
	            "info"      : "현재 _START_ - _END_ / _TOTAL_건",
	            "infoEmpty" : "데이터가 존재하지 않습니다.",
	            "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
	            "search"    : "검색: ",
	            "zeroRecords": "일치하는 데이터가 없어요.",
	            "loadingRecords": "로딩중...",
	            "processing": "잠시만 기다려 주세요...",
	            "paginate"  : {
	                "first"     : "처음",
	                "next"      : "다음",
	                "previous"  : "이전",
	                "last"      : "마지막"
	            }
	        },
	        createdRow: function(row, data, dataIndex, cells) {
	        },
	        columns: [
	            { title: "rowIdx",	data : "rowIdx",				width:"0%" },
	            { title: "그룹",		data : "GROUP_CODE",			width:"7%" },
	            { title: "No.",		data : "SEQ",					width:"7%" },
	            { title: "원료코드",   	data : "CHILD_ITEM_CODE",		width:"10%" },
	            { title: "시험번호",	data : "LOT_NO",				width:"10%" },
	            { title: "원료명",	    data : "CHILD_ITEM_NAME",		width:"12%" },
	            { title: "단위",		data : "STOCK_UNIT",			width:"8%" },
	            { title: "함량(%)",	data : "UNIT_Q",				width:"11%" },
	            { title: "이론량(g)",	data : "ALLOCK_Q",				width:"11%" },
	            { title: "계량량(g)",	data : "PRODT_Q_G",				width:"12%" },
	            { title: "계량량(%)",	data : "PRODT_Q_P",				width:"7%" },
	            { title: "상세",		data : "btn_search",			width:"5%" },
	            { title: "사업장",		data : "DIV_CODE",				width:"0%" },
	            { title: "작업지시번호",	data : "WKORD_NUM",				width:"0%" },
	            { title: "공정코드",	data : "PROG_WORK_CODE",		width:"0%" },
	            { title: "공정차수",	data : "WKORD_NUM_SEQ",			width:"0%" },
	            { title: "제품코드",	data : "ITEM_CODE",				width:"0%" },
	            { title: "변경여부",	data : "SHOW_YN",				width:"0%" },
	            { title: "공정차수",	data : "WKORD_NUM_SEQ",			width:"0%" },
	            { title: "차수변경여부",	data : "SEQ_SHOW_YN",			width:"0%" },
	            { title: "저장일시",	data : "INSERT_DB_TIME",		width:"0%" },
	            { title: "",		data : "REF_TYPE",				width:"0%" },
	            { title: "",		data : "PATH_CODE",				width:"0%" },
	            { title: "",		data : "DATA_EXIST_YN",			width:"0%" },
	            { title: "그룹",		data : "GROUP_NAME",			width:"0%" }
	            
	        ],
			
	        columnDefs: [
	        	{
	        		targets : 0,
	        		orderable: true,
	        		className: "text-center",
	        		visible: false,
	        		render : function(data, type, row, meta){
	        			row.rowIdx = meta.row;
	        			return meta.row;
	        		}
	        	},{
	        		targets : [1,2,3],
	        		orderable: true,
	        		className: "text-center"
	        	},{
	        		targets : 4,
	        		orderable: true,
	        		className: "text-center td-lot-no",
	        		render : function(data, type, row){
	        			return (ObjUtil.isEmpty(data) ? "" : data);
	        		}
	        		
	        	},{
	        		targets : 5,
	        		orderable: true,
	        		className: "dt-head-center"
	        	},{
	        		targets : 6,
	        		orderable: true,
	        		className: "text-center"
	        	},{
	        		targets : 7,
	        		orderable: true,
	        		className: "dt-head-center dt-body-right"
	        	},{
	        		targets : 8,
	        		orderable: true,
	        		className: "dt-head-center dt-body-right",
	        		render : function(data, type, row){
	        			
	        			return StringUtil.formatNumber(data);
	        		}
	        	},{
	        		targets : 9,
	        		orderable: false,
	        		className: "dt-head-center pr-1 pl-1 pb-1 pt-1",
	        		render : function(data, type, row){
	        			var html = '<input type="text" style="height:45px;width:120px;font-size:23px;" class="text-right form-control gr-ctr"  name="tb_input_prodt_q_g" readonly value="' + StringUtil.formatNumber(data) + '">';
	        			
	        			return html;
	        		}
	        	},{
	        		targets : 10,
	        		orderable: false,
	        		className: "dt-head-center pr-1 pl-1 pb-1 pt-1",
	        		render : function(data, type, row){
	        			var html = '<input type="text" style="height:45px;width:100px;font-size:23px;" class="text-right form-control gr-ctr"  name="tb_input_prodt_q_p" readonly value="' + StringUtil.formatNumber(data) + '">';
	        			
	        			return html;
	        		}
	        	},{
	        		targets : 11,
	        		orderable: true,
	        		className: "text-center",
	        		render : function(data, type, row){
	        			var html = '';
	        			if(row.SHOW_YN == "Y")
	        				html = '<button class="btn btn-outline-info btn-hist-info" style="height: 45px;" name="btn_pop_rmgmt_hist_detail">&nbsp;&gt;&nbsp;</button>';
	        			
	        			return html;
	        		}
	        	},{
	        		targets:[12,13,14,15,16,17,18,19,20,21,22,23,24],
	        		visible: false
	        	}
	        ],
	        drawCallback: function () {
	        }
	    });
 		
 	}
        	
 	/********** 유효성 검사.
    **************************************************/
    function fnValidate() {
		
		var isValidate 		= true;
		var loadWkordNum 	= $("#LOAD_WKORD_NUM").val();
		var wkordNum 		= $("#WKORD_NUM").val();
		var dataExistYn 	= $("#DATA_EXIST_YN").val();
		var dtInsert		= $("#MAX_INSERT_DB_TIME").val();
		
		if(_glbBodyTop.length <= 0){
			isValidate = false;
			alert("저장 할 내용이 없습니다.");
			return isValidate;
		};
		
		if(dataExistYn == "Y" && loadWkordNum != wkordNum) {
			var insDate = DateUtil.toString(parseInt(dtInsert), "yyyy/MM/dd HH:mm:ss")
			alert("이미 제조공정 이력이 등록된 제조공정이력은 저장할 수 없습니다. \n작업지시번호 : " + loadWkordNum + " 입력일시 : " + insDate);
			isValidate = false;
			return isValidate;
		}
		
		var tabSeq 		= "";
		var tabSeqNm 	= "";
		var errObjName	= "";
		var arrTopKeys 	= Object.keys(_glbBodyTop).sort();
		$.each(arrTopKeys, function(index, key){
		
			if(key != "01") return true;
			
			tabSeq 		= key;
			tabSeqNm 	= fnFindSeqName(key);
			
			$.each(_glbBodyTop[key], function(subIndex, item){
				
				var msg 		= "";
				
				/***** “시작” 선택시 RPM, Time는 공통 필수 입력, 1차공정시 파우더색소 필수 입력 체크 *****/

				// Rpm 체크
				if(ObjUtil.isEmpty(item.RPM_Q) || item.RPM_Q == "0"){
					errObjName = "Rpm";
					msg += ((msg=="") ? "":", ") + errObjName;
					isValidate = false;
				}
				// Time 체크
				if(ObjUtil.isEmpty(item.TIME_Q) || item.TIME_Q == "0"){
					errObjName = "Time";
					msg += ((msg=="") ? "":", ") + errObjName;
					isValidate = false;
				}
				// Powder 체크
				/* if(key == "01" && (ObjUtil.isEmpty(item.POWDER_Q) || item.POWDER_Q == "0")){
					errObjName = "Powder";
					msg += ((msg=="") ? "":", ") + errObjName;
					isValidate = false;
				} */
				
				if(!isValidate){
					
					alert(tabSeqNm + " 에서" + msg + "은(는) 필수 입력사항 입니다.");
					return isValidate; //break;
				};

			});
			
			if(!isValidate){
				$("#aBodyTopSeq" + tabSeq).trigger("click");
				return isValidate;
			};
		});

		return isValidate;
	}
	
	
    /********** 사용자 정의 함수.
    **************************************************/
    /***** 바코드 스캔
 	*************************/
    function fnBarcodeScan(divCode, wkordNum, progWorkCode){
		
		//$("#selEqu").val(equCode);
		var equCode = $("#EQU_CODE").val();
		if(ObjUtil.isEmpty(equCode)){
			equCode = $("#selEqu").val();
			$("#EQU_CODE").val(equCode);
		}
		/***** header(마스터) 조회
		*************************/
		$.ajax({
			url     : "${pageContext.request.contextPath}/z_rmgmt/getHeader.do",
			type    : "POST",
			data	: {
				DIV_CODE 		: divCode,
				WKORD_NUM 		: wkordNum,
				PROG_WORK_CODE	: progWorkCode,
				EQU_CODE		: equCode
			},
			async: false,
			success : function(data){
				if(!ObjUtil.isEmpty(data) && data.length > 0){
					
					var prodtDate = ObjUtil.isEmpty(data[0].PRODT_DATE) ? "" : DateUtil.toString(data[0].PRODT_DATE, "yyyy.MM.dd");
					
					$("#h_item").text(data[0].ITEM_NAME);
					$("#h_wkord_num").val(wkordNum);
					$("#h_lot_no").text(ObjUtil.blank(data[0].LOT_NO));
					$("#h_prodt_date").text(prodtDate);
					$("#h_wkord_q").text(StringUtil.formatNumber(data[0].WKORD_Q) + " (G)");
					$("#h_work_q").text(StringUtil.formatNumber(data[0].WORK_Q) + " (G)");
					
					// form_m 에 데이터 관리
					$("#DIV_CODE").val(divCode);
					$("#WKORD_NUM").val(wkordNum);
					$("#LOAD_WKORD_NUM").val(data[0].LOAD_WKORD_NUM);
					$("#LOAD_PROG_WORK_CODE").val(data[0].LOAD_PROG_WORK_CODE);
					$("#DATA_EXIST_YN").val(data[0].DATA_EXIST_YN);
					$("#MAX_INSERT_DB_TIME").val(data[0].MAX_INSERT_DB_TIME)
					$("#USE_WKORD_Q_YN").val(data[0].USE_WKORD_Q_YN)
					$("#PROG_WORK_CODE").val(data[0].PROG_WORK_CODE);
					$("#ITEM_CODE").val(data[0].ITEM_CODE);
					$("#LOT_NO").val(data[0].LOT_NO);
					$("#WKORD_Q").val(data[0].WKORD_Q);
					$("#PRODT_DATE").val(data[0].PRODT_DATE);

					if(ObjUtil.isEmpty(data[0].EQU_CODE)){
						/* $("#EQU_CODE").val(equCode);
						$("#selEqu").val(equCode); */
					}else{
						$("#EQU_CODE").val(data[0].EQU_CODE);
						$("#selEqu").val(data[0].EQU_CODE);	
					}

					$("#PRODT_PRSN").val(data[0].PRODT_PRSN);
					$("#selPrsn").val(data[0].PRODT_PRSN);
					
				}else{
					$("#h_item").text("");
					$("#h_lot_no").text("");
					$("#h_prodt_date").text("");
					$("#h_wkord_q").text("");
					$("#h_work_q").text("");
					
					// form_m 에 데이터 관리
					$("form").each(function() {
						if(this.id == "frm_m") this.reset();
					});
				}
		
				fnCheckParam();
			}
		});
		
		/***** Aside(제조공정) 조회
		*************************/
		$.ajax({
			url     : "${pageContext.request.contextPath}/z_rmgmt/getAside.do",
			type    : "POST",
			data	: {
				DIV_CODE 		: divCode,
				WKORD_NUM 		: wkordNum,
				PROG_WORK_CODE	: $("#PROG_WORK_CODE").val()
			},
			success : function(subData){
				if(!ObjUtil.isEmpty(subData)){
					var strAside = "";
					$.each(subData, function(index, item){
						if(strAside != "") strAside += "\n";
						strAside += item.PROC_DRAW;
					});
					
					$("#engineeringDisign").val(strAside);
				}else{
					$("#engineeringDisign").val("");
				}
			}
		});
		
		var itemCode 	= $("#ITEM_CODE").val();
		var wkordQ 		= $("#WKORD_Q").val();
		var maxInsertDt = $("#MAX_INSERT_DB_TIME").val();
		var useWkordQYn = $("#USE_WKORD_Q_YN").val();
		
		if(!ObjUtil.isEmpty(maxInsertDt)){
			var timeStamp = new Date(parseInt(maxInsertDt));
			maxInsertDt = DateUtil.toString(parseInt(maxInsertDt), "yyyy-MM-dd HH:mm:ss");
			maxInsertDt += "." + String(timeStamp.getMilliseconds()).padStart(3, '0');
		}

		/***** Body(공정차수 및 테이블) 조회
		*************************/
		$.ajax({
			url     : "${pageContext.request.contextPath}/z_rmgmt/getBody.do",
			type    : "POST",
			data	: {
				DIV_CODE 			: divCode,
				WKORD_NUM 			: wkordNum,
				PROG_WORK_CODE		: $("#PROG_WORK_CODE").val(),
				ITEM_CODE			: itemCode,
				WKORD_Q				: wkordQ,
				EQU_CODE			: equCode,
				MAX_INSERT_DB_TIME 	: maxInsertDt,
				USE_WKORD_Q_YN		: useWkordQYn
			},
			success : function(subData){
				if(!ObjUtil.isEmpty(subData)){
					_glbBodyTop = subData.bodyTop;
					_glbBodyTb = subData.bodyTb;
					
					fnDrawWkordNumSeq();
					fnSetBody("00");
				}else{
					fnDrawTb(_glbBodyTb, "#tbRmgHist");
				};
			}
		});
	
	}

	function fnPopupSearch(divCode, popWkordNum, popProgWorkCode){
		
		$("#LOAD_WKORD_NUM").val(popWkordNum);
		$("#LOAD_PROG_WORK_CODE").val(popProgWorkCode);
		
		/***** Body(공정차수 및 테이블) 조회
		*************************/
		$.ajax({
			url     : "${pageContext.request.contextPath}/z_rmgmt/getBodyToPopup.do",
			type    : "POST",
			data	: {
				DIV_CODE 			: divCode,
				WKORD_NUM 			: $("#WKORD_NUM").val(),
				PROG_WORK_CODE		: $("#PROG_WORK_CODE").val(),
				P_WKORD_NUM			: popWkordNum,
				P_PROG_WORK_CODE	: popProgWorkCode
				
			},
			success : function(subData){
				if(!ObjUtil.isEmpty(subData)){
					_glbBodyTop = subData.bodyTop;
					_glbBodyTb = subData.bodyTb;
					
					fnDrawWkordNumSeq();
					fnSetBody("00");
				}else{
					fnDrawTb(_glbBodyTb, "#tbRmgHist");
				};
			}
		});
	}

    /***** get WkordNumSeq Name
	*************************/
	function fnFindSeqName(pCode){
		
		var rtnName = "";
		$.each(_glbSeq, function(index, item){
			
			if(item.CODE_CD == pCode){
				rtnName = item.CODE_NM;
				
				return false; // 찾으면 Break;
			}
		});
		
		return rtnName;
	}
    
    /***** Body Tab Draw
	*************************/
    function fnDrawWkordNumSeq(){
		
		$("#ulSeqArea").html("");
		
		if(ObjUtil.isEmpty(_glbBodyTop)){
			
			_glbBodyTop = {
				"00" : [{
					WKORD_NUM_SEQ 	: "00",
					RPM_Q : "0",
					TIME_Q : "0",
					SHARP_7_Q : "0",
					POWDER_YN : "N",
					COLORING_YN : "N",
					BINDER_YN : "N",
					PEARL_YN : "N",
					HGI_Q_CD : "00",
					PROC_GROUP_CD : "",
					PROD_PROC : "",
					USER_PROD_PROC : ""
				}],
				"01" : [{
					WKORD_NUM_SEQ 	: "01",
					RPM_Q : "0",
					TIME_Q : "0",
					SHARP_7_Q : "0",
					POWDER_YN : "N",
					COLORING_YN : "N",
					BINDER_YN : "N",
					PEARL_YN : "N",
					HGI_Q_CD : "00",
					PROC_GROUP_CD : "",
					PROD_PROC : "",
					USER_PROD_PROC : ""
				}]
			};
			
		}

    	var arrTopKeys = Object.keys(_glbBodyTop).sort();
  		if(arrTopKeys.length > 0){
	   		$.each(arrTopKeys, function(index, item){
	       		
	       		var name = fnFindSeqName(item);
	       		
	       		fnAddBtnTabSeq(item, name, "N");

	       	});
	   		
	   		//x 
	   		if(_glbSeq[arrTopKeys.length - 1].REF_CODE1 != "Y"){
	   			fnAddBtnTabSeqDel(_glbSeq[arrTopKeys.length -1].CODE_CD);
    		}
	       	
	   		if(_glbSeq.length > arrTopKeys.length){
	       		
	       		var nextSeq = _glbSeq[arrTopKeys.length].CODE_CD;
	       		
	       		fnAddBtnTabSeqPlus(nextSeq);
	       	}
       	}
    	
    };
    
    /***** Body Tab 공정 생성
	*************************/
	function fnDrawNewSeq(){
		
		var addTabSeqCode = $("#btnAddTabSeq").val();
		var addTabSeqName = fnFindSeqName(addTabSeqCode);
		
		//탭 생성
		fnAddBtnTabSeq(addTabSeqCode, addTabSeqName, "Y");
		
		//body data 제어 
		fnAddBodyData(addTabSeqCode);
		
		var arrTopKeys = Object.keys(_glbBodyTop).sort();
		var addSeq = _glbSeq[arrTopKeys.length - 1].CODE_CD;
		//기존 + button tab 삭제
		$("#divAddTabSeq").remove();
		$("#liDeleteTabSeq").remove();
		
		fnAddBtnTabSeqDel(addSeq);
		//공통코드 에 존재하는 공정코드보다 작을 시 + tab 생성
		if(_glbSeq.length > arrTopKeys.length){
			
			var nextSeq = _glbSeq[arrTopKeys.length].CODE_CD;
			
			fnAddBtnTabSeqPlus(nextSeq);
			
		}
		
		$("#aBodyTopSeq" + addTabSeqCode).trigger("click");
	}
    
    /***** Body Tab 마지막 공정 삭제
	*************************/
	function fnDeleteLastTabSeq(){
		
		var DelTabSeqCode = $("#btnDeleteTab").val();
		var activeWkordNumSeq = $("#ulSeqArea").find("a.active").attr("data-code");
		
		// 필수 공정차수인지 체크 
		// ref_code1 : 기본적으로 존재해야 되는 공정
		
		
		// 삭제되는 차수 코드
		var beforeDelCode = fnGetCode(_glbSeq, DelTabSeqCode, "CODE_CD");
		
		// 객체에서 차수 데이터 삭제
		delete _glbBodyTop[beforeDelCode];
		
		// 삭제 후 마지막 코드
		var arrTopKeys = Object.keys(_glbBodyTop).sort();
		var bodyTopLastSeq = _glbSeq[arrTopKeys.length - 1].CODE_CD;
		
		/************************************/
		
		//공정 설비 정보 재 집계
		fnBodyTopAggrs();
		
		// 해당 차수의 row를 삭제
		var tbDeleteRows = _glbBodyTb.filter(function(item){
			return item.WKORD_NUM_SEQ  == DelTabSeqCode;
		})

		$.each(tbDeleteRows.reverse(), function(index, tbDeleteRow){
			_glbBodyTb.splice(tbDeleteRow.rowIdx, 1);
		})
		//차수별 제조이력tb re Sum........
		fnSumBobyTbSeqs();
		/************************************/
		
		// 추가 삭제 버튼 제거
		$("#liDeleteTabSeq").remove();
		$("#divAddTabSeq").remove();
		
		// 현재 active 되어 있는 탭이 삭제 대상이라면
		// 삭제 대상 이전 탭으로 active 변경
		if(DelTabSeqCode == activeWkordNumSeq){
			$("#aBodyTopSeq" + bodyTopLastSeq).trigger("click");
		}
		$("#liBodyTopSeq" + beforeDelCode).remove();
		
		
		// 새로운 추가 제거 버튼 생성
		if(_glbSeq[arrTopKeys.length - 1].REF_CODE1 != "Y"){
				fnAddBtnTabSeqDel(bodyTopLastSeq);
		}
		var nextSeq = _glbSeq[arrTopKeys.length].CODE_CD;
		fnAddBtnTabSeqPlus(nextSeq);
		
		//공정 약어 재 생성.......
		$.each(arrTopKeys, function(index, item){
			fnDrawFooterProc(item);
		})
		
	}
    
    /***** Body Tab 공정 draw
	*************************/
	function fnAddBtnTabSeq(pCode, pName, pNew){
		var seqHtml = '';
		seqHtml += '<li class="nav-item" id="liBodyTopSeq' + pCode + '">';
		if(pNew == "N" ){
			seqHtml += '    <a id="aBodyTopSeq' + pCode + '" onClick="javascript:fnSetBody(\''+ pCode +'\');" data-toggle="tab" data-code="'+ pCode +'" aria-expanded="false" class="nav-link ' + (pCode == "00" ? "active" : "") + '">';	
		}else{
			seqHtml += '    <a id="aBodyTopSeq' + pCode + '" onClick="javascript:fnSetBody(\''+ pCode +'\');" data-toggle="tab" data-code="'+ pCode +'" aria-expanded="false" class="nav-link">';
		}
		
		//seqHtml += '        <i class="mdi mdi-home-variant d-md-none d-block"></i>';
		seqHtml += '        <span class="d-md-none d-block tab-hist">' + pName + '</span>';
		seqHtml += '        <span class="d-none d-md-block tab-hist">' + pName + '</span>';
		seqHtml += '    </a>';
		seqHtml += '</li>';
		
		$("#ulSeqArea").append(seqHtml);
	}

    /***** Body Tab 공정  + 버튼 draw
	*************************/
	function fnAddBtnTabSeqPlus(pNextSeq){
		var liHtml = "";
		//liHtml += '<li class="nav-item" id="liAddTabSeq">';
		liHtml += '    <div id="divAddTabSeq" data-toggle="tab" aria-expanded="false" class="">';
		liHtml += '        <button class="btn" id="btnAddTabSeq" value="' + pNextSeq + '">';
		liHtml += '        <span class="text-warning d-none d-md-block tab-plus" >&nbsp; + 추가 &nbsp;</span>    ';
		liHtml += '        </button>';
		liHtml += '    </div>';
		//liHtml += '</li>';
		
		$("#divPlusArea").html(liHtml);
	}
    
    function fnAddBtnTabSeqDel(pSeq){
		var liHtml = "";
		liHtml += '<li class="nav-item" id="liDeleteTabSeq">';
		liHtml += '    <div data-toggle="tab" aria-expanded="false" class="">';
		liHtml += '        <button class="btn" id="btnDeleteTab" value="' + pSeq + '">';
		liHtml += '        <span class=" d-none d-md-block tab-minus" >x &nbsp&nbsp</span>    ';
		liHtml += '        </button>';
		liHtml += '    </div>';
		liHtml += '</li>';
		
		$("#ulSeqArea").append(liHtml);
	}
    
    /***** BodyTob & tb Setting
	*************************/
    function fnSetBody(pSeq){
		
		if(pSeq == "00"){
			$("#bodyFooterUserProc").attr("disabled",true);
		}else{
			$("#bodyFooterUserProc").removeAttr("disabled");
		}
		
		//펼치기 접기 tab data init 및 더보기 변경
		$("#btnCtrlTbHistPlus").attr("data-tab", pSeq);
		$("#btnCtrlTbHistPlus").show();
		$("#btnCtrlTbHistMinus").attr("data-tab", pSeq);
		$("#btnCtrlTbHistMinus").hide();
		
		var arrTopKeys = Object.keys(_glbBodyTop);
		
		// 데이터에 존재하는 공정 차수일 때
		if(arrTopKeys.includes(pSeq)){
			
			$.each(_glbBodyTop[pSeq], function(index, item){
				$("#bodyTopRpm").val(item.RPM_Q);
				$("#bodyTopTime").val(item.TIME_Q);
				$("#bodyTopSharp7").val(item.SHARP_7_Q);
				$("#bodyTopPowder").val((item.POWDER_YN == "N") ? "OFF" : "ON");
				$("#bodyTopColoring").val((item.COLORING_YN == "N") ? "OFF" : "ON");
				$("#bodyTopBinder").val((item.BINDER_YN == "N") ? "OFF" : "ON");
				$("#bodyTopPearl").val((item.PEARL_YN == "N") ? "OFF" : "ON");
				$("#bodyTopHgi").val(fnGetCode(_glbCommHgi, item.HGI_Q_CD, "CODE_NM"));
				$("#bodyTopGroup").val(item.PROC_GROUP_CD);
				$("#bodyFooterProc").val(item.PROD_PROC);
				$("#bodyFooterUserProc").val(item.USER_PROD_PROC);
				
				$("#bodyTopRpm").attr("data-value", item.RPM_Q);
				$("#bodyTopTime").attr("data-value", item.TIME_Q);
				$("#bodyTopSharp7").attr("data-value", item.SHARP_7_Q);
				$("#bodyTopPowder").attr("data-value", item.POWDER_YN);
				$("#bodyTopColoring").attr("data-value", item.COLORING_YN);
				$("#bodyTopBinder").attr("data-value", item.BINDER_YN);
				$("#bodyTopPearl").attr("data-value", item.PEARL_YN);
				$("#bodyTopHgi").attr("data-value", item.HGI_Q_CD);
				$("#bodyTopGroup").attr("data-value", item.PROC_GROUP_CD);
				$("#bodyFooterProc").attr("data-value", item.PROD_PROC);
				$("#bodyFooterUserProc").attr("data-value", item.USER_PROD_PROC);
				
				fnSetBodyTopColor(item);
			})
    		
    		// Hist Table Data binding
			fnDrawTb(_glbBodyTb, "#tbRmgHist");
        	// 최근 이력이 존재하는 로우만 필터
			fnFilterTbHist(pSeq);
		}
	}
    
	function fnGetCode(pArray, pCode, pType){
		var arrComm = pArray.filter(function(codeInfo){
			return codeInfo.CODE_CD == pCode
		});
		
		var rtnStr = "";
		if(arrComm.length > 0){
			
			if(pType == "CODE_CD"){
				rtnStr = arrComm[0].CODE_CD;
			}else if(pType == "CODE_NM"){
				rtnStr = arrComm[0].CODE_NM;
			}else if(pType == "REF_CODE1"){
				rtnStr = arrComm[0].REF_CODE1;
			}
		}
		return rtnStr;
	}
    
    /***** table draw
	*************************/
	function fnDrawTb(pData, pId) {
		var table = $(pId).DataTable();
		table.clear();

		if(!ObjUtil.isEmpty(pData)){
			table.rows.add(pData)
		};
		table.draw();
	}
    /***** main 제조이력 테이블 필터
    *************************/
	function fnFilterTbHist(pSeq, pShowYn){
		
		fnDrawTb(_glbBodyTb, "#tbRmgHist");
		var seqShowYn = "" + pSeq + "Y";
		var table = $("#tbRmgHist").DataTable();
		
		if(ObjUtil.isEmpty(pShowYn)){
			
			var bodyTbFilter = _glbBodyTb.filter(function(item){
				return (item.WKORD_NUM_SEQ == pSeq && item.SEQ_SHOW_YN == seqShowYn);
			});

			if(bodyTbFilter.length > 0){
				table.columns().search('').columns(19).search("^" + seqShowYn + "$", true, false).draw();

			}else{
				table.columns().search('').columns(18).search("^" + pSeq + "$", true, false).draw();
				$("#btnCtrlTbHistPlus").hide();
				$("#btnCtrlTbHistMinus").show();
			}


		}else{
			if(pShowYn == "Y"){
				table.columns().search('').columns(19).search("^" + seqShowYn + "$", true, false).draw();
			}else{
				table.columns().search('').columns(18).search("^" + pSeq + "$", true, false).draw();
			}
		}
	}

	/***** body 공정 차수 add 함수
	*************************/
	function fnAddBodyData(pWkordNumSeq){
		// bodyTop 추가
		_glbBodyTop[pWkordNumSeq] = [{
			WKORD_NUM_SEQ 	: pWkordNumSeq,
			RPM_Q : "0",
			TIME_Q : "0",
			SHARP_7_Q : "0",
			POWDER_YN : "N",
			COLORING_YN : "N",
			BINDER_YN : "N",
			PEARL_YN : "N",
			HGI_Q_CD : "00",
			PROC_GROUP_CD : "",
			PROD_PROC : "",
			USER_PROD_PROC : ""
		}];
		
		
		//clon 생성
		var clonBodyTb = JSON.parse(JSON.stringify(_glbBodyTb));
		//wkord_num_seq = 00 만 찾는다.
		var newBodyTb = clonBodyTb.filter(function(item){
			return item.WKORD_NUM_SEQ == "00";
		})
		//wkord_num_seq = 신규 seq로 변경 및 초기화
		var changeSeqBodyTb = newBodyTb.map(function(item, index){
			item.WKORD_NUM_SEQ 	= pWkordNumSeq;
			item.PRODT_Q_G 		= 0;
			item.PRODT_Q_P 		= 0;
			item.SHOW_YN 		= "N";
			item.SEQ_SHOW_YN 	= "" + pWkordNumSeq + "N";
			return item;
		})
		
		// 신규 생성한 arr를 기존arr과 합쳐준다.
		_glbBodyTb = _glbBodyTb.concat(changeSeqBodyTb);

	}
	
	/********** 팝업 창 호출 함수
	 **************************************************/
	/***** rmgmt-pop-hist open 함수
	*************************/
	function openPopHist(){
		_glbRmgmtPopHist = {
				DIV_CODE 	: $("#DIV_CODE").val(),
				ITEM_CODE 	: $("#ITEM_CODE").val(),
				ITEM_NAME	: $("#h_item").text(),
				EQU_CODE 	: $("#EQU_CODE").val(),
				EQU_NAME	: $("#selEqu option:checked").text(),
				WKORD_Q		: $("#WKORD_Q").val()
				
		};	
		$("#rmgmtPopHist").modal("show");
	}
    
    /***** rmgmt-pop-hist-detail open 함수
	*************************/
	function openPopHistDetail(me){
		var table = $("#tbRmgHist").DataTable();
		var tableRow = table.rows($(me).parents("tr")).data()[0];
			
		_glbRmgmtPopHistDetail = {
				DIV_CODE 		: tableRow.DIV_CODE,
				WKORD_NUM 		: tableRow.WKORD_NUM,
				PROG_WORK_CODE 	: tableRow.PROG_WORK_CODE,
				WKORD_NUM_SEQ 	: tableRow.WKORD_NUM_SEQ,
				ITEM_CODE		: $("#ITEM_CODE").val(),
				CHILD_ITEM_CODE : tableRow.CHILD_ITEM_CODE,
				REF_TYPE 		: tableRow.REF_TYPE,
				PATH_CODE 		: tableRow.PATH_CODE,
				EQU_CODE		: $("#EQU_CODE").val(),
				WKORD_Q			: $("#WKORD_Q").val(),
				USE_WKORD_Q_YN	: $("#USE_WKORD_Q_YN").val()

		};
			
		$("#rmgmtPopHistDetail").modal("show");
	}
    
    /***** rmgmt-pop-calculator
    - (form click) open 함수
	*************************/
	function openPopCalulator(pLoc){

		var wkordNumSeq = $("#ulSeqArea").find("a.active").attr("data-code");
		if (wkordNumSeq == "00") return;
		
		_glbRmgmtPopCalc = {
				loc		: pLoc,
				seq		: wkordNumSeq,
				rpm  	: {obj : $("#bodyTopRpm"), 		value : $("#bodyTopRpm").attr("data-value")},
				time 	: {obj : $("#bodyTopTime"), 	value : $("#bodyTopTime").attr("data-value")},
				sharp7 	: {obj : $("#bodyTopSharp7"), 	value : $("#bodyTopSharp7").attr("data-value")},
				powder	: {obj : $("#bodyTopPowder"), 	value : $("#bodyTopPowder").attr("data-value")},
				coloring: {obj : $("#bodyTopColoring"), value : $("#bodyTopColoring").attr("data-value")},
				binder	: {obj : $("#bodyTopBinder"), 	value : $("#bodyTopBinder").attr("data-value")},
				pearl	: {obj : $("#bodyTopPearl"), 	value : $("#bodyTopPearl").attr("data-value")},
				hgi		: {obj : $("#bodyTopHgi"), 		value : $("#bodyTopHgi").attr("data-value")},
				group	: {obj : $("#bodyTopGroup"), 	value : $("#bodyTopGroup").attr("data-value")}
			};
			
		$("#rmgmtPopCalculator").modal("show");
	}
	/***** rmgmt-pop-calculator
    - (Grid input click) open 함수
    - pLoc : Grid
	*************************/
	function openPopCalulatorGrid(pLoc, pMe){

		var wkordNumSeq = $("#ulSeqArea").find("a.active").attr("data-code");
		if (wkordNumSeq == "00") return;

		var targetTable = $("#tbRmgHist").DataTable();
		var targetRow 	= pMe.parents('tr');
		var targetData 	= targetTable.rows(targetRow).data()[0];
		var $prodtQG = $("input", $("#tbRmgHist").DataTable().cell({ row: targetData.rowIdx, column: 9}).node());
		var $prodtQP = $("input", $("#tbRmgHist").DataTable().cell({ row: targetData.rowIdx, column: 10}).node());
		
		_glbRmgmtPopCalc = {
				loc		: pLoc,
				seq		: wkordNumSeq,
				rpm  	: {obj : $("#bodyTopRpm"), 		value : $("#bodyTopRpm").attr("data-value")},
				time 	: {obj : $("#bodyTopTime"), 	value : $("#bodyTopTime").attr("data-value")},
				sharp7 	: {obj : $("#bodyTopSharp7"), 	value : $("#bodyTopSharp7").attr("data-value")},
				powder	: {obj : $("#bodyTopPowder"), 	value : $("#bodyTopPowder").attr("data-value")},
				coloring: {obj : $("#bodyTopColoring"), value : $("#bodyTopColoring").attr("data-value")},
				binder	: {obj : $("#bodyTopBinder"), 	value : $("#bodyTopBinder").attr("data-value")},
				pearl	: {obj : $("#bodyTopPearl"), 	value : $("#bodyTopPearl").attr("data-value")},
				hgi		: {obj : $("#bodyTopHgi"), 		value : $("#bodyTopHgi").attr("data-value")},
				group	: {obj : $("#bodyTopGroup"), 	value : $("#bodyTopGroup").attr("data-value")},

				prodtQG	: {obj : $prodtQG, 				value : targetData.PRODT_Q_G},
				prodtQP	: {obj : $prodtQP, 				value : targetData.PRODT_Q_P},
				no			: targetData.SEQ,	
				childCode 	: targetData.CHILD_ITEM_CODE,
				childLotNo 	: targetData.LOT_NO,
				childName 	: targetData.CHILD_ITEM_NAME,
				stockUnit	: targetData.STOCK_UNIT,
				unitQ		: targetData.UNIT_Q,
				allockQ		: targetData.ALLOCK_Q
			};
			
		$("#rmgmtPopCalculator").modal("show");
	}
	
	/***** rmgmt-pop-calculator
	- 확인 후 종료 시 bodyTop 데이터 연결
	*************************/
    function fnSetTopObjFromBodyTop(pSeq, pLoc, pRow){
    	
		// bodyTop 에서 키패드로 변경 시에
		if(pLoc != "G" && pLoc != "P" ){
	
			var receiveRpm 		= _glbRmgmtPopCalc.rpm.obj.attr("data-value");
			var receiveTime 	= _glbRmgmtPopCalc.time.obj.attr("data-value");
			var receiveSharp7	= _glbRmgmtPopCalc.sharp7.obj.attr("data-value");
			var receivePowder 	= _glbRmgmtPopCalc.powder.obj.attr("data-value");
			var receiveColoring	= _glbRmgmtPopCalc.coloring.obj.attr("data-value");
			var receiveBinder 	= _glbRmgmtPopCalc.binder.obj.attr("data-value");
			var receivePearl 	= _glbRmgmtPopCalc.pearl.obj.attr("data-value");
			var receiveHgi 		= _glbRmgmtPopCalc.hgi.obj.attr("data-value");
			var receiveGroup	= _glbRmgmtPopCalc.group.obj.attr("data-value");
			
			var arrTopKeys = Object.keys(_glbBodyTop);

    		//해당 차수에 데이터를 넣어준다.
        	if(arrTopKeys.includes(pSeq)){
        		$.each(_glbBodyTop[pSeq], function(index, item){

					item.RPM_Q 			= receiveRpm;
					item.TIME_Q 		= receiveTime;
					item.SHARP_7_Q 		= receiveSharp7;
					item.POWDER_YN 		= receivePowder;
					item.COLORING_YN	= receiveColoring;
					item.BINDER_YN 		= receiveBinder;
					item.PEARL_YN 		= receivePearl;
					item.HGI_Q_CD 		= receiveHgi;
					item.PROC_GROUP_CD	= receiveGroup;
					
					fnSetBodyTopColor(item);
				})
				
				// "00" : 전체 공정차수에 최대값으로 변경 -> 바인더, 펄은 sum값
				fnBodyTopAggrs();
				
			}
			// prodt_proc 그려주기
			// ex (파우더 색소 )
			
        // Grid 에서 키패드로 변경 시에	
		}else{
			
			// 현재 키패드 open한 로우를 찾는다
			var trObj = pRow.parents("tr");
			var currentRow = $("#tbRmgHist").DataTable().rows(trObj).data()[0];
			
			// 키패드로 변경한 내용을 반영한다.
			currentRow.PRODT_Q_G = _glbRmgmtPopCalc.prodtQG.value;
			currentRow.PRODT_Q_P = _glbRmgmtPopCalc.prodtQP.value;
			if(_glbRmgmtPopCalc.prodtQG.value == 0){
				currentRow.SHOW_YN 		= "N";
				currentRow.SEQ_SHOW_YN 	= pSeq + "N";
			}else{
				currentRow.SHOW_YN 		= "Y";
				currentRow.SEQ_SHOW_YN 	= pSeq + "Y";
			}
			
			// 누적값을 반영할 공정차수 :00 전체를 찾는다.
			var tbFinalRow = $("#tbRmgHist").DataTable().rows().data().filter(function(item){
				if(item.WKORD_NUM_SEQ  == "00"
					&& item.DIV_CODE == currentRow.DIV_CODE
					&& item.WKORD_NUM == currentRow.WKORD_NUM
					&& item.PROG_WORK_CODE == currentRow.PROG_WORK_CODE
					&& item.CHILD_ITEM_CODE == currentRow.CHILD_ITEM_CODE
					&& item.REF_TYPE == currentRow.REF_TYPE
					&& item.PATH_CODE == currentRow.PATH_CODE) {
				
					return true;
				}
			}).toArray();
			
			// 누적 할 Rows를 찾는다.
			var tbSameRows = $("#tbRmgHist").DataTable().rows().data().filter(function(item){
				if(item.WKORD_NUM_SEQ  != "00"
					&& item.DIV_CODE == currentRow.DIV_CODE
					&& item.WKORD_NUM == currentRow.WKORD_NUM
					&& item.PROG_WORK_CODE == currentRow.PROG_WORK_CODE
					&& item.CHILD_ITEM_CODE == currentRow.CHILD_ITEM_CODE
					&& item.REF_TYPE == currentRow.REF_TYPE
					&& item.PATH_CODE == currentRow.PATH_CODE) {
				
					return true;
				}
			}).toArray();
			
			// 누적 값을 구한다.
			var initialValueG = 0;
			var sameRowsSumG = tbSameRows.reduce(function(accumulator, currentValue){
				return parseFloat(accumulator) + parseFloat(currentValue.PRODT_Q_G)
			}, initialValueG);
			
			var initialValueP = 0;
			var sameRowsSumP = tbSameRows.reduce(function(accumulator, currentValue){
				return parseFloat(accumulator) + parseFloat(currentValue.PRODT_Q_P)
			}, initialValueP);
			
			// 공정차수 : 00(전체) 의 해당 행에 누적값을 바인딩.
			var tbFinalRowIdx = tbFinalRow[0].rowIdx;
			if(sameRowsSumG == 0) {
				tbFinalRow[0].SHOW_YN 		= "N";
				tbFinalRow[0].SEQ_SHOW_YN 	= "00N";
			}else{
				tbFinalRow[0].SHOW_YN 		= "Y";
				tbFinalRow[0].SEQ_SHOW_YN 	= "00Y";
			}
			tbFinalRow[0].PRODT_Q_G = sameRowsSumG;
			tbFinalRow[0].PRODT_Q_P = sameRowsSumP;
			$("input", $("#tbRmgHist").DataTable().cell({ row: tbFinalRowIdx, column: 9}).node()).val(sameRowsSumG);
			$("input", $("#tbRmgHist").DataTable().cell({ row: tbFinalRowIdx, column: 10}).node()).val(sameRowsSumP);
			
			/*
			var idx = $("#tbRmgHist").DataTable().row(pRow.parents("tr")).index();
			
			*/
		}
		
		fnDrawFooterProc(pSeq);
	}
	
	/*****  제조이력 축약 내용 생성.
	*************************/
	function fnDrawFooterProc(pSeq){
		
		if(pSeq == "00") return;
		
		var nowSeqRpm 		= "";
		var nowSeqTime 		= "";
		var nowSeqSharp7	= "";
		var nowSeqPower 	= "";
		var nowSeqColoring 	= "";
		var nowSeqBinder	= "";
		var nowSeqPearl		= "";
		var nowSeqHgi		= "";
		var nowSeqGroup		= "";
		
		var arrTopKeys = Object.keys(_glbBodyTop);
		if(arrTopKeys.includes(pSeq)){
			$.each(_glbBodyTop[pSeq], function(index, item){
				
				nowSeqRpm 		= item.RPM_Q;
				nowSeqTime 		= item.TIME_Q;
				nowSeqSharp7	= item.SHARP_7_Q;
				nowSeqPower 	= item.POWDER_YN;
				nowSeqColoring 	= item.COLORING_YN;
				nowSeqBinder	= item.BINDER_YN;
				nowSeqPearl		= item.PEARL_YN;
				nowSeqHgi		= item.HGI_Q_CD;
				nowSeqGroup		= item.PROC_GROUP_CD;
				
			})
		};

		/***** proc 만들기 		*****/
		var strProcRpm 	= fnGetCode(_glbCommRpm, nowSeqRpm, "REF_CODE1");
		var strProc 	= "";
		
		// 순서 : rpm, 시간, #7, 파우더, 색소, 바인더, 펄, 분쇄도, 공정그룹 , 제조지시 수정 내용
		strProc += (ObjUtil.isEmpty(nowSeqPower) 	|| nowSeqPower == "N") 		? "" : "" + "파";
		strProc += (ObjUtil.isEmpty(nowSeqPower) 	|| nowSeqColoring == "N") 	? "" : " " + "색";
		strProc += (ObjUtil.isEmpty(nowSeqBinder)	|| nowSeqBinder == "N")		? "" : " " + "바";
		strProc += (ObjUtil.isEmpty(nowSeqPearl)	|| nowSeqPearl == "N")  	? "" : " " + "펄";
		strProc += (ObjUtil.isEmpty(nowSeqSharp7)	|| nowSeqSharp7 == "0") 	? "" : " #7 " + nowSeqSharp7;
		strProc += (ObjUtil.isEmpty(nowSeqRpm)		|| nowSeqRpm  == "0") 		? "" : " " + strProcRpm;
		strProc += (ObjUtil.isEmpty(nowSeqTime)		|| nowSeqTime == "0") 		? "" : " " + nowSeqTime;
		strProc += (ObjUtil.isEmpty(nowSeqHgi)		|| nowSeqHgi == "00") 		? "" : " 분" + nowSeqHgi;
		
		
		var tbTargetRows = _glbBodyTb.filter(function(item){
			if(item.WKORD_NUM_SEQ  == pSeq && item.SHOW_YN == "Y"){
				return true;
			}
		});
		
		$.each(tbTargetRows, function(index, item){
			strProc += " N" + item.SEQ + " " + item.PRODT_Q_P + "%";
		});
		
		
		// 순서 : rpm, 시간, #7, 파우더, 색소, 바인더, 펄, 분쇄도, 공정그룹 , 제조지시 수정 내용 End
		
		var activeSeq = $("#ulSeqArea").find("a.active").attr("data-code");
		
		// 현재 active 된 탭과 같을 때만 바인딩 
		if(activeSeq == pSeq){
			$("#bodyFooterProc").val(strProc);
		}
		
		// proc 만들기 End			 *****/
		
		var arrTopKeys = Object.keys(_glbBodyTop).sort();
		
		if(arrTopKeys.includes(pSeq)){
			$.each(_glbBodyTop[pSeq], function(index, item){
				item.PROD_PROC	= strProc;
			})
			
			var prodProc = "";
			var userProdProc = "";
			$.each(arrTopKeys, function(index, key){
				
				$.each(_glbBodyTop[key], function(subIndex, item){
					
					if(key == "00") return true;
					
					var bodyTabName = fnFindSeqName(key);
					//prodProc 		+= (item.PROD_PROC == "") 		? "" : (prodProc 		== "" ? "" : "/") + item.PROD_PROC;
					//userProdProc	+= (item.USER_PROD_PROC == "") 	? "" : (userProdProc 	== "" ? "" : "/") + item.USER_PROD_PROC;
					prodProc 		+= (key == "01" ? bodyTabName + ": " : "\n" + bodyTabName + ": ") + item.PROD_PROC;
					prodProc		+= (item.USER_PROD_PROC.replace(" ","") == "") ? "" : "\n(" + item.USER_PROD_PROC + ")";
					userProdProc	+= (key == "01" ? "" : "/") + item.USER_PROD_PROC;
				})
			});
			
			if(userProdProc.replaceAll(" ", "").replaceAll("/", "") == ""){
				userProdProc = "";
			}
			
			// "00" 공정차수에 데이터 put
			$.each(_glbBodyTop["00"], function(subIndex, item){

				item.PROD_PROC 		= prodProc;
				item.USER_PROD_PROC	= userProdProc;
				
			});
			
			if(activeSeq == "00"){
				$("#bodyFooterProc").val(prodProc);
				$("#bodyFooterUserProc").val(userProdProc);
			}
		}	
	}
	
	function fnSumBobyTbSeqs(pSeq){
		
		// 누적값을 반영할 공정차수 :00 전체를 찾는다.
		var tbFinalRows = $("#tbRmgHist").DataTable().rows().data().filter(function(item){
			return item.WKORD_NUM_SEQ  == "00";
		}).toArray();
		
		var arrTopKeys = Object.keys(_glbBodyTop).sort();
		
		$.each(tbFinalRows, function(index, finalRow){
			
			// 누적 할 Rows를 찾는다.
			var tbSameRows = $("#tbRmgHist").DataTable().rows().data().filter(function(item){
				if(item.WKORD_NUM_SEQ  != "00" && arrTopKeys.includes(item.WKORD_NUM_SEQ)
					&& item.DIV_CODE == finalRow.DIV_CODE
					&& item.WKORD_NUM == finalRow.WKORD_NUM
					&& item.PROG_WORK_CODE == finalRow.PROG_WORK_CODE
					&& item.CHILD_ITEM_CODE == finalRow.CHILD_ITEM_CODE
					&& item.REF_TYPE == finalRow.REF_TYPE
					&& item.PATH_CODE == finalRow.PATH_CODE) {
				
					return true;
				}
			}).toArray();
			
			// 누적 값을 구한다.
			var initialValueG = 0;
			var sameRowsSumG = tbSameRows.reduce(function(accumulator, currentValue){
				return parseFloat(accumulator) + parseFloat(currentValue.PRODT_Q_G)
			}, initialValueG);
			
			var initialValueP = 0;
			var sameRowsSumP = tbSameRows.reduce(function(accumulator, currentValue){
				return parseFloat(accumulator) + parseFloat(currentValue.PRODT_Q_P)
			}, initialValueP);
			
			
			// 공정차수 : 00(전체) 의 해당 행에 누적값을 바인딩.
			var tbFinalRowIdx = finalRow.rowIdx;
			finalRow.PRODT_Q_G = sameRowsSumG;
			finalRow.PRODT_Q_P = sameRowsSumP;
			if(sameRowsSumG == 0) {
				finalRow.SHOW_YN 		= "N";
				finalRow.SEQ_SHOW_YN 	= "00N";
			}else{
				finalRow.SHOW_YN 		= "Y";
				finalRow.SEQ_SHOW_YN 	= "00Y";
			}
			$("input", $("#tbRmgHist").DataTable().cell({ row: tbFinalRowIdx, column: 9}).node()).val(sameRowsSumG);
    		$("input", $("#tbRmgHist").DataTable().cell({ row: tbFinalRowIdx, column: 10}).node()).val(sameRowsSumP);
		});
	}
	
	
	function fnBodyTopAggrs(){
		var rpmQ 		= "0";
		var timeQ 		= "0";
		var sharp7Q 	= "0";
		var powderYn 	= "N";
		var coloringYn 	= "N";
		var binderYn 	= "N";
		var pearlYn		= "N";
		var hgiQCd		= "00";
		var group		= "";
		
		var activeSeq = $("#ulSeqArea").find("a.active").attr("data-code");
		
		var arrTopKeys = Object.keys(_glbBodyTop).sort();
		$.each(arrTopKeys, function(index, key){
			
			$.each(_glbBodyTop[key], function(subIndex, item){
				
				if(key == "00") return true;
				
				rpmQ 		= (parseFloat(rpmQ) 	> parseFloat(item.RPM_Q)) 		? rpmQ 		: item.RPM_Q;
				timeQ 		= (parseFloat(timeQ) 	> parseFloat(item.TIME_Q)) 		? timeQ 	: item.TIME_Q;
				sharp7Q 	= parseFloat(sharp7Q)   + parseFloat(item.SHARP_7_Q);
				powderYn 	= (powderYn 	== "Y" 	|| item.POWDER_YN 	== "Y") ? "Y" : "N";
				coloringYn 	= (coloringYn 	== "Y" 	|| item.COLORING_YN == "Y") ? "Y" : "N";
				binderYn	= (binderYn 	== "Y" 	|| item.BINDER_YN 	== "Y") ? "Y" : "N";
				pearlYn		= (pearlYn	 	== "Y" 	|| item.PEARL_YN 	== "Y") ? "Y" : "N";

				hgiQCd 		= (parseFloat(hgiQCd) 	> parseFloat(item.HGI_Q_CD)) ? hgiQCd : item.HGI_Q_CD;
				group 		= (group 				> item.PROC_GROUP_CD) ? group : item.PROC_GROUP_CD;
			})
		});
		
		// "00" 공정차수에 데이터 put
		$.each(_glbBodyTop["00"], function(subIndex, item){
			
			item.RPM_Q  		= rpmQ;
			item.TIME_Q  		= timeQ;
			item.SHARP_7_Q		= sharp7Q;
			item.POWDER_YN 		= powderYn;
			item.COLORING_YN	= coloringYn;
			item.BINDER_YN		= binderYn;
			item.PEARL_YN		= pearlYn;
			item.HGI_Q_CD		= hgiQCd;
			item.PROC_GROUP_CD	= group;
			
			if(activeSeq == "00"){
				$("#bodyTopRpm").val(item.RPM_Q);
				$("#bodyTopTime").val(item.TIME_Q);
				$("#bodyTopSharp7").val(item.SHARP_7_Q);
				$("#bodyTopPowder").val((item.POWDER_YN == "N") ? "OFF" : "ON");
				$("#bodyTopColoring").val((item.COLORING_YN == "N") ? "OFF" : "ON");
				$("#bodyTopBinder").val((item.BINDER_YN == "N") ? "OFF" : "ON");
				$("#bodyTopPearl").val((item.PEARL_YN == "N") ? "OFF" : "ON");
				$("#bodyTopHgi").val(fnGetCode(_glbCommHgi, item.HGI_Q_CD, "CODE_NM"));
				$("#bodyTopGroup").val(item.PROC_GROUP_CD);
				$("#bodyFooterProc").val(item.PROD_PROC);
				
				$("#bodyTopRpm").attr("data-value", item.RPM_Q);
				$("#bodyTopTime").attr("data-value", item.TIME_Q);
				$("#bodyTopSharp7").attr("data-value", item.SHARP_7_Q);
				$("#bodyTopPowder").attr("data-value", item.POWDER_YN);
				$("#bodyTopColoring").attr("data-value", item.COLORING_YN);
				$("#bodyTopBinder").attr("data-value", item.BINDER_YN);
				$("#bodyTopPearl").attr("data-value", item.PEARL_YN);
				$("#bodyTopHgi").attr("data-value", item.HGI_Q_CD);
				$("#bodyTopGroup").attr("data-value", item.PROC_GROUP_CD);
				$("#bodyFooterProc").attr("data-value", item.PROD_PROC);
				
				fnSetBodyTopColor(item);
			}
		});
	}
	
	function fnSetBodyTopColor(pCurBodyTop){
		
		if(pCurBodyTop.RPM_Q == "0"){
			if($("#bodyTopRpm").hasClass("form-changed")){
				$("#bodyTopRpm").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopRpm").hasClass("form-changed")){
				$("#bodyTopRpm").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.TIME_Q == "0"){
			if($("#bodyTopTime").hasClass("form-changed")){
				$("#bodyTopTime").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopTime").hasClass("form-changed")){
				$("#bodyTopTime").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.SHARP_7_Q == "0"){
			if($("#bodyTopSharp7").hasClass("form-changed")){
				$("#bodyTopSharp7").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopSharp7").hasClass("form-changed")){
				$("#bodyTopSharp7").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.POWDER_YN == "N"){
			if($("#bodyTopPowder").hasClass("form-changed")){
				$("#bodyTopPowder").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopPowder").hasClass("form-changed")){
				$("#bodyTopPowder").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.COLORING_YN == "N"){
			if($("#bodyTopColoring").hasClass("form-changed")){
				$("#bodyTopColoring").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopColoring").hasClass("form-changed")){
				$("#bodyTopColoring").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.BINDER_YN == "N"){
			if($("#bodyTopBinder").hasClass("form-changed")){
				$("#bodyTopBinder").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopBinder").hasClass("form-changed")){
				$("#bodyTopBinder").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.PEARL_YN == "N"){
			if($("#bodyTopPearl").hasClass("form-changed")){
				$("#bodyTopPearl").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopPearl").hasClass("form-changed")){
				$("#bodyTopPearl").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.HGI_Q_CD == "00"){
			if($("#bodyTopHgi").hasClass("form-changed")){
				$("#bodyTopHgi").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopHgi").hasClass("form-changed")){
				$("#bodyTopHgi").addClass("form-changed");
			}
		}
		
		if(pCurBodyTop.PROC_GROUP_CD == ""){
			if($("#bodyTopGroup").hasClass("form-changed")){
				$("#bodyTopGroup").removeClass("form-changed");
			}
		}else{
			if(!$("#bodyTopGroup").hasClass("form-changed")){
				$("#bodyTopGroup").addClass("form-changed");
			}
		}
		
		
	}
	
	
    </script>
</body>
</html>
