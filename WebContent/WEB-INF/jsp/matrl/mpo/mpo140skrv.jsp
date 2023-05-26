<%--
'   프로그램명 : 미입고현황조회 (구매재고)
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
<t:appConfig pgmId="mpo140skrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 발주단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정구분 -->
<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--입고창고-->
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
	Unilite.defineModel('Mpo140skrvModel', {
		fields: [
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'		, type: 'string'	, comboType: 'AU', comboCode: 'B013'},

//			{name: 'ORDER_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
//			{name: 'ORDER_P'        , text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'      , type: 'uniUnitPrice'},
//			{name: 'ORDER_O'        , text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'      , type: 'uniPrice'},

			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'   , text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'      , type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'   , text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'      , type: 'uniPrice'},
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},

			//20181022 추가
			{name: 'ORDER_UNIT_Q_I'	, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_O_I'	, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'		, type: 'uniPrice'},
			{name: 'NOTORDER_UNIT_Q', text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},

			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'INSTOCK_Q'		, text: '입고량(재고)'		, type: 'uniQty'},
			{name: 'INSTOCK_I'		, text: '입고금액(재고)'		, type: 'uniPrice'},
			{name: 'NOTINSTOCK_Q'	, text: '<t:message code="system.label.purchase.unreceiptqty2" default="미입고량(재고단위)"/>'		, type: 'uniQty'},

			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'PO_STATUS'		, text: '<t:message code="system.label.purchase.postatus" default="발주상태"/>'	    , type: 'string'},
			{name: 'AGREE_STATUS'   , text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'      , type: 'string',comboType:'AU' ,comboCode:'M007'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'		, type: 'string'},
			{name: 'REMARK2'		, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'		, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string',comboType:'AU' ,comboCode:'B020'}
		]
	});//End of Unilite.defineModel('Mpo140skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo140skrvMasterStore1', {
		model: 'Mpo140skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo140skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
        }
	});//End of var directMasterStore1 = Unilite.createStore('mpo140skrvMasterStore1', {

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
				allowBlank: true,
				width: 315,
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
						valueFieldName: 'CUST_CODE_FR',
						textFieldName: 'CUST_NAME_FR',
						textFieldWidth: 170,
						popupWidth: 710,
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUST_CODE_FR', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_NAME_FR', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUST_NAME_FR', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_CODE_FR', '');
										}
									}
						}
					}),
					Unilite.popup('CUST', {
						fieldLabel: '~',
						valueFieldName: 'CUST_CODE_TO',
						textFieldName: 'CUST_NAME_TO',
						textFieldWidth: 170,
						popupWidth: 710,
						allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
						listeners: {
									onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUST_CODE_TO', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_NAME_TO', '');
										}
									},
									onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
										panelSearch.setValue('CUST_NAME_TO', newValue);
										if(!Ext.isObject(oldValue)) {
											panelSearch.setValue('CUST_CODE_TO', '');
										}
									}
						}
					}),
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
						valueFieldName: 'ITEM_CODE_FR',
						textFieldName: 'ITEM_NAME_FR',
						textFieldWidth: 170,
						popupWidth: 710,
				    	allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
				    	listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelResult.setValue('ITEM_CODE_FR', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME_FR', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME_FR', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE_FR', '');
									}
								},
								applyextparam: function(popup){
		      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
		     					}
						}
					}),
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '~',
						valueFieldName: 'ITEM_CODE_TO',
						textFieldName: 'ITEM_NAME_TO',
						textFieldWidth: 170,
						popupWidth: 710,
				    	allowBlank:true,	// 2021.08 표준화 작업
						autoPopup:false,	// 2021.08 표준화 작업
						validateBlank:false,// 2021.08 표준화 작업
				    	listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelResult.setValue('ITEM_CODE_TO', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME_TO', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME_TO', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE_TO', '');
									}
								},
								applyextparam: function(popup){
		      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
		     					}
						}
					}),
			{
				fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315
			},(
				Unilite.popup('', {
					fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
					textFieldWidth: 70
			})),{
				fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
				name: 'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M007'
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name: 'CONTROL_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M002'
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201'
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
		layout : {type : 'uniTable', columns : 4},
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
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: true,
				width: 315,
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
	var masterGrid = Unilite.createGrid('mpo140skrvGrid1', {
    	// for tab
		layout: 'fit',
		region:'center',
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
			{dataIndex: 'ITEM_CODE'		, width: 113,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemtotal" default="품목계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 200},
			{dataIndex: 'CUSTOM_CODE'		, width: 60 , hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 126},
			{dataIndex: 'ORDER_DATE'		, width: 80},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
//			{dataIndex: 'ORDER_Q'			, width: 100, summaryType: 'sum'},
//			{dataIndex: 'ORDER_P'       	, width: 100, summaryType: 'sum'},
//			{dataIndex: 'ORDER_O'       	, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_O'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_Q'			, width: 100, summaryType: 'sum'},

			//20181022 추가
			{dataIndex: 'ORDER_UNIT_Q_I'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_O_I'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'NOTORDER_UNIT_Q'	, width: 100, summaryType: 'sum'},

			{dataIndex: 'STOCK_UNIT'		, width: 66 , align:'center'},
			{dataIndex: 'INSTOCK_Q'			, width: 100, summaryType: 'sum'	, hidden: true},
			{dataIndex: 'INSTOCK_I'			, width: 100, summaryType: 'sum'	, hidden: true},
			{dataIndex: 'NOTINSTOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 80 , align:'center'},
			{dataIndex: 'PO_STATUS'			, width: 80 , align:'center'},
			{dataIndex: 'AGREE_STATUS'  	, width: 80 , align:'center'},
			{dataIndex: 'REMARK'			, width: 250},
			{dataIndex: 'REMARK2'			, width: 250},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'ITEM_ACCOUNT'	, width: 100, align: 'center'}
		]
	});//End of var masterGrid = Unilite.createGrid('mpo140skrvGrid1', {

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
		id: 'mpo140skrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.reset();
			masterGrid.getStore().loadStoreRecords();

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
};//End of Unilite.Main({
</script>