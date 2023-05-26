<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="opo300skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 */
	Unilite.defineModel('Opo300skrvModel', {
	    fields: [  	
	    	{name: 'ITEM_CODE',			text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',	type:'string'},
	    	{name: 'ITEM_NAME',			text:'<t:message code="system.label.purchase.itemname" default="품목명"/>',		type:'string'},
	    	{name: 'SPEC',				text:'<t:message code="system.label.purchase.spec" default="규격"/>',		type:'string'},
	    	{name: 'CUSTOM_CODE',		text:'<t:message code="system.label.purchase.custom" default="거래처"/>',		type:'string'},
	    	{name: 'CUSTOM_NAME',		text:'<t:message code="system.label.purchase.custom" default="거래처"/>',		type:'string'},
	    	{name: 'ORDER_TYPE',		text:'<t:message code="system.label.purchase.potype" default="발주형태"/>',	type:'string',comboType: "AU", comboCode: "M001"},
	    	{name: 'ORDER_DATE',		text:'<t:message code="system.label.purchase.podate" default="발주일"/>',		type:'uniDate'},
	    	{name: 'STOCK_UNIT',		text:'<t:message code="system.label.purchase.unit" default="단위"/>',		type:'string'},
	    	{name: 'DVRY_DATE',			text:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>',		type:'uniDate'},
	    	{name: 'ORDER_Q',			text:'<t:message code="system.label.purchase.poqty" default="발주량"/>',		type:'uniQty'},
	    	{name: 'MONEY_UNIT',		text:'<t:message code="system.label.purchase.currency" default="화폐"/>',		type:'string'},
	    	{name: 'ORDER_P',			text:'<t:message code="system.label.purchase.price" default="단가"/>',		type:'uniUnitPrice'},
	    	{name: 'ORDER_O',			text:'<t:message code="system.label.purchase.amount" default="금액"/>',		type:'uniPrice'},
	    	{name: 'INSTOCK_Q',			text:'<t:message code="system.label.purchase.receiptqty" default="입고량"/>',		type:'uniQty'},
	    	{name: 'UN_Q',				text:'<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>',		type:'uniQty'},
	    	{name: 'ORDER_PRSN',		text:'<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',	type:'string',comboType: "AU", comboCode: "M021"},
	    	{name: 'ORDER_NUM',			text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',	type:'string'},
	    	{name: 'CONTROL_STATUS',	text:'<t:message code="system.label.purchase.processstatus" default="진행상태"/>',	type:'string',comboType: "AU", comboCode: "M002"},
	    	{name: 'ORDER_REQ_NUM',		text:'<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>',type:'string'},
	    	{name: 'UNIT_PRICE_TYPE',	text:'<t:message code="system.label.purchase.pricetype" default="단가형태"/>',	type:'string',comboType: "AU", comboCode: "M301"},
	    	{name: 'AGREE_STATUS',		text:'<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',	type:'string',comboType: "AU", comboCode: "M007"},
	    	{name: 'AGREE_PRSN',		text:'<t:message code="system.label.purchase.approvaluser" default="승인자"/>',		type:'string'},
	    	{name: 'REMARK',			text:'<t:message code="system.label.purchase.remarks" default="비고"/>',		type:'string'},
	    	{name: 'PROJECT_NO',		text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type:'string'} 	    						
			]
	});
	
	Unilite.defineModel('Opo300skrvModel2', {
	    fields: [  	
	    	{name: 'CUSTOM_CODE',		text:'<t:message code="system.label.purchase.custom" default="거래처"/>',		type:'string'},
	    	{name: 'CUSTOM_NAME',		text:'<t:message code="system.label.purchase.custom" default="거래처"/>',		type:'string'},
	    	{name: 'ITEM_CODE',			text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',	type:'string'},
	    	{name: 'ITEM_NAME',			text:'<t:message code="system.label.purchase.itemname" default="품목명"/>',		type:'string'},
	    	{name: 'SPEC',				text:'<t:message code="system.label.purchase.spec" default="규격"/>',		type:'string'},
	    	{name: 'ORDER_TYPE',		text:'<t:message code="system.label.purchase.potype" default="발주형태"/>',	type:'string',comboType: "AU", comboCode: "M001"},
	    	{name: 'ORDER_DATE',		text:'<t:message code="system.label.purchase.podate" default="발주일"/>',		type:'uniDate'},
	    	{name: 'STOCK_UNIT',		text:'<t:message code="system.label.purchase.unit" default="단위"/>',		type:'string'},
	    	{name: 'DVRY_DATE',			text:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>',		type:'uniDate'},
	    	{name: 'ORDER_Q',			text:'<t:message code="system.label.purchase.poqty" default="발주량"/>',		type:'uniQty'},
	    	{name: 'MONEY_UNIT',		text:'<t:message code="system.label.purchase.currency" default="화폐"/>',		type:'string'},
	    	{name: 'ORDER_P',			text:'<t:message code="system.label.purchase.price" default="단가"/>',		type:'uniUnitPrice'},
	    	{name: 'ORDER_O',			text:'<t:message code="system.label.purchase.amount" default="금액"/>',		type:'uniPrice'},
	    	{name: 'INSTOCK_Q',			text:'<t:message code="system.label.purchase.receiptqty" default="입고량"/>',		type:'uniQty'},
	    	{name: 'UN_Q',				text:'<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>',		type:'uniQty'},
	    	{name: 'ORDER_PRSN',		text:'<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',	type:'string',comboType: "AU", comboCode: "M021"},
	    	{name: 'ORDER_NUM',			text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',	type:'string'},
	    	{name: 'CONTROL_STATUS',	text:'<t:message code="system.label.purchase.processstatus" default="진행상태"/>',	type:'string',comboType: "AU", comboCode: "M002"},
	    	{name: 'ORDER_REQ_NUM',		text:'<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>',type:'string'},
	    	{name: 'UNIT_PRICE_TYPE',	text:'<t:message code="system.label.purchase.pricetype" default="단가형태"/>',	type:'string',comboType: "AU", comboCode: "M301"},
	    	{name: 'AGREE_STATUS',		text:'<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',	type:'string',comboType: "AU", comboCode: "M007"},
	    	{name: 'AGREE_PRSN',		text:'<t:message code="system.label.purchase.approvaluser" default="승인자"/>',		type:'string'},
	    	{name: 'REMARK',			text:'<t:message code="system.label.purchase.remarks" default="비고"/>',		type:'string'},
	    	{name: 'PROJECT_NO',		text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type:'string'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 */					
	var directMasterStore1 = Unilite.createStore('opo300skrvMasterStore1',{
			model: 'Opo300skrvModel',
			uniOpt : {
            	isMaster  : true,			// 상위 버튼 연결 
            	editable  : false,			// 수정 모드 사용 
            	deletable : false,			// 삭제 가능 여부 
	            useNavi   : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                    read: 'opo300skrvService.selectList'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				this.load({params : param});
			},
			groupField: 'ITEM_CODE'
	});
	
	var directMasterStore2 = Unilite.createStore('opo300skrvMasterStore2',{
			model: 'Opo300skrvModel2',
			uniOpt : {
            	isMaster  : true,			// 상위 버튼 연결 
            	editable  : false,			// 수정 모드 사용 
            	deletable : false,			// 삭제 가능 여부 
	            useNavi   : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	read: 'opo300skrvService.selectList2'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				this.load({params : param});
			},
			groupField: 'CUSTOM_CODE'
	});

	/**
	 * 검색조건 (Search Panel)
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        width:390,
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
           	items : [{	
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_ORDER_DATE',
	        	endFieldName: 'TO_ORDER_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	width:315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_ORDER_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_ORDER_DATE',newValue);
			    	}
			    }
	     	}]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[
            		Unilite.popup('CUST', { 
						fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
						valueFieldName: 'FR_CUSTOM_CODE', 
						textFieldName: 'FR_CUSTOM_NAME', 
						textFieldWidth: 170, 
						validateBlank: false, 
						popupWidth: 710
					}),
					Unilite.popup('CUST', { 
						fieldLabel: '~', 
						valueFieldName: 'TO_CUSTOM_CODE', 
						textFieldName: 'TO_CUSTOM_NAME', 
						textFieldWidth: 170, 
						validateBlank: false, 
						popupWidth: 710
					}),
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
						valueFieldName: 'FR_ITEM_CODE', 
						textFieldName: 'FR_ITEM_NAME', 
						textFieldWidth: 170, 
						validateBlank: false, 
						popupWidth: 710
					}),
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '~', 
						valueFieldName: 'TO_ITEM_CODE', 
						textFieldName: 'TO_ITEM_NAME', 
						textFieldWidth: 170, 
						validateBlank: false, 
						popupWidth: 710
					}),
			{
                fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DVRY_DATE',
                endFieldName: 'TO_DVRY_DATE',
                width:315
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
				name: 'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'M007'
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name: 'CONTROL_STATUS' ,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M002'
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+'<t:message code="system.label.purchase.required" default="은(는) 필수입력 사항입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{	
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_ORDER_DATE',
	        	endFieldName: 'TO_ORDER_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	width:315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_ORDER_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_ORDER_DATE',newValue);
			    	}
			    }
	     	}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     */  
    var masterGrid = Unilite.createGrid('opo300skrvGrid1', {
        layout : 'fit',
        region:'center',
        title: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter : false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
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
    	store: directMasterStore1,
        columns:  [  
        	{ dataIndex: 'ITEM_CODE',      			width:120, locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemsubtotal" default="품목소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'ITEM_NAME',      			width:180, locked : true },
        	{ dataIndex: 'SPEC',      				width:153 },
        	{ dataIndex: 'CUSTOM_CODE',      		width:80, hidden : true },
        	{ dataIndex: 'CUSTOM_NAME',      		width:146 },
        	{ dataIndex: 'ORDER_TYPE',      		width:106 },
        	{ dataIndex: 'ORDER_DATE',      		width:80 },
        	{ dataIndex: 'STOCK_UNIT',      		width:53 },
        	{ dataIndex: 'DVRY_DATE',      			width:80 },
        	{ dataIndex: 'ORDER_Q',      			width:110 ,summaryType:'sum'},
        	{ dataIndex: 'MONEY_UNIT',      		width:66 },
        	{ dataIndex: 'ORDER_P',      			width:133 },
        	{ dataIndex: 'ORDER_O',      			width:133 ,summaryType:'sum'},
        	{ dataIndex: 'INSTOCK_Q',      			width:110 ,summaryType:'sum'},
        	{ dataIndex: 'UN_Q',      				width:110 ,summaryType:'sum'},
        	{ dataIndex: 'ORDER_PRSN',      		width:93 },
        	{ dataIndex: 'ORDER_NUM',      			width:106 },
        	{ dataIndex: 'CONTROL_STATUS',      	width:66 },
        	{ dataIndex: 'ORDER_REQ_NUM',      		width:120 },
        	{ dataIndex: 'UNIT_PRICE_TYPE',      	width:66 },
        	{ dataIndex: 'AGREE_STATUS',      		width:66 },
        	{ dataIndex: 'AGREE_PRSN',      		width:66 },
        	{ dataIndex: 'REMARK',      			width:133 },
        	{ dataIndex: 'PROJECT_NO',      		width:133 } 				                                                                                  
          ] 
    });
    
    var masterGrid2 = Unilite.createGrid('opo300skrvGrid2', {
        layout : 'fit',
        region:'center',
        title: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
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
    	store: directMasterStore2,
        columns:  [  
        	{ dataIndex: 'CUSTOM_CODE',      		width:80  , locked : true, hidden : true},
        	{ dataIndex: 'CUSTOM_NAME',      		width:146 , locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customsubtotal" default="거래처소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'ITEM_CODE',      			width:120 , locked : true},
        	{ dataIndex: 'ITEM_NAME',      			width:153 , locked : true},
        	{ dataIndex: 'SPEC',      				width:153 },
        	{ dataIndex: 'ORDER_TYPE',      		width:106 },
        	{ dataIndex: 'ORDER_DATE',      		width:80  },
        	{ dataIndex: 'STOCK_UNIT',      		width:53  },
        	{ dataIndex: 'DVRY_DATE',      			width:80  },
        	{ dataIndex: 'ORDER_Q',      			width:110 ,summaryType:'sum'},
        	{ dataIndex: 'MONEY_UNIT',      		width:66  },
        	{ dataIndex: 'ORDER_P',      			width:133 },
        	{ dataIndex: 'ORDER_O',      			width:133 ,summaryType:'sum'},
        	{ dataIndex: 'INSTOCK_Q',      			width:110 ,summaryType:'sum'},
        	{ dataIndex: 'UN_Q',      				width:110 ,summaryType:'sum'},
        	{ dataIndex: 'ORDER_PRSN',      		width:93  },
        	{ dataIndex: 'ORDER_NUM',      			width:106 },
        	{ dataIndex: 'CONTROL_STATUS',      	width:66  },
        	{ dataIndex: 'ORDER_REQ_NUM',      		width:86  },
        	{ dataIndex: 'UNIT_PRICE_TYPE',      	width:66  },
        	{ dataIndex: 'AGREE_STATUS',      		width:66  },
        	{ dataIndex: 'AGREE_PRSN',      		width:66  },
        	{ dataIndex: 'REMARK',      			width:133 },
        	{ dataIndex: 'PROJECT_NO',      		width:133 } 				                                                                                  
          ] 
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid, masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'opo300skrvGrid1':
						break;
					case 'opo300skrvGrid2':
						break;
					default:
						break;
				}
	     	}
	     }
	});
	
	
    Unilite.Main( {
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
		panelSearch
		],	
		id  : 'opo300skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_ORDER_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_ORDER_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_ORDER_DATE',UniDate.get('today'));
			panelResult.setValue('TO_ORDER_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'opo300skrvGrid1'){
				if(!UniAppManager.app.checkForNewDetail()){
				   return false;
			    }else{
			        masterGrid.getStore().loadStoreRecords();
			        var viewLocked = masterGrid.lockedGrid.getView();
			        var viewNormal = masterGrid.normalGrid.getView();
		            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			        UniAppManager.setToolbarButtons('excel',true);
			    }
			}else if(activeTabId == 'opo300skrvGrid2'){
				if(!UniAppManager.app.checkForNewDetail()){
				   return false;
			    }else{
			        masterGrid2.getStore().loadStoreRecords();
			        var viewLocked = masterGrid2.lockedGrid.getView();
			        var viewNormal = masterGrid2.normalGrid.getView();
		            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			        UniAppManager.setToolbarButtons('excel',true);
			    }
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid2.reset();
        	masterGrid.getStore().clearData();
        	masterGrid2.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
};
</script>