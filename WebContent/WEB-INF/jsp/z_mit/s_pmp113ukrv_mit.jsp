<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp113ukrv_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp113ukrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />				<!-- 가공창고 -->
	<t:ExtComboStore comboType="WU" />								<!-- 작업장-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>				<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/>				<!-- 대체여부 -->
</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var searchInfoWindow;	//SearchInfoWindow : 검색창
var excelWindow;		//엑셀참조
var BsaCodeInfo = {
};

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp113ukrv_mitService.selectMasterList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp113ukrv_mitService.selectDetailList'
		}
	});



	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs		: {width: 330}
		},{
			fieldLabel		: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_END_DATE_FR',
			endFieldName	: 'PRODT_END_DATE_TO',
			allowBlank		: false
		},{
			xtype	: 'container',
			layout	: { type: 'uniTable', columns: 2},
			defaults: {enforceMaxLength: true},
			items	: [{
				fieldLabel	: ' ',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '생산오더',
					name		: 'WORK_GUBUN',
					inputValue	: '1',
					width		: 80
				},{
					boxLabel	: '업로드',
					name		: 'WORK_GUBUN',
					inputValue	: '2',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.WORK_GUBUN == '1'){
							panelResult.down('#doButton').setText('소요량계산');

						} else if(newValue.WORK_GUBUN == '2'){
							panelResult.down('#doButton').setText('업로드');
						}
					}
				}
			},{
				xtype	: 'button',
				text	: '소요량계산',
				itemId	: 'doButton',
				width	: 100,
				handler	: function() {
					var param = panelResult.getValues();
					if(param.WORK_GUBUN == '1') {
						//소요량 계산로직 실행
						if(confirm('소요량 계산을 실행하시겠습니까?')) {
							Ext.getCmp('pageAll').mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
							calcRequirement(param);
						}
					} else {
						//업로드 로직 실행
						openExcelWindow();
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			allowBlank	: false,
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					}else{
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.grgiplanno" default="수급계획번호"/>',
			name		: 'MRP_CONTROL_NUM',
			xtype		: 'uniTextfield',
			holdable	: 'hold',
			readOnly	: true
		}]
	});



	/** defineModel
	 */
	Unilite.defineModel('s_pmp113ukrv_mitMasterModel', {
		fields: [
			{name: 'PROD_ITEM_CODE'	, text: '제품코드'	, type: 'string'	, editable: false},
			{name: 'ITEM_NAME'		, text: '제품명'	, type: 'string'	, editable: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.common.spec" default="규격"/>'	, type:'string'},
			{name: 'PL_QTY'			, text: '<t:message code="system.label.product.qty" default="수량"/>'	, type:'uniQty'}
		]
	});

	Unilite.defineModel('s_pmp113ukrv_mitDetailModel', {
		fields: [
			{name: 'CHILD_ITEM_CODE', text: '자재코드'		, type: 'string'	, editable: false},
			{name: 'ITEM_NAME'		, text: '제품명'		, type: 'string'	, editable: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.common.spec" default="규격"/>'				, type:'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'	, type:'string'},		//20200212 추가: 재고단위(bpr100t.stock_unit)
			{name: 'PL_QTY'			, text: '소요 예상수량'	, type:'uniQty'},
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'	, type:'uniQty'},
			{name: 'MATR_STOCK_Q'	, text: '자재창고재고'	, type:'uniQty'},
			{name: 'PRODT_STOCK_Q'	, text: '그외창고재고'	, type:'uniQty'},
			{name: 'OVER_Q'			, text: '과부족'	, type:'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp113ukrv_mitMasterStore', {
		model	: 's_pmp113ukrv_mitMasterModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			//상위 버튼 연결
			editable	: false,		//수정 모드 사용
			deletable	: false,		//삭제 가능 여부
			allDeletable: false			//전체 삭제 가능 여부
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.count() > 0){
				}
			}
		}
	});

	var detailStore2 = Unilite.createStore('s_pmp113ukrv_mitDetailStore', {
		model	: 's_pmp113ukrv_mitDetailModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			//상위 버튼 연결
			editable	: false,		//수정 모드 사용
			deletable	: false,		//삭제 가능 여부
			allDeletable: false			//전체 삭제 가능 여부
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.count() > 0){
				}
			}
		}
	});

	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmp113ukrv_mitGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 0.4,
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{dataIndex:'PROD_ITEM_CODE'	, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex:'ITEM_NAME'		, width: 150},
			{dataIndex:'SPEC'			, width: 120},
			{dataIndex:'PL_QTY'			, flex: 1, summaryType: 'sum'}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
//				if(e.record.phantom || !e.record.phantom) {
					return false;
