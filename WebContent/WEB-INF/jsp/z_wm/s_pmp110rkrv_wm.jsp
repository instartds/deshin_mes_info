<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp110rkrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>	<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>	<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="P510"/>	<!-- 등록자 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>	<!-- 배송방법 -->
	<t:ExtComboStore comboType="WU"/>					<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
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
			allowBlank	: false
		},{
			fieldLabel		: '<t:message code="system.label.common.workorderdate" default="작업지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_PRODT_WKORD_DATE',
			endFieldName	: 'TO_PRODT_WKORD_DATE'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.printyn" default="출력여부"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.noprint" default="미출력"/>',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '<t:message code="system.label.sales.print" default="출력"/>',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
				name		: 'rdoSelect',
				inputValue	: '',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20210106 추가
					if(!panelResult.getInvalidMessage()) {
						return false;
					}
					masterGrid.down('#printBtn').disable();
					masterGrid.down('#labelPrintBtn').disable();
					masterGrid.down('#carriageBillprintBtn').disable();
					masterGrid.down('#excelDownload').disable();			//20210322 추가
					masterStore.loadStoreRecords(newValue.rdoSelect);
				}
			}
		},{	//20210324 추가: 서비스번호 일괄생성 기능 추가 - 그리드에서 진행 (주석)
			title	: '서비스번호 일괄생성',
			xtype	: 'uniFieldset',
			layout	: {type: 'uniTable', tableAttrs:{cellpadding:3}, tdAttrs: {valign:'top'}},
			rowspan	: 2,
			margin	: '0 0 0 20',
			padding	: '0 0 3 0',
			width	: 200,
			items	: [{
				fieldLabel	: '시작번호',
				xtype		: 'uniTextfield',
				name		: 'START_NO',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype	: 'button',
				text	: '일괄생성',
				margin	: '0 0 0 80',
				width	: 80,
				handler	: function() {
					var records	= masterGrid.getSelectionModel().getSelection();
					records		= records.sort(function(a,b){return masterGrid.getStore().indexOf(a)-masterGrid.getStore().indexOf(b);})
					if(records.length == 0) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
//					if(Ext.isEmpty(panelResult.getValue('START_NO'))){
//						Unilite.messageBox('시작번호를 입력한 후, 일괄생성을 진행하세요.');
//						panelResult.getField('START_NO').focus();
//						return false;
//					}
					var startNo		= records[0].get('SERVICE_NO');
					var startPeri	= records[0].get('EXPIRATION_DAY');
					var startIdx	= masterGrid.getSelectedRowIndex(records[0]);
					var i		= 1;
					if(Ext.isEmpty(startNo)){
						Unilite.messageBox('시작번호를 입력한 후, 일괄생성을 진행하세요.');
						return false;
					}
					if(startNo.length < 14) {
						Unilite.messageBox('서비스번호가 잘못 되었습니다.');
						return false;
					}
					var startNoT = startNo.substring(0, records[0].get('SERVICE_NO').length - 5);
					var startNoB = startNo.substring(records[0].get('SERVICE_NO').length - 5, records[0].get('SERVICE_NO').length);
					Ext.each(records, function(record, idx) {
						if(idx != 0
						&& Ext.isEmpty(record.get('SERVICE_NO')) && startIdx < masterGrid.getStore().indexOf(record)
						&& record.get('CIR_PERIOD_YN') == 'Y' && record.get('EXPIRATION_DAY') == startPeri) {
							record.set('SERVICE_NO', startNoT + (parseInt(startNoB) + i));
							i++;
						}
					});
					Unilite.messageBox('서비스번호 생성이 완료 되었습니다.');
				}
			}
		]},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
