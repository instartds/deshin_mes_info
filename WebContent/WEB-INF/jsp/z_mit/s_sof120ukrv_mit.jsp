<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof120ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof120ukrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>				<!-- 예/아니오 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-row-gray {
	background-color: #eaeaea;
}
</style>
<script type="text/javascript">

//출고예정표(MIT) (s_sof120ukrv_mit)
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof120ukrv_mitService.selectDetailList',
			update	: 's_sof120ukrv_mitService.updateDetail',
			create	: 's_sof120ukrv_mitService.insertDetail',
			destroy	: 's_sof120ukrv_mitService.deleteDetail',
			syncAll	: 's_sof120ukrv_mitService.saveAll'
		}
	});



	/** Model 정의 
	 */
	Unilite.defineModel('s_sof120ukrv_mitModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'int'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'		,type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'	,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'				,text: '규격'			,type: 'string'},																		//20191205 신규컬럼 추가(BPR100T.SPEC)
			{name: 'SPEC_NUM'			,text: '도면번호'		,type: 'string'},																		//20191205 신규컬럼 추가(BPR100T.SPEC_NUM)
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'			,type: 'uniQty'},
			{name: 'ORDER_Q_CAL'		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'			,type: 'uniQty'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'	,type: 'string'	,displayField: 'value'},
			{name: 'INIT_DVRY_DATE'		,text: '최초납기'		,type: 'uniDate'},																		//20191205 신규컬럼 추가(SOF110T.INIT_DVRY_DATE)
			{name: 'DVRY_DATE'			,text: '출고예정일'		,type: 'uniDate'},																		//20191205 컬럼명 변경: 납기일 -> 출고예정일
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'	/*,allowBlank: false*/},	//20200129 LOT_NO 값 없을 떄 '*' 넣기 위한 로직 추가 / 필수 해제
			{name: 'LOT_NO_ORI'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'},
			{name: 'ITEM_INSTOCK_DATE'	,text: '멸균 입고일'		,type: 'string'},
			{name: 'DVRY_CUST_NM'		,text: '국내배송처'		,type: 'string'},
			{name: 'WH_CELL_CODE'		,text: '랜딩위치코드'		,type: 'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'		,type: 'string'},
			{name: 'REMARK'				,text: '비고'		,type: 'string'},		
			{name: 'REMARK_INTER'		,text: '내부비고'		,type: 'string'},																		//20191120 작업지시번호, 내부비고 컬럼 추가
			{name: 'PRINT_YN'			,text: '출력여부'		,type: 'string'	,comboType:'AU'	,comboCode:'B131'},										//20191205 신규컬럼 추가(S_SOF120T_MIT.PRINT_YN)
			{name: 'PAB_STOCK_YN'		,text: '가용재고여부'		,type: 'string'},																		//20200128 신규컬럼 추가(가용재고)
			{name: 'CHECK_YN'			,text: 'CHECK_YN'	,type: 'string', editable: false},														//20200129 체크된 데이터만 저장하기 위해 신규컬럼 추가(CHECK_YN)
			{name: 'PO_NUM'				,text: 'PO NO'		,type: 'string'}	,
			{name: 'UPDATE_DB_TIME'		,text: '확인저장시간'		,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 */
	var detailStore = Unilite.createStore('s_sof120ukrv_mitDetailStore1',{
		model	: 's_sof120ukrv_mitModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//20200129 체크된 데이터만 저장되도록 로직 추가
			var saveRecords = masterGrid.getStore().data.items
			Ext.each(saveRecords, function(record, i) {
				if(masterGrid.getSelectionModel().isSelected(record) == true) {
					record.set('CHECK_YN', 'Y');
				}
			});

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정
			
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(detailStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sof120ukrv_mitGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records && records.length > 0) {
					UniAppManager.setToolbarButtons(['newData'], true);
				} else {
					UniAppManager.setToolbarButtons(['newData'], false);
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



	/** 검색조건 (Search Panel)
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '수주입력일',							//20200313 라벨명 변경: 수주일 -> 수주입력일
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'), 			/* UniDate.get('endOfTwoNextMonth'),	 */
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				'onSelected': {
					fn: function(records, type) {
					},
					scope: this
				},
				'onClear': function(type) {
				}
			}
		}),{
			//20191120 출고준비 필드 추가
			xtype		: 'radiogroup',
			fieldLabel	: '출고준비',
			items		: [{
				boxLabel	: '전체',
				name		: 'COMPLETE_YN',
				inputValue	: '',
				width		: 60
			},{
				boxLabel	: '미완료',
				name		: 'COMPLETE_YN',
				inputValue	: '1',
				width		: 70,
				checked		: true
			},{
				boxLabel	: '완료',
				name		: 'COMPLETE_YN',
				inputValue	: '2',
				width		: 150
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20200128 조회조건 변경: 진행상태 -> 확인여부
			xtype		: 'radiogroup',
			fieldLabel	: '확인여부',
			items		: [{
				boxLabel	: '미확인',
				name		: 'CONFIRM_YN',
				inputValue	: 'N',
				width		: 80,
				checked		: true
			},{
				boxLabel	: '확인',
				name		: 'CONFIRM_YN',
				inputValue	: 'Y',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
//		},{	//20200128 조회조건 변경: 진행상태 -> 확인여부
//			xtype		: 'radiogroup',
//			fieldLabel	: '진행상태',
//			items		: [{
//				boxLabel	: '진행 중',
//				name		: 'RDO_SELECT',
//				inputValue	: '1',
//				width		: 80,
//				checked		: true
//			},{
//				boxLabel	: '완료',
//				name		: 'RDO_SELECT',
//				inputValue	: '2',
//				width		: 80
//			}],
//			listeners: {
//				change: function(field, newValue, oldValue, eOpts) {
//				}
//			}
		},{
			fieldLabel		: '수주일',							//20200313 라벨명 변경: 납기일 -> 수주일
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			//startDate		: UniDate.get('startOfMonth'),
			//endDate			: UniDate.get('endOfTwoNextMonth'),		/*UniDate.get('today'), */
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: '수주번호',
			xtype		: 'uniTextfield',
			name		: 'ORDER_NUM',
			listeners	: {
				change : function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				'onSelected': {
					fn: function(records, type) {
					},
					scope: this
				},
				'onClear': function(type) {
				}
			}
		}),{//20191205 출력데이터를 위한 키값 필드 생성
			fieldLabel	: '',
			name		: 'KEY_VALUE',
			xtype		: 'uniTextfield',
			width		: 1000,
			readOnly	: true,
			hidden		: true
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('s_sof120ukrv_mitGrid1', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useLiveSearch		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false
		},
		//20191205 체크박스 모텔 추가
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount()) {
						var keyValue = panelResult.getValue('KEY_VALUE');
						if(!Ext.isEmpty(selectRecord.get('LOT_NO'))) {
							if(Ext.isEmpty(keyValue)) {
								panelResult.setValue('KEY_VALUE', selectRecord.get('ORDER_NUM') + selectRecord.get('SER_NO') + selectRecord.get('LOT_NO'));
							} else {
								panelResult.setValue('KEY_VALUE', keyValue + ',' + selectRecord.get('ORDER_NUM') + selectRecord.get('SER_NO') + selectRecord.get('LOT_NO'));
							}
						}
//						//20200129 체크된 데이터만 저장하기 위해 신규컬럼 로직 추가(CHECK_YN)
//						selectRecord.set('CHECK_YN', 'Y');
						UniAppManager.setToolbarButtons('print'	, true);
						UniAppManager.setToolbarButtons('save'	, true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					//20200129 추가
//					if(UniAppManager.app._needSave()) {
//						var needSave = true;
//					} else {
//						var needSave = false;
//					}
					if(!Ext.isEmpty(selectRecord.get('LOT_NO'))) {
						var keyValue	= panelResult.getValue('KEY_VALUE');
						var deletedNum0	= selectRecord.get('ORDER_NUM') + selectRecord.get('SER_NO') + selectRecord.get('LOT_NO') + ','; 
						var deletedNum1	= ',' + selectRecord.get('ORDER_NUM') + selectRecord.get('SER_NO') + selectRecord.get('LOT_NO'); 
						var deletedNum2	= selectRecord.get('ORDER_NUM') + selectRecord.get('SER_NO') + selectRecord.get('LOT_NO');
						if(deletedNum0 != ',') {
							keyValue = keyValue.split(deletedNum0).join("");
						}
						if(deletedNum1 != ',') {
							keyValue = keyValue.split(deletedNum1).join("");
						}
						keyValue = keyValue.split(deletedNum2).join("");
						panelResult.setValue('KEY_VALUE', keyValue);
					}
//					//20200129 체크된 데이터만 저장하기 위해 신규컬럼 로직 추가(CHECK_YN)
//					selectRecord.set('CHECK_YN', '');
					if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons('print'	, false);
						UniAppManager.setToolbarButtons('save'	, false);
					}
				}
			}
		}),
		columns	: [{
				//20191205 체크박스 모델 추가로 행번호 컬럼 수동으로 생성
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				width		: 35
			},
			{ dataIndex: 'DIV_CODE'			, width: 120, hidden: true},
			{ dataIndex: 'CHECK_YN'			, width: 100, hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'SER_NO'			, width: 53	, align: 'center'},
			{ dataIndex: 'ORDER_DATE'		, width: 93	},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 250},
			{ dataIndex: 'SPEC'				, width: 120},							//20191205 신규컬럼 추가(BPR100T.SPEC)
			{ dataIndex: 'SPEC_NUM'			, width: 120},							//20191205 신규컬럼 추가(BPR100T.SPEC_NUM)
			{ dataIndex: 'ORDER_UNIT'		, width: 66	, align: 'center' },
			{ dataIndex: 'ORDER_Q'			, width: 80	, hidden: true},
			{ dataIndex: 'ORDER_Q_CAL'		, width: 80	},
			{ dataIndex: 'INIT_DVRY_DATE'	, width: 93	},							//20191205 신규컬럼 추가(SOF110T.INIT_DVRY_DATE)
			{ dataIndex: 'DVRY_DATE'		, width: 93	},
			{ dataIndex: 'PAB_STOCK_YN'		, width: 80, align: 'center'},							//20200128 신규컬럼 추가(가용재고)
			{ dataIndex: 'LOT_NO'			, width: 200,
				editor: Unilite.popup('LOT_MULTI_MIT_G', {
					textFieldName	: 'LOT_NO',
					DBtextFieldName	: 'LOT_NO',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord	= masterGrid.uniOpt.currentRecord;
								var grdIdx		= masterGrid.getStore().findBy(function(record, id) {
													if(grdRecord.id	== id) return true
												  });
								//20200129 로직 추가
								var needSelect	= masterGrid.getSelectionModel().getSelection();
								Ext.each(records, function(record,i) {
									if(i==0){
										grdRecord.set('LOT_NO'		, record['LOT_NO']);
										//20191129 로직 추가
										grdRecord.set('ORDER_Q_CAL'	, 1);
									} else{
										var r = {
											'COMP_CODE'			: grdRecord.get('COMP_CODE'),
											'DIV_CODE'			: grdRecord.get('DIV_CODE'),
											'ORDER_NUM'			: grdRecord.get('ORDER_NUM'),
											'SER_NO'			: grdRecord.get('SER_NO'),
											'ORDER_DATE'		: grdRecord.get('ORDER_DATE'),
											'CUSTOM_CODE'		: grdRecord.get('CUSTOM_CODE'),
											'CUSTOM_NAME'		: grdRecord.get('CUSTOM_NAME'),
											'ITEM_CODE'			: grdRecord.get('ITEM_CODE'),
											'ITEM_NAME'			: grdRecord.get('ITEM_NAME'),
											'SPEC'				: grdRecord.get('SPEC'),
											'SPEC_NUM'			: grdRecord.get('SPEC_NUM'),
											'ORDER_Q'			: grdRecord.get('ORDER_Q'),
											'ORDER_Q_CAL'		: 1,
											'ORDER_UNIT'		: grdRecord.get('ORDER_UNIT'),
											'INIT_DVRY_DATE'	: grdRecord.get('INIT_DVRY_DATE'),
											'DVRY_DATE'			: grdRecord.get('DVRY_DATE'),
											'LOT_NO'			: record.LOT_NO,
											'LOT_NO_ORI'		: grdRecord.get('LOT_NO_ORI'),
											'ITEM_INSTOCK_DATE'	: grdRecord.get('ITEM_INSTOCK_DATE'),
											'DVRY_CUST_NM'		: grdRecord.get('DVRY_CUST_NM'),
											'WH_CELL_CODE'		: grdRecord.get('WH_CELL_CODE'),
											'WKORD_NUM'			: grdRecord.get('WKORD_NUM'),
											'REMARK'			: grdRecord.get('REMARK'),
											'REMARK_INTER'		: grdRecord.get('REMARK_INTER'),
											'PRINT_YN'			: grdRecord.get('PRINT_YN')
											//'PAB_STOCK_YN'		: grdRecord.get('PAB_STOCK_Q')
										}
										masterGrid.createRow(r, null, grdIdx + i - 1);
									}
								});
								//20200129 로직 추가
								var selectRecords = masterGrid.getStore().data.items;
								Ext.each(selectRecords, function(selectRecord, idx) {
									if(grdRecord.get('ORDER_NUM')	== selectRecord.get('ORDER_NUM')
									&& grdRecord.get('SER_NO')		== selectRecord.get('SER_NO')
									/*&& masterGrid.getSelectionModel().isSelected(selectRecord) == false*/) {
										needSelect.push(selectRecord);
									}
								});
								masterGrid.getSelectionModel().select(needSelect);
							},
						scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO'		, '');
							//20191129 로직 추가
							rtnRecord.set('ORDER_Q_CAL'	, 1);
						},
						applyextparam: function(popup){
							var record		= masterGrid.uniOpt.currentRecord;
							var divCode		= record.get('DIV_CODE');
							var customCode	= record.get('CUSTOM_CODE');
							var customName	= record.get('CUSTOM_NAME'); 
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							//20191120 멀티 LOT 선택 시 체크하기 위해서 추가, 20191129 로직 수정(남은수량 넘기기 위한 로직)
							var mstRecords	= detailStore.data.items;
							var orderQ		= 0
							Ext.each(mstRecords, function(mstRecord,i) {
								if (mstRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && mstRecord.get('SER_NO') == record.get('SER_NO')) {
									orderQ = orderQ + 1;
								}
							});
							orderQ = record.get('ORDER_Q') - orderQ +1;
							popup.setExtParam({
								'SELMODEL'	: 'MULTI',
								'DIV_CODE'	: divCode,
								'ITEM_CODE'	: itemCode,
								'ITEM_NAME'	: itemName,
								'ORDER_Q'	: orderQ
							});
						}
					}
				})
			},
			{ dataIndex: 'WKORD_NUM'		, width: 100},							//20191120 작업지시번호 컬럼 추가
			{ dataIndex: 'ITEM_INSTOCK_DATE', width: 100},
			{ dataIndex: 'DVRY_CUST_NM'		, width: 200},
			{ dataIndex: 'WH_CELL_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'REMARK'			, width: 200},	
			{ dataIndex: 'REMARK_INTER'		, width: 200},							//20191120 내부비고 컬럼 추가Z
			{ dataIndex: 'PRINT_YN'			, width: 70	, align: 'center'},			//20191205 신규컬럼 추가(S_SOF120T_MIT.PRINT_YN)
			{ dataIndex: 'PO_NUM'			, width: 200},
			{ dataIndex: 'UPDATE_DB_TIME'	, width: 200}
		],
		listeners: { 
			beforeedit : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['LOT_NO'])){
					return true;
				} else {
					return false;
				}
			}
		},
		//20191205 출력여부가 'Y'이면 회색으로 변경하는 로직 추가
		viewConfig:{
			forceFit	: true,
			stripeRows	: false,
			getRowClass	: function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('PRINT_YN')=="Y"){
					cls = 'x-change-row-gray';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 's_sof120ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid,
				panelResult
			] 
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'			,UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	,UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO'	,UniDate.get('today'));	//UniDate.get('endOfTwoNextMonth'));
			panelResult.getField('CONFIRM_YN').setValue('N');
			//20191120 출고준비 필드 추가
			panelResult.getField('COMPLETE_YN').setValue('1');
			UniAppManager.setToolbarButtons(['detail','reset'], false);
			UniAppManager.setToolbarButtons('reset'	, true);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		onQueryButtonDown : function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			//20191205 출력데이터를 위한 키값 초기화
			panelResult.setValue('KEY_VALUE', '');
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown : function() {
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getStore().clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function() {
			var grdRecord = masterGrid.uniOpt.currentRecord;
			if(Ext.isEmpty(grdRecord)) {
				Unilite.messageBox('추가할 행을 선택하세요');
				return false;
			}
			masterGrid.createRow();
			var rtnRecord = masterGrid.getSelectedRecord();
			var columns = masterGrid.getColumns();
			Ext.each(columns, function(column, index) {
				if(column.dataIndex != 'LOT_NO') {
					rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(selRow)) {
				Unilite.messageBox('선택된 데이터가 없습니다.');
				return false;
			}
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
			//20200129 추가
			masterGrid.getSelectionModel().deselectAll();
			UniAppManager.setToolbarButtons('save'	, true);
		},
		onPrintButtonDown: function() {
			//20200129 주석: 체크로직 변경으로 인해 저장 전 출력 체크로직은 주석
//			if(UniAppManager.app._needSave()) {
//				Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
//				return false;
//			}
			var errFlag = false;
			var records = masterGrid.getSelectedRecords();
			Ext.each(records, function(record, index) {
				if(Ext.isEmpty(record.get('LOT_NO')) || record.get('LOT_NO') == '*') {		//20200129 '!record.get('LOT_NO') == '*'' 추가
					Unilite.messageBox('출고준비가 완료된 행만 출력 가능 합니다.');
					errFlag = true
					return false;
				}
			});
			if(errFlag) return false;

			var param	= panelResult.getValues();
			var win		= Ext.create('widget.ClipReport', {
				url		: CPATH+'/z_mit/s_sof120clukrv_mit.do',
				prgID	: 's_sof120ukrv_mit',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>