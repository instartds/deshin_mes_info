<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- Modal -->
<div class="modal fade" id="modal_${param.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
	<div class="modal-dialog" style="width: 510px;margin: 10% auto;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title" id="myModalLabel">불량 인자</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12" id="${param.id}" >
						<img src="<c:url value="/resources/css/dashboard/img2/heatmap.png"/>">
<!-- 						<img src="http://112.220.253.106:9999/resources/img2/heatmap.png"> -->
					</div>
				</div>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /Modal -->

<script src="https://code.highcharts.com/modules/heatmap.js"></script>
<script type="text/javascript" charset="utf-8">
$('#modal_${param.id}').on('show.bs.modal', function (e) {
	/*
	$.ajax({
		url: CONTEXT_ROOT + 'dashboard/modal/issue_report_detail.json',
		success: function(jsonData){
			var data = jsonData.data[0]
				categories = [],
				seriesData = [];
			
			$(data).each(function(){
				categories.push(this.event_name_en);
			});
			
			console.log(categories)
			for(var i=0;i<categories.length;i++){
				for(var j=0;j<categories.length;j++){
					seriesData.push([i, j, data[i]['event_value'+(j+1)].format(2)]);
				}
			}
			
			$('#${param.id}').highcharts({
		
		        chart: {
		            type: 'heatmap',
		            marginTop: 40,
		            marginBottom: 80,
		            plotBorderWidth: 1
		        },
		        title: {
		            text: ''
		        },
		        xAxis: {
		            categories: categories
		        },
		        yAxis: {
		            categories: categories,
		            title: null
		        },
		        colorAxis: {
		            min: 0,
		            minColor: '#FFFFFF',
		            maxColor: '#7cb5ec'
// 		            maxColor: Highcharts.getOptions().colors[0]
		        },
		        legend: {
		            align: 'right',
		            layout: 'vertical',
		            margin: 0,
		            verticalAlign: 'top',
		            y: 25,
		            symbolHeight: 280
		        },
// 		        tooltip: {
// 		            formatter: function () {
// 		                return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> sold <br><b>' +
// 		                    this.point.value + '</b> items on <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>';
// 		            }
// 		        },
		        series: [{
		            name: 'Sales per employee',
		            borderWidth: 1,
// 		            data: [[0, 0, 10], [0, 1, 19], [0, 2, 8], [0, 3, 24], [0, 4, 67], [1, 0, 92], [1, 1, 58], [1, 2, 78], [1, 3, 117], [1, 4, 48], [2, 0, 35], [2, 1, 15], [2, 2, 123], [2, 3, 64], [2, 4, 52], [3, 0, 72], [3, 1, 132], [3, 2, 114], [3, 3, 19], [3, 4, 16], [4, 0, 38], [4, 1, 5], [4, 2, 8], [4, 3, 117], [4, 4, 115], [5, 0, 88], [5, 1, 32], [5, 2, 12], [5, 3, 6], [5, 4, 120], [6, 0, 13], [6, 1, 44], [6, 2, 88], [6, 3, 98], [6, 4, 96], [7, 0, 31], [7, 1, 1], [7, 2, 82], [7, 3, 32], [7, 4, 30], [8, 0, 85], [8, 1, 97], [8, 2, 123], [8, 3, 64], [8, 4, 84], [9, 0, 47], [9, 1, 114], [9, 2, 31], [9, 3, 48], [9, 4, 91]],
		            data: seriesData,
		            dataLabels: {
		                enabled: true,
		                color: '#000000'
		            }
		        }]
		
		    });
		},
		error: function(jqXHR, textStatus, errorThrown){
			console.error(jqXHR, textStatus, errorThrown);
		}
	});
	*/
	
	
});

</script>