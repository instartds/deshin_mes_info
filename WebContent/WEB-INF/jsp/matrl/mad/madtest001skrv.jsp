<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="madtest001skrv"  >
<t:ExtComboStore comboType="AU" comboCode="YP01"/>	<!-- POS명		-->
<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('madtest001skrvModel', {
	    fields: [
	    	{name:'POS_NUM' 	, text: 'POS'		, type: 'string'},
	    	{name:'POS_NAME' 	, text: 'POS명'		, type: 'string'},
	    	{name:'POS_CODE' 	, text: 'POS'		, type: 'string'},
	    	{name:'GUBUN' 		, text: '<t:message code="system.label.purchase.classfication" default="구분"/>'		, type: 'string'},
	    	{name:'SUMMARY' 	, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'},
	    	{name:'C08' 		, text: '08~09'		, type: 'uniPrice'},
	    	{name:'C09' 		, text: '09~10'		, type: 'uniPrice'},
	    	{name:'C10' 		, text: '10~11'		, type: 'uniPrice'},
	    	{name:'C11' 		, text: '11~12'		, type: 'uniPrice'},
	    	{name:'C12' 		, text: '12~13'		, type: 'uniPrice'},
	    	{name:'C13' 		, text: '13~14'		, type: 'uniPrice'},
	    	{name:'C14' 		, text: '14~15'		, type: 'uniPrice'},
	    	{name:'C15' 		, text: '15~16'		, type: 'uniPrice'},
	    	{name:'C16' 		, text: '16~17'		, type: 'uniPrice'},
	    	{name:'C17' 		, text: '17~18'		, type: 'uniPrice'},
	    	{name:'C18' 		, text: '18~19'		, type: 'uniPrice'},
	    	{name:'C19' 		, text: '19~24'		, type: 'uniPrice'},
	    	{name:'SALE_DATE' 	, text: '매출일'		, type: 'uniDate'},
	    	{name:'SALE_HOUR' 	, text: '매출시간'		, type: 'uniDate'}
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('madtest001skrvMasterStore',{
			model: 'madtest001skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'madtest001skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: 'POS_NUM'	
	});		// End of var MasterStore 
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업부',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				comboType:'AU',
		        comboCode:'YP01',
		        multiSelect: true, 
		        typeAhead: false,
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					}
				}
			},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect1',
			    fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',
			    items : [{
			    	boxLabel: '객수',
			    	name: 'SORT',
			    	inputValue: '1',
			    	width:80,
			    	checked:true
			    }, {
			    	boxLabel: '매출수량',
			    	name: 'SORT' ,
			    	inputValue: '2',
			    	width:80
			    }, {
			    	boxLabel: '매출금액',
			    	name: 'SORT' ,
			    	inputValue: '3',
			    	width:80
			    }, {
			    	boxLabel: '객단가',
			    	name: 'SORT' ,
			    	inputValue: '4',
			    	width:80
			    }, {
			    	boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
			    	name: 'SORT' ,
			    	inputValue: '5',
			    	width:80
			    }]				
			}]
		}]
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
					fieldLabel: '사업부',
					name:'DIV_CODE', 
					value : UserInfo.divCode,
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 350,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);		    		
			    	}
			    }
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				comboType:'AU',
		        comboCode:'YP01',
		        multiSelect: true, 
		        typeAhead: false,
				allowBlank:false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('POS_CODE', newValue);
						}
					}
			}]
		
    });
    
    
    
    	Ext.define('chartModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'SALE_TIME', 'P01_CNT','P02_CNT','P03_CNT']
	});
	var chartStore = new Ext.data.SimpleStore({
  		model:'chartModel',
  		autoLoad: true,
  		proxy: {
            type: 'direct',
            api: {
            	read: 'madtest001skrvService.selectList'                	
            }
        }/*,
        listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           		 chartStore.add({
           		 	
           		 	
           		 	
                	time : records.get('SALE_TIME'),
                	pos : records.get('P01_CNT')
                });
           	}
        }*/
        //    type: "ajax",
        //    url: "C:/g3erp/workspace/G3ERP/src/java/foren/unilite/modules/matrl/mad/Madtest001skrvServiceImpl_SQL.xml"
        /*    reader:{
            	type:"xml",
            	root:"NewDataSet",
            	record: "Floats"
            }*/
       // }
	});
	
    var chart = Ext.create('Ext.chart.Chart', {
        style: 'background:#fff',
        animate: true,
        store: chartStore,
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
            fields: ['P01_CNT'],
         //   fields: ['value1'],
          /*  label: {
            	renderer: Ext.util.Format.numberRenderer('0,0')
    		},*/
            title: '구 분 Value',
            minorTickSteps: 1,
            grid: {
                odd: {
                    opacity: 1,
                    fill: '#ddd',
                    stroke: '#bbb',
                    'stroke-width': 0.5
                }
            }
        },{
            type: 'Category',
            position: 'bottom',
          //  fields: ['name'],
            fields: ['SALE_TIME'],
            title: '시 간 대 '
        }],
        series: [{
            type: 'line',
            
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
          //   showMarkers:true,
            title:'101',
          //  title: record.get('POS_NUM'),
            xField: 'SALE_TIME', 
            yField: 'P01_CNT',	// 비교필드는 y필드
          	//title:'101',
            markerConfig: {
                type: 'cross',
                size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P01_CNT'));
                }
            }
        }, {
            type: 'line',
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
            smooth: true,
            xField: 'SALE_TIME',
            yField: 'P02_CNT',
            markerConfig: {
                type: 'circle',
                size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P02_CNT'));
                }
            }
        }, {
            type: 'line',
            highlight: {
                size: 7,
                radius: 7
            },
            axis: 'left',
            smooth: true,
            fill: true,
            xField: 'SALE_TIME',
            yField: 'P03_CNT',
            markerConfig: {
                type: 'circle',
                size: 4,
                radius: 4,
                'stroke-width': 0
            },
             tips: {
                trackMouse: true,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('P03_CNT'));
                }
            }
        }]
    });
     var panelResult2 = Unilite.createSimpleForm('panelResultForm2', {
    	//hidden: !UserInfo.appOption.collapseLeftSearch,
     //	collapsed:true,
     	/*listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },*/
		region: 'south',
		//layout : {type : 'uniTable'},
		//padding:'5 5 5 5',
		border:true,
		layout : 'fit',
		
      	// width: 500,
        height: 810,
        minHeight: 200,
        minWidth: 300,
        hidden: false,
      //  maximizable: true,
        title: 'Line Chart',
       // renderTo: Ext.getBody(),
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
    

    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('madtest001skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [
			{dataIndex:'POS_NUM'  	 	, width: 85, locked: true},
			{dataIndex:'POS_NAME'	 	, width: 85, locked: true},                                      
			{dataIndex:'GUBUN' 		 	, width: 85, locked: true},                                                                         	                                       	
			{dataIndex:'C08' 	 		, width: 85},                                       	
			{dataIndex:'C09' 	 		, width: 85},                                       	
			{dataIndex:'C10' 	 		, width: 85},                                       	
			{dataIndex:'C11' 	 		, width: 85},
			{dataIndex:'C12' 	 		, width: 85},
			{dataIndex:'C13' 	 		, width: 85},
			{dataIndex:'C14' 	 		, width: 85},
			{dataIndex:'C15' 	 		, width: 85},
			{dataIndex:'C16' 	 		, width: 85},
			{dataIndex:'C17' 	 		, width: 85},
			{dataIndex:'C18' 	 		, width: 85},
			{dataIndex:'C19' 	 		, width: 85},
			{dataIndex:'SUMMARY' 	 	, width: 150}           
		]
    });		//End of var masterGrid 
	
   
    
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
           		panelResult2
         	]	
      	}/*,
      		panelSearch*/
      	],
		id: 'madtest001skrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{
			
			chartStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
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
