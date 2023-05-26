<%--
'   프로그램명 : 매출등록 (영업)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa390skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa390skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>			<!-- 세액포함여부 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

function appMain() {

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
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
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'SALE_CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('SALE_CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('SALE_CUSTOM_CODE', '');
							panelResult.setValue('SALE_CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
					}
				}
			}),{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				width	: 300,
				items	: [{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.sales.contractendyn" default="계약종료여부"/>',
					name		: 'CONT_STATE',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
						name		: 'CONT_STATE',
						inputValue	: '', 
						width		: 60
					},{
						boxLabel	: '<t:message code="system.label.sales.end" default="종료"/>',
						name		: 'CONT_STATE',
						inputValue	: '9', 
						width		: 60
					},{
						boxLabel	: '<t:message code="system.label.sales.contract" default="계약"/>',
						name		: 'CONT_STATE',
						inputValue	: '1', 
						width		: 60
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('CONT_STATE').setValue(newValue.CONT_STATE);
						}
					}
				}]
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
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('SALE_CUSTOM_CODE', '');
						panelResult.setValue('SALE_CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractendyn" default="계약종료여부"/>',
				name		: 'CONT_STATE',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'CONT_STATE',
					inputValue	: '', 
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.end" default="종료"/>',
					name		: 'CONT_STATE',
					inputValue	: '9', 
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.contract" default="계약"/>',
					name		: 'CONT_STATE',
					inputValue	: '1', 
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CONT_STATE').setValue(newValue.CONT_STATE);
					}
				}
			}]
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
			}
		}
	});

	//마스터 모델
	Unilite.defineModel('Ssa390ukrvMModel',{
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'	, allowBlank: false},
			{name: 'CONT_NUM'		, text: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'CONT_GUBUN'		, text: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>'	, type: 'string'},
			{name: 'CONT_DATE'		, text: '<t:message code="system.label.sales.contractdate" default="계약일"/>'				, type: 'uniDate'},
			{name: 'CONT_AMT'		, text: '<t:message code="system.label.sales.contractamount" default="계약금액"/>'			, type: 'uniPrice'},
			{name: 'REMAIN_AMT'		, text:	'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'			, type: 'uniPrice'},
			{name: 'SALE_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'CONT_STATE'		, text: '<t:message code="system.label.sales.contractstatus" default="계약상태"/>'			, type: 'string'},
			{name: 'CONT_FR_DATE'	, text: '<t:message code="system.label.sales.contractedperiod" default="계약기간"/>FR'		, type: 'uniDate'},
			{name: 'CONT_TO_DATE'	, text: '<t:message code="system.label.sales.contractedperiod" default="계약기간"/>TO'		, type: 'uniDate'},
			{name: 'CONT_MONTH'		, text: '<t:message code="system.label.sales.monthsofcontract" default="계약월수"/>'		, type: 'int'},
			{name: 'MONTH_MAINT_AMT', text: '<t:message code="system.label.sales.monthmaintenancecost" default="월유지보수비"/>'	, type: 'uniPrice'},
			{name: 'CHAGE_DAY'		, text: '<t:message code="system.label.sales.billingdate" default="청구일"/>'				, type: 'int'},
			{name: 'TAX_IN_OUT'		, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		, type: 'string'	, comboType:'AU'	, comboCode: 'B030'},
			{name: 'REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'}
		]
	});
	//디테일 모델
	Unilite.defineModel('Ssa390ukrvDModel',{
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				, type: 'uniDate'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S024'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'SALE_TYPE_NAME'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'SALE_TOT_O'			, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'			, type: 'uniPrice'},
			{name: 'REMAIN_AMT'			, text:	'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'			, type: 'uniPrice'},
			{name: 'SALE_LOC_AMT_I'		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'		, type: 'uniPrice'},
			{name: 'SALE_LOC_EXP_I'		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'	, type: 'uniPrice'},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'			, type: 'uniPrice'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'SALE_PRSN_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var directMasterStore = Unilite.createStore('ssa101ukrvDirectMasterStore',{
		model	: 'Ssa390ukrvMModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa390skrvService.selectMaster'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	//디테일 스토어 정의
	var directDetailStore = Unilite.createStore('ssa101ukrvDirectDetailStore',{
		model	: 'Ssa390ukrvDModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa390skrvService.selectDetailList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function(record) {
			var param= panelResult.getValues();
			param.ORDER_NUM	= record.get('CONT_NUM');
			param.CONT_AMT	= record.get('CONT_AMT');
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	//마스터 그리드
	var masterGrid = Unilite.createGrid('ssa390skrvMGrid',{
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false,
			copiedRow		: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'CONT_NUM'			, width: 120	, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 150},
			{ dataIndex: 'CONT_GUBUN'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_DATE'		, width: 80},
			{ dataIndex: 'CONT_AMT'			, width: 100},
			{ dataIndex: 'REMAIN_AMT'		, width: 100},
			{ dataIndex: 'SALE_PRSN'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_STATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_FR_DATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_TO_DATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_MONTH'		, width: 100	, hidden: true},
			{ dataIndex: 'MONTH_MAINT_AMT'	, width: 100	, hidden: true},
			{ dataIndex: 'CHAGE_DAY'		, width: 100	, hidden: true},
			{ dataIndex: 'TAX_IN_OUT'		, width: 100	, hidden: true},
			{ dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			select: function( model1, selected, eOpts ){
				if(!Ext.isEmpty(selected)) {
					detailGrid.getStore().loadStoreRecords(selected);
				}
			}
		}
	});
	//디테일 그리드
	var detailGrid = Unilite.createGrid('ssa390skrvDGrid',{
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'east',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false,
			copiedRow		: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'SALE_CUSTOM_CODE'	, width: 100	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 130	, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 120	, hidden: true},
			{ dataIndex: 'ITEM_NAME'		, width: 166	, hidden: true},
			{ dataIndex: 'SALE_DATE'		, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
			},
			{ dataIndex: 'BILL_TYPE'		, width: 73		, hidden: true},
			{ dataIndex: 'SALE_TYPE'		, width: 100	, hidden: true},
			{ dataIndex: 'SALE_TYPE_NAME'	, width: 100	, hidden: true},
			{ dataIndex: 'SALE_Q'			, width: 86		, hidden: true},
			{ dataIndex: 'SALE_TOT_O'		, width: 86		, summaryType: 'sum'},
			{ dataIndex: 'REMAIN_AMT'		, width: 100	, summaryType: 'min'},
			{ dataIndex: 'SALE_LOC_AMT_I'	, width: 86		, hidden: true},
			{ dataIndex: 'SALE_LOC_EXP_I'	, width: 80		, hidden: true},
			{ dataIndex: 'TAX_AMT_O'		, width: 80		, hidden: true},
			{ dataIndex: 'SALE_PRSN'		, width: 100	, hidden: true},
			{ dataIndex: 'SALE_PRSN_NAME'	, width: 66		, hidden: true},
			{ dataIndex: 'BILL_NUM'			, width: 120	, hidden: true},
			{ dataIndex: 'PROJECT_NO'		, width: 86		, hidden: true},
			{ dataIndex: 'INOUT_NUM'		, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
			}
		}
	});





	Unilite.Main( {
		id			: 'ssa390skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid, detailGrid
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			this.setDefault();
			//초기화 시 이체일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getField('CONT_STATE').setValue('1');

			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('CONT_STATE').setValue('1');
		}
	});// End of Unilite.Main( {
};
</script>
