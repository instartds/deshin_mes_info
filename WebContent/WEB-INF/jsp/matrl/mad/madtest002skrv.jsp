<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="madtest002skrv"  >
<t:ExtComboStore comboType="AU" comboCode="YP01"/>	<!-- POS명		-->
<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

//var gsShopCodes: ${gsShopCodes};		controller에  추가해서 가져와야함

function appMain() {
/*	var arrShopCodes = new Array();
	Ext.each(gsShopCodes, function(item){
		arrShopCodes.push(item.SHOP_CODE);
	});*/
	
	var arrShopCodes = ['101','103','104','105','106','107','108','109'];
	
    Ext.define('chartModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'CODE_NAME', 'SUM_SALE']
	});
	var chartStore = new Ext.data.SimpleStore({
  		model:'chartModel',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest002skrvService.selectList'                	
            }
        }
	});
	
    var chart = Ext.create('Ext.chart.Chart', {
        animate: true,
        shadow: true,
        store: chartStore,
        axes: [{
            type: 'Numeric',
            position: 'bottom',
            fields: ['SUM_SALE'],
            label: {
                renderer: Ext.util.Format.numberRenderer('0,0')
            },
            title: '매 출 금 액 / 천단위',
            grid: true,
            minimum: 0
        }, {
            type: 'Category',
            position: 'left',
            fields: ['CODE_NAME'],
            title: '매 장 명'
        }],
        theme: 'Base:gradients',
        background: {
            gradient: {
                id: 'backgroundGradient',
                angle: 45,
                stops: {
                    0: {
                        color: '#ffffff'
                    },
                    100: {
                        color: '#eaf1f8'
                    }
                }
            }
        },
        series: [{
            type: 'bar',
            axis: 'bottom',
            highlight: true,
            tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('CODE_NAME') + ': ' + storeItem.get('SUM_SALE') + '원/천단위');
                }
            },
            label: {
              display: 'insideEnd',
                  field: 'SUM_SALE',
                  renderer: Ext.util.Format.numberRenderer('0,0'),
                  orientation: 'horizontal',
                  color: '#333',
                'text-anchor': 'middle'
            },
            xField: 'CODE_NAME',
            yField: ['SUM_SALE']
        }]
    });
     var panelResult = Unilite.createSearchForm('panelResultForm1', {
    	
		region: 'north',
		border:true,
		layout : 'fit',
		
      	width: 500,
        height: 400,
        minHeight: 100,
        minWidth: 150,
        hidden: false,
      //  maximizable: true,
        title: '매장별 매출현황',
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                // Add a short delay to prevent fast sequential clicks
                window.loadTask.delay(100, function() {
                    store1.loadData(generateData(8));
                });
            }
        }],
        items: chart
    });
    
    
    
    Ext.define('chartModel2', {
	    extend: 'Ext.data.Model',
	    fields: [ 'DIV_NAME', 'SUM_SALE']
	});
	var chartStore2 = new Ext.data.SimpleStore({
  		model:'chartModel2',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest002skrvService.selectList2'                	
            }
        }
	});
	
    var chart2 = Ext.create('Ext.chart.Chart', {
        style: 'background:#fff',
        animate: true,
        store: chartStore2,
        shadow: true,
      //  title:'name',
        theme: 'Category1',
        legend: {
            position: 'right'
        },
        axes: [{
            type: 'Numeric',
            minimum: 0,
            position: 'left',
            fields: ['SUM_SALE'],
            grid:true,
         //   fields: ['value1'],
          /*  label: {
            	renderer: Ext.util.Format.numberRenderer('0,0')
    		},*/
            title: '매 출 금 액 / 천단위',
            minorTickSteps: 1
           /*{
                odd: {
                    opacity: 1,
                    fill: '#ddd',
                    stroke: '#bbb',
                    'stroke-width': 0.5
                }
            }*/
        },{
            type: 'Category',
            position: 'bottom',
          //  fields: ['name'],
            fields: ['DIV_NAME'],
            title: '사 업 장'
        }],
        series: [{
            type: 'line',
            fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'매출현황',
          //  title: record.get('POS_NUM'),
            xField: 'DIV_NAME', 
            yField: 'SUM_SALE',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
              //  type: 'cross',
              //  size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('SUM_SALE'));
                }
            }
        }]
    });
     var panelResult2 = Unilite.createSimpleForm('panelResultForm2', {
    	
		region: 'west',
		border:true,
		layout : 'fit',
		
      	width: 500,
        height: 400,
        minHeight: 100,
        minWidth: 150,
        hidden: false,
      //  maximizable: true,
        title: '사업장별 매출현황',
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                // Add a short delay to prevent fast sequential clicks
                window.loadTask.delay(100, function() {
                    store1.loadData(generateData(8));
                });
            }
        }],
        items: chart2
    });
    
    Ext.define('chartModel3', {
	    extend: 'Ext.data.Model',
	    fields: [ 'DIV_NAME', 'SUM_SALE']
	});
	var chartStore3 = new Ext.data.SimpleStore({
  		model:'chartModel3',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest002skrvService.selectList2'                	
            }
        }
	});
	
    var chart3 = Ext.create('Ext.chart.Chart', {
	    width: 500,
	    height: 350,
	    animate: true,
	    store: chartStore3,
	    legend: {
                field: 'DIV_NAME',
                position: 'right',
                boxStrokeWidth: 0,
                labelFont: '12px Helvetica'
            },       
	    theme: 'Base:gradients',
	    series: [{
	        type: 'pie',
	        angleField: 'SUM_SALE',
	        showInLegend: true,
	        tips: {
	            trackMouse: true,
	            width: 140,
	            height: 28,
	            renderer: function(storeItem, item) {
	                // calculate and display percentage on hover
	                var total = 0;
	                chartStore3.each(function(rec) {
	                    total += rec.get('SUM_SALE');
	                });
	                this.setTitle(storeItem.get('DIV_NAME') + ': ' + Math.round(storeItem.get('SUM_SALE') / total * 100) + '%');
	            }
	        },
	        highlight: {
	            segment: {
	                margin: 20
	            }
	        },
	        label: {
	            field: 'DIV_NAME',
	            display: 'rotate',
	            contrast: true,
	            font: '18px Arial'
	        }
	    }]
    });
     var panelResult3 = Unilite.createSimpleForm('panelResultForm3', {
    	
		region: 'east',
		border:true,
		layout : 'fit',
		
      	width: 500,
        height: 400,
        minHeight: 100,
        minWidth: 150,
        hidden: false,
      //  maximizable: true,
        title: '사업장별 매출현황',
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                // Add a short delay to prevent fast sequential clicks
                window.loadTask.delay(100, function() {
                    store1.loadData(generateData(8));
                });
            }
        }],
        items: chart3
    });
 
    

				/*madtest002skrvService.selectList001({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						
						
						var rule = [];
						Ext.each(provider, function(data, i)	{
			        		switch(data['SHOP_CODE']) {
			        			case "A" : rule["A"] = data['SHOP_CODE']	//숫자체크
			        		}
		        		});
					}
				}),*/
    
    Ext.define('chartModel4', {
	    extend: 'Ext.data.Model',
	    fields: ['SALE_TIME'].concat(arrShopCodes)//[ 'SALE_TIME','101']
	});
	var chartStore4 = new Ext.data.SimpleStore({
  		model:'chartModel4',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest002skrvService.selectList4'                	
            }
        }
	});
	
	var chart4Series = new Array();
	Ext.each(arrShopCodes, function(shopCode){
		chart4Series.push(
			{
	            type: 'line',
	       //     fill:true,
	            highlight: {
	                size: 7,
	                radius: 7
	            },
	            axis: 'left',
	          //   showMarkers:true,
	            title:'하얀샘01',
	          //  title: record.get('POS_NUM'),
	            xField: 'SALE_TIME', 
	            yField: shopCode,	// 비교필드는 y필드
	          	//title:'101',
	            markerConfig: {
	            //    type: 'cross',
	            //    size: 4,
	                radius: 4,
	                'stroke-width': 0
	            },
	             tips: {
	                trackMouse: true,
	                renderer: function(storeItem, item) {
	                    this.setTitle(storeItem.get(shopCode));
	                }
	            }
	        }
		);
	});
    var chart4 = Ext.create('Ext.chart.Chart', {
	    style: 'background:#fff',
        animate: true,
        store: chartStore4,
        shadow: true,
      //  title:'name',
        theme: 'Category1',
        legend: {
            position: 'right'
        },
        axes: [{
            type: 'Numeric',
            minimum: 0,
            position: 'left',
            fields: arrShopCodes, //['101','P02_AMT','P03_AMT','P04_AMT','P05_AMT','P06_AMT','P07_AMT','P08_AMT','P09_AMT','P10_AMT'],
            grid:true,
         //   fields: ['value1'],
          /*  label: {
            	renderer: Ext.util.Format.numberRenderer('0,0')
    		},*/
            title: '매 출 금 액 / 천단위',
            minorTickSteps: 1
           /*{
                odd: {
                    opacity: 1,
                    fill: '#ddd',
                    stroke: '#bbb',
                    'stroke-width': 0.5
                }
            }*/
        },{
            type: 'Category',
            position: 'bottom',
          //  fields: ['name'],
            fields: ['SALE_TIME'],
            title: '시 간 대'
        }],
        series: chart4Series/*[{
            type: 'line',
       //     fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'하얀샘01',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: '101',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
            //    type: 'cross',
            //    size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('101'));
                }
            }
        }*//*,{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'하얀샘02',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P02_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
      //          type: 'cross',
      //          size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P02_AMT'));
                }
            }
        },{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'솟을샘01',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P03_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
       //         type: 'cross',
        //        size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P03_AMT'));
                }
            }
        },{
            type: 'line',
         //   fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'한울샘',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P04_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
        //        type: 'cross',
        //        size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P04_AMT'));
                }
            }
        },{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'이슬샘',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P05_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
      //          type: 'cross',
      //          size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P05_AMT'));
                }
            }
        },{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'청경관01',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P06_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
       //         type: 'cross',
       //         size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P06_AMT'));
                }
            }
        },{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'청경관02',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P07_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
      //          type: 'cross',
     //           size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P07_AMT'));
                }
            }
        },{
            type: 'line',
       //     fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'상록샘01',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P08_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
    //           type: 'cross',
      //          size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P08_AMT'));
                }
            }
        },{
            type: 'line',
         //   fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'맛나샘01',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P09_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
     //           type: 'cross',
     //           size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P09_AMT'));
                }
            }
        },{
            type: 'line',
        //    fill:true,
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'맛나샘02',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P10_AMT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
       //         type: 'cross',
       //         size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P10_AMT'));
                }
            }
        }]*/
    });
     var panelResult4 = Unilite.createSimpleForm('panelResultForm4', {
    	
		region: 'center',
		border:true,
		layout : 'fit',
		
      	width: 500,
        height: 400,
        minHeight: 100,
        minWidth: 150,
        hidden: false,
      //  maximizable: true,
        title: '사업장별 매출현황',
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                // Add a short delay to prevent fast sequential clicks
                window.loadTask.delay(100, function() {
                    store1.loadData(generateData(8));
                });
            }
        }],
        items: chart4
    });
     Ext.define('chartModel5', {
	    extend: 'Ext.data.Model',
	    fields: [ 'SALE_DATE_MONTH', 'SUM_SALE','DIV_NAME']
	});
	var chartStore5 = new Ext.data.SimpleStore({
  		model:'chartModel5',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest002skrvService.selectList5'                	
            }
        }
	});
	
    var chart5 = Ext.create('Ext.chart.Chart', {
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
            store: chartStore5,
            //insetPadding: 40,            
            axes: [{
                type: 'Numeric',
                position: 'left',
                grid: true,
                 fields: ['SUM_SALE'],
//                label: {
//                    renderer: function(v) { return v + '%'; }
//                },
                minimum: 0
            }, {
                type: 'Category',
                position: 'bottom',
                grid: true,
                fields: ['SALE_DATE_MONTH']/*,
                label: {
                    rotate: {
                        degrees: -45
                    }
                }*/
        }],
            series: [{
                type: 'column',
                axis: 'left',
                title: ['DIV_NAME'],
                xField: 'SALE_DATE_MONTH',
                yField: ['SUM_SALE'],
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
                        this.setTitle(browser + ' for ' + storeItem.get('SALE_DATE_MONTH') + ': ' + storeItem.get(item.yField));
                    }
                }
            }]
    });
     var panelResult5 = Unilite.createSimpleForm('panelResultForm5', {
    	
		region: 'east',
		border:true,
		layout : 'fit',
		
      	width: 500,
        height: 400,
        minHeight: 100,
        minWidth: 150,
        hidden: false,
      //  maximizable: true,
        title: '사업장별 매출현황',
        layout: 'fit',
        tbar: [{
            text: 'Save Chart',
            handler: function() {
                Ext.MessageBox.confirm('Confirm Download', 'Would you like to download the chart as an image?', function(choice){
                    if(choice == 'yes'){
                        chart.save({
                            type: 'image/png'
                        });
                    }
                });
            }
        }, {
            text: 'Reload Data',
            handler: function() {
                // Add a short delay to prevent fast sequential clicks
                window.loadTask.delay(100, function() {
                    store1.loadData(generateData(8));
                });
            }
        }],
        items: chart5
    });
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
    	
    	
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		panelResult,panelResult2,panelResult5,panelResult4//,panelResult3
         	]	
      	}/*,
      		panelSearch*/
      	],
		id: 'madtest002skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
		},
		/*onQueryButtonDown: function()	{
			
			chartStore.loadStoreRecords();
		},*/
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}/*,
		fnShopCodeCheck: function(rtnRecord, fieldName, oldValue)	{
			
			madtest002skrvService.selectList001( function(provider, response)	{
				if(!Ext.isEmpty(provider) )	{
					
					
				}
			})
		}*/
	});
	

	    
/*	var btnChart = {
			xtype:'uniBaseButton',	iconCls: 'icon-chart',
			text : 'Chart',tooltip : 'Chart', disabled: false,
			width: 26, height: 26,
	 		itemId : 'chart',
			handler : function() {
				
				chartStore.loadStoreRecords();
				//chartStore.removeAll();
				//directMasterStore.each(function(rec) {
			
                        //total += rec.get('data1');
					var key = rec.key;
					var sum =0;
					var sale_time;
					var p01_cnt;
					chartStore.each(function(rec) {
						sale_time = rec.get('SALE_TIME');
						po1_cnt	= rec.get('P01_CNT');
					});
					Ext.each(chartStore.data.items, function(record,index) {
							sale_time= record.get('SALE_TIME');
							p01_cnt= record.get('P01_CNT');
							
							 chartStore.add({
		                    	time: sale_time,
		                    	pos: p01_cnt
		                    });
							
					});
                   
             

//	console.log('store',data);
	
      
			//	panelResult2.expand() ;
			}
			
			
			
			
	};
	
	
	UniAppManager.addButton(btnChart);
	*/
	
};
</script>
