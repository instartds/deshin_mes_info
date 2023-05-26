<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr160skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="btr160skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!-- 품목계정 -->
	<%-- <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/> --%>		<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /> <!--창고Cell-->
	<t:ExtComboStore comboType="O" storeId="whList" />	 				<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> 				<!--담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011" /> 				<!--마감정보-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
</t:appConfig>

<script type="text/javascript" >
var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsLotNoYN	: '${gsLotNoYN}',
	gsCellCodeYN: '${gsCellCodeYN}'
};

function appMain() {
	var LotNoYN = true;
		if(BsaCodeInfo.gsLotNoYN =='Y') {
			LotNoYN = false;
		}
	var CellCodeYN = true;
		if(BsaCodeInfo.gsCellCodeYN =='Y') {
			CellCodeYN = false;
		}

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Btr160skrvModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',		type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',			type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',		type: 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'OUT_WH_NAME'		, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',	type: 'string'},
			{name: 'OUT_WH_CODE'		, text: '<t:message code="system.label.inventory.issuewarehousename" default="출고창고명"/>',		type: 'string'},
			{name: 'OUT_WH_CELL_NAME'	, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',	type: 'string'},
			{name: 'ITEM_STATUS_NAME'	, text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>',		type: 'string'},
			{name: 'REQSTOCK_Q'			, text: '<t:message code="system.label.inventory.requestqty" default="요청량"/>',			type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',			type: 'uniQty'},
			{name: 'NOTSTOCK_Q'			, text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'OUTSTOCK_DATE'		, text: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>',		type: 'uniDate'},
			{name: 'REQSTOCK_NUM'		, text: '<t:message code="system.label.inventory.moverequestno" default="이동요청번호"/>',	type: 'string'},
			{name: 'REQSTOCK_SEQ'		, text: '<t:message code="system.label.inventory.seq" default="순번"/>',			type: 'string'},
			{name: 'REQSTOCK_DATE'		, text: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',			type: 'uniDate'},
			{name: 'CLOSE_YN'			, text: '<t:message code="system.label.inventory.requestclosing" default="요청마감"/>',		type: 'string', comboType: 'AU', comboCode: 'S011'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.receiptdivision2" default="받을사업장"/>',		type: 'string'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',	type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',		type: 'string'},
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.inventory.receiptwarehousecellname" default="받을창고Cell명"/>',	type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',		type: 'uniQty'},
			{name: 'REQ_PRSN'			, text: '<t:message code="system.label.inventory.charger" default="담당자"/>',			type: 'string', comboType: 'AU', comboCode: 'B024',		autoSelect	: false},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',			type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',			type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>',	type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.inventory.writer" default="작성자"/>',	 		type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.inventory.writtendate" default="작성일"/>',		type: 'string'},
			//20200320 추가: 수주번호, 순번
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('btr160skrvMasterStore1',{
		model: 'Btr160skrvModel',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'btr160skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: ''
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
					name:'DIV_CODE',
					child:'WH_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					value: UserInfo.divCode,		//20200707 추가
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'REQSTOCK_DATE_FR',
					endFieldName: 'REQSTOCK_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('REQSTOCK_DATE_FR',newValue);

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('REQSTOCK_DATE_TO',newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					//20200305 추가: 멀티선택
					multiSelect: true,
					child: 'WH_CELL_CODE',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고cell"/>',
					name: 'WH_CELL_CODE',
					fieldWidth: 150,
					hidden: false,
					xtype:'uniCombobox',
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whCellList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CELL_CODE', newValue);
						}
					}
//						multiSelect:true
				},{
					fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
					name: 'REQ_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B024',
					autoSelect	: false,
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){						
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('REQ_PRSN', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
								},
								scope: this
							},
							onClear: function(type) {
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							onClear: function(type) {
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.inventory.closingyn" default="마감여부"/>',
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
						width:60,
						name:'CLOSE_YN',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width:60,
						name:'CLOSE_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
						width:60,
						name:'CLOSE_YN' ,
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('CLOSE_YN').setValue(newValue.CLOSE_YN);
						}
					}
				}]
			},{
				title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
				itemId: 'search_panel2',
			   	layout: {type: 'uniTable', columns: 1},
			   	defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
					name:'OUT_DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001'
				},{
					fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
					name: 'OUT_WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList')
				},{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'TXTLV_L1' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
					child: 'TXTLV_L2'
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
					child: 'TXTLV_L3'
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['TXTLV_L1','TXTLV_L2'],
					levelType:'ITEM'
				},
				Unilite.popup('',{
					fieldLabel: '<t:message code="system.label.inventory.issuerequestno" default="출고요청번호"/>',
					textFieldWidth:170,
					validateBlank:false,
					popupWidth: 710
				}),
				Unilite.popup('',{
					fieldLabel: '~',
					valueFieldName: 'REQSTOCK_NUM_TO',
					textFieldName: 'REQSTOCK_NUM_TO',
					textFieldWidth: 170,
					validateBlank: false,
					popupWidth: 710
				}),{//20200320 추가: 조회조건 추가
					fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
					xtype		: 'uniTextfield',
					name		: 'ORDER_NUM'
				}
			]}
			]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					child:'WH_CODE',
					value: UserInfo.divCode,		//20200707 추가
					allowBlank:false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'REQSTOCK_DATE_FR',
					endFieldName: 'REQSTOCK_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelSearch.setValue('REQSTOCK_DATE_FR',newValue);

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelSearch.setValue('REQSTOCK_DATE_TO',newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse2" default="받을창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					child: 'WH_CELL_CODE',
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.receiptwarehousecell" default="받을창고cell"/>',
					name: 'WH_CELL_CODE',
					xtype:'uniCombobox',
					hidden: false,
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whCellList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CELL_CODE', newValue);
						}
					}
