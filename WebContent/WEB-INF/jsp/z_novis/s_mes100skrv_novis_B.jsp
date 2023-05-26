<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>노비스바이오 대쉬보드</title>
    
	<link rel="stylesheet" type="text/css" href='<c:url value="/extjs_4.2.2/resources/css/ext-all.css" />'> 
	<script type="text/javascript" src='<c:url value="/extjs_6.2.0/ext-all-debug.js" />'></script>
	<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>

    <style>
    
    	.x-tip-body-default {
    		font-size: 14px;
    	}
    	.x-legend-item{
    		font-size: 18px;
    	}
    	.x-panel-header-text-container-default {
    		line-height: 25px;
    	}
    	.x-panel-header-default {
    		font-size: 20px;
    		font-weight: bold;
    	}
    	.x-table-layout {
    		font-size: 20px;
    		back-ground: '#00e1ff';
    	}
    	.x-toolbar {
    		font-size: 15px;
    	}
    	.oper-circle{
    		background-color:#008000;
			width: 60px; height: 60px;
			border-radius:75px;
			text-align:center;
			/* margin:0 auto; */
			vertical-align:middle;
			line-height:100px;
    	}
    	
    	.middle-circle{
    		background-color:#FF7F00;
			width: 60px; height: 60px;
			border-radius:75px;
			text-align:center;
			/* margin:0 auto; */
			vertical-align:middle;
			line-height:100px;
    	}
    	
    	.stop-circle{
    		background-color:#E61919;
			width: 60px; height: 60px;
			border-radius:75px;
			text-align:center;
			/* margin:0 auto; */
			vertical-align:middle;
			line-height:100px;
    	}
    	
    	.await-circle{
			background-color:#ddd;
			width: 60px; height: 60px;
			border-radius:75px;
			text-align:center;
			/* margin:0 auto; */
			vertical-align:middle;
			line-height:100px;
    	}
    </style>
    
<script type="text/javascript">

var gDomain = 'http://localhost:8080/g3erp';
var chart1Data = 0;
var chart2Data = 0;
var RELOAD_INTERVAL_CHART = 3;
var RELOAD_INTERVAL_GRID  = 3;
var intClock;

