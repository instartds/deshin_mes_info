<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map110skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map110skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="O" />    <!-- 창고   -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
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
	Unilite.defineModel('Map110skrvModel', {
		fields: [
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'COMPANY_NUM'			, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'BILL_NUM'				, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'BILL_DATE'				, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'					, type: 'uniDate'},
			{name: 'CHANGE_BASIS_DATE'		, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'					, type: 'uniDate'},
			{name: 'ISSUE_EXPECTED_DATE'	, text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'			, type: 'uniDate'},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'BUY_Q'					, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				, type: 'string'},
			{name: 'AMOUNT_P'				, text: '<t:message code="system.label.purchase.localprice" default="원화단가"/>'				, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'				, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'				, type: 'uniPrice'},
			{name: 'TAX_I'					, text: 'VAT'																				, type: 'uniPrice'},
			{name: 'TOTAL_I'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'				, type: 'uniPrice'},
			{name: 'FOR_AMOUNT_O'			, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'					, type: 'string'},
			{name: 'EX_DATE'				, text: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>'				, type: 'uniDate'},
			{name: 'EX_NUM'					, text: '<t:message code="system.label.purchase.exslipno" default="결의전표번호"/>'				, type: 'string'},
			{name: 'AC_DATE'				, text: '<t:message code="system.label.human.acdate" default="회계전표일"/>'						, type: 'uniDate'},
			{name: 'AC_NUM'					, text: '<t:message code="system.label.purchase.acslipno" default="회계전표번호"/>'				, type: 'string'},
			{name: 'AGREE_YN'				, text: '<t:message code="system.label.purchase.exslipapproveyn" default="결의전표승인여부"/>'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'}
		]
	});//End of Unilite.defineModel('Map110skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('map110skrvMasterStore1',{
		model: 'Map110skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'map110skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params:param,
				callback : function(records,options,success) {
					if(success) {
						if(Ext.isEmpty(records)){
							UniAppManager.setToolbarButtons(['print'], false);
						}else{
							UniAppManager.setToolbarButtons(['print'], true);
						}
					}
				}

			});
		},
			groupField: 'CUSTOM_NAME'
			//groupField: 'BILL_NUM'
	});//End of var directMasterStore1 = Unilite.createStore('map110skrvMasterStore1',{

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
				fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'IN_WH_CODE',
				value: UserInfo.divCode,

				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('IN_WH_CODE');
						field2.getStore().clearFilter(true);
						panelSearch.setValue('IN_WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('BILL_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('BILL_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'IN_WH_CODE',
				comboType  : 'O',
				xtype: 'uniCombobox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IN_WH_CODE', newValue);
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
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
				Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUST_CODE',
					textFieldName: 'CUST_NAME',
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUST_CODE', newValue);
									panelResult.setValue('CUST_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUST_NAME', '');
										panelResult.setValue('CUST_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUST_NAME', newValue);
									panelResult.setValue('CUST_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUST_CODE', '');
										panelResult.setValue('CUST_CODE', '');
									}
								}
						}
				}),
				{
				fieldLabel: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{	//20200218 추가: 조회조건 "기표여부" 추가
				fieldLabel	: '<t:message code="system.label.sales.slipyn" default="기표여부"/>',
				xtype		: 'radiogroup',
				itemId		: 'rdo',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					name		: 'rdoSelect',
					inputValue	: 'A',
					width		: 60,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
					name		: 'rdoSelect',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
					name		: 'rdoSelect',
					inputValue	: 'N',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
			}
		]},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.electronicbillnum" default="전자세금계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ISSUE_EXPDT_FR',
				endFieldName: 'ISSUE_EXPDT_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_EXPDT_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_EXPDT_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'IN_FR_DATE',
				endFieldName: 'IN_TO_DATE',
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM'
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'IN_WH_CODE',
				value: UserInfo.divCode,

				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
						var field2 = panelSearch.getField('IN_WH_CODE');
						field2.getStore().clearFilter(true);
						panelResult.setValue('IN_WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('BILL_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('BILL_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'IN_WH_CODE',
				xtype: 'uniCombobox',
				comboType  : 'O',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('IN_WH_CODE', newValue);
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
			},{
				fieldLabel		: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ISSUE_EXPDT_FR',
				endFieldName	: 'ISSUE_EXPDT_TO',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ISSUE_EXPDT_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ISSUE_EXPDT_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			},
				Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUST_CODE',
					textFieldName: 'CUST_NAME',
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUST_CODE', newValue);
									panelResult.setValue('CUST_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUST_NAME', '');
										panelResult.setValue('CUST_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUST_NAME', newValue);
									panelResult.setValue('CUST_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUST_CODE', '');
										panelResult.setValue('CUST_CODE', '');
									}
								}
						}
				}),
				{
					fieldLabel: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>',
					name: 'AGENT_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('AGENT_TYPE', newValue);
						}
					}
				},{	//20200218 추가: 조회조건 "기표여부" 추가
					fieldLabel	: '<t:message code="system.label.sales.slipyn" default="기표여부"/>',
					xtype		: 'radiogroup',
					itemId		: 'rdo',
					items		: [{
						boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
						name		: 'rdoSelect',
						inputValue	: 'A',
						width		: 60,
						checked		: true
					},{
						boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
						name		: 'rdoSelect',
						inputValue	: 'Y',
						width		: 60
					},{
						boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
						name		: 'rdoSelect',
						inputValue	: 'N',
						width		: 60
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
						}
					}
				}

				/*,
			{
				xtype: 'radiogroup',
				fieldLabel: '무역',
				id: 'rdo2',
				labelWidth: 90,
				items: [{
					boxLabel: '포함',
					width: 80,
					name: 'rdoSelect',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel: '포함안함',
					width: 80,
					name: 'rdoSelect',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
			}*/]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('map110skrvGrid1', {
    	// for tab
		layout: 'fit',
		region:'center',
		excelTitle: '<t:message code="system.label.purchase.creditpurchasestatusinquiry" default="외상매입현황 조회"/>',
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
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'INOUT_CODE'				, width: 53, hidden: true},
			{dataIndex: 'CUSTOM_NAME'				, width: 126,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customtotal" default="거래처계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }
			},
			{dataIndex: 'ORDER_TYPE'				, width: 100,align:'center'},
			{dataIndex: 'COMPANY_NUM'				, width: 120,align:'center'},
			{dataIndex: 'BILL_NUM'					, width: 120},
			{dataIndex: 'DIV_CODE'					, width: 100},
			{dataIndex: 'BILL_DATE'					, width: 86},
			{dataIndex: 'CHANGE_BASIS_DATE'			, width: 86, hidden: true},
			{dataIndex: 'ISSUE_EXPECTED_DATE'		, width: 86},
			{dataIndex: 'INOUT_DATE'				, width: 86},
			{dataIndex: 'ITEM_CODE'					, width: 120},
			{dataIndex: 'ITEM_NAME'					, width: 130},
			{dataIndex: 'SPEC'						, width: 133},
			{dataIndex: 'INOUT_Q'					, width: 66},
			{dataIndex: 'BUY_Q'						, width: 66,summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'				, width: 66,align:'center'},
			{dataIndex: 'MONEY_UNIT'				, width: 66,align:'center'},
			{dataIndex: 'AMOUNT_P'					, width: 100},
			{dataIndex: 'AMOUNT_I'					, width: 100,summaryType: 'sum'},
			{dataIndex: 'TAX_I'						, width: 80,summaryType: 'sum'},
			{dataIndex: 'TOTAL_I'					, width: 120,summaryType: 'sum'},
			{dataIndex: 'FOR_AMOUNT_O'				, width: 120},
			{dataIndex: 'EXCHG_RATE_O'				, width: 66},
			{dataIndex: 'INOUT_NUM'					, width: 120},
			{dataIndex: 'INOUT_METH'				, width: 66,align:'center'},
			{dataIndex: 'WH_CODE'					, width: 100,align:'center'},
			{dataIndex: 'EX_DATE'					, width: 86},
			{dataIndex: 'EX_NUM'					, width: 86},
			{dataIndex: 'AC_DATE'					, width: 86},
			{dataIndex: 'AC_NUM'					, width: 86},
			{dataIndex: 'AGREE_YN'					, width: 113},
			{dataIndex: 'REMARK'					, width: 133},
			{dataIndex: 'PROJECT_NO'				, width: 133}
		]
	});//End of var masterGrid = Unilite.createGrid('map110skrvGrid1', {

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
		id: 'map110skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('BILL_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('BILL_DATE_TO',UniDate.get('today'));
			panelResult.setValue('BILL_DATE_FR',UniDate.get('today'));
			panelResult.setValue('BILL_DATE_TO',UniDate.get('today'));
			//20200218 추가: 조회조건 "기표여부" 추가
			panelSearch.setValue('rdoSelect','A');
			panelResult.setValue('rdoSelect','A');

			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			//var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
			//console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    //viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
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
			masterGrid.reset();
			this.fnInitBinding();
		},
		onPrintButtonDown: function(){
			var param = panelResult.getValues();
			var selectedDetails = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				alert('출력할 데이터를 선택하여 주십시오.');
				return;
			}
            param.PGM_ID= PGM_ID;
            param.MAIN_CODE= 'M030';

			var win = Ext.create('widget.ClipReport', {
			url: CPATH+'/map/map110clskrv.do',
			prgID: 'map110skrv',
			extParam: param
			});
			win.center();
			win.show();
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};


</script>
