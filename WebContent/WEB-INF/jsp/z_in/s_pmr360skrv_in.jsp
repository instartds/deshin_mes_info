<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_pmr360skrv_in"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
/**
------------------------ 화면 내용 및 주요 항목정의 ------------------------
하기 내용은 20200616 이현 부장의 사전 협의 후 승인을 받고 완료한 내용
이노베이션은 반제품의 생산계획을 수립하고 작업지시를 등록하면 상위 완제품의 작업지시가 일괄 생성됨
작업지시 번호는 각각 생성되며 TOP_WRKORD_NUM으로 묶어서 관리
완제품과 반제품의 작업지시번호는 각각 생성되며,
본 화면에서는 생산수량은 반제품의 실적수량, 불량수량은 완제품과 반제품의 불량 유형별 합계를 표시 
예) 품목코드는 500101(완제품)이 그리드에 표현되며 000101(반제품)의 불량수량을 합산하여 조회함

총제조량 : 분주시 사용되는 혈액 또는 기타액 (공정코드 : P10에 투입된 수량)
총제조수량 : 1차포장까지 완료된 생산수량 (반제품의 생산수량 : 공정코드 P40)
분주QC = (1000 : 분주(QC) 폐기)
분주불량 = (1100 ~ 5200)
1중불량 = (P010 ~ P060)
포장불량 = P100 + (P110 ~ P190) + (Q110 ~ 190)
불량합계 = 분주QC+분주불량+1중불량+제품QC당월+포장불량
양품 = 총제조수량 – 불량합계
제품QC (당월) = 출고유형 M104의 94(QC테스트 출고)로 등록된 조회 기간내의 생산LOT분의 출고수량
제품QC (전월) = 출고유형 M104의 94(QC테스트 출고)로 등록된 조회 기간 이전의 생산LOT분의 출고수량

현 화면에서 그리드 순서는 상기 표기 이후는 동일
더블클릭시 나타나는 팝업에도 순서 적용
팝업은 해당 품목의 기간별 LOT 생산현황을 조회
팝업에서 시작시간과 종료시간은 TOP_WRKORD_NUM 의 P40(1차포장) 에서 입력된 투입 시간을 표시

※ 각 항목의 설명은 상기와 같으나 쿼리 방법은 다를 수 있음
※ 불량수량은 P003에 정의한 분주불량 코드 참조할 것
 */

