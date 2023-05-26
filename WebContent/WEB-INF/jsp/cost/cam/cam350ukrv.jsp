<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam350ukrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var costPoolList = ${COST_POOL_LIST};
var compareWindow;	//합진비교

function appMain() {

	//모델 정의
	var cam350ModelFields = [
   		
   		{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string', editable:false},
   		{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type: 'string', editable:false},
    	{name: 'ACCNT'		    , text: '계정코드'    	, type: 'string', editable:false},
    	{name: 'ACCNT_NAME'		, text: '계정명'    		, type: 'string', editable:false}
    ];
    
	//모델 정의-cost center 추가
	cam350ModelFields.push({name: 'SUM_AMT'	, text: '합계'	, type: 'uniPrice'});
	Ext.each(costPoolList, function(item){
    	cam350ModelFields.push({name: "COST_POOL_"+item.COST_POOL_CODE	, text: item.COST_POOL_NAME	, type: 'uniPrice'});
    })
    
    var cam350ukrvModel = Unilite.defineModel('cam350ukrvModel', {
		fields: cam350ModelFields
   	});
   var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cam350ukrvService.selectList',
        	create  : 'cam350ukrvService.insert',
            update  : 'cam350ukrvService.update',
            syncAll : 'cam350ukrvService.saveAll'
		}
	 });
	//스토어 정의
	var cam350ukrvStore = Unilite.createStore('Store', {	
   		model: 'cam350ukrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
			editable: true,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function()	{
			if(!costPoolList || costPoolList.length == 0)	{
        		alert("등록된 부문이 없습니다.")
        		return;
        	} else {
        		var checkCnt = 0
        		Ext.each(costPoolList , function(item){
        			if(item.DIV_CODE == panelResult.getValue("DIV_CODE"))	{
        				checkCnt = 1;
        			}
        		})
        		if(checkCnt == 0)	{
        			alert("해당 사업장에 등록된 부문이 없습니다.")
        			return;
        		}
        	}
			var param = panelResult.getValues();	
			masterGrid.loadCostPoolColumns(panelResult.getValue("DIV_CODE"));
			console.log("param", param);
			this.load({
				params : param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {      
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			update:function(store, record, operation, modifiedFieldNames, details, eOpts ) {
				var sumAmt = 0;
				Ext.each(costPoolList, function(item){
			    	sumAmt += record.get( "COST_POOL_"+item.COST_POOL_CODE);
			    })
			    record.set("SUM_AMT", sumAmt);
			}
		}
   	});

	// Grid 정의
	var masterGridColumns = [
		{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
    	{dataIndex: 'WORK_MONTH'	, width: 100, hidden: true},
     	{dataIndex: 'ACCNT'		    , width: 100},
     	{dataIndex: 'ACCNT_NAME'	, width: 250, 
     	  summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
     	 }}
	];
	var excelImportColumns = [];
	 
	// Grid 정의-cost center 추가
    Ext.each(costPoolList, function(item){
    	masterGridColumns.push({dataIndex: "COST_POOL_"+item.COST_POOL_CODE	, width: 130, summaryType: 'sum'});
    	excelImportColumns.push("COST_POOL_"+item.COST_POOL_CODE);
    })
	masterGridColumns.push({dataIndex:'SUM_AMT'	, width: 120, summaryType: 'sum'});
	
    var masterGrid = Unilite.createGrid('cam350ukrvGrid', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			
			importData :{	// 엑셀에서 복사한 내용 붙여넣기 설정	
				useData :true, 
				configId: "",
				createOption: "customFn",
				columns : excelImportColumns
			},
			
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        
        tbar: [{
			itemId: 'compareBtn',
			text: '<div style="color: blue">합잔비교</div>',
			handler: function() {
				openCompareWindow();
				}
		},'-', {
			itemId: 'totalBtn',
			text: '<div style="color: blue">전표집계 가져오기</div>',
			handler: function() {
				if(!panelSearch.getInvalidMessage()) return;    //필수체크
				
				if(confirm('기존자료는 삭제됩니다.')) {
					var param = panelSearch.getValues();
						Ext.getBody().mask('실행중...','loading-indicator');
						cam350ukrvService.executeProcessAccntSum(param, 
							function(provider, response) {
								if(provider) {	
									UniAppManager.updateStatus("전표집계가 완료되었습니다.");
								}
								console.log("response",response)
								Ext.getBody().unmask();
							}
						)
					}
				}
		}],
		
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam350ukrvStore,
        columns: masterGridColumns,
        listeners:{
        	render:function(grid){
        		this.loadCostPoolColumns(UserInfo.divCode);
        	}	
        },
		loadCostPoolColumns:function(divCode)	{
			var me = this;
			Ext.each(costPoolList, function(item){
				if(item.DIV_CODE == divCode )	{
					me.getColumn("COST_POOL_"+item.COST_POOL_CODE).show();
				} else {
					me.getColumn("COST_POOL_"+item.COST_POOL_CODE).hide();
				}
		    })
			
		},
		//엑셀 붙여넣기
		loadImportData:function(dataList) {
			var me = this;
			//var cnrcYear = panelResult.getValue('CNRC_YEAR');
			//var meritsYear = panelResult.getValue('MERITS_YEARS');
			var itemArray = [];
			
			var masterRecords = cam350ukrvStore.data.items;
			
			var lLoop = 0;
			
			if(dataList.length > 0) {
				for(var iLoop in dataList) {
					if(masterRecords.length > iLoop) {
						var data = dataList[iLoop];
						var record = masterRecords[iLoop];
						
						Ext.each(excelImportColumns, function(column) {
							record.set(column, data[column]);
						});
					}
				}
			}		
			
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
           	layout: {type: 'uniTable', columns: 2},
           	defaultType: 'uniTextfield',
			items: [{
				name: 'DIV_CODE', 
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value: UserInfo.divCode,
				hidden: false,
				colspan: 2,
				allowBlank: false,
				maxLength: 20,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				name: 'WORK_MONTH',
				fieldLabel: '기준월',
				xtype: 'uniMonthfield',
				value:UniDate.get('startOfMonth'),
				hidden: false,
				colspan:2,
				allowBlank:false,
				maxLength: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_MONTH', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
  	
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
				//	this.mask();		    
   				}
	  		} else {
 					this.unmask();
 			}
			return r;
 		}
	});	

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout: {type: 'uniTable', columns: 4},
		padding: '1 1 1 1',
		border: true,
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value:UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20,
      		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
        }, {
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200,
       		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_MONTH', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
  	
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
				//	this.mask();		    
   				}
	  		} else {
 					this.unmask();
 			}
			return r;
 		}
    });		

    Unilite.Main( {
		id: 'cam350ukrvApp',
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("WORK_MONTH",param.WORK_MONTH);
			}
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown: function () {
			cam350ukrvStore.saveStore();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
		}
	});
	
	//합진비교
    function openCompareWindow() {
        if(!panelSearch.getInvalidMessage()) return;    //필수체크
        
        if(!compareWindow) {
            compareWindow = Ext.create('widget.uniDetailWindow', {
                title: '합잔비교',
                width: 700,                             
                height: 380,
                layout:{type:'vbox', align:'stretch'},             
                items: [compareSearch, CompareGrid], 

                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.product.inquiry" default="조회"/>',
                        handler: function() {
                            compareStore.loadStoreRecords();
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.product.close" default="닫기"/>',
                        handler: function() {
                            compareWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        compareSearch.clearForm();                                          
                    },
                    beforeclose: function( panel, eOpts )   {
                        compareSearch.clearForm();
                    }
                    ,
                    beforeshow: function( panel, eOpts )  {
                        compareSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                        compareSearch.setValue('WORK_MONTH', panelResult.getValue('WORK_MONTH'));       
                        

                    }
                }       
            })
        }
        compareWindow.show();
        compareWindow.center();
        
        compareStore.loadStoreRecords();
	    }
	    
    //합잔비교 팝업 정의
	 var compareSearch = Unilite.createSearchForm('productionForm', {
            layout :  {type : 'uniTable', columns : 3},
            items: [{
				name: 'DIV_CODE', 
				fieldLabel: '사업장',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value: UserInfo.divCode,
				hidden: false,
				readOnly     : true,
				allowBlank: false,
				maxLength: 20
			}, {
				name: 'WORK_MONTH',
				fieldLabel: '기준월',
				xtype: 'uniMonthfield',
				value:UniDate.get('startOfMonth'),
				hidden: false,
				readOnly     : true,
				allowBlank:false,
				maxLength: 200
			},{
				fieldLabel: ' ',
				name: 'SHOW_DIFF_YN',
				xtype: 'checkbox',
				labelWidth: 100,
				boxLabel: '차액',
				handler: function(field, newValue, oldValue, eOpts) {
					var bYN = (newValue ? true : false);
					var idxDiffAmt = CompareGrid.getColumnIndex('DIFF_AMT');
					
					if(bYN) {
						CompareGrid.columns[idxDiffAmt].show();
					}
					else {
						CompareGrid.columns[idxDiffAmt].hide();
					}
				}
			}]
    });
    

    //합잔비교 팝업 모델 정의
	Unilite.defineModel('cam350ukrvCompareModel', {
	    fields: [{name: 'ACCNT'     	,text: '계정코드'		, type: 'string'},
				 {name: 'ACCNT_NAME'    ,text: '계정과목명'	, type: 'string'},
				 {name: 'COST_AMT'      ,text: '금액'			, type: 'uniPrice'},
				 {name: 'SLIP_AMT'      ,text: '시산표금액'	, type: 'uniPrice'},
				 {name: 'DIFF_AMT'      ,text: '차이금액'	, type: 'uniPrice'}
		]
	});
    
    var compareStore = Unilite.createStore('cam350ukrvCompareStore', {
			model: 'cam350ukrvCompareModel',
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
                	read    : 'cam350ukrvService.selectCompare'
                }
            },
            
