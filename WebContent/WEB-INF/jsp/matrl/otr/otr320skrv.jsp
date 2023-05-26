<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr320skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->     
	<t:ExtComboStore comboType="O" />    <!-- 창고   -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 * Model 정의 
	 */
	Unilite.defineModel('Otr320skrvModel', {
	    fields: [  	 
	    	{name: 'ORDER_ITEM_CODE',		text:'<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>',	type:'string'},
	    	{name: 'ORDER_ITEM_NAME',		text:'<t:message code="system.label.purchase.poitemname" default="발주품목명"/>',		type:'string'},
	    	{name: 'ITEM_CODE',				text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',		type:'string'},
	    	{name: 'ITEM_NAME',				text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'	,		type:'string'},
	    	{name: 'SPEC',					text:'<t:message code="system.label.purchase.spec" default="규격"/>',			type:'string'},
	    	{name: 'STOCK_UNIT',			text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',		type:'string'},
	    	{name: 'ORDER_DATE',			text:'<t:message code="system.label.purchase.podate" default="발주일"/>',		    type:'uniDate'},
	    	{name: 'ALLOC_Q',				text:'<t:message code="system.label.purchase.allocationqty" default="예약량"/>'	,		type:'uniQty'},
	    	{name: 'OUTSTOCK_Q',			text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>'	,		type:'uniQty'},
	    	{name: 'NOT_OUTSTOCK',			text:'<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>',		type:'uniQty'},
	    	{name: 'AVERAGE_P',				text:'<t:message code="system.label.purchase.price" default="단가"/>',			type:'uniUnitPrice'},
	    	{name: 'STOCK_Q',				text:'<t:message code="system.label.purchase.onhandstock" default="현재고"/>'	,		type:'uniQty'},
	    	{name: 'CUSTOM_CODE',			text:'<t:message code="system.label.purchase.subcontractor" default="외주처"/>'	,		type:'string'},
	    	{name: 'CUSTOM_NAME',			text:'<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>',		type:'string'},
	    	{name: 'MONEY_UNIT',			text:'<t:message code="system.label.purchase.currency" default="화폐"/>',			type:'string'},
	    	{name: 'DIV_CODE',				text:'<t:message code="system.label.purchase.division" default="사업장"/>'	,		type:'string'},
	    	{name: 'ORDER_NUM',				text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',		type:'string'},
	    	{name: 'ORDER_SEQ',				text:'<t:message code="system.label.purchase.poseq" default="발주순번"/>',		type:'string'},
	    	{name: 'WH_CODE',				text:'<t:message code="system.label.purchase.warehouse" default="창고"/>',			type:'string', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'REMARK',				text:'<t:message code="system.label.purchase.remarks" default="비고"/>',			type:'string'},
	    	{name: 'PROJECT_NO',			text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',		type:'string'},
	    	{name: 'COMP_CODE',			    text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>',        type:'string'}
			]
	});		// end of Unilite.defineModel('Otr320skrvModel', {
	
	Unilite.defineModel('Otr320skrvModel2', {
	    fields: [  	 
	    	{name: 'CUSTOM_NAME',			text:'<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>',		type:'string'},
	    	{name: 'ORDER_DATE',			text:'<t:message code="system.label.purchase.podate" default="발주일"/>'  ,		type:'uniDate'},
	    	{name: 'ORDER_ITEM_CODE',		text:'<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>',	type:'string'},
	    	{name: 'ORDER_ITEM_NAME',		text:'<t:message code="system.label.purchase.poitemname" default="발주품목명"/>',		type:'string'},
	    	{name: 'ITEM_CODE',				text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',		type:'string'},
	    	{name: 'ITEM_NAME',				text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'	,		type:'string'},
	    	{name: 'SPEC',					text:'<t:message code="system.label.purchase.spec" default="규격"/>',			type:'string'},
	    	{name: 'STOCK_UNIT',			text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',		type:'string'},
	    	{name: 'ALLOC_Q',				text:'<t:message code="system.label.purchase.allocationqty" default="예약량"/>'	,		type:'uniQty'},
	    	{name: 'OUTSTOCK_Q',			text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>'	,		type:'uniQty'},
	    	{name: 'NOT_OUTSTOCK',			text:'<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>',		type:'uniQty'},
	    	{name: 'AVERAGE_P',				text:'<t:message code="system.label.purchase.price" default="단가"/>',			type:'uniUnitPrice'},
	    	{name: 'STOCK_Q',				text:'<t:message code="system.label.purchase.onhandstock" default="현재고"/>'	,		type:'uniQty'},
	    	{name: 'CUSTOM_CODE',			text:'<t:message code="system.label.purchase.subcontractor" default="외주처"/>'	,		type:'string'},
	    	{name: 'MONEY_UNIT',			text:'<t:message code="system.label.purchase.currency" default="화폐"/>',			type:'string'},
	    	{name: 'DIV_CODE',				text:'<t:message code="system.label.purchase.division" default="사업장"/>'	,		type:'string'},
	    	{name: 'ORDER_NUM',				text:'<t:message code="system.label.purchase.pono" default="발주번호"/>',		type:'string'},
	    	{name: 'ORDER_SEQ',				text:'<t:message code="system.label.purchase.poseq" default="발주순번"/>',		type:'string'},
	    	{name: 'WH_CODE',				text:'<t:message code="system.label.purchase.warehouse" default="창고"/>',			type:'string', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'REMARK',				text:'<t:message code="system.label.purchase.remarks" default="비고"/>',			type:'string'},
	    	{name: 'PROJECT_NO',			text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',		type:'string'},
	    	{name: 'COMP_CODE',			    text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>',        type:'string'}
			]
	});		// end of Unilite.defineModel('Otr320skrvModel2', {
	
	/**
	 * Store 정의(Service 정의)
	 */					
	var directMasterStore1 = Unilite.createStore('otr320skrvMasterStore1',{
			model: 'Otr320skrvModel',
			uniOpt : {
            	isMaster  : true,		// 상위 버튼 연결 
            	editable  : false,	    // 수정 모드 사용 
            	deletable : false,		// 삭제 가능 여부 
	            useNavi   : false		// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'otr320skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'COMP_CODE'			
	});		// end of var directMasterStore1 = Unilite.createStore('otr320skrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('otr320skrvMasterStore2',{
			model: 'Otr320skrvModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'otr320skrvService.selectList2'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'COMP_CODE'			
	});		// end of var directMasterStore1 = Unilite.createStore('otr320skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        width:380,
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
	        items: [{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120', 
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WH_CODE', '');
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_ORDER_DATE',
	        	endFieldName: 'TO_ORDER_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width: 315,
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
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype: 'uniCombobox',
				comboType  : 'O', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelSearch.getValue('DIV_CODE');
                        })
                        }else{
                            store.filterBy(function(record){
                            return false;   
                        })
                    }
                  }
				}
			}]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
		    	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		    	name: 'ITEM_ACCOUNT',
		    	xtype: 'uniCombobox', 
		    	comboType:'AU',
		    	comboCode:'B020'
	    	},
		    	Unilite.popup('CUST',{ 
		    		fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
		    		textFieldWidth: 170,
		    		valueFieldName: 'CUSTOM_CODE', 
					textFieldName: 'CUSTOM_NAME',
		    		extParam: {'CUSTOM_TYPE':'3' },
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_CODE', '');
									}
								}
						}
	    		}),
	    	{ 
	    		fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
	    		name: 'ORDER_PRSN', 
	    		xtype: 'uniCombobox', 
	    		comboType: 'AU',
	    		comboCode: 'M201'
	    	},
		    Unilite.popup('DIV_PUMOK',{ 
				fieldLabel     : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
				textFieldWidth : 170, 
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})
	     	]
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
						panelResult.setValue('WH_CODE', '');
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_ORDER_DATE',
	        	endFieldName: 'TO_ORDER_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width: 315,
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
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype: 'uniCombobox',
				comboType  : 'O', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        })
                        }else{
                            store.filterBy(function(record){
                            return false;   
                        })
                    }
                  }
				}
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     */  
    var masterGrid = Unilite.createGrid('otr320skrvGrid1', {
    	// for tab    	
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
        	} 
        ],
    	store: directMasterStore1,
        columns:  [  
        	{ dataIndex: 'ORDER_ITEM_CODE',   	width: 120},
        	{ dataIndex: 'ORDER_ITEM_NAME',   	width: 150},
        	{ dataIndex: 'ITEM_CODE',   		width: 100},
        	{ dataIndex: 'ITEM_NAME',   		width: 133},
        	{ dataIndex: 'SPEC',   				width: 150},
        	{ dataIndex: 'STOCK_UNIT',   		width: 66 ,align:'center'},
        	{ dataIndex: 'ORDER_DATE',   		width: 80},
        	{ dataIndex: 'ALLOC_Q',   			width: 93, summaryType:"sum"},
        	{ dataIndex: 'OUTSTOCK_Q',   		width: 93, summaryType:"sum"},
        	{ dataIndex: 'NOT_OUTSTOCK',   		width: 93, summaryType:"sum"},
        	{ dataIndex: 'AVERAGE_P',  			width: 66, 		hidden : true},
        	{ dataIndex: 'STOCK_Q',   			width: 93, summaryType:"sum"},
        	{ dataIndex: 'CUSTOM_CODE',   		width: 66, 		hidden : true},
        	{ dataIndex: 'CUSTOM_NAME',   		width: 133},
        	{ dataIndex: 'MONEY_UNIT',   		width: 66, 		hidden : true},
        	{ dataIndex: 'DIV_CODE',   			width: 66, 		hidden : true},
        	{ dataIndex: 'ORDER_NUM',  	 		width: 66, 		hidden : true},
        	{ dataIndex: 'ORDER_SEQ',   		width: 66, 		hidden : true},
        	{ dataIndex: 'WH_CODE',   			width: 100} ,
        	{ dataIndex: 'REMARK',				width: 133},
        	{ dataIndex: 'PROJECT_NO',   		width: 133},
        	{ dataIndex: 'COMP_CODE',   		width: 133,hidden : true}
          ] 
    });		// end of var masterGrid = Unilite.createGrid('otr320skrvGrid1', {  	
    
    /**
     * Master Grid2 정의(Grid Panel)
     */  
    var masterGrid2 = Unilite.createGrid('otr320skrvGrid2', {
    	// for tab    	
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
        	id    : 'masterGridSubTotal', 
        	ftype : 'uniGroupingsummary',
        	showSummaryRow: true 
        },{
        	id    : 'masterGridTotal',
        	ftype : 'uniSummary',
        	showSummaryRow: true
        	} 
        ],
    	store: directMasterStore2,
        columns:  [  
        	{ dataIndex: 'CUSTOM_CODE',   		width: 66, 		hidden : true},
        	{ dataIndex: 'CUSTOM_NAME',   		width: 133},
        	{ dataIndex: 'ORDER_DATE',   		width: 80},
        	{ dataIndex: 'ORDER_ITEM_CODE',   	width: 103},
        	{ dataIndex: 'ORDER_ITEM_NAME',   	width: 133},
        	{ dataIndex: 'ITEM_CODE',   		width: 100},
        	{ dataIndex: 'ITEM_NAME',   		width: 133},
        	{ dataIndex: 'SPEC',   				width: 150},
        	{ dataIndex: 'STOCK_UNIT',   		width: 66 ,align:'center'},
        	{ dataIndex: 'ALLOC_Q',   			width: 93, summaryType:"sum"},
        	{ dataIndex: 'OUTSTOCK_Q',   		width: 93, summaryType:"sum"},
        	{ dataIndex: 'NOT_OUTSTOCK',   		width: 93, summaryType:"sum"},
        	{ dataIndex: 'AVERAGE_P',  			width: 66, 		hidden : true},
        	{ dataIndex: 'STOCK_Q',   			width: 93, summaryType:"sum"},
        	{ dataIndex: 'MONEY_UNIT',   		width: 66, 		hidden : true},
        	{ dataIndex: 'DIV_CODE',   			width: 66, 		hidden : true},
        	{ dataIndex: 'ORDER_NUM',  	 		width: 66, 		hidden : true},
        	{ dataIndex: 'ORDER_SEQ',   		width: 66, 		hidden : true},
        	{ dataIndex: 'WH_CODE',   			width: 100} ,
        	{ dataIndex: 'REMARK',				width: 133},
        	{ dataIndex: 'PROJECT_NO',   		width: 133},
        	{ dataIndex: 'COMP_CODE',   		width: 133, hidden : true}
          ] 
    });		// end of var masterGrid = Unilite.createGrid('otr320skrvGrid1', {
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid, masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'otr320skrvGrid1':
						break;
					case 'otr320skrvGrid2':
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
		},panelSearch],
		id  : 'otr320skrvApp',
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
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'otr320skrvGrid1'){
					masterGrid.getStore().loadStoreRecords();
				}else if(activeTabId == 'otr320skrvGrid2'){
					masterGrid2.getStore().loadStoreRecords();
				}
			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			UniAppManager.setToolbarButtons('excel',true);
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