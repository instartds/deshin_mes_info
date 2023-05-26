<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map120skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map120skrv"/>				<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" opts= '${gsList1}'/>	<!-- 계산서유형 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var BsaCodeInfo = {
	gsList1: '${gsList1}'
};

function appMain() {
	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('Map120skrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'	, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'			, type: 'string'},
			{name: 'BILL_DATE'			, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'			, type: 'uniDate'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'		, type: 'string'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'		, type: 'uniPrice'},
			{name: 'VAT_AMOUNT_O'		, text: 'VAT'		, type: 'uniPrice'},
			{name: 'TOTAL'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'},
			{name: 'CHANGE_BASIS_DATE'	, text: '<t:message code="system.label.purchase.changebasisdate" default="지출결의일"/>'	, type: 'uniDate'},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'			, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '<t:message code="system.label.purchase.number" default="번호"/>'				, type: 'string'},
			{name: 'AC_DATE'			, text: '<t:message code="system.label.human.acdate" default="회계전표일"/>'				, type: 'uniDate'},		//20210524 추가
			{name: 'AC_NUM'				, text: '<t:message code="system.label.purchase.acslipno" default="회계전표번호"/>'		, type: 'string'},		//20210524 추가
			{name: 'ORG_AMT_I'			, text: '<t:message code="system.label.common.occuramount" default="발생금액"/>'		, type:'uniPrice'},		//20210524 추가
			{name: 'J_AMT_I'			, text: '반제금액'		, type:'uniPrice'},																		//20210524 추가
			{name: 'BLN_I'				, text: '잔액'		, type:'uniPrice'}																		//20210524 추가
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('map120skrvMasterStore1', {
		model	: 'Map120skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'map120skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'BILL_FR_DATE',
				endFieldName	: 'BILL_TO_DATE',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				width			: 315,
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('BILL_FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('BILL_TO_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},
			Unilite.popup('CUST', { 
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUST_CODE', 
				textFieldName	: 'CUST_NAME', 
				extParam		: {'CUSTOM_TYPE': ['1','2']},
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
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name		: 'BILL_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'A022',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EX_FR_DATE',
				endFieldName	: 'EX_TO_DATE',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('EX_FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('EX_TO_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>', 
				name		: 'AGENT_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'B055',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.autoslipyn" default="자동기표여부"/>',
				itemId		: 'rdo',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width		: 60,
					name		: 'rdoSelect',
					inputValue	: 'A', 
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
					width		: 60, 
					name		: 'rdoSelect',
					inputValue	: 'Y'
				},{
					boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
					width		: 60,
					name		: 'rdoSelect',
					inputValue	: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.classfication" default="구분"/>',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.billnoby" default="계산서번호별"/>',
					width		: 100,
					name		: 'GUBUN',
					inputValue	: '1',
					checked		: true 
				},{
					boxLabel	: '<t:message code="system.label.purchase.billnotypeby" default="계산서유형별"/>',
					width		: 170,
					name		: 'GUBUN',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
						UniAppManager.setToolbarButtons('save',false);
						if(newValue.GUBUN == '1' ){
							masterGrid.getColumn('BILL_NUM').setVisible(true);
							masterGrid.getColumn('BILL_DATE').setVisible(true);
							masterGrid.getColumn('EX_DATE').setVisible(true);
							masterGrid.getColumn('EX_NUM').setVisible(true);
							masterGrid.reset();
//							UniAppManager.app.onQueryButtonDown();
						}else if(newValue.GUBUN == '2' ){
							masterGrid.getColumn('BILL_NUM').setVisible(false);
							masterGrid.getColumn('BILL_DATE').setVisible(false);
							masterGrid.getColumn('EX_DATE').setVisible(false);
							masterGrid.getColumn('EX_NUM').setVisible(false);
							masterGrid.reset();
//							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			},{	//20210524 추가
				fieldLabel	: '지급여부',
				xtype		: 'radiogroup',
				itemId		: 'PROV_YN',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					name		: 'PROV_YN',
					inputValue	: 'A',
					width		: 60
				},{
					boxLabel	: '지급', 
					name		: 'PROV_YN',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '미지급',
					name		: 'PROV_YN',
					inputValue	: 'N',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('PROV_YN').setValue(newValue.PROV_YN);
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

					Unilite.messageBox(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>', 
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox', 
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'BILL_FR_DATE',
			endFieldName	: 'BILL_TO_DATE',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			width			: 315,
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('BILL_FR_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('BILL_TO_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
			valueFieldName	: 'CUST_CODE', 
			textFieldName	: 'CUST_NAME', 
			extParam		: {'CUSTOM_TYPE': ['1','2']},
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
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
			name		: 'BILL_TYPE', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'A022',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_TYPE', newValue);
//					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'EX_FR_DATE',
			endFieldName	: 'EX_TO_DATE',
			width			: 315,
			 onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('EX_FR_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('EX_TO_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>',
			name		: 'AGENT_TYPE', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B055',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.autoslipyn" default="자동기표여부"/>',
			itemId		: 'rdo2',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				width		: 60,
				name		: 'rdoSelect',
				inputValue	: 'A',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
				width		: 60,
				name		: 'rdoSelect',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
				width		: 60,
				name		: 'rdoSelect',
				inputValue	: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					UniAppManager.setToolbarButtons('save',false);
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.classfication" default="구분"/>',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.billnoby" default="계산서번호별"/>',
				width		: 100,
				name		: 'GUBUN',
				inputValue	: '1',
				checked		: true 
				
			},{
				boxLabel	: '<t:message code="system.label.purchase.billnotypeby" default="계산서유형별"/>',
				width		: 170,
				name		: 'GUBUN',
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.setToolbarButtons('save',false);
					panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
					if(newValue.GUBUN == '1' ){
						masterGrid.getColumn('BILL_NUM').setVisible(true);
						masterGrid.getColumn('BILL_DATE').setVisible(true);
						masterGrid.getColumn('EX_DATE').setVisible(true);
						masterGrid.getColumn('EX_NUM').setVisible(true);
						//20210524 추가
						masterGrid.getColumn('AC_DATE').setVisible(true);
						masterGrid.getColumn('AC_NUM').setVisible(true);
						masterGrid.getColumn('ORG_AMT_I').setVisible(true);
						masterGrid.getColumn('J_AMT_I').setVisible(true);
						masterGrid.getColumn('BLN_I').setVisible(true);
						masterGrid.reset();
						UniAppManager.setToolbarButtons('save',false);
//						UniAppManager.app.onQueryButtonDown();
					} else if(newValue.GUBUN == '2' ){
//						UniAppManager.setToolbarButtons('save',false);
						masterGrid.getColumn('BILL_NUM').setVisible(false);
						masterGrid.getColumn('BILL_DATE').setVisible(false);
						masterGrid.getColumn('EX_DATE').setVisible(false);
						masterGrid.getColumn('EX_NUM').setVisible(false);
						//20210524 추가
						masterGrid.getColumn('AC_DATE').setVisible(false);
						masterGrid.getColumn('AC_NUM').setVisible(false);
						masterGrid.getColumn('ORG_AMT_I').setVisible(false);
						masterGrid.getColumn('J_AMT_I').setVisible(false);
						masterGrid.getColumn('BLN_I').setVisible(false);
						//UniAppManager.setToolbarButtons('save',false);
						masterGrid.reset();
						UniAppManager.setToolbarButtons('save',false);
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		},{	//20210524 추가
			fieldLabel	: '지급여부',
			xtype		: 'radiogroup',
			itemId		: 'PROV_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'PROV_YN',
				inputValue	: 'A',
				width		: 60
			},{
				boxLabel	: '지급', 
				name		: 'PROV_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '미지급',
				name		: 'PROV_YN',
				inputValue	: 'N',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('PROV_YN').setValue(newValue.PROV_YN);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('map120skrvGrid1', {
		store		: directMasterStore1,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '<t:message code="system.label.purchase.creditpurchasetotalinquiry" default="외상매입금집계조회"/>',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns: [
			{dataIndex: 'CUSTOM_CODE'			, width: 88, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 250,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customtotal" default="거래처계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},
			{dataIndex: 'COMPANY_NUM'			, width: 150,align:'center'},
			{dataIndex: 'BILL_NUM'				, width: 150},
			{dataIndex: 'BILL_DATE'				, width: 86},
			{dataIndex: 'BILL_TYPE'				, width: 106, align:'center'},
			{dataIndex: 'AMOUNT_I'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'VAT_AMOUNT_O'			, width: 80	, summaryType: 'sum'},
			{dataIndex: 'TOTAL'					, width: 120, summaryType: 'sum'},
			{dataIndex: 'CHANGE_BASIS_DATE'		, width: 86	, hidden: true},
			{dataIndex: 'EX_DATE'				, width: 86},
			{dataIndex: 'EX_NUM'				, width: 40},
			{dataIndex: 'AC_DATE'				, width: 86},						//20210524 추가
			{dataIndex: 'AC_NUM'				, width: 86},						//20210524 추가
			{dataIndex: 'ORG_AMT_I'				, width: 120, hidden: true},		//20210524 추가
			{dataIndex: 'J_AMT_I'				, width: 120, summaryType: 'sum'},	//20210524 추가
			{dataIndex: 'BLN_I'					, width: 120, summaryType: 'sum'}	//20210524 추가
		]
	});



	Unilite.Main({
		id			: 'map120skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BILL_FR_DATE'	, UniDate.get('today'));
			panelResult.setValue('BILL_FR_DATE'	, UniDate.get('today'));
			panelSearch.setValue('BILL_TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('BILL_TO_DATE'	, UniDate.get('today'));
			panelSearch.setValue('rdoSelect'	, 'A');
			panelResult.setValue('rdoSelect'	, 'A');
			panelSearch.setValue('GUBUN'		, '1');
			panelResult.setValue('GUBUN'		, '1');
			panelSearch.getField('PROV_YN').setValue('A');	//20210524 추가
			panelResult.getField('PROV_YN').setValue('A');	//20210524 추가
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('reset'	, true);
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
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
		}
	});
};
</script>