//				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
		}
	});

	var detailGrid2 = Unilite.createGrid('s_pmp113ukrv_mitGrid2', {
		excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
		store	: detailStore2,
		layout	: 'fit',
		region	: 'east',
		flex	: 0.7,
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex:'CHILD_ITEM_CODE', width: 120/*,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}*/
			},
			{dataIndex:'ITEM_NAME'		, width: 150},
			{dataIndex:'SPEC'			, width: 150},
			{dataIndex:'STOCK_UNIT'		, width: 80	, align: 'center'},			//20200212 추가: 재고단위(bpr100t.stock_unit)
			{dataIndex:'PL_QTY'			, width: 120/*, summaryType: 'sum'*/},
			{dataIndex:'STOCK_Q'		, width: 120/*, summaryType: 'sum'*/},
			{dataIndex:'MATR_STOCK_Q'	, width: 120/*, summaryType: 'sum'*/},
			{dataIndex:'PRODT_STOCK_Q'	, width: 120/*, summaryType: 'sum'*/},
			{dataIndex:'OVER_Q'			, width: 120/*, summaryType: 'sum'*/}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
//				if(e.record.phantom || !e.record.phantom) {
					return false;
//				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
		},
		//20200212 추가: 과부족이 -인 경우 빨간색 글씨로 표시
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){	 
				var cls = '';
				if(record.get('OVER_Q') < 0){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});



	/** 엑셀참조
	 * @return {Boolean}
	 */
	function openExcelWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		var me		= this;
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create(appName, {
				modal			: false,
				excelConfigName	: 's_pmp113ukrv_mit',
				extParam		: {
					'PGM_ID'	: 's_pmp113ukrv_mit',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
					'WORK_GUBUN': '2'
				},
				listeners: {
					close: function() {
						this.hide();
					},
					hide: function() {
						this.hide();
					}
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype	: 'button',
						text	: UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
						tooltip	: UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
						handler	: function() { 
							me.jobID = null;
							me.uploadFile();
							//20200519 추가
							Ext.getCmp('pageAll').mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
						}
					},'->',{
						xtype	: 'button',
						text	: UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
						tooltip	: UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
						handler	: function() { 
							me.hide();
						}
					}]
				},
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						//20200519 추가
						Ext.getCmp('pageAll').unmask();
						alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
				 	frm.submit({
						params	: me.extParam,
						waitMsg	: 'Uploading...',
						success	: function(form, action) {
							var param			= me.extParam;
							param._EXCEL_JOBID	= action.result.jobID;
							//소요량 계산로직 실행
							calcRequirement(param);
							me.hide();
						},
						failure: function(form, action) {
							//20200519 추가
							Ext.getCmp('pageAll').unmask();
							Unilite.messageBox(action.result.msg);
							//메세지 표현 안되는것 확인필요
						}
					});
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	/** main app
	 */
	Unilite.Main ({
		id			: 's_pmp113ukrv_mit',
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, detailGrid2
			]
		}],
		fnInitBinding: function() {
			this.setDefault();
			panelResult.onLoadSelectText('DIV_CODE');
		},
		setDefault: function() {
			UniAppManager.setToolbarButtons(['query'], false);

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			//20200212 수정: "완료예정일" 기본값 변경: 현재일 ~ 3개월 뒤
			panelResult.setValue('PRODT_END_DATE_FR', UniDate.get('today'));
			panelResult.setValue('PRODT_END_DATE_TO', UniDate.get('threeMonthsLater'));
			panelResult.getField('WORK_GUBUN').setValue('1');
			panelResult.down('#doButton').setText('소요량계산');
			panelResult.setValue('WORK_SHOP_CODE'	, 'W40');
		},
		onQueryButtonDown: function() {
//			var orderNo = panelResult.getValue('WKORD_NUM');
//			if(Ext.isEmpty(orderNo)) {
//				opensearchInfoWindow();
//			} else {
//				detailStore.loadStoreRecords();
//				detailStore2.loadStoreRecords();
//			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailStore.loadData({});
			detailStore2.loadData({});

			this.fnInitBinding();
		}/*,
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						---------삭제전 로직 구현 시작----------

						---------삭제전 로직 구현 끝-----------
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		}*/
	});



	//소요량 계산 함수
	function calcRequirement(param) {
		s_pmp113ukrv_mitService.calcRequirement(param, function(provider, response) {
			if(provider) {
				if(provider[0].ERR_DESC) {
					Ext.getCmp('pageAll').unmask();
					Unilite.messageBox(provider[0].ERR_DESC.split('|')[0], provider[0].ERR_DESC.split('|')[1]);
					return false;
				} else if(provider[0].MRP_CONTROL_NUM) {
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
					Ext.getCmp('pageAll').unmask();
					panelResult.setValue('MRP_CONTROL_NUM', provider[0].MRP_CONTROL_NUM);
					detailStore.loadStoreRecords();
					detailStore2.loadStoreRecords();
//				} else {
//					Unilite.messageBox();
				//20200519 추가
				} else {
					Ext.getCmp('pageAll').unmask();
				}
			}
		});
	}



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
//			switch(fieldName) {
//				case "PROG_UNIT_Q" : // 원단위량
//					break;
//			}
			return rv;
		}
	}); // validator
};
</script>