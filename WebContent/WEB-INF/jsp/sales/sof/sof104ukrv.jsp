<%--
	' 프로그램명 : 수주납기변경등록 (sof104ukrv)
	' 작   성   자 : 시너지시스템즈 개발팀
	' 작   성   일 :
	' 최종수정자 :
	' 최종수정일 :
	' 버         전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof104ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="sof104ukrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S180"/>				<!-- 변경사유 -->
	<t:ExtComboStore items="${userCombo}" storeId="userCombo"/>		<!-- 창고Cell-->
</t:appConfig>
<style type="text/css">
.x-change-cell {
	background-color: #FFFFC6;
}
</style>
<script type="text/javascript" >


function appMain() {
/* type
 *	uniQty			- 수량
 *	uniUnitPrice	- 단가
 *	uniPrice		- 금액(자사화폐)
 *	uniPercent		- 백분율(00.00)
 *	uniFC			- 금액(외화화폐)
 *	uniER			- 환율
 *	uniDate			- 날짜(2999.12.31)
 *	maxLength		- 입력가능한 최대 길이
 *	editable: true	- 수정가능 여부
 *	allowBlank		- 필수 여부
 *	defaultValue	- 기본값
 *	comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
 */

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,	//20210621 추가: 조회조건 '영업담당' 추가로 초기화 시, filter로직 구현하기 위해 추가
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20210621 추가: 조회조건 '영업담당' 추가로 filter 로직 추가
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			allowBlank		: false,
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup) {
//					popup.setExtParam({'CUSTOM_TYPE':['1', '3']});
				}
			}
		}),{//20210621 추가: 조회조건 '영업담당' 추가
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			name		: 'ORDER_NUM',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}]
	});




	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sof104ukrvService.selectList',
			update	: 'sof104ukrvService.updateDetail',
			create	: 'sof104ukrvService.insertDetail',
			destroy	: 'sof104ukrvService.deleteDetail',
			syncAll	: 'sof104ukrvService.saveAll'
		}
	});

	Unilite.defineModel('sof104ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ITEM_NAMES'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					, type: 'uniDate'},
			{name: 'SEQ'				, text: '변경차수'			, type: 'string'},
			{name: 'BF_DVRY_DATE'		, text: '이전 납기일'		, type: 'uniDate'},
			{name: 'AF_DVRY_DATE'		, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				, type: 'uniDate'	, allowBlank: false},
			{name: 'REASON_CODE'		, text: '<t:message code="system.label.sales.deliverydatereason" default="납기변경사유"/>'	, type: 'string'	, allowBlank: false, comboType: 'AU', comboCode: 'S180'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'				, type: 'string'	, store: Ext.data.StoreManager.lookup('userCombo')},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'				, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('sof104ukrvStore', {
		model	: 'sof104ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부, 20210621 수정: 삭제 안 되도록 변경
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			this.load({
				params: param
			});
		},
		saveStore: function() {
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						panelResult.setValue('ORDER_NUM', master.ORDER_NUM);

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
				var grid = Ext.getCmp('sof104ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					UniAppManager.setToolbarButtons('newData', true);
				} else {
					UniAppManager.setToolbarButtons('newData', false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'ORDER_NUM'
	});

	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sof104ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false}
		],
		columns: [
//			{dataIndex: 'COMP_CODE'			, width: 133, hidden: true},
//			{dataIndex: 'DIV_CODE'			, width: 133, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 133},
			{dataIndex: 'CUSTOM_CODE'		, width: 133},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'ITEM_NAMES'		, width: 250},
			{dataIndex: 'ORDER_DATE'		, width: 100},
			{dataIndex: 'SEQ'				, width: 100, align: 'center',
				renderer:function(value, metaData, record) {
					var r = value;
					if(r == '0') r ='최초';
					return r;
				}
			},
//			{dataIndex: 'BF_DVRY_DATE'		, width: 100},
			{dataIndex: 'AF_DVRY_DATE'		, width: 100, tdCls: 'x-change-cell'},
			{dataIndex: 'REASON_CODE'		, width: 180, tdCls: 'x-change-cell'},
			{dataIndex: 'REMARK'			, width: 200},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100, align: 'center'},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 130, align: 'center'}
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
				var orderNum = e.record.get('ORDER_NUM');
				if(e.record.get('SEQ') != 0 && e.record.get('SEQ') == directMasterStore.max('SEQ', orderNum)[orderNum]) {
					if (UniUtils.indexOf(e.field, ['AF_DVRY_DATE', 'REASON_CODE', 'REMARK'])) {
						return true;
					}
				}
				return false;
			},
			selectionchange:function( grid, selection, eOpts ) {
/*				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}*/
			},
			afterrender: function(grid) {
/*				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '수주등록 바로가기',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'sof104ukrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ORDER_NUM	: record.data.ORDER_NUM
						}
						var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sof100ukrv.do', params);
					}
				});*/
			}
		}
	});



	Unilite.Main({
		id			: 'sof104ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			//20210621 추가: 조회조건 '영업담당' 추가로 filter 로직 추가
			var pCombo	= panelResult.getField('DIV_CODE');
			var combo	= panelResult.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			var field	= panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons('newData', false);
			this.fnInitBinding();
		},
		onNewDataButtonDown: function() {
			if(UniAppManager.app._needSave()) {
				//한 번에 하나의 행만 추가할 수 있음: 아래 주석한 내용은 필수 입력 되면 행 추가를 더 할 수 있게 하려고 구현했던 내용임
//				var inValidRecs = directMasterStore.getInvalidRecords();
//				if(inValidRecs != 0) {
//					var grid = Ext.getCmp('sof104ukrvGrid1');
//					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>')
					return false;
//				}
			}
			var record = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(record)) {
				Unilite.messageBox('선택된 데이터가 없습니다.');
				return false;
			}
			var seq = parseInt(directMasterStore.max('SEQ', record.get('ORDER_NUM'))[record.get('ORDER_NUM')]);
			var newSeq;
			if(!seq) newSeq = 1;
			else newSeq = seq + 1;

			//행 추가 시, 가지고 갈 데이터(이전 납기일) 선택
			var basisRecords = masterGrid.getStore().data.items;
			var bfDvryDate, bfRowIndex;
			Ext.each(basisRecords,function(basisRecord, i) {
				if(basisRecord.get('ORDER_NUM') == record.get('ORDER_NUM')
				&& basisRecord.get('SEQ') == seq) {
					bfDvryDate = basisRecord.get('AF_DVRY_DATE');
					bfRowIndex = i;
				}
			});
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				ORDER_NUM		: record.get('ORDER_NUM'),
				CUSTOM_CODE		: record.get('CUSTOM_CODE'),
				CUSTOM_NAME		: record.get('CUSTOM_NAME'),
				ITEM_NAMES		: record.get('ITEM_NAMES'),
				ORDER_DATE		: record.get('ORDER_DATE'),
				SEQ				: newSeq,
				BF_DVRY_DATE	: bfDvryDate,
				UPDATE_DB_USER	: UserInfo.userID,
				UPDATE_DB_TIME	: realTimer()				//UniDate.get('today')
			};
			masterGrid.createRow(r, null, bfRowIndex);
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('SEQ') == 0) {
					Unilite.messageBox('기준 데이터는 삭제할 수 없습니다.');
					return false;
				} else if(selRow.get('SEQ') != directMasterStore.max('SEQ', selRow.get('ORDER_NUM'))[selRow.get('ORDER_NUM')]) {
					Unilite.messageBox('가장 상위차수의 데이터만 삭제할 수 있습니다.');
					return false;
				} else {
					masterGrid.deleteSelectedRow();
				}
			}
		}
	});



	//행추가 시, 현재시간(yyyy-mm-dd hh:mm:ss) 표시 위해
	function realTimer() {
		const nowDate	= new Date();
		const year		= nowDate.getFullYear();
		const month		= nowDate.getMonth() + 1;
		const date		= nowDate.getDate();
		const hour		= nowDate.getHours();
		const min		= nowDate.getMinutes();
		const sec		= nowDate.getSeconds();
		return year + '-' + addzero(month) + '-' + addzero(date) + ' ' + addzero(hour) + ':'  + addzero(min) + ':' + addzero(sec);
	}
	//1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) { num = '0' + num; }
		return num;
	}
};
</script>