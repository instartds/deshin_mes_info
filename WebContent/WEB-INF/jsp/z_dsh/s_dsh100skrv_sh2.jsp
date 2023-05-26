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
	
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/dataTables.bootstrap4.min.css"/>" />

	<style>

		.footer {
		   position: fixed;
		   left: 0;
		   bottom: 0;
		   padding:0px;
		   width: 100%;
		
		   text-align: center;
		}


.title { 
	display: inline-block; 
	width: 100%; 
	white-space: nowrap; 
	overflow: hidden; 
	text-overflow: ellipsis; 
	color:#bcc5d0;
	line-height: normal;
	margin:0;
}
.div-vm{
	display: flex; 
	align-items: center;
}

	</style>

</head>
    <body> 

        <div class="container-fluid">

                    <!-- start page title -->
                    <div class="page-title-box row">
                        <div class="col-1 div-vm">
                            
                            
                            
                             <!--    <div class="page-title-right">
				                    <div class="row">
	                        			<div class="col-2">
	                                    	<button type="button" class="btn btn-primary btn-block" id="startBtn"><i class="dripicons-media-play"></i></button>
	                                    </div>	
	                        			<div class="col-2">
	                                    	<button type="button" class="btn btn-danger btn-block" id="stopBtn"><i class="dripicons-media-stop"></i></button>
	                                    </div>
                                    </div>
                                </div>  -->
                                
                                
                          <!--       <h4 class="page-title">DashBoard</h4> -->
                                <!-- 
									<select class="form-control" id="equip_code" style ="height:60px; font-size:25px;" required="required">
							        </select> -->
							        
		                   <h1 class="title" align="left" id="equip_name"></h1>
		                   <input type="hidden" id="equip_code" name="equip_code" value="">
		             <!--       <h1 align="left" id="equip_code" style="overflow:hidden;"></h1> -->
                                
                        </div>
                        
                        <div class="col-7 div-vm">
                        	<h4 class="title" align="left" id="item_name" style="margin-top: 15px;"></h4>
                        </div>
                        <div class="col-1">
                         	<div class="row" style="height:100%; align-items: center;">
                        	
	                        	<div class="col-4">
	                        		<button type="button" class="btn btn-primary btn-block" id="startBtn"><i class="dripicons-media-play"></i></button>
	                        	</div>
	                        	<div class="col-4">
	                        		<button type="button" class="btn btn-danger btn-block" id="stopBtn"><i class="dripicons-media-stop"></i></button>
	                        	</div>
                        		<div class="col-4">
	                        		<button type="button" class="btn btn-info btn-block" id="menuBtn"><i class="dripicons-menu"></i></button>
                        		</div>
                        	</div>
                        </div>
                        <div class="col-3 div-vm">
		                   <h1 class="title" align="right" id="prodt_start_date_time"></h1>
                        </div>
                        
                    </div>
                    <!-- end page title -->

                    <div class="row">
                            <div class="col-12">
                                <div class="card widget-inline">
                                    <div class="card-body p-0">
                                        <div class="row no-gutters">
                                            
                
                                            <div class="col-sm-6 col-xl-3">
                                                <div class="card shadow-none m-0 border-left">
                                                    <div class="card-body text-center">
                                                        <i class="dripicons-user-group text-muted" style="font-size: 24px;"></i>
                                                        <h3 id="wkord_q"><span>0</span></h3>
                                                        <p class="text-muted font-15 mb-0">목표수량</p>
                                                    </div>
                                                </div>
                                            </div>
                
                							<div class="col-sm-6 col-xl-3">
                                                <div class="card shadow-none m-0 border-left">
                                                    <div class="card-body text-center">
                                                        <i class="dripicons-briefcase text-muted" style="font-size: 24px;"></i>
                                                        <h3 id="prodt_q"><span>0</span></h3>
                                                        <p class="text-muted font-15 mb-0">작업수량</p>
                                                    </div>
                                                </div>
                                            </div>
                
                                            <div class="col-sm-6 col-xl-3">
                                                <div class="card shadow-none m-0 border-left">
                                                    <div class="card-body text-center">
                                                        <i class="dripicons-graph-line text-muted" style="font-size: 24px;"></i>
                                                        <h3 id="work_progress"><span>0%</span> <i class="mdi mdi-arrow-up text-success"></i></h3>
                                                        <p class="text-muted font-15 mb-0">진행율</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            
                
                                            <div class="col-sm-6 col-xl-3">
                                                <div class="card shadow-none m-0 border-left">
                                                    <div class="card-body text-center">
                                                        <i class="dripicons-checklist text-muted" style="font-size: 24px;"></i>
                                                        <h3 id="act_shot_time"><span>0</span></h3>
                                                        <p class="text-muted font-15 mb-0">사이클타임</p>
                                                    </div>
                                                </div>
                                            </div>
                
                                        </div> <!-- end row -->
                                    </div>
                                </div> <!-- end card-box-->
                            </div> <!-- end col-->
                        </div>
                        <!-- end row-->


                        <div class="row">
                            <div class="col-lg-4">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="dropdown float-right">
                                            <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                <i class="mdi mdi-dots-vertical"></i>
                                            </a>
                                            <div class="dropdown-menu dropdown-menu-right">
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                            </div>
                                        </div>
                                        <h4 class="header-title mb-3">운영상태</h4>

                                        <div id="operating_status_chart" class="apex-charts" data-colors="#727cf5,#6c757d,#0acf97,#fa5c7c"></div>
