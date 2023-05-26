<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>

	table#tbProdHistory tr {
		/* height: 60px; */
	}

	table#tbChildHistory tr td,
	table#tbProdHistory tr td {
		/* font-size : 18px;
		
		padding-top: 0;
		padding-bottom: 0;  */
		height: 30px;
   		white-space: normal;
		/* font-size: 17px; */
		
		vertical-align: middle; 
		display: table-cell;
	}
	
	table#tbChildHistory tr td.chlid-hist-qty {
		font-size : 20px;
	}
	
	.pop-hist-label {
		font-size : 20px;
		line-height: 43px
	}
	.pop-hist-label-text {
		font-size : 23px;
		line-height: 58px
	}
	/* datepicker */
	.datepicker-days td,
	.datepicker-days th {
		width: 80px;
		height: 80px;
		font-size: 35px;
	}
	
	.datepicker-months td,
	.datepicker-months th {
		width: 180px;
		height: 100px;
		font-size: 35px;
	}
	.datepicker-years td,
	.datepicker-years th,
	.datepicker-decades td,
	.datepicker-decades th{
		width: 180px;
		height: 100px;
		font-size: 35px;
	}
	.datepicker .datepicker-switch {
		width: 190px;
	}
	

</style>    
<!-- 제조이력 조회 진행 -->
<div id="rmgmtPopHist" class="modal fade p-0" tabindex="-1" role="dialog" aria-labelledby="rmgmtPopHistHeader" aria-hidden="true">
    <div class="modal-dialog modal-full-width">
        <div class="modal-content">
            <div class="modal-header mb-0 pb-0">
                <h4 class="modal-title" id="standard-modalLabel"><span id="titlistpop"></span>제조이력 조회</h4>
                <button type="button" class="close" name="listpopClose" data-dismiss="modal" aria-hidden="true"><span style="font-size: 50px;">x</span></button>
            </div>
            <div class="row">
            	<div class="col-12">
	            	<div class="card mr-2 ml-2 mt-1 mb-1">
	            		<div class="card-body p-2">
	            			<div class="row">
	            				<div class="col-xl-4 col-md-6">
	            					<div class="row">
				                        <label for="popHistSearchDt" class="col-3 col-form-label pop-hist-label">제조일자</label>
				                        <div class="col-9">
				                            <div class="row pr-2 pl-2">
				                                <input type="text" id="popHistSearchDtFr" class="col-5 m-0 form-control from-date text-center" autocomplete="off" style="height:60px;font-size:22px;text-align: center;">
				                                <div class="col-lg-1 col-2 pl-1 pr-1 text-center pop-hist-label" style="font-size: 25px;">~</div>
				                                <input type="text" id="popHistSearchDtTo" class="col-5 m-0 form-control to-date text-center" autocomplete="off" style="height:60px;font-size:22px;text-align: center;">
				                            </div>
				                        </div>
				                    </div>
	            				</div>	
	            				<div class="col-xl-4 col-md-6">
	            					<div class="row">
				                        <label for="popHistSearchPrsn" class="col-3 col-form-label pop-hist-label">작업자</label>
				                        <div class="col-9">
				                        	<select id="popHistSearchPrsn" class="form-control text-center" style="height:60px;font-size:25px;text-align: center;">
												<option value=""></option>
												<c:forEach items="${P505 }" var="ls" varStatus="i">
													<option value="${ls.CODE_CD }">${ls.CODE_NM }</option>
												</c:forEach>
											</select>
				                        </div>
				                        
				                    </div>
	            				</div>
	            				<div class="col-xl-2 col-md-8 col-6"></div>
	            				<div class="col-xl-2 col-md-4 col-6">
									 <button id="btnPopHistSearch" style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block">
				                        <i class="mdi mdi-table-search"></i>
				                        <span>조 회</span>
				                    </button>
	            				</div>
	            			</div>
	            		</div>
	            	</div>
            	</div>
            	
                

            </div>
            <div class="row">
            	<div class="col-12">
            		<div class="card ml-2 mr-2 mb-1">
            			<div class="card-body p-2 pt-1 pb-1">
            				<div class="row">
            					<div class="col-xl-4">
	            					<div class="row">
				                        <label for="" class="col-xl-3 col-3 col-form-label pop-hist-label">제조기기</label>
				                        <div class="col-xl-9 col-9">
                                            <select id="selPopHistEqu" class="form-control text-center" style="height:60px;font-size:25px;text-align:center;">
												<option value=""></option>
												<c:forEach items="${EQU }" var="ls" varStatus="i">
													<option value="${ls.EQU_CODE }">${ls.EQU_NAME }</option>
												</c:forEach>
                                            </select>
                                        </div>
				                    </div>
	            				</div>	
            					<div class="col-xl-5">
	            					<div class="row">
				                        <label for="" class="col-xl-2 col-3 col-form-label pop-hist-label">제품명</label>
				                        <label for="" id="lblPopHistItemNm" class="col-xl-10 col-9 col-form-label pop-hist-label-text text-success p-0"></label>
				                    </div>
	            				</div>
            					<div class="col-xl-3">
	            					<div class="row">
				                        <label for="" class="col-xl-4 col-3 col-form-label pop-hist-label">이론량</label>
				                        <label for="" id="lblPopHistWkordQ" class="col-xl-8 col-9 col-form-label pop-hist-label-text text-success p-0"></label>
				                    </div>
	            				</div>
            				</div>
            			</div>
            		</div>
            	</div>
            </div>
            <div class="mb-0" style="border-top: 1px solid #515c69"></div>
            <div class="row">
                <div class="col-6 pr-1">
                	<div class="card ml-2 mt-1 mb-0" style="height:520px;">
                		<div class="card-body p-1">
                			<div class="form-group">
		                    	<label for="" class="pop-hist-label mb-0"><i class="mdi mdi-arrow-right-drop-circle"></i>&nbsp 제조이력</label>
			                    <table id="tbProdHistory" class="table table-stripedtable-sm mb-0" width="100%">
			                    
			                	</table>
		                	</div>
                		</div>
                	</div>
                    
                </div>
                <div class="col-6 pl-1">
                    <div class="card mr-2 mt-1 mb-1" style="height:520px;">
                        <div class="card-body p-1">
                        	<ul class="nav nav-tabs mb-0" id="ulWkordSeqTab" style="border-bottom:none;">
                        	</ul>
                            <table id="tbChildHistory" class="table table-stripedtable-sm mb-0 mt-0" width="100%">
                            
                        	</table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="modal-footer">
             	<div class="col-2 text-right pr-0 pl-3">
                    <button id="btnPopHistBindMainHist" style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block">
                        
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

