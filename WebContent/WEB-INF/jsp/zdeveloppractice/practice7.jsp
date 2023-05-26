<%--
'   프로그램명 : 폼/그리드 저장 (practice7)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2021.04
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.2.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="practice7">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>				<!-- 구분 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="practice7_1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="practice7_2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="practice7_3Store" />
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
	var panelResult = Unilite.createSearchForm('resultForm',{							//resultForm -> disabled: false필요
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		disabled: false,
		items	: [{ 
			fieldLabel	: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel	: '구분',
			name		: 'PRICE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,									//조회조건에서 주로 사용: 부분값만 입력 후 조회할 때 validateBlank: false 사용
			listeners		: {
				onValueFieldChange: function(field, newValue){				//조회조건에서 주로 사용: 부분값만 입력 후 조회할 때 panel 동기화 시, onSelected, onClear 대신 onValueFieldChange, onTextFieldChange사용
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
				}
			}
		}),{
			fieldLabel	: '조건 ',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.nowapplyprice" default="현재적용단가"/>',
				name		: 'rdoSelect', 
				inputValue	: 'C',
				width		: 100
			},{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'rdoSelect', 
				inputValue	: 'A',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('practice7_1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('practice7_2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100
				
			 }, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('practice7_3Store'),
				width		: 100
			}]
		}]	
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'zDevelopPracticeService.selectList7',
			create	: 'zDevelopPracticeService.insertList7',
			update	: 'zDevelopPracticeService.updateList7',
			destroy	: 'zDevelopPracticeService.deleteList7',
			syncAll	: 'zDevelopPracticeService.saveAll7'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('practice7Model', {
		fields: [
		{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'		, comboType: 'BOR120'},
			{name: 'PRICE_TYPE'			, text: '구분'																		, type: 'string'		, allowBlank: false, comboType: 'AU'	, comboCode: 'Z001'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string', allowBlank: false},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ITEM_P'				, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'		, allowBlank: false, comboType: 'AU'	, comboCode: 'B004'	, displayField: 'value'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'		, allowBlank: false, comboType: 'AU'	, comboCode: 'B013'	, displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'	, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '<t:message code="system.label.purchase.applyenddate" default="적용종료일"/>'	, type: 'uniDate'		, allowBlank: false}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('practice7MasterStore1', {
		model	: 'practice7Model',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: true,		//수정 모드 사용 
			deletable	: true,		//삭제 가능 여부 
			useNavi		: false		//prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();		//또는 panelResult.getValues();
			console.log( param );
			this.load({
				params	: param
			});	
		},
		saveStore: function(config) {
//			var toCreate	= this.getNewRecords();					//신규 데이터
//			var toUpdate	= this.getUpdatedRecords();				//수정된 데이터
//			var toDelete	= this.getRemovedRecords();				//삭제된 데이터
			var inValidRecs	= this.getInvalidRecords();				//validation 체크
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {success : function() {
						masterStore.loadStoreRecords();
					}};
				}
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
	listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
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

	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('practice7Grid1', {
		store	: masterStore,															
		region	: 'center',																				//위치 정의: 'center'는 한 페이지에 하나만 정의할 수 있음
		uniOpt	: {																						//문서 참조: 그리드 옵션 설정
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
			},
			columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'PRICE_TYPE'		, width: 100	, align: 'center'},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
				 	autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 133	,
				editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 93},
			{dataIndex: 'ITEM_P'			, width: 100},
			{dataIndex: 'MONEY_UNIT'		, width: 93, align: 'center'},
			{dataIndex: 'ORDER_UNIT'		, width: 93, align: 'center'},
			{dataIndex: 'APLY_START_DATE'	, width: 100},
			{dataIndex: 'APLY_END_DATE'		, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {					//등록 프로그램에서 수정가능여부 설정할 때 사용
				if (!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'CUSTOM_CODE', 'PRICE_TYPE', 'ITEM_CODE', 'ITEM_NAME', 'MONEY_UNIT', 'ORDER_UNIT', 'APLY_START_DATE'])){
						return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['SPEC'])){
					return false;
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});



	Unilite.Main({
		id			: 'practice7App',
		borderItems	: [{												//전체 화면 배치 정의
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {										//화면 열렸을 때 초기설정
			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			this.setDefault();

		},
		onQueryButtonDown: function() {									//조회버튼
		if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {									//신규버튼
			panelResult.clearForm();									//panel 필드 초기화: 공백 값으로 변경
			masterGrid.getStore().loadData({});							//그리드 초기화: 빈 데이터 load
			this.fnInitBinding();										//초기화 값 세팅
		},
		onSaveDataButtonDown: function(config) {						//저장 버튼 실행로직
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) { 
				return false;
			}
			masterStore.saveStore(config);
		},
		onNewDataButtonDown: function() {								//신규 행 추가 버튼 로직
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				CUSTOM_CODE		: '*',									//저장시 기본값
				APLY_START_DATE	: new Date(),
				APLY_END_DATE	: '29991231',							//적용종료일
				MONEY_UNIT		: UserInfo.currency
			};
			masterGrid.createRow(r, null, masterStore.getCount() - 1);
		},
		onDeleteDataButtonDown: function() {									//삭제 버튼 로직
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {				//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('rdoSelect', 'C');
		}
	});
	
	Unilite.createValidator('validator07', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "APLY_START_DATE" :	// 적용 시작일
					var aplyStartDate = UniDate.getDbDateStr(newValue);
					if(aplyStartDate.length == 8) {
						if (!Ext.isEmpty(record.get('APLY_END_DATE'))) {
							var aplyEndDate = UniDate.getDbDateStr(record.get('APLY_END_DATE'));
							if (aplyStartDate > aplyEndDate) {
								rv = '<t:message code="system.message.purchase.message098" default="적용 시작일은 종료일 보다 늦을 수 없습니다."/>';
							}
						}
					}
				break;

				case "APLY_END_DATE" :		// 적용 종료일
					var aplyEndDate = UniDate.getDbDateStr(newValue);
					if(aplyEndDate.length == 8) {
						var aplyStartDate = UniDate.getDbDateStr(record.get('APLY_START_DATE'));
						if (aplyEndDate < aplyStartDate) {
							rv = '<t:message code="system.message.purchase.message099" default="적용 종료일은 시작일 보다 빠를 수 없습니다."/>';
						}
					}
				break;
			}
			return rv;
		}
	})
	
	
};
</script>