<!-- 
                                        <div class="text-center mt-2">
                                            <button class="btn btn-sm btn-primary" id="randomize">RANDOMIZE</button>
                                            <button class="btn btn-sm btn-primary" id="add">ADD</button>
                                            <button class="btn btn-sm btn-primary" id="remove">REMOVE</button>
                                            <button class="btn btn-sm btn-primary" id="reset">RESET</button>
                                        </div> -->

          <!--                               <div class="row text-center py-2">
                                            <div class="col-4">
                                                <i class="mdi mdi-trending-up text-success mt-3 h3"></i>
                                                <h3 class="font-weight-normal">
                                                    <span>64%</span>
                                                </h3>
                                                <p class="text-muted mb-0">Completed</p>
                                            </div>
                                            <div class="col-4">
                                                <i class="mdi mdi-trending-down text-primary mt-3 h3"></i>
                                                <h3 class="font-weight-normal">
                                                    <span>26%</span>
                                                </h3>
                                                <p class="text-muted mb-0"> In-progress</p>
                                            </div>
                                            <div class="col-4">
                                                <i class="mdi mdi-trending-down text-danger mt-3 h3"></i>
                                                <h3 class="font-weight-normal">
                                                    <span>10%</span>
                                                </h3>
                                                <p class="text-muted mb-0"> Behind</p>
                                            </div>
                                        </div> -->
                                        <!-- end row-->

                                    </div> <!-- end card body-->
                                </div> <!-- end card -->
                            </div><!-- end col-->

                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-body">
                                    
                                    
										<section class="table-set-eqpmn">
											<table id="tblSMInfo" class="table table-sm table-hover table-bordered nowrap" style="width: 100%;">
											</table>
										</section>
                                    
                                    
                     <!--                
                                        <div class="dropdown float-right">
                                            <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                <i class="mdi mdi-dots-vertical"></i>
                                            </a>
                                            <div class="dropdown-menu dropdown-menu-right">
                                                item
                                                <a href="javascript:void(0);" class="dropdown-item">Today</a>
                                                item
                                                <a href="javascript:void(0);" class="dropdown-item">Yesterday</a>
                                                item
                                                <a href="javascript:void(0);" class="dropdown-item">Last Week</a>
                                                item
                                                <a href="javascript:void(0);" class="dropdown-item">Last Month</a>
                                            </div>
                                        </div>
                                        
                                        <h4 class="header-title mb-3">Revenue</h4>

                                        <div class="chart-content-bg">
                                            <div class="row text-center">
                                                <div class="col-md-6">
                                                    <p class="text-muted mb-0 mt-3">Current Month</p>
                                                    <h2 class="font-weight-normal mb-3">
                                                        <span>$42,025</span>
                                                    </h2>
                                                </div>
                                                <div class="col-md-6">
                                                    <p class="text-muted mb-0 mt-3">Previous Month</p>
                                                    <h2 class="font-weight-normal mb-3">
                                                        <span>$74,651</span>
                                                    </h2>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="dash-revenue-chart" class="apex-charts" data-colors="#0acf97,#fa5c7c"></div>

 -->




                                    </div>
                                    <!-- end card body-->
                                </div>
                                <!-- end card -->
                            </div>
                            <!-- end col-->
                        </div>
                        <!-- end row-->

                    <div class="row">
                    
                    	<div class="col-lg-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="dropdown float-right">
                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                            <i class="mdi mdi-dots-vertical"></i>
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right">
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Today</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Yesterday</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Week</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Month</a>
                                        </div>
                                    </div>

                                    <h4 class="header-title mb-3">Particulate Matter chart</h4>
                                    
                                    <div id="line-chart-realtime3" class="apex-charts" data-colors="#6c757d,#39afd1"></div>
<!-- 
                                    <div id="dash-campaigns-chart" class="apex-charts" data-colors="#ffbc00,#727cf5,#0acf97"></div>

                                    <div class="row text-center mt-2">
                                        <div class="col-md-4">
                                            <i class="mdi mdi-send widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>6,510</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-warning"></i> Total Sent</p>
                                        </div>
                                        <div class="col-md-4">
                                            <i class="mdi mdi-flag-variant widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>3,487</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-primary"></i> Reached</p>
                                        </div>
                                        <div class="col-md-4">
                                            <i class="mdi mdi-email-open widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>1,568</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-success"></i> Opened</p>
                                        </div>
                                    </div>

 -->


                                </div>
                                <!-- end card body-->
                            </div>
                            <!-- end card -->
                        </div>
                        <!-- end col-->
                    
                    
                    
                        <div class="col-lg-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="dropdown float-right">
                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                            <i class="mdi mdi-dots-vertical"></i>
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right">
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Today</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Yesterday</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Week</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Month</a>
                                        </div>
                                    </div>

                                    <h4 class="header-title mb-3">Humidity chart</h4>
                                    
                                    <div id="line-chart-realtime1" class="apex-charts" data-colors="#6c757d,#39afd1"></div>
