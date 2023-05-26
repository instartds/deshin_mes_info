<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sea100skrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="SE01"/>						<!-- 견적기준 -->
	<t:ExtComboStore comboType="AU" comboCode="SE06"/>						<!-- 생산파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE07"/>						<!-- 연구파트 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	 .button{
	background: url('<c:url value="/resources/images/nbox/MailInbox.gif" />') no-repeat;
	cursor:pointer;
	border: none;
	width: 50px;
	background-position:center;
}
</style>
<script type="text/javascript" >

function appMain() {
var beforeRowIndex; // Master Grid 클릭시 현재 row알기 위함
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
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
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							// 영업담당 콤보세팅
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SALE_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
							
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST', {
					fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners		: {
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
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
						}
					}
				}),{
					fieldLabel	: '연구파트',
					name		: 'RES_PART',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE07',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('RES_PART', newValue);
						}
					}
				},{
					fieldLabel	: '생산파트',
					name		: 'PROD_PART',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE06',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROD_PART', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'SALE_PRSN',
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
							panelResult.setValue('SALE_PRSN', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.estiReqDate" default="견적의뢰일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.approvalyn" default="승인여부"/>',
					name		: 'AGREE_YN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'M007',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AGREE_YN', newValue);
						}
					}
				},{	//20210907 추가
					fieldLabel	: '견적의뢰번호',
					name		: 'ESTI_NUM',
					xtype		: 'uniTextfield',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ESTI_NUM', newValue);
						}
					}
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '품목연결여부',
					colspan		: 3,
					items		: [{
						boxLabel: '전체',
						width: 70,
						name: 'LINK_YN',
						inputValue: "1",
						checked: true
					},{
						boxLabel : '연결',
						width: 70,
						name: 'LINK_YN',
						inputValue: "2"
					},{
						boxLabel : '미연결',
						width: 70,
						name: 'LINK_YN',
						inputValue: "3"
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('LINK_YN', newValue);
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

	/* master 정보 form
	 */
	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4},
		padding		: '1 1 1 1',
		disabled	: false,
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					// 영업담당 콤보세팅
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
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
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '연구파트',
			name		: 'RES_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE07',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RES_PART', newValue);
				}
			}
		},{
			fieldLabel	: '생산파트',
			name		: 'PROD_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE06',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROD_PART', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
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
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.estiReqDate" default="견적의뢰일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.approvalyn" default="승인여부"/>',
			name		: 'AGREE_YN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M007',

			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_YN', newValue);
				}
			}
		},{	//20210907 추가
			fieldLabel	: '견적의뢰번호',
			name		: 'ESTI_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ESTI_NUM', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '품목연결여부',
			colspan		: 3,
			items:[{
				boxLabel: '전체',
				width: 60,
				name: 'LINK_YN',
				inputValue: "1",
				checked: true
			},{
				boxLabel : '연결',
				width: 60,
				name: 'LINK_YN',
				inputValue: "2"
			},{
				boxLabel : '미연결',
				width: 70,
				name: 'LINK_YN',
				inputValue: "3"
			}]
		}]
	});



	Unilite.defineModel('sea100skrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		, type: 'string', comboType:'AU', comboCode: 'S010'},
			{name: 'ESTI_REQ_DATE'		, text: '<t:message code="system.label.sales.estiReqDate" default="견적의뢰일"/>'	, type: 'uniDate'},
			{name: 'ESTI_ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ESTI_ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ESTI_QTY'			, text: '<t:message code="system.label.sales.estimateqty" default="견적수량"/>'		, type: 'uniQty'},
			{name: 'ESTI_TYPE'			, text: '견적기준'		, type: 'string'		, comboType: 'AU' , comboCode: 'SE01'},
			{name: 'BASE_AMT'			, text: '합계'		, type: 'uniPrice'},					//20210907 수정: 합계로 변경, uniPrice로 변경
			{name: 'SPEC_AMT'			, text: '합계'		, type: 'uniPrice'},					//20210907 수정: 합계로 변경, uniPrice로 변경
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'	, type: 'string'},
			{name: 'RES_PART'			, text: '연구파트'		, type: 'string'		, comboType: 'AU' , comboCode: 'SE07'},
			{name: 'PROD_PART'			, text: '생산파트'		, type: 'string'		, comboType: 'AU' , comboCode: 'SE06'},
			{name: 'AGREE_YN'			, text: '승인여부'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: 'ERP코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: 'ERP품목명'	, type: 'string'},
			{name: 'MAN_HOUR_YN'		, text: '공수등록'		, type: 'string'},
			{name: 'MATR_COST_YN'		, text: '원가계산등록'	, type: 'string'},
			{name: 'ESTI_DETAIL'		, text: '상세정보'		, type: 'string'},
			{name: 'BASE_PROD_COST'		, text: '임가공비'		, type: 'uniPrice'},	//20210907 추가, 20210914 수정
			{name: 'SPEC_PROD_COST'		, text: '임가공비'		, type: 'uniPrice'},	//20210907 추가, 20210914 추가
			{name: 'BASE_SOURCE_COST'	, text: '원료비'		, type: 'uniPrice'},	//20210907 추가
			{name: 'SPEC_SOURCE_COST'	, text: '원료비'		, type: 'uniPrice'}		//20210907 추가
		]
	});

	var masterStore = Unilite.createStore('sea100skrvMasterStore',{
		model	: 'sea100skrvModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sea100skrvService.selectMaster'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param			= panelSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var masterGrid = Unilite.createGrid('sea100skrvGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 80		, align: 'center'},
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'SALE_PRSN'			, width: 80		, align: 'center'},
			{dataIndex: 'ESTI_REQ_DATE'		, width: 100},
			{dataIndex: 'ESTI_ITEM_CODE'	, width: 110	, align: 'center'},
			{dataIndex: 'ESTI_ITEM_NAME'	, width: 200},
			{dataIndex: 'ESTI_QTY'			, width: 80},
			{dataIndex: 'ESTI_TYPE'			, width: 80		, align: 'center'},
			//20210907 수정: 컬럼 추가 / 2중 그리드로 변경
			{text: '기본가',
				columns: [
						{dataIndex: 'BASE_PROD_COST'	, width: 100},	//20210914 수정
						{dataIndex: 'BASE_SOURCE_COST'	, width: 100},
						{dataIndex: 'BASE_AMT'			, width: 100}
				]
			},
			{text: '기획가',
				columns: [
						{dataIndex: 'SPEC_PROD_COST'	, width: 100},	//20210914 추가
						{dataIndex: 'SPEC_SOURCE_COST'	, width: 100},
						{dataIndex: 'SPEC_AMT'			, width: 100}
				]
			},
			{dataIndex: 'ESTI_NUM'			, width: 120	, align: 'center'},
			{dataIndex: 'RES_PART'			, width: 120},
			{dataIndex: 'PROD_PART'			, width: 120	, align: 'center'},
			{dataIndex: 'AGREE_YN'			, width: 80		, align: 'center'},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 100},
			{dataIndex: 'MAN_HOUR_YN'		, width: 80		, align: 'center'},
			{dataIndex: 'MATR_COST_YN'		, width: 90		, align: 'center'},
			{ text: '상세정보'		, dataIndex: 'ESTI_DETAIL', width: 128,
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='상세정보' >"
 				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						var params = {
								action		: 'select',
								'PGM_ID'	: 'sea100skrv',
								'record'	: val.actionPosition.record,
								'formPram'	: panelSearch.getValues()
							}
						
							// 견적집계표 화면 open
							var rec = {data : {prgID : 'sea300skrv', 'text':''}};
							parent.openTab(rec, '/sales/sea300skrv.do', params);
					} 
					
 				}
			}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					detailStore.loadData({});
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			}
		}
	});





	Unilite.defineModel('sea100skrvModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'},
			{name: 'CODE_NAME'		, text: '항목'			, type: 'string'},
			{name: 'ESTI_QTY'		, text: '수량'			, type: 'uniUnitPrice'},
			
			{name: 'BASE_PERCENT'	, text: '비율(%)'			, type: 'uniPercent'},
			{name: 'BASE_AMT'		, text: '금액'			, type: 'uniUnitPrice'},
			{name: 'BASE_AMT_PRICE'	, text: '개당원가'			, type: 'uniUnitPrice'},
			{name: 'SPEC_PERCENT'	, text: '비율(%)'			, type: 'uniPercent'},
			{name: 'SPEC_AMT'		, text: '금액'			, type: 'uniUnitPrice'},
			{name: 'SPEC_AMT_PRICE'	, text: '개당원가'			, type: 'uniUnitPrice'}
		]
	});

	var detailStore = Unilite.createStore('sea100skrvdetailStore',{
		model	: 'sea100skrvModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sea100skrvService.selectDetail'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(record) {
			console.log( record.data);
			this.load({
				params : record.data
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
		},
		
	});

	var detailGrid = Unilite.createGrid('sea100skrvGrid2', {
		store	: detailStore,
		region	: 'south',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			userToolbar			: false
		},
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'	, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'CODE_NAME'	, width: 150	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '공급가(VAT별도)', '공급가(VAT별도)');
				}},
			{dataIndex: 'ESTI_QTY'		, width: 150	, align: 'center'},
			
			
			{text: '기본가',
				columns:[
					{dataIndex: 'BASE_PERCENT'	, width: 150	, align: 'center'},
					{dataIndex: 'BASE_AMT'		, width: 150	, summaryType: 'sum'},
					{dataIndex: 'BASE_AMT_PRICE', width: 150	, summaryType: 'sum'}
				]
			},
			
			{text: '기획가',
				columns:[
					{dataIndex: 'SPEC_PERCENT'	, width: 150	, align: 'center'},
					{dataIndex: 'SPEC_AMT'		, width: 150	, summaryType: 'sum'},
					{dataIndex: 'SPEC_AMT_PRICE', width: 150	, summaryType: 'sum'}
				]
			}
		]
	});


	Unilite.Main({
		id			: 'sea100skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid, detailGrid
			]
		},panelSearch
		],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			// 초기값 세팅
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelResult.setValue('FR_DATE'		, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE'		, UniDate.get('today'));
			panelSearch.setValue('FR_DATE'		, UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE'		, UniDate.get('today'));
		},
		onQueryButtonDown: function () {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			beforeRowIndex = -1;
			
			masterStore.loadData({});
			detailGrid.getStore().loadData({});
			
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			// form 초기화
			panelResult.clearForm();
			panelSearch.clearForm();
			
			// grid 초기화
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>