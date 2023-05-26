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
  	<div class="row" style="width:fit-content;margin:auto;" >
  		<button type="button" class="btn btn-primary" id="newBtn" style="margin:auto;display:block;" >신규</button>&nbsp;&nbsp;&nbsp;&nbsp;
		<button type="button" class="btn btn-primary" id="searchBtn"  style="margin:auto;display:block;" >조회</button>&nbsp;&nbsp;&nbsp;&nbsp;
		<button type="button" class="btn btn-primary" id="saveBtn" style="margin:auto;display:block;" >저장</button>

	</div>

	<div class="row" style="margin-top:10px;" >

		<div class="col-3">
			<label class="col-form-label">바코드<br>번호</label>
		</div>
		<div class="col-9">
			<input type="text" id="barcode" class="form-control"  onkeydown='barcode();'>
		</div>
	</div>
    <div class="row">
		<div class="col-3">
			<label class="col-form-label">출고창고</label>
		</div>

		<div class="col-9">
			<select id="issuewarehouse" class="form-control" disabled>
				<option value="" >  </option>
		     	 <option value="WH02" > 원자재창고(인천) </option>
		     	 <option value="WH03" > 부자재창고(인천) </option>
		     	 <option value="WH04" > 보관소(인천) </option>
		     	 <option value="WH05" > 반제품창고(인천) </option>
		     	 <option value="WH06" > 현장창고(인천) </option>
		     	 <option value="WH01" > 제품창고(인천) </option>
		     	 <option value="WH07" > 폐기창고 </option>



			</select>
		</div>
	</div>
<div class="row">
		<div class="col-3">
			<label  class="col-form-label">출고구분</label>
		</div>

		<div class="col-9">
			<select id="issuetype" class="form-control" disabled>
				 <option value="" >  </option>
		     	 <option value="10" > 정상판매 </option>
			     <option value="22" > AS 유상 </option>
			     <option value="94" > 에누리 </option>
			     <option value="95" > 반품환입 </option>

			</select>
		</div>
	</div>

  	<div class="row">
		<div class="col-3 ">
			<label  class="col-form-label">출고요청일</label>
	    </div>
		<div class="col-9 ">
 			<input type="text" id="issueDate" class="form-control" disabled>

 	    </div>

	</div>
	<div class="row">
		<div class="col-3">
			<label class="col-form-label">거래처</label>
		</div>

		<div class="col-9">
			<input type="text" id="customName" class="form-control" disabled >

		</div>

	</div>
	<div class="row">
		<div class="col-3">
			<label class="col-form-label">수불담당자</label>
		</div>

		<div class="col-9">
			<select id="inoutPrsn" class="form-control" >
		     	 <option value="02" > 조영숙 </option>
		     	 <option value="01" > 이주영 </option>

			</select>
		</div>
	</div>
		<div class="row" style="display:none;">
		<div class="col-3 ">
			<label  class="col-form-label">오늘날짜</label>
	    </div>
		<div class="col-9 ">
 			<input type="text" id="todayDate" class="form-control" disabled>

 	    </div>

	</div>
<!--
  	<div class="row">
		<button type="button" class="btn btn-primary" id="saveBtn2" >조회</button>
	</div>
 -->

 	<section class="table-set-eqpmn">
				<!-- <table id="tblSMInfo" class="table table-striped table-bordered nowrap" style="width: 100%"> 한 로우의 데이터 한줄로 표현-->
				<!--<table id="tblSMInfo" class="table table-striped table-bordered " style="width: 100%">


				</table>-->
				<table id="ownerlist" class="table table-striped table-bordered " style="width: 100%"><!-- 한 로우의 데이터 여러줄로 표현  -->


				</table>

			</section>
</main>

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
        bor35r: 1px solid #ddd;
    }
  table#tblSMInfo.dataTable td .spec{
       overflow: hidden;
       white-space: nowrap;
       text-overflow: ellipsis;
       table-layout:fixed;
     }



</style>
<script type="text/javascript"  charset="utf-8" >

var userId = '${userId}';
var userCompCode = '${compCode}';
var userDivCode = '${divCode}';


