<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
#rmgmtPopHistDetail .modal-content {
	height: 100%;
	overflow: auto;
}

#rmgmtPopHistDetail .modal-header {
	align-items: center;
}
#rmgmtPopHistDetail .modal-header button {
	position: static;
}


#tbRmgmtHistDetail .pagination-align ul {
	justify-content: center !important;
}
#tbRmgmtHistDetail_paginate .page-item {
	height: 70px;
	width: 70px; 
	font-size: 35px;
	text-align: center;
}
#tbRmgmtHistDetail_paginate .first,
#tbRmgmtHistDetail_paginate .previous,
#tbRmgmtHistDetail_paginate .next,
#tbRmgmtHistDetail_paginate .last {
	width: 150px;
}
#tbRmgmtHistDetail_paginate .first,
#tbRmgmtHistDetail_paginate .previous {
	margin-right: 10px;
}
#tbRmgmtHistDetail_paginate .next,
#tbRmgmtHistDetail_paginate .last {
	margin-left: 10px; 
}

#tbRmgmtHistDetail th {
	font_size: 22px;
}
#tbRmgmtHistDetail th.dt-head-center {
	text-align: center
}

#tbRmgmtHistDetail td {
	height: 40px;
	white-space: normal;
	font-size: 23px;
	
	vertical-align: middle; 
	display: table-cell;
}
#tbRmgmtHistDetail td.prodt-q-g {
	font-size: 35px;
	color : #727cf5
}
#tbRmgmtHistDetail td.prodt-q-p {
	font-size: 35px;
	color : #0acf97
}

#tbRmgmtHistDetail td.dt-body-right {
	text-align: right
}	
#tbRmgmtHistDetail td.dt-body-center {
	text-align: center
}

</style>

<!-- 내용물 조회 -->
<div id="rmgmtPopHistDetail" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="rmgmtPopHistDetailHeader" aria-hidden="true">
    <div class="modal-dialog modal-full-width modal-right">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="standard-modalLabel"><span id="rmgmtPopHistDetailtitle"></span>내용물 조회</h4>
                <button type="button" class="close" name="rmgmtPopHistDetailClose" data-dismiss="modal" aria-hidden="true"><span
                        style="font-size: 50px;">x</span></button>
            </div>
            <div class="modal-body pr-2 pl-2">
	            <div class="card" style="height:100%">
	            	<div class="card-body">
	            		<table id="tbRmgmtHistDetail" class="table table-stripedtable-sm nowrap" style="width: 100%">
						</table>
	            	</div>
	            </div>
            </div>
            
            <div class="modal-footer">
                <div class="col-2 text-right pr-0 pl-3">
                    <button style="height: 60px;font-size:35px" type="button" class="btn btn-primary btn-block"
                        name="listpopClose" data-dismiss="modal">
                        <span>닫 기</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>


