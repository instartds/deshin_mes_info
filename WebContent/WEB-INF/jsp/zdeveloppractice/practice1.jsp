<%--
'   프로그램명 : 작업지시서 출력 (practice1)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2021.04
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.2.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="practice1" >
	<t:ExtComboStore comboType="BOR120" pgmId="practice1"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>				<!-- 예/아니오 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList"/>	<!-- 작업장 -->		<%-- 테이블에서 combo값 가져올 때는 store 사용: controller에서 데이터 만들어서 페이지 상단에서 받아서 사용 --%>

</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell {
		background-color: #FFFFC6;
	}
	.x-change-cell2 {
		background-color: #FDE3FF;
	}
	.x-change-cell3 {
		background-color: #ff8201;
	}
	.x-change-blue {
		background-color: #A7EEFF;
	}
	.x-change-yellow {
		background-color: #FAF082;
	}
	.x-change-gray {
		background-color: #d2d2d2;
	}
</style>

<script type="text/javascript" >


function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,																			//필수 입력
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_START_DATE',
				endFieldName	: 'PRODT_END_DATE',
				startDate		: UniDate.get('startOfMonth'),													//날짜(FROM) 초기값 설정: 보통은 fnInitBinding에서 처리
				endDate			: UniDate.get('today'),															//날짜(TO) 초기값 설정: 보통은 fnInitBinding에서 처리
				allowBlank		: false,																		//필수 입력
				onStartDateChange: function(field, newValue, oldValue, eOpts) {									//조회 프로그램의 경우 panelSearch, panelResult 2개로 구성되므로 동기화 로직 필요: from 날짜 동기화
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {									//조회 프로그램의 경우 panelSearch, panelResult 2개로 구성되므로 동기화 로직 필요: to 날짜 동기화
					if(panelResult) {
						panelResult.setValue('PRODT_END_DATE',newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '출력여부',
				items		: [{
					boxLabel	: '미출력',
					name		: 'CONT_GUBUN',
					inputValue	: 'N', 
					width		: 60,
					checked		: true
				},{
					boxLabel	: '출력',
					width		: 60,
					name		: 'CONT_GUBUN',
					inputValue	: 'Y'
				},{
					boxLabel	: '전체',
					width		: 70,
					name		: 'CONT_GUBUN',
					inputValue	: ''
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CONT_GUBUN').setValue(newValue.CONT_GUBUN);							//라디오의 경우 필드 값 가져오거나 넣는 방식이 다른 필드와 다름: (가져올 때, panelSearch.getValues().CONT_GUBUN으로 가져옴
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('wsList'),												//테이블에서 combo값 가져올 때는 store 사용: controller에서 데이터 만들어서 페이지 상단에서 받아서 사용
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '고객명',
				name		: 'CUSTOM_PRSN',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_PRSN', newValue);
					}
				}
			},{																										//필드 모양 이쁘게 할 때, 사용(공백필드 삽입)
				xtype: 'component',
				width: 100
			},
////////////////////////////////////////////////각종 필드 sample
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '팝업(거래처)',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,																			//조회조건에서 주로 사용: 부분값만 입력 후 조회할 때 validateBlank: false 사용
				listeners		: {
					onValueFieldChange: function(field, newValue){													//조회조건에서 주로 사용: 부분값만 입력 후 조회할 때 panel 동기화 시, onSelected, onClear 대신 onValueFieldChange, onTextFieldChange사용
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup){																	//팝업 오픈 시, 필요한 값 넘길 때 사용
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}
			}),{
				fieldLabel	: '숫자필드(수량)',
				xtype		: 'uniNumberfield',
				type		: 'uniQty',
				name		: 'TOT_QTY',
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TOT_QTY', newValue);
					}
				}
			},{
				fieldLabel	: '체크박스 필드',																			//체크박스 앞 쪽에 글자가 필요할 때 사용
				boxLabel	: '<font color="red">뒷쪽 글씨도 가능</font>',													//체크박스 뒷 쪽에 글자가 필요할 때 사용
				name		: 'EXCEPTION_END',
				xtype		: 'checkboxfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('EXCEPTION_END').setValue(newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
			fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_START_DATE',
			endFieldName	: 'PRODT_END_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_END_DATE',newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '출력여부',
			items		: [{
				boxLabel	: '미출력',
				name		: 'CONT_GUBUN',
				inputValue	: 'N', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '출력',
				width		: 60,
				name		: 'CONT_GUBUN',
				inputValue	: 'Y'
			},{
				boxLabel	: '전체',
				width		: 70,
				name		: 'CONT_GUBUN',
				inputValue	: ''
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('CONT_GUBUN').setValue(newValue.CONT_GUBUN);
				}
			}
		},{
			xtype: 'component',
			width: 100
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '고객명',
			name		: 'CUSTOM_PRSN',
			xtype		: 'uniTextfield',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_PRSN', newValue);
				}
			}
		},{
			xtype: 'component',
			width: 100
		},
