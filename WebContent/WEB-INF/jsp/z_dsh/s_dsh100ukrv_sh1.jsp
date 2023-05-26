<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>Dashboard</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- 
	 Cache-Control
	 no-cache : 캐시를 사용하기 전에 재검증을 위한 요청을 강제함.
	 no-store : 클라이언트의 요청, 서버의 응답 등을 일체 저장하지 않음
	 must-revalidate : 캐시를 사용하기 전에 반드시 만료된 것인지 검증을 함.
	 Ex) Cache-Control: no-cache, no-store, must-revalidate
	 -->
	 <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	
	 <!-- 
	 Expires
	 리소스가 validate 하지 않다고 판단할 시간을 설정함
	 유효하지 않은 날짜 포맷(0)과 같은 경우 리소스가 만료 되었음을 의미함.
	 Ex) Expires: Wed, 21 Oct 2015 07:28:00 GMT
	 -->
	 <meta http-equiv="Expires" content="0">
	
	 <!-- 
	 HTTP 1.0 버전에서 HTTP 1.1의 Cache-Control 헤더와 같은 역할을 함
	 Ex) Pragma: no-cache
	 -->
	 <meta http-equiv="Pragma" content="no-cache">
	
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />

	<style>
		.form-font-custom{
			font-size:15px;
		}
		.control-label{
		    text-align: right;
		}	
		body, html {background:#444;}	
		
		.footer {
		   position: fixed;
		   left: 0;
		   bottom: 0;
		   padding:0px;
		   width: 100%;
		
		   text-align: center;
		}
		
		.header {
			height:80px;
		  background: #555;
		  padding-top: 10px;
		}
		
		/* 스크롤바 넓이 변경 */
		::-webkit-scrollbar {
		
		  height: 35px;
		}
		
		/* 스크롤바 막대 바깥 바탕색 */
		::-webkit-scrollbar-track {
		  background: #555; 
		}
		 
		/* 스크롤바 막대색 */
		::-webkit-scrollbar-thumb {
		  background: gray; 
		}
		
		/* 스크롤바 마우스오버 막대색 */
		::-webkit-scrollbar-thumb:hover {
		  background:#989898; 
		}
	
	
	
	
	
	
.menu-pages {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}


.label-font-lg{
		line-height:50px;
		height:50px; 
		font-size:25px;
		vertical-align: middle;
	}
	
.div-vm{
	display: flex; 
	align-items: center;
}	
	</style>

</head>
    <body> 

        <div class="menu-pages" id = "menuPage">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <!-- Logo -->
                            <div class="card-header pt-2 pb-2 text-center bg-primary">
                            
	                            <div class="row div-vm">
	                            	<div class="col-3" style="width:100px; height:100px;">
	                           			<a href="${pageContext.request.contextPath}/" target="_self">
	                           				<img id="imgLogo" src="${pageContext.request.contextPath}/resources/images/inno_logo_1.gif" alt="이미지가 없습니다." style="	max-width: 100%; height: 100%;">
	                           			</a>
	                           		</div>
	                                <h1 class="col-6 text-white text-center font-weight-bold">현장 등록 시스템</h1>
	                                
	                            	<div class="col-3">
	                            	</div>
                                </div>
                            </div>

                            <div class="card-body p-4" style="background-color:#555;color: #fff;">
                                <form id="menuForm">
                                    <div class="form-group">
	                                    <div class="row mb-3">
									    	<label for ="equip_code" class="col-4 label-font-lg"  style="text-align:right">설비명</label>
									    	<div class="col-6">
										    	<select class="form-control" id="equip_code" style ="color: #fff;  background-color: #666;height:50px; font-size:25px;" required="required" >
								
												</select>
										    </div>
									    </div>
									    <div class="row mb-3">
									    	<label for ="inspec_prsn" class="col-4 label-font-lg"  style="text-align:right">작업자</label>
									    	<div class="col-6">
										    	<select class="form-control" id="inspec_prsn" style ="color: #fff;  background-color: #666; height:50px; font-size:25px;" required="required" >
												</select>
										    </div>
									    </div>
									</div>
                                    <div class="form-group mb-3">
                                        
                                    </div>

                                    <div class="form-group mb-0 text-center">
                                        <button class="btn btn-primary mr-5" type="button" id="startInfo" style ="width:200px; height:60px; font-size:25px;"> 작업 실적 등록 </button>
                                        <button class="btn btn-primary" type="button" style ="width:200px; height:60px; font-size:25px;"> 작업 상세 정보 </button>
                                    </div>

                                </form>
                            </div> <!-- end card-body -->
                        </div>
                        <!-- end card -->

                    </div> <!-- end col -->
                </div>
                <!-- end row -->
            </div>
            <!-- end container -->
        </div>
        <!-- end page -->

        <footer class="footer footer-alt">
            Copyrightⓒ2021 SynergySystems All rights reserved.
        </footer>
</body>

<!-- js -->		
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-ui.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>

	
	<script type="text/javascript" chartset="utf-8">
		var CPATH ='<%=request.getContextPath()%>';
	
$(document).ready(function(){
	//var img = document.getElementById('imgLogo'); 
   // img.src = CPATH+"/resources/images/inno_logo_1.gif";
    
	fnEquipCodeList();
	fnGetInspecPrsnList();
	
	//작업실적등록 버튼 클릭
	$("#startInfo").click(function () {
		if (!fnValidation()) return;
		
		//var win = window.open(CPATH+'/z_dsh/s_dsh100ukrv_sh2.do?equipCode='+$("#equip_code").val()+'&equipName='+ $("#equip_code option:checked").text() , "_self", 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');
		var param = {
			equipCode : $("#equip_code").val(),
			equipName : $("#equip_code option:checked").text(),
			inspecPrsn : $("#inspec_prsn").val(),
			inspecPrsnName : $("#inspec_prsn option:checked").text()
	    };
	   
		startInfoOpen('POST', CPATH+'/z_dsh/s_dsh100ukrv_sh2.do', param ); 
	});
})
	
	function startInfoOpen(verb, url, data, target) {
        var form = document.createElement("form");
        form.action = location.origin + url;
        form.method = verb;
        form.target = target || "_self";
        if (data) {
          for (var key in data) {
            var input = document.createElement("textarea");
            input.name = key;
            input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
            form.appendChild(input);
          }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
	}
	
	
//설비정보 세팅
	function fnEquipCodeList(){
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getEquipCode.do";
		var ajaxData 	= {};
		var ajaxloding	= false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			$("#equip_code option").remove();
			$("#equip_code").append('<option value="">선택 해주세요</option>');
			for(var i = 0; i < data.length; i++){
				$("#equip_code").append("<option value='"+ data[i].EQU_CODE +"'>" + data[i].EQU_NAME + "</option>");
			}
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}
	
	//작업자 세팅
	function fnGetInspecPrsnList(){
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getInspecPrsn.do";
		var ajaxData 	= {};
		var ajaxloding	= false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			$("#inspec_prsn option").remove();
			$("#inspec_prsn").append('<option value="">선택 해주세요</option>');
			for(var i = 0; i < data.length; i++){
				$("#inspec_prsn").append("<option value='"+ data[i].INSPEC_PRSN +"'>" + data[i].INSPEC_PRSN_NAME + "</option>");
			}
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}
	
	function fnValidation(){
		var $t, t;
		var result = true;
		var error;
		$("#menuPage").find("input, select, textarea").each(function(i) {
			$t = jQuery(this);
			if($t.prop("required")) {
				if(!jQuery.trim($t.val())) {
					t = jQuery("label[for='"+$t.attr("id")+"']").text();
					$t.focus();
					alert( t + " 을(를) 선택해주세요." );
					result = false;
				}
			}
		});
		return result;
	}
	
/* 	function wClose(){
		window.open('', '_self', '');
		window.close();
	  
	    return false;
	} */ 
    
	</script>
</html>
