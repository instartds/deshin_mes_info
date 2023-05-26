<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb200skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="CB23" />
	<t:ExtComboStore comboType="AU" comboCode="CB24" />
	<t:ExtComboStore comboType="AU" comboCode="CB46" />
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {
	/**
	 * Model 정의
	 * @type
	 */	
	Unilite.defineModel('Cmb200skrvModel', {
	    fields: [{name:'PROCESS_NAME'	,text:'공정',		type:'string' },
             	 {name:'CUSTOM_NAME'	,text:'거래처',		type:'string' },
             	 {name:'CUSTOM_CODE'	,text:'거래처코드',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',	type:'string' },
	             {name:'PROJECT_TYPE'	,text:'구분',		type:'string' },
	             {name:'SALE_EMP'		,text:'영업담당',	type:'string' },
	             {name:'RESULT_DATE'	,text:'실행일자',	type:'uniDate'},
	             {name:'TARGET_DATE'	,text:'완료목표일',	type:'uniDate'},
	             {name:'MONTH_QUANTITY'	,text:'예상규모',	type:'int'},
	             {name:'CURRENT_DD'		,text:'제품',	type:'string' },
	             {name:'SALE_STATUS'	,text:'상태',		type:'string', comboType:"AU", comboCode:"CB46"},
	             {name:'SALE_STATUS_NM'	,text:'상태',		type:'string' },
	             {name:'SUMMARY_STR'	,text:'현황',		type:'string' },
	             {name:'PLAN_TARGET'	,text:'계획',		type:'string' },
	             {name:'ITEM_NAME'		,text:'샘플',		type:'string' },
	             {name:'CLIENT_NAME'	,text:'고객명',		type:'string' },
	             {name:'PROJECT_NO'		,text:'프로젝트 번호',	type:'string' },
	             {name:'DVRY_CUST_NM'	,text:'배송처',		type:'string' },
	             {name:'DOC_NO'			,text:'문서번호',	type:'string' },
	             {name:'PLAN_DATE'		,text:'영업활동계획일',	type:'uniDate' },
	             {name: 'PURCHASE_AMT'		,text: '매입액'		,type: 'uniPrice' },
	        	 {name: 'MARGIN_AMT'		,text: '마진액'		,type: 'uniPrice' },
	        	 {name: 'MARGIN_RATE'		,text: '마진율'		,type: 'uniPercent' 	},
	        	 {name: 'SALES_PROJECTION'	,text: '확률'		,type: 'uniPercent' 	},
	        	 {name: 'EXPECTED_ORDER'	,text: '수주예정'	,type: 'uniDate'}
	    ]
	});
	

						
	var directMasterStore = Unilite.createStore('Cmb200skrvMasterStore', {
			model: 'Cmb200skrvModel',
            autoLoad: false,
            uniOpt: {
            	isMaster: false
            },
            proxy: {
                type: 'direct',
                api: {
                	read: 'cmb200skrvService.selectDataListR'
                }
            },
            groupField: 'PROJECT_TYPE'
	});
//	var win
/*	Ext.define("uniliteCustomModel", {
	    extend: 'Ext.data.Model',
        fields: [
            'customCode','customName'
        ]
    });
    
*/
            
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */     
  	var panelSearch = Unilite.createSearchForm('searchForm', {  
        region:'west',	
		title: '검색조건',
		split:true,
        width:292,
        margin: '0 0 0 0',
	    border: true,
		collapsible: false,	
		autoScroll:true,
		collapseDirection: 'left',
		tools: [{
			region:'west',
			type: 'left', 	
			itemId:'left',
			tooltip: 'Hide',
			handler: function(event, toolEl, panelHeader) {
						panelSearch.collapse(); 
				    }
			}
		],
        xtype:'container',
        defaults:{
        	collapsible: true,
        	titleCollapse: true,
        	hideCollapseTool: true,
			bodyStyle:{'border-width': '0px',
						'spacing-bottom':'3px'
			},
			header:{ xtype:'header',
					 style:{
							'background-color': '#D9E7F8',
							'background-image':'none',
							'color': '#333333',
							'font-weight': 'normal',
							'border-width': '0px',
							'spacing':'5px'
							}
					}
		},
		layout: {type: 'vbox', align:'stretch'},
	    defaultType: 'panel',
	    items: [{
	    	title: '기본정보',
			id: 'search_panel1',
	        items: [{
	            xtype:'container',
	            flex: 1,
	            layout : {type : 'uniTable', columns : 1},
	            defaultType: 'uniTextfield',
	            items :[  
	            	Unilite.popup('CUST',{
	            	textFieldWidth:160,
	            	validateBlank:false,
		            labelWidth:55	            
	            }),
					Unilite.popup('CUSTOMER',{
			      	fieldLabel:'고객명',
			      	showValue : false,
			      	width:240,
			      	textFieldWidth:100,
	        		labelWidth:55,
			      	valueFieldName:'CLIENT_ID'
			    }),{
				    fieldLabel: '시작일',
		            xtype: 'uniDateRangefield',
		            startFieldName: 'START_FR_DATE',
		            endFieldName: 'START_TO_DATE',	
		            width: 350,
		            startDate: UniDate.get('startOfYear'),
		            endDate: UniDate.get('endOfMonth'),
		            labelWidth:55
            	 },{
            	 	fieldLabel: '유형',
            	 	name: 'PROJECT_OPT',
            	 	xtype: 'uniRadiogroup',
            	 	comboType:'AU',
            	 	comboCode:'CB24',
            	 	width:190,
            	 	allowBlank:false,
		            labelWidth:55
            	 },{ 
            	 	fieldLabel: '중요도',
            	 	name: 'IMPORTANCE_STATUS',
            	 	xtype: 'uniCheckboxgroup',
            	 	comboType:'AU',
            	 	comboCode:'CB23',
            	 	width:252,
            	 	initAllTrue:true,
		            labelWidth:55
            	 },{ 
            	 	fieldLabel: '목표일',
	                xtype: 'uniDateRangefield',
	                startFieldName: 'END_FR_DATE',
	                endFieldName: 'END_TO_DATE'	,
	                width: 350,
		            labelWidth:55
            	 }]
	        }]	        
	    }]
    }); // createSearchForm    

       /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */ 

    var masterGrid = Unilite.createGrid('cmb200skrvGrid', {
    	region:'center',
    	layout : 'fit',
    	padding: '0 5 5 5',
    	tbar: ['->',
       		 {
            	itemId : 'cmb200Btn', iconCls : 'icon-link'	,
        		text:' 영업기회정보',
        		handler: function() {
	        		var record = masterGrid.getSelectedRecord();
	        		var params = {
						'projectNo' : record.get('PROJECT_NO')
					}
					var rec = {data : {prgID : 'cmb200ukrv', 'text':''}};							
					parent.openTab(rec, '/cm/cmb200ukrv.do', params);							
        		}        			
       		 },
       		 {
            	itemId : 'cmb210Btn', iconCls : 'icon-link'	,
        		text:' 영업기회세부정보',
        		handler: function() {
        					var record = masterGrid.getSelectedRecord();
	        				if(record.get('DOC_NO') =='' )	{
								if((record.data['SUMMARY_STR']+record.data['PLAN_TARGET']+record.data['ITEM_NAME']).trim() == '' )	{
									alert('해당 영업기회로 진행된 내역이 없습니다.');
								}else {
									var params = {
										projectNo : record.get('PROJECT_NO')
									}
									var rec = {data : {prgID : 'cmb210skrv', 'text':'test'}};									
									parent.openTab(rec, '/cm/cmb210skrv.do', params);
								}
							}else {
								var record = masterGird.getSelecedRecord();
								var params = {
									DOC_ID : record.get('DOC_NO'),
									PLAN_DATE : record.get('PLAN_DATE')									
								}
								var width=850;
						    	var height=600;
						    	
						    	var sParam = UniUtils.param(params);
						    	var features = "help:0;scroll:0;status:0;center:true;" +
							            ";dialogWidth="+width +"px" +
							            ";dialogHeight="+height+"px" ;
							    var url = '<c:url value="/cm/cmd100ukrv.do" />';
							    var rv = window.showModalDialog(url+'?'+sParam, params, features);
							}
							
        			}
       		 }
        	
        	],
        store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false, dock:''} ],
        columns:  [        	    	
					{ dataIndex: 'CUSTOM_CODE'		,width: 80	,hidden:true},    	
					{ dataIndex: 'CUSTOM_NAME'		,width: 120, filter: {type: 'uniList'},  isLink:true},    	
					//,{ dataIndex: 'DVRY_CUST_NM'	,width: 120, locked:true}    	
					{ dataIndex: 'PROJECT_NAME'	,width: 250, isLink:true, locked:true, 
		              summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    },
		             	filter: {type: 'string'}},    	
					{ dataIndex: 'PROJECT_TYPE'	,width: 90, filter: {type: 'uniList'}},   	
					{ dataIndex: 'SALE_EMP'		,width: 90, filter: {type: 'uniList'}},    			
					{ dataIndex: 'RESULT_DATE'		,width: 90, filter: {type: 'date'} },    	
					{ dataIndex: 'TARGET_DATE'		,width: 90, filter: {type: 'date'} },    	    	
					{ dataIndex: 'MONTH_QUANTITY'	,width: 90 , summaryType:'sum', filter:{type: 'numeric'}},    
					{ dataIndex: 'PURCHASE_AMT'	,width: 100},
	        		{ dataIndex: 'MARGIN_AMT'		,width: 100},
	        		{ dataIndex: 'MARGIN_RATE'		,width: 100},
	        		{ dataIndex: 'SALES_PROJECTION',width: 100},
					{ dataIndex: 'CURRENT_DD'		,width: 120},    		
					{ dataIndex: 'SALE_STATUS_NM'		,width: 100, filter: {type: 'uniList'}},  	
					{ dataIndex: 'SUMMARY_STR'	,width: 180,  tooltip:true, isLink:true }, 	
					{ dataIndex: 'PLAN_TARGET'		,width: 200},   
					{ dataIndex: 'EXPECTED_ORDER'  ,width: 100 },
					{ dataIndex: 'ITEM_NAME'		,width: 110},   		
					{ dataIndex: 'PROJECT_NO'		,width: 100, hidden:true},    		
					{ dataIndex: 'CLIENT_NAME'		,width: 80}  
				
          ] ,
          listeners: {
          	  itemcontextmenu:function( grid, record, item, index, event, eOpts )	{
          	  		event.stopEvent();
					contextMenu.projectNo = record.get("PROJECT_NO");
					contextMenu.docNo = record.get("DOC_NO");
					contextMenu.customCode = record.get("CUSTOM_CODE");
					contextMenu.planDate = record.get("PLAN_DATE");
					contextMenu.summaryStr = record.get("SUMMARY_STR");
					contextMenu.planTarget = record.get("PLAN_TARGET");
					contextMenu.itemName = record.get("ITEM_NAME");
					contextMenu.showAt(event.getXY());					
          	  },
	          onGridDblClick:function(grid, record, cellIndex, colName) {
          			switch(colName)	{
					case 'PROJECT_NAME' :
							var params = {
									'projectNo' : record.data['PROJECT_NO']
							}
							var rec = {data : {prgID : 'cmb200ukrv', 'text':''}};
							
							parent.openTab(rec, '/cm/cmb200ukrv.do', params);
							break;
					case 'SUMMARY_STR' :
							if(record.data['DOC_NO'] =='' )	{
								if((record.data['SUMMARY_STR']+record.data['PLAN_TARGET']+record.data['ITEM_NAME']).trim() == '' )	{
									alert('해당 영업기회로 진행된 내역이 없습니다.');
								}else {
									var params = {
										projectNo : record.data['PROJECT_NO']
									}
									var rec = {data : {prgID : 'cmb210skrv', 'text':'test'}};									
									parent.openTab(rec, '/cm/cmb210skrv.do', params);
								}
							}else {
								var params = {
									DOC_ID : record.data['DOC_NO'],
									PLAN_DATE : record.data['PLAN_DATE']									
								}
								var width=850;
						    	var height=600;
						    	
						    	var sParam = UniUtils.param(params);
						    	var features = "help:0;scroll:0;status:0;center:true;" +
							            ";dialogWidth="+width +"px" +
							            ";dialogHeight="+height+"px" ;
							    var url = '<c:url value="/cm/cmd100ukrv.do" />';
							    var rv = window.showModalDialog(url+'?'+sParam, params, features);
							}
							
							break;
					default:
							break;
          			}
	          } //onGridDblClick
          } //listeners
          
          
         
    });
    
    var contextMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '영업기회정보 보기',   iconCls : 'icon-link',
	                	handler: function(menuItem, event) {
	                		var t = menuItem.up('menu');
	                		var params = {
									'projectNo' : t.projectNo
							}
							var rec = {data : {prgID : 'cmb200ukrv', 'text':''}};
							
							parent.openTab(rec, '/cm/cmb200ukrv.do', params);
	                	}
	            	},{	text: '영업기회 건별 세부사항 보기',   iconCls : 'icon-link',
	                	handler: function(menuItem, event) {
	                		var t = menuItem.up('menu');
	                		if(t.docNo =='' )	{
								if((t.summaryStr+t.planTarget+t.itemName).trim() == '' )	{
									alert('해당 영업기회로 진행된 내역이 없습니다.');
								}else {
									var params = {
										projectNo : t.projectNo
									}
									var rec = {data : {prgID : 'cmb210skrv', 'text':''}};									
									parent.openTab(rec, '/cm/cmb210skrv.do', params);
								}
							}else {
								var params = {
									DOC_ID : t.docNo,
									PLAN_DATE : t.planDate									
								}
								var width=850;
						    	var height=600;
						    	
						    	var sParam = UniUtils.param(params);
						    	var features = "help:0;scroll:0;status:0;center:true;" +
							            ";dialogWidth="+width +"px" +
							            ";dialogHeight="+height+"px" ;
							    var url = '<c:url value="/cm/cmd100ukrv.do" />';
							    var rv = window.showModalDialog(url+'?'+sParam, params, features);
							}
	                	}
	            	}
	        	]
    	});
    	


    Unilite.Main( {
			 items:[ {
				  layout:'fit',
				  flex:1,
				  border:false,
				  items:[{
				  		layout:'border',
				  		defaults:{style:{padding: '5 5 5 5'}},
				  		border:false,
				  		items:[
				 		 masterGrid
						,panelSearch
						]}
					]
				}
		]
			,fnInitBinding:function()	{
				panelSearch.setValue('PROJECT_OPT','2');	
				UniAppManager.setToolbarButtons('excel',true);			
			}
			,onSaveAsExcelButtonDown: function() {
				var masterGrid = Ext.getCmp('cmb200skrvGrid');
				 masterGrid.downloadExcelXml();
			}
			,onQueryButtonDown:function () {
					var masterGrid = Ext.getCmp('cmb200skrvGrid');
					var param= Ext.getCmp('searchForm').getValues();
					masterGrid.getStore().load({params: param});
					var viewLocked = masterGrid.lockedGrid.getView();
					var viewNormal = masterGrid.normalGrid.getView();
					console.log("viewLocked : ",viewLocked);
					console.log("viewNormal : ",viewNormal);
				    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}
	}); // main
	Ext.define('chartModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'name', 'value']
	});
	var chartStore = new Ext.data.SimpleStore({
  		model:'chartModel'
	});
	
	var chart = Ext.create('Ext.chart.Chart', {
	        //xtype: 'chart',
	        animate: true,
	        store: chartStore,
	        shadow: true,
	        legend: {
	            position: 'right'
	        },
	        insetPadding: 60,
	        theme: 'Base:gradients',
	        series: [{
	            type: 'pie',
	            angleField: 'value',
	            showInLegend: true,
	            donut: 35,
	            tips: {
	                trackMouse: true,
	                renderer: function(storeItem, item) {
	                    //calculate percentage.
	                    //var total = 0;
	                    //this.store.each(function(rec) {
	                    //    total += rec.get('value');
	                    //});
	                    this.setTitle(storeItem.get('name') + ': ' + Ext.util.Format.number(storeItem.get('value'), '0,000'));
	                }
	            },
	            highlight: {
	                segment: {
	                    margin: 20
	                }
	            },
	            label: {
	                field: 'name',
	                display: 'rotate',
	                contrast: true,
	                font: '18px dotum'
	            }
	        }]
	    });
	/*
	var chart = Ext.create('Ext.chart.Chart', {
		    //renderTo: Ext.getBody(),
		    width: 500,
		    height: 350,
		    animate: true,
		    store: chartStore,
		    theme: 'Base:gradients',
		    series: [{
		        type: 'pie',
		        angleField: 'value',
		        showInLegend: true,
		        tips: {
		            trackMouse: true,
		            width: 140,
		            height: 28,
		            renderer: function(storeItem, item) {
		                // calculate and display percentage on hover
		                var total = 0;
		                store.each(function(rec) {
		                    total += rec.get('value');
		                });
		                this.setTitle(storeItem.get('name') + ': ' + Ext.util.Format.number(storeItem.get('value'), '0,000'));
		            }
		        },
		        highlight: {
		            segment: {
		                margin: 20
		            }
		        },
		        label: {
		            field: 'name',
		            display: 'rotate',
		            contrast: true,
		            font: '18px Arial'
		        }
		    }]
		});
	*/
    var panel1 = Ext.create('widget.window', {
	        width: 800,
	        height: 600,
	        model: true,
	        layout: 'fit',
	        items: [chart],
            closeAction: 'hide',
	        tbar: [
	        	{ 
		        	text: 'Reload Data',
		            handler: function() {
		                loadChartData();
		            }
	           }
	        ]
	    });
	    
	var btnChart = {
			xtype:'uniBaseButton',	iconCls: 'icon-chart',
			text : 'Chart',tooltip : 'Chart', disabled: false,
			width: 26, height: 26,
	 		itemId : 'chart',
			handler : function() {
				loadChartData();
			}
	};
	UniAppManager.addButton(btnChart);
	
	function loadChartData()	{
		chartStore.removeAll();
		//directMasterStore.each(function(rec) {
		Ext.each( directMasterStore.getGroups(), function(rec) {
                //total += rec.get('data1');
			var key = rec.name;
			var sum =0;
			Ext.Array.each(rec.children, function(sRec) {
				 console.log("sRec:", sRec);
					sum+= sRec.get('MONTH_QUANTITY');
			});
            chartStore.add({
            	name: key ,
            	value: sum
            });
            console.log("rec:", rec);
            console.log("name:", key, "value:",sum);
        });
        console.log("chartStore data:", chartStore.data);
		panel1.show() ;
			
	}
};
</script>

