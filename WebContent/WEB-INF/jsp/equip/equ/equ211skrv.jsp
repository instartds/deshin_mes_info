<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ211skrv"  >
	<t:ExtComboStore comboType="BOR120"  />						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="I801" />			<!-- 장비상태 -->
	<t:ExtComboStore comboType="AU" comboCode="I802" />			<!-- 목형종류 -->
	<t:ExtComboStore comboType="AU" comboCode="I803" />			<!-- 목형재질 -->
	<t:ExtComboStore comboType="AU" comboCode="I804" />			<!-- 폐기구분 -->
	<t:ExtComboStore comboType="AU" comboCode="WB08" />			<!-- 구분 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-cell_red {
	background-color: #ff5500;
	//color:white;
}
.x-grid-cell_yellow {
	background-color: #ffff66;
	//color:white;
}
.x-grid-cell_black {
	background-color: #eee;
	//color:white;
}
</style>

<script type="text/javascript" >


var outDivCode = UserInfo.divCode;
var selectRecordCode;


function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'equ211skrvService.selectList'/*,
			update	: 'equ211skrvService.updateDetail',
			create	: 'equ211skrvService.insertDetail',
			destroy	: 'equ211skrvService.deleteDetail',
			syncAll	: 'equ211skrvService.saveAll'*/
		}
	});



	Unilite.defineModel('equ211skrvModel1', {
		fields: [

 			{name: 'DIV_CODE'			, text: '<t:message code="system.label.equipment.division" default="사업장"/>'					, type: 'string'	,isPk:true},
 			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcentercode" default="작업장"/>'					, type: 'string'    ,allowBlank:false},
 			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'				, type: 'string'},
 			{name: 'EQU_CODE_TYPE'		, text: '<t:message code="system.label.equipment.equipnamemold" default="장비구분"/>'			, type: 'string'},
 			{name: 'EQU_CODE'			, text: '<t:message code="system.label.equipment.equipcodemold" default="장비(금형)코드"/>'		, type: 'string'	,allowBlank:false},
 			{name: 'EQU_NAME'			, text: '<t:message code="system.label.equipment.equipnamemold" default="장비(금형)명"/>'		, type: 'string'},
 			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'					, type: 'string'    ,allowBlank:false},
 			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'						, type: 'string'},
 			{name: 'AREAID'			    , text: '위치NO'			, type: 'string', comboType: 'AU', comboCode: 'I806'},
 			{name: 'IP'			        , text: 'IP주소'			, type: 'string'},
 			{name: 'WDT'			    , text: '기록일시'			, type: 'uniTime'},
 			{name: 'WDATE'			    , text: '기록일자'			, type: 'uniDate'},
 			{name: 'COUNTER1'			, text: '카운터1'			, type: 'string'},
 			{name: 'COUNTER2'			, text: '카운터2'			, type: 'string'},
 			{name: 'COUNTER3'			, text: '카운터3'			, type: 'string'},
 			{name: 'LOG_DATA'			, text: '수신데이터로그'		, type: 'string'},
 			{name: 'INF_FLAG'			, text: '인터페이스구분'		, type: 'string'},
 			{name: 'INF_TIME'			, text: '인터페이스시간'		, type: 'string'},
 			{name: 'RST_FLAG'			, text: '리셋구분'			, type: 'string'},
 			{name: 'RST_TIME'			, text: '리셋시간'			, type: 'string'},
 			{name: 'PRINT_FLAG'			, text: '출력구분'			, type: 'string'},
 			{name: 'PRT_TIME'			, text: '출력시간'			, type: 'string'},
 			{name: 'CMDGBN'			    , text: '명령구분'			, type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	* @type
	*/
	var directMasterStore1 = Unilite.createStore('equ211skrvMasterStore1',{
		model	: 'equ211skrvModel1',
		proxy	: directProxy1,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용

		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param//,
//				callback:function(records, operation, success)	{
//					if(success){
//					}
//				}
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts){
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'WORK_SHOP_NAME'
	});//End of var directMasterStore1 = Unilite.createStore('equ211skrvMasterStore1',{



	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '검색조건',
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
		items	: [{
			title		: '<t:message code="system.label.equipment.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('EQU_MACH_CODE',{
				fieldLabel		: '<t:message code="system.label.equipment.equipcodemold" default="장비(금형)코드"/>',
				valueFieldName	: 'EQU_MACH_CODE',
				textFieldName	: 'EQU_MACH_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('EQU_MACH_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('EQU_MACH_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'EQU_MACH_CODE':  panelSearch.getValue('EQU_MACH_CODE')});
					}
				}
			}),{
				fieldLabel		: '<t:message code="system.label.equipment.punchpriod" default="타발기간"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
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
				fieldLabel	: '<t:message code="system.label.equipment.status" default="상태"/>',
				name		: 'EQU_GRADE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'I801',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EQU_GRADE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.equipment.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.equipment.type" default="구분"/>',
				id			: 'rdoSelect1',
				items: [{
					boxLabel	: '<t:message code="system.label.equipment.equipinfomation" default="장비(금형)정보"/>',
					name		: 'WOODEN_GUBUN',
					inputValue	: '1',
					checked		: true,
					width		: 110
				},{
					boxLabel	: '<t:message code="system.label.equipment.historyinquiry" default="이력조회"/>',
					name		: 'WOODEN_GUBUN',
					inputValue	: '2',
					width		: 90
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(panelSearch.getValue('WOODEN_GUBUN') == '1'){
							panelResult.getField('WOODEN_GUBUN').setValue(newValue.WOODEN_GUBUN);
							panelSearch.setValue('PRODT_DATE_FR', new Date());
							panelSearch.setValue('PRODT_DATE_TO', new Date());
							panelResult.setValue('PRODT_DATE_FR', new Date());
							panelResult.setValue('PRODT_DATE_TO', new Date());
							panelSearch.getField('PRODT_DATE_FR').setReadOnly(true);
							panelSearch.getField('PRODT_DATE_TO').setReadOnly(true);
							panelResult.getField('PRODT_DATE_FR').setReadOnly(true);
							panelResult.getField('PRODT_DATE_TO').setReadOnly(true);

						//	masterGrid.getColumn('PRODT_DATE').setHidden(true);
						//	masterGrid.getColumn('PRESS_CNT').setHidden(true);
						//	masterGrid.getColumn('PRODT_NUM').setHidden(true);

						}else{
							panelResult.getField('WOODEN_GUBUN').setValue(newValue.WOODEN_GUBUN);
							panelSearch.setValue('PRODT_DATE_FR', new Date());
							panelSearch.setValue('PRODT_DATE_TO', new Date());
							panelResult.setValue('PRODT_DATE_FR', new Date());
							panelResult.setValue('PRODT_DATE_TO', new Date());
							panelSearch.getField('PRODT_DATE_FR').setReadOnly(false);
							panelSearch.getField('PRODT_DATE_TO').setReadOnly(false);
							panelResult.getField('PRODT_DATE_FR').setReadOnly(false);
							panelResult.getField('PRODT_DATE_TO').setReadOnly(false);

						//	masterGrid.getColumn('PRODT_DATE').setHidden(false);
						//	masterGrid.getColumn('PRESS_CNT').setHidden(false);
						//	masterGrid.getColumn('PRODT_NUM').setHidden(false);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.equipment.type" default="구분"/>',
				name		: 'GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'WB08',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('GUBUN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="금형위치" default="금형위치"/>',
				name		: 'AREAID',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'I806',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AREAID', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3,	rows:2, tableAttrs: { /*style: { width: '100%', height:'100%' }*/ }},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			tdAttrs		: {width: 280},
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel		: '<t:message code="system.label.equipment.equipcodemold" default="장비(금형)코드"/>',
			valueFieldName	: 'EQU_MACH_CODE',
			textFieldName	: 'EQU_MACH_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('EQU_MACH_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('EQU_MACH_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
					popup.setExtParam({'EQU_MACH_CODE':  panelResult.getValue('EQU_MACH_CODE')});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.equipment.punchpriod" default="타발기간"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
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
			fieldLabel	: '<t:message code="system.label.equipment.status" default="상태"/>',
			name		: 'EQU_GRADE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'I801',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EQU_GRADE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.equipment.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE':  panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.equipment.type" default="구분"/>',
			id			: 'rdoSelect2',
			items: [{
				boxLabel	: '<t:message code="system.label.equipment.equipinfomation" default="장비(금형)정보"/>',
				name		: 'WOODEN_GUBUN',
				inputValue	: '1',
				checked		: true,
				width		: 110
			},{
				boxLabel	: '<t:message code="system.label.equipment.historyinquiry" default="이력조회"/>',
				name		: 'WOODEN_GUBUN',
				inputValue	: '2',
				width		: 90
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(panelResult.getValue('WOODEN_GUBUN') == '1'){
						panelSearch.getField('WOODEN_GUBUN').setValue(newValue.WOODEN_GUBUN);

						panelSearch.setValue('PRODT_DATE_FR', new Date());
						panelSearch.setValue('PRODT_DATE_TO', new Date());
						panelResult.setValue('PRODT_DATE_FR', new Date());
						panelResult.setValue('PRODT_DATE_TO', new Date());
						panelSearch.getField('PRODT_DATE_FR').setReadOnly(false);
						panelSearch.getField('PRODT_DATE_TO').setReadOnly(false);
						panelResult.getField('PRODT_DATE_FR').setReadOnly(false);
						panelResult.getField('PRODT_DATE_TO').setReadOnly(false);
						panelSearch.setValue('PRODT_DATE_FR', '');
						panelSearch.setValue('PRODT_DATE_TO', '');
						panelResult.setValue('PRODT_DATE_FR', '');
						panelResult.setValue('PRODT_DATE_TO', '');
//						masterGrid.getColumn('PRODT_DATE').setHidden(true);
//						masterGrid.getColumn('PRESS_CNT').setHidden(true);
//						masterGrid.getColumn('PRODT_NUM').setHidden(true);

					}else{
						panelSearch.getField('WOODEN_GUBUN').setValue(newValue.WOODEN_GUBUN);

						panelSearch.setValue('PRODT_DATE_FR', new Date());
						panelSearch.setValue('PRODT_DATE_TO', new Date());
						panelResult.setValue('PRODT_DATE_FR', new Date());
						panelResult.setValue('PRODT_DATE_TO', new Date());
						panelSearch.getField('PRODT_DATE_FR').setReadOnly(false);
						panelSearch.getField('PRODT_DATE_TO').setReadOnly(false);
						panelResult.getField('PRODT_DATE_FR').setReadOnly(false);
						panelResult.getField('PRODT_DATE_TO').setReadOnly(false);

//						masterGrid.getColumn('PRODT_DATE').setHidden(false);
//						masterGrid.getColumn('PRESS_CNT').setHidden(false);
//						masterGrid.getColumn('PRODT_NUM').setHidden(false);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.equipment.type" default="구분"/>',
			name		: 'GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'WB08',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="금형위치" default="금형위치"/>',
			name		: 'AREAID',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'I806',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AREAID', newValue);
				}
			}
		}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{



	var masterGrid = Unilite.createGrid('equ211skrvGrid1', {
		title	: '',
		layout	: 'fit',
		region	: 'center',
		store	: directMasterStore1,
		uniOpt	: {
			useLiveSearch		: true,
			useGroupSummary		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel	  : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData	  : false,
				summaryExport : true
			}
		},
		features: [
			{id: 'masterGridSubTotal'	,ftype: 'uniGroupingsummary',showSummaryRow: true},
			{id: 'masterGridTotal'		,ftype: 'uniSummary'		,showSummaryRow: true
		}],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
//				var cls = '';
//					if(record.get("EQU_GRADE") == "C"){
//						return 'x-grid-cell_red';
//					}else if(record.get("EQU_GRADE") == "A"){
//						return 'x-grid-cell_yellow';
//					}
//					return 'x-grid-cell_black';

//				return cls;
			}
		},
		columns: [

			{dataIndex: 'DIV_CODE'				, width: 120,hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 80,hidden:true},
			{dataIndex: 'WORK_SHOP_NAME'		, width: 120},
			{dataIndex: 'EQU_CODE_TYPE'			, width: 80},
			{dataIndex: 'EQU_CODE'				, width: 120},
			{dataIndex: 'EQU_NAME'				, width: 180},
			{dataIndex: 'PROG_WORK_CODE'		, width: 80},
			{dataIndex: 'PROG_WORK_NAME'		, width: 120},
			{dataIndex: 'AREAID'				, width: 100},
			{dataIndex: 'IP'					, width: 100},
			{dataIndex: 'WDT'					, width: 100},
			{dataIndex: 'WDATE'					, width: 100},
			{dataIndex: 'COUNTER1'				, width: 100},
			{dataIndex: 'COUNTER2'				, width: 100},
			{dataIndex: 'COUNTER3'				, width: 100},
			{dataIndex: 'LOG_DATA'				, width: 100},
			{dataIndex: 'INF_FLAG'				, width: 80 },
			{dataIndex: 'INF_TIME'				, width: 100},
			{dataIndex: 'RST_FLAG'				, width: 80},
			{dataIndex: 'RST_TIME'				, width: 100},
			{dataIndex: 'PRINT_FLAG'			, width: 80},
			{dataIndex: 'PRT_TIME'				, width: 100},
			{dataIndex: 'CMDGBN'				, width: 100}

		]
	});





	Unilite.Main( {
		id			: 'equ211skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('WOODEN_GUBUN').setValue('1');
			panelResult.getField('WOODEN_GUBUN').setValue('1');

			panelSearch.setValue('PRODT_DATE_FR', '');
			panelSearch.setValue('PRODT_DATE_TO', '');
			panelResult.setValue('PRODT_DATE_FR', '');
			panelResult.setValue('PRODT_DATE_TO', '');
		//	panelSearch.getField('PRODT_DATE_FR').setReadOnly(true);
		//	panelSearch.getField('PRODT_DATE_TO').setReadOnly(true);
		//	panelResult.getField('PRODT_DATE_FR').setReadOnly(true);
		//	panelResult.getField('PRODT_DATE_TO').setReadOnly(true);

			UniAppManager.setToolbarButtons(['reset'], true);
		},

		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			masterGrid.getStore().loadData({});

			panelSearch.clearForm();
			panelResult.clearForm();

			//masterGrid.getColumn('PRODT_DATE').setHidden(true);
			//masterGrid.getColumn('PRESS_CNT').setHidden(true);
			//masterGrid.getColumn('PRODT_NUM').setHidden(true);
			this.fnInitBinding();
		}
	});
};
</script>