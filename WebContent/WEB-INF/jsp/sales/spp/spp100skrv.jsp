<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="spp100skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="spp100skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>			<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>			<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Spp100skrvModel1', {
		fields: [
			{name: 'TAB_BASE'			,text: 'TAB_BASE'	,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'	,type: 'string'},
			{name: 'ESTI_DATE'			,text: '견적일'		,type: 'uniDate'},
			{name: 'ESTI_NUM'			,text: '견적번호'		,type: 'string'},
			{name: 'ESTI_SEQ'			,text: 'ESTI_SEQ'	,type: 'string'},
			{name: 'ESTI_QTY'			,text: '견적수량'		,type: 'uniQty'},
			{name: 'ESTI_CFM_PRICE'		,text: '견적단가'		,type: 'uniUnitPrice'},
			{name: 'ESTI_CFM_AMT'		,text: '견적금액'		,type: 'uniPrice'},
			{name: 'PROFIT_RATE'		,text: 'DC율'		,type: 'uniPercent'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'ESTI_UNIT'			,text: '견적단위'		,type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'	,type: 'uniQty'},
			{name: 'ESTI_PRICE'			,text: '정상판매가'		,type: 'uniPrice'},
			{name: 'ESTI_AMT'			,text: '정상금액'		,type: 'uniPrice'},
			{name: 'CONFIRM_DATE'		,text: '견적확정일'		,type: 'uniDate'},
			{name: 'CONFIRM_FLAG'		,text: '<t:message code="system.label.sales.classfication" default="구분"/>'	,type: 'string'},
			{name: 'ESTI_PRSN'			,text: '견적담당자'		,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore = Unilite.createStore('spp100skrvMasterStore1',{
		model	: 'Spp100skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'spp100skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE'
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'ESTI_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ESTI_PRSN', newValue);
						}
					}
				},{
					fieldLabel		: '견적일',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
	 				width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners	: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					xtype		: 'radiogroup',
					fieldLabel	: '견적구분',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
						name		: 'RDO',
						inputValue	: '0',
						width		: 50,
						checked		: true  
					},{
						boxLabel	: '진행',
						name		: 'RDO',
						inputValue	: '1', 
						width		: 50
					},{
						boxLabel	: '확정',
						name		: 'RDO',
						inputValue	: '2',
						width		: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//panelResult.getField('RDO').setValue({RDO: newValue});
							panelResult.getField('RDO').setValue(newValue.RDO);
						}
					}
				}]
			}]
		},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{ 
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false
			},{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'TXTLV_L1', 
				xtype		: 'uniCombobox',  
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2'
			},{
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'TXTLV_L2', 
				xtype		: 'uniCombobox',  
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child		: 'TXTLV_L3'
			},{
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'TXTLV_L3', 
				xtype		: 'uniCombobox',  
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'), 
				colspan		: 2
			},{
				fieldLabel	: '견적금액',
				xtype		: 'uniTextfield',
				name		: 'ESTI_CFM_AMT_FR',
				suffixTpl	: '&nbsp;이상'
			},{
				fieldLabel	: ' ',
				xtype		: 'uniTextfield',
				name		: 'ESTI_CFM_AMT_TO',
				suffixTpl	: '&nbsp;이하'
			},{
				fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name		: '',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적요청자',
				width		: 315,
				name		: 'CUST_PRSN'
			}, 
			Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName	: 'ITEM_GROUP_CODE',
				textFieldName	: 'ITEM_GROUP_NAME'
			}),{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적건명',
				width		: 315,
				name		: 'ESTI_TITLE'
			},{
				fieldLabel	: '견적번호',
				xtype		: 'uniTextfield',
				name		: 'ESTI_NUM_FR'
			},{
				fieldLabel	: '~',
				xtype		: 'uniTextfield',
				name		: 'ESTI_NUM_TO'
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name		: 'ESTI_PRSN', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ESTI_PRSN', newValue);
				}
			}
		},{
			fieldLabel		: '견적일',
			width			: 315,
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '견적구분',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				width		: 50,
				name		: 'RDO',
				inputValue	: '0',
				checked		: true  
			},{
				boxLabel	: '진행', 
				width		: 50,
				name		: 'RDO',
				inputValue	: '1'
			},{
				boxLabel	: '확정',
				width		: 70,
				name		: 'RDO',
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('RDO').setValue({RDO: newValue});
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
		}]	
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('spp100skrvGrid1', {
		store	: directMasterStore,
		region	: 'center',
		layout	: 'fit',
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'TAB_BASE'			, width: 93	, locked: false, hidden: true},		//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'ITEM_CODE'		, width: 100, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}}, 																			//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'ITEM_NAME'		, width: 133, locked: false},					//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'CUSTOM_CODE'		, width: 93	, locked: false},					//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'CUSTOM_NAME'		, width: 133, locked: false},					//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'ESTI_DATE'		, width: 80	, locked: false},					//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
			{ dataIndex: 'ESTI_NUM'			, width: 86},
			{ dataIndex: 'ESTI_SEQ'			, width: 33	, hidden: true},
			{ dataIndex: 'ESTI_QTY'			, width: 123, summaryType: 'sum'},
			{ dataIndex: 'ESTI_CFM_PRICE'	, width: 123},
			{ dataIndex: 'ESTI_CFM_AMT'		, width: 123, summaryType: 'sum'},
			{ dataIndex: 'PROFIT_RATE'		, width: 110},
			{ dataIndex: 'ESTI_UNIT'		, width: 86},
			{ dataIndex: 'TRANS_RATE'		, width: 103},
			{ dataIndex: 'ESTI_PRICE'		, width: 133},
			{ dataIndex: 'ESTI_AMT'			, width: 133, summaryType: 'sum'},
			{ dataIndex: 'CONFIRM_DATE'		, width: 133},
			{ dataIndex: 'CONFIRM_FLAG'		, width: 40},
			{ dataIndex: 'ESTI_PRSN'		, width: 100}
		],
		//20200512 추가: 견적등록 바로가기
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '견적등록 바로가기',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'spp100skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ESTI_NUM	: record.data.ESTI_NUM,
							CUSTOM_CODE	: record.data.CUSTOM_CODE,
							CUSTOM_NAME	: record.data.CUSTOM_NAME,
							ESTI_DATE	: UniDate.getDbDateStr(record.data.ESTI_DATE),
//							ESTI_TITLE	: record.data.ESTI_TITLE,		//추후 추가
							CONFIRM_FLAG: record.data.CONFIRM_FLAG
						}
						var rec = {data : {prgID : 'spp100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/spp100ukrv.do', params);
					}
				});
			}
		}
	});



	Unilite.Main({
		id			: 'spp100skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
			//20200512 주석: lock그리드 해제 - 컬럼 설정 사용하기 위해
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
};
</script>