<%--
'   프로그램명 : 1차CAL-측정데이타
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
<t:appConfig pgmId="s_qbs200ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ05" />				<!-- 성적서 검사진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P509" />				<!-- 공정검사자 -->
	<t:ExtComboStore comboType="AU" comboCode="ZQ02" />				<!-- 시험성적서-타이틀유형 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

div .x-grid-widgetcolumn-cell-inner {padding: 0px;}
</style>

<script type="text/javascript">

var labViewWindow;
var resultWindow;

function appMain() {
	
	var glFixedColCount = 1;
	var glFormColumnCount = 2;
	fnGetColumnCount();
	
	var gsColumnList = ${gsColumnList};
	
	var directMachProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs200ukrv_mekService.selectListMach',
			create  : 's_qbs200ukrv_mekService.insertMach',
			destroy : 's_qbs200ukrv_mekService.deleteMach',
			syncAll : 's_qbs200ukrv_mekService.saveAllMach'
		}
	});
	
	var directBadProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs200ukrv_mekService.selectListBad',
			update  : 's_qbs200ukrv_mekService.updateBad',
			syncAll : 's_qbs200ukrv_mekService.saveAllBad'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('s_qbs200ukrv_mekModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank:false},
			{name: 'INSPECT_NO'			, text: '<t:message code="" default="INSPECT_NO"/>'									, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'										, type: 'string'},
			{name: 'MODEL_NAME'			, text: '<t:message code="" default="모델"/>'											, type: 'string'},
			{name: 'REV_NO'				, text: '<t:message code="" default="REV_NO"/>'										, type: 'string'},
			{name: 'STATUS'				, text: '<t:message code="system.label.purchase.status" default="진행상테"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'ZQ05'},
			{name: 'WKORD_NUM'			, text: '<t:message code="" default="작업지시번호"/>'										, type: 'string'}
		]
	});
	
	/**
	 * Machine grid Model
	 */
	Unilite.defineModel('s_qbs200ukrv_mekMachModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank:false},
			{name: 'SEQ'				, text: '<t:message code="" default="SEQ"/>'										, type: 'int'		, allowBlank:false},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'										, type: 'string'	, allowBlank:false},
			{name: 'WORK_DATE'			, text: '<t:message code="" default="작업일"/>'										, type: 'uniDate'	, allowBlank:false},
			{name: 'SORT_ORDER'			, text: '<t:message code="" default="SEQ"/>'										, type: 'int'},
			{name: 'MACHINE_CODE'		, text: '<t:message code="" default="계측기코드"/>'										, type: 'string'	, allowBlank:false},
			{name: 'MACHINE_NAME'		, text: '<t:message code="" default="계측기"/>'										, type: 'string'	, allowBlank:false},
			{name: 'WORK_USER'			, text: '<t:message code="" default="검사자"/>'										, type: 'string'	, allowBlank:false},
			{name: 'USE_YN'				, text: '<t:message code="system.label.purchase.useyn" default="사용여부"/>'			, type: 'string'}
		]
	});
	
	/**
	 * Machine grid Model
	 */
	Unilite.defineModel('s_qbs200ukrv_mekBadModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'BAD_CODE'			, text: '<t:message code="" default="불량코드"/>'										, type: 'string'	, allowBlank:false},
			{name: 'BAD_NAME'			, text: '<t:message code="" default="불량명"/>'										, type: 'string'	, allowBlank:false},
			{name: 'INSPECT_NO'			, text: '<t:message code="" default="Inspection No"/>'								, type: 'string'},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="" default="검사유형"/>'										, type: 'string'},
			{name: 'INSPECT_DATE'		, text: '<t:message code="" default="검사일"/>'										, type: 'uniDate'},
			{name: 'BAD_Q'				, text: '<t:message code="" default="불량"/>'											, type: 'int'},
			{name: 'REASON'				, text: '<t:message code="" default="증상"/>'											, type: 'string'},
			{name: 'INSPECT_VALUE'		, text: '<t:message code="" default="세부수치"/>'										, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore1 = Unilite.createStore('s_qbs200ukrv_mekMasterStore1', {
		model : 's_qbs200ukrv_mekModel1',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : false,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: {
			type: 'direct',
			api : {
				read	: 's_qbs200ukrv_mekService.selectList1'
			}
		},
		loadStoreRecords: function(){
			var param = panelSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * Machine grid store
	 */
	var directMachStore = Unilite.createStore('s_qbs200ukrv_mekMachStore1', {
		model : 's_qbs200ukrv_mekMachModel1',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directMachProxy,
		loadStoreRecords: function(){
			var param = inspectSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = inspectSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directMachStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				machGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					var record = records[0];
					
					inspectSearch.setValue('WORK_DATE', record.get('WORK_DATE'));
					inspectSearch.setValue('WORK_USER', record.get('WORK_USER'));
					
					inspectSearch.setAllFieldsReadOnly(true);
				}
				else {
					inspectSearch.setAllFieldsReadOnly(false);
				}
			}
		}
	});
	
	/**
	 * Machine grid store
	 */
	var directBadStore = Unilite.createStore('s_qbs200ukrv_mekBadStore1', {
		model : 's_qbs200ukrv_mekBadModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directBadProxy,
		loadStoreRecords: function(){
			var param = inspectSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = inspectSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directBadStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				machGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			items: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				//holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				//holdable	: 'hold',
				store		: Ext.getStore('wsList'),
		 		allowBlank	: false,
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="" default="작업일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'WORK_DATE_FR',
				endFieldName	: 'WORK_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_DATE_TO', newValue);
				}
			},{
				fieldLabel	: '<t:message code="" default="Inspection No"/>',
				name		: 'INSPECT_NO',
				xtype		: 'uniTextfield',
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPECT_NO', newValue);
					}
				}
			},{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '진행상태',
				name		: 'STATUS',
				//holdable	: 'hold',
				items		: [{
					boxLabel	: '전체',
					inputValue	: '',
					name		: 'STATUS'
				},{
					boxLabel	: '미검사(수리완료)',
					inputValue	: 'R',
					name		: 'STATUS'
				},{
					boxLabel	: '전체',
					inputValue	: 'Q',
					name		: 'STATUS'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STATUS', newValue.STATUS);
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			//holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			//holdable	: 'hold',
			store		: Ext.getStore('wsList'),
	 		allowBlank	: false,
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="" default="작업일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'WORK_DATE_FR',
			endFieldName	: 'WORK_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('WORK_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('WORK_DATE_TO', newValue);
			}
		},{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPECT_NO', newValue);
				}
			}
		},{
			xtype		: 'uniRadiogroup',
			fieldLabel	: '진행상태',
			name		: 'STATUS',
			//holdable	: 'hold',
			colspan		: 2,
			items		: [{
				boxLabel	: '전체',
				name		: 'STATUS',
				inputValue	: '',
				width		: 70
			},{
				boxLabel	: '미검사(수리완료)',
				name		: 'STATUS',
				inputValue	: 'R',
				width		: 130
			},{
				boxLabel	: '검사',
				name		: 'STATUS',
				inputValue	: 'Q',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('STATUS', newValue.STATUS);
				}
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * masterGrid
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region: 'west',
		flex  : 1,
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
			}
		},
		store: directMasterStore1,
		sortableColumns : false,
		selModel: 'rowmodel',
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'INSPECT_NO'	, width: 100},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, minWidth: 150, flex: 1},
			{dataIndex: 'MODEL'			, width: 100, hidden: true},
			{dataIndex: 'MODEL_NAME'	, width: 120},
			{dataIndex: 'REV_NO'		, width: 100, hidden: true},
			{dataIndex: 'STATUS'		, width: 100},
			{dataIndex: 'WKORD_NUM'		, width: 100, hidden: true}
		],
		listeners: {
			selectionchangerecord: function(record) {
				inspectSearch.setValue('INSPECT_NO'	, record.get('INSPECT_NO'));
				inspectSearch.setValue('DIV_CODE'	, record.get('DIV_CODE'));
				inspectSearch.setValue('MODEL'		, record.get('MODEL'));
				inspectSearch.setValue('WKORD_NUM'	, record.get('WKORD_NUM'));
				inspectSearch.setValue('REV_NO'		, record.get('REV_NO'));
				
				directMachStore.loadStoreRecords();
				directBadStore.loadStoreRecords();
			}
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * machGrid
	 */
	var machGrid = Unilite.createGrid('machGrid', {
		layout	: 'fit',
		region	: 'north',
		flex	: 1,
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMachStore,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SEQ'			, width: 100, hidden: true},
			{dataIndex: 'MODEL'			, width: 100, hidden: true},
			{dataIndex: 'WORK_DATE'		, width: 100, hidden: true},
			{dataIndex: 'MACHINE_CODE'	, width: 100, hidden: true},
			{dataIndex: 'SORT_ORDER'	, width: 100},
			{dataIndex: 'MACHINE_NAME'	, minWidth: 100, flex: 1,
				editor: Unilite.popup('EQU_MOLD_CODE_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type) {
							var grdRecord = machGrid.uniOpt.currentRecord;
							grdRecord.set('MACHINE_CODE',records[0]['EQU_MOLD_CODE']);
							grdRecord.set('MACHINE_NAME',records[0]['EQU_MOLD_NAME']);
						},
						onClear:function(type) {
							var grdRecord = machGrid.uniOpt.currentRecord;
							grdRecord.set('MACHINE_CODE','');
							grdRecord.set('MACHINE_NAME','');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': inspectSearch.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex: 'WORK_USER'		, width: 100, hidden: true},
			{dataIndex: 'USE_YN'		, width:  70, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(e.record.phantom) {
					return true;
				}
				
				return false;
			}
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * machGrid
	 */
	var badGrid = Unilite.createGrid('badGrid', {
		layout	: 'fit',
		region	: 'north',
		flex	: 3,
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directBadStore,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'BAD_CODE'		, width:  80},
			{dataIndex: 'BAD_NAME'		, width: 150},
			{dataIndex: 'INSPECT_NO'	, width: 100, hidden: true},
			{dataIndex: 'INSPECT_TYPE'	, width: 100, hidden: true},
			{dataIndex: 'INSPECT_DATE'	, width: 100, hidden: true},
			{dataIndex: 'BAD_Q'			, width: 100},
			{dataIndex: 'REASON'		, minWidth: 200, flex: 1},
			{dataIndex: 'INSPECT_VALUE'	, width: 120}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['BAD_Q', 'REASON', 'INSPECT_VALUE'])) {
					return true;
				}
				
				return false;
			}
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	var inspectSearch = Unilite.createSearchForm('inspectSearchForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4, tableAttrs:{width:'100%'}},
		padding	: '1 1 1 1',
		border	: false,
		items: [{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
			readOnly	: true,
			width		: 250
		},{
			fieldLabel	: '<t:message code="" default="작업일"/>',
			name		: 'WORK_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			width		: 220
		},{
			fieldLabel	: '<t:message code="" default="검사자"/>',
			name		: 'WORK_USER',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'P509',
			allowBlank	: false,
			//holdable	: 'hold',
			width		: 250,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(directMachStore.isDirty()) {
						Ext.Msg.show({
							title:UniUtils.getMessage('system.message.commonJS.baseApp.confirm','확인'),
							msg:  UniUtils.getMessage('system.message.commonJS.baseApp.dirty','내용이 변경되었습니다.') + "\n" 
								+ UniUtils.getMessage('system.message.commonJS.baseApp.confirmSave','변경된 내용을 저장하시겠습니까?'),
							buttons: Ext.Msg.YESNOCANCEL,
							icon: Ext.Msg.QUESTION,
							fn: function(res) {
								//console.log(res);
								if (res === 'yes') {
									directMachStore.saveStore();
									directMachStore.loadStoreRecords();
								}
								else {
									field.value = oldValue;
									if(res === 'no') {
										directMachStore.loadStoreRecords();
									}
								}
							}
						});
					}
					else {
						directMachStore.loadStoreRecords();
					}
				}
			}
		},{
			xtype	: 'component',
			html	: '&nbsp;',
			tdAttrs	: {width:'100%'}
		},{
			fieldLabel	: '<t:message code="" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="MODEL"/>',
			name		: 'MODEL',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="WKORD_NUM"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="REV_NO"/>',
			name		: 'REV_NO',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			xtype	: 'uniDetailForm',
			layout	: {type: 'uniTable', columns: 4},
			colspan	: 4,
			disabled: false,
			items	: [{
				xtype	: 'component',
				html	: '&nbsp;',
				tdAttrs	: {width:'100%'}
			},{
				xtype	: 'button',
				text	: '추가',
				width	: 65,
				tdAttrs	: { style: 'padding-right: 5px;' },
				handler	: function() {
					if(inspectSearch.setAllFieldsReadOnly(true)) {
						var maxSeq = 0;
						
						Ext.each(directMachStore.data.items, function(record) {
							if(Number(record.get('SEQ')) > maxSeq) {
								maxSeq = Number(record.get('SEQ'));
							}
						});
						
						var r = {
							COMP_CODE		: UserInfo.compCode,
							DIV_CODE		: inspectSearch.getValue('DIV_CODE'),
							SEQ				: -1,
							MODEL			: inspectSearch.getValue('MODEL'),
							WORK_DATE		: inspectSearch.getValue('WORK_DATE'),
							MACHINE_CODE	: '',
							SORT_ORDER		: (maxSeq + 1),
							MACHINE_NAME	: '',
							WORK_USER		: inspectSearch.getValue('WORK_USER'),
							USE_YN			: 'Y'
						};
						
						machGrid.createRow(r);
					}
				}
			},{
				xtype	: 'button',
				text	: '삭제',
				width	: 65,
				tdAttrs	: { style: 'padding-right: 5px;' },
				handler	: function() {
					var row = machGrid.getSelectedRecord();
					
					if(row.phantom === true)	{
						machGrid.deleteSelectedRow();
					}
					else {
						Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
							if (btn == 'yes') {
								machGrid.deleteSelectedRow();
								
								if(directMachStore.getCount() < 1) {
									inspectSearch.setAllFieldsReadOnly(false);
								}
							}
						});
					}
					
					if(directMachStore.getCount() < 1) {
						inspectSearch.setAllFieldsReadOnly(false);
					}
				}
			},{
				xtype	: 'button',
				text	: '저장',
				width	: 65,
				handler	: function() {
					directMachStore.saveStore();
				}
			}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	var inspectResult = Unilite.createSearchForm('inspectResultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5, tableAttrs:{width:'100%'}},
		padding	: '20 1 25 1',
		border	: false,
		items: [{
			xtype	: 'component',
			html	: '&nbsp;',
			tdAttrs	: {width:'50%'}
		},{
			xtype	: 'button',
			text	: '1. LAB VIEW 데이터 적용',
			width	: 180,
			tdAttrs	: { style: 'padding-right: 10px;' },
			handler	: function() {
				openLabViewWindow();
			}
		},{
			xtype	: 'button',
			text	: '2. 측정 데이터 확인',
			width	: 180,
			tdAttrs	: { style: 'padding-right: 10px;' },
			handler	: function() {
				var mRow = masterGrid.getSelectedRecord();
				if(Ext.isEmpty(mRow)) {
					return;
				}
				
				if(Ext.isEmpty(masterGrid.getSelectedRecord().get('MODEL'))) {
					Unilite.messageBox('품목 마스터에 모델코드가 지정되지 않았습니다. 품목정보등록에서 해당품목의 모델코드 지정 후 재조회하여 작업하시기 바랍니다.');
					return;
				}
				
				if(Ext.isEmpty(masterGrid.getSelectedRecord().get('REV_NO'))) {
					Unilite.messageBox('지정된 모델의 시험성적서 양식이 등록되지 않았습니다. 양식 등록 후 재조회하여 작업하시기 바랍니다.');
					return;
				}
				
				if(directMachStore.getCount() < 1) {
					Unilite.messageBox('등록된 계측기가 없습니다. 검사결과 등록 전 계측기를 먼저 등록하여 주시기 바랍니다.');
					return;
				}
				
				if(directMachStore.isDirty()) {
					Unilite.messageBox('저장되지 않은 계측기 정보가 있습니다. 계측기 저장 후 등록하여 주시기 바랍니다.');
					return;
				}
				
//				if(mRow.get('STATUS') == 'RR') {
//					Unilite.messageBox('수리신청된 검사에 대해서는 결과 등록을 하실 수 없습니다.');
//					return;
//				}
				
				openResultWindow();
			}
		},{
			xtype	: 'button',
			text	: '3. 수리신청',
			width	: 180,
			tdAttrs	: { style: 'padding-right: 10px;' },
			handler	: function() {
				if(directMasterStore1.getCount() < 1) {
					return;
				}
				
				var param = {
					DIV_CODE		: inspectSearch.getValue('DIV_CODE'),
					INSPECT_NO		: inspectSearch.getValue('INSPECT_NO'),
					MODEL			: inspectSearch.getValue('MODEL'),
					REV_NO			: inspectSearch.getValue('REV_NO'),
					INSPECT_TYPE	: 'C',
					REQ_DATE		: UniDate.getDbDateStr(inspectSearch.getValue('WORK_DATE'))
				};
				
				s_qbs200ukrv_mekService.checkRepair(param, function(provider, response){
					if(!Ext.isEmpty(provider)) {
						if(provider.CHECK_RESULT == 'Y') {
							Unilite.messageBox('수리요청 등록되었습니다.');
							
							var mRow = masterGrid.getSelectedRecord();
							mRow.set('STATUS', 'RR');
							directMasterStore1.commitChanges();
						}
						else {
							Unilite.messageBox(provider.CHECK_RESULT);
						}
					}
				});
			}
		},{
			xtype	: 'component',
			html	: '&nbsp;',
			tdAttrs	: {width:'50%'}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	var inspectForm = Unilite.createSimpleForm('inspectForm', {
		region	: 'center',
		layout	: {type:'vbox', align:'stretch'},
		flex	: 2,
		border	: true,
		scrollable:true,
		items:[inspectSearch, machGrid, inspectResult, badGrid]
	});
	
	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, panelResult, inspectForm
			]
		},
			panelSearch
		],
		id : 's_qbs200ukrv_mekApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelSearch.setValue('WORK_DATE_FR'	, UniDate.get("aMonthAgo"));
			panelResult.setValue('WORK_DATE_FR'	, UniDate.get("aMonthAgo"));
			
			panelSearch.setValue('WORK_DATE_TO'	, UniDate.get("today"));
			panelResult.setValue('WORK_DATE_TO'	, UniDate.get("today"));
			
			panelSearch.setValue('STATUS'		, '');
			panelResult.setValue('STATUS'		, '');
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
		},
		fnSetDefault : function() {
			inspectSearch.setValue('WORK_DATE', UniDate.get("today"));
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) && panelResult.setAllFieldsReadOnly(true)) {
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function(itemCode, orderType)	{
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			machGrid.reset();
			machGrid.getStore().clearData();
			
			badGrid.reset();
			badGrid.getStore().clearData();
			
			inspectSearch.clearForm();
			resultSearch.clearForm();
			
			resultGrid.reset();
			resultGrid.getStore().clearData();
			
			labViewWindow = null;
			resultWindow = null;
			
			this.fnInitBinding();
			this.fnSetDefault();
		},
		onSaveDataButtonDown: function(config) {
			if(directMachStore.isDirty()) {
				directMachStore.saveStore();
			}
			if(directBadStore.isDirty()) {
				directBadStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
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
			
			switch(fieldName) {
			}
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
	
	function openLabViewWindow() {
		if(Ext.isEmpty(masterGrid.getSelectedRecord())) {
			return;
		}
		
		if(!labViewWindow) {
			labViewWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="LAB VIEW 결과 복사"/>',
				width	: 800,
				height	: 600,
				layout	: {type:'vbox', align:'stretch'},
				items	: [{
					itemId:'labViewCondition',
					xtype:'uniSearchForm',
					style:{
						'background':'#fff'
					},
					layout:{type:'uniTable', columns:1},
					margine:'3 3 3 3',
					items:[{
						fieldLabel	: '<t:message code="" default="사업장"/>',
						name		: 'DIV_CODE',
						xtype		: 'uniTextfield',
						hidden		: true
					},{
						fieldLabel	: '<t:message code="" default="MODEL"/>',
						name		: 'MODEL',
						xtype		: 'uniTextfield',
						hidden		: true
					},{
						fieldLabel	: '<t:message code="" default="INSPECT_NO"/>',
						name		: 'INSPECT_NO',
						xtype		: 'uniTextfield',
						hidden		: true
					},{
						fieldLabel	: '<t:message code="" default="WKORD_NUM"/>',
						name		: 'WKORD_NUM',
						xtype		: 'uniTextfield',
						hidden		: true
					},{
						fieldLabel	: '<t:message code="" default="LAB VIEW DATA"/>',
						name		: 'LABVIEW_DATA',
						xtype		: 'textareafield',
						width		: 770,
						labelWidth	: 100,
						height		: 470
					},{
						xtype		: 'button',
						text		: '저장',
						width		: 120,
						margin		: '20 0 20 340',
						handler		: function() {
							var lvCond = labViewWindow.down('#labViewCondition');
							
							//	저장로직 구현해야함.
							
							labViewWindow.hide();
						}
					}]
				}],
				tbar	: ['->',
					{
						itemId	: 'labViewWinCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							labViewWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						labViewWindow.down('#labViewCondition').clearForm();
					},
					beforeclose: function(panel, eOpts)	{
						labViewWindow.down('#labViewCondition').clearForm();
					},
					show: function(panel, eOpts)	{
						var lvCond = labViewWindow.down('#labViewCondition');
						
						lvCond.setValue('DIV_CODE'	, inspectSearch.getValue('DIV_CODE'));
						lvCond.setValue('MODEL'		, inspectSearch.getValue('MODEL'));
						lvCond.setValue('INSPECT_NO', inspectSearch.getValue('INSPECT_NO'));
						lvCond.setValue('WKORD_NUM'	, inspectSearch.getValue('WKORD_NUM'));
						
					}
				}
			});
		}
		labViewWindow.show();
		labViewWindow.center();
	}
	
	var directResultProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs200ukrv_mekService.selectListResult',
			update  : 's_qbs200ukrv_mekService.updateResultDetail',
			syncAll : 's_qbs200ukrv_mekService.saveAllResult'
		}
	});
	
	/**
	 * Result grid Model
	 */
	Unilite.defineModel('s_qbs200ukrv_mekResultModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'										, type: 'string'},
			{name: 'REV_NO'				, text: '<t:message code="" default="REV_NO"/>'										, type: 'string'},
			{name: 'ITEM_NO'			, text: '<t:message code="" default="ITEM_NO"/>'									, type: 'string'},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="" default="검사유형"/>'										, type: 'string'},
			{name: 'SUBJECT_CODE'		, text: '<t:message code="" default="계측코드"/>'										, type: 'string'},
			{name: 'SUBJECT_TITLE'		, text: '<t:message code="" default="계측제목"/>'										, type: 'string'},
			{name: 'TITLE_TYPE'			, text: '<t:message code="" default="양식유형"/>'										, type: 'string'},
			{name: 'INSPECT_NO'			, text: '<t:message code="" default="Inspection No"/>'								, type: 'string'},
			{name: 'NO'					, text: '<t:message code="" default="NO"/>'											, type: 'string'},
			{name: 'ITEMS'				, text: '<t:message code="" default="ITEMS"/>'										, type: 'string'},
			{name: 'CHECK_POINT'		, text: '<t:message code="" default="CHECK_POINT"/>'								, type: 'string'},
			{name: 'STANDARD'			, text: '<t:message code="" default="STANDARD"/>'									, type: 'string'},
			{name: 'LOTNO'				, text: '<t:message code="" default="LOTNO"/>'										, type: 'string'},
			{name: 'NUM_VALUE'			, text: '<t:message code="" default="NUM_VALUE"/>'									, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="" default="SPEC"/>'										, type: 'string'},
			{name: 'MEASURE_VALUE'		, text: '<t:message code="" default="MEASURE_VALUE"/>'								, type: 'string'},
			{name: 'RE_MEASURE_VALUE'	, text: '<t:message code="" default="RE_MEASURE_VALUE"/>'							, type: 'string'},
			{name: 'FIRST_CAL'			, text: '<t:message code="" default="FIRST_CAL"/>'									, type: 'string'},
			{name: 'FACTORY_TOL'		, text: '<t:message code="" default="FACTORY_TOL"/>'								, type: 'string'},
			{name: 'UNIT'				, text: '<t:message code="" default="UNIT"/>'										, type: 'string'},
			{name: 'INSPECT_RESULT'		, text: '<t:message code="" default="INSPECT_RESULT"/>'								, type: 'string'},
			{name: 'RE_INSPECT_RESULT'	, text: '<t:message code="" default="RE_INSPECT_RESULT"/>'							, type: 'string'},
			{name: 'INSPECT_RESULT_TYPE', text: '<t:message code="" default="INSPECT_RESULT_TYPE"/>'						, type: 'string'},
			{name: 'SORT_SEQ'			, text: '<t:message code="" default="정렬순서"/>'										, type: 'string'},
			{name: 'MEASURE_VAR'		, text: '<t:message code="" default="계측기변수"/>'										, type: 'string'}
		]
	});
	
	/**
	 * Result grid store
	 */
	var directResultStore = Unilite.createStore('s_qbs200ukrv_mekResultStore1', {
		model : 's_qbs200ukrv_mekResultModel1',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directResultProxy,
		loadStoreRecords: function(){
			var param = resultSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = resultSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directResultStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				machGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					var type = records[0].get('TITLE_TYPE');
					resultGrid.setColumnDisplay(type);
				}
				else {
					resultGrid.setColumnDisplay('');
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(operation == 'edit' && UniUtils.indexOf('NUM_VALUE', modifiedFieldNames)) {
					record.set('MEASURE_VALUE', record.get('NUM_VALUE'));
				}
				
				return true;
			}
		}
	});
	
	/**
	 * result search
	 */
	var resultSearch = Unilite.createSearchForm('resultSearchForm', {
		layout: {type: 'uniTable', columns : 4},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
			readOnly	: true
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			tdAttrs		: {width:'100%'}
		},{
			xtype		: 'button',
			itemId		: 'btnInit',
			text		: '초기화',
			width		: 65,
			tdAttrs		: { style: 'padding-right: 5px;' },
			handler: function() {
				resultWindow.fnDelData();
			}
		},{
			xtype		: 'button',
			itemId		: 'btnSave',
			text		: '저장',
			width		: 65,
			handler: function() {
				resultWindow.fnSaveData();
			}
		},{
			fieldLabel	: '<t:message code="" default="사업장코드"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="모델코드"/>',
			name		: 'MODEL',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="리비전"/>',
			name		: 'REV_NO',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="품목코드"/>',
			name		: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="검사일"/>',
			name		: 'WORK_DATE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="검사자"/>',
			name		: 'WORK_USER',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="작업지시번호"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="COMP_CODE"/>',
			name		: 'COMP_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		}]
	}); // createSearchForm

	/**
	 * resultGrid
	 */
	var resultGrid = Unilite.createGrid('resultGrid', {
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
				useFilter	: true,
				autoCreate	: true
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		editable: true,
		store: directResultStore,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true},
			{dataIndex: 'ITEM_NO'				, width: 100, hidden: true},
			{dataIndex: 'MODEL'					, width: 100, hidden: true},
			{dataIndex: 'REV_NO'				, width: 100, hidden: true},
			{dataIndex: 'INSPECT_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'SUBJECT_CODE'			, width:  80, hidden: true},
			{dataIndex: 'SUBJECT_TITLE'			, width:  80, hidden: true},
			{dataIndex: 'TITLE_TYPE'			, width:  80, hidden: true},
			{dataIndex: 'NO'					, width:  70},
			{dataIndex: 'ITEMS'					, minWidth: 300, flex:1},
			{dataIndex: 'CHECK_POINT'			, minWidth: 300, flex:1, hidden: true},
			{dataIndex: 'STANDARD'				, minWidth: 300, flex:1, hidden: true},
			{dataIndex: 'LOTNO'					, width: 150, hidden: true},
			{dataIndex: 'NUM_VALUE'				, width: 100, hidden: true},
			{dataIndex: 'SPEC'					, minWidth: 300, flex:1, hidden: true},
			{dataIndex: 'MEASURE_VALUE'			, width: 150, hidden: true},
			{dataIndex: 'RE_MEASURE_VALUE'		, width: 150, hidden: true},
			{dataIndex: 'FIRST_CAL'				, width: 150, hidden: true},
			{dataIndex: 'FACTORY_TOL'			, width: 150, hidden: true},
			{dataIndex: 'UNIT'					, width: 150, hidden: true},
			{dataIndex: 'INSPECT_RESULT'		, width: 150, hidden: true},
			{
				text: 'INSPECT_RESULT',
				width: 200,
				xtype: 'widgetcolumn',
				padding: 0,
				dataIndex: 'INSPECT_RESULT_DYNAMIC',
				hidden: true,
				onWidgetAttach: function (column, widget, record) {
					var type = record.get('INSPECT_RESULT_TYPE');
					if(type == 'A') {
						widget.items.items[0].show();
						widget.items.items[0].recordId = record.id;
						if(Ext.isEmpty(record.get('INSPECT_RESULT'))) {
							Ext.each(widget.items.items[0].items.items, function(item){
								item.setValue(false);
							});
						}
						else {
							widget.items.items[0].setValue(record.get('INSPECT_RESULT'));
						}
						widget.items.items[0].setReadOnly(!resultGrid.editable);
					}
					else if(type == 'B') {
						widget.items.items[1].show();
						widget.items.items[1].recordId = record.id;
						if(Ext.isEmpty(record.get('INSPECT_RESULT'))) {
							Ext.each(widget.items.items[1].items.items, function(item){
								item.setValue(false);
							});
						}
						else {
							widget.items.items[1].setValue(record.get('INSPECT_RESULT'));
						}
						widget.items.items[1].setReadOnly(!resultGrid.editable);
					}
					else if(type == 'C') {
						widget.items.items[2].show();
						widget.items.items[2].recordId = record.id;
						widget.items.items[2].setValue(record.get('INSPECT_RESULT'));
						
						widget.items.items[2].setReadOnly(!resultGrid.editable);
					}
					else {
						widget.items.items[3].show();
					}
				},
				widget: {
					itemId:'dynamicWidget',
					xtype:'uniSearchForm',
					height:25,
					layout:{type:'uniTable', columns:4, tdAttrs:{style:'padding:0px;'}},
					padding: '0 0 0 0',
					items:[{
						xtype: 'uniRadiogroup',
						items: [{
							boxLabel: 'OK',
							inputValue: 'OK',
							width:70
						}, {
							boxLabel: 'NG',
							inputValue: 'NG',
							width:70
						}],
						hidden: true,
						recordId: '',
						listeners:{
							change: function(field, newValue, oldValue, eOpts) {
								if(Ext.isEmpty(this.recordId)) {
									return;
								}
								
								resultGrid.selectById(this.recordId);
								var record = resultGrid.getSelectedRecord();
								
								if(Ext.isEmpty(record)) {
									return;
								}
								else {
									record.set('INSPECT_RESULT', newValue[field.name]);
								}
							}
						}
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel: 'OK',
							inputValue: 'OK',
							width:70
						}, {
							boxLabel: 'NG',
							inputValue: 'NG',
							width:70
						}, {
							boxLabel: 'NA',
							inputValue: 'NA',
							width:60
						}],
						hidden: true,
						recordId: '',
						listeners:{
							change: function(field, newValue, oldValue, eOpts) {
								if(Ext.isEmpty(this.recordId)) {
									return;
								}
								
								resultGrid.selectById(this.recordId);
								var record = resultGrid.getSelectedRecord();
								
								if(Ext.isEmpty(record)) {
									return;
								}
								else {
									record.set('INSPECT_RESULT', newValue[field.name]);
								}
							}
						}
					},{
						xtype: 'uniTextfield',
						hidden: true,
						recordId: '',
						width: 197,
						listeners:{
							change: function(field, newValue, oldValue, eOpts) {
								if(Ext.isEmpty(this.recordId)) {
									return;
								}
								
								resultGrid.selectById(this.recordId);
								var record = resultGrid.getSelectedRecord();
								
								if(Ext.isEmpty(record)) {
									return;
								}
								else {
									record.set('INSPECT_RESULT', newValue);
								}
							}
						}
					},{
						xtype: 'component',
						hidden: true
					}]
				}
			},
			{dataIndex: 'RE_INSPECT_RESULT'		, width: 150, hidden: true},
			{dataIndex: 'INSPECT_RESULT_TYPE'	, width: 150, hidden: true},
			{dataIndex: 'SORT_SEQ'				, width: 100, hidden: true},
			{dataIndex: 'MEASURE_VAR'			, width: 100, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(!resultGrid.editable) {
					return false;
				}
				
				if(UniUtils.indexOf(e.field, ['NUM_VALUE', 'MEASURE_VALUE', 'INSPECT_RESULT'])) {
					return true;
				}
				
				return false;
			}
		},
		setColumnDisplay : function(type) {
			var codeInfo;
			var codeIndex = Ext.getStore('CBS_AU_ZQ02').findBy(function(record){
				return record.get('value') == type;
			});
			
			resultGrid.getColumn('CHECK_POINT').hide();
			resultGrid.getColumn('STANDARD').hide();
			resultGrid.getColumn('LOTNO').hide();
			resultGrid.getColumn('NUM_VALUE').hide();
			resultGrid.getColumn('SPEC').hide();
			resultGrid.getColumn('MEASURE_VALUE').hide();
			resultGrid.getColumn('RE_MEASURE_VALUE').hide();
			resultGrid.getColumn('FIRST_CAL').hide();
			resultGrid.getColumn('FACTORY_TOL').hide();
			resultGrid.getColumn('UNIT').hide();
			resultGrid.getColumn('INSPECT_RESULT').hide();
			resultGrid.getColumn('RE_INSPECT_RESULT').hide();
			
			if(!Ext.isEmpty(codeIndex) && codeIndex >= 0) {
				codeInfo = Ext.getStore('CBS_AU_ZQ02').data.items[codeIndex];
				
				for(var lRefIdx = 1; lRefIdx <= 15; lRefIdx++) {
					var sRefName = 'refCode' + String(lRefIdx);
					var sColName = codeInfo.get(sRefName);
					
					if(!Ext.isEmpty(sColName) && resultGrid.getColumnIndex(gsColumnList['REF_CODE' + String(lRefIdx)]) >= 0){
						var colName = gsColumnList['REF_CODE' + String(lRefIdx)];
						
						if(colName == 'INSPECT_RESULT') {
							colName = 'INSPECT_RESULT_DYNAMIC';
						}
						resultGrid.getColumn(colName).show();
						resultGrid.getColumn(colName).setText(sColName);
					}
				}
			}
			
			//masterGrid.uniOpt.selectedTitleType	= type;
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {

	function openResultWindow() {
		if(!resultWindow) {
			resultWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="계측결과입력"/>',
				width	: document.body.offsetWidth,		//	전체화면
				height	: document.body.offsetHeight,
				layout	: {type:'vbox', align:'stretch'},
				items	: [resultSearch, resultGrid],
				tbar	: ['->',
					{
						itemId	: 'resultWinCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							resultWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						resultSearch.clearForm();
						resultGrid.reset();
					},
					beforeclose: function(panel, eOpts)	{
						resultSearch.clearForm();
						resultGrid.reset();
					},
					show: function(panel, eOpts)	{
						var record = masterGrid.getSelectedRecord();
						
						resultSearch.setValue('INSPECT_NO'	, record.get('INSPECT_NO'));
						resultSearch.setValue('DIV_CODE'	, record.get('DIV_CODE'));
						resultSearch.setValue('MODEL'		, record.get('MODEL'));
						resultSearch.setValue('REV_NO'		, record.get('REV_NO'));
						resultSearch.setValue('ITEM_CODE'	, record.get('ITEM_CODE'));
						resultSearch.setValue('WKORD_NUM'	, record.get('WKORD_NUM'));
						resultSearch.setValue('WORK_DATE'	, UniDate.getDbDateStr(inspectSearch.getValue('WORK_DATE')));
						resultSearch.setValue('WORK_USER'	, inspectSearch.getValue('WORK_USER'));
						
						resultWindow.setReadOnly(record.get('STATUS'));
						
						directResultStore.loadStoreRecords();
					}
				},
				fnDelData: function() {
					var param = resultSearch.getValues();
					Ext.Msg.confirm('초기화', '검사결과를 초기화 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							s_qbs200ukrv_mekService.deleteResult(param, function(provider, response){
								if(!Ext.isEmpty(provider)) {
									Unilite.messageBox('초기화 되었습니다.');
									
									resultGrid.reset();
									directResultStore.clearData();
									directResultStore.loadStoreRecords();
								}
							});
						}
					});
				},
				fnSaveData: function() {
					if(directResultStore.isDirty()) {
						directResultStore.saveStore();
					}
				},
				setReadOnly: function(status) {
					if(status == 'RR') {
						resultGrid.editable = false;
						resultSearch.down('#btnInit').setDisabled(true);
						resultSearch.down('#btnSave').setDisabled(true);
					}
					else {
						resultGrid.editable = true;
						resultSearch.down('#btnInit').setDisabled(false);
						resultSearch.down('#btnSave').setDisabled(false);
					}
				}
			});
		}
		else {
			var record = masterGrid.getSelectedRecord();
			
			resultSearch.setValue('INSPECT_NO'	, record.get('INSPECT_NO'));
			resultSearch.setValue('DIV_CODE'	, record.get('DIV_CODE'));
			resultSearch.setValue('MODEL'		, record.get('MODEL'));
			resultSearch.setValue('REV_NO'		, record.get('REV_NO'));
			resultSearch.setValue('ITEM_CODE'	, record.get('ITEM_CODE'));
			resultSearch.setValue('WKORD_NUM'	, record.get('WKORD_NUM'));
			resultSearch.setValue('WORK_DATE'	, UniDate.getDbDateStr(inspectSearch.getValue('WORK_DATE')));
			resultSearch.setValue('WORK_USER'	, inspectSearch.getValue('WORK_USER'));
			
			resultGrid.reset();
			directResultStore.clearData();
			directResultStore.loadStoreRecords();
		}
		resultWindow.show();
		resultWindow.center();
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
	
}
</script>