<!-- 
                                    <div id="dash-campaigns-chart" class="apex-charts" data-colors="#ffbc00,#727cf5,#0acf97"></div>

                                    <div class="row text-center mt-2">
                                        <div class="col-md-4">
                                            <i class="mdi mdi-send widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>6,510</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-warning"></i> Total Sent</p>
                                        </div>
                                        <div class="col-md-4">
                                            <i class="mdi mdi-flag-variant widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>3,487</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-primary"></i> Reached</p>
                                        </div>
                                        <div class="col-md-4">
                                            <i class="mdi mdi-email-open widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                            <h3 class="font-weight-normal mt-3">
                                                <span>1,568</span>
                                            </h3>
                                            <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-success"></i> Opened</p>
                                        </div>
                                    </div>

 -->


                                </div>
                                <!-- end card body-->
                            </div>
                            <!-- end card -->
                        </div>
                        <!-- end col-->

                        <div class="col-lg-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="dropdown float-right">
                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                            <i class="mdi mdi-dots-vertical"></i>
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right">
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Today</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Yesterday</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Week</a>
                                            <!-- item-->
                                            <a href="javascript:void(0);" class="dropdown-item">Last Month</a>
                                        </div>
                                    </div>

                                    <h4 class="header-title mb-3">Temperature chart</h4>

                <!--                     <div class="chart-content-bg">
                                        <div class="row text-center">
                                            <div class="col-md-6">
                                                <p class="text-muted mb-0 mt-3">Current Month</p>
                                                <h2 class="font-weight-normal mb-3">
                                                    <span>$42,025</span>
                                                </h2>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="text-muted mb-0 mt-3">Previous Month</p>
                                                <h2 class="font-weight-normal mb-3">
                                                    <span>$74,651</span>
                                                </h2>
                                            </div>
                                        </div>
                                    </div> -->

                                        <div id="line-chart-realtime2" class="apex-charts" data-colors="#6c757d,#39afd1"></div>




                                <!--     <div id="dash-revenue-chart" class="apex-charts" data-colors="#0acf97,#fa5c7c"></div> -->

                                </div>
                                <!-- end card body-->
                            </div>
                            <!-- end card -->
                        </div>
                        <!-- end col-->
                    </div>
                    <!-- end row-->


                </div> <!-- container -->

            </div>

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
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/apexcharts.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/Chart.bundle.min.js" ></script>
<!-- DataTable -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/datatables.min.js" ></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/dataTables.bootstrap4.min.js" ></script>


	<script type="text/javascript" chartset="utf-8">
		var CPATH ='<%=request.getContextPath()%>';

		var isResponsive = false;
		var isPaging = true;
		var isScrollX = true;
		
		
		var p_equipCode = '${equipCode}';		//메인화면에서 선택한 호기정보
		var p_equipName = '${equipName}';		//메인화면에서 선택한 호기정보

		var p_itemName = '숄더(성형)SHH0200 아이더블유 리르퀵헤어마커2.내추럴브라운 브라운 숄더(성형)SHH0200 아이더블유 리르퀵헤어마커2.내추럴브라운 브라운';//'${itemName}';		//메인화면에서 선택한 부품정보
		


		
		
