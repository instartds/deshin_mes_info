<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa620skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa620skrv" />	<!-- 사업장 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/** 구분 컬럼 스토어 생성 - 20190911 추가
	 */
	var gubunStore = Unilite.createStore('gubunStore',{
		fields	: ['text','value'],
		data	: [{
			text	: '',
			value	: '01'
		},{
			text	: '발행',
			value	: '02'
		},{
			text	: '수금',
			value	: '03'
		},{
			text	: '',
			value	: '04'
		},{
			text	: '미발행',
			value	: '05'
		},{
			text	: '카드매출',
			value	: '06'
		},{
			text	: '합계',
			value	: '07'
		}]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('ssa620skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type:'string', comboType: 'BOR120'},
			{name: 'PUB_NUM'		,text: '<t:message code="system.label.sales.billnum" default="세금계산서번호"/>'		,type: 'string'},
			{name: 'BILL_NUM'		,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'			,type: 'string'},
			{name: 'SALE_MONTH'		,text: '<t:message code="system.label.sales.salesmonth" default="매출월"/>'		,type: 'string'},
			{name: 'SALE_DATE'		,text: '<t:message code="system.label.sales.date" default="일자"/>'				,type: 'string'},
			{name: 'SALE_AMT'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		,type: 'uniFC'},
			{name: 'COLLECT_AMT'	,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'	,type: 'uniFC'},
			{name: 'BALANCE_AMT'	,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'		,type: 'uniFC'},
			{name: 'GUBUN'			,text: '<t:message code="system.label.sales.classfication" default="구분"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('gubunStore')},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}
		]
	});

	Unilite.defineModel('ssa620skrvModel2', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type:'string', comboType: 'BOR120'},
			{name: 'SALE_DATE'		,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			,type: 'uniDate'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'SALE_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string'},
			{name: 'SALE_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'SALE_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'SALE_AMT_O'		,text: '<t:message code="system.label.common.amount" default="금액"/>' 			,type: 'uniPrice'},
			{name: 'TAX_AMT_O'		,text: '<t:message code="system.label.sales.vat" default="부가세"/>'				,type: 'uniPrice'},
			{name: 'SALE_TOT_O'		,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'		,type: 'uniPrice'},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
			{name: 'SALE_NAME'		,text: '<t:message code="system.label.sales.salename" default="영업담당"/>'			,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa620skrvMasterStore1',{
		model	: 'ssa620skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa620skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					//20200514 수정: 전체적으로 if(i != 0) { 로직 추가
					Ext.each(records, function(record, i){
						//20190911 로직 추가 - 월합계의 경우 이전 행의 미수잔액을 그대로 보여 줌
						if(record.get('GUBUN') == '04') {
							if(i == 0) {
								record.set('BALANCE_AMT', 0);
							} else {
								var preRecord = store.getAt(i-1);		//대상행의 이전 행
								record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT'));
							}
						}
						//20190911 로직 추가 - 미발행의 경우 이전행의 미수잔액에 미발행된 매출액을 더해서 미수잔액을 표기
						if(record.get('GUBUN') == '05') {
							if(i == 0) {
								record.set('BALANCE_AMT', record.get('SALE_AMT') - record.get('COLLECT_AMT'));
							} else {
								var preRecord = store.getAt(i-1);		//대상행의 이전 행
								record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT') + record.get('SALE_AMT') - record.get('COLLECT_AMT'));
							}
						}
						//20190911 로직 추가 - 합계의 경우 이전행의 미수잔액을 표시 
						if(record.get('GUBUN') == '06') {
							if(i == 0) {
								record.set('BALANCE_AMT', 0);
							} else {
								var preRecord = store.getAt(i-1);		//대상행의 이전 행
								record.set('BALANCE_AMT', preRecord.get('BALANCE_AMT'));
							}
						}
					});
					this.commitChanges();
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}/*,
		groupField: 'SALE_MONTH'*/
	});

	var directMasterStore2 = Unilite.createStore('ssa620skrvMasterStore2',{
		model	: 'ssa620skrvModel2',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa620skrvService.selectList2'
			}
		},
		loadStoreRecords: function(record) {
			var param		= Ext.getCmp('searchForm').getValues();
			param.PUB_NUM	= record.get('PUB_NUM');
			param.BILL_NUM	= record.get('BILL_NUM');
			console.log( param );
			this.load({
				params: param
			});
		}/*,
		groupField: 'SALE_MONTH'*/
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
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
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
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FrDate',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ToDate',newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					allowBlank	: false,
					listeners	: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
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
					var labelText = ''
					r = false;
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
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
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
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FrDate',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ToDate',newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			allowBlank	: false,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa620skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: true},
		selModel: 'rowmodel',
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
		 			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
//			{ dataIndex: 'DIV_CODE'		, width: 100 },
			{ dataIndex: 'PUB_NUM'		, width: 120 },
//			{ dataIndex: 'BILL_NUM'		, width: 120 },
//			{ dataIndex: 'SALE_MONTH'	, width: 133, hidden: true},
			{ dataIndex: 'SALE_DATE'	, width: 90	, align: 'center',
				summaryType: function(records) {
					var rv="";
					if(records.length > 0) {
						var colData = records[0].data.SALE_DATE;
						if(Ext.isEmpty(colData)) {
							if( records.length > 1) {  // 이월된 금액 첫행의 일자 컬럼이 비어있음
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
			{ dataIndex: 'GUBUN'		, width: 133, align: 'center'},
			{ dataIndex: 'SALE_AMT'		, width: 200, summaryType: 'sum'},
			{ dataIndex: 'COLLECT_AMT'	, width: 200, summaryType: 'sum'},
			{ dataIndex: 'BALANCE_AMT'	, width: 200, summaryType: 'sum'},
			{ dataIndex: 'REMARK'		, width: 233}
		], 
		listeners: {
//			selectionChange: function( gird, selected, eOpts )	{
			select: function(grid, selected, index, rowIndex, eOpts ){
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected) 
				&& (selected.get('GUBUN') == '02' || selected.get('GUBUN') == '05')) {
					masterGrid2.getStore().loadStoreRecords(selected);
				} else {
					masterGrid2.getStore().loadData({});
				}
			}
		}/*,//20190911 안 이뻐서 일단 대기
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('GUBUN') == '06') {
					cls = 'x-change-cell_dark';
				} else if(record.get('GUBUN') == '04'){
					cls = 'x-change-cell_normal';
				}
				return cls;
			}
		}*/
	});

	var masterGrid2 = Unilite.createGrid('ssa620skrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {useRowNumberer: true},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
		 			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
//			{ dataIndex: 'DIV_CODE'		, width: 100},
			{ dataIndex: 'SALE_DATE'	, width: 90 },
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 200},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'SALE_UNIT'	, width: 80 },
			{ dataIndex: 'SALE_Q'		, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'SALE_P'		, width: 110},
			{ dataIndex: 'SALE_AMT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'TAX_AMT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'SALE_TOT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'REMARK'		, width: 233},
			{ dataIndex: 'SALE_NAME'	, width: 100}
		]
	});



	Unilite.Main({
		id			: 'ssa620skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult, masterGrid2
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(params && !Ext.isEmpty(params.CUSTOM_CODE)){
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			var view = masterGrid.getView();
			view.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		},
		processParams: function(params) {
			panelSearch.setValue('DIV_CODE', params.DIV_CODE);
			panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
			panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
			panelResult.setValue('DIV_CODE', params.DIV_CODE);
			panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
			panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>