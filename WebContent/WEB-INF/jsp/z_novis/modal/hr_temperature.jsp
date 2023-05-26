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
				<h4 class="modal-title" id="myModalLabel">HR 온도 설정/실제 정보</h4>
			</div>
			<div class="modal-body">
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th rowspan="2" style="text-align: center; vertical-align: middle;">time</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z501</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z502</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z504</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z505</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z506</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z507</th>
										<th colspan="2" style="text-align: center; vertical-align: middle; ">Z508</th>
									</tr>
									<tr>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
										<th style="text-align: center; vertical-align: middle;">설정값</th>
										<th style="text-align: center; vertical-align: middle;">실제값</th>
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
	 			url:'<c:url value="/dashboard/modal/hr_temperature.json"/>',
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
				{ data: 'time' },
				{ data: 'mold_h_heat1_z501set' },
				{ data: 'mold_h_heat1_z501act' },
				{ data: 'mold_h_heat1_z502set' },
				{ data: 'mold_h_heat1_z502act' },
				{ data: 'mold_h_heat1_z504set' },
				{ data: 'mold_h_heat1_z504act' },
				{ data: 'mold_h_heat1_z505set' },
				{ data: 'mold_h_heat1_z505act' },
				{ data: 'mold_h_heat1_z506set' },
				{ data: 'mold_h_heat1_z506act' },
				{ data: 'mold_h_heat1_z507set' },
				{ data: 'mold_h_heat1_z507act' },
				{ data: 'mold_h_heat1_z508set' },
				{ data: 'mold_h_heat1_z508act' }
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