$(document).ready(function(){
	$.App.activateDarkMode();

	
	fnInitData();
	fnInit();
	
	$("#menuBtn").click(function () {
		var win = window.open(CPATH+'/z_dsh/s_dsh100skrv_sh1.do' , "_self", 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');

	});
	  
	realTimer();
   	setInterval(realTimer, 500);
	
   	var equipInfoLastSeq = 0;
	
	function getEquipInfo(){
		var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/getEquipInfo.do";
		var ajaxData = {"LAST_SEQ" : equipInfoLastSeq, "EQUIP_CODE" : p_equipCode};
		var ajaxloding = false;
		var returnData;
		var type = 'GET';
		var ajaxCallback= function (data1) {
			returnData = data1;
			if(returnData.length>0){
				//for(var i = 0; i < returnData.length; i++){
					var date = new Date(returnData[0].INSERT_DB_TIME).getTime();
			        var actShotCnt = returnData[0].ACT_SHOT_CNT;
			        var actShotTime = returnData[0].ACT_CYCLE_TIME;

			        var wkordQ = returnData[0].WKORD_Q;
			        var prodtQ = returnData[0].PRODT_Q;
			        
			        var workProgress = returnData[0].WORK_PROGRESS;
			        
			        var itemName = returnData[0].ITEM_NAME;

					/* $("#wkord_q").text(wkordQ.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
					
					$("#prodt_q").text(prodtQ.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));

					$("#work_progress").text(workProgress.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") + '%' );
*/
					
					
			        if(returnData[0].LAST_SEQ != null){
			        	$("#wkord_q").text(wkordQ);
						
						$("#prodt_q").text(prodtQ);

						$("#work_progress").text(workProgress + '%' );
						
						
						$("#act_shot_time").text(actShotTime);
						
						$("#item_name").text(itemName);
						
						equipInfoLastSeq = returnData[0].LAST_SEQ;
			        }
				//}
			}
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnData,type);
	}
	
	
	//제품별 작업효율
	function getOpsearch(){
		var ajaxUrl         = "${pageContext.request.contextPath}/z_dsh/getOpsearch.do";
	    var ajaxData        = {"EQUIP_CODE" : p_equipCode};//params;
	    var ajaxloding  = false;
		var returnCode;
	    var ajaxCallback= function (data) {
	    /* 	if(data.length > 0){
	    		window.Android.callMsg("SUCCESS");
	    	}else{
	    		window.Android.callMsg("data is not found");
	    	} */
	    	fnMainTableDraw(data);
			returnCode = data;
	    }
		var type = 'POST';
	    DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback,returnCode,type);
		
	}
	
	
  //온습도 차트 데이터
	var lastSeq = 0;
	
	var chartData1_1 = [];
	var chartData1_2 = [];
	var chartData1_3 = [];
	var chartData2_1 = [];
	var chartData2_2 = [];
	var chartData2_3 = [];
	
	var initChartData = 'Y';
	
	function getTemperature(){
		var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/getTemperature.do";
		var ajaxData = {"LAST_SEQ" : lastSeq, "INIT_CHART_DATA" : initChartData};
		var ajaxloding = false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			
			if(data.length>0){
				initChartData = 'N';
				for(var i = 0; i < data.length; i++){
					
					var date = new Date(data[i].INSERT_DB_TIME).getTime();
			        var hum = data[i].HUM01;
			        var tem = data[i].TEM01;
			        
					if(data[i].SENSOR_CODE == 'S01'){
	
				        chartData1_1.push({
				            x: date,
				            y: hum
				        });
						
				        chartData2_1.push({
				            x: date,
				            y: tem
				        });
					}else if(data[i].SENSOR_CODE == 'S02'){
						
						chartData1_2.push({
				            x: date,
				            y: hum
				        });
				        chartData2_2.push({
				            x: date, 
				            y: tem
				        });
					}else if(data[i].SENSOR_CODE == 'S03'){
						
						chartData1_3.push({
				            x: date,
				            y: hum
				        });
				        chartData2_3.push({
				            x: date, 
				            y: tem
				        });
					}
	
			        lastSeq = data[i].LAST_SEQ;
	
			        
				}
				
				chart1.updateSeries([{
				    data: chartData1_1
			    },{
			        data: chartData1_2
			    },{
			        data: chartData1_3
			    }]);
				
				chart2.updateSeries([{
				    data: chartData2_1
			    },{
			        data: chartData2_2
			    },{
			        data: chartData2_3
			    }]);
			
			}
			
			
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}

	function resetData() {
		
		chartData1_1 = chartData1_1.slice(-300);//배열의 마지막 300개 추출
		chartData1_2 = chartData1_2.slice(-300);
		chartData1_3 = chartData1_3.slice(-300);
		
		chartData2_1 = chartData2_1.slice(-300);//배열의 마지막 300개 추출
		chartData2_2 = chartData2_2.slice(-300);
		chartData2_3 = chartData2_3.slice(-300);
		
		//chartData1 = chartData1.slice(chartData1.length - 10, chartData1.length);
	}

	
	
	
	
	
	//운영상태 차트 데이터
	var operatingStatusData = [];
	
	function getOperatingStatus(){
		var ajaxUrl = "${pageContext.request.contextPath}/z_dsh/getOperatingStatus.do";
		var ajaxData = {"EQUIP_CODE" : p_equipCode};
		var ajaxloding = false;
		var returnCode;
		var type = 'GET';
		var ajaxCallback= function (data) {
			returnCode = data;
			if(data.length>0){
				
				operatingStatusData = [data[0].CNT_8,data[0].CNT_0_2,data[0].CNT_16,data[0].CNT_9];
				
			/* 	for(var i = 0; i < data.length; i++){
					
					var date = new Date(data[i].INSERT_DB_TIME).getTime();
			        var hum = data[i].HUM01;
			        var tem = data[i].TEM01;
			        
					
			        chartData1_1.push({
			            x: date,
			            y: hum
			        });
				} */
				
				chart4.updateSeries(operatingStatusData);
				
			}
			
			
		}
		DataUtil.ajax(ajaxUrl, ajaxData, ajaxloding, ajaxCallback, returnCode,type);
	}
	
	
	/* 
	
	if ($('#project-status-chart').length > 0) {
        var dataColors = $("#project-status-chart").data('colors');
        var colors = dataColors ? dataColors.split(",") : ["#0acf97", "#727cf5", "#fa5c7c"];
        //donut chart
        var donutChart = {
            labels: [
                "Completed",
                "In-progress",
                "Behind"
            ],
            datasets: [
                {
                    data: [64, 26, 10],
                    backgroundColor: colors,
                    borderColor: "transparent",
                    borderWidth: "3",
                }]
        };
        var donutOpts = {
            maintainAspectRatio: false,
            cutoutPercentage: 80,
            legend: {
                display: false
            }
        };
        donutCharts.push(this.respChart($("#project-status-chart"), 'Doughnut', donutChart, donutOpts));
    }
    return donutCharts;
	
	
	
	 */
	
	
	
	
	
	
	

	//
	// Realtime chart Humidity
	//
	var colors1 =["#64CD3C","#FF5676","#1E90FF"];//["#6c757d","#39afd1","#555"];
	/* var dataColors = $("#line-chart-realtime").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	} */
	var options1 = {
	    chart: {
	        height: 350,
	        type: 'line',//line radialBar
	        animations: {
	            enabled: true,
	            easing: 'linear',
	       /*      linear
	            easein
	            easeout
	            easeinout */
	            dynamicAnimation: {
	                speed: 0
	            }
	        },
	        toolbar: {
	            show: false
	        },
	        zoom: {
	            enabled: false
	        }
	    },
	    dataLabels: {
	        enabled: false
	    },
	    stroke: {
	        curve: 'smooth',
	        width: [4,4,4],
	    },
	    series: [
	             
	    {
	    	name: "습도1번",	    	
	        data: chartData1_1
	    },{
	    	name: "습도2번",	 	
	        data: chartData1_2
	    },{
	    	name: "습도3번",	 	
	        data: chartData1_3
	    }	    
	    ],
	    colors: colors1,
	    markers: {
	    	 colors: colors1,
	        size: 0
	    },
	    xaxis: {
	        type: 'datetime',//'category',datetime
	        range: 600000,//20초량 데이터,  최초 가져오는 데이터가 2초 단위씩 한로우 11개 데이터 이고 후에  2초 단위인 로우 하나씩 가져옴//777600000  9일		
	     //   tickPlacement: 'on',	//category
	      //  floating: true,
	        labels: {
	        	rotate: 0,
	        	 formatter: function (value, timestamp) {
	        		var date = new Date(timestamp);
	        		var hour = date.getHours();
	        		var minute = date.getMinutes();
	        		var second = date.getSeconds();
	     
					return hour + ':' + minute; // The formatter function overrides format property
        	    }
	        }
	    },
	    yaxis: {
	    	min: 10.0,
	        max: 50.0
	    },
	    legend: {
	        show: true,
	        onItemClick: {
            	toggleDataSeries: false
          	},
	    },
	    grid: {
	      borderColor: '#f1f3fa',
	      xaxis: {
	          lines: {
	              show: true
	          }
	      },  
	    }
	    /* title: {
	          text: '온도',
	      } */
	};

	var chart1 = new ApexCharts(document.querySelector("#line-chart-realtime1"), options1);
	chart1.render();
	
	
	
	
	
	
	

	//
	// Realtime chart Temperature
	//
	var colors2 =["#64CD3C","#FF5676","#1E90FF"];//["#6c757d","#39afd1","#555"];
	/* var dataColors = $("#line-chart-realtime").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	} */
	var options2 = {
	    chart: {
	        height: 350,
	        type: 'line',//line radialBar
	        animations: {
	            enabled: true,
	            easing: 'linear',
	       /*      linear
	            easein
	            easeout
	            easeinout */
	            dynamicAnimation: {
	                speed: 0
	            }
	        },
	        toolbar: {
	            show: false
	        },
	        zoom: {
	            enabled: false
	        }
	    },
	    dataLabels: {
	        enabled: false
	    },
	    stroke: {
	        curve: 'smooth',
	        width: [4,4,4],
	    },
	    series: [
	             
	    {
	    	name: "온도1번",	    	
	        data: chartData2_1
	    },{
	    	name: "온도2번",	 	
	        data: chartData2_2
	    },{
	    	name: "온도3번",	 	
	        data: chartData2_3
	    }	    
	    ],
	    colors: colors2,
	    markers: {
	    	 colors: colors2,
	        size: 0
	    },
	    xaxis: {
	        type: 'datetime',//'category',datetime
	        range: 600000,//20초량 데이터,  최초 가져오는 데이터가 2초 단위씩 한로우 11개 데이터 이고 후에  2초 단위인 로우 하나씩 가져옴//777600000  9일		
	     //   tickPlacement: 'on',	//category
	      //  floating: true,
	        labels: {
	        	rotate: 0,
	        	 formatter: function (value, timestamp) {
	        		var date = new Date(timestamp);
	        		var hour = date.getHours();
	        		var minute = date.getMinutes();
	        		var second = date.getSeconds();
	     
        	      return hour + ':' + minute; // The formatter function overrides format property
        	    }
	        }
	    },
	    yaxis: {
	    	min: 15.0,
	        max: 25.0
	    },
	    legend: {
	        show: true,
	        onItemClick: {
            	toggleDataSeries: false
          	},
	    },
	    grid: {
	      borderColor: '#f1f3fa',
	      xaxis: {
	          lines: {
	              show: true
	          }
	      },  
	    }
	    /* title: {
	          text: '온도',
	      } */
	};

	var chart2 = new ApexCharts(document.querySelector("#line-chart-realtime2"), options2);
	chart2.render();
	
	
/* 	
	// 
	// Realtime chart Particulate Matter
	//
	var colors2 =["#64CD3C","#FF5676","#1E90FF"];

	var options2 = {
	    chart: {
	        height: 350,
	        type: 'line',//line radialBar
	        animations: {
	            enabled: true,
	            easing: 'linear',

	            dynamicAnimation: {
	                speed: 0
	            }
	        },
	        toolbar: {
	            show: false
	        },
	        zoom: {
	            enabled: false
	        }
	    },
	    dataLabels: {
	        enabled: false
	    },
	    stroke: {
	        curve: 'smooth',
	        width: [2,2,2],
	    },
	    series: [
	             
	    {
	    	name: "온도1번",	    	
	        data: chartData2_1
	    },{
	    	name: "온도2번",	 	
	        data: chartData2_2
	    },{
	    	name: "온도3번",	 	
	        data: chartData2_3
	    }	    
	    ],
	    colors: colors2,
	    markers: {
	    	 colors: colors2,
	        size: 1
	    },
	    xaxis: {
	        type: 'datetime',//'category',datetime
	        range: 600000,//20초량 데이터,  최초 가져오는 데이터가 2초 단위씩 한로우 11개 데이터 이고 후에  2초 단위인 로우 하나씩 가져옴//777600000  9일		
	     //   tickPlacement: 'on',	//category
	      //  floating: true,
	        labels: {
	        	rotate: 0,
	        	 formatter: function (value, timestamp) {
	        		var date = new Date(timestamp);
	        		var hour = date.getHours();
	        		var minute = date.getMinutes();
	        		var second = date.getSeconds();
	     
        	      return hour + ':' + minute; // The formatter function overrides format property
        	    }
	        }
	    },
	    yaxis: {
	    	min: 15.0,
	        max: 25.0
	    },
	    legend: {
	        show: true,
	        onItemClick: {
            	toggleDataSeries: false
          	},
	    },
	    grid: {
	      borderColor: '#f1f3fa',
	      xaxis: {
	          lines: {
	              show: true
	          }
	      },  
	    }
	};

	var chart2 = new ApexCharts(document.querySelector("#line-chart-realtime2"), options2);
	chart2.render();
	 */

	
	var setIV1;	//온, 습도 차트  //setInterval(setChartData, 2000);	
	var setIV2; //온, 습도 차트 데이터배열 초기화관련	//setInterval(setChartData, 2000);
	var setIV3; //각호기별 데이터 
	
	var setIV4; //각호기별 운영상태 
		$("#startBtn").click(function(){
			setIV1 = setInterval(getTemperature, 2000);
			setIV2 = setInterval(resetData, 600000);

			setIV3 = setInterval(getEquipInfo, 2000);
			 
			getOpsearch();
			setIV4 = setInterval(getOperatingStatus, 2000);
		});
		
		//2초 간격이 제일 빠른 트랜잭션 간격이라는 가정하에 (MAX 2초 간격 으로 데이터 1로우씩 생성되었다고 가정)
			//600초 단위로 배열에 300개 씩 쌓임
			//600초 단위로 배열 체크 하여 최근 300개만 남기고 나머지 제거 하여 300개 유지 시킴
			//X축 간격이 600초(10분)으로 고정해놓았기 때문에 데이터가 최소 300개는 있어야 함
		$("#stopBtn").click(function(){
			clearInterval(setIV1);
			clearInterval(setIV2);
			
			clearInterval(setIV3);
			clearInterval(setIV4);
		});
	
	
	
	
	
	
	
	/**
	 * Theme: Hyper - Responsive Bootstrap 4 Admin Dashboard
	 * Author: Coderthemes
	 * Module/App: CRM Dashboard
	 */

/* 

	//
	// Campaign Sent Chart
	//
	var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors = $("#campaign-sent-chart").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	}
	var options1 = {
	    chart: {
	        type: 'bar',
	        height: 60,
	        sparkline: {
	            enabled: true
	        }
	    },
	    plotOptions: {
	        bar: {
	            columnWidth: '60%'
	        }
	    },
	    colors: colors,
	    series: [{
	        data: [25, 66, 41, 89, 63, 25, 44, 12, 36, 9, 54]
	    }],
	    labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
	    xaxis: {
	        crosshairs: {
	            width: 1
	        },
	    },
	    tooltip: {
	        fixed: {
	            enabled: false
	        },
	        x: {
	            show: false
	        },
	        y: {
	            title: {
	                formatter: function (seriesName) {
	                    return ''
	                }
	            }
	        },
	        marker: {
	            show: false
	        }
	    }
	}

	new ApexCharts(document.querySelector("#campaign-sent-chart"), options1).render();


	// 
	// New Leads Chart
	//
	var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors = $("#new-leads-chart").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	}
	var options2 = {
	    chart: {
	        type: 'line',
	        height: 60,
	        sparkline: {
	            enabled: true
	        }
	    },
	    series: [{
	        data: [25, 66, 41, 89, 63, 25, 44, 12, 36, 9, 54]
	    }],
	    stroke: {
	        width: 2,
	        curve: 'smooth'
	    },
	    markers: {
	        size: 0
	    },
	    colors: colors,
	    tooltip: {
	        fixed: {
	            enabled: false
	        },
	        x: {
	            show: false
	        },
	        y: {
	            title: {
	                formatter: function (seriesName) {
	                    return ''
	                }
	            }
	        },
	        marker: {
	            show: false
	        }
	    }
	}


	new ApexCharts(document.querySelector("#new-leads-chart"), options2).render();


	//
	// Deals Charts
	//
	var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors = $("#deals-chart").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	}
	var options3 = {
	    chart: {
	        type: 'bar',
	        height: 60,
	        sparkline: {
	            enabled: true
	        }
	    },
	    plotOptions: {
	        bar: {
	            columnWidth: '60%'
	        }
	    },
	    colors: colors,
	    series: [{
	        data: [12, 14, 2, 47, 42, 15, 47, 75, 65, 19, 14]
	    }],
	    labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
	    xaxis: {
	        crosshairs: {
	            width: 1
	        },
	    },
	    tooltip: {
	        fixed: {
	            enabled: false
	        },
	        x: {
	            show: false
	        },
	        y: {
	            title: {
	                formatter: function (seriesName) {
	                    return ''
	                }
	            }
	        },
	        marker: {
	            show: false
	        }
	    }
	}


	new ApexCharts(document.querySelector("#deals-chart"), options3).render();

	//
	// Booked Revenue Chart
	//
	var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors = $("#booked-revenue-chart").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	}
	var options4 = {
	    chart: {
	        type: 'bar',
	        height: 60,
	        sparkline: {
	            enabled: true
	        }
	    },
	    plotOptions: {
	        bar: {
	            columnWidth: '60%'
	        }
	    },
	    colors: colors,
	    series: [{
	        data: [47, 45, 74, 14, 56, 74, 14, 11, 7, 39, 82]
	    }],
	    labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
	    xaxis: {
	        crosshairs: {
	            width: 1
	        },
	    },
	    tooltip: {
	        fixed: {
	            enabled: false
	        },
	        x: {
	            show: false
	        },
	        y: {
	            title: {
	                formatter: function (seriesName) {
	                    return ''
	                }
	            }
	        },
	        marker: {
	            show: false
	        }
	    }
	}

	new ApexCharts(document.querySelector("#booked-revenue-chart"), options4).render();

	  
	//
	// CAMPAIGNS RADIALBARS CHART
	//
	var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors = $("#dash-campaigns-chart").data('colors');
	if (dataColors) {
	    colors = dataColors.split(",");
	}
	var options = {
	    chart: {
	        height: 339,
	        type: 'radialBar'
	    },
	    colors: colors,
	    series: [86, 36, 50],
	    labels: ['Total Sent', 'Reached', 'Opened'],
	    plotOptions: {
	        radialBar: {
	            track: {
	                margin: 8,
	            }
	        }
	    }
	}

	var chart = new ApexCharts(
	    document.querySelector("#dash-campaigns-chart"),
	    options
	);

	chart.render();
	 */

	//
	// REVENUE AREA CHART
	//

	var colors3 = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
	var dataColors3 = $("#dash-revenue-chart").data('colors');
	if (dataColors3) {
	    colors3 = dataColors3.split(",");
	}
	var options3 = {
	    chart: {
	        height: 321,
	        type: 'line',
	        toolbar: {
	            show: false
	        }
	    },
	    stroke: {
	        curve: 'smooth',
	        width: 2
	    },
	    series: [{
	        name: 'Total Revenue',
	        type: 'area',
	        data: [44, 55, 31, 47, 31, 43, 26, 41, 31, 47, 33, 43]
	    }, {
	        name: 'Total Pipeline',
	        type: 'line',
	        data: [55, 69, 45, 61, 43, 54, 37, 52, 44, 61, 43, 56]
	    }],
	    fill: {
	        type: 'solid',
	        opacity: [0.35, 1],
	    },
	    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
	    markers: {
	        size: 0
	    },
	    colors: colors3,
	    yaxis: [
	        {
	            title: {
	                text: 'Revenue (USD)',
	            },
	            min: 0
	        }
	    ],
	    tooltip: {
	        shared: true,
	        intersect: false,
	        y: {
	            formatter: function (y) {
	                if (typeof y !== "undefined") {
	                    return y.toFixed(0) + "k";
	                }
	                return y;
	  
	            }
	        }
	    },
	    grid: {
	        borderColor: '#f1f3fa'
	    },
	    legend: {
	        fontSize: '14px',
	        fontFamily: '14px',
	        offsetY: -10,
	    },
	    responsive: [{
	        breakpoint: 600,
	        options: {
	            yaxis: {
	                show: false
	            },
	            legend: {
	                show: false
	            }
	        }
	    }]
	  }
	  
	  var chart3 = new ApexCharts(
	    document.querySelector("#dash-revenue-chart"),
	    options3
	  );
	  
	  chart3.render();
	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	//
	// 운영상태 차트
	//
	
	var operatingStatusData = [];
	
	var colors4 = ["#727cf5", "#6c757d","#0acf97", "#fa5c7c"];
	var dataColors4 = $("#operating_status_chart").data('colors');
	if (dataColors4) {
	    colors4 = dataColors4.split(",");
	}
	var options4 = {
	    chart: {
	        height: 320,
	        type: 'donut',
	    },
	    plotOptions: {
	        pie: {
	            donut: {
	                labels: {
	                    show: true,
	                /*     name: {
	                        //...
	                    },
	                    value: {
	                       // ...
	                    } */
	                    total:{
	                    	show:true
	                    }
	                }
	            }
	        }
	    },
	    
	    dataLabels: {
	        enabled: true
	    /*     formatter: function (val) {
	          return val //+ "%"
	        } */
	      /*   dropShadow: {
	          ...
	        } */
	    },
	    series: operatingStatusData,
	   /*  series: [{
	        //name: 'Total Revenue',
	      //  type: 'area',
	        data: operatingStatusData
	    }], */
	    
	    labels: ['자동', '반자동/수동', '금형', '정지'],
	    colors: colors4,
	    legend: {
	        show: true,
	        position: 'bottom',
	        horizontalAlign: 'center',
	        verticalAlign: 'middle',
	        floating: false,
	        fontSize: '14px',
	        offsetX: 0,
	        offsetY: -10
	    },
	    responsive: [{
	        breakpoint: 600,
	        options: {
	            chart: {
	                height: 240
	            },
	            legend: {
	                show: false
	            },
	        }
	    }]
	}

	var chart4 = new ApexCharts(
	    document.querySelector("#operating_status_chart"),
	    options4
	);

	chart4.render();

/* 	function appendData() {
	    var arr = chart.w.globals.series.map(function () {
	        return Math.floor(Math.random() * (100 - 1 + 1)) + 1;
	    });
	    arr.push(Math.floor(Math.random() * (100 - 1 + 1)) + 1);
	    return arr;
	}

	function removeData() {
	    var arr = chart.w.globals.series.map(function () {
	        return Math.floor(Math.random() * (100 - 1 + 1)) + 1;
	    });
	    arr.pop();
	    return arr;
	}

	function randomize() {
	    return chart.w.globals.series.map(function () {
	        return Math.floor(Math.random() * (100 - 1 + 1)) + 1;
	    });
	}

	function reset() {
	    return options.series;
	}

	document.querySelector("#randomize").addEventListener("click", function () {
	    chart.updateSeries(randomize());
	});

	document.querySelector("#add").addEventListener("click", function () {
	    chart.updateSeries(appendData());
	});

	document.querySelector("#remove").addEventListener("click", function () {
	    chart.updateSeries(removeData());
	});

	document.querySelector("#reset").addEventListener("click", function () {
	    chart.updateSeries(reset());
	});
	  
	   */
	  
	   
	 
})




	



	




