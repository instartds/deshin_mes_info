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
		
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/buttons.bootstrap4.min.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/common.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/dashLayout.css"/>" />


<!-- web font -->
<link href="https://fonts.googleapis.com/css?family=Roboto:100,300,500,700" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@300;400;600&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
     body header{
       padding-top: 120px;
     }
 
     .form-font-lg{
		height:80px; 
		font-size:40px;
	}
   </style>

</head>


<body>

<header>
<!-- <nav class="navbar navbar-inverse navbar-fixed-top">-->
			<ul class="nav nav-pills bg-nav-pills nav-justified fixed-top">
			    <li class="nav-item">
			        <a href="#tab1" data-toggle="tab" aria-expanded="true" class="nav-link rounded-0 active">
			            <i class="mdi mdi-home-variant d-md-none d-block"></i>
			            <span class="d-none d-md-block form-font-lg">금형정보</span>
			        </a>
			    </li>
			    <li class="nav-item">
			        <a href="#tab2" data-toggle="tab" aria-expanded="false" class="nav-link rounded-0">
			            <i class="mdi mdi-account-circle d-md-none d-block"></i>
			            <span class="d-none d-md-block form-font-lg">불량정보</span>
			        </a>
			    </li>
			    <li class="nav-item">
			        <a href="#tab3" data-toggle="tab" aria-expanded="false" class="nav-link rounded-0">
			            <i class="mdi mdi-account-circle d-md-none d-block"></i>
			            <span class="d-none d-md-block form-font-lg">불량정보</span>
			        </a>
			    </li>
			</ul>
