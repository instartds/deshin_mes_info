<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa610skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa610skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Ssa610skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		, text:'<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_MONTH'		, text: '<t:message code="system.label.sales.salesmonth" default="매출월"/>'		, type: 'string'},
			{name: 'SALE_DATE'		, text: '<t:message code="system.label.sales.date" default="일자"/>'				, type: 'string'},
			{name: 'SALE_AMT'		, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniFC'},
			{name: 'COLLECT_AMT'	, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'	, type: 'uniFC'},
			{name: 'BALANCE_AMT'	, text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'		, type: 'uniFC'},
			{name: 'CARD_SALE'		, text: '<t:message code="system.label.sales.cardsale" default="카드매출"/>'		, type: 'uniFC'},
			{name: 'GUBUN'			, text: 'GUBUN'	,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa610skrvMasterStore1',{
		model	: 'Ssa610skrvModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
					read: 'ssa610skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'SALE_MONTH'
	});



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
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
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
					fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FrDate',
					endFieldName	: 'ToDate',
					allowBlank		: false,
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FrDate',newValue);
							//panelResult.getField('FrDate').validate();
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ToDate',newValue);
							//panelResult.getField('ToDate').validate();
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners	: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				})]
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
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
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
			fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'FrDate',
			endFieldName	: 'ToDate',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FrDate',newValue);
					//panelSearch.getField('FrDate').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ToDate',newValue);
					//panelSearch.getField('ToDate').validate();
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners	: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		})]
	});


	
	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa610skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: false},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 100 },
			{ dataIndex: 'SALE_MONTH'			, width: 133, hidden: true},
			{ dataIndex: 'SALE_DATE'			, width: 133, align: 'center',
				summaryType: function(records) {
					var rv="";
					if(records.length > 0) {
						var colData = records[0].data.SALE_DATE;
						if(Ext.isEmpty(colData)) {
							if( records.length > 1) {		// 이월된 금액 첫행의 일자 컬럼이 비어있음
								colData = records[1].data.SALE_DATE
							}
						}
						if(!Ext.isEmpty(colData)) {
							rv = (colData.substr(5,1)=='0') ? colData.substr(6,1): colData.substr(5,2);
							rv = rv+'<t:message code="system.label.sales.monthtotal" default="월계"/>';
						}
					}
					return rv;
				},
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, Ext.String.format('{0} ', value), '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'SALE_AMT'				, width: 266, summaryType: 'sum'  },
			{ dataIndex: 'COLLECT_AMT'			, width: 266, summaryType: 'sum'  },
			{ dataIndex: 'BALANCE_AMT'			, width: 266, /*summaryType: 'sum'*/
				summaryType: function(records) {
					var rv = 0;
					if(records != null && records.length > 0) {
						var record = records[records.length - 1];
						rv = record.get('BALANCE_AMT');
					}
//					Ext.each(records, function(record, index){
//						rv = Number(record.get('BALANCE_AMT'));
//					});
					return rv;
				}
			},
			{ dataIndex: 'CARD_SALE'			, width: 266}, 
			{ dataIndex: 'GUBUN'				, width: 133,hidden: true  }
		]
	});

	Unilite.Main({
		id			: 'ssa610skrvApp',
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
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			if(params && !Ext.isEmpty(params.CUSTOM_CODE)){
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var view = masterGrid.getView();								//20210511 주석: 그리드 백화현상 수정
//			view.getFeature('masterGridSubTotal').toggleSummaryRow(true);	//20210511 주석: 그리드 백화현상 수정
		},
		processParams: function(params) {
			panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
			panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
			panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
			panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
			panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
			panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>