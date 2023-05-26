/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 * 연세대 신촌 캠퍼스
 */
Ext.define('Unilite.main.portal.MainPortalDEMO', {
	extend: 'Unilite.com.panel.portal.UniPortalPanel',
	title: 'Portal',
    itemId: 'portal',
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,
    // implement getPortalItems of base class
    getPortalItems: function() {
    	
    	
        Unilite.defineModel('chartModelt', {
    	    fields: ['month', 'data1', 'data2', 'data3', 'data4', 'other']
    	});
        var chart1 = {
	        id:'chart1',
	        xtype: 'chart',
	        width: '100%',
	        height: 400,
	        interactions: {
	            type: 'panzoom',
	            zoomOnPanGesture: true
	        },
	        animation: {
	            duration: 200
	        },
	        store: Ext.create( 'Ext.data.Store', {
	        	model:'chartModelt',
				data : [
		            { month: '11월', data1: "86317", data2: "86,317", data3: 35, data4: 4, other: 4 },
		            { month: '12월', data1: "149094", data2: "149,094", data3: 36, data4: 5, other: 2 },
		            { month: '1월', data1: "94164", data2: "94,164", data3: 37, data4: 4, other: 4 },
		            { month: '2월', data1: "141247", data2: "141,247", data3: 38, data4: 5, other: 3 },
		            { month: '3월', data1: "109859", data2: "109,859", data3: 39, data4: 4, other: 4 },
		            { month: '4월', data1: "125553", data2: "125,553", data3: 42, data4: 4, other: 3 },
		            { month: '5월', data1: "102012", data2: "102,012", data3: 43, data4: 4, other: 3 },
		            { month: '6월', data1: "133400", data2: "133,400", data3: 44, data4: 4, other: 3 },
		            { month: '7월', data1: "133400", data2: "133,400", data3: 44, data4: 4, other: 4 },
		            { month: '8월', data1: "86317", data2: "86,317", data3: 45, data4: 4, other: 3 },
		            { month: '9월', data1: "117706", data2: "117,706", data3: 46, data4: 4, other: 4 },
		            { month: '10월', data1: "133400", data2: "133,400", data3: 47, data4: 4, other: 3 }
		        ]
	        }),
	        insetPadding: 40,
	        innerPadding: {
	            left: 40,
	            right: 40
	        },
	        sprites: [{
	            type: 'text',
	            text: '2016-2017 월별 매출현황',
	            fontSize: 18,
	            width: 100,
	            height: 40,
	            x: 40, // the sprite x position
	            y: 20  // the sprite y position
	        }, {
	            type: 'text',
	            text: '2016-2017 ',
	            fontSize: 10,
	            x: 12,
	            y: 470
	        }],
	        axes: [{
	            type: 'numeric',
	            position: 'left',
	            grid: true,
	            minimum: 1000,
	            maximum: 200000,
	            renderer: 'onAxisLabelRender'
	        }, {
	            type: 'category',
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
	            xField: 'month',
	            yField: 'data1',
	            style: {
	                lineWidth: 2
	            },
	            marker: {
	                radius: 4,
	                lineWidth: 2
	            },
	            label: {
	                field: 'data2',
	                display: 'over'
	            },
	            highlight: {
	                fillStyle: '#000',
	                radius: 5,
	                lineWidth: 2,
	                strokeStyle: '#fff'
	            },
	            tooltip: {
	                trackMouse: true,
	                showDelay: 0,
	                dismissDelay: 0,
	                hideDelay: 0,
	                renderer: 'onSeriesTooltipRender'
	            }
	        }],
	        listeners: {
	            itemhighlightchange: 'onItemHighlightChange'
	        },
	        
	        onAxisLabelRender: function (axis, label, layoutContext) {
		        // Custom renderer overrides the native axis label renderer.
		        // Since we don't want to do anything fancy with the value
		        // ourselves except appending a '%' sign, but at the same time
		        // don't want to loose the formatting done by the native renderer,
		        // we let the native renderer process the value first.
		        //return layoutContext.renderer(label) + '';
		        var value = layoutContext.renderer(label);
		        return value !== '0' ? (value / 1000 + ',000') : value;
		    },
		
		    onSeriesTooltipRender: function (tooltip, record, item) {
		    	var value =  record.get('data1');
		        value = value !== '0' ? (value / 1000 + ',000') : value;
		        tooltip.setHtml(record.get('month') + ': ' + value);
		    },
		
		    onItemHighlightChange: function (chart, newHighlightItem, oldHighlightItem) {
		        this.setSeriesLineWidth(newHighlightItem, 4);
		        this.setSeriesLineWidth(oldHighlightItem, 2);
		    },
		
		    setSeriesLineWidth: function (item, lineWidth) {
		        if (item) {
		            item.series.setStyle({
		                lineWidth: lineWidth
		            });
		        }
		    },
		
		    onPreview: function () {
		        if (Ext.isIE8) {
		            Ext.Msg.alert('Unsupported Operation', 'This operation requires a newer version of Internet Explorer.');
		            return;
		        }
		        var chart = this;
		        chart.preview();
		    }

        }
    	
    	Ext.define('chartModel2', {
    	    extend: 'Ext.data.Model',
    	     fields: ['year', '경기', '인천', '서울']
    	});
        var store2 = new Ext.data.Store({
      		model:'chartModel2',
      		data: [
		        
		        {
		            "year": 2000,
		            "경기": "273393",
		            "인천": "308322",
		            "서울": "860853"
		        },
		        {
		            "year": 2001,
		            "경기": "297916",
		            "인천": "305424",
		            "서울": "908915"
		        },
		        {
		            "year": 2002,
		            "경기": "325463",
		            "인천": "309480",
		            "서울": "966063"
		        },
		        {
		            "year": 2003,
		            "경기": "360829",
		            "인천": "323667",
		            "서울": "1028475"
		        },
		        {
		            "year": 2004,
		            "경기": "399684",
		            "인천": "332220",
		            "서울": "1062183"
		        },
		        {
		            "year": 2005,
		            "경기": "442749",
		            "인천": "338297",
		            "서울": "1097753"
		        },
		        {
		            "year": 2006,
		            "경기": "496780",
		            "인천": "350857",
		            "서울": "1151068"
		        },
		        {
		            "year": 2007,
		            "경기": "561996",
		            "인천": "369016",
		            "서울": "1227493"
		        },
		        {
		            "year": 2008,
		            "경기": "645626",
		            "인천": "385850",
		            "서울": "1309370"
		        },
		        {
		            "year": 2009,
		            "경기": "749822",
		            "인천": "404439",
		            "서울": "1385590"
		        },
		        {
		            "year": 2010,
		            "경기": "879082",
		            "인천": "424303",
		            "서울": "1447763"
		        },
		        {
		            "year": 2011,
		            "경기": "982685",
		            "인천": "428120",
		            "서울": "1471858"
		        },
		        {
		            "year": 2012,
		            "경기": "1081381",
		            "인천": "407529",
		            "서울": "1441873"
		        },
		        {
		            "year": 2013,
		            "경기": "1208545",
		            "인천": "431698",
		            "서울": "1496440"
		        },
		        {
		            "year": 2014,
		            "경기": "1348208",
		            "인천": "438615",
		            "서울": "1551793"
		        },
		        {
		            "year": 2015,
		            "경기": "1477438",
		            "인천": "453029",
		            "서울": "1616315"
		        },
		        {
		            "year": 2016,
		            "경기": "1614909",
		            "인천": "466755",
		            "서울": "1676805"
		        },
		        {
		            "year": 2017,
		            "경기": "1763201",
		            "인천": "478803",
		            "서울": "1741625"
		        }
		    ]
    	});
		var chart2 = {
	        xtype: 'cartesian',
	        reference: 'chart2',
	        width: '100%',
	        height: 500,
	        insetPadding: '40 40 40 40',
	        store:store2,
	        legend: {
	            docked: 'bottom'
	        },
	        sprites: [{
	            type: 'text',
	            text: '2000-2017 주요 지역별 매출 (서울, 경기, 인천)',
	            fontSize: 18,
	            width: 100,
	            height: 40,
	            x: 40, // the sprite x position
	            y: 20  // the sprite y position
	        }, {
	            type: 'text',
	            text: 'Data: 2000 - 2017',
	            fontSize: 12,
	            x: 12,
	            y: 525
	        }],
	        axes: [{
	            type: 'numeric',
	            position: 'left',
	            fields: ['경기', '인천', '서울'],
	           
	            grid: true,
	            minimum: 200000,
	            maximum: 2000000,
	            majorTickSteps: 10,
	            renderer: 'onAxisLabelRender'
	        }, {
	            type: 'category',
	            position: 'bottom',
	            fields: 'year',
	            label: {
	                rotate: {
	                    degrees: -45
	                }
	            }
	        }],
	        listeners: {
		        afterrender: 'onAfterRender'
		    },
	        onAxisLabelRender: function (axis, label, layoutContext) {
		        // Custom renderer overrides the native axis label renderer.
		        // Since we don't want to do anything fancy with the value
		        // ourselves except appending a '%' sign, but at the same time
		        // don't want to loose the formatting done by the native renderer,
		        // we let the native renderer process the value first.
		        var value = layoutContext.renderer(label);
		        return value !== '0' ? (value / 1000 + ',000') : value;
		    },
		
		    onPreview: function () {
		        var chart = this;
		        chart.preview();
		    },
		
		    getSeriesConfig: function (field, title) {
		        return {
		            type: 'area',
		            title: title,
		            xField: 'year',
		            yField: field,
		            style: {
		                opacity: 0.60
		            },
		            marker: {
		                opacity: 0,
		                scaling: 0.01,
		                fx: {
		                    duration: 200,
		                    easing: 'easeOut'
		                }
		            },
		            highlightCfg: {
		                opacity: 1,
		                scaling: 1.5
		            },
		            tooltip: {
		                trackMouse: true,
		                renderer: function (tooltip, record, item) {
		                    tooltip.setHtml(title + ' (' + record.get('year') + '): ' + record.get(field));
		                }
		            }
		        };
		    },
		
		    onAfterRender: function () {
		        //var chart = this,
		        chart = this;
		
		        chart.setSeries([
		            chart.getSeriesConfig('서울', '서울'),
		            chart.getSeriesConfig('경기', '경기'),
		            chart.getSeriesConfig('인천', '인천')
		        ]);
		    }
		};
    	
       
	     
	    Unilite.defineModel('chartModelPie', {
    	    fields: ['os', 'data1', 'data2' ]
    	});
        
		var chart3 = {
	        xtype: 'polar',
	        reference: 'chart',
	        innerPadding: 40,
	        width: '100%',
	        height: 400,
	        store: Ext.create('Ext.data.Store',{
	        	model:'chartModelPie',
	        	seed: 1.42,
				data: [
			        { os: 'Android', data1: 68.3, data2: 150 },
			        { os: 'iOS', data1: 17.9, data2: 200 },
			        { os: 'Windows Phone', data1: 10.2, data2: 250 },
			        { os: 'BlackBerry', data1: 1.7, data2: 90 },
			        { os: 'Others', data1: 1.9, data2: 190 }
			    ]
	        }),
	        theme: 'Muted',
	        interactions: ['itemhighlight', 'rotatePie3d'],
	        legend: {
	            type: 'sprite',
	            docked: 'bottom'
	        },
	        series: [
	            {
	                type: 'pie3d',
	                angleField: 'data1',
	                donut: 30,
	                distortion: 0.6,
	                highlight: {
	                    margin: 40
	                },
	                label: {
	                    field: 'os'
	                },
	                tooltip: {
	                    trackMouse: true,
	                    renderer: 'onSeriesTooltipRender'
	                }
	            }
	        ],
	        sprites: [{
	            type: 'text',
	            text: '2016-2017 매출',
	            fontSize: 18,
	            width: 100,
	            height: 40,
	            x: 40, // the sprite x position
	            y: 20  // the sprite y position
	        }],
	        onSeriesTooltipRender: function (tooltip, record, item) {
		        tooltip.setHtml(record.get('os') + ': ' + record.get('data1') + '%');
		    },
		
		    onStyleToggle: function (segmentedButton, button, pressed) {
		        var value = segmentedButton.getValue();
		
		        this.setPieStyle({
		            opacity: value === 0 ? 1 : 0.8
		        });
		    },
		
		    onThemeSwitch: function () {
		        var chart = this.lookupReference('chart'),
		            currentThemeClass = Ext.getClassName(chart.getTheme()),
		            themes = Ext.chart.theme,
		            themeNames = [],
		            currentIndex = 0,
		            name;
		
		        for (name in themes) {
		            if (Ext.getClassName(themes[name]) === currentThemeClass) {
		                currentIndex = themeNames.length;
		            }
		            if (name !== 'Base' && name.indexOf('Gradients') < 0) {
		                themeNames.push(name);
		            }
		        }
		        chart.setTheme(themes[themeNames[++currentIndex % themeNames.length]]);
		        chart.redraw();
		    },
		
		    onDownload: function() {
		        if (Ext.isIE8) {
		            Ext.Msg.alert('Unsupported Operation', 'This operation requires a newer version of Internet Explorer.');
		            return;
		        }
		        var chart = this.lookupReference('chart');
		
		        if (Ext.os.is.Desktop) {
		            chart.download({
		                filename: 'Mobile OS Marketshare'
		            });
		        } else {
		            chart.preview();
		        }
		    },
		
		    onThicknessChange: function (slider, value) {
		        var chart = this.lookupReference('chart'),
		            series = chart.getSeries()[0];
		
		        series.setThickness(value);
		        chart.redraw();
		    },
		
		    onDistortionChange: function (slider, value) {
		        var chart = this.lookupReference('chart'),
		            series = chart.getSeries()[0];
		
		        series.setDistortion(value / 100);
		        chart.redraw();
		    },
		
		    onBevelChange: function (slider, value) {
		        this.setPieStyle({
		            bevelWidth: value
		        });
		    },
		
		    onDonutChange: function (slider, value) {
		        var chart = this.lookupReference('chart'),
		            series = chart.getSeries()[0];
		
		        series.setDonut(value);
		        chart.redraw();
		    },
		
		    onColorSpreadChange: function (slider, value) {
		        this.setPieStyle({
		            colorSpread: value
		        });
		    },
		
		    setPieStyle: function (style) {
		        var chart = this.lookupReference('chart'),
		            series = chart.getSeries()[0];
		
		        series.setStyle(style);
		        chart.redraw();
		    },
		
		    onSliderDragStart: function () {
		        var chart = this.lookupReference('chart');
		        chart.suspendAnimation();
		    },
		
		    onSliderDragEnd: function () {
		        var chart = this.lookupReference('chart');
		        chart.resumeAnimation();
		    }

	    };
        
        
          
    	var itemCol1 = {
    			defaults:{
    				padding: '0 0 0 0',
            	},
	        items: [{
	            title: '월매출현황',
	            layout: 'fit',
	            flex:0.5,
	            items: [chart1]
	        },{
		           title: '상품별 매출',
		           layout: 'fit',
		           flex:0.5,
		           items: [chart3]
		        }]
	    };
	    
	    var itemCol2 = {
	    		defaults:{
	    			padding: '0 0 0 0',
            	},
	        items: [{
	           title: '지역별 매출 추이',
	           layout: {type:'vbox', align:'stretch'},//'fit',
	           flex:0.5,
	           items: [chart2,
	           {
	           		height:327,
	           		scrollable:true,
	           		width:'400',
			        style: 'margin-top: 10px;',
			        xtype: 'gridpanel',
			        columns : {
			            defaults: {
			                sortable: false,
			                menuDisabled: true
			            },
			            items: [
			                { text: '연도', dataIndex: 'year' , align:'center', flex:.1},
			                { text: '서울', dataIndex: '서울' , align:'center', flex:.3, xtype: 'numbercolumn', format:'0,000', renderer:function(value){return "<div style='text-align:right;'>"+(value !== '0' ? (value / 1000 + ',000') : value)+"</div>"}},
			            	{ text: '경기', dataIndex: '경기' , align:'center', flex:.3, xtype: 'numbercolumn', format:'0,000', renderer:function(value){return "<div style='text-align:right;'>"+(value !== '0' ? (value / 1000 + ',000') : value)+"</div>"}},
			                { text: '인천', dataIndex: '인천' , align:'center', flex:.3, xtype: 'numbercolumn', format:'0,000', renderer:function(value){return "<div style='text-align:right;'>"+(value !== '0' ? (value / 1000 + ',000') : value)+"</div>"}},
			            ]
			        },
			        store: store2,
			        width: '100%'
			        //</example>
			    }
	           ]
	        }]
	    };
	    
	    return [itemCol1,
    			itemCol2]
    },
    
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems()
    		
    	});
    		    
    	this.callParent();
    }
 
});