function appMain() {
	var searchPop1Window;	//팝업 윈도우1
	//동적 그리드 구현(공통코드(P003)에서 컬럼 가져오기)
	colData		= ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var columns2= createGridColumn2(colData);
	var gsBadQtyInfo;
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_pmr360skrv_inModel', {
		fields : fields
	});

	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type: 'string'},
			{name: 'PLAN_ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'ITEM_WIDTH'			,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type: 'string'},
			{name: 'PACK_QTY'			,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string'},
			//20200512 추가: 생산일, 시작시간, 종료시간
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	,type:'uniDate'},
			{name: 'PRODT_START_TIME'	,text: '<t:message code="system.label.product.workhourfrom" default="시작시간"/>'	,type:'string' 	, maxLength: 4},
			{name: 'PRODT_END_TIME'		,text: '<t:message code="system.label.product.workhourto" default="종료시간"/>'		,type:'string' 	, maxLength: 4},
			{name: 'WKORD_Q'			,text: '총제조량(L)'		,type: 'uniQty'},
			{name: 'GOOD_WORK_Q'		,text: '총제조수량(EA)'		,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			{name: 'GOOD_Q'				,text: '양품'				,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			{name: 'BAD_PRODT_Q'		,text: '분주불량'			,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			{name: 'BAD_PACK_Q'			,text: '포장불량'			,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			{name: 'BAD_TOT_Q'			,text: '불량합계'			,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			{name: 'QC_Q'				,text: '분주QC'			,type: 'int'},			//20200525 수정: type변경(uniPrice -> int)
			//20200512 수정: 제품QC -> 제품QC(당월), 제품QC(전월)로 분리
			{name: 'INSPECT_OUT_Q'		,text: '제품QC(당월)'		,type: 'int'},			//20200525 수정: type변경(uniPrice -> int), 20200529 수정: 엑셀다운로드 오류로 HTM TAG 삭제
			{name: 'BEFORE_LOT_OUTQ'	,text: '제품QC(전월)'		,type: 'int'},			//20200525 수정: type변경(uniPrice -> int), 20200529 수정: 엑셀다운로드 오류로 HTM TAG 삭제
			{name: 'BASIS_P'			,text: '제조원가'			,type: 'uniUnitPrice'},	//20200512 수정: type변경(uniPrice -> uniUnitPrice)
			{name: 'PRODT_AMT'			,text: '생산금액'			,type: 'uniPrice'},
			{name: 'PRODT_QC_AMT'		,text: 'QC사용금액'			,type: 'uniPrice'},
			{name: 'LOT_NO'				,text: 'LOT번호'			,type: 'string'},
			//20200615 추가
			{name: 'BAD_1'				,text: '1중 불량'			,type: 'int'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty' });					//20200512 수정: type변경(uniPrice -> uniQty)
		});
		console.log(fields);
		return fields;
	}


	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'COMP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PLAN_ITEM_CODE'	, width: 70		, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 150	, locked: true},
			{dataIndex: 'ITEM_WIDTH'		, width: 50		, locked: true, align:'center'},
			{dataIndex: 'PACK_QTY'			, width: 50		, locked: true, align:'center'},
			{dataIndex: 'WKORD_Q'			, width: 100	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'GOOD_WORK_Q'		, width: 110	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'QC_Q'				, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_PRODT_Q'		, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			//20200615 추가
			{dataIndex: 'BAD_1'				, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			//20200512 수정: 제품QC -> 제품QC(당월), 제품QC(전월)로 분리
			{dataIndex: 'INSPECT_OUT_Q'		, width: 110	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_PACK_Q'		, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_TOT_Q'			, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'GOOD_Q'			, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BEFORE_LOT_OUTQ'	, width: 110	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BASIS_P'			, width: 90		, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'PRODT_AMT'			, width: 110	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'PRODT_QC_AMT'		, width: 100	, locked: true, summaryType: 'sum',tdCls:'x-change-cell2'}
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + item.SUB_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:100, summaryType: 'sum',tdCls:'x-change-cell2'},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price });
		});
		columns.push(
			{text: '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
				columns: array1
			}
		);
 		console.log(columns);
		return columns;
	}

	// 그리드 컬럼 생성
	function createGridColumn2(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'COMP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PLAN_ITEM_CODE'	, width: 70		, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 150	, locked: true},
			{dataIndex: 'ITEM_WIDTH'		, width: 50		, hidden: true, align:'center'},
			{dataIndex: 'LOT_NO'			, width: 100	, locked: true},
			//20200512 추가: 생산일, 시작시간, 종료시간
			{dataIndex: 'PRODT_DATE'		, width: 80		, locked: true, align:'center'},
			{dataIndex: 'PRODT_START_TIME'	, width: 80		, locked: true, align:'center'},
			{dataIndex: 'PRODT_END_TIME'	, width: 80		, locked: true, align:'center'},
			{dataIndex: 'PACK_QTY'			, width: 50		, hidden: true, align:'center'},
			{dataIndex: 'WKORD_Q'			, width: 100	, locked: true},
			{dataIndex: 'GOOD_WORK_Q'		, width: 110	, locked: true},
			{dataIndex: 'QC_Q'				, width: 90		, locked: true},
			{dataIndex: 'BAD_PRODT_Q'		, width: 90		, locked: true},
			//20200615 추가
			{dataIndex: 'BAD_1'				, width: 90		, locked: true},
			{dataIndex: 'INSPECT_OUT_Q'		, width: 90		, locked: true},
			{dataIndex: 'BAD_PACK_Q'		, width: 90		, locked: true},
			{dataIndex: 'BAD_TOT_Q'			, width: 90		, locked: true},
			{dataIndex: 'GOOD_Q'			, width: 90		, locked: true}
			
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + item.SUB_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:100},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price });
		});
		columns.push(
			{text: '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
				columns: array1
			}
		);
 		console.log(columns);
		return columns;
	}

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('S_pmr360skrv_inMasterStore',{
		model	: 's_pmr360skrv_inModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read: 's_pmr360skrv_inService.selectList'
			}
		},
		loadStoreRecords : function(badQtyArray)	{
			var param = panelResult.getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE', 
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					
				}
			}
		},{ 
			fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			xtype			: 'uniDateRangefield',  
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			width			: 315,
			textFieldWidth	: 170,
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				
			} 
		},
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>', 
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					
				},
				onTextFieldChange: function(field, newValue){
					
				}
			}
		})
		],
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

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_pmr360skrv_inGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			expandLastColumn	: false,
			useLiveSearch		: true,
			//useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
        features: [
            {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
            {id : 'masterGridTotal' ,   ftype: 'uniSummary',         showSummaryRow: true}
        ],
		selModel: 'rowmodel',
		sortableColumns : false,
		columns	: columns,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				openSearchPop1Window(record.get('PLAN_ITEM_CODE'));
			}
		}
	});



	var pop1Store = Unilite.createStore('pop1Store', {
		model: 's_pmr360skrv_inModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr360skrv_inService.selectPop1List'
			}
		},
		loadStoreRecords : function(badQtyArray)	{
			var param = panelResult.getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			var selectedRecord = masterGrid.getSelectedRecord();
			param.ITEM_CODE = selectedRecord.get('PLAN_ITEM_CODE');
			
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var pop1Grid = Unilite.createGrid('pop1Grid', {
		store: pop1Store,
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst: false,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		columns	: columns2
	});

	function openSearchPop1Window() {
		if (!searchPop1Window) {
			searchPop1Window = Ext.create('widget.uniDetailWindow', {
				id: 'pop1Page',
				autoScroll	: true,
				title: '',
				width: '100%',
				height: 600,
				layout: {
					type: 'vbox',
					align: 'stretch'
				},
				items: [pop1Grid],
				tbar: ['->'
		/*		,{
					itemId: 'searchBtn',
					text: '<t:message code="system.label.product.inquiry" default="조회"/>',
					minWidth: 100,
					handler: function() {
						if(!pop1Search.getInvalidMessage()) return;	//필수체크
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();
					},
					disabled: false
				}*/
				,{
					itemId: 'closeBtn',
					text: '<t:message code="system.label.product.close" default="닫기"/>',
					minWidth: 100,
					handler: function() {
						searchPop1Window.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						pop1Grid.reset();
						pop1Store.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					beforeshow: function(panel, eOpts) {
						var badQtyArray = new Array();
						badQtyArray = gsBadQtyInfo.split(',');
						
						pop1Store.loadStoreRecords(badQtyArray);
//						var selectedRecord = detailGrid.getSelectedRecord();

//						pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
//						pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
//						pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
//						pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
//						pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
//						pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));
//
//						pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
					},
					show: function(panel, eOpts) {
//						setTimeout( function() {
//							pop1Search.getField('SCAN_CODE').focus();
//						}, 50 );
					}
				}
			})
		}
		searchPop1Window.center();
		searchPop1Window.show();
	}



	Unilite.Main({
		id			: 's_pmr360skrv_inApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons('reset'	, false);
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {
				var badQtyArray = new Array();
				badQtyArray = gsBadQtyInfo.split(',');
				masterGrid.getStore().loadStoreRecords(badQtyArray);
			}
		},
		onDetailButtonDown:function() {
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
		}
	});
};
</script>