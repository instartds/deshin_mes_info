<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa615skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa615skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	var BsaCodeInfo = {
		gsLinkPgID1: '${gsLinkPgID1}',
		gsLinkPgID2: '${gsLinkPgID2}',
		gsLinkPgID3: '${gsLinkPgID3}',
		gsLinkPgID4: '${gsLinkPgID4}',
	};
	//20210507 추가: 링크에서 넘어왔을 때 ,제일 아래행 보여주기 위해 수정
	var gsLinkFlag = '';

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
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
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
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					allowBlank	: false,
					listeners	: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
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
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
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
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			allowBlank	: false,
			listeners	: {
				onTextSpecialKey: function(field, event) {
					if(event.getKey() == event.ENTER) {
						panelResult.getField('CUSTOM_NAME').blur();
					}
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						//20210503 추가: 거래처 팝업 값 set되면 조회되도록 수정
						if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown();}, 100);
						}
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('ssa615skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'BAL_TYPE'		, text: '<t:message code="system.label.base.classfication" default="구분"/>'		, type: 'string'},
			{name: 'SALE_DATE'		, text: '<t:message code="system.label.sales.date" default="일자"/>'				, type: 'string'},
			{name: 'SALE_AMT'		, text: '<t:message code="system.label.sales.sales1" default="매출/지급"/>'			, type: 'uniFC'},
			{name: 'COLLECT_AMT'	, text: '수금/매입'		,type: 'uniFC'},
			{name: 'BALANCE_AMT'	, text: '<t:message code="system.label.sales.balanceamount2" default="잔액"/>'	, type: 'uniFC'},
			{name: 'CARD_SALE'		, text: '카드매출'		,type: 'uniFC'},
			{name: 'PRE_PAY'		, text: '선급/선수 반제'	,type: 'uniFC'},
			{name: 'BASIS_NUM'		, text: '<t:message code="system.label.sales.basisno" default="근거번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'PUB_YN'			, text: '계산서'		, type: 'string'}	//20210507 추가
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa615skrvMasterStore1',{
		model	: 'ssa615skrvModel1',
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
				read: 'ssa615skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'SALE_MONTH'
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa615skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {useRowNumberer: true},
		selModel: 'rowmodel',				//20210429 추가
		flex	: 3,						//20210503 추가
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns	: [
			{ dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'BAL_TYPE'		, width: 133, align: 'center'},
			{ dataIndex: 'SALE_DATE'	, width: 133, align: 'center',
				summaryType: function(records) {
					var rv="";
					if(records.length > 0) {
						var colData = records[0].data.SALE_DATE;
						if(Ext.isEmpty(colData)) {
							if( records.length > 1) {	//이월된 금액 첫행의 일자 컬럼이 비어있음
								colData = records[1].data.SALE_DATE
							}
						}
						if(!Ext.isEmpty(colData)) {
							rv = (colData.substr(5,1)=='0') ? colData.substr(6,1): colData.substr(5,2);
							rv = rv+'<t:message code="system.label.sales.monthtotal" default="월계"/>';
						}
					}
					return rv;
				},
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, Ext.String.format('{0} ', value), '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'SALE_AMT'		, width: 200, summaryType: 'sum'},
			{ dataIndex: 'COLLECT_AMT'	, width: 200, summaryType: 'sum'},
			{ dataIndex: 'BALANCE_AMT'	, width: 200, /*summaryType: 'sum'*/
				summaryType: function(records) {
					var rv = 0;
					if(records != null && records.length > 0) {
						var record = records[records.length - 1];
						rv = record.get('BALANCE_AMT');
					}
					return rv;
				}
			},
			{ dataIndex: 'CARD_SALE'	, width: 160, summaryType: 'sum'},
			{ dataIndex: 'PRE_PAY'		, width: 160, summaryType: 'sum'},
			{ dataIndex: 'BASIS_NUM'	, width: 133},
			{ dataIndex: 'CUSTOM_CODE'	, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'	, width: 133, hidden: true},
			{ dataIndex: 'PUB_YN'		, width: 100, align: 'center'}				//20210507 추가
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			if(record.get('BAL_TYPE') == '매입') {
				menu.down('#gsLinkPgID1').show();
				menu.down('#gsLinkPgID2').hide();
				menu.down('#gsLinkPgID3').hide();
				menu.down('#gsLinkPgID4').hide();
			} else if(record.get('BAL_TYPE') == '매출') {
				menu.down('#gsLinkPgID1').hide();
				menu.down('#gsLinkPgID2').show();
				menu.down('#gsLinkPgID3').hide();
				menu.down('#gsLinkPgID4').hide();
			} else if(record.get('BAL_TYPE') == '수금') {
				menu.down('#gsLinkPgID1').hide();
				menu.down('#gsLinkPgID2').hide();
				menu.down('#gsLinkPgID3').show();
				menu.down('#gsLinkPgID4').hide();
			} else if(record.get('BAL_TYPE') == '선급' || record.get('BAL_TYPE') == '지급') {
				menu.down('#gsLinkPgID1').hide();
				menu.down('#gsLinkPgID2').hide();
				menu.down('#gsLinkPgID3').hide();
				menu.down('#gsLinkPgID4').show();
			} else {
				menu.down('#gsLinkPgID1').hide();
				menu.down('#gsLinkPgID2').hide();
				menu.down('#gsLinkPgID3').hide();
				menu.down('#gsLinkPgID4').hide();
			}
			return true;
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
			},{
				text	: '회계전표입력 이동',
				itemId	: 'gsLinkPgID4',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj200(param.record);
				}
			}]
		},
		gotoMap100:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID1.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID1.split('/')[2].length - 3);
				var params		= {
					action		: 'select',
					'PGM_ID'	: 'ssa615skrv',
					'DIV_CODE'	: record.get('DIV_CODE'),
					'BASIS_NUM'	: record.get('BASIS_NUM')
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
					'PGM_ID'		: 'ssa615skrv',
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
					'PGM_ID'		: 'ssa615skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BASIS_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '수금등록'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID3, params);
			}
		},
		// 회계전표입력 
		gotoAgj200:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsLinkPgID4.split('/')[2].substring(0, BsaCodeInfo.gsLinkPgID4.split('/')[2].length - 3);
				var params		= {
					action			: 'select',
					'PGM_ID'		: 'ssa615skrv',
					'DIV_CODE'		: record.get('DIV_CODE'),
					'BASIS_NUM'		: record.get('BASIS_NUM')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': '회계전표입력'}};
				parent.openTab(rec1, BsaCodeInfo.gsLinkPgID4, params);
			}
		},
		//20210429 추가
		listeners: {
			select: function(grid, selected, index, rowIndex, eOpts ){
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected) 
				&& (selected.get('BAL_TYPE') == '매출' || selected.get('BAL_TYPE') == '매입' || selected.get('BAL_TYPE') == '수금' || selected.get('BAL_TYPE') == '지급')) {
					masterGrid2.getStore().loadStoreRecords(selected);
				} else {
					masterGrid2.getStore().loadData({});
				}
			}
		},
		//20210507 추가
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('PUB_YN') == '미발행'){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});



	//20210429 추가
	Unilite.defineModel('ssa615skrvModel2', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type:'string', comboType: 'BOR120'},
			{name: 'SALE_DATE'		,text: '<t:message code="system.label.sales.date" default="일자"/>'				,type: 'uniDate'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'SALE_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string'},
			{name: 'SALE_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'SALE_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'SALE_AMT_O'		,text: '<t:message code="system.label.common.amount" default="금액"/>' 			,type: 'uniPrice'},
			{name: 'TAX_AMT_O'		,text: '<t:message code="system.label.sales.vat" default="부가세"/>'				,type: 'uniPrice'},
			{name: 'SALE_TOT_O'		,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'		,type: 'uniPrice'},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
			{name: 'SALE_NAME'		,text: '<t:message code="system.label.sales.charger" default="담당자"/>'			,type: 'string'},
			{name: 'PUB_YN'			,text: '계산서'		,type: 'string'}	//20210507 추가
		]
	});

	var directMasterStore2 = Unilite.createStore('ssa615skrvMasterStore2',{
		model	: 'ssa615skrvModel2',
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
				read: 'ssa615skrvService.selectList2'
			}
		},
		loadStoreRecords: function(record) {
			var param		= panelSearch.getValues();
			param.BAL_TYPE	= record.get('BAL_TYPE');
			param.SALE_DATE	= record.get('SALE_DATE');
			param.BASIS_NUM	= record.get('BASIS_NUM');
			console.log( param );
			this.load({
				params	: param,
				//20210507 추가: 링크에서 넘어왔을 때 ,제일 아래행 보여주기 위해 수정
				callback: function(records, operation, success) {
					if(gsLinkFlag == 'Y') {
						var view		= masterGrid.getView();
						var navi		= view.getNavigationModel();
						var currRowIndex= masterGrid.store.data.items.length;
						navi.setPosition(currRowIndex -1 , 0);
						masterGrid.getSelectionModel().select(currRowIndex -1);
						gsLinkFlag = '';
					}
				}
			});
		}/*,
		groupField: 'SALE_MONTH'*/
	});

	var masterGrid2 = Unilite.createGrid('ssa615skrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		flex	: 2,				//20210503 추가
		split	: true,				//20210503 추가
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: true
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
		 			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
//			{ dataIndex: 'DIV_CODE'		, width: 100},
			{ dataIndex: 'SALE_DATE'	, width: 90 },
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 200},
			{ dataIndex: 'SPEC'			, width: 150},
			{ dataIndex: 'SALE_UNIT'	, width: 80 },
			{ dataIndex: 'SALE_Q'		, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'SALE_P'		, width: 110},
			{ dataIndex: 'SALE_AMT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'TAX_AMT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'SALE_TOT_O'	, width: 110	, summaryType: 'sum'},
			{ dataIndex: 'REMARK'		, width: 233},
			{ dataIndex: 'SALE_NAME'	, width: 100	, align: 'center'},
			{ dataIndex: 'PUB_YN'		, width: 100	, align: 'center'}				//20210507 추가
		],
		//20210507 추가
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('PUB_YN') == '미발행'){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'ssa615skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult, masterGrid2	//20210429 추가: , masterGrid2
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			if(params && !Ext.isEmpty(params.CUSTOM_CODE)){
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid2.getStore().loadData({});
			masterGrid.getStore().loadStoreRecords();
		},
		processParams: function(params) {
			gsLinkFlag = 'Y';											//20210507 추가: 링크에서 넘어왔을 때 ,제일 아래행 보여주기 위해 수정
			panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
			panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
			panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
			panelSearch.setValue('FrDate'		, params.FrDate);		//20210504 추가
			panelSearch.setValue('ToDate'		, params.ToDate);		//20210504 추가
			panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
			panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
			panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
			panelResult.setValue('FrDate'		, params.FrDate);		//20210504 추가
			panelResult.setValue('ToDate'		, params.ToDate);		//20210504 추가
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>