var isResponsive = false;
var isPaging = true;
var isScrollX = true;

$(document).ready(function() {


	$("#searchBtn").trigger("click");
	$("#barcode").click().focus();

	$("#barcode").keydown( function (key) {

		if (key.keyCode == 13) {
				$("#searchBtn").trigger("click");
				$(this).val("").focus();
			}
		});

		 fnInit();
		 fnEvent();

})


function barcode(e){
 var event=window.event || e;

 if(event.keyCode=="13"){
  //alert(e);
  //$("#barcode").val()=event;
  $("#searchBtn").trigger("click");
 }
}

function fnInit() {

	fnDatePickerInit();

	// 컴포넌트
	fnMainTableInit();


	// 공통코드
	fnGetCommonCodeList();

}

function fnMainTableInit(){

	var data = null;
	var CUSTOM_NAME='';
	var ISSUE_REQ_DATE='';
	var WH_CODE='';

	  var params = {'COMP_CODE':userCompCode,'DIV_CODE':userDivCode};
		if ($("#barcode").val()== ''){
			   console.log('$("#barcode").val()', $("#barcode").val());
			   params.ISSUE_REQ_NUM = '***';
		}else{
			 console.log('$("#barcode").val()1', $("#barcode").val());
			 params.ISSUE_REQ_NUM = $("#barcode").val();
		}

	$('#ownerlist').DataTable({
            ajax: {
                url: "${pageContext.request.contextPath}/pda/s_pdp100ukrv_wm_search.do",
                type: "post",
                dataType: "JSON",
                data: params,
                complete: function (data) {
                    info = data['responseJSON']

                    if(info.length>0){
                    	ISSUE_REQ_DATE = info[0].ISSUE_REQ_DATE
                    	CUSTOM_NAME = info[0].CUSTOM_NAME
                    	WH_CODE = info[0].WH_CODE


                    	fnresult(WH_CODE,ISSUE_REQ_DATE,CUSTOM_NAME);
                    }

                },
                dataSrc: function (res) {

                    var data = res;
                    var result = []


                    // 상태가 waiting인 객체 빼고 리턴하기
                    for (let i = 0; i < data.length; i++) {
                        if ( data[i].status == 'waiting' ) {
                            continue;
                        }
                        result.push(data[i])
                    }

					// 배열에 인덱스 번호 매기기 (테이블에 인덱스 보여지게)
                    for (let i = 0; i < data.length; i++) {
                        data[i].index = i + 1
                        //console.log(data[i])
                    }

                    return result
                }
            },
            pageLength: 10,
            info: false,
            paging: false,
            ordering: false,
            searching: false,
            autoWidth: false,
            destroy: true,
    		select : false,
    		//paging : true,
    		ordering : true,
    		filter : false,
    		lenghChange : true,
    		lengthChange : true,
    		order : [],
    		stateSave : false,
    		pagingType : "full_numbers",
    		processing : false,
    		serverside : false,

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


            columns: [
				{ title: "작지번호",		data : "ISSUE_REQ_NUM", width:"1%", visible:false},
				{ title: "품목명",			data : "ITEM_NAME", width:"20%"},
                { title: "규격",			data : "SPEC", width:"10%"},
                { title: "출고량",			data : "ISSUE_REQ_QTY", width:"10%"},
	            { title: "주문량",			data : "ISSUE_REQ_QTY", width:"10%"},
	            { title: "재고량",			data : "STOCK_Q", width:"*"}

            ],

            columnDefs: [
              {
       		   targets: 0,
       	       className: "text-head-center",
       	       width: "1%",
       	       render : function (data, type, row, meta) {
       				return "<td id='inoutNum' name='ISSUE_REQ_NUM'>" + data + "</td>";
       			}

       		},{
    			targets: 1,
    		    className: "text-head-center",
    		    width: "20%",
    		    render : function (data, type, row, meta) {
    				return "<td id='itemName' name='ITEM_NAME'  >" + data + "</td>";
    			}


            },{
    		   targets: 2,
    	       className: "text-head-center",
    	       width: "10%",
    	       render : function (data, type, row, meta) {
    				return "<td id='spec' name='SPEC'>" + data + "</td>";
    			}

    		},{

                targets: 3,
                className: "text-head-center",
                width: "10%",
                render : function (data, type, row, meta) {
        			var inputHtml = "";
        			inputHtml += "<td id='inoutQ' name='ISSUE_REQ_QTY'>";
        			inputHtml += "<input type='text' style='width:50px;' id='txtInfo' value=" + data + ">"  ;
        			inputHtml += "</td>";
					return inputHtml;
        		}

            },{
                targets: 4,
                className: "text-head-center",
                width: "10%",
                render : function (data, type, row, meta) {
        			return "<td id='originQ' name='ORIGIN_Q'>" + data + "</td>";
        		}


            },{
           	  	targets: 5,
                className: "text-head-center",
                width: "*",
                render : function (data, type, row, meta) {
        			return "<td id='StockQ'  name='STOCK_Q'>" + data + "</td>";
          		}


            }]
	})

}

