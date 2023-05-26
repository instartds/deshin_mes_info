<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<body>

<div class="container">

	<header class="row">
		<div class="col">
			<div class="page-title">
				<hr class="mt-1">
			</div>
		</div>
	</header>
		
<main>
	<div class="row">

		<div class="col-3">
			<label for="wkordNum" class="col-form-label">작지번호</label>
		</div>
		<div class="col-9">
			<input type="text" id="wkordNum" class="form-control">
		</div>
	</div>
    <div class="row">
		<div class="col-3">
			<label for="wkordPrsn" class="col-form-label">담당자</label>
		</div>
    
		<div class="col-9">
			<select id="wkordPrsn" class="form-control">
	
				
			</select>
		</div>
	</div>


  	<div class="row">
		<div class="col-3 ">
			<label for="wkordDate" class="col-form-label">작업일</label>
	    </div>
		<div class="col-9 ">
<!-- 			<input type="text" id="wkordDate" class="col-5 p-0 form-control from-date text-center m-0 sch" autocomplete="off">
 -->
 			<input type="text" id="wkordDate" class="form-control" value="2019-06-27">
 
 	    </div>

	</div>
	
<!-- 	
  	<div class="row">
		<button type="button" class="btn btn-primary" id="saveBtn2" >테스트</button>
	</div>
 -->	
	
 	<section class="table-set-eqpmn">
				<!-- <table id="tblSMInfo" class="table table-striped table-bordered nowrap" style="width: 100%"> 한 로우의 데이터 한줄로 표현-->
				<table id="tblSMInfo" class="table table-striped table-bordered " style="width: 100%"><!-- 한 로우의 데이터 여러줄로 표현  -->
					
		
				</table>		
				
			</section> 
</main>


<footer>
  	<div class="row">
		<button type="button" class="btn btn-primary" id="searchBtn" hidden=true>조회</button>
		<button type="button" class="btn btn-primary" id="saveBtn" hidden=true>저장</button>

	</div>

</footer>

</div>


<style>
.child-container{
        padding: 1 !important;
    }

    table.row-detail {
        border-collapse: collapse;
        width: 100%;
        border: 1px solid #ddd;
    }

    table.row-detail td {
        padding: 5px 5px !important;
        border: 1px solid #ddd;
    }
  table#tblSMInfo.dataTable td .item-code{
       overflow: hidden;
       white-space: nowrap;
       text-overflow: ellipsis;
     }
    
/*    text-overflow: ellipsis;
    
    table#tblSMInfo.dataTable td .prdctn-name {
    	width: 850px;
    	height: 109px;
    	white-space: normal;
font-size: 37px;

vertical-align: middle; 
display: table-cell; 
    	} */
    	
    	
</style>
<script type="text/javascript"  charset="utf-8" >

/*
var userId = "unilite5";
var userCompCode = "MASTER";
var userDivCode = "01";
*/
 
var userId = "";
var userCompCode = "";
var userDivCode = "";


var isResponsive = false;
var isPaging = true;
var isScrollX = true;

//var companyNo = '${companyNo}';

$(document).ready(function() {

	$("#wkordNum").focus();

	$("#wkordNum").keydown( function (key) {
	
		if (key.keyCode == 13) {
			$("#searchBtn").trigger("click");
			$(this).val("").focus();
			
			//soft키보드 내리기위한 작업
			$('#wkordNum').val('');
			$('#wkordNum').attr("readonly",true);
			$('#wkordNum').focus();
			setTimeout(function(){ $('#wkordNum').attr("readonly",false);}, 50);
		}
	});

		fnInit();
		fnEvent();

})

function fnInit() {
	
	fnDatePickerInit();
	
	// 컴포넌트
	fnMainTableInit();
	
	
	// 공통코드
	fnGetCommonCodeList();
	    
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
            { title: "품목코드",			data : "ITEM_CODE", width:"40%"},
            { title: "지시량",			data : "WKORD_Q", width:"30%"},
            { title: "실적수량",				data : "WORK_Q", width:"30%"}
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
            className: "text-head-center text-right"
         //   width: "55px"
        },{
            targets: 2,
            className: "text-head-center",
           // width: "55px",
            render : function(data, type, row){
    			var html = "<input type='number' class='form-control form-control-sm i-input text-right' name='workQ' value='" + data + "' placeholder='' autocomplete='off'>";
    			return  html;
    		}
        }
        
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
    $("#tblSMInfo").on('draw.dt', function () {
    	$('#tblSMInfo').DataTable().rows().every(function () {
            this.child(format(this.data())).show();
            this.nodes().to$().addClass('shown');
            // this next line removes the padding from the TD in the child row 
            // In my case this gives a more uniform appearance of the data
            this.child().find('td:first-of-type').addClass('child-container')
          });
    });
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

	function format(d) {
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
   	}
function fnMainTableDraw(data){
    var table = $('#tblSMInfo').DataTable();
    table.clear();

    if(!ObjUtil.isEmpty(data)) table.rows.add(data);
        table.draw();
}

function fnEvent(){
	
 	$(document).on("click", "#searchBtn", function(){
	
		var params = {'COMP_CODE':userCompCode,'DIV_CODE':userDivCode};
		params.WKORD_NUM = $("#wkordNum").val();
	
	    var ajaxUrl         = "${pageContext.request.contextPath}/pda/s_pdp100ukrv_wm_search.do";
	    var ajaxData        = params;
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

function fnDatePickerInit(){
	var date = new Date();
	var dateY = date.getFullYear();
	var dateM = date.getMonth();
	var dateD = date.getDate();
	
	$('#wkordDate').datepicker({
	    format: 'yyyy-mm-dd',
	    autoclose: 'true'
	}).datepicker("setDate", new Date(dateY, dateM, dateD));
	 
}

</script>
</body>
</html>