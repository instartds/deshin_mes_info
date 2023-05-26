<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- Modal -->
<div class="modal fade" id="modal_${param.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog">
		<c:import url="/dashboard/modal/test?id=test" />
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="myModalLabel">프리폼 생산추이@@@@@@</h4>
			</div>
			<div class="modal-body">
			
				<div class="row">
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">1</div>
									<div class="col-xs-2"><i class="fa fa-bars fa-lg" data-toggle="modal" data-target="#modal_dd"></i></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">2</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">3</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">4</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">5</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">6</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">7</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
						</div>
					</div>
					<div class="col-lg-3 col-md-6">
						<div class="panel panel-list">
							<div class="panel-heading">
								<div class="row">
									<div class="col-xs-8 col-xs-offset-2 text-center">8</div>
									<div class="col-xs-2"></div>
								</div>
							</div>
							<div class="list-group sqn-main-body" id="">
							</div>
							<div class="panel-footer text-center" style="padding: 10px 15px;">
								<i class="fa fa-clock-o fa-lg"></i> <span>23:59:45</span>
							</div>
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
</script>