<%--
'   프로그램명 : 발주대비 입고현황 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo135skrv"  >
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
	Unilite.defineModel('Mpo135skrvModel1', {
	    fields: [
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.supplycustom" default="공급처"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string'},
	    	{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
	    	{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
	    	{name: 'MAX_INOUT_DATE'		, text: '<t:message code="system.label.purchase.lastreceiptdate" default="최종입고일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			, type: 'uniQty'},
	    	{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		, type: 'string'},
	    	{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
	    	{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniFC'},
	    	{name: 'PURCHASE_BASE_P'	, text: '<t:message code="system.label.purchase.basisprice" default="기준단가"/>'			, type: 'uniUnitPrice'},
	    	{name: 'ORDER_O2'			, text: '<t:message code="system.label.purchase.changeamount" default="환산금액"/>'			, type: 'uniPrice'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'	, type: 'uniER'},
			{name: 'ORDER_LOC_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'			, type: 'uniUnitPrice'},
	    	{name: 'ORDER_LOC_O'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			, type: 'uniPrice'},
			
	    	{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>(<t:message code="system.label.purchase.stock" default="재고"/>)'		, type: 'uniQty'},
	    	{name: 'PO_REQ_NUM'	        , text: '<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>' 	, type: 'string'},
	    	{name: 'SALE_ORDER_NUM'			, text: '수주번호'		, type: 'string'},
	    	{name: 'SALE_SER_NO'			, text: '수주순번'		, type: 'string'},
	    	{name: 'SALE_ITEM_CODE'			, text: '수주품번'		, type: 'string'},
	    	{name: 'SALE_ITEM_NAME'			, text: '수주품명'		, type: 'string'},
	    	{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'},
	    	{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
	    	{name: 'UNDVRY_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
	    	{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
	    	{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
	    	{name: 'ORDER_NUMBER'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			, type: 'string'},
	    	{name: 'CONTROL_STATUS'		, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			, type: 'string'},
	    	{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
	    	{name: 'REMARK2'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'			, type: 'string'},
	    	{name: 'LINK_PAGE'			, text: 'LINK_PAGE'		, type: 'string'},
	    	{name: 'ORDER_NUM'			, text: 'ORDER_NUM'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'	, type: 'string'},
	    	{name: 'AGREE_STATUS'		, text: 'AGREE_STATUS'	, type: 'string'},
	    	{name: 'AGREE_DATE'			, text: 'AGREE_DATE'	, type: 'string'},
	    	{name: 'LC_NUM'				, text: 'LC_NUM'		, type: 'string'},
	    	{name: 'RECEIPT_TYPE'		, text: 'RECEIPT_TYPE'	, type: 'string'},
	    	{name: 'REMARK1'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'		, type: 'string'},
	    	
	    	{name: 'DRAFT_YN'			, text: 'DRAFT_YN'		, type: 'string'},
	    	{name: 'AGREE_PRSN'			, text: 'AGREE_PRSN'	, type: 'string'},
	    	{name: 'IN_DIV_CODE'      ,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>',type: 'string', allowBlank: false , comboType: 'BOR120'}
	    ]
	});//End of	Unilite.defineModel('Mpo135skrvModel1', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo135skrvMasterStore1', {
		model: 'Mpo135skrvModel1',
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
				read: 'mpo135skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
		//groupField: 'CUSTOM_NAME'
	});//End of var directMasterStore1 = Unilite.createStore('mpo135skrvMasterStore1', {

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
				fieldLabel: '<t:message code="system.label.purchase.inquiryperiod" default="조회기간"/>',
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
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.supplycustom" default="공급처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
		                    applyextparam: function(popup){
		                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
		                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
				}
			}),
			Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				})]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name: 'CONTROL_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M002'
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasereceiptcharger" default="구매/입고담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201'
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.closingyn" default="마감여부"/>',
				id: 'rdoSelect',
					items: [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'AGREE_STATUS',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.closing" default="마감"/>',
						width: 60,
						name: 'AGREE_STATUS',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.noclosing" default="미마감"/>',
						width: 60,
						name: 'AGREE_STATUS',
						inputValue: 'N'
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.accountclass" default="계정구분"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},(
				Unilite.popup('', {
					fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
					name:'PROJECT_NO',
					textFieldWidth: 70
				})
			),{
				fieldLabel: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>',
				name: 'UNIT_PRICE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M301'
			},
			/* Unilite.popup('PO_REQ_NUM', {
				fieldLabel: '구매계획번호',
				valueFieldName: 'PO_REQ_NUM',
				textFieldName: 'PO_REQ_NUM'
			})	 */
	        {
	            fieldLabel:'<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>',
	            name: 'PO_REQ_NUM',
	            id: 'PO_REQ_NUM',
	            xtype: 'uniTextfield'
	        }

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
		layout : {type : 'uniTable', columns : 3},
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
				fieldLabel: '<t:message code="system.label.purchase.inquiryperiod" default="조회기간"/>',
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
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.supplycustom" default="공급처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
		                    applyextparam: function(popup){
		                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
		                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                    }
				}
			}),
			Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				})
			]
	    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{




	    /*      //POPUP
 	    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
			if(!SearchInfoWindow) {
				SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
	            	title: '구매의뢰번호검색',
	                width: 1080,
	                height: 580,
	                layout: {type:'vbox', align:'stretch'},
	                items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
	                tbar:  ['->',{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							orderNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							SearchInfoWindow.hide();
							Ext.getCmp('PO_REQ_NUM').setConfig('readOnly',true);
						},
						disabled: false
					}],
					listeners : {
						beforehide: function(me, eOpt)	{
							orderNoSearch.clearForm();
							orderNoMasterGrid.reset();
						},
						beforeclose: function( panel, eOpts )	{
							orderNoSearch.clearForm();
							orderNoMasterGrid.reset();
						},
						show: function( panel, eOpts )	{
	                        orderNoSearch.setValue('DIV_CODE',       panelResult.getValue('DIV_CODE'));
	                        orderNoSearch.setValue('DEPT_CODE',      panelResult.getValue('DEPT_CODE'));
	                        orderNoSearch.setValue('DEPT_NAME',      panelResult.getValue('DEPT_NAME'));
	                        orderNoSearch.setValue('PERSON_NUMB',    panelResult.getValue('PERSON_NUMB'));
	                        orderNoSearch.setValue('PERSON_NAME',    panelResult.getValue('PERSON_NAME'));
	                        orderNoSearch.setValue('ITEM_ACCOUNT',   panelResult.getValue('ITEM_ACCOUNT'));
	                        orderNoSearch.setValue('SUPPLY_TYPE',    panelResult.getValue('SUPPLY_TYPE'));
	                        orderNoSearch.setValue('PO_REQ_DATE_FR',   UniDate.get('startOfMonth'));
	                        orderNoSearch.setValue('PO_REQ_DATE_TO',   UniDate.get('today'));
						}
					}
				})
			}
			SearchInfoWindow.center();
			SearchInfoWindow.show();
	    };

	  var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
			layout: {type: 'uniTable', columns : 3},
		    trackResetOnLoad: true,
		    items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank: false
			},
			{
				fieldLabel: '요청일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PO_REQ_DATE_FR',
				endFieldName: 'PO_REQ_DATE_TO',
	            allowBlank: false,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						if(authoInfo == "A"){	//자기사업장
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			{
				fieldLabel: '조달구분',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B014'
			},
			{
				fieldLabel: '품목계정',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'PERSON_NAME',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NAME', newValue);
					}
				}
			})],
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
	                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	                    }
	                    alert(labelText+Msg.sMB083);
	                    invalid.items[0].focus();
	                } else {
	                    var fields = this.getForm().getFields();
	                    Ext.each(fields.items, function(item) {
	                        if(Ext.isDefined(item.holdable) )   {
	                            if (item.holdable == 'hold') {
	                                item.setReadOnly(true);
	                            }
	                        }
	                        if(item.isPopupField)   {
	                            var popupFC = item.up('uniPopupField')  ;
	                            if(popupFC.holdable == 'hold') {
	                                popupFC.setReadOnly(true);
	                            }
	                        }
	                    })
	                }
	            } else {
	                var fields = this.getForm().getFields();
	                Ext.each(fields.items, function(item) {
	                    if(Ext.isDefined(item.holdable) )   {
	                        if (item.holdable == 'hold') {
	                            item.setReadOnly(false);
	                        }
	                    }
	                    if(item.isPopupField)   {
	                        var popupFC = item.up('uniPopupField')  ;
	                        if(popupFC.holdable == 'hold' ) {
	                            item.setReadOnly(false);
	                        }
	                    }
	                })
	            }
	            return r;
	        }
	    });
	    var orderNoMasterGrid = Unilite.createGrid('s_mre101ukrv_kdOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창 (의뢰번호)
			layout : 'fit',
	        //excelTitle: '구매요청등록(의뢰번호검색)',
			store: orderNoMasterStore,
			uniOpt:{
				expandLastColumn: false,
				useRowNumberer: false
			},
	        columns: [
	            { dataIndex: 'PO_REQ_DATE'		    ,  width: 80},
	            { dataIndex: 'SUPPLY_TYPE'		    ,  width: 70,align:'center'},
	            { dataIndex: 'PO_REQ_NUM'		    ,  width: 133},
	            { dataIndex: 'PO_SER_NO'		    ,  width: 80,hidden:true},

	            { dataIndex: 'ITEM_CODE'		    ,  width: 100},
	            { dataIndex: 'ITEM_NAME'		    ,  width: 120},
	            { dataIndex: 'CUSTOM_CODE'	    ,  width: 80,hidden:true},
	            { dataIndex: 'CUSTOM_NAME'	    ,  width: 120},

	            { dataIndex: 'DEPT_CODE'	   		,  width: 80},
	            { dataIndex: 'DEPT_NAME'	   		,  width: 80},
	            { dataIndex: 'PERSON_NUMB'		    ,  width: 80,align:'center'},
	            { dataIndex: 'PERSON_NAME'	        ,  width: 80,align:'center'},
	            { dataIndex: 'GW_STATUS'	        ,  width: 60,align:'center'},
	            { dataIndex: 'MONEY_UNIT'		    ,  width: 100,align:'center',hidden:true},
	            { dataIndex: 'EXCHG_RATE_O'         ,  width: 100,hidden:true},
	            { dataIndex: 'DIV_CODE'		        ,  width: 66,hidden:true},
	            { dataIndex: 'ITEM_ACCOUNT'		        ,  width: 66,hidden:true}

			],
			listeners: {
				onGridDblClick: function(grid, record, cellIndex, colName) {
					orderNoMasterGrid.returnData(record);
					//UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
				}
			},
			returnData: function(record)	{
				if(Ext.isEmpty(record))	{
					record = this.getSelectedRecord();
				}
				panelResult.setValues({
	                'DIV_CODE'          :record.data.DIV_CODE,
	                'PO_REQ_NUM'        :record.data.PO_REQ_NUM,
	                'PO_REQ_DATE'       :record.data.PO_REQ_DATE,
	                'MONEY_UNIT'        :record.data.MONEY_UNIT,
	                'EXCHG_RATE_O'      :record.data.EXCHG_RATE_O,

	                'DEPT_CODE'         :record.data.DEPT_CODE,
	                'DEPT_NAME'         :record.data.DEPT_NAME,
	                'PERSON_NUMB'       :record.data.PERSON_NUMB,
	                'PERSON_NAME'       :record.data.PERSON_NAME,

	                'SUPPLY_TYPE'       :record.data.SUPPLY_TYPE,
	                'ITEM_ACCOUNT'      :record.data.ITEM_ACCOUNT
	            });
	          	panelResult.setAllFieldsReadOnly(true);
	            panelResult.setAllFieldsReadOnly(true);
	          	directMasterStore1.loadStoreRecords();
			}
	    });
	    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창(의뢰번호)
			model: 'orderNoMasterModel',
			autoLoad: false,
			uniOpt: {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read    : 'mpo135skrvService.selectOrderNumMasterList'
				}
			},
			loadStoreRecords : function()	{
				var param= orderNoSearch.getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			}
		}); */
	    //END OF POPUP



    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mpo135skrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
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
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
		flex: 1,
		columns: [
			{dataIndex:'IN_DIV_CODE'          ,width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 133, locked: false},
			{dataIndex: 'ITEM_NAME'			, width: 200, locked: false},
			{dataIndex: 'SPEC'				, width: 133},
			{dataIndex: 'CUSTOM_NAME'		, width: 100},
			{dataIndex: 'ORDER_TYPE'		, width: 86,align:'center'},
			{dataIndex: 'ORDER_DATE'		, width: 80},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'ORDER_UNIT'		, width: 66,align:'center'},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 73},
			{dataIndex: 'INSTOCK_Q'			, width: 73},
			{dataIndex: 'UNDVRY_Q'			, width: 73},
			{dataIndex: 'MAX_INOUT_DATE'	, width: 80},
			{dataIndex: 'MONEY_UNIT'		, width: 66,align:'center'},
			{dataIndex: 'ORDER_UNIT_P'		, width: 86},
			{dataIndex: 'ORDER_O'			, width: 86},
			{dataIndex: 'PURCHASE_BASE_P'	, width: 86, hidden: true},
			{dataIndex: 'ORDER_O2'			, width: 86, hidden: true},
			{dataIndex: 'EXCHG_RATE_O'		, width: 86,align:'right'},			
			{dataIndex: 'ORDER_LOC_P'		, width: 86},
			{dataIndex: 'ORDER_LOC_O'			, width: 86},			
			{dataIndex: 'ORDER_Q'			, width: 86},
			{dataIndex: 'STOCK_UNIT'		, width: 73,align:'center'},
			{dataIndex: 'ORDER_PRSN'		, width: 86,align:'center'},
			{dataIndex: 'WH_CODE'			, width: 86,align:'center'},
			{dataIndex: 'ORDER_NUMBER'		, width: 150},
			{dataIndex: 'PO_REQ_NUM'			, width: 120},
			{dataIndex: 'SALE_ORDER_NUM'			, width: 120},
			{dataIndex: 'SALE_SER_NO'			, width: 88},
			{dataIndex: 'SALE_ITEM_CODE'			, width: 120},
			{dataIndex: 'SALE_ITEM_NAME'			, width: 150},
			{dataIndex: 'CONTROL_STATUS'	, width: 86,align:'center'},
			{dataIndex: 'UNIT_PRICE_TYPE'	, width: 86,align:'center'},
			{dataIndex: 'PROJECT_NO'		, width: 100},
			{dataIndex: 'REMARK2'			, width: 86},
			{dataIndex: 'LINK_PAGE'			, width: 86, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 86, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 86, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 86, hidden: true},
			{dataIndex: 'AGREE_DATE'		, width: 86, hidden: true},
			{dataIndex: 'LC_NUM'			, width: 86, hidden: true},
			{dataIndex: 'RECEIPT_TYPE'		, width: 86, hidden: true},
			{dataIndex: 'REMARK1'			, width: 86, hidden: true},
			{dataIndex: 'DRAFT_YN'			, width: 86, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 86, hidden: true},
			{dataIndex: 'AGREE_PRSN'		, width: 86, hidden: true}
		],
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '발주등록 바로가기',
					//iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender: me,
							'PGM_ID'	: 'mpo135skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ORDER_NUM	: record.data.ORDER_NUM,
							CUSTOM_CODE	: record.data.CUSTOM_CODE,
							CUSTOM_NAME	: record.data.CUSTOM_NAME,
							ORDER_DATE	: record.data.ORDER_DATE,
							MONEY_UNIT	: record.data.MONEY_UNIT,
							PROJECT_NO	: record.data.PROJECT_NO
						};
						var rec = {data : {prgID : 'mpo502ukrv', 'text':''}};
						parent.openTab(rec, '/matrl/mpo502ukrv.do', params);
					}
				});
			}
		}
	});//End of var masterGrid = Unilite.createGrid('mpo135skrvGrid1', {

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
		id: 'mpo135skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
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