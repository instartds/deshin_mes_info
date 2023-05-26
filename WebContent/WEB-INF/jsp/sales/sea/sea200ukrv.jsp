<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sea200ukrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="SE01"/>						<!-- 견적기준 -->
	<t:ExtComboStore comboType="AU" comboCode="SE06"/>						<!-- 생산파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE07"/>						<!-- 연구파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE08"/>						<!-- 충전단위 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	.editorCls {height:100%;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'>
</script>
<script type="text/javascript" >

function appMain() {
	var SearchInfoWindow;	//검색창
	var BsaCodeInfo	= {
		gsUseApprovalYn: '${gsUseApprovalYn}'	//견적승인사용여부
	}


	/* master 정보 form
	 */
	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, valign : 'top'*/}
		},
		padding		: '1 1 1 1',
		disabled	: false,
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			readOnly		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '견적의뢰일',
			xtype		: 'uniDatefield',
			name		: 'ESTI_REQ_DATE',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			readOnly	: true,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM',
			readOnly	: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank	: false,
			readOnly		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.poqty" default="발주량"/>',
			xtype		: 'uniNumberfield',
			name		: 'ESTI_QTY',
			readOnly	: true,
			value		: 0
		},{
			fieldLabel	: '충전단위',
			name		: 'FILL_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE08',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '생산파트',
			name		: 'PROD_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE06',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '연구파트',
			name		: 'RES_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE07',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적기준',
			name		: 'ESTI_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE01',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'component',
			hidden	: BsaCodeInfo.gsUseApprovalYn == 'Y' ? true:false,
			width	: 100
		},
		Unilite.popup('USER_SINGLE',{
			fieldLabel		: '<t:message code="system.label.sales.approvaluser" default="승인자"/>',
			autoPopup		: true,
//			holdable		: 'hold',
			hidden			: BsaCodeInfo.gsUseApprovalYn == 'Y' ? false:true,
			listeners		: {
				'onSelected': {
					fn: function(records, type ){
					},
					scope: this
				},
				'onClear' : function(type)	{
				}
			} 
		}),{
			fieldLabel	: 'BOM 포장사양',
			xtype		: 'textarea',
			name		: 'BOM_SPEC',
			readOnly	: true,
			width		: 573,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			fieldLabel	: '특이사항',
			xtype		: 'textarea',
			name		: 'REMARK',
			readOnly	: true,
			width		: 490,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'AGREE_YN',
			name		: 'AGREE_YN',
			value		: BsaCodeInfo.gsUseApprovalYn == 'Y' ? 'Y':'',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});



	var subPanel1 = Unilite.createSearchForm('subPanel1',{
		padding	: '0 0 0 0',
		layout	: {type:'uniTable', columns: 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			labelWidth	: 90,
			allowBlank	: false,
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = subPanel1.getField('PRODT_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);

//					var records = detailStore.data.items;
//					Ext.each(records, function(record,i) {
//						record.set('OUT_DIV_CODE', newValue);
//					});
				}
			}
		},{
			fieldLabel	: '생산담당',
			xtype		: 'uniCombobox',
			name		: 'PRODT_PRSN',
			comboType	: 'AU',
			comboCode	: 'P510',
			labelWidth	: 90,
			allowBlank	: false,
//			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//				if(eOpts){
//					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
//				} else {
//					combo.divFilterByRefCode('refCode1', newValue, divCode);
//				}
//			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = detailStore.data.items;
					Ext.each(records, function(record,i) {
						record.set('PRODT_PRSN', newValue);
					});
				}
			}
		}]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sea200ukrvService.selectDetail',
			update	: 'sea200ukrvService.updateDetail',
			create	: 'sea200ukrvService.insertDetail',
			destroy	: 'sea200ukrvService.deleteDetail',
			syncAll	: 'sea200ukrvService.saveAll'
		}
	});

	Unilite.defineModel('sea200ukrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, editable: false, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, editable: false, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'	, editable: false},
			{name: 'OUT_DIV_CODE'	, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'	, type: 'string'	, editable: false, comboType: 'BOR120'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'		, type: 'string'	, editable: false},
			{name: 'WORK_SHOP_NAME'	, text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'		, type: 'string'	, editable: false},
			{name: 'PROG_WORK_CODE'	, text: '<t:message code="system.label.sales.routingcode" default="공정코드"/>'		, type: 'string'	, editable: false},
			{name: 'PROG_WORK_NAME'	, text: '<t:message code="system.label.sales.routingname" default="공정명"/>'		, type: 'string'	, editable: false},
			{name: 'WORK_TIME'		, text: '소요시간'		, type: 'float'	, allowBlank: false	, decimalPrecision: 1	, format: '0,0000.0'},
			{name: 'MAN_CNT'		, text: '투입인력(명)'	, type: 'float'	, allowBlank: false	, decimalPrecision: 0	, format: '0,0000'},
			{name: 'MAN_HOUR'		, text: '작업공수'		, type: 'float'	, allowBlank: false	, decimalPrecision: 1	, format: '0,0000.0', editable: false},
			{name: 'PRODT_PRSN'		, text: '생산담당'		, type: 'string', comboType: 'AU'	, comboCode: 'P510'}
		]
	});

	var detailStore = Unilite.createStore('sea200ukrvDetailStore',{
		model	: 'sea200ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param			= panelResult.getValues();
			param.OUT_DIV_CODE	= subPanel1.getValue('OUT_DIV_CODE');
			param.PRODT_PRSN	= subPanel1.getValue('PRODT_PRSN');
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;

			var paramMaster = panelResult.getValues();
			
			// 임가공비 저장
			var proCost = 0;
			for(var i=0; i < detailStore2.data.length; i++){
				var record = detailStore2.getAt(i);
				// 노무비
				if(record.get('FLAG') == '20') {
					paramMaster["MAN_COST"] = record.get("PRICE")
					proCost += record.get("PRICE");
				// 제조경비
				} else if(record.get('FLAG') == '30'){
					paramMaster["PROD_EXPENSE"] = record.get("PRICE");
					proCost += record.get("PRICE");
				}
			}
			// 임가공비
			paramMaster["PROD_COST"] = proCost;
			
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue('ESTI_NUM', master.ESTI_NUM);
							}
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					subPanel1.setValue('OUT_DIV_CODE'	, records[0].get('OUT_DIV_CODE'));
					subPanel1.setValue('PRODT_PRSN'		, records[0].get('PRODT_PRSN'));
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('sea200ukrvGrid', {
		store	: detailStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'OUT_DIV_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE', width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_NAME', width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'PROG_WORK_CODE', width: 110	, align: 'center'},
			{dataIndex: 'PROG_WORK_NAME', width: 200},
			{dataIndex: 'WORK_TIME'		, width: 120},
			{dataIndex: 'MAN_CNT'		, width: 120},
			{dataIndex: 'MAN_HOUR'		, width: 120	, summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var sumData = Ext.util.Format.number(metaData.record.data.MAN_HOUR, '0,000.0');
					
					UniAppManager.app.fnValidateSummry(sumData);
					return Unilite.renderSummaryRow(summaryData, metaData, null, '<div align="right">' + sumData);
				}
			},
			{dataIndex: 'PRODT_PRSN'	, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
//				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'ESTI_NUM'])){
//					return false;
//				}
				//위 필드 제외, 모두 수정 가능 - 뒷단로직 발생 시, 저장하면서 체크
//				if (e.record.phantom) {
//					return true;
//				} else {
//					return false;
//				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});






	var subPanel2 = Unilite.createSearchForm('subPanel2',{
		padding	: '0 0 0 0',
		layout	: {type:'uniTable', columns: 3},
		items	: [{
			fieldLabel	: '월평균노무공수',
			name		: 'MONTH_AVG_MAN_HOUR',
			xtype		: 'uniNumberfield',
			type		: 'uniPrice',
			labelWidth	: 90,
			value		: 0,
			readOnly	: true
		},{
			fieldLabel		: '작업공수',
			name			: 'SUM_MAN_HOUR',
			xtype			: 'uniNumberfield',
			type			: 'float',
			decimalPrecision: 1,
			format			: '0,0000.0',
			labelWidth		: 90,
			value			: 0,
			readOnly		: true
		},{
			fieldLabel		: '공수점유율(%)',
			name			: 'RATIO_MAN_HOUR',
			xtype			: 'uniNumberfield',
			type			: 'float',
			decimalPrecision: 3,
			format			: '0,0000.000',
			labelWidth		: 130,
			value			: 0,
			readOnly		: true
		}]
	});

	Unilite.defineModel('sea200ukrvModel2', {
		fields: [
			{name: 'GUBUN'			, text: '<t:message code="system.label.base.classfication" default="구분"/>'	, type: 'string'	, editable: false},
			{name: 'UNIT_P'			, text: '단가(원)'			, type: 'float'	, allowBlank: false, decimalPrecision: 2, format:'0,0000.00'},
			{name: 'QTY'			, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'float'	, allowBlank: false, decimalPrecision: 0, format:'0,0000'},
			{name: 'PRICE'			, text: '가공금액'			, type: 'float'	, allowBlank: false, decimalPrecision: 0, format:'0,0000'},
			{name: 'MONTH_AVG_AMT'	, text: '월평균노무비/제조경비'	, type: 'float'	, allowBlank: false, decimalPrecision: 0, format:'0,0000'},
			{name: 'FLAG'			, text: '노무비/제조경비 구분'	, type: 'string'}
		]
	});

	var detailStore2 = Unilite.createStore('sea200ukrvdetailStore2',{
		model	: 'sea200ukrvModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sea200ukrvService.selectDetail2'
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
			var param			= panelResult.getValues();
			param.OUT_DIV_CODE	= subPanel1.getValue('OUT_DIV_CODE');	//20210804 추가
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					subPanel2.setValue('MONTH_AVG_MAN_HOUR'	, records[0].get('MONTH_AVG_MAN_HOUR'));
					subPanel2.setValue('SUM_MAN_HOUR'		, records[0].get('SUM_MAN_HOUR'));
					subPanel2.setValue('RATIO_MAN_HOUR'		, records[0].get('RATIO_MAN_HOUR'));
				}
			},
			write: function(proxy, operation){
//				if (operation.action == 'destroy') {
//					Ext.getCmp('panelResult').reset();
//				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				panelResult.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
//				if(store.count() == 0) {
//					panelResult.clearForm();
//					panelResult.disable();
//				}
			}
		}
	});

	var detailGrid2 = Unilite.createGrid('sea200ukrvGrid2', {
		store	: detailStore2,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			userToolbar			: false
		},
		features: [ {id : 'detailGrid2SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGrid2Total'	, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'GUBUN'			, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'UNIT_P'		, width: 200},
			{dataIndex: 'QTY'			, width: 200},
			{dataIndex: 'PRICE'			, width: 200	, summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, null, '<div align="right">' + Ext.util.Format.number(metaData.record.data.PRICE, '0,000'));
				}
			},
			{dataIndex: 'MONTH_AVG_AMT'	, width: 200}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});




	/* 검색 팝업
	 */
	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns: 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = searchPopupPanel.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '견적의뢰일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_REQ_DATE',
			endFieldName	: 'TO_ESTI_REQ_DATE'
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM'
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
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
			xtype		: 'radiogroup',
			itemId		: 'AGREE_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'AGREE_YN',
				inputValue	: 'A',
				width		: 50,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.approved" default="승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'Y',
				width		: 50
			},{
				boxLabel	: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'N',
				width		: 60
			}]
		}]
	});
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ESTI_REQ_DATE'		, text: '견적의뢰일'		, type: 'uniDate'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'	, type: 'string'},
			{name: 'ESTI_ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ESTI_ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'				, type: 'string'},
			{name: 'ESTI_QTY'			, text: '<t:message code="system.label.sales.estimateqty" default="견적수량"/>'			, type: 'uniQty'},
			{name: 'FILL_UNIT'			, text: '충전단위'		, type: 'string'},
			{name: 'PROD_PART'			, text: '생산파트'		, type: 'string'},
			{name: 'RES_PART'			, text: '연구파트'		, type: 'string'},
			{name: 'ESTI_TYPE'			, text: '견적기준'		, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.sales.approvaluser" default="승인자"/>'			, type: 'string'},
			{name: 'BOM_SPEC'			, text: 'BOM포장사양'	, type: 'string'},
			{name: 'REMARK'				, text: '특이사항'		, type: 'string'},
			{name: 'REF_CODE1'			, text: '출고사업장'		, type: 'string'}
		]
	});
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sea200ukrvService.searchPopupList'
			}
		},
		loadStoreRecords : function() {
			var param = searchPopupPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchPopupGrid = Unilite.createGrid('sea200ukrvsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 140},
			{dataIndex: 'ESTI_REQ_DATE'		, width: 90},
			{dataIndex: 'ESTI_NUM'			, width: 120},
			{dataIndex: 'ESTI_ITEM_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'ESTI_ITEM_NAME'	, width: 150},
			{dataIndex: 'ESTI_QTY'			, width: 100},
			{dataIndex: 'SALE_PRSN'			, width: 100},
			{dataIndex: 'FILL_UNIT'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_PART'			, width: 100	, hidden: true},
			{dataIndex: 'RES_PART'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_TYPE'			, width: 100},
			{dataIndex: 'AGREE_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'BOM_SPEC'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function() {
			record = this.getSelectedRecord();
			panelResult.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
				'ESTI_REQ_DATE'	: record.get('ESTI_REQ_DATE'),
				'ESTI_NUM'		: record.get('ESTI_NUM'),
				'ITEM_CODE'		: record.get('ESTI_ITEM_CODE'),
				'ITEM_NAME'		: record.get('ESTI_ITEM_NAME'),
				'ESTI_QTY'		: record.get('ESTI_QTY'),
				'SALE_PRSN'		: record.get('SALE_PRSN'),
				'FILL_UNIT'		: record.get('FILL_UNIT'),
				'PROD_PART'		: record.get('PROD_PART'),
				'RES_PART'		: record.get('RES_PART'),
				'ESTI_TYPE'		: record.get('ESTI_TYPE'),
				'USER_ID'		: record.get('AGREE_PRSN'),
				'BOM_SPEC'		: record.get('BOM_SPEC'),
				'REMARK'		: record.get('REMARK')
			});
			subPanel1.setValue('OUT_DIV_CODE', record.get('REF_CODE1'))
		}
	});
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '견적의뢰번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						if(!searchPopupPanel.getInvalidMessage()){
							return false;
						}
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						searchPopupPanel.setValue('FR_ESTI_REQ_DATE', UniDate.get('startOfMonth'));
						searchPopupPanel.setValue('TO_ESTI_REQ_DATE', UniDate.get('today'));
						searchPopupPanel.setValue('CUSTOM_CODE'		, panelResult.getValue('CUSTOM_CODE'));
						searchPopupPanel.setValue('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
						searchPopupPanel.setValue('SALE_PRSN'		, panelResult.getValue('SALE_PRSN'));
						searchPopupPanel.getField('AGREE_YN').setValue('A');
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	var groupPanel1 = Ext.create('Ext.panel.Panel', {
		region	: 'center',
		layout	: {
			type	: 'vbox',
			layout	: 'border',
			align	: 'stretch'
		},
		flex	: 2,
		items	: [
			subPanel1, detailGrid
		]
	});

	var groupPanel2 = Ext.create('Ext.panel.Panel', {
		region	: 'south',
		layout	: {
			type	: 'vbox',
			layout	: 'border',
			align	: 'stretch'
		},
		flex	: 1,
		items	: [
			subPanel2, detailGrid2
		]
	});



	Unilite.Main({
		id			: 'sea200ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, groupPanel1, groupPanel2
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault(params);
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);

//			var field = panelResult.getField('SALE_PRSN');
//			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onQueryButtonDown: function () {
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				openSearchInfoWindow();
			} else {
				subPanel2.clearForm();
				detailStore.loadData({});
				detailStore2.loadData({});
				detailStore.loadStoreRecords();
				detailStore2.loadStoreRecords();
			}
		},
		onDeleteDataButtonDown : function() {
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(selRow.phantom == true) {
					detailGrid.deleteSelectedRow();
				} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!subPanel1.getInvalidMessage()) return;	//필수체크
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			subPanel1.clearForm();
			subPanel2.clearForm();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			this.fnInitBinding();
		},
		fnValidateSummry: function(sumManHour){
			// 작업공수 데이터 세팅
			subPanel2.setValue('SUM_MAN_HOUR', sumManHour);
			// 월평균노무공수
			var monthManHour = subPanel2.getValue('MONTH_AVG_MAN_HOUR');
			// 공수점유율 = 작업공수/월평균노무공수 * 100
			var ratioManHour = Ext.util.Format.number(sumManHour/monthManHour*100, '0,000.000');
			subPanel2.setValue('RATIO_MAN_HOUR', ratioManHour);
			
			// 수량
			var estiQty = panelResult.getValue('ESTI_QTY');

			for(var i=0; i < detailStore2.data.length - 3; i++){		//20210818 수정: 일반관리비는 공수와 무관( - 1), 20210909 수정: -1 -> -3
				var record = detailStore2.getAt(i);
				// 가공금액
				var price = record.get('MONTH_AVG_AMT') * ratioManHour / 100;
				// 단가 = 월평균 노무비/제조경비 * 공수점유율  / 생산수량
				var unitP = price / estiQty;
				
				record.set('UNIT_P', unitP);
				record.set('PRICE', price);
			}
		}
	});



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			// 소요시간 * 투입인력(명)
			switch(fieldName) {
				case "WORK_TIME" :
					record.set('MAN_HOUR', Unilite.multiply(record.get('MAN_CNT'), newValue));
				break;

				case "MAN_CNT" :
					record.set('MAN_HOUR', Unilite.multiply(record.get('WORK_TIME'), newValue));
				break;
			}
			return rv;
		}
	})
};
</script>