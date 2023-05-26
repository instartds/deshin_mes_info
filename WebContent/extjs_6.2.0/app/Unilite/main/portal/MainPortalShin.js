// @charset UTF-8

/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
Ext.define('Unilite.main.portal.MainPortalShin', {
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
	                read: 'portalskrService.kodiSelectList1'
	            }
	        },
			loadStoreRecords: function()	{
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
							toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
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
	                read: 'portalskrService.kodiSelectList2'
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
							toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
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
	                read: 'portalskrService.kodiSelectList3'
	            }
	        },
			loadStoreRecords: function()	{
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
							toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('SALE_AMT_O'),'000,000'));
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
				{name: 'DIV_NAME'			, text:'사업장'				,type:'string'},
				{name: 'GOOD_PRODT_Q'			, text:'생산량'				,type:'uniQty'}
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
	                read: 'portalskrService.kodiSelectList4'
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
							toolTip.setHtml(record.get('DIV_NAME'));// + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
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
	    
	    
		var itemCol1 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '10 10 10 10',
			items: [panelResult,pieChartPanel],
			layout: 'fit',
	        flex:1
	    };
	    
	    var itemCol2 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '10 10 10 10',
			items: [panelResult2,pieChartPanel2],
			layout: 'fit',
	        flex:1
	    };
	    
	    var itemCol3 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '10 10 10 10',
			items: [panelResult3,pieChartPanel3],
			layout: 'fit',
	        flex:1
	    };
	    
	    
	    var itemCol4 = {
			xtype:'container',
			layout: {type : 'uniTable', columns : 2},
			padding: '10 10 10 10',
			items: [panelResult4,chartPanel4],
			layout: 'fit',
	        flex:1
	    };
	    
	    return [{
			xtype:'container',
			layout: {type : 'uniTable', columns : 3},
			items: [
				itemCol1,itemCol2,itemCol3
	    		,itemCol4
	    	]
	    }]
    },
    
    initComponent: function() {
    	var me = this;
    	Ext.apply(this, {
    		items: this.getPortalItems(),
    		listeners:{
    			'show':function(portalPanel, eOpts)	{
	    			var panelResult = Ext.getCmp("panelResult");
	    			var panelResult2 = Ext.getCmp("panelResult2");
	    			var panelResult3 = Ext.getCmp("panelResult3");
    				
	    			var panelResult4 = Ext.getCmp("panelResult4");
	    			
    				panelResult.setValue('BASIS_YM',UniDate.get('today'));
    				panelResult2.setValue('BASIS_YM',UniDate.get('today'));
    				panelResult3.setValue('BASIS_YM',UniDate.get('today'));
    				
    				panelResult4.setValue('BASIS_YM',UniDate.get('today'));
    				
	    			var pieChartStore = Ext.data.StoreManager.lookup("pieChartStore");
	    			pieChartStore.loadStoreRecords();
	    			var pieChartStore2 = Ext.data.StoreManager.lookup("pieChartStore2");
	    			pieChartStore2.loadStoreRecords();
	    			var pieChartStore3 = Ext.data.StoreManager.lookup("pieChartStore3");
	    			pieChartStore3.loadStoreRecords();
	    			
	    			var chartStore4 = Ext.data.StoreManager.lookup("chartStore4");
	    			chartStore4.loadStoreRecords();
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