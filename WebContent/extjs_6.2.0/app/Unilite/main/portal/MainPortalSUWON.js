// @charset UTF-8
/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
Ext.define('Unilite.main.portal.MainPortalSUWON', {
    extend: 'Unilite.com.panel.portal.UniPortalPanel',
    title: 'Portal',
    itemId: 'portal',
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,
    
    //abstract 
    getPortalItems: function() {
    	var pt1 = this.getPortlet1();
    	var pt2 = this.getPortlet2();
    	var pt3 = this.getPortlet3();
    	//var pt4 = this.getPortlet4();
    	
    	var pt5 = this.getPortlet5();
    	//var pt6 = this.getPortlet6();
    	//var pt7 = this.getPortlet7();
    	var pt8 = this.getPortlet8();
    	
        var itemCol1 = {
        	defaults:{
        		margin : 5
        	},
	        items: [pt1,pt2, pt3]
	    };
	    
	   
	    var itemCol2 = {
	    	defaults:{
        		margin : 5
        	},
	        items: [
	        	{
			    	title: '',
			    	columnWidth: 1,
			    	xtype:'panel',
			    	items:[
			    		{xtype:'component',
			    		 html:'<div style="height:32px;">&nbsp;</div>'
			    		}
					]
	    		},
	    		pt5,
	    		pt8
	    	]
	    };
	    
	    
	    return [itemCol1,
    			itemCol2]
    },
    
    //initialize
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems(),
    		listeners:{
    			'afterrender':function(portalPanel, eOpts)	{
    				console.log("portalPanel", portalPanel);
	    			var store = Ext.data.StoreManager.lookup("suwonPortalStore")
	    			store.loadStoreRecords()	    		
    			},
    			'show':function(portalPanel, eOpts)	{
    				console.log("portalPanel", portalPanel);
	    			var store = Ext.data.StoreManager.lookup("suwonPortalStore")
	    			store.loadStoreRecords()	    		
    			}
    		}
    	});
    		    
    	this.callParent();
    	
    },
	
    summaryStore : null,
    
    converRate: function(value, record)	{
		return Math.floor(value);
	},
    getPortlet1: function()	{
    	console.log("portlet 1");
    	Unilite.defineModel('SummaryModel', {
		    fields: [	 {name: 'DIV_CODE'   			,text:'구분'		,type : 'string'  }
					    ,{name: 'DIV_NAME'   			,text:'구분'		,type : 'string'  }
					    ,{name: 'ROUTE_GROUP'   		,text:'노선그룹'	,type : 'string'  }
		    			,{name: 'ROUTE_GROUP_NAME'   	,text:'노선그룹'	,type : 'string'  }	
		    			,{name: 'OPERATION_COUNT_CNT'   ,text:'운행계획'	,type : 'uniQty'  }	
						,{name: 'RUN_OPERATION_CNT'   	,text:'운행'		,type : 'uniQty'  }	
						,{name: 'NOTINSERVICE_CNT'   	,text:'운휴'		,type : 'uniQty'  }
						
						,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'기사배정'	,type : 'uniQty'  }						
						,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'	,type : 'uniQty'  }	
						,{name: 'TAG_IN_CNT'   			,text:'출근'	,type : 'uniQty'  }	
						,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'	,type : 'uniQty'  }	
						,{name: 'TAG_OUT_CNT'   		,text:'퇴근'	,type : 'uniQty'  }	
						,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
						,{name: 'LATE_CNT'   			,text:'지각'		,type : 'uniQty'  }	
						,{name: 'EARLY_CNT'   			,text:'조퇴'		,type : 'uniQty'  }	
						
						,{name: 'RUN_OPERATION_RATE'   		,text:'운행율(%)'			,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TOT_RUN_OPERATION_RATE'   	,text:'전체운행율(%)'		,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'ASSIGNED_DRIVER_RATE'   	,text:'기사배정율(%)'		,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TOT_ASSIGNED_DRIVER_RATE'	,text:'전체기사배정율(%)'	,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TAG_IN_RATE'   			,text:'출근등록율(%)'		,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TOT_TAG_IN_RATE'   		,text:'전체출근등록율(%)'	,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TAG_OUT_RATE'   			,text:'퇴근등록율(%)'		,type : 'uniQty'  , convert:this.converRate}	
						,{name: 'TOT_TAG_OUT_RATE'   		,text:'전체퇴근등록율(%)'	,type : 'uniQty'  , convert:this.converRate}	
						       
			]
		});
		
		this.summaryStore =  Ext.create('Ext.data.Store', {
			storeId:'suwonPortalStore',
	        model: 'SummaryModel',   
	        autoLoad: false,
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
	        proxy: {
	            type: 'direct',
	            api: {
	            	   read : 'gtt100skrvService.summaryPortal'
	            }
	        },
			loadStoreRecords: function()	{
					var pt2 = Ext.getCmp('pt2');
					pt2.getEl().mask('로딩중...','loading-indicator');
					
					var pt3 = Ext.getCmp('pt3');
					pt3.getEl().mask('로딩중...','loading-indicator');
					
//					var pt4 = Ext.getCmp('pt4');
//					pt4.getEl().mask('로딩중...','loading-indicator');
					
					var pt5 = Ext.getCmp('pt5');
					pt5.getEl().mask('로딩중...','loading-indicator');
					
//					var pt7 = Ext.getCmp('pt7');
//					pt7.getEl().mask('로딩중...','loading-indicator');
					
					var pt8 = Ext.getCmp('pt8');
					pt8.getEl().mask('로딩중...','loading-indicator');
					
					var sForm = Ext.getCmp('portalSearchForm');
			    	var params = sForm.getValues();
					this.load({params: params});
			},
			listeners:{
				load:function()	{
					var pvtStore = Ext.data.StoreManager.lookup("pvtStore");
					pvtStore.loadStoreRecords();	
					
					var pvtRateStore = Ext.data.StoreManager.lookup("pvtRateStore");
					pvtRateStore.loadStoreRecords();	
					
					var pt2Store = Ext.data.StoreManager.lookup("pt2Store");
					pt2Store.loadStoreRecords();
					
					var pt2ChartStore = Ext.data.StoreManager.lookup("pt2ChartStore");
					pt2ChartStore.loadStoreRecords();					
					
					var pt3ChartStore1 = Ext.data.StoreManager.lookup("pt3ChartStore1");
					pt3ChartStore1.loadStoreRecords();	
					var pt3ChartStore2 = Ext.data.StoreManager.lookup("pt3ChartStore2");
					pt3ChartStore2.loadStoreRecords();	
					
					var pt8ChartStore1 = Ext.data.StoreManager.lookup("pt8ChartStore1");
					pt8ChartStore1.loadStoreRecords();	
					var pt8ChartStore2 = Ext.data.StoreManager.lookup("pt8ChartStore2");
					pt8ChartStore2.loadStoreRecords();	
					
					
					var pt5Store = Ext.data.StoreManager.lookup("pt5Store");
					pt5Store.loadStoreRecords();
					
					var pt5ChartStore = Ext.data.StoreManager.lookup("pt5ChartStore");
					pt5ChartStore.loadStoreRecords();
					
//					var pt6ChartStore = Ext.data.StoreManager.lookup("pt6ChartStore");
//					pt6ChartStore.loadStoreRecords();	
					
					
				}
			}
		});	
	
		Unilite.defineModel('pvtModel', {
		    fields: [	 {name: 'SUMMARY_NAME'  ,text:'구분'	,type : 'string'  }
		    			,{name: '1반'   		,text:'1반'		,type : 'uniQty'  , convert:this.converRate  }	
						,{name: '2반'   		,text:'2반'		,type : 'uniQty'  , convert:this.converRate  }	
						,{name: '3반'   		,text:'3반'		,type : 'uniQty'  , convert:this.converRate  }
						,{name: '5반'   		,text:'5반'		,type : 'uniQty'  , convert:this.converRate  }						
						,{name: '7반'   		,text:'7반'		,type : 'uniQty'  , convert:this.converRate  }	
						       
			]
		});
		
		var pvtStore = Ext.create('Ext.data.Store', {
			storeId:'pvtStore',
	        model: 'pvtModel',   
	        autoLoad: false,
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				var opCnt		= {'SUMMARY_NAME':'운행계획'};
				var runCnt		= {'SUMMARY_NAME':'운행'}; 
				var notSrvCnt	= {'SUMMARY_NAME':'운휴'}; 
				var asDrvCnt	= {'SUMMARY_NAME':'기사배정'};
				var inCnt		= {'SUMMARY_NAME':'출근'	};
				var outCnt		= {'SUMMARY_NAME':'퇴근'}; 
				var notInCnt	= {'SUMMARY_NAME':'출근미등록'} 
				var notOutCnt	= {'SUMMARY_NAME':'퇴근미등록'};
				
				Ext.each(store.data.items, function(record, idx){
					var name = record.get("ROUTE_GROUP_NAME");
					
					opCnt[name]		= record.get("OPERATION_COUNT_CNT") ;
					runCnt[name]	= record.get("RUN_OPERATION_CNT") ;
					notSrvCnt[name] = record.get("NOTINSERVICE_CNT") ;
					asDrvCnt[name]	= record.get("ASSIGNED_DRIVER_CNT");
					inCnt[name]		= record.get("TAG_IN_CNT") ;
					outCnt[name]	= record.get("TAG_OUT_CNT");
					notInCnt[name]	= record.get("NO_TAG_IN_CNT");
					notOutCnt[name]	= record.get("NO_TAG_OUT_CNT");
										
				})
				
				arr.push(opCnt);
				arr.push(runCnt);
				arr.push(notSrvCnt);
				arr.push(asDrvCnt);
				arr.push(inCnt);
				arr.push(outCnt);
				arr.push(notInCnt);
				arr.push(notOutCnt);
			

				this.loadData(arr);
//				var pt4 = Ext.getCmp('pt4');
//				pt4.getEl().unmask();
					
			}
		});
		
		var pvtRateStore = Ext.create('Ext.data.Store', {
			storeId:'pvtRateStore',
	        model: 'pvtModel',   
	        autoLoad: false,
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
					
				var runRate		= {'SUMMARY_NAME':'운행율(%)'};
				var asDrvRate	= {'SUMMARY_NAME':'기사배정율(%)'};
				var inRate		= {'SUMMARY_NAME':'출근등록율(%)'};
				var outRate		= {'SUMMARY_NAME':'퇴근등록율(%)'};
				Ext.each(store.data.items, function(record, idx){
					var name = record.get("ROUTE_GROUP_NAME");
						
					runRate[name]	= record.get("RUN_OPERATION_RATE");
					asDrvRate[name]	= record.get("ASSIGNED_DRIVER_RATE");
					inRate[name]	= record.get("TAG_IN_RATE");
					outRate[name]	= record.get("TAG_OUT_RATE");					
				})
				
				arr.push(runRate);
				arr.push(asDrvRate);
				arr.push(inRate);
				arr.push(outRate);

				this.loadData(arr);
//				var pt7 = Ext.getCmp('pt7');
//				pt7.getEl().unmask();
					
			}
		});
		
		var rangeDate = Ext.create('Unilite.com.form.field.UniDateRangeField', {
			fieldLabel: '조회일',
			name: 'ATT_DATE',
            startFieldName: 'ATT_DATE_FR',
            endFieldName: 'ATT_DATE_TO',	
            startDate: UniDate.get('yesterday'),
            endDate: UniDate.get('yesterday'),
            width:320,
			allowBlank:false,
			height:22			
		});
    	this.pt1SearchForm = Unilite.createSearchForm('portalSearchForm',{
    			itemId:'portalSearchForm',
	            layout:{type:'uniTable', columns:2},
	         	items : [
		     		rangeDate,
		     		{
		     			xtype:'button',
		     			text:'조회',
		     			handler:function()	{		     				
			    			var store = Ext.data.StoreManager.lookup("suwonPortalStore")
			    			store.loadStoreRecords()	    
		     			}
		     		}
	         	]
	    }) ;
	    
	    var ptPanel = {
	    	title: '',
	    	columnWidth: 1,
	    	xtype:'panel',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[this.pt1SearchForm]
	    	
	    };
    	return ptPanel;
    },
    
    getPortlet2:function()	{
    	console.log("portlet 2");
		
    	Unilite.defineModel('pt2Model', {
		    fields: [	 {name: 'DIV_NAME'   			,text:'구분'		,type : 'string'  }	
		    			,{name: 'OPERATION_COUNT_CNT'   ,text:'운행계획'	,type : 'uniQty'  }	
						,{name: 'RUN_OPERATION_CNT'   	,text:'운행'		,type : 'uniQty'  }	
						,{name: 'NOTINSERVICE_CNT'   	,text:'운휴'		,type : 'uniQty'  }	
						,{name: 'ASSIGNED_DRIVER_CNT'   ,text:'기사배정'	,type : 'uniQty'  }						
						,{name: 'NO_DRIVER_CNT'   		,text:'기사미배정'	,type : 'uniQty'  }	
						,{name: 'TAG_IN_CNT'   			,text:'출근'		,type : 'uniQty'  }	
						,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'	,type : 'uniQty'  }	
						,{name: 'TAG_OUT_CNT'   		,text:'퇴근'		,type : 'uniQty'  }	
						,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
			]
		});
		
		var pt2Store =  Ext.create('Ext.data.Store', {
			storeId:'pt2Store',
	        model: 'pt2Model',   
	        autoLoad: true,
	        data:[
	        	{'OPERATION_COUNT_CNT':0, 'RUN_OPERATION_CNT':0, 'ASSIGNED_DRIVER_CNT':0, 'NO_DRIVER_CNT':0,
	        	 'TAG_IN_CNT':0, 'NO_TAG_IN_CNT':0, 'TAG_OUT_CNT':0, 'NO_TAG_OUT_CNT':0}
	        ],
			loadStoreRecords: function(params)	{					
					var store = Ext.data.StoreManager.lookup("suwonPortalStore");
					var arr = new Array();
					arr.push({	  'DIV_NAME':store.max("DIV_NAME")
								, 'OPERATION_COUNT_CNT':store.sum("OPERATION_COUNT_CNT")								
								, 'RUN_OPERATION_CNT':store.sum("RUN_OPERATION_CNT")
								, 'NOTINSERVICE_CNT':store.sum("NOTINSERVICE_CNT")
								, 'ASSIGNED_DRIVER_CNT':store.sum("ASSIGNED_DRIVER_CNT")
								, 'TAG_IN_CNT':store.sum("TAG_IN_CNT")
								, 'TAG_OUT_CNT':store.sum("TAG_OUT_CNT")
								, 'NO_TAG_IN_CNT':store.sum("NO_TAG_IN_CNT")
								, 'NO_TAG_OUT_CNT':store.sum("NO_TAG_OUT_CNT")	});				
					this.loadData(arr);
					var pt = Ext.getCmp('pt2');
					pt.getEl().unmask();
			}
		});	
		
		var pt2Grid = Unilite.createGrid('pt2Grid', {
			uniOpt:{
				//column option--------------------------------------------------
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			height:50,
			border:false,
	    	store: pt2Store,
	    	disableSelection :true,
			columns:[
			    { dataIndex:'DIV_NAME'				,flex: .11 },				
				{ dataIndex:'OPERATION_COUNT_CNT'	,flex: .11 },
				{ dataIndex:'RUN_OPERATION_CNT'		,flex: .11 },
				{ dataIndex:'NOTINSERVICE_CNT'		,flex: .11 },
				{ dataIndex:'ASSIGNED_DRIVER_CNT'	,flex: .11 },
				{ dataIndex:'TAG_IN_CNT'			,flex: .11 },
				{ dataIndex:'TAG_OUT_CNT'			,flex: .11 },
				{ dataIndex:'NO_TAG_IN_CNT'			,flex: .11 },
				{ dataIndex:'NO_TAG_OUT_CNT'		,flex: .11 }
			]
		});
	    var pt1View = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
				'<table cellpadding="5" cellspacing="0" border="0" width="500"  align="center" style="border:1px solid #cccccc;">' ,				
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	<td style="text-align: center;" width="60"  class="bus_gray-label">구분</td>' ,
				'	<td style="text-align: center;" width="60"  class="bus_gray-label">운행계획</td>' ,
				'	<td style="text-align: center;" width="40"  class="bus_gray-label">운행</td>' ,
				'	<td style="text-align: center;" width="40"  class="bus_gray-label">운휴</td>' ,
				'	<td style="text-align: center;" width="60"  class="bus_gray-label">기사배정</td>' ,
				'	<td style="text-align: center;" width="40"  class="bus_gray-label">출근</td>' ,
				'	<td style="text-align: center;" width="40"  class="bus_gray-label">퇴근</td>' ,
				'	<td style="text-align: center;" width="70"  class="bus_gray-label">출근미등록</td>' ,
				'	<td style="text-align: center;" width="70"  class="bus_gray-label">퇴근미등록</td>' ,			
				'</tr>' ,
				'<tpl for=".">' ,
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	<td style="text-align: center;border-left: 0px solid #eeeeee;" class="bus_white-label" >수원여객</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{OPERATION_COUNT_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{RUN_OPERATION_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{NOTINSERVICE_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{ASSIGNED_DRIVER_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{TAG_IN_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{TAG_OUT_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{NO_TAG_IN_CNT}</td>',
				'	<td style="text-align: right;" class="bus_white-label" >{NO_TAG_OUT_CNT}</td>',
				'</tr>' ,
				'</tpl>',
				'</table>' ,
				'<div>'
			],
			border:false,
			autoScroll:false,
			itemSelector: 'div.summary-source',
	        store: pt2Store,
	        margin : '5 0 5 0'
		});	
	    
		Unilite.defineModel('pt2ChartModel', {
		    fields: [
		    			 {name: 'SUMMARY_NAME'  ,text:'집계구분'	,type : 'string'  }	
						,{name: 'VALUE'   		,text:'운행'		,type : 'uniQty'  }	
			]
		});
		
		
		var pt2chartStore = Ext.create('Ext.data.Store', {
			storeId:'pt2ChartStore',
	        model: 'pt2ChartModel',   
	        autoLoad: true,
	        data:[
				{'SUMMARY_NAME':'운행계획'		, 'VALUE':0},
				{'SUMMARY_NAME':'운행'			, 'VALUE':0},
				{'SUMMARY_NAME':'운휴'			, 'VALUE':0},
				{'SUMMARY_NAME':'기사배정'		, 'VALUE':0},
				{'SUMMARY_NAME':'출근'			, 'VALUE':0},
				{'SUMMARY_NAME':'퇴근'			, 'VALUE':0},
				{'SUMMARY_NAME':'출근미등록'	, 'VALUE':0},
				{'SUMMARY_NAME':'퇴근미등록'	, 'VALUE':0}			
			],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				arr.push({'SUMMARY_NAME':'운행계획'		, 'VALUE':store.sum("OPERATION_COUNT_CNT")});
				arr.push({'SUMMARY_NAME':'운행'			, 'VALUE':store.sum("RUN_OPERATION_CNT")});
				arr.push({'SUMMARY_NAME':'운휴'			, 'VALUE':store.sum("NOTINSERVICE_CNT")});
				arr.push({'SUMMARY_NAME':'기사배정'		, 'VALUE':store.sum("ASSIGNED_DRIVER_CNT")});
				arr.push({'SUMMARY_NAME':'출근'			, 'VALUE':store.sum("TAG_IN_CNT")});
				arr.push({'SUMMARY_NAME':'퇴근'			, 'VALUE':store.sum("TAG_OUT_CNT")});
				arr.push({'SUMMARY_NAME':'출근미등록'	, 'VALUE':store.sum("NO_TAG_IN_CNT")});
				arr.push({'SUMMARY_NAME':'퇴근미등록'	, 'VALUE':store.sum("NO_TAG_OUT_CNT")});					
				this.loadData(arr);
			}
		});
		var pt2chart = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:550,
	        height:310,
	        tdAttrs:{align:'center'},
	        store: pt2chartStore,
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['VALUE'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['SUMMARY_NAME'],
	            title: ''
	        }],
	        series: [{
	            type: 'column',
	            axis: 'left',
	            highlight: false,
	            xField: 'SUMMARY_NAME',
	            yField: 'VALUE',
	            label: {
	              	display: 'outside',
	                field: 'VALUE',
	                renderer: Ext.util.Format.numberRenderer('0'),
	                orientation: 'horizontal',
	                color: '#333',
	                'text-anchor': 'center'
	            },
	            renderer: function(sprite, record, attr, index, store) {
                    return Ext.apply(attr, {
                        fill: '#72A9DA'
                    });
                }
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt2',
            title: '전체집계',
            autoScroll:true,
            layout:{type:'uniTable',columns:1, tableAttrs:{width:'100%'}},
            height:350,            
            items:[
            		//pt2Grid,
            		pt2chart
            ]
	     });
	     return ptPanel;
    },
    
     getPortlet3:function()	{
     	
		
		var pt3Grid = Unilite.createGrid('pt3Grid', {
			uniOpt:{
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			disableSelection :true,
			height:150,
			border:false,
	    	store: Ext.data.StoreManager.lookup("suwonPortalStore"),
			columns:[
				{ dataIndex:'ROUTE_GROUP_NAME'		,flex: .11 , align:'center'},
				{ dataIndex:'OPERATION_COUNT_CNT'	,flex: .11 },
				{ dataIndex:'RUN_OPERATION_CNT'		,flex: .11 },
				{ dataIndex:'NOTINSERVICE_CNT'		,flex: .11 },
				{ dataIndex:'ASSIGNED_DRIVER_CNT'	,flex: .11 },
				{ dataIndex:'TAG_IN_CNT'			,flex: .11 },
				{ dataIndex:'TAG_OUT_CNT'			,flex: .11 },
				{ dataIndex:'NO_TAG_IN_CNT'			,flex: .11 },
				{ dataIndex:'NO_TAG_OUT_CNT'		,flex: .11 }
			]
		});
	   
		Unilite.defineModel('pt3ChartModel', {
		    fields: [
		    			 {name: 'ROUTE_GROUP_NAME'  ,text:'노선그룹'	,type : 'string'  }	
		    			,{name: '운행계획'   		,text:'운행계획'	,type : 'uniQty'  }	
						,{name: '운행'   			,text:'운행'		,type : 'uniQty'  }	
						,{name: '운휴'   			,text:'운휴'		,type : 'uniQty'  }	
						,{name: '기사배정'   		,text:'기사배정'	,type : 'uniQty'  }						
						,{name: '기사미배정'   		,text:'기사미배정'	,type : 'uniQty'  }	
						,{name: '출근'   			,text:'출근'		,type : 'uniQty'  }	
						,{name: '출근미등록'   		,text:'출근미등록'	,type : 'uniQty'  }	
						,{name: '퇴근'   			,text:'퇴근'		,type : 'uniQty'  }	
						,{name: '퇴근미등록'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
			]
		});
		
		
		var pt3chartStore1 = Ext.create('Ext.data.Store', {
			storeId:'pt3ChartStore1',
	        model: 'pt3ChartModel',   
	        autoLoad: true,
	         data:[
	        	{'운행계획':0, '운행':0, '기사배정':0, '기사미배정':0,
	        	 '출근':0, '출근미등록':0, '퇴근':0, '퇴근미등록':0}
	        ],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				Ext.each(store.data.items, function(record, idx){
					arr.push({   'ROUTE_GROUP_NAME':record.get("ROUTE_GROUP_NAME")
								,'운행':record.get("RUN_OPERATION_CNT")
								,'운휴':record.get("NOTINSERVICE_CNT")});	
				})				
				this.loadData(arr);
				
				var pt3 = Ext.getCmp('pt3');
				pt3.getEl().unmask();
					
			}
		});
		var pt3chart1 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:330,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pt3ChartStore1"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'bottom',
	            fields: ['운행','운휴'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'left',
	            fields: ['ROUTE_GROUP_NAME'],
	            title: ''
	        }],
	        //['운행계획','운행','운휴','기사배정','출근','퇴근','출근미등록','퇴근미등록']
	        //['OPERATION_COUNT_CNT','RUN_OPERATION_CNT','NOTINSERVICE_CNT','ASSIGNED_DRIVER_CNT','TAG_IN_CNT','TAG_OUT_CNT','NO_TAG_IN_CNT','NO_TAG_OUT_CNT'],
	        series: [{
	            type: 'bar',
	            stacked: true,
	            axis: 'bottom',
	            highlight: false,
	            xField: 'ROUTE_GROUP_NAME',
	            yField: ['운행','운휴'],	           
	            label: {
	              	display: 'insideEnd',
	                field: ['운행','운휴'],	  
	                renderer: Ext.util.Format.numberRenderer('0'),
	                orientation: 'horizontal',
	                color: '#fff',
	                'text-anchor': 'center'
	            }
	        }]
	    });
	    
	    var pt3chartStore2 = Ext.create('Ext.data.Store', {
			storeId:'pt3ChartStore2',
	        model: 'pt3ChartModel',   
	        autoLoad: true,
	         data:[
	        	{'운행계획':0, '운행':0, '기사배정':0, '기사미배정':0,
	        	 '출근':0, '출근미등록':0, '퇴근':0, '퇴근미등록':0}
	        ],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				Ext.each(store.data.items, function(record, idx){
					arr.push({   'ROUTE_GROUP_NAME':record.get("ROUTE_GROUP_NAME")
								,'기사배정':record.get("ASSIGNED_DRIVER_CNT")
								,'기사미배정':record.get("NO_DRIVER_CNT")});	
				})				
				this.loadData(arr);
			}
		});
	    var pt3chart2 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:330,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pt3ChartStore2"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'bottom',
	            fields: ['기사배정','기사미배정'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'left',
	            fields: ['ROUTE_GROUP_NAME'],
	            title: ''
	        }],
	         series: [{
	            type: 'bar',
	            stacked: true,
	            axis: 'bottom',
	            highlight: false,
	            xField: 'ROUTE_GROUP_NAME',
	            yField: ['기사배정','기사미배정'],	           
	   			label: {
	              	display: 'insideEnd',
	                field: ['기사배정','기사미배정'],	     
	                renderer: Ext.util.Format.numberRenderer('0'),
	                orientation: 'horizontal',
	                color: '#fff',
	                'text-anchor': 'center'
	            }          
	          
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt3',
            title: '반별집계',
            autoScroll:true,
            layout:{type:'uniTable',columns:2, tableAttrs:{width:'100%'}},
            height:300,            
            items:[
            		//pt3Grid,
            		pt3chart1,
            		pt3chart2
            ]
	     });
	     return ptPanel;
     },
     
     getPortlet8:function()	{
	   
		Unilite.defineModel('pt8ChartModel', {
		    fields: [
		    			 {name: 'ROUTE_GROUP_NAME'  ,text:'노선그룹'	,type : 'string'  }	
						,{name: '출근등록'   			,text:'출근등록'		,type : 'uniQty'  }	
						,{name: '출근미등록'   		,text:'출근미등록'	,type : 'uniQty'  }	
						,{name: '퇴근등록'   			,text:'퇴근'		,type : 'uniQty'  }	
						,{name: '퇴근미등록'   		,text:'퇴근미등록'	,type : 'uniQty'  }	
			]
		});
		
		
		var pt8chartStore1 = Ext.create('Ext.data.Store', {
			storeId:'pt8ChartStore1',
	        model: 'pt8ChartModel',   
	        autoLoad: true,
	         data:[
	        	{'출근등록':0, '출근미등록':0, '퇴근등록':0, '퇴근미등록':0}
	        ],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				Ext.each(store.data.items, function(record, idx){
					arr.push({   'ROUTE_GROUP_NAME':record.get("ROUTE_GROUP_NAME")
								,'출근등록':record.get("TAG_IN_CNT")
								,'출근미등록':record.get("NO_TAG_IN_CNT")});	
				})				
				this.loadData(arr);
				var pt8 = Ext.getCmp('pt8');
				pt8.getEl().unmask();
			}
		});
		var pt8chart1 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:330,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pt8ChartStore1"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'bottom',
	            fields: ['출근등록','출근미등록'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'left',
	            fields: ['ROUTE_GROUP_NAME'],
	            title: ''
	        }],
	        //['운행계획','운행','운휴','기사배정','출근','퇴근','출근미등록','퇴근미등록']
	        //['OPERATION_COUNT_CNT','RUN_OPERATION_CNT','NOTINSERVICE_CNT','ASSIGNED_DRIVER_CNT','TAG_IN_CNT','TAG_OUT_CNT','NO_TAG_IN_CNT','NO_TAG_OUT_CNT'],
	        series: [{
	            type: 'bar',
	            stacked: true,
	            axis: 'bottom',
	            highlight: false,
	            xField: 'ROUTE_GROUP_NAME',
	            yField: ['출근등록','출근미등록'],	           
	            label: {
	              	display: 'insideEnd',
	                field: ['출근등록','출근미등록'],	       
	                renderer: Ext.util.Format.numberRenderer('0'),
	                orientation: 'horizontal',
	                color: '#fff',
	                'text-anchor': 'center'
	            }
	        }]
	    });
	    
	    var pt8chartStore2 = Ext.create('Ext.data.Store', {
			storeId:'pt8ChartStore2',
	        model: 'pt8ChartModel',   
	        autoLoad: true,
	         data:[
	        	{'출근등록':0, '출근미등록':0, '퇴근등록':0, '퇴근미등록':0}
	        ],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				Ext.each(store.data.items, function(record, idx){
					arr.push({   'ROUTE_GROUP_NAME':record.get("ROUTE_GROUP_NAME")
								,'퇴근등록':record.get("TAG_OUT_CNT")
								,'퇴근미등록':record.get("NO_TAG_OUT_CNT")});	
				})				
				this.loadData(arr);
			}
		});
	    var pt8chart2 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:330,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pt8ChartStore2"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'bottom',
	            fields: ['퇴근등록','퇴근미등록'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'left',
	            fields: ['ROUTE_GROUP_NAME'],
	            title: ''
	        }],
	         series: [{
	            type: 'bar',
	            stacked: true,
	            axis: 'bottom',
	            highlight: false,
	            xField: 'ROUTE_GROUP_NAME',
	            yField: ['퇴근등록','퇴근미등록'],	           
	   			label: {
	              	display: 'insideEnd',
	                field: ['퇴근등록','퇴근미등록'],
	                renderer: Ext.util.Format.numberRenderer('0'),
	                orientation: 'horizontal',
	                color: '#fff',
	                'text-anchor': 'center'
	            }
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt8',
            title: '근태집계',
            autoScroll:true,
            layout:{type:'uniTable',columns:2, tableAttrs:{width:'100%'}},
            height:300,            
            items:[
            		//pt3Grid,
            		pt8chart1,
            		pt8chart2
            ]
	     });
	     return ptPanel;
     },
     
     getPortlet4:function()	{
     	
  		var pt4Grid = Unilite.createGrid('pt4Grid', {
			uniOpt:{
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			disableSelection :true,
			height:150,
			border:false,
	    	store: Ext.data.StoreManager.lookup("pvtStore"),
			columns:[
				{ dataIndex:'SUMMARY_NAME'	,width: 100 },
				{ dataIndex:'1반'			,flex: .2},
				{ dataIndex:'2반'			,flex: .2 },
				{ dataIndex:'3반'			,flex: .2 },
				{ dataIndex:'5반'			,flex: .2 },
				{ dataIndex:'7반'			,flex: .2 }
			
			]
		});
	   
		
		var pt4chart = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:600,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pvtStore"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['1반','2반','3반','5반','7반'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['SUMMARY_NAME'],
	            title: ''
	        }],
	         series: [{
	            type: 'column',
	            axis: 'left',
	            highlight: false,
	            xField: 'SUMMARY_NAME',
	            yField: ['1반','2반','3반','5반','7반']	           
	        },{
	            type: 'column',
	            axis: 'left',
	            highlight: false,
	            xField: 'SUMMARY_NAME',
	            yField: ['1반','2반','3반','5반','7반']	           
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt4',
            title: '항목별집계',
            autoScroll:true,
            layout:{type:'uniTable',columns:1, tableAttrs:{width:'100%'}},
            height:450,            
            items:[
            		pt4Grid,
            		pt4chart
            ]
	     });
	     return ptPanel;
     },

     getPortlet5:function() {

    	Unilite.defineModel('pt5Model', {
		    fields: [	 {name: 'DIV_NAME'   			,text:'구분'		,type : 'string'  }	
						,{name: 'RUN_OPERATION_RATE'   	,text:'운행율'		,type : 'uniQty'  , convert:this.converRate  }	
						,{name: 'ASSIGNED_DRIVER_RATE'  ,text:'기사배정율'	,type : 'uniQty'  , convert:this.converRate  }	
						,{name: 'TAG_IN_RATE'   		,text:'출근등록율'	,type : 'uniQty'  , convert:this.converRate  }	
						,{name: 'TAG_OUT_RATE'   		,text:'퇴근등록율'	,type : 'uniQty'  , convert:this.converRate  }	
						
			]
		});
		
		var pt5Store =  Ext.create('Ext.data.Store', {
			storeId:'pt5Store',
	        model: 'pt5Model',   
	        autoLoad: true,
	        data:[
	        	{'RUN_OPERATION_RATE':0, 'ASSIGNED_DRIVER_RATE':0, 'TAG_IN_RATE':0, 'TAG_OUT_RATE':0}
	        ],
			loadStoreRecords: function(params)	{					
					var store = Ext.data.StoreManager.lookup("suwonPortalStore");
					var arr = new Array();
					arr.push({	  'DIV_NAME':store.max("DIV_NAME")
								, 'RUN_OPERATION_RATE':store.max("TOT_RUN_OPERATION_RATE")								
								, 'ASSIGNED_DRIVER_RATE':store.max("TOT_ASSIGNED_DRIVER_RATE")
								, 'TAG_IN_RATE':store.max("TOT_TAG_IN_RATE")
								, 'TAG_OUT_RATE':store.max("TOT_TAG_OUT_RATE")});				
					this.loadData(arr);
					var pt = Ext.getCmp('pt5');
					pt.getEl().unmask();
			}
		});	
		
		var pt5Grid = Unilite.createGrid('pt5Grid', {
			uniOpt:{
				//column option--------------------------------------------------
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			height:50,
			border:false,
	    	store: pt5Store,
	    	disableSelection :true,
			columns:[
			    { dataIndex:'DIV_NAME'				,flex: .2 },				
				{ dataIndex:'RUN_OPERATION_RATE'	,flex: .2 },
				{ dataIndex:'ASSIGNED_DRIVER_RATE'	,flex: .2 },
				{ dataIndex:'TAG_IN_RATE'			,flex: .2 },
				{ dataIndex:'TAG_OUT_RATE'			,flex: .2 }
			]
		});
	    
		Unilite.defineModel('pt5ChartModel', {
		    fields: [
		    			 {name: 'SUMMARY_NAME'  ,text:'집계구분'	,type : 'string'  }	
						,{name: 'VALUE'   		,text:'운행'		,type : 'uniQty'  , convert:this.converRate  }	
			]
		});
		
		
		var pt5chartStore = Ext.create('Ext.data.Store', {
			storeId:'pt5ChartStore',
	        model: 'pt5ChartModel',   
	        autoLoad: true,
	        data:[			
				{ 'RUN_OPERATION_RATE':50,
				  'ASSIGNED_DRIVER_RATE':50,
				  'TAG_IN_RATE':50,
				  'TAG_OUT_RATE':50}		
			],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				arr.push({ 	 'RUN_OPERATION_RATE':store.max("TOT_RUN_OPERATION_RATE")
							,'ASSIGNED_DRIVER_RATE':store.max("TOT_ASSIGNED_DRIVER_RATE")
							,'TAG_IN_RATE':store.max("TOT_TAG_IN_RATE")
							,'TAG_OUT_RATE':store.max("TOT_TAG_OUT_RATE")});
			//	arr.push({'SUMMARY_NAME':'출근등록율'	, 'VALUE':store.max("TOT_TAG_IN_RATE")});
			//	arr.push({'SUMMARY_NAME':'퇴근등록율'	, 'VALUE':store.max("TOT_TAG_OUT_RATE")});				
				this.loadData(arr);
			}
		});
		var pt5chart1 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#fff',
	        animate: {
                easing: 'elasticIn',
                duration: 1000
            },
            insetPadding: 5,
	        width:230,
	        height:150,
	        
	        tdAttrs:{align:'center'},
	        
	        store: pt5Store,
	        title:'운행율',
	        axes: [{
	            type: 'gauge',
                position: 'gauge',
                minimum: 0,
                maximum: 100,
                steps: 10,
                margin: -10
	        }],
	        series: [{
	            type: 'gauge',
	            field: 'RUN_OPERATION_RATE',
                donut: 30,
                colorSet: ['#F49D10', '#ddd'],
                label: {
	              	display: 'rotate',
	                field: 'RUN_OPERATION_RATE',
	                color: '#333',
	                'text-anchor': 'center'
	            }
	        }],
	         items: [{
			      type  : 'text',
			      text  : '운행율(%)',
			      font  : '12px Gulim',
			      width : 250,
			      height: 25,
			      x : 87, //the sprite x position
			      y : 140  //the sprite y position
			   }]
	    });
	    
	    var pt5chart2 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#fff',
	        animate: {
                easing: 'elasticIn',
                duration: 1000
            },
            insetPadding: 5,
	        width:230,
	        height:150,
	        tdAttrs:{align:'center'},
	        
	        store: pt5Store,
	        axes: [{
	            type: 'gauge',
                position: 'gauge',
                minimum: 0,
                maximum: 100,
                steps: 10,
                margin: -10
                
	        }],
	        series: [{
	            type: 'gauge',
	            field: 'ASSIGNED_DRIVER_RATE',
                donut: 40,
                colorSet: ['#82B525', '#ddd'] 
               
	        }],
	         items: [{
			      type  : 'text',
			      text  : '기사배정율(%)',
			      font  : '12px Gulim',
			      width : 250,
			      height: 25,
			      x : 75, //the sprite x position
			      y : 140  //the sprite y position
			   }]
	    });
	    
	    var pt5chart3 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#fff',
	        animate: true,
            insetPadding: 5,
	        width:230,
	        height:150,
	        tdAttrs:{align:'center'},
	        title:'',
	        store: pt5Store,
	        axes: [{
	            type: 'gauge',
                position: 'gauge',
                minimum: 0,
                maximum: 100,
                steps: 10,
                margin: -10
                
	        }],
	        series: [{
	            type: 'gauge',
	            field: 'TAG_IN_RATE',
                donut: 40,
                colorSet: ['#3AA8CB', '#ddd'] 
               
	        }],
	         items: [{
			      type  : 'text',
			      text  : '출근등록율(%)',
			      font  : '12px Gulim',
			      width : 250,
			      height: 25,
			      x : 77, //the sprite x position
			      y : 140  //the sprite y position
			   }]
	    });
	    
	    var pt5chart4 = Ext.create('Ext.chart.Chart', {
	        style: 'background:#fff',
	        animate: true,
            insetPadding: 5,
	        width:230,
	        height:150,
	        tdAttrs:{align:'center'},
	        title:'',
	        store: pt5Store,
	        axes: [{
	            type: 'gauge',
                position: 'gauge',
                minimum: 0,
                maximum: 100,
                steps: 10,
                margin: -10
                
	        }],
	        series: [{
	            type: 'gauge',
	            field: 'TAG_OUT_RATE',
                donut: 40,
                colorSet: ['#FFC000', '#ddd'] 
	        }],
	         items: [{
			      type  : 'text',
			      text  : '퇴근등록율(%)',
			      font  : '12px Gulim',
			      width : 250,
			      height: 25,
			      x : 77, //the sprite x position
			      y : 140  //the sprite y position
			   }]
	    });
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt5',
            title: '전체달성율',
            autoScroll:true,
            layout:{type:'uniTable',columns:2, tableAttrs:{width:'100%'}},
            height:350,            
            items:[
            		//pt5Grid,
            		pt5chart1,
            		pt5chart2,
            		pt5chart3,
            		pt5chart4
            ]
	     });
	     return ptPanel;
    },
    
      getPortlet6:function() {
      var pt6Grid = Unilite.createGrid('pt6Grid', {
			uniOpt:{
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			disableSelection :true,
			height:150,
			border:false,
	    	store: Ext.data.StoreManager.lookup("suwonPortalStore"),
			columns:[
				{ dataIndex:'ROUTE_GROUP_NAME'		,flex: .2 , align:'center'},
				{ dataIndex:'RUN_OPERATION_RATE'	,flex: .2 },
				{ dataIndex:'ASSIGNED_DRIVER_RATE'	,flex: .2 },
				{ dataIndex:'TAG_IN_RATE'			,flex: .2 },
				{ dataIndex:'TAG_OUT_RATE'			,flex: .2 }
			]
		});
	   
		Unilite.defineModel('pt6ChartModel', {
		    fields: [
		    			 {name: 'ROUTE_GROUP_NAME'  ,text:'노선그룹'		,type : 'string'  }	
		    			,{name: '운행율(%)'   			,text:'운행율(%)'			,type : 'uniQty'  , convert:this.converRate }	
						,{name: '기사배정율(%)'   		,text:'기사배정율(%)'		,type : 'uniQty'  , convert:this.converRate  }						
						,{name: '출근등록율(%)'   		,text:'출근등록율(%)'		,type : 'uniQty'  , convert:this.converRate  }	
						,{name: '퇴근등록율(%)'   		,text:'퇴근등록율(%)'		,type : 'uniQty'  , convert:this.converRate  }	
			]
						
		});
		
		
		var pt6chartStore = Ext.create('Ext.data.Store', {
			storeId:'pt6ChartStore',
	        model: 'pt6ChartModel',   
	        autoLoad: true,
	         data:[
	        	{'운행율':0, '기사배정율':0, '출근등록율':0, '퇴근등록율':0}
	        ],
			loadStoreRecords: function()	{
				var store = Ext.data.StoreManager.lookup("suwonPortalStore");
				var arr = new Array();
				Ext.each(store.data.items, function(record, idx){
					arr.push({   'ROUTE_GROUP_NAME':record.get("ROUTE_GROUP_NAME")
								,'운행율(%)':record.get("RUN_OPERATION_RATE")
								,'기사배정율(%)':record.get("ASSIGNED_DRIVER_RATE")
								,'출근등록율(%)':record.get("TAG_IN_RATE")
								,'퇴근등록율(%)':record.get("TAG_OUT_RATE")});	
				})				
				this.loadData(arr);
			}
		});
		var pt6chart = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:600,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pt6ChartStore"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['운행율(%)','기사배정율(%)','출근등록율(%)','퇴근등록율(%)'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['ROUTE_GROUP_NAME'],
	            title: ''
	        }],
	        //['운행계획','운행','운휴','기사배정','출근','퇴근','출근미등록','퇴근미등록']
	        //['OPERATION_COUNT_CNT','RUN_OPERATION_CNT','NOTINSERVICE_CNT','ASSIGNED_DRIVER_CNT','TAG_IN_CNT','TAG_OUT_CNT','NO_TAG_IN_CNT','NO_TAG_OUT_CNT'],
	        series: [{
	            type: 'column',
	            axis: 'left',
	            highlight: false,
	            xField: 'ROUTE_GROUP_NAME',
	            yField: ['운행율(%)','기사배정율(%)','출근등록율(%)','퇴근등록율(%)']	           
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt6',
            title: '반별달성율',
            autoScroll:true,
            layout:{type:'uniTable',columns:1, tableAttrs:{width:'100%'}},
            height:450,            
            items:[
            		pt6Grid,
            		pt6chart
            ]
	     });
	     return ptPanel;
      },
      
      getPortlet7:function() {
     		var pt7Grid = Unilite.createGrid('pt7Grid', {
			uniOpt:{
				expandLastColumn: false,
				useRowNumberer: false,		//번호 컬럼 사용 여부	
				onLoadSelectFirst: false,
				state: {
					useState: false,			//그리드 설정 버튼 사용 여부
					useStateList: false		//그리드 설정 목록 사용 여부
				},
				excel: {
					useExcel: false			//엑셀 다운로드 사용 여부
				}
			},
			disableSelection :true,
			height:150,
			border:false,
	    	store: Ext.data.StoreManager.lookup("pvtRateStore"),
			columns:[
				{ dataIndex:'SUMMARY_NAME'	,width: 100 },
				{ dataIndex:'1반'			,flex: .2},
				{ dataIndex:'2반'			,flex: .2 },
				{ dataIndex:'3반'			,flex: .2 },
				{ dataIndex:'5반'			,flex: .2 },
				{ dataIndex:'7반'			,flex: .2 }
			
			]
		});
	   
		
		var pt7chart = Ext.create('Ext.chart.Chart', {
	        style: 'background:#eee',
	        animate: true,
	        shadow: true,
	        width:600,
	        height:250,
	        tdAttrs:{align:'center'},
	        store: Ext.data.StoreManager.lookup("pvtRateStore"),
	        legend: {
                position: 'bottom'
            },
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['1반','2반','3반','5반','7반'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0')
	            },
	            title: '',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['SUMMARY_NAME'],
	            title: ''
	        }],
	         series: [{
	            type: 'column',
	            axis: 'left',
	            highlight: false,
	            xField: 'SUMMARY_NAME',
	            yField: ['1반','2반','3반','5반','7반']	           
	        }]
	    });
	    
    	var ptPanel = Ext.create('Ext.panel.Panel', {
    		id:'pt7',
            title: '항목별달성율',
            autoScroll:true,
            layout:{type:'uniTable',columns:1, tableAttrs:{width:'100%'}},
            height:450,            
            items:[
            		pt7Grid,
            		pt7chart
            ]
	     });
	     return ptPanel;
      }
});