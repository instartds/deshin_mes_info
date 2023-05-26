
// @charset UTF-8

/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */

Ext.define('Unilite.main.portal.MainPortalPanel', {
	extend: 'Unilite.com.panel.portal.UniPortalPanel',
	title: 'Portal',
	itemId: 'portal',
	id:'portalPage',
	uniOpt: {
		'prgID': 'portal',
		'title': 'Portal'
	},
	closable: false,
	getPortalItems: function() {

		Unilite.defineModel('pieChartModel', {
			fields: [
				{name: 'DIV_NAME'			, text:'사업장'				,type:'string'},
				{name: 'ORDER_O'			, text:'수주금액'				,type:'uniPrice'}
			]
		});

		var pieChartStore = Unilite.createStore('pieChartStore',{
			model: 'pieChartModel',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList1'
				}
			},
			loadStoreRecords: function() {
				var param = panelResult.getValues();
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult.setValue('TOTAL_AMT',Ext.util.Format.number(pieChartStore.sum('ORDER_O').toFixed(7),'000,000'));
				}
			}
		});

		var pieChartPanel = Unilite.createSearchForm('pieChartPanel', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'polar',
				store: pieChartStore,
				animate: true,
				shadow: true,
				width: '100%',
				innerPadding: 30,
				theme: 'green-gradients',
				legend: {
					position: 'right'
				},
				series: [{
					type: 'pie',
					angleField: 'ORDER_O',
					showInLegend: true,
					donut: 15,
					highlight: {
						segment: {
							margin: 20
						}
					},
					label: {
						field: 'DIV_NAME',
//						display: 'rotate',
//						contrast: true,
						font: '15px Arial'
					},
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
							}
						}
					}
				}]
			}]
		});
		Unilite.defineModel('pieChartModel2', {
			fields: [
				{name: 'DIV_NAME'			, text:'사업장'				,type:'string'},
				{name: 'ORDER_O'			, text:'예상매출금액'				,type:'uniPrice'}
			]
		});

		var pieChartStore2 = Unilite.createStore('pieChartStore2',{
			model: 'pieChartModel2',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList2'
				}
			},
			loadStoreRecords: function()	{
				var param = panelResult2.getValues();
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult2.setValue('TOTAL_AMT',Ext.util.Format.number(pieChartStore2.sum('ORDER_O').toFixed(7),'000,000'));
				}
			}
		});

		var pieChartPanel2 = Unilite.createSearchForm('pieChartPanel2', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'polar',
				store: pieChartStore2,
				animate: true,
				shadow: true,
				width: '100%',
				innerPadding: 30,
				theme: 'purple-gradients',
				legend: {
					position: 'right'
				},
				series: [{
					type: 'pie',
					angleField: 'ORDER_O',
					showInLegend: true,
					donut: 15,
					highlight: {
						segment: {
							margin: 20
						}
					},
					label: {
						field: 'DIV_NAME',
//						display: 'rotate',
//						contrast: true,
						font: '15px Arial'
					},
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
							}
						}
					}
				}]
			}]
		});
	    Unilite.defineModel('pieChartModel3', {
			fields: [
				{name: 'DIV_NAME'			, text:'사업장'				,type:'string'},
				{name: 'SALE_AMT_O'			, text:'매출금액'				,type:'uniPrice'}
			]
		});

		var pieChartStore3 = Unilite.createStore('pieChartStore3',{
			model: 'pieChartModel3',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList3'
				}
			},
			loadStoreRecords: function() {
				var param = panelResult3.getValues();
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult3.setValue('TOTAL_AMT',Ext.util.Format.number(pieChartStore3.sum('SALE_AMT_O').toFixed(7),'000,000'));
				}
			}
		});

		var pieChartPanel3 = Unilite.createSearchForm('pieChartPanel3', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'polar',
				store: pieChartStore3,
				animate: true,
				shadow: true,
				width: '100%',
				innerPadding: 30,
				theme: 'sky-gradients',
				legend: {
					position: 'right'
				},
				series: [{
					type: 'pie',
					angleField: 'SALE_AMT_O',
					showInLegend: true,
					donut: 15,
					highlight: {
						segment: {
							margin: 20
						}
					},
					label: {
						field: 'DIV_NAME',
//						display: 'rotate',
//						contrast: true,
						font: '15px Arial'
					},
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('SALE_AMT_O'),'000,000'));
							}
						}
					}
				}]
			}]
		});
		var panelResult = Unilite.createSearchForm('panelResult',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '사업장별 수주금액',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '수주년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						pieChartStore.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 수주금액',
				name:'TOTAL_AMT',
				readOnly:true
			}]
		});
		var panelResult2 = Unilite.createSearchForm('panelResult2',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '사업장별 예상매출금액',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '예상매출년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						pieChartStore2.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 예상매출금액',
				name:'TOTAL_AMT',
				readOnly:true
			}]
		});
		var panelResult3 = Unilite.createSearchForm('panelResult3',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '사업장별 매출금액',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '매출년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						pieChartStore3.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 매출금액',
				name:'TOTAL_AMT',
				readOnly:true
			}]
		});

		Unilite.defineModel('chartModel4', {
			fields: [
				{name: 'DIV_NAME'			, text: '사업장'				,type: 'string'},
				{name: 'GOOD_PRODT_Q'		, text: '생산량'				,type: 'uniQty'}
			]
		});

		var chartStore4 = Unilite.createStore('chartStore4',{
			model: 'chartModel4',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList4'
				}
			},
			loadStoreRecords: function()	{
				var param = panelResult4.getValues();
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult4.setValue('TOTAL_QTY',Ext.util.Format.number(chartStore4.sum('GOOD_PRODT_Q').toFixed(7),'000,000'));
				}
			}
		});

		var chartPanel4 = Unilite.createSearchForm('chartPanel4', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'polar',
				store: chartStore4,
				animate: true,
				shadow: true,
				width: '100%',
				innerPadding: 30,
				theme: 'green-gradients',
				legend: {
					position: 'right'
				},
				series: [{
					type: 'pie',
					angleField: 'GOOD_PRODT_Q',
					showInLegend: true,
					donut: 15,
					highlight: {
						segment: {
							margin: 20
						}
					},
					label: {
						field: 'DIV_NAME',
//						display: 'rotate',
//						contrast: true,
						font: '15px Arial'
					},
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
							}
						}
					}
				}]
			}]
		});

		var panelResult4 = Unilite.createSearchForm('panelResult4',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '사업장별 생산현황',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '생산년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						chartStore4.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 생산량',
				name:'TOTAL_QTY',
				readOnly:true
			}]
		});

		Unilite.defineModel('chartModel5', {
			fields: [
				{name: 'ITEM_LEVEL1_NAME'			, text:'대분류'				,type:'string'},
				{name: 'GOOD_PRODT_Q'			, text:'생산량'				,type:'uniQty'},
				{name: 'GOOD_PRODT_Q_FORMAT'			, text:'생산량(포맷)'				,type:'string'}
			]
		});

		var chartStore5 = Unilite.createStore('chartStore5',{
			model: 'chartModel5',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList5'
				}
			},
			loadStoreRecords: function()	{
				var param = panelResult5.getValues();
				param.DIV_CODE = '01';
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult5.setValue('TOTAL_QTY',Ext.util.Format.number(chartStore5.sum('GOOD_PRODT_Q').toFixed(7),'000,000'));
				}
			}
		});

		var chartPanel5 = Unilite.createSearchForm('chartPanel5', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'cartesian',
				reference: 'chart',
				store: chartStore5,
//				animate: true,
//				shadow: true,
				width: '100%',
				innerPadding: 30,
				flipXY: true,
				interactions: ['itemhighlight'],
				theme: {
					type: 'purple'
				},
				axes: [{
					type: 'numeric3d',
					position: 'bottom',
					fields: 'GOOD_PRODT_Q',
					grid: true
//					title: {
//						text: 'Sample Values',
//						fontSize: 15
//					}
				},{
					type: 'category3d',
					position: 'left',
					fields: 'ITEM_LEVEL1_NAME',
					grid: true
//					title: {
//						text: 'Sample Values',
//						fontSize: 15
//					}
				}],
			/*	theme: 'green-gradients',
				legend: {
					position: 'right'
				},*/
				series: [{
					type: 'bar3d',
					highlight: true,
//					subStyle: {
//						fill: ['#FAF4C0']
////						stroke: 'black'
//					},
					xField: 'ITEM_LEVEL1_NAME',
					yField: 'GOOD_PRODT_Q',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('ITEM_LEVEL1_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
							}
						}
					},
					label: {
						field: 'GOOD_PRODT_Q_FORMAT',
						display: 'insideEnd'
					}
				}]
			}]
		});

		var panelResult5 = Unilite.createSearchForm('panelResult5',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '분류별 생산현황',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '생산년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						chartStore5.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 생산량',
				name:'TOTAL_QTY',
				readOnly:true
			}]
		});

		Unilite.defineModel('chartModel6', {
			fields: [
				{name: 'DIV_NAME'				, text:'사업장'				,type:'string'},
				{name: 'GOOD_PRODT_Q'			, text:'생산량'				,type:'uniQty'},
				{name: 'GOOD_PRODT_Q_FORMAT'	, text:'생산량(포맷)'			,type:'string'}
			]
		});

		var chartStore6 = Unilite.createStore('chartStore6',{
			model: 'chartModel6',
			uniOpt: {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					read: 'portalskrService.SelectList5'
				}
			},
			loadStoreRecords: function()	{
				var param = panelResult6.getValues();
				param.DIV_CODE = '02';
				this.load({
					params: param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					panelResult6.setValue('TOTAL_QTY',Ext.util.Format.number(chartStore6.sum('GOOD_PRODT_Q').toFixed(7),'000,000'));
				}
			}
		});

		var chartPanel6 = Unilite.createSearchForm('chartPanel6', {
//			renderTo: Ext.getBody(),
			region: 'center',
			border: false,
			height: 350,
			layout: 'fit',
			items: [{
				xtype: 'cartesian',
				reference: 'chart',
				store: chartStore6,
//				animate: true,
//				shadow: true,
				width: '100%',
				innerPadding: 30,
				flipXY: true,
				interactions: ['itemhighlight'],
				theme: {
					type: 'sky'
				},
				axes: [{
					type: 'numeric3d',
					position: 'bottom',
					fields: 'GOOD_PRODT_Q',
					grid: true
//					title: {
//						text: 'Sample Values',
//						fontSize: 15
//					}
				},{
					type: 'category3d',
					position: 'left',
					fields: 'ITEM_LEVEL1_NAME',
					grid: true
//					title: {
//						text: 'Sample Values',
//						fontSize: 15
//					}
				}],
			/*	theme: 'green-gradients',
				legend: {
					position: 'right'
				},*/
				series: [{
					type: 'bar3d',
					highlight: true,
//					subStyle: {
//						fill: ['#73d1f7'],
//						stroke: 'black'
//					},
					xField: 'ITEM_LEVEL1_NAME',
					yField: 'GOOD_PRODT_Q',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							if(!Ext.isEmpty(record)){
								toolTip.setHtml(record.get('ITEM_LEVEL1_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
							}
						}
					},
					label: {
						field: 'GOOD_PRODT_Q_FORMAT',
						display: 'insideEnd'
					}
				}]
			}]
		});

		var panelResult6 = Unilite.createSearchForm('panelResult6',{
			region: 'north',
			layout: {type : 'uniTable', columns : 2},
			border: true,
			title: '분류별 생산현황',
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '생산년월',
				name: 'BASIS_YM',
				allowBlank: false,
				width:200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						chartStore6.loadStoreRecords();
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '총 생산량',
				name:'TOTAL_QTY',
				readOnly:true
			}]
		});

		var panelResult7 = Unilite.createSearchForm('panelResult7',{
			region: 'north',
			layout: {type : 'uniTable', columns : 1},
			border: false,
			colspan:3,
			padding: '0 0 0 0',
			tdAttrs: {align: 'left'},
			items: [{
				xtype: 'uniMonthfield',
				fieldLabel: '기준년월  일괄적용',
				name: 'BASIS_YM',
				allowBlank: true,
				labelWidth: 150,
				padding: '0 0 0 0',
				margin: '0 0 0 -30',
				width: 300,
				listeners: {
					change: function(field, newValue, oldValue, eOpts){
						var field = panelResult.getField('BASIS_YM');
						var field2 = panelResult2.getField('BASIS_YM');
						var field3 = panelResult3.getField('BASIS_YM');
						var field4 = panelResult4.getField('BASIS_YM');
						var field5 = panelResult5.getField('BASIS_YM');
						var field6 = panelResult6.getField('BASIS_YM');

						panelResult.setValue('BASIS_YM' ,newValue, false);
						panelResult2.setValue('BASIS_YM' ,newValue, false);
						panelResult3.setValue('BASIS_YM' ,newValue, false);
						panelResult4.setValue('BASIS_YM' ,newValue, false);
						panelResult5.setValue('BASIS_YM' ,newValue, false);
						panelResult6.setValue('BASIS_YM' ,newValue, false);

						/*field.fireEvent('change', field, newValue, oldValue, eOpts);
						field2.fireEvent('change', field2, newValue, oldValue, eOpts);
						field3.fireEvent('change', field3, newValue, oldValue, eOpts);
						field4.fireEvent('change', field4, newValue, oldValue, eOpts);
						field5.fireEvent('change', field5, newValue, oldValue, eOpts);
						field6.fireEvent('change', field6, newValue, oldValue, eOpts);*/

					}
				}
			}]
		});
		
		var itemCol1 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult,pieChartPanel],
			layout: 'fit',
			flex:1
		};

		var itemCol2 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult2,pieChartPanel2],
			layout: 'fit',
			flex:1
		};

		var itemCol3 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult3,pieChartPanel3],
			layout: 'fit',
			flex:1
		};

		var itemCol4 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult4,chartPanel4],
			layout: 'fit',
			flex:1
		};

		var itemCol5 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult5,chartPanel5],
			layout: 'fit',
			flex:1
		};

		var itemCol6 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '0 10 10 10',
			items: [panelResult6,chartPanel6],
			layout: 'fit',
			flex:1
		};
		var itemCol7 = {
				xtype:'container',
				layout: {type : 'uniTable', columns : 1},
				padding: '10 10 10 10',
				items: [panelResult7],
				layout: 'fit',
				coslpan: 3,
				flex:1
			};
		return [{
			xtype:'container',
			layout: {type : 'uniTable', columns : 3,tableAttrs: {width: '100%'}},
			items: [
				panelResult7,itemCol1,itemCol2,itemCol3
				,itemCol4,itemCol5,itemCol6
			]
		}]
	},

	initComponent: function() {
		var me = this;
		Ext.apply(this, {
			items: this.getPortalItems(),
			autoScroll:false,
			listeners:{
				'show':function(portalPanel, eOpts)	{
					var panelResult = Ext.getCmp("panelResult");
					var panelResult2 = Ext.getCmp("panelResult2");
					var panelResult3 = Ext.getCmp("panelResult3");

					var panelResult4 = Ext.getCmp("panelResult4");
					var panelResult5 = Ext.getCmp("panelResult5");
					var panelResult6 = Ext.getCmp("panelResult6");
					var panelResult7 = Ext.getCmp("panelResult7");

					panelResult.setValue('BASIS_YM',UniDate.get('today'));
					panelResult2.setValue('BASIS_YM',UniDate.get('today'));
					panelResult3.setValue('BASIS_YM',UniDate.get('today'));

					panelResult4.setValue('BASIS_YM',UniDate.get('today'));
					panelResult5.setValue('BASIS_YM',UniDate.get('today'));
					panelResult6.setValue('BASIS_YM',UniDate.get('today'));
					panelResult7.setValue('BASIS_YM',UniDate.get('today'));
					var pieChartStore = Ext.data.StoreManager.lookup("pieChartStore");
					pieChartStore.loadStoreRecords();
					var pieChartStore2 = Ext.data.StoreManager.lookup("pieChartStore2");
					pieChartStore2.loadStoreRecords();
					var pieChartStore3 = Ext.data.StoreManager.lookup("pieChartStore3");
					pieChartStore3.loadStoreRecords();

					var chartStore4 = Ext.data.StoreManager.lookup("chartStore4");
					chartStore4.loadStoreRecords();
					var chartStore5 = Ext.data.StoreManager.lookup("chartStore5");
					chartStore5.loadStoreRecords();
					var chartStore6 = Ext.data.StoreManager.lookup("chartStore6");
					chartStore6.loadStoreRecords();
					
					var param = {
						COMP_CODE	: UserInfo.compCode
					}
					
					portalskrService.getDivcode(param, function(provider, response){
						if(!Ext.isEmpty(provider)) {
							if(provider.length == 1) {
								panelResult6.setHidden(true);
								Ext.getCmp('chartPanel6').setHidden(true);
							}
							Ext.each(provider, function(record, i) {
								if(i == 0) {
									panelResult5.setTitle("분류별 생산현황(" + provider[i].DIV_NAME + ")");
								} else if(i == 1) {
									panelResult6.setTitle("분류별 생산현황(" + provider[i].DIV_NAME + ")");
								}
							});
						}
					})
				},
				'hide':function(portalPanel, eOpts)	{
					
				},
				'close':function(portalPanel, eOpts)	{
					
				}
			}
		});
		this.callParent();
	}
});