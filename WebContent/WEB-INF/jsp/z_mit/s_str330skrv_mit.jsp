<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str330skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str330skrv_mit" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S008" /> <!-- 반품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--양불구분-->
	<t:ExtComboStore comboType="OU" />											<!-- 창고-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
var BsaCodeInfo = {
	gsInoutPrsn	: '${gsInoutPrsn}',	//로그인 한 유저의 영업담당자 정보
	gsSendInfo	: '${gsSendInfo}',	//출력 시 로그인 유저의 발신부서 정보
	gsReciInfo1	: '${gsReciInfo1}',	//출력 시 로그인 유저의  수신부서 정보(국내)
	gsReciInfo2	: '${gsReciInfo2}'	//출력 시 로그인 유저의  수신부서 정보(해외)
};
var gsGubunFlag = 'O';

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_str330skrv_mitModel1', {
		fields: [
			{name: 'INOUT_DATE'		,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			,type: 'uniDate'},
			{name: 'INOUT_NUM'		,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'			,type: 'string'},
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'int'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'INOUT_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'			,type: 'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'WH_CELL_NAME'	,text: '출고장소'	, type: 'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
			{name: 'DEPT_NAME'		,text: '작성부서'	, type: 'string'},
			{name: 'PRSN_NAME'		,text: '작성자'	, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_str330skrv_mitMasterStore1',{
		model	: 's_str330skrv_mitModel1',
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
				read: 's_str330skrv_mitService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.NATION_INOUT = gsGubunFlag;
//			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//20200403 주석: 체크박스에서 control하도록 로직 변경
//				if(records != null && records.length > 0 ){
//					UniAppManager.setToolbarButtons('print', true);
//				} else {
//					UniAppManager.setToolbarButtons('print', false);
//				}
			}
		},
		groupField: 'INOUT_DATE'
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
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('INOUT_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_INOUT_DATE',
					endFieldName	: 'TO_INOUT_DATE',
					startDate		: UniDate.get('today'),
					endDate			: UniDate.get('today'),
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_INOUT_DATE',newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
					name		: 'INOUT_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B024',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
					name		: 'WH_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'OU',
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						},
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == panelSearch.getValue('DIV_CODE')
							})
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.classfication" default="구분"/>',
					xtype		: 'radiogroup',
					items		: [{
						boxLabel	: '해외',
						name		: 'NATION_INOUT',
						inputValue	:  'O',
						width		:  70,
						checked		:  true
					},{
						boxLabel	: '국내', 
						name		:  'NATION_INOUT',
						inputValue	:  'I',
						width		:  90
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							gsGubunFlag = newValue.NATION_INOUT;
							if(gsGubunFlag == 'O') {
								panelSearch.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo2);
								panelResult.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo2);
							} else {
								panelSearch.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo1);
								panelResult.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo1);
							}
							panelResult.getField('NATION_INOUT').setValue(newValue.NATION_INOUT);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
					fieldLabel	: '수신부서/수신자',
					name		: 'RECIEVER',
					xtype		: 'uniTextfield',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('RECIEVER', newValue);
						}
					}
				}]
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
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_INOUT_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_INOUT_DATE',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item){
						return item.get('option') == panelSearch.getValue('DIV_CODE')
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.classfication" default="구분"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '해외',
				name		: 'NATION_INOUT',
				inputValue	:  'O',
				width		:  70,
				checked		:  true
			},{
				boxLabel	: '국내', 
				name		:  'NATION_INOUT',
				inputValue	:  'I', 
				width		:  90
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					gsGubunFlag = newValue.NATION_INOUT;
					panelSearch.getField('NATION_INOUT').setValue(newValue.NATION_INOUT);
				}
			}
		},{
			xtype	: 'component',
			width	: 100,
			colspan	: 1
		},{
			xtype	: 'component',
			width	: 100,
			colspan	: 1
		},{
//			fieldLabel	: '출력 관련 필드 - 수신부서 / 수신자',
			fieldLabel	: "<font color = 'blue'>출력 관련 필드 - 수신부서 / 수신자</font>",
			name		: 'RECIEVER',
			xtype		: 'uniTextfield',
			labelWidth	: 406,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECIEVER', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_str330skrv_mitGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		//20200403 추가
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		//20200403 수정: 체크박스모델 사용
//		selModel: 'rowmodel',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(masterGrid.getSelectionModel().getSelection().length > 0) {
						UniAppManager.setToolbarButtons('print', true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if(masterGrid.getSelectionModel().getSelection().length == 0) {
						UniAppManager.setToolbarButtons('print', false);
					}
				}
			}
		}),
		//20200403 주석: 불필요 로직 주석
