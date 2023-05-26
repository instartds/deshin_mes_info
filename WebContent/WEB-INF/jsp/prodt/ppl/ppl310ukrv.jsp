<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl310ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="ppl310ukrv"/>	<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="P401"/>				<!-- 확정/미확정 -->
<t:ExtComboStore comboType="AU" comboCode="P402"/>				<!-- 생성구분 -->
</t:appConfig>
<style type="text/css">
	.x-change-cell {
	background-color: #FFFFC6;
	}
	.x-change-cell2 {
	background-color: #FDE3FF;
	}
</style>

<script type="text/javascript" >

var SearchInfoWindow;		//수주참조팝업
var gsInit = true;			//초기화 시 조회로직 안 타도록 수정

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl310ukrvService.selectList',
			create	: 'ppl310ukrvService.insertList',
			update	: 'ppl310ukrvService.updateList',
			destroy	: 'ppl310ukrvService.deleteList',
			syncAll	: 'ppl310ukrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('ppl310ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank: false, editable: false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank: false, editable: false},
			{name: 'WEEK_NUM'			, text: '계획주차'			, type: 'string'	, allowBlank: false, editable: false},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'	, editable: false},
			{name: 'SEQ'				, text: '<t:message code="system.label.product.seq" default="순번"/>'					, type: 'int'		, editable: false},
			{name: 'CONFIRM_YN'			, text: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>'	, type: 'string'	, allowBlank: false	, comboType: 'AU'	, comboCode: 'P401'	, editable: false},
			{name: 'PLAN_TYPE'			, text: '생성구분'			, type: 'string'	, allowBlank: false	, comboType: 'AU'	, comboCode: 'P402'	, editable: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.item" default="품목"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type: 'string'	, allowBlank: false},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'	, editable: false},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'	, editable: false},
			{name: 'PLAN_QTY'			, text: '<t:message code="system.label.product.planqty" default="계획량"/>'			, type: 'uniQty'	, allowBlank: false},
			{name: 'DUE_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'	, allowBlank: false},
			{name: 'PRIORITY'			, text: '<t:message code="system.label.product.priority" default="우선순위"/>'			, type: 'int'},
			{name: 'APS_NUM'			, text: 'APS생성번호'		, type:'string'},
			{name: 'PLAN_START_DATE'	, text: '<t:message code="system.label.product.planstartdate" default="계획시작일"/>'	, type: 'uniDate'},
			
			{name: 'CUSTOM_NAME'			, text: '수주거래처'		, type:'string'},
			{name: 'ORDER_DATE'	, text: '수주일'	, type: 'uniDate'},
			{name: 'DVRY_DATE'	, text: '납기일'	, type: 'uniDate'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('ppl310ukrvMasterStore',{
		model	: 'ppl310ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue) {
			var param= panelResult.getValues();
			//조회조건 확정여부 추가와 관련하여 로직 추가
			if(newValue) {
				param.CONFIRM_YN = newValue;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
			var inValidRecs	= this.getInvalidRecords();
			//1. 마스터 정보 파라미터 구성
			var paramMaster	= panelResult.getValues();	// syncAll 수정

			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(directMasterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ppl310ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					panelResult.getField('DIV_CODE').setReadOnly(true);
					panelResult.getField('OPTION_DATE').setReadOnly(true);
					panelResult.getField('CAL_NO').setReadOnly(true);
				} else {
					panelResult.getField('DIV_CODE').setReadOnly(false);
					panelResult.getField('OPTION_DATE').setReadOnly(false);
					panelResult.getField('CAL_NO').setReadOnly(false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('ppl310ukrvGrid', {
		store	: directMasterStore,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		tbar: [{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue">수주참조</div>',
			handler	: function() {
				openSearchInfoWindow();
			}
		}],
		features: [{
			id				: 'detailGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'detailGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true,
			toggleOnClick	: false,
			listeners		: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(selectRecord.get('CONFIRM_YN') == '1') {
						selectRecord.set('CONFIRM_YN', '2');
					} else {
						selectRecord.set('CONFIRM_YN', '1');
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if(selectRecord.get('CONFIRM_YN') == '1') {
						selectRecord.set('CONFIRM_YN', '2');
					} else {
						selectRecord.set('CONFIRM_YN', '1');
					}
				}
			}
		}),
		columns: [
//			{dataIndex:'COMP_CODE'			, width: 100, hidden: true},
//			{dataIndex:'DIV_CODE'			, width: 100, hidden: true},
//			{dataIndex:'WEEK_NUM'			, width: 100},
			{dataIndex:'CONFIRM_YN'			, width: 80, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex:'PLAN_TYPE'			, width: 80, align: 'center'},
			{dataIndex:'ITEM_CODE'			, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME'	, records[0]['ITEM_NAME']);
							grdRecord.set('SPEC'		, records[0]['SPEC']);
							grdRecord.set('STOCK_UNIT'	, records[0]['STOCK_UNIT']);
						},
						onClear:function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('SPEC'		, '');
							grdRecord.set('STOCK_UNIT'	, '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME'			, width: 300,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME'	, records[0]['ITEM_NAME']);
							grdRecord.set('SPEC'		, records[0]['SPEC']);
							grdRecord.set('STOCK_UNIT'	, records[0]['STOCK_UNIT']);
						},
						onClear:function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('SPEC'		, '');
							grdRecord.set('STOCK_UNIT'	, '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex:'SPEC'				, width: 100},
			{dataIndex:'STOCK_UNIT'			, width: 80	, align: 'center'},
			{dataIndex:'DUE_DATE'			, width: 80},
			{dataIndex:'PLAN_QTY'			, width: 100, summaryType:'sum'},
			{dataIndex:'PRIORITY'			, width: 80, align: 'center'},
//			{dataIndex:'APS_NUM'			, width: 120},
//			{dataIndex:'PLAN_START_DATE'	, width: 100},
			{dataIndex:'ORDER_NUM'			, width: 100, align: 'center'},
			{dataIndex:'SEQ'				, width: 66, align: 'center'},
			
			{dataIndex:'CUSTOM_NAME'				, width: 200},
			{dataIndex:'ORDER_DATE'				, width: 80},
			{dataIndex:'DVRY_DATE'				, width: 80}
		],
		fnMakeSof100tDataRef: function(records) {
			var newDetailRecords= new Array();

			Ext.each(records, function(record,i){
				var r = {
					'COMP_CODE'		: record.data['COMP_CODE'],
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'WEEK_NUM'		: panelResult.getValue('CAL_NO'),
					'CONFIRM_YN'	: '1',
					'PLAN_TYPE'		: 'S',
					'ITEM_CODE'		: record.data['ITEM_CODE'],
					'ITEM_NAME'		: record.data['ITEM_NAME'],
					'SPEC'			: record.data['SPEC'],
					'STOCK_UNIT'	: record.data['STOCK_UNIT'],
					'PLAN_QTY'		: record.data['ORDER_Q'],
					'DUE_DATE'		: record.data['DVRY_DATE'],
					'ORDER_NUM'		: record.data['ORDER_NUM'],
					'SEQ'			: record.data['SER_NO'],
					'PRIORITY'		: '10',					
					'CUSTOM_NAME'	: record.data['CUSTOM_NAME'],
					'ORDER_DATE'	: record.data['ORDER_DATE'],
					'DVRY_DATE'		: record.data['DVRY_DATE']
				};
				newDetailRecords[i] = directMasterStore.model.create( r );
			});
			directMasterStore.loadData(newDetailRecords, true);

			panelResult.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('OPTION_DATE').setReadOnly(true);
			panelResult.getField('CAL_NO').setReadOnly(true);
		},
		listeners:{
			selectionchange:function(grid, selected, eOpts){
			},
			beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['SPEC', 'STOCK_UNIT'])){
					return false;
				}
				if(e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['ORDER_NUM', 'SEQ'])){
						return false;
					}else{
						return true;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'ORDER_NUM', 'SEQ'])){
						return false;
					}else{
						return true;
					}
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			value		: UserInfo.divCode
		},{
			xtype		: 'container',
			layout		: {type:'uniTable', columns : 2},
			colspan:3,
			items		: [{
				fieldLabel	: '계획주차',
				name		: 'OPTION_DATE',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur : function (field, event, eOpts) {
						if(Ext.isEmpty(field.value)){
							panelResult.setValue('CAL_NO', '');
						}else{
							var param = {
								'OPTION_DATE'	: UniDate.getDbDateStr(field.value),
								'CAL_TYPE'		: '3'								//주단위
							}
							prodtCommonService.getCalNo(param, function(provider, response) {
								if(!Ext.isEmpty(provider.CAL_NO)){
									panelResult.setValue('CAL_NO', provider.CAL_NO);
								}else{
									panelResult.setValue('CAL_NO', '');
								}
							})
						}
					}
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'CAL_NO',
				width		: 80,
				allowBlank	: false,
				readOnly	: true
			}]
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE")});
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'CONFIRM_YN',
				inputValue	: '', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
				width		: 60,
				name		: 'CONFIRM_YN',
				inputValue	: '2'
			},{
				boxLabel	: '<t:message code="system.label.purchase.noconfirm" default="미확정"/>',
				width		: 70,
				name		: 'CONFIRM_YN',
				inputValue	: '1'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!gsInit) {
						directMasterStore.loadStoreRecords(newValue.CONFIRM_YN);
					}
				}
			}
		},{
			xtype: 'button',
			text: '품목CAPA등록여부 체크',
			width: 200,
			tdAttrs: {align: 'right',width: 250},
			handler: function() {
				if(!panelResult.getInvalidMessage()) return;	//필수체크
				var param = panelResult.getValues();
				
				var param = {
					"DIV_CODE" : panelResult.getValue('DIV_CODE'),
					"CAL_NO": panelResult.getValue('CAL_NO')
				};
				ppl310ukrvService.capaChk(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						if(provider.ROW_COUNT == 0){										
							Unilite.messageBox(panelResult.getValue('CAL_NO')+ ' 주차로 확정된 APS대상이 없습니다.','');
						}else{
							if(provider.ERR_DESC != ''){
								Unilite.messageBox(panelResult.getValue('CAL_NO') + ' 주차에 생산공수등록이 되지 않은 품목이 있습니다.','품목코드 : ' + provider.ITEM_CHECK.slice(0, -1));
							}else{
								Unilite.messageBox(panelResult.getValue('CAL_NO')+ ' 주차로 APS 생성이 가능합니다.','');	
							}
						}
					} else {
						Unilite.messageBox(panelResult.getValue('CAL_NO')+ ' 주차로 APS 생성이 불가능합니다.','');
					}
				});
			}
		},{
			xtype: 'button',
			text: '품목CAPA 자동생성',
			width: 200,
			tdAttrs: {align: 'right',width: 220},
			handler: function() {
				if(!panelResult.getInvalidMessage()) return;	//필수체크
				var param = panelResult.getValues();
				
				var param = {
					"DIV_CODE" : panelResult.getValue('DIV_CODE'),
					"CAL_NO": panelResult.getValue('CAL_NO')
				};
				ppl310ukrvService.capaAutoSave(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						if(provider == 'Y'){
							Ext.Msg.alert('확인', "생성 성공.");
						}else{
							Ext.Msg.alert('확인', "생성 실패.");
						}
					} else {
						Ext.Msg.alert('확인', "생성 실패.");
					}
				});
			}
		}]
	});

	// 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		:'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ORDER_DATE',
			endFieldName	: 'TO_ORDER_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.sales.pono" default="발주번호"/>',
			name: 'PO_NUM'
		},{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name: 'ORDER_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S010',
			value: '',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners:{
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>'		, name: 'ORDER_NUM'
		},{
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	, name: 'ORDER_TYPE',   xtype:'uniCombobox',comboType:'AU', comboCode:'S002'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.offerno" default="OFFER번호"/>',
			name		: 'OFFER_NO'
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			textFieldName	: 'PROJECT_NO',
			validateBlank	: false,
			textFieldWidth	: 150,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			width		: 325
		}]
	}); // createSearchForm
	// 검색 모델(디테일)
	Unilite.defineModel('orderNoDetailModel', {
		fields: [
			{name: 'DIV_CODE'		, text:'<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'	, comboType:'BOR120'},
			{name: 'ITEM_CODE'		, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text:'<t:message code="system.label.sales.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'			, text:'<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_DATE'		, text:'<t:message code="system.label.sales.sodate" default="수주일"/>'			, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_Q'		, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_TYPE'		, text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'	, comboType:'AU', comboCode:'S002'},
			{name: 'ORDER_PRSN'		, text:'<t:message code="system.label.sales.salesperson" default="수주담당"/>'		, type: 'string'	, comboType:'AU', comboCode:'S010'},
			{name: 'PO_NUM'			, text:'<t:message code="system.label.sales.pono" default="PO번호"/>'	  			, type: 'string'},
			{name: 'PROJECT_NO'		, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PROJECT_NAME'	, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'		, type: 'string'},
			{name: 'ORDER_NUM'		, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'			, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text:'<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text:'<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'PJT_CODE'		, text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'	, type: 'string'},
			{name: 'PJT_NAME'		, text:'<t:message code="system.label.sales.project" default="프로젝트"/>'			, type: 'string'},
			{name: 'COMP_CODE'		, text:'COMP_CODE'		, type: 'string' },
			{name: 'CARE_YN'		, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'CARE_REASON'	, text: 'CARE_REASON'	, type: 'string'},
			{name: 'STOCK_UNIT'		, text: 'STOCK_UNIT'	, type: 'string'}
		]
	});
	// 검색 스토어(디테일)
	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model	: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ppl310ukrvService.selectOrderNumDetailList'
			}
		},
		listeners:{
        	load:function(store, records, successful, eOpts)	{
    			if(successful)	{
    			   var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);  
    			   var  orderNoRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
        			   	Ext.each(records, function(item, i)	{           			   								
   							Ext.each(masterRecords.items, function(record, i)	{
   								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
										&& (record.data['SEQ'] == item.data['SER_NO'] )
								  ){
									 orderNoRecords.push(item);
								}
   							});		
        			   	});
        			   store.remove(orderNoRecords);
    			   }
    			}
        	}
        },
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 검색 그리드(디테일)
	var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
		store	: orderNoDetailStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 80},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_DATE'	, width: 80},
			{dataIndex: 'DVRY_DATE'		, width: 80		, hidden:true},
			{dataIndex: 'ORDER_Q'		, width: 80},
			{dataIndex: 'ORDER_TYPE'	, width: 90},
			{dataIndex: 'ORDER_PRSN'	, width: 90		, hidden:true},
			{dataIndex: 'PO_NUM'		, width: 100},
			{dataIndex: 'PROJECT_NO'	, width: 100},
			{dataIndex: 'PROJECT_NAME'	, width: 120},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'SER_NO'		, width: 70		, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 200},
			{dataIndex: 'COMP_CODE'		, width: 80		, hidden:true},
			{dataIndex: 'PJT_CODE'		, width: 120	, hidden:true},
			{dataIndex: 'PJT_NAME'		, width: 200	, hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				detailGrid.fnMakeSof100tDataRef(record);
				SearchInfoWindow.hide();
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			detailGrid.fnMakeSof100tDataRef(records);
			this.deleteSelectedRow();
		}
	});
	// openSearchInfoWindow (검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.sonosearch" default="수주번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoDetailGrid],
				tbar	: ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						orderNoDetailStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.referenceapply" default="참조적용"/>',
					handler	: function() {
						orderNoDetailGrid.returnData();
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
						orderNoSearch.clearForm();
						orderNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						
						orderNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('startOfMonth'));
						orderNoSearch.setValue('TO_ORDER_DATE'	, UniDate.get('today'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	Unilite.Main({
		id			: 'ppl310ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]}
		],
		fnInitBinding: function() {
			this.setDefault();
			gsInit = false;									//초기화 시 조회로직 안 타도록 수정 
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			panelResult.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('OPTION_DATE').setReadOnly(true);
			panelResult.getField('CAL_NO').setReadOnly(true);

			var divCode = panelResult.getValue('DIV_CODE');
			var r = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: divCode,
				PLAN_TYPE	: 'P',
				WEEK_NUM	: panelResult.getValue('CAL_NO'),
				CONFIRM_YN	: '1'
			}
			detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1);
			detailGrid.getSelectionModel().deselect(detailGrid.getStore().getCount() - 1)
		},
		onResetButtonDown: function() {
			gsInit = true;									//초기화 시 조회로직 안 타도록 수정 
			panelResult.clearForm();
			detailGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('OPTION_DATE'	, UniDate.get('today'));
			panelResult.getField('CONFIRM_YN').setValue('');
			var param = {
				'OPTION_DATE'	: UniDate.getDbDateStr(UniDate.get('today')),
				'CAL_TYPE'		: '3'										//주단위
			}
			prodtCommonService.getCalNo(param, function(provider, response) {
				if(!Ext.isEmpty(provider.CAL_NO)){
					panelResult.setValue('CAL_NO', provider.CAL_NO);
				}else{
					panelResult.setValue('CAL_NO', '');
				}
			});
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('OPTION_DATE').setReadOnly(false);
			panelResult.getField('CAL_NO').setReadOnly(false);
		}
	});
};
</script>