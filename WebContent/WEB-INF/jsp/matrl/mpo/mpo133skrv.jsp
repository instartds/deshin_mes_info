<%--
'   프로그램명 : 발주현황(통합)조회
'
'   작  성  자 : 
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.2.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo133skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
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
	
	var gubunStore = Unilite.createStore('gubunComboStore', {
		fields	: ['text', 'value'],
		data	:	[
			{'text':'구매'	, 'value':'1'},
			{'text':'외주'	, 'value':'2'}
		]
	});
	
	Unilite.defineModel('Mpo133skrvModel1', {
	    fields: [
	    	{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.classfication" default="구분"/>'		, type: 'string'},
	    	{name: 'IN_DIV_CODE'	, text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'	, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type:'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type:'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type:'string'},
	    	{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
	    	{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type:'string'},
	    	{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},	    	
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},	    	
	    	{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},	    	
	    	{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},	    	
			{name: 'D_DAY'			, text: 'D-Day'		, type: 'string'},
	    	{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			, type: 'uniQty'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		, type: 'string'},	    	
	    	{name: 'ORDER_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
	    	{name: 'ORDER_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'	, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'	, type: 'uniER'},	    	
			{name: 'ORDER_LOC_P'	, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'			, type: 'uniUnitPrice'},
	    	{name: 'ORDER_LOC_O'	, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			, type: 'uniPrice'},
			{name: 'INSTOCK_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type:'uniQty'},
			{name: 'INSTOCK_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'	, type:'uniPrice'},
	    	{name: 'MAX_INOUT_DATE'	, text: '<t:message code="system.label.purchase.lastreceiptdate" default="최종입고일"/>'		, type: 'uniDate'},
	    	{name: 'UNDVRY_Q'		, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
	    	{name: 'ORDER_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>(<t:message code="system.label.purchase.stock" default="재고"/>)', type: 'uniQty'},
	    	{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
	    	{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
	    	{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
	    	{name: 'UNIT_PRICE_TYPE', text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string'},
	    	{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
	    	{name: 'SUPPLY_TYPE'	, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'		, type: 'string'},
	    	{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
	    	{name: 'PJT_NAME'		, text: '<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'			, type: 'string'},
	    	{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'RECEIPT_Q'	    , text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type:'uniQty'},
			{name:'MIN_RECEIPT_DATE', text:'최초접수일'		,type:'uniDate'},
			{name:'MAX_RECEIPT_DATE', text:'최종접수일'		,type:'uniDate'},
			{name:'DELAY'			, text:'지연일'				,type:'int'},
			{name: 'END_ORDER_Q'	, text: '마감량'		, type:'uniQty'},
			{name: 'END_ORDER_O'	, text: '마감금액'	, type:'uniPrice'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type:'string'},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.status" default="상태"/>'				, type:'string'},
	    	{name: 'PO_REQ_NUM'	    , text: '<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>' 	, type: 'string'},
			{name:'SO_CUSTOM_CODE'	, text:'수주처'				,type:'string'},
			{name:'SO_CUSTOM_NAME'	, text:'수주처명'				,type:'string'},
	    	{name: 'SO_NUM'			, text: '수주번호'		, type: 'string'},
	    	{name: 'SO_SEQ'			, text: '수주순번'		, type: 'string'},
	    	{name: 'SO_ITEM_CODE'	, text: '수주품번'		, type: 'string'},
	    	{name: 'SO_ITEM_NAME'	, text: '수주품명'		, type: 'string'},
			{name:'SO_ORDER_DATE'	, text:'수주일'				,type:'uniDate'},
			{name:'SO_DVRY_DATE'	, text:'수주납기'				,type:'uniDate'},
			{name:'SO_ORDER_Q'		, text:'수주량'				,type:'uniQty'}	
			]
	});//End of	Unilite.defineModel('Mpo133skrvModel1', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo133skrvMasterStore1', {
		model: 'Mpo133skrvModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo133skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ORDER_TYPE'
	});//End of var directMasterStore1 = Unilite.createStore('mpo133skrvMasterStore1', {

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
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false,
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
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
				}
			}),{
				fieldLabel	: '입고유무',
				name		: 'INOUT_FLAG',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'I008',
				value		: '3',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_FLAG', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				store		: gubunStore,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.deliverytime3" default="납품기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
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
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
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
				fieldLabel: '<t:message code="system.label.purchase.purchasereceiptcharger" default="구매/입고담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201'
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name: 'CONTROL_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M002'
			},{
				fieldLabel: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>',
				name: 'UNIT_PRICE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M301'
			},{
	            fieldLabel:'<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>',
	            name: 'PO_REQ_NUM',
	            id: 'PO_REQ_NUM',
	            xtype: 'uniTextfield'
	        },(
				Unilite.popup('', {
					fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
					name:'PROJECT_NO',
					textFieldWidth: 70
				})
			),{
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SO_DATE_FR',
				endFieldName: 'SO_DATE_TO',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SO_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SO_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.soplace" default="수주처"/>',
				valueFieldName: 'SO_CUSTOM_CODE',
				textFieldName: 'SO_CUSTOM_NAME',
				validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('SO_CUSTOM_CODE', panelSearch.getValue('SO_CUSTOM_CODE'));
							panelResult.setValue('SO_CUSTOM_NAME', panelSearch.getValue('SO_CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('SO_CUSTOM_CODE', '');
						panelResult.setValue('SO_CUSTOM_NAME', '');
					},
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
				}
			}),(
				Unilite.popup('', {
					fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
					name:'SO_NO',
					textFieldWidth: 70
				})
			)

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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [
			{
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
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false,
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
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
							panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					},
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
				}
			}),{
			fieldLabel	: '입고유무',
			name		: 'INOUT_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'I008',
			value		: '3',
			colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_FLAG', newValue);
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				store		: gubunStore,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.deliverytime3" default="납품기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DVRY_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
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
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
			}
			]
	    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mpo133skrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		store: directMasterStore1,
		features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
		flex: 1,
		columns: [
			{dataIndex: 'ORDER_TYPE'		, width: 86,align:'center'},
			{dataIndex: 'IN_DIV_CODE'        ,width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 90},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_DATE'        , width: 90},
			{dataIndex: 'ORDER_SEQ'			, width: 70,align:'center'},
			{dataIndex: 'ITEM_CODE'			, width: 133, locked: false},
			{dataIndex: 'ITEM_NAME'			, width: 200, locked: false},
			{dataIndex: 'SPEC'				, width: 133},
			{dataIndex: 'ORDER_UNIT'		, width: 66,align:'center'},
			{dataIndex: 'DVRY_DATE'			, width: 80,align:'center'},
			{dataIndex: 'D_DAY'				, width: 60 , align:'center',
				renderer:function(value, metaData, record) {
					var r = value;
					if(r == 'D-1') {
						r = '<span style="color:' + 'red' + ';">' + r +'</span>';					//빨갛게
					}
					return r;
				}
			},			
			{dataIndex: 'ORDER_UNIT_Q'		, width: 73, summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 66,align:'center'},
			{dataIndex: 'ORDER_P'		    , width: 86},
			{dataIndex: 'ORDER_O'			, width: 86, summaryType: 'sum'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 86,align:'right'},
			{dataIndex: 'ORDER_LOC_P'		, width: 86},
			{dataIndex: 'ORDER_LOC_O'		, width: 86, summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'			, width: 73, summaryType: 'sum'},
			{dataIndex: 'INSTOCK_O'			, width: 73, summaryType: 'sum'},
			{dataIndex: 'MAX_INOUT_DATE'	, width: 80,align:'center'},
			{dataIndex: 'UNDVRY_Q'			, width: 73, summaryType: 'sum'},
			{dataIndex: 'ORDER_Q'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'		, width: 73,align:'center'},
			{dataIndex: 'ORDER_PRSN'		, width: 86,align:'center'},
			{dataIndex: 'WH_CODE'			, width: 86,align:'center'},			
			{dataIndex: 'UNIT_PRICE_TYPE'	, width: 86,align:'center'},			
			{dataIndex: 'ITEM_ACCOUNT'		, width: 86},
			{dataIndex: 'SUPPLY_TYPE'		, width: 86},
			{dataIndex: 'PROJECT_NO'		, width: 100},
			{dataIndex: 'PJT_NAME'		    , width: 100},
			{dataIndex: 'REMARK'			, width: 86},	
			{dataIndex: 'RECEIPT_Q'		    , width: 86, summaryType: 'sum'},
			{dataIndex: 'MIN_RECEIPT_DATE'		, width: 86,align:'center'},
			{dataIndex: 'MAX_RECEIPT_DATE'		, width: 86,align:'center'},
			{dataIndex: 'DELAY'		, width: 86},
			{dataIndex: 'END_ORDER_Q'		,width: 90 , summaryType: 'sum'},
			{dataIndex: 'END_ORDER_O'		,width: 90 , summaryType: 'sum'},	
			{dataIndex: 'AGREE_STATUS'		,width: 90 , align:'center'},
			{dataIndex: 'CONTROL_STATUS'		,width: 90 , align:'center'},
			{dataIndex: 'PO_REQ_NUM'			, width: 120},
			{dataIndex: 'SO_CUSTOM_CODE'	, width: 90},
			{dataIndex: 'SO_CUSTOM_NAME'	, width: 120},
	    	{dataIndex: 'SO_NUM'			, width: 100},
	    	{dataIndex: 'SO_SEQ'			, width: 70,align:'center'},
	    	{dataIndex: 'SO_ITEM_CODE'	, width: 100},
	    	{dataIndex: 'SO_ITEM_NAME'	, width: 120},
			{dataIndex: 'SO_ORDER_DATE'	, width: 100,align:'center'},
			{dataIndex: 'SO_DVRY_DATE'	, width: 100,align:'center'},
			{dataIndex: 'SO_ORDER_Q'	, width: 100, summaryType: 'sum'}		

		]
	});//End of var masterGrid = Unilite.createGrid('mpo133skrvGrid1', {

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
		id: 'mpo133skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore1.loadData({});
			this.fnInitBinding();
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