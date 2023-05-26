<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str330ukrv_mit" >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str330ukrv_mit" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />							<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />							<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />							<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S008" />							<!-- 반품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Z024" />							<!-- 고객불만유형 -->
	<t:ExtComboStore comboType="OU" />											<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />				<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />		<!-- 창고Cell-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!--소분류-->
</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo = {
		gsInoutPrsn	: '${gsInoutPrsn}'	//20200204 추가: 로그인 한 유저의 영업담당자 정보
	};
	var outWindow;		//20200204 추가: 폐기팝업
	var reInWindow;		//20200204 추가: 재입고팝업

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str330ukrv_mitService.selectList',
			update	: 's_str330ukrv_mitService.updateList',
			create	: 's_str330ukrv_mitService.insertList',
			destroy	: 's_str330ukrv_mitService.deleteList',
			syncAll	: 's_str330ukrv_mitService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str330ukrv_mitService.selectList2',
			update	: 's_str330ukrv_mitService.updateList2',
			create	: 's_str330ukrv_mitService.insertList2',
			destroy	: 's_str330ukrv_mitService.deleteList2',
			syncAll	: 's_str330ukrv_mitService.saveAll2'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_str330ukrv_mitModel1', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.qty" default="수량"/>'					,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.returnqty_stock" default="반품량(재고)"/>'	,type: 'uniQty'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'			,type: 'string',comboType: 'AU',comboCode: 'S008'},
			{name: 'CUSTOM_COMPL'		,text: '고객불만유형'		,type: 'string',comboType: 'AU',comboCode: 'Z024'},				//20191011 CUSTOM_COMPL 추가
			{name: 'CUSTOM_COMPL_GROUP'	,text: '고객불만그룹'		,type: 'string'},												//20191017 고객불만유형에 따른 고객불만그룹 추가
			{name: 'ACCOUNT_YNC'		,text: '매출처리결과'		,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>'		,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string',store : Ext.data.StoreManager.lookup('whList')},
			{name: 'LOCATION'			,text: '위치'			,type: 'string'},
			{name: 'REMARK'				,text: '특이사항'		,type: 'string'},
			{name: 'CONFIRM_YN'			,text: '제품확인'		,type: 'boolean'},
			{name: 'CONFIRM_YN2'		,text: '제품확인'		,type: 'string'},
			{name: 'PROC_METHOD'		,text: '처리방향'		,type: 'string',comboType: 'AU',comboCode: 'S073', allowBlank: false},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.trandivision" default="수불사업장"/>'		,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.returnno" default="반품번호"/>'				,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '순번'			,type: 'int'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'integer'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.returndate" default="반품일"/>'			,type: 'uniDate'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		,text: '<t:message code="system.label.sales.returnamount" default="반품액"/>'			,type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
			{name: 'TOT_INOUT_AMT'		,text: '<t:message code="system.label.sales.returntotalamount" default="반품총액"/>'	,type: 'uniPrice'},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		,type: 'string'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		,text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				,type: 'uniQty'},
			{name: 'OUT_DATE'			,text: '폐기일자'		,type: 'uniDate'},												//20200204 추가: 폐기일자
			{name: 'RE_IN_DATE'			,text: '재입고일자'		,type: 'uniDate'},												//20200204 추가: 재입고일자
			{name: 'NEW_INOUT_SEQ'		,text: '순번'			,type: 'int'}													//20200219 수정 - 신규 SEQ 채번 로직 수정
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_str330ukrv_mitMasterStore1',{
		model	: 's_str330ukrv_mitModel1',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			var authoInfo	= pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			console.log( param );
			this.load({
				params	: param,
				callback: function() {
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(directMasterStore1.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'INSPEC_NUM'
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('s_str330ukrv_mitMasterStore2',{
		model	: 's_str330ukrv_mitModel1',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			//20200219 날짜 조회조건 포맷 수정
			param.INSPEC_DATE_FR	= UniDate.getDbDateStr(confirmTabForm.getValue('INSPEC_DATE_FR'));
			param.INSPEC_DATE_TO	= UniDate.getDbDateStr(confirmTabForm.getValue('INSPEC_DATE_TO'));
			param.LOT_NO			= confirmTabForm.getValue('LOT_NO');
			param.INSPEC_NUM		= confirmTabForm.getValue('INSPEC_NUM');
			//20191017 추가: 품목분류, 품목, 규격
			param.ITEM_LEVEL1		= confirmTabForm.getValue('ITEM_LEVEL1');
			param.ITEM_LEVEL2		= confirmTabForm.getValue('ITEM_LEVEL2');
			param.ITEM_LEVEL3		= confirmTabForm.getValue('ITEM_LEVEL3');
			param.ITEM_CODE			= confirmTabForm.getValue('ITEM_CODE');
			param.ITEM_NAME			= confirmTabForm.getValue('ITEM_NAME');
			param.SPEC				= confirmTabForm.getValue('SPEC');
			
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			console.log( param );
			this.load({
				params	: param,
				callback: function() {
				}
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(directMasterStore2.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
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
				}
			}
		},{
			fieldLabel	: '반품확인일',
			name		: 'INSPEC_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			value		: UniDate.get('today'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_str330ukrv_mitGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		features: [ {id: 'masterGrid1SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id: 'masterGrid1Total'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_NUM'			, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_SEQ'			, width: 100	, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 220},
			{ dataIndex: 'SPEC'					, width: 160},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100},
			{ dataIndex: 'INOUT_Q'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 130},
			//20191011 CUSTOM_COMPL 추가
			{ dataIndex: 'CUSTOM_COMPL'			, width: 110},
			//20191017 고객불만유형에 따른 고객불만그룹 추가
			{ dataIndex: 'CUSTOM_COMPL_GROUP'	, width: 110},
			{ dataIndex: 'ACCOUNT_YNC'			, width: 90		, align: 'center'},
			{ dataIndex: 'INSPEC_NUM'			, width: 110},
			{ dataIndex: 'WH_CODE'				, width: 110	, hidden: true},
			{ dataIndex: 'LOCATION'				, width: 100	, hidden: true	, align: 'center'},
			{ dataIndex: 'REMARK'				, width: 200},
			{ dataIndex: 'CONFIRM_YN'			, width: 80		, align: 'center'	, xtype : 'checkcolumn',
				listeners: {
					beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ) {
					},
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ) {
					}
				}
			},
			{ dataIndex: 'PROC_METHOD'			, width: 80}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL', 'REMARK', 'PROC_METHOD'])) {
					return true;
				} else {
					//20191011 CUSTOM_COMPL 추가
					if(UniUtils.indexOf(e.field, ['CUSTOM_COMPL'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			selectionchange:function( grid, selection, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_str330ukrv_mitGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'center',
		//20200204 추가
		uniOpt	: {
			useMultipleSorting	: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup 	: false,	//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: false
			}
		},
		//20200204 수정: 체크박스 모텔 추가
//		selModel: 'rowmodel',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					if (this.selected.getCount() > 0) {
						confirmTabForm.down('#OUT').enable();
						confirmTabForm.down('#RE_IN').enable();
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						confirmTabForm.down('#OUT').disable();
						confirmTabForm.down('#RE_IN').disable();
					}
				}
			}
		}),
		features: [ {id: 'masterGrid1SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGrid1Total'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_NUM'			, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_SEQ'			, width: 100	, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 220},
			{ dataIndex: 'SPEC'					, width: 160},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100},
			{ dataIndex: 'INOUT_Q'				, width: 100	, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 130},
			//20191011 CUSTOM_COMPL 추가
			{ dataIndex: 'CUSTOM_COMPL'			, width: 110},
			//20191017 고객불만유형에 따른 고객불만그룹 추가
			{ dataIndex: 'CUSTOM_COMPL_GROUP'	, width: 110},
			{ dataIndex: 'ACCOUNT_YNC'			, width: 90		, align: 'center'},
			{ dataIndex: 'INSPEC_NUM'			, width: 110},
			{ dataIndex: 'WH_CODE'				, width: 110	, hidden: true},
			{ dataIndex: 'LOCATION'				, width: 100	, hidden: true	, align: 'center'},
			{ dataIndex: 'REMARK'				, width: 200},
			{ dataIndex: 'CONFIRM_YN2'			, width: 80		, align: 'center'},
			{ dataIndex: 'PROC_METHOD'			, width: 80},
			//20200204 추가: 폐기일자, 재입고일자,
			{ dataIndex: 'OUT_DATE'				, width: 80},
			{ dataIndex: 'RE_IN_DATE'			, width: 80}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['REMARK', 'PROC_METHOD'])) {
					return true;
				} else {
					//20191011 CUSTOM_COMPL 추가
					if(UniUtils.indexOf(e.field, ['CUSTOM_COMPL'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			selectionchange:function( grid, selection, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			}
		}
	});

	var confirmTabForm = Unilite.createSearchForm('confirmTab_condition',{
		layout	: {type:'uniTable', columns: '4', tableAttrs: {width: '100%'}},
		border	: false,
		items	: [{
			fieldLabel		: '반품확인일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			//20200204 추가: 버튼 추가로 form 디자인 조정용
			tdAttrs			: {width: 380},
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.lotno" default="LOT번호"/>',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			//20200204 추가: 버튼 추가로 form 디자인 조정용
			tdAttrs		: {width: 350},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			//20191017 추가: 품목분류, 품목, 규격
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 2 0',
			//20200204 추가: 버튼 추가로 form 디자인 조정용
			tdAttrs	: {width: 380},
			items	: [{
				fieldLabel	: '품목분류',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 210,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parents		: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM',
				width		: 110,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank	: false,
			//20200204 추가: 버튼 추가로 form 디자인 조정용
			tdAttrs			: {width: 350},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.spec" default="규격"/>',
			name		: 'SPEC',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			//20200204 추가: 폐기, 재입고 버튼
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			tdAttrs	: {align: 'right'},
			padding	: '0 0 2 0',
			items	: [{
				xtype	: 'button',
				text	: '폐기',
				itemId	: 'OUT',
				width	: 100,
				handler	: function() {
					openOutWindow();		//20200204 추가: 폐기팝업
				}
			},{
				xtype	: 'button',
				text	: '재입고',
				itemId	: 'RE_IN',
				width	: 100,
				handler	: function() {
					openReInWindow();		//20200204 추가: 재입고팝업
				}
			}]
		}]
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		region		: 'center',
		activeTab	: 0,
		items		: [{
			title	: '미확인',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid1],
			id		: 'nonConfirmTab'
		},{
			title	: '확인',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [confirmTabForm, masterGrid2],
			id		: 'confirmTab'
		}],
		listeners	: {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
				if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					} else {
						return false;
					}
				}
			},
			tabChange: function ( tabPanel, newCard, oldCard, eOpts ) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'nonConfirmTab') {
					UniAppManager.setToolbarButtons(['delete'], false);
				} else {
//					UniAppManager.setToolbarButtons(['delete'], true);
				}
			}
		}
	});



	/** 폐기팝업 관련로직
	 * 
	 */
	var outPanel = Unilite.createSearchForm('outPanel', {	//20200204 추가: 폐기팝업
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '폐기일',
			name		: 'OUT_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			allowBlank	: false,
			tdAttrs		: {width: 350},
			listeners	: {
				//20200210 추가: PANEL의 사업장에 해당하는 창고만 콤보로 설정
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == panelResult.getValue('DIV_CODE');
					})
				},
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == outPanel.getValue('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&& item.get('refCode10') == '*'
					})
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '<t:message code="system.label.sales.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			allowBlank		: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
			name		: 'INOUT_PRSN',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B024',
			allowBlank	: false,
			//20200220 추가
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			xtype	: 'component',
			height	: 25,
			colspan	: 2
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			tdAttrs	: {align: 'center'},
			padding	: '0 0 2 0',
			colspan	: 2,
			items	: [{
				xtype	: 'button',
				text	: '폐기',
				itemId	: 'OUT',
				width	: 100,
				handler	: function() {
					if(!outPanel.getInvalidMessage()) {
						return false;
					}
					//20200219 추가: 확인로직
					if(confirm('폐기 하시겠습니까?')) {
						buttonStore.saveStore('OUT');
					}
				}
			}]
		}]
	})

	function openOutWindow() {		//20200204 추가: 폐기팝업
		if(!outWindow) {
			outWindow = Ext.create('widget.uniDetailWindow', {
				title	: '폐기',
				width	: 650,
				height	: 210,
				layout	: {type:'vbox', align:'stretch'},
				items	: [outPanel],
				tbar	:  ['->', {
					itemId	: 'CloseBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						outWindow.hide();
					}
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						outPanel.clearForm();
					},
					beforeshow: function(panel, eOpts) {
						outPanel.setValue('OUT_DATE'	, UniDate.get('today'));
						outPanel.setValue('WH_CODE'		, '1700');
						outPanel.setValue('WH_CELL_CODE', '10');
						outPanel.setValue('DEPT_CODE'	, UserInfo.deptCode);
						outPanel.setValue('DEPT_NAME'	, UserInfo.deptName);
						outPanel.setValue('INOUT_PRSN'	, BsaCodeInfo.gsInoutPrsn);
						//20200220 추가
						var field = outPanel.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
					}
				}
			})
		}
		outWindow.center();
		outWindow.show();
	}


	/** 재입고팝업 관련로직
	 * 
	 */
	var reInPanel = Unilite.createSearchForm('reInPanel', {	//20200204 추가: 재입고팝업
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '이동일',
			name		: 'RE_IN_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			allowBlank	: false,
			tdAttrs		: {width: 350},
			listeners	: {
				//20200210 추가: PANEL의 사업장에 해당하는 창고만 콤보로 설정
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == panelResult.getValue('DIV_CODE');
					})
				},
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == reInPanel.getValue('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&& item.get('refCode10') == '*';
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name		: 'IN_WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'IN_WH_CELL_CODE',
			allowBlank	: false,
			listeners	: {
				//20200210 추가: PANEL의 사업장에 해당하는 창고만 콤보로 설정
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == panelResult.getValue('DIV_CODE');
					})
				},
				change: function(combo, newValue, oldValue, eOpts) {
				},
				select: function(combo, record, eOpts) {
				},
				specialkey: function(field, event) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>',
			name		: 'IN_WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == reInPanel.getValue('IN_WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&& item.get('refCode10') == '*';
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
			name		: 'INOUT_PRSN',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B024',
			allowBlank	: false,
			colspan		: 2,
			//20200220 추가
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			tdAttrs	: {align: 'center'},
			padding	: '0 0 2 0',
			colspan	: 2,
			items	: [{
				xtype	: 'button',
				text	: '재입고',
				itemId	: 'RE_IN',
				width	: 100,
				handler	: function() {
					if(!reInPanel.getInvalidMessage()) {
						return false;
					}
					//20200219 추가: 확인로직
					if(confirm('재입고 하시겠습니까?')) {
						buttonStore.saveStore('RE_IN');
					}
				}
			}]
		}]
	})

	function openReInWindow() {		//20200204 추가: 재입고팝업
		if(!reInWindow) {
			reInWindow = Ext.create('widget.uniDetailWindow', {
				title	: '재입고',
				width	: 650,
				height	: 210,
				layout	: {type:'vbox', align:'stretch'},
				items	: [reInPanel],
				tbar	:  ['->', {
					itemId	: 'CloseBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						reInWindow.hide();
					}
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						reInPanel.clearForm();
					},
					beforeshow: function(panel, eOpts) {
						reInPanel.setValue('RE_IN_DATE'		, UniDate.get('today'));
						reInPanel.setValue('WH_CODE'		, '1700');
						reInPanel.setValue('WH_CELL_CODE'	, '10');
						reInPanel.setValue('INOUT_PRSN'		, BsaCodeInfo.gsInoutPrsn);
						//20200220 추가
						var field = reInPanel.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
					}
				}
			})
		}
		reInWindow.center();
		reInWindow.show();
	}


	/** 폐기 / 재입고 관련 저장 로직
	 * 
	 */
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_str330ukrv_mitService.outRein',
			syncAll	: 's_str330ukrv_mitService.setBtr100t'
		}
	});

	var buttonStore = Unilite.createStore('buttonStore',{
		proxy		: directButtonProxy,
		uniOpt		: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		saveStore	: function(saveFlag) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			if(saveFlag == 'OUT') {
				var paramMaster = outPanel.getValues();
			} else {
				var paramMaster = reInPanel.getValues();
			}
			paramMaster.SAVE_FLAG = saveFlag;

			var selRecords = masterGrid2.getSelectionModel().getSelection();
			Ext.each(selRecords, function(selRecord, index) {
				//20200219 수정 - 신규 SEQ 채번 로직 수정
				selRecord.set('NEW_INOUT_SEQ', index + 1);
				selRecord.phantom = true;
				buttonStore.insert(index, selRecord);
			})

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	Unilite.Main({
		id			: 's_str330ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		}],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE'			, UniDate.get('today'));
			confirmTabForm.setValue('INSPEC_DATE_FR'	, UniDate.get('startOfMonth'));
			confirmTabForm.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));
			confirmTabForm.down('#OUT').disable();
			confirmTabForm.down('#RE_IN').disable();

			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				Unilite.messageBox('사업장'+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'nonConfirmTab') {
				directMasterStore1.loadStoreRecords();
			} else {
				directMasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid1.getStore().loadData({})
			confirmTabForm.clearForm();
			masterGrid2.getStore().loadData({})
			UniAppManager.setToolbarButtons('print', false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'nonConfirmTab') {
				if(!panelResult.getInvalidMessage()) {
					return false;
				}
				directMasterStore1.saveStore();
			} else {
				directMasterStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId != 'nonConfirmTab') {
				var selRow = masterGrid2.getSelectedRecord();
				if(selRow.phantom === true) {
					masterGrid2.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid2.deleteSelectedRow();
				}
			}
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
			if(newValue == oldValue) {
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "INOUT_TYPE_DETAIL" :
				case "REMARK" :
				case "PROC_METHOD" :
					record.set('CONFIRM_YN', true);
					break;
				case "CUSTOM_COMPL" :
					record.set('CONFIRM_YN', true);
					var items = Ext.data.StoreManager.lookup('CBS_AU_Z024').data.items;
					var groupValue;
					Ext.each(items, function(item,i) {
						if(item.get('value') == newValue) {
							groupValue = item.get('refCode2');
						}
					});
					record.set('CUSTOM_COMPL_GROUP', groupValue);
					break;
			}
			return rv;
		}
	});
	Unilite.createValidator('validator02', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
			if(newValue == oldValue) {
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "CUSTOM_COMPL" :
					var items = Ext.data.StoreManager.lookup('CBS_AU_Z024').data.items;
					var groupValue;
					Ext.each(items, function(item,i) {
						if(item.get('value') == newValue) {
							groupValue = item.get('refCode2');
						}
					});
					record.set('CUSTOM_COMPL_GROUP', groupValue);
					break;
			}
			return rv;
		}
	});
};
</script>