function fnMainTableDraw(data){
    var table = $('#ownerlist').DataTable();
    table.clear();


    if(!ObjUtil.isEmpty(data)) table.rows.add(data);
        table.draw();
}

function fnEvent(){

 	$(document).on("click", "#searchBtn", function(){
 		 var table = $('#ownerlist').DataTable();
    table.clear();
		fnMainTableInit();

	});


 	$("#ownerlist").on('click', 'tbody tr td', function () {
 		let row = $("#ownerlist").DataTable().row(0).data();
		let todayDate = $("#todayDate").val();
		let inoutPrsn = $("#inoutPrsn").val();

		let params = [];

		let tblRows = $('#ownerlist').dataTable().api().rows();
		let s = 0;
		var sInout_q = row.NOT_REQ_Q;;
		var sUnitVol = row.UNIT_VOL;;
		var sOrderVolQ = sInout_q * sUnitVol;
		let txtInfo = $("#txtInfo").val();
		console.log('출고량'+txtInfo);
 	   console.log(row);

 	  if (window.confirm('출고적용하시겠습니까?'))
 	  {

 			console.log("출고적용함");
			$.each(tblRows.data(), function(i, v){
 				params[0] = v;
 				params[0].COMP_CODE 			= 	userCompCode;
 	 			params[0].DIV_CODE 				= 	userDivCode;
 				params[0].KEY_VALUE 			= 	'';
 				params[0].OPR_FLAG 				= 	'N';
 				params[0].INOUT_NUM 			= 	row.ORDER_NUM;
 				params[0].INOUT_SEQ 			= 	'1';
 				params[0].INOUT_METH 			= 	'1';
 				params[0].INOUT_TYPE_DETAIL 	= 	row.INOUT_TYPE_DETAIL;
 				params[0].INOUT_CODE 			= 	row.CUSTOM_CODE;
 				params[0].WH_CODE 				= 	row.WH_CODE;
 				params[0].INOUT_DATE 			= 	todayDate;
 				params[0].ITEM_CODE 			= 	row.ITEM_CODE;
 				params[0].ITEM_STATUS			= 	'1';
 				params[0].MONEY_UNIT 			= 	row.MONEY_UNIT;
 				params[0].ORDER_UNIT_O 			= 	row.ISSUE_REQ_AMT;
 				params[0].EXCHG_RATE_O 			= 	'1';
 				params[0].ORDER_TYPE 			= 	row.ORDER_TYPE;
 				params[0].ORDER_NUM  			= 	row.ORDER_NUM;
 				params[0].ORDER_SEQ 			= 	row.SER_NO;
 				params[0].INOUT_PRSN			= 	inoutPrsn;
 				params[0].BASIS_NUM 			= 	row.PO_NUM;
 				params[0].BASIS_SEQ 			= 	row.PO_SEQ;
 				params[0].ACCOUNT_YNC 			= 	row.ACCOUNT_YNC;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].REMARK 				= 	row.REMARK;
 				params[0].ORDER_UNIT 			= 	row.ORDER_UNIT;
 				params[0].TRANS_RATE 			= 	row.TRANS_RATE;
 				params[0].PLAN_NUM 				= 	row.PROJECT_NO;
 				params[0].ORDER_UNIT_Q 			= 	row.NOT_REQ_Q;
 				params[0].ORDER_UNIT_P 			= 	row.ISSUE_REQ_PRICE;
 				params[0].ISSUE_REQ_NUM 		= 	row.ISSUE_REQ_NUM;
 				params[0].ISSUE_REQ_SEQ 		= 	row.ISSUE_REQ_SEQ;
 				params[0].DVRY_CUST_CD 			= 	row.DVRY_CUST_CD;
 				params[0].DISCOUNT_RATE 		= 	row.DISCOUNT_RATE;
 				params[0].TAX_TYPE 				= 	row.TAX_TYPE;
 				params[0].LOT_NO 				= 	row.LOT_NO;
 				params[0].SALE_DIV_CODE 		= 	'';
 				params[0].SALE_CUSTOM_CODE 		= 	row.SALE_CUSTOM_CODE;
 				params[0].BILL_TYPE 			= 	row.BILL_TYPE;
 				params[0].SALE_TYPE 			= 	row.ORDER_TYPE;
 				params[0].PRICE_YN 				= 	row.PRICE_YN;
 				params[0].SALE_PRSN 			= 	row.ISSUE_REQ_PRSN;
 				params[0].LC_SER_NO 			= 	row.LC_SER_NO;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].PAY_METHODE1 			= 	row.PAY_METHODE1;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].DELIVERY_DATE 		= 	row.ISSUE_DATE.replaceAll('.', '');
 				params[0].DELIVERY_TIME 		= 	'';
 				params[0].WH_CELL_CODE 			= 	row.WH_CELL_CODE;
 				params[0].AGENT_TYPE 			= 	row.CUSTOM_AGENT_TYPE;
 				params[0].DEPT_CODE 			= 	row.DEPT_CODE;
 				params[0].TRANS_COST 			=	'0';
 				params[0].PRICE_TYPE 			= 	row.PRICE_TYPE;
 				params[0].INOUT_WGT_Q 			= 	txtInfo;
 				params[0].INOUT_FOR_WGT_P 		= 	row.ISSUE_FOR_WGT_P;
 				params[0].INOUT_WGT_P 			= 	row.ISSUE_WGT_P;
 				params[0].INOUT_VOL_Q 			= 	sOrderVolQ;
 				params[0].INOUT_FOR_VOL_P 		= 	'0';
 				params[0].INOUT_VOL_P 			= 	'0';
 				params[0].WGT_UNIT 				= 	row.WGT_UNIT;
 				params[0].UNIT_WGT 				= 	row.UNIT_WGT;
 				params[0].VOL_UNIT 				= 	row.VOL_UNIT;
 				params[0].UNIT_VOL 				= 	row.UNIT_VOL;
 				params[0].NATION_INOUT 			= 	'1';
 				params[0].SALE_DATE 			= 	todayDate;
 				params[0].S_USER_ID 			= 	userId;
 				params[0].PACK_UNIT_Q 			= 	'0';
 				params[0].BOX_Q 				= 	'0';
 				params[0].EACH_Q 				= 	'0';
 				params[0].LOSS_Q 				= 	'0';
 				params[0].REMARK_INTER 			= 	row.REMARK_INTER;
 				params[0].TAX_INOUT 			= 	row.TAX_INOUT;
 				params[0].CARD_CUSTOM_CODE		= 	row.CARD_CUSTOM_CODE;
 				params[0].ADDRESS 				= 	row.ADDRESS;
 				params[0].ITEM_CODE 			=	row.ITEM_CODE;
 				s++;
 			});

 			fnSave(params);

 	  }
 	  else
 	  {
 		 console.log("출고적용안함");
 	  }


 	});


 	$(document).on("click", "#saveBtn", function(){


 		let row = $("#ownerlist").DataTable().row(0).data();
		let todayDate = $("#todayDate").val();
		let inoutPrsn = $("#inoutPrsn").val();

		let params = [];

		let tblRows = $('#ownerlist').dataTable().api().rows();
		let s = 0;
		var sInout_q = row.NOT_REQ_Q;;
		var sUnitVol = row.UNIT_VOL;;
		var sOrderVolQ = sInout_q * sUnitVol;
		let txtInfo = $("#txtInfo").val();





 	  if (window.confirm('출고적용하시겠습니까?'))
 	  {

 			console.log("출고적용함");
 			$.each(tblRows.data(), function(i, v){
 				params[0] = v;
 				params[0].COMP_CODE 			= 	userCompCode;
 	 			params[0].DIV_CODE 				= 	userDivCode;
 				params[0].KEY_VALUE 			= 	'';
 				params[0].OPR_FLAG 				= 	'N';
 				params[0].INOUT_NUM 			= 	row.ORDER_NUM;
 				params[0].INOUT_SEQ 			= 	'1';
 				params[0].INOUT_METH 			= 	'1';
 				params[0].INOUT_TYPE_DETAIL 	= 	row.INOUT_TYPE_DETAIL;
 				params[0].INOUT_CODE 			= 	row.CUSTOM_CODE;
 				params[0].WH_CODE 				= 	row.WH_CODE;
 				params[0].INOUT_DATE 			= 	todayDate;
 				params[0].ITEM_CODE 			= 	row.ITEM_CODE;
 				params[0].ITEM_STATUS			= 	'1';
 				params[0].MONEY_UNIT 			= 	row.MONEY_UNIT;
 				params[0].ORDER_UNIT_O 			= 	row.ISSUE_REQ_AMT;
 				params[0].EXCHG_RATE_O 			= 	'1';
 				params[0].ORDER_TYPE 			= 	row.ORDER_TYPE;
 				params[0].ORDER_NUM  			= 	row.ORDER_NUM;
 				params[0].ORDER_SEQ 			= 	row.SER_NO;
 				params[0].INOUT_PRSN			= 	inoutPrsn;
 				params[0].BASIS_NUM 			= 	row.PO_NUM;
 				params[0].BASIS_SEQ 			= 	row.PO_SEQ;
 				params[0].ACCOUNT_YNC 			= 	row.ACCOUNT_YNC;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].REMARK 				= 	row.REMARK;
 				params[0].ORDER_UNIT 			= 	row.ORDER_UNIT;
 				params[0].TRANS_RATE 			= 	row.TRANS_RATE;
 				params[0].PLAN_NUM 				= 	row.PROJECT_NO;
 				params[0].ORDER_UNIT_Q 			= 	row.NOT_REQ_Q;
 				params[0].ORDER_UNIT_P 			= 	row.ISSUE_REQ_PRICE;
 				params[0].ISSUE_REQ_NUM 		= 	row.ISSUE_REQ_NUM;
 				params[0].ISSUE_REQ_SEQ 		= 	row.ISSUE_REQ_SEQ;
 				params[0].DVRY_CUST_CD 			= 	row.DVRY_CUST_CD;
 				params[0].DISCOUNT_RATE 		= 	row.DISCOUNT_RATE;
 				params[0].TAX_TYPE 				= 	row.TAX_TYPE;
 				params[0].LOT_NO 				= 	row.LOT_NO;
 				params[0].SALE_DIV_CODE 		= 	'';
 				params[0].SALE_CUSTOM_CODE 		= 	row.SALE_CUSTOM_CODE;
 				params[0].BILL_TYPE 			= 	row.BILL_TYPE;
 				params[0].SALE_TYPE 			= 	row.ORDER_TYPE;
 				params[0].PRICE_YN 				= 	row.PRICE_YN;
 				params[0].SALE_PRSN 			= 	row.ISSUE_REQ_PRSN;
 				params[0].LC_SER_NO 			= 	row.LC_SER_NO;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].PAY_METHODE1 			= 	row.PAY_METHODE1;
 				params[0].CREATE_LOC 			= 	'1';
 				params[0].DELIVERY_DATE 		= 	row.ISSUE_DATE.replaceAll('.', '');
 				params[0].DELIVERY_TIME 		= 	'';
 				params[0].WH_CELL_CODE 			= 	row.WH_CELL_CODE;
 				params[0].AGENT_TYPE 			= 	row.CUSTOM_AGENT_TYPE;
 				params[0].DEPT_CODE 			= 	row.DEPT_CODE;
 				params[0].TRANS_COST 			=	'0';
 				params[0].PRICE_TYPE 			= 	row.PRICE_TYPE;
 				params[0].INOUT_WGT_Q 			= 	txtInfo;
 				params[0].INOUT_FOR_WGT_P 		= 	row.ISSUE_FOR_WGT_P;
 				params[0].INOUT_WGT_P 			= 	row.ISSUE_WGT_P;
 				params[0].INOUT_VOL_Q 			= 	sOrderVolQ;
 				params[0].INOUT_FOR_VOL_P 		= 	'0';
 				params[0].INOUT_VOL_P 			= 	'0';
 				params[0].WGT_UNIT 				= 	row.WGT_UNIT;
 				params[0].UNIT_WGT 				= 	row.UNIT_WGT;
 				params[0].VOL_UNIT 				= 	row.VOL_UNIT;
 				params[0].UNIT_VOL 				= 	row.UNIT_VOL;
 				params[0].NATION_INOUT 			= 	'1';
 				params[0].SALE_DATE 			= 	todayDate;
 				params[0].S_USER_ID 			= 	userId;
 				params[0].PACK_UNIT_Q 			= 	'0';
 				params[0].BOX_Q 				= 	'0';
 				params[0].EACH_Q 				= 	'0';
 				params[0].LOSS_Q 				= 	'0';
 				params[0].REMARK_INTER 			= 	row.REMARK_INTER;
 				params[0].TAX_INOUT 			= 	row.TAX_INOUT;
 				params[0].CARD_CUSTOM_CODE		= 	row.CARD_CUSTOM_CODE;
 				params[0].ADDRESS 				= 	row.ADDRESS;
 				params[0].ITEM_CODE 			=	row.ITEM_CODE;
 				s++;
 			});

 			fnSave(params);

 	  }
 	  else
 	  {
 		 console.log("출고적용안함");
 	  }



 /*

		var table = $('#ownerlist').DataTable();
		let params = [];
		let tblRows = $('#ownerlist').dataTable().api().rows();
		let s = 0;

		//console.log("2222"+ $("#ownerlist").DataTable().row($(this)).data());
		//console.log("33333"+table.api().rows());
		//console.log("11111"+$('#ownerlist').dataTable().api().row($this).data());
		//console.log("2222"+$('#ownerlist').dataTable().api().row().data());


		//console.log("00000"+tblRows.data());
		$.each(tblRows.data(), function(i, v){
			params[0] = v;
			params[0].COMP_CODE 			= 	userCompCode;
 			params[0].DIV_CODE 				= 	userDivCode;

			s++;
		});
		console.log("111"+params[0]);
		fnSave(params);*/
	});
 	$(document).on("click", "#newBtn", function(){


		var table = $('#ownerlist').DataTable();

		fnClear();
		table.clear();
		fnMainTableInit();

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
        alert("저장할 데이터가 없습니다.");
	}else{

		var ajaxUrl     = "${pageContext.request.contextPath}/pda/s_pdp100ukrv_wm_chk_save.do";

		var ajaxData    = {
			data : JSON.stringify(params)
		};
		var returnCode;
		var ajaxloding  = false;
		var ajaxCallback= function (data) {
	   	/* $(".i-input").val(undefined); */
	   	if(data.success){

	        alert("저장되었습니다.");
	        $("#searchBtn").trigger("click");

	   	}else{
	   		alert("저장에 실패하였습니다.");
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

	$('#todayDate').datepicker({
	    format: 'yyyymmdd',
	    autoclose: 'true'
	}).datepicker("setDate", new Date(dateY, dateM, dateD));

}
function fnresult(wh,dt,cust){

	$("#customName").val(cust);
	$("#issueDate").val(dt);
	$("#issuewarehouse").val(wh);
	$("#issuetype").val('10');



}
function fnClear(){

	$("#barcode").val('')
	$("#customName").val('')
	$("#issueDate").val('')
	$("#issuewarehouse").val('')
	$("#issuetype").val('')



}
</script>
</body>
</html>