//설비정보 세팅	(설비정보 메인메뉴에서 가져오는것으로 변경)
	function fnInitData(){
/* 		
		 $("#equip_code option").remove();
		$("#equip_code").append("<option value='"+ p_equipCode +"'>" + p_equipName + "</option>");	//메인화면에서 선택한 호기정보
		 */
		//$("#equip_code").text(p_equipCode);
		$("#equip_code").val(p_equipCode)
		$("#equip_name").text(p_equipName);

	//	$("#item_name").text(p_itemName);
		
		
		
 		/* var ajaxUrl 	= "${pageContext.request.contextPath}/z_dsh/getEquipCode.do";
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
		 */
		
	} 

function realTimer() {
	const nowDate = new Date();
	const year = nowDate.getFullYear();
	const month= nowDate.getMonth() + 1;
	const date = nowDate.getDate();
	const hour = nowDate.getHours();
	const min = nowDate.getMinutes();
	const sec = nowDate.getSeconds();
	//$("#prodt_start_date2").text(year + "." + addzero(month) + "." + addzero(date));
	//$("#prodt_start_time2").text(hour + ":" + addzero(min) + ":" + addzero(sec));
	
	$("#prodt_start_date_time").text(year + "." + addzero(month) + "." + addzero(date) + ' ' + hour + ":" + addzero(min) + ":" + addzero(sec));
	
	
	//panelSearch.down('#nowTimes').setHtml(hour + ":" + addzero(min) + ":" + addzero(sec));
	//panelSearch.down('#nowDays').setHtml(year + "년 " + addzero(month) + "월 " + addzero(date) + "일");
}
   // 1자리수의 숫자인 경우 앞에 0을 붙여준다.
