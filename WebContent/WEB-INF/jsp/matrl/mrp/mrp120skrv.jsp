<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp120skrv"  >
	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019" /> <!-- 국내외구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
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

	Unilite.defineModel('Mrp120skrvModel', {
	    fields: [  	
	    	{name: 'ORDER_PLAN_DATE'   		,text:'<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'		,type:'uniDate'},
	    	{name: 'BASIS_DATE'				,text:'<t:message code="system.label.purchase.deliverydate2" default="납기예정일"/>'		,type:'uniDate'},
	    	{name: 'ITEM_CODE'		    	,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type:'string'},
	    	{name: 'ITEM_NAME'		    	,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type:'string'},
	    	{name: 'SPEC'		    		,text:'<t:message code="system.label.purchase.spec" default="규격"/>'			,type:'string'},
	    	{name: 'TOTAL_NEED_Q'			,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'		,type:'uniQty'},
	    	{name: 'WH_STOCK_Q'				,text:'<t:message code="system.label.purchase.onhandstock" default="현재고"/>'		,type:'uniQty'},
	    	{name: 'INSTOCK_PLAN_Q'			,text:'<t:message code="system.label.purchase.receiptplannedqty" default="입고예정량"/>'		,type:'uniQty'},
	    	{name: 'OUTSTOCK_PLAN_Q'   		,text:'<t:message code="system.label.purchase.issueresevationqty" default="출고예정량"/>'		,type:'uniQty'},
	    	{name: 'SAFE_STOCK_Q'			,text:'<t:message code="system.label.purchase.safetystockqty" default="안전재고량"/>'		,type:'uniQty'},
	    	{name: 'POH_STOCK_Q'			,text:'<t:message code="system.label.purchase.estimatedstockqty" default="예상재고량"/>'		,type:'uniQty'},
	    	{name: 'POR_STOCK_Q'			,text:'<t:message code="system.label.purchase.plansupplementqty" default="계획보충량"/>'		,type:'uniQty'},
	    	{name: 'PAB_STOCK_Q'			,text:'<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'		,type:'uniQty'},
	    	{name: 'NET_REQ_Q'				,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'		,type:'uniQty'},
	    	{name: 'ORDER_PLAN_Q'	    	,text:'<t:message code="system.label.purchase.purchaseplannedqty" default="발주예정량"/>'		,type:'uniQty'},
	    	{name: 'DOM_FORIGN'				,text:'<t:message code="system.label.purchase.domesticoverseas" default="국내외"/>'		,type:'string',comboType:'AU',comboCode:'B019'},
	    	{name: 'SUPPLY_TYPE'			,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'		,type:'string',comboType:'AU',comboCode:'B014'},
	    	{name: 'ITEM_ACCOUNT'			,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		,type:'string',comboType:'AU',comboCode:'B020'},
	    	{name: 'MRP_CONTROL_NUM'   		,text:'<t:message code="system.label.purchase.mrpcontrolnum2" default="수습계획번호"/>'	,type:'string'}
		]
	});		// end of Unilite.defineModel('Mrp120skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrp120skrvMasterStore1',{
			model: 'Mrp120skrvModel',
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
                	   read: 'mrp120skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			},
			groupField: ''			
	});		// end of var directMasterStore1 = Unilite.createStore('mrp120skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',	
	    items: [{	    
		    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	    	},{
	    		fieldLabel: '<t:message code="system.label.purchase.deliverydate2" default="납기예정일"/>',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'ORDER_DATE_FR',
	    		endFieldName: 'ORDER_DATE_TO',
	    		startDate: UniDate.get('startOfMonth'),
	    		endDate: UniDate.get('today'),
	    		allowBlank:false,
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>',
				name:'DOM_FORIGN', 
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode:'B019',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOM_FORIGN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	    	},{
	    		fieldLabel: '<t:message code="system.label.purchase.deliverydate2" default="납기예정일"/>',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'ORDER_DATE_FR',
	    		endFieldName: 'ORDER_DATE_TO',
	    		startDate: UniDate.get('startOfMonth'),
	    		endDate: UniDate.get('today'),
	    		allowBlank:false,
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>',
				name:'DOM_FORIGN', 
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode:'B019',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DOM_FORIGN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrp120skrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: directMasterStore1,
        columns: [
        	{ dataIndex: 'ORDER_PLAN_DATE'   	,    width: 80, locked : true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.classficationtotal2" default="분류계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
        	{ dataIndex: 'BASIS_DATE'		   	,    width: 80, locked : true},
        	{ dataIndex: 'ITEM_CODE'		    ,    width: 100, locked : true},
        	{ dataIndex: 'ITEM_NAME'		    ,    width: 153, locked : true},
        	{ dataIndex: 'SPEC'		    		,    width: 133},
        	{ dataIndex: 'TOTAL_NEED_Q'			,    width: 103, summaryType:'sum'},
        	{ dataIndex: 'WH_STOCK_Q'		   	,    width: 103},
        	{ dataIndex: 'INSTOCK_PLAN_Q'	   	,    width: 103},
        	{ dataIndex: 'OUTSTOCK_PLAN_Q'   	,    width: 103},
        	{ dataIndex: 'SAFE_STOCK_Q'			,    width: 110},
        	{ dataIndex: 'POH_STOCK_Q'		   	,    width: 106},
        	{ dataIndex: 'POR_STOCK_Q'		   	,    width: 106, hidden : true},
        	{ dataIndex: 'PAB_STOCK_Q'		   	,    width: 106, hidden : true},
        	{ dataIndex: 'NET_REQ_Q'			,    width: 93},
        	{ dataIndex: 'ORDER_PLAN_Q'	    	,    width: 93},
        	{ dataIndex: 'DOM_FORIGN'		   	,    width: 70, align: 'center'},
        	{ dataIndex: 'SUPPLY_TYPE'		   	,    width: 73, align: 'center'},
        	{ dataIndex: 'ITEM_ACCOUNT'			,    width: 73},
        	{ dataIndex: 'MRP_CONTROL_NUM'   	,    width: 100} 							
		] 
    }); 		// end of var masterGrid = Unilite.createGrid('mrp120skrvGrid1', {  
	
	
    Unilite.Main({
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
		id  : 'mrp120skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);

			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}				
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

};

</script>
