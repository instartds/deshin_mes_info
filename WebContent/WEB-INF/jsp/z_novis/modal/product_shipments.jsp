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
				<h4 class="modal-title" id="myModalLabel">제품 출하량</h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th>일시</th>
										<th>프리폼 투입량 (개)</th>
										<th>500ml 패키지 (set)</th>
										<th>500ml 낱개 (개)</th>
										<th>2L 패키지 (set)</th>
										<th>2L 낱개 (개)</th>
										<th>출하량 계 (개)</th>
										<th>불량 (개)</th>
										<th>불량율</th>
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
	 			url:'<c:url value="/dashboard/modal/product_shipments.json"/>',
	 			data:function(d){
	 				var settings = $target.dataTable().fnSettings();
	 				var date_st = $modal.find('input[name=date_st]').val();
 					var date_ed = $modal.find('input[name=date_ed]').val();
 					
 					/*
 					var col = new Array(); // array
 					for(var index in settings.aoColumns){ col.push(settings.aoColumns[index].sName) };
 					var ord = {"column" : settings.aLastSort[0].col, "dir" : settings.aLastSort[0].dir};
 					*/
 					
	 				return {
	 					draw : settings.iDraw,
	 					start : settings._iDisplayStart,
	 					length : settings._iDisplayLength,
// 	 					columns: col,
// 	 					order: ord,
	 					date_st: date_st ? date_st : today,
						date_ed: date_ed ? date_ed : today
	 				}
	 			},
	 		},
		    initComplete: function(settings, json){
		    	var id = this[0].id;
		    	var $modal = $(this).parent();
		    	
			 	var toolbar =
			 		'<label>기간:<input type="text" class="form-control input-sm" name="date_st" /></label>'
			 		+' <button type="button" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> 검색</button>'
			 		$modal.find('.dataTables_filter').html(toolbar)
		 			.find('input[name=date_st]').datepicker().val((new Date()).formatter('yyyy-mm-dd'));

			 		$modal.find('.btn-primary').on('click',function(){
			 		$('#'+id).DataTable().ajax.reload();
			 	})
		    },
			columns: [
				{ data: 'date_string' },
				{ data: 'input_count1' },
				{ data: 'count_500ml_set' },
				{ data: 'count_500ml_piece' },
				{ data: 'count_2l_set' },
				{ data: 'count_2l_piece' },
				{ data: 'total_piece' },
				{ data: 'irreg_count' },
				{ data: 'irreg_rate' },
			]
		});
	 	$modal.find('.btn-primary').on('click',function(){
	 		$dataTable.ajax.reload();
	 	})
	 	
	}
}).on('hide.bs.modal', function (e) {
	$('#${param.id}').DataTable().destroy();
});

</script>