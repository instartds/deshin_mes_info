<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page session="false" %>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>대쉬보드</title>
<!-- <script src="https://code.jquery.com/jquery-1.12.4.min.js"
		integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="
		crossorigin="anonymous"></script>
		 -->
		
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="SQN">


	<title>SQN</title>
	<!-- http://blackrockdigital.github.io/startbootstrap-sb-admin-2/pages/tables.html -->
	<!-- Bootstrap Core CSS -->
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/bootstrap/dist/css/bootstrap.min.css"/>" rel="stylesheet">
	<!-- MetisMenu CSS -->
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/metisMenu/dist/metisMenu.min.css"/>" rel="stylesheet">
	
	<link href="<c:url value="/resources/css/dashboard/css/jquery-ui-1.10.4.custom.css"/>" rel="stylesheet">
	
	
	
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.css"/>" rel="stylesheet">
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/datatables-responsive/css/responsive.dataTables.scss"/>" rel="stylesheet">
	
	<!-- Timeline CSS -->
	<link href="<c:url value="/resources/css/dashboard/ext/dist/css/timeline.css"/>" rel="stylesheet">
	<!-- Custom CSS -->
	<link href="<c:url value="/resources/css/dashboard/ext/dist/css/sb-admin-2.css"/>" rel="stylesheet">
	<!-- Morris Charts CSS -->
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/morrisjs/morris.css"/>" rel="stylesheet">
	<!-- Custom Fonts -->
	<link href="<c:url value="/resources/css/dashboard/ext/bower_components/font-awesome/css/font-awesome.css"/>" rel="stylesheet" type="text/css">

	<!-- Custom Common CSS -->
	<link href="<c:url value="/resources/css/dashboard/css/common.css"/>" rel="stylesheet" type="text/css">

	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	
	
	<!-- jQuery -->
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/jquery/dist/jquery.min.js"/>"></script>
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/jquery/dist/jquery.number.min.js"/>"></script>
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/jquery/dist/jquery.animateNumber.js"/>"></script>
	<!-- Bootstrap Core JavaScript -->
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/bootstrap/dist/js/bootstrap.min.js"/>"></script>
	<!-- DataTables on Bootstrap -->
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/datatables/media/js/jquery.dataTables.min.js"/>"></script>
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"/>"></script>
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/datatables-responsive/js/dataTables.responsive.js"/>"></script>
	
	
	<!-- Metis Menu Plugin JavaScript -->
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/metisMenu/dist/metisMenu.min.js"/>"></script>
	<!-- Morris Charts JavaScript / http://morrisjs.github.io/morris.js/ -->
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/raphael/raphael-min.js"/>"></script>
	<script src="<c:url value="/resources/css/dashboard/ext/bower_components/morrisjs/morris.min.js"/>"></script>
	<!-- Custom Theme JavaScript -->
	<script src="<c:url value="/resources/css/dashboard/ext/dist/js/sb-admin-2.js"/>"></script>
	

	<!-- jQslide / http://egorkhmelev.github.io/jslider/ -->
	<link rel="stylesheet" href="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/css/jslider.css"/>" type="text/css">
	<link rel="stylesheet" href="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/css/jslider.blue.css"/>" type="text/css">
	<link rel="stylesheet" href="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/css/jslider.plastic.css"/>" type="text/css">
	<link rel="stylesheet" href="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/css/jslider.round.css"/>" type="text/css">
	<link rel="stylesheet" href="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/css/jslider.round.plastic.css"/>" type="text/css">
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/jshashtable-2.1_src.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/jquery.numberformatter-1.2.3.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/tmpl.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/jquery.dependClass-0.1.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/draggable-0.1.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/css/dashboard/ext/bower_components/jslider/js/jquery.slider.js"/>"></script>

	<!-- HighStock -->
	<script src="https://code.highcharts.com/stock/highstock.js"></script>
	<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>

	<!-- Custom Common JavaScript -->
	<script src="<c:url value="/resources/css/dashboard/js/main/main.js"/>"></script>

	<script>var CONTEXT_ROOT = "${pageContext.request.contextPath}/";
	</script>

</head>
<body>
	<!-- Modal -->
	<!-- 상단 정보 -->
	<c:import url="/dashboard/modal/preform_irreg_accuracy_rate?id=preform_irreg_accuracy_rate" />
	
