<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mis200skrv_wm">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001" opts= '2;3;5;7;8;9'/>	<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>						<!-- 주문상태(기존 마감/미마감에서 - 마감 flag에 '취소' 설정) -->
	<t:ExtComboStore comboType="WU"/>										<!-- 작업장-->
	<t:ExtComboStore comboType="W"/>										<!-- 작업장 (전체)-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	.x-change-cell3 {
		background-color: #ff8201;
	}
</style>
<script type="text/javascript" >

function appMain() {
	/* 조회조건
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
		items: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
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
			},{
				fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_START_DATE',
				endFieldName	: 'PRODT_END_DATE',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{	//20210215 수정: 작업중, 대기 추가
				fieldLabel	: '<t:message code="" default="조건"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
					name		: 'WORK_END_YN',
					inputValue	: 'A',
					width		: 55
				},{
					boxLabel	: '<t:message code="system.label.product.process" default="진행"/>',
					name		: 'WORK_END_YN',
					inputValue	: '2',
					width		: 55
				},{
					boxLabel	: '작업중',
					name		: 'WORK_END_YN',
					inputValue	: '5',
					width		: 65
				},{
					boxLabel	: '대기',
					name		: 'WORK_END_YN',
					inputValue	: '7',
					width		: 55
				},{
					boxLabel	: '<t:message code="system.label.product.closing" default="마감"/>',
					name		: 'WORK_END_YN',
					inputValue	: '8',
					width		: 55
				},{
					boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>',
					name		: 'WORK_END_YN',
					inputValue	: '9',
					width		: 55
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU',
				listeners	: {
					beforequery:function( queryPlan, eOpts ) {
						var store	= queryPlan.combo.store;
						var prStore	= panelResult.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
						} else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					},
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue) {
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue) {
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '수령자',
				name		: 'RECEIVER_NAME',
				xtype		: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIVER_NAME', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
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
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_END_DATE', newValue);
				}
			}
		},{	//20210215 수정: 작업중, 대기 추가
			fieldLabel	: '<t:message code="" default="조건"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
				name		: 'WORK_END_YN',
				inputValue	: 'A',
				width		: 55
			},{
				boxLabel	: '<t:message code="system.label.product.process" default="진행"/>',
				name		: 'WORK_END_YN',
				inputValue	: '2',
				width		: 55
			},{
				boxLabel	: '작업중',
				name		: 'WORK_END_YN',
				inputValue	: '5',
				width		: 65
			},{
				boxLabel	: '대기',
				name		: 'WORK_END_YN',
				inputValue	: '7',
				width		: 55
			},{
				boxLabel	: '<t:message code="system.label.product.closing" default="마감"/>',
				name		: 'WORK_END_YN',
				inputValue	: '8',
				width		: 55
			},{
				boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>',
				name		: 'WORK_END_YN',
				inputValue	: '9',
				width		: 55
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
				}
			}
		},{
			xtype	: 'button',
			text	: '현황판 보기',
			tdAttrs	: {width: 380, align:'right'},
			width	: 100,
			height	: 40,
			rowspan	: 2,
			handler	: function() {
				//20201208 추가: 현황판 보기 클릭 시, 작업지시일(to)는 필수
				if(Ext.isEmpty(panelResult.getValue('PRODT_END_DATE'))) {
					Unilite.messageBox('작업지시일(to)를 입력하세요.');
					return false;
				}
				//20201109 수정: 새창에서 열도록 변경
				var divCode			= panelResult.getValue('DIV_CODE');
				var prodtStartDate	= Ext.isEmpty(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')))	? '' : UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE'));
				var prodtEndDate	= Ext.isEmpty(UniDate.getDbDateStr(panelResult.getValue('PRODT_END_DATE')))		? '' : UniDate.getDbDateStr(panelResult.getValue('PRODT_END_DATE'));
				var wordEndYn		= panelResult.getValues().WORK_END_YN;
				var workShopCode	= Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))							? '' : panelResult.getValue('WORK_SHOP_CODE');
				//20201208 추가
				var commonCodes		= Ext.data.StoreManager.lookup('CBS_WU_').data.items
				var workShopName;
				Ext.each(commonCodes,function(commonCode, i) {
					if(commonCode.get('value') == workShopCode) {
						workShopName = commonCode.get('text');
					}
				})
				if(Ext.isEmpty(workShopName)) {
					workShopName = '전체';
				}

				var itemCode		= Ext.isEmpty(panelResult.getValue('ITEM_CODE'))								? '' : panelResult.getValue('ITEM_CODE');
				var itemName		= Ext.isEmpty(panelResult.getValue('ITEM_NAME'))								? '' : panelResult.getValue('ITEM_NAME');
				var receiverName	= Ext.isEmpty(panelResult.getValue('RECEIVER_NAME'))							? '' : panelResult.getValue('RECEIVER_NAME');
				window.open('s_mis200skrvb_wm.do?PGM_ID=s_mis200skrv_wm&DIV_CODE='			+ divCode
																	+ '&PRODT_START_DATE='	+ prodtStartDate
																	+ '&PRODT_END_DATE='	+ prodtEndDate
																	+ '&WORK_END_YN='		+ wordEndYn
																	+ '&WORK_SHOP_CODE='	+ workShopCode
																	+ '&WORK_SHOP_NAME='	+ workShopName	//20201208 추가
																	+ '&ITEM_CODE='			+ itemCode
																	+ '&ITEM_NAME='			+ itemName
																	+ '&RECEIVER_NAME='		+ receiverName,'_blank','width='+(screen.availWidth-10)+',height='+(screen.availHeight)+'menubar=no,location=no,scrollbars=yes,resizable=no,top=0,left=0');
//				var params = {
//					action		: 'select',
//					'PGM_ID'	: 's_mis200skrv_wm',
//					'formPram'	: panelResult.getValues()
//				}
//				var rec = {data : {prgID : 's_mis200skrvb_wm', 'text':''}};
//				parent.openTab(rec, '/z_wm/s_mis200skrvb_wm.do', params, CHOST + CPATH);
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store	= queryPlan.combo.store;
					var psStore	= panelSearch.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					psStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						psStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else{
						store.filterBy(function(record){
							return false;
						});
						psStore.filterBy(function(record){
							return false;
						});
					}
				},
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue) {
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue) {
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '수령자',
			name		: 'RECEIVER_NAME',
			xtype		: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIVER_NAME', newValue);
				}
			}
		}]
	});



	Unilite.defineModel('s_mis200skrv_wmMModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'SEQ'				, text: '<t:message code="system.label.product.seq" default="순번"/>'				, type: 'int'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'SITE_NAME'			, text: '사이트'			, type: 'string'},
			{name: 'RECEIVER_NAME'		, text: '수령자'			, type: 'string'},
			{name: 'GROUPKEY'			, text: '묶음번호(주문번호)'	, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string' , comboType:'AU', comboType:'W'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'	, type: 'uniQty'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			,type: 'string'},
			{name: 'ORDER_STATUS'		, text: '주문상태'			, type: 'string' , comboType:'AU' ,comboCode: 'S011'},
			{name: 'ITEMLEVEL1_NAME'	, text: '<t:message code="system.label.product.majorgroup" default="대분류"/>'		, type: 'string'},
			{name: 'ITEMLEVEL2_NAME'	, text: '<t:message code="system.label.product.middlegroup" default="중분류"/>'	, type: 'string'},
			{name: 'ITEMLEVEL3_NAME'	, text: '<t:message code="system.label.product.minorgroup" default="소분류"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'},
			//20210215 추가: 작지상태, 검사수량
			{name: 'CONTROL_STATUS'		, text: '작지상태'			, type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.purchase.inspectqty" default="검사수량"/>'	, type: 'uniQty'}
		]
	});

	var masterStore = Unilite.createStore('s_mis200skrv_wmMasterStore',{
		model	: 's_mis200skrv_wmMModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mis200skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mis200skrv_wmGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'SEQ'				, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, align: 'center'},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},	//20210215 추가: 작지상태, 검사수량
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'INSPEC_Q'			, width: 100},						//20210215 추가: 작지상태, 검사수량
			{dataIndex: 'SITE_NAME'			, width: 110},
			{dataIndex: 'RECEIVER_NAME'		, width: 100},
			{dataIndex: 'GROUPKEY'			, width: 120},
			{dataIndex: 'ORDER_STATUS'		, width: 80		, align: 'center'},
			{dataIndex: 'ITEMLEVEL1_NAME'	, width: 100},
			{dataIndex: 'ITEMLEVEL2_NAME'	, width: 100},
			{dataIndex: 'ITEMLEVEL3_NAME'	, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		},
		//20210215 추가: 주문상태가 '취소/마감'이면 배경색 표시
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('ORDER_STATUS') == 'Y') {
					cls = 'x-change-cell3';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 's_mis200skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		},
			panelSearch
		],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('PRODT_START_DATE'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_END_DATE'	, UniDate.get('today'));
			panelSearch.getField('WORK_END_YN').setValue('A');

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_END_DATE'	, UniDate.get('today'));
			panelResult.getField('WORK_END_YN').setValue('A');

			//초기화 시, 포커스 설정
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('WORK_SHOP_CODE');
		},
		onQueryButtonDown: function () {
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>