<!-- </nav> -->
			</header>
				
		<main>
			

			<div class="tab-content">
			    <div class="tab-pane show active" id="tab1">
			    
			    	
					<div class="container" id="coreInfo">
				    	<div class="col-12">
							<div class="card" id="coreCardInfo">
								<div class="card-body">
									<div class="row mb-3">
								    	<label for ="equip_code" class="col-4 form-font-lg"  style="text-align:right">설비명</label>
								    	<div class="col-8">
									    	<select class="form-control" id="equip_code" style ="border: 1px solid #ff0000; height:80px; font-size:40px;" required="required" >
											    
											</select>
									    </div>
								    </div>
								    <div class="row mb-3">
								    	<label for ="wkord_num" class="col-4 form-font-lg"  style="text-align:right">작업지시번호</label>
								    	<div class="col-8 form-font-lg">
									    	<select class="form-control" id="wkord_num" style ="border: 1px solid #ff0000; height:80px; font-size:40px;" required="required">
											
											</select>
									    </div>
								    </div>
						    		<div class="row mb-3" >
									    <label for="core_code" class="col-4 form-font-lg"  style="text-align:right">금형번호</label>
								    	<div class="col-8">
									    <input type="text" id="core_code" name="core_code" class="form-control form-font-lg" placeholder="금형번호를 입력하세요" style="border: 1px solid #ff0000;" required="required" >
									    </div>
									</div>
								    
						    		<div class="row mb-3">
									    <label for="item_name" class="col-4 form-font-lg"  style="text-align:right">부품명</label>
								    	<div class="col-8">
									   <!--  <input type="text" id="item_name" name="core_name" class="form-control form-font-lg" placeholder=""> -->
    									<textarea class="form-control " id="item_name" rows="2" style ="height:80px; font-size:20px; border: 0px; background-color: #fff;" readonly></textarea>
									    </div>
									</div>
									<div class="row mb-3">
									    <label for="wkord_q" class="col-4 form-font-lg"  style="text-align:right">작지수량</label>
								    	<div class="col-4">
    										<input type="text" class="form-control form-font-lg" id="wkord_q" name="wkord_q" style="text-align:right; border: 0px; background-color: #fff;" readonly >
									    </div>
									    <div class="col-4">
									    </div>
									</div>
									<div class="row mb-3">
								    	<label for ="prodt_start_date" class="col-4 form-font-lg"  style="text-align:right">시작시간</label>
								    	<div class="col-4">
									    	<input type="text" class="form-control form-font-lg" id="prodt_start_date" name="prodt_start_date" style="text-align:right; border: 0px; background-color: #fff;" readonly >
									    </div>
									    <div class="col-4">
									    	<input type="text" class="form-control form-font-lg" id="prodt_start_time" name="prodt_start_time" style="text-align:left; border: 0px; background-color: #fff;" readonly>
									    </div>
							<!-- 	    	<label id ="prodt_start_date" class="col-4 form-font-lg"  style="text-align:center"></label>
								    	<label id ="prodt_start_time" class="col-4 form-font-lg"  style="text-align:center"></label> -->
								    	
									    <!-- <div class="col-4">
								    		<label for ="prodt_start_time" class="col-4 form-font-lg" hidden=true>시간</label>
										    <input class="form-control form-font-lg" id="prodt_start_time" type="time" name="time" required="required">
										</div> -->
									</div>
						    <!-- 		<div class="row mb-3">
								    	<label for ="prodt_start_date" class="col-4 form-font-lg"  style="text-align:right">시작시간</label>
								    	<div class="col-4">
									    	<input type="text" class="form-control form-font-lg date" id="prodt_start_date" data-toggle="date-picker" data-single-date-picker="true" required="required">
									    </div>
									    <div class="col-4">
								    		<label for ="prodt_start_time" class="col-4 form-font-lg" hidden=true>시간</label>
										    <input class="form-control form-font-lg" id="prodt_start_time" type="time" name="time" required="required">
										</div>
									</div>
									 -->
									<div class="form-group mb-0 text-center">
									<button type="button" class="btn btn-outline-success btn-rounded" id="startBtn" style ="width:300px; height:100px; font-size:50px;"><i class="uil-caret-right"></i>시작</button>
                                        <!-- <button class="btn btn-primary" id="startBtn" style ="width:300px; height:100px; font-size:50px;"> 시작 </button> -->
                                    </div>
								</div>
							</div>
						</div>
					</div>
			    		
						
						
						
				</div>
				
				
				
				<div class="tab-pane" id="tab2">
				
			        <div class="warp">
						<div class="dashWrap">
							<div class="container-fluid">
								<div class="row">
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">바리</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">흑점</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">미성형</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">가스</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">웰드</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">찍힘</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">기름오염</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">수축</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">기포</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">사상불량</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">안료</div></button>
											</div>
										</div>
									</div>
									<div class="col-md-2">
										<div class="dashItemWrap">
											<div class="countNum">0</div>
											<div class="btn-area">
												<button type="button" class="btn btn-default btn-lg btn-countUp"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i><br /><div class="btn-text">기타</div></button>
											</div>
										</div>
									</div>
				
								</div>
							</div>
						</div>
						<div class="indicatorBarWarp">
							<div class="text-right">
								<button type="button" class="btn btn-default btn-lg btn-reset"><i class="fa fa-repeat" aria-hidden="true"></i> Reset</button>
				            </div>
				        </div>
					</div> 
			    </div>
			    
			    
			    
			   <!--  style ="padding-top: 150px;" -->
			    
				<div class="tab-pane" id="tab3">
				<!-- 최대폭 레이아웃 -->
					<div class="container-fluid" >
                        
                        <div class="row mb-3" style ="align-items: center; height:80px; background-color: #555;">
                        
	                        <div class="col-sm-2 col-md-2 col-lg-2">
                      			<input type="text" class="form-control" id="prodt_start_time2" name="prodt_start_time2" style="height:60px; text-align:center; border: 0px; font-size:40px; color: #fff; background-color: #555;" readonly>
	                        
	                        </div>
                        
	                        <div class="col-sm-2 col-md-2 col-lg-2 text-center">
	                        	<button type="button" class="btn btn-xs btn-success btn-block" id="startBtn2" style ="height:60px; font-size:30px;"><i class="uil-caret-right"></i>시작</button>
	                        
	                        </div>
	                        
	                        <div class="col-sm-4 col-md-4 col-lg-4 text-center">
	                        	<select class="form-control" id="equip_code2" style ="height:60px; border: 1px solid #ff0000; color: #fff;  background-color: #555; font-size:30px;" required="required" >
	                        		<option selected>Open this select menu</option>
								    <option value="1">One</option>
								    <option value="2">Two</option>
								    <option value="3">Three</option>
	                        	</select>
	                        </div>
	                    
	                        <div class="col-sm-2 col-md-2 col-lg-2 text-center">
	                        	<button type="button" class="btn btn-xs btn-info btn-block" id="menuBtn2" style ="height:60px; font-size:30px;"><i class="dripicons-menu"></i>메뉴</button>
	                        
	                        </div>
                        
	                        <div class="col-sm-2 col-md-2 col-lg-2">
	                        	<input type="text" class="form-control" id="prodt_start_date2" name="prodt_start_date2" style="height:60px; text-align:center; border: 0px; font-size:40px; color: #fff; background-color: #555;" readonly>
	                        
	                        </div>    
	                        
	                      <!--   <div class="col-12">
	                        
	                        
	                        
	                            <div class="page-title-box">
	                                <div class="page-title-right">
	                                    <ol class="breadcrumb m-0">
	                                        <li class="breadcrumb-item"><a href="javascript: void(0);">Hyper</a></li>
	                                        <li class="breadcrumb-item"><a href="javascript: void(0);">UI Kit</a></li>
	                                        <li class="breadcrumb-item active">Cards</li>
	                                    </ol>
	                                </div>
	                                <h4 class="page-title">Cards</h4>
	                            </div>
	                            
	                            
	                        </div> -->
	                        
	                    </div>  
	                    
                        <div class="row row-dynamic">
						
					<!-- 		<div class="col-md-6 col-lg-3">
	                            <div class="card d-block">
	                                <img class="card-img-top" src="'+ CPATH+'/equit/equ201Photo/{FILE_ID}.{FILE_EXT}" alt="Card image cap">
	                                <div class="card-body">
	                                    <h5 class="card-title">Card title</h5>
	                                    <p class="card-text">Some quick example text to build on the card title and make
	                                        up the bulk of the card's content. Some quick example text to build on the card title and make up.</p>
	                                    <a href="javascript: void(0);" class="btn btn-primary">Button</a>
	                                </div>
	                            </div>
	                        </div> -->
						
					    	<!-- <div class="control-group">
					        	<label class="control-label" for="inputEmail">
					            	Email</label>
					           	<div class="controls">
					            	<input type="text" id="inputEmail" placeholder="Email" />
					            </div>
							</div> -->
						</div>
				
                        <div class="row row-dynamic2" ">
                        	 <!-- <div class="col-sm-4 col-md-4 col-lg-4">
                        		<div class="row" style ="align-items: center; height:80px; background-color: #555;" >
                        			<div class="col-2">
	  									<input type="text" class="form-control" id="bad_inspec_name" name="bad_inspec_name" style="height:60px; font-size:30px; text-align:right; border: 0px; background-color: #555;" readonly >
								    </div>
							    	<div class="col-2">
	  									<input type="text" class="form-control" id="bad_inspec_q" name="bad_inspec_q" style="height:60px; font-size:30px; text-align:right; border: 0px; background-color: #555;" readonly >
								    </div>
								    <div class="col-4">
		                        		<button type="button" class="btn btn-xs btn-outline-warning btn-block" id="plus" style ="height:60px; font-size:30px;"><i class="uil-plus-square"></i></button>
		                        	</div>
		                        	<div class="col-4">
		                        		<button type="button" class="btn btn-xs btn-outline-warning btn-block" id="minus" style ="height:60px; font-size:30px;"><i class="uil-minus-square"></i></button>
		                        	</div>
	                        	</div>
	                        </div> -->
                        </div>
					
		 				<div class="form-group mb-0 text-center">
							<button type="button" class="btn btn-outline-warning btn-rounded" id="addBtn" style ="width:100px; height:50px; font-size:10px;"></i>작업지시 데이터</button>
                        </div>
                        	<div class="form-group mb-0 text-center">
							<button type="button" class="btn btn-outline-warning btn-rounded" id="addBtn2" style ="width:100px; height:50px; font-size:10px;"></i>불량코드 데이터2</button>
                        </div>
                        
                        
                        
						<!-- <div class="row">
	                        <div class="col-12">
	                            <div class="page-title-box">
	                                <div class="page-title-right">
	                                    <ol class="breadcrumb m-0">
	                                        <li class="breadcrumb-item"><a href="javascript: void(0);">Hyper</a></li>
	                                        <li class="breadcrumb-item"><a href="javascript: void(0);">UI Kit</a></li>
	                                        <li class="breadcrumb-item active">Cards</li>
	                                    </ol>
	                                </div>
	                                <h4 class="page-title">Cards</h4>
	                            </div>
	                        </div>
	                    </div>  
	                    
	                    
				    	<div class="row">
				    	
	                        <div class="col-md-6 col-lg-3">
	                            <div class="card d-block">
	                                <img class="card-img-top" src="'+ CPATH+'/equit/equ201Photo/{FILE_ID}.{FILE_EXT}" alt="Card image cap">
	                                <div class="card-body">
	                                    <h5 class="card-title">Card title</h5>
	                                    <p class="card-text">Some quick example text to build on the card title and make
	                                        up the bulk of the card's content. Some quick example text to build on the card title and make up.</p>
	                                    <a href="javascript: void(0);" class="btn btn-primary">Button</a>
	                                </div> end card-body
	                            </div> end card
	                        </div>end col
	
	                        <div class="col-md-6 col-lg-3">
	                            <div class="card d-block">
	                                <img class="card-img-top" src="assets/images/small/small-2.jpg" alt="Card image cap">
	                                <div class="card-body">
	                                    <h5 class="card-title">Card title</h5>
	                                    <p class="card-text">Some quick example text to build on the card..</p>
	                                </div>
	                                <ul class="list-group list-group-flush">
	                                    <li class="list-group-item">Cras justo odio</li>
	                                </ul>
	                                <div class="card-body">
	                                    <a href="javascript: void(0);" class="card-link text-custom">Card link</a>
	                                    <a href="javascript: void(0);" class="card-link text-custom">Another link</a>
	                                </div> end card-body
	                            </div> end card
	                        </div>end col
	
	                        <div class="col-md-6 col-lg-3">
	                            <div class="card d-block">
	                                <img class="card-img-top" src="assets/images/small/small-3.jpg" alt="Card image cap">
	                                <div class="card-body">
	                                    <p class="card-text">Some quick example text to build on the card title and make
	                                        up the bulk of the card's content. Some quick example text to build on the card title and make up.</p>
	                                    <a href="javascript: void(0);" class="btn btn-primary">Button</a>
	                                </div> end card-body
	                            </div> end card
	                        </div>end col
	
	
	                        <div class="col-md-6 col-lg-3">
	                            <div class="card d-block">
	                                <div class="card-body">
	                                    <h5 class="card-title">Card title</h5>
	                                    <h6 class="card-subtitle text-muted">Support card subtitle</h6>
	                                </div>
	                                <img class="img-fluid" src="assets/images/small/small-4.jpg" alt="Card image cap">
	                                <div class="card-body">
	                                    <p class="card-text">Some quick example text to build on the card title and make
	                                        up the bulk of the card's content.</p>
	                                    <a href="javascript: void(0);" class="card-link text-custom">Card link</a>
	                                    <a href="javascript: void(0);" class="card-link text-custom">Another link</a>
	                                </div> end card-body
	                            </div> end card
	                        </div>end col
	                    </div> -->
				    </div>
			    </div>
			    
			</div>
		</main>
		
		<footer class="container-fluid navbar-fixed-bottom">
	<!-- 	  	<div class="row">
		  		<div class="form-group mb-0 text-center">
							<button type="button" class="btn btn-outline-success btn-rounded" id="addBtn" style ="width:100px; height:50px; font-size:10px;"></i>다이나믹 데이터</button>
                        </div>
			</div> -->
		</footer>

	
	
	
	
				
						
						
						
		