<%@include file="modal/issue_report_detail.jsp" %>
	
	<script>
	/* $('#modal_').removeClass('fade');
	$('#modal_').css('display', 'block'); */
	</script>
	
	<!-- 프리폼 제조 탭 -->
	<c:import url="modal/issue_report_detail?id=issue_report_detail" />
	<c:import url="modal/pet_input?id=pet_input" />
	<c:import url="modal/catapult_status1?id=catapult_status1" />
	<c:import url="modal/cylinder_status?id=cylinder_status" />
	<c:import url="modal/moulding_temperature?id=moulding_temperature" />
	<c:import url="modal/catapult_production_process?id=catapult_production_process" />
	<c:import url="modal/etc_temperature?id=etc_temperature" />
	<c:import url="modal/preform_test?id=preform_test" />
	<c:import url="modal/preform_output?id=preform_output" />
	
	<c:import url="modal/preform_output_history?id=preform_output_history" />
	
	<!-- 생수 제조 탭 -->
	<c:import url="/dashboard/modal/preform_put?id=preform_put" />
	<c:import url="/dashboard/modal/seal_product_test?id=seal_product_test" />
	<c:import url="/dashboard/modal/visual_examination?id=visual_examination" />
	<c:import url="/dashboard/modal/product_shipments?id=product_shipments" />
	<!-- /Modal -->


	<div id="page-wrapper">
		<!-- TOP -->
		<div class="row">
			<!-- <ul class="nav nav-tabs" id="nav-tabs" style="margin-top: 10px;">
				<li class="active"><a href="#tab_area_0" onclick="changeTab(0)" data-toggle="tab" aria-expanded="true">프리폼 제조</a></li>
				<li class=""><a href="#tab_area_1" onclick="changeTab(1)" data-toggle="tab" aria-expanded="false">생수 제조</a></li>
			</ul> -->
			<div class="col-lg-12 page-header pd0">
				<div class="col-lg-23 pd0">
					<div class="col-lg-40 col-md-40 col-sm-40 pd0">
						<div class="panel panel-none">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-9 text-left">
										<div>날짜</div>
									</div>
								</div>
							</div>
							<div class="panel-body top-clock" id="top_clock_date">
<!-- 								<div class="year_bg"><div name="year_0"></div><div name="year_1"></div><div name="year_2"></div><div name="year_3"></div></div> -->
<!-- 								<div class="date_dot"></div> -->
								<div class="time_bg"><div name="month_before"></div><div name="month_after"></div></div>
								<div class="date_dot"></div>
								<div class="time_bg"><div name="date_before"></div><div name="date_after"></div></div>
							</div>
						</div>
					</div>
					<div class="col-lg-60 col-md-60 col-sm-60 pd0">
						<div class="panel panel-none">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-9 text-left">
										<div>현재 시간</div>
									</div>
								</div>
							</div>
							<div class="panel-body top-clock" id="top_clock_current">
								<div class="time_bg"><div name="hours_before"></div><div name="hours_after"></div></div>
								<div class="time_dot"></div>
								<div class="time_bg"><div name="minutes_before"></div><div name="minutes_after"></div></div>
								<div class="time_dot"></div>
								<div class="time_bg"><div name="seconds_before"></div><div name="seconds_after"></div></div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-76 pd0">
					<!-- 프리폼 -->
					<div id="summary-tab0">
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-cart-arrow-down"></i> 생산량(10열Ⅰ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_0"></span> <span class="unit">개</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-calendar-plus-o"></i> 가동시간(10열Ⅰ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_1"></span><span class="unit">&nbsp</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-calendar-minus-o"></i> 중단시간(10열Ⅰ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_2"></span> <span class="unit">&nbsp</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-square-o"></i> 생산량(10열 Ⅱ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_3"></span> <span class="unit">개</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-minus-square-o" data-toggle="modal" data-target="#modal_preform_irreg_accuracy_rate"></i> 가동시간(10열 Ⅱ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_4"></span> <span class="unit">&nbsp</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left" style="padding-right: 0px;">
											<i class="fa fa-lg fa-minus-square-o"></i> 중단시간(10열 Ⅱ)
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_5"></span> <span class="unit">&nbsp</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-check-square-o" data-toggle="modal" data-target="#modal_preform_irreg_accuracy_rate"></i> 불량 예측 오차율
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_preform_6"></span><span style="font-size: 2em;">0</span> <span class="unit">%</span>
								</div>
							</div>
						</div>
					</div>
					<!-- /프리폼 -->
					<!-- 생수 -->
					<div id="summary-tab1" style="display:none;">
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-cart-arrow-down"></i> 일 프리폼 투입량
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_0"></span> <span class="unit">kg</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-calendar-plus-o"></i> 일 생수 생산량
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_1"></span> <span class="unit">개</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-calendar-minus-o"></i> 일 생수 불량
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_2"></span> <span class="unit">개</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-square-o"></i> 일 생수 예측 불량
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_3"></span> <span class="unit">개</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-minus-square-o" data-toggle="modal" data-target="#modal_preform_irreg_accuracy_rate"></i> 일 생수 불량률
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_4"></span> <span class="unit">%</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left" style="padding-right: 0px;">
											<i class="fa fa-lg fa-minus-square-o"></i> 일 생수 예측불량률
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_5"></span> <span class="unit">%</span>
								</div>
							</div>
						</div>
						<div class="col-lg-14 col-md-14 col-sm-14 pdl0">
							<div class="panel panel-top">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-12 text-left">
											<i class="fa fa-lg fa-check-square-o"></i> 불량 예측 오차율
										</div>
									</div>
								</div>
								<div class="panel-body text-center">
									<span class="value" id="summary_water_6"></span> ()<span class="unit">%</span>
								</div>
							</div>
						</div>
					</div>
					<!-- /생수 -->
				</div>
			</div>
		</div>
		<!-- /TOP -->


		<!-- MAIN -->
		<div class="row">
			<div class="row">
				<div class="col-lg-12 pdl10 pdt10 pdr10">
					<div class="col-lg-80 col-md-8 col-sm-8 pdl5 pdr5">
						<div class="panel panel-main">