<script type="text/javascript" charset="utf-8">
/********** 전역 
 **************************************************/
 	var _glbRmgmtPopHist = {
			DIV_CODE 		: "", 
			ITEM_CODE		: "",
			ITEM_NAME		: "",
			EQU_CODE 		: "",
			EQU_NAME		: "",
			WKORD_Q			: ""
	};
 
 	var _boolSearch = false;
 
	$(document).ready(function () {
		/********** 이벤트 함수 정의.
    	**************************************************/
    	 $(document).on('click', '#tbProdHistory tbody tr', function () {
    		var table = $('#tbProdHistory').DataTable();
    		 
    		if ( $(this).hasClass('selected') ) {
   	            
   	        }
   	        else {
   	            table.$('tr.selected').removeClass('selected');
   	            $(this).addClass('selected');
   	            
   	         	fnGetWkordSeqTab(table.rows(this).data()[0]);
   	        }
   	    } );
    	
		$(document).on('click', '#btnPopHistBindMainHist', function(){
			 var table = $('#tbProdHistory').DataTable();
			 var selectedRowCnt = table.rows(table.$('tr.selected')).count();
			 
			 if(selectedRowCnt <= 0){
				 if(confirm("좌측 리스트에서 선택된 제조이력 데이터가 없습니다.\n제조이력 빠른찾기 화면을 닫으시겠습니까?")){
					
					 $("#rmgmtPopHist").modal("hide"); 
				 }
			 }else{
				 var selectedRow = table.rows(table.$('tr.selected')).data()[0];
				 // 해당 선택된 이력 상세 내용을 Main 제조이력 테이블에 바인딩
				 
				 fnPopupSearch(_glbRmgmtPopHist.DIV_CODE, selectedRow.WKORD_NUM, selectedRow.PROG_WORK_CODE);
				 
				 $("#rmgmtPopHist").modal("hide");
			 }
			 
		});
		
		$(document).on('click', '#btnPopHistSearch', function(){
			fnGetPrdtHistory();
		})
		
    	/********** Modal Open 이벤트. **********/
        $('#rmgmtPopHist').on('show.bs.modal', function (e) {
        	
        	setTimeout(function(){
        		$("#tbProdHistory").DataTable().columns.adjust().draw();
        		$("#tbChildHistory").DataTable().columns.adjust().draw();	
        	}, 200);
            
            
            $("#selPopHistEqu").val(_glbRmgmtPopHist.EQU_CODE);
            $("#lblPopHistItemNm").text(_glbRmgmtPopHist.ITEM_NAME);
            
            var sWkordQ = _glbRmgmtPopHist.WKORD_Q;
            sWkordQ = ObjUtil.isEmpty(sWkordQ) ? "" : StringUtil.formatNumber(sWkordQ) + "(G)";
            
            $("#lblPopHistWkordQ").text(sWkordQ);
            
         	// 제조이력 데이터 조회
         	if(!_boolSearch){
         		fnGetPrdtHistory();
         		_boolSearch = true;
         	}
            
            
        });
		
		/********** Modal Close 이벤트. **********/
		$('#rmgmtPopHist').on('hidden.bs.modal', function (e) {
			$("#tbProdHistory").DataTable().clear().draw();
			$("#tbChildHistory").DataTable().clear().draw();
			
			_boolSearch = false;
		});
		
		fnInitManufactureHistory();
	});
	
	/********** 초기화.
     **************************************************/
	function fnInitManufactureHistory(){
    	
		var date = new Date();
		var dateY = date.getFullYear();
		var dateM = date.getMonth();
		var dateD = date.getDate();
		
		$('.from-date').datepicker({
		    format: 'yyyy-mm-dd',
		    autoclose: 'true'
		}).datepicker("setDate", new Date(dateY, 0, 1));
		$('.to-date, .date-i').datepicker({
		    format: 'yyyy-mm-dd',
		    autoclose: 'true'
		}).datepicker("setDate", new Date(dateY, dateM, dateD));
		
		
		$('.from-date').datepicker()
		.on('changeDate', function(selected) {
			var startDate = new Date(selected.date.valueOf());
			$('.to-date').datepicker('setStartDate', startDate);
		}).on('clearDate', function(selected) {
			$('.to-date').datepicker('setStartDate', null);
		});
		
		$('.to-date').datepicker()
		.on('changeDate', function(selected) {
			var endDate = new Date(selected.date.valueOf());
			$('.from-date').datepicker('setEndDate', endDate);
		}).on('clearDate', function(selected) {
			$('.from-date').datepicker('setEndDate', null);
		});
		
		
		// 제조이력 테이블 생성
    	$("#tbProdHistory").DataTable({
    		dom : "" 
				/* + "<'hr'>" + "<'row'<'col-6'l><'col-6'f>>" */		
				+ "<'row'<'col-12'tr>>" //col-12
				+ "<'row'<'col-sm-6'i><'col-sm-6'p>>",
	        autoWidth 	: true,
	        select      : false,
	        paging      : false,
	        ordering    : true,
	        info        : false,
	        filter      : true,
	        lenghChange : true,
	        lengthChange: true,
	        order       : [],
	        stateSave   : false,
	        pagingType  : "full_numbers",
	        pageLength  : 10,
	        lengthMenu  : [5, 10, 25, 50, 100],
	        processing  : false,
	        serverside  : false,
	        scrollX		: false,
	        scrollY		: "366px",
	        scrollCollapse	: true,
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
	            { title: "제조일자"  , 	data : "PRODT_DATE"		, width:"15%"},
				{ title: "제조기기"  ,	data : "EQU_NAME"},
	            { title: "제조이력"  , 	data : "PROD_PROC"	    , width:"46%", name: "grp"},
	            { title: "제조번호"  , 	data : "LOT_NO"        	, width:"13%"},
	            { title: "이론량"   ,	data : "WKORD_Q"},
	            { title: "실제조량"  , 	data : "PRODT_Q"  		, width:"13%"},
	            { title: "제조자"   , 	data : "PRODT_PRSN_NM"  , width:"13%"},
	            { title: "작업지시번호", data : "WKORD_NUM"},
	            { title: "공정코드"	  , data : "PROG_WORK_CODE"}
	        ],columnDefs: [
	        	{	
	        		targets: 0,
   	                className: "text-center",
   	                render : function(data, type, row){
   	                	var html = "";
   	                	html += (ObjUtil.isEmpty(data)) ? "" : DateUtil.toString(data, "yyyy.MM.dd");
   	                	html += (ObjUtil.isEmpty(row.EQU_NAME)) ? "" : "<br/>(" + row.EQU_NAME + ")";
   	                	return html;
   	                }
   	            },{	
   	            	targets: 1,
   	                className: "text-center",
   	                visible: false
   	            },{	
   	            	targets: 2,
   	                className: "dt-head-center"
   	            },{	
   	            	targets: 3,
   	                className: "text-center"
   	            },{	
   	            	targets: 4,
   	                className: "text-center",
   	                visible: false,
					render : function(data, type, row){
	   	            	return StringUtil.formatNumber(data);
   	             	}
   	            },{	
   	            	targets: 5,
   	                className: "dt-head-center dt-body-right",
					render : function(data, type, row){
	   	            	return StringUtil.formatNumber(data);
   	             	}
   	            },{	
   	            	targets: 6,
   	                className: "text-center"
   	            },{
   	                targets : [7,8],
   	             	visible	: false
   	            }
   	        ]
	    });
    	
    	// 원료 이력 테이블 생성
    	$("#tbChildHistory").DataTable({
    		dom : "" 
				/* + "<'hr'>" + "<'row'<'col-6'l><'col-6'f>>" */		
				+ "<'row'<'col-12'tr>>" //col-12
				+ "<'row'<'col-sm-6'i><'col-sm-6'p>>",
	        autoWidth 	: true,
	        select      : false,
	        paging      : false,
	        ordering    : true,
	        info        : false,
	        filter      : true,
	        lenghChange : true,
	        lengthChange: true,
	        order       : [],
	        stateSave   : false,
	        pagingType  : "full_numbers",
	        pageLength  : 10,
	        lengthMenu  : [5, 10, 25, 50, 100],
	        processing  : false,
	        serverside  : false,
	        scrollX		: false,
	        scrollY		: "366px",
	        scrollCollapse	: true,
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
	            {   		 	title: "공정"	, 		data : "WKORD_NUM_SEQ_NM"	, width:"0%"},
				{ name:'grp', 	title: "제조이력"	,	data : "PROD_PROC"  		, width:"30%"},
	            { 				title: "원료코드"	,  	data : "CHILD_ITEM_CODE"	, width:"14%"},
	            { 				title: "원료명"	,  	data : "CHILD_ITEM_NM"      , width:"20%"},
	            { 				title: "이론량"	,  	data : "OUTSTOCK_REQ_Q"		, width:"12%"},
	            { 				title: "계량량(G)", 	data : "PRODT_Q_G"	    	, width:"12%"},
	            { 				title: "계량량(%)", 	data : "PRODT_Q_P"	    	, width:"12%"},
	            { 				title: "공정차수"	,  	data : "WKORD_NUM_SEQ"}
	            
	        ],
	        columnDefs: [
	        	{
	        		targets : 0,
	        		orderable: true,
	        		visible: false,
	        		className: "text-center"
	        	},{
	        		targets : 1,
	        		orderable: true,
	        		className: "dt-head-center",
	        		render : function(data, type, row){
	   	            	return data.replaceAll("\n", "<br/>");
   	             	}
	        	},{
	        		targets : 2,
	        		orderable: true,
	        		className: "text-center"
	        	},{
	        		targets : 3,
	        		orderable: true,
	        		className: "dt-head-center"
	        	},{
	        		targets : [4,5,6],
	        		orderable: true,
	        		className: "dt-head-center dt-body-right chlid-hist-qty ",
	        		render : function(data, type, row){
	        			
	        			return StringUtil.formatNumber(data);
	        		}
	        	},{
   	                targets : 7,
   	             	visible	: false
   	            }
   	        ],
   	     	rowsGroup: ['grp:name']
	    });
    }
 	
	/********** 유효성 검사.
     **************************************************/
    function fnValidateManufactureHistory() {
 		
    }
 	
 	
 	
 	
    /********** 사용자 정의 함수.
     **************************************************/
 	/* 제조이력 데이터 조회 */
	function fnGetPrdtHistory() {
 		
    	var dtFrom 	= $("#popHistSearchDtFr").val();
    	var dtTo 	= $("#popHistSearchDtTo").val();
    	
    	dtFrom 	= ObjUtil.isEmpty(dtFrom) 	? "" : DateUtil.toString(dtFrom, "yyyyMMdd");
    	dtTo 	= ObjUtil.isEmpty(dtTo) 	? "" : DateUtil.toString(dtTo, "yyyyMMdd");
    	
		var param = { "DIV_CODE"        : _glbRmgmtPopHist.DIV_CODE
				    , "PROD_ITEM_CODE"	: _glbRmgmtPopHist.ITEM_CODE
					, "EQU_CODE"     	: $("#selPopHistEqu").val()
					, "WKORD_Q"			: _glbRmgmtPopHist.WKORD_Q
					, "DT_FR"			: dtFrom
					, "DT_TO"			: dtTo
					, "PRODT_PRSN"		: $("#popHistSearchPrsn").val()};
		
		$.ajax({      
			url     : "${pageContext.request.contextPath}/z_rmgmt/selectProdHistory.do",
			type    : "POST",
			data	: param,
			success : function(data){
				
				if(ObjUtil.isEmpty(data.prodHistoryList)){
					
					var table = $('#tbProdHistory').DataTable();
					var childTable = $('#tbChildHistory').DataTable();
					table.clear().draw();
					childTable.clear().draw();
					
				}else{
					// 테이블 데이터 세팅
					fnDrawTb(data.prodHistoryList, "#tbProdHistory");
					var table = $('#tbProdHistory').DataTable();
					
					// 이력 클릭시 해당되는 원료 조회
					table.$('tr.selected').removeClass('selected');
					$("#tbProdHistory tbody tr").first().addClass("selected");
					
					// 공정차수 조회
					fnGetWkordSeqTab(data.prodHistoryList[0]);	
				}
				
			}
	    });
	}
 	
	// Datatable 데이터 세팅
    function fnDrawTb(pData, pId) {
		var table = $(pId).DataTable();
		table.clear();

		if(pData != null) {
			table.rows.add(pData).draw();
		}else{
			table.draw();
		}
	}
	
 	// 공정차수, 원료이력 조회
 	function fnGetWkordSeqTab(prodData){
 		
 		var param = { "DIV_CODE"		: '02'
 				    , "WKORD_NUM"		: prodData.WKORD_NUM 		// 작업지시번호
		            , "PROG_WORK_CODE"	: prodData.PROG_WORK_CODE};	// 공정코드
		
		$.ajax({      
			url     : "${pageContext.request.contextPath}/z_rmgmt/selectChildHistory.do",
			type    : "POST",
			data	: param,
			success : function(data){
				
				// 탭 초기화
				$("#ulWkordSeqTab").empty();
				
				// 조회한 공정차수 데이터
				const wkordNumSeqListData = data.wkordNumSeqList;

				let fstData = null;
				// 공정차수 탭생성
				for(let i=0; i<wkordNumSeqListData.length; i++){
					const seqData = wkordNumSeqListData[i];
					
					let matrlHTML = '	<li class="nav-item">';
					matrlHTML += '  	<a onClick="fnChildFilter(\''+seqData.WKORD_NUM_SEQ+'\');" data-toggle="tab" aria-expanded="false" class="nav-link ';
					matrlHTML += '																								'+i==0 ? 'active' : '' +'">';
					matrlHTML += '      	<i class="mdi mdi-home-variant d-md-none d-block"></i>';
					matrlHTML += '         	<span class="d-none d-md-block pop-hist-label" id="tab_pbl_change_span_'+i+'">' + seqData.WKORD_NUM_SEQ_NM+'</span>';
					matrlHTML += '		</a>';
					matrlHTML += '	</li>';
					
					$("#ulWkordSeqTab").append(matrlHTML);
				}
				
				// 테이블 데이터 세팅
				fnDrawTb(data.childHistoryList, "#tbChildHistory");
				
				// detail 데이터 조회
				fnChildFilter('00');
			}
	    });
 	}

 	// 탭별 Datatable filtering
    function fnChildFilter(wkordSeqNum){
 		
    	var table = $('#tbChildHistory').DataTable();
		table.columns(7).search(wkordSeqNum).draw();
    }
	
	
</script>
    