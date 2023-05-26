<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sea210ukrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="SE01"/>						<!-- 견적기준 -->
	<t:ExtComboStore comboType="AU" comboCode="SE06"/>						<!-- 생산파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE07"/>						<!-- 연구파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE08"/>						<!-- 충전단위 -->
	<t:ExtComboStore comboType="AU" comboCode="SE02" storeId="SE02"/>		<!-- 견적기준 -->
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
	var activeTabId = 'tab_main';				// 현재 활성화 된 탭 id
	var SearchInfoWindow;	//검색창
	var BsaCodeInfo	= {
		gsUseApprovalYn: '${gsUseApprovalYn}'	//견적승인사용여부
	}

	/* master 정보 form
	 */
	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
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
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '견적의뢰일',
			xtype		: 'uniDatefield',
			name		: 'ESTI_REQ_DATE',
			readOnly	: true
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
			readOnly	: true
		},{
			fieldLabel	: '생산파트',
			name		: 'PROD_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE06',
			readOnly	: true
		},{
			fieldLabel	: '연구파트',
			name		: 'RES_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE07',
			readOnly	: true
		},{
			fieldLabel	: '견적기준',
			name		: 'ESTI_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE01',
			readOnly	: true
		},{
			xtype	: 'component',
			hidden	: BsaCodeInfo.gsUseApprovalYn == 'Y' ? true:false,
			width	: 100
		},
		Unilite.popup('USER_SINGLE',{
			fieldLabel		: '<t:message code="system.label.sales.approvaluser" default="승인자"/>',
			autoPopup		: true,
			hidden			: BsaCodeInfo.gsUseApprovalYn == 'Y' ? false:true
		}),{
			fieldLabel	: 'BOM 포장사양',
			xtype		: 'textarea',
			name		: 'BOM_SPEC',
			readOnly	: true,
			width		: 573,
			height		: 50,
			colspan		: 2
		},{
			fieldLabel	: '특이사항',
			xtype		: 'textarea',
			name		: 'REMARK',
			readOnly	: true,
			width		: 490,
			height		: 50,
			colspan		: 2
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'AGREE_YN',
			name		: 'AGREE_YN',
			value		: BsaCodeInfo.gsUseApprovalYn == 'Y' ? 'Y':'',
			hidden		: true
		}]
	});


	/**
	 * 원재료
	 *
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sea210ukrvService.selectDetail',
			update	: 'sea210ukrvService.updateDetail',
			create	: 'sea210ukrvService.insertDetail',
			syncAll	: 'sea210ukrvService.saveAll'
		}
	});

	Unilite.defineModel('sea210ukrvModel', {
		fields: [
			{name: 'LAB_NO'				, text: 'LAB No.'		, type: 'string'		, allowBlank: false},
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'		, allowBlank: false},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'		, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'		, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '내용물'			, type: 'string'},
			{name: 'PROD_ITEM_NAME'		, text: '내용물'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'},
			{name: 'UNIT_Q'				, text: 'BOM 비율'		, type: 'uniUnitPrice'},
			{name: 'INPUT_QTY'			, text: '투입량'			, type: 'uniUnitPrice'},
			{name: 'PURCH_PRICE'		, text: '단가(원/g)'			, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'PURCH_PRICE_ORG'	, text: '단가'			, type: 'uniUnitPrice'},
			{name: 'FILL_AMT'			, text: '충전가(최초)'		, type: 'uniUnitPrice'},
			{name: 'BASE_FILL_AMT'		, text: '충전가(기본)'		, type: 'uniUnitPrice'},
			{name: 'SPEC_FILL_AMT'		, text: '충전가(기획)'		, type: 'uniUnitPrice'},
			{name: 'FILL_QTY'			, text: '충진량'			, type: 'uniQty'},
			{name: 'SPEC_GRAVITY'		, text: '비중'			, type: 'uniUnitPrice'},
			{name: 'ISNEW_FLAG'			, text: '조회데이터여부'		, type: 'string'},
			{name: 'BASE_MTRL_RATE'		, text: '기본가비율'		, type: 'uniUnitPrice'},
			{name: 'SPEC_MTRL_RATE'		, text: '기획가비율'		, type: 'uniUnitPrice'}
		]
	});

	var detailStore = Unilite.createStore('sea210ukrvDetailStore',{
		model	: 'sea210ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param		= panelResult.getValues();

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
			var isErr		= false;

			var paramMaster = panelResult.getValues();
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
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
		},listeners:{
			load: function(store, records, successful, eOpts) {

				if(records != null && records.length > 0 ){
					var cnt = 0;
					Ext.each(records, function(record,i) {
						if(record.data.ISNEW_FLAG == 'Y'){
							cnt += 1;
						}
					});
					
					// 신규데이터일 경우 저장버튼 비활성화로 인해
					if(cnt>0){
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			}
		},groupField: 'LAB_NO'
	});

	var detailGrid = Unilite.createGrid('sea210ukrvGrid', {
		store	: detailStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'LAB_NO'			, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'PROD_ITEM_NAME'	, width: 200},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'UNIT_Q'			, width: 100	,summaryType: 'sum'},
			{dataIndex: 'INPUT_QTY'			, width: 100	,summaryType: 'sum'},
			{dataIndex: 'PURCH_PRICE'		, width: 100},
			{dataIndex: 'FILL_AMT'			, width: 100	,summaryType: 'sum'},
			{dataIndex: 'BASE_FILL_AMT'		, width: 110	,summaryType: 'sum'},
			{dataIndex: 'SPEC_FILL_AMT'		, width: 110	,summaryType: 'sum'},
			{dataIndex: 'SPEC_GRAVITY'		, width: 110	, hidden: true},
			{dataIndex: 'FILL_QTY'			, width: 110	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				// 단가가 0인경우에만 수정가능
				if (UniUtils.indexOf(e.field, ['PURCH_PRICE']) && e.record.data.PURCH_PRICE_ORG == 0){ // 처음 조회했을 때 단가가 0원인 경우에만 수정 가능하도록(잘못 입력했을 경우 대비)
					return true;
				}
				return false;
			}
		}
	});



	/**
	 * 부재료
	 *
	 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sea210ukrvService.selectDetail2',
			update	: 'sea210ukrvService.updateDetail2',
			create	: 'sea210ukrvService.insertDetail2',
			destroy	: 'sea210ukrvService.deleteDetail2',
			syncAll	: 'sea210ukrvService.saveAll2'
		}
	});

	Unilite.defineModel('sea210ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'		, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'	, allowBlank: false},
			{name: 'ESTI_UNIT'			, text: '단위'			, type: 'string'	, editable: false, comboType:'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'ESTI_QTY'			, text: '수량'			, type: 'uniQty'},
			{name: 'ESTI_PRICE'			, text: '단가(원)'			, type: 'uniUnitPrice'},
			{name: 'ESTI_AMT'			, text: '금액(원)'			, type: 'uniPrice'},
			{name: 'FREE_PAY_TYPE'		, text: '유/무상'			, type: 'string'	, comboType:'AU', comboCode: 'M105'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'}
		]
	});

	var detailStore2 = Unilite.createStore('sea210ukrvdetailStore2',{
		model	: 'sea210ukrvModel2',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var isErr		= false;

			var paramMaster = panelResult.getValues();
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							
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
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var detailGrid2 = Unilite.createGrid('sea210ukrvGrid2', {
		store	: detailStore2,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'detailGrid2SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGrid2Total'	, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'			, width: 100	, hidden: true},
			
			{dataIndex:'ITEM_CODE'		, width: 100 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					validateBlank:false,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid2.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
								grdRecord.set('ESTI_UNIT',records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid2.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
							grdRecord.set('ESTI_UNIT','');
							
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME'		, width: 100 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					validateBlank:false,
					listeners: {
						scope:this,
						onSelected:function(records, type ) {
								var grdRecord = detailGrid2.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
								grdRecord.set('ESTI_UNIT',records[0]['ORDER_UNIT']);
						},
						onClear:function(type) {
							var grdRecord = detailGrid2.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
							grdRecord.set('ESTI_UNIT','');
							
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					} 
				})
			},
			{dataIndex: 'ESTI_UNIT'			, width: 100},
			{dataIndex: 'ESTI_QTY'			, width: 100},
			{dataIndex: 'ESTI_PRICE'		, width: 100},
			{dataIndex: 'ESTI_AMT'			, width: 100},
			{dataIndex: 'FREE_PAY_TYPE'		, width: 110},
			{dataIndex: 'REMARK'			, flex: 1}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				// 신규행이면 모두 수정 가능
				if (e.record.phantom || UniUtils.indexOf(e.field, ['ESTI_QTY'])
										|| UniUtils.indexOf(e.field, ['ESTI_PRICE'])
										|| UniUtils.indexOf(e.field, ['ESTI_AMT'])
										|| UniUtils.indexOf(e.field, ['FREE_PAY_TYPE'])
										|| UniUtils.indexOf(e.field, ['REMARK'])) {
					return true;
				}
				
				return false;
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
				read: 'sea210ukrvService.searchPopupList'
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
	var searchPopupGrid = Unilite.createGrid('sea210ukrvsearchPopupGrid', {
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
				//20210907 추가: 실 데이터 조회 전, 비중 0인 데이터 존재여부 체크해서 메세지 띄우는 로직 추가
				var param = {
					DIV_CODE: record.get('DIV_CODE'),
					ESTI_NUM: record.get('ESTI_NUM')
				}
				sea210ukrvService.checkSpecGravity(param, function(provider, response){
					if(provider != 0) {
						Unilite.messageBox('비중이 0인 데이터가 존재합니다. 먼저 비중을 등록하세요.');
						return false;
					} else {
						searchPopupGrid.returnData(record);
						UniAppManager.app.onQueryButtonDown();
						SearchInfoWindow.hide();
					}
				});
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



	var tab = Unilite.createTabPanel('tabPanel',{
		region		: 'center',
		activeTab	: 0,
		items		: [{
			title	: '원재료',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid],
			id		: 'tab_main'
		},{
			title	: '부재료',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid2],
			id		: 'tab_sub'
		}],
		listeners	: {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
				var newTabId = newCard.getId();
				switch(newTabId)	{
					// 원재료 탭
					case 'tab_main':
						// 저장 할 데이터가 존재할 경우
						if(detailStore2.isDirty() || detailStore2.isDirty() ) {
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								var inValidRecs = detailStore2.getInvalidRecords();
								if(inValidRecs.length > 0 )	{
									alert(Msg.sMB083);
								}else {
									UniAppManager.app.onSaveDataButtonDown();
								}
								return false;
							} else {
								if(detailStore2.isDirty()) {
									// 변경 데이터 초기화
									detailStore2.rejectChanges();
									UniAppManager.setToolbarButtons('save', false);
								}
							}
						}
						
						activeTabId = 'tab_main';
						UniAppManager.setToolbarButtons('newData', false);
						break;
					
					// 부재료
					case 'tab_sub':
						// 저장 할 데이터가 존재할 경우
						if(detailStore.isDirty() || detailStore.isDirty() ) {
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								var inValidRecs = detailStore.getInvalidRecords();
								if(inValidRecs.length > 0 )	{
									alert(Msg.sMB083);
								}else {
									UniAppManager.app.onSaveDataButtonDown();
								}
								return false;
							} else {
								if(detailStore.isDirty()) {
									// 변경 데이터 초기화
									detailStore.rejectChanges();
									UniAppManager.setToolbarButtons('save', false);
								}
							}
						}
						activeTabId = 'tab_sub';
						UniAppManager.setToolbarButtons('newData', true);
						break;
						
					default:
						break;
				}
			}
		}
	});



	Unilite.Main({
		id			: 'sea210ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, tab
			]
		}],
		fnInitBinding : function(params) {
			
			UniAppManager.setToolbarButtons('delete', false);
			// 원재료
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab_main'){
				UniAppManager.setToolbarButtons('newData', false);
			// 부재료
			} else if(activeTabId == 'tab_sub'){
				UniAppManager.setToolbarButtons('newData', true);
			}
			
			this.setDefault(params);
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onQueryButtonDown: function () {
			// 견적의뢰번호가 존재하는지 않는 경우 팝업창
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				openSearchInfoWindow();
			} else {
				// 원재료
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'tab_main'){
					detailStore.loadStoreRecords();
				// 부재료
				} else if(activeTabId == 'tab_sub'){
					detailStore2.loadStoreRecords()
				}
			}
		},
		onSaveDataButtonDown: function (config) {
			//필수체크
			if(!panelResult.getInvalidMessage()) return;

			var activeTabId = tab.getActiveTab().getId();
			// 원재료 탭
			if(activeTabId == 'tab_main'){
				var records = detailStore.data.items;
				// 전체 데이터 비교 후 저장
				Ext.each(records, function(record,i) {
					detailStore.data.items[i].phantom = true;
				});
				detailStore.saveStore();
			// 부재료 탭
			} else if(activeTabId == 'tab_sub'){
				detailStore2.saveStore();
			}
		},
		onNewDataButtonDown: function() {		// 행추가
			
			var activeTabId = tab.getActiveTab().getId();
			// 원재료 탭은 추가기능 없음
			if(activeTabId == 'tab_main') return;
			
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				Unilite.messageBox("견적의뢰번호가 필요합니다.");
				return;
			}

			var compCode	= UserInfo.compCode;
			var divCode		= panelResult.getValue('DIV_CODE');
			var estiNum		= panelResult.getValue('ESTI_NUM');

			var r = {
					COMP_CODE	: compCode,
					DIV_CODE	: divCode,
					ESTI_NUM	: estiNum
					}
			detailGrid2.createRow(r);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function(){
			// 원재료 탭은 삭제기능 없음
			if(activeTabId == 'tab_main') return;
			
			var selRow = detailGrid2.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid2.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid2.deleteSelectedRow();
			}			
		},
	});



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				// 단가
				case "PURCH_PRICE" :
					var estiType	= panelResult.getValue('ESTI_TYPE'); // 견적기준
					var baseAmt		= 0; // 원재료 마진율 (기준)
					var specAmt		= 0; // 원재료 마진율 (기획)
					
					var commonCodes = Ext.data.StoreManager.lookup('SE02').data.items;
					Ext.each(commonCodes,function(commonCode, i) {
						// 충전가(기본)
						if(commonCode.get('value') == 'B10') {
							baseAmt = (estiType == 'A') ? commonCode.get('refCode2') : commonCode.get('refCode3');
						// 원재료 마진율 (기획)
						} else if(commonCode.get('value') == 'S10') {
							specAmt = (estiType == 'A') ? commonCode.get('refCode2') : commonCode.get('refCode3');
						}
					})
					
					var inputQty	= record.get('INPUT_QTY');		// 투입량

				//	var fillAmt		= (inputQty * newValue/1000);	// 최초충전가(투입량 *단가/1000)
				//	var baseFillAmt	= (fillAmt  * baseAmt /100);	// 기본충전가(최초충전가 *원재료마진율/100)
				//	var specFillAmt	= (fillAmt  * specAmt /100);	// 기획충전가(최초충전가 *원재료마진율/100)
					var fillAmt		= (inputQty * newValue);	// 최초충전가(투입량 *단가/1000)
					var baseFillAmt	= (fillAmt  * baseAmt /100 );	// 기본충전가(최초충전가 *원재료마진율/100)
					var specFillAmt	= (fillAmt  * specAmt /100 );	// 기획충전가(최초충전가 *원재료마진율/100)

					record.set('FILL_AMT'		, fillAmt);
					record.set('BASE_FILL_AMT'	, baseFillAmt);
					record.set('SPEC_FILL_AMT'	, specFillAmt);
					
				break;
			}
			return rv;
		}
	})
};
</script>