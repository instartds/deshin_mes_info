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
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/buttons.bootstrap4.min.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/common.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/dataTables.bootstrap4.min.css"/>" />
	<style>
		.form-font-custom{
			font-size:20px;
			font-weight: normal;
			
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
		
		  height: 25px;
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
		
		.div-vm{
			display: flex; 
			align-items: center;
		}
		
	.col-form-label {
	  padding-top: calc(0.3rem + 0px);
	  padding-bottom: calc(0.3rem + 0px);
	  margin-bottom: 0;
				font-size:20px;
				font-weight: normal;
	  line-height: 1.5; 
 	}
 	
 	.modal-setup-label {
		display: flex; 
		align-items: center;
		flex-direction: row-reverse;
		font-size:14px;
		font-weight: bold;
		padding:2px 6px;
	}
	.modal-setup-value {
		font-size:15px;
		font-weight: bold;
		background-color: #000 !important;
		padding:2px 6px;
		text-align: right;
	}
	.modal-setup-header {
		text-align: center; 
		color:#ffd868; 
		background-color: #000;
		padding:0px;
		margin:0px 0px 0px 0px;
		border: 1px solid #464f5b;
	}
	
	.modal-setup-label2 {
		text-align: right;
		align-items: right;
		font-weight: bold;
	}
	.modal-setup-value2 {
		background-color: #000 !important;
	}
	
	.gutter { 
	
		margin-top:70px; 
	   
	}
	</style>

</head>
<body>
	<header class="header" id="myHeader"> 
		<div class="row mb-3 " >       
			<div class="col-sm-2 col-md-2 col-lg-2">
			
				<input type="text" class="form-control" id="prodt_start_time2" name="prodt_start_time2" style="height:60px; text-align:center; border: 0px; font-size:30px; color: #fff; background-color: #555;" readonly>

			
			<!-- 오른쪽 상단에 상태 표시시 사용
				<div class="row" >   
					<input type="text" onclick="openFullScreenMode()" class="form-control" id="prodt_start_date2" name="prodt_start_date2" style="height:30px; text-align:center; border: 0px; font-size:25px; color: #fff; background-color: #555;" readonly>
					<input type="text" class="form-control" id="prodt_start_time2" name="prodt_start_time2" style="height:30px; text-align:center; border: 0px; font-size:25px; color: #fff; background-color: #555;" readonly>
				</div>
				-->
				

			</div>
			<div class="col-sm-2 col-md-2 col-lg-2 text-center">
				<button type="button" class="btn btn-xs btn-info btn-block" id="refresh" style ="height:60px; font-size:30px;"><i class="mdi mdi-refresh"></i>새로고침</button>
			</div>
			<div class="col-sm-2 col-md-2 col-lg-2 text-center">
				<select class="form-control" id="equip_code" style ="height:60px; color: #fff;  background-color: #555; font-size:25px;" required="required" readonly onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
		        </select>
			</div>
			<div class="col-sm-2 col-md-2 col-lg-2 text-center">
				<select class="form-control" id="inspec_prsn" style ="height:60px; color: #fff;  background-color: #555; font-size:25px;" required="required" readonly onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
		        </select>
			</div>
			<div class="col-sm-2 col-md-2 col-lg-2 text-center">
		        <button type="button" class="btn btn-xs btn-info btn-block" id="menuBtn" style ="height:60px; font-size:30px;"><i class="dripicons-menu"></i>메뉴</button>
			</div>
			<div class="col-sm-2 col-md-2 col-lg-2 warning-div">
				<input type="text" onclick="openFullScreenMode()" class="form-control" id="prodt_start_date2" name="prodt_start_date2" style="height:60px; text-align:center; border: 0px; font-size:30px; color: #fff; background-color: #555;" readonly>
				<!-- 오른쪽 상단에 상태 표시시 사용
	        	<input type="text" class="form-control warning-div" id="warning_status" name="warning_status" style="height:60px; text-align:center; border: 0px; font-size:30px; font-weight: bold; color: #fff; background-color: #555;" readonly>
	        	-->
			</div>
			
		</div>
	</header>
	<main>

	
<!--웹소켓 콘솔창 제거(기본) start-->	

		<div class="container-fluid  mt-2"style="overflow-x: auto; overflow-y: hidden; height:63vh;" >
			<div class="row flex-nowrap row-dynamic4" style= "height:100%; background-color:#444;">    
			</div>
		</div>

<!--웹소켓 콘솔창 제거(기본) end-->			
<!--웹소켓 콘솔창 볼때 start-->
<!--
	<div class="row">
		<div class="container-fluid col-9  mt-2"style="overflow-x: auto; overflow-y: hidden; height:63vh;" >
			<div class="container">
				<div class="row flex-nowrap row-dynamic4" style= "height:100%; background-color:#444;">    
				</div>
			</div>
		</div>
		
		
		<div class="container-fluid col-3  mt-2"style="overflow-x: auto; height:63vh;" >
			<div class="container">
				
					<input type="button" value="Connect" onclick="javascript:connect()">
					<input type="button" value="Disconnect" onclick="javascript:disconnect()">
					<div>
					    <input type="text" autocomplete="one-time-code" placeholder="type and press enter to chat" id="chat" />
	
					    <div id="console-container">
					        <div id="console"/>
					    </div>
					</div>
				
			</div>
		</div>
	</div>
-->
<!--웹소켓 콘솔창 볼때 end-->		
		
		<!--  원료 투입량 저장 모달 -->
		<div id="item-mtrl-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="item-mtrl-modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header modal-colored-header bg-info">
                        <h4 class="modal-title" id="item-mtrl-modalLabel">원료 투입</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    </div>
                    <div class="modal-body md-mtrl">
                        <div class="row">
                        	
	                        <label for ="md_wkord_num" class="col-4 col-form-label" id= "md_wkord_num_label" style="color: #fff; text-align:right;">작지번호</label>
							<div class="col-8 div-vm">
								<input type="text" class="form-control" id="md_wkord_num" name="md_wkord_num" value="" style="font-size:20px; border: 0px; color: #fff; background-color: #000;" readonly required="required">
	
							</div>
	                        <label for ="md_item_mtrl" class="col-4 col-form-label" id= "md_item_mtrl_label" style="color: #fff;text-align:right;">원료</label>
							<div class="col-8 div-vm">
								<input type="text" class="form-control" id="md_item_mtrl" name="md_item_mtrl" value="" style="font-size:20px; border: 0px; color: #fff; background-color: #000;" readonly required="required">
	
							</div>
	                        <label for ="md_item_mtrl_q_origin" class="col-4 col-form-label" id= "md_item_mtrl_q_label" style="color: #fff;text-align:right;">기투입량</label>
							<div class="col-8 div-vm">
								<input type="text" class="form-control" id="md_item_mtrl_q_origin" name="md_item_mtrl_q_origin" value="" style="font-size:20px;  border: 0px; color: #fff; background-color: #000;" readonly>
	
							</div>
	                        <label for ="md_item_mtrl_q" class="col-4 col-form-label" id= "md_item_mtrl_q_label" style="color: #fff;font-size:30px; text-align:right;">투입량</label>
							<div class="col-6 div-vm pr-0">
								<input type="text" autocomplete="off" class="form-control" id="md_item_mtrl_q" name="md_item_mtrl_q" value="" style="height:50px; font-size:25px;  border: 0px; color: #000; background-color: #fff;" required="required">
	
							</div>
							<div class="col-2 div-vm pl-0"">
								<input type="text" class="form-control" id="md_unit" name="md_unit" value="Kg" style="height:50px; font-size:20px;  border: 0px; color: #fff; background-color: #000;" readonly>
								
							</div>
						</div>
                    </div>
                    <div class="modal-footer">
                    	<div class="col-12  mt-2 text-center">
	                        <button type="button" class="btn btn-xs btn-info" id ="mtrl_q_save_btn" style ="display:inline-block; width:30%; height:50px; font-size:25px;">저장</button>
	                        <button type="button" class="btn btn-light" data-dismiss="modal" style ="display:inline-block; width:30%; height:50px; font-size:25px;">취소</button>
						</div>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>
        
        
        <!--  설비setup값 저장 모달 -->
		<div id="setup-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="setup-modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-full-width">
                <div class="modal-content">
                    <div class="modal-header modal-colored-header bg-info">
                        <h2 class="modal-title" id="setup-modalLabel" >사출기 조건값 셋업</h2>
                        <div class="col-8 text-right">
	                        <button type="button" class="btn btn-xs btn-light" id ="setup_save_btn" style ="display:inline-block; width:15%; height:50px; font-size:25px;">자동</button>
	                        <button type="button" class="btn btn-info" data-dismiss="modal" style ="display:inline-block; width:15%; height:50px; font-size:25px;">취소</button>
						</div>
                      <!--   <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button> -->
                    </div>
                    <div class="modal-body pt-0">
                    
                       	<div class="row">
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>사출정보</span></h3>
                       		</div>
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>사출보압</span></h3>
                       		</div>
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>계량정보</span></h3>
                       		</div>
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>사출온도</span></h3>
                       		</div>
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>사출대정보</span></h3>
                       		</div>
                       		<div class="col-2 modal-setup-header">
                       			<h3><span>이젝터정보</span></h3>
                       		</div>
                       	</div>
                       	<div class="row">
	                        	
                       		<!-- 사출정보 -->
	                        <div class="col-2">
	                        	<div class="row">
			                        <label for ="md_setup_core_code" class="col-6 col-form-label modal-setup-label" id= "md_setup_core_code_label">금형</label>
									
										<input type="text" class="col-6 form-control modal-setup-value" id="md_setup_core_code" name="md_setup_core_code" value="" readonly>
									
									<label for ="md_setup_set_inject_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_speed1_label">사출1차 속도</label>
							
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_speed1" name="md_setup_set_inject_speed1" value="" readonly>
						
									
									<label for ="md_setup_set_inject_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_speed2_label">사출2차 속도</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_speed2" name="md_setup_set_inject_speed2" value="" readonly>
							
									
									<label for ="md_setup_set_inject_speed3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_speed3_label">사출3차 속도</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_speed3" name="md_setup_set_inject_speed3" value="" readonly>
							
									
									<label for ="md_setup_set_inject_speed4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_speed4_label" >사출4차 속도</label>
							
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_speed4" name="md_setup_set_inject_speed4" value="" readonly>
						
									
									<label for ="md_setup_set_inject_speed5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_speed5_label" >사출5차 속도</label>
							
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_speed5" name="md_setup_set_inject_speed5" value="" readonly>
								
									
									<label for ="md_setup_set_inject_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_press1_label" >사출1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_press1" name="md_setup_set_inject_press1" value="" readonly>
								
									
									<label for ="md_setup_set_inject_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_press2_label" >사출2차 압력</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_press2" name="md_setup_set_inject_press2" value="" readonly>
								
									
									<label for ="md_setup_set_inject_press3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_press3_label" >사출3차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_press3" name="md_setup_set_inject_press3" value="" readonly>
									
									
									<label for ="md_setup_set_inject_press4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_press4_label" >사출4차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_press4" name="md_setup_set_inject_press4" value="" readonly>
									
									
									<label for ="md_setup_set_inject_press5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_press5_label" >사출5차 압력</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_press5" name="md_setup_set_inject_press5" value="" readonly>
								
									
									<label for ="md_setup_set_inject_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_point1_label" >사출1차 위치</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_point1" name="md_setup_set_inject_point1" value="" readonly>
								
									
									<label for ="md_setup_set_inject_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_point2_label" >사출2차 위치</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_point2" name="md_setup_set_inject_point2" value="" readonly>
								
									
									<label for ="md_setup_set_inject_point3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_point3_label" >사출3차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_point3" name="md_setup_set_inject_point3" value="" readonly>
							
									
									<label for ="md_setup_set_inject_point4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_point4_label" >사출4차 위치</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_point4" name="md_setup_set_inject_point4" value="" readonly>
								
									
									<label for ="md_setup_set_inject_point5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_point5_label" >사출5차 위치</label>
							
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_point5" name="md_setup_set_inject_point5" value="" readonly>
							
									
									<label for ="md_setup_set_inject_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_inject_time_label" >사출시간</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_inject_time" name="md_setup_set_inject_time" value="" readonly>
							
								</div>
								
							</div>
							
                       		<!-- 사출보압 -->
							<div class="col-2">
	                        	<div class="row">
			                        <label for ="md_setup_set_cusion_hi" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cusion_hi_label" >쿠션위치HI</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cusion_hi" name="md_setup_set_cusion_hi" value="" readonly>
									
									
			                        <label for ="md_setup_set_cusion_lo" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cusion_lo_label" >쿠션위치LO</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cusion_lo" name="md_setup_set_cusion_lo" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_press1_label" >보압1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_press1" name="md_setup_set_holding_press1" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_press2_label" >보압2차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_press2" name="md_setup_set_holding_press2" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_press3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_press3_label" >보압3차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_press3" name="md_setup_set_holding_press3" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_press4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_press4_label" >보압4차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_press4" name="md_setup_set_holding_press4" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_press5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_press5_label" >보압5차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_press5" name="md_setup_set_holding_press5" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_speed1_label" >보압1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_speed1" name="md_setup_set_holding_speed1" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_speed2_label" >보압2차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_speed2" name="md_setup_set_holding_speed2" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_speed3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_speed3_label" >보압3차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_speed3" name="md_setup_set_holding_speed3" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_speed4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_speed4_label" >보압4차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_speed4" name="md_setup_set_holding_speed4" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_speed5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_speed5_label" >보압5차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_speed5" name="md_setup_set_holding_speed5" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_time1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_time1_label" >보압1차 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_time1" name="md_setup_set_holding_time1" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_time2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_time2_label" >보압2차 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_time2" name="md_setup_set_holding_time2" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_time3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_time3_label" >보압3차 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_time3" name="md_setup_set_holding_time3" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_time4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_time4_label" >보압4차 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_time4" name="md_setup_set_holding_time4" value="" readonly>
									
									
			                        <label for ="md_setup_set_holding_time5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_holding_time5_label" >보압5차 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_holding_time5" name="md_setup_set_holding_time5" value="" readonly>
									
								</div>
							</div>
							 
                       		<!-- 계량정보 -->
							<div class="col-2">
	                        	<div class="row">
								
			                        <label for ="md_setup_set_suckback_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_suckback_point1_label" >석백1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_suckback_point1" name="md_setup_set_suckback_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_suckback_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_suckback_point2_label" >석백2차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_suckback_point2" name="md_setup_set_suckback_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_suckback_press1" class="col-9 col-form-label modal-setup-label" id= "md_setup_set_suckback_press1_label" >석백1차 압력(계량전)</label>
									
										<input type="text" class="col-3 form-control modal-setup-value" id="md_setup_set_suckback_press1" name="md_setup_set_suckback_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_suckback_press2" class="col-9 col-form-label modal-setup-label" id= "md_setup_set_suckback_press2_label" >석백2차 압력(계량후)</label>
									
										<input type="text" class="col-3 form-control modal-setup-value" id="md_setup_set_suckback_press2" name="md_setup_set_suckback_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_suckback_speed1" class="col-9 col-form-label modal-setup-label" id= "md_setup_set_suckback_speed1_label" >석백1차 속도(계량전)</label>
									
										<input type="text" class="col-3 form-control modal-setup-value" id="md_setup_set_suckback_speed1" name="md_setup_set_suckback_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_suckback_speed2" class="col-9 col-form-label modal-setup-label" id= "md_setup_set_suckback_speed2_label" >석백2차 속도(계량후)</label>
									
										<input type="text" class="col-3 form-control modal-setup-value" id="md_setup_set_suckback_speed2" name="md_setup_set_suckback_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_point1_label" >계량1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_point1" name="md_setup_set_feed_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_point2_label" >계량2차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_point2" name="md_setup_set_feed_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_point3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_point3_label" >계량3차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_point3" name="md_setup_set_feed_point3" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_press1_label" >계량1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_press1" name="md_setup_set_feed_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_press2_label" >계량2차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_press2" name="md_setup_set_feed_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_press3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_press3_label" >계량3차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_press3" name="md_setup_set_feed_press3" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_speed1_label" >계량1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_speed1" name="md_setup_set_feed_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_speed2_label" >계량2차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_speed2" name="md_setup_set_feed_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_speed3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_speed3_label" >계량3차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_speed3" name="md_setup_set_feed_speed3" value="" readonly>
									
								
			                        <label for ="md_setup_set_back_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_back_press1_label" >배압1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_back_press1" name="md_setup_set_back_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_back_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_back_press2_label" >배압2차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_back_press2" name="md_setup_set_back_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_back_press3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_back_press3_label" >배압3차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_back_press3" name="md_setup_set_back_press3" value="" readonly>
									
								</div>
							</div>
							
							<!-- 사출온도 -->
							<div class="col-2">
	                        	<div class="row">
			                        <label for ="md_setup_set_cool_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cool_time_label" >냉각시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cool_time" name="md_setup_set_cool_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_cycle_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cycle_time_label" >공정시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cycle_time" name="md_setup_set_cycle_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_feed_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_feed_time_label" >계량시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_feed_time" name="md_setup_set_feed_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_switchover_point" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_switchover_point_label" >V=P 보압전환위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_switchover_point" name="md_setup_set_switchover_point" value="" readonly>
									
								
			                        <label for ="md_setup_set_switchover_press" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_switchover_press_label" >V=P 보압전환압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_switchover_press" name="md_setup_set_switchover_press" value="" readonly>
									
								
			                        <label for ="md_setup_set_switchover_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_switchover_time_label" >V=P 보압전환시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_switchover_time" name="md_setup_set_switchover_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_nozzle_t1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_nozzle_t1_label" >노즐1온도(롱)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_nozzle_t1" name="md_setup_set_nozzle_t1" value="" readonly>
									
								
			                        <label for ="md_setup_set_nozzle_t2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_nozzle_t2_label" >노즐2온도(단)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_nozzle_t2" name="md_setup_set_nozzle_t2" value="" readonly>
									
								
			                        <label for ="md_setup_set_cylinder_t1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cylinder_t1_label" >실린더1 온도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cylinder_t1" name="md_setup_set_cylinder_t1" value="" readonly>
									
								
			                        <label for ="md_setup_set_cylinder_t2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cylinder_t2_label" >실린더2 온도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cylinder_t2" name="md_setup_set_cylinder_t2" value="" readonly>
									
								
			                        <label for ="md_setup_set_cylinder_t3" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cylinder_t3_label" >실린더3 온도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cylinder_t3" name="md_setup_set_cylinder_t3" value="" readonly>
									
								
			                        <label for ="md_setup_set_cylinder_t4" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cylinder_t4_label" >실린더4 온도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cylinder_t4" name="md_setup_set_cylinder_t4" value="" readonly>
									
								
			                        <label for ="md_setup_set_cylinder_t5" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_cylinder_t5_label" >실린더5 온도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_cylinder_t5" name="md_setup_set_cylinder_t5" value="" readonly>
									
								</div>
							</div>
							
							<!-- 사출대정보 -->
							<div class="col-2">
	                        	<div class="row">
			                        <label for ="md_setup_set_body_back_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_point1_label" >후진1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_point1" name="md_setup_set_body_back_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_point2_label" >후진2차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_point2" name="md_setup_set_body_back_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_press1_label" >후진1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_press1" name="md_setup_set_body_back_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_press2_label" >후진2차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_press2" name="md_setup_set_body_back_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_speed1_label" >후진1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_speed1" name="md_setup_set_body_back_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_speed2_label" >후진2차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_speed2" name="md_setup_set_body_back_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_back_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_back_time_label" >후진 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_back_time" name="md_setup_set_body_back_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_point1_label" >전진1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_point1" name="md_setup_set_body_forw_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_point2_label" >전진2차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_point2" name="md_setup_set_body_forw_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_press1_label" >전진1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_press1" name="md_setup_set_body_forw_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_press2_label" >전진2차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_press2" name="md_setup_set_body_forw_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_speed1_label" >전진1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_speed1" name="md_setup_set_body_forw_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_speed2_label" >전진2차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_speed2" name="md_setup_set_body_forw_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_body_forw_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_body_forw_time_label" >전진 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_body_forw_time" name="md_setup_set_body_forw_time" value="" readonly>
									
								</div>
							</div>
							
							<!-- 이젝터정보 -->
							<div class="col-2">
	                        	<div class="row">
							
			                        <label for ="md_setup_set_ejt_back_dtime" class="col-9 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_dtime_label" >후진 지연시간(완료)</label>
									
										<input type="text" class="col-3 form-control modal-setup-value" id="md_setup_set_ejt_back_dtime" name="md_setup_set_ejt_back_dtime" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_point1_label" >후진1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_point1" name="md_setup_set_ejt_back_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_point2_label" >후진2차 위치(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_point2" name="md_setup_set_ejt_back_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_press1_label" >후진1차 압력</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_press1" name="md_setup_set_ejt_back_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_press2_label" >후진2차 압력(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_press2" name="md_setup_set_ejt_back_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_speed1_label" >후진1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_speed1" name="md_setup_set_ejt_back_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_speed2_label" >후진2차 속도(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_speed2" name="md_setup_set_ejt_back_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_back_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_back_time_label" >후진 시간(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_back_time" name="md_setup_set_ejt_back_time" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_dtime" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_dtime_label" >전진 지연시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_dtime" name="md_setup_set_ejt_forw_dtime" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_point1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_point1_label" >전진1차 위치</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_point1" name="md_setup_set_ejt_forw_point1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_point2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_point2_label" >전진2차 위치(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_point2" name="md_setup_set_ejt_forw_point2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_press1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_press1_label" >전진1차 압력</label>
								
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_press1" name="md_setup_set_ejt_forw_press1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_press2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_press2_label" >전진2차 압력(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_press2" name="md_setup_set_ejt_forw_press2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_speed1" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_speed1_label" >전진1차 속도</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_speed1" name="md_setup_set_ejt_forw_speed1" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_speed2" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_speed2_label" >전진2차 속도(완료)</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_speed2" name="md_setup_set_ejt_forw_speed2" value="" readonly>
									
								
			                        <label for ="md_setup_set_ejt_forw_time" class="col-8 col-form-label modal-setup-label" id= "md_setup_set_ejt_forw_time_label" >전진 시간</label>
									
										<input type="text" class="col-4 form-control modal-setup-value" id="md_setup_set_ejt_forw_time" name="md_setup_set_ejt_forw_time" value="" readonly>
									
								</div>
							</div>
						</div>
                    </div>
         <!--            <div class="modal-footer">
                    	<div class="col-12  mt-2 text-center">
	                        <button type="button" class="btn btn-xs btn-info" id ="setup_save_btn" style ="display:inline-block; width:30%; height:50px; font-size:25px;">저장</button>
	                        <button type="button" class="btn btn-light" data-dismiss="modal" style ="display:inline-block; width:30%; height:50px; font-size:25px;">취소</button>
						</div>
                    </div> -->
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>
        
        <!--  설비setup값 저장 패스워드 모달 -->
		<div id="setup-pw-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="setup-pw-modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header modal-colored-header bg-info">
                        <h4 class="modal-title" id="setup-pw-modalLabel">패스워드 입력</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    </div>
                    <div class="modal-body md-pw" style="background-color: #3d4248;">
                        <div class="row">
                        	
	                        <label for ="md_pw_equip_code" class="col-4 col-form-label" id= "md_pw_equip_code_label" style="color: #fff; text-align:right;">사출기</label>
							<div class="col-8 div-vm">
								<input type="text" class="form-control" id="md_pw_equip_code" name="md_pw_equip_code" value="" style="font-size:20px; border: 0px; color: #fff; background-color: #000;" readonly required="required">
	
							</div>
	                        <label for ="md_pw_core_code" class="col-4 col-form-label" id= "md_pw_core_code_label" style="color: #fff;text-align:right;">금형</label>
							<div class="col-8 div-vm">
								<input type="text" class="form-control" id="md_pw_core_code" name="md_pw_core_code" value="" style="font-size:20px; border: 0px; color: #fff; background-color: #000;" readonly required="required">
	
							</div>
	                        <label for ="md_pw_password" class="col-4 col-form-label" id= "md_pw_password_label" style="color: #fff;font-size:30px; text-align:right;">비밀번호</label>
							<div class="col-8 div-vm">
								<input type="password" autocomplete="off" class="form-control" id="md_pw_password" name="md_pw_password" value="" style="height:50px; font-size:25px;  border: 0px; color: #000; background-color: #fff;" required="required">
	
							</div>
						</div>
                    </div>
                    <div class="modal-footer" style="background-color: #3d4248;">
                    	<div class="col-12  mt-2 text-center">
	                        <button type="button" class="btn btn-xs btn-info" id ="md_pw_save_btn" style ="display:inline-block; width:30%; height:50px; font-size:25px;">저장</button>
	                        <button type="button" class="btn btn-light" data-dismiss="modal" style ="display:inline-block; width:30%; height:50px; font-size:25px;">취소</button>
						</div>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>
        
        <!--  자동제어 모달 -->
		<div id="auto-setup-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="setup-modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-full-width">
                <div class="modal-content">
                    <div class="modal-header modal-colored-header bg-info">
                        <h2 class="modal-title" id="setup-modalLabel" >자동제어</h2>
                        <div class="col-8 text-right">
	                        <!--<button type="button" class="btn btn-xs btn-light" id ="setup_save_btn" style ="display:inline-block; width:15%; height:50px; font-size:25px;">자동</button> -->
	                        <button type="button" class="btn btn-info" data-dismiss="modal" style ="display:inline-block; width:15%; height:50px; font-size:25px;">취소</button>
						</div>
                      <!--   <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button> -->
                    </div>
                    <div class="modal-body pt-1 pb-1">
                    
                       	<div class="row">
	                        	
							<div class="col-8">
	                        	<div class="row gutter">
	                        	
	                        		<div class="col-2 text-center" style ="display: flex; align-items: center; justify-content: center;">
	                        			<p class="text-white text-center font-weight-bold" style ="font-size:50px;"> 수동 </p>
	                        		</div>
	                        		<!--
	                        		<div class="col-5 text-center">
										<button type="button" class="btn btn-xs btn-primary btn-rounded btn-block" id ="t1" style ="display:inline-block; width:70%; height:80%; font-size:40px;">호출</button>
									</div>
									-->
									<div class="col-5 text-center">
										<button type="button" class="btn btn-xs btn-primary btn-rounded btn-block" id ="t2" style ="display:inline-block; width:70%; height:80%; font-size:40px;">적용</button>
									</div>
									
									
								</div>
								
	                        	<div class="row gutter">
								
	                        		<div class="col-2">
	                        			<p class="text-white text-center font-weight-bold" style ="font-size:50px;"> 자동 </h1>
	                        		</div>
	                        		<div class="col-5 text-center">
										<button type="button" class="btn btn-xs btn-success btn-rounded btn-block" id ="t3" style ="display:inline-block; width:70%; height:80%; font-size:40px;">ON</button>
									</div>
									<div class="col-5 text-center">
										<button type="button" class="btn btn-xs btn-danger btn-rounded btn-block" id ="t4" style ="display:inline-block; width:70%; height:80%; font-size:40px;">OFF</button>
									</div>
								
								</div>
	                        </div>	

							<div class="col-4 text-center" style ="background-color:#3d4248;">
	                        	<div class="row text-center" >
			                        <label for ="md_auto_setup_wkord_num" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_wkord_num_label" >작지번호</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_wkord_num" name="md_auto_setup_wkord_num" value="" readonly>
									
			                        <label for ="md_auto_setup_equip_code" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_equip_code_label" >사출기</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_equip_code" name="md_auto_setup_equip_code" value="" readonly>
									
			                        <label for ="md_auto_setup_core_code" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_core_code_label" >금형번호</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_core_code" name="md_auto_setup_core_code" value="" readonly>
									
									<label for ="md_auto_setup_mold_set_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_mold_set_temp_label" >금형설정온도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_mold_set_temp" name="md_auto_setup_mold_set_temp" value="" readonly>
									
									<label for ="md_auto_setup_nozzle_2_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_nozzle_2_temp_label" >노즐2온도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_nozzle_2_temp" name="md_auto_setup_nozzle_2_temp" value="" readonly>
									
									<label for ="md_auto_setup_cyl_1_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_1_temp_label" >실린더온도1</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_1_temp" name="md_auto_setup_cyl_1_temp" value="" readonly>
									
									<label for ="md_auto_setup_cyl_2_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_2_temp_label" >실린더온도2</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_2_temp" name="md_auto_setup_cyl_2_temp" value="" readonly>
									
									<label for ="md_auto_setup_oil_oper_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_oil_oper_temp_label" >작동유온도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_oil_oper_temp" name="md_auto_setup_oil_oper_temp" value="" readonly>
									
									<label for ="md_auto_setup_sub_chng_press" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_sub_chng_press_label" >보압전환압력</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_sub_chng_press" name="md_auto_setup_sub_chng_press" value="" readonly>
									

									
									
									<!--
			                        <label for ="md_auto_setup_ejc_speed" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_ejc_speed_label" >사출속도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_ejc_speed" name="md_auto_setup_ejc_speed" value="" readonly>
									
			                        <label for ="md_auto_setup_ejc_time" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_ejc_time_label" >사출시간</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_ejc_time" name="md_auto_setup_ejc_time" value="" readonly>
									
									
			                        <label for ="md_auto_setup_cyl_1_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_1_temp_label" >실린더온도1</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_1_temp" name="md_auto_setup_cyl_1_temp" value="" readonly>
									
			                        <label for ="md_auto_setup_cyl_2_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_2_temp_label" >실린더온도2</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_2_temp" name="md_auto_setup_cyl_2_temp" value="" readonly>
										
									<label for ="md_auto_setup_cyl_3_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_3_temp_label" >실린더온도3</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_3_temp" name="md_auto_setup_cyl_3_temp" value="" readonly>
										
									<label for ="md_auto_setup_cyl_4_temp" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_cyl_4_temp_label" >실린더온도4</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_cyl_4_temp" name="md_auto_setup_cyl_4_temp" value="" readonly>
									
									
									<label for ="md_auto_setup_sub_max_press" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_sub_max_press_label" >보압최대압력</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_sub_max_press" name="md_auto_setup_sub_max_press" value="" readonly>
									
									<label for ="md_auto_setup_sub_chng_press" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_sub_chng_press_label" >보압전환압력</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_sub_chng_press" name="md_auto_setup_sub_chng_press" value="" readonly>
									
									<label for ="md_auto_setup_sub_chng_speed" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_sub_chng_speed_label" >보압전환속도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_sub_chng_speed" name="md_auto_setup_sub_chng_speed" value="" readonly>
									
									<label for ="md_auto_setup_sub_move_dist" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_sub_move_dist_label" >보압이동거리</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_sub_move_dist" name="md_auto_setup_sub_move_dist" value="" readonly>
									
									
									<label for ="md_auto_setup_tmp1" class="col-6 col-form-label modal-setup-label2" id= "md_auto_setup_tmp1_label" >금형온도</label>
									<input type="text" class="col-6 form-control modal-setup-value2" id="md_auto_setup_tmp1" name="md_auto_setup_tmp1" value="" readonly>
									
									-->
									
								</div>
							</div>
						</div>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>
        
        
        
	</main>			
	<footer class="footer">
		<div class="row row-dynamic3" style ="padding : 0px 10px 10px 10px;">
		</div>
	</footer>
<!-- 	
	<div id="standard-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="standard-modalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered">
	        <div class="modal-content modal-filled bg-dark">
	            <div class="modal-header">
	                <h4 class="modal-title" id="standard-modalLabel">시작 하시겠습니까?</h4>
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	            </div>
	            <div class="modal-body">
	                ...
	            </div> 
	            <div class="modal-footer">
	                <button type="button" class="btn btn-light" data-dismiss="modal" style ="display:inline-block; height:50px; width:30%; font-size:20px;">취소</button>
	                <button type="button" class="btn btn-outline-light" id = "start_btn" style ="display:inline-block; height:50px; width:30%; font-size:20px;"><i class="uil-caret-right"></i>시작</button>
	            </div>
	        </div>
	    </div>
	</div> -->
	

</body>

<!-- js -->		
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-ui.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>

<!-- DataTable -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/datatables.min.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/dataTables.bootstrap4.min.js" ></script>

	
	<script type="text/javascript" chartset="utf-8">
	
		var CPATH ='<%=request.getContextPath()%>';
		var p_equipCode = '${equipCode}';		//메인화면에서 선택한 호기정보
		var p_equipName = '${equipName}';		//메인화면에서 선택한 호기정보

		var p_inspecPrsn = '${inspecPrsn}';		//메인화면에서 선택한 작업자정보
		var p_inspecPrsnName = '${inspecPrsnName}';		//메인화면에서 선택한 작업자정보
		
		var equipImagePath = '${equipImagePath}';
		var wkordNumLately = "";	//마지막으로 시작된 작업에 대한 작업지시번호 초기화
		

		var docV = document.documentElement;

		// 전체화면 설정

		function openFullScreenMode() {

			/* if (docV.requestFullscreen)

				docV.requestFullscreen();

			else */ if (docV.webkitRequestFullscreen) // Chrome, Safari (webkit)

				docV.webkitRequestFullscreen();

			/* else if (docV.mozRequestFullScreen) // Firefox

				docV.mozRequestFullScreen();

			else if (docV.msRequestFullscreen) // IE or Edge

				docV.msRequestFullscreen();
 */
		}
		var isResponsive = false;
		var isPaging = true;
		var isScrollX = true;
		
$(document).ready(function(){
	$.App.activateDarkMode();
	
	fnMainTableInit();
	fnButtonInit();
	
	//설비명 콤보리스트set
	fnEquipCodeList();
	
	//작업자 콤보리스트set
	fnGetInspecPrsnList();
	
	// 작업지시정보 세팅  (설비정보 메인메뉴에서 가져오는것으로 변경)
	//getWkordInfoList(p_equipCode);
	//불량 코드 불량수량 정보 최초 오픈시 셋팅 필요 
	//아래에서  $("#refresh").trigger("click"); 수행시킴
	
	//설비선택시 작업지시정보 세팅  (설비정보 메인메뉴에서 가져오는것으로 변경)
/* 	$("#equip_code").change(function(){
		
		var equipCode = $("#equip_code").val();
		getWkordInfoList(equipCode);
	}); */
	
	//불량유형 세팅
	getBadInspecCode();

    //새로고침 버튼
	$("#refresh").click(function(){
		var equipCode = $("#equip_code").val();
		getWkordInfoList(equipCode);
	    
	});
    
	$("#menuBtn").click(function () {
		var win = window.open(CPATH+'/z_dsh/s_dsh100ukrv_sh1.do' , "_self", 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');
//pollingKafka.abort();
	});
	
/* 
	$(document).on('click', '#start_btn', function() {

	   	$(".dynamic-btn2").trigger("click");
	})
     */
	
	
    //각 작지데이터 시작 버튼 관련
	$(document).on('click', '.dynamic-btn2', function() {
		var cf = confirm('시작 하시겠습니까?');
		if(cf){

			var indexA = $(this).attr("id").lastIndexOf("_");	// 예 start_btn_01P20190930012 의 _01P20190930012이 시작되는 인덱스 
	
			var _wkordNum = $(this).attr("id").substring(indexA);	//_01P20190930012 , _01P20190930013 ...
			var wkordNum = $(this).attr("id").substring(indexA+1);
	
			//$('.dynamic-div').css("border-style", "none");
			
			//$('.dynamic-div').css("border-style", "solid");
			//$('.dynamic-div').css("border-color", "#fff");
			
			$('.dynamic-div').css("background-color", "#555");
			$('.dynamic-div .form-control').css("background-color", "#555");
			
			var result = true;
			var error = "";
			try{
	
				if (!fnValidation(wkordNum)) return;
				var param = {
						
					'EQUIP_CODE' : $("#equip_code").val(),
					'WKORD_NUM' : $("#wkord_num"+ _wkordNum).val(),
					'CORE_CODE' : $("#core_code"+ _wkordNum).val(),
					
					'PRODT_START_DATE' : $("#prodt_start_date2").val().split(".").join(""),
					'PRODT_START_TIME' : $("#prodt_start_time2").val()
				};
			
				var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/startSave.do";
				var ajaxData = param;
				var ajaxloding = true;
				var ajaxCallback = function (data) {
					if(data == null || data == ''){
						error = "관리자에게 문의하세요.";
	
					//	$('.dynamic-div-'+wkordNum).css("border-style", "solid");
					//	$('.dynamic-div-'+wkordNum).css("border-color", "#fa6767");
	
						$('.dynamic-div-'+wkordNum).css("background-color", "#555");
						$('.dynamic-div-'+wkordNum+' .form-control').css("background-color", "#555");
						//$('#coreInfo').css("background-color", "#fa6767");		//오류 색으로 변경
						//$('#coreCardInfo').css("opacity", "0.5");
						//#fa6767
						
						
					}else{
						//if(data.status == "1"){
						//	AlertsUtil.save("이미 시작 되었습니다.");
						//}else{
						AlertsUtil.save("시작 되었습니다.");	
						//}
					   	$("#refresh").trigger("click");
					   	
			/* 		   	$("#refresh").trigger("click"); 로 대체
						$('.dynamic-div-'+wkordNum).css("background-color", "#727cf5");
						$('.dynamic-div-'+wkordNum+' .form-control').css("background-color", "#727cf5");
	
						$('.bad-inspec-q').val(0);	//불량유형별 각 불량량 초기화 0
						
						getBadInspecQList(wkordNum);	//해당작업지시에 대한 불량코드별 불량수량 합 세팅
						
						wkordNumLately = wkordNum; //마지막으로 시작된 작업에 대한 작업지시번호 세팅
						 */
					}
				}
	
				var returnCode = param;
				var type = 'POST'
			    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 
	
				if(error != ""){
					throw new Error(error);;
				}
			}catch(e){
				AlertsUtil.warning(e.message);
				error = "";
				result = false;
			}finally{
				return result;
			}
		}
	});
	  
	//자동제어 창
    $(document).on('click', '.dynamic-btn3', function() {
		var indexA = $(this).attr("id").lastIndexOf("_");	// 예 start_btn_01P20190930012 의 _01P20190930012이 시작되는 인덱스 
		var _wkordNum = $(this).attr("id").substring(indexA);
		var core_code_val = $("#core_code"+ _wkordNum).val();
		
		var wkord_num_val = $(this).attr("id").substring(indexA+1);
		if(wkordNumLately == wkord_num_val){
			if(core_code_val != ''){
				$("#auto-setup-modal").modal("show");
				var params = {'EQUIP_CODE':p_equipCode,'CORE_CODE':core_code_val};
				
				$("#md_auto_setup_equip_code").val('');
				$("#md_auto_setup_core_code").val('');
				$("#md_auto_setup_wkord_num").val('');
				
				
				$("#md_auto_setup_equip_code").val(p_equipCode);
				$("#md_auto_setup_core_code").val(core_code_val);
				$("#md_auto_setup_wkord_num").val(wkord_num_val);
				
				$("#md_auto_setup_mold_set_temp").val('');
				$("#md_auto_setup_nozzle_2_temp").val('');
				$("#md_auto_setup_cyl_1_temp").val('');
				$("#md_auto_setup_cyl_2_temp").val('');
				$("#md_auto_setup_oil_oper_temp").val('');
				$("#md_auto_setup_sub_chng_press").val('');
	//			searchSetup(params);
			}else{
				AlertsUtil.warning("금형번호 없음");
			}
		}else{
			AlertsUtil.warning("먼저 시작을 해주세요");
		}
    });
	
	
	
    //불량코드버튼 누를시  + , - 관련
	$(document).on('click', '.dynamic-btn1', function() {
		if(wkordNumLately!=""){

			var indexA = $(this).attr("id").lastIndexOf("_");	// 예 minus_3000 의 _3000이 시작되는 인덱스 
			
			var badInspecCode = $(this).attr("id").substring(indexA+1);	//_3000 , _3010 ...
			
			var calGubun = $(this).attr("id").substring(0,indexA);	//plus, minus
			
			var count = $("#bad_inspec_q_"+ badInspecCode).val();
			
			var sumBadQ = $("#bad_inspec_q_"+ wkordNumLately).val();
			
			if(calGubun == "plus"){
	
				badInspecQSave(calGubun,badInspecCode,1,count,sumBadQ);
				
				
			/* 	$("#bad_inspec_q_"+ badInspecCode).val(parseInt(count)+1);	//불량코드별 버튼옆 수량	set
				
				$("#bad_inspec_q_"+ wkordNumLately).val(parseInt(sumBadQ)+1);	//마지막 시간된 작업지시데이터의 불량수량 정보에 set
				
				badInspecQSave(badInspecCode,1);
				 */
				
			}else if(calGubun == "minus"){
				//마이너스시 0 밑으로 더 내려가지 않도록
				//마이너스 저장 못하도록 임시 제외 시킴 //다시 추가 시킴
				if(count > 0){
					badInspecQSave(calGubun,badInspecCode,-1,count,sumBadQ);
				} 
			}
		}
	});
	
   	realTimer();
   	setInterval(realTimer, 500);
   	
   	$("#refresh").trigger("click");
   	
	var setIV1;
	setIV1 = setInterval(refreshTrigger, 600000);	//10분 마다 새로고침 버튼 자동
  
	//금형번호 누를시 모달 창 오픈
	$(document).on('click', '.dynamic-setup', function() {
		
		var core_code_val = $("#"+$(this).attr("id")).val();
		if(core_code_val != ''){
			var indexA = $(this).attr("id").lastIndexOf("_");
			var _wkordNum = $(this).attr("id").substring(indexA);
	

			var material_code = $("#item_mtrl_code"+_wkordNum).val();
		//	$("#md_setup").val('');
			//$("#md_item_mtrl").val('');
			//$("#md_item_mtrl_q_origin").val('');
			//$("#md_item_mtrl_q").val('');
			
		
	//		$("#md_setup").val($("#wkord_num"+ _wkordNum).val());
			//$("#md_item_mtrl").val(item_mtrl_val);
			//$("#md_item_mtrl_q_origin").val($("#"+$(this).attr("id")+"_q_origin").val().toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));

			$("#setup-modal").modal("show");
			
		/* 	setTimeout( function() {
				$("#md_item_mtrl_q").click().focus();
			}, 1000 ); */

			var params = {'EQUIP_CODE':p_equipCode,'CORE_CODE':core_code_val, 'MATERIAL_CODE':material_code};
			
			searchSetup(params);
		}
		
	});
	 
	 
	//원료 버튼 누를시 모달 창 오픈
	$(document).on('click', '.dynamic-mtrl', function() {
		
		var item_mtrl_val = $("#"+$(this).attr("id")).val();
		if(item_mtrl_val != ''){
			var indexA = $(this).attr("id").lastIndexOf("_");
			var _wkordNum = $(this).attr("id").substring(indexA);
	
			var paramList = new Array();

			$("#md_wkord_num").val('');
			$("#md_item_mtrl").val('');
			$("#md_item_mtrl_q_origin").val('');
			$("#md_item_mtrl_q").val('');
			
			//paramList["wkord_num"] = $("#wkord_num"+ _wkordNum).val();
			//paramList["item_mtrl"] =
			$("#md_wkord_num").val($("#wkord_num"+ _wkordNum).val());
			$("#md_item_mtrl").val(item_mtrl_val);
			$("#md_item_mtrl_q_origin").val($("#"+$(this).attr("id")+"_q_origin").val().toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));

			$("#item-mtrl-modal").modal("show");
			
			setTimeout( function() {
				$("#md_item_mtrl_q").click().focus();
			}, 1000 );

		}
	});

	$("#mtrl_q_save_btn").click(function(){

		
		var result = true;
		var error = "";
		try{
			if (!fnValidationMtrlModal()) return;
			if(!$.isNumeric($("#md_item_mtrl_q").val())){
			    throw new Error("투입량에 숫자를 입력하세요.");
			    return;
			}
			var param = {
				'WKORD_NUM' : $("#md_wkord_num").val(),
				'ITEM_MTRL' : $("#md_item_mtrl").val(),
				'ITEM_MTRL_Q' : $("#md_item_mtrl_q").val()
			};
		
			var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/itemMtrlSave.do";
			var ajaxData = param;
			var ajaxloding = true;
			var ajaxCallback = function (data) {
				if(data == null || data == ''){
					error = "관리자에게 문의하세요.";
					
				}else{
					AlertsUtil.save("저장 되었습니다.");	
					$("#item-mtrl-modal").modal("hide");
				   	$("#refresh").trigger("click");
				   	
				}
			}

			var returnCode = param;
			var type = 'POST'
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 

			if(error != ""){
				throw new Error(error);;
			}
		}catch(e){
			AlertsUtil.warning(e.message);
			error = "";
			result = false;
		}finally{
			return result;
		}
		
	});
	
/* $("input:text[numberOnly]").keyup(function(event){
        
        var str;
                        
        if(event.keyCode != 8){
            if (!(event.keyCode >=37 && event.keyCode<=40)) {
                var inputVal = $(this).val();
                
                str = inputVal.replace(/[^-0-9]/gi,'');
                
                if(str.lastIndexOf("-")>0){ //중간에 -가 있다면 replace
                    if(str.indexOf("-")==0){ //음수라면 replace 후 - 붙여준다.
                        str = "-"+str.replace(/[-]/gi,'');
                    }else{
                        str = str.replace(/[-]/gi,'');
                    }
                
                }
                                        
                $(this).val(str);
                
            }                    
        }

    }); */
    
   //사출기 조건값 셋업
	$("#setup_save_btn").click(function(){

		//패스워드 입력창
		$("#setup-pw-modal").modal("show");
		
		$("#md_pw_equip_code").val('');
		$("#md_pw_core_code").val('');
		$("#md_pw_password").val('');
		
		$("#md_pw_equip_code").val(p_equipCode);
		$("#md_pw_core_code").val($("#md_setup_core_code").val());
		
		setTimeout( function() {
			$("#md_pw_password").click().focus();
		}, 1000 );

	}); 
	
	
   //사출기 조건값 셋업 저장 버튼
	$("#md_pw_save_btn").click(function(){
		
		var result = true;
		var error = "";
		try{
			var param = {
				'EQUIP_CODE' : $("#md_pw_equip_code").val(),
				'CORE_CODE' : $("#md_pw_core_code").val(),
				'PASSWORD' : $("#md_pw_password").val()
			};

			var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/setSetup.do";
	//var ajaxUrl = "${pageContext.request.contextPath}/resources/phthon3/test.py";
			var ajaxData = param;
			var ajaxloding = true;
			var ajaxCallback = function (data) {
				
				if(data == 0){
					AlertsUtil.save("저장 되었습니다.");	
					$("#setup-pw-modal").modal("hide");
					$("#setup-modal").modal("hide");
				} else if(data == 77){
					error = "비밀번호를 확인해주세요.";	
				}else if(data == 99){
					error = "사출기 정보를 확인해주세요.";	
				}else{
					error = "관리자에게 문의하세요.";
				}
				
			/*	if(data == null || data == ''){
					error = "관리자에게 문의하세요.";
					
				}else{
					AlertsUtil.save("저장 되었습니다.");	
					$("#setup-modal").modal("hide");
				}*/
			}

			var returnCode = param;
			var type = 'POST'
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 

			if(error != ""){
				throw new Error(error);;
			}
		}catch(e){
			AlertsUtil.warning(e.message);
			error = "";
			result = false;
		}finally{
			return result;
		}
		
	});
	
	//자동제어 창 on /off 버튼
	$("#t3").click(function(){
		$("#t3").attr('disabled', true);		
		$("#t4").attr('disabled', false);
		
		$('#auto_btn_'+$("#md_auto_setup_wkord_num").val()).removeClass("btn-danger").addClass("btn-success");
	})
	
	$("#t4").click(function(){
		$("#t4").attr('disabled', true);
		$("#t3").attr('disabled', false);
		
		$('#auto_btn_'+$("#md_auto_setup_wkord_num").val()).removeClass("btn-success").addClass("btn-danger");
	})
	
	//소켓connect
	connect();

	//페이지 이탈시 소켓 disconnect   
	$(window).on("beforeunload", function(){
		disconnect()
	});
})
//end $(document).ready(function(){

	function refreshTrigger(){
		$("#refresh").trigger("click");
	}
	
	function fnValidation(wkordNum){
		//e.preventDefault();
		//e.stopPropagation();
		var $t, t;
		var result = true;
		var error;
		$(".dynamic-div-"+wkordNum).find("input, select, textarea").each(function(i) {
			$t = jQuery(this);

			if($t.prop("required")) {
				if(!jQuery.trim($t.val())) {
					t = jQuery("label[for='"+$t.attr("id")+"']").text();
					$t.focus();
					//throw new Error( t + " 필수 입력입니다." );
					alert( t + " 을(를) 확인 해주세요." );
					result = false;
				}
			}
		});
		if(!result){
			$('.dynamic-div-'+wkordNumLately).css("background-color", "#727cf5");
			$('.dynamic-div-'+ wkordNumLately +' .form-control').css("background-color", "#727cf5");
		}

		return result;
	}
	
/* 	$("input:text[numberOnly]").on("keyup", function() {
		
		if(!$.isNumeric($(this).val())){
		    $(this).val($(this).val(),"");
		}
	});
  */
	
	
	
	//modal 창 필수 체크
	function fnValidationMtrlModal(){
		var $t, t;
		var result = true;
		var error;
		$(".md-mtrl").find("input, select, textarea").each(function(i) {
			$t = jQuery(this);

			if($t.prop("required")) {
				if(!jQuery.trim($t.val())) {
					t = jQuery("label[for='"+$t.attr("id")+"']").text();
					$t.focus();
					//throw new Error( t + " 필수 입력입니다." );
					alert( t + " 을(를) 확인 해주세요." );
					result = false;
				}
			}
		});

		return result;
	}
	
	//설비정보 세팅	(설비정보 메인메뉴에서 가져오는것으로 변경)
	function fnEquipCodeList(){
		
		$("#equip_code option").remove();
		$("#equip_code").append("<option value='"+ p_equipCode +"'>" + p_equipName + "</option>");	//메인화면에서 선택한 호기정보

/* 		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getEquipCode.do";
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
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type); */
		
		
	}
	
	//작업자정보 세팅	(작업자정보 메인메뉴에서 가져오는것으로 변경)
	function fnGetInspecPrsnList(){
		
		$("#inspec_prsn option").remove();
		$("#inspec_prsn").append("<option value='"+ p_inspecPrsn +"'>" + p_inspecPrsnName + "</option>");	//메인화면에서 선택한 작업자정보

	}
	
	//불량유형 리스트 세팅 
	function getBadInspecCode(){
			var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getBadInspecCode.do";
			var ajaxData 	= {};
			var ajaxloding	= false;
			var returnCode;
			var type = 'GET';
			var ajaxCallback= function (data) {
				returnCode = data;
				for(var i = 0; i < data.length; i++){
					$('.row-dynamic3').append(
	            		'<div class="col-sm-4 col-md-4 col-lg-4">'+
	                		'<div class="row" style ="align-items: center; height:65px; background-color: #555;" >'+
	                			'<div class="col-3">'+
									'<input type="text" class="form-control" id="bad_inspec_name_' + data[i].BAD_INSPEC_CODE + '" name="bad_inspec_name_' + data[i].BAD_INSPEC_CODE + '" value="' + data[i].BAD_INSPEC_NAME + '" style="height:50px; padding:0px; font-size:20px; text-align:right; border: 0px; color: #fff; background-color: #555;" readonly>'+
							    '</div>'+
						    	'<div class="col-3">'+
									'<input type="text" class="form-control	bad-inspec-q" id="bad_inspec_q_' + data[i].BAD_INSPEC_CODE + '" name="bad_inspec_q_' + data[i].BAD_INSPEC_CODE + '" value="0" style="height:50px; padding:0px; font-size:20px; text-align:center; border: 0px; color: #fff; background-color: #555;" readonly>'+
							    '</div>'+
							    '<div class="col-3">'+
	                        		'<button type="button" class="btn btn-xs btn-warning btn-block dynamic-btn1" id="plus_' + data[i].BAD_INSPEC_CODE + '" style ="height:50px; font-size:25px;"><i class="uil-plus"></i></button>'+
	                        	'</div>'+
	                        	'<div class="col-3">'+
	                        		'<button type="button" class="btn btn-xs btn-warning btn-block dynamic-btn1" id="minus_' + data[i].BAD_INSPEC_CODE + '" style ="height:50px; font-size:25px;"><i class="uil-minus"></i></button>'+
	                        	'</div>'+
	                    	'</div>'+
	                    '</div>'
	           		);
				}
			}
			DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
		}
	
	//작지데이터 리스트 세팅
	function getWkordInfoList(equipCode){
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getWkordNum2.do";
		var ajaxData 	= {'EQUIP_CODE' : equipCode};
		var ajaxloding	= false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			$('.row-dynamic4').empty();
			wkordNumLately = "";	//마지막으로 시작된 작업에 대한 작업지시번호 초기화
			$('.bad-inspec-q').val(0);	//불량유형별 각 불량량 초기화 0
			for(var i = 0; i < data.length; i++){

				//원료
				var item_mtrl = "";
					item_mtrl = data[i].ITEM_MTRL;
				if(typeof item_mtrl != "undefined"){
					item_mtrl = item_mtrl.split(",");
					if(typeof item_mtrl[1]=="undefined" ){
						item_mtrl[1] = '';
					}
				}else{
					item_mtrl = [];
					item_mtrl[0] = '';
					item_mtrl[1] = '';
				}
				
				//기투입량
				var item_mtrl_q_origin = "";
					item_mtrl_q_origin = data[i].ITEM_MTRL_Q_ORIGIN;
				if(typeof item_mtrl_q_origin != "undefined"){
					item_mtrl_q_origin = item_mtrl_q_origin.split(",");
					if(typeof item_mtrl_q_origin[1]=="undefined" ){
						item_mtrl_q_origin[1] = '0';
					}
				}else{
					
					item_mtrl_q_origin = [];
				
					item_mtrl_q_origin[0] = '0';
					item_mtrl_q_origin[1] = '0';
				}
				
				$('.row-dynamic4').append(
					'<div class="col-4 dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" style="background-color:#555;color: #fff;  height:100%; margin-right: 10px;">'+ //border-color: #fff; border-style: solid;

            			'<div class="row dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" style ="align-items: center; background-color: #555;" >'+
							'<div class="col-6">'+
								'<input type="text" class="form-control" id="seq_' + data[i].WKORD_NUM + '" name="seq_' + data[i].WKORD_NUM + '" value="' + data[i].SEQ + '" style="text-align:center; height:80px; font-size:80px; border: 0px; color: #ffbc00; background-color: #555;" readonly>'+
							'</div>'+
							'<img class="col-6 dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" src="'+ CPATH+'/z_dsh/dsh100ukrvPhoto/' + data[i].FILE_NAME + '"  width="100%" height="150"  alt="이미지가 없습니다." style="border: 0px; color: #fff; background-color: #555;" >'+
						'</div>'+
						'<form class="form-group row dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" style="background-color:#555;">'+

						
							'<label for ="wkord_num_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">작지번호</label>'+
						
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="wkord_num_' + data[i].WKORD_NUM + '" name="wkord_num_' + data[i].WKORD_NUM + '" value="' + data[i].WKORD_NUM + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
							
					   		'<label for ="core_code_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">금형번호</label>'+
							'<div class="col-5 div-vm">'+
								'<input type="text" class="form-control dynamic-setup" id="core_code_' + data[i].WKORD_NUM + '" name="core_code_' + data[i].WKORD_NUM + '" value="' + data[i].CORE_CODE + '" style="font-size:20px; border: 0px; color: yellow; background-color: #555;" readonly required="required">'+
							'</div>'+

							'<div class="col-2 div-vm">'+
								'<input type="text" class="form-control p-0" id="cavity_q_' + data[i].WKORD_NUM + '" name="cavity_q_' + data[i].WKORD_NUM + '" value="' + data[i].CAVITY_Q + '" style="text-align:right; font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
			 				'<label for ="cavity_q_' + data[i].WKORD_NUM + '" class="col-1 col-form-label"  style="text-align:left; padding-left: 0px;">C</label>'+
			 				
							'<label for ="so_num_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">수주번호</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="so_num_' + data[i].WKORD_NUM + '" name="so_num_' + data[i].WKORD_NUM + '" value="' + data[i].SO_NUM + '" style="font-size:20px; border: 0px; color: #ffbc00; background-color: #555;" readonly >'+
							'</div>'+
					   		'<label for ="item_name_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">부품명</label>'+
							'<div class="col-8 div-vm">'+
								'<textarea class="form-control" rows="2" id="item_name_' + data[i].WKORD_NUM + '" name="item_name_' + data[i].WKORD_NUM + '"  style="overflow:hidden; width:100%; height:45px; font-size:12px; border: 0px; color: #fff; background-color: #555; resize: none;" readonly >' + data[i].ITEM_NAME + '</textarea>'+
							'</div>'+
							
							'<label for ="item_mtrl_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">원료</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control dynamic-mtrl" id="item_mtrl1_' + data[i].WKORD_NUM + '" name="item_mtrl1_' + data[i].WKORD_NUM + '" value="' + item_mtrl[0] + '" style="font-size:20px; border: 0px; color: yellow; background-color: #555;" readonly >'+
								'<input type="text" class="form-control dynamic-mtrl" id="item_mtrl2_' + data[i].WKORD_NUM + '" name="item_mtrl2_' + data[i].WKORD_NUM + '" value="' + item_mtrl[1] + '" style="font-size:20px; border: 0px; color: yellow; background-color: #555;" readonly >'+

								'<input type="text" class="form-control dynamic-mtrl" id="item_mtrl1_' + data[i].WKORD_NUM + '_q_origin" name="item_mtrl_q_origin1_' + data[i].WKORD_NUM + '" value="' + item_mtrl_q_origin[0] + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" hidden="hidden" readonly >'+
								'<input type="text" class="form-control dynamic-mtrl" id="item_mtrl2_' + data[i].WKORD_NUM + '_q_origin" name="item_mtrl_q_origin2_' + data[i].WKORD_NUM + '" value="' + item_mtrl_q_origin[1] + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" hidden="hidden" readonly >'+

								'<input type="text" class="form-control dynamic-mtrl" id="item_mtrl_code_' + data[i].WKORD_NUM + '" name="item_mtrl_code_' + data[i].WKORD_NUM + '" value="' + data[i].MATERIAL_CODE + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" hidden="hidden" readonly >'+
							'</div>'+

							'<label for ="item_color_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">색상</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="item_color_' + data[i].WKORD_NUM + '" name="item_color_' + data[i].WKORD_NUM + '" value="' + data[i].ITEM_COLOR + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly >'+
							'</div>'+
							
							'<label for ="prodt_time_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">작업시간</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="prodt_time_' + data[i].WKORD_NUM + '" name="prodt_time_' + data[i].WKORD_NUM + '" value="' + data[i].PRODT_TIME + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly >'+
							'</div>'+
							
					   		'<label for ="wkord_q_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">작지수량</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="wkord_q_' + data[i].WKORD_NUM + '" name="wkord_q_' + data[i].WKORD_NUM + '" value="' + data[i].WKORD_Q + '" style="font-size:20px; border: 0px; color: #ffbc00; background-color: #555;" readonly>'+
							'</div>'+
							
				 			'<label for ="prodt_q_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">작업수량</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="prodt_q_' + data[i].WKORD_NUM + '" name="prodt_q_' + data[i].WKORD_NUM + '" value="' + data[i].PRODT_Q + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
							 
							'<label for ="bad_inspec_q_' + data[i].WKORD_NUM + '" class="col-4 col-form-label"  style="text-align:right">불량수량</label>'+
							'<div class="col-8 div-vm">'+
								'<input type="text" class="form-control" id="bad_inspec_q_' + data[i].WKORD_NUM + '" name="bad_inspec_q_' + data[i].WKORD_NUM + '" value="' + data[i].BAD_INSPEC_Q_SUM + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
							
							//'<label for ="work_shop_code_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">작업장</label>'+
							'<div class="col-12 div-vm" style="display:none">'+
								'<input type="text" class="form-control" id="work_shop_code_' + data[i].WKORD_NUM + '" name="work_shop_code_' + data[i].WKORD_NUM + '" value="' + data[i].WORK_SHOP_CODE + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
							
						    '<div class="col-8 mt-2">'+
					    	//	'<button type="button" class="btn btn-xs btn-light btn-rounded btn-block dynamic-btn2" hidden="hidden" id="start_btn_' + data[i].WKORD_NUM + '" style ="display:inline-block; height:50px; width:30%; font-size:20px;"><i class="uil-caret-right"></i>시작</button>'+
						    	'<button type="button" class="btn btn-xs btn-dark btn-rounded btn-block dynamic-btn2 float-right" id="start_btn_' + data[i].WKORD_NUM + '" style ="display:inline-block; height:50px; width:50%; font-size:20px;"><i class="uil-caret-right"></i>시작</button>'+
						    	
						    '</div>'+
						    
						    
						    '<div class="col-4 mt-2 text-center">'+
						    	'<button type="button" class="btn btn-xs btn-danger btn-rounded btn-block dynamic-btn3" id="auto_btn_' + data[i].WKORD_NUM + '" style ="display:inline-block; height:50px; width:70%; font-size:12px; font-weight: bold;">자동제어</button>'+
						    	
						    '</div>'+
						    
						    
						'</form>'+
					'</div>'
						
						
						
						
						
					/* '<div class="col-4 dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" style="background-color:#555;color: #fff;  height:100%; margin-right: 10px;">'+ //border-color: #fff; border-style: solid;
						'<img src="'+ CPATH+'/z_dsh/dsh100ukrvPhoto/' + data[i].FILE_NAME + '"  width="100%" height="200"  alt="이미지가 없습니다." style="border: 0px; color: #fff; background-color: #555;" >'+
						'<form class="form-group row dynamic-div dynamic-div-' + data[i].WKORD_NUM + '" style="background-color:#555;">'+
							'<label for ="wkord_num_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right;">작업지시번호</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="wkord_num_' + data[i].WKORD_NUM + '" name="wkord_num_' + data[i].WKORD_NUM + '" value="' + data[i].WKORD_NUM + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
					   		'<label for ="core_code_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">금형번호</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="core_code_' + data[i].WKORD_NUM + '" name="core_code_' + data[i].WKORD_NUM + '" value="' + data[i].CORE_CODE + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly required="required">'+
							'</div>'+
							'<label for ="so_num_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">수주번호</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="so_num_' + data[i].WKORD_NUM + '" name="so_num_' + data[i].WKORD_NUM + '" value="' + data[i].SO_NUM + '" style="font-size:20px; border: 0px; color: #ffbc00; background-color: #555;" readonly >'+
							'</div>'+
					   		'<label for ="item_name_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">부품명</label>'+
							'<div class="col-8">'+
								'<textarea class="form-control" rows="2" id="item_name_' + data[i].WKORD_NUM + '" name="item_name_' + data[i].WKORD_NUM + '"  style="overflow:hidden; width:100%;  font-size:15px; border: 0px; color: #fff; background-color: #555;" readonly >' + data[i].ITEM_NAME + '</textarea>'+
							'</div>'+

							'<label for ="color_mtrl_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">색상/원료</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="color_mtrl_' + data[i].WKORD_NUM + '" name="color_mtrl_' + data[i].WKORD_NUM + '" value="' + data[i].COLOR_MTRL + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly >'+
							'</div>'+
							
							'<label for ="prodt_time_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">작업시간</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="prodt_time_' + data[i].WKORD_NUM + '" name="prodt_time_' + data[i].WKORD_NUM + '" value="' + data[i].PRODT_TIME + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly >'+
							'</div>'+
							
					   		'<label for ="wkord_q_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">작지수량</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="wkord_q_' + data[i].WKORD_NUM + '" name="wkord_q_' + data[i].WKORD_NUM + '" value="' + data[i].WKORD_Q + '" style="font-size:20px; border: 0px; color: #ffbc00; background-color: #555;" readonly>'+
							'</div>'+
							'<label for ="bad_inspec_q_' + data[i].WKORD_NUM + '" class="col-4 col-form-label form-font-custom"  style="text-align:right">불량수량</label>'+
							'<div class="col-8">'+
								'<input type="text" class="form-control" id="bad_inspec_q_' + data[i].WKORD_NUM + '" name="bad_inspec_q_' + data[i].WKORD_NUM + '" value="' + data[i].BAD_INSPEC_Q_SUM + '" style="font-size:20px; border: 0px; color: #fff; background-color: #555;" readonly>'+
							'</div>'+
							
							'<div class="col-4 mt-2">'+
								'<input type="text" class="form-control" id="seq_' + data[i].WKORD_NUM + '" name="seq_' + data[i].WKORD_NUM + '" value="' + data[i].SEQ + '" style="text-align:left; font-size:40px; border: 0px; color: #ffbc00; background-color: #555;" readonly>'+
							'</div>'+
						    '<div class="col-8 mt-2 text-left">'+
						    	'<button type="button" class="btn btn-xs btn-warning btn-rounded btn-block dynamic-btn2" id="start_btn_' + data[i].WKORD_NUM + '" style ="display:inline-block; height:50px; width:50%; font-size:20px;"><i class="uil-caret-right"></i>시작</button>'+
						    '</div>'+
						'</form>'+
					'</div>'
					 */
					
					
					
           		);
				//제일 최근에 작업시작한 데이터
				if(data[i].WKORD_NUM == data[i].WKORD_NUM_LATELY){
					$('.dynamic-div-'+data[i].WKORD_NUM).css("background-color", "#727cf5");
					$('.dynamic-div-'+ data[i].WKORD_NUM +' .form-control').css("background-color", "#727cf5");
					wkordNumLately = data[i].WKORD_NUM;	//마지막으로 시작된 작업에 대한 작업지시번호 세팅
					getBadInspecQList(wkordNumLately);	//해당작업지시에 대한 불량코드별 불량수량 합 세팅
				}
			}
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}
	
	//해당작업지시에 대한 불량코드별 불량수량 합 세팅
	function getBadInspecQList(wkordNum){
		var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getBadInspecQList.do";
		var ajaxData 	= {'WKORD_NUM' : wkordNum};
		var ajaxloding	= false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			$('.bad-inspec-q').val(0);	//불량유형별 각 불량량 초기화 0
			for(var i = 0; i < data.length; i++){
				//해당 작업지시에 대한 불량코드별 불량수량 합 세팅
				$('#bad_inspec_q_'+data[i].BAD_INSPEC_CODE).val(data[i].BAD_INSPEC_Q);
			}
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}
	
	//시작된 해당작업지시에 대한 불량 수량 저장
	function badInspecQSave(calGubun,badInspecCode,badInspecCodeQ,count,sumBadQ){
		var result = true;
		var error = "";
		try{
			var param = {
				'WKORD_NUM' : wkordNumLately,	//마지막시작된 작업지시번호
				'INSPEC_DATE' : $("#prodt_start_date2").val().split(".").join(""),	//검사일자
				'INSPEC_TIME' : $("#prodt_start_time2").val(),	//검사시간
				'BAD_INSPEC_CODE' : badInspecCode,
				'BAD_INSPEC_Q' : badInspecCodeQ,
				'INSPEC_PRSN' : $("#inspec_prsn").val(),
				
				'WORK_SHOP_CODE' : $("#work_shop_code_"+ wkordNumLately).val(),//작업장
				'EQU_CODE' : $("#equip_code").val(),//설비코드
				'MOLD_CODE' : $("#core_code_"+ wkordNumLately).val()   //금형코드
			};
		
			var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/badInspecQSave.do";
			var ajaxData = param;
			var ajaxloding = true;
			var returnCode = param;
			var type = 'POST'
			var ajaxCallback = function (data) {
				if(data == null || data == ''){
					error = "관리자에게 문의하세요.";
				}else{
					if(calGubun == "plus"){
						$("#bad_inspec_q_"+ badInspecCode).val(parseInt(count)+1);	//불량코드별 버튼옆 수량	set
						$("#bad_inspec_q_"+ wkordNumLately).val(parseInt(sumBadQ)+1);	//마지막 시간된 작업지시데이터의 불량수량 정보에 set
					}else if(calGubun == "minus"){
						//마이너스시 0 밑으로 더 내려가지 않도록
						if(count > 0){
							$("#bad_inspec_q_"+ badInspecCode).val(parseInt(count)-1);	//불량코드별 버튼옆 수량	set
							$("#bad_inspec_q_"+ wkordNumLately).val(parseInt(sumBadQ)-1);	//마지막 시간된 작업지시데이터의 불량수량 정보에 set
						}
					}
				}
			}
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type); 
			if(error != ""){
				throw new Error(error);;
			}
		}catch(e){
			AlertsUtil.warning(e.message);
			error = "";
			result = false;
		}finally{
			return result;
		}
	}
	
	function realTimer() {
		const nowDate = new Date();
		const year = nowDate.getFullYear();
		const month= nowDate.getMonth() + 1;
		const date = nowDate.getDate();
		const hour = nowDate.getHours();
		const min = nowDate.getMinutes();
		const sec = nowDate.getSeconds();
		
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
    
    
    
	function fnMainTableInit(){

	    var data = null;
	    $("#tblSMInfo").DataTable({

	   //     l - length changing input control
	   //     f - filtering input
	  //      t - The table!
	   //     i - Table information summary tblSMInfo
	   //     p - pagination control
	   //     r - processing display element
	        dom : "<'row' <'col-lg-5 col-md-6 pb-2 area1'> <'col-lg-4 col-md-6 pb-2 area2'> <'col-lg-3 col-md-12 pb-2 area3 text-right'B'>>"
	                + "<'row'>" + "<'row'<'col-6'l><'col-6'f>>"
	                + "<'row'<'col-12'tr>>" //col-12
	                + "<'row'<'col-sm-6'i><'col-sm-6'p>>",
	        //destroy: true,
			select : false,
			//paging : true,
			paging : false,
			ordering : false,
			info : false,
			filter : false,
			lenghChange : false,
			lengthChange : false,
			order : [],
			stateSave : false,
			pagingType : "full_numbers",
			pageLength : 5,
			lengthMenu : [ 5, 10, 15, 25, 50, 100 ],
			processing : false,
			serverside : false,
			scrollY: "100%",
			scrollX : "100%",//isScrollX,
			//scrollXInner:"250px",
			scrollCollapse: true,
			responsive: isResponsive,
			
	        buttons : [],
	        language : {
	            "emptyTable" : "데이터가 존재하지 않습니다.",
	            "lengthMenu" : "페이지당 _MENU_ 개씩 보기",
	            "info" : "현재 _START_ - _END_ / _TOTAL_건",
	            "infoEmpty" : "데이터가 존재하지 않습니다.",
	            "infoFiltered" : "( _MAX_건의 데이터에서 필터링됨 )",
	            "search" : "찾기: ",
	            "zeroRecords" : "일치하는 데이터가 없습니다.",
	            "loadingRecords" : "로딩중...",
	            "processing" : "잠시만 기다려 주세요...",
	            "paginate" : {
	                "first" : "처음",
	                "next" : "다음",
	                "previous" : "이전",
	                "last" : "마지막"
	            }
	        },
	        createdRow: function(row, data, dataIndex, cells) {
	            //if (dataIndex != 0)  $(row).attr("draggable", "true");
	        },

	        columns: [
	           /*  { title: "품목",				data : "ITEM_NAME"},
	            { title: "규격",			data : "SPEC"}, */
	            

	            { title: "설비",			data : "SENSOR_CODE", width:"5%"},
	            { title: "금형",			data : "ERP_MOLD_CODE", width:"5%"},
	            { title: "사출1차 속도",			data : "SET_INJECT_SPEED1", width:"5%"},
	            { title: "사출2차 속도",			data : "SET_INJECT_SPEED2", width:"5%"},
	            { title: "사출3차 속도",			data : "SET_INJECT_SPEED3", width:"5%"},
	            { title: "사출4차 속도",			data : "SET_INJECT_SPEED4", width:"5%"},
	            { title: "사출5차 속도",			data : "SET_INJECT_SPEED5", width:"5%"},
	            { title: "사출1차 압력",			data : "SET_INJECT_PRESS1", width:"5%"},
	            { title: "사출2차 압력",			data : "SET_INJECT_PRESS2", width:"5%"},
	            { title: "사출3차 압력",			data : "SET_INJECT_PRESS3", width:"5%"},
	            { title: "사출4차 압력",			data : "SET_INJECT_PRESS4", width:"5%"},
	            { title: "사출5차 압력",			data : "SET_INJECT_PRESS5", width:"5%"}
	           /*  { title: "사출1차 위치",			data : "SET_INJECT_POINT1", width:"5%"},
	            { title: "사출2차 위치",			data : "SET_INJECT_POINT2", width:"5%"},
	            { title: "사출3차 위치",			data : "SET_INJECT_POINT3", width:"5%"},
	            { title: "사출4차 위치",			data : "SET_INJECT_POINT4", width:"5%"},
	            { title: "사출5차 위치",			data : "SET_INJECT_POINT5", width:"5%"},
	            { title: "사출시간",			data : "SET_INJECT_TIME", width:"5%"}
	             */
	            
	     //       { title: "설비코드",			data : "SENSOR_CODE", width:"20%"},
	    //        { title: "설비명",			data : "SENSOR_NAME", width:"20%"},
	    //        { title: "코어",				data : "MOLD_CODE", width:"20%"},
	    //        { title: "작동모드",				data : "OP_MODE", width:"10%"},
	    //        { title: "ACT_SHOT_CNT",				data : "ACT_SHOT_CNT", width:"15%"},
	    //        { title: "ACT_CYCLE_TIME",				data : "ACT_CYCLE_TIME", width:"15%"}
			//	{ title: "더보기",		data : "", className : "details-control"}

	        ],
	        columnDefs: [
	 /*            {
	            targets: 0,
	            className: "text-center",
	            orderable: false,
	            width: "60px"
	        },{
	            targets: 1,
	            className: "text-head-center",
	            width: "60px"
	        },
	        */
	        
	        {
	            targets: 0,
	            className: "text-head-center",
	            render : function (data, type, row, meta) {
	    			return "<div class='item-code'>" + data + "<div>";
	    		}
	           // width: "55px"
	        },{
	            targets: 1,
	            className: "text-head-center"
	         //   width: "55px"
	        },{
	            targets: 2,
	            className: "text-head-center"
	         //   width: "55px"
	        },{
	            targets: 3,
	            className: "text-head-center"
	         //   width: "55px"
	        },{
	            targets: 4,
	            className: "text-head-center"
	         //   width: "55px"
	        },{
	            targets: 5,
	            className: "text-head-center"

	        },{
	            targets: 6,
	            className: "text-head-center"

	        },{
	            targets: 7,
	            className: "text-head-center"

	        },{
	            targets: 8,
	            className: "text-head-center"

	        },{
	            targets: 9,
	            className: "text-head-center"

	        },{
	            targets: 10,
	            className: "text-head-center"

	        },{
	            targets: 11,
	            className: "text-head-center"

	        },{
	            targets: 12,
	            className: "text-head-center"

	        },{
	            targets: 13,
	            className: "text-head-center"

	        },{
	            targets: 14,
	            className: "text-head-center"

	        },{
	            targets: 15,
	            className: "text-head-center"

	        }
	        ]
	    });
	}
	function fnMainTableDraw(data){
	    var table = $('#tblSMInfo').DataTable();
	    table.clear();

	    if(!ObjUtil.isEmpty(data)) table.rows.add(data);
	        table.draw();
	}
	function fnButtonInit(){
/* 		var btnFind = "";
		btnFind += "<button type='button' class='btn btn-primary mr-2 btnSearch' id='btnSearch'>";
		btnFind += "<i class='mdi mdi-table-search'></i>";
		btnFind += "<span>&nbsp조 회</span>";
		btnFind += "</button>"; */
		var btnAdd = "";
		btnAdd += "<button type='button' class='btn btn-primary mr-2 btnSearch' id='btnSave'>";
		btnAdd += "<i class='mdi mdi mdi-table-edit'></i>";
		btnAdd += "<span>&nbsp저장</span>";
		btnAdd += "</button>";


		$(".hr").html("<hr class='mt-0'>");
		$(".area3").prepend(btnAdd);


		$("div.dt-buttons.btn-group").removeClass("dt-buttons");
	}
	

	 	$(document).on("click", "#btnSearch", function(){
		
		/* 	var params = {'COMP_CODE':userCompCode,'DIV_CODE':userDivCode};
			params.WKORD_NUM = $("#wkordNum").val(); */
		
		    var ajaxUrl         = "${pageContext.request.contextPath}/z_dsh/getSetup.do";
		    var ajaxData        = {};//params;
		    var ajaxloding  = false;
			var returnCode;
		    var ajaxCallback= function (data) {
		    	if(data.length > 0){
		    		window.Android.callMsg("SUCCESS");
		    	}else{
		    		window.Android.callMsg("data is not found");
		    	}
		    	fnMainTableDraw(data);
				returnCode = data;
		    }
			var type = 'POST';
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type);
		}); 
	 	
	 	$(document).on("click", "#btnSave", function(){
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
		});
	 	
	 	
	 	function searchSetup(params){
	 		var ajaxUrl         = "${pageContext.request.contextPath}/z_dsh/getSetup.do";
		    var ajaxData        = params;
		    var ajaxloding  = false;
			var returnCode;
		    var ajaxCallback= function (data) {
		    	if(data.length > 0){
		    		//window.Android.callMsg("SUCCESS");
		    		//사출정보
		    		$("#md_setup_core_code").val(data[0].ERP_MOLD_CODE);
		    		$("#md_setup_set_inject_speed1").val(data[0].SET_INJECT_SPEED1);
		    		$("#md_setup_set_inject_speed2").val(data[0].SET_INJECT_SPEED2);
		    		$("#md_setup_set_inject_speed3").val(data[0].SET_INJECT_SPEED3);
		    		$("#md_setup_set_inject_speed4").val(data[0].SET_INJECT_SPEED4);
		    		$("#md_setup_set_inject_speed5").val(data[0].SET_INJECT_SPEED5);
		    		$("#md_setup_set_inject_press1").val(data[0].SET_INJECT_PRESS1);
		    		$("#md_setup_set_inject_press2").val(data[0].SET_INJECT_PRESS2);
		    		$("#md_setup_set_inject_press3").val(data[0].SET_INJECT_PRESS3);
		    		$("#md_setup_set_inject_press4").val(data[0].SET_INJECT_PRESS4);
		    		$("#md_setup_set_inject_press5").val(data[0].SET_INJECT_PRESS5);
		    		$("#md_setup_set_inject_point1").val(data[0].SET_INJECT_POINT1);
		    		$("#md_setup_set_inject_point2").val(data[0].SET_INJECT_POINT2);
		    		$("#md_setup_set_inject_point3").val(data[0].SET_INJECT_POINT3);
		    		$("#md_setup_set_inject_point4").val(data[0].SET_INJECT_POINT4);
		    		$("#md_setup_set_inject_point5").val(data[0].SET_INJECT_POINT5);
		    		$("#md_setup_set_inject_time").val(data[0].SET_INJECT_TIME);
		    		
					//사출보압
		    		$("#md_setup_set_cusion_hi").val(data[0].SET_CUSION_HI);
		    		$("#md_setup_set_cusion_lo").val(data[0].SET_CUSION_LO);
		    		$("#md_setup_set_holding_press1").val(data[0].SET_HOLDING_PRESS1);
		    		$("#md_setup_set_holding_press2").val(data[0].SET_HOLDING_PRESS2);
		    		$("#md_setup_set_holding_press3").val(data[0].SET_HOLDING_PRESS3);
		    		$("#md_setup_set_holding_press4").val(data[0].SET_HOLDING_PRESS4);
		    		$("#md_setup_set_holding_press5").val(data[0].SET_HOLDING_PRESS5);
		    		$("#md_setup_set_holding_speed1").val(data[0].SET_HOLDING_SPEED1);
		    		$("#md_setup_set_holding_speed2").val(data[0].SET_HOLDING_SPEED2);
		    		$("#md_setup_set_holding_speed3").val(data[0].SET_HOLDING_SPEED3);
		    		$("#md_setup_set_holding_speed4").val(data[0].SET_HOLDING_SPEED4);
		    		$("#md_setup_set_holding_speed5").val(data[0].SET_HOLDING_SPEED5);
		    		$("#md_setup_set_holding_time1").val(data[0].SET_HOLDING_TIME1);
		    		$("#md_setup_set_holding_time2").val(data[0].SET_HOLDING_TIME2);
		    		$("#md_setup_set_holding_time3").val(data[0].SET_HOLDING_TIME3);
		    		$("#md_setup_set_holding_time4").val(data[0].SET_HOLDING_TIME4);
		    		$("#md_setup_set_holding_time5").val(data[0].SET_HOLDING_TIME5);

					//계량정보
		    		$("#md_setup_set_suckback_point1").val(data[0].SET_SUCKBACK_POINT1);
		    		$("#md_setup_set_suckback_point2").val(data[0].SET_SUCKBACK_POINT2);
		    		$("#md_setup_set_suckback_press1").val(data[0].SET_SUCKBACK_PRESS1);
		    		$("#md_setup_set_suckback_press2").val(data[0].SET_SUCKBACK_PRESS2);
		    		$("#md_setup_set_suckback_speed1").val(data[0].SET_SUCKBACK_SPEED1);
		    		$("#md_setup_set_suckback_speed2").val(data[0].SET_SUCKBACK_SPEED2);
		    		$("#md_setup_set_feed_point1").val(data[0].SET_FEED_POINT1);
		    		$("#md_setup_set_feed_point2").val(data[0].SET_FEED_POINT2);
		    		$("#md_setup_set_feed_point3").val(data[0].SET_FEED_POINT3);
		    		$("#md_setup_set_feed_press1").val(data[0].SET_FEED_PRESS1);
		    		$("#md_setup_set_feed_press2").val(data[0].SET_FEED_PRESS2);
		    		$("#md_setup_set_feed_press3").val(data[0].SET_FEED_PRESS3);
		    		$("#md_setup_set_feed_speed1").val(data[0].SET_FEED_SPEED1);
		    		$("#md_setup_set_feed_speed2").val(data[0].SET_FEED_SPEED2);
		    		$("#md_setup_set_feed_speed3").val(data[0].SET_FEED_SPEED3);
		    		$("#md_setup_set_back_press1").val(data[0].SET_BACK_PRESS1);
		    		$("#md_setup_set_back_press2").val(data[0].SET_BACK_PRESS2);
		    		$("#md_setup_set_back_press3").val(data[0].SET_BACK_PRESS3);
					
					//사출온도
		    		$("#md_setup_set_cool_time").val(data[0].SET_COOL_TIME);
		    		$("#md_setup_set_cycle_time").val(data[0].SET_CYCLE_TIME);
		    		$("#md_setup_set_feed_time").val(data[0].SET_FEED_TIME);
		    		$("#md_setup_set_switchover_point").val(data[0].SET_SWITCHOVER_POINT);
		    		$("#md_setup_set_switchover_press").val(data[0].SET_SWITCHOVER_PRESS);
		    		$("#md_setup_set_switchover_time").val(data[0].SET_SWITCHOVER_TIME);
		    		$("#md_setup_set_nozzle_t1").val(data[0].SET_NOZZLE_T1);
		    		$("#md_setup_set_nozzle_t2").val(data[0].SET_NOZZLE_T2);
		    		$("#md_setup_set_cylinder_t1").val(data[0].SET_CYLINDER_T1);
		    		$("#md_setup_set_cylinder_t2").val(data[0].SET_CYLINDER_T2);
		    		$("#md_setup_set_cylinder_t3").val(data[0].SET_CYLINDER_T3);
		    		$("#md_setup_set_cylinder_t4").val(data[0].SET_CYLINDER_T4);
		    		$("#md_setup_set_cylinder_t5").val(data[0].SET_CYLINDER_T5);
					
					//사출대정보
		    		$("#md_setup_set_body_back_point1").val(data[0].SET_BODY_BACK_POINT1);
		    		$("#md_setup_set_body_back_point2").val(data[0].SET_BODY_BACK_POINT2);
		    		$("#md_setup_set_body_back_press1").val(data[0].SET_BODY_BACK_PRESS1);
		    		$("#md_setup_set_body_back_press2").val(data[0].SET_BODY_BACK_PRESS2);
		    		$("#md_setup_set_body_back_speed1").val(data[0].SET_BODY_BACK_SPEED1);
		    		$("#md_setup_set_body_back_speed2").val(data[0].SET_BODY_BACK_SPEED2);
		    		$("#md_setup_set_body_back_time").val(data[0].SET_BODY_BACK_TIME);
		    		$("#md_setup_set_body_forw_point1").val(data[0].SET_BODY_FORW_POINT1);
		    		$("#md_setup_set_body_forw_point2").val(data[0].SET_BODY_FORW_POINT2);
		    		$("#md_setup_set_body_forw_press1").val(data[0].SET_BODY_FORW_PRESS1);
		    		$("#md_setup_set_body_forw_press2").val(data[0].SET_BODY_FORW_PRESS2);
		    		$("#md_setup_set_body_forw_speed1").val(data[0].SET_BODY_FORW_SPEED1);
		    		$("#md_setup_set_body_forw_speed2").val(data[0].SET_BODY_FORW_SPEED2);
		    		$("#md_setup_set_body_forw_time").val(data[0].SET_BODY_FORW_TIME);
					
					//이젝터정보
		    		$("#md_setup_set_ejt_back_dtime").val(data[0].SET_EJT_BACK_DTIME);
		    		$("#md_setup_set_ejt_back_point1").val(data[0].SET_EJT_BACK_POINT1);
		    		$("#md_setup_set_ejt_back_point2").val(data[0].SET_EJT_BACK_POINT2);
		    		$("#md_setup_set_ejt_back_press1").val(data[0].SET_EJT_BACK_PRESS1);
		    		$("#md_setup_set_ejt_back_press2").val(data[0].SET_EJT_BACK_PRESS2);
		    		$("#md_setup_set_ejt_back_speed1").val(data[0].SET_EJT_BACK_SPEED1);
		    		$("#md_setup_set_ejt_back_speed2").val(data[0].SET_EJT_BACK_SPEED2);
		    		$("#md_setup_set_ejt_back_time").val(data[0].SET_EJT_BACK_TIME);
		    		$("#md_setup_set_ejt_forw_dtime").val(data[0].SET_EJT_FORW_DTIME);
		    		$("#md_setup_set_ejt_forw_point1").val(data[0].SET_EJT_FORW_POINT1);
		    		$("#md_setup_set_ejt_forw_point2").val(data[0].SET_EJT_FORW_POINT2);
		    		$("#md_setup_set_ejt_forw_press1").val(data[0].SET_EJT_FORW_PRESS1);
		    		$("#md_setup_set_ejt_forw_press2").val(data[0].SET_EJT_FORW_PRESS2);
		    		$("#md_setup_set_ejt_forw_speed1").val(data[0].SET_EJT_FORW_SPEED1);
		    		$("#md_setup_set_ejt_forw_speed2").val(data[0].SET_EJT_FORW_SPEED2);
		    		$("#md_setup_set_ejt_forw_time").val(data[0].SET_EJT_FORW_TIME);
		    		
		    	}else{
		    		AlertsUtil.warning("data is not found");
		    		
		    		
		    		$("#md_setup_core_code").val('');
		    		$("#md_setup_set_inject_speed1").val('');
		    		$("#md_setup_set_inject_speed2").val('');
		    		$("#md_setup_set_inject_speed3").val('');
		    		$("#md_setup_set_inject_speed4").val('');
		    		$("#md_setup_set_inject_speed5").val('');
		    		$("#md_setup_set_inject_press1").val('');
		    		$("#md_setup_set_inject_press2").val('');
		    		$("#md_setup_set_inject_press3").val('');
		    		$("#md_setup_set_inject_press4").val('');
		    		$("#md_setup_set_inject_press5").val('');
		    		$("#md_setup_set_inject_point1").val('');
		    		$("#md_setup_set_inject_point2").val('');
		    		$("#md_setup_set_inject_point3").val('');
		    		$("#md_setup_set_inject_point4").val('');
		    		$("#md_setup_set_inject_point5").val('');
		    		$("#md_setup_set_inject_time").val('');
		    		
					//사출보압
		    		$("#md_setup_set_cusion_hi").val('');
		    		$("#md_setup_set_cusion_lo").val('');
		    		$("#md_setup_set_holding_press1").val('');
		    		$("#md_setup_set_holding_press2").val('');
		    		$("#md_setup_set_holding_press3").val('');
		    		$("#md_setup_set_holding_press4").val('');
		    		$("#md_setup_set_holding_press5").val('');
		    		$("#md_setup_set_holding_speed1").val('');
		    		$("#md_setup_set_holding_speed2").val('');
		    		$("#md_setup_set_holding_speed3").val('');
		    		$("#md_setup_set_holding_speed4").val('');
		    		$("#md_setup_set_holding_speed5").val('');
		    		$("#md_setup_set_holding_time1").val('');
		    		$("#md_setup_set_holding_time2").val('');
		    		$("#md_setup_set_holding_time3").val('');
		    		$("#md_setup_set_holding_time4").val('');
		    		$("#md_setup_set_holding_time5").val('');

					//계량정보
		    		$("#md_setup_set_suckback_point1").val('');
		    		$("#md_setup_set_suckback_point2").val('');
		    		$("#md_setup_set_suckback_press1").val('');
		    		$("#md_setup_set_suckback_press2").val('');
		    		$("#md_setup_set_suckback_speed1").val('');
		    		$("#md_setup_set_suckback_speed2").val('');
		    		$("#md_setup_set_feed_point1").val('');
		    		$("#md_setup_set_feed_point2").val('');
		    		$("#md_setup_set_feed_point3").val('');
		    		$("#md_setup_set_feed_press1").val('');
		    		$("#md_setup_set_feed_press2").val('');
		    		$("#md_setup_set_feed_press3").val('');
		    		$("#md_setup_set_feed_speed1").val('');
		    		$("#md_setup_set_feed_speed2").val('');
		    		$("#md_setup_set_feed_speed3").val('');
		    		$("#md_setup_set_back_press1").val('');
		    		$("#md_setup_set_back_press2").val('');
		    		$("#md_setup_set_back_press3").val('');
					
					//사출온도
		    		$("#md_setup_set_cool_time").val('');
		    		$("#md_setup_set_cycle_time").val('');
		    		$("#md_setup_set_feed_time").val('');
		    		$("#md_setup_set_switchover_point").val('');
		    		$("#md_setup_set_switchover_press").val('');
		    		$("#md_setup_set_switchover_time").val('');
		    		$("#md_setup_set_nozzle_t1").val('');
		    		$("#md_setup_set_nozzle_t2").val('');
		    		$("#md_setup_set_cylinder_t1").val('');
		    		$("#md_setup_set_cylinder_t2").val('');
		    		$("#md_setup_set_cylinder_t3").val('');
		    		$("#md_setup_set_cylinder_t4").val('');
		    		$("#md_setup_set_cylinder_t5").val('');
					
					//사출대정보
		    		$("#md_setup_set_body_back_point1").val('');
		    		$("#md_setup_set_body_back_point2").val('');
		    		$("#md_setup_set_body_back_press1").val('');
		    		$("#md_setup_set_body_back_press2").val('');
		    		$("#md_setup_set_body_back_speed1").val('');
		    		$("#md_setup_set_body_back_speed2").val('');
		    		$("#md_setup_set_body_back_time").val('');
		    		$("#md_setup_set_body_forw_point1").val('');
		    		$("#md_setup_set_body_forw_point2").val('');
		    		$("#md_setup_set_body_forw_press1").val('');
		    		$("#md_setup_set_body_forw_press2").val('');
		    		$("#md_setup_set_body_forw_speed1").val('');
		    		$("#md_setup_set_body_forw_speed2").val('');
		    		$("#md_setup_set_body_forw_time").val('');
					
					//이젝터정보
		    		$("#md_setup_set_ejt_back_dtime").val('');
		    		$("#md_setup_set_ejt_back_point1").val('');
		    		$("#md_setup_set_ejt_back_point2").val('');
		    		$("#md_setup_set_ejt_back_press1").val('');
		    		$("#md_setup_set_ejt_back_press2").val('');
		    		$("#md_setup_set_ejt_back_speed1").val('');
		    		$("#md_setup_set_ejt_back_speed2").val('');
		    		$("#md_setup_set_ejt_back_time").val('');
		    		$("#md_setup_set_ejt_forw_dtime").val('');
		    		$("#md_setup_set_ejt_forw_point1").val('');
		    		$("#md_setup_set_ejt_forw_point2").val('');
		    		$("#md_setup_set_ejt_forw_press1").val('');
		    		$("#md_setup_set_ejt_forw_press2").val('');
		    		$("#md_setup_set_ejt_forw_speed1").val('');
		    		$("#md_setup_set_ejt_forw_speed2").val('');
		    		$("#md_setup_set_ejt_forw_time").val('');
		    		
		    	}
		    	//fnMainTableDraw(data);
				returnCode = data;
		    }
			var type = 'POST';
		    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type);
	 	}
/**
 * 웹소켓 클라이언트
 * @type 
 */
	var Wc = {};
	
    Wc.socket = null;

    // connect() 함수 정의
    Wc.connect = (function(host) {
        // 서버에 접속시도
        if ('WebSocket' in window) {
            Wc.socket = new WebSocket(host);
        } else if ('MozWebSocket' in window) {
            Wc.socket = new MozWebSocket(host);
        } else {
//            Console.log('Error: WebSocket is not supported by this browser.');
        	console.log('Error: WebSocket is not supported by this browser.');
            return;
        }

        // 서버로부터 메시지를 받은 경우에 호출되는 콜백함수
        Wc.socket.onmessage = function (message) {
        	
        	var mv = message.data;
        	
        	var value = mv.substring(mv.indexOf(":: ")+3);
        
	        if(IsJsonString(value)){
	            var json = value//'{"ejc":4, "is_normal":0}';
				var obj = JSON.parse(json);
				
				var topicNm = obj.topics_nm;
				var equip = obj.ejc;
				equip = "KJ_M_" + equip.padStart(3, '0');
				
				if(topicNm == 'monitoring-result'){	//카프카 토픽 monitoring-result 알림
					var status = obj.is_normal;
					
					
					if(equip == p_equipCode){
						//정상 0
				        //경고 1
				        //불량 2
						if(status == '1'){
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#ffbc00");
	//						$("#warning_status").val('경고');
	
							AlertsUtil.kioskWarning_1("");
						}else if(status == '2'){
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#fa5c7c");
	//						$("#warning_status").val('불량');
							
							AlertsUtil.kioskWarning_2("");
						}else{
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#0acf97");
	//						$("#warning_status").val('정상');
							
							AlertsUtil.kioskWarning_0("");
						}
					}
				
				}else if(topicNm == 'recommend-result'){	//카프카 토픽 recommend-result 추천파라미터
					
					if(equip == p_equipCode){
						
						if($('#auto-setup-modal').hasClass('show')){	//자동제어창이 오픈 되어있을시
						
							
							//금형온도	md_auto_setup_mold_set_temp
							//노즐 2온도 md_auto_setup_nozzle_2_temp
							//실린더온도 1 md_auto_setup_cyl_1_temp
							//실린더온도 2 md_auto_setup_cyl_2_temp
							//작동유온도 md_auto_setup_oil_oper_temp
							//보압 전환 압력 md_auto_setup_sub_chng_press
							$("#md_auto_setup_mold_set_temp").val(obj.recommend_parameters.mold_set_temp);
							$("#md_auto_setup_nozzle_2_temp").val(obj.recommend_parameters.nozzle_2_temp);
							$("#md_auto_setup_cyl_1_temp").val(obj.recommend_parameters.cyl_1_temp);
							$("#md_auto_setup_cyl_2_temp").val(obj.recommend_parameters.cyl_2_temp);
							$("#md_auto_setup_oil_oper_temp").val(obj.recommend_parameters.oil_oper_temp);
							$("#md_auto_setup_sub_chng_press").val(obj.recommend_parameters.sub_chng_press);
						}
					}
				}
	        }
        };
    });
 	// connect() 함수 정의 끝
 	
 	// 위에서 정의한 connect() 함수를 호출하여 접속을 시도함
    Wc.initialize = function() {
        if (window.location.protocol == 'http:') {
//            Wc.connect('ws://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
            
//            Wc.connect('ws://' + 'erp.shapla.co.kr:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
//            Wc.connect('ws://' + '210.122.45.124:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
        	
//            Wc.connect('ws://' + 'erp.shapla.co.kr' +'/omegaplusshin'+ '/websocket/z_shDash');

//        	Wc.connect('ws://localhost:8080/op125/websocket/z_shDash');
    		
        	//운영
            Wc.connect('ws://' + '210.122.45.123:8086' +'/omegaplusshin'+ '/websocket/z_shDash');
        	
        	
//	            	Wc.connect('ws://localhost:8080/op125/websocket/chat');
        } else {
            Wc.connect('wss://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
        }
    };

    // 위에 정의된 함수(접속시도)를 호출함
    //Wc.initialize();
	function connect() {
		Wc.initialize();
		console.log( "소켓 connect" );
	}
	
	function disconnect(){
		console.log( "소켓 disconnect" );
        Wc.socket.close();
    }


  /*  

    var Wc2 = {};
	
    Wc2.socket = null;

    // connect() 함수 정의
    Wc2.connect = (function(host) {
        // 서버에 접속시도
        if ('WebSocket' in window) {
            Wc2.socket = new WebSocket(host);
        } else if ('MozWebSocket' in window) {
            Wc2.socket = new MozWebSocket(host);
        } else {
//            Console.log('Error: WebSocket is not supported by this browser.');
        	console.log('Error: WebSocket is not supported by this browser.');
            return;
        }

        // 서버로부터 메시지를 받은 경우에 호출되는 콜백함수
        Wc2.socket.onmessage = function (message) {
        	
        	var mv = message.data;
        	
        	var value = mv.substring(mv.indexOf(":: ")+3);
        
	        if(IsJsonString(value)){
	            var json = value//'{"ejc":4, "is_normal":0}';
				var obj = JSON.parse(json);
				var equip = obj.ejc;
				var status = obj.is_normal;
				
				equip = "KJ_M_" + equip.padStart(3, '0');
				
				if(equip == p_equipCode){
					
					$("#P1").val('P1');
					$("#P2").val('P2');
					$("#P3").val('P3');
					$("#P4").val('P4');
					$("#P5").val('P5');
					$("#P6").val('P6');
				
				}
	        }
        };
    });
 	// connect() 함수 정의 끝
 	
 	// 위에서 정의한 connect() 함수를 호출하여 접속을 시도함
    Wc2.initialize = function() {
        if (window.location.protocol == 'http:') {
//            Wc.connect('ws://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
            
//            Wc.connect('ws://' + 'erp.shapla.co.kr:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
//            Wc.connect('ws://' + '210.122.45.124:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
        	
//            Wc.connect('ws://' + 'erp.shapla.co.kr' +'/omegaplusshin'+ '/websocket/z_shDash');
//        	Wc.connect('ws://localhost:8080/op125/websocket/z_shDash');
	            	
            Wc2.connect('ws://' + '210.122.45.123:8086' +'/omegaplusshin'+ '/websocket/z_shDash');
//	            	Wc.connect('ws://localhost:8080/op125/websocket/chat');
        } else {
            Wc2.connect('wss://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
        }
    };

    // 위에 정의된 함수(접속시도)를 호출함
    //Wc.initialize();
	function connect2() {
		Wc2.initialize();
		console.log( "소켓 connect" );
	}
	
	function disconnect2(){
		console.log( "소켓 disconnect" );
        Wc2.socket.close();
    }
    */
/**
 * 웹소켓 클라이언트 (콘솔용)
 * @type 
 */    
/*	var Wc = {};
	
    Wc.socket = null;

    // connect() 함수 정의
    Wc.connect = (function(host) {
        // 서버에 접속시도
        if ('WebSocket' in window) {
            Wc.socket = new WebSocket(host);
        } else if ('MozWebSocket' in window) {
            Wc.socket = new MozWebSocket(host);
        } else {
//            Console.log('Error: WebSocket is not supported by this browser.');
        	console.log('Error: WebSocket is not supported by this browser.');
            return;
        }

         // 서버에 접속이 되면 호출되는 콜백함수
        Wc.socket.onopen = function () {
        	
            Console.log('Info: WebSocket connection opened.');
            // 채팅입력창에 메시지를 입력하기 위해 키를 누르면 호출되는 콜백함수
            document.getElementById('chat').onkeydown = function(event) {
                // 엔터키가 눌린 경우, 서버로 메시지를 전송함
                if (event.keyCode == 13) {
                    Wc.sendMessage();
                }
            };
            
        };
		
        
        // 연결이 끊어진 경우에 호출되는 콜백함수
        Wc.socket.onclose = function () {
        	// 채팅 입력창 이벤트를 제거함
           document.getElementById('chat').onkeydown = null;
            Console.log('Info: WebSocket closed.');
            
        };
		
        // 서버로부터 메시지를 받은 경우에 호출되는 콜백함수
        Wc.socket.onmessage = function (message) {
        	
        	var mv = message.data;
        	
        	var value = mv.substring(mv.indexOf(":: ")+3);
        
        	if(IsJsonString(value)){
	            var json = value//'{"ejc":4, "is_normal":0}';
				var obj = JSON.parse(json);
				
				var topicNm = obj.topics_nm;
				var equip = obj.ejc;
				equip = "KJ_M_" + equip.padStart(3, '0');
				
				if(topicNm == 'monitoring-result'){	//카프카 토픽 monitoring-result 알림
					var status = obj.is_normal;
					
					
					if(equip == p_equipCode){
						//정상 0
				        //경고 1
				        //불량 2
						if(status == '1'){
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#ffbc00");
	//						$("#warning_status").val('경고');
	
							AlertsUtil.kioskWarning_1("");
						}else if(status == '2'){
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#fa5c7c");
	//						$("#warning_status").val('불량');
							
							AlertsUtil.kioskWarning_2("");
						}else{
							
							// 오른쪽 상단에 상태 표시시 사용
	//						$('.warning-div').css("background-color", "#0acf97");
	//						$("#warning_status").val('정상');
							
							AlertsUtil.kioskWarning_0("");
						}
					}
				
				}else if(topicNm == 'recommend-result'){	//카프카 토픽 recommend-result 추천파라미터
					
					if(equip == p_equipCode){
						
						if($('#auto-setup-modal').hasClass('show')){	//자동제어창이 오픈 되어있을시
						
							
							//금형온도	md_auto_setup_mold_set_temp
							//노즐 2온도 md_auto_setup_nozzle_2_temp
							//실린더온도 1 md_auto_setup_cyl_1_temp
							//실린더온도 2 md_auto_setup_cyl_2_temp
							//작동유온도 md_auto_setup_oil_oper_temp
							//보압 전환 압력 md_auto_setup_sub_chng_press
							$("#md_auto_setup_mold_set_temp").val(obj.recommend_parameters.mold_set_temp);
							$("#md_auto_setup_nozzle_2_temp").val(obj.recommend_parameters.nozzle_2_temp);
							$("#md_auto_setup_cyl_1_temp").val(obj.recommend_parameters.cyl_1_temp);
							$("#md_auto_setup_cyl_2_temp").val(obj.recommend_parameters.cyl_2_temp);
							$("#md_auto_setup_oil_oper_temp").val(obj.recommend_parameters.oil_oper_temp);
							$("#md_auto_setup_sub_chng_press").val(obj.recommend_parameters.sub_chng_press);
						}
					}
				}
	        }
        	
        	// 수신된 메시지를 화면에 출력함
            Console.log(mv);
        };
    });
 	// connect() 함수 정의 끝
 	
 	// 위에서 정의한 connect() 함수를 호출하여 접속을 시도함
    Wc.initialize = function() {
        if (window.location.protocol == 'http:') {
//            Wc.connect('ws://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
//            210.122.45.123:8086
//            Wc.connect('ws://' + 'erp.shapla.co.kr:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
        	
        	//운영
//            Wc.connect('ws://' + '210.122.45.123:8086' +'/omegaplusshin'+ '/websocket/z_shDash');
            
            
//            Wc.connect('ws://' + '210.122.45.124:8187' +'/omegaplusshin'+ '/websocket/z_shDash');
        	
//            Wc.connect('ws://' + 'erp.shapla.co.kr' +'/omegaplusshin'+ '/websocket/z_shDash');
            
        	Wc.connect('ws://localhost:8080/op125/websocket/z_shDash');
	            	
//	            	Wc.connect('ws://localhost:8080/op125/websocket/chat');
        } else {
            Wc.connect('wss://' + window.location.host +'/omegaplusshin'+ '/websocket/z_shDash');
        }
    };

    // 서버로 메시지를 전송하고 입력창에서 메시지를 제거함
    Wc.sendMessage = (function() {
        var message = document.getElementById('chat').value;
        if (message != '') {
            Wc.socket.send(message);
            document.getElementById('chat').value = '';
        }
    });
	
    
    
    var Console = {}; // 화면에 메시지를 출력하기 위한 객체 생성

    // log() 함수 정의
    Console.log = (function(message) {
        var console = document.getElementById('console');
        var p = document.createElement('p');
        p.style.wordWrap = 'break-word';
        p.innerHTML = message;
        	
    	console.appendChild(p); // 전달된 메시지를 하단에 추가함
    	// 추가된 메시지가 25개를 초과하면 가장 먼저 추가된 메시지를 한개 삭제함
        while (console.childNodes.length > 25) {
            console.removeChild(console.firstChild);
        }
//	            }
        // 스크롤을 최상단에 있도록 설정함
        console.scrollTop = console.scrollHeight;
    });
    
    // 위에 정의된 함수(접속시도)를 호출함
    //Wc.initialize();
	function connect() {
		Wc.initialize();
		console.log( "소켓 connect" );
	}
	
	function disconnect(){
		console.log( "소켓 disconnect" );
        Wc.socket.close();
    }    
    */
   
    
    
    
    
    
    
    
    
    

//json타입 확인
function IsJsonString(str) {
  try {
    var json = JSON.parse(str);
    return (typeof json === 'object');
  } catch (e) {
    return false;
  }
}


	</script>
</html>
