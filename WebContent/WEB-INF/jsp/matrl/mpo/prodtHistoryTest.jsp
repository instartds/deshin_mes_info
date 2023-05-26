<%--
'   프로그램명 : 발주대비 입고현황 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Hyper - Responsive Bootstrap 4 Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description" />
    <meta content="Coderthemes" name="author" />
    <!-- App favicon -->
    <link rel="shortcut icon" href="assets/images/favicon.ico">

    <!-- third party css -->
    <link href="assets/css/vendor/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <!-- third party css end -->

    <link href="assets/css/vendor/responsive.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/vendor/buttons.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/vendor/select.bootstrap4.css" rel="stylesheet" type="text/css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app-dark.min.css" rel="stylesheet" type="text/css" id="light-style" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" id="dark-style" />
    <!--
    <link href="assets/css/app-dark.min.css" rel="stylesheet" type="text/css" id="dark-style" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" id="light-style" />
    -->
    <link href="assets/css/dataTables/dataTables.bootstrap4.min.css" type="text/css" rel="stylesheet" />
    <link href="assets/css/dataTables/buttons.bootstrap4.min.css" type="text/css" rel="stylesheet" />

    <!--<link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />-->


    <link rel="stylesheet" href="assets/css/clock/flipclock.css">
    <link rel="stylesheet" href="assets/css/timepicki/timepicki.css">

    <style>
        .tot-line-font {
            font-size: 15px;
        }

        .tot-line-icon {
            font-size: 13px;
        }

        .tot-line-ymd,
        ,
        .card-prdctn-efcny .efcny-sub-header {
            font-size: 36px;
        }

        .tot-line-contents {
            font-size: 20px;
            /*display: block;*/
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .tot-line-unit {
            font-size: 30px;
        }



        .ribbon-text {
            font-size: 20px;
        }

        .eqpmn-nm {
            font-size: 28px;
        }

        .contents-tag-name {
            font-size: 28px;
        }

        .contents-tag-value {
            font-size: 40px;
        }

        tr.off {
            display: none;
        }

        td {
            font-size: 20px;
        }

    </style>

</head>

<body>
    <div class="container-fluid">

        <!-- start page title -->
        <!--<header class="row">
            <div class="col-12">
                <div class="page-title-box">
                    <div class="page-title-right">
                        <ol class="breadcrumb m-0">
                            <li class="breadcrumb-item"><a href="javascript: void(0);">대분류</a></li>
                            <li class="breadcrumb-item"><a href="javascript: void(0);">중분류</a></li>
                            <li class="breadcrumb-item active">메뉴</li>
                        </ol>
                    </div>
                    <h2 class="page-title">제조이력관리</h2>
                    <hr class="mt-0">
                </div>
            </div>
        </header>-->
        <main>
            <div class="main-tot-aggr">
                <div class="card m-2">
                    <div class='card-body row p-0'>

                        <div class="col-12 text-right ">
                            <div class="btn-group">
                                <button class="btn btn-rounded btn-outline-info" style="width:90px;height:60px;font-size:25px;">&lt;&lt; </button>
                                <button class="btn btn-rounded btn-outline-primary" style="width:100px; height:60px;font-size:25px;">&lt; </button>
                                <button class="btn btn-rounded btn-outline-primary" style="width:100px;height:60px;font-size:25px;"> &gt;</button>
                                <button class="btn btn-rounded btn-outline-info" style="width:90px;height:60px;font-size:25px;"> &gt;&gt;</button>
                            </div>
                            <!--<div class="row">
                                <div class="col-2 pt-2 pr-0">
                                    <button class="btn btn-block btn-rounded btn-outline-info" style="height:70px;font-size: 25px;">&lt&lt</button>
                                </div>
                                <div class="col-3 pt-2">
                                    <button class="btn btn-block btn-rounded btn-outline-primary" style="height:70px;font-size: 35px;">&lt</button>
                                </div>
                                <div class="col-3 pt-2">
                                    <button class="btn btn-block btn-rounded btn-outline-primary" style="height:70px;font-size: 35px;">&gt</button>
                                </div>
                                <div class="col-2 pt-2 pl-0">
                                    <button class="btn btn-block btn-rounded btn-outline-info" style="height:70px;font-size: 30px;">&gt&gt</button>
                                </div>
                            </div>-->
                        </div>


                        <!--<div class="col-8">
                            <div class="row">
                                <div class='col-2'>
                                    <div class='card-body p-3'>
                                        <i class='mdi mdi-hammer tot-line-icon'></i>
                                        <span class='' style="font-size:22px">&nbsp제 품 명</span>
                                    </div>
                                </div>
                                <div class='col-10'>
                                    <div class='card-body p-2'>

                                        <span class='tot-line-contents text-success' id=''>3CE MULTI EYE COLOR PALETTE #OVERTAKE #1</span>

                                    </div>
                                </div>
                            </div>
                       </div>-->
                        <!--<div class="col-4">
                           <div class="row">

                                <div class='col-4'>
                                    <div class='card-body pt-3 text-right'>
                                        <span class='' style="font-size:22px">&nbsp바 코 드</span>
                                    </div>
                                </div>
                                <div class='col-8'>
                                    <div class='card-body p-0 pl-0'>
                                        <input class="form-control" style="height:80px;">
                                    </div>
                                </div>
                            </div>
                       </div>-->

                    </div>
                </div>
                <div class="card widget-inline m-2">
                    <div class='card-body row p-0'>
                        <div class="col-4">
                            <div class='card-body p-2'>
                                <i class='mdi mdi-hammer tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제품명</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success tot-line-prdctn-nm' id='prdctnProductNm'>
                                        3CE MULTI EYE COLOR PALETTE #OVERTAKE #1
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-2'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-hammer tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조기기</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success tot-line-prdctn-nm' id='prdctnProductNm'>
                                        레이덱스 제조
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-1'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-pencil-box tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조번호</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success' id='planOuttrn'>
                                        KA22009
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-1'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-pencil-box-outline tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조일</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success' id='outtrnData'>
                                        2021.03,01
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-1'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp이론량</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success' id='outtrnPercent'>
                                        50,000 (G)
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-1'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp실제조량</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success' id='outtrnPercent'>
                                        52,000 (G)
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class='col-2'>
                            <div class='card-body p-2'>
                                <i class='mdi mdi-cup tot-line-icon'></i>
                                <span class='tot-line-font'>&nbsp제조자</span>
                                <div class='text-center'>
                                    <span class='tot-line-contents text-success' id='outtrnPercent'>
                                        김 의 중
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">

                <div class="col-7 p-0">
                    <div class="row">
                        <div class="col-6 " style="display: none">
                            <div class="card">
                                <div class="card-body">
                                    <h4>RPM</h4>
                                    <hr class="mt-1 mb-1" />
                                    <div class="row">
                                        <div class="col-4">
                                            <button id="btn_01" type="button" style="width: 100%; height: 60px;" class="btn btn-outline-info">
                                                <span style="font-size:33px;">1,200</span>
                                            </button>
                                        </div>
                                        <div class="col-4">
                                            <button id="btn_02" type="button" style="width: 100%; height: 60px;" class="btn btn-outline-info">
                                                <span style="font-size:33px;">700</span>
                                            </button>
                                        </div>
                                        <div class="col-4">
                                            <button id="btn_03" type="button" style="width: 100%; height: 60px;" class="btn btn-outline-info">
                                                <span style="font-size:33px;">300</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4 pl-4 pr-0">
                            <div class="card mb-2">
                                <div class="card-body pt-1 pb-2">
                                    <h4>RPM</h4>
                                    <hr class="mt-1 mb-1" />
                                    <div class="row">
                                        <!--<div class="col-3 pr-0 text-right">
                                            <button id="rpm_plus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">+</span>
                                            </button>
                                        </div>-->
                                        <div class="col-12 pt-1">
                                            <input id="rpm_num" class="form-control text-center" type="number" style="height:50px;font-size:35px" value=120>
                                        </div>
                                        <!--<div class="col-3 pl-0">
                                            <button id="rpm_minus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">-</span>
                                            </button>
                                        </div>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4 ">
                            <div class="card mb-2">
                                <div class="card-body pt-1 pb-2">
                                    <h4>시간(초)</h4>
                                    <hr class="mt-1 mb-1" />
                                    <div class="row">
                                        <!--<div class="col-3 pr-0 text-right">
                                            <button id="plus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">+</span>
                                            </button>
                                        </div>-->
                                        <div class="col-12 pt-1">
                                            <input id="sec_time" class="form-control text-center" type="number" style="height:50px;font-size:35px" value=120>
                                        </div>
                                        <!--<div class="col-3 pl-0">
                                            <button id="minus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">-</span>
                                            </button>
                                        </div>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4 pl-0">
                            <div class="card mb-2">
                                <div class="card-body pt-1 pb-2">
                                    <h4>파우더 색소(#7 용량)</h4>
                                    <hr class="mt-1 mb-1" />
                                    <div class="row">
                                        <!--<div class="col-3 pr-0 text-right">
                                            <button id="plus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">+</span>
                                            </button>
                                        </div>-->
                                        <div class="col-12 pt-1">
                                            <input id="pa_qty" class="form-control text-center" type="number" style="height:50px;font-size:35px" value=120>
                                        </div>
                                        <!--<div class="col-3 pl-0">
                                            <button id="minus" class="btn btn-primary" style="height:60px;width:70px;">
                                                <span style="font-size:33px;">-</span>
                                            </button>
                                        </div>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 pl-4">
                            <div class="card mb-2" style="height: 650px;">
                                <div class="card-body pt-1 pb-1">
                                    <div style="display: inline-block">
                                        <h4>제조지시 및 공정기록</h4>
                                    </div>
                                    <hr class="mt-1 mb-1" />
                                    <table id="dtVerticalScrollExample" class="table table-striped table-bordered table-sm" id="test_table" cellspacing="0" open-value="off" width="100%">
                                        <thead>
                                            <tr style="font-size:16px">
                                                <th>NO.</th>
                                                <th>원료코드</th>
                                                <th>시험번호</th>
                                                <th>원료명</th>
                                                <th>단위</th>
                                                <th>함량(%)</th>
                                                <th>이론량(g)</th>
                                                <th>계량량(g)</th>
                                            </tr>
                                        </thead>
                                        <tbody style="font-size:22px;">
                                            <tr>
                                                <td>10</td>
                                                <td>6007563</td>
                                                <td>SIE20012</td>
                                                <td>Talc FM SSA</td>
                                                <td>G</td>
                                                <td>27.600</td>
                                                <td>13,800.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr>
                                                <td>20</td>
                                                <td>6020325</td>
                                                <td>SIE20011</td>
                                                <td>Sericite J</td>
                                                <td>G</td>
                                                <td>30.000</td>
                                                <td>15,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr>
                                                <td>30</td>
                                                <td>6910237</td>
                                                <td>SIE17010</td>
                                                <td>SI-2 MICA MK-200</td>
                                                <td>G</td>
                                                <td>10.000</td>
                                                <td>5,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr>
                                                <td>40</td>
                                                <td>6005577</td>
                                                <td>SIE17005</td>
                                                <td>ORGASOL® 2002 EXD Nat COS Type S</td>
                                                <td>G</td>
                                                <td>10.000</td>
                                                <td>5,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr class="off">
                                                <td>50</td>
                                                <td>6002807</td>
                                                <td>SIB13002</td>
                                                <td>Boron Nitride Powders</td>
                                                <td>G</td>
                                                <td>6.000</td>
                                                <td>3,000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr class="off">
                                                <td>60</td>
                                                <td>6007097</td>
                                                <td>SIE03001</td>
                                                <td>KSP-101</td>
                                                <td>G</td>
                                                <td>2.000</td>
                                                <td>1,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr class="off">
                                                <td>70</td>
                                                <td>6000246</td>
                                                <td>SIE09008</td>
                                                <td>Magnesium Myristate</td>
                                                <td>G</td>
                                                <td>2.000</td>
                                                <td>1,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>
                                            <tr class="off">
                                                <td>80</td>
                                                <td>6004009</td>
                                                <td>SID18007</td>
                                                <td>Titanium Dioxide SS</td>
                                                <td>G</td>
                                                <td>2.000</td>
                                                <td>1,000.000</td>
                                                <td class="p-1"><input type="number" style="height: 45px" class="form-control gr-ctr" readonly></td>
                                            </tr>


                                        </tbody>
                                    </table>



                                    <div class="row text-center">
                                        <div class="col-12 pt-2">
                                            <button id="ck_table" class="btn btn-rounded btn-outline-primary" style="font-size: 26px;">
                                                <span style="font-size: 33px;">+</span>
                                                더 보 기 &nbsp;
                                            </button>
                                        </div>


                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
                <div class="col-xl-5 pr-3">
                    <div class="card mb-1">
                        <div class="card-body pt-1 pb-2">


                            <h4>제조 표준 공정</h4>

                            <hr class="mt-1 mb-2" />

                            <div class="row">
                                <textarea class="form-control" name="" id="" cols="100" rows="24" readonly style="font-size:17px">
┬① 원료투입 및 1차혼합
│1) 헨셀믹서에 10~120번 원료 투입
│2) 저속 500±50rpm 30초, 고속 1200±50rpm 30초 혼합
│
├┬② 바인더투입 및 2차 혼합
││1) 130번~200번 원료를 바인더용기에 투입하여 75±5℃가온
││2) 완전용해된 바인더를 헨셀믹서에 투입 후 저속 500±50rpm 30초 혼합
││3) 기벽에 붙은 뭉친 바인더를 긁어내주어 고속 1200±50rpm 30초 혼합
││
││표준품과 비교하여 외색 및 발색 확인
││품질관리팀에 품질검사의뢰
┘│적합판정시 반제품 샘플채취 후, 저장용기에 내용물 배출
┐│여과실에 운반하여 30메쉬망에 여과 1회
││반제품 창고에 운반하여 지정된 위치에 저장
││
├┘
│
│
│
┘
                            </textarea>
                                <!--<div class="col pl-3" style="height: 710px; font-size: 23px;">

                                    1.원료 투입 및 1차혼합
                                    <br>
                                    <ul>
                                        <li>헨셀믹서에 10~120번 원료 투입</li>
                                        <li>wlthr 500 +_50게ㅡ 30초, rhthr 120+_rpm 30초 혼합</li>
                                    </ul>
                                </div>-->
                                <!-- end col -->
                            </div> <!-- end row-->
                        </div> <!-- end card-body -->
                    </div> <!-- end card-->
                    <div class="row">
                        <div class="col-8 pr-0">
                            <div class="card mb-1">
                                <div class="card-body pt-2 pb-2">
                                    <div class="row">
                                        <textarea class="form-control" name="" id="" cols="100" rows="2" readonly style="font-size:17px">파우더 색소(#7 포함)고1 / 고1 / 바중50 / 고30 / 펄저 15
                                        </textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4 pl-0">
                            <div class="card mb-1">
                                <div class="card-body p-2">
                                    <button class="btn btn-block btn-primary" style="height:65px;font-size:25px">이 력 등 록</button>
                                </div>
                            </div>

                        </div>
                    </div>

                </div> <!-- end col -->


            </div>

        </main>
        <!-- end page title -->
    </div>







    <!-- bundle -->
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- <script src="assets/js/vendor/Chart.bundle.min.js"></script> -->
    <script src="assets/js/vendor/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->
    <script src="assets/js/pages/demo.dashboard-analytics.js"></script>
    <script src="assets/js/clock/flipclock.js"></script>
    <!-- end demo js-->
    <script src="assets/js/timepicki/timepicki.js"></script>

    <script src="assets/js/datatables/datatables.min.js"></script>
    <script src="assets/js/datatables/dataTables.bootstrap4.min.js"></script>
    <script src="assets/js/vendor/dataTables.responsive.min.js"></script>
    <script src="assets/js/vendor/dataTables.buttons.min.js"></script>
    <script type = "text/javascript" charset = "utf-8" >

        $(document).ready(function() {

            $('#dtVerticalScrollExample').DataTable({
                "scrollY": "440px",
                "scrollCollapse": true,
            });

            $("#rpm_num, #sec_time, #pa_qty").click(function(){
                openPopup($(this).attr("id"));
            });

            $("#open").click(function() {
                $("#rowsNone").show();
            });
            $("#close").click(function() {
                $("#rowsNone").hide();
            });
            $("#plus").click(function() {

                var num = $("#secTime").val();

                if (!$.isNumeric(num)) {
                    num = 0;
                }

                $("#secTime").val(num * 1 + 1);
            });
            $("#minus").click(function() {

                var num = $("#secTime").val();

                if (!$.isNumeric(num)) {
                    num = 0;
                }

                $("#secTime").val(num * 1 - 1);
            });

            $("#btn_01, #btn_02, #btn_03").click(function() {

                var id = $(this).attr("id");


                $("#btn_01, #btn_02, #btn_03").removeClass("btn-outline-info");

                $("#btn_01, #btn_02, #btn_03").removeClass("btn-info");
                $("#btn_01, #btn_02, #btn_03").addClass("btn-outline-info");

                $(this).removeClass("btn-outline-info");
                $(this).addClass("btn-info");
            });

            $("#ck_table").click(function() {
                var open = $("#dtVerticalScrollExample").attr("open-value");

                if (open == "on") {
                    $("tr.off").hide();
                    $("#dtVerticalScrollExample").attr("open-value", "off");
                    $(this).text("+ 더 보 기");
                } else {
                    $("tr.off").show();
                    $("#dtVerticalScrollExample").attr("open-value", "on");
                    $(this).text("- 접 기");

                }
            });

            function openPopup(isPop){

                var popup = "";

                switch(isPop){
                    case "rpm_pop":
                        popup = "";
                        break;
                    case "sec_pop":
                        popup = "";
                        break;
                    case "qty_pop":
                        popup = "";
                        break;
                    default:
                        break;

                }
                window.open('./test_pop.html', 'popup', 'width=330px,height=530px,scrollbars=yes');
            }

            $(".dataTables_info, .pagination, .dataTables_length, .dataTables_filter").hide();
        });


    </script>
</body></html>