Ext.onReady(function(){
    
	Ext.define('dataModel', {
		extend:'Ext.data.Model',	//5.0.0
		fields : [{name: 'data'				,type:'int'}]
	});
	
	//	1번째, 2번째 패널 데이터 조회용 스토어
	var dataStore = Ext.create('Ext.data.Store', {
	    model: 'dataModel',
	    proxy: {
	   	 	type: 'ajax',
			api: {
			    read : 's_mes100skrv_novisSelectList'
			},
			reader : {
				roopProperty : 'records'
			}
	    },
	    loadStoreRecords: function() {
            this.load({
                params : {},
                callback : function(records,options,success)    {
                    if(success & records.length > 0) {
                    	var record = records[0];
                    	var timeOperEfficiency = record.data.TIME_OPER_EFFICIENCY;
                    	var perfmOperEfficiency = record.data.PERFM_OPER_EFFICIENCY;
                    	
                    	if (timeOperEfficiency > 10)
                    	{
                    		gaugeStore1.clearData();
                    		gaugeStore1.add({ data : record.data.TIME_OPER_EFFICIENCY - 10 });
                    	}
                    	
                    	if (perfmOperEfficiency > 10)
                    	{
                    		gaugeStore2.clearData();
                    		gaugeStore2.add({ data : record.data.PERFM_OPER_EFFICIENCY - 10 });
                    	}
                    	setTimeout(function(){
							//게이지 차트 데이터 업데이트
                        	gaugeStore1.clearData();
                			gaugeStore2.clearData();
                        	gaugeStore1.add({ data : record.data.TIME_OPER_EFFICIENCY });		//시간 가동효율 차트
                        	gaugeStore2.add({ data : record.data.PERFM_OPER_EFFICIENCY });		//성능 가동효율차트	
                    	},500);
                    	
                    	
                    	// 대쉬보드 및 판넬
                    	if(record.data.YN_OPER == 'True' )
                    		document.getElementById( 'pnl1CompCircleOnOff' ).setAttribute( 'class', 'oper-circle' );
                    	else
                    		document.getElementById( 'pnl1CompCircleOnOff' ).setAttribute( 'class', 'stop-circle' );
                    	
                    	if(record.data.YN_LAMP1 == 'True' )
                    		document.getElementById( 'pnl1CompCircleLamp1' ).setAttribute( 'class', 'oper-circle' );
                    	else
                    		document.getElementById( 'pnl1CompCircleLamp1' ).setAttribute( 'class', 'await-circle' );
                    	
                    	if(record.data.YN_LAMP2 == 'True' )
                    		document.getElementById( 'pnl1CompCircleLamp2' ).setAttribute( 'class', 'middle-circle' );
                    	else
                    		document.getElementById( 'pnl1CompCircleLamp2' ).setAttribute( 'class', 'await-circle' );
                    	
                    	if(record.data.YN_LAMP3 == 'True' )
                    		document.getElementById( 'pnl1CompCircleLamp3' ).setAttribute( 'class', 'stop-circle' );
                    	else
                    		document.getElementById( 'pnl1CompCircleLamp3' ).setAttribute( 'class', 'await-circle' );
                    	
                    	if(record.data.QTY_PRODT == null) record.data.QTY_PRODT = 0;
                    	if(record.data.SPEED_PRODT == null) record.data.SPEED_PRODT = 0;
                    	if(record.data.QTY_PRODT_BF == null) record.data.QTY_PRODT_BF = 0;
                    	if(record.data.SPEED_PRODT_BF  == null) record.data.SPEED_PRODT_BF = 0;
                    	
                    	document.getElementById('pnl1CompPrdt').innerText = record.data.QTY_PRODT;
                    	document.getElementById('pnl1CompRpm').innerHTML = record.data.SPEED_PRODT + '<font style="font-size:20px;"> RPM</font>';
                    	document.getElementById('pnl1CompPrdt1Ago').innerText = '전일동시간 : ' + record.data.QTY_PRODT_BF;
                    	document.getElementById('pnl1CompRpm1Ago').innerText = '전일동시간 :  ' + record.data.SPEED_PRODT_BF + '  RPM';
                    	
                    	// 가동정보 판넬
                    	if(record.data.TIME_START_OPER == null) record.data.TIME_START_OPER = '00:00:00';
                    	if(record.data.TIME_OPER == null) record.data.TIME_OPER = '00:00:00';
                    	if(record.data.TIME_STOP == null) record.data.TIME_STOP = '00:00:00';
                    	if(record.data.CNT_STOP == null) record.data.CNT_STOP = 0;
                    	document.getElementById('pnl2CompStartTime').innerText = record.data.TIME_START_OPER;
                    	document.getElementById('pnl2CompOperTime').innerText = record.data.TIME_OPER;
                    	document.getElementById('pnl2CompStopTime').innerText = record.data.TIME_STOP;
                    	document.getElementById('pnl2CompStopCnt').innerText = record.data.CNT_STOP;
                    }else
                    {
                    	document.getElementById( 'pnl1CompCircleOnOff' ).setAttribute( 'class', 'stop-circle' );
                    	document.getElementById( 'pnl1CompCircleLamp1' ).setAttribute( 'class', 'await-circle' );
                    	document.getElementById( 'pnl1CompCircleLamp2' ).setAttribute( 'class', 'await-circle' );
                    	document.getElementById( 'pnl1CompCircleLamp3' ).setAttribute( 'class', 'await-circle' );
                    	document.getElementById('pnl1CompPrdt').innerText = '0';
                    	document.getElementById('pnl1CompRpm').innerHTML = '0' + '<font style="font-size:20px;"> RPM</font>';
                    	document.getElementById('pnl1CompPrdt1Ago').innerText = '전일동시간 : ' + '0';
                    	document.getElementById('pnl1CompRpm1Ago').innerText = '전일동시간 :  ' + '0' + '  RPM';
                    }
                }
            });
        }
	});
	//	gauge 차트 store 1, 2
	var gaugeStore1 = Ext.create('Ext.data.Store', {
	      model : dataModel,
	      data: [{
	         'data' : chart1Data
	      }]
  	})
  	
  	var gaugeStore2 = Ext.create('Ext.data.Store', {
		  model : dataModel,
	      data: [{
	         'data' : chart2Data
	      }]
  	})
	///////// 반원 차트 1.
  	var gaugeChart1 = Ext.create('Ext.chart.PolarChart', {
        /* xtype: 'polar', */
        name : 'gauseChart1',
        id : 'gauseChart1',
        itemId : 'gauseChart1',
        rowspan: 4,
        /* style: 'background:#fff', */
        width: 440,
        height: 220,
        padding: '20 0 0 0',
        animate: true,
        border : false,
        store: gaugeStore1,
        insetPadding: 30,
        axes: [{
            type: 'numeric',
            position: 'gauge',
            minimum: 0,				// 눈금 시작 값
            maximum: 100,			// 눈금 종료 값
            margin: 10,
            majorTickSteps : 10		// 눈금 steps
            /* ,renderer : function(axis, label, layoutContext) {
                return (label / 10);
            } */
        }],
        series: [{
            type: 'gauge',
            angleField: 'data',
            donut: false,
            needle: true,
            needleLength: 100,
            colors: ['#000', '#F49D10'],
            totalAngle: Math.PI		// 각도
        }]
  	})
  	
  	///////// 반원 차트 2
  	var gaugeChart2 = Ext.create('Ext.chart.PolarChart', {
        ///////// 반원 차트 2.
        xtype: 'polar',
        name : 'gauseChart2',
        id : 'gauseChart2',
        itemId : 'gauseChart2',
        rowspan: 4,
        width: 440,
        height: 220,
        padding: '20 0 0 0',
        animate: true,
        border : false,
        store: gaugeStore2,
        insetPadding: 30,
        captions : {body : {style :{fontSize: 15} }},
        axes: [{
            type: 'numeric',
            position: 'gauge',
            minimum: 0,
            maximum: 100,
            majorTickSteps : 10,		// 눈금 steps
            margin: 10
        }],
        series: [{
            type: 'gauge',
            angleField: 'data',
            donut: 20,
            needleLength: 100,
            colors: ['#81C147', '#DDD'],
            totalAngle: Math.PI		// 각도
        }]
	})
  	
	//	하단 패널 라인 총생산량 차트 조회용 스토어
	var gridStore = Ext.create('Ext.data.Store', {
	    fields: [
	    	{name: 'HH'		,type:'string'},
	    	{name: 'HHMM'	,type:'string'},
	    	{name: 'CNT'	,type:'int'}
	    ],
	    proxy: {
	   	 	type: 'ajax',
			api: {
			    read : 's_mes100skrv_novisSelectProductionCnt'
			},
			reader : {
				roopProperty : 'records'
			}
	    },
	    loadStoreRecords: function() {
            this.load({
                params : {}
            });
        }
	});
	
	var totalProdtChart = Ext.create('Ext.chart.Chart', {
    	// 총샌산량 차트.
		xtype: 'chart',
		style: 'background:#fff',
		itemId: 'chartCmp',
		title: '총생산량',
		width		: '50%',
		height		: '100%',
		minHeight: 400,
		minWidth: 500,
		maximizable: true,
		shadow: false,
		animate: true,
		store: gridStore,
		axes: [{
		    type: 'numeric',
		    minimum: 0,
		    maximum: 10000,
		    position: 'left',
		    fields: ['Cnt'],
		    title: 'Minutes',
		    grid: {
		        odd: {
		            fill: '#dedede',
		            stroke: '#ddd',
		            'stroke-width': 0.5
		        }
		    }
		}, {
		    type: 'category',
		    position: 'bottom',
		    fields: 'HH',
		    title: 'Hour',
		    visibleRange: [0, 1],
		    minimum: '00',
		    maximum: '23',
		    grid: false
		}],
		series: [{
		    type: 'line',
		    smooth: false,
		    axis: ['left', 'bottom'],
		    xField: 'HHMM',
		    yField: 'CNT',
		    label: {
		        display: 'none',
		        field: 'CNT',
		        renderer: function(v) { return v >> 0; },
		        'text-anchor': 'middle'
		    },
		    markerConfig: {
		        radius: 1,
		        size: 1
		    }
		}]
	})
	
	// 3d 차트스토어
	var gridViewChartStore = Ext.create('Ext.data.Store', {
		fields: [
	    	{name: 'HH'					,type:'string'},
	    	{name: 'MM'					,type:'string'},
	    	{name: 'HHMM'				,type:'string'},
	    	{name: 'H_SUM_PRODT'		,type:'int'},
	    	{name: 'OVER_H_SUM_PRODT'	,type:'int'},
	    	{name: 'PERFM_H_SUM_PRODT'	,type:'int'},
	    	{name: 'TOT_MIN_CHART_DATA'	,type:'int'},
	    	{name: 'TOT_TIME'			,type:'string'}
		],
		proxy: {
			type: 'ajax',
			api: {
			    read : 's_mes100skrv_novisSelectProductionCnt2'
			},
			reader : {
				roopProperty : 'records'
			}
		},
		loadStoreRecords: function() {
            this.load({
                params : {}
            });
        }
	})
	
	var prodtChart = Ext.create('Ext.chart.Chart', {
		title		: '생산량',
		//titleAlign	: 'center',
		xtype		: 'cartesian',					//chart, cartesian, axis
		store		: gridViewChartStore,
		width		: '100%',
		height		: '100%',
		interactions: 'crosszoom',					//크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
		animate		: true,
		shadow		: false,
		innerPadding: '10 20 0 20'
		,					//간격조정2
		/* legend		: {								//범례 위치 설정 .. legend가 들어가면 범례생성됨.. 없애려면 legent 빼야함.
			docked	: 'top'
		}, */
		axes		: [{							//위치
			title	: '생산량',
			type	: 'numeric3d',
			position: 'left',						//Y축
			//grid	: true,							//그리드 선 표시 여부
			minimum	: 0,							//표시되는 최소치
			maximum : 3000,						//표시되는 최대치
			majorTickSteps: 10,					//Y축에 표시되는 값에 대한 간격
			grid: {
			        odd: {
			            fill: '#dedede',
			            stroke: '#ddd',
			            'stroke-width': 0.5
			        }
			    }
		}
		, {
			title	: '시간',
			//fields	: 'HH_MM',
			type	: 'category3d',
			position: 'bottom',						//X축
			//minimum: 0,
            //maximum: 2400,
            //majorTickSteps : 10,
			//grid	: true,							//그리드 선 표시 여부
			label	: {								//label 속성
			}
		}
		],
		series: [{
			type		: 'bar3d',					//line, bar, scatter(점), area(영역)
			//type		: 'line',					//line, bar, scatter(점), area(영역)
			axis		: 'left',
			stacked		: true,					//합칠지 여부
			xField		: 'HH_MM',
			title		: ['생산량'],					//범례에 변수에 대한 명칭설정
			yField		: ['H_SUM_PRODT'],
			//fill		: true,
			style		: {
				lineWidth: 2
			},
			marker		: {
				radius: 0
								
			},
			label		: {
				
				field	: ['H_SUM_PRODT_FM'],
				display	: 'insideEnd',				//outside, insideStart, insideEnd
				//display: 'none',
				orientation : 'horizontal',
				fontSize : '15px'
			},
			tooltip: {
				trackMouse: true,
				width	: 160,
				height	: 50,
				renderer: function (toolTip, record, ctx) {
					if(!Ext.isEmpty(record)){
						toolTip.setHtml('시간 : ' + record.get('HH_MM_TO') + '<br>' + '생산량 : ' + record.get('H_SUM_PRODT_FM'));
					}
				}
			}
		}
		/* ,{
			type		: 'line',					//line, bar, scatter(점), area(영역)
			axis		: 'left',
			stacked		: false,					//합칠지 여부
			xField		: 'HH_MM',
			title		: ['누적시간'],					//범례에 변수에 대한 명칭설정
			yField		: ['TOT_MIN_CHART_DATA'],
			colors		: ['#ff0000'],
			style		: {
				lineWidth: 2
			},
			marker		: {
				radius: 0.5
			},
			label		: {
				field	: ['TOT_MIN_CHART_DATA'],
				//display	: 'over',					//over, under, rotate
				display : 'none',
				color	: '#ff0000'
			}
			,
			tooltip: {
				trackMouse: true,
				width	: 140,
				height	: 70,
				style: {fontSize: '20px'}
				,
				renderer: function (toolTip, record, ctx) {
					if(!Ext.isEmpty(record)){
						toolTip.setHtml('시간 : ' + record.get('HH_MM_TO') + '<br>' + '생산량 : ' + record.get('H_SUM_PRODT_FM'));
					}
				}
			}
//			step: true
		} */
		]
		
	})
	//	
    Ext.create('Ext.Viewport', {
    	layout: 'border',
    	items: [{
    	    title: '노비스바이오 대쉬보드',
    	    flex: 1.7,
    	    region: 'north',
    	    tbar: ['->', {
    	    	xtype: 'label',
    	    	id: 'lblClock',
    	    	text: '&nbsp;',
    	    	width: 200
    	    }],
    	    items: [{
				region: 'border',
				border: false,
				layout: {
					type: 'table',
					columns: 4,
					tableAttrs: {
						style: {height: '100%' }
					},
					trAttrs: {
						style: { verticalAlign: 'top' }
					},
					tdAttrs: {
						style: { width : '14%' }
					}
				},
				//	1번째 패널
				items: [{
					xtype: 'label',
					padding: '0 0 0 160',
					text : '[가동상태]'
				},{
					xtype: 'label',
					padding: '0 0 0 20',
					text : '[원단감지램프]'
				},{
					width: 300,
					xtype: 'label',
					text : '[총생산량]'
				},{
					xtype: 'label',
					text : '[포장속도]'
				},{
					border : false,
					rowspan : 2,
					padding: '10 0 0 180',
					html: '<div id ="pnl1CompCircleOnOff" class="await-circle"></div>'	
				},{
					region: 'border',
					rowspan : 2,
					border : false,
					layout: {
						type: 'table',
						columns: 3,
					},
					items :[{
						border : false,
						padding: '10 0 0 0',
						html: '<div id ="pnl1CompCircleLamp1" class="await-circle"></div>'
							
					},{
						border : false,
						padding: '10 0 0 5',
						html: '<div id ="pnl1CompCircleLamp2" class="await-circle"></div>'
						
					},{
						border : false,
						padding: '10 0 0 5',
						html: '<div id ="pnl1CompCircleLamp3" class="await-circle"></div>'
					}]
				},{
					xtype: 'component',
					html: '&nbsp;',
					id : 'pnl1CompPrdt',
					style: {fontSize : '45px'}
				},{
					xtype: 'component',
					html: '&nbsp;',
					id : 'pnl1CompRpm',
					style: {fontSize : '45px'}
				},{
					xtype: 'component',
					html: '&nbsp;',
					id : 'pnl1CompPrdt1Ago',
					style: {fontSize : '18px', color:'gray'}
				},{
					xtype: 'component',
					html: '&nbsp;',
					id : 'pnl1CompRpm1Ago',
					style: {fontSize : '18px', color:'gray'}
				}]
    	    }]
    	},{
    	    title: '가동정보',
    	    flex: 2.8,
    	    region: 'center',
    	    items : [{
    	    	region: 'fit',
    	    	height:'100%',
    	    	//border: false,
    	    	layout: {
    	    		type: 'table',
    	    		columns: 4,
					tableAttrs: {
						style: {
							width: '100%',
							height: '100%'
						}
					}
    	    	},
    	    	items: [{
	               xtype: 'component' ,
	               html : '시작시간 :',
	               padding: '0 10 0 0',
	               style: {textAlign:'right', fontSize : '23px'}
				},{
	               xtype: 'component' ,
	               name : '시작시간data',
	               id 	: 'pnl2CompStartTime',
	               html: '&nbsp;',
	               
	               width: 150,
	               style: {fontSize : '23px'}}
				,gaugeChart1,gaugeChart2
				,{
	               xtype: 'component' ,
	               html : '가동시간 :',
	               padding: '0 10 0 0',
	               style: {textAlign:'right', fontSize : '23px'}
				},{
	               xtype: 'component' ,
	               id 	: 'pnl2CompOperTime',
	               html : '&nbsp;',
	               width: 150,
	               style: {fontSize : '23px'}
				},{
	               xtype: 'component' ,
	               html : '정지시간 :',
	               padding: '0 10 0 0',
	               style: {textAlign:'right', fontSize : '23px'}
				},{
				   xtype: 'component' ,
				   id 	: 'pnl2CompStopTime', 
	               html : '&nbsp;',
	               width: 150,
	               style: {fontSize : '23px'}
				},{
	               xtype: 'component' ,
	               html : '정지횟수 :',
	               padding: '0 10 0 0',
	               style: {textAlign:'right', fontSize : '23px'}
				},{
	               xtype: 'component' ,
	               id 	: 'pnl2CompStopCnt', 
	               html : '&nbsp;',
	               width: 150,
	               style: {fontSize : '23px'}
    	        },{
    	        	xtype: 'component',
    	        	html: '&nbsp;'
    	        },{
    	        	xtype: 'component',
    	        	html: '&nbsp;'
    	        },{
    	        	xtype: 'component',
    	        	html: '[시간 가동 효율]',
    	        	padding: '0 0 10 0',
    	        	width:440,
    	        	style: {fontSize:'20px', textAlign:'center'}
    	        },{
    	        	xtype: 'component',
    	        	html: '[성능 가동 효율]',
    	        	padding: '0 0 10 0',
    	        	width:440,
    	        	style: {fontSize:'20px', textAlign:'center'}
    	        }]
			}]
    	},{
    		xtype : 'container',
    		region : 'south',
    		layout : {type: 'hbox', align: 'fit'},
    		flex : 4,
    		border : true,
    		items : [ /* totalProdtChart, */ prodtChart]
    	}]
    });  
    
    var now = new Date();
    var nowLabel = '시간 표시 설정중...';
    var intervalChart = RELOAD_INTERVAL_CHART - 1;
    var intervalGrid  = RELOAD_INTERVAL_GRID  - 1;
    
    function fnSetInterval() {
	    intClock = setInterval(function(){
	    	now = new Date();
	    	nowLabel = fnMakeClockFormat(now);
	    	document.getElementById('lblClock').innerText = nowLabel;
	    	
	    	intervalChart++;
	    	intervalGrid++;
	    	if(intervalChart >= RELOAD_INTERVAL_CHART) {
	    		//gaugeStore1.clearData();
            	//gaugeStore2.clearData();
	    		dataStore.loadStoreRecords();
	    		intervalChart = 0;
	    	}
	    	if(intervalGrid >= RELOAD_INTERVAL_GRID) {
	    		gridViewChartStore.clearData();
	    		
	    		//gridStore.loadStoreRecords();
	    		gridViewChartStore.loadStoreRecords();
	    		intervalGrid = 0;
	    	}
	    }, 1000);
    };
    
    
    function fnMakeClockFormat(dateNtime) {
    	var mon = String(now.getMonth() + 1);
    	var day = String(now.getDay());
    	var hh = String(now.getHours());
    	var mm = String(now.getMinutes());
    	var ss = String(now.getSeconds());
    	
    	if(mon.length < 2) {
    		mon = '0' + mon;
    	}
    	if(day.length < 2) {
    		day = '0' + day;
    	}
    	if(hh.length < 2) {
    		hh = '0' + hh;
    	}
    	if(mm.length < 2) {
    		mm = '0' + mm;
    	}
    	if(ss.length < 2) {
    		ss = '0' + ss;
    	}
    	
    	return String(dateNtime.getFullYear()) + "년 " + mon + "월 " + day + "일  " + hh + ":" + mm + ":" + ss;
    }
    
    fnSetInterval();
    
});
</script>
 
</head>
<body>


</body>
</html>