function addzero(num) {
	if(num < 10) { num = "0" + num; }
		return num;
}
   
   
function fnInit() {
	
	//fnDatePickerInit();
	
	// 컴포넌트
	fnMainTableInit();
	
	//$("#searchBtn").trigger("click");
	// 공통코드
	//fnGetCommonCodeList();
	    
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
            //    + "<'row'>" + "<'row'<'col-6'l><'col-6'f>>"
                + "<'row'<'col-12'tr>>" //col-12
                + "<'row'<'col-sm-6'i><'col-sm-6'p>>",
        //destroy: true,
		select : false,
		//paging : true,
		paging : isPaging,
		ordering : true,
		info : true,
		filter : false,
		lenghChange : true,
		lengthChange : true,
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
            

            { title: "수주번호",			data : "SO_NUM", width:"20%"},
            { title: "시작시간",			data : "PRODT_START_TIME", width:"10%"},
            { title: "총작업시간",			data : "TOTAL_WORK_TIME", width:"5%"},
            { title: "유실시간",			data : "PAUSE_WORK_TIME", width:"5%"},
            { title: "실작업시간",			data : "REAL_WORK_TIME", width:"5%"},
            { title: "가동율(%)",			data : "WORK_RATE", width:"5%"},
            { title: "생산량",			data : "WKORD_Q", width:"5%"},
            { title: "평균가공시간",			data : "ACT_SHOT_CNT", width:"5%"},
            { title: "표준작업시간",			data : "STANDARD_WORK_TIME", width:"5%"},
            { title: "작업효율(%)",			data : "WORK_EF", width:"5%"},
            { title: "부품명",			data : "ITEM_NAME", width:"30%"},
            
            
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

        },
        
