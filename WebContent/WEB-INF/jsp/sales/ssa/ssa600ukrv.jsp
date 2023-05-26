<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa600ukrv"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsMoneyUnit:		'${gsMoneyUnit}'
};

/*var output =''; 
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	Unilite.messageBox(output);*/

var excelWindow;	// 엑셀참조
var outDivCode = UserInfo.divCode;
var query02Load = "1";

function appMain() { 
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ssa600ukrvService.selectList',
			//update: 'ssa600ukrvService.updateDetail',
			create: 'ssa600ukrvService.insertDetail',
			destroy: 'ssa600ukrvService.deleteDetail',
			syncAll: 'ssa600ukrvService.saveAll'
		}
	});
	
		var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
	 		    xtype: 'uniDateRangefield',
	            startFieldName: 'FR_SALE_DATE',
	            endFieldName: 'TO_SALE_DATE',
	            allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_SALE_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_SALE_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '매장',
				name:'STORE_CODE',				
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'YP43',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {					
						panelResult.setValue('STORE_CODE', newValue);
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
	    items :[{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{ 
					fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
		 		    width: 315,
		            xtype: 'uniDateRangefield',
		            startFieldName: 'FR_SALE_DATE',
		            endFieldName: 'TO_SALE_DATE',
		            allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelSearch.setValue('FR_SALE_DATE',newValue);
		            	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('TO_SALE_DATE',newValue);
				    	}
				    }
		     	},{
					fieldLabel: '매장',
					name:'STORE_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'YP43',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {					
							panelSearch.setValue('STORE_CODE', newValue);
						}
					}
				}
			]}
		],
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

	//ssa600ukrvs1 Model
	Unilite.defineModel('ssa600ukrvs1Model', {		// 메인
	    fields: [
	    	{name: 'STORE_CODE' 		,text:'매장코드'		,type: 'string', alowBlank: false},
	    	{name: 'SALE_DATE' 		 	,text:'<t:message code="system.label.sales.salesdate" default="매출일"/>'		,type: 'uniDate', alowBlank: false},
	    	{name: 'DAY_WEEK' 		 	,text:'요일'			,type: 'string'},
	    	{name: 'SALE_CNT' 		 	,text:'객수'			,type: 'uniQty'},
	    	{name: 'SALE_AMT_O' 		,text:'순매출'		,type: 'uniPrice'},
	    	{name: 'TAX_AMT_O' 		 	,text:'<t:message code="system.label.sales.vat" default="부가세"/>'		,type: 'uniPrice'},
	    	{name: 'DISCOUNT_O' 		,text:'<t:message code="system.label.sales.discount" default="할인"/>'			,type: 'uniPrice'},
	    	{name: 'COUPON' 		 	,text:'쿠폰'			,type: 'uniPrice'},
	    	{name: 'TOTAL_AMT_O' 		,text:'총매출'		,type: 'uniPrice'},
	    	{name: 'CONSIGNMENT_O' 		,text:'수수료'		,type: 'uniPrice'},
	    	{name: 'REMARK' 		 	,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}
		]
	});
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.ssa600.sheet01', {
	    fields: [
	    	{name: 'STORE_CODE' 		,text:'매장코드'		,type: 'string'},
	    	{name: 'SALE_DATE' 		 	,text:'<t:message code="system.label.sales.salesdate" default="매출일"/>'		,type: 'uniDate'},
	    	{name: 'DAY_WEEK' 		 	,text:'요일'			,type: 'string'},
	    	{name: 'SALE_CNT' 		 	,text:'객수'			,type: 'uniQty'},
	    	{name: 'SALE_AMT_O' 		,text:'순매출'		,type: 'uniPrice'},
	    	{name: 'TAX_AMT_O' 		 	,text:'<t:message code="system.label.sales.vat" default="부가세"/>'		,type: 'uniPrice'},
	    	{name: 'DISCOUNT_O' 		,text:'<t:message code="system.label.sales.discount" default="할인"/>'			,type: 'uniPrice'},
	    	{name: 'COUPON' 		 	,text:'쿠폰'			,type: 'uniPrice'},
	    	{name: 'TOTAL_AMT_O' 		,text:'총매출'		,type: 'uniPrice'},
	    	{name: 'CONSIGNMENT_O' 		,text:'수수료'		,type: 'uniPrice'},
	    	{name: 'REMARK' 		 	,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}	 
		]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'ssa600',
                		/*extParam: { 
                			'DIV_CODE': panelSearch.getValue('DIV_CODE'),
                			'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')
                		},*/
                        grids: [{
                        		itemId: 'grid01',
                        		title: '백양로 매출',                        		
                        		useCheckbox: false,
                        		model : 'excel.ssa600.sheet01',
                        		readApi: 'ssa600ukrvService.selectExcelUploadSheet1',
                        		columns: [
                        			{dataIndex: 'STORE_CODE' 	 		, 		width: 80},    
                        			{dataIndex: 'SALE_DATE' 		 	, 		width: 80},    
                        			{dataIndex: 'DAY_WEEK' 		 		, 		width: 80},    
                        			{dataIndex: 'SALE_CNT' 		 		, 		width: 80},    
                        			{dataIndex: 'SALE_AMT_O' 	 		, 		width: 110},   
                        			{dataIndex: 'TAX_AMT_O' 		 	, 		width: 110},   
                        			{dataIndex: 'DISCOUNT_O' 	 		, 		width: 110},   
                        			{dataIndex: 'COUPON' 		 		, 		width: 110},   
                        			{dataIndex: 'TOTAL_AMT_O' 	 		, 		width: 110},   
                        			{dataIndex: 'CONSIGNMENT_O' 	 	, 		width: 110},   
                        			{dataIndex: 'REMARK' 		 		, 		width: 160}    
                        		]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							/*excelWindow.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							ssa600ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	var countDate = UniDate.getDbDateStr(panelSearch.getValue('COUNT_DATE')).substring(0, 6);
								var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);              
								for(var i=0; i<records.length; i++) { 
									records[i].BASIS_YYYYMM = monthDate;                                                
								} 
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });*/
                        	
                        	excelWindow.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							ssa600ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	//directMasterStore
	var directMasterStore = Unilite.createStore('ssa600ukrvMasterStore1',{		// 메인
			model: 'ssa600ukrvs1Model',
            uniOpt : {
            	isMaster: true,		// 상위 버튼 연결 
   	 			editable: true,		// 수정 모드 사용 
            	deletable: true,	// 삭제 가능 여부 
	        	useNavi : false		// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy1,
			loadStoreRecords: function(provider, response) {
				var param= panelSearch.getValues();	
				console.log(param);
				this.load({
					params : param
				});
			},
            saveStore: function() {	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {	
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});	// End of var directMasterStore1 
		
    var masterGrid = Unilite.createGrid('ssa600ukrvGrid', {		
		layout : 'fit',
        region:'center',
    	uniOpt: {
			expandLastColumn: false,
		 	useRowNumberer: true,
		 	useContextMenu: true
        },
        margin: 0,
         tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '<t:message code="system.label.sales.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        	openExcelWindow();
			        }
				}]
			})
		}],
        store: directMasterStore,
        features: [ 
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],
		columns: [
			{dataIndex: 'STORE_CODE' 	 		 	, 		width: 80},
			{dataIndex: 'SALE_DATE' 		 		, 		width: 80},
			{dataIndex: 'DAY_WEEK' 		 		 	, 		width: 80},
			{dataIndex: 'SALE_CNT' 		 		 	, 		width: 80},
			{dataIndex: 'SALE_AMT_O' 	 		 	, 		width: 110},
			{dataIndex: 'TAX_AMT_O' 		 		, 		width: 110},
			{dataIndex: 'DISCOUNT_O' 	 		 	, 		width: 110},
			{dataIndex: 'COUPON' 		 		 	, 		width: 110},
			{dataIndex: 'TOTAL_AMT_O' 	 		 	, 		width: 110},
			{dataIndex: 'CONSIGNMENT_O' 	 		, 		width: 110},
			{dataIndex: 'REMARK' 		 		 	, 		width: 160}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {	
	        	if(UniUtils.indexOf(e.field, ['STORE_CODE','SALE_DATE','DAY_WEEK','SALE_CNT','SALE_AMT_O','TAX_AMT_O','DISCOUNT_O','COUPON','TOTAL_AMT_O','CONSIGNMENT_O','REMARK'])) {                                      
					return false;                       
  				}                                         
	        }
		}
    });	//End of var masterGrid = Unilite.createGrid('ssa600ukrvGrid1', { 
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],  
		id : 'ssa600ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('FR_SALE_DATE',UniDate.get('today'));
			panelSearch.setValue('TO_SALE_DATE',UniDate.get('endOfMonth'));
			panelResult.setValue('FR_SALE_DATE',UniDate.get('today'));
			panelResult.setValue('TO_SALE_DATE',UniDate.get('endOfMonth'));			
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
//			UniAppManager.setToolbarButtons(['query'], false);
			this.setDefault();
		},
		setDefault: function() {		// 기본값                 
         	UniAppManager.setToolbarButtons('save', false); 
		},
		onQueryButtonDown: function()	{
			var param= panelSearch.getValues();
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);  
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterGrid.reset();
			this.fnInitBinding();
			directMasterStore.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function()	{		// 삭제
			if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');   
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {
	
};
</script>
