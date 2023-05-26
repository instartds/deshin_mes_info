<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="utf-8" />
		<title>DELTA MES</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<meta name="copyright" content="" />
		<meta name="google-site-verification" content="" />

		<meta property="og:url" content="">
		<meta property="og:title" content="">
		<meta property="og:image" content="">
		<meta property="og:description" content="">

		<meta content="" name="description" />
		<meta content="" name="author" />
		<link rel="shortcut icon" href='<c:url value="/resources/images/main/logo.ico" />' type="image/x-icon" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/common.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/dataTables.bootstrap4.min.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/buttons.bootstrap4.min.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/responsive.dataTables.css"/>" />
		<!-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/jquery.dataTables.css"/>" /> -->

	</head>

	<body class="loading">
		<!-- Begin page -->
		<div class="wrapper">
			<!-- ========== Left Sidebar Start ========== -->
			<div class="left-side-menu">

				<div class="slimscroll-menu" id="left-side-menu-container">

					<!-- LOGO -->
					<a href=<c:url value="main_m.do"/> class="logo text-center">
						<span class="logo-lg">
							<%-- <img src="<c:url value="/resources/images/bootstrap/SF_symbol_w.png"/>" alt="시너지시스템즈" height="32px;" id="side-main-logo"> --%>
						</span>
						<span class="logo-sm">
							<%-- <img src="<c:url value="/resources/images/bootstrap/SF_symbol.png"/>" alt="시너지시스템즈" height="32px;" id="side-sm-main-logo"> --%>
						</span>
					</a>

					<!--- Sidemenu -->
					<ul class="metismenu side-nav">
						<!-- 기준 -->
						<li class="side-nav-title side-nav-item">

							<hr class="mt-1 mb-1" />
						</li>
						<li class="side-nav-item">
							<a href="javascript: void(0);" class="side-nav-link">
								<i class="uil-box"></i>
								<span> 출고관리</span>
								<span class="menu-arrow"></span>
							</a>
							<ul class="side-nav-second-level" aria-expanded="false">
								<li>
									<a href="javascript:openDiv('<c:url value="/zm_wm/sm_pdp100ukrv_wm.do"/>');">제품출고관리</a>
								</li>

							</ul>
						</li>

					</ul>

					<!-- Help Box -->
					<div class="help-box text-white text-center" style="display:none">
						<a href="javascript: void(0);" class="float-right close-btn text-white">
							<i class="mdi mdi-close"></i>
						</a>
						<img src="<c:url value="/resources/images/hyper/help-icon.svg"/>" height="90" alt="Helper Icon Image" />
						<h5 class="mt-3">Unlimited Access</h5>
						<p class="mb-3">Upgrade to plan to get access to unlimited reports</p>
						<a href="javascript: void(0);" class="btn btn-outline-light btn-sm">Upgrade</a>
					</div>
					<!-- end Help Box -->
					<!-- End Sidebar -->

					<div class="clearfix"></div>

				</div>
				<!-- Sidebar -left -->

			</div>
			<!-- Left Sidebar End -->

			<!-- ============================================================== -->
			<!-- Start Page Content here -->
			<!-- ============================================================== -->

			<div class="content-page">
				<div class="content">
					<!-- Topbar Start -->
					<div class="navbar-custom">
						<ul class="list-unstyled topbar-right-menu float-right mb-0">
							<li class="notification-list">
								<a class="nav-link right-bar-toggle" href="javascript: void(0);">
									<i class="dripicons-gear noti-icon"></i>
								</a>
							</li>

							<li class="dropdown notification-list" style="display:none;">
								<a class="nav-link dropdown-toggle arrow-none" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
									<i class="dripicons-bell noti-icon"></i>
									<span class="noti-icon-badge"></span>
								</a>
								<div class="dropdown-menu dropdown-menu-right dropdown-menu-animated dropdown-lg">

									<!-- item-->
									<div class="dropdown-item noti-title">
										<h5 class="m-0">
											<span class="float-right">
												<a href="javascript: void(0);" class="text-dark">
													<small>Clear All</small>
												</a>
											</span>Notification
										</h5>
									</div>

									<div class="slimscroll" style="max-height: 230px;">
										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon bg-primary">
												<i class="mdi mdi-comment-account-outline"></i>
											</div>
											<p class="notify-details">Caleb Flakelar commented on Admin
												<small class="text-muted">1 min ago</small>
											</p>
										</a>

										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon bg-info">
												<i class="mdi mdi-account-plus"></i>
											</div>
											<p class="notify-details">New user registered.
												<small class="text-muted">5 hours ago</small>
											</p>
										</a>

										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon">
												<img src="<c:url value="/resources/images/hyper/users/avatar-2.jpg"/>" class="img-fluid rounded-circle" alt="" /> </div>
											<p class="notify-details">Cristina Pride</p>
											<p class="text-muted mb-0 user-msg">
												<small>Hi, How are you? What about our next meeting</small>
											</p>
										</a>

										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon bg-primary">
												<i class="mdi mdi-comment-account-outline"></i>
											</div>
											<p class="notify-details">Caleb Flakelar commented on Admin
												<small class="text-muted">4 days ago</small>
											</p>
										</a>

										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon">
												<img src="<c:url value="/resources/images/hyper/users/avatar-4.jpg"/>" class="img-fluid rounded-circle" alt="" /> </div>
											<p class="notify-details">Karen Robinson</p>
											<p class="text-muted mb-0 user-msg">
												<small>Wow ! this admin looks good and awesome design</small>
											</p>
										</a>

										<!-- item-->
										<a href="javascript:void(0);" class="dropdown-item notify-item">
											<div class="notify-icon bg-info">
												<i class="mdi mdi-heart"></i>
											</div>
											<p class="notify-details">Carlos Crouch liked
												<b>Admin</b>
												<small class="text-muted">13 days ago</small>
											</p>
										</a>
									</div>

									<!-- All-->
									<a href="javascript:void(0);" class="dropdown-item text-center text-primary notify-item notify-all">
										View All
									</a>

								</div>
							</li>

							<li class="dropdown notification-list">
								<a class="nav-link dropdown-toggle nav-user arrow-none mr-0" data-toggle="dropdown" href="#" role="button" aria-haspopup="false"
									aria-expanded="false">
									<span class="account-user-avatar">
										<img src="${pageContext.request.contextPath}/resources/images/bg_pf_noimg.png" alt="user-image" class="rounded-circle">
									</span>
									<span>
										<span class="account-user-name">${userName}</span>
										<!-- <span class="account-position">시너지 시스템즈</span> -->
                                        <span class="account-position">${compName}</span>
									</span>
								</a>
								<div class="dropdown-menu dropdown-menu-right dropdown-menu-animated topbar-dropdown-menu profile-dropdown">
									<!-- item-->
									<!-- <div class=" dropdown-header noti-title">
										<h6 class="text-overflow m-0">환영합니다.</h6>
									</div> -->
									<!-- item-->
									<a href="<c:url value="/login/actionLogout.do"/>" class="dropdown-item notify-item">
										<i class="mdi mdi-logout mr-1"></i>
										<span>로그아웃</span>
									</a>
								</div>
							</li>

						</ul>
						<button class="button-menu-mobile open-left disable-btn">
							<i class="mdi mdi-menu"></i>
						</button>
						<!-- <div class="app-search">
							<form>
								<div class="input-group">
									<input type="text" class="form-control" placeholder="Search...">
									<span class="mdi mdi-magnify"></span>
									<div class="input-group-append">
										<button class="btn btn-primary" type="submit">Search</button>
									</div>
								</div>
							</form>
						</div> -->
					</div>
					<!-- end Topbar -->

					<!-- Start Content-->
					 <!--시작-->

					   <!-- <div class="content" style="height:100%;">
							<iframe id="ifr-main-content" src="" frameborder="0" style="display:block; width:100%; height: 100vh" scrolling="no" ></iframe>
					   </div> -->

						<div id="dynamic_div">
						</div>

					<!--종료 -->
					<!-- container -->

				</div>
				<!-- content -->

				<!-- Footer Start -->
				<footer class="footer">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-6">
								© DELTA MES
							</div>
							<!-- <div class="col-md-6">
								<div class="text-md-right footer-links d-none d-md-block">
									<a href="javascript: void(0);">About</a>
									<a href="javascript: void(0);">Support</a>
									<a href="javascript: void(0);">Contact Us</a>
								</div> -->
							</div>
						</div>
					</div>
				</footer>
				<!-- end Footer -->

			</div>

			<!-- ============================================================== -->
			<!-- End Page content -->
			<!-- ============================================================== -->


		</div>
		<!-- END wrapper -->

		<!-- Right Sidebar -->
		<div class="right-bar" >

		  <div class="rightbar-title">
			<a href="javascript:void(0);" class="right-bar-toggle float-right">
			  <i class="dripicons-cross noti-icon"></i>
			</a>
			<h5 class="m-0">설정</h5>
		  </div>

		  <div class="slimscroll-menu rightbar-content">

			<div class="p-3">
			  <!-- <div class="alert alert-warning" role="alert">
				<strong>Customize </strong> the overall color scheme, sidebar menu, etc. Note that, Hyper stores the preferences
				in local storage.
			  </div> -->

			  <!-- Settings -->
			  <h5 class="mt-1">테마</h5>
			  <hr class="mt-1" />

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="color-scheme-mode" value="light" id="light-mode-check"
				  checked />
				<label class="custom-control-label" for="light-mode-check">라이트 모드</label>
			  </div>

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="color-scheme-mode" value="dark" id="dark-mode-check" />
				<label class="custom-control-label" for="dark-mode-check">다크 모드</label>
			  </div>

			  <!-- Width -->
			  <h5 class="mt-4">폭</h5>
			  <hr class="mt-1"/>
			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="width" value="fluid" id="fluid-check" checked />
				<label class="custom-control-label" for="fluid-check">유동체</label>
			  </div>
			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="width" value="boxed" id="boxed-check" />
				<label class="custom-control-label" for="boxed-check">박스</label>
			  </div>

			  <!-- Left Sidebar-->
			  <h5 class="mt-4">메뉴바</h5>
			  <hr class="mt-1" />
			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="theme" value="default" id="default-check" checked />
				<label class="custom-control-label" for="default-check">기본</label>
			  </div>

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="theme" value="light" id="light-check" />
				<label class="custom-control-label" for="light-check">라이트</label>
			  </div>

			  <div class="custom-control custom-switch mb-3">
				<input type="radio" class="custom-control-input" name="theme" value="dark" id="dark-check" />
				<label class="custom-control-label" for="dark-check">다크</label>
			  </div>

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="compact" value="fixed" id="fixed-check" checked />
				<label class="custom-control-label" for="fixed-check">고정</label>
			  </div>

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="compact" value="condensed" id="condensed-check" />
				<label class="custom-control-label" for="condensed-check">응축</label>
			  </div>

			  <div class="custom-control custom-switch mb-1">
				<input type="radio" class="custom-control-input" name="compact" value="scrollable" id="scrollable-check" />
				<label class="custom-control-label" for="scrollable-check">스크롤 가능</label>
			  </div>

			  <button class="btn btn-primary btn-block mt-4" id="resetBtn">기본값</button>

			  <!-- <a href="https://themes.getbootstrap.com/product/hyper-responsive-admin-dashboard-template/" class="btn btn-danger btn-block mt-3" target="_blank"><i class="mdi mdi-basket mr-1"></i> Purchase Now</a> -->
			</div> <!-- end padding-->

		  </div>
		</div>

		<div class="rightbar-overlay"></div>
	   <!-- /Right-bar -->

	</body>
		<!-- iFrame -->
		<%-- <script type="text/javascript" src="<c:url value="/resources/js/jquery.iframeResizer.min.js" />"></script> --%>
		<!-- bundle -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.min.js" ></script>
		<!-- DataTable -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/datatables.min.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/dataTables.bootstrap4.min.js" ></script>
		<!-- jQuery -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/jquery.number.min.js" /></script>
		<!-- high chart -->
	<!-- 	<script type="text/javascript" src="https://code.highcharts.com/highcharts.js"></script>
		<script type="text/javascript" src="https://code.highcharts.com/modules/exporting.js"></script>
		<script type="text/javascript" src="https://code.highcharts.com/modules/export-data.js"></script>
		<script type="text/javascript" src="https://code.highcharts.com/modules/accessibility.js"></script> -->
		<!-- SynergyCommon -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/controll.js?ver=1.0"/></script>


		<script type="text/javascript" chartset="utf-8">
		var CPATH ='<%=request.getContextPath()%>';
		/********** 전역
		**************************************************/

		/********** 이벤트 함수 정의.
		**************************************************/
		var isMobile = false;
		$(document).ready(function () {
			fnInit();
		})

		/********** 초기화.
		**************************************************/
		function fnInit() {
			$("#dynamic_div").click().focus();
/* 			$("html").click(function(e){
				if ( $("#divCertPopLayer").length > 0 ){
					if ( e.target != $("#divCertPopLayer") && !$("#divCertPopLayer").find(e.target).length > 0 )
						$("#divCertPopLayer").remove();
				}
			}); */

			// 모바일 체크
			var filter = "win16|win32|win64|mac|macintel";
			if ( navigator.platform ) {
				if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { //mobile
					isMobile = true;
				} else { //pc
					isMobile = false;
				}
			}
//			openDiv("/dashBoardList.do");
		}

		/********** 메뉴 구성.
		**************************************************/
		function fnLeftMenuList(){

		}


		/********** 유효성 검사.
		**************************************************/
		function fnValidate() {

		}

		/********** 사용자 함수 정의
		**************************************************/


		function openDiv(uri){
			$('#dynamic_div').load(uri);
			//$('#left-side-menu').collapse().hide();
		}
		/* 프레임 resize() */
		/* $('#ifr-main-content').iFrameResize({
			 log                    : false,  // For development
			 autoResize             : true,  // Trigering resize on events in iFrame
			 contentWindowBodyMargin: 8,     // Set the default browser body margin style (in px)
			 enablePublicMethods    : true,
			 heightCalculationMethod: 'lowestElement',
			 //heightCalculationMethod: 'offset',	// 기존 lowestElement 적용시 iframe창 안에서 팝업호출시 위치 문제 발생(인증서 관련)
			 doHeight               : true,  // Calculates dynamic height
			 doWidth                : false, // Calculates dynamic width
			 enablePublicMethods    : true,  // Enable methods within iframe hosted page
			 interval               : 0,     // interval in ms to recalculate body height, 0 to disable refreshing
			 scrolling              : false, // Enable the scrollbars in the iFrame
			 callback               : function(messageData){ // Callback fn when message is received

			 }
		}); */


		</script>

</html>