/*         
        
        {
            targets: 2,
            className: "text-head-center",
           // width: "55px",
            render : function(data, type, row){
    			var html = "<input type='number' class='form-control form-control-sm i-input text-right' name='workQ' value='" + data + "' placeholder='' autocomplete='off'>";
    			return  html;
    		}
        }
         */
/*         ,{
			responsivePriority: 0,
			targets: 5,
			render : function (data, type, row){
				var popHtml = "";
					popHtml += "<button type='button' class='btn btn-outline-info btn-sm detail-control' id='btnInfo'>";
					popHtml += "<i class='mdi mdi-chevron-right' ></i>";
					popHtml += "</button>";
				return popHtml;
			},
			className: "text-center",
			orderable: false,
			visible: isResponsive
		} */
        
        ]
/* 		responsive: {
			details: {
				type : isResponsive,
				display: $.fn.dataTable.Responsive.display.childRowImmediate
			}
		} */
    });
/*     $("#tblSMInfo").on('draw.dt', function () {
    	$('#tblSMInfo').DataTable().rows().every(function () {
            this.child(format(this.data())).show();
            this.nodes().to$().addClass('shown');
            // this next line removes the padding from the TD in the child row 
            // In my case this gives a more uniform appearance of the data
            this.child().find('td:first-of-type').addClass('child-container')
          });
    }); */
 // Add event listener for opening and closing details
 /* 		$('#tblSMInfo tbody').on('click', 'td', function () {
		var tr = $(this).closest('tr');
		//var row = table.row( tr );
		var row = $('#tblSMInfo').DataTable().row(tr);

		if ( row.child.isShown() ) {
			// This row is already open - close it
			row.child.hide();
			tr.removeClass('shown');
		}
		else {
			// Open this row
			row.child( format(row.data()) ).show();
			//row.child( row.data() ).show();
			//row.child.show();
			tr.addClass('shown');
		}
	} );
 
	$("#tblSMInfo").DataTable().rows().every( function () {
        this.child(format(this.data())).show();
        this.nodes().to$().addClass('shown');
    });  */
}

