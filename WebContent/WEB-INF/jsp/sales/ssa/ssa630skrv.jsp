<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa630skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa630skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell {
		background-color: #FFFFC6;
	}
	.x-change-yellow {
		background-color: #FAF082;
	}
	.x-change-blue1 {
		background-color: #C0FFFF;
	}
	.x-change-blue2 {
		background-color: #B9E2FA;
	}
	.x-change-pink {
		background-color: #FFCAD5;
	}
</style>

<script type="text/javascript" >
function appMain() {
	var BsaCodeInfo = {
		gsLinkPgID1: '${gsLinkPgID1}',
		gsLinkPgID2: '${gsLinkPgID2}',
		gsLinkPgID3: '${gsLinkPgID3}'
	};

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
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				}, {
					fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
					name		: 'AGENT_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B055',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
				}, {
					fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FrDate',
					endFieldName	: 'ToDate',
					allowBlank		: false,
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FrDate',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ToDate',newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					}
				})]
			}]
		}],
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
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		}, {
			fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'FrDate',
			endFieldName	: 'ToDate',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FrDate',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ToDate',newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown();}, 100);
						}
					}
				}
			}
		})]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('ssa630skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		, text: 'DIV_CODE'	, type: 'string'},
			{name: 'AGENT_TYPE'		, text: '<t:message code="system.label.base.clienttype" default="고객분류"/>'		, type: 'string'},
			{name: 'AGENT_NAME'		, text: '<t:message code="system.label.base.clienttype" default="고객분류"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'BASE_AMT'		, text: '<t:message code="system.label.sales.overbalance" default="이월잔액"/>'		, type: 'uniFC'},
			{name: 'SALE_AMT'		, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniFC'},
			{name: 'COLLECT_AMT'	, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'	, type: 'uniFC'},
			{name: 'PURCH_AMT'		, text: '<t:message code="system.label.sales.pruchaseamount" default="매입액"/>'	, type: 'uniFC'},
			{name: 'PAY_AMT'		, text: '<t:message code="system.label.human.supptotali" default="지급액"/>'		, type: 'uniFC'},
			{name: 'BAL_AMT'		, text: '<t:message code="system.label.sales.balanceamount2" default="잔액"/>'	, type: 'uniFC'},
			{name: 'RE_AMT'			, text: '받을 돈'		, type: 'uniFC'},
			{name: 'DEBT_AMT'		, text: '줄 돈'		, type: 'uniFC'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa630skrvMasterStore1',{
		model	: 'ssa630skrvModel1',
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
				read: 'ssa630skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'AGENT_NAME'
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa630skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: true},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns	: [
			{ dataIndex: 'AGENT_TYPE'	, width: 100, hidden: true},
			{ dataIndex: 'AGENT_NAME'	, width: 133, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalbyclienttype" default="고객분류계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'CUSTOM_CODE'	, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'	, width: 133},
			{ dataIndex: 'BASE_AMT'		, width: 140, summaryType: 'sum'},
			{text: '영업',
				columns:[
					{ dataIndex: 'SALE_AMT'		, width: 140, summaryType: 'sum'},
					{ dataIndex: 'COLLECT_AMT'	, width: 140, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.purchase.purchase2" default="구매"/>',
				columns:[
					{ dataIndex: 'PURCH_AMT'	, width: 140, summaryType: 'sum'},
					{ dataIndex: 'PAY_AMT'		, width: 140, summaryType: 'sum'}
				]
			},
			{ dataIndex: 'BAL_AMT'		, width: 140, summaryType: 'sum'},
			{ dataIndex: 'RE_AMT'		, width: 140, summaryType: 'sum'},
			{ dataIndex: 'DEBT_AMT'		, width: 140, summaryType: 'sum'}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			//20210504 주석: 우선 링크기능 사용 안 함
//			if(record.get('BAL_TYPE') == '매입') {
//				menu.down('#gsLinkPgID1').show();
//				menu.down('#gsLinkPgID2').hide();
//				menu.down('#gsLinkPgID3').hide();
//			} else if(record.get('BAL_TYPE') == '매출') {
//				menu.down('#gsLinkPgID1').hide();
//				menu.down('#gsLinkPgID2').show();
//				menu.down('#gsLinkPgID3').hide();
//			} else if(record.get('BAL_TYPE') == '수금') {
//				menu.down('#gsLinkPgID1').hide();
//				menu.down('#gsLinkPgID2').hide();
//				menu.down('#gsLinkPgID3').show();
//			} else {
//				menu.down('#gsLinkPgID1').hide();
//				menu.down('#gsLinkPgID2').hide();
//				menu.down('#gsLinkPgID3').hide();
//			}
//			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '지급결의 등록 이동',
				itemId	: 'gsLinkPgID1',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoMap100(param.record);
				}
			},{
				text	: '매출등록 이동',
				itemId	: 'gsLinkPgID2',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoSsa100(param.record);
				}
			},{
				text	: '수금등록 이동',
				itemId	: 'gsLinkPgID3',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoSco110(param.record);
				}
			}]
		},
		gotoMap100:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID1.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID1.split('/')[2].length - 3);
				var params		= {
					action			: 'select',
					'PGM_ID'		: 'ssa630skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BASIS_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '지급결의 등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID1, params);
			}
		},
		gotoSsa100:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID2.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID2.split('/')[2].length - 3);
				var params		= {
					action			: 'select',
					'PGM_ID'		: 'ssa630skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BILL_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '매출등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID2, params);
			}
		},
		gotoSco110:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID3.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID3.split('/')[2].length - 3);
				var params		= {
					action			: 'select',
					'PGM_ID'		: 'ssa630skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BASIS_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '수금등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID3, params);
			}
		},
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				masterGrid.goto_ssa615skrv(record);
			}
//			cellclick : function ( gridView, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				//선택된 행의 저장된 데이터만 masterGrid2에 보여주도록 filter
//				if(!Ext.isEmpty(record) 
//				&& (record.get('BAL_TYPE') == '매출' || record.get('BAL_TYPE') == '매입')) {
//					masterGrid2.getStore().loadStoreRecords(record);
//				} else {
//					masterGrid2.getStore().loadData({});
//				}
//			},
//			select: function(grid, selected, index, rowIndex, eOpts ){
//				//선택된 행의 저장된 데이터만 masterGrid2에 보여주도록 filter
//				if(!Ext.isEmpty(selected) 
//				&& (selected.get('BAL_TYPE') == '매출' || selected.get('BAL_TYPE') == '매입')) {
//					masterGrid2.getStore().loadStoreRecords(selected);
//				} else {
//					masterGrid2.getStore().loadData({});
//				}
//			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
//				var cls = '';
//				if(record.get('BAL_TYPE') == '매출'){
//					cls = 'x-change-cell';
//				} else if(record.get('BAL_TYPE') == '수금') {
//					cls = 'x-change-yellow';
//				} else if(record.get('BAL_TYPE') == '매입') {
//					cls = 'x-change-blue1';
//				} else if(record.get('BAL_TYPE') == '지급') {
//					cls = 'x-change-blue2';
//				} else if(record.get('BAL_TYPE') == '선급') {
//					cls = 'x-change-pink';
//				}
//				return cls;
			}
		},
		//20210108 추가: 링크 넘어가는 로직 추가
		goto_ssa615skrv:function(record) {
			if(record) {
				var params = {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.data['DIV_CODE'],
					'CUSTOM_CODE'	: record.data['CUSTOM_CODE'],
					'CUSTOM_NAME'	: record.data['CUSTOM_NAME'],
					'FrDate'		: panelSearch.getValue('FrDate'),
					'ToDate'		: panelSearch.getValue('ToDate')
				}
				var rec1 = {data : {'ssa615skrv' : PGM_ID, 'text': ''}};
				parent.openTab(rec1, '/sales/ssa615skrv.do', params, CHOST + CPATH);
			}
		}
	});



	Unilite.Main({
		id			: 'ssa630skrvApp',
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
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('FrDate'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('ToDate'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('FrDate'	, UniDate.get('startOfMonth'));
			panelResult.setValue('ToDate'	, UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset',false);

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					panelSearch.setValue('DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'	, params.DIV_CODE);
					panelSearch.setValue('FrDate'	, params.BASIS_DATE);
					panelResult.setValue('FrDate'	, params.BASIS_DATE);
					panelSearch.setValue('ToDate'	, params.BASIS_DATE);
					panelResult.setValue('ToDate'	, params.BASIS_DATE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
//		processParams: function(params) {
//			panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
//			panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
//			panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
//			panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
//			panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
//			panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
//			masterGrid.getStore().loadStoreRecords();
//		}
	});
};
</script>