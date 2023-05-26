<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb999skr"  >
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


function appMain() {    
    /**
     *   Model 정의 
     * @type 
     */             
    Unilite.defineModel('Afb999skrModel', {
        fields: [    
            {name: 'FLAG'              , text: 'FLAG'          , type: 'string'},
            {name: 'ITEMS'             , text: '항목'            , type: 'string'},
            {name: 'SUM_ITEMS_Q'       , text: '총 매출현황'       , type: 'int'}
            
        ]
    });  
    
    /**
     * MasterStore1 정의
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('afb999skrMasterStore',{
            model: 'Afb999skrModel',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable: false,           // 삭제 가능 여부 
                useNavi: false          // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                    read: 'afb999skrService.selectListGrid'                    
                }
            },
            loadStoreRecords : function()   {
                var param= Ext.getCmp('searchForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
            }
    });  
    

    /**
     * 검색조건 (Search Panel)
     * @type 
     */
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{   
            title: '기본정보',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                xtype:'uniTextfield',
                fieldLabel:'테스트 조건',
                name:'TEST1'
            
            }]      
        }]
    });   

    var panelResult = Unilite.createSearchForm('panelResultForm', {
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            items :[{
                xtype:'uniTextfield',
                fieldLabel:'테스트 조건',
                name:'TEST1'
            
            },{
                xtype:'uniCombobox',
                text:'테스스',
                name:'',
                width:100
            }]
        }]
    });
    
    var masterGrid = Unilite.createGrid('afb999skrGrid', {
        store: directMasterStore,
        layout:'fit',
        region: 'west',
        uniOpt: {
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            useRowNumberer: true,
            expandLastColumn: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }

        },
        columns:  [
            {dataIndex: 'FLAG'           ,       width: 100,hidden:true},
            {dataIndex: 'ITEMS'          ,       width: 100},
            {dataIndex: 'SUM_ITEMS_Q'    ,       width: 100}
        ],
        listeners:{
            beforeedit  : function( editor, e, eOpts ) {
                return false;
            },
            selectionchangerecord:function(selected)    {
            }
        }
    });  
    
    Unilite.defineModel('chartModel', {
            fields: [ {name: 'FRUIT', type: 'string'}, 
                      {name: 'SALE_Q', type: 'int'}]
        });
        var store1 = new Ext.data.Store({
            storeId: 'a',
            model:'chartModel',
//              autoLoad: true,
            proxy: {
                type: 'direct',
                api: {
                    read: 'afb999skrService.selectListChartFruit'                   
                }
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
//                      chart1.axes[0].maximum = store.max('SALE_AMT_O');
                        if(successful)  {
                            var loadingChart1 = Ext.getCmp('chart1');
                            loadingChart1.getEl().unmask('과일별 매출현황</br>로딩중...','loading-indicator');
                        }
                }
            },
            loadStoreRecords: function()    {
                var loadingChart1 = Ext.getCmp('chart1');
                loadingChart1.getEl().mask('과일별 매출현황</br>로딩중...','loading-indicator');
                this.load();
                
            }
            
            
        });
        var chart1 = {
            id:'chart1',
            xtype: 'chart',
            region: 'west',
            height: 290,
//            hidden:true,
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
                fields: 'SALE_Q',
                position: 'left',
                grid: true,
//                adjustMaximumByMajorUnit : true,
//                majorTickSteps : 15,
                minimum: 0,
                
                label: {
                    renderer: Ext.util.Format.numberRenderer('0,000')
                }
                
            }, {
                type: 'Category',
                fields: 'FRUIT',
                position: 'bottom',
                grid: true
            }],
            series: [{
                type: 'line',
                axis: 'left',
                xField: 'FRUIT',
                yField: 'SALE_Q',
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
                        this.setTitle(storeItem.get('FRUIT') + ': ' + storeItem.get('SALE_Q'));
                    }
                }
            }]
        };
    
    
    Ext.define('chartModel2', {
            extend: 'Ext.data.Model',
            fields: [ {name: 'ALCOHOL', type: 'string'}, 
                      {name: 'SALE_Q', type: 'int'}]
        });
        var store2 = new Ext.data.Store({
            model:'chartModel2',
            storeId: 'b',
//              autoLoad: true,
            proxy: {
                type: 'direct',
                api: {
                    read: 'afb999skrService.selectListChartAlcohol'           
                }
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                        if(successful)  {
                            var loadingChart2 = Ext.getCmp('chart2');
                            loadingChart2.getEl().unmask('술별 매출현황</br>로딩중...','loading-indicator');
                        }
                }
            },
            
            
            loadStoreRecords: function()    {
                var loadingChart2 = Ext.getCmp('chart2');
                loadingChart2.getEl().mask('술별 매출현황</br>로딩중...','loading-indicator');
                this.load();
            }
        });
        var chart2 = {
            id:'chart2',
            xtype: 'chart',
//            hidden:true,
            region: 'center',
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
                fields: ['SALE_Q'],
                grid: true,
                label: {
//                  renderer: Ext.util.Format.numberRenderer('0,000')
                }
            }, {
                type: 'Category',
                position: 'left',
                fields: ['ALCOHOL'],
                grid: true
                
            }],
            series: [{
                type: 'bar',
                axis: 'bottom',
                xField: 'ALCOHOL',
                yField: 'SALE_Q',
                renderer: function(sprite, record, attr, index, store) {
                    return Ext.apply(attr, {
                        fill: 'black'
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
                        this.setTitle(storeItem.get('ALCOHOL') + ': ' + storeItem.get('SALE_Q'));
                    }
                }
            }]
        };
        
        
        Ext.define('chartModel3', {
            extend: 'Ext.data.Model',
            fields: [ {name: 'ITEMS', type: 'string'}, 
                      {name: 'SUM_ITEMS_Q', type: 'int'}]
        });
        var store3 = new Ext.data.Store({
            model:'chartModel3',
            storeId: 'c',
//              autoLoad: true,
            proxy: {
                type: 'direct',
                api: {
                    read: 'afb999skrService.selectListChart'           
                }
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                        if(successful)  {
                            var loadingChart3 = Ext.getCmp('chart3');
                            loadingChart3.getEl().unmask('전체 매출현황</br>로딩중...','loading-indicator');
                        }
                }
            },
            
            
            loadStoreRecords: function()    {
                var loadingChart3 = Ext.getCmp('chart3');
                loadingChart3.getEl().mask('전체 매출현황</br>로딩중...','loading-indicator');
                this.load();
            }
        });
        var chart3 = {
            id:'chart3',
            xtype: 'chart',
//            hidden:true,
            region: 'east',
            width: '100%',
            height: 290,
            flex:1,
            padding: '0 0 0 0',
            style: 'background: #fff',
            animate: true,
            shadow: false,
            store: store3,
            insetPadding: 40, 
            legend: {
                field: 'ITEMS',
                position: 'right',
                boxStrokeWidth: 0,
                labelFont: '8px Helvetica'
            }, 
            
            series: [{
                type: 'pie',
                angleField: 'SUM_ITEMS_Q',
                label: {
                    field: 'ITEMS',
                    display: 'rotate',
                    contrast: true,
                    font: '18px Arial'
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
                        this.setTitle(storeItem.get('ITEMS') + ': ' + storeItem.get('SUM_ITEMS_Q'));
                    }
                }
            }]
        };
        
        
        Ext.define('chartModel4', {
            extend: 'Ext.data.Model',
            fields: [ {name: 'ITEMS', type: 'string'}, 
                      {name: 'SUM_ITEMS_Q', type: 'int'}]
        });
        var store4 = new Ext.data.Store({
            model:'chartModel4',
            storeId: 'd',
//              autoLoad: true,
            proxy: {
                type: 'direct',
                api: {
                    read: 'afb999skrService.selectListChartMeat'           
                }
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                        if(successful)  {
                            var loadingChart4 = Ext.getCmp('chart4');
                            loadingChart4.getEl().unmask('고기별 매출현황</br>로딩중...','loading-indicator');
                        }
                }
            },
            
            
            loadStoreRecords: function()    {
                var loadingChart4 = Ext.getCmp('chart4');
                loadingChart4.getEl().mask('고기별 매출현황</br>로딩중...','loading-indicator');
                this.load();
            }
        });
        var chart4 = {
            id:'chart4',
            xtype: 'chart',
//            hidden:true,
            region: 'east',
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
                }
            }, {
                type: 'Category',
                position: 'bottom',
                fields: ['MEAT'],
                grid: true
                
            }],
            series: [{
                type: 'column',
                axis: 'left',
                xField: 'MEAT',
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
                        this.setTitle(storeItem.get('MEAT') + ': ' + storeItem.get('SALE_Q'));
                    }
                }
            }]
        };
        
        
    Unilite.Main({          
        borderItems:[{
            region: 'center',
            layout: 'border',
            border: false,
            items: [panelResult,
            	
            {
                region:'north',
                xtype:'container',
                layout:{type:'hbox', align:'stretch'},
//                border: true,
                items:[masterGrid,chart3
                ]
            },{
                region:'center',
                xtype:'container',
                layout:{type:'hbox', align:'stretch'},
//                border: true,
                items:[chart1,chart2,chart4
                ]
            }
                
            ]},
            panelSearch
            ],
        id: 'afb999skrApp',
        fnInitBinding: function() {
        },
        onQueryButtonDown : function()  {  
        	directMasterStore.loadStoreRecords();
        	
//        	Ext.getCmp('chart1').setHidden(false);
        	Ext.getCmp('chart1').surface.removeAll();
        	store1.loadStoreRecords();
//        	Ext.getCmp('chart2').setHidden(false);
        	Ext.getCmp('chart2').surface.removeAll();
        	store2.loadStoreRecords();
//        	Ext.getCmp('chart3').setHidden(false);
        	Ext.getCmp('chart3').surface.removeAll();
        	store3.loadStoreRecords();
//        	Ext.getCmp('chart4').setHidden(false);
        	Ext.getCmp('chart4').surface.removeAll();
        	store4.loadStoreRecords();
        }
        
    });   
};

</script>