/* 	function format(d) {
    	  // `d` is the original data object for the row
		return  '<table class="row-detail">' +
    	          	'<tr>' +
	    	          	'<td width=30>품명:</td>'+
	    	            '<td title="품명">' + d.ITEM_NAME + '</td>' +
    	            '</tr>' + 
    	            '<tr>' +
	    	            '<td>규격:</td>'+
	    	            '<td title="규격">' + d.SPEC + '</td>' +
    	          	'</tr>' + 
    	          '</table>';
   	} */
function fnMainTableDraw(data){
    var table = $('#tblSMInfo').DataTable();
    table.clear();

    if(!ObjUtil.isEmpty(data)) table.rows.add(data);
        table.draw();
}





function fnEvent(){
	
 	$(document).on("click", "#searchBtn", function(){
	
	/* 	var params = {'COMP_CODE':userCompCode,'DIV_CODE':userDivCode};
		params.WKORD_NUM = $("#wkordNum").val(); */
	
	    var ajaxUrl         = "${pageContext.request.contextPath}/z_dsh/getOpsearch.do";
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
 	
 	$(document).on("click", "#saveBtn", function(){
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
 	
/*  	$(document).on("click", "#saveBtn2", function(){
		
 		window.Android.callMsg("테스트 2");
 		
	}); */
}

function fnGetCommonCodeList(){
	//공통코드 B024
	var wkordPrsn = DataUtil.getCommonCodeList(userCompCode,'P505').data;
	$("#wkordPrsn option").remove();
	$("#wkordPrsn").append('<option value="">[선 택]</option>');
	for(var i = 0; i < wkordPrsn.length; i++){
		$("#wkordPrsn").append("<option value='"+ wkordPrsn[i].SUB_CODE +"'>" + wkordPrsn[i].CODE_NAME + "</option>");
		if(wkordPrsn[i].REF_CODE2 == userId){
			$("#wkordPrsn").val(wkordPrsn[i].SUB_CODE).prop("selected",true);
		}
	}
}

function fnSave(params){
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
	   	/* $(".i-input").val(undefined); */
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
	}
}

/* function fnDatePickerInit(){
	var date = new Date();
	var dateY = date.getFullYear();
	var dateM = date.getMonth();
	var dateD = date.getDate();
	
	$('#wkordDate').datepicker({
	    format: 'yyyy-mm-dd',
	    autoclose: 'true'
	}).datepicker("setDate", new Date(dateY, dateM, dateD));
	 
} */  
   
   
	
	</script>
</html>
