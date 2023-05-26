<%--
'   프로그램명 : 시험성적서 양식 등럭
'
'   작  성  자 : (주)시너지시스템즈 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_qbs100ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ01" /> <!-- 시험성적서-계측제목 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ02" /> <!-- 시험성적서-타이틀유형 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ03" /> <!-- Insepect Result 유형 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ04" /> <!-- 검사유형 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

var revWindow;
var copyWindow;
var remarkWindow;

function appMain() {
	
	var glFixedColCount = 1;
	var glFormColumnCount = 2;
	fnGetColumnCount();
	
	var gsColumnList = ${gsColumnList};
	var inLoading = false;
	var storeLoading = false;
	var isInit = true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs100ukrv_mekService.selectList1',
			update  : 's_qbs100ukrv_mekService.update',
			create  : 's_qbs100ukrv_mekService.insert',
			destroy : 's_qbs100ukrv_mekService.delete',
			syncAll : 's_qbs100ukrv_mekService.saveAll'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('s_qbs100ukrv_mekModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'ITEM_NO'			, text: '<t:message code="" default="ITEM_NO"/>'									, type: 'int'		, allowBlank:false},
			{name: 'MODEL'				, text: '<t:message code="" default="MODEL"/>'										, type: 'string'	, allowBlank:false},
			{name: 'REV_NO'				, text: '<t:message code="" default="REV_NO"/>'										, type: 'string'	, allowBlank:false},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="" default="INSPECT_TYPE"/>'								, type: 'string'	, allowBlank:false},
			{name: 'SUBJECT_CODE'		, text: '<t:message code="" default="SUBJECT_CODE"/>'								, type: 'string'	, allowBlank:false},
			{name: 'SUBJECT_TITLE'		, text: '<t:message code="" default="SUBJECT_TITLE"/>'								, type: 'string'	, allowBlank:false},
			{name: 'TITLE_TYPE'			, text: '<t:message code="" default="TITLE_TYPE"/>'									, type: 'string'	, allowBlank:false},
			{name: 'NO'					, text: '<t:message code="" default="NO"/>'											, type: 'string'	, allowBlank:false},
			{name: 'ITEMS'				, text: '<t:message code="" default="ITEMS"/>'										, type: 'string'},
			{name: 'CHECK_POINT'		, text: '<t:message code="" default="CHECK_POINT"/>'								, type: 'string'},
			{name: 'STANDARD'			, text: '<t:message code="" default="STANDARD"/>'									, type: 'string'},
			{name: 'LOTNO'				, text: '<t:message code="" default="LOTNO"/>'										, type: 'string'},
			{name: 'NUM_VALUE'			, text: '<t:message code="" default="NUM_VALUE"/>'									, type: 'float'		, decimalPrecision:2, format:'0,000.00'},
			{name: 'SPEC'				, text: '<t:message code="" default="SPEC"/>'										, type: 'string'},
			{name: 'MEASURE_VALUE'		, text: '<t:message code="" default="MEASURE_VALUE"/>'								, type: 'string'},
			{name: 'RE_MEASURE_VALUE'	, text: '<t:message code="" default="RE_MEASURE_VALUE"/>'							, type: 'string'},
			{name: 'FIRST_CAL'			, text: '<t:message code="" default="FIRST_CAL"/>'									, type: 'string'},
			{name: 'FACTORY_TOL'		, text: '<t:message code="" default="FACTORY_TOL"/>'								, type: 'string'},
			{name: 'UNIT'				, text: '<t:message code="" default="UNIT"/>'										, type: 'string'},
			{name: 'INSPECT_RESULT'		, text: '<t:message code="" default="INSPECT_RESULT"/>'								, type: 'string'	, comboType:"AU"	, comboCode:"ZQ03"},
			{name: 'RE_INSPECT_RESULT'	, text: '<t:message code="" default="RE_INSPECT_RESULT"/>'							, type: 'string'	, comboType:"AU"	, comboCode:"ZQ03"},
			{name: 'ADD_TEXT1'			, text: '<t:message code="" default="추가사항1"/>'										, type: 'string'},
			{name: 'ADD_TEXT2'			, text: '<t:message code="" default="추가사항2"/>'										, type: 'string'},
			{name: 'SORT_SEQ'			, text: '<t:message code="" default="정렬순서"/>'										, type: 'int'},
			{name: 'MEASURE_VAR'		, text: '<t:message code="" default="계측기변수"/>'										, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore1 = Unilite.createStore('s_qbs100ukrv_mekMasterStore1', {
		model : 's_qbs100ukrv_mekModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : true,			// 삭제 가능 여부
			allDeletable : true,			// 전체삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: directProxy,
		loadStoreRecords: function(){
			var param = panelSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = panelSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					var type = records[0].get('TITLE_TYPE');
					var title = records[0].get('SUBJECT_TITLE');
					
					panelSearch.setValue('SUBJECT_TITLE', title);
					panelResult.setValue('SUBJECT_TITLE', title);
					
					masterGrid.setColumnDisplay(type);
				}
				
				storeLoading = false;
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	
	/**
	 * searchPanel
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		defaultType	: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId : 'search_panel1',
			layout : {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [Unilite.popup('MODEL_MICS',{
				fieldLabel		: '모델',
				holdable		: 'hold',
//				validateBlank	: false,
//				autoPopup		: true,
				allowBlank		: false,
				valueFieldName	: 'MODEL_CODE',
				textFieldName	: 'MODEL_NAME',
				DBvalueFieldName: 'MODEL_CODE',
				DBtextFieldName	: 'MODEL_NAME',
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelResult.setValue('MODEL_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MODEL_NAME', '');
							panelResult.setValue('MODEL_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
						panelResult.setValue('MODEL_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MODEL_CODE', '');
							panelResult.setValue('MODEL_CODE', '');
						}
					}
				}
			}),{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '',
				name		: 'INSPECT_TYPE',
				holdable	: 'hold',
				comboType	: 'AU',
				comboCode	: 'ZQ04',
				store		: Ext.getStore('CBS_AU_ZQ04'),
				allowBlank	: false,
				padding		: '0 0 0 95',
				width		: 270,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPECT_TYPE', newValue.INSPECT_TYPE);
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="문서양식번호"/>',
				name		: 'REV_NO',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				holdable	: 'hold',
				refValues	: {
					MODEL_CODE	: '',
					MODEL_NAME	: '',
					INSPECT_TYPE: ''
				},
				triggers: {
					popup: {
						cls: 'x-form-search-trigger',
						handler: function() {
							if(Ext.isEmpty(panelSearch.getValue('MODEL_CODE'))) {
								Unilite.messageBox('모델' + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
								return;
							}
							this.refValues.MODEL_CODE	= panelSearch.getValue('MODEL_CODE');
							this.refValues.MODEL_NAME	= panelSearch.getValue('MODEL_NAME');
							this.refValues.INSPECT_TYPE	= panelSearch.getValue('INSPECT_TYPE').INSPECT_TYPE;
							
							openRevWindow(this);
						}
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REV_NO', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="계측제목"/>',
				name		: 'SUBJECT_CODE',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				//holdable	: 'hold',
				comboType	: 'AU',
				comboCode	: 'ZQ01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnChangeSubjectCode(newValue, field.rawValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'SUBJECT_TITLE',
				xtype		: 'uniTextfield',
				//holdable	: 'hold',
				padding		: '0 0 0 95',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUBJECT_TITLE', newValue);
						masterGrid.setSubjectTitle(newValue);
					}
				}
	 		}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * panelResult
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [Unilite.popup('MODEL_MICS',{
			fieldLabel		: '모델',
			holdable		: 'hold',
//			validateBlank	: false,
//			autoPopup		: true,
			allowBlank		: false,
			width			: 330,
			valueFieldName	: 'MODEL_CODE',
			textFieldName	: 'MODEL_NAME',
			DBvalueFieldName: 'MODEL_CODE',
			DBtextFieldName	: 'MODEL_NAME',
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('MODEL_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('MODEL_NAME', '');
						panelResult.setValue('MODEL_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					panelSearch.setValue('MODEL_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('MODEL_CODE', '');
						panelResult.setValue('MODEL_CODE', '');
					}
				}
			}
		}),{
			xtype		: 'uniRadiogroup',
			fieldLabel	: '&nbsp;',
			name		: 'INSPECT_TYPE',
			allowBlank	: true,
			width		: 300,
			holdable	: 'hold',
			items		: getRadioGroupItems('CBS_AU_ZQ04', 'INSPECT_TYPE'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPECT_TYPE', newValue.INSPECT_TYPE);
				}
			}
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			colspan		: 2
 		},{
			fieldLabel	: '<t:message code="" default="문서양식번호"/>',
			name		: 'REV_NO',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			holdable	: 'hold',
			refValues	: {
				MODEL_CODE	: '',
				MODEL_NAME	: '',
				INSPECT_TYPE: ''
			},
			triggers: {
				popup: {
					cls: 'x-form-search-trigger',
					handler: function() {
						if(Ext.isEmpty(panelResult.getValue('MODEL_CODE'))) {
							Unilite.messageBox('모델' + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
							return;
						}
						
						this.refValues.MODEL_CODE	= panelResult.getValue('MODEL_CODE');
						this.refValues.MODEL_NAME	= panelResult.getValue('MODEL_NAME');
						this.refValues.INSPECT_TYPE	= panelSearch.getValue('INSPECT_TYPE').INSPECT_TYPE;
						
						openRevWindow(this);
					}
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REV_NO', newValue);
				}
			}
		},{
			xtype		: 'uniDetailForm',
			disabled	: false,
			layout: {
				type: 'table',
				columns:2
			},
			padding		: 0,
			width		: 400,
			items:[{
				fieldLabel	: '<t:message code="" default="계측제목"/>',
				name		: 'SUBJECT_CODE',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				//holdable	: 'hold',
				comboType	: 'AU',
				comboCode	: 'ZQ01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnChangeSubjectCode(newValue, field.rawValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'SUBJECT_TITLE',
				xtype		: 'uniTextfield',
				//holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SUBJECT_TITLE', newValue);
						masterGrid.setSubjectTitle(newValue);
					}
				}
			}]
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			tdAttrs		: {width:'100%'}
 		},{
			xtype		: 'button',
			text		: '복사',
			width		: 100,
			handler: function() {
				openCopyWindow();
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	function getRadioGroupItems(storeName, fieldName) {
		var store = Ext.getStore(storeName);
		var items = [];
		
		if(store.count() > 0 ) {
			var records = store.data.items;
			
			for(var i = 0, j = records.length; i < j; i++) {
				items.push({
					boxLabel	: records[i].get('text'),
					inputValue	: records[i].get('value'),
					//width		: 80,
					name		: fieldName
				});
			}
		}
		
		return items;
	}
	
	var typeListForm = Unilite.createSearchForm('typeListForm', {
		region		: 'north',
		layout : {type : 'uniTable', columns : glFormColumnCount,
			tableAttrs : { style: 'width:100%; border:2px solid #ced9e7; border-collapse: collapse;' },
			tdAttrs    : { style: 'border: 1px solid #ced9e7; overflow: hidden; white-space: nowrap;', height: 29, align : 'left' }
		},
		padding		: '1 1 1 1',
		border		: true,
		title		: '유형리스트',
		collapsible	: true,
		collapseDirection: 'top',
		items		: fnGetType()
	});
	
	function fnGetType() {
		var types = Ext.getStore('CBS_AU_ZQ02').data.items;
		var typeList = [];
		
		typeList.push({
			xtype	: 'component',
			html	: '유형',
			tdAttrs	: { style: 'background-color: #eeeefe;', align : 'center' }
		},{
			xtype	: 'component',
			html	: '계측항목',
			colspan	: (glFormColumnCount - glFixedColCount),
			tdAttrs	: { style: 'background-color: #eeeefe;', align : 'center' }
		});
		
		Ext.each(types, function(type, i){
			typeList.push({
				xtype	: 'button',
				text	: type.get('text'),
				minWidth: 50,
				width	: 100,
				tdAttrs	: { align : 'center', SUB_CODE: type.get('value')},
				handler	: function() {
					if(directMasterStore1.getCount() < 1) {
						masterGrid.setColumnDisplay(this.config.tdAttrs.SUB_CODE);
					}
				}
			});
			
			var cnt = 0;
			for(var lCol = 1; lCol <= 15; lCol++) {
				var sColName = 'refCode' + String(lCol);
				
				if(!Ext.isEmpty(type.get(sColName))){
					typeList.push({
						xtype	: 'component',
						html	: type.get(sColName),
						minWidth: 100,
						padding	: '0 5 0 5'
					});
					cnt++;
				}
			}
			
			for(var lLoop = (glFormColumnCount - glFixedColCount - cnt); lLoop > 0; lLoop--) {
				typeList.push({
					xtype	: 'component',
					html	: '&nbsp;',
					minWidth: 100
				});
			}
		});
		
		return typeList;
	}
	
	function fnGetColumnCount() {
		Ext.each(Ext.getStore('CBS_AU_ZQ02').data.items, function(type, i){
			var cnt = 0;
			
			if(!Ext.isEmpty(type.get('refCode1')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode2')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode3')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode4')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode5')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode6')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode7')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode8')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode9')))  cnt++;
			if(!Ext.isEmpty(type.get('refCode10'))) cnt++;
			if(!Ext.isEmpty(type.get('refCode11'))) cnt++;
			if(!Ext.isEmpty(type.get('refCode12'))) cnt++;
			if(!Ext.isEmpty(type.get('refCode13'))) cnt++;
			if(!Ext.isEmpty(type.get('refCode14'))) cnt++;
			if(!Ext.isEmpty(type.get('refCode15'))) cnt++;
			
			if(cnt + glFixedColCount > glFormColumnCount) {
				glFormColumnCount = cnt + glFixedColCount;
			}
		});
	}
	
	/**
	 * masterGrid
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			},
			nonTextSelectedColumns:['ITEMS', 'CHECK_POINT', ''],
			selectedTitleType	: '',
			hasResult			: false
		},
		store: directMasterStore1,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ITEM_NO'			, width: 100, hidden: true},
			{dataIndex: 'MODEL'				, width: 100, hidden: true},
			{dataIndex: 'REV_NO'			, width: 100, hidden: true},
			{dataIndex: 'INSPECT_TYPE'		, width: 100, hidden: true},
			{dataIndex: 'SUBJECT_CODE'		, width:  80, hidden: true},
			{dataIndex: 'SUBJECT_TITLE'		, width:  80, hidden: true},
			{dataIndex: 'TITLE_TYPE'		, width:  80, hidden: true},
			{dataIndex: 'NO'				, width:  70},
			{dataIndex: 'ITEMS'				, minWidth: 300, flex:1,
				editor:{
					xtype:	'textfield',
					triggers: {
						popup: {
							cls: 'x-form-search-trigger',
							handler: function() {
								openRemarkWindow(this);
							}
						}
					}
				}
			},
			{dataIndex: 'CHECK_POINT'		, minWidth: 300, flex:1, hidden: true,
				editor:{
					xtype:	'textfield',
					triggers: {
						popup: {
							cls: 'x-form-search-trigger',
							handler: function() {
								openRemarkWindow(this);
							}
						}
					}
				}
			},
			{dataIndex: 'STANDARD'			, minWidth: 300, flex:1, hidden: true},
			{dataIndex: 'LOTNO'				, width: 150, hidden: true},
			{dataIndex: 'NUM_VALUE'			, width: 100, hidden: true},
			{dataIndex: 'SPEC'				, minWidth: 300, flex:1, hidden: true},
			{dataIndex: 'MEASURE_VALUE'		, width: 150, hidden: true},
			{dataIndex: 'RE_MEASURE_VALUE'	, width: 150, hidden: true},
			{dataIndex: 'FIRST_CAL'			, width: 150, hidden: true},
			{dataIndex: 'FACTORY_TOL'		, width: 150, hidden: true},
			{dataIndex: 'UNIT'				, width: 150, hidden: true},
			{dataIndex: 'INSPECT_RESULT'	, width: 150, hidden: true},
			{dataIndex: 'RE_INSPECT_RESULT'	, width: 150, hidden: true},
			{dataIndex: 'ADD_TEXT1'			, minWidth: 150, flex:1},
			{dataIndex: 'ADD_TEXT2'			, minWidth: 150, flex:1},
			{dataIndex: 'SORT_SEQ'			, width: 100},
			{dataIndex: 'MEASURE_VAR'		, width: 100}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom) {
					return true;
				}
				
				if(inLoading) {
					return false;
				}
				
				return !masterGrid.uniOpt.hasResult;
			},
			selectionchangerecord: function(record) {
				var grid = masterGrid;
				if(Ext.isEmpty(grid.view.eventPosition)){
					return;
				}
				
				if(storeLoading) {
					return;
				}
				
				inLoading = true;
				
				s_qbs100ukrv_mekService.checkResult(record.data, function(provider, response){
					inLoading = false;
					
					if(!Ext.isEmpty(provider)) {
						if(Number(provider[0].CNT_RESULT) > 0) {
							masterGrid.uniOpt.hasResult = true;
							UniAppManager.setToolbarButtons(['delete'], false);
							
							masterGrid.editing.cancelEdit();
						}
						else {
							var colIdx = grid.view.eventPosition.colIdx;
							
							masterGrid.uniOpt.hasResult = false;
							UniAppManager.setToolbarButtons(['delete'], true);
							
							var plugin = masterGrid.editingPlugin;
							plugin.startEdit(record, colIdx);
						}
					}
				});
			}
		},
		setColumnDisplay : function(type) {
			var codeInfo;
			var codeIndex = Ext.getStore('CBS_AU_ZQ02').findBy(function(record){
				return record.get('value') == type;
			});
			
			masterGrid.getColumn('CHECK_POINT').hide();
			masterGrid.getColumn('STANDARD').hide();
			masterGrid.getColumn('LOTNO').hide();
			masterGrid.getColumn('NUM_VALUE').hide();
			masterGrid.getColumn('SPEC').hide();
			masterGrid.getColumn('MEASURE_VALUE').hide();
			masterGrid.getColumn('RE_MEASURE_VALUE').hide();
			masterGrid.getColumn('FIRST_CAL').hide();
			masterGrid.getColumn('FACTORY_TOL').hide();
			masterGrid.getColumn('UNIT').hide();
			masterGrid.getColumn('INSPECT_RESULT').hide();
			masterGrid.getColumn('RE_INSPECT_RESULT').hide();
			
			if(!Ext.isEmpty(codeIndex) && codeIndex >= 0) {
				codeInfo = Ext.getStore('CBS_AU_ZQ02').data.items[codeIndex];
				
				for(var lRefIdx = 1; lRefIdx <= 15; lRefIdx++) {
					var sRefName = 'refCode' + String(lRefIdx);
					var sColName = codeInfo.get(sRefName);
					
					if(!Ext.isEmpty(sColName) && masterGrid.getColumnIndex(gsColumnList['REF_CODE' + String(lRefIdx)]) >= 0){
						masterGrid.getColumn(gsColumnList['REF_CODE' + String(lRefIdx)]).show();
						masterGrid.getColumn(gsColumnList['REF_CODE' + String(lRefIdx)]).setText(sColName);
					}
				}
			}
			
			masterGrid.uniOpt.selectedTitleType	= type;
		},
		setSubjectTitle: function(title) {
			Ext.each(directMasterStore1.data.items, function(record){
				record.set('SUBJECT_TITLE', title);
			});
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {

	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, panelResult, typeListForm
			]
		},
			panelSearch
		],
		id : 's_qbs100ukrv_mekApp',
		fnInitBinding : function() {
			isInit = true;
			
			var inspectType = panelResult.getField('INSPECT_TYPE').getBoxes()[0].inputValue;
			
			panelSearch.getField('INSPECT_TYPE').setValue(inspectType);
			panelResult.getField('INSPECT_TYPE').setValue(inspectType);
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			UniAppManager.setToolbarButtons(['newData'], true);
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			isInit = false;
		},
		onQueryButtonDown: function(isRef) {
			if(isInit) {
				return;
			}
			
			if(isRef && !panelSearch.isValid()) {
				return false;
			}
			
			if(!panelSearch.getInvalidMessage()) {
				return false;
			}
			
			if(panelSearch.setAllFieldsReadOnly(true) && panelResult.setAllFieldsReadOnly(true)) {
				storeLoading = true;
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			var r = {
				COMP_CODE			: UserInfo.compCode,
				ITEM_NO				: -1,
				MODEL				: panelSearch.getValue('MODEL_CODE'),
				REV_NO				: panelSearch.getValue('REV_NO'),
				INSPECT_TYPE		: panelSearch.getField('INSPECT_TYPE').getValue().INSPECT_TYPE,
				SUBJECT_CODE		: panelSearch.getValue('SUBJECT_CODE'),
				SUBJECT_TITLE		: panelSearch.getValue('SUBJECT_TITLE'),
				TITLE_TYPE			: masterGrid.uniOpt.selectedTitleType,
				NO					: '',
				ITEMS				: '',
				CHECK_POINT			: '',
				STANDARD			: '',
				LOTNO				: '',
				NUM_VALUE			: '',
				SPEC				: '',
				MEASURE_VALUE		: '',
				RE_MEASURE_VALUE	: '',
				FIRST_CAL			: '',
				FACTORY_TOL			: '',
				UNIT				: '',
				INSPECT_RESULT		: '',
				RE_INSPECT_RESULT	: '',
				SORT_SEQ			: '',
				MEASURE_VAR			: ''
			};
			
			masterGrid.createRow(r);
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			UniAppManager.setToolbarButtons(['newData'], true);
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			//this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}
			
			if(masterGrid.uniOpt.hasResult) {
				Unilite.messageBox('결과가 등록된 양식은 삭제하실 수 없습니다.');
				return false;
			}
			
			Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					masterGrid.deleteSelectedRow();
				}
			});
		},
		onDeleteAllButtonDown: function() {
			var isNotPhantom = false;
			var param = {};
			
			Ext.each(directMasterStore1.data.items, function(record) {
				if(!record.phantom) {
					isNotPhantom = true;
					
					param.COMP_CODE		= record.get('COMP_CODE');
					param.MODEL			= record.get('MODEL');
					param.REV_NO		= record.get('REV_NO');
					param.INSPECT_TYPE	= record.get('INSPECT_TYPE');
					param.SUBJECT_CODE	= record.get('SUBJECT_CODE');
				}
			});
			
			if(isNotPhantom) {
				s_qbs100ukrv_mekService.checkResultAll(param, function(provider, response){
					if(!Ext.isEmpty(provider)) {
						if(Number(provider[0].CNT_RESULT) > 0) {
							Unilite.messageBox('결과가 등록된 양식은 삭제하실 수 없습니다.');
							return false;
						}
						else {
							Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>', function(btn){
								if (btn == 'yes') {
									masterGrid.reset();
								}
							});
						}
					}
				});
			}
		},
		fnChangeSubjectCode: function(value, rawValue) {
			if(this._needSave()) {
				Ext.Msg.show({
					title:UniUtils.getMessage('system.message.commonJS.baseApp.confirm','확인'),
					msg:  UniUtils.getMessage('system.message.commonJS.baseApp.dirty','내용이 변경되었습니다.') + "\n" 
						+ UniUtils.getMessage('system.message.commonJS.baseApp.confirmSave','변경된 내용을 저장하시겠습니까?'),
					buttons: Ext.Msg.YESNOCANCEL,
					icon: Ext.Msg.QUESTION,
					fn: function(res) {
						//console.log(res);
						if (res === 'yes' ) {
							UniAppManager.app.onSaveDataButtonDown();
							
							panelSearch.setValue('SUBJECT_CODE', value);
							panelResult.setValue('SUBJECT_CODE', value);
							
							if(!Ext.isEmpty(value)) {
								panelSearch.setValue('SUBJECT_TITLE', rawValue);
								panelResult.setValue('SUBJECT_TITLE', rawValue);
							}
							else {
								panelSearch.setValue('SUBJECT_TITLE', '');
								panelResult.setValue('SUBJECT_TITLE', '');
							}
							UniAppManager.app.onQueryButtonDown(true);
						}
						else if (res === 'no' ) {
							UniAppManager.app.onQueryButtonDown(true);
						}
					}
				});
			}
			else {
				panelSearch.setValue('SUBJECT_CODE', value);
				panelResult.setValue('SUBJECT_CODE', value);
				
				if(!Ext.isEmpty(value)) {
					panelSearch.setValue('SUBJECT_TITLE', rawValue);
					panelResult.setValue('SUBJECT_TITLE', rawValue);
				}
				else {
					panelSearch.setValue('SUBJECT_TITLE', '');
					panelResult.setValue('SUBJECT_TITLE', '');
				}
				
				UniAppManager.app.onQueryButtonDown(true);
			}
		},
		fnChangeInspectType: function(value) {
			if(this._needSave()) {
				Ext.Msg.show({
					title:UniUtils.getMessage('system.message.commonJS.baseApp.confirm','확인'),
					msg:  UniUtils.getMessage('system.message.commonJS.baseApp.dirty','내용이 변경되었습니다.') + "\n" 
						+ UniUtils.getMessage('system.message.commonJS.baseApp.confirmSave','변경된 내용을 저장하시겠습니까?'),
					buttons: Ext.Msg.YESNOCANCEL,
					icon: Ext.Msg.QUESTION,
					fn: function(res) {
						//console.log(res);
						if (res === 'yes' ) {
							UniAppManager.app.onSaveDataButtonDown();
							
							panelSearch.setValue('INSPECT_TYPE', value.INSPECT_TYPE);
							panelResult.setValue('INSPECT_TYPE', value.INSPECT_TYPE);
							
							UniAppManager.app.onQueryButtonDown(true);
						}
						else if (res === 'no' ) {
							UniAppManager.app.onQueryButtonDown(true);
						}
					}
				});
			}
			else {
				panelSearch.setValue('INSPECT_TYPE', value.INSPECT_TYPE);
				panelResult.setValue('INSPECT_TYPE', value.INSPECT_TYPE);
				
				UniAppManager.app.onQueryButtonDown(true);
			}
		}
	});//End of Unilite.Main( {
	
	/**
	 * master grid validator
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(newValue == oldValue) {
				return true;
			}
			
//			switch(fieldName) {
//			}
			return rv;
		}
	});
	
	function setAllFieldsReadOnly(b){
		var r = true;
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			
			if(invalid.length > 0) {
				r = false;
				var labelText = '';
				
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
				
				return r;
			}
		}
		
		//this.unmask();
		var fields = this.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(b);
				}
			} 
			if(item.isPopupField)	{
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					item.setReadOnly(b);
				}
			}
		});
		
		return r;
	}
	
	var revProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs100ukrv_mekService.selectRevHistory',
			create	: 's_qbs100ukrv_mekService.insertRev',
			//update	: 's_qbs100ukrv_mekService.updateRev',
			destroy	: 's_qbs100ukrv_mekService.deleteRev',
			syncAll	: 's_qbs100ukrv_mekService.saveAllRev'
		}
	});
	
	/**
	 * query model
	 */
	Unilite.defineModel('revModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="" default="법인코드"/>'			, type: 'string'},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'			, type: 'string'},
			{name: 'MODEL_NAME'			, text: '<t:message code="" default="모델명"/>'			, type: 'string'},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="" default="검사유형"/>'			, type: 'string'},
			{name: 'REV_NO'				, text: '<t:message code="" default="리비전번호"/>'			, type: 'string'},
			{name: 'START_DATE'			, text: '<t:message code="" default="적용시작일"/>'			, type: 'uniDate'},
			{name: 'END_DATE'			, text: '<t:message code="" default="적용종료일"/>'			, type: 'uniDate'}
		]
	});

	/**
	 * query store
	 */
	var revStore = Unilite.createStore('revStore', {
		model	: 'revModel',
		autoLoad : false,
		uniOpt : {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		proxy: revProxy,
		loadStoreRecords : function()	{
			var param = revSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = revSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						revStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				revGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * query search
	 */
	var revSearch = Unilite.createSearchForm('revSearchForm', {
		layout: {type: 'uniTable', columns : 6},
		trackResetOnLoad: true,
		items: [Unilite.popup('MODEL_MICS',{
			fieldLabel		: '모델',
			allowBlank		: false,
			readOnly		: true,
			valueFieldName	: 'MODEL_CODE',
			textFieldName	: 'MODEL_NAME',
			DBvalueFieldName: 'MODEL_CODE',
			DBtextFieldName	: 'MODEL_NAME',
			width			: 350,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					revSearch.setValue('MODEL_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					revSearch.setValue('MODEL_NAME', newValue);
				}
			}
		}),{
			xtype		: 'uniRadiogroup',
			fieldLabel	: '&nbsp;',
			name		: 'INSPECT_TYPE',
			hideLabel	: true,
			allowBlank	: true,
			readOnly	: true,
			width		: 200,
			items		: getRadioGroupItems('CBS_AU_ZQ04', 'INSPECT_TYPE'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			tdAttrs		: {width:'100%'}
 		},{
			xtype		: 'button',
			text		: '추가',
			width		: 65,
			tdAttrs		: { style: 'padding-right: 5px;' },
			handler: function() {
				revWindow.fnNewData();
			}
 		},{
			xtype		: 'button',
			text		: '삭제',
			width		: 65,
			tdAttrs		: { style: 'padding-right: 5px;' },
			handler: function() {
				revWindow.fnDelData();
			}
 		},{
			xtype		: 'button',
			text		: '저장',
			width		: 65,
			handler: function() {
				revWindow.fnSaveData();
			}
		}]
	}); // createSearchForm

	/**
	 * query grid
	 */
	var revGrid = Unilite.createGrid('s_qbs100ukrv_mekRevGrid', {
		layout : 'fit',
		store  : revStore,
		uniOpt:{
			useLiveSearch		: true,
			useGroupSummary		: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true,			//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		columns: [
			{ dataIndex: 'COMP_CODE'			, width:100, hidden:true},
			{ dataIndex: 'MODEL'				, width:100, hidden:true},
			{ dataIndex: 'MODEL_NAME'			, width:100, hidden:true},
			{ dataIndex: 'INSPECT_TYPE'			, width:100, hidden:true},
			{ dataIndex: 'REV_NO'				, minWidth:150, flex: 1},
			{ dataIndex: 'START_DATE'			, minWidth:150, flex: 1},
			{ dataIndex: 'END_DATE'				, minWidth:150, flex: 1}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(record.phantom) {
					Unilite.messageBox('저장 후 선택 가능합니다.');
					return false;
				}
				
				revGrid.returnData(record);
				revWindow.hide();
			},
			beforeedit: function(editor, e, eOpts) {
				if(e.record.phantom == true){
					if (UniUtils.indexOf(e.field,['REV_NO', 'START_DATE'])){
						return true;
					}
					else {
						return false;
					}
				}
				else {
					return false;
				}
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			var field = revWindow.referer;
			
			field.setValue(record.get('REV_NO'));
			field.clearInvalid();
			field.focus();
		}
	});

	function openRevWindow(field) {
		if(!revWindow) {
			revWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="리비전조회 Popup"/>',
				width	: 800,
				height	: 500,
				layout	: {type:'vbox', align:'stretch'},
				items	: [revSearch, revGrid],
				tbar	: ['->',
					{
						itemId	: 'saveBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler : function() {
							revStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId	: 'OrderNoCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							revWindow.hide();
						},
						disabled: false
					}
				],
				referer: field,
				listeners : {
					beforehide: function(me, eOpt)	{
						revSearch.clearForm();
						revGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						revSearch.clearForm();
						revGrid.reset();
					},
					show: function(panel, eOpts)	{
						revSearch.setValue('MODEL_CODE'  , this.referer.refValues.MODEL_CODE);
						revSearch.setValue('MODEL_NAME'  , this.referer.refValues.MODEL_NAME);
						revSearch.setValue('INSPECT_TYPE', this.referer.refValues.INSPECT_TYPE);
						
						revSearch.getField('INSPECT_TYPE').setReadOnly(true);
						
						revStore.loadStoreRecords();
					}
				},
				fnNewData: function() {
					var r = {
						COMP_CODE		: UserInfo.compCode,
						MODEL			: revSearch.getValue('MODEL_CODE'),
						MODEL_NAME		: revSearch.getValue('MODEL_NAME'),
						INSPECT_TYPE	: revSearch.getValue('INSPECT_TYPE').INSPECT_TYPE,
						REV_NO			: '',
						START_DATE		: UniDate.get('today'),
						END_DATE		: '99991231'
					};
					
					revGrid.createRow(r);
				},
				fnDelData: function() {
					var record = revGrid.getSelectedRecord();
					var toCreate = revStore.getNewRecords();
					
					if(Ext.isEmpty(record)) {
						return;
					}
					
					if(record.phantom == true) {
						revGrid.deleteSelectedRow();
						return true;
					}
					
					if(UniDate.getDbDateStr(record.get('END_DATE')) != '99991231') {
						Unilite.messageBox('과거의 리비전은 삭제하실 수 없습니다.');
						return;
					}
					
					s_qbs100ukrv_mekService.checkForm(record.data, function(provider, response){
						if(!Ext.isEmpty(provider)) {
							if(Number(provider[0].CNT_RESULT) > 0) {
								Unilite.messageBox('양식이 등록된 리비전은 삭제하실 수 없습니다.');
							}
							else {
								revGrid.deleteSelectedRow();
							}
						}
					});
					
				},
				fnSaveData: function() {
					if(revStore.isDirty()) {
						revStore.saveStore();
					}
				}
			});
		}
		
		revWindow.referer = field;
		
		revWindow.show();
		revWindow.center();
	};
	
	
	/**
	 * copy form
	 */
	var copyCond = Unilite.createSearchForm('copyForm', {
		layout: { type: 'uniTable', columns : 2
				, tdAttrs: {style:'padding: 10px;'} },
		trackResetOnLoad: true,
		items: [{
			title	: '원본',
			xtype	: 'uniFieldset',
			padding	: '10 10 10 10',
			height	: 145,
			items: [Unilite.popup('MODEL_MICS',{
				fieldLabel		: '모델',
				allowBlank		: false,
				valueFieldName	: 'MODEL_CODE_FR',
				textFieldName	: 'MODEL_NAME_FR',
				DBvalueFieldName: 'MODEL_CODE_FR',
				DBtextFieldName	: 'MODEL_NAME_FR',
				width			: 320,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							 copyCond.setValue('MODEL_CODE_FR', records[0]["MODEL_CODE"]);
							 copyCond.setValue('MODEL_NAME_FR', records[0]["MODEL_NAME"]);
						 }
					},
					onClear: function(type)	{
						copyCond.setValue('MODEL_CODE_FR', '');
						copyCond.setValue('MODEL_NAME_FR', '');
					}
				}
			}),{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '&nbsp;',
				name		: 'INSPECT_TYPE_FR',
				hideLabel	: true,
				allowBlank	: true,
				width		: 240,
				padding		: '0 0 0 85',
				items		: getRadioGroupItems('CBS_AU_ZQ04', 'INSPECT_TYPE_FR'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="문서양식번호"/>',
				name		: 'REV_NO_FR',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				refValues	: {
					MODEL_CODE	: '',
					MODEL_NAME	: '',
					INSPECT_TYPE: ''
				},
				triggers: {
					popup: {
						cls: 'x-form-search-trigger',
						handler: function() {
							if(Ext.isEmpty(copyCond.getValue('MODEL_CODE_FR'))) {
								Unilite.messageBox('모델' + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
								return;
							}
							
							this.refValues.MODEL_CODE	= copyCond.getValue('MODEL_CODE_FR');
							this.refValues.MODEL_NAME	= copyCond.getValue('MODEL_NAME_FR');
							this.refValues.INSPECT_TYPE	= copyCond.getValue('INSPECT_TYPE_FR').INSPECT_TYPE_FR;
							
							openRevWindow(this);
						}
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="계측제목"/>',
				name		: 'SUBJECT_CODE_FR',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'ZQ01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			title	: '대상',
			xtype	: 'uniFieldset',
			padding	: '10 10 10 10',
			height	: 145,
			items	: [Unilite.popup('MODEL_MICS',{
				fieldLabel		: '모델',
				allowBlank		: false,
				valueFieldName	: 'MODEL_CODE_TO',
				textFieldName	: 'MODEL_NAME_TO',
				DBvalueFieldName: 'MODEL_CODE_TO',
				DBtextFieldName	: 'MODEL_NAME_TO',
				width			: 320,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							 copyCond.setValue('MODEL_CODE_TO', records[0]["MODEL_CODE"]);
							 copyCond.setValue('MODEL_NAME_TO', records[0]["MODEL_NAME"]);
						 }
					},
					onClear: function(type)	{
						copyCond.setValue('MODEL_CODE_TO', '');
						copyCond.setValue('MODEL_NAME_TO', '');
					}
				}
			}),{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '&nbsp;',
				name		: 'INSPECT_TYPE_TO',
				hideLabel	: true,
				allowBlank	: true,
				width		: 240,
				padding		: '0 0 0 85',
				items		: getRadioGroupItems('CBS_AU_ZQ04', 'INSPECT_TYPE_TO'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="문서양식번호"/>',
				name		: 'REV_NO_TO',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				refValues	: {
					MODEL_CODE	: '',
					MODEL_NAME	: '',
					INSPECT_TYPE: ''
				},
				triggers: {
					popup: {
						cls: 'x-form-search-trigger',
						handler: function() {
							if(Ext.isEmpty(copyCond.getValue('MODEL_CODE_TO'))) {
								Unilite.messageBox('모델' + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
								return;
							}
							
							this.refValues.MODEL_CODE	= copyCond.getValue('MODEL_CODE_TO');
							this.refValues.MODEL_NAME	= copyCond.getValue('MODEL_NAME_TO');
							this.refValues.INSPECT_TYPE	= copyCond.getValue('INSPECT_TYPE_TO').INSPECT_TYPE_TO;
							
							openRevWindow(this);
						}
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="계측제목"/>',
				name		: 'SUBJECT_CODE_TO',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'ZQ01',
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype		: 'component',
				html		: '&nbsp;'
			}]
		},{
			xtype		: 'uniDetailForm',
			disabled	: false,
			layout: {
				type: 'table', columns:1
				, tableAttrs: {align:'center'}
				, tdAttrs: {align:'center'}
			},
			padding		: '0 0 20 0',
			colspan		: 2,
			items:[{
				xtype		: 'button',
				text		: '실행',
				width		: 100,
				handler: function() {
					var param = copyCond.getValues();
					param.COMP_CODE	= UserInfo.compCode;
					
					s_qbs100ukrv_mekService.copyForm(param, function(provider, response){
						if(!Ext.isEmpty(provider)) {
							Unilite.messageBox('복사가 완료되었습니다.');
						}
					});
				}
			}]
		}]
	}); // createSearchForm

	function openCopyWindow() {
		if(!copyWindow) {
			copyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="양식 복사"/>',
				width	: 755,
				height	: 300,
				layout	: {type:'vbox', align:'stretch'},
				items	: [copyCond],
				tbar	: ['->',
					{
						itemId	: 'OrderNoCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							copyWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						copyCond.clearForm();
					},
					beforeclose: function(panel, eOpts)	{
						copyCond.clearForm();
					},
					show: function(panel, eOpts)	{
						copyCond.setValue('MODEL_CODE_FR'	, panelSearch.getValue('MODEL_CODE'));
						copyCond.setValue('MODEL_NAME_FR'	, panelSearch.getValue('MODEL_NAME'));
						copyCond.setValue('INSPECT_TYPE_FR'	, panelSearch.getValue('INSPECT_TYPE').INSPECT_TYPE);
						copyCond.setValue('REV_NO_FR'		, panelSearch.getValue('REV_NO'));
						
						copyCond.setValue('INSPECT_TYPE_TO'	, copyCond.getField('INSPECT_TYPE_TO').getBoxes()[0].inputValue);
					}
				}
			});
		}
		copyWindow.show();
		copyWindow.center();
	};
	
	var remarkProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs100ukrv_mekService.selectRemarkList'
		}
	});
	
	/**
	 * query model
	 */
	Unilite.defineModel('remarkModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="" default="법인코드"/>'			, type: 'string'},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'			, type: 'string'},
			{name: 'MODEL_NAME'			, text: '<t:message code="" default="모델명"/>'			, type: 'string'},
			{name: 'SUBJECT_CODE'		, text: '<t:message code="" default="계측제목"/>'			, type: 'string'	, comboType	: 'AU'	, comboCode	: 'ZQ01'},
			{name: 'DATA_GUBUN'			, text: '<t:message code="" default="구분"/>'				, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="" default="내용"/>'				, type: 'string'}
		]
	});

	/**
	 * remark store
	 */
	var remarkStore = Unilite.createStore('remarkStore', {
		model	: 'remarkModel',
		autoLoad: false,
		uniOpt	: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : false,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api : {
				read	: 's_qbs100ukrv_mekService.selectRemarkList'
			}
		},
		loadStoreRecords : function()	{
			var param = remarkSearch.getValues();
			
			if(remarkWindow.referer.dataIndex == 'ITEMS') {
				param.DATA_GUBUN = '01';
			}
			else if(remarkWindow.referer.dataIndex == 'CHECK_POINT') {
				param.DATA_GUBUN = '02';
			}
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * remark search
	 */
	var remarkSearch = Unilite.createSearchForm('remarkSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [Unilite.popup('MODEL_MICS',{
			fieldLabel		: '모델',
			allowBlank		: false,
			readOnly		: true,
			valueFieldName	: 'MODEL_CODE',
			textFieldName	: 'MODEL_NAME',
			DBvalueFieldName: 'MODEL_CODE',
			DBtextFieldName	: 'MODEL_NAME',
			width			: 350,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
				}
			}
		}),{
			fieldLabel	: '<t:message code="" default="계측제목"/>',
			name		: 'SUBJECT_CODE',
			xtype		: 'uniCombobox',
			allowBlank	: false,
			readOnly	: true,
			comboType	: 'AU',
			comboCode	: 'ZQ01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',
			name		: 'TXT_SEARCH',
			xtype		: 'uniTextfield',
			colspan		: 2,
			width		: 500,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
				}
			}
		}]
	}); // createSearchForm

	/**
	 * query grid
	 */
	var remarkGrid = Unilite.createGrid('s_qbs100ukrv_mekRemarkGrid', {
		layout : 'fit',
		store  : remarkStore,
		uniOpt:{
			useLiveSearch		: true,
			useGroupSummary		: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			filter: {
				useFilter		: false,
				autoCreate		: false
			}
		},
		columns: [
			{ dataIndex: 'COMP_CODE'			, width:100, hidden:true},
			{ dataIndex: 'MODEL'				, width:100, hidden:true},
			{ dataIndex: 'MODEL_NAME'			, width:120},
			{ dataIndex: 'SUBJECT_CODE'			, width:150},
			{ dataIndex: 'DATA_GUBUN'			, width:100, hidden:true},
			{ dataIndex: 'REMARK'				, minWidth:150, flex: 1}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				remarkGrid.returnData(record);
				remarkWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			var field = remarkWindow.referer;
			var mRow = masterGrid.getSelectedRecord();
			
			mRow.set(field.dataIndex, record.get('REMARK'));
		}
	});

	function openRemarkWindow(field) {
		if(!remarkWindow) {
			remarkWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="Items/Check 조회 Popup"/>',
				width	: 800,
				height	: 500,
				layout	: {type:'vbox', align:'stretch'},
				items	: [remarkSearch, remarkGrid],
				tbar	: ['->',
					{
						itemId	: 'saveBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler : function() {
							remarkStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="확인"/>',
						handler : function() {
							remarkGrid.returnData(record);
							remarkWindow.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							remarkWindow.hide();
						},
						disabled: false
					}
				],
				referer: field,
				listeners : {
					beforehide: function(me, eOpt)	{
						remarkSearch.clearForm();
						remarkGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						remarkSearch.clearForm();
						remarkGrid.reset();
					},
					show: function(panel, eOpts)	{
						var mRow = masterGrid.getSelectedRecord();
						
						remarkSearch.setValue('MODEL_CODE'  , panelSearch.getValue('MODEL_CODE'));
						remarkSearch.setValue('MODEL_NAME'  , panelSearch.getValue('MODEL_NAME'));
						remarkSearch.setValue('SUBJECT_CODE', mRow.get('SUBJECT_CODE'));
						
						remarkStore.loadStoreRecords();
					}
				}
			});
		}
		
		remarkWindow.referer = field;
		
		remarkWindow.show();
		remarkWindow.center();
	};
	
}

</script>