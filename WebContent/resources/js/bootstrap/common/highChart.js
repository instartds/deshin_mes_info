(function(){
	Highcharts.theme = {
		//colors: ['#45abaa', '#77bc8e', '#37acd6', '#bc9c76', '#9e76bc', '#f83030', '#c3cfd8'],
		colors: ['#E9E8EE','#058DC7',  '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'],
		chart: {
		}
		,
		exporting: {
			enabled: false
		}
		,
		credits: {
			enabled: false
		}
	};



	/*$('.highcharts-button').remove();
	$('.highcharts-contextbutton').remove();*/
	//Apply the theme
	Highcharts.setOptions(Highcharts.theme);
})();

var intervalDate = 3;
var CHART = {
		interval : function(id, chartInfo){
			var me = this;

			if(!$(id).highcharts())
				me.show(id, chartInfo);

			var interval = setInterval(function () {
					me.show(id, chartInfo)
				}, intervalDate*1000);

			return interval;
		},
		show : function(id, chartInfo){
			var me = this;
			if(!ObjUtil.isEmpty(chartInfo)){
				var type = {
						chartTypeNm		: chartInfo.chart_type_nm,
						chartType 		: chartInfo.chart_type,
						tagValType		: chartInfo.tag_val_type,
						content			: chartInfo.chart_cont,
						backgroundColor : chartInfo.bcrn_color,
						lineColor		: (ObjUtil.isEmpty(chartInfo.line_color)) ? "#45abaa" : chartInfo.line_color,
						minValueY		: chartInfo.y_axis_min_val,
						maxValueY		: chartInfo.y_axis_max_val
					};

				if(!$(id).highcharts()){
					$.ajax({
						url     		: '/cms/selectTagData.do',
						type    		: 'post',
						dataType 		: 'json',
						contentType 	: "application/json; charset=UTF-8",
						data    		: JSON.stringify(chartInfo),
						/*async     		: true,*/
						success   : function(data){
							me.setChart(id, type, data);
						}
				    });
				}else{
					var date = new Date();
					date.setSeconds(date.getSeconds() - intervalDate);
					chartInfo.dt = DateUtil.toString(date, 'yyyy-MM-dd HH:mm:ss');
					$.ajax({
				        type : 'post',
				        url : "/cms/selectTagFlowData.do",
				        type    		: 'post',
						dataType 		: 'json',
						contentType 	: "application/json; charset=UTF-8",
						data    		: JSON.stringify(chartInfo),
				        success : function (data) {
				        	me.setChart(id, type, data);
				        }
				    });
				}
			}
		},
		setChart : function(id, chartInfo, data){
			var me = this;

			if (chartInfo.chartType == '01' || chartInfo.chartType == '99'){
				me.liveDefaultChart.set(id, data, chartInfo);
			}
			else if (chartInfo.chartType == '02'){
				me.liveFillChart.set(id, data, chartInfo);
			}
			else if (chartInfo.chartType == '03'){
				me.liveColumnChart.set(id, data, chartInfo);
			}
			else if (chartInfo.chartType == '04'){
				me.gaugeSingle.set(id, data, chartInfo);
			}
			else if (chartInfo.chartType == '05'){
				me.gaugeSolid.set(id, data, chartInfo);
			}
		},
		gaugeSolid : {
			set : function(id,	data, type){
				var me = this;

				opt = {
					data1 : [],
					data2 : []
				};

				if(!ObjUtil.isEmpty(data)){
					var last =data.length - 1;
					opt.data1.push([data[last].data]);
				}

				if($(id).highcharts()){
					var series = $(id).highcharts().series;
					if(opt.data1 && opt.data1.length > 0)
						series[0].setData(opt.data1);
				}else{
					me.draw(id, opt, type);
				}
			},

			draw : function(id, opt, type){
				$(id).highcharts('chart', {

					chart: {
						backgroundColor : type.backgroundColor,
				        type: 'solidgauge'
				    },

				    title: '제목',

				    pane: {
				        center: ['50%', '85%'],
				        size: '100%',
				        startAngle: -90,
				        endAngle: 90,
				        background: {
				            backgroundColor:
				                Highcharts.defaultOptions.legend.backgroundColor || '#EEE',
				            innerRadius: '60%',
				            outerRadius: '100%',
				            shape: 'arc'
				        }
				    },

				    tooltip: {
				        enabled: false
				    },

				    // the value axis
				    yAxis: {
				        stops: [
				            [0.1, '#DF5353'], // red
				            [0.5, '#DDDF0D'], // yellow
				            [0.9, '#55BF3B'] // green
				        ],
				        lineWidth: 0,
				        minorTickInterval: null,
				        tickAmount: 2,
				        title: {
				            y: -70
				        },
				        labels: {
				            y: 16
				        },
				        min: Number(type.minValueY),
				        max: Number(type.maxValueY)
				        /*,
				        title: {
				            text: 'Speed'

				        }*/
				    },
				    credits: {
				        enabled: false
				    },
				    series: [{
				        /*name: 'Speed',*/
				        data: opt.data1,
				        dataLabels: {
				            format:
				                '<div style="text-align:center">' +
				                '<span style="font-size:25px">{y}</span><br/>' +
				               /* '<span style="font-size:12px;opacity:0.4">km/h</span>' +*/
				                '</div>'
				        }
				    	/*,tooltip: {
				            valueSuffix: ' km/h'
				        }*/
				    }],
				    plotOptions: {
				        solidgauge: {
				            dataLabels: {
				                y: 5,
				                borderWidth: 0,
				                useHTML: true
				            }
				        }
				    }
				})
			}
		},
		barReverseChart : {
			set : function(id,	data, type){
				var me = this;

				opt = {
					categories : [],
					series: [{
				    	showInLegend:false,
				        name: '잔여 생산계획건',
				        data: []
				    }, {
				    	showInLegend:false,
				        name: '생산실적건',
				        data: []
				    }]
				};

				if(!ObjUtil.isEmpty(data)){
					var categoriesName = "";
					var maxOuttrn = 0;
					$.each(data, function(index, item){


						var iPlanOuttrn =  ObjUtil.isEmpty(item.plan_outtrn) ? 0 : item.plan_outtrn;
						var iData = ObjUtil.isEmpty(item.data) ? 0 : item.data;



						iPlanOuttrn =  (iPlanOuttrn >= iData) ? iPlanOuttrn - iData : 0;

						categoriesName = (ObjUtil.isEmpty(item.prdctn_product_nm)) ? item.pbl_line_nm : item.prdctn_product_nm ;

						opt.categories.push(categoriesName); 				// 제품명
						opt.series[0].data.push(iPlanOuttrn);			// 계획
						opt.series[1].data.push(iData);					// 실적

						var iTotOuttrn = iPlanOuttrn + iData;
						maxOuttrn = maxOuttrn < iTotOuttrn ? iTotOuttrn : maxOuttrn;
					})

					opt.tickInterval = Math.ceil(maxOuttrn / 5);
					/*var last =data.length - 1;
					opt.data1.push([data[last].data]);
					opt.data2.push([data[last].plan_outtrn]);*/

				}

				if($(id).highcharts()){
					var series = $(id).highcharts().series;
					if(opt.series && opt.series.length > 0){
						series[0].setData(opt.series[0].data);
						series[1].setData(opt.series[1].data);
					}
				}else{
					me.draw(id, opt, type);
				}
			},
			draw: function(id, opt, type){
				$(id).highcharts("chart", {
					chart: {
				        type: 'bar',
				        backgroundColor: null
				        /*,colors:['#0acf97','#fa5c7c']*/
				    },
				    title: null,
				    xAxis: {
				        categories: opt.categories,
				        labels: {
				    		style: {
				    			fontSize: '20px'
				    		}
				        }
				    },
				    yAxis: {
				        min: 0,
				        tickInterval: opt.tickInterval,
				        title: null,
				        labels: {
				    		style: {
				    			fontSize: '15px'
				    		}
				        }
				    },
				   legend: {
				        reversed: true
				    },
				    plotOptions: {
				        series: {
				            stacking: 'normal'
				        }
				    },
				    series: opt.series
				})
			}
		},
		gaugeSingle :{

			set : function(id,	data, type){
				var me = this;
				opt = {
					data1 : [],
					data2 : []
				};

				if(data && data.length > 0){
					var last =data.length - 1;
					opt.data1.push([data[last].data]);
				}

				if($(id).highcharts()){
					var series = $(id).highcharts().series;

					if(opt.data1 && opt.data1.length > 0)
						series[0].setData(opt.data1);
				}else{
					me.draw(id, opt, type);
				}
			},
			draw : function(id, opt, type){
				$(id).highcharts('chart', {

				    chart: {
				    	backgroundColor : type.backgroundColor,
				        type: 'gauge',
				        plotBackgroundColor: null,
				        plotBackgroundImage: null,
				        plotBorderWidth: 0,
				        plotShadow: false
				    },

				    title: {
				        text: ''
				    },

				    pane: {
				        startAngle: -150,
				        endAngle: 150,
				        background: [{
				            backgroundColor: {
				                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
				                stops: [
				                    [0, '#FFF']
				                    ,[1, '#333']
				                ]
				            },
				            borderWidth: 0,
				            outerRadius: '109%'
				        }, {
				            backgroundColor: {
				                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
				                stops: [
				                    [0, '#333'],
				                    [1, '#FFF']
				                ]
				            },
				            borderWidth: 1,
				            outerRadius: '107%'
				        }, {
				            // default background
				        }, {
				            backgroundColor: '#DDD',
				            borderWidth: 0,
				            outerRadius: '105%',
				            innerRadius: '103%'
				        }]
				    },

				    // the value axis
				    yAxis: {
				        min: 0/*type.minValueY*/,
				        max: 200/*type.maxValueY*/,

				        minorTickInterval: 'auto',
				        minorTickWidth: 1,
				        minorTickLength: 10,
				        minorTickPosition: 'inside',
				        minorTickColor: '#666',

				        tickPixelInterval: 30,
				        tickWidth: 2,
				        tickPosition: 'inside',
				        tickLength: 10,
				        tickColor: '#666',
				        labels: {
				            step: 2,
				            rotation: 'auto'
				        },
				        /*title: {
				            text: 'km/h'
				        },*/
				        plotBands: [{
				            from: 0,
				            to: 120,
				            color: '#55BF3B' // green
				        }, {
				            from: 120,
				            to: 160,
				            color: '#DDDF0D' // yellow
				        }, {
				            from: 160,
				            to: 200,
				            color: '#DF5353' // red
				        }]
				    },

				    series: [{
				        name: '',
				        data: opt.data1,
				        tooltip: {
				            //valueSuffix: ' km/h'
				        }
				    }]
				})
			}
		},
		gaueSeries : {
			draw : function(id, opt, type){
				$(id).highcharts('chart', {
					chart: {
				        type: 'gauge',
				        alignTicks: false,
				        plotBackgroundColor: null,
				        plotBackgroundImage: null,
				        plotBorderWidth: 0,
				        plotShadow: false
				    },

				    title: {
				        text: 'Speedometer with dual axes'
				    },

				    pane: {
				        startAngle: -150,
				        endAngle: 150
				    },

				    yAxis: [
				    /*{
				        min: 0,
				        max: 200,
				        lineColor: '#339',
				        tickColor: '#339',
				        minorTickColor: '#339',
				        offset: -25,
				        lineWidth: 2,
				        labels: {
				            distance: -20,
				            rotation: 'auto'
				        },
				        tickLength: 5,
				        minorTickLength: 5,
				        endOnTick: false
				    },*/
				    {
				        min: 0,
				        max: 124,
				        tickPosition: 'outside',
				        lineColor: '#933',
				        lineWidth: 2,
				        minorTickPosition: 'outside',
				        tickColor: '#933',
				        minorTickColor: '#933',
				        tickLength: 5,
				        minorTickLength: 5,
				        labels: {
				            distance: 12,
				            rotation: 'auto'
				        },
				        offset: -20,
				        endOnTick: false
				    }
				    ],

				    series: [{
				        name: 'Speed',
				        data: [80],
				        dataLabels: {
				            formatter: function () {
				                var kmh = this.y,
				                    mph = Math.round(kmh * 0.621);
				                return '<span style="color:#339">' + kmh + ' km/h</span><br/>' +
				                    '<span style="color:#933">' + mph + ' mph</span>';
				            },
				            backgroundColor: {
				                linearGradient: {
				                    x1: 0,
				                    y1: 0,
				                    x2: 0,
				                    y2: 1
				                },
				                stops: [
				                    [0, '#DDD'],
				                    [1, '#FFF']
				                ]
				            }
				        },
				        tooltip: {
				            valueSuffix: ' km/h'
				        }
				    }]
				});
			}
		},
		liveDefaultChart : {
			set : function(id,	data, type){
				var me = this;

				opt = {
						data1 : [],
						data2 : []
					};

				$(data).each(function(){
					var dt = this.insert_db_time;
					var chartData = this.data;

					opt.data1.push([dt, chartData]);
				});

				if($(id).highcharts()){

					if(ObjUtil.isEmpty(data)) return;
					var series = $(id).highcharts().series;
					if (type.tagValType == '01' || type.tagValType == '99'){
						$.each(opt.data1, function(i,item){
							series[0].addPoint(item, true, true);
						});

					}else{
						series[0].setData(opt.data1);
					}

					/*$.each(opt.data1, function(i, item){
						var series = $(id).highcharts().series;

						if(series[0].data) {
							var seriesDataLength = series[0].data.length - 1;
							var lastSeries = series[0].data[seriesDataLength];

							if(lastSeries.x == item[0]){
								lastSeries.y = lastSeries.y + item[1];
							}else{
								series[0].addPoint([item[0], item[1]], true, true);
							}

						}
					});

					series[0].setData(opt.data1);*/
					/*var x = data[data.length -1].insert_db_time;
					var y = data[data.length -1].data;
					series[0].addPoint([x, y], true, true);
					series[0].setData(opt.data1);*/
				}else{
					me.draw(id, opt, type);
				}
			},
			draw : function(id, opt, type){

				$(id).highcharts('stockChart',{
					colors: [type.lineColor],
				    chart: {
				    	backgroundColor : type.backgroundColor
				        /*events: {
				            load: function () {

				                // set up the updating of the chart each second
				                var series = this.series[0];
				                setInterval(function () {
				                    var x = (new Date()).getTime(), // current time
				                        y = Math.round(Math.random() * 100);
				                    series.addPoint([x, y], true, true);
				                }, 1000);
				            }
				        }*/
				    },

				    time: {
				        useUTC: false
				    },

				    rangeSelector: {
				        buttons: [{
				            count: 1,
				            type: 'minute',
				            text: '1M'
				        }, {
				            count: 5,
				            type: 'minute',
				            text: '5M'
				        }, {
				            type: 'all',
				            text: 'All'
				        }],
				        inputEnabled: false,
				        selected: 0
				    },

				   /* title: {
				        text: 'Live random data'
				    },*/
				    yAxis: [{
				    	min : type.minValueY,
				    	max : type.maxValueY
				    }],
				    exporting: {
				        enabled: false
				    },

				    series: [{
				        name: type.chartTypeNm,
				        data: opt.data1
				    }]
				});
			}
		},
		liveFillChart : {
			set : function(id,	data, type){
				var me = this;

				opt = {
					data1 : [],
					data2 : []
				};

				$(data).each(function(){
					var dt = this.insert_db_time;
					var chartData = this.data;

					opt.data1.push([dt, chartData]);
				});

				if($(id).highcharts()){

					if(ObjUtil.isEmpty(data)) return;
					var series = $(id).highcharts().series;
					if (type.tagValType == '01' || type.tagValType == '99'){
						$.each(opt.data1, function(i,item){
							series[0].addPoint(item, true, true);
						});

					}else{
						series[0].setData(opt.data1);
					}

					/*var series = $(id).highcharts().series;
					var x = data[data.length -1].insert_db_time;
					var y = data[data.length -1].data;
					series[0].addPoint([x, y], true, true);*/
				}else{
					me.draw(id, opt, type);
				}
			},
			draw : function(id, opt, type){
				$(id).highcharts('stockChart',{
					colors: [type.lineColor],
				    chart: {
				    	backgroundColor : type.backgroundColor
				    	/*plotBorderColor: '#606063'*/
				        /*events: {
				            load: function () {

				                // set up the updating of the chart each second
				                var series = this.series[0];
				                setInterval(function () {
				                    var x = (new Date()).getTime(), // current time
				                        y = Math.round(Math.random() * 100);
				                    series.addPoint([x, y], true, true);
				                }, 1000);
				            }
				        }*/
				    },

				    time: {
				        useUTC: false
				    },

				    rangeSelector: {
				        buttons: [{
				            count: 1,
				            type: 'minute',
				            text: '1M'
				        }, {
				            count: 5,
				            type: 'minute',
				            text: '5M'
				        }, {
				            type: 'all',
				            text: 'All'
				        }],
				        inputEnabled: false,
				        selected: 0
				    },

				   /* title: {
				        text: 'Live random data'
				    },*/

				    exporting: {
				        enabled: false
				    },
				    yAxis: {
				    	min : type.minValueY,
				    	max : type.maxValueY
				    },
				    series: [{
				    	/*color : '#ff0000',*/
				    	/*dataLabels :{
				    		color : '#fff'
				    	},
				    	 marker: {
				                lineColor: '#333'
				            },*/
				        name: type.chartTypeNm,
				        data: opt.data1
				       ,
				        type: 'area',
				        fillColor: {
			                linearGradient: {
			                    x1: 0,
			                    y1: 0,
			                    x2: 0,
			                    y2: 1
			                },
			                stops: [
			                    [0, type.lineColor],
			                    [1, Highcharts.Color(type.lineColor).setOpacity(0).get('rgba')]
			                ]
			            },
			            threshold: null
				    }]
				});
			}
		},
		liveColumnChart : {
			set : function(id,	data, type){
				var me = this;

				opt = {
					data1 : [],
					data2 : []
				};

				$(data).each(function(){
					var dt = this.insert_db_time;
					var chartData = this.data;

					opt.data1.push([dt, chartData]);
				});

				if($(id).highcharts()){

					if(ObjUtil.isEmpty(data)) return;
					var series = $(id).highcharts().series;
					if (type.tagValType == '01' || type.tagValType == '99'){
						$.each(opt.data1, function(i,item){
							series[0].addPoint(item, true, true);
						});

					}else{
						series[0].setData(opt.data1);
					}

					/*var series = $(id).highcharts().series;
					var x = data[data.length -1].insert_db_time;
					var y = data[data.length -1].data;
					var dataLength = series[0].points.length;

					if(dataLength > 0 ){
						var oldDate = series[0].points[dataLength - 1].y;

						if(oldDate != y)
							series[0].addPoint([x, y], true, true);
					}*/


				}else{
					me.draw(id, opt, type);
				}
			},
			draw : function(id, opt, type){
				$(id).highcharts('stockChart',{
					colors: [type.lineColor],
				    chart: {
				    	backgroundColor : type.backgroundColor,

				    	type: 'column'
				    	/*,
				        events: {
				            load: function () {

				                // set up the updating of the chart each second
				                var series = this.series[0];
				                setInterval(function () {
				                    var x = (new Date()).getTime(), // current time
				                        y = Math.round(Math.random() * 100);
				                    series.addPoint([x, y], true, true);
				                }, 1000);
				            }
				        }*/
				    },

				    time: {
				        useUTC: false
				    },

				    rangeSelector: {
				        buttons: [{
				            count: 1,
				            type: 'minute',
				            text: '1M'
				        }, {
				            count: 5,
				            type: 'minute',
				            text: '5M'
				        }, {
				            type: 'all',
				            text: 'All'
				        }],
				        inputEnabled: false,
				        selected: 0
				    },

				    /*title: {
				        text: 'Live random data'
				    },*/

				    exporting: {
				        enabled: false
				    },
				   /* xAxis : {
				    	lineColor: '#707073',
				        minorGridLineColor: '#505053'
				    },*/
				    yAxis: {
				    	min : type.minValueY,
				    	max : type.maxValueY
				    },
				    plotOptions: {
				        series: {
				        	borderWidth: 1,
				            borderColor: '#fff'
				        }
				    },
				    series: [{
				        name: type.chartTypeNm,
				        data: opt.data1
				       /* ,
				        type: 'area',
				        fillColor: {
			                linearGradient: {
			                    x1: 0,
			                    y1: 0,
			                    x2: 0,
			                    y2: 1
			                },
			                stops: [
			                    [0, Highcharts.getOptions().colors[0]],
			                    [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
			                ]
			            },
			            threshold: null*/
				    }]
				});
			}
		}
}
