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
				<h4 class="modal-title" id="myModalLabel">기타 온도</h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th>일자</th>
										<th>시간</th>
										<th>오일 실온도</th>
										<th>수입구 온도</th>
										<th>수출구 온도</th>
										<th>캐비닛 온도</th>
										<th>녹는 온도</th>
									</tr>
									<tr style="background-color: #dbeef4;">
										<th colspan="2" style="text-align: center;">최적온도</th>
										<td id="act_tmp_oil" style="color: #0070c0;"></td>
										<td id="act_tmp_wtr_in" style="color: #0070c0;"></td>
										<td id="act_tmp_wtr_out" style="color: #0070c0;"></td>
										<td id="act_tmp_cab" style="color: #0070c0;"></td>
										<td id="act_tmp_mlt" style="color: #0070c0;"></td>
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
	 			url:'<c:url value="/dashboard/modal/etc_temperature.json"/>',
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
			columns: [
				{ data: 'date_string' },
				{ data: 'time_string' },
				{ data: 'act_tmp_oil' },
				{ data: 'act_tmp_wtr_in' },
				{ data: 'act_tmp_wtr_out' },
				{ data: 'act_tmp_cab' },
				{ data: 'act_tmp_mlt' },
			] 
		});
	 	$modal.find('.btn-primary').on('click',function(){
	 		$dataTable.ajax.reload();
	 	})
	 	
	}
	
	//최적온도 검색
	$.ajax({ 
		type:"GET",
		dataType:"json",  
		url: "<c:url value='/dashboard/modal/std_etc_temperature.json'/>",
		success:function(data) {
			
			$("#act_tmp_oil").html(data.data[0].act_tmp_oil);
			$("#act_tmp_wtr_in").html(data.data[0].act_tmp_wtr_in);
			$("#act_tmp_wtr_out").html(data.data[0].act_tmp_wtr_in);
			$("#act_tmp_cab").html(data.data[0].act_tmp_cab);
			$("#act_tmp_mlt").html(data.data[0].act_tmp_mlt);
			
		},
		error:function() {}
	});
	
}).on('hide.bs.modal', function (e) {
	$('#${param.id}').DataTable().destroy();
});

</script>