<!-- 							<div class="panel-body" id="main_area_0" style="height: 343px;"> -->
							<div class="panel-body" id="main_area_0" style="height: 343px;"> <!-- 차트인듯... -->
							</div>
						</div>
						<div>
							<!-- <div class="list-legend">
								<small>
									<i class="fa fa-cart-plus color-success"></i>생산량 (10열Ⅰ)
									<i class="fa fa-external-link-square color-warning"></i>생산량 (10열 Ⅱ)
								</small>
							</div> -->
						</div>
					</div>
					<div class="col-lg-20 col-md-4 col-sm-4 pdl5 pdr5">
						<div class="panel panel-main">
							<div class="panel-heading">
	<!-- 							불량 인자 -->
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">일자별 생산량 (10열Ⅰ)</div>
									<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_issue_report_detail"></i></div>
								</div>
							</div>
							<div class="panel-body">
								<ul class="chat" id="issue_report">
									<li class="left clearfix">
										<div class="list-number">1</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">2</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">3</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">4</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">5</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">6</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">7</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">8</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12 pdl10 pdt10 pdr10">
					<div class="col-lg-80 col-md-8 col-sm-8 pdl5 pdr5">
						<div class="panel panel-main">
<!-- 							<div class="panel-body" id="main_area_0" style="height: 343px;"> -->
							<div class="panel-body" id="main_area_1" style="height: 313px;"> <!-- 차트인듯... -->
							</div>
						</div>
						<div>
							<div class="list-legend">
								<small>
<!-- 									<i class="fa fa-cog color-success"></i>PET 중량센서 -->
									<i class="fa fa-cart-plus color-success"></i>투입현황
<!-- 									<i class="fa fa-line-chart color-warning"></i>사출기 센서 -->
									<i class="fa fa-external-link-square color-warning"></i>생산상태
									<!-- <i class="fa fa-first-order color-danger"></i>검사기 센서 --> <!-- 주석처리 -->
<!-- 									<i class="fa fa-database color-info"></i> -->
								</small>
							</div>
						</div>
					</div>
					<div class="col-lg-20 col-md-4 col-sm-4 pdl5 pdr5">
						<div class="panel panel-main">
							<div class="panel-heading">
	<!-- 							불량 인자 -->
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">일자별 생산량 (10열 Ⅱ)</div>
									<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_issue_report_detail"></i></div>
								</div>
							</div>
							<div class="panel-body">
								<ul class="chat" id="issue_report2">
									<li class="left clearfix">
										<div class="list-number">1</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">2</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">3</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">4</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">5</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">6</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">7</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
									<li class="left clearfix">
										<div class="list-number">8</div><div class="list-text"></div><i class="fa fa-fw fa-lg"></i>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- MAIN -->
			
			
			<!-- LIST -->
			<div class="tab-content">
				<div class="tab-pane fade active in" id="tab_area_0">
					<div class="row">
						<div class="col-lg-80 col-md-6 col-sm-6 pd0">
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-cart-plus fa-lg color-success" data-toggle="tooltip" data-placement="top" data-original-title="투입현황"></i></div>
											<div class="col-xs-8 text-center">원자재 투입량</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_pet_input"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_0">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-external-link-square fa-lg color-warning" data-toggle="tooltip" data-placement="top" data-original-title="생산상태"></i></div>
											<div class="col-xs-8 text-center">생산 상태 Ⅰ</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_catapult_status1"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_1">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-external-link-square fa-lg color-warning" data-toggle="tooltip" data-placement="top" data-original-title="생산상태"></i></div>
											<div class="col-xs-8 text-center">생산 상태 Ⅱ</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_catapult_status1"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_2">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
										
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-external-link-square fa-lg color-warning" data-toggle="tooltip" data-placement="top" data-original-title="생산상태"></i></div>
											<div class="col-xs-8 text-center">원단 상태</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_cylinder_status"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_3">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6 pdr5">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-external-link-square fa-lg color-warning" data-toggle="tooltip" data-placement="top" data-original-title="생산상태"></i></div>
											<div class="col-xs-8 text-center">표준 온도</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_moulding_temperature"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_4">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="clearfix"></div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-external-link-square fa-lg color-warning" data-toggle="tooltip" data-placement="top" data-original-title="생산상태"></i></div>
											<div class="col-xs-8 text-center">기타 온도</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_etc_temperature"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_5">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-2"><i class="fa fa-first-order fa-lg color-danger" data-toggle="tooltip" data-placement="top" data-original-title="검사기 센서"></i></div>
