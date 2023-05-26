<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- Modal -->
<div class="modal fade" id="modal_${param.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="myModalLabel">날짜별 생수제품 데이터 검색 </h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">설정시간</th>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">일 프리폼 투입량</th>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">일 생수 생산량</th>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">일 생수 불량</th>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">일 생수 예측불량</th>
										<th colspan="2" style="text-align: center; vertical-align: middle;">정열기 프리폼투입</th>
										<th colspan="3" style="text-align: center; vertical-align: middle;">날인 제품 검사</th>
										<th colspan="4" style="text-align: center; vertical-align: middle;">제품 출하량</th>
									</tr>
									<tr>
										<th style="text-align: center; vertical-align: middle;">입력</th>
										<th style="text-align: center; vertical-align: middle;">출력</th>
										<th style="text-align: center; vertical-align: middle;">입력</th>
										<th style="text-align: center; vertical-align: middle;">출력</th>
										<th style="text-align: center; vertical-align: middle;">불량</th>
										<th style="text-align: center; vertical-align: middle;">500ml 패키지</th>
										<th style="text-align: center; vertical-align: middle;">500ml 낱개</th>
										<th style="text-align: center; vertical-align: middle;">2L 패키지</th>
										<th style="text-align: center; vertical-align: middle;">2L 낱개</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /Modal -->

<script type="text/javascript" charset="utf-8">
$('#modal_${param.id}').on('show.bs.modal', function (e) {
	var id = "${param.id}",
		$modal = $('#modal_'+id),
		$target = $('#'+id),
		today = (new Date()).formatter('yyyy-mm-dd');
	
	if($target.DataTable){
	 	var $dataTable = $target.DataTable({
	 		ajax: {
	 			url:'<c:url value="/dashboard/modal/water_date_search.json"/>',
	 			data:function(d){
	 				var settings = $target.dataTable().fnSettings();
	 				var date_st = $modal.find('input[name=date_st]').val();
 					//var date_ed = $modal.find('input[name=date_ed]').val();
 					
	 				return {
	 					draw : settings.iDraw,
	 					start : settings._iDisplayStart,
	 					length : settings._iDisplayLength,
	 					date_st: date_st ? date_st : today
						//date_ed: date_ed ? date_ed : today
	 				}
	 			},
	 		},
			columns: [
				{ data: 'setting_time' },
				{ data: 'weight_day_sum' },
				{ data: 'input_count_day_sum' },
				{ data: 'irreg_count_day_sum' },
				{ data: 'irreg_count_forecast_day_sum' },
				{ data: 'input_count1_preform_input' },
				{ data: 'output_count1_preform_input' },
				{ data: 'input_count1_product_test' },
				{ data: 'output_count1_product_test' },
				{ data: 'irreg_count1_product_test' },
				{ data: 'count_500ml' },
				{ data: 'count_500ml_piece' },
				{ data: 'count_2l' },
				{ data: 'count_2l_piece' }
			],
			initComplete: function(settings, json){
		 	 	var toolbar = '<label>기간 : '
		 	 				+ '<input type="text" class="form-control input-sm" name="date_st" value="'+today+'" readOnly />&nbsp;'
		 	 				+ '<button type="button" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> 검색</button>';

		 		$modal.find('.dataTables_filter').html(toolbar).val(today)
		 		 	.find('input[name=date_st]').datepicker().val(today);
		 		
		 		$modal.find('.btn-primary').on('click',function(){
			 		$('#'+id).DataTable().ajax.reload();
			 	})
			 	
			 	$("#water_date_search_paginate").hide();
		 		$("#water_date_search_info").hide();
		    }
		});
	 	$modal.find('.btn-primary').on('click',function(){
	 		$dataTable.ajax.reload();
	 	})
	 	
	}
}).on('hide.bs.modal', function (e) {
	$('#${param.id}').DataTable().destroy();
});

</script>