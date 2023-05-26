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
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />

	<style>

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
	
.dynamic-img{
	max-width: 100%; 
	height: 100px;
}	
.dynamic-div{
  text-align: center;
	height: 150px;
}	
a {cursor:pointer;}


.div-vm{
	display: flex; 
  	justify-content: center;
	align-items: center;
}	
	</style>

</head>
    <body> 
<!-- 		<header>
			<h1 class="text-center font-weight-bold p-2">성형사출기 모니터링 시스템</h1>
                	
		</header> -->
		<main>
	        <div class="menu-pages" id = "menuPage">
	            <div class="container">
	            	<div class="col-lg-12">
	                	<div class="card">
	                    	<div class="card-header pt-1 pb-1 pl-1 pr-1 text-center bg-primary">
								<div class="row div-vm">
	                            	<div class="col-2" style="width:100px; height:100px;">
	                           			<img id="imgLogo" src="${pageContext.request.contextPath}/resources/images/inno_logo_1.gif" alt="이미지가 없습니다." style="	max-width: 100%; height: 100%;">
	                           		</div>
	                                <h1 class="col-7 text-white text-center font-weight-bold">성형사출기 모니터링 시스템</h1>
	                               <!--  #aab8c5 -->
	                            	<div class="row col-3">
		                            	<div class="col" style="padding-left:150px;">
		                            		<h1 class="text-left m-0" style="font-size:15px; color: #FA5C7C;"><i class="uil-pause-circle" style="font-size:20px; color: #FA5C7C;"></i> 저속개폐</h1>
		                    				<h1 class="text-left m-0" style="font-size:15px; color: #FF8800;"><i class="uil-play-circle" style="font-size:20px; color: #FF8800;"></i> 수동</h1>
		                    				<h1 class="text-left m-0" style="font-size:15px; color: #FFBC00;"><i class="uil-play-circle" style="font-size:20px; color: #FFBC00;"></i> 반자동</h1>
		                    				<h1 class="text-left m-0" style="font-size:15px; color: #0ACF97;"><i class="uil-play-circle" style="font-size:20px; color: #0ACF97;"></i> 전자동</h1>
	                    				</div>
	                            	</div>
                                </div>
								
								
								
						<!-- 		<div class="row">
									<h1 class="col-9 text-center font-weight-bold">성형사출기 모니터링 시스템</h1>
									<div class="row col-3" style="text-align: right;">
	                    				<h1 class="col-6 text-center" style="font-size:15px; color: #FFF;"><i class="uil-pause-circle" style="font-size:20px; color: #FA5C7C;"></i> 저속개폐</h1>
	                    				<h1 class="col-6 text-center" style="font-size:15px; color: #FFF;"><i class="uil-play-circle" style="font-size:20px; color: #FF8800;"></i> 수동</h1>
	                    				<h1 class="col-6 text-center" style="font-size:15px; color: #FFF;"><i class="uil-play-circle" style="font-size:20px; color: #FFBC00;"></i> 반자동</h1>
	                    				<h1 class="col-6 text-center" style="font-size:15px; color: #FFF;"><i class="uil-play-circle" style="font-size:20px; color: #0ACF97;"></i> 전자동</h1>
	                    				
									</div>
								</div> -->
								
							</div>
							<div class="card-body">
				                <div class="row row-dynamic">
				                
				                </div>
				            </div>
				        </div>
				    </div>
	            </div>
	            <!-- end container -->
	        </div>
	        <!-- end page -->
        </main>

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

	$.App.activateDarkMode();
	
	fnEquipCodeList();
	fnGetInspecPrsnList();
	
/*     var img = document.getElementById('dynamicImg'); 
    img.src = CPATH+"/z_dsh/dsh100ukrvPhoto/a.gif";

    var img = document.getElementById('dynamicImg2'); 
    img.src = CPATH+"/z_dsh/dsh100ukrvPhoto/a.gif";
    
     $(document).on('click','#dynamicImg',function(){
    	alert("Click event works!");
    });   */
 /* 	$("#dynamicImg").click(function () {
		
		alert('이미지');
	}); */
	
	
	//db데이터 읽어와서 작동중인 호기에 대해 gif 세팅 필요
	
//	$("#dynamicImg_KJ_M_001").attr("src", $("#dynamicImg_KJ_M_001").data("animated"));
//	$("#dynamicImg_KJ_M_002").attr("src", $("#dynamicImg_KJ_M_002").data("animated"));
//	$("#dynamicImg_KJ_M_007").attr("src", $("#dynamicImg_KJ_M_007").data("animated"));
	
	//해당 호기 누를시 대시 보드 에 호기 와 부품명 세팅 필요
	