//		tbar	: [{
//			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
//			xtype		:'uniNumberfield',
//			itemId		: 'selectionSummary',
//			readOnly	: true,
//			value		: 0,
//			labelWidth	: 110,
//			decimalPrecision:4,
//			format		: '0,000.0000'
//		}],
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns	: [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
			{ dataIndex: 'INOUT_DATE'		, width: 80},
			{ dataIndex: 'INOUT_NUM'		, width: 110},
			{ dataIndex: 'INOUT_SEQ'		, width: 66, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '일자별', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 200},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'INOUT_Q'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'LOT_NO'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200},
			{ dataIndex: 'WH_CELL_NAME'		, width: 100},
			{ dataIndex: 'REMARK'			, width: 150},
			{ dataIndex: 'DEPT_NAME'		, width: 150, hidden: true},
			{ dataIndex: 'PRSN_NAME'		, width: 150, hidden: true}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				//20200403 주석: 불필요 로직 주석
//				if(selection && selection.startCell) {
//					var columnName = selection.startCell.column.dataIndex;
//					var displayField= Ext.getCmp("selectionSummary");
//						if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
//						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
//						var store = grid.store;
//						var sum = 0;
//						for(var i=startIdx; i <= endIdx; i++){
//							var record = store.getAt(i);
//							sum += record.get(columnName);
//						}
//						this.down('#selectionSummary').setValue(sum);
//					} else {
//						this.down('#selectionSummary').setValue(0);
//					}
//				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				if(record && !Ext.isEmpty(record.get('INSPEC_NUM'))) {
//					panelSearch.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
//					panelResult.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
//					UniAppManager.setToolbarButtons('print', true);
//				} else {
//					panelSearch.setValue('INSPEC_NUM', '');
//					panelResult.setValue('INSPEC_NUM', '');
//					UniAppManager.setToolbarButtons('print', false);
//				}
			}
		}
	});



	Unilite.Main({
		id			: 's_str330skrv_mitApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('today'));
			panelSearch.getField('NATION_INOUT').setValue('O');

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('today'));
			panelResult.getField('NATION_INOUT').setValue('O');

			panelSearch.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo2);
			panelResult.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo2);
			panelSearch.setValue('INOUT_PRSN'	, BsaCodeInfo.gsInoutPrsn);
			panelResult.setValue('INOUT_PRSN'	, BsaCodeInfo.gsInoutPrsn);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			directMasterStore1.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons('print', false);
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('RECIEVER'))) {
				Unilite.messageBox('수신부서/수신자를 입력한 후 출력하시기 바랍니다.');
				panelResult.getField('RECIEVER').focus();
				return false;
			}
			//20200403 수정: 선택된 데이터만 출력하도록 로직 수정
//			var records = masterGrid.getStore().data.items;
			var records = masterGrid.getSelectedRecords();
			if(records.length == 0) {
				Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
				return false;
			}
			var printInoutData = '';
			Ext.each(records, function(record, index) {
				if(index == 0) {
					printInoutData = record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
				} else {
					printInoutData = printInoutData + ',' + record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');
				}
			});

			var param = panelSearch.getValues();
			param.NATION_INOUT	= gsGubunFlag;
			param.TARGET_DATA	= printInoutData;

			var win;
			win = Ext.create('widget.ClipReport', {
				url		: CPATH + '/z_mit/s_str330clskrv_mit.do',
				prgID	: 's_str330skrv_mit',
				extParam: param,
				submitType : "POST"
			});
			win.center();
			win.show();
		}
	});
};
</script>