//			allowBlank	: false,
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						 store.filterBy(function(record){
							 return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});




	/** Proxy 정의 - 20210324 추가: 저장기능 추가
	 *  @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp110rkrv_wmService.selectList',
//			create	: 's_pmp110rkrv_wmService.insertDetail',
			update	: 's_pmp110rkrv_wmService.updateDetail',
//			destroy	: 's_pmp110rkrv_wmService.deleteDetail',
			syncAll	: 's_pmp110rkrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_pmp110rkrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'	, comboType: 'WU'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		, type: 'string'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B013' , displayField: 'value', allowBlank: false},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.specialremark" default="특기사항"/>'		, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'				, type: 'int'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '등록자'		, type: 'string'	, comboType:'AU', comboCode: 'P510'},
			{name: 'PRODT_START_DATE'	, text: '착수예정일'		, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '완료예정일'		, type: 'uniDate'},
			{name: 'PRODT_WKORD_DATE'	, text: '작업지시일'		, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '<t:message code="system.label.purchase.printyn" default="출력여부"/>'			, type: 'string'	, comboType:'AU', comboCode: 'B131'},
			{name: 'DELIV_METHOD'		, text: '배송방법'			, type: 'string', comboType: 'AU', comboCode: 'ZM11'},		//DELIVMETHOD(), 20210106 추가: 배송방법
			{name: 'SERVICE_NO'			, text: '서비스 번호'		, type: 'string'},											//20210324 추가: 서비스 번호, AS여부, AS기간
			{name: 'CIR_PERIOD_YN'		, text: 'AS여부'			, type: 'string', comboType: 'AU', comboCode: 'B010'},		//20210324 추가: 서비스 번호, AS여부, AS기간
			{name: 'EXPIRATION_DAY'		, text: 'AS기간'			, type: 'string'}											//20210324 추가: 서비스 번호, AS여부, AS기간
		]
	});

	var masterStore = Unilite.createStore('s_pmp110rkrv_wmMasterStore',{
		model	: 's_pmp110rkrv_wmModel',
		proxy	: directProxy,			//20210324 수정: 저장기능 추가
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 , 20210324 수정: 저장기능 추가
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = Ext.getCmp('resultForm').getValues();
			//20210106 추가
			if(Ext.isDefined(newValue)) {
				param.rdoSelect = newValue;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toUpdate	= this.getUpdatedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(masterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmp110rkrv_wmGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
				}
			},
			write: function(proxy, operation) {
				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
				}
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_pmp110rkrv_wmGrid', {
		store	: masterStore,
		region	: 'center',
		uniOpt	:{
			useLiveSearch		: true,		//20210311 추가
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
//					var selectedCustom = rowSelection.selected.items[0];
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					masterGrid.down('#printBtn').enable();
					masterGrid.down('#labelPrintBtn').enable();
					masterGrid.down('#carriageBillprintBtn').enable();
					masterGrid.down('#excelDownload').enable();				//20210322 추가
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						masterGrid.down('#printBtn').disable();
						masterGrid.down('#labelPrintBtn').disable();
						masterGrid.down('#carriageBillprintBtn').disable();
						masterGrid.down('#excelDownload').disable();		//20210322 추가
					}
				}
			}
		}),
		tbar	: [{
			text	: '작업지시서',
			itemId	: 'printBtn',
			width	: 100,
			handler	: function() {
				var selectedMasters	= masterGrid.getSelectedRecords();
				var workOrderInfo;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						workOrderInfo = record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
					} else {
						workOrderInfo = workOrderInfo + ',' + record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
					}
				});
				var param			= panelResult.getValues();
				param.PGM_ID		= 's_pmp110rkrv_wm(W)';
				param.MAIN_CODE		= 'Z012';
				param.dataCount		= selectedMasters.length;
				param.workOrderInfo	= workOrderInfo;

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/z_wm/s_pmp110clrkrv_wm.do',
					prgID		: 's_pmp110rkrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
				//출력한 데이터 상태값 변경
				s_pmp110rkrv_wmService.updatePrintStatus(param, function(provider2, response){
				});
			}
		},{
			text	: '라벨',
			itemId	: 'labelPrintBtn',
			width	: 100,
			handler	: function() {
				//20201102 추가 - 라벨출력 관련 로직 추가
				var selectedMasters	= masterGrid.getSelectedRecords();
				var workOrderInfo;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						workOrderInfo = record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
					} else {
						workOrderInfo = workOrderInfo + ',' + record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
					}
				});
				var param			= panelResult.getValues();
				param.PGM_ID		= 's_pmp110rkrv_wm(L)';
				param.MAIN_CODE		= 'Z012';
				param.dataCount		= selectedMasters.length;
				param.workOrderInfo	= workOrderInfo;

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/z_wm/s_pmp110clrkrv_wm(L).do',
					prgID		: 's_pmp110rkrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		},{
			text	: '운송장',
			itemId	: 'carriageBillprintBtn',
			width	: 100,
			handler	: function() {
				//20201112 추가 - 운송장출력 관련 로직 추가
				var selectedMasters	= masterGrid.getSelectedRecords();
				var workOrderInfo;
				var errFlag			= false;	//20210106 추가: 택배배송 여부 확인 flag
				//20210225 추가: 전체 선택 등의 경우 운송장 필요한 데이터만 출력  그외에는 메세지 뿌리지 않고 넘어가도록 수정
				var i = 0;
				Ext.each(selectedMasters, function(record, idx) {
					if(record.get('DELIV_METHOD') == '01' || record.get('DELIV_METHOD') == '02' || record.get('DELIV_METHOD') == '03') {
						if(i == 0) {
							workOrderInfo = record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
						} else {
							workOrderInfo = workOrderInfo + ',' + record.get('WKORD_NUM') + '/' + record.get('WORK_SHOP_CODE');
						}
						i++;
//						//20210106 추가: 택배배송 여부 확인: 01 택배배송, 02 무료배송, 03 선결제
//						if(record.get('DELIV_METHOD') != '01' && record.get('DELIV_METHOD') != '02' && record.get('DELIV_METHOD') != '03') {
//							Unilite.messageBox('배송방법이 택배배송/선결제/무료배송인 경우만 운송장 출력이 가능합니다.');
//							errFlag = true;
//							return false;
//						}
					}
				});
				if(errFlag) return false;

				//20210308 추가: 운송장 출력 시, 안내 메시지 추가
				if(!Ext.isEmpty(workOrderInfo)) {
					var param			= panelResult.getValues();
					param.PGM_ID		= 's_pmp110rkrv_wm(C)';
					param.MAIN_CODE		= 'Z012';
					param.dataCount		= i;					//20210225 수정: selectedMasters.length -> i
					param.workOrderInfo	= workOrderInfo;
	
					var win = Ext.create('widget.ClipReport', {
						url			: CPATH+'/z_wm/s_pmp110clrkrv_wm(C).do',
						prgID		: 's_pmp110rkrv_wm',
						extParam	: param,
						submitType	: 'POST'
					});
					win.center();
					win.show();
				} else {
					Unilite.messageBox('운송장을 출력할(택배배송) 데이터가 없습니다.');
					return false;
				}
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{	//20210322 추가: 바른서비스 데이터 다운로드 기능 추가
			text	: '<font color="blue">다운로드</font>',
			itemId	: 'excelDownload',
			width	: 80,
			handler	: function() {
				//20210324 추가: 저장기능 추가로 체크로직 추가
				if(masterStore.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				var selectedMasters	= masterGrid.getSelectedRecords();
				var workOrderInfo;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						workOrderInfo = record.get('WKORD_NUM') + '/' + record.get('PROG_WORK_CODE');
					} else {
						workOrderInfo = workOrderInfo + ',' + record.get('WKORD_NUM') + '/' + record.get('PROG_WORK_CODE');
					}
				});
				var param			= panelResult.getValues();
				param.dataCount		= selectedMasters.length;
				param.workOrderInfo	= workOrderInfo;

				var form = panelFileDown;
				form.submit({
					params: param,
					success:function(form, action)  {
					},
					failure: function(form, action){
					}
				});
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, align: 'center'},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'PROG_WORK_CODE'	, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'CUSTOM_PRSN'		, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'ORDER_Q'			, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SER_NO'			, width: 80		, align: 'center'},
			{dataIndex: 'TEMPC_01'			, width: 80		, align: 'center'},
			{dataIndex: 'DELIV_METHOD'		, width: 100	, align: 'center'},	//20210106 추가
			{dataIndex: 'ORDER_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'SERVICE_NO'		, width: 130},						//20210324 추가
			{dataIndex: 'CIR_PERIOD_YN'		, width: 80		, align: 'center'},	//20210324 추가
			{dataIndex: 'EXPIRATION_DAY'	, width: 80		, align: 'center'}	//20210324 추가

		],
		listeners: {
			//20210324 추가: 저장기능 추가
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['SERVICE_NO'])) {
					if(e.record.get('CIR_PERIOD_YN') == 'Y') {
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			},
			//20201202 체크로직 수정
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				if(cellIndex != 0) {
					var sm		= masterGrid.getSelectionModel();
					var records	= masterStore.data.items;
					var data	= masterGrid.getSelectionModel().getSelection();
					Ext.each(records, function(record, idx) {
						if(!Ext.isEmpty(selRecord.get('CUSTOM_PRSN')) && selRecord.get('CUSTOM_PRSN') == record.get('CUSTOM_PRSN')){
							data.push(record);
						}
					});
					sm.select(data);
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});



	//20210322 추가: 바른서비스 데이터 다운로드 기능 추가
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH+'/z_wm/pmp110rkrvExcelDown.do',
		layout			: {type: 'uniTable', columns: 1},
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true
	});



	Unilite.Main({
		id			: 's_pmp110rkrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('TO_PRODT_WKORD_DATE'	, UniDate.get('today'));
			panelResult.setValue('FR_PRODT_WKORD_DATE'	, UniDate.add(panelResult.getValue('TO_PRODT_WKORD_DATE'), {weeks: -1}));
			panelResult.setValue('rdoSelect'			, 'N');
			masterGrid.down('#printBtn').disable();
			masterGrid.down('#labelPrintBtn').disable();
			masterGrid.down('#carriageBillprintBtn').disable();
			masterGrid.down('#excelDownload').disable();			//20210322 추가
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()) {
				return false;
			}
			masterGrid.down('#printBtn').disable();
			masterGrid.down('#labelPrintBtn').disable();
			masterGrid.down('#carriageBillprintBtn').disable();
			masterGrid.down('#excelDownload').disable();			//20210322 추가
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},
		//20210324 추가: 저장기능 추가
		onSaveDataButtonDown: function(config) {
			if(masterStore.isDirty()){
				masterStore.saveStore();
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		}
	});
};
</script>