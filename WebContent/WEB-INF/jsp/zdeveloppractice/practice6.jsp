<%--
'   프로그램명 : 작업지시서 출력 (practice6)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2021.04
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.2.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="practice6" >									<%-- 공통코드 --%>
	<t:ExtComboStore comboType="BOR120" pgmId="practice6"/>			<!-- 사업장 -->
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


function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'TYPE_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '창고',
			name		: 'TREE_CODE',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'zDevelopPracticeService.selectList6',
			create	: 'zDevelopPracticeService.insertDetail6',
			update	: 'zDevelopPracticeService.updateDetail6',
			destroy	: 'zDevelopPracticeService.deleteDetail6',
			syncAll	: 'zDevelopPracticeService.saveAll6'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('practice6Model', {
		fields: [
			{name: 'TREE_CODE'			,text: '<t:message code="system.label.base.warehousecode" default="창고코드"/>'	, type: 'string', allowBlank: false},
			{name: 'TREE_NAME'			,text: '<t:message code="system.label.base.warehousename" default="창고명"/>'		, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.base.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'TYPE_LEVEL'			,text: '<t:message code="system.label.base.division" default="사업장"/>'			, type: 'string', allowBlank: false, xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'GROUP_CD'			,text: '<t:message code="system.label.base.groupset" default="그룹설정"/>'			, type: 'string', comboType: 'AU', comboCode: 'B070'},
			{name: 'USE_YN'				,text: '<t:message code="system.label.base.useyn" default="사용여부"/>'			, type: 'string', comboType: 'AU', comboCode: 'B010'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('practice6MasterStore1', {
		model	: 'practice6Model',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
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
//			var toCreate	= this.getNewRecords();					//신규 데이터
//			var toUpdate	= this.getUpdatedRecords();				//수정된 데이터
//			var toDelete	= this.getRemovedRecords();				//삭제된 데이터
			var inValidRecs	= this.getInvalidRecords();				//validation 체크: 오류나는 것이 없을 때
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {							//
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
				var grid = Ext.getCmp('practice6Grid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
	var masterGrid = Unilite.createGrid('practice6Grid1', {
		store	: directMasterStore,																	//해당 그리드와 연결된 store 정의
		layout	: 'fit',
		region	: 'center',			
		//위치 정의: 'center'는 한 페이지에 하나만 정의할 수 있음
		uniOpt	: {				
			useRowNumberer		: false,			//번호 칼럼
			useContextMenu		: false,																	//문서 참조: 그리드 옵션 설정
			useGroupSummary		: false,
			expandLastColumn	: true,				//칼럼 확장 선택
			onLoadSelectFirst	: true,				//첫줄 선택
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
		selModel: 'rowmodel',
		tbar	: [],
		columns	: [
			{dataIndex: 'TREE_CODE'		, width: 110},
			{dataIndex: 'TREE_NAME'		, width: 150},
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
			{dataIndex: 'TYPE_LEVEL'	, width: 100},
			{dataIndex: 'GROUP_CD'		, width: 100, align: 'right'},
			{dataIndex: 'USE_YN'		, width: 100, align: 'center'}		
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {									//그리드 더블클릭 이벤트: 링크 등에 사용
			},
			beforeedit: function( editor, e, eOpts ) {													//등록 프로그램에서 수정가능여부 설정할 때 사용
				//신규 행일 때는 모두 수정 가능
				if(e.record.phantom ) {				//이 행이 신규이면,
					return true;
				} else {							//조회된 행이면,
					//조회된 행일 때는 USER_ID는 수정 불가
					if (UniUtils.indexOf(e.field, ['USER_ID'])) {
						return false;
					} else {
						return true;
					}
				}
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {				//cell 클릭 했을 때 필요한 로직이 있으면 사용
			}
		},
		viewConfig: {																					//특정 행에 대해, 글자, 글자색, 바탕색 등 highlights 필요할 때 사용
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



	Unilite.Main({
		id			: 'practice6App',
		borderItems	: [{										//전체 화면 배치 정의
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function() {								//화면 열렸을 때 초기설정
			panelResult.setValue('TYPE_LEVEL', UserInfo.divCode);
			//초기화 시 포커스 이동
			panelResult.onLoadSelectText('TYPE_LEVEL');

			UniAppManager.setToolbarButtons('reset'	, true);	//초기화 버튼 활성화
			UniAppManager.setToolbarButtons('newData', true);	//행추가 버튼 활성화
		},
		onQueryButtonDown: function() {							//조회버튼
			if(!this.isValidSearchForm()){						//필수조건 체크
				return false;
			}
			masterGrid.getStore().loadStoreRecords();			//조회
		},
		onResetButtonDown: function() {							//신규버튼
			panelResult.clearForm();							//panel 필드 초기화: 공백 값으로 변경
			masterGrid.getStore().loadData({});					//그리드 초기화: 빈 데이터 load
			this.fnInitBinding();								//초기화 값 세팅
		},
//		onPrintButtonDown: function() {							//프린트(출력)
//			var param			= panelResult.getValues();		//출력에 필요한 parameter 정의
//			param.PGM_ID		= 'practice6';					//parameter에 추가로 필요한 데이터 정의: PGM_ID는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
//			param.MAIN_CODE		= 'Z012';						//parameter에 추가로 필요한 데이터 정의: MAIN_CODE는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
//
//			var win = Ext.create('widget.ClipReport', {
//				url			: CPATH+'/base/practiceClip1.do',	//출력 시 호출할 url 정의
//				prgID		: 'practice6',
//				extParam	: param,
//				submitType	: 'POST'							//대용량 데이터 통신의 경우, post 방식으로 호출: 기본값으로 사용하면 됨
//			});
//			win.center();
//			win.show();
//		},
		onSaveDataButtonDown: function(config) {				//저장 버튼 실행로직
			directMasterStore.saveStore();
		},
		onNewDataButtonDown: function() {						//신규 행 추가 버튼 로직
			var r = {
				DIV_CODE		: UserInfo.divCode,
				USE_YN			: 'Y',
				AUTHORITY_LEVEL	: '15'
			}
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {					//삭제 버튼 로직
			var selRow	= masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();				//그리드에서 삭제할 행을 선택했을 때
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		}
	});
};
</script>