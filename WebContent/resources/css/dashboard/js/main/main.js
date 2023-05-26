(function(){
	Highcharts.theme = {
		colors: ['#45abaa', '#77bc8e', '#37acd6', '#bc9c76', '#9e76bc', '#f83030', '#c3cfd8'],
		chart: {
		},
		exporting: {
			enabled: false
		},
		credits: {
			enabled: false
		}
	};
	
	//Apply the theme
	Highcharts.setOptions(Highcharts.theme);
})();

/*
 * 상단 영역 관련
 */
var TOP = {
	init: function(){
		this.clock.init();
		this.summary.init();
	},
	
	clock: {
		init: function(){
			this.set();
			setInterval(this.set, 1*1000);  // 1초
		},
		set: function(){
			var me = TOP.clock,
				dt = new Date(),
				mm = me.getClassArr(dt.getMonth()+1),
				dd = me.getClassArr(dt.getDate()),
				hh24 = me.getClassArr(dt.getHours()),
				mi = me.getClassArr(dt.getMinutes()),
				ss = me.getClassArr(dt.getSeconds());
			
			$('#top_clock_date div[name=month_before]').attr('class', mm[0]);
			$('#top_clock_date div[name=month_after]').attr('class', mm[1]);
			$('#top_clock_date div[name=date_before]').attr('class', dd[0]);
			$('#top_clock_date div[name=date_after]').attr('class', dd[1]);
			
			$('#top_clock_current div[name=month_before]').attr('class', mm[0]);
			$('#top_clock_current div[name=month_after]').attr('class', mm[1]);
			$('#top_clock_current div[name=date_before]').attr('class', dd[0]);
			$('#top_clock_current div[name=date_after]').attr('class', dd[1]);
			
			$('#top_clock_current div[name=hours_before]').attr('class', hh24[0]);
			$('#top_clock_current div[name=hours_after]').attr('class', hh24[1]);
			$('#top_clock_current div[name=minutes_before]').attr('class', mi[0]);
			$('#top_clock_current div[name=minutes_after]').attr('class', mi[1]);
			$('#top_clock_current div[name=seconds_before]').attr('class', ss[0]);
			$('#top_clock_current div[name=seconds_after]').attr('class', ss[1]);
			
			
			me.newClock();
			//설정시간 세팅
			/*$.ajax({
//				type: 'POST',
				url: CONTEXT_ROOT+'dashboard/main/setting_time.json',
				success: function(jsonData){
					var data = jsonData.data[0];
					if(data){
						var ydt = new Date(Date.parse(dt) - 1 * 1000 * 60 * 60 * 24),
						ymm = me.getClassArr(data.mm),
						ydd = me.getClassArr(data.dd),
						yhh24 = me.getClassArr(data.hh24),
						ymi = me.getClassArr(data.mi),
						yss = me.getClassArr(data.ss);
						
						$('#top_clock_setting div[name=month_before]').attr('class', ymm[0]);
						$('#top_clock_setting div[name=month_after]').attr('class', ymm[1]);
						$('#top_clock_setting div[name=date_before]').attr('class', ydd[0]);
						$('#top_clock_setting div[name=date_after]').attr('class', ydd[1]);
						
						$('#top_clock_setting div[name=hours_before]').attr('class', yhh24[0]);
						$('#top_clock_setting div[name=hours_after]').attr('class', yhh24[1]);
						$('#top_clock_setting div[name=minutes_before]').attr('class', ymi[0]);
						$('#top_clock_setting div[name=minutes_after]').attr('class', ymi[1]);
						$('#top_clock_setting div[name=seconds_before]').attr('class', yss[0]);
						$('#top_clock_setting div[name=seconds_after]').attr('class', yss[1]);
					}
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});*/

			
		},
		getClassArr: function(num){
			var dd = 'time_';
			num = String(num)
			return num.length>1 ? [dd+num[0],dd+num[1]] : [dd+'0',dd+num];
		},
		newClock: function(){
			var me = TOP.clock;
			var clock = document.getElementById("clock");            // 출력할 장소 선택
		    var currentDate = new Date();                                     // 현재시간
		    var calendar = currentDate.getFullYear() + "<span style='font-size:10px;'>년 </span>" + (currentDate.getMonth()+1) + "<span style='font-size:10px;'>월 </span>" + currentDate.getDate()+"<span style='font-size:10px;'>일 </span>" // 현재 날짜
		    var amPm = 'AM'; // 초기값 AM
		    var currentHours = me.addZeros(currentDate.getHours(),2); 
		    var currentMinute = me.addZeros(currentDate.getMinutes() ,2);
		    var currentSeconds =  me.addZeros(currentDate.getSeconds(),2);
		    
		    if(currentHours >= 12){ // 시간이 12보다 클 때 PM으로 세팅, 12를 빼줌
		    	amPm = 'PM';
		    	currentHours = me.addZeros(currentHours - 12,2);
		    }

		    if(currentSeconds >= 50){// 50초 이상일 때 색을 변환해 준다.
		       currentSeconds = '<span style="color:#de1951;">'+currentSeconds+'</span>'
		    }
		    clock.innerHTML = '<i class="fa fa-lg fa-cart-plus"></i>';
		    clock.innerHTML = calendar + " " + currentHours+":"+currentMinute+":"+currentSeconds +" <span style='font-size:10px;'>"+ amPm+"</span>"; //날짜를 출력해 줌

		},
		addZeros: function(num, digit){
			 var zero = '';
			  num = num.toString();
			  if (num.length < digit) {
			    for (i = 0; i < digit - num.length; i++) {
			      zero += '0';
			    }
			  }
			  return zero + num;
		}
		
	},
	
	summary: {
		init: function(){
			this.set();
			setInterval(this.set,3*1000); // 3초
		},
		set: function(){
			$.ajax({
			//				type: 'POST',
				url: 's_mes100skrv_novisSelectList',
				success: function(jsonData){
					var data = jsonData;
					if(data.length > 0){
						$(data).each(function(i, list){
							if(data[i]['COMM_EQPMN_IP'] == '192.168.0.231'){
								//jQuery('#summary_preform_0').text('888');
								//$('#summary_preform_0').text(0);
								if($('#cboProdtName1').val() == "") 
									$('#cboProdtName1').val(data[i]['ITEM_NAME']);
								if(data[i]['YN_OPER'] == 'True')
									$('#summery_1_status').html('<div class="circle1"></div>');
								else if (data[i]['YN_OPER'] == 'False')
									$('#summery_1_status').html('<div class="circle2"></div>');
								else
									$('#summery_1_status').html('<div class="circle3"></div>');
								$('#summery_1_equip').animateNumber({
									number : data[i]['QTY_PRODT'], 
									numberStep: $.animateNumber.numberStepFactories.separator(',', 3, '')}
								);
								$('#summery_1_st_time').text(data[i]['TIME_START_OPER']);
								$('#summery_1_op_time').text(data[i]['TIME_OPER']);
								$('#summery_1_op_stop').text(data[i]['TIME_STOP']);
								$('#summery_1_stop_cnt').text(data[i]['CNT_STOP']);
							}else{
								if($('#cboProdtName2').val() == "") 
									$('#cboProdtName2').val(data[i]['ITEM_NAME']);
								if(data[i]['YN_OPER'] == 'True')
									$('#summery_2_status').html('<div class="circle1"></div>');
								else if (data[i]['YN_OPER'] == 'False')
									$('#summery_2_status').html('<div class="circle2"></div>');
								else
									$('#summery_2_status').html('<div class="circle3"></div>');
								$('#summery_2_equip').animateNumber({
									number : data[i]['QTY_PRODT'], 
									numberStep: $.animateNumber.numberStepFactories.separator(',', 3, '')}
								);
								$('#summery_2_st_time').text(data[i]['TIME_START_OPER']);
								$('#summery_2_op_time').text(data[i]['TIME_OPER']);
								$('#summery_2_op_stop').text(data[i]['TIME_STOP']);
								$('#summery_2_stop_cnt').text(data[i]['CNT_STOP']);
							}
						});
					}else{
						$('#summary_preform_0').animateNumber({number : 0});
						$('#summary_preform_1').text('00:00:00');
						$('#summary_preform_2').text('00:00:00');
						$('#summary_preform_3').animateNumber({number : 0});
						$('#summary_preform_4').text('00:00:00');
						$('#summary_preform_5').text('00:00:00');
					}
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});
			
			//tes
			//$('#summary_preform_0').animateNumber({number : 10 });
			//$('#summary_preform_1').animateNumber({number : 5  });
			//$('#summary_preform_2').animateNumber({number : 50 });
			//$('#summary_preform_3').animateNumber(data.irreg_count_rate);
			
//			var tab1 = $('#nav-tabs>li:eq(0)').hasClass('active'),
//				tab2 = $('#nav-tabs>li:eq(1)').hasClass('active');
			/*var tab1 = (location.href.indexOf('preform') > -1),
				tab2 = (location.href.indexOf('water') > -1);
			
			if(tab1){
				$.ajax({
//					type: 'POST',
					url: CONTEXT_ROOT+'dashboard/main/summary_preform.json',
					success: function(jsonData){
						var data = jsonData.data[0][0];
						if(data){
							$('#summary_preform_0').animateNumber(data.weight_day_sum, 0);
							$('#summary_preform_1').animateNumber(data.input_count_day_sum);
							$('#summary_preform_2').animateNumber(data.irreg_count_day_sum);
							//$('#summary_preform_3').animateNumber(data.irreg_count_rate);
							
							// 2017-07-04 임시로 하드코딩 (추후 DB에서 가져온값으로 뿌린다.)
							var irreg_count_rate = 0;
							if(data.irreg_count_day_sum > -1){
								irreg_count_rate = data.irreg_count_day_sum * 0.99;
							}
							
							$('#summary_preform_3').animateNumber(parseInt(irreg_count_rate));
							
							
							//$('#summary_preform_4').animateNumber(data.irreg_rate, 2);
							//$('#summary_preform_5').animateNumber(data.irreg_accuracy_rate, 2);
							//$('#summary_preform_6').animateNumber(data.irreg_accuracy_error_rate, 2);
						}
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.error(jqXHR, textStatus, errorThrown);
					}
				});
			}else if(tab2){
				$.ajax({
//					type: 'POST',
					url: CONTEXT_ROOT+'dashboard/main/summary_water.json',
					success: function(jsonData){
						var data = jsonData.data[0][0];
						if(data){
							$('#summary_water_0').animateNumber(data.weight_day_sum);
							$('#summary_water_1').animateNumber(data.input_count_day_sum);
							$('#summary_water_2').animateNumber(data.irreg_count_day_sum);
							$('#summary_water_3').animateNumber(data.irreg_count_forecast_day_sum);
							//$('#summary_water_4').animateNumber(data.irreg_rate, 2);
							//$('#summary_water_5').animateNumber(data.irreg_accuracy_rate, 2);
							//$('#summary_water_6').animateNumber(data.irreg_accuracy_error_rate, 2);
						}
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.error(jqXHR, textStatus, errorThrown);
					}
				});
			}*/
				
		}
	}
};

/*
 * 메인 차트 & 리스트관련
 */
var MAIN_INTERVAL;
var MAIN = {
	cls: 'panel-green',	// default, primary, success, info, warning, danger, green, yellow, red
	chart:{
		live:{
			getData: function(id, type){
				var me = this;
				var paramId = id;
				$.ajax({
					url: 's_mes100skrv_novisSelectProductionCnt2',
					//type:'json',
					//data: {id: paramId},
//					data:{
//						type:type
//					},
					success: function(jsonData){
						
//						if(type != $('#nav-tabs > li.active').index()){	// 데이터를 가져온 도중에 탭이 바꼈으면 그리지 않음
//							return ;
//						}else{
						//console.log(jsonData.data);
						
							var data = jsonData,
							opt = {
									h_sum_prodt_1: [],
									h_sum_prodt_2: []
							};
							
							
							$(data).each(function(){
								var dt = this.DT;
								opt.h_sum_prodt_1.push([dt, this.H_SUM_PRODT_1]);
								opt.h_sum_prodt_2.push([dt, this.H_SUM_PRODT_2]);
								
							});
							if($('#'+id).highcharts()){
								var series = $('#'+id).highcharts().series;
								series[0].setData(opt.h_sum_prodt_1);
								series[1].setData(opt.h_sum_prodt_2);
								
							}else{
								me.draw(id, opt, type);
							}
							setTimeout(function () {
								me.getData(paramId, type)
							}, 3*1000);
//						}
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.error(jqXHR, textStatus, errorThrown);
					}
				});
			},
			
			draw: function(id, opt, type){
				var me = this;
				$('#'+id).highcharts('StockChart', {
					chart : {
						events : {
							load : function () {
								/*MAIN_INTERVAL = setInterval(function () {
									me.getData(id, type)
								}, 15*1000);*/
							}
						}
					},
					navigator:{
						enabled: false
						/*yAxis:{
							min: 0
						}*/
					},
					rangeSelector: false,
					/*{
						buttonTheme: { // styles for the buttons
							fill: 'none',
							stroke: 'none',
							'stroke-width': 0,
							r: 8,
			                width:50,
							buttonSpacing:250,
							style: {
								color: '#039',
								fontWeight: 'bold'
							},
						},
						buttons: [{
							
							type: 'all',
							text: '전체'
						}, {
							count: 60*3,
							type: 'minute',
							text: '3시간'
						}, {
							count: 60*6,
							type: 'minute',
							text: '6시간'
						},{
							count: 60*9,
							type: 'minute',
							text: '9시간'
						}],
						inputEnabled: false,
//						inputEnabled: true,
//						inputDateFormat: '%Y-%m-%d',
//						inputEditDateFormat: '%Y-%m-%d',
						selected: 0
						,dateTimeLabelFormats: {
			                second: '%H:%M',
			                minute: '%H:%M',
			                hour: '%H:%M',
			                day: '%H:%M:%S<br>%Y-%m-%d',
			                week: '%Y<br/>%m-%d %H:%M',
			                month: '%Y-%m',
			                year: '%Y'
			            }
					},*/
					scrollbar: {
			            enabled: false
			        },
					title : false,
					
			        legend: {
			            enabled: true,
			            x:-23,
			            borderColor: '#D9D9D9',
			            borderWidth: 1,
			            align: 'right',
			            verticalAlign: 'top',
			            //floating: !window.mobileAndTabletcheck()
			            //layout:'vertical'
			        },
			        
					xAxis: {
						labels: {
							formatter: function() {
								var seconds = parseInt((this.value/1000)%60);
								var minutes = parseInt((this.value/(1000*60))%60);
								var hours = parseInt((this.value/(1000*60*60))%24) + 9;
								return hours + ':' + (minutes == '0' ? '00' : minutes);
							}
						}
			        
						
					},
					yAxis: [{ // Primary yAxis
						max : 1500,
						min : 0,
						labels: {
							align:'right',
							x: 30,
							format: '{value}'
						},
						//endOnTick: false,
						opposite: false,	// false : 왼쪽   true : 오른쪽
				        //gridLineWidth: 1,	// 그리드 줄 굴기
				        //tickInterval: 1000,	// 구간정의
						title:{
							//text: '생산량',
							align: 'high',
							offset: 10,		//가로 margin
							rotation: 0,	//타이틀 기울
							y: 10,			//세로(아래로)타이틀 위치
							style: { "color": "#707070", "fontWeight": "bold" },
						},
					}
					, { // Secondary yAxis
						max : 1500,
						min : 0,
						opposite: true,
						//tickInterval: 1000,	// 구간정의
				   		gridLineWidth: 0,
				   		title:{
				   			//text: '생산',
				   			align: 'high',
				   			offset: 10,
				   			rotation: 0,
				   			y: 10,
							style: { "color": "#707070", "fontWeight": "bold" },
						}
					}],
					tooltip: {
						shared: true,
						formatter: function(a){
							var points = this.points;
							var tooltip = '<span style="font-size: 12px">'+(new Date(points[0].key))+'</span><br/>';
							for(var i=0; i<points.length; i++){
								if( points[i] != undefined){
									tooltip += '<span style="color:'+points[i].series.color+'">●</span> '+points[i].series.name +': <b>' + points[i].y + '</b> 개<br/>';
								}
							}
							return tooltip;
						}
					},
					exporting: {
						enabled: false
					},

					series : [{
						name : '생산량(10열Ⅰ)',
						color: 'rgb(69, 171, 170)',
						type:'column',
						yAxis: 1,
						data : opt.h_sum_prodt_1,
						dataGrouping:{
							enabled: false,
							approximation:'sum'
						}
					},/*{
						name : '불량 예측',
						color: '#c3cfd8',
						type:'column',
						yAxis: 1,
						data : opt.irreg_forecast,
						dataGrouping:{
							enabled: false,
//							approximation:'sum'
						}
					},*/{
						name : '생산량(10열 Ⅱ)',
						color: 'rgba(255,0,0,0.4)',
						type:'column',
						yAxis: 0,
						data : opt.h_sum_prodt_2,
						dataGrouping:{
							enabled: false,
//							approximation:'sum'
						}
					}]
				});
			}
		}
	},
	
	chart2 :{
		live:{
			getData: function(id, type){
				var me = this;
				var paramId = '192.168.0.232';
				$.ajax({
					url: 's_mes100skrv_novisSelectProductionCnt',
					//type:'json',
					data: {id: paramId},
//					data:{
//						type:type
//					},
					success: function(jsonData){
						
//						if(type != $('#nav-tabs > li.active').index()){	// 데이터를 가져온 도중에 탭이 바꼈으면 그리지 않음
//							return ;
//						}else{
						//console.log(jsonData.data);
						
							var data = jsonData,
							opt = {
									tot_sec_1: [],
									tot_sec_2: []
									
									
							};
							
							
							$(data).each(function(){
								var dt = this.DT;
								
								
								opt.tot_sec_1.push({x: dt, y: this.TOT_SEC_1, z: this.TOT_OPER_TIME_1});
								opt.tot_sec_2.push({x: dt, y: this.TOT_SEC_2, z: this.TOT_OPER_TIME_2});
								
							});
							if($('#'+id).highcharts()){
								var series = $('#'+id).highcharts().series;
								series[0].setData(opt.tot_sec_1);
								series[1].setData(opt.tot_sec_2);
								
							}else{
								me.draw(id, opt, type);
							}
							setTimeout(function () {
								me.getData(id, type)
							}, 3*1000);
//						}
					},
					error: function(jqXHR, textStatus, errorThrown){
						console.error(jqXHR, textStatus, errorThrown);
					}
				});
			},
			
			draw: function(id, opt, type){
				var me = this;
				$('#'+id).highcharts('StockChart', {
					chart : {
						type: 'spline',
						events : {
							load : function () {
								/*MAIN_INTERVAL = setInterval(function () {
									me.getData(id, type)
								}, 15*1000);*/
							}
						}
					},
					navigator:{
						enabled : false
						/*yAxis:{
							min:0
						}*/
					},
					scrollbar: {
			            enabled: false
			        },
			        rangeSelector: false,
					/*rangeSelector: {
						buttonTheme: { // styles for the buttons
							fill: 'none',
							stroke: 'none',
							'stroke-width': 0,
							r: 8,
			                width:50,
							buttonSpacing:250,
							style: {
								color: '#039',
								fontWeight: 'bold'
							},
						},
						buttons: [{
							
							type: 'all',
							text: '전체'
						}, {
							count: 60*3,
							type: 'minute',
							text: '3시간'
						}, {
							count: 60*6,
							type: 'minute',
							text: '6시간'
						},{
							count: 60*9,
							type: 'minute',
							text: '9시간'
						}],
						inputEnabled: false,
//						inputEnabled: true,
//						inputDateFormat: '%Y-%m-%d',
//						inputEditDateFormat: '%Y-%m-%d',
						selected: 0
						,dateTimeLabelFormats: {
			                second: '%H:%M',
			                minute: '%H:%M',
			                hour: '%H:%M',
			                day: '%H:%M:%S<br>%Y-%m-%d',
			                week: '%Y<br/>%m-%d %H:%M',
			                month: '%Y-%m',
			                year: '%Y'
			            }
					},*/

					title : false,
					
			        legend: {
			            enabled: true,
			            x:-23,
//			            borderColor: 'black',
			            borderColor: '#D9D9D9',
			            borderWidth: 1,
			            align: 'right',
			            verticalAlign: 'top',
			            //floating: !window.mobileAndTabletcheck(),
			            //layout:'vertical'
			        },
			        
					xAxis: {
						/*format: '{value}'*/
						labels: {
							/*format: '{value: %H:%M}'*/
							formatter: function() {
								var seconds = parseInt((this.value/1000)%60);
								var minutes = parseInt((this.value/(1000*60))%60);
								var hours = parseInt((this.value/(1000*60*60))%24) + 9;
								return hours + ':' + (minutes == '0' ? '00' : minutes);
							}
						}
						
					},
					plotOptions: {
					        series: {
					            lineWidth: 5
					        }
					},
					yAxis: [{ // Primary yAxis
							min: 0,
							max: 360,
							labels: {
								align:'right',
								x: 10,
								//format: '{value: %H:%M}'
								formatter: function() {
									
									return (parseInt(this.value % 3600 /60));
								}
							},
						opposite: true,
						title:{
							text: '',
							align: 'high',
							offset: 10,
							rotation: 0,
							y: 10,
							style: { "color": "#707070", "fontWeight": "bold" },
						},
					}
					, { // Secondary yAxis
						min: 0,
						max: 360,
						opposite:false,
						labels: {
							align:'right',
							x: 10,
							//format: '{value: %H:%M}'
							formatter: function() {
								
								return (parseInt(this.value % 3600 /60));
							}
						},
				   		title:{
				   			text: '',
				   			align: 'high',
				   			offset: 10,
				   			rotation: 0,
				   			y: 10,
							style: { "color": "#707070", "fontWeight": "bold" },
						}
					}],
					tooltip: {
						shared: true,
						formatter: function(a){
							var time = function (dataSeconds) {
								var seconds = parseInt((dataSeconds)%60);
								var minutes = parseInt((dataSeconds/(60))%60);
								var hours = parseInt((dataSeconds/(60*60))%24);
								
								return  hours + '시간 ' 
										+ (minutes == '0' ? '00' : minutes) + '분 ' 
										+ (seconds == '0' ? '00' : seconds) + '초';
							}
							var points = this.points;
							var tooltip = '<span style="font-size: 12px">'+(new Date(points[0].key))+'</span><br/>';
							
							for(var i=0; i<points.length; i++){
								if( points[i] != undefined){
									tooltip += '<span style="color:'+points[i].series.color+'">●</span> '+points[i].series.name +': <b>' + points[i].point.z + '</b><br/>';
								}
							}
							return tooltip;
						}
					},
					exporting: {
						enabled: false
					},

					series : [{
						name : '가동시간(10열Ⅰ)',
						color: 'rgb(69, 171, 170)',
						type:'column',
						yAxis: 1,
						data : opt.tot_sec_1,
						dataGrouping:{
							enabled: false,
//							approximation:'sum'
						}
					},/*{
						name : '불량 예측',
						color: '#c3cfd8',
						type:'column',
						yAxis: 1,
						data : opt.irreg_forecast,
						dataGrouping:{
							enabled: false,
//							approximation:'sum'
						}
					},*/{
						name : '가동시간(10열 Ⅱ)',
						type : 'column',
						color: 'rgba(255,0,0,0.4)',
						yAxis: 0,
						data : opt.tot_sec_2,
						dataGrouping:{
							enabled: false,
//							approximation:'sum'
						}
					}]
				});
			}
		}
	},
	
	list:{
		set: function(){
			var me = this;
			me.getData(120);		// start - fast
			setInterval(function(){
				me.getData(500);	// interval - normal
			},10*1000)  // 10초
		},
		getData: function(time){
			var me = this;
			$.ajax({
				url: 's_mes100skrv_novisQtyList',
				success: function(jsonData){
					var data = jsonData;
					me.update( data, time);
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});
			
		},
		update: function(jsonData, time){
			
			$('#issue_report > li').each(function(i, list){
				var $target = $(list).children();
				var ip = '192.168.0.231';
				setHtml($target, list, jsonData[i], i, ip)
			});
			
			$('#issue_report2 > li').each(function(i, list){
				var $target = $(list).children();
				var ip = '192.168.0.232';
				setHtml($target, list, jsonData[i], i, ip)
			});
			
			function setHtml($target, list, data, i, ip){
				var act1 = function(){
					if (i == 0)
					{
						$target.css({transition: '0.3s', transform: 'rotateX(180deg)'})	
					}
				};
				
				var act2 = function(data){
					if(data != null){
						var commYMD_231 = ((data.COMM_YMD_231) ? data.COMM_YMD_231 : '');
						var commQty_231 = (data.QTY_231) ? data.QTY_231 : '';
						var commYMD_232 = ((data.COMM_YMD_232) ? data.COMM_YMD_232 : '');
						var commQty_232 = (data.QTY_232) ? data.QTY_232 : '';
						if(ip == '192.168.0.231' && data.QTY_231)
							$(list).find('.list-text').html( '<span style="margin-left:10px">' + commYMD_231 + '</span><span style="text-align:right; font-size:15px; font-weight:bold; display:inline-block; width:130px;">' + commQty_231 + '</span>')
						else
							$(list).find('.list-text').html( '<span style="margin-left:10px">' + commYMD_232 + '</span><span style="text-align:right; font-size:15px; font-weight:bold; display:inline-block; width:130px;">' + commQty_232 + '</span>')
						/*if(data.direction=='up'){
							$(list).find('.fa').html('').removeClass('fa-long-arrow-down').addClass('fa-long-arrow-up');
						}else if(data.direction=='dn'){
							$(list).find('.fa').html('').removeClass('fa-long-arrow-up').addClass('fa-long-arrow-down');
						}else if(data.direction=='-'){
							$(list).find('.fa').html('-').removeClass('fa-long-arrow-up').removeClass('fa-long-arrow-down');
						}*/
					}
					
				};
				
				var act3 = function(){
					$target.css({transition: '0.3s', transform:'rotateX(0deg)'})
				};
				setTimeout(function(){act1()},time*i);
				setTimeout(function(){act2(data),act3()},time*i+300);
			}
			
			
		}
	}
	
};

/*
 * 하단 차트&리스트 관련
 */
var LIST = {
	cls: 'panel-green',	// default, primary, success, info, warning, danger, green, yellow, red
	
	setTime: function(id, time){
		$('#'+id).next().find('span').html(time);
	},
	
	load: function(){
		var me = this;
		me.setAll();
		setInterval(function(){
			me.setAll();
		}, 10*1000);  // 10초
	},
	
	setAll: function(){
		
		LIST.list.petWeight('list_area_0_0', 0);
		LIST.list.preformCount('list_area_0_1', 1);
		LIST.list.preformCountTotal('list_area_0_2', 2);
		LIST.list.preformMachineStatus1('list_area_0_3', 3);
		LIST.list.preformSetting('list_area_0_4', 4);
		LIST.list.packingSetting('list_area_0_5', 5);
		LIST.list.hrTemperature('list_area_0_6', 6);
		LIST.list.barrelTemperature('list_area_0_7', 7);
		LIST.list.hrTemperatureChange('list_area_0_8', 8);
		LIST.list.barrelTemperatureChange('list_area_0_9', 9);
		LIST.list.temperatureCorrelation('list_area_0_10', 10);
		LIST.list.etcSetting('list_area_0_11', 11);
		LIST.list.listPreformIrreg('list_area_0_12', 12);
		
//		var tab1 = $('#nav-tabs>li:eq(0)').hasClass('active'),
//			tab2 = $('#nav-tabs>li:eq(1)').hasClass('active'),
		var tab1 = (location.href.indexOf('preform') > -1),
			tab2 = (location.href.indexOf('water') > -1),
			url = CONTEXT_ROOT+'dashboard/main';
		if(tab1){
			
			
			
			/*$.ajax({
				url: url + '/preform_product_list.json',
				success: function(jsonData){
					var data = jsonData.data;
					
					if(data[0]) LIST.list.petWeight('list_area_0_0', data[0]);
					if(data[1]) LIST.list.preformCount('list_area_0_1', data[1]);
					if(data[2]) LIST.list.preformCountTotal('list_area_0_2', data[2]);
					if(data[3]) LIST.list.preformMachineStatus1('list_area_0_3', data[3]);
					if(data[4]) LIST.list.preformSetting('list_area_0_4', data[4]);
					if(data[5]) LIST.list.packingSetting('list_area_0_5', data[5]);
					if(data[6]) LIST.list.hrTemperature('list_area_0_6', data[6]);
					if(data[7]) LIST.list.barrelTemperature('list_area_0_7', data[7]);
					if(data[8]) LIST.list.hrTemperatureChange('list_area_0_8', data[8]);
					if(data[9]) LIST.list.barrelTemperatureChange('list_area_0_9', data[9]);
					if(data[10]) LIST.list.temperatureCorrelation('list_area_0_10', data[10]);
					if(data[11]) LIST.list.etcSetting('list_area_0_11', data[11]);
					if(data[12]) LIST.list.listPreformIrreg('list_area_0_12', data[12]);
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});*/
		}else if(tab2){
			$.ajax({
				url: url + '/water_product_list.json',
				success: function(jsonData){
					var data = jsonData.data;
					//if(data[0]) LIST.chart.pie.productPreformCount('list_area_1_0', data[0]);
					//if(data[1]) LIST.chart.pie.productPreformCount('list_area_1_1', data[1]);
					if(data[0]) LIST.list.productPreformCount('list_area_1_0', data[0]);
					if(data[1]) LIST.list.productPreformCheck('list_area_1_1', data[1]);
					if(data[2]) LIST.list.productShipmentCount('list_area_1_3', data[2]);
					if(data[3]) LIST.list.productShipmentCountPerPreform('list_area_1_4', data[3]);
					if(data[4]) LIST.chart.column.productProgress('list_area_1_5', data[4]);
				},
				error: function(jqXHR, textStatus, errorThrown){
					console.error(jqXHR, textStatus, errorThrown);
				}
			});
		}
		
		
	},
	
	chart: {
		pie: {
			preformCount: function(id, data){
				if(data){
					var chartData = {
						type: 'input',
						cur_time: data.cur_time,
						value_total: data.product_cnt,
						title:'투입량<br/><span>' + (data.product_cnt).format() + '</span><span> 개</span>',
						seriesData: [{
							name:'양품',
							y: data.input_count1
						},{
							name: '불량',
							y: data.irreg_count1,
							color:'red'
						}]
					}
					if($('#'+id).highcharts()){
						this.redraw(id, chartData);
					}else{
						this.draw(id, chartData);
					}
					LIST.setTime(id, data.cur_time);
				}
			},
			
			productPreformCount: function(id, data){
				var chartData = {
					type: 'input',
					cur_time: data.cur_time,
					value_total: data.input_count1 + data.irreg_count1,
					title:'투입량<br/><span>' + (data.input_count1 + data.irreg_count1).format() + '</span><span> 개</span>',
					seriesData: [{
						name:'양품',
						y: data.input_count1
					},{
						name: '불량',
						y: data.irreg_count1,
						color:'red'
					}]
				}
				if($('#'+id).highcharts()){
					this.redraw(id, chartData);
				}else{
					this.draw(id, chartData);
				}
				LIST.setTime(id, data.cur_time);
			},
			
			productSelfCount: function(id, data){
				var total = data.error_type1 + data.error_type2 + data.error_type3 + data.error_type4 + data.error_type5;
				var chartData = {
					type: 'error',
					cur_time: data.cur_time,
					value_total: total,
					title: '에러량<br/><span>' + (total).format() + '</span><span> 개</span>',
					seriesData: [{
						name:'기포',
						y: data.error_type1
					},{
						name: '탄화',
						y: data.error_type2,
					},{
						name: '용량',
						y: data.error_type3,
					},{
						name: '밀봉',
						y: data.error_type4,
					},{
						name: '날짜',
						y: data.error_type5,
					}]
				}
				if($('#'+id).highcharts()){
					this.redraw(id, chartData);
				}else{
					this.draw(id, chartData);
				}
				LIST.setTime(id, data.cur_time);
			},
			
			redraw: function(id, data){
				if(data.type=='input'){
					$('#'+id).highcharts().series[0].setData([data.value1, data.value2]);
				}else if(data.type=='error'){
					$('#'+id).highcharts().series[0].setData([data.error_type1, data.error_type2, data.error_type3, data.error_type4, data.error_type5]);
				}
				$('#'+id+' .highcharts-title > tspan:eq(1)').animateNumber(data.value_total);
			},

			draw: function(id, data){
				//console.log(data);
				$('#'+id).highcharts({
					chart: {
						margin:0,
						plotBackgroundColor: null
					},
					title: {
						text: data.title,
						useHtml:true,
						style:{
							fontSize: '1.4em'
						},
						align: 'center',
						verticalAlign: 'middle',
						y:0
					},
					tooltip: {
						formatter: function(a,b,c){
							var html = '<span style="font-size: 1.3em; color:' + this.color + '">' + this.key + '</span><br/>'
								+ '<span style="font-size: 1em;">' + this.y.format() + '개</span><br/>'
								+ '<span style="font-size: 1em;">' + '(' + this.percentage.format(2) + '%)</span>';
							return html;
						}
					},
					plotOptions: {
						pie: {
							dataLabels: {
								enabled: false,
							}
						}
					},
					series: [{
						type: 'pie',
						name: '프리폼 검사',
						innerSize: '80%',
						borderColor: '#ccc',
						borderWidth: 1,
						data: data.seriesData
					}]
				});
			},
			
		},
		
		column:{
			
			preformProgress: function(id, data){
				LIST.setTime(id, data.cur_time);
				var chartData = {
					categories: [],
					series: [{
						name:'불량', data:[], color:'#f83030'
					},{
						name:'양품', data:[]
					}]
				};
				
				$(data.list).each(function(){
					chartData.categories.push(this.day);
					chartData.series[0].data.push(this.irreg_count1);
					chartData.series[1].data.push(this.input_count1);
				});
				
				if($('#'+id).highcharts()){
					this.redraw(id, chartData);
				}else{
					this.draw(id, chartData);
				}
			},
			
			productProgress: function(id, data){
				LIST.setTime(id, data.cur_time);
				var chartData = {
					categories: [],
					series: [{
						name:'2L', data:[]
					},{
						name:'500ml', data:[]//, color:'#f83030'
					}]
				};
				
				$(data.list).each(function(){
					chartData.categories.push(this.day);
					chartData.series[0].data.push(this.count_2l);
					chartData.series[1].data.push(this.count_500ml);
				});
				
				if($('#'+id).highcharts()){
					this.redraw(id, chartData);
				}else{
					this.draw(id, chartData);
				}
			},
			
			redraw: function(id, data){
				var me = this;
//				$('#'+id).highcharts().series[0].setData([data.value, 100-data.value]);
			},

			draw: function(id, data){
				$('#'+id).highcharts({
					chart: {
						type: 'column',
						spacing:[7,7,0,0],
					},
					title: false,
					legend:{enabled:false},
					xAxis: {
						categories: data.categories
					},
					yAxis: {
						min: 0,
						title: false
					},
					tooltip: {
//						pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
						shared: true,
						formatter: function(a,b,c){
							var html = '<span style="font-size: 1em; color: '+ this.points[1].color +'">●' + this.points[1].series.name + ': </span>' + this.points[1].y.format() + '<br/>'
								+ '<span style="font-size: 1em; color: '+ this.points[0].color +'">●' + this.points[0].series.name + ': </span>' + this.points[0].y.format() + '<br/>'
								+ '<span style="font-size: 1em;">●계: </span>' + (this.points[0].y + this.points[1].y).format() + '<br/>';
							return html;
						}
					},
					plotOptions: {
						column: {
							stacking: 'normal'
						}
					},
					series: data.series
				});
			}
		}
	},
	
	list:{
		numberCheck: function(num1, num2){
			return Math.abs( (1-(num1/num2)) <= 0.2) ? true : false;
		},
		numberCheckCls: function(num1, num2){
			return this.numberCheck(num1, num2) ? '' : 'text-danger';
		},
		
		petWeight: function(id, data){

			var weight_day_sum = data.weight_day_sum != null ? data.weight_day_sum.format(2) : 0;
			var weight_day_count = data.weight_day_count != null ? data.weight_day_count.format() : 0;
			var lately_weight = data.lately_weight != null ? data.lately_weight.format(2) : 0;
			
			var tpl =
				'<a class="list-group-item">'
				+	'<span class="">금일 누적 투입량</span>'
				+	'<span class="pull-right"><span class="list-value1">' + weight_day_sum + ' kg</span></span>'
				+'</a>'
				+'<a class="list-group-item">'
				+	'<span class="">금일 누적 투입 횟수</span>'
				+	'<span class="pull-right"><span class="list-value1">' + weight_day_count + ' 회</span></span>'
				+'</a>'
				+'<a class="list-group-item text-center" style="background-color: #f8f8f8;">'
				+	'<span class="">최근 투입량</span>'
				+'</a>'
				+'<div class="list-group-item text-center">'
				+	'<span class="list-value3" style="font-size:1.5em;">' + lately_weight + '</span><span class="list-unit3"> kg</span>'
				+'</div>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformCount:function(id, data){
			
			var t_input_count1 = data.t_input_count1 != null ? data.t_input_count1.format() : '0';
			var t_irreg_count1 = data.t_irreg_count1 != null ? data.t_irreg_count1.format() : '0';
			var t_product_cnt = data.t_product_cnt != null ? data.t_product_cnt.format() : '0';
			var y_input_count1 = data.y_input_count1 != null ? data.y_input_count1.format() : '0';
			var y_irreg_count1 = data.y_irreg_count1 != null ? data.y_irreg_count1.format() : '0';
			var y_product_cnt = data.y_product_cnt != null ? data.y_product_cnt.format() : '0';
			
			var tpl =
				'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">총검사량</span>'
				+	'<span class="list-value1" style="float: right;">'+t_input_count1+'</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">양품(전일/금일)</span>'
				+	'<span class="list-value1" style="float: right;">'+y_product_cnt+'/'+t_product_cnt+'</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">불량(전일/금일)</span>'
				+	'<span class="list-value1" style="float: right;">'+y_irreg_count1+'/'+t_irreg_count1+'</span>'
				+'</div>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
			
		},
		preformMachineStatus1: function(id, data){
			
			var int_c_cavityset = data.int_c_cavityset != null ? data.int_c_cavityset.format() : 0; 
			
			var tpl =
				'<div class="list-group-item text-center">'
				+	'<span class="list-value">원단 수</span>'
				+'</div>'
				+'<div class="list-group-item text-center" >'
				+	'<span class="list-value1">0</span>'
				+'</div>'
				+'<div class="list-group-item text-center">'
				+'	<span class="list-value">원단 셋팅</span>'
				+'</div>'
				+'<div class="list-group-item text-center">'
				+	'<span class="list-value1">' + int_c_cavityset + '</span>'
				+'</div>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformMachineStatus2: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item3-full">'
				+	'<span class="">생산제외부분</span>'
				+	'<span class="pull-right list-value1">' + data.act_cnt_prt_rej.format() + ' Part</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item3-full">'
				+	'<span class="">원단공간 수</span>'
				+	'<span class="pull-right list-value1">' + data.act_cnt_mld.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item3-full">'
				+	'<span class="">프리폼 수</span>'
				+	'<span class="pull-right list-value1">' + data.act_cnt_prt.format() + ' Part</span>'
				+'</a>';
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformBarrelTemperature: function(id, data){
			var cls = (data.act_cfg_brl == 'ON') ? 'text-success' : 'text-danger';
			var tpl =
				'<a class="list-group-item">'
				+	'<span class="">실린더 온도 지역내 실온도</span>'
				+	'<span class="pull-right list-value1">' + data.act_tmp_brl_zn + ' ℃</span>'
				+'</a>'
				+'<div class="list-group-item1">'
				+	'<span class="list-value3 ' + cls + '">' + data.act_cfg_brl + '</span>'
				+'</div>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformMoldTemperature: function(id, data){
			var cls = this.numberCheckCls(data.act_tmp_mld_zn, data.std_act_tmp_mld_zn);
			var tpl =
				'<a class="list-group-item">'
				+	'<span class="">성형 온도 지역 내 실온도</span>'
				+	'<span class="pull-right list-value1">' + data.act_tmp_mld_zn + ' ℃</span>'
				+'</a>'
				+'<div class="list-group-item1">'
				+	'<span class="list-value3 ' + cls + '">' + data.std_act_tmp_mld_zn + ' ℃</span>'
				+'</div>';
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformEtcTemperature: function(id, data){
			var cls = this.numberCheckCls(data.act_tmp_oil, data.std_act_tmp_oil);
			var tpl =
				'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">오일온도</span>'
				+	'<span class="pull-right"><span class="list-value1 ' + cls + '">' + data.act_tmp_oil.format() + ' ℃</span> / <span class="list-value2">' + data.std_act_tmp_oil.format() + ' ℃</span></span>'
				+'</a>';
			
			cls = this.numberCheckCls(data.act_tmp_wtr_in, data.std_act_tmp_wtr_in);
			tpl += '<a class="list-group-item list-group-item5-full">'
				+	'<span class="">수입구</span>'
				+	'<span class="pull-right"><span class="list-value1 ' + cls + '">' + data.act_tmp_wtr_in.format() + ' ℃</span> / <span class="list-value2">' + data.std_act_tmp_wtr_in.format() + ' ℃</span></span>'
				+'</a>';
			cls = this.numberCheckCls(data.act_tmp_wtr_out, data.std_act_tmp_wtr_out);
			tpl += '<a class="list-group-item list-group-item5-full">'
				+	'<span class="">수출구</span>'
				+	'<span class="pull-right"><span class="list-value1 ' + cls + '">' + data.act_tmp_wtr_out.format() + ' ℃</span> / <span class="list-value2">' + data.std_act_tmp_wtr_out.format() + ' ℃</span></span>'
				+'</a>';
			cls = this.numberCheckCls(data.act_tmp_cab, data.std_act_tmp_cab);
			tpl += '<a class="list-group-item list-group-item5-full">'
				+	'<span class="">캐비닛</span>'
				+	'<span class="pull-right"><span class="list-value1 ' + cls + '">' + data.act_tmp_cab.format() + ' ℃</span> / <span class="list-value2">' + data.std_act_tmp_cab.format() + ' ℃</span></span>'
				+'</a>';
			cls = this.numberCheckCls(data.act_tmp_mlt, data.std_act_tmp_mlt);
			tpl += '<a class="list-group-item list-group-item5-full">'
				+	'<span class="">녹는 온도</span>'
				+	'<span class="pull-right"><span class="list-value1 ' + cls + '">' + data.act_tmp_mlt.format() + ' ℃</span> / <span class="list-value2">' + data.std_act_tmp_mlt.format() + ' ℃</span></span>'
				+'</a>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformCountTotal: function(id, data){
			var input_day_sum = data.input_day_sum != null ? data.input_day_sum.format() : 0;
			
			var tpl =
				'<div class="list-group-item text-center" style="background-color: #f8f8f8;">'
				+	'<span class="list-value">금일 누적</span>'
				+'</div>'
				+'<div class="list-group-item1">'
				+	'<span class="list-value3" style="font-size:3em;"></span>'
				+	'<span class="list-unit3">'+ input_day_sum +'개</span>'
				+'</div>'
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformCountPerPetWeight: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">PET투입</span>'
				+	'<span class="pull-right list-value1">' + data.total_weight.format() + ' kg</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">일 프리폼 생산량</span>'
				+	'<span class="pull-right list-value1">' + data.input_day_sum.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">일 프리폼 불량</span>'
				+	'<span class="pull-right list-value1 text-danger">' + data.irreg_count1.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">일 프리폼 불량률</span>'
				+	'<span class="pull-right list-value1 text-danger">' + data.irreg_per_product.format(2) + ' %</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">일 프리폼 예측불량</span>'
				+	'<span class="pull-right list-value1 text-danger">' + data.irreg_count1_forecast.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">일 프리폼 예측불량률</span>'
				+	'<span class="pull-right list-value1 text-danger">' + data.irreg_per_forecast.format(2) + ' %</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item7-full">'
				+	'<span class="">불량 예측 오차율</span>'
				+	'<span class="pull-right list-value1 text-danger">' + data.irreg_per_distence.format(2) + ' %</span>'
				+'</a>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		
		preformMornitoring: function(id, data){
			var list = [
				{name:'가소 시간', field:'act_tim_plst', unit:' sec'},
				{name:'주기 시간', field:'act_tim_cyc', unit:' sec'},
				{name:'쿠션 스트로크 위치', field:'act_str_csh', unit:' mm'},
				{name:'쿠션 부피', field:'act_vol_csh', unit:' cm<sup>3</sup>'},
				{name:'가소 스트로크위치', field:'act_str_plst', unit:' mm'},
				{name:'가소 부피', field:'act_vol_plst', unit:' cm<sup>3</sup>'},
				{name:'스크류 지름', field:'act_dia_scr', unit:' mm'},
				{name:'가소 전 감압길이', field:'act_str_dcmp_pre', unit:' mm'},
				{name:'가소 전 감압부피', field:'act_vol_dcmp_pre', unit:' cm<sup>3</sup>'},
				{name:'가소 후 감압길이', field:'act_str_dcmp_pst', unit:' mm'},
				{name:'가소 후 감압부피', field:'act_vol_dcmp_pst', unit:' cm<sup>3</sup>'},
				{name:'전달 길이', field:'act_str_xfr', unit:' mm'},
				{name:'전달 볼륨', field:'act_vol_xfr', unit:' cm<sup>3</sup>'},
				{name:'전달 유압', field:'act_prs_xfr_hyd', unit:' bar'},
				{name:'금형 내부 압력', field:'act_prs_xfr_cav', unit:' bar'},
				{name:'금형 특정 압력', field:'act_prs_xfr_spec', unit:' bar'},
				{name:'전달 시간', field:'act_tim_xfr', unit:' sec'},
				{name:'금형 내부 최대압력', field:'act_prs_cav_max', unit:' bar'},
				{name:'최대 유압', field:'act_prs_mach_hyd_max', unit:' bar'},
				{name:'특정 최대유압', field:'act_prs_mach_spec_max', unit:' bar'},
				{name:'가소 최대 속력', field:'act_spd_plst_max', unit:' RPM'},
				{name:'가소 평균 속력', field:'act_spd_plst_ave', unit:' RPM'},
				{name:'가소 최대 속도', field:'act_vel_plst_max', unit:' mm/sec'},
				{name:'가소 평균 속도', field:'act_vel_plst_ave', unit:' mm/sec'},
				{name:'형 조임력', field:'act_frc_clp', unit:' KN'},
				{name:'유지 유압 최대값', field:'act_prs_hld_hyd_max', unit:' bar'},
				{name:'유지 유압 평균값', field:'act_prs_hld_hyd_ave_max', unit:' bar'},
				{name:'가소 유압 최대값', field:'act_prs_plst_hyd_max', unit:' bar'},
				{name:'가소 유압 평균값', field:'act_prs_plst_hyd_ave_max', unit:' bar'}
			];
			
			var tpl = '';
			$(list).each(function(){
				tpl += '<a class="list-group-item">'
					+	'<span class="">'+this.name+'</span>'
					+	'<span class="pull-right"><span class="list-value1">'+data[0][this.field]+this.unit+'</span> / <span class="list-value2">'+data[1][this.field]+this.unit+'</span></span>'
					+'</a>';
			})
				
			$('#'+id).html(tpl);
			LIST.setTime(id, data[0].cur_time);
		},
		
		productSelfCount: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">기포</span>'
				+	'<span class="pull-right list-value1">' + data.error_type1.format() + '</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">탄화</span>'
				+	'<span class="pull-right list-value1">' + data.error_type2.format() + '</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">용량</span>'
				+	'<span class="pull-right list-value1">' + data.error_type3.format() + '</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">밀봉</span>'
				+	'<span class="pull-right list-value1">' + data.error_type4.format() + '</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item5-full">'
				+	'<span class="">날짜</span>'
				+	'<span class="pull-right list-value1">' + data.error_type5.format() + '</span>'
				+'</a>';
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		productShipmentCount: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">500ml 패키지</span>'
				+	'<span class="pull-right list-value1">' + data.count_500ml.format() + ' set</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">500ml 낱개</span>'
				+	'<span class="pull-right list-value1">' + data.count_500ml_piece.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">2L 패키지</span>'
				+	'<span class="pull-right list-value1">' + data.count_2l.format() + ' set</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">2L 낱개</span>'
				+	'<span class="pull-right list-value1">' + data.count_2l_piece.format() + ' 개</span>'
				+'</a>'
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		productShipmentCountPerPreform: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">프리폼 투입량</span>'
				+	'<span class="pull-right list-value1">' + data.preform_count.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">출하량 계</span>'
				+	'<span class="pull-right list-value1">' + data.package_count.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">불량</span>'
				+	'<span class="pull-right list-value1">' + data.irreg_count.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">출하율</span>'
				+	'<span class="pull-right list-value1">' + data.package_perc.format(2) + ' %</span>'
				+'</a>'
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		productShipmentLineCount: function(id, data){
			var tpl =
				'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">2L 출고 Count</span>'
				+	'<span class="pull-right list-value1">' + data.output_2l_cnt.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">2L 총 출고갯수</span>'
				+	'<span class="pull-right list-value1">' + data.output_2l_piece_cnt.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">500ml 출고 Count</span>'
				+	'<span class="pull-right list-value1">' + data.output_500ml_cnt.format() + ' 개</span>'
				+'</a>'
				+'<a class="list-group-item list-group-item4-full">'
				+	'<span class="">500ml 총 출고갯수</span>'
				+	'<span class="pull-right list-value1">' + data.output_500ml_piece_cnt.format() + ' 개</span>'
				+'</a>'
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		preformSetting: function(id, data){
			
			var scrw1_p_injc_step01set = data.scrw1_p_injc_step01set != null ? data.scrw1_p_injc_step01set.format() : 0;
			var scrw1_s_injc_step01set = data.scrw1_s_injc_step01set != null ? data.scrw1_s_injc_step01set.format() : 0;
			var scrw1_v_injc_step01set = data.scrw1_v_injc_step01set != null ? data.scrw1_v_injc_step01set.format() : 0;
			
			var tpl =
				'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">압력</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw1_p_injc_step01set + '</span>'
				+	'</div>'
				+	'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">거리</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw1_s_injc_step01set + '</span>'
				+	'</div>'
				+	'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">속도</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw1_v_injc_step01set + '</span>'
				+	'</div>';
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		packingSetting: function(id, data){
			
			var scrw1_p_hldp_step01set = data.scrw1_p_hldp_step01set != null ? data.scrw1_p_hldp_step01set.format() : 0;
			var scrw1_t_hldp_step01set = data.scrw1_t_hldp_step01set != null ? data.scrw1_t_hldp_step01set.format() : 0;
			
			var tpl =
				'<div class="list-group-item" style="padding-top: 32.5px; padding-bottom: 32.5px;">'
				+		'<span class="list-value">압력</span>'
				+		'<span class="list-value1" style="float: right;">' + scrw1_p_hldp_step01set + '</span>'
				+	'</div>'
				+	'<div class="list-group-item" style="padding-top: 32.5px; padding-bottom: 32.5px;">'
				+	'	<span class="list-value">시간</span>'
				+	'	<span class="list-value1" style="float: right;">' + scrw1_t_hldp_step01set + '</span>'
				+	'</div>';
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		hrTemperature: function(id, data){
			
			var mold_h_heat1_set = data.mold_h_heat1_set != null ? data.mold_h_heat1_set.format() : 0;
			var mold_h_heat1_act = data.mold_h_heat1_act != null ? data.mold_h_heat1_act.format() : 0;
			var mold_h_heat1_cycact = data.mold_h_heat1_cycact != null ? data.mold_h_heat1_cycact.format() : 0;
			
			var tpl =
				'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">설정 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + mold_h_heat1_set + '</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">실제 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + mold_h_heat1_act + '</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">순환실제 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + mold_h_heat1_cycact + '</span>'
				+'</div>'
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		barrelTemperature: function(id, data){
			
			var scrw_h_bar_set = data.scrw_h_bar_set != null ? data.scrw_h_bar_set.format() : 0;
			var scrw_h_bar_cycact = data.scrw_h_bar_cycact != null ? data.scrw_h_bar_cycact.format() : 0;
			var scrw_h_bar_act = data.scrw_h_bar_act != null ? data.scrw_h_bar_act.format() : 0;
			
			var tpl =
				'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">셋팅 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw_h_bar_set + '</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">실제 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw_h_bar_act + '</span>'
				+'</div>'
				+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
				+	'<span class="list-value">순환실제 값 (평균)</span>'
				+	'<span class="list-value1" style="float: right;">' + scrw_h_bar_cycact + '</span>'
				+'</div>'
				
				$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		hrTemperatureChange: function(id, data){
			
			var tpl = '';
			for(var i=0; i < data.length ; i++){
				
				var nm = data[i].nm;
				var cur_time = data[i].cur_time;
				var mold_h_heat1_act_avg = data[i].mold_h_heat1_act_avg != null ? data[i].mold_h_heat1_act_avg.format() : "";
				var mold_h_heat1_act_stddev = data[i].mold_h_heat1_act_stddev != null ? data[i].mold_h_heat1_act_stddev.format() : "";
				
				if(i == 0){
					LIST.setTime(id, cur_time);
				}
				
				
				var class_nm = '';
				var color = '';
				var style = '';
				
				
				if(sessionStorage.getItem(nm) == null){
					
					class_nm = 'glyphicon-triangle-top';
					color = 'red';
					
					sessionStorage.setItem(nm, i+1);
					
				}else{
					
					if(sessionStorage.getItem(nm) > (i+1)){
						class_nm = 'glyphicon-triangle-top';
						color = 'red';
					}else if(sessionStorage.getItem(nm) < (i+1)){
						class_nm = 'glyphicon-triangle-bottom';
						color = 'blue';
					}else{
						class_nm = 'glyphicon-minus';
						color = 'gray';
					} 
					
					sessionStorage.removeItem(nm);
					sessionStorage.setItem(nm, i+1);
				}
				
				if(i < 5){
				
					tpl +=
					'<div class="list-group-item" style="padding-top: 6.5px;padding-bottom: 6.5px;">'
					+	'<span class="list-value" style="border-radius: 20%;width: 20px;height: 20px;padding: 0px ;background: #143A5E;border: 4px solid #143A5E;color: #fff;text-align: center;font: 13px Arial, sans-serif;">'+(i+1)+'</span>'
					+	'<span class="list-value"> ' + nm + ' </span>'
					+	'<div style="float: right;">'
					+		'<span class="list-value"> ' + mold_h_heat1_act_avg + ' </span>'
					+		'(<span class="list-value" style="color:'+color+';"> ' + mold_h_heat1_act_stddev + ' </span><i class="glyphicon '+class_nm+'" style="color:'+color+';"></i>)'
					+	'</div>'
					+'</div>';
				}
				
			}
			
			$('#'+id).html(tpl);
			
		},
		
		barrelTemperatureChange: function(id, data){
			
			var tpl = '';
			for(var i=0; i < data.length ; i++){
				
				var nm = data[i].nm;
				var cur_time = data[i].cur_time;
				var scrw_h_bar_act_avg = data[i].scrw_h_bar_act_avg != null ? data[i].scrw_h_bar_act_avg.format() : "";
				var scrw_h_bar_act_stddev = data[i].scrw_h_bar_act_stddev != null ? data[i].scrw_h_bar_act_stddev.format() : "";
				
				if(i == 0){
					LIST.setTime(id, cur_time);
				}
				
				
				var class_nm = '';
				var color = '';
				var style = '';
				
				
				if(sessionStorage.getItem(nm) == null){
					
					class_nm = 'glyphicon-triangle-top';
					color = 'red';
					
					sessionStorage.setItem(nm, i+1);
					
				}else{
					
					if(sessionStorage.getItem(nm) > (i+1)){
						class_nm = 'glyphicon-triangle-top';
						color = 'red';
					}else if(sessionStorage.getItem(nm) < (i+1)){
						class_nm = 'glyphicon-triangle-bottom';
						color = 'blue';
					}else{
						class_nm = 'glyphicon-minus';
						color = 'gray';
					} 
					
					sessionStorage.removeItem(nm);
					sessionStorage.setItem(nm, i+1);
				}
				
				if(i < 5){
				
					tpl +=
					'<div class="list-group-item" style="padding-top: 6.5px;padding-bottom: 6.5px;">'
					+	'<span class="list-value" style="border-radius: 20%;width: 20px;height: 20px;padding: 0px ;background: #143A5E;border: 4px solid #143A5E;color: #fff;text-align: center;font: 13px Arial, sans-serif;">'+(i+1)+'</span>'
					+	'<span class="list-value"> ' + nm + ' </span>'
					+	'<div style="float: right; color:'+color+';">'
					+		'<span class="list-value"> ' + scrw_h_bar_act_avg + ' </span>'
					+		'(<span class="list-value" style="color:'+color+';"> ' + scrw_h_bar_act_stddev + ' </span><i class="glyphicon '+class_nm+'" style="color:'+color+';"></i>)'
					+	'</div>'
					+'</div>';
				}
				
			}
			
			$('#'+id).html(tpl);
			
		},
		
		temperatureCorrelation: function(id, data){
			
			var tpl = '';
			for(var i=0; i < data.length ; i++){
				
				var nm = data[i].nm;
				var cur_time = data[i].cur_time;
				var corr = data[i].corr != null ? data[i].corr : "";
				
				if(i == 0){
					LIST.setTime(id, cur_time);
				}
				
				
				if(i < 5){
				
					tpl +=
					'<div class="list-group-item" style="padding-top: 6.5px;padding-bottom: 6.5px;">'
					+	'<span class="list-value" style="border-radius: 20%;width: 20px;height: 20px;padding: 0px ;background: #143A5E;border: 4px solid #143A5E;color: #fff;text-align: center;font: 13px Arial, sans-serif;">'+(i+1)+'</span>'
					+	'<span class="list-value"> ' + nm + ' </span>'
					+	'<span class="list-value1" style="float: right;"> ' + corr + ' </span>'
					+'</div>';
				}
				
			}
			
			$('#'+id).html(tpl);
			
		},
		
		etcSetting: function(id, data){
			
			var tpl = '';
			var mold_t_coolset = data.mold_t_coolset != null ? data.mold_t_coolset : "";
			var mold_t_coolact = data.mold_t_coolact != null ? data.mold_t_coolact : "";
			var syst_h_oil_z14set = data.syst_h_oil_z14set != null ? data.syst_h_oil_z14set : "";
			var syst_h_oil_z14act = data.syst_h_oil_z14act != null ? data.syst_h_oil_z14act : "";
			
			tpl +=
			'<div class="list-group-item" style="padding-top: 11px; padding-bottom: 11px;">'
			+	'<span class="list-value">쿨링시간 설정값</span>'
			+	'<span class="list-value1" style="float: right;">'+mold_t_coolset+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 11px; padding-bottom: 11px;">'
			+	'<span class="list-value">쿨링시간 실제값</span>'
			+	'<span class="list-value1" style="float: right;">'+mold_t_coolact+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 11px; padding-bottom: 11px;">'
			+	'<span class="list-value">오일온도 설정값</span>'
			+	'<span class="list-value1" style="float: right;">'+syst_h_oil_z14set+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 11px; padding-bottom: 11px;">'
			+	'<span class="list-value">오일온도 실제값</span>'
			+	'<span class="list-value1" style="float: right;">'+syst_h_oil_z14act+'</span>'
			+'</div>';
				
			
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		productPreformCount: function(id, data){
			
			var tpl = '';
			var input_count1 = data.input_count1 != null ? data.input_count1 : "";
			var output_count1 = data.output_count1 != null ? data.output_count1 : "";
			
			/*
			tpl +=
			'<div class="list-group-item" style="padding-top: 32.5px; padding-bottom: 32.5px;">'
			+	'<span class="list-value">입력</span>'
			+	'<span class="list-value1" style="float: right;">'+input_count1+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 32.5px; padding-bottom: 32.5px;">'
			+	'<span class="list-value">출력</span>'
			+	'<span class="list-value1" style="float: right;">'+output_count1+'</span>'
			+'</div>'*/
			
			tpl +=
			  '<div class="list-group-item text-center" style="background-color: #f8f8f8;">'
			+ '    <span class="list-value">출력</span>'
			+ '</div>'
			+ '<div class="list-group-item1">'
			+ '    <span class="list-value1" style="font-size:3em;">'+output_count1.format()+'</span>'
			+ '    <span class="list-unit3">개</span>'
			+ '</div>';

			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		productPreformCheck: function(id, data){
			
			var tpl = '';
			var input_count1 = data.input_count1 != null ? data.input_count1 : "";
			var output_count1 = data.output_count1 != null ? data.output_count1 : "";
			var irreg_count1 = data.irreg_count1 != null ? data.irreg_count1 : "";
			
			tpl +=
			'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
			+	'<span class="list-value">입력</span>'
			+	'<span class="list-value1" style="float: right;">'+input_count1+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
			+	'<span class="list-value">출력</span>'
			+	'<span class="list-value1" style="float: right;">'+output_count1+'</span>'
			+'</div>'
			+'<div class="list-group-item" style="padding-top: 18px; padding-bottom: 18px;">'
			+	'<span class="list-value">불량</span>'
			+	'<span class="list-value1" style="float: right;">'+irreg_count1+'</span>'
			+'</div>'
			
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		},
		
		listPreformIrreg: function(id, data){
			
			var tpl = '';
			var irreg_count_day_sum = data.irreg_count_day_sum != null ? data.irreg_count_day_sum : "";
			
			tpl +=
			'<div class="list-group-item text-center" style="background-color: #f8f8f8;">'
			+	'<span class="list-value">금일 누적</span>'
			+'</div>'
			+'<div class="list-group-item1">'
			+	'<span class="list-value3" style="font-size:3em;">'+parseInt(irreg_count_day_sum)+'</span>'
			+	'<span class="list-unit3">kg</span>'
			+'</div>'
				
			
			$('#'+id).html(tpl);
			LIST.setTime(id, data.cur_time);
		}
	}

};



