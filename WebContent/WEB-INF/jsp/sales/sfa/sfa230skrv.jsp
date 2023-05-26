<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa230skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="sfa230skrv" /> 			<!-- 사업장 -->  
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
	Unilite.defineModel('sfa230skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 				, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'},
	    	{name:'DIV_CODE' 				, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'}, 	
	    	{name:'DEPT_CODE' 				, text: '<t:message code="system.label.sales.department" default="부서"/>'			, type: 'string'},
	    	{name:'TREE_NAME' 				, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name:'ITEM_CODE' 				, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
	    	{name:'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
	    	{name:'ITEM_LEVEL1' 			, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
	    	{name:'ITEM_LEVEL2' 			, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
	    	{name:'ITEM_LEVEL3' 			, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			, type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name:'SALE_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'			, type: 'uniQty'},
	    	{name:'SALES_AMT_O' 			, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			, type: 'uniPrice'},
	    	{name:'SAVE_MONEY' 				, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'			, type: 'uniPrice'},
	    	{name:'SALE_COST' 				, text: '<t:message code="system.label.sales.salescost" default="판매원가"/>'			, type: 'uniPrice'},
	    	{name:'GROSS_PROFIT' 			, text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'			, type: 'uniPrice'},
	    	{name:'COST_RATE' 				, text: '<t:message code="system.label.sales.costrate" default="원가율(%)"/>'		, type: 'uniPercent'},
	    	{name:'SALES_COMMON_O' 			, text: '시중가액'			, type: 'uniPrice'},
	    	{name:'COMMON_COST_RATE' 		, text: '시중원가율(%)'		, type: 'uniPercent'}
	    	
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
	var MasterStore = Unilite.createStore('sfa230skrvMasterStore',{
			model: 'sfa230skrvModel',
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
               		read: 'sfa230skrvService.selectList'
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
				    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
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
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					 
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
			}),
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
					 
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					}
			}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '집계옵션',					            		
					id: 'rdoSelect',
					items: [{
						boxLabel: '기본', 
						width: 50, 
						name: 'S_QRY_OPT',
						inputValue: '1',
						checked: true  
					},{
						boxLabel : '부서집계', 
						width: 70,
						name: 'S_QRY_OPT',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('S_QRY_OPT').setValue(newValue.S_QRY_OPT);
						}
					}
			},{ 
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				colspan:3,
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
			}),
		    	Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					}
			}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '집계옵션',					            		
					id: 'rdoSelect2', 
					colspan:2, 
					items: [{
						boxLabel: '기본', 
						width: 50, 
						name: 'S_QRY_OPT',
						inputValue: '1',
						checked: true  
					},{
						boxLabel : '부서집계', 
						width: 70,
						name: 'S_QRY_OPT',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelSearch.getField('S_QRY_OPT').setValue(newValue.S_QRY_OPT);
						}
					}
			},{ 
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
		    },
			{	
				xtype:'container',
				width:150,
				items: {
					border:false,
			 		html:"<div id='' class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; color:red;'>※ 부가세 제외금액</div>"
				}
			}
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
    var masterGrid = Unilite.createGrid('sfa230skrvGrid', {
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
			{dataIndex:'DEPT_CODE' 		  						, width: 80
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
			{dataIndex:'TREE_NAME' 	  							, width: 160},
			{dataIndex:'ITEM_CODE' 	  							, width: 120},
			{dataIndex:'ITEM_NAME' 	  							, width: 300},
			{dataIndex:'ITEM_LEVEL1' 	  						, width: 200 , hidden:true},
			{dataIndex:'ITEM_LEVEL2' 	  						, width: 200 , hidden:true},
			{dataIndex:'ITEM_LEVEL3' 				  			, width: 150  },
			{dataIndex:'SALE_Q' 			  					, width: 100 , summaryType: 'sum'},
			{dataIndex:'SALES_AMT_O' 		  					, width: 120 , summaryType: 'sum'},
			{dataIndex:'SAVE_MONEY'   							, width: 120 , summaryType: 'sum'},
			{dataIndex:'SALE_COST' 		  						, width: 120 , summaryType: 'sum'},
			{dataIndex:'GROSS_PROFIT' 			  				, width: 120 , summaryType: 'sum'},
			{dataIndex:'COST_RATE' 			  					, width: 120 
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var results = MasterStore.sumBy(function(record, id) {
						return true;
					},
					['SALE_COST', 'SALES_AMT_O']);
					saleCose = results.SALE_COST;			
					salesAmtO = results.SALES_AMT_O;
					costRate = saleCose / salesAmtO * 100;
					costRateValue = Ext.util.Format.number(costRate, '0,000.00');
					//dAttrs: {align: 'right'}
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="right">' + costRateValue);
				}
			},
			{dataIndex:'SALES_COMMON_O'			  				, width: 120 , summaryType: 'sum'},
			{dataIndex:'COMMON_COST_RATE' 			  			, width: 120 
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var results = MasterStore.sumBy(function(record, id) {
						return true;
					},
					['SALE_COST', 'SALES_COMMON_O']);
					saleCose = results.SALE_COST;			
					salesAmtO = results.SALES_COMMON_O;
					costRate = saleCose / salesAmtO * 100;
					costRateValue = Ext.util.Format.number(costRate, '0,000.00');
					//dAttrs: {align: 'right'}
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="right">' + costRateValue);
				}
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
		id: 'sfa230skrvApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
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
		},
		setCostRateSet: function() {
    		var results = MasterStore.sumBy(function(record, id) {
				return true;
			}, 
			['SALE_COST', 'SALES_AMT_O']);
			saleCose = results.SALE_COST;			
			salesAmtO = results.SALES_AMT_O;
			costRate = saleCose / salesAmtO * 100;
    	}
	});
};
</script>
