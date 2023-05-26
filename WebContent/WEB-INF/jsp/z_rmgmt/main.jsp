<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
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

    <style>
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
            font-size: 20px;
            /*display: block;*/
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        tr.off {
            display: none;
        }
        td {
            font-size: 20px;
        }
    </style>

</head>

<body><body>
    <div class="container-fluid">
        <main>
            <div class="main-tot-aggr">
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
                <div class="card widget-inline m-2">
                    <div class='card-body row p-0'>        
                        <div class="col-4">
                            <div class='card-body p-2'>
                                <a href="javascript:openPopList();">
                                    <i class='mdi mdi-hammer tot-line-icon'></i>
                                    <span class='tot-line-font'>&nbsp제품명</span>
                                    <div class='text-center'>
                                        <span class='tot-line-contents text-success tot-line-prdctn-nm' id='prdctnProductNm'>
                                            3CE MULTI EYE COLOR PALETTE #OVERTAKE #1
                                        </span>
                                    </div>    
                                </a>
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
                <div class="col-xl-4 pl-3">
                    <div class="card mb-1">
                        <div class="card-body pt-1 pb-2">
                            <h4>제조 표준 공정</h4>
                            <hr class="mt-1 mb-2" />
                            <div class="row">
                                <textarea class="form-control" name="" id="" cols="100" rows="28" readonly style="font-size:17px"></textarea>
                            </div> <!-- end row-->
                        </div> <!-- end card-body -->
                    </div> <!-- end card-->
                </div> <!-- end col -->
                <div class="col-8 p-0">
                   <div class="row">
                      <div class="col-12 pr-4">
                           <ul class="nav nav-tabs mb-0">
                                <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="false" class="nav-link active">
                                        <i class="mdi mdi-home-variant d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_0">제조이력</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="true" class="nav-link">
                                        <i class="mdi mdi-account-circle d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_1">&nbsp;1공정&nbsp;</span>
                                    </a>
                                </li>
                               <!--  <li class="nav-item">
                                    <a onClick="" data-toggle="tab" aria-expanded="false" class="nav-link">
                                        <i class="mdi mdi-settings-outline d-md-none d-block"></i>
                                        <span class="d-none d-md-block tab-hist" id="tab_pbl_change_span_2">&nbsp;2공정&nbsp;</span>
                                        
                                    </a>
                                </li> -->
                                 <li class="nav-item">
                                    <div data-toggle="tab" aria-expanded="false" class="">
                                        <button class="btn btn-sucess">
                                        <span class="text-warning d-none d-md-block tab-hist" >&nbsp; + &nbsp;</span>    
                                        </button>
                                        
                                        
                                    </div>
                                </li>
                                
                            </ul>   
                      </div>
                       
                   </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="row" id="pbl-2">
                                <div class="col-2 pr-0">
                                    <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4>RPM</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="rpm_num" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2">
                                    <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4>시간(초)</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="sec_time" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2 pl-0">
	                                <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4 >파우더 색소(#7 용량)</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="pop_pa_qty" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
	                                </div>
	                            </div>
                                <div class="col-2 pl-0">
                                    <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4>바인더</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="pa_qty" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2 pl-0">
                                    <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4>펄</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="pa_qty" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2 pr-4 pl-0">
                                    <div class="card mb-2">
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4>분쇄도</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <select class="form-control" style="height:50px;font-size:30px;text-align: center;">

                                                        <option value="AK">없 음</option>
                                                        <option value="AK">7.5마력</option>
                                                        <option value="HI">10마력</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-12 pr-4">
                            <div class="card mb-2" style="height: 496px;">
                                <div class="card-body pt-1 pb-1">
                                    <div style="display: inline-block">
                                        <h4>제조지시 및 공정기록</h4>
                                    </div>
                                    <hr class="mt-1 mb-1" />
                                    <table id="tRmgHist" class="table table-hover table-bordered nowrap" style="width:100%">
									</table>
									
									<div class="row text-center">
                                        <div class="col-12 pt-2">
                                            <button id="ck_table" class="btn btn-block btn-primary" style="font-size: 26px;">
                                                <span style="font-size: 33px;">+</span>
                                                더 보 기 &nbsp;
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-9 pr-0">
                            <div class="card mb-1">
                                <div class="card-body pt-2 pb-2 pl-4">
                                    <div class="row">
                                        <input type="text" class="form-control text-center" readonly style="font-size:20px;height:65px;line-height:65px;" value="파우더 색소(#7 포함)고1 / 고1 / 바중50 / 고30 / 펄저 15">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-3 pr-4">
                            <div class="card mb-1">
                                <div class="card-body p-2">
                                    <button class="btn btn-block btn-primary" style="height:65px;font-size:35px">이 력 등 록</button>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </div>

        </main>
        <!-- end page title -->
    </div>
    
    <!-- 제조이력 조회 진행 -->
    <div id="listpop" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="listpop002Header" aria-hidden="true">
        <div class="modal-dialog modal-full-width">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="standard-modalLabel"><span id="titlistpop"></span>제조이력 조회</h4>
                    <button type="button" class="close" name="listpopClose" data-dismiss="modal" aria-hidden="true"><span style="font-size: 50px;">x</span></button>
                </div>
                <div class="pb-2">

                </div>
                <div class="row">
                    <div class="col-4  find-pbl-procs-line pb-2 pl-3 pr-0">
                        <input type="text" class="" id="popInputbox" style="height: 60px;width: 100%" autocomplete="off">
                    </div>
                    <div class="col-1 text-right pl-0">
                        <button style="height: 60px;font-size: 35px;" type="button" class="btn btn-primary btn-block" id="BtnFindProducIng2">
                            <i class="mdi mdi-table-search"></i>
                        </button> 
                    </div>

                </div>
                <div class="row">
                    <div class="col-6">
                        <div class="card">
                            <div class="card-body">
                                <table id="tbPopList" class="table table-striped table-sm mb-0" id="test_table" width="100%">
                                <thead>
                                    <tr style="font-size:16px">
                                        <th>제조일자</th>
                                        <th>제조기기</th>
                                        <th>제조번호</th>
                                        <th>이론량</th>
                                        <th>실제조량</th>
                                        <th>제조이력</th>
                                        <th>제조자</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="text-align:center;">2021.02.28</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.27</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.26</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.25</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.24</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.24</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center;">2021.02.24</td>
                                        <td>Mixer 300L</td>
                                        <td>KA22008</td>
                                        <td style="text-align:right;">50.000(G)</td>
                                        <td style="text-align:right;">52.000(G)</td>
                                        <td >파우더색소(#7포함)/고1/고1/고30/<span class="text-danger">펄저15</span></td>
                                        <td>김의중</td>
                                    </tr>
                                    


                                </tbody>
                            </table>
                            <div class="text-center pt-1">
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&lt;&lt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&lt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>1 / 200</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&gt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&gt;&gt;</span>
                                </button>
                            </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card">
                            <div class="card-body">
                                <table id="tbPopList2" class="table table-striped table-sm mb-0" id="test_table" width="100%">
                                <thead>
                                    <tr style="font-size:16px">
                                        <th>공정</th>
                                        <th>제조이력</th>
                                        <th>원료코드</th>
                                        <th>원료명</th>
                                        <th>이론량</th>
                                        <th>계획량</th>
                                        

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                    <tr>
                                        <td>1공정</td>
                                        <td>고12</td>
                                        <td>KA22008</td>
                                        <td>Titanium Dioxide SS</td>
                                        <td>20,000 (G)</td>
                                        <td>21,000 (G)</td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="text-center pt-1">
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&lt;&lt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&lt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>1 / 200</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&gt;</span>
                                </button>
                                &nbsp;
                                <button style="height:50px;width:0px; font-size:23px" type="button" class="btn btn-primary ">
                                    <span>&gt;&gt;</span>
                                </button>
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <div class="col-2 text-right pr-0 pl-3">
                        <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="listpopClose" data-dismiss="modal">
                            
                            <span>확 인</span>
                        </button>
                    </div>
                    <div class="col-2 text-right pr-0 pl-3">
                        <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="listpopClose" data-dismiss="modal">
                            
                            <span>닫 기</span>
                        </button>
                    </div>
                    
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!-- 제조이력 조회 진행 End-->
    
    <!-- 계산기 버튼 -->
    <div id="popCals" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="popCalsHeader" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="standard-modalLabel"><span id="titlistpop">제조이력 Setting</span></h4>
                    <button type="button" class="close" name="popCalsClose" data-dismiss="modal" aria-hidden="true"><span style="font-size: 50px;">x</span></button>
                    
                </div>
                <div class="pb-2">

                </div>
                <div class="row">
                    <div class="col-12 pl-4 pr-0">
                       <div class="row">
                           <div class="col-3 pl-0">
                                <div class="card mb-2">
                                   <div class="card-body pt-1 pb-2 pr-1 pl-1">
                                    <h4>RPM</h4>
                                        <hr class="mt-1 mb-1" />
                                        <div class="row">
                                            <div class="col-12 pt-1">
                                                <input id="pop_rpm_num" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-2 pl-0">
                                <div class="card mb-2">
                                    <div class="card-body pt-1 pb-2 pr-1 pl-1">
                                        <h4>시간(초)</h4>
                                        <hr class="mt-1 mb-1" />
                                        <div class="row">
                                            <div class="col-12 pt-1">
                                                <input id="pop_sec_time" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=60>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-2 pl-0">
                                <div class="card mb-2">
                                    
                                        <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                            <h4 >바인더</h4>
                                            <hr class="mt-1 mb-1" />
                                            <div class="row">
                                                <div class="col-12 pt-1">
                                                    <input id="pop_pa_qty" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                                </div>
                                            </div>
                                        </div>
                                    

                                </div>

                            </div>
                            <div class="col-2 pl-0">
                                <div class="card mb-2">
                                     <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                         <h4 >펄</h4>
                                         <hr class="mt-1 mb-1" />
                                         <div class="row">
                                             <div class="col-12 pt-1">
                                                 <input id="pop_pa_qty" class="form-control text-center" readonly type="number" style="height:50px;font-size:35px" value=0>
                                             </div>
                                         </div>
                                     </div>
                                </div>

                            </div>
                            <div class="col-3 pr-4 pl-0">
                                <div class="card mb-2">
                                    <div class="card-body pt-1 pb-2 pl-1 pr-1">
                                        <h4>분쇄도</h4>
	                                    <hr class="mt-1 mb-1" />
	                                    <div class="row">
	                                        <div class="col-12 pt-1">
	                                            <select class="form-control" style="height:50px;font-size:30px;text-align: center;">
	                                                <option value="AK">없 음</option>
	                                                <option value="AK">7.5마력</option>
	                                                <option value="HI">10마력</option>
	                                            </select>
	                                        </div>
	                                    </div>
                                    </div>
                                </div>
                           </div>
                       </div>
                   </div>
                    <div class="col-12  find-pbl-procs-line pb-2 pl-3 pr-3">
                       <div class="row">
                           <div class="col-12">
                              <div class="card mb-2">
                                  <div class="card-body pt-2 pb-2 pr-1 pl-1">
                                      <input type="text" class="" id="popCalsInputbox" style="height: 60px;width:100%" autocomplete="off">
                                  </div>
                              </div>
                           </div>
                           <div class="col-12">
                               <div class="card mb-2">
                                   <div class="card-body pt-2 pb-2">
                                       <div class="row">
                                           <div class="col-12">
                                               <div class="row" id="pop_comm_rpm" style="display: none;">
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">1,200 rpm</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">750 rpm</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">450 rpm</button></div>
                                                </div>
                                                <div class="row" id="pop_comm_sec">
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">10</button></div>
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">20</button></div>
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">30</button></div>
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">40</button></div>
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">50</button></div>
                                                    <div class="col-2"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-info">60</button></div>
                                                </div>
                                           </div>
                                       </div>
                                   </div>
                               </div>
                           </div>
                           <div class="col-12">
                               <div class="card mb-0">
            
                                    <div class="card-body pb-0 pt-0 pl-1 pr-1">
                                       <div class="row">
                                           <div class="col-9 pl-0">
                                               <div class="row p-2">
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">1</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">2</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block btn-outline-dark">3</button></div>
                                                </div>
                                                <div class="row p-2">
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">4</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">5</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">6</button></div>
                                                </div>
                                                <div class="row p-2">
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">7</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">8</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">9</button></div>
                                                </div>
                                                <div class="row p-2">
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">←</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">0</button></div>
                                                    <div class="col-4"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-dark">.</button></div>
                                                </div>
                                           </div>
                                           <div class="col-3">
                                               <div class="row p-2">
                                                   <div class="col-12 pr-0"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-primary">Clear</button></div>
                                               </div>
                                               <div class="row p-2">
                                                   <div class="col-12 pr-0"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-success">G</button></div>
                                               </div>
                                              
                                               <div class="row p-2">
                                                   <div class="col-12 pr-0"><button style="height: 70px;font-size: 30px;" class="btn btn-block  btn-outline-success">%</button></div>
                                               </div>

                                           </div>
                                       </div>

                                    </div>
                                </div>
                           </div>
                       </div>
                        
                    </div>
                    <div class="col-4">
                        
                    </div>
                    

                </div>
                
                
                <div class="modal-footer pt-2">
                    <div class="col-3 text-right pr-0 pl-3">
                        <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="listpopClose" data-dismiss="modal">
                            
                            <span>확 인</span>
                        </button>
                    </div>
                    <div class="col-3 text-right pr-0 pl-3">
                        <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="listpopClose" data-dismiss="modal">
                            
                            <span>닫 기</span>
                        </button>
                    </div>
                    
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

     <!-- 내용물 조회 -->
    <div id="listpop2" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="listpop2Header" aria-hidden="true">
        <div class="modal-dialog modal-full-width modal-right">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="standard-modalLabel"><span id="titlistpop2"></span>내용물 조회</h4>
                    <button type="button" class="close" name="listpopClose" data-dismiss="modal" aria-hidden="true"><span style="font-size: 50px;">x</span></button>
                </div>
                <div class="pb-2">

                </div>
                
                <div class="modal-body pr-2 pl-2 pb-1">
                    <table id="tb_hist_list" class="table table-striped table-sm mb-0" id="test_table" width="100%">
                        <thead>
                            <tr style="font-size:16px">
                                <th>제조일자</th>
                                <th>제조번호</th>
                                <th>원료코드</th>
                                <th>원료명</th>
                                <th>이론량</th>
                                <th>계획량</th>
                                
                                
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                            <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                            <tr>
                               <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                            <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                            <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                             <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                             <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                             <tr>
                                <td style="text-align:center;">2021.02.28</td>
                                <td>KA22008</td>
                                <td>6007563</td>
                                <td>Talc FM SSA</td>
                                <td style="text-align:right;">50.000(G)</td>
                                <td style="text-align:right;">52.000(G)</td>
                            </tr>
                            
                        </tbody>
                    </table>
                    <div class="text-center pt-1">
                        <button style="height:70px;width:150px; font-size:35px" type="button" class="btn btn-primary ">
                            <span>&lt;&lt;</span>
                        </button>
                        &nbsp;
                        <button style="height:70px;width:150px; font-size:35px" type="button" class="btn btn-primary ">
                            <span>&lt;</span>
                        </button>
                        &nbsp;
                        <button style="height:70px;width:150px; font-size:35px" type="button" class="btn btn-primary ">
                            <span>1 / 5</span>
                        </button>
                        &nbsp;
                        <button style="height:70px;width:150px; font-size:35px" type="button" class="btn btn-primary ">
                            <span>&gt;</span>
                        </button>
                        &nbsp;
                        <button style="height:70px;width:150px; font-size:35px" type="button" class="btn btn-primary ">
                            <span>&gt;&gt;</span>
                        </button>
                    </div>
                </div>
                <div class="modal-footer">
                    
                    <div class="col-2 text-right pr-0 pl-3">
                        <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block" name="listpopClose" data-dismiss="modal">
                            
                            <span>닫 기</span>
                        </button>
                    </div>
                    
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- bundle -->
    <script src="<c:url value='/resources/z_rmgmt/assets/js/vendor.min.js' />"></script>
    <script src="<c:url value='/resources/z_rmgmt/assets/js/app.min.js' />"></script>

    <!-- third party js ends -->

    
    <script src="<c:url value='/resources/z_rmgmt/assets/js/timepicki/timepicki.js' />"></script>

    <script src="<c:url value='/resources/z_rmgmt/assets/js/datatables/datatables.min.js' />"></script>
    <script src="<c:url value='/resources/z_rmgmt/assets/js/datatables/dataTables.bootstrap4.min.js' />"></script>
    
    <script type="text/javascript" chartset="utf-8">
    /********** 전역 
     **************************************************/
 	
        	
 	$(document).ready(function () {
 		/********** 이벤트 함수 정의.
    	 **************************************************/ 		
 		
 	    
 	    fnInit();
 	})
 	
 	/********** 초기화.
     **************************************************/
 	function fnInit() {
 		$("#tRmgHist").DataTable({
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
	        select      : true,
	        paging      : true,
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
	        /* scrollY 	: "450px", */
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
	            { title: "no",		data : "SEQ",					width:"10%" },
	            { title: "원료코드",   	data : "CHILD_ITEM_CD",			width:"15%" },
	            { title: "시험번호",	data : "LOT_NO",				width:"15%" },
	            { title: "원료명",	    data : "CHILD_ITEM_NM",			width:"15%" },
	            { title: "단위",		data : "STOCK_UNIT",			width:"10%" },
	            { title: "함량(%)",	data : "UNIT_Q",				width:"10%" },
	            { title: "이론량(g)",	data : "ALLOCK_Q",				width:"10%" },
	            { title: "계량량(g)",	data : "PRODT_Q",				width:"10%" },
	            { title: "상세",		data : "btn_search",			width:"10%" },
	            { title: "사업장",		data : "DIV_CODE",				width:"0%" },
	            { title: "작업지시번호",	data : "WKORD_NUM",				width:"0%" },
	            { title: "공정코드",	data : "PROG_WORK_CODE",		width:"0%" },
	            { title: "공정차수",	data : "WKORD_NUM_SEQ",			width:"0%" },
	            { title: "제품코드",	data : "ITEM_CODE",				width:"0%" },
	        ],
			
	        columnDefs: [
	        	{
	        		targets: [0,1,2,3,4,5,6,7,8,9],
	        		orderable: true,
	        		className: "text-center"
	        	},{
	        		targets:[9,10,11,12,13],
	        		visible: false
	        	}
	        	
	        ],
	        drawCallback: function () {
	        }
	    });
 	}
        	
 	/********** 유효성 검사. 공통으로 다 뺄 함수.
     **************************************************/
    function fnValidate() {
 		
    }
 	
 	
 	
 	
    /********** 사용자 정의 함수.
     **************************************************/
    function fn_barcode_scan(){
    	
    	
    }
     
    </script>
    
    
</body>
</html>