////////////////////////////////////////////////각종 필드 sample,
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '팝업(거래처)',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '숫자필드(수량)',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			name		: 'TOT_QTY',
			value		: 0,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TOT_QTY', newValue);
				}
			}
		},{
			fieldLabel	: '체크박스 필드',
			boxLabel	: '<font color="red">뒷쪽 글씨도 가능</font>',
			name		: 'EXCEPTION_END',
			xtype		: 'checkboxfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('EXCEPTION_END').setValue(newValue);
				}
			}
		},{
			xtype	: 'button',
			text	: 'panel버튼 (작업지시서)',
			handler	: function() {
				//버튼 눌렀을 때 이벤트: 상세 설명은 onPrintButtonDown: function() 참조
				var param			= panelResult.getValues();
				param.PGM_ID		= 'practice1';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/base/practiceClip1.do',
					prgID		: 'practice1',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}]
	});



	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('practice1Model', {
		fields: [
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'	, store: Ext.data.StoreManager.lookup('wsList')},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'	, type: 'string'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'	, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'	, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'B013' , displayField: 'value'},	//콤보에서 value를 보여주고 싶을 때 사용, 기본은 name이 보임
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.specialremark" default="특기사항"/>'	, type: 'string'},
//			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'			, type: 'uniQty'},
//			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
//			{name: 'SER_NO'				, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'			, type: 'int'},
			{name: 'TEMPC_01'			, text: '<t:message code="system.label.purchase.printyn" default="출력여부"/>'		, type: 'string'	, comboType:'AU', comboCode: 'B131'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('practice1MasterStore1', {
		model	: 'practice1Model',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'zDevelopPracticeService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {																		//조회로직 이후에 처리할 로직이 있을 때 사용
					if(success) {
					}
				}
			});	
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//데이터 조회 후 처리할 로직이 있을 때 사용 (예, 조회후 데이터가 있으면 '출력'버튼 활성화
//				if(records.length > 0) {
//					UniAppManager.setToolbarButtons('print', true);
//				}
			},
			add: function(store, records, index, eOpts) {
				//등록 프로그램에서 행 추가 후 처리할 로직이 있을 때 사용
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//등록 프로그램에서 수정 후 처리할 로직이 있을 때 사용
			},
			remove: function(store, record, index, isMove, eOpts) {
				//등록 프로그램에서 삭제 후 처리할 로직이 있을 때 사용
			}
		}
	});


	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('practice1Grid1', {
		store	: directMasterStore,																	//해당 그리드와 연결된 store 정의
		layout	: 'fit',
		region	: 'center',																				//위치 정의: 'center'는 한 페이지에 하나만 정의할 수 있음
		uniOpt	: {																						//문서 참조: 그리드 옵션 설정
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,			//그리드에서 마우스 오른쪽 클릭 사용
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},		//소계 기능
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: false}		//총계 기능(디폴트: 그리드 하단에 표시)
		],
		selModel: 'rowmodel',
		tbar	: [{																					//그리드에 버튼기능 필요할 때 사용: 출력, 다른 프로그램으로 링크 시 사용
			id		: 'reqBtn',
			text	: '그리드 버튼 (출하지시서)',
			width	: 170,
			handler	: function() {
				//버튼 눌렀을 때 이벤트: 상세 설명은 onPrintButtonDown: function() 참조
				var param			= panelResult.getValues();
				param.PGM_ID		= 'practice1';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/base/practiceClip1.do',
					prgID		: 'practice1',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}],
		columns	: [
			{dataIndex: 'WORK_SHOP_CODE'	, width: 110},
			{dataIndex: 'WKORD_NUM'			, width: 150},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80},
			{dataIndex: 'PROG_WORK_NAME'	, width: 80, align: 'center'},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 100},
			{text: '2중 그리드(품목정보)',
				columns:[
					{dataIndex: 'ITEM_CODE'	, width: 100},
					{dataIndex: 'ITEM_NAME'	, width: 100},
					{dataIndex: 'SPEC'		, width: 100},
					{dataIndex: 'ORDER_UNIT', width: 100}
				]
			},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'REMARK'			, width: 100},
