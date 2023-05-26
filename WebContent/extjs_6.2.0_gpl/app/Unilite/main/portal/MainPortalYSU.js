/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 * 연세대 신촌 캠퍼스
 */
Ext.define('Unilite.main.portal.MainPortalYSU', {
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
    	
    	Unilite.defineModel('chartModel', {
    	    fields: [ {name: 'TREE_NAME', type: 'string'}, 
    				  {name: 'SALE_AMT_O', type: 'int'}]
    	});
        var store1 = new Ext.data.Store({
        	storeId: 'a',
      		model:'chartModel',
//      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'portaltestskrvService.selectList1'                	
                }
            },
            listeners: {
               	load: function(store, records, successful, eOpts) {
//               		chart1.axes[0].maximum = store.max('SALE_AMT_O');
                		if(successful)	{
            				var loadingChart1 = Ext.getCmp('chart1');
                			loadingChart1.getEl().unmask('팀별  월매출현황</br>로딩중...','loading-indicator');
                		}
               	}
    		},
    		loadStoreRecords: function()	{
				var loadingChart1 = Ext.getCmp('chart1');
    			loadingChart1.getEl().mask('팀별  월매출현황</br>로딩중...','loading-indicator');
    			this.load();
    			
    		}
    		
    		
    	});
    	var chart1 = {
    		id:'chart1',
            xtype: 'chart',
            region: "center",
            height: 290,
            flex:1,
            style: {
                'background' : '#fff'
            },
            animate: true,
            shadow: false,
            store: store1,
            insetPadding: 40,            
            axes: [{
                type: 'Numeric',
                fields: 'SALE_AMT_O',
                position: 'left',
                grid: true,
//                adjustMaximumByMajorUnit : true,
//                majorTickSteps : 15,
                minimum: 0,
                label: {
	                renderer: Ext.util.Format.numberRenderer('0,000')
	            },
                
            }, {
                type: 'Category',
                fields: 'TREE_NAME',
                position: 'bottom',
                grid: true
            }],
            series: [{
                type: 'line',
                axis: 'left',
                xField: 'TREE_NAME',
                yField: 'SALE_AMT_O',
                fill: true,
                style: {
                    'stroke-width': 4,
                    fill: 'red'
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
                        this.setTitle(storeItem.get('TREE_NAME') + ': ' + storeItem.get('SALE_AMT_O'));
                    }
                }
            }]
        };
        
    	
    	Ext.define('chartModel2', {
    	    extend: 'Ext.data.Model',
    	    fields: [ {name: 'LEVEL_NAME', type: 'string'}, 
    				  {name: 'SALE_AMT_O', type: 'int'}]
    	});
        var store2 = new Ext.data.Store({
      		model:'chartModel2',
      		storeId: 'b',
//      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'portaltestskrvService.selectList2'                	
                }
            },
            listeners: {
               	load: function(store, records, successful, eOpts) {
                		if(successful)	{
            				var loadingChart2 = Ext.getCmp('chart2');
                			loadingChart2.getEl().unmask('대분류별  월매출현황</br>로딩중...','loading-indicator');
                		}
               	}
    		},
            
            
            loadStoreRecords: function()	{
            	var loadingChart2 = Ext.getCmp('chart2');
    			loadingChart2.getEl().mask('대분류별  월매출현황</br>로딩중...','loading-indicator');
    			this.load();
    		}
    	});
		var chart2 = {
			id:'chart2',
            xtype: 'chart',
            width: '100%',
            height: 290,
            flex:1,
            padding: '0 0 0 0',
            style: 'background: #fff',
            animate: true,
            shadow: false,
            store: store2,
            insetPadding: 40, 
           
            axes: [{
                type: 'Numeric',
                position: 'bottom',
                fields: ['SALE_AMT_O'],
                grid: true,
                label: {
//	                renderer: Ext.util.Format.numberRenderer('0,000')
	            },
            }, {
                type: 'Category',
                position: 'left',
                fields: ['LEVEL_NAME'],
                grid: true
                
            }],
            series: [{
                type: 'bar',
                axis: 'bottom',
                xField: 'LEVEL_NAME',
                yField: 'SALE_AMT_O',
                renderer: function(sprite, record, attr, index, store) {
                    return Ext.apply(attr, {
                        fill: 'yellow'
                    });
                },
                style: {
                    opacity: 0.60
                },
//                colorSet: ['#0000FF'],
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
                        this.setTitle(storeItem.get('LEVEL_NAME') + ': ' + storeItem.get('SALE_AMT_O'));
                    }
                }
            }]
        };
    	
        Ext.define('PortaltestskrvModel', {
    	    extend: 'Ext.data.Model',
    	    fields: [ 
    	            {name: 'DEPT_CODE'		, text: '부서코드'		, type: 'string'},
    	            {name: 'DEPT_NAME'		, text: '부서'		, type: 'string'},
    	  	    	{name: 'D_SALE_AMT_O'	, text: '일매출'		, type: 'int'},
    		    	{name: 'M_SALE_AMT_O'	, text: '월매출'		, type: 'int'}
    		    	
    		    	]
    	});
        var store3 = new Ext.data.Store({
      		model:'PortaltestskrvModel',
      		storeId: 'c',
//      	autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'portaltestskrvService.selectList3'                	
                }
            },
            
            
            loadStoreRecords: function()	{
    			this.load();
    		}
    	});
        
        
    	var Grid = Unilite.createGrid('mad120skrvGrid1', {
            height: 290,
    		flex:1,
    		
            uniOpt: {
        		useGroupSummary: false,
        		useLiveSearch: false,
    			useContextMenu: false,
    			useMultipleSorting: false,
    			useRowNumberer: false,
    			expandLastColumn: false,
        		filter: {
    				useFilter: false,
    				autoCreate: false
    			}
            },
            features: [{
            	id: 'masterGridSubTotal', 
            	ftype: 'uniGroupingsummary', 
            	showSummaryRow: true
    		},{
    			id: 'masterGridTotal', 
    			ftype: 'uniSummary', 
    			showSummaryRow: true
    		}],
        	store: store3,
            columns: [
            	{dataIndex: 'DEPT_CODE'			, width: 60,hidden:true},
    		    {dataIndex: 'DEPT_NAME'			, width: 200,
		    	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }},
            	{dataIndex: 'D_SALE_AMT_O'		, width: 200,summaryType: 'sum'},
            	{dataIndex: 'M_SALE_AMT_O'		, width: 200,summaryType: 'sum'}]
        });
    	Unilite.defineModel('chartModel3', {
    	    fields: [ {name: 'ITEM_NAME', type: 'string'},
    	              {name: 'ITEM_NAME2', type: 'string'},
    				  {name: 'SALE_Q', type: 'int'}]
    	});
        var store4 = new Ext.data.Store({
      		model:'chartModel3',
      		storeId: 'd',
//      		autoLoad: true,
      		proxy: {
                type: 'direct',
                api: {
                	read: 'portaltestskrvService.selectList4'                	
                }
            },
            listeners: {
               	load: function(store, records, successful, eOpts) {
//               		chart1.axes[0].maximum = store.max('SALE_AMT_O');
                		if(successful)	{
            				var loadingChart3 = Ext.getCmp('chart3');
                			loadingChart3.getEl().unmask('TOP 10 매출상품</br>로딩중...','loading-indicator');
                		}
               	}
    		},
            loadStoreRecords: function()	{
            	var param = Ext.getCmp('resultForm').getValues();
            	
            	var loadingChart3 = Ext.getCmp('chart3');
    			loadingChart3.getEl().mask('TOP 10 매출상품</br>로딩중...','loading-indicator');
    			this.load({
    				params: param
    			});
    		}
    	});
        
        var panel = Unilite.createSearchForm('resultForm',{

            autoScroll:true,
            layout:{type:'uniTable',columns:1},
            height:40,  
            width:200,
            border:false,
            padding: '5 200 0 250',
            
            items:[{
	    		 fieldLabel: '대분류',
	    		 name: 'ITEM_LEVEL1',
	    		 xtype:'uniCombobox',
	    		 store: Ext.data.StoreManager.lookup('itemLeve1Store'),
	    		 listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						
						store4.clearData();
//						chart3.series.clear();
//						chart3.axes.clear();
						Ext.getCmp('chart3').redraw([true]);
//						chart3.surface.removeAll();
//						chart3.series.remove();
//						chart3.redraw(true);
//						chart3.clearForm();
						store4.loadStoreRecords();
					}
				}
	    		 
            }]
	     });
        
		var chart3 = {
			id:'chart3',
            xtype: 'chart',
            width: '100%',
            height: 290,
            flex:1,
            style: 'background: #fff',
            animate: true,
            shadow: false,
            store: store4,
            insetPadding: 45,
            axes: [{
                type: 'Numeric',
                position: 'left',
                fields: ['SALE_Q'],
                grid: true,
                label: {
	                renderer: Ext.util.Format.numberRenderer('0,000')
	            },
            }, {
                type: 'Category',
                position: 'bottom',
                fields: ['ITEM_NAME2'],
                grid: true,
                
            }],
            series: [{
            	type: 'column',
                axis: 'left',
                xField: 'ITEM_NAME',
                yField: 'SALE_Q',
                renderer: function(sprite, record, attr, index, store) {
                    return Ext.apply(attr, {
                        fill: 'blue'
                    });
                },
                style: {
                    opacity: 0.60
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
                        this.setTitle(storeItem.get('ITEM_NAME') + ': ' + storeItem.get('SALE_Q'));
                    }
                }
            }]
        };
        
        
          
    	var itemCol1 = {
    			defaults:{
    				padding: '0 0 0 0',
            	},
	        items: [{
	            title: '팀별  월매출현황',
	            layout: 'fit',
	            flex:0.5,
	            items: [chart1]
	        },{
		           title: '부서별 일매출/월누계',
		           layout: 'fit',
		           flex:0.5,
		           items: [Grid]
		        }]
	    };
	    
	    var itemCol2 = {
	    		defaults:{
	    			padding: '0 0 0 0',
            	},
	        items: [{
	           title: '대분류별 월매출현황',
	           layout: 'fit',
	           flex:0.5,
	           items: [chart2]
	        },{
		           title: 'TOP 10 매출상품',
		           layout: 'fit',
		           flex:0.5,
		           items: [panel,chart3]
		        }]
	    };
	    
	    return [itemCol1,
    			itemCol2]
    },
    
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems()
    		,listeners:{
    			'show':function(portalPanel, eOpts)	{
	    			var store1 = Ext.data.StoreManager.lookup("a");
	    			var store2 = Ext.data.StoreManager.lookup("b");
	    			var store3 = Ext.data.StoreManager.lookup("c");
	    			var store4 = Ext.data.StoreManager.lookup("d");
	    			store1.loadStoreRecords();
	    			store2.loadStoreRecords();
	    			store3.loadStoreRecords();
	    			store4.loadStoreRecords();

    			}
    		}
    	});
    		    
    	this.callParent();
    }
 
});