/* 	
	$("#dynamicImg_KJ_M_001").mouseover(function() {
	  $(this).attr("src", $(this).data("animated"))
	}),
	$("#dynamicImg_KJ_M_001").mouseout(function() {
	  $(this).attr("src", $(this).data("static"))
	});
 */
	
//각 작지데이터 시작 버튼 관련
	$(document).on('click', '.dynamic-img', function() {

		var indexA = $(this).attr("id").indexOf("_");	
		var equipCode = $(this).attr("id").substring(indexA+1);

		var equipName = $('#dynamicH1_'+equipCode).text();
		
		//$('.dynamic-div').css("border-style", "none");
		
		//$('.dynamic-div').css("border-style", "solid");
		//$('.dynamic-div').css("border-color", "#fff");
		
		var param = {
			equipCode : equipCode,
			equipName : equipName
	    };
	   
		startDashOpen('POST', CPATH+'/z_dsh/s_dsh100skrv_sh2.do', param );
		
	});
 
 
 
/* 	 
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
	}); */
})
	
	function startDashOpen(verb, url, data, target) {
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
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getEquipCodeDashMenu.do";
		var ajaxData 	= {};
		var ajaxloding	= false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			 //uil-pause		uil-play-circle
			for(var i = 0; i < data.length; i++){
				
				var iconClass = '';
				var iconColor = '';
				
				if(data[i].OP_MODE == '0'){
					iconClass = 'uil-play-circle';
					iconColor = '#FF8800';
				}else if(data[i].OP_MODE == '2'){
					iconClass = 'uil-play-circle';
					iconColor = '#FFBC00';
				}else if(data[i].OP_MODE == '8'){
					iconClass = 'uil-play-circle';
					iconColor = '#0ACF97';
				}else{		               
					iconClass = 'uil-pause-circle';
					iconColor = '#FA5C7C';
				}
				
				
				
				$('.row-dynamic').append(
					'<div class="col-lg-3">'+
	                	'<div class="card">'+
	                    	'<div class="card-header pt-1 pb-1 text-center">'+
                    			'<div class="row div-vm">'+
										'<h1 class="col-8 text-white text-center font-weight-bold m-0" id="dynamicH1_' + data[i].EQU_CODE + '" style ="font-size:25px;">' + data[i].EQU_NAME + '</h1>'+
		                    			'<h1 class="col-4 text-right font-weight-bold m-0" id="dynamicHi1_' + data[i].EQU_CODE + '"><i class="'+ iconClass +'" style="color: '+iconColor+';"> </i></h1>'+
								'</div>'+
							'</div>'+
							'<div class="card-body p-1" style ="background-color: #3a434c">'+
	                        	'<form>'+
			                        '<div class="dynamic-div div-vm">'+
				                    	'<a id="dynamicLink_' + data[i].EQU_CODE + '"><img class="dynamic-img" id="dynamicImg_' + data[i].EQU_CODE + '" src="'+ CPATH+'/z_dsh/dsh100ukrvPhoto/equip_dashImage.png' + '" data-animated="'+ CPATH+'/z_dsh/dsh100ukrvPhoto/equip_dashImage.gif' + '" data-static="'+ CPATH+'/z_dsh/dsh100ukrvPhoto/equip_dashImage.png' + '" alt="이미지가 없습니다."/> </a>'+
				                    '</div>'+
	                            '</form>'+
	                        '</div>'+
                        '</div>'+
                    '</div>'
           		);
				
				if(data[i].OP_MODE == '0' || data[i].OP_MODE == '2' || data[i].OP_MODE == '8' ){
					$("#dynamicImg_" + data[i].EQU_CODE).attr("src", $("#dynamicImg_" + data[i].EQU_CODE).data("animated"));
				}
			}
			
		      /*           <div class="col-lg-4">   
		                	<div class="card">
		                    	<div class="card-header pt-2 pb-2 text-center">
									<h1 class="text-white text-center font-weight-bold">2호기</h1>
								</div>
								<div class="card-body p-2">
		                        	<form id="menuForm">
				                        <div class="form-group">
					                    	<a id="dynamicLink" href=""><img class="dynamic-img" id="dynamicImg2" src=""alt="이미지가 없습니다."/> </a>
					                    </div>
		                            </form>
		                        </div>
		                    </div>
		                </div> */
/* 			
			$("#equip_code option").remove();
			$("#equip_code").append('<option value="">선택 해주세요</option>');
			for(var i = 0; i < data.length; i++){
				$("#equip_code").append("<option value='"+ data[i].EQU_CODE +"'>" + data[i].EQU_NAME + "</option>");
			}
			 */
			
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
    
	</script>
</html>