/*            listeners:{
            	load:function(store, records, successful, eOpts)	{
            			if(successful)	{
            			   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
            			   var estiRecords = new Array();
            			   
            			   if(masterRecords.items.length > 0)	{
            			   	console.log("store.items :", store.items);
            			   	console.log("records", records);
            			   	
	            			   Ext.each(records, 
	            			   			function(item, i)	{           			   								
			   								Ext.each(masterRecords.items, function(record, i)	{
			   										console.log("record :", record);
			   										
			   										if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM']) 
			   											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
			   											)	
			   										{
			   												estiRecords.push(item);
			   										}
			   								});
	            			   								
	            			   			});
	            			   store.remove(estiRecords);
            			   }
            			}
            	}
            },*/
            
            loadStoreRecords : function()	{
				var param= compareSearch.getValues();
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	//합잔비교 팝업 그리드 정의
	var CompareGrid = Unilite.createGrid('cam350ukrvCompareGrid', {
		// title: '기본',
		layout : 'fit',
		store: compareStore,
		//selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
			expandLastColumn: false,
			onLoadSelectFirst : false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{ dataIndex: 'ACCNT'         ,  width: 100},
			{ dataIndex: 'ACCNT_NAME'    ,  width: 150},
			{ dataIndex: 'COST_AMT'      ,  width: 120 ,align:'right'	, summaryType: 'sum'},
			{ dataIndex: 'SLIP_AMT'      ,  width: 120 ,align:'right'	, summaryType: 'sum'},
			{ dataIndex: 'DIFF_AMT'      ,  width: 120 ,align:'right'	, summaryType: 'sum'	, hidden:true}
		]
/*       ,listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {
  				}
       		}
       	,returnData: function()	{
       		var records = this.getSelectedRecords();
       		
			Ext.each(records, function(record,i){	
							        	UniAppManager.app.onNewDataButtonDown();
							        	detailGrid.setEstiData(record.data);								        
								    }); 
			//this.deleteSelectedRow();
			this.getStore().remove(records);
       	} */ 
	});
	
};
</script>