<script type = "text/javascript" charset = "utf-8" >
/********** 전역 
 **************************************************/
 	var _glbRmgmtPopHistDetail = {
		DIV_CODE 		: "", 
   		WKORD_NUM 		: "", 
   		PROG_WORK_CODE 	: "",
   		WKORD_NUM_SEQ 	: "", 
   		ITEM_CODE 		: "",
   		CHILD_ITEM_CODE	: "", 
   		REF_TYPE 		: "", 
   		PATH_CODE 		: "",
   		EQU_CODE		: "",
   		WKORD_Q			: "",
   		USE_WKORD_Q_YN	: ""
	};
 
 
 	$(document).ready(function () {
		/********** 이벤트 함수 정의.
    	**************************************************/
    	/********** Modal Open 이벤트. **********/
        $('#rmgmtPopHistDetail').on('show.bs.modal', function (e) {
            $("#tblPop002_info, #tblPop002_paginate .pagination").show();
            
            fnGetHistDetail();
        });

        /********** Modal Close 이벤트. **********/
        $('#rmgmtPopHistDetail').on('hidden.bs.modal', function (e) {

        });
    	
    	fnInitRmgmtPopHistDetail()
	});
	
	/********** 초기화.
    **************************************************/
    function fnInitRmgmtPopHistDetail() {
        $("#tbRmgmtHistDetail").DataTable({
            /*객체 순서.*/
            /*l - length changing input control
            f - filtering input
            t - The table!
            i - Table information summary tblProductInfo
            p - pagination control
            r - processing display element*/
            /*dom: "Blfrtip",*/
            /*"dom": '<"top"iflp<"clear">>rt<"bottom"iflp<"clear">>',*/
            dom: ""
                /* + "<'hr'>" + "<'row'<'col-6'l><'col-6'f>>" */
                + "<'row'<'table-responsive'<'col-12'tr>>>" //col-12
                /* + "<'row'<'col-sm-6'i><'col-sm-6'p>>", */
                + "<'row'<'col-sm-12'><'col-sm-12 pagination-align'p>>",
            select: false,
            paging: true,
            ordering: true,
            info: true,
            filter: true,
            lenghChange: true,
            lengthChange: true,
            order: [],
            stateSave: false,
            pagingType: "full_numbers",
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            processing: false,
            serverside: false,
            buttons: [{
                extend: "excel",
                text: "엑셀",
                footer: true,
                className: "exportBtnExcel"
            }, {
                extend: "pdf",
                text: "PDF",
                footer: true,
                className: "exportBtnPdf"
            }],
            language: {
                "emptyTable": "데이터가 존재하지 않습니다.",
                "lengthMenu": "페이지당 _MENU_ 개씩 보기",
                "info": "현재 _START_ - _END_ / _TOTAL_건",
                "infoEmpty": "데이터가 존재하지 않습니다.",
                "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
                "search": "찾기: ",
                "zeroRecords": "일치하는 데이터가 없어요.",
                "loadingRecords": "로딩중...",
                "processing": "잠시만 기다려 주세요...",
                "paginate": {
                    "first": "처음",
                    "next": "다음",
                    "previous": "이전",
                    "last": "마지막"
                }
            },
            /* select : {
                style:    'os',
                selector: 'td:first-child' 
            }, */
            createdRow: function (row, data, dataIndex, cells) {
                //if (dataIndex != 0)  $(row).attr("draggable", "true");
            },
            columns: [
                { title: '제조일자', 	data: "PRODT_DATE", width: '12%' },
                { title: '제조번호', 	data: "LOT_NO", 		width: '12%' },
                { title: '원료코드', 	data: "ITEM_CODE", 		width: '12%' },
                { title: '원료명', 	data: "ITEM_NAME", 		width: '25%' },
                { title: '이론량', 	data: "OUTSTOCK_REQ_Q", width: '13%' },
                { title: '계량량(G)', 	data: "PRODT_Q_G", 		width: '13%' },
                { title: '계량량(%)', 	data: "PRODT_Q_P", 		width: '13%' }
            ],
            columnDefs: [
                {
                    targets: 0,
                    className: "text-center",
                    render : function(data, type, row){
                    	return DateUtil.toString(data, "yyyy.MM.dd")
                    }
                }, {
                    targets: 1,
                    className: "text-center",
                }, {
                    targets: 2,
                    className: "text-center",
                }, {
                    targets: 3,
                    className: "dt-head-center"
                }, {
                    targets: 4,
                    className: "dt-head-center dt-body-right",
                    render : function(data, type, row){
                    	return StringUtil.formatNumber(data);
                    }
                }, {
                    targets: 5,
                    className: "dt-head-center dt-body-right prodt-q-g",
                    render : function(data, type, row){
                    	return StringUtil.formatNumber(data) + " G";;
                    }
                }, {
                    targets: 6,
                    className: "dt-head-center dt-body-right prodt-q-p",
                    render : function(data, type, row){
                    	return StringUtil.formatNumber(data) + " %";
                    }
                }
            ]
        });
    }
	
    /********** 유효성 검사.
    **************************************************/
    function fnValidateRmgmtPopHistDetail() {
 		
    }
	
    /********** 사용자 정의 함수.
    **************************************************/
    /***** table draw
 	*************************/
    function fnGetHistDetail() {
    	
        $.ajax({
            url 	: "${pageContext.request.contextPath}/z_rmgmt/selectHistDetail.do",
            type	: "post",
            data	: _glbRmgmtPopHistDetail,
            success: function (data) {
                fnDrawTbHistDetail(data);
            }
        });
	}
    
    /***** table draw
	*************************/
    function fnDrawTbHistDetail(data) {
        var table = $("#tbRmgmtHistDetail").DataTable();
        table.clear();

        if (!ObjUtil.isEmpty(data)) 
        	table.rows.add(data);

        table.draw();

        if (ObjUtil.isEmpty(data))
            $('#tbRmgmtHistDetail_previous').css('margin-right', '0');
        else
            $('#tbRmgmtHistDetail_previous').css('margin-right', '5px');
    }
</script>