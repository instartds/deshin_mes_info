<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo010skrv_wm">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>				<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>				<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>				<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM02"/>				<!-- 접수담당(01-홍길동(REF1-사용자ID)) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>				<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM12"/>				<!-- 수거방법(10-직접발송, 20-택배방문, 30-출장, 90-기타) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
</style>
<script type="text/javascript" >

function appMain() {
	var activeGridId = 's_mpo010skrv_wmGrid';
	var BsaCodeInfo	= {
		defaultRectiptPrsn	: '${defaultRectiptPrsn}',
		defaultSalesPrsn	: '${defaultSalesPrsn}',
		sendMailAddr		: '${sendMailAddr}', 
		gsUserSign			: '${gsUserSign}'
	}

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{ 
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'RECEIPT_DATE_FR',
				endFieldName	: 'RECEIPT_DATE_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('RECEIPT_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('RECEIPT_DATE_TO', newValue);
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
				name		: 'RECEIPT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'ZM02',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
				xtype		: 'uniTextfield',
				name		: 'CUSTOM_PRSN',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_PRSN', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}
			}),{
				fieldLabel	: '연락처',
				xtype		: 'uniTextfield',
				name		: 'PHONE_NUM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PHONE_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				xtype		: 'component',
				width		: 100
			},{
				fieldLabel	: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name		: 'CONTROL_STATUS',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'ZM03',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CONTROL_STATUS', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);

					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_TO', newValue);
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM02',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_PRSN', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PHONE_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
		},{
			xtype		: 'component',
			width		: 100
		},{
			fieldLabel	: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
			name		: 'CONTROL_STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM03',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CONTROL_STATUS', newValue);
				}
			}
		}]
	});



	Unilite.defineModel('s_mpo010skrv_wmMModel', {
		fields: [
			//S_MPO010T_WM (MASTER)
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, comboType:'BOR120'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'PHONE_NUM'		, text: '연락처'			, type: 'string'	, allowBlank: false},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'	, comboType:'AU' , comboCode:'S010'},
			{name: 'RECEIPT_TYPE'	, text: '접수구분'			, type: 'string'	, comboType:'AU' , comboCode:'ZM01'},
			{name: 'PRICE_TYPE'		, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string'	, comboType:'AU' , comboCode:'Z001'},
			{name: 'REPRE_NUM'		, text: '주민등록번호'		, type: 'string'},
			{name: 'REPRE_NUM_EXPOS', text: '주민등록번호'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '접수일'			, type: 'uniDate'},
			{name: 'RECEIPT_PRSN'	, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string'	, comboType:'AU' , comboCode:'ZM02'},
			//S_MPO020T_WM (DETAIL)
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'		, text: '입고수량'			, type: 'uniQty'	, allowBlank: true},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string'	, comboType:'AU' , comboCode:'ZM03'},
			{name: 'ARRIVAL_DATE'	, text: '도착일'			, type: 'uniDate'},
			{name: 'ARRIVAL_PRSN'	, text: '도착확인'			, type: 'string'	, comboType:'AU'	, comboCode:'ZM02'},
			{name: 'WORK_SEQ'		, text: '우선순위'			, type: 'int'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'RECEIPT_Q'		, text: '접수수량'			, type: 'uniQty'},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniPrice'},
			{name: 'DVRY_DATE'		, text: '도착예정일'			, type: 'uniDate'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT'	, type: 'string'},
			{name: 'EXCHG_RATE_O'	, text: 'EXCHG_RATE_O'	, type: 'uniER'},
			{name: 'ITEM_STATUS'	, text: '품목상태'			, type: 'string'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'M007', editable: false},
			//20201228 추가: 수거방법, 수거예정일, 지역
			{name: 'PICKUP_METHOD'	, text: '수거방법'			, type: 'string', comboType:'AU'	, comboCode:'ZM12'},
			{name: 'PICKUP_DATE'	, text: '수거예정일'			, type: 'uniDate'},
			{name: 'PICKUP_AREA'	, text: '지역'			, type: 'string', comboType:'AU'	, comboCode:'B056'}
		]
	});

	var masterStore = Unilite.createStore('s_mpo010skrv_wmMasterStore',{
		model	: 's_mpo010skrv_wmMModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mpo010skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mpo010skrv_wmGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true },	//20210113 추가: 합계 표시
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_PRSN'		, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData) {							//20210113 추가: 합계 표시
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'PHONE_NUM'			, width: 100},
			{dataIndex: 'ORDER_PRSN'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_TYPE'		, width: 80		, align: 'center', hidden: true},
			{dataIndex: 'PRICE_TYPE'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 100	, summaryType: 'sum'},	//20210113 수정: 도착수량 앞으로 위치 변경, 합계표시
			{dataIndex: 'RECEIPT_P'			, width: 100	},
			{dataIndex: 'RECEIPT_O'			, width: 120	, summaryType: 'sum'},
			{dataIndex: 'ITEM_STATUS'			, width: 90 , align: 'center' },
			{dataIndex: 'INSTOCK_Q'			, width: 100	, summaryType: 'sum'},	//20210113 수정: 합계표시
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
			{dataIndex: 'ARRIVAL_DATE'		, width: 100	, hidden: true},    //
			{dataIndex: 'ARRIVAL_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'WORK_SEQ'			, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80		, align: 'center'},
			{dataIndex: 'REPRE_NUM_EXPOS'	, width: 110},
			{dataIndex: 'RECEIPT_PRSN'		, width: 100	, align: 'center'},
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'DVRY_DATE'			, width: 100	, hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 100	, hidden: true	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 100	, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 66		, hidden: true	, align: 'center'},
			//20201228 추가: 수거방법, 수거예정일, 지역
			{dataIndex: 'PICKUP_METHOD'		, width: 100	, align: 'center' , hidden: true},
			{dataIndex: 'PICKUP_DATE'		, width: 100, hidden: true},
			{dataIndex: 'PICKUP_AREA'		, width: 100	, align: 'center', hidden: true}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		}
	});


	Unilite.Main({
		id			: 's_mpo010skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		},
			panelSearch
		],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('RECEIPT_PRSN'		, BsaCodeInfo.defaultRectiptPrsn);
			panelSearch.setValue('RECEIPT_DATE_TO'	, UniDate.get('today'));
			panelSearch.setValue('RECEIPT_DATE_FR'	, UniDate.add(panelSearch.getValue('RECEIPT_DATE_TO'), {weeks: -1}));

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('RECEIPT_PRSN'		, BsaCodeInfo.defaultRectiptPrsn);
			panelResult.setValue('RECEIPT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE_FR'	, UniDate.add(panelResult.getValue('RECEIPT_DATE_TO'), {weeks: -1}));

			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');

			panelSearch.setValue('ORDER_PRSN'	, BsaCodeInfo.defaultSalesPrsn);
			panelResult.setValue('ORDER_PRSN'	, BsaCodeInfo.defaultSalesPrsn);

			//초기화 시, 포커스 설정
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>