<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssd100skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="ssd100skrv"  /> 				<!-- 사업장 -->         
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!--거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 과세구분 -->
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

	
	Unilite.defineModel('Ssd100skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'				, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
//	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
	    
	    	{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.purchaseplacename" default="매입처명"/>'		, type: 'string'},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'TAX_TYPE'				, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'		, type: 'string'/*,comboType:'AU',comboCode:'B059'*/},
	    	
	    	{name: 'SPEC'					, text: '<t:message code="system.label.sales.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.sales.unit" default="단위"/>'		, type: 'string'},
	    	{name: 'STOCK_Q'				, text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'		, type: 'uniQty'},
	    	
	    	{name: 'PUR_PRICE'				, text: '<t:message code="system.label.sales.purchaseprice" default="매입가"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_PRICE'				, text: '<t:message code="system.label.sales.sellingprice2" default="판매가"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'CON_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'CON_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'CON_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'CON_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'CON_TOT_AMT'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'CASH_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'CASH_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'CASH_TOT_AMT'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	
	    	{name: 'TOT_Q'					, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'TOT_DISCOUNT_AMT'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_SALE_AMT'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_TAX_AMT'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_AMT_SUM'			, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	{name: 'AGENT_TYPE'				, text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'		, type: 'string'/*, comboType:'AU',comboCode:'B055' */,allowBlank: false, defaultValue:'1'}
	    ]
	});//End of Unilite.defineModel('Ssd100skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssd100skrvMasterStore1', {
		model: 'Ssd100skrvModel',
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
				read: 'ssd100skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});	
		}, 
		listeners: {
			load: function(store, records, successful, eOpts) {		
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		},groupField: 'CUSTOM_CODE'
			
	});//End of var directMasterStore1 = Unilite.createStore('ssd100skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				},
		     	afterrender: function(field) {
		     		var divStore = field.getStore();
		     		divStore.insert(0, {"value":"", "option":null, "text":"전사"});
		     	}
			}
		},
        	Unilite.popup('DEPT', { 
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
			     		onClear: function(type) {
			        		panelResult.setValue('DEPT_CODE', '');
			        		panelResult.setValue('DEPT_NAME', '');
			     		},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
		   }),{
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
			Unilite.popup('CUST', {
						fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
						valueFieldName: 'CUST_CODE', 
						textFieldName: 'CUST_NAME', 
						 
//						validateBlank:false, 
						popupWidth: 710,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
									panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_CODE', '');
								panelResult.setValue('CUST_NAME', '');
							}
						}
					})/*,
					Unilite.popup('CUST',{ 
						fieldLabel: '~', 
						valueFieldName: 'CUST_CODE2', 
						textFieldName: 'CUST_NAME2', 						 
//						validateBlank: false, 
						popupWidth: 710,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_CODE2', panelSearch.getValue('CUST_CODE2'));
									panelResult.setValue('CUST_NAME2', panelSearch.getValue('CUST_NAME2'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_CODE2', '');
								panelResult.setValue('CUST_NAME2', '');
							}
						}
					})*/,
			    	Unilite.popup('DIV_PUMOK', {
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
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'    ,
					name: 'AGENT_TYPE' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'B055' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
				}/*,
					Unilite.popup('DIV_PUMOK', {
					fieldLabel: '~',
					valueFieldName: 'ITEM_CODE2', 
					textFieldName: 'ITEM_NAME2', 
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE2', panelSearch.getValue('ITEM_CODE2'));
								panelResult.setValue('ITEM_NAME2', panelSearch.getValue('ITEM_NAME2'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE2', '');
							panelResult.setValue('ITEM_NAME2', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})*/
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				},
		     	afterrender: function(field) {
		     		var divStore = field.getStore();
		     		divStore.insert(0, {"value":"", "option":null, "text":"전사"});
		     	}
			}
		},
		Unilite.popup('DEPT', { 
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
	     		onClear: function(type) {
	        		panelSearch.setValue('DEPT_CODE', '');
	        		panelSearch.setValue('DEPT_NAME', '');
	     		},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
	    	}
		}),{
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALE_DATE_FR',
			endFieldName: 'SALE_DATE_TO',
			colspan: 2,
			startDate: UniDate.get('startOfMonth'),
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
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE', 
				textFieldName: 'CUST_NAME',
				 
//				validateBlank:false,
				//labelWidth:150,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUST_CODE', panelResult.getValue('CUST_CODE'));
							panelSearch.setValue('CUST_NAME', panelResult.getValue('CUST_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUST_CODE', '');
						panelSearch.setValue('CUST_NAME', '');
					}
				}
			})/*,
			Unilite.popup('CUST',{ 
				fieldLabel: '~', 
				valueFieldName: 'CUST_CODE2', 
				textFieldName: 'CUST_NAME2', 
				 
//				validateBlank: false, 
				labelWidth:15,
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUST_CODE2', panelResult.getValue('CUST_CODE2'));
							panelSearch.setValue('CUST_NAME2', panelResult.getValue('CUST_NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUST_CODE2', '');
						panelSearch.setValue('CUST_NAME2', '');
					}
				}
			})*/,
			Unilite.popup('DIV_PUMOK', {
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
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'    ,
					name: 'AGENT_TYPE' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'B055' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AGENT_TYPE', newValue);
						}
					}
				}/*,
					Unilite.popup('DIV_PUMOK', {
					fieldLabel: '~',
					valueFieldName: 'ITEM_CODE2', 
					textFieldName: 'ITEM_NAME2', 
					
					labelWidth:15,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE2', panelResult.getValue('ITEM_CODE2'));
								panelSearch.setValue('ITEM_NAME2', panelResult.getValue('ITEM_NAME2'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE2', '');
							panelSearch.setValue('ITEM_NAME2', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})*/
			
		
		]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {
    	// for tab    	
		layout: 'fit',
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
        features: [
                   {id: 'masterGridSubTotal',  ftype: 'uniGroupingsummary', showSummaryRow: true},
        	       {id: 'masterGridTotal',     ftype: 'uniSummary', showSummaryRow: true}
                  ],
    	store: directMasterStore1,
        columns: [
        {dataIndex: 'COMP_CODE'				, width: 80,hidden:true},
//        {dataIndex: 'DIV_CODE'				, width: 80,hidden:true},
        
        {dataIndex: 'CUSTOM_CODE'         , width: 80,locked:true,
                     summaryRenderer:function(value, summaryData, dataIndex, metaData ) 
                     {return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');}
         },
        	{dataIndex: 'CUSTOM_NAME'		, width: 150,locked:true},
        	{dataIndex: 'ITEM_CODE'			, width: 100,locked:true},
        	{dataIndex: 'ITEM_NAME'			, width: 160,locked:true},
        	{dataIndex: 'TAX_TYPE'			, width: 88,locked:true, align:'center'},
        	{dataIndex: 'SPEC'				, width: 120,hidden:true},
        	{dataIndex: 'STOCK_UNIT'		, width: 120,hidden:true},
        	{dataIndex: 'STOCK_Q'			, width: 60},
        	{dataIndex: 'PUR_PRICE'			, width: 60},
        	{dataIndex: 'SALE_PRICE'		, width: 60},
			{dataIndex: 'AGENT_TYPE'		, width:120,hidden:true},
			{ 
         	text:'위탁',
         		columns: [
		         	{dataIndex: 'CON_Q'		, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'CON_DISCOUNT_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_SALE_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_TAX_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CON_TOT_AMT'	, width: 100,summaryType: 'sum'}
	         	]
			},{ 
	      	text:'현매',
     			columns: [
		        	{dataIndex: 'CASH_Q'		, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'CASH_DISCOUNT_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_SALE_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_TAX_AMT'		, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'CASH_TOT_AMT'	, width: 100,summaryType: 'sum'}
	        	]
			},{ 
    	 	text:'<t:message code="system.label.sales.totalamount" default="합계"/>',
	     		columns: [
		        	{dataIndex: 'TOT_Q'			, width: 60,summaryType: 'sum'},
		        	{dataIndex: 'TOT_DISCOUNT_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_SALE_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_TAX_AMT'			, width: 90,summaryType: 'sum'},
		        	{dataIndex: 'TOT_AMT_SUM'	, width: 100,summaryType: 'sum'}
	        	]
    	 }] 
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
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
		id: 'ssd100skrvApp',
		fnInitBinding: function() {
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
			
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
			
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/ssd/ssd100rkrPrint.do',
	            prgID: 'ssd100rkr',
	               extParam: {			/*  ssdReportController 보내는 파라미터*/
	
	                  DIV_CODE  	: param.DIV_CODE,			
	                  DEPT_CODE 	: param.DEPT_CODE,			
	                  DEPT_NAME  	: param.DEPT_NAME,
	                  SALE_DATE_FR  : param.SALE_DATE_FR,
	                  SALE_DATE_TO	: param.SALE_DATE_TO,    
	                  CUST_CODE  	: param.CUST_CODE,
	                  CUST_NAME  	: param.CUST_NAME,
	                  ITEM_CODE  	: param.ITEM_CODE,
	                  ITEM_NAME  	: param.ITEM_NAME,
	                  AGENT_TYPE  	: param.AGENT_TYPE

	               }
	            });
	            win.center();
	            win.show();
	               
	      }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

};


</script>
