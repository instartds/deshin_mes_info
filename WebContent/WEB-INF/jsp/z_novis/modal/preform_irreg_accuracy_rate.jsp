<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="modal fade" id="modal_${param.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="myModalLabel">주간 예측불량률 추이</h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th>일자</th>
										<th>생산량</th>
										<th>불량</th>
										<th>불량률</th>
										<th>예측불량</th>
										<th>예측불량률</th>
										<th>오차율</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" charset="utf-8">
$('#modal_${param.id}').on('show.bs.modal', function (e) {
	
	var id = "${param.id}",
		$modal = $('#modal_'+id),
		$target = $('#'+id);
	
	var dt = new Date();
	var today_date_st = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate()-7).formatter('yyyy-mm-dd');
	var today_date_ed = dt.formatter('yyyy-mm-dd');

	
	if($target.DataTable){
	 	var $dataTable = $target.DataTable({
	 		bInfo: false,
	 		bPaginate: false,
	 		ajax: {
	 			url:'<c:url value="/dashboard/modal/preform_irreg_accuracy_rate.json"/>',
	 			dataSrc: 'data',
	 			data:function(d){
	 				var settings = $target.dataTable().fnSettings();
	 				var select_date_st = $modal.find('input[name=date_st]').val();
 					var select_date_ed = $modal.find('input[name=date_ed]').val();
					
 					return {
	 					draw : settings.iDraw,
	 					start : settings._iDisplayStart,
	 					length : settings._iDisplayLength,
	 					date_st: select_date_st ? select_date_st : today_date_st,
						date_ed: select_date_ed ? select_date_ed : today_date_ed
	 				}
	 			}
	 		}, 
			columns: [
				{ data: 'ctime' },
				{ data: 'count_500ml_piece' },
				{ data: 'irreg_count_sensor_day_sum' },
				{ data: 'irreg_count_sensor_day_rate' },
				{ data: 'irreg_count_forecast_day_sum' },
				{ data: 'irreg_count_forecast_day_rate' },
				{ data: 'irreg_accuracy_rate' }
			],
			initComplete: function(settings, json){
		 	 	var toolbar = '<label>기간: '
		 	 				+ '<input type="text" class="form-control input-sm" name="date_st" value="'+today_date_st+'" readOnly /> ~ '
		 	 				+ '<input type="text" class="form-control input-sm" name="date_ed" /> '
		 	 				+ '<button type="button" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> 검색</button>';

		 		$modal.find('.dataTables_filter').html(toolbar)
					  .find('input[name=date_ed]').datepicker({
				 			onClose: function(d) {
				 				var dt = new Date(d);
				 		       	var newDate = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate()-7).formatter('yyyy-mm-dd');
								$modal.find('input[name=date_st]').val(newDate);
				 			}
					   }).val(today_date_ed);

		 		$modal.find('.btn-primary').on('click',function(){
			 		$('#'+id).DataTable().ajax.reload();
			 	})
		    }
		});
	 	$modal.find('.btn-primary').on('click',function(){
	 		$dataTable.ajax.reload();
	 	})
		
	}
	
}).on('hide.bs.modal', function (e) {
	$('#${param.id}').find('tbody').remove();
	$('#${param.id}').DataTable().destroy();
});

</script>