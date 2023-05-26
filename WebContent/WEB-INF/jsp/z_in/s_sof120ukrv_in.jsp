<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof120ukrv_in"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_sof120ukrv_in"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Z012" />				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B138" />				<!--영업담당 -->
	<t:ExtComboStore comboType="W" />								<!--작업장(전체) -->
	<t:ExtComboStore comboType="OU" />								<!--창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

</style>
<style type="text/css">

.x-change-cell_color {
		color: #FF0000
}

</style>
</t:appConfig>
<script type="text/javascript" >
var beforeRowIndex;	//마스터그리드 같은row중복 클릭시 다시 load되지 않게
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof120ukrv_inService.selectList',
			update	: 's_sof120ukrv_inService.updateDetail',
			create	: 's_sof120ukrv_inService.insertDetail',
			destroy	: 's_sof120ukrv_inService.deleteDetail',
			syncAll	: 's_sof120ukrv_inService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('S_sof120ukrv_inModel1', {
		fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'		,type: 'string'},
			{name: 'SER_NO'					, text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'int'},
			{name: 'CUSTOM_CODE'			, text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'	,type: 'uniDate'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'READY_STATUS'			, text: '준비상태'		,type: 'string'	, comboType: 'AU'		, comboCode: 'Z012' },
			{name: 'PROD_END_DATE'			, text: '생산완료일'		,type:'uniDate'},
			{name: 'LOT_NO'					, text: 'LOT NO'	,type:'string'},
			{name: 'PACK_TYPE'				, text: '포장유형'		,type:'string'	, comboType: 'AU'	, comboCode: 'B138' },
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.sales.packqty" default="포장수량"/>'		,type:'uniQty'},
			{name: 'TRANS_RATE'				, text: '포장단위'		,type:'string'},
			{name: 'ORDER_Q'				, text: '판매수량'		,type:'uniQty'},
			{name: 'ORDER_UNIT'				, text: '단위'		,type:'string'},
			{name: 'DVRY_CUST_NM'			, text: '납품처'		,type:'string'},
			{name: 'WH_CODE'				, text: '출고창고코드'	,type:'string'},
			{name: 'WH_NAME'				, text: '출고창고'		,type:'string'},
			{name: 'ORDER_DATE'				, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'		,type: 'uniDate'},
			{name: 'REMARK'					, text: '<t:message code="system.label.sales.remarks" default="비고"/>'		,type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,type: 'string' , comboType: 'AU'	, comboCode: 'S002'},
			{name: 'IN_WH_CODE'				, text: '입고창고'		,type: 'string'	, comboType: 'OU', value: '31000', editable: false, child: 'IN_WH_CELL_CODE'},
			//20200515 추가
			{name: 'IN_WH_CELL_CODE'		, text: '입고창고CELL'	, type: 'string', editable: false, store: Ext.data.StoreManager.lookup('whCellList')},
			{name: 'REMARK_INTER'			, text: '내부기록'		,type: 'string'},
			//20200508 추가: 비고(출하), LOT_NO_ORI
			{name: 'OUT_REMARK'				, text: '비고(출하)'	,type: 'string'},
			{name: 'LOT_NO_ORI'				, text: 'LOT_NO_ORI',type: 'string'},
			//20200514 추가: WH_CELL_CODE
			{name: 'WH_CELL_CODE'			, text: '출고창고CELL'	,type: 'string'	, editable: false}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_sof120ukrv_inMasterStore1',{
		model: 'S_sof120ukrv_inModel1',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부		//20200508 수정: 삭제가능하게 변경
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()	{
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			var errFlag = false;

			Ext.each(list, function(record,i) {
				if(record.get('READY_STATUS') == '10' && Ext.isEmpty(record.get('LOT_NO'))) {
					errFlag = true;
					return false;
				}
			});
			if(errFlag) {
				Unilite.messageBox('출고준비 완료인 경우에는 LOT_NO는 필수 입력사항 입니다.');
				return false;
			}
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						panelResult.getForm().wasDirty = false;
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sof120ukrv_inGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		//20200508 추가: LOT_NO가 있으면  삭제가능하도록 수정하는 로직과 관련해서 조회 시 삭제버튼 비활성화로직 추가
		listeners:{
			load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons(['delete'], false);
			}
		}
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		}, {
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 470,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('DVRY_DATE_FR',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('DVRY_DATE_TO',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '조회',
			items : [{
				boxLabel: '전체',
				name: 'INQ_TYPE' ,
				inputValue: '',
				checked: true,
				width:55
			}, {boxLabel: '생산 미확인',
				name: 'INQ_TYPE',
				inputValue: '1',
				width:95
			}, {boxLabel: '생산완료',
				name: 'INQ_TYPE',
				inputValue: '2',
				width:95
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.getField('INQ_TYPE').setValue(newValue.INQ_TYPE);
				}
			}
		},Unilite.popup('AGENT_CUST', {
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
						}
			}
	}),Unilite.popup('DIV_PUMOK',{
		fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		valueFieldName: 'ITEM_CODE',
		textFieldName: 'ITEM_NAME',
		autoPopup: true,
		listeners: {
			onValueFieldChange: function(field, newValue){
				panelResult.setValue('ITEM_CODE', newValue);
			},
			onTextFieldChange: function(field, newValue){
				panelResult.setValue('ITEM_NAME', newValue);
			},
			applyextparam: function(popup){
				popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
			}
		}
   })]
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
					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		//hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_TO',newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '조회',
			items : [{
				boxLabel: '전체',
				name: 'INQ_TYPE' ,
				inputValue: '',
				checked: true,
				width:55
			}, {boxLabel: '생산 미확인',
				name: 'INQ_TYPE',
				inputValue: '1',
				width:95
			}, {boxLabel: '생산완료',
				name: 'INQ_TYPE',
				inputValue: '2',
				width:95
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('INQ_TYPE').setValue(newValue.INQ_TYPE);
				}
			}
		},Unilite.popup('AGENT_CUST', {
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
			}
	}),Unilite.popup('DIV_PUMOK',{
		fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		valueFieldName: 'ITEM_CODE',
		textFieldName: 'ITEM_NAME',
		autoPopup: true,
		listeners: {
			onValueFieldChange: function(field, newValue){
				panelSearch.setValue('ITEM_CODE', newValue);
			},
			onTextFieldChange: function(field, newValue){
				panelSearch.setValue('ITEM_NAME', newValue);
			},
			applyextparam: function(popup){
				popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
			}
		}
   }),{   fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
		name: 'ORDER_TYPE',
		comboType: 'AU',
		comboCode: 'S002',
		xtype: 'uniCombobox',
		allowBlank:true,
		holdable: 'hold',
		listeners: {
			change: function(field, newValue, oldValue, eOpts) {

			}
		}
   }]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_sof120ukrv_inGrid1', {
		layout	: 'fit',
		region	: 'center',
		store	: masterStore,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true,
			onLoadSelectFirst	: false
		}
		,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns:  [
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 90 },
			{ dataIndex: 'CUSTOM_NAME'			, width: 115},
			{ dataIndex: 'DVRY_DATE'			, width: 100 },
			{ dataIndex: 'ITEM_CODE'			, width: 80 },
			{ dataIndex: 'ITEM_NAME'			, width: 125 },
			{ dataIndex: 'REMARK'				, width: 130 },
			{ dataIndex: 'REMARK_INTER'			, width: 110,
				renderer: function(value, metaData, record) {
					metaData.tdCls = 'x-change-cell_color';
					return value ;
				}
			},
			//20200508 추가: 비고(출하), LOT_NO_ORI
			{ dataIndex: 'OUT_REMARK'			, width: 110 },
			{ dataIndex: 'LOT_NO_ORI'			, width: 110 , hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 110 , hidden: true},
			{ dataIndex: 'WH_NAME'				, width: 130 , hidden: true},
			//20200514 추가: WH_CELL_CODE
			{ dataIndex: 'WH_CELL_CODE'			, width: 130 , hidden: true},
			{ dataIndex: 'READY_STATUS'			, width: 110 },
			{ dataIndex: 'PROD_END_DATE'		, width: 110 },
			{ dataIndex: 'LOT_NO'				, width: 90	,
				editor: Unilite.popup('LOT_MULTI_IN_G', {
					textFieldName	: 'LOT_CODE',
					DBtextFieldName	: 'LOT_CODE',
					validateBlank	: false,
					autoPopup		: false,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;
									}else{
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord = masterGrid.getSelectedRecord();
										var columns		= masterGrid.getColumns();
										Ext.each(columns, function(column, index)	{
										 if(column.dataIndex != 'LOT_NO'
												 && column.dataIndex != 'WH_CODE'
												 && column.dataIndex != 'WH_NAME') {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});
									}
									rtnRecord.set('LOT_NO'		, record['LOT_NO']);
									rtnRecord.set('WH_CODE'		, record['WH_CODE']);
									rtnRecord.set('WH_NAME'		, record['WH_NAME']);
									//20200514 추가: WH_CELL_CODE
									rtnRecord.set('WH_CELL_CODE', record['WH_CELL_CODE']);
									//202005145추가
									rtnRecord.set('IN_WH_CODE'		, record['WH_CODE']);
									rtnRecord.set('IN_WH_CELL_CODE'	, record['WH_CELL_CODE']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO'		, '');
							//20200514 추가: 초기화 로직 추가
							rtnRecord.set('WH_CODE'		, '');
							rtnRecord.set('WH_NAME'		, '');
							//20200514 추가: WH_CELL_CODE
							rtnRecord.set('WH_CELL_CODE', '');
							//202005145추가
							rtnRecord.set('IN_WH_CODE'		, '');
							rtnRecord.set('IN_WH_CELL_CODE'	, '');
						},
						'applyextparam': function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var stockYN		= 'Y'
							popup.setExtParam({
								SELMODEL	: 'MULTI',
								'DIV_CODE'	: divCode,
								'ITEM_CODE'	: itemCode,
								'ITEM_NAME'	: itemName,
								'STOCK_YN'	: stockYN
							});
						}
					}
				})
			},
			{ dataIndex: 'IN_WH_CODE'			, width: 140},
			//20200515 추가
			{ dataIndex: 'IN_WH_CELL_CODE'		, width: 140,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('IN_WH_CODE')
					})
				}
			},
			{ dataIndex: 'PACK_TYPE'			, width: 80 , align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100},
			{ dataIndex: 'TRANS_RATE'			, width: 80 , align:'right'},
			{ dataIndex: 'ORDER_Q'				, width: 90 },
			{ dataIndex: 'ORDER_UNIT'			, width: 45 },
			{ dataIndex: 'DVRY_CUST_NM'  		, width: 100 , hidden: true },
			{ text:'프로세스' , dataIndex:'service'	, width: 130,
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='포장작업지시' >"
				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						//Click Action
						var params = val.actionPosition.record;
						masterGrid.gotoPmp120(params);
					}
				}
			},
			{ dataIndex: 'ORDER_TYPE'			, width: 120, hidden:false },
			{ dataIndex: 'ORDER_DATE'			, width: 110 },
			{ dataIndex: 'ORDER_NUM'			, width: 130 },
			{ dataIndex: 'SER_NO'				, width: 65 }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['READY_STATUS', 'PROD_END_DATE', 'LOT_NO','ORDER_Q'
												//20200515주석
//												,'IN_WH_CODE'
												//20200508 추가: 비고(출하)
												, 'OUT_REMARK'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['READY_STATUS', 'PROD_END_DATE', 'LOT_NO','ORDER_Q'
												//20200508 추가: 비고(출하)
												, 'OUT_REMARK'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				console.log('record:', record);
			},
			select: function( grid, record, index, eOpts ) {
				console.log('record:', record);
			},
			//20200508 추가: LOT_NO가 있으면  삭제가능하도록 수정
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					if(Ext.isEmpty(e.record)) {
						return false;
					}
					if(Ext.isEmpty(e.record.get('LOT_NO_ORI'))) {
						UniAppManager.setToolbarButtons(['delete'], false);
					} else {
						UniAppManager.setToolbarButtons(['delete'], true);
					}
				});
			}
		},
		gotoPmp120:function(record)	{
			if(record)  {
				var params = {
					action		: 'new',
					'PGM_ID'	: 's_sof120ukrv_in',
					'record'	: record,
					'formPram'	: panelResult.getValues(),
					'ITEM_CODE'	: record.data.ITEM_CODE,
					'ITEM_NAME'	: record.data.ITEM_NAME,
					'ORDER_Q'	: record.data.ORDER_Q ,
					'LOT_NO'	: record.data.LOT_NO,
					'TRANS_RATE': record.data.TRANS_RATE,
					'REMARK'	: record.data.REMARK,
					'DVRY_DATE' : UniDate.getDateStr(record.data.DVRY_DATE)
				}
				var rec = {data : {prgID : 'pmp120ukrv', 'text':''}};
				parent.openTab(rec, '/prodt/pmp120ukrv.do', params);
			}
		}
	});

	Unilite.Main({
		id  : 's_sof120ukrv_inApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('DVRY_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('ORDER_TYPE'	, '11');
			UniAppManager.setToolbarButtons(['save'], false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			};
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelSearch.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if (masterStore.isDirty()) {
				masterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				//20200508 수정: 주석
//				if(selRow.phantom === true) {
					masterGrid.deleteSelectedRow();
//				}
			}
		},
		onNewDataButtonDown: function()	{
			var divCode = panelResult.getValue('DIV_CODE');
			var r = {
					DIV_CODE : divCode
				};
			masterGrid.createRow(r);
		}
	});
};
</script>