//					multiSelect:true
				},{
					fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
					name: 'REQ_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B024',
					autoSelect	: false,
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('REQ_PRSN', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
								},
								scope: this
							},
							onClear: function(type) {
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
			   }),{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.inventory.closingyn" default="마감여부"/>',
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
						width:60,
						name:'CLOSE_YN',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width:60,
						name:'CLOSE_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
						width:60,
						name:'CLOSE_YN' ,
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.getField('CLOSE_YN').setValue(newValue.CLOSE_YN);
						}
					}
				}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv160skrvGrid1', {
		region: 'center' ,
		layout : 'fit',
		store : directMasterStore1,
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useLiveSearch		: true,			//20200303 추가: 그리드 찾기기능 추가
			useMultipleSorting: true
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false}
		],
		columns:  [
			{dataIndex: 'ITEM_CODE'			,	  	width :120, locked: false},
			{dataIndex: 'ITEM_NAME'			,	  	width :180, locked: false},
			{dataIndex: 'SPEC'				,	  	width :150},
			{dataIndex: 'STOCK_UNIT'		,	  	width :60},
			{dataIndex: 'OUT_DIV_CODE'		,	  	width :100},
			{dataIndex: 'OUT_WH_NAME'		,	  	width :85,hidden:true},
			{dataIndex: 'OUT_WH_CODE'		,	  	width :100},
			{dataIndex: 'OUT_WH_CELL_NAME'	,	  	width :100,hidden: CellCodeYN},
			{dataIndex: 'ITEM_STATUS_NAME'	,	  	width :66},
			{dataIndex: 'REQSTOCK_Q'		,	  	width :80},
			{dataIndex: 'OUTSTOCK_Q'		,	  	width :80},
			{dataIndex: 'NOTSTOCK_Q'		,	  	width :80},
			{dataIndex: 'GOOD_STOCK_Q'		,	  	width :80},
			{dataIndex: 'BAD_STOCK_Q'		,	  	width :80},
			{dataIndex: 'OUTSTOCK_DATE'		,	  	width :80},
			{dataIndex: 'REQSTOCK_NUM'		,	  	width :120},
			{dataIndex: 'REQSTOCK_DATE'		,	  	width :80},
			//20200320 추가: 수주번호, 순번
			{dataIndex: 'ORDER_NUM'			,	  	width :120},
			{dataIndex: 'ORDER_SEQ'			,	  	width :66},
			{dataIndex: 'CLOSE_YN'			,	  	width :66},
			{dataIndex: 'DIV_CODE'			,	  	width :100,hidden:true},
			{dataIndex: 'WH_NAME'			,	  	width :85,hidden:true},
			{dataIndex: 'WH_CODE'			,	  	width :100},
			{dataIndex: 'WH_CELL_NAME'		,	  	width :100,hidden:CellCodeYN},
			{dataIndex: 'INSTOCK_Q'		    ,	  	width :80},
			{dataIndex: 'REQ_PRSN'			,	  	width :100},
			{dataIndex: 'LOT_NO'			,	  	width :120,hidden: LotNoYN},
			{dataIndex: 'REMARK'			,	  	width :133},
			{dataIndex: 'PROJECT_NO'		,	  	width :133},
			{dataIndex: 'UPDATE_DB_USER'	,	  	width :66,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	,	  	width :66,hidden:true}
		],
		//20200226 추가: 재고이동요청 등록으로 링크 기능 추가
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '재고이동요청 등록 바로가기',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'btr160skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							REQSTOCK_NUM: record.data.REQSTOCK_NUM,
							GRID_DATA	: record.data
						}
						var rec = {data : {prgID : 'btr101ukrv', 'text':''}};
						parent.openTab(rec, '/stock/btr101ukrv.do', params);
					}
				});
			}
		}
	});

	Unilite.Main({
		id  : 'btr160skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			this.setDefault();
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			btr160skrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		fnGetreqPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.reqPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function() {
			var field = panelSearch.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var reqPrsn = UniAppManager.app.fnGetreqPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewNormal = masterGrid.getView();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
			panelSearch.setValue('REQSTOCK_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('REQSTOCK_DATE_TO', UniDate.get('today'));
			panelResult.setValue('REQSTOCK_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('REQSTOCK_DATE_TO', UniDate.get('today'));
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>