</body>


<!-- js -->		
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.min.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-ui.min.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>

	
	<script type="text/javascript" chartset="utf-8">
	$(document).ready(function(){
		
		//설비명 콤보리스트set
		fnEquipCodeList();
		
		//설비명 콤보선택시
		$("#equip_code").change(function(){

			$('#coreInfo').css("background-color", "#444");	//시작완료,오류 색 다시 초기 색으로 변경 
			
			$("#core_code").val("");
			$("#item_name").val("");
			$("#wkord_q").val("");
			var equipCode = $("#equip_code").val();
			fnWkordNumList(equipCode);
		});
		
		//작지번호 콤보선택시
		$("#wkord_num").change(function(){
			var wkodNum = $("#wkord_num").val();
			fnWkordNumInfo(wkodNum);
		});
		
		
    	realTimer();
    	setInterval(realTimer, 500);
    	
    	
    	
    	
    	
		function numberWithCommas(x) {
		  x = x.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
		  x = x.replace(/,/g,'');          // ,값 공백처리
		  $("#wkord_q").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가 
		}
		 
		
		
		/*$(".btn-countUp").click(function(){
			var $target = $(this).parent().siblings(".countNum");
			var countNum = parseInt($target.text());
			$target.text(countNum + 1);
		});*/
		
		$("#addBtn").click(function () {
            /* if( ($('.form-horizontal .control-group').length+1) > 2) {
                alert("Only 2 control-group allowed");
                return false;
            } */
            for(var i=0; i<6; i++){
            	//var id = ($('.form-horizontal .control-group').length+1).toString();
            	var id = i;
            	
            	$('.row-dynamic').append(
           			'<div class="col-md-6 col-lg-4">'+
						'<div class="card d-block">'+
							'<img class="card-img-top" src="'+'+ CPATH+'+'/equit/equ201Photo/{FILE_ID}.{FILE_EXT}" alt="Card image cap">'+
							'<div class="card-body">'+
								'<h5 class="card-title">'+'Card title'+'</h5>'+
								'<p class="card-text">'+'test'+'</p>'+
								'<a href="javascript: void(0);" class="btn btn-primary">Button</a>'+
							'</div>'+
						'</div>'+
					'</div>'
            	/* 		
           			'<div class="control-group" id="control-group' + id + '">'+
           				'<label class="control-label" for="inputEmail' + id + '">Email' + id + '</label>'+
	           			'<div class="controls' + id + '">'+
	           				'<input type="text" id="inputEmail' + id + '" placeholder="Email">'+
	           			'</div>'+
           			'</div>' */
           		);
            	
            }
           
        });
		$("#addBtn2").click(function () {
            /* if( ($('.form-horizontal .control-group').length+1) > 2) {
                alert("Only 2 control-group allowed");
                return false;
            } */
            for(var i=0; i<6; i++){
            	//var id = ($('.form-horizontal .control-group').length+1).toString();
            	var id = i;
            	
            	$('.row-dynamic2').append(
            		'<div class="col-sm-4 col-md-4 col-lg-4">'+
                		'<div class="row" style ="align-items: center; height:80px; background-color: #555;" >'+
                			'<div class="col-2">'+
								'<input type="text" class="form-control" id="bad_inspec_name" name="bad_inspec_name" style="height:60px; font-size:30px; text-align:right; border: 0px; color: #fff; background-color: #555;" >'+
						    '</div>'+
					    	'<div class="col-2">'+
								'<input type="text" class="form-control" id="bad_inspec_q" name="bad_inspec_q" style="height:60px; font-size:30px; text-align:center; border: 0px; color: #fff; background-color: #555;" >'+
						    '</div>'+
						    '<div class="col-4">'+
                        		'<button type="button" class="btn btn-xs btn-outline-warning btn-block" id="plus" style ="height:60px; font-size:30px;"><i class="uil-plus-square"></i></button>'+
                        	'</div>'+
                        	'<div class="col-4">'+
                        		'<button type="button" class="btn btn-xs btn-outline-warning btn-block" id="minus" style ="height:60px; font-size:30px;"><i class="uil-minus-square"></i></button>'+
                        	'</div>'+
                    	'</div>'+
                    '</div>'
            	/* 		
           			'<div class="control-group" id="control-group' + id + '">'+
           				'<label class="control-label" for="inputEmail' + id + '">Email' + id + '</label>'+
	           			'<div class="controls' + id + '">'+
	           				'<input type="text" id="inputEmail' + id + '" placeholder="Email">'+
	           			'</div>'+
           			'</div>' */
           		);
            	
            }
           
        });
  /*       $("#removeButton").click(function () {
            if ($('.form-horizontal .control-group').length == 1) {
                alert("No more textbox to remove");
                return false;
            }

            $(".form-horizontal .control-group:last").remove();
        }); */
        
		
		$(document).on("click", "#startBtn", function(){
			
			fnStartSave();
			
/* 			
			var table = $('#tblSMInfo').DataTable();
			let params = [];
			let tblRows = $("#tblSMInfo").dataTable().api().rows();
			let s = 0;
			$.each(tblRows.data(), function(i, v){
				params[s] = v;
				params[s].USER_ID = userId;
				params[s].COMP_CODE = userCompCode;
				params[s].DIV_CODE = userDivCode;
				params[s].PRODT_DATE = $("#wkordDate").val();
				params[s].PRODT_PRSN = $("#wkordPrsn").val();
				params[s].WORK_Q = table.cell(s,2).nodes().to$().find('input').val();
				
				s++;
			});
			fnSave(params);
			 */
			
		});
		
		
		
		
		
		   $(".dashItemWrap").click(function(){
	            var $target = $(this).children(".countNum");
	            var countNum = parseInt($target.text());
				$target.text(countNum + 1);
	        });
	        
			$(".btn-reset").click(function(){
	            
	            if(confirm("Reset 하시겠습니까?") == true) {
	                $(".countNum").text(0);    
	            }
				
			})
			
		
	})
	
	
	
	function fnValidation(){
		//e.preventDefault();
		//e.stopPropagation();
		var $t, t;
		var result = true;
		var error;
	
		//try{
			/* if ($("#AccountInfo").find("button.on").length == 0){
				throw new Error( "은행을 선택하세요." );
			} */
			$("#coreInfo").find("input, select, textarea").each(function(i) {
				$t = jQuery(this);
	
				if($t.prop("required")) {
					if(!jQuery.trim($t.val())) {
						t = jQuery("label[for='"+$t.attr("id")+"']").text();
						$t.focus();
						//throw new Error( t + " 필수 입력입니다." );
						alert( t + " 필수 입력입니다." );
						result = false;
					}
				}
			});
	
			return result;
		//}catch(e){
			//AlertsUtil.error(strMsg);
		//	AlertsUtil.warning(e.message);
		//	result = false;
		//}finally{
		//	return result;
		//}
	}
	
	

	function fnEquipCodeList(){
		
	//	var me = this;

		//var ajaxUrl 	= "/cms/common/getCode.do";
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getEquipCode.do";
		var ajaxData 	= {};
		var ajaxloding	= false;
		var returnCode;
		var ajaxCallback= function (data) {
			returnCode = data;
			
			var equipList = returnCode;
			
			$("#equip_code option").remove();
			$("#equip_code").append('<option value="">선택 해주세요</option>');
			for(var i = 0; i < equipList.length; i++){
				$("#equip_code").append("<option value='"+ equipList[i].EQU_CODE +"'>" + equipList[i].EQU_NAME + "</option>");
			}
		}
		var type = 'GET';

		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);

	}
	
	function fnWkordNumList(equipCode){
			
		//	var me = this;

			//var ajaxUrl 	= "/cms/common/getCode.do";
			var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getWkordNum.do";
			var ajaxData 	= {'EQUIP_CODE' : equipCode};
			var ajaxloding	= false;
			var returnCode;
			var ajaxCallback= function (data) {
				returnCode = data;
				
				var wkordNumList = returnCode;
				
				$("#wkord_num option").remove();
				$("#wkord_num").append('<option value="">선택 해주세요</option>');
				for(var i = 0; i < wkordNumList.length; i++){
					$("#wkord_num").append("<option value='"+ wkordNumList[i].WKORD_NUM +"'>" + wkordNumList[i].WKORD_SO_NUM + "</option>");
				}
			}
			var type = 'GET';

			DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);

		}
	
	function fnWkordNumInfo(wkordNum){
		
		//	var me = this;

			//var ajaxUrl 	= "/cms/common/getCode.do";
			var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getWkordNumInfo.do";
			var ajaxData 	= {'WKORD_NUM' : wkordNum};
			var ajaxloding	= false;
			var returnCode;
			var ajaxCallback= function (data) {
				returnCode = data;
				
				var wkordNumInfo = returnCode;
				$("#core_code").val(wkordNumInfo.CORE_CODE);
				$("#item_name").val(wkordNumInfo.ITEM_NAME);
				$("#wkord_q").val(wkordNumInfo.WKORD_Q);
				/* 
				$("#wkord_num option").remove();
				//$("#wkord_num").append('<option value="">[선 택]</option>');
				for(var i = 0; i < wkordNumList.length; i++){
					$("#wkord_num").append("<option value='"+ wkordNumList[i].WKORD_NUM +"'>" + wkordNumList[i].WKORD_SO_NUM + "</option>");
				} */
			}
			var type = 'GET';

			DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);

		}
	
	//시작버튼
	function fnStartSave(){

		var result = true;
		var error = "";
		try{
	//		if (!confirm("시작 하시겠습니까?")) return;

			if (!fnValidation()) return;
			var param = {
				'EQUIP_CODE' : $("#equip_code").val(),
				'WKORD_NUM' : $("#wkord_num").val(),
				'CORE_CODE' : $("#core_code").val(),
				'PRODT_START_DATE' : $("#prodt_start_date").val().split(".").join(""),
				'PRODT_START_TIME' : $("#prodt_start_time").val()
			};
		
			var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/startSave.do";
			var ajaxData = param;
			var ajaxloding = true;
			var ajaxCallback = function (data) {
				if(data == null || data == ''){
					error = "관리자에게 문의하세요.";
					$('#coreInfo').css("background-color", "#fa6767");		//오류 색으로 변경
					//$('#coreCardInfo').css("opacity", "0.5");
					//#fa6767
				}else{
					if(data.status == "1"){
						AlertsUtil.save("이미 시작 되었습니다.");
					}else{
						AlertsUtil.save("시작 되었습니다.");	
					}
					$('#coreInfo').css("background-color", "#42d29d");	//시작완료 색으로 변경
					//$('#coreCardInfo').css("opacity", "0.5");
					//#42d29d
				}
			}

			var returnCode = param;
			var type = 'POST'
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 

			if(error != ""){
				throw new Error(error);;
			}
		}catch(e){
			//AlertsUtil.error(strMsg);
			AlertsUtil.warning(e.message);
			error = "";
			result = false;
		}finally{
			return result;
		}
		

	}	
		
	/* 	
		if(params.length <= 0){
	        window.Android.callMsg("저장할 데이터가 없습니다.");
		}else{
			var ajaxUrl     = "${pageContext.request.contextPath}/pda/s_pdp100ukrv_wm_save.do";
			var ajaxData    = {
				data : JSON.stringify(params)
			};
			var returnCode;
			var ajaxloding  = false;
			var ajaxCallback= function (data) {

		   	if(data.success){
		      //  AlertsUtil.info("저장되었습니다.");
		        window.Android.callMsg(data.message);
		        fnMainTableDraw();
		   	}else{
		   		//AlertsUtil.error(data.message);
		   		window.Android.callMsg(data.message);
		   	}
				returnCode = data;
		    }
			var type = 'POST'
		   
		   DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 
		} */
	
	
	
	function realTimer() {
		const nowDate = new Date();
		const year = nowDate.getFullYear();
		const month= nowDate.getMonth() + 1;
		const date = nowDate.getDate();
		const hour = nowDate.getHours();
		const min = nowDate.getMinutes();
		const sec = nowDate.getSeconds();
		

		$("#prodt_start_date").val(year + "." + addzero(month) + "." + addzero(date));
		$("#prodt_start_time").val(hour + ":" + addzero(min) + ":" + addzero(sec));
		
		$("#prodt_start_date2").val(year + "." + addzero(month) + "." + addzero(date));
		$("#prodt_start_time2").val(hour + ":" + addzero(min) + ":" + addzero(sec));
		
		//panelSearch.down('#nowTimes').setHtml(hour + ":" + addzero(min) + ":" + addzero(sec));
		//panelSearch.down('#nowDays').setHtml(year + "년 " + addzero(month) + "월 " + addzero(date) + "일");
	}
    // 1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) { num = "0" + num; }
 		return num;
	}
	
	
	
	</script>
</html>
