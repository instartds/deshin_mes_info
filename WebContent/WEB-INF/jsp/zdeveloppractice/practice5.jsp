<%--
'   프로그램명 : 작업지시서 출력 (practice5)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2021.04
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.2.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="practice5" >									<%-- 공통코드 --%>
	<t:ExtComboStore comboType="BOR120" pgmId="practice5"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>				<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B070"/>				<!-- 그룹설정 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>				<!-- 예/아니오 -->
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
var SearchInfoWindow;			//SearchInfoWindow : 검색창 선언 - 조회버튼 눌렀을 때 생성할 window 선언


function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		disabled: false,
		api		: {												//form data 조회/저장 시 사용할 api 선언
			load	: 'zDevelopPracticeService.selectMaster5',	//조회: load
			submit	: 'zDevelopPracticeService.saveMaster5'		//저장: submit
		},items	: [{
			fieldLabel	: '사업장',								//fieldLabel: 패널
			name		: 'TYPE_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '창고코드',
			name		: 'TREE_CODE',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '창고명',
			name		: 'TREE_NAME',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			//form 데이터 변경 시, 저장버튼 활성화여부 체크하기 위한 로직 추가
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.getField('TYPE_LEVEL').isDirty()	|| basicForm.getField('TREE_CODE').isDirty() || basicForm.getField('TREE_NAME').isDirty()) {
					UniAppManager.setToolbarButtons(['save', 'reset'], true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			dirtychange:function( basicForm, dirty, eOpts ) {
				UniAppManager.setToolbarButtons(['save', 'reset'], true);
			}
		}
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'zDevelopPracticeService.selectList5',
			create	: 'zDevelopPracticeService.insertDetail5',
			update	: 'zDevelopPracticeService.updateDetail5',
			destroy	: 'zDevelopPracticeService.deleteDetail5',
			syncAll	: 'zDevelopPracticeService.saveAll5'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('practice5Model', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'			, type: 'string', allowBlank: false},														//name:모델
			{name: 'TYPE_LEVEL'		, text: '사업장'				, type: 'string', allowBlank: false},
			{name: 'TREE_CODE'		, text: '<t:message code="system.label.base.warehousecode" default="창고코드"/>'	, type: 'string', allowBlank: false},
			{name: 'WH_CELL_CODE'	, text: '창고CELL코드'			, type: 'string', allowBlank: false},
			{name: 'WH_CELL_NAME'	, text: '창고CELL명'			, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'	, text: '거래처코드'				, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'					, type: 'string'},	
			{name: 'USE_YN'			, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'			, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B010'},
			{name: 'PABSTOCK_YN'	, text: '가용재고적용여부'			, type: 'string', comboType: 'AU', comboCode: 'B010'},
			{name: 'VALID_YN'		, text: '유효 Cell 여부'			, type: 'string', comboType: 'AU', comboCode: 'B010'},
			{name: 'WH_CELL_BARCODE', text: '창고 Cell Barcode'	, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('practice5MasterStore1', {
		model	: 'practice5Model',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: true, 	//전체삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();		//또는 panelResult.getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {		//조회로직 이후에 처리할 로직이 있을 때 사용
					if(success) {
					}
				}
			});	
		},
		saveStore: function() {
//			var toCreate	= this.getNewRecords();						//신규 데이터
//			var toUpdate	= this.getUpdatedRecords();				//수정된 데이터
//			var toDelete	= this.getRemovedRecords();				//삭제된 데이터
			var inValidRecs	= this.getInvalidRecords();				//validation 체크: 오류나는 것이 없을 때
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {						//데이터 저장할때, 오류나는 것이 없다면,		
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(directMasterStore.getCount() == 0) {						//조회된 데이터가 없으면,
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('practice5Grid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//데이터 조회 후 처리할 로직이 있을 때 사용 - 조회후 데이터가 있으면 사업장, 창고코드 필드 비활성화
//				if(records && records.length > 0) {
//					panelResult.getField('TYPE_LEVEL').setReadOnly(true);
//					panelResult.getField('TREE_CODE').setReadOnly(true);
//				} else {
//					panelResult.getField('TYPE_LEVEL').setReadOnly(false);
//					panelResult.getField('TREE_CODE').setReadOnly(false);
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
	var masterGrid = Unilite.createGrid('practice5Grid1', {
		store	: directMasterStore,																	//해당 그리드와 연결된 store 정의
		layout	: 'fit',
		region	: 'center',			
		//위치 정의: 'center'는 한 페이지에 하나만 정의할 수 있음
		uniOpt	: {				
			useRowNumberer		: false,			//번호 칼럼
			useContextMenu		: false,																	//문서 참조: 그리드 옵션 설정
			useGroupSummary		: false,
			expandLastColumn	: true,				//칼럼 확장 선택
			onLoadSelectFirst	: false,			//첫줄 선택
			useLiveSearch		: true,				//내용검색 버튼
//			useMultipleSorting	: true,
			filter				: {
				useFilter		: false,
				autoCreate		: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},		//소계 기능
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}			//총계 기능(디폴트: 그리드 하단에 표시)
		],
//		selModel: 'rowmodel',		//한줄 행 선택
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: true, mode: 'SIMPLE',					//checkOnly	: 체크박스만 선택		toggleOnClick: 행 재선택
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {							//수정 가능 여부		선택하기 전단계
					if(record.get('COMP_CODE') == 'MASTER') {
						return true;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){			
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 110},
			{dataIndex: 'TYPE_LEVEL'				, width: 150},
			{dataIndex: 'TREE_CODE'				, width: 150},
			{dataIndex: 'WH_CELL_CODE'		, width: 110},
			{dataIndex: 'WH_CELL_NAME'		, width: 150},
			{dataIndex: 'CUSTOM_CODE'		, width:150,
			editor: Unilite.popup('CUST_G',{
				textFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_CODE',
				autoPopup: true,
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)  {
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})
			},
			{dataIndex: 'CUSTOM_NAME'		, width:150,
			editor: Unilite.popup('CUST_G',{
				textFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_CODE',
				autoPopup: true,
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)  {
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})
			},
			{dataIndex: 'USE_YN'			, width: 100, align: 'center'},
			{dataIndex: 'PABSTOCK_YN'		, width: 100},
			{dataIndex: 'VALID_YN'			, width: 100 },
			{dataIndex: 'WH_CELL_BARCODE'	, width: 100 }
					
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {									//그리드 더블클릭 이벤트: 링크 등에 사용
			},
			beforeedit: function( editor, e, eOpts ) {															//등록 프로그램에서 수정가능여부 설정할 때 사용
				//신규 행일 때는 모두 수정 가능
				if(e.record.phantom ) {				//이 행이 신규이면,
					if (UniUtils.indexOf (e.field, ['COMP_CODE', 'TYPE_LEVEL', 'TREE_CODE'])){
					return false;
					} else {
						return true;
					}
				} else {							//조회된 행이면,
					//조회된 행일 때는 
					if (UniUtils.indexOf(e.field, ['COMP_CODE', 'TYPE_LEVEL', 'TREE_CODE', 'WH_CELL_CODE'])) {
						return false;
					} else {
						return true;
					}
				}
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {				//cell 클릭 했을 때 필요한 로직이 있으면 사용
			}
		},
		viewConfig: {																								//특정 행에 대해, 글자, 글자색, 바탕색 등 highlights 필요할 때 사용
			getRowClass: function(record, rowIndex, rowParams, store){
//				//예, 거래처코드가 100044이면 바탕색 연한노랑색으로 설정
				var cls = '';
				if(record.get('CUSTOM_CODE') == '098027'){
					cls = 'x-change-cell';
				}
				return cls;
			}
		}
	});


	
	//창고정보 검색을 위한 window 구성요소 정의 - form, grid(model, store, grid)
	var whCodeSearch = Unilite.createSearchForm('whCodeSearchForm', {
		layout			: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'TYPE_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '창고코드',
			name		: 'TREE_CODE',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '창고명',
			name		: 'TREE_NAME',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	//검색 모델
	Unilite.defineModel('whCodeModel', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'	, type: 'string'},
			{name: 'TYPE_LEVEL'		, text: '<t:message code="system.label.sales.division" default="사업장"/>', type: 'string', comboType:'BOR120'},
			{name: 'TREE_CODE'		, text: '창고코드'	, type: 'string'},
			{name: 'TREE_NAME'		, text: '창고명'	, type: 'string'},
			{name: 'GROUP_CD'		, text: '그룹설정'	, type: 'string', comboType: 'AU', comboCode: 'B070'},
			{name: 'USE_YN'			, text: '사용여부'	, type: 'string', comboType: 'AU', comboCode: 'B010'}
		]
	});
	//검색 스토어
	var whCodeStore = Unilite.createStore('whCodeStore', {
		model	: 'whCodeModel',
		autoLoad: false,
		uniOpt	: {											//검색 window는 isMaster: false로 설정
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'zDevelopPracticeService.selectWhCodeList5'
			}
		},
		loadStoreRecords : function() {
			var param = whCodeSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드
	var whCodeGrid = Unilite.createGrid('whCodeGrid', {
		store	: whCodeStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'		, width: 80, hidden: true},
			{dataIndex: 'TYPE_LEVEL'			, width: 100},
			{dataIndex: 'TREE_CODE'			, width: 100},
			{dataIndex: 'TREE_NAME'		, width: 120},
			{dataIndex: 'GROUP_CD'			, width: 100},
			{dataIndex: 'USE_YN'				, flex:1, minWidth: 100}			//flex: 1 - 남은 여백 전체, minWidth: 최소 넓이 설정
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {	//조회 window에서 조회된 그리드 더블클릭 시 event
				whCodeGrid.returnData(record);									//returnData에 더블클릭된 record를 넘기면서 호출
				SearchInfoWindow.hide();											//작업 후, 검색 windows 숨김(hide)
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'TYPE_LEVEL	'	: record.get('TYPE_LEVEL'),
				'TREE_CODE'	: record.get('TREE_CODE'), 
				'TREE_NAME'	: record.get('TREE_NAME'), 
				'GROUP_CD'		: record.get('GROUP_CD'),  
				'USE_YN'			: record.get('USE_YN')     
			}); 	
			UniAppManager.app.onQueryButtonDown();
			//panel 값을 set하면 저장버튼 활성화 되므로 필요한 로직
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});
	//openSearchInfoWindow (검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '창고정보 검색',
				width	: 600,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [whCodeSearch, whCodeGrid],
				tbar	: ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						whCodeStore.loadStoreRecords();
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
					beforehide: function(me, eOpt) {			//검색 window 숨기기 전 처리 로직
						whCodeSearch.clearForm();
						whCodeGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {		//검색 window 숨기기 전 처리 로직2
						whCodeSearch.clearForm();
						whCodeGrid.reset();
					},
					show: function( panel, eOpts ) {			//검색 window 보여주기 전 값 set
						whCodeSearch.setValue('TYPE_LEVEL'			, panelResult.getValue('TYPE_LEVEL'));
						whCodeSearch.setValue('TREE_CODE'			, panelResult.getValue('TREE_CODE'));
						whCodeSearch.setValue('TREE_NAME'		, panelResult.getValue('TREE_NAME'));
						whCodeSearch.setValue('GROUP_CD'			, panelResult.getValue('GROUP_CD'));
						whCodeSearch.setValue('USE_YN'				, panelResult.getValue('USE_YN'));
					}                         		
				}
			})
		}
		SearchInfoWindow.center();								//검색 window 가운데
		SearchInfoWindow.show();								//검색 window 보여라
	}
	
	
	
	Unilite.Main({
		id			: 'practice5App',
		borderItems	: [{														//전체 화면 배치 정의
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function() {										//화면 열렸을 때 초기설정
			panelResult.setValue('TYPE_LEVEL', UserInfo.divCode);	
			//초기화 시 포커스 이동
			panelResult.onLoadSelectText('TYPE_LEVEL');

			UniAppManager.setToolbarButtons('reset'	, true);		//초기화 버튼 활성화
			UniAppManager.setToolbarButtons('newData', true);		//행추가 버튼 활성화
			
			//panel 값을 set하면 저장버튼 활성화 되므로 필요한 로직
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			//조회 시, 비활성화 되는 panel 필드 활성화
			panelResult.getField('TYPE_LEVEL').setReadOnly(false);
			panelResult.getField('TREE_CODE').setReadOnly(false);
		},
		onQueryButtonDown: function() {							//조회버튼
			if(Ext.isEmpty(panelResult.getValue('TYPE_LEVEL'))) {
				openSearchInfoWindow();
			}
			if(Ext.isEmpty(panelResult.getValue('TREE_CODE'))) {
				openSearchInfoWindow();
			} else {
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				panelResult.getForm().load({
					params: param,
					success:function() {
						panelResult.getField('TYPE_LEVEL').setReadOnly(true);
						panelResult.getField('TREE_CODE').setReadOnly(true);
						masterGrid.getStore().loadStoreRecords();
						panelResult.uniOpt.inLoading = false;
					},
					failure: function(form, action) {
						panelResult.uniOpt.inLoading = false;
					}
				})
			}
		},
		onResetButtonDown: function() {							//신규버튼
			panelResult.clearForm();									//panel 필드 초기화: 공백 값으로 변경
			masterGrid.getStore().loadData({});						//그리드 초기화: 빈 데이터 load
			this.fnInitBinding();										//초기화 값 세팅
		},
//		onPrintButtonDown: function() {							//프린트(출력)
//			var param			= panelResult.getValues();		//출력에 필요한 parameter 정의
//			param.PGM_ID		= 'practice5';						//parameter에 추가로 필요한 데이터 정의: PGM_ID는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
//			param.MAIN_CODE		= 'Z012';						//parameter에 추가로 필요한 데이터 정의: MAIN_CODE는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
//
//			var win = Ext.create('widget.ClipReport', {
//				url			: CPATH+'/base/practiceClip1.do',			//출력 시 호출할 url 정의
//				prgID		: 'practice5',
//				extParam	: param,
//				submitType	: 'POST'										//대용량 데이터 통신의 경우, post 방식으로 호출: 기본값으로 사용하면 됨
//			});
//			win.center();
//			win.show();
//		},
		onSaveDataButtonDown: function(config) {					//저장 버튼 실행로직
			if(!panelResult.getInvalidMessage()) return;				//필수체크
			if(panelResult.isDirty()) {										//panel에 저장할 데이터가 있으면....
				var param = panelResult.getValues();
				panelResult.submit({										//panel 저장로직
					params: param,
					success:function(comp, action) {					//panel 저장 성공 시, 수행하는 부분
						if(directMasterStore.isDirty()) {
							directMasterStore.saveStore();
						} else {
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
						}
					},
					failure: function(form, action){						//panel 저장 실패 시, 수행하는 부분
					}
				});
			} else {
				directMasterStore.saveStore();							//grid 데이터 저장
			}
		},
		onNewDataButtonDown: function() {							//신규 행 추가 버튼 로직
			var r = {
				COMP_CODE		: UserInfo.compCode,
				TYPE_LEVEL		: panelResult.getValue('TYPE_LEVEL'),
				TREE_CODE		: panelResult.getValue('TREE_CODE')
			}
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {							//삭제 버튼 로직
			var selRow	= masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();						//그리드에서 삭제할 행을 선택했을 때
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},		onDeleteAllButtonDown: function() {								//전체 삭제로직은 프로그램에 따라 다르게 구성 - 아래 로직은 특수한 경우 사용.. 일반적은 소스는 아래 주석부분 참조
			if(confirm('전체삭제 하시겠습니까?')) {
				var param = panelResult.getValues();
				zDevelopPracticeService.deleteAll5(param, function(provider, response) {
					if(provider == 0){
						UniAppManager.updateStatus('전체삭제 되었습니다.');
						UniAppManager.app.onResetButtonDown();
					}
				});
			}
			//일반적인 전체삭제 로직
//			var records = directMasterStore.data.items;					//전체 레코드 가져와서 체크 함
//			var isNewData = false;
//			Ext.each(records, function(record,i) {
//				if(record.phantom){										// 신규 레코드일시 isNewData에 true를 반환
//					isNewData = true;
//				} else {														// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
//					isNewData = false;
//					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
//						var deletable = true;
//						/*---------삭제전 로직 구현 시작----------*/
//						Ext.each(records, function(record,i) {
//							if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
//								Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
//								deletable = false;
//								return false;
//							}
//						});
//						/*---------삭제전 로직 구현 끝----------*/
//						if(deletable){										//체크 후, 문제가 없을 경우, 
//							masterGrid.reset();							//그리드 reset 후
//							UniAppManager.app.onSaveDataButtonDown();	//저장로직 수행
//						}
//					}
//					return false;
//				}
//			});
//			if(isNewData){												// 신규 레코드들만 있을시에는 그리드 리셋만 하면 됨
//				masterGrid.reset();
//				UniAppManager.app.onResetButtonDown();		// 삭제후 RESET(초기화)..
//			}
		}
	});
};
</script>