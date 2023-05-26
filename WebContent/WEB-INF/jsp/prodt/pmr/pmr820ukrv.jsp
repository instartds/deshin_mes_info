<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr820ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pmr820ukrv"/>	<%-- 사업장 --%>  
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	var excelWindow;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmr820ukrvService.selectList',
			update	: 'pmr820ukrvService.updateDetail',
			syncAll	: 'pmr820ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('Pmr820ukrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
			{name: 'PRODT_DATE'			, text: '<t:message code="system.label.product.productiondate" default="생산일"/>'				, type: 'uniDate'},
			{name: 'PRODT_NUM'			, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spece" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					, type: 'string'},
			{name: 'STANDARD_MAN_HOUR'	, text: '<t:message code="system.label.product.standardtacttime" default="표준공수"/>'			, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				, type: 'uniQty'},
			{name: 'MAN_HOUR'			, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'					, type: 'uniQty'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type: 'string'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'				, type: 'uniQty'},
			{name: 'PRODT_WKORD_DATE'	, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			, type: 'string'}
		]
	});
	
	Unilite.Excel.defineModel('excel.pmr820.sheet01', {
		fields: [
			{name: 'PRODT_NUM'			, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'		, type: 'string'},
			{name: 'STANDARD_MAN_HOUR'	, text: '<t:message code="system.label.product.standardtacttime" default="표준공수"/>'			, type: 'uniQty'},
			{name: 'MAN_HOUR'			, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'					, type: 'uniQty'}
		]
	});
	
	function openExcelWindow() {
		var me = this;
		var appName = 'Unilite.com.excel.ExcelUploadWin';

	if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName); // 자동으로 사용할 수 있는 기본 전역 창 그룹
			excelWindow = Ext.create( appName, {
					modal: false,
					excelConfigName: 'pmr820',
					grids: [{
						itemId: 'grid01',
						title: '투입공수',
						useCheckbox: false,
						model : 'excel.pmr820.sheet01',
						readApi: 'pmr820ukrvService.selectExcelUploadSheet1',
						columns: [
							{dataIndex: 'PRODT_NUM'				, width: 110}, // 생산실적번호
							{dataIndex: 'STANDARD_MAN_HOUR'		, width: 100}, // 표준공수
							{dataIndex: 'MAN_HOUR' 				, width: 100}  // 투입공수
						]
					}],
					listeners: {
						close: function() {
							this.hide();
						}
					},
					onApply:function()	{
						var me = this;
						var grid = this.down('#grid01');
						
						if(grid.getStore().getCount() < 1) {
							Unilite.messageBox('업로드된 데이터가 없습니다.');
							return;
						}
						var records = grid.getStore().data.items;
						
						Ext.each(records, function(record, index) {
							var fRecord = directMasterStore1.getAt( // 스토어 인덱스에서 레코드를 가져옴
								directMasterStore1.findBy(function(rec) { // 스토어에 해당하는 값이 있으면 레코드의 인덱스를 찾음
									return (rec.get('PRODT_NUM') == record.get('PRODT_NUM'));
								}
							));
							
							// 생산실적번호가 있는 항목을 엡데이트
							if(!Ext.isEmpty(fRecord)){
								fRecord.set('MAN_HOUR'			, record.get('MAN_HOUR'));			// 투입공수
								fRecord.set('STANDARD_MAN_HOUR'	, record.get('STANDARD_MAN_HOUR'));	// 표준공수
							}
							me.hide();
						})
					}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	}

	var directMasterStore1 = Unilite.createStore('pmr820ukrvMasterStore1',{
		model	: 'Pmr820ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues(); // 컴포넌트 호출 후 값 가져옴
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {				
				config = {
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				directMasterStore1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',  
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '생산일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
				allowBlank		: false,
				width			: 315,
				startDate: UniDate.get('twoMonthsAgo'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				name		: 'WKORD_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				autoPopup		: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '생산일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
			allowBlank		: false,
			width			: 315,
			startDate: UniDate.get('twoMonthsAgo'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WKORD_NUM', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
		})]
	});
	
	var masterGrid1 = Unilite.createGrid('pmr820ukrvGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false, // 마지막 열 자동 확장
			useLiveSearch		: true,  // 내용검색 버튼 사용 여부
			useContextMenu		: false,  // Context 메뉴 자동 생성 여부 
			useMultipleSorting	: true,  // 정렬 버튼 사용 여부
			useGroupSummary		: false, // 그룹핑 버튼 사용 여부
			useRowNumberer		: true,  // 번호 컬럼 사용 여부
			filter				: {
				useFilter	: true,		 // 컬럼 filter 사용 여부
				autoCreate	: true		 // 컬럼 필터 자동 생성 여부
			}
		},
		tbar: [{
			xtype: 'button',
			text: '엑셀 업로드',
			handler: function() {
				openExcelWindow();
			}
		}],
		selModel:'rowmodel',
			
		columns	: [
			{dataIndex: 'DIV_CODE'				, width:330 , hidden  : true },	// 사업장
			{dataIndex: 'PRODT_DATE'			, width:330 , hidden  : true },	// 생산일
			{dataIndex: 'PRODT_NUM'				, width:109 , editable: false},	// 생산실적번호
			{dataIndex: 'WORK_SHOP_CODE'		, width:80  , editable: false}, // 작업장
			{dataIndex: 'ITEM_CODE'				, width:100 , editable: false}, // 품목코드
			{dataIndex: 'ITEM_NAME'				, width:300 , editable: false}, // 품목명
			{dataIndex: 'SPEC'					, width:80  , editable: false}, // 규격
			{dataIndex: 'STOCK_UNIT'			, width:60  , editable: false},	// 단위
			{dataIndex: 'LOT_NO'				, width:100 , editable: false}, // LOT번호
			{dataIndex: 'STANDARD_MAN_HOUR'		, width:90	, editable: false}, // 표준공수
			{dataIndex: 'PRODT_Q'				, width:90  , editable: false}, // 생산량
			{dataIndex: 'MAN_HOUR'				, width:90   				 }, // 투입공수
			{dataIndex: 'WKORD_NUM'				, width:110 , editable: false}, // 작업지시번호
			{dataIndex: 'WKORD_Q'				, width:90  , editable: false}, // 작업지시량
			{dataIndex: 'PRODT_WKORD_DATE'		, width:80  , editable: false} 	// 작업지시일
		]
	});

	Unilite.Main({
		id			: 'pmr820ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid1
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('PRODT_DATE_FR'	, UniDate.get('twoMonthsAgo'));
			panelSearch.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('PRODT_DATE_FR'	, UniDate.get('twoMonthsAgo'));
			panelResult.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			UniAppManager.setToolbarButtons(['save', 'reset'], false);
		},
		onQueryButtonDown : function() {
			masterGrid1.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onResetButtonDown: function() {
			panelSearch.reset();
			masterGrid1.reset();
			panelResult.reset();
			this.fnInitBinding();
		}
	});
};
</script>