//			{dataIndex: 'ORDER_Q'			, width: 100},
//			{dataIndex: 'ORDER_NUM'			, width: 100},
//			{dataIndex: 'SER_NO'			, width: 100},
			{dataIndex: 'TEMPC_01'			, width: 100}
		],
		listeners:{
			itemmouseenter:function(view, record, item, index, e, eOpts ) {								//마우스 포인터 변경(손가락)
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {									//그리드 더블클릭 이벤트: 링크 등에 사용
			},
			beforeedit: function( editor, e, eOpts ) {													//등록 프로그램에서 수정가능여부 설정할 때 사용
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {				//cell 클릭 했을 때 필요한 로직이 있으면 사용
			}
		},
		//마우스 오른쪽 클릭 시, 보일메뉴 설정
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			menu.down('#gsLinkPgID1').show();
			return true;
		},
		//마우스 오른쪽 클릭 시, 보여줄 메뉴 등록
		uniRowContextMenu:{
			items: [{
				text	: '마우스 오른쪽 버튼',
				itemId	: 'gsLinkPgID1',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoMap100(param.record);
				}
			}]
		},
		//linkPgmId로 이동하는 로직
		gotoMap100:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID1.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID1.split('/')[2].length - 3);
				var params		= {
					action		: 'select',
					'PGM_ID'	: 'ssa615skrv',
					'DIV_CODE'	: record.get('DIV_CODE'),
					'BASIS_NUM'	: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '지급결의 등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID1, params);
			}
		},
		viewConfig: {																					//특정 행에 대해, 글자, 글자색, 바탕색 등 highlights 필요할 때 사용
			getRowClass: function(record, rowIndex, rowParams, store){
				//예, 거래처코드가 100044이면 바탕색 연한노랑색으로 설정
				var cls = '';
				if(record.get('CUSTOM_CODE') == '100044'){
					cls = 'x-change-cell';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'practice1App',
		borderItems	: [{															//전체 화면 배치 정의
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {													//화면 열렸을 때 초기설정
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('PRODT_START_DATE'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_END_DATE'	, UniDate.get('today'));
			panelSearch.getField('CONT_GUBUN').setValue('N');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_END_DATE'	, UniDate.get('today'));
			panelResult.getField('CONT_GUBUN').setValue('N');

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');

			UniAppManager.setToolbarButtons('reset', true);		//초기화 버튼 활성화
			UniAppManager.setToolbarButtons('print', true);		//프린트 버튼 활성화
		},
		onQueryButtonDown: function() {							//조회버튼
			if(!this.isValidSearchForm()){						//필수조건 체크
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {							//신규버튼
			panelSearch.clearForm();							//panel 필드 초기화: 공백 값으로 변경
			panelResult.clearForm();							//panel 필드 초기화: 공백 값으로 변경
			masterGrid.getStore().loadData({});					//그리드 초기화: 빈 데이터 load
			this.fnInitBinding();								//초기화 값 세팅
		},
		onPrintButtonDown: function() {							//프린트(출력)
			var param			= panelResult.getValues();		//출력에 필요한 parameter 정의
			param.PGM_ID		= 'practice1';					//parameter에 추가로 필요한 데이터 정의: PGM_ID는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
			param.MAIN_CODE		= 'Z012';						//parameter에 추가로 필요한 데이터 정의: MAIN_CODE는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/base/practiceClip1.do',	//출력 시 호출할 url 정의
				prgID		: 'practice1',
				extParam	: param,
				submitType	: 'POST'							//대용량 데이터 통신의 경우, post 방식으로 호출: 기본값으로 사용하면 됨
			});
			win.center();
			win.show();
		}
	});
};
</script>