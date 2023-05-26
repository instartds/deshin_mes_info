<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- second modal -->
<div class="modal" id="multi_modal" style="display: none; z-index: 1060;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h4 class="modal-title" id="myModalLabel">사출기 생산과정 - <span id="catapultProductionProcessSpan"></span></h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="multi_modal_table" style="width: 100%;">
								<thead>
									<tr>
										<th>일자</th>
										<th>시간</th>
										<th>데이터 (<span id="catapultProductionProcessUnitSpan"></span>)</th>
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
<!-- /second modal -->

<input type="hidden" id="column_value" />

<script type="text/javascript" charset="utf-8">

 $('#multi_modal').on('show.bs.modal', function (e) {
	var $modal = $('#multi_modal'),
		$target = $('#multi_modal_table'),
		today = (new Date()).formatter('yyyy-mm-dd');
	
	 if($target.DataTable){
		 
		 var $dataTable = $target.DataTable({
		 		ajax: {
		 			url:'<c:url value="/dashboard/modal/catapult_production_process_detail.json"/>',
		 			data:function(d){
		 				var settings = $target.dataTable().fnSettings();
		 				var date_st = $modal.find('input[name=date_st]').val();
	 					var date_ed = $modal.find('input[name=date_ed]').val();
	 					
		 				return {
		 					draw : settings.iDraw,
		 					start : settings._iDisplayStart,
		 					length : settings._iDisplayLength,
		 					date_st: date_st ? date_st : today,
							date_ed: date_ed ? date_ed : today
		 				}
		 			},
		 		},
				columns: [
					{ data: 'date_string' },
					{ data: 'time_string' },
					{ data: $("#column_value").val() }
				]
			});
		 	$modal.find('.btn-primary').on('click',function(){
		 		$dataTable.ajax.reload();
		});
	 }
}).on('hide.bs.modal', function (e) {
	$('#multi_modal_table').DataTable().destroy();
});

</script>