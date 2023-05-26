// @charset UTF-8
/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 * 연세대 신촌 캠퍼스
 */
Ext.define('Unilite.main.portal.MainPortalYSU', {
    extend: 'Unilite.main.portal.MainPortalPanel',

    // implement getPortalItems of base class
    getPortalItems: function() {
    	/*
    	//chart1 model
    	Unilite.defineModel('mainPortalChartModel1', {
		    fields: [				
				{name: 'SALE_DATE', type: 'string'}, 
				{name: 'SALE_Q', type: 'int'}
		    ]
		});

		//chart1 store
		var chartStore1 = Unilite.createStore('mainPortalChartStore1', {
			model: 'mainPortalChartModel1',
			autoLoad: true,
			uniOpt: {
				isMaster: false			// 상위 버튼 연결
			},
			proxy: {
				type: 'direct',
				api: {
					read: 'mainPortalService.selectSales1'
				}
			}
		});
		
		//console.log('chartStore1', chartStore1);
    	
		var chart1 = {
    		xtype: 'chart',
            animate: false,
            shadow: false,
            store: chartStore1,
            legend: {
                position: 'right'
            },
            axes: [{
                type: 'Numeric',
                position: 'left',
                fields: ['SALE_Q'],
                title: 'sales',
                label: {
                    font: '11px Arial'
                }
            },{
	            type: 'Category',
	            position: 'bottom',
	            fields: ['SALE_DATE'],
	            title: 'Month of the Year'
	        }],
            series: [{
                type: 'line',
                lineWidth: 1,
                showMarkers: false,
                fill: true,
                axis: 'left',
                xField: 'SALE_DATE',
                yField: 'SALE_Q',
                style: {
                    'stroke-width': 1,
                    stroke: 'rgb(148, 174, 10)'

                }
            }]
    	};    	
    	*/
    	var store1 = Ext.create('Ext.data.JsonStore', {
            fields: ['name', 'data' ],
            data: [
				{name: '하얀샘01', data: 480000 },
				{name: '하얀샘02', data: 400000 },
				{name: '솟을샘01', data: 890000 },
				{name: '한울샘', data: 230000 },
				{name: '이슬샘', data: 410000 },
				{name: '청경관01', data: 420000 },
				{name: '청경관02', data: 270000 },
				{name: '상록샘01', data: 280000 },
				{name: '맛나샘01', data: 200000 },
				{name: '맛나샘02', data: 800000 },
				{name: '부를샘-경음료', data: 700000 },
				{name: '고를샘02', data: 810000 },
				{name: '고를샘01', data: 30000 },
				{name: '글로벌라운지', data: 690000 },
				{name: '교직원식당01', data: 630000 },
				{name: '교직원식당02', data: 770000 },
				{name: '솟을샘02', data: 200000 },
				{name: '상록샘02', data: 230000 },
				{name: '청경관03(특판)', data: 710000 }
            ]
        });
		var chart1 = {
            xtype: 'chart',
            width: '100%',
            height: 520,
            padding: '5 0 0 0',
            style: 'background: #fff',
            animate: true,
            shadow: false,
            store: store1,
            //insetPadding: 40,
            axes: [{
                type: 'Numeric',
                position: 'bottom',
                fields: ['data'],
//                label: {
//                    renderer: function(v) { return v + '%'; }
//                },
                grid: true,
                minimum: 0
            }, {
                type: 'Category',
                position: 'left',
                fields: ['name'],
                grid: true
            }],
            series: [{
                type: 'bar',
                axis: 'bottom',
                xField: 'name',
                yField: 'data',
                style: {
                    opacity: 0.80
                },
                highlight: {
                    fill: '#000',
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        this.setTitle(storeItem.get('name') + ': ' + storeItem.get('data'));
                    }
                }
            }]
        };
    	        
        var store2 = Ext.create('Ext.data.JsonStore', {
            fields: ['name', 'data' ],
            data: [
				{name: '사업1팀', data: 7389900 },
				{name: '사업2팀', data: 12830990 },
				{name: '사업3팀', data: 9080090 },
				{name: '사업4팀', data: 5234000 }

            ]
        });
    	var chart2 = {
            xtype: 'chart',
            width: '100%',
            height: 150,
            padding: '5 0 0 0',
            style: {
                'background' : '#fff'
            },
            animate: true,
            shadow: false,
            store: store2,
            //insetPadding: 40,            
            axes: [{
                type: 'Numeric',
                fields: 'data',
                position: 'left',
                grid: true,
                minimum: 0
            }, {
                type: 'Category',
                fields: 'name',
                position: 'bottom',
                grid: true/*,
                label: {
                    rotate: {
                        degrees: -45
                    }
                }*/
            }],
            series: [{
                type: 'line',
                axis: 'left',
                xField: 'name',
                yField: 'data',
                fill: true,
                style: {
                    'stroke-width': 4
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    showDelay: 0,
                    dismissDelay: 0,
                    hideDelay: 0,
                    renderer: function(storeItem, item) {
                        this.setTitle(storeItem.get('name') + ': ' + storeItem.get('data'));
                    }
                }
            }]
        };
        
        var store3 = Ext.create('Ext.data.JsonStore', {
            fields: ['name', 'data' ],
            data: [
				{name: '사업1팀', data: 7389900 },
				{name: '사업2팀', data: 12830990 },
				{name: '사업3팀', data: 9080090 },
				{name: '사업4팀', data: 5234000 }
            ]
        });
        var chart3 = {
            xtype: 'chart',
            width: '100%',
            height: 120,
            padding: '5 0 0 0',
            style: 'background: #fff',
            animate: true,
            shadow: false,
            store: store3,
            //insetPadding: 40,
            legend: {
                field: 'name',
                position: 'right',
                boxStrokeWidth: 0,
                labelFont: '12px Helvetica'
            },            
            series: [{
                type: 'pie',
                angleField: 'data',
                label: {
                    field: 'name',
                    display: 'inside',
                    calloutLine: true,
                    contrast: true
                },
                showInLegend: true,
                highlight: true,
                highlightCfg: {
                    fill: '#000',
                    'stroke-width': 20,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    renderer: function(storeItem, item) {
                        this.setTitle(storeItem.get('name') + ': ' + storeItem.get('data'));
                    }
                }
            }]
        };
        
        var store4 = Ext.create('Ext.data.JsonStore', {
            fields: ['name', 'data1', 'data2', 'data3', 'data4' ],
            data: [
				{name: '1', data1: 7715014, data2: 8919545, data3: 8946667, data4: 8134128},
				{name: '2', data1: 8636951, data2: 3873090, data3: 7396165, data4: 5963626},
				{name: '3', data1: 2354069, data2: 2210196, data3: 1774822, data4: 2870037},
				{name: '4', data1: 9936156, data2: 5255193, data3: 3170542, data4: 8354155},
				{name: '5', data1: 7625363, data2: 6213866, data3: 8982387, data4: 3925617},
				{name: '6', data1: 8163287, data2: 3254080, data3: 8633007, data4: 1741703},
				{name: '7', data1: 8599280, data2: 5862951, data3: 9549322, data4: 1604320},
				{name: '8', data1: 7637640, data2: 1456995, data3: 1463881, data4: 1496282},
				{name: '9', data1: 1538969, data2: 2828146, data3: 3907223, data4: 9063517},
				{name: '10', data1: 3452792, data2: 3435856, data3: 9432382, data4: 6804078},
				{name: '11', data1: 7173050, data2: 9948881, data3: 4183416, data4: 5791583},
				{name: '12', data1: 1519843, data2: 2303035, data3: 1870216, data4: 7418684}
            ]
        });
        var chart4 = {
            xtype: 'chart',
            width: '100%',
            height: 170,
            padding: '5 0 0 0',
            animate: true,
            shadow: false,
            style: 'background: #fff;',
            legend: {
                position: 'bottom',
                boxStrokeWidth: 0,
                labelFont: '12px Helvetica'
            },
            store: store4,
            //insetPadding: 40,            
            axes: [{
                type: 'Numeric',
                position: 'left',
                grid: true,
                 fields: ['data1','data2','data3','data4'],
//                label: {
//                    renderer: function(v) { return v + '%'; }
//                },
                minimum: 0
            }, {
                type: 'Category',
                position: 'bottom',
                grid: true,
                fields: ['name']/*,
                label: {
                    rotate: {
                        degrees: -45
                    }
                }*/
            }],
            series: [{
                type: 'column',
                axis: 'left',
                title: [ '사업1팀', '사업2팀', '사업3팀', '사업4팀' ],
                xField: 'name',
                yField: [ 'data1', 'data2', 'data3', 'data4' ],
                stacked: true,
                style: {
                    opacity: 0.80
                },
                highlight: {
                    fill: '#000',
                    'stroke-width': 1,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var browser = item.series.title[Ext.Array.indexOf(item.series.yField, item.yField)];
                        this.setTitle(browser + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.yField));
                    }
                }
            }]
        };
        
        
        var store5 = Ext.create('Ext.data.JsonStore', {
            fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data8', 'data9' ],
            data: [
                {name:'9', data1:377271,data2:299466,data3:257167,data4:151454,data5:481947,data6:304413,data7:404447,data8:320384,data9:370288},
				{name:'10', data1:394751,data2:396457,data3:235602,data4:142088,data5:228126,data6:215874,data7:163598,data8:387205,data9:132693},
				{name:'11', data1:333375,data2:228146,data3:69753,data4:403721,data5:225940,data6:286899,data7:483281,data8:408507,data9:127045},
				{name:'12', data1:388489,data2:463733,data3:484174,data4:359022,data5:349869,data6:130235,data7:153241,data8:56242,data9:325865},
				{name:'13', data1:11668,data2:175951,data3:294744,data4:265509,data5:233008,data6:108433,data7:343328,data8:183084,data9:300452},
				{name:'14', data1:168941,data2:50352,data3:129716,data4:415745,data5:172161,data6:298763,data7:333703,data8:349412,data9:381216},
				{name:'15', data1:223738,data2:416733,data3:397877,data4:308191,data5:311462,data6:456256,data7:372960,data8:216824,data9:186602}
            ]
        });
        var chart5 = {
            xtype: 'chart',
            width: '100%',
            height: 520,
            padding: '5 0 0 0',
            animate: true,
            shadow: false,
            style: 'background: #fff;',
            legend: {
                position: 'bottom',
                boxStrokeWidth: 0,
                labelFont: '11px Helvetica'
            },
            store: store5,
            //insetPadding: 40,            
            axes: [{
                type: 'Numeric',
                fields: ['data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data8', 'data9' ],
                position: 'left',
                grid: true,
                minimum: 0
            }, {
                type: 'Category',
                fields: 'name',
                position: 'bottom',
                grid: true/*,
                label: {
                    rotate: {
                        degrees: -45
                    }
                }*/
            }],
            series: [{
                type: 'line',
                axis: 'left',
                title: '하얀샘',
                xField: 'name',
                yField: 'data1',
                style: {
                    'stroke-width': 4
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '솟을샘',
                xField: 'name',
                yField: 'data2',
                style: {
                    'stroke-width': 4
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '한울샘',
                xField: 'name',
                yField: 'data3',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
            }, {
                type: 'line',
                axis: 'left',
                title: '이슬샘',
                xField: 'name',
                yField: 'data4',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }, {
                type: 'line',
                axis: 'left',
                title: '상록샘',
                xField: 'name',
                yField: 'data5',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }, {
                type: 'line',
                axis: 'left',
                title: '맛나샘',
                xField: 'name',
                yField: 'data6',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }, {
                type: 'line',
                axis: 'left',
                title: '고를샘',
                xField: 'name',
                yField: 'data7',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           },{
                type: 'line',
                axis: 'left',
                title: '부를샘',
                xField: 'name',
                yField: 'data8',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }/*,{
                type: 'line',
                axis: 'left',
                title: '창경관',
                xField: 'name',
                yField: 'data9',
                style: {
                    'stroke-width': 2
                },
                markerConfig: {
                    radius: 4
                },
                highlight: {
                    fill: '#000',
                    radius: 5,
                    'stroke-width': 2,
                    stroke: '#fff'
                },
                tips: {
                    trackMouse: true,
                    style: 'background: #FFF',
                    height: 20,
                    renderer: function(storeItem, item) {
                        var title = item.series.title;
                        this.setTitle(title + ' for ' + storeItem.get('name') + ': ' + storeItem.get(item.series.yField));
                    }
                }
           }*/]
        };
//        
//        var store6 = Ext.create('Ext.data.JsonStore', {
//            fields: ['data1', 'data2', 'data3', 'data4' ],
//            data: [
//                { data1: 65, data2: 50, data3: 90, data4: 30 }
//            ]
//        });
//        var chart6 = [{
//            xtype: 'panel',
//            width: '100%',
//            flex: 1,
//            layout: {
//                type: 'hbox',
//                align: 'stretch'
//            },
//            items: [/*{
//                xtype: 'chart',
//                height: 180,
//                width: 300,
//                padding: '5 5 5 5',
//                style: 'background: #fff',
//                animate: true,
//                shadow: false,
//                store: store6,
//                //insetPadding: 40,                
//                axes: [{
//                    title: '3M넥스케어 황사마스',
//                    type: 'gauge',
//                    position: 'gauge',
//                    maximum: 100,
//                    steps: 10,
//                    margin: 10
//                }],
//                series: [{
//                    type: 'gauge',
//                    field: 'data1',
//                    needle: true,
//                    donut: 30,
//                    colorSet: [ '#FFFFFF', '#FFFF00'],
//                    renderer: function(sprite, record, attributes, index, store) {
//                        return attributes;
//                    }
//                }]
//            }*/{
//                xtype: 'chart',
//                height: 160,
//                width: 260,
//                padding: '5 5 5 5',
//                style: 'background: #fff',
//                animate: true,
//                store: store6,
//                //insetPadding: 40,              
//                axes: [{
//                    title: '3M WP-5500/레이저포',
//                    type: 'gauge',
//                    position: 'gauge',
//                    maximum: 100,
//                    steps: 10,
//                    margin: 10
//                }],
//                series: [{
//                    type: 'gauge',
//                    field: 'data2',
//                    donut: 50
//                }]
//            }]
//        }];
        
    	var itemCol1 = {
	        items: [{
	            title: 'POS별 매출현황',
	            layout: 'fit',
	            items: [chart1]
	        }]
	    };
	    
	    var itemCol2 = {
	        items: [{
	           title: '사업팀별매출현황',
	           layout: 'fit',
	           items: [chart2]
	        },{
	           title: '사업팀별매출현황',
	           layout: 'fit',
	           items: [chart3]
	        },{
	           title: '사업팀별매출현황',
	           layout: 'fit',
	           items: [chart4]
	        }]
	    };
	    
	    var itemCol3 = {
	        items: [{
	           title: '시간대별매출현황',
	           layout: 'fit',
	           items: [chart5]
	        }/*,{
	           title: '주요품목적정재고현황',
	           layout: 'fit',
	           items: chart6
	        }*/]
	    };
	    
	    return [itemCol1,
    			itemCol2,
    			itemCol3]
    },
    
    //private
    generateData: function(){
        var data = [{
                name: 0,
                djia: 10000,
                sp500: 1100
            }],
            i;
        for (i = 1; i < 50; i++) {
            data.push({
                name: i,
                sp500: data[i - 1].sp500 + ((Math.floor(Math.random() * 2) % 2) ? -1 : 1) * Math.floor(Math.random() * 7),
                djia: data[i - 1].djia + ((Math.floor(Math.random() * 2) % 2) ? -1 : 1) * Math.floor(Math.random() * 7)
            });
        }
        return data;
    }
});