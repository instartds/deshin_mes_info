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

	<style>
		.panel{
			border-width: 0px 0px 0px;
			border-radius: 0px;
			box-shadow: none;
		}
		.panel-main{
			border-width: 1px;
		}
		
		.panel-title{
			padding:0px 0px 0px 10px;
			
		}
		
		.panel-default>.panel-heading{
			border-radius: 0px;
			background-color: #ffffff;
			border: 0px 0px 1px solid gray;
			height: 37px;
			padding:15px 1px 15px 1px;
			border-color: #ffffff;
			
		}
		.panel-default>.titleForm>.panel-body{
			border-width: 0px 0px 1px;
			border-style: gray;
			height:37px;
			font-size:16px;
			font-weight:bold;
			/* padding:0px 0px 0px 5px; */
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			border-color: #ffffff;
		}
		
		.panel-default>.prodt>.panel-body{
			border-width: 0px 0px 1px;
			border-style: gray;
			height:37px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		
		.panel-default>.prodt>.panel-body{
			border-width: 0px 0px 1px;
			border-style: gray;
			height:37px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		
		.circle1 {
			background-color:green;
			width:28px;
			height:28px;
			border-radius:75px;
			text-align:left;
			margin:0px;
			font-size:12px;
			vertical-align:middle;
			line-height:28px;
			padding:0px 0px 0px 20px;
		}
		
		.circle2 {
			background-color:orange;
			width:28px;
			height:28px;
			border-radius:75px;
			text-align:left;
			margin:0px;
			font-size:12px;
			vertical-align:middle;
			line-height:28px;
			padding:0px 0px 0px 20px;
		}
		
		.circle3 {
			background-color:red;
			width:28px;
			height:28px;
			border-radius:75px;
			text-align:left;
			margin:0px;
			font-size:12px;
			vertical-align:middle;
			line-height:28px;
			padding:0px 0px 0px 20px;
		}
		i {
			color: #44ADA8;
		}
	</style>

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
	<%-- <c:import url="modal/issue_report_detail?id=issue_report_detail" />
	<c:import url="modal/pet_input?id=pet_input" />
	<c:import url="modal/catapult_status1?id=catapult_status1" />
	<c:import url="modal/cylinder_status?id=cylinder_status" />
	<c:import url="modal/moulding_temperature?id=moulding_temperature" />
	<c:import url="modal/catapult_production_process?id=catapult_production_process" />
	<c:import url="modal/etc_temperature?id=etc_temperature" />
	<c:import url="modal/preform_test?id=preform_test" />
	<c:import url="modal/preform_output?id=preform_output" />
	
	<c:import url="modal/preform_output_history?id=preform_output_history" /> --%>
	
	<!-- 생수 제조 탭 -->
	<%-- <c:import url="/dashboard/modal/preform_put?id=preform_put" />
	<c:import url="/dashboard/modal/seal_product_test?id=seal_product_test" />
	<c:import url="/dashboard/modal/visual_examination?id=visual_examination" />
	<c:import url="/dashboard/modal/product_shipments?id=product_shipments" /> --%>
	<!-- /Modal -->


	<div id="page-wrapper">
		<!-- TOP -->
		<div class="row">
			<div class="hidden-lg hidden-md hidden-sm col-xs-12">
				<div style="padding:20px 0px 0px; /* color:#666; */font-size:16px; text-align:right; font-weight:bold;" id="clock">
				</div>
			</div>
			
		</div>
		<div class="row">
			<div class="col-lg-12 pd0">
				<div class="col-lg-3 hidden-md hidden-xs  pd0">
					<div class="col-lg-40 pd0">
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
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-certificate"></i> 설비
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9"> 
		  					<div class="col-lg-12 col-xs-6 pd0 panel-body">
							  	10열 스틱 1호기
							</div>
							<div class="col-lg-12 col-xs-6 pd0 panel-body">
							  	10열 스틱 2호기
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-2 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-cart-plus"></i> 품목
							</div>
		  				</div>
		  					<div class="col-lg-10 col-xs-4 panel-body" style="padding:4px 0px 0px 15px;">
							  	<div class="input-group">
							       	<input type="text" class="form-control" id="cboProdtName1" aria-label="..." readonly="readonly" style="background:#fff; font-weight:bold; color:#2828cd;">
									<div class="input-group-btn">
									  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span></button>
									  <ul class="dropdown-menu dropdown-menu-right" role="menu">
									  </ul>
									</div><!-- /btn-group -->
							    </div><!-- /input-group -->
							</div>
							<div class="col-lg-10 col-xs-4 panel-body" style="padding:4px 0px 0px 15px;">
							  	<div class="input-group">
							       	<input type="text" class="form-control" id="cboProdtName2" aria-label="..."  readonly="readonly" style="background:#fff; font-weight:bold; color:#2828cd;">
									<div class="input-group-btn">
									  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span></button>
									  <ul class="dropdown-menu dropdown-menu-right" role="menu">
									  </ul>
									</div><!-- /btn-group -->
							    </div><!-- /input-group -->
							</div>
		  				
						
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-adjust"></i> 상태
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9">
		  					<div class="col-lg-12 col-xs-6 panel-body" style="padding:5px 15px 0px;" id="summery_1_status">
							  	<div class="circle3"></div>
							</div>
							<div class="col-lg-12 col-xs-6 panel-body" style="padding:5px 15px 0px;" id="summery_2_status">
							  	<div class="circle3"></div>
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title">
								<i class="fa fa-lg fa-cart-arrow-down"></i> 생산량
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9 pdl0">
		  					<div class="col-lg-12 col-xs-6 pdt10 pdr0 panel-body" id="summery_1_equip" style="font-weight:bold; font-size:20px;">
							  	0
							</div>
							<div class="col-lg-12 col-xs-6 pdt10 pdr0 panel-body" id="summery_2_equip" style="font-weight:bold; font-size:20px;">
							  	0
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-square-o"></i> 시작
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9 pdl0">
		  					<div class="col-lg-12 col-xs-6 pdl15 pdr0 panel-body" id="summery_1_st_time">
							  	00:00:00
							</div>
							<div class="col-lg-12 col-xs-6 pdl15 pdr0 panel-body" id="summery_2_st_time">
							  	00:00:00
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-calendar-plus-o"></i> 가동
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9 pdl0">
		  					<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_1_op_time">
							  	00:00:00
							</div>
							<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_2_op_time">
							  	00:00:00
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-calendar-minus-o"></i> 중단
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9 pdl0">
		  					<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_1_op_stop">
							  	00:00:00
							</div>
							<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_2_op_stop">
							  	00:00:00
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-1 col-xs-12 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-3 pd0 panel-heading">
							<div class="panel-title ">
								<i class="fa fa-lg fa-check-square-o"></i> 횟수
							</div>
		  				</div>
		  				<div class="titleForm col-lg-12 col-xs-9 pdl0">
		  					<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_1_stop_cnt">
							  	0
							</div>
							<div class="col-lg-12 col-xs-6 pdr0 panel-body" id="summery_2_stop_cnt">
							  	0
							</div>
		  				</div>
						
					</div>
				</div>
			</div>
		</div>
		<!-- /TOP -->
		<!-- 금일 설비 정보 -->
		<!-- /금일 설비 정보 -->

		<!-- MAIN -->
		<div class="row">
			<div class="row">
				<div class="col-lg-6 pdl10 pdt10 pdr10">
					<div class="col-lg-12 col-md-12 col-sm-12">
						<div class="panel-body" id="main_area_0" style="height: 343px;"> <!-- 차트인듯... -->
						</div>
					</div>
				</div>
			
				<div class="col-lg-6 pdl10 pdt10 pdr10">
					<div class="col-lg-12 col-md-12 col-sm-12">
						<div class="panel-body" id="main_area_1" style="height: 343px;"> <!-- 차트인듯... -->
						</div>
					</div>
				</div>
			</div>
		</div>
			<!-- MAIN -->
			
			
			<!-- LIST -->
		<div class="container-fluid" style="height:420px;">
			<div class="row">
				<div class="col-lg-1 col-xs-3 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-12 pd0 panel-heading">
							<div class="panel-title pd0">일자</div>
		  				</div>
		  				<div class="prodt prodtDate">
		  					<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
		  				</div>
						
					</div>
				</div>
				<div class="col-lg-2 col-xs-3 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-12 pd0 panel-heading">
							<div class="panel-title pd0">설비</div>
		  				</div>
						<div class="prodt equipName">
		  					<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-3 col-xs-3 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-12 pd0 panel-heading">
							<div class="panel-title pd0">생산품목</div>
		  				</div>
						<div class="prodt prodtName">
		  					<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-12 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 col-xs-3 pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-12 pd0 panel-heading">
							<div class="panel-title pd0">생산량</div>
		  				</div>
						<div class="prodt prodtQty">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 hidden-md hidden-xs pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs- pd0 panel-heading">
							<div class="panel-title pd0">시작</div>
		  				</div>
						<div class="prodt prodtStTime">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 hidden-md hidden-xs pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-4 pd0 panel-heading">
							<div class="panel-title pd0">종료</div>
		  				</div>
						<div class="prodt prodtEdTime">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 hidden-md hidden-xs pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-4 pd0 panel-heading">
							<div class="panel-title pd0">가동</div>
		  				</div>
						<div class="prodt prodtOpTime">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 hidden-md hidden-xs pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-4 pd0 panel-heading">
							<div class="panel-title pd0">중단</div>
		  				</div>
						<div class="prodt prodtStopTime">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
				<div class="col-lg-1 hidden-md hidden-xs pd0">
					<div class="col-lg-12 col-xs-12 pd0 panel panel-default">
						<div class="col-lg-12 col-xs-4 pd0 panel-heading">
							<div class="panel-title pd0">횟수</div>
		  				</div>
						<div class="prodt prodtStopCnt">
		  					<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
							<div class="col-lg-12 col-xs-4 pd0 panel-body">
							</div>
		  				</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="text-center">
			<!-- pagenation bar -->
			<nav style="cursor:pointer">
				<ul class="pagination">
				
				<c:if test='${1 < navi.CUR_BLOCK_GROUP_NUM}'>
				<li class='previous'><a aria-label="P"><span aria-hidden="true">&laquo;</span></a></li>
				</c:if>
				<c:forEach var="num" begin="${navi.CUR_BLOCK_ST_PAGE_NUM }" end="${navi.CUR_BLOCK_ED_PAGE_NUM }">
					<c:choose>
					<c:when test="${num eq navi.CUR_PAGE }">
					<li class="active"><a>${num }</a></li>
					</c:when>
				    <c:otherwise>
				    <li><a>${num }</a></li>
				    </c:otherwise>
				    </c:choose>
      			</c:forEach>
				<c:if test='${navi.TOT_BLOCK_GROUP_NUM > navi.CUR_BLOCK_GROUP_NUM}'>
				<li class='next'>
					<a aria-label="N"><span aria-hidden="true">&raquo;</span></a>
				</li>
				</c:if>
				
				</ul>
			</nav>
			<!-- /pagenation bar -->
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
 		MAIN.list.set();
 		LIST.load();
 		
 		var pagenation = {
			PAGE_VIEW_CNT : "${navi.PAGE_VIEW_CNT}",
			CUR_PAGE : "${navi.CUR_PAGE}",
			BLOCK_PAGES : "${navi.BLOCK_PAGES}",
			TOT_PAGE_CNT : "${navi.TOT_PAGE_CNT}",
			TOT_BLOCK_GROUP_NUM : "${navi.TOT_BLOCK_GROUP_NUM}",
			CUR_BLOCK_GROUP_NUM : "${navi.CUR_BLOCK_GROUP_NUM}",
			CUR_BLOCK_ST_PAGE_NUM : "${navi.CUR_BLOCK_ST_PAGE_NUM}",
			CUR_BLOCK_ED_PAGE_NUM : "${navi.CUR_BLOCK_ED_PAGE_NUM}"
 		}
 		
 		var cboItemSet = function(){
 			var cboItemHtml = '';
 			
 			<c:forEach items="${cboItem}" var="item">
 				cboItemHtml += '<li><a href="#" data-value='+ "${item.ITEM_CODE}" + '>' + "${item.ITEM_NAME}" + '</a></li>';
	 		</c:forEach>
	 		
	 		$('.dropdown-menu').html(cboItemHtml);
 		}
 		
 		$(document).on("click",".pagination > li",function(){
 			var pageDataCnt = pagenation.PAGE_VIEW_CNT;
 			var pageNo 		= this.children[0].text;
 			var pageDataSt 	= (pageNo - 1) * pageDataCnt + 1;
 			var pageDataEd 	= pageNo * pageDataCnt;
 			var preOrNext 	= $(this).attr('class');
 			if (preOrNext == 'previous' || preOrNext == 'next'){
 				var pageNumber = (preOrNext == 'previous') ? Number(pagenation.CUR_BLOCK_ST_PAGE_NUM) - 1 : Number(pagenation.CUR_BLOCK_ED_PAGE_NUM) + 1;
 				loadPagination(pageNumber, this);
 			}
 			else
 				pageData(pageDataSt, pageDataEd, this);
 		})
 		
 		$(document).on("click",".dropdown-menu li a",function(){
 				var me = this;
				var cboText = $(me).text();
				var cboValue = $(me).attr("data-value");
				var equipIp = ($(me).parents('.input-group').find('.form-control').attr('id') == 'cboProdtName1') ? '192.168.0.231' : '192.168.0.232'; 
				
				$.ajax({
					url: 's_mes100skrv_novisMergeItem',
					type: 'post',
					data: {
						eqpmnIp  : equipIp,
						itemCode : cboValue,
						itemName : cboText
					},
					success: function(data){
						if(data > 0){
							alert("저장되었습니다.");	
						}
						
						$(me).parents('.input-group').find('.form-control').val(cboText);
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.error(jqXHR, textStatus, errorThrown);
					}
				});
				
				
				
				
				
		});
 		
 		/* <div class="input-group">
       	<input type="text" class="form-control" id="cboProdtName2" aria-label="..." readonly="readonly">
		<div class="input-group-btn">
		  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span></button>
		  <ul class="dropdown-menu dropdown-menu-right" role="menu">
		    <li><a href="#">Action</a></li>
		    <li><a href="#">Another action</a></li>
		    <li><a href="#">Something else here</a></li>
		    <li class="divider"></li>
		    <li><a href="#">Separated link</a></li>
		  </ul>
		</div><!-- /btn-group -->
    </div><!-- /input-group --> */
 		
 		var loadPagination = function(pageNum, object){
 			$.ajax({
				url: 's_mes100skrv_novisSelectPagenation',
				type: 'post',
				data: {pageNumber: pageNum},
				success: function(jsonData){
					var data = jsonData;
					if(data.length > 0){
						
						pagenation.PAGE_VIEW_CNT	 		= data[0].PAGE_VIEW_CNT;
						pagenation.CUR_PAGE 				= data[0].CUR_PAGE;
						pagenation.BLOCK_PAGES				= data[0].BLOCK_PAGES;
						pagenation.TOT_PAGE_CNT 			= data[0].TOT_PAGE_CNT;
						pagenation.TOT_BLOCK_GROUP_NUM 		= data[0].TOT_BLOCK_GROUP_NUM;
						pagenation.CUR_BLOCK_GROUP_NUM 		= data[0].CUR_BLOCK_GROUP_NUM;
						pagenation.CUR_BLOCK_ST_PAGE_NUM 	= data[0].CUR_BLOCK_ST_PAGE_NUM;
						pagenation.CUR_BLOCK_ED_PAGE_NUM 	= data[0].CUR_BLOCK_ED_PAGE_NUM;
					
						pageData((data[0].CUR_PAGE - 1) * data[0].PAGE_VIEW_CNT + 1, data[0].CUR_PAGE * data[0].PAGE_VIEW_CNT, object)
					}
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});
 		}
 		
 		var pageData = function(pageDataSt, pageDataEd, object){
 			var pageSt = pageDataSt;
 			var pageEd = pageDataEd;
 			$.ajax({
				url: 's_mes100skrv_novisSelectPageData',
				type: 'post',
				data: {pageDataS: pageSt, pageDataE: pageEd},
				success: function(jsonData){
					var data = jsonData;
					if(data.length > 0){
						
						var prodtDateHtml = '';
						var equipNameHtml = '';
						var prodtNameHtml = '';
						var prodtQtyHtml = '';
						var equipStTimeHtml = '';
						var equipEdTimeHtml = '';
						var equipOpTimeHtml = '';
						var equipStopTimeHtml = '';
						var equipStopCntHtml = '';
						
						$(data).each(function(i, list){
							prodtDateHtml 		+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.COMM_YMD + '</div>';
							equipNameHtml 		+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.EQUIP_NAME + '</div>';
							prodtNameHtml 		+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.ITEM_NAME  + '</div>';
							prodtQtyHtml 		+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.QTY_PRODT_FORMT + '</div>';
							equipStTimeHtml 	+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.TIME_START_OPER + '</div>';
							equipEdTimeHtml 	+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.TIME_END_OPER + '</div>';
							equipOpTimeHtml 	+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.TIME_OPER + '</div>';
							equipStopTimeHtml 	+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.TIME_STOP + '</div>';
							equipStopCntHtml	+= '<div class="col-lg-12 col-xs-12 pd0 panel-body">' + list.CNT_STOP + '</div>';
						});
						
						$('.prodtDate').html(prodtDateHtml);
						$('.equipName').html(equipNameHtml);
						$('.prodtName').html(prodtNameHtml);
						$('.prodtQty').html(prodtQtyHtml);
						$('.prodtStTime').html(equipStTimeHtml);
						$('.prodtEdTime').html(equipEdTimeHtml);
						$('.prodtOpTime').html(equipOpTimeHtml);
						$('.prodtStopTime').html(equipStopTimeHtml);
						$('.prodtStopCnt').html(equipStopCntHtml);
					}
					
					
						
		 			var preOrNext 	= $(object).attr('class');
		 			if (preOrNext == 'previous' || preOrNext == 'next'){
		 				var naviHtml = '';
		 				
		 				if (pagenation.CUR_BLOCK_GROUP_NUM > 1) 
							naviHtml += "<li class='previous'><a aria-label='P'><span aria-hidden='true'>&laquo;</span></a></li>";
							
						for(var i=pagenation.CUR_BLOCK_ST_PAGE_NUM; i<=pagenation.CUR_BLOCK_ED_PAGE_NUM; i++) {
							if(i == pagenation.CUR_PAGE)
								naviHtml += "<li class='active'><a>" + i + "</a></li>";
							else
								naviHtml += "<li><a>" + i + "</a></li>";
						}
						
						if (pagenation.CUR_BLOCK_GROUP_NUM != pagenation.TOT_BLOCK_GROUP_NUM) 
							naviHtml += "<li class='next'><a aria-label='P'><span aria-hidden='true'>&raquo;</span></a></li>";
							$('.pagination').html(naviHtml);
		 			}
		 			
		 			$(object).parent().find('.active').attr('class', '');
		 			$(object).attr('class', 'active');
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});
 		}
 		
 		cboItemSet();
 		pageData(1 , pagenation.PAGE_VIEW_CNT );
// 		resizeFrame();
// 		$(window).on('resize', function() { 
// 			resizeFrame();
// 		});
	});
</script>


</body>
</html>