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
				<h4 class="modal-title" id="myModalLabel">사출기 생산과정 </h4>
			</div>
			<div class="modal-body">
				<div>
					데이터 기준 시간 : <span id="std_time"></span>
				</div>
				<div class="dataTable_wrapper">
					<div class="row">
						<div class="col-sm-12">
							<table width="100%" class="table table-striped table-bordered table-hover dataTable no-footer dtr-inline" id="${param.id}" role="grid" style="width: 100%;">
								<thead>
									<tr>
										<th>요인</th>
										<th>실시간 데이터</th>
									</tr>
								</thead>
								<tbody>
								
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_tim_fil" class="multiModal" unit="sec">충전 시간</a>
										</td>
										<td id="act_tim_fil_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_tim_plst" class="multiModal" unit="sec">가소 시간</a>
										</td>
										<td id="act_tim_plst_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_tim_cyc" class="multiModal" unit="sec">주기 시간</a>
										</td>
										<td id="act_tim_cyc_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_str_csh" class="multiModal" unit="mm">쿠션 스트로크 위치</a>
										</td>
										<td id="act_str_csh_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vol_csh" class="multiModal" unit="㎤">쿠션 부피</a>
										</td>
										<td id="act_vol_csh_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_str_plst" class="multiModal" unit="mm">가소 스트로크위치</a>
										</td>
										<td id="act_str_plst_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vol_plst" class="multiModal" unit="㎤">가소 부피</a>
										</td>
										<td id="act_vol_plst_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_dia_scr" class="multiModal" unit="mm">스크류 지름</a>
										</td>
										<td id="act_dia_scr_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_str_dcmp_pre" class="multiModal" unit="mm">가소 전 감압길이</a>
										</td>
										<td id="act_str_dcmp_pre_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vol_dcmp_pre" class="multiModal" unit="㎤">가소 전 감압부피</a>
										</td>
										<td id="act_vol_dcmp_pre_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_str_dcmp_pst" class="multiModal" unit="mm">가소 후 감압길이</a>
										</td>
										<td id="act_str_dcmp_pst_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vol_dcmp_pst" class="multiModal" unit="㎤">가소 후 감압부피</a>
										</td>
										<td id="act_vol_dcmp_pst_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_str_xfr" class="multiModal" unit="mm">전달 길이</a>
										</td>
										<td id="act_str_xfr_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vol_xfr" class="multiModal" unit="㎤">전달 볼륨</a>
										</td>
										<td id="act_vol_xfr_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_xfr_hyd" class="multiModal" unit="bar">전달 유압</a>
										</td>
										<td id="act_prs_xfr_hyd_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_xfr_cav" class="multiModal" unit="bar">금형 내부 압력</a>
										</td>
										<td id="act_prs_xfr_cav_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_xfr_spec" class="multiModal" unit="bar">금형 특정 압력</a>
										</td>
										<td id="act_prs_xfr_spec_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_tim_xfr" class="multiModal" unit="sec">전달 시간</a>
										</td>
										<td id="act_tim_xfr_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_cav_max" class="multiModal" unit="bar">금형 내부 최대압력</a>
										</td>
										<td id="act_prs_cav_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_mach_hyd_max" class="multiModal" unit="bar">최대 유압</a>
										</td>
										<td id="act_prs_mach_hyd_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_mach_spec_max" class="multiModal" unit="bar">특정 최대유압</a>
										</td>
										<td id="act_prs_mach_spec_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_spd_plst_max" class="multiModal" unit="RPM">가소 최대 속력</a>
										</td>
										<td id="act_spd_plst_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_spd_plst_ave" class="multiModal" unit="RPM">가소 평균 속력</a>
										</td>
										<td id="act_spd_plst_ave_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vel_plst_max" class="multiModal" unit="㎜/sec">가소 최대 속도</a>
										</td>
										<td id="act_vel_plst_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_vel_plst_ave" class="multiModal" unit="㎜/sec">가소 평균 속도</a>
										</td>
										<td id="act_vel_plst_ave_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_frc_clp" class="multiModal" unit="KN">형 조임력</a>
										</td>
										<td id="act_frc_clp_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_hld_hyd_max" class="multiModal" unit="bar">유지 유압 최대값</a>
										</td>
										<td id="act_prs_hld_hyd_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_hld_hyd_ave_max" class="multiModal" unit="bar">유지 유압 평균값</a>
										</td>
										<td id="act_prs_hld_hyd_ave_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_plst_hyd_max" class="multiModal" unit="bar">가소 유압 최대값</a>
										</td>
										<td id="act_prs_plst_hyd_max_text"></td>
									</tr>
									<tr>
										<td>
											<a data-toggle="modal" href="#multi_modal" id="act_prs_plst_hyd_ave_max" class="multiModal" unit="bar">가소 유압 평균값</a>
										</td>
										<td id="act_prs_plst_hyd_ave_max_text"></td>
									</tr>
									
								</tbody>
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

<jsp:include page="catapult_production_process_detail.jsp" flush="false" />
<script type="text/javascript" charset="utf-8">
$('#modal_${param.id}').on('show.bs.modal', function (e) {
	var id = "${param.id}",
		$modal = $('#modal_'+id),
		$target = $('#'+id);
	
	 if($target.DataTable){
		 
	 	$modal.find('.btn-primary').on('click',function(){
	 		$dataTable.ajax.reload();
	 	});
	 	
	 	$.ajax({ 
			type:"GET",
			dataType:"json",  
			url: "<c:url value='/dashboard/modal/catapult_production_process.json'/>",
			success:function(data) {
				
				$("#std_time").html(data.data[0].std_time);
				
				$("#act_tim_fil_text").html(data.data[0].act_tim_fil+ " sec");
				$("#act_tim_plst_text").html(data.data[0].act_tim_plst+ " sec");
				$("#act_tim_cyc_text").html(data.data[0].act_tim_cyc+ " sec");
				$("#act_str_csh_text").html(data.data[0].act_str_csh+ " mm");
				$("#act_vol_csh_text").html(data.data[0].act_vol_csh+ " ㎤");
				$("#act_str_plst_text").html(data.data[0].act_str_plst+ " mm");
				$("#act_vol_plst_text").html(data.data[0].act_vol_plst+ " ㎤");
				$("#act_dia_scr_text").html(data.data[0].act_dia_scr+ " mm");
				$("#act_str_dcmp_pre_text").html(data.data[0].act_str_dcmp_pre+ " mm");
				$("#act_vol_dcmp_pre_text").html(data.data[0].act_vol_dcmp_pre+ " ㎤");
				$("#act_str_dcmp_pst_text").html(data.data[0].act_str_dcmp_pst+ " mm");
				$("#act_vol_dcmp_pst_text").html(data.data[0].act_vol_dcmp_pst+ " ㎤");
				$("#act_str_xfr_text").html(data.data[0].act_str_xfr+ " mm");
				$("#act_vol_xfr_text").html(data.data[0].act_vol_xfr+ " ㎤");
				$("#act_prs_xfr_hyd_text").html(data.data[0].act_prs_xfr_hyd+ " bar");
				$("#act_prs_xfr_cav_text").html(data.data[0].act_prs_xfr_cav+ " bar");
				$("#act_prs_xfr_spec_text").html(data.data[0].act_prs_xfr_spec+ " bar");
				$("#act_tim_xfr_text").html(data.data[0].act_tim_xfr+ " sec");
				$("#act_prs_cav_max_text").html(data.data[0].act_prs_cav_max+ " bar");
				$("#act_prs_mach_hyd_max_text").html(data.data[0].act_prs_mach_hyd_max+ " bar");
				$("#act_prs_mach_spec_max_text").html(data.data[0].act_prs_mach_spec_max+ " bar");
				$("#act_spd_plst_max_text").html(data.data[0].act_spd_plst_max+ " RPM");
				$("#act_spd_plst_ave_text").html(data.data[0].act_spd_plst_ave+ " RPM");
				$("#act_vel_plst_max_text").html(data.data[0].act_vel_plst_max+ " ㎜/sec");
				$("#act_vel_plst_ave_text").html(data.data[0].act_vel_plst_ave+ " ㎜/sec");
				$("#act_frc_clp_text").html(data.data[0].act_frc_clp+ " KN");
				$("#act_prs_hld_hyd_max_text").html(data.data[0].act_prs_hld_hyd_max+ " bar");
				$("#act_prs_hld_hyd_ave_max_text").html(data.data[0].act_prs_hld_hyd_ave_max+ " bar");
				$("#act_prs_plst_hyd_max_text").html(data.data[0].act_prs_plst_hyd_max+ " bar");
				$("#act_prs_plst_hyd_ave_max_text").html(data.data[0].act_prs_plst_hyd_ave_max+ " bar");

			},
			error:function() {}
		});
	}
}).on('hide.bs.modal', function (e) {
// 	$('#${param.id}').DataTable().destroy();
});

$('.multiModal').click(function() {
	$('#catapultProductionProcessSpan').html(this.text);
	$('#column_value').val(this.id);
	$('#catapultProductionProcessUnitSpan').html($(this).attr('unit'));
});

</script>