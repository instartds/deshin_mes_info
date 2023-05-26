<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa240skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="sfa240skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('sfa240skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 				, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'},
	    	{name:'DIV_CODE' 				, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'}, 	
	    	{name:'ITEM_LEVEL1' 			, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
	    	{name:'ITEM_LEVEL2' 			, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
	    	{name:'ITEM_LEVEL3' 			, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	
	    	/* 전년도 합계 */
	    	{name:'BF_SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
	    	{name:'BF_DISCOUNT_P' 			, text: '<t:message code="system.label.sales.discount" default="할인"/>'			, type: 'uniUnitPrice'},
	    	{name:'BF_SALE_LOC_AMT_I' 		, text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'			, type: 'uniPrice'},
	    	{name:'BF_TAX_AMT_O' 			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'			, type: 'uniPrice'},
	    	{name:'BF_SALE_AMT_O' 			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'			, type: 'uniPrice'},
	    	
	    	/* 현재년도 합계 */
	    	{name:'SALE_Q'					, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
	    	{name:'DISCOUNT_P' 		 		, text: '<t:message code="system.label.sales.discount" default="할인"/>'			, type: 'uniUnitPrice'},
	    	{name:'SALE_LOC_AMT_I' 	 		, text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'			, type: 'uniPrice'},
	    	{name:'TAX_AMT_O' 		 		, text: '<t:message code="system.label.sales.vat" default="부가세"/>'			, type: 'uniPrice'},
	    	{name:'SALE_AMT_O' 		 		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'			, type: 'uniPrice'},
	    	
	    	/* 차이 합계 */
	    	{name:'SUB_SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
	    	{name:'SUB_DISCOUNT_P' 			, text: '<t:message code="system.label.sales.discount" default="할인"/>'			, type: 'uniUnitPrice'},
	    	{name:'SUB_SALE_LOC_AMT_I' 		, text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'			, type: 'uniPrice'},
	    	{name:'SUB_TAX_AMT_O' 			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'			, type: 'uniPrice'},
	    	{name:'SUB_SALE_AMT_O' 			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'			, type: 'uniPrice'},
	    	{name:'INCREASE_DECREASE' 		, text: '증감액'			, type: 'uniPrice'},
	    	{name:'INCREASE_DECREASE_PER' 	, text: '증감률'			, type: 'uniPercent'}
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
	var MasterStore = Unilite.createStore('sfa240skrvMasterStore',{
			model: 'sfa240skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'sfa240skrvService.selectList'
                }
            },
			loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});		// End of var MasterStore 
	
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
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfYear'),
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
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					
					allowBlank: false,
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{ 
		    	fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
		    	name: 'TXTLV_L1',
		    	xtype: 'uniCombobox',  
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
		    	child: 'TXTLV_L2',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			    name: 'TXTLV_L2', 
			    xtype: 'uniCombobox',  
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			    child: 'TXTLV_L3',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'TXTLV_L3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L3', newValue);
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
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				colspan:2,
				startDate: UniDate.get('startOfYear'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					 
					allowBlank: false,
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{ 
		    	fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
		    	name: 'TXTLV_L1',
		    	xtype: 'uniCombobox',  
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
		    	child: 'TXTLV_L2',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			    name: 'TXTLV_L2', 
			    xtype: 'uniCombobox',  
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			    child: 'TXTLV_L3',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'TXTLV_L3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sfa240skrvGrid', {
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
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex:'COMP_CODE' 	  							, width: 100, hidden:true},
			{dataIndex:'DIV_CODE' 	  							, width: 100, hidden:true},
			{dataIndex:'ITEM_LEVEL1' 		  					, width: 150
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
			{dataIndex:'ITEM_LEVEL2' 	  						, width: 150 },
			{dataIndex:'ITEM_LEVEL3' 				  			, width: 200 },
			{
            	text: '전년도 합계',
         		columns: [ 
            		{dataIndex: 'BF_SALE_Q'						, width: 96, summaryType: 'sum' },
            		{dataIndex: 'BF_DISCOUNT_P'					, width: 96, summaryType: 'sum' },
            		{dataIndex: 'BF_SALE_LOC_AMT_I'				, width: 93, summaryType: 'sum' },
            		{dataIndex: 'BF_TAX_AMT_O'					, width: 96, summaryType: 'sum' },
            		{dataIndex: 'BF_SALE_AMT_O'					, width: 96, summaryType: 'sum' }
            	]
           	},
			{
            	text: '현재년도 합계',
         		columns: [ 
            		{dataIndex: 'SALE_Q'			, width: 96, summaryType: 'sum' },
            		{dataIndex: 'DISCOUNT_P' 		, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SALE_LOC_AMT_I' 	, width: 93, summaryType: 'sum' },
            		{dataIndex: 'TAX_AMT_O' 		, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SALE_AMT_O' 		, width: 96, summaryType: 'sum' }
            	]
           	},
			{
            	text: '차이 합계',
         		columns: [ 
            		{dataIndex: 'SUB_SALE_Q'			, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SUB_DISCOUNT_P' 		, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SUB_SALE_LOC_AMT_I' 	, width: 93, summaryType: 'sum' },
            		{dataIndex: 'SUB_TAX_AMT_O' 		, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SUB_SALE_AMT_O' 		, width: 93, summaryType: 'sum' },
            		{dataIndex: 'INCREASE_DECREASE'		, width: 96, summaryType: 'sum' },
            		{dataIndex: 'INCREASE_DECREASE_PER' , width: 96,
						renderer : function(val) {
			                    if (val > 0) {
			                        return val + '%';
			                    } else if (val < 0) {
			                        return val + '%';
			                    }
			                    return val;
			                },
			            summaryRenderer: function(val){
			            		return 
			            	}
						}
            	]
           	}
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
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'sfa240skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};
</script>