<!-- 											<div class="col-xs-2"><i class="fa fa-search fa-lg color-danger" data-toggle="tooltip" data-placement="top" data-original-title="검사기 센서"></i></div> -->
											<div class="col-xs-8 text-center">검사</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_preform_test"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_6"></div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading panel-heading-survey">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">생산량</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_preform_output"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_7"></div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading panel-heading-survey">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">생산량</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_preform_output"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_8"></div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-20 col-md-6 pdr5">
								<div class="panel panel-list">
									<div class="panel-heading panel-heading-survey">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">생산 추이</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_preform_output_history"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_0_9"></div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-20 col-md-6 col-sm-6 pdl5 pdr5">
							<div class="panel panel-list">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-9 col-xs-offset-1 text-center"> 생산과정</div>
										<div class="col-xs-1"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_catapult_production_process"></i></div>
									</div>
								</div>
								<div class="list-group" id="list_area_0_10" style="height:440px;overflow-y: scroll;"></div>
								<div class="panel-footer text-center">
									<i class="fa fa-clock-o fa-lg"></i> <span></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- LIST -->
				<div class="tab-pane fade" id="tab_area_1">
					<div class="row">
	<!-- 				<div class="col-lg-80 pd0"> -->
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">정열기 프리폼 투입</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_preform_put"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_0">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">날인 제품 검사</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_seal_product_test"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_1">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">육안 검사</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_visual_examination"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_2">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_3">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading panel-heading-survey">
										<div class="row">
											<div class="col-xs-10 text-right">프리폼 투입대비 제품 출하량</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_4">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading panel-heading-survey">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량 추이</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_5">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="clearfix"></div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량 L1</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments_l1"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_6">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량 L2</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments_l2"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_7">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량 L3</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments_l3"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_8">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
							<div class="col-lg-2 col-md-6">
								<div class="panel panel-list">
									<div class="panel-heading">
										<div class="row">
											<div class="col-xs-8 col-xs-offset-2 text-center">제품 출하량 L4</div>
											<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_product_shipments_l4"></i></div>
										</div>
									</div>
									<div class="list-group sqn-main-body" id="list_area_1_9">
									</div>
									<div class="panel-footer text-center">
										<i class="fa fa-clock-o fa-lg"></i> <span></span>
									</div>
								</div>
							</div>
	<!-- 				</div> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- /#page-wrapper -->


<script type="text/javascript" charset="utf-8">
	
 	// tooltip
 	$('.tab-content').tooltip({
 	    selector: "[data-toggle=tooltip]",
 	    container: "body"
 	});

 	


	$(function () {
		
 		TOP.init();
		
 		MAIN.chart.live.getData('main_area_0', 0);
 		MAIN.chart2.live.getData('main_area_1', 0);
// // 		MAIN.chart.live.draw('main_area_0', Math.round(Math.random()*100));
 		MAIN.list.set();
 		LIST.load();
		
// 		resizeFrame();
// 		$(window).on('resize', function() { 
// 			resizeFrame();
// 		});
	});
	
	function resizeFrame(){
		var $navbar = $('.navbar.navbar-default.navbar-static-top');
// 		var $pageHeader = $('.page-header');
		var $listRow = $('.tab-content .tab-pane > .row');
		var $panelFooter = $('.panel-list>.panel-footer');
		var $listArea = $('#list_area_0_10');
		if(window.innerWidth == screen.width && window.innerHeight == screen.height && !window.mobileAndTabletcheck()){
			$navbar.hide();
// 			$pageHeader.css('margin-bottom', 5);
			$listRow.css('margin-top', '0px');
			$panelFooter.css('padding', '5px 15px');
			$listArea.css('height', '428px');
		}else{
			$navbar.show();
// 			$pageHeader.css('margin-bottom', 20);
			$listRow.css('margin-top', '0px');
			$panelFooter.css('padding', '10px 15px');
			$listArea.css('height', '440px');
		}
	}
	
	function changeTab(idx){
		if($('#main_area_0').highcharts()) $('#main_area_0').highcharts().destroy();
// 		$('#nav-tabs > li:eq('+idx+')').addClass('active').siblings().removeClass('active')
		MAIN.chart.live.getData('main_area_0', idx);
		
		$('#summary-tab'+idx).show().siblings().hide();
	}
	
</script>


</body>
</html>