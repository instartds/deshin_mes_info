<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa625skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa625skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>			<!-- 예/아니오 -->
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

var detailInfoWindow;		//상제정보 조회 팝업 - 20210512 추가
var detailSeachParam;		//상제정보 조회 팝업 조회조건- 20210512 추가

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
				},{
		            xtype: 'radiogroup',
		            fieldLabel: '수금여부',
		            items: [{
		                boxLabel: '전체',
		                width: 60,
		                name: 'COLLECT_YN',
		                inputValue: 'A',
		                checked: true
		            },{
		                boxLabel: '예',
		                width: 50, name: 'COLLECT_YN',
		                inputValue: 'Y'
		            },{
		                boxLabel: '아니오',
		                width: 60, name: 'COLLECT_YN',
		                inputValue: 'N'
		            }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('COLLECT_YN').setValue(newValue.COLLECT_YN);
						}
					}
		        },{
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
					validateBlank	: false,		//20210504 추가: 부분 조건 가능하도록 추가
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
		layout	: {type : 'uniTable', columns : 3},
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
		},{
            xtype: 'radiogroup',
            fieldLabel: '수금여부',
            items: [{
                boxLabel: '전체',
                width: 60,
                name: 'COLLECT_YN',
                inputValue: 'A',
                checked: true
            },{
                boxLabel: '예',
                width: 50, name: 'COLLECT_YN',
                inputValue: 'Y'
            },{
                boxLabel: '아니오',
                width: 60, name: 'COLLECT_YN',
                inputValue: 'N'
            }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('COLLECT_YN').setValue(newValue.COLLECT_YN);
				}
			}
        },{
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
			validateBlank	: false,		//20210504 추가: 부분 조건 가능하도록 추가
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
	Unilite.defineModel('ssa625skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'BASE_DATE'		, text: '<t:message code="system.label.sales.date" default="일자"/>'				, type: 'uniDate'},
			{name: 'BAL_TYPE'		, text: '<t:message code="system.label.base.classfication" default="구분"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CONTENTS'		, text: '<t:message code="system.label.sales.remark" default="적요"/>'			, type: 'string'},
			{name: 'AMT_I'		, text: '<t:message code="system.label.sales.amount" default="금액"/>'				, type: 'uniFC'},		//20210512 추가
			{name: 'TAX_AMT_O'	, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniFC'},		//20210512 추가
			{name: 'TOT_AMT'		, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'	, type: 'uniFC'},
			{name: 'FEE_RATE'		, text: '수수료율(%)'																, type: 'uniPercent'},	//20210512 추가
			{name: 'AMT_ECEPT_FEE'	, text: '금액(수수료제외)'																, type: 'uniFC'},		//20210512 추가
			{name: 'CARD_SALE'		, text: '<t:message code="system.label.sales.creditcardsale" default="카드매출"/>'	, type: 'uniFC'},
			{name: 'SALE_COST'		, text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'		, type: 'uniFC'},
			{name: 'SALE_PROFIT'	, text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'		, type: 'uniFC'},
			{name: 'PROFIT_RATE'	, text: '<t:message code="system.label.sales.profitrate" default="이익율"/>(%)'	, type: 'uniPercent'},	//20210512 추가
			{name: 'SALE_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'			, type: 'string'},		//20210512 추가
			{name: 'BASIS_NUM'		, text: '<t:message code="system.label.sales.basisno" default="근거번호"/>'			, type: 'string'},
			{name: 'CUST_NAME'		, text: '고객명'																	, type: 'string'},
			{name: 'COLLECT_O'		, text: '수금액'																	, type: 'uniQty'},
			{name: 'COLLECT_YN'		, text: '수금여부'																	, type: 'string', comboType: 'AU', comboCode: 'A020'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa625skrvMasterStore1',{
		model	: 'ssa625skrvModel1',
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
				read: 'ssa625skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'BASE_DATE'
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa625skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useRowNumberer	: true,
			expandLastColumn: false
		},
		flex	: 3,
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'BASE_DATE'	, width: 90, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'BAL_TYPE'		, width: 90,  align: 'center'},
			{ dataIndex: 'CUSTOM_CODE'	, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'	, width: 130},
			{ dataIndex: 'CONTENTS'		, width: 170},
			{ dataIndex: 'AMT_I'		, width: 120, summaryType: 'sum'},		//20210512 추가
			{ dataIndex: 'TAX_AMT_O'	, width: 115, summaryType: 'sum'},		//20210512 추가
			{ dataIndex: 'TOT_AMT'		, width: 120, summaryType: 'sum'},
			{ dataIndex: 'FEE_RATE'		, width: 110},							//20210512 추가
			{ dataIndex: 'AMT_ECEPT_FEE', width: 125, summaryType: 'sum'},		//20210512 추가
			{ dataIndex: 'CARD_SALE'	, width: 100, summaryType: 'sum'},
			{ dataIndex: 'SALE_COST'	, width: 120, summaryType: 'sum'},
			{ dataIndex: 'SALE_PROFIT'	, width: 120, summaryType: 'sum'},
			{ dataIndex: 'PROFIT_RATE'	, width: 100},							//20210512 추가
			{ dataIndex: 'SALE_NAME'	, width: 100, align: 'center'},			//20210512 추가
			{ dataIndex: 'BASIS_NUM'	, width: 120},
			{ dataIndex: 'CUST_NAME'	, width: 120, hidden: true},
			{ dataIndex: 'COLLECT_O'	, width: 100, summaryType: 'sum'},
			{ dataIndex: 'COLLECT_YN'	, width: 80,  align: 'center'}
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
					'PGM_ID'		: 'ssa625skrv',
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
					'PGM_ID'		: 'ssa625skrv',
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
					'PGM_ID'		: 'ssa625skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BASIS_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '수금등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID3, params);
			}
		},
		listeners: {
			cellclick : function ( gridView, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				//선택된 행의 저장된 데이터만 masterGrid2에 보여주도록 filter
				if(!Ext.isEmpty(record) 
				&& (record.get('BAL_TYPE') == '매출' || record.get('BAL_TYPE') == '매입')) {
					masterGrid2.getStore().loadStoreRecords(record);
				} else {
					masterGrid2.getStore().loadData({});
				}
			},
			select: function(grid, selected, index, rowIndex, eOpts ){
				//선택된 행의 저장된 데이터만 masterGrid2에 보여주도록 filter
				if(!Ext.isEmpty(selected) 
				&& (selected.get('BAL_TYPE') == '매출' || selected.get('BAL_TYPE') == '매입')) {
					masterGrid2.getStore().loadStoreRecords(selected);
				} else {
					masterGrid2.getStore().loadData({});
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('BAL_TYPE') == '매출'){
					cls = 'x-change-cell';
				} else if(record.get('BAL_TYPE') == '수금') {
					cls = 'x-change-yellow';
				} else if(record.get('BAL_TYPE') == '매입') {
					cls = 'x-change-blue1';
				} else if(record.get('BAL_TYPE') == '지급') {
					cls = 'x-change-blue2';
				} else if(record.get('BAL_TYPE') == '선급') {
					cls = 'x-change-pink';
				}
				return cls;
			}
		}
	});



	Unilite.defineModel('ssa625skrvModel2', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type:'string', comboType: 'BOR120'},
			{name: 'BASE_DATE'		, text: '<t:message code="system.label.sales.date" default="일자"/>'				, type: 'uniDate'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'SALE_UNIT'		, text: '<t:message code="system.label.sales.unit" default="단위"/>'				, type: 'string'},
			{name: 'SALE_Q'			, text: '<t:message code="system.label.sales.qty" default="수량"/>'				, type: 'uniQty'},
			{name: 'SALE_P'			, text: '<t:message code="system.label.sales.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'SALE_P_VAT'		, text: '단가(V)',  type: 'uniUnitPrice'},
			{name: 'SALE_AMT_O'		, text: '<t:message code="system.label.common.amount" default="금액"/>' 			, type: 'uniFC'},
			{name: 'TAX_AMT_O'		, text: '<t:message code="system.label.sales.vat" default="부가세"/>'				, type: 'uniFC'},
			{name: 'SALE_TOT_O'		, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'	, type: 'uniFC'},
			{name: 'SALE_COST'		, text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'		, type: 'uniFC'},		//20210510 추가
			{name: 'SALE_PROFIT'	, text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'		, type: 'uniFC'},		//20210510 추가
			{name: 'REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'},
			{name: 'SALE_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: 'ITEM_ACCOUNT'	, type: 'string'},																//20210512 추가: 상세정보 버튼 컨트롤하기 위해
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, type: 'string'},		//20210512 추가: 상세정보 팝업 데이터 조회 위해 추가
			{name: 'SER_NO'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'},			//20210512 추가: 상세정보 팝업 데이터 조회 위해 추가
			{name: 'BILL_NUM'		, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'			, type: 'string'},		//20210608 추가: 상세정보 팝업 데이터 조회 위해 추가
			{name: 'BILL_SEQ'		, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'}			//20210608 추가: 상세정보 팝업 데이터 조회 위해 추가
		]
	});

	var directMasterStore2 = Unilite.createStore('ssa625skrvMasterStore2',{
		model	: 'ssa625skrvModel2',
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
				read: 'ssa625skrvService.selectList2'
			}
		},
		loadStoreRecords: function(record) {
			var param		= panelSearch.getValues();
			param.BAL_TYPE	= record.get('BAL_TYPE');
			param.BASE_DATE	= UniDate.getDateStr(record.get('BASE_DATE'));
			param.BASIS_NUM	= record.get('BASIS_NUM');
			console.log( param );
			this.load({
				params: param
			});
		}/*,
		groupField: 'SALE_MONTH'*/
	});

	var masterGrid2 = Unilite.createGrid('ssa625skrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		flex	: 2,
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: true
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
//			{ dataIndex: 'DIV_CODE'		, width: 100},
//			{ dataIndex: 'ITEM_ACCOUNT'	, width: 100	, hidden: false},
			{ dataIndex: 'ORDER_NUM'	, width: 100	, hidden: false},
			{ dataIndex: 'SER_NO'		, width: 100	, hidden: false},
			{ dataIndex: 'BILL_NUM'		, width: 100	, hidden: false},	//20210608 추가: 상세정보 팝업 데이터 조회 위해 추가
			{ dataIndex: 'BILL_SEQ'		, width: 100	, hidden: false},	//20210608 추가: 상세정보 팝업 데이터 조회 위해 추가
			{ dataIndex: 'BASE_DATE'	, width: 90 },
			{ dataIndex: 'ITEM_CODE'	, width: 110},
			{ dataIndex: 'ITEM_NAME'	, width: 160},
			{ dataIndex: 'SPEC'			, width: 140},
			{ dataIndex: 'SALE_UNIT'	, width: 70 },
			{ dataIndex: 'SALE_Q'		, width: 90		, summaryType: 'sum'},
			{ dataIndex: 'SALE_P'		, width: 100	, hidden: true},
			{ dataIndex: 'SALE_P_VAT'	, width: 100},
			{ dataIndex: 'SALE_AMT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'TAX_AMT_O'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'SALE_TOT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'SALE_COST'	, width: 100	, summaryType: 'sum'},		//20210510 추가
			{ dataIndex: 'SALE_PROFIT'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'SALE_NAME'	, width: 90	, align: 'center'},				//20210512 추가
			{ text: '상세정보'				, dataIndex: 'service', width: 128,			//20210512 추가
				renderer: function(value, metaData, record){
					if(record.get('ITEM_ACCOUNT') == '10' || record.get('ITEM_ACCOUNT') == '20') {
						return "<input type='button' style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='상세정보' >";
					} else {
						return;
					}
 				},
				listeners:{
					click: function(val, metaDate, rowIndex, colIndex, view, record, store){
						if(record.get('ITEM_ACCOUNT') == '10' || record.get('ITEM_ACCOUNT') == '20') {
							detailSeachParam = record;
							openDetailInfoWindow();
						} else {
							return;
						}
					}
 				}
			},
			{ dataIndex: 'REMARK'		, width: 200}
		]
	});



	/** 상세정보 팝업 - 20210512 추가
	 * 
	 */
	Unilite.defineModel('detailInfoModel', {
		fields: [
			{name: 'ITEM_CODE'	, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'	, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SALE_Q'		, text: '<t:message code="system.label.sales.qty" default="수량"/>'				, type: 'uniQty'},
			{name: 'SALE_O'		, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'	, type: 'uniFC'},
			{name: 'SALE_COST'	, text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'		, type: 'uniFC'}
		]
	});

	var detailInfoStore = Unilite.createStore('detailInfoStore', {
		model	: 'detailInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa625skrvService.selectDetailInfo'
			}
		},
		loadStoreRecords : function(record) {
			var param = {
				DIV_CODE	: record.get('DIV_CODE'),
				BILL_NUM	: record.get('BILL_NUM'),		//20210608 수정: ORDER_NUM -> BILL_NUM
				BILL_SEQ	: record.get('BILL_SEQ')		//20210608 수정: SER_NO -> BILL_SEQ
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var detailInfoGrid = Unilite.createGrid('ssa625skrvDetailInfoGrid', {	//조회버튼 누르면 나오는 조회창
		layout		: 'fit',
		excelTitle	: '상세정보',
		store		: detailInfoStore,
		uniOpt		: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns:  [
			{dataIndex: 'ITEM_CODE'		, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_NAME'		, width: 160},
			{dataIndex: 'SALE_Q'		, width: 80	, summaryType: 'sum'},
			{dataIndex: 'SALE_O'		, width: 130, summaryType: 'sum'},
			{dataIndex: 'SALE_COST'		, width: 130, summaryType: 'sum'}
		]
	});

	function openDetailInfoWindow() {
		if(!detailInfoWindow) {
			detailInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '상세정보',
				width	: 785,
				height	: 480,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailInfoGrid],
				tbar	: ['->', {
					itemId	: 'qryBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						detailInfoStore.loadStoreRecords(detailSeachParam);
					},
					disabled: false
				}, {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						detailInfoWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						detailInfoGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						detailInfoGrid.reset();
					},
					show: function( panel, eOpts ) {
						detailInfoStore.loadStoreRecords(detailSeachParam);
					}
				}
			})
		}
		detailInfoWindow.center();
		detailInfoWindow.show();
	}




	Unilite.Main({
		id			: 'ssa625skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult, masterGrid2
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('FrDate'	, UniDate.get('today'));
			panelSearch.setValue('ToDate'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('FrDate'	, UniDate.get('today'));
			panelResult.setValue('ToDate'	, UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset',false);

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					panelSearch.setValue('DIV_CODE'	, params.DIV_CODE);
					panelSearch.setValue('FrDate'	, params.BASIS_DATE);
					panelSearch.setValue('ToDate'	, params.BASIS_DATE);
					panelResult.setValue('DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('FrDate'	, params.BASIS_DATE);
					panelResult.setValue('ToDate'	, params.BASIS_DATE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid2.getStore().loadData({});
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