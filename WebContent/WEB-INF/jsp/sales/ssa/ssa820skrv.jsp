<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa820skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa820skrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="YP43" /> 				<!--매장 -->	
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

	Unilite.defineModel('Ssa820skrvModel1', {
	    fields: [
	    	{name: 'GUBUN'				, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'		, type: 'string'},
	    	{name: 'SALE_MONTH'			, text: '매출월'		, type: 'string'},
	    	{name: 'STORE_CODE'			, text: '매장코드'		, type: 'string'},
	    	{name: 'STORE_NAME'			, text: '매장명'		, type: 'string'},
	    	{name: 'SALE_CNT'			, text: '영업일수'		, type: 'int'},
	    	{name: 'SALE_PRSN_CNT'		, text: '이용고객수'	, type: 'int'},	   
	    	{name: 'DISCOUNT_O'			, text: '<t:message code="system.label.sales.discount" default="할인"/>'		, type: 'uniPrice'}, 	
	    	{name: 'SALE_AMT_O'			, text: '순매출액'		, type: 'uniPrice'},
	    	{name: 'CONSIGNMENT_O'		, text: '위탁수수료'	, type: 'uniPrice'},
	    	{name: 'VIEW_DATE'			, text: 'VIEW_DATE'	, type: 'string'}
	    	
	    ]
	});
	
	Unilite.defineModel('Ssa820skrvModel2', {
	    fields: [
	    	{name: 'STORE_CODE'			, text: '매장코드'		, type: 'string'},
	    	{name: 'STORE_NAME'			, text: '매장명'		, type: 'string'},
	    	{name: 'JAN'				, text: '<t:message code="system.label.sales.january" default="1월"/>'		, type: 'uniPrice'},
	    	{name: 'FEB'				, text: '<t:message code="system.label.sales.february" default="2월"/>'		, type: 'uniPrice'},
	    	{name: 'MAR'				, text: '<t:message code="system.label.sales.march" default="3월"/>'		, type: 'uniPrice'},
	    	{name: 'APR'				, text: '<t:message code="system.label.sales.april" default="4월"/>'		, type: 'uniPrice'},
	    	{name: 'MAY'				, text: '<t:message code="system.label.sales.may" default="5월"/>'		, type: 'uniPrice'},
	    	{name: 'JUN'				, text: '<t:message code="system.label.sales.june" default="6월"/>'		, type: 'uniPrice'},
	    	{name: 'JUL'				, text: '<t:message code="system.label.sales.july" default="7월"/>'		, type: 'uniPrice'},
	    	{name: 'AUG'				, text: '<t:message code="system.label.sales.august" default="8월"/>'		, type: 'uniPrice'},
	    	{name: 'SEP'				, text: '<t:message code="system.label.sales.september" default="9월"/>'		, type: 'uniPrice'},
	    	{name: 'OCT'				, text: '<t:message code="system.label.sales.october" default="10월"/>'		, type: 'uniPrice'},
	    	{name: 'NOV'				, text: '<t:message code="system.label.sales.november" default="11월"/>'		, type: 'uniPrice'},
	    	{name: 'DECE'				, text: '<t:message code="system.label.sales.december" default="12월"/>'		, type: 'uniPrice'},
	    	{name: 'TOTAL'				, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'		, type: 'uniPrice'}
	    ]
	});
	
	Unilite.defineModel('Ssa820skrvModel3', {
	    fields: [
	    	{name: 'SALE_DATE'			, text: '일자'		, type: 'uniDate'},
	    	{name: 'STORE_CODE'			, text: '매장코드'		, type: 'string'},
	    	{name: 'STORE_NAME'			, text: '매장명'		, type: 'string'},
	    	{name: 'SALE_CNT'			, text: '객수'		, type: 'int'},
	    	{name: 'SALE_AMT_O'			, text: '순매출'		, type: 'uniPrice'}
	    ]
	});
	
	Unilite.defineModel('Ssa820skrvModel4', {
	    fields: [
	    	{name: 'SALE_DATE'			, text: '일자'			, type: 'uniDate'},
	    	{name: 'STORE_CODE'			, text: '매장코드'			, type: 'string'},
	    	{name: 'STORE_NAME'			, text: '매장명'			, type: 'string'},
	    	{name: 'DAY_WEEK'			, text: '요일'			, type: 'string'},
	    	{name: 'SALE_CNT'			, text: '객수'			, type: 'int'},
	    	{name: 'SALE_AMT_O'			, text: '순매출'			, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'			, type: 'uniPrice'},
	    	{name: 'DISCOUNT_O'			, text: '<t:message code="system.label.sales.discount" default="할인"/>'			, type: 'uniPrice'},
	    	{name: 'COUPON'				, text: '쿠폰'			, type: 'uniPrice'},
	    	{name: 'TOTAL_AMT_O'		, text: '총매출'			, type: 'uniPrice'},
	    	{name: 'CONSIGNMENT_O'		, text: '수수료'			, type: 'uniPrice'},
	    	{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'}
	    ]
	});
	
	
	Ext.create( 'Ext.data.Store', {
          storeId: "gubunStore",
          fields: [ 'text', 'value'],
          data : [
              {text: "백양로",   value:"1" },
              {text: "CU",     value:"2" }
          ]
      });

      
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa820skrvMasterStore1', {
		model: 'Ssa820skrvModel1',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa820skrvService.selectList1'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params: param
			});
		},
		groupField: 'STORE_NAME'			
	});
	
	var directMasterStore2 = Unilite.createStore('ssa820skrvMasterStore2', {
		model: 'Ssa820skrvModel2',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa820skrvService.selectList2'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params: param
			});
		}			
	});
	
	var directMasterStore3 = Unilite.createStore('ssa820skrvMasterStore3', {
		model: 'Ssa820skrvModel3',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa820skrvService.selectList3'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params: param
			});
		}
	});
	
	var directMasterStore4 = Unilite.createStore('ssa820skrvMasterStore4', {
		model: 'Ssa820skrvModel4',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa820skrvService.selectList4'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params: param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '조회년/월',
		        xtype: 'uniMonthfield',	
		        name: 'SALE_DATE',
		        allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_DATE', newValue);
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
			}, {
	        	fieldLabel: '매장구분',
	        	name: 'GUBUN',
	        	xtype:'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('gubunStore'),
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {					
						panelResult.setValue('GUBUN', newValue);
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
				}
	  		}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '조회년/월',
	        xtype: 'uniMonthfield',	
//		        value: new Date().getFullYear(),
	        name: 'SALE_DATE',
	        allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_DATE', newValue);
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
		}, {
        	fieldLabel: '매장구분',
        	name: 'GUBUN',
        	xtype:'uniCombobox',
        	store: Ext.data.StoreManager.lookup('gubunStore'),
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {					
					panelSearch.setValue('GUBUN', newValue);
				}
			}
        }]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('ssa820skrvGrid1', {
    	// for tab    
		title: '당월매출조회',
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal1', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal1' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
	   	store: directMasterStore1,
        columns: [
        	{dataIndex: 'STORE_CODE'		,		 width:	100},
        	{dataIndex: 'STORE_NAME'		,		 width:	150},
        	{dataIndex: 'GUBUN'				,		 width:	80,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'SALE_MONTH'		,		 width:	120, align: 'center'},        	
        	{dataIndex: 'SALE_CNT'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'SALE_PRSN_CNT'		,		 width:	90, summaryType: 'sum'},
    		{dataIndex: 'DISCOUNT_O'		,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'SALE_AMT_O'		,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'CONSIGNMENT_O'		,		 width:	90, summaryType: 'sum'}
		] 
    });  
    
       /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2 = Unilite.createGrid('ssa820skrvGrid2', {
    	// for tab    	
		title: '월별 위탁수수료 현황',
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal2' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	   	store: directMasterStore2,
        columns: [
        	{dataIndex: 'STORE_CODE'		,		 width:	100,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'STORE_NAME'		,		 width:	150},
        	{dataIndex: 'JAN'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'FEB'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'MAR'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'APR'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'MAY'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'JUN'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'JUL'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'AUG'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'SEP'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'OCT'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'NOV'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'DECE'				,		 width:	90 , summaryType: 'sum'},
        	{dataIndex: 'TOTAL'				,		 width:	90, summaryType: 'sum'}
		] 
    });
    
       /**
     * Master Grid3 정의(Grid Panel)
     * @type 
     */
	var masterGrid3 = Unilite.createGrid('ssa820skrvGrid3', {
    	// for tab    
		title: '주말 이용현황',
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal3' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	   	store: directMasterStore3,
        columns: [
        	{dataIndex: 'SALE_DATE'			,		 width:	120},
        	{dataIndex: 'STORE_CODE'		,		 width:	100,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'STORE_NAME'		,		 width:	150},
        	{dataIndex: 'SALE_CNT'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'SALE_AMT_O'		,		 width:	90, summaryType: 'sum'}
		] 
    });
    
       /**
     * Master Grid4 정의(Grid Panel)
     * @type 
     */
	var masterGrid4 = Unilite.createGrid('ssa820skrvGrid4', {
    	// for tab    
		title: '매출 상세조회',
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal4', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal4' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	   	store: directMasterStore4,
        columns: [
        	{dataIndex: 'SALE_DATE'				,		 width:	120},
        	{dataIndex: 'STORE_CODE'			,		 width:	100},
        	{dataIndex: 'STORE_NAME'			,		 width:	150,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'DAY_WEEK'				,		 width:	90},
        	{dataIndex: 'SALE_CNT'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'SALE_AMT_O'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'TAX_AMT_O'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'DISCOUNT_O'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'COUPON'				,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'TOTAL_AMT_O'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'CONSIGNMENT_O'			,		 width:	90, summaryType: 'sum'},
        	{dataIndex: 'REMARK'				,		 width:	120}
		] 
    });
	
    
     var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [
	         masterGrid1,
	         masterGrid2,
	         masterGrid3,
	         masterGrid4
	    ]
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
		id: 'ssa820skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('SALE_DATE', UniDate.get('today'));
			panelResult.setValue('SALE_DATE', UniDate.get('today'));
		},
		onQueryButtonDown: function() {			
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}			
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'ssa820skrvGrid1'){
				directMasterStore1.loadStoreRecords();
				viewNormal = masterGrid1.getView();
//				viewNormal.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal1').toggleSummaryRow(true);
			}else if(activeTabId == 'ssa820skrvGrid2'){
				directMasterStore2.loadStoreRecords();
				viewNormal = masterGrid2.getView();
				viewNormal.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal2').toggleSummaryRow(true);
			}else if(activeTabId == 'ssa820skrvGrid3'){
				directMasterStore3.loadStoreRecords();
				viewNormal = masterGrid3.getView();
				viewNormal.getFeature('masterGridSubTotal3').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal3').toggleSummaryRow(true);
			}else if(activeTabId == 'ssa820skrvGrid4'){
				directMasterStore4.loadStoreRecords();
				viewNormal = masterGrid4.getView();
				viewNormal.getFeature('masterGridSubTotal4').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal4').toggleSummaryRow(true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();			
		}
	});

};


</script>
