<%--
'   프로그램명 : 년간입고현황집계 (구매재고)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr170rkrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>	<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031"/>	<!-- 생성경로 --> 
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Mtr170rkrvModel', {
		fields: [
			{name: 'INDEX_01'	, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'INDEX_02'	, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'AMOUNT_I1'	, text: '<t:message code="system.label.purchase.year" default="년"/>1<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I2'	, text: '<t:message code="system.label.purchase.year" default="년"/>2<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I3'	, text: '<t:message code="system.label.purchase.year" default="년"/>3<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I4'	, text: '<t:message code="system.label.purchase.year" default="년"/>4<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I5'	, text: '<t:message code="system.label.purchase.year" default="년"/>5<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I6'	, text: '<t:message code="system.label.purchase.year" default="년"/>6<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I7'	, text: '<t:message code="system.label.purchase.year" default="년"/>7<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I8'	, text: '<t:message code="system.label.purchase.year" default="년"/>8<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I9'	, text: '<t:message code="system.label.purchase.year" default="년"/>9<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I10'	, text: '<t:message code="system.label.purchase.year" default="년"/>10<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I11'	, text: '<t:message code="system.label.purchase.year" default="년"/>11<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I12'	, text: '<t:message code="system.label.purchase.year" default="년"/>12<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I13'	, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Mtr170rkrvModel', {

	Unilite.defineModel('Mtr170rkrvModel2', {
		fields: [
			{name: 'INDEX_01'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
			{name: 'INDEX_02'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'AMOUNT_I1'		, text: '<t:message code="system.label.purchase.year" default="년"/>1<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I2'		, text: '<t:message code="system.label.purchase.year" default="년"/>2<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I3'		, text: '<t:message code="system.label.purchase.year" default="년"/>3<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I4'		, text: '<t:message code="system.label.purchase.year" default="년"/>4<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I5'		, text: '<t:message code="system.label.purchase.year" default="년"/>5<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I6'		, text: '<t:message code="system.label.purchase.year" default="년"/>6<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I7'		, text: '<t:message code="system.label.purchase.year" default="년"/>7<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I8'		, text: '<t:message code="system.label.purchase.year" default="년"/>8<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I9'		, text: '<t:message code="system.label.purchase.year" default="년"/>9<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I10'		, text: '<t:message code="system.label.purchase.year" default="년"/>10<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I11'		, text: '<t:message code="system.label.purchase.year" default="년"/>11<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I12'		, text: '<t:message code="system.label.purchase.year" default="년"/>12<t:message code="system.label.purchase.month" default="월"/>'		, type: 'uniPrice'},
			{name: 'AMOUNT_I13'		, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('mtr170rkrvMasterStore1',{
		model	: 'Mtr170rkrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mtr170rkrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param['GUBUN'] = '1';
			console.log( param );
			this.load({
				params: param
			});
		}//,
		//groupField: 'ITEM_CODE'
	});

	var directMasterStore2 = Unilite.createStore('mtr170rkrvMasterStore2',{
		model	: 'Mtr170rkrvModel2',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mtr170rkrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param['GUBUN'] = '2';
			console.log( param );
			this.load({
				params: param
			});
		}//,
		//groupField: 'CUSTOM_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120', 
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>',
				fieldStyle	: 'text-align:center;',
				value		: UniDate.get('startOfMonth'), 
				name		: 'BASIS_YYYYMM',
				xtype		: 'uniMonthfield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_YYYYMM', newValue);
						//20210120 추가: 기준일자 변경 시, 컬럼명 변경
						if(Ext.isDate(newValue)) {
							masterGrid.getStore().loadData({});
							masterGrid2.getStore().loadData({});
							masterGrid.setColumnHeader(newValue);
							masterGrid2.setColumnHeader(newValue);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboCode	: 'B024',
				comboType	: 'AU',
				allowBlank	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2'
			},{ 
				fieldLabel	: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3'
			},{ 
				fieldLabel	: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store')
			},{
				fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name		: 'CREATE_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B031'
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.basisinquiry" default="조회기준"/>',
				labelWidth	: 90,
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.amount" default="금액"/>',
					name		: 'VIEW_OPT',
					id			: 'VIEW_OPT_1',
					width		: 80,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.qty" default="수량"/>',
					name		: 'VIEW_OPT',
					id			: 'VIEW_OPT_2',
					width		: 80,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue == 2){
						}
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.expenseinclude" default="부대비포함"/>',
				id			: 'EXPENSE_YN',
				labelWidth	: 90,
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.yes" default="예"/>',
					name		: 'EXPENSE_YN',
					inputValue	: 'Y',
					width		: 80
				},{
					boxLabel	: '<t:message code="system.label.purchase.no" default="아니오"/>',
					name		: 'EXPENSE_YN',
					inputValue	: 'N',
					width		: 80,
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.basisyearmonth" default="기준년월"/>',
			fieldStyle	: 'text-align:center;',
			value		: UniDate.get('startOfMonth'),
			name		: 'BASIS_YYYYMM',
			xtype		: 'uniMonthfield',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_YYYYMM', newValue);
					//20210120 추가: 기준일자 변경 시, 컬럼명 변경
					if(Ext.isDate(newValue)) {
						masterGrid.getStore().loadData({});
						masterGrid2.getStore().loadData({});
						masterGrid.setColumnHeader(newValue);
						masterGrid2.setColumnHeader(newValue);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboCode	: 'B024',
			comboType	: 'AU',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_PRSN', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r= false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('mtr170rkrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'INDEX_01'		, width: 130	, locked: true
//				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
//				}
			},
			{dataIndex: 'INDEX_02'		, width: 133	, locked: true},
			{dataIndex: 'AMOUNT_I1'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I2'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I3'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I4'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I5'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I6'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I7'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I8'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I9'		, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I10'	, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I11'	, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I12'	, width: 100	, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I13'	, width: 100	, summaryType:'sum'}
		],
		setColumnHeader : function(time) {
			var year	= time.getFullYear();
			var month	= time.getMonth()+1;
			for(var i=1;i<13;i++){
				var title	= '';
				var t_month	= (month+i)%13;
				var t_year	= (month - t_month)< 0 ? year-1 : year ; 
				var column	= this.getColumn('AMOUNT_I'+i); 

				if(year != t_year){
					column.setText(t_year+'년 '+t_month+'월');
				}else{
					var t_month1 = parseInt(t_month) + 1;
					column.setText(t_year+'년 '+t_month1+'월');
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('mtr170rkrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'INDEX_01'		, width: 80	, locked: true
//				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customcode" default="거래처코드"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
//				}
			},
			{dataIndex: 'INDEX_02'		, width: 133, locked: true},
			{dataIndex: 'AMOUNT_I1'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I2'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I3'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I4'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I5'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I6'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I7'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I8'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I9'		, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I10'	, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I11'	, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I12'	, width: 100, summaryType:'sum'},
			{dataIndex: 'AMOUNT_I13'	, width: 100, summaryType:'sum'}
		],
		setColumnHeader : function(time) {
			var year = time.getFullYear();
			var month = time.getMonth()+1;
			for(var i=1;i<13;i++){
				var title	= '';
				var t_month	= (month+i)%13;
				var t_year	= (month - t_month)< 0 ? year-1 : year ; 
				var column	= this.getColumn('AMOUNT_I'+i); 

				if(year != t_year){
					column.setText(t_year+'년 '+t_month+'월');
				}else{
					var t_month1 = parseInt(t_month) + 1;
					column.setText(t_year+'년 '+t_month1+'월');
				}
			}
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid],
			id		: 'mtr170rkrvGridTab1'
		},{
			title	: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid2],
			id		: 'mtr170rkrvGridTab2'
		}],
		listeners: {
			tabChange: function ( tabPanel, newCard, oldCard, eOpts ) {
				var newTabId = newCard.getId();
				console.log("newCard:  " + newCard.getId());
				console.log("oldCard:  " + oldCard.getId());
				//탭 넘길때마다 초기화
				UniAppManager.setToolbarButtons(['save', 'newData'], false);
				panelResult.setAllFieldsReadOnly(false);
			}
		}
	});



	Unilite.Main({
		id			: 'mtr170rkrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset'	, true);
			UniAppManager.setToolbarButtons('save'	, false);
			masterGrid.setColumnHeader(panelSearch.getValue('BASIS_YYYYMM'));
			masterGrid2.setColumnHeader(panelSearch.getValue('BASIS_YYYYMM'));
		},
		onQueryButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'mtr170rkrvGridTab1'){
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked: ",viewLocked);
				console.log("viewNormal: ",viewNormal);
				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				UniAppManager.setToolbarButtons('excel',true);
				UniAppManager.setToolbarButtons('print',true);
			}else if(activeTabId == 'mtr170rkrvGridTab2'){
				masterGrid2.getStore().loadStoreRecords();
				var viewLocked = masterGrid2.lockedGrid.getView();
				var viewNormal = masterGrid2.normalGrid.getView();
				console.log("viewLocked: ",viewLocked);
				console.log("viewNormal: ",viewNormal);
				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				UniAppManager.setToolbarButtons('excel',true);
				UniAppManager.setToolbarButtons('print',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setValue('BASIS_YYYYMM', UniDate.get('startOfMonth'));
			panelResult.setValue('BASIS_YYYYMM', UniDate.get('startOfMonth'));
			masterGrid.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true),
					panelResult.setAllFieldsReadOnly(true);
		},
		onPrintButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			var param = panelSearch.getValues();
			if(activeTabId == 'mtr170rkrvGridTab1'){
				param['GUBUN'] = '1';
			} else {
				param['GUBUN'] = '2';
			}
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/mtr/mtr170rkrPrint.do',